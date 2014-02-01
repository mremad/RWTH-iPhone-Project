//
//  BaseViewController.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        // Put in code here to handle shake
        CLLocation *location = [self getLocation];
        if (location != nil) {
            [[ServerConnection sharedServerConnection] SendToServerShakeLocation:currentLocation];
        }
        
        //Testing Location
        NSLog(@"didUpdateToLocation: %@", [self getLocation]); // TODO: This call should be changed to send to the server        
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

-(void)notifitcationRecieved
{
    [self addLocalNotification];
}

-(void)shakeRecieved{
    
}


@end
