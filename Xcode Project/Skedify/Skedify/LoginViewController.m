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
{
    BOOL removeButtonPressedInEmailTextField;
}
@property(retain) L2PHandler *handler;

@end

@implementation LoginViewController


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
  
	// Do any additional setup after loading the view.
    //[self loadCredentials];
    
    // Instantiate L2PHandler and set the delegate to receive calls from the handler instance.
    _handler = [[L2PHandler alloc] initWithViewController:self];
    _handler.delegate = self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(UIButton*)sender
{
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //  NSString *accountEmail = [defaults objectForKey: @"accountEmailAddress"];
    NSString *accountEmail = [ServerConnection sharedServerConnection].accountEmailAddress;
    
    
    
    if(accountEmail==nil)
    {
        [_handler obtainUserCode];
    }
    else
    {
        [self performSegueWithIdentifier:@"toGroupsDirectly" sender:sender];
        [[ServerConnection sharedServerConnection] fetchGroups];
    }
    //[self saveCredentials:[_textFieldUserName text] withPass:[_textFieldPassword text]];
    
    
// [self userDataWasFetched]; // TODO: remove in RELEASE
}

#pragma mark - APIDelegate methods

- (void) userDataWasFetched
{
    // Trigger the login segue after the handler notifies that all user data has been fetched.
    [self performSegueWithIdentifier:@"Login" sender:self.ButtonLogin];
}


@end
