//
//  LoginViewController.m
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)ValueChangedInUserNameTextField:(id)sender
{
    
}
- (IBAction)EditingChanedInUserNameTextField:(id)sender
{
    if([_textFieldUserName text].length>=2)
    {
        _textFieldUserName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_textFieldUserName resignFirstResponder];
        [_textFieldUserName becomeFirstResponder];
    }
    else
    {
        _textFieldUserName.keyboardType = UIKeyboardTypeDefault;
        [_textFieldUserName resignFirstResponder];
        [_textFieldUserName becomeFirstResponder];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    _textFieldUserName.delegate=self;
    _textFieldPassword.delegate=self;
  
	// Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
