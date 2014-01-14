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

- (NSArray *) GetGroupList
{
    return @[@"DIS", @"Artificial Intellegience"];
}
- (NSArray *) GetGroupContacts: (int) groupIdentifier
{
    NSMutableArray* contacts=[[NSMutableArray alloc]init];
   
    if(groupIdentifier==0)
    {
        Contact *a = [[Contact alloc]initWithName:@"Dil"];
        Contact *b = [[Contact alloc]initWithName:@"Daimon"];
        [contacts insertObject:a atIndex:0];
        [contacts insertObject:b atIndex:1];
        return contacts;
    }
    else
    {
        Contact *a = [[Contact alloc]initWithName:@"Alex"];
        Contact *b = [[Contact alloc]initWithName:@"Andrea"];
        [contacts insertObject:a atIndex:0];
        [contacts insertObject:b atIndex:1];
        return contacts;
    }
}


@end
