//
//  SkedNavigationController.m
//  Skedify
//
//  Created by M on 2/1/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "SkedNavigationController.h"

@implementation SkedNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //int g=1;
    if([[self visibleViewController] isKindOfClass:[EmailViewController class]])
    {
        EmailViewController *emailViewController =(EmailViewController *) [self visibleViewController];
        if(![emailViewController isAllowedToLeaveView])
        {
            return;
        }
    }
    [super pushViewController:viewController animated:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ServerConnection sharedServerConnection] appStart];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *accountEmail = [defaults objectForKey: @"accountEmailAddress"];
   
    if(accountEmail!=nil)
    {
        NSString *accountNickName =[defaults objectForKey: @"accountNickName"];
        [ServerConnection sharedServerConnection].accountEmailAddress = accountEmail;
        [ServerConnection sharedServerConnection].accountNickName = accountNickName;
    }
    
    [ServerConnection sharedServerConnection].notificationsReadCounter= [defaults integerForKey: @"notificationsRead"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}






@end
