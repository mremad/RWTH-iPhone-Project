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
    
    int testingNotificationCounter;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if([[ServerConnection sharedServerConnection] notificationsNotReadCounter] != 0){
    [self addNotificationBadgeWithNumber:[[ServerConnection sharedServerConnection] notificationsNotReadCounter]];
    }
//    For testing Purpose
//        [self addNotificationBadgeWithNumber:testingNotificationCounter];

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
        
         UIBarButtonItem *myBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(buttonAddAction:)];
        if([self.title isEqual:@"GroupMenu"])
        {
            UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc]
                                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                       target:nil
                                                       action:nil];
            flexibleSpaceBarButton.width=12;
              UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(buttonEditAction:)];
            self.navigationItem.rightBarButtonItems = @[editButton,flexibleSpaceBarButton, notificationItem];
        }
        else if (![self.title isEqual:@"notifications"])
        {
            
            self.navigationItem.rightBarButtonItems = @[myBarButton, notificationItem];
        }
    }
}

-(void)buttonAddAction:(id)sender
{
    //to be overwritten from sub classes who that want to use the add button
}

-(void)buttonEditAction:(id)sender
{
    //to be overwritten from sub classes who that want to use the edit button
}

-(void)buttonNotifications:(id)sender{
    
    //Remove badge
    [self removeNotificationBadge];
    //Reset notifications not read counter
    [ServerConnection sharedServerConnection].notificationsNotReadCounter = 0;
    //Go to notifications view
    [self performSegueWithIdentifier:@"toNotifications" sender:sender];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *) suitableNameWithAddedDotsIfAboveAcceptableSize:(NSString *) name AndAcceptableSize:(NSInteger) acceptableSize
{
    int size=[name length];
    NSMutableString *result = [[NSMutableString alloc]init];
    if (size>acceptableSize)
    {
        int start = acceptableSize/2;
        for(int i = 0;i < start ;i++)
        {
            [result appendFormat:@"%c",[name characterAtIndex:i]];
        }
        
        [result appendFormat:@"..."];
        
        int end = acceptableSize/3;
        for(int i = size-end;i < size;i++)
        {
            [result appendFormat:@"%c",[name characterAtIndex:i]];
        }
        
        return result;
    }
    else
    {
        return name;
    }
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
        NSLog(@"didUpdateToLocation: %@", [self getLocation]); 
        
        //Testing Notification Badge
        testingNotificationCounter ++;
        [self addNotificationBadgeWithNumber:testingNotificationCounter];
        
        //Testing Local Notification
        [self addLocalNotification];
        
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
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
    if (newLocation == nil) {
        currentLocation = oldLocation;
    }
    else{
    currentLocation = newLocation;
    }
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
#pragma mark DrawingNotificationBadge methods

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
    
    if (self.notificationBadge != nil) {
    [self.notificationBadge removeFromSuperview];
    testingNotificationCounter = 0;
    }
}

-(void)initNotificationItem{
    
    self.badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.badgeButton.frame = CGRectMake(0, 0, 30, 30);
    [self.badgeButton addTarget:self action:@selector(buttonNotifications:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.badgeButton setImage:[UIImage imageNamed:@"notificationIcon.png"] forState:UIControlStateNormal];
    
    testingNotificationCounter = 0;
    
}

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
    [self addNotificationBadgeWithNumber:[[ServerConnection sharedServerConnection] notificationsNotReadCounter]];
    [self addLocalNotification];
}

-(void)shakeRecieved:(BOOL)firstShaker{
    
}

@end
