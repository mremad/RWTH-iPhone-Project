//
//  CreateGroupViewController.h
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
#import "BaseViewController.h"

@interface CreateGroupViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ButtonCancel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGroupName;

@end
