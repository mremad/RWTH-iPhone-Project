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
    
    int notificationCounter;
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
        [self initNotificationItem];
        UIBarButtonItem *notificationItem = [[UIBarButtonItem alloc] initWithCustomView:self.badgeButton];
        
        if(self.navigationItem.rightBarButtonItem==nil)
        {
            
            UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                       target:nil
                                                       action:nil];
            flexibleSpaceBarButton.width=42;
            self.navigationItem.rightBarButtonItems = @[flexibleSpaceBarButton, notificationItem];
        }
        else
        {
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
        
        [self addNotificationBadgeWithNumber:notificationCounter]; // Should be added by a call from the server **Testing Purpose**
        notificationCounter ++;
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

-(void)addNotificationBadgeWithNumber:(int)number{
    
    NSString* string = [NSString stringWithFormat:@"%i", number];
    
    if (self.notificationBadge != nil) {
        [self.notificationBadge removeFromSuperview];
    }
    
    self.notificationBadge = [CustomBadge customBadgeWithString:string withStringColor:[UIColor whiteColor] withInsetColor:[UIColor redColor] withBadgeFrame:NO withBadgeFrameColor:[UIColor whiteColor]];
    CGRect badgeFrame = CGRectMake((-self.notificationBadge.frame.size.width) + 11, -1.0f, self.notificationBadge.frame.size.width, self.notificationBadge.frame.size.height);
    [self.notificationBadge setFrame:badgeFrame];
    
    [self.badgeButton addSubview:self.notificationBadge];
}

-(void)removeNotificationBadge{
    
    [self.notificationBadge removeFromSuperview];
    notificationCounter = 1;
}

-(void)initNotificationItem{
    
    self.badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.badgeButton.frame = CGRectMake(0, 0, 30, 30);
    [self.badgeButton addTarget:self action:@selector(removeNotificationBadge) forControlEvents:UIControlEventTouchUpInside];
    
    [self.badgeButton setImage:[UIImage imageNamed:@"notificationIcon.png"] forState:UIControlStateNormal];
    
    notificationCounter = 1;
    
}

@end
