//
//  EmailViewController.m
//  Skedify
//
//  Created by M on 1/31/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "EmailViewController.h"

@implementation EmailViewController
{
    BOOL removeButtonPressedInEmailTextField;
}

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

- (IBAction)EditingChangedInUserNameTextField:(id)sender
{
    NSString *textFieldText=[_textFieldEmail text];
    if([textFieldText length]>1 && [[textFieldText substringFromIndex:[textFieldText length]-1] isEqualToString:@"@"]&& !removeButtonPressedInEmailTextField)
    {
        NSString* autocmpletedString = [NSString stringWithFormat:@"%@%@", _textFieldEmail.text ,@"rwth-aachen.de"];
        _textFieldEmail.text = autocmpletedString;
    }
    else if(removeButtonPressedInEmailTextField && [textFieldText length]>=15 && [[textFieldText substringFromIndex:[textFieldText length]-14] isEqualToString:@"@rwth-aachen.d"])
    {
        NSString* stringWithAtRwthAachen = [textFieldText substringToIndex:[textFieldText length]-14];
        _textFieldEmail.text = stringWithAtRwthAachen;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""])
    {
        removeButtonPressedInEmailTextField=YES;
    }
    else
    {
        removeButtonPressedInEmailTextField=NO;
    }
    return YES;
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
