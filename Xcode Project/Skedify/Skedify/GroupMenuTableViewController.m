//
//  GroupMenuTableViewController.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "GroupMenuTableViewController.h"
#import "GroupContactsTableViewController.h"
#import "ServerConnection.h"
#import "Group.h"

@interface GroupMenuTableViewController ()

@end

@implementation GroupMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(void)viewDidAppear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].delegatenotificationsView = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [ServerConnection sharedServerConnection].delegatenotificationsView = nil;
}

-(void)notifitcationRecieved
{
    //do something about it
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Group *g=[[[ServerConnection sharedServerConnection] GetGroupList] objectAtIndex:_groupIndex];
    self.title = [self suitableNameWithAddedDotsIfAboveAcceptableSize:g.name AndAcceptableSize:18];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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
     if([[segue identifier] isEqual:@"toGroupContacts"])
     {
         GroupContactsTableViewController *groupContactsMenu=(GroupContactsTableViewController *)[segue destinationViewController];
         groupContactsMenu.groupIndex=_groupIndex; //just delegating the value to the next controller
     }
 }

@end
