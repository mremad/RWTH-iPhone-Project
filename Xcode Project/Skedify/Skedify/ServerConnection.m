//
//  ServerConnection.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection


#pragma mark -
#pragma mark Singleton stuff

static ServerConnection *sharedServerConnection = nil;
static NSString *serverAdress = @"localhost:3000";
/*
 * returns the singleton instance of ServerConnection.
 */
+ (ServerConnection *)sharedServerConnection
{
    if (nil != sharedServerConnection) {
        return sharedServerConnection;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedServerConnection = [[ServerConnection alloc] init];
    });
    
    return sharedServerConnection;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self fetchNeededInformation];
    }
    
    return self;
}

- (void) fetchNeededInformation
{
    //ServerCode Get Created Groups(If any ) From Server
    //for ex User added that was not there in the system or User just opened the app and
    // recieves his info
    
    //GetGroupsFromPreviouStorage
    
    _groupsList = [[NSMutableArray alloc]init];
    Group* g1 = [[Group alloc]initWithName:@"DIS"];
    Member *a = [[Member alloc]initWithName:@"Dil"];
    Member *b = [[Member alloc]initWithName:@"Daimon"];
    [g1 insertMember:a];
    [g1 insertMember:b];
    [_groupsList insertObject:g1 atIndex:0];
    
    
    Group* g2 = [[Group alloc]initWithName:@"Artificial Intellegience" ];
    Member *c = [[Member alloc]initWithName:@"Alex"];
    Member *d = [[Member alloc]initWithName:@"Andrea"];
    [g2 insertMember:c];
    [g2 insertMember:d];
    [_groupsList insertObject:g2 atIndex:1];
}
#pragma mark -
#pragma mark Group Handling methods
- (NSArray *) GetGroupList
{
    return _groupsList; //we do not have an instance of this class thats why we retrive properties this way
}

- (Group *) GetGroup:(NSInteger) index
{
    return (Group *)[_groupsList objectAtIndex:index];
}

-(void) addGroup:(Group *) theGroup
{
     [_groupsList insertObject:theGroup atIndex:[_groupsList count]];
    //ServerCode Send Created Group To Server
}


- (NSArray *) GetGroupContacts: (NSInteger) groupIdentifier
{
    Group *theIdentifierGroup = (Group *)[_groupsList objectAtIndex:groupIdentifier];
    return [theIdentifierGroup members];
}

#pragma mark -
#pragma mark ServerConnection methods

/*
 * handles all notfication messages recieved from the server
 */
- (void)didReceiveNotificationFromServer
{
    if ([_notificationsViewDelegate respondsToSelector:@selector(notifitcationRecieved)])
    {
        [_notificationsViewDelegate notifitcationRecieved];
    }
    else
    {
        //for now we do nothing.. maybe we can do quick vibration ??
        // This situation happends when we are in a view that does not have the notification icon
    }
}

-(void)didRecieveShakeMessageFromServer
{
    [_notificationsViewDelegate shakeRecieved:NO];
}


@end
