//
//  EmailViewController.h
//  Skedify
//
//  Created by M on 1/31/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Member.h"
@interface EmailViewController : BaseViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;


-(BOOL)isAllowedToLeaveView;
@end
