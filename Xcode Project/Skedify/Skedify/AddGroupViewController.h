//
//  AddGroupViewController.h
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "BaseViewController.h"

@interface AddGroupViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonCancel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGroupName;
@property (strong, nonatomic) IBOutlet UITableView *tableViewMembers;
@property (strong, nonatomic) NSMutableArray *membersToInvite;
@property (weak, nonatomic) IBOutlet UITextField *textFiledEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@end
