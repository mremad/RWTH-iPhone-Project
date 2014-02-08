//
//  BaseViewController.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "BaseViewController.h"

#import "GroupsTableViewController.h"
#import "ScheduleViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ServerConnection sharedServerConnection].delegatenotificationsView = self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ServerConnection sharedServerConnection].delegatenotificationsView = nil;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //   [self shakeGroupCreationActionRecieved:1];
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        CLLocation *location = [self getLocation];
        if (location != nil) {
            
            NSDate *lastShakeDatePlusSomeSeconds =[[[ServerConnection sharedServerConnection] dateOfLastShakeGesture] dateByAddingTimeInterval:15];
            if ([lastShakeDatePlusSomeSeconds compare: [NSDate date]] == NSOrderedDescending)
            {
                return;
            }
            else
            {
                [ServerConnection sharedServerConnection].dateOfLastShakeGesture=[NSDate date];
            }
            
            // Put in code here to handle shake
            location = [self getLocation];
            if (location != nil) {
                [[ServerConnection sharedServerConnection] setShakelocation:location];
            }
            
            //Testing Location
            NSLog(@"didUpdateToLocation: %@", location);
            
            //        //Testing Notification Badge
            //        testingNotificationCounter ++;
            //        [self addNotificationBadgeWithNumber:testingNotificationCounter];
            //
            //        //Testing Local Notification
            //        [self addLocalNotification];
            
        }
    }
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark LocationManager methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //For testing
    NSLog(@"didFailWithError: %@", error);
    
    /*
     UIAlertView *errorAlert = [[UIAlertView alloc]
     initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [errorAlert show];*/

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
}

- (CLLocation*)getLocation{
    // Create the location manager if this object does not already have one.
    if (nil == locationManager){
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = (id)self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    return currentLocation;
}



#pragma mark -
#pragma mark Local Notification methods

-(void)addLocalNotification{
    
    //Add Local Notification scheduled to fire after 5 seconds
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = @"You have an invitation from Skedify";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

#pragma mark -
#pragma mark NotificationsReceivedFromServer methods

-(void)notificationRecieved
{
    if([ServerConnection sharedServerConnection].notificationsReadCounter > 0){
        [ServerConnection sharedServerConnection].notificationsReadCounter --;
        return;
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self addLocalNotification];            
        });
}
}

-(void)shakeGroupCreationActionRecieved:(NSInteger ) groupID
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UINavigationController *baseNC =(UINavigationController *)[self presentingViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSArray *allVC= [baseNC viewControllers];
    GroupsTableViewController  *groupMenu;
    for(int i=0;i<[allVC count];i++)
    {
        UIViewController *vc=[allVC objectAtIndex:i];
        if([vc.title isEqual:@"GroupsList"])
        {
            groupMenu= [allVC objectAtIndex:i];
            break;
        }
    }
    
    GroupMenuTableViewController *groupsMenu = (GroupMenuTableViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"GroupMenuIdentifier"];
    groupsMenu.groupId=groupID;
    ScheduleViewController *sced = (ScheduleViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ScheduleIdentifier"];
    
    sced.groupID=groupID;
    [baseNC popToViewController:groupMenu animated:NO];
    [baseNC pushViewController:groupsMenu animated:NO];
    [baseNC pushViewController:sced animated:YES];
}


@end
