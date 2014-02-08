//
//  AppDelegate.m
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "AppDelegate.h"
#import "ServerConnection.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    //Background Thread to check on the server
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
         [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] run];
        
    });
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [ServerConnection sharedServerConnection].notificationsReadCounter = [[ServerConnection sharedServerConnection].notificationsList count] - [ServerConnection sharedServerConnection].notificationsNotReadCounter;
    [[ServerConnection sharedServerConnection] storeAccountInfoInUserDefaultsAndOnServer];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [ServerConnection sharedServerConnection].notificationsReadCounter = [[ServerConnection sharedServerConnection].notificationsList count] - [ServerConnection sharedServerConnection].notificationsNotReadCounter;
    [[ServerConnection sharedServerConnection] storeAccountInfoInUserDefaultsAndOnServer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Reset icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [ServerConnection sharedServerConnection].notificationsReadCounter = [[ServerConnection sharedServerConnection].notificationsList count] - [ServerConnection sharedServerConnection].notificationsNotReadCounter;
    [[ServerConnection sharedServerConnection] storeAccountInfoInUserDefaultsAndOnServer];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
 /*   UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Skedify Invitation"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }*/
    
    // Request to reload table view data
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

- (void)timerFireMethod:(NSTimer *)timer{
    
    //TODO: Call checking method
//    if (YES) { //if there is shaking motion
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //TODO: Call Shake received
//        });
//    }
    if (([[ServerConnection sharedServerConnection] alreadySignedIn]) || ([[NSUserDefaults standardUserDefaults] objectForKey: @"accountEmailAddress"] != nil)) {
 
    [[ServerConnection sharedServerConnection] getFromServerPullData];
    }
}

@end
