//
//  GroupViewController.m
//  Skedify
//
//  Created by M on 1/31/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "GroupViewController.h"

@implementation GroupViewController

- (IBAction)buttonDonePressed:(id)sender
{
    [[ServerConnection sharedServerConnection] GetGroup:_groupIndex].name=[_textFieldGroupName text];
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFieldGroupName resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textFieldGroupName.delegate=self;
    _textFieldGroupName.text=[[ServerConnection sharedServerConnection] GetGroup:_groupIndex].name;
    
    //  _textFieldNickName.delegate=self;
	// Do any additional setup after loading the view.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
