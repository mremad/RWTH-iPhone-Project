//
//  GroupsTableViewController.m
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "GroupsTableViewController.h"

@interface GroupsTableViewController ()

@end

@implementation GroupsTableViewController

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
    self.navigationItem.hidesBackButton = YES;
}

-(void)buttonAddAction:(id)sender
{
    [self performSegueWithIdentifier:@"toAddGroup" sender:sender];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].delegatenotificationsView = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].delegatenotificationsView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
     [self.tableView reloadData];
}


-(void)pushGroupMenuController
{
  
}


-(void)groupsRefreshed
{
     [self.tableView reloadData];
}

-(void)notificationRecieved
{
    [super notificationRecieved];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[ServerConnection sharedServerConnection].getGroupList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"GroupCell"; //also written in StoryBoard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Group *group =[[ServerConnection sharedServerConnection].getGroupList objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 350, 40)];
        nameLabel.text = group.name;
        nameLabel.highlightedTextColor = [UIColor whiteColor];
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
    }
    else
    {
        ((UILabel *)[cell.contentView.subviews objectAtIndex:0]).text = group.name;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"toGroupMenu"])
    {
        GroupMenuTableViewController *groupMenu=(GroupMenuTableViewController *)[segue destinationViewController];
        NSInteger row = ((NSIndexPath *)[self.tableView indexPathForSelectedRow]).row;
        Group *group =[[ServerConnection sharedServerConnection].getGroupList objectAtIndex:row];
        groupMenu.groupId=group.groupId;
    }
    if([[segue identifier] isEqual:@"toAddGroup"])
    {
       //set as delegate
    }
//    if([[segue identifier] isEqual:@"toNotifications"])
//    {
//     NotificationsTableViewController *notificationsVC=(NotificationsTableViewController *)[segue destinationViewController];
//    }
}



@end
