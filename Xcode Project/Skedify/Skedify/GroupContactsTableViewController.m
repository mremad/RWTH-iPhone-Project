//
//  GroupContactsTableViewController.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "GroupContactsTableViewController.h"
#import "Group.h"
#import "AddMemberViewController.h"

@interface GroupContactsTableViewController ()

@end

@implementation GroupContactsTableViewController

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
    Group *g=[[ServerConnection sharedServerConnection] getGroupGivenGroupId:_groupId];
    NSString *nameOfViewWithDots = [self suitableNameWithAddedDotsIfAboveAcceptableSize:g.name AndAcceptableSize:10];
    self.title= [nameOfViewWithDots stringByAppendingString:@" Members"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated
{
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
    return [[[ServerConnection sharedServerConnection] getGroupContacts:_groupId] count ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Member *theContact=[[[ServerConnection sharedServerConnection] getGroupContacts:_groupId]  objectAtIndex:indexPath.row];
    theContact.hasAcceptedGroupInvitation=YES;
    
  [_membersTableView reloadData]; //TODO remove the complete method ..leave it for now..
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"GroupContactsCell"; //also written in StoryBoard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Member *theContact=[[[ServerConnection sharedServerConnection] getGroupContacts:_groupId]  objectAtIndex:indexPath.row];
    NSString *contactName =[theContact getStrongestIdentifier];
   if (cell == nil||[cell.contentView.subviews count]==0) //[cell.contentView.subviews count]==0) solving weird bug where executution find a cell with this identifier which does not own a nameLabel
   {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 350, 40)];
        nameLabel.text = contactName;
        nameLabel.highlightedTextColor = [UIColor whiteColor];
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
          }
    else
    {
        ((UILabel *)[cell.contentView.subviews objectAtIndex:0]).text = contactName;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    
    if ([theContact hasAcceptedGroupInvitation])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"toAddMember"])
    {
        AddMemberViewController *groupContactsMenu=(AddMemberViewController *)[segue destinationViewController];
        groupContactsMenu.groupId=_groupId; //just delegating the value to the next controller
    }
//    if([[segue identifier] isEqual:@"toNotifications"])
//    {
//        NotificationsTableViewController *notificationsVC=(NotificationsTableViewController *)[segue destinationViewController];
//    }
    
}

-(void)buttonAddAction:(id)sender
{
    [self performSegueWithIdentifier:@"toAddMember" sender:sender];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].delegatenotificationsView = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].delegatenotificationsView = nil;
}

-(void)memberAcceptRejectinGroupNotification
{
    [_membersTableView reloadData];
}


@end
