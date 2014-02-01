//
//  LoginViewController.m
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "LoginViewController.h"
#import "L2PHandler.h"


@interface LoginViewController () <L2PHandlerDelegate>

@property(retain) L2PHandler *handler;

@end

@implementation LoginViewController

- (IBAction)ValueChangedInUserNameTextField:(id)sender
{
    
}
- (IBAction)EditingChanedInUserNameTextField:(id)sender
{
 /*   if([_textFieldUserName text].length>=2)
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
    }*/
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFieldUserName resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    _textFieldUserName.delegate=self;
    _textFieldPassword.delegate=self;
  
	// Do any additional setup after loading the view.
    [self loadCredentials];
    
    // Instantiate L2PHandler and set the delegate to receive calls from the handler instance.
    _handler = [[L2PHandler alloc] initWithViewController:self];
    _handler.delegate = self;
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

- (IBAction)loginButtonPressed:(UIButton*)sender
{
    [self saveCredentials:[_textFieldUserName text] withPass:[_textFieldPassword text]];
    [_handler obtainUserCode];
//     [self userDataWasFetched]; // TODO: remove in RELEASE
}

#pragma mark - APIDelegate methods

- (void) userDataWasFetched
{
    // Trigger the login segue after the handler notifies that all user data has been fetched.
    [self performSegueWithIdentifier:@"Login" sender:self.ButtonLogin];
}

/**
 saves username and password to userdefaults
 */
- (void) saveCredentials: (NSString *) username withPass: (NSString *) password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"user"];
    [defaults setObject:password forKey:@"pass"];
    [defaults synchronize];
}

/**
 loads username and password from userdefaults and sets textviews
 */
- (void) loadCredentials
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey: @"user"];
    NSString *pass = [defaults objectForKey: @"pass"];
    if (user != nil) {
        [_textFieldUserName setText:user];
        NSLog(@"user: %@", user);
        [_textFieldPassword setText:pass];
    } else {
        NSLog(@"no user information cached");
    }
}


@end
