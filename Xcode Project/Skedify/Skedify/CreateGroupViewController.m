//
//  CreateGroupViewController.m
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController
- (IBAction)ButtonDoneClicked:(id)sender
{
    NSString *groupName = [_textFieldGroupName text];
    NSString *trimmedGroupName = [groupName stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    if([trimmedGroupName isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter the Group's name!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    Group* toBeAddedGroup=[[Group alloc]initWithName:trimmedGroupName];
    //handle Members
    [[ServerConnection sharedServerConnection] addGroup:toBeAddedGroup];
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)ButtonCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textFieldGroupName.delegate=self;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
