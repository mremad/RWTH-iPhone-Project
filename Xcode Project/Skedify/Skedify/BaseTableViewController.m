//
//  BaseTableViewController.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "BaseTableViewController.h"
@interface BaseTableViewController ()

@end

@implementation BaseTableViewController{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(YES)
    {
        if(self.navigationItem.rightBarButtonItem==nil)
        {
            UIBarButtonItem *notificationItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
            UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                       target:nil
                                                       action:nil];
            flexibleSpaceBarButton.width=42;
            self.navigationItem.rightBarButtonItems = @[flexibleSpaceBarButton, notificationItem];
        }
        else
        {
            UIBarButtonItem *notificationItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
            self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, notificationItem];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake)
    {
        // Put in code here to handle shake
         NSLog(@"didUpdateToLocation: %@", [self getLocation]); // This call should be changed to send to the server 
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
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

@end
