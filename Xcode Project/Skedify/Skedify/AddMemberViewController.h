//
//  AddMemberViewController.h
//  Skedify
//
//  Created by M on 1/15/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "BaseViewController.h"

@interface AddMemberViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonCancel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (nonatomic) NSInteger groupId;
@end
