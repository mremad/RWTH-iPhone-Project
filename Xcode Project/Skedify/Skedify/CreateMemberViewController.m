//
//  CreateMemberViewController.m
//  Skedify
//
//  Created by M on 1/15/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "CreateMemberViewController.h"
#import "GroupContactsTableViewController.h"
#import "Member.h"
@interface CreateMemberViewController ()

@end

@implementation CreateMemberViewController

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
    if(![self NSStringIsValidRWTHAachenEmail:[_textFieldEmail text]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a valid RWTH Aachen Email Address!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    Group *groupToHaveAnExtraMember = [[ServerConnection sharedServerConnection] GetGroup:_groupIndex];
    
    [groupToHaveAnExtraMember insertMember:[[Member alloc] initWithEmail:[_textFieldEmail text]]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFieldEmail resignFirstResponder];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) NSStringIsValidRWTHAachenEmail:(NSString *)checkString
{
    return [checkString hasSuffix:@"rwth-aachen.de"] && [self NSStringIsValidEmail:checkString];
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
