//
//  GroupsTableViewController.h
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "GroupMenuTableViewController.h"
#import "GroupMembersTableViewController.h"
#import "Group.h"
#import "BaseTableViewController.h"
@interface GroupsTableViewController : BaseTableViewController<UITextFieldDelegate>
-(void)pushGroupMenuController;

-(void)groupsRefreshed;
@end
