//
//  NickNameViewController.h
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NickNameViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldNickName;

@end
