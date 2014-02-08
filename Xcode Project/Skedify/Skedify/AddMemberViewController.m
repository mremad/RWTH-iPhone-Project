//
//  AddMemberViewController.m
//  Skedify
//
//  Created by M on 1/15/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "AddMemberViewController.h"
#import "GroupMembersTableViewController.h"
#import "Member.h"
@interface AddMemberViewController ()

@end

@implementation AddMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)ButtonCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ButtoneDoneClicked:(id)sender
{
    if(![Member NSStringIsValidRWTHAachenEmail:[_textFieldEmail text]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a valid RWTH Aachen Email Address!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[ServerConnection sharedServerConnection] addMemberWithEmail:[_textFieldEmail text] inGroup:_groupId];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFieldEmail resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textFieldEmail.delegate=self;
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
