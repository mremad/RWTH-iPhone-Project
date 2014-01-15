//
//  ServerConnection.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ServerConnection.h"
#import "Group.h"

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

-(void)fetchNeededInformation
{
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

- (NSArray *) GetGroupList
{
    return _groupsList; //we do not have an instance of this class thats why we retrive properties this way
}

-(void) addGroup:(Group *)theGroup
{
     [_groupsList insertObject:theGroup atIndex:[_groupsList count]];
}


- (NSArray *) GetGroupContacts: (int) groupIdentifier
{
    Group *theIdentifierGroup = (Group *)[_groupsList objectAtIndex:groupIdentifier];
    return [theIdentifierGroup members];
}

#pragma mark -
#pragma mark ServerConnection methods

/*
 * handles all messages receiving from the server
 */
- (void)didReceiveDataFromServerMethod
{
    [_notificationsViewDelegate notifitcationRecieved];
}

@end
