//
//  GroupMembersTableViewController.h
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "BaseTableViewController.h"

@interface GroupMembersTableViewController : BaseTableViewController
{
   // NSInteger groupIndex;
}
@property (strong, nonatomic) IBOutlet UITableView *membersTableView;
@property (nonatomic) NSInteger groupId;
@end
