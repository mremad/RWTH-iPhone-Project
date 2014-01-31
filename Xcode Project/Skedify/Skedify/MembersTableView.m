//
//  MembersTableView.m
//  Skedify
//
//  Created by M on 1/30/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "MembersTableView.h"

@implementation MembersTableView

#pragma mark - Table view data source




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ServerConnection sharedServerConnection] GetGroupContacts:_groupIndex] count ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Member *theContact=[[[ServerConnection sharedServerConnection] GetGroupContacts:_groupIndex]  objectAtIndex:indexPath.row];
    theContact.hasAcceptedGroupInvitation=YES;
    
    [self reloadData]; //TODO remove the complete method ..leave it for now..
    
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
@end
