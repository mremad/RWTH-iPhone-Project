//
//  AddGroupViewController.m
//  Skedify
//
//  Created by M on 1/13/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "AddGroupViewController.h"

@interface AddGroupViewController ()

@end

@implementation AddGroupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _textFieldGroupName.delegate=self;
    _textFiledEmail.delegate=self;
    _tableViewMembers =[[UITableView alloc]initWithFrame:CGRectMake(10, 250, 250, 250)];
    [self.view addSubview:_tableViewMembers];
    [_tableViewMembers reloadData];
    _tableViewMembers.delegate=self;
    _tableViewMembers.dataSource=self;
    _membersToInvite=[[NSMutableArray alloc]init];
	// Do any additional setup after loading the view.
}

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
   // [[ServerConnection sharedServerConnection] addGroup:toBeAddedGroup];
    //[[ServerConnection sharedServerConnection] SendToServerAddGroup:toBeAddedGroup WithMembers:_membersToInvite];
    [[ServerConnection sharedServerConnection]addGroup:toBeAddedGroup WithMembersEmails:_membersToInvite];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ButtonCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)buttonEditAction:(id)sender
{
    
}

- (IBAction)ButtonAddClicked:(id)sender
{
    [_textFiledEmail resignFirstResponder];
    
    if(![Member NSStringIsValidRWTHAachenEmail:[_textFiledEmail text]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter a valid RWTH Aachen Email Address!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if([_membersToInvite containsObject:_textFiledEmail.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This member is already invited!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [_membersToInvite addObject:_textFiledEmail.text];
    _textFiledEmail.text=@"";
    [_tableViewMembers reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textFieldGroupName resignFirstResponder];
    [_textFiledEmail resignFirstResponder];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TableView Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Number of rows is the number of time zones in th
    return [_membersToInvite count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // The header for the section is the region name -- get this from the region at the section index.
    
    return @"Members To Invite";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"MyReuseIdentifier"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [_membersToInvite objectAtIndex:indexPath.row];
    return cell;
}


@end
