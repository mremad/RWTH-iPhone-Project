//
//  NotificationsTableViewController.m
//  Skedify
//
//  Created by Mariam Abouelfadl on 1/31/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "ServerConnection.h"
#import "Notification.h"

@interface NotificationsTableViewController ()

@end

@implementation NotificationsTableViewController{
    NSArray *NotificationsTableData;
    Notification *notificationChosen;
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
    
    NotificationsTableData = [[ServerConnection sharedServerConnection] notificationsList];
//    
//    //Testing Data
//    NSDate *now = [[NSDate alloc] init];
//    
//    Notification *notification1 = [[Notification alloc] init];
//    notification1.isGroupInvitationNotification = YES;
//    notification1.groupName = @"DIS";
//    notification1.senderName = @"Dil";
//
//    
//    Notification *notification2 = [[Notification alloc] init];
//    notification2.isGroupInvitationNotification = NO;
//    notification2.groupName = @"AI";
//    notification2.meetingBeginningTime = now;
//    notification2.meetingEndingTime = now;
//    
//    NotificationsTableData =  [NSArray arrayWithObjects:notification1, notification2, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NotificationsTableData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    notificationChosen = [NotificationsTableData  objectAtIndex:indexPath.row];
    UIAlertView *alert;
    NSString *alertMessage = @"You have received a ";
    
    if (notificationChosen.isGroupInvitationNotification) {
        alertMessage = [[[[[alertMessage stringByAppendingString:@"Group Invitation from "] stringByAppendingString:notificationChosen.senderName] stringByAppendingString:@", group name "] stringByAppendingString:notificationChosen.groupName] stringByAppendingString:@"."];
        
        alert = [[UIAlertView alloc] initWithTitle:@"Invitation" message:alertMessage delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Accept"];
        [alert addButtonWithTitle:@"Decline"];
    }
    else{
        
        NSString *date = [NSDateFormatter localizedStringFromDate:notificationChosen.meetingBeginningTime
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterNoStyle];
        NSString *beginTime = [NSDateFormatter localizedStringFromDate:notificationChosen.meetingBeginningTime
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        NSString *endTime = [NSDateFormatter localizedStringFromDate:notificationChosen.meetingEndingTime
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
        
        alertMessage = [[[[[[[[[alertMessage stringByAppendingString:@"Meeting Invitation from "] stringByAppendingString:notificationChosen.groupName] stringByAppendingString:@". On: "] stringByAppendingString:date] stringByAppendingString:@". Begins at: "] stringByAppendingString:beginTime] stringByAppendingString:@" and Ends at: "] stringByAppendingString:endTime] stringByAppendingString:@"."];
        alert = [[UIAlertView alloc] initWithTitle:@"Invitation" message:alertMessage delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Decline"];
    }
    

    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //NSLog(@"Cancel");
    }
    else if (buttonIndex == 1){
        //NSLog(@"Accept Group or reject meeting");

        if (notificationChosen.isGroupInvitationNotification) {
            
            [[ServerConnection sharedServerConnection] acceptGroupRequest:notificationChosen.groupId];
            Group *g =[[Group alloc] initWithName:notificationChosen.groupName andID:notificationChosen.groupId];
            [[ServerConnection sharedServerConnection].groupsList addObject:g];
        }
        else{ //This a meeting rejection
            
            [[ServerConnection sharedServerConnection] rejectMeeting:notificationChosen.groupId withGroupName:notificationChosen.groupName fromTimeSlot:notificationChosen.meetingBeginningTime toTimeSlot:notificationChosen.meetingEndingTime];
        }
        
        int indexOfNotificationToBeRemoved = [notificationChosen getIndexOfNotificationInArray:[ServerConnection sharedServerConnection].notificationsList];
        [[ServerConnection sharedServerConnection].notificationsList removeObjectAtIndex:indexOfNotificationToBeRemoved];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        
    }
    else{
         //NSLog(@"Decline Group");

        if (notificationChosen.isGroupInvitationNotification) {
            [[ServerConnection sharedServerConnection] rejectGroupRequest:notificationChosen.groupId withGroupName:notificationChosen.groupName];
            
            int indexOfNotificationToBeRemoved = [notificationChosen getIndexOfNotificationInArray:[ServerConnection sharedServerConnection].notificationsList];
            [[ServerConnection sharedServerConnection].notificationsList removeObjectAtIndex:indexOfNotificationToBeRemoved];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"notificationTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Notification *currentCellNotification = [NotificationsTableData objectAtIndex:indexPath.row];
    
    if (currentCellNotification.isGroupInvitationNotification) {
        cell.textLabel.text = [currentCellNotification.groupName stringByAppendingString:@" Group Invitation"];
    }
    else {
        cell.textLabel.text = [currentCellNotification.groupName stringByAppendingString:@" Meeting Invitation"];
    }
    return cell;
}
@end
