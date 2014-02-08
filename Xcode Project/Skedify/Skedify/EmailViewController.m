//
//  EmailViewController.m
//  Skedify
//
//  Created by M on 1/31/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "EmailViewController.h"

@implementation EmailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    _textFieldEmail.delegate=self;
  //  _textFieldNickName.delegate=self;
	// Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)isAllowedToLeaveView
{
    if(![Member NSStringIsValidRWTHAachenEmail:[_textFieldEmail text]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a valid RWTH Aachen Email Address!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ServerConnection sharedServerConnection].accountEmailAddress = [[_textFieldEmail text] lowercaseString];
    [[ServerConnection sharedServerConnection] storeAccountInfoInUserDefaultsAndOnServer];
}



@end
