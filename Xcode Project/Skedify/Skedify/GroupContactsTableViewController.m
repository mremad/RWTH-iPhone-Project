//
//  GroupContactsTableViewController.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "GroupContactsTableViewController.h"
#import "Group.h"
#import "CreateMemberViewController.h"

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
    UIBarButtonItem *notificationItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, notificationItem];
    Group *g=[[[ServerConnection sharedServerConnection] GetGroupList] objectAtIndex:_groupIndex];
    self.title= [g.name stringByAppendingString:@" Members"]; //TODO Spacing..
    
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
    return [[[ServerConnection sharedServerConnection] GetGroupContacts:_groupIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"GroupContactsCell"; //also written in StoryBoard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Member *theContact=[[[ServerConnection sharedServerConnection] GetGroupContacts:_groupIndex]  objectAtIndex:indexPath.row];
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
        CreateMemberViewController *groupContactsMenu=(CreateMemberViewController *)[segue destinationViewController];
        groupContactsMenu.groupIndex=_groupIndex; //just delegating the value to the next controller
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].notificationsViewDelegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].notificationsViewDelegate = nil;
}

-(void)notifitcationRecieved
{
    //do something about it
}


@end
