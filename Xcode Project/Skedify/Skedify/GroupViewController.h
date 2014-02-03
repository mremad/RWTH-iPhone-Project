//
//  GroupViewController.h
//  Skedify
//
//  Created by M on 1/31/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "GroupsTableViewController.h"
#import "BaseViewController.h"
@interface GroupViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldGroupName;
@property (nonatomic) NSInteger groupId;
@end
