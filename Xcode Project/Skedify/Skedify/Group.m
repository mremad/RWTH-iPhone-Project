//
//  Group.m
//  Skedify
//
//  Created by M on 1/15/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "Group.h"

@implementation Group


- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    return self;
}

- (id)initWithName:(NSString *)theGroupName
{
    self = [super init];
    if(self)
    {
        _name = theGroupName;
        _members = [[NSMutableArray alloc]init];
        _groupSchedule = [NSMutableArray arrayWithObjects:nil];
    }
    
    return self;
}

- (id)initWithName:(NSString *)theGroupName andID :(NSInteger) theId
{
    self = [super init];
    if(self)
    {
        _name = theGroupName;
        _members = [[NSMutableArray alloc]init];
        _groupSchedule = [NSMutableArray arrayWithObjects:nil];
        _groupId=theId;
    }
    
    return self;
}

- (id)initWithName:(NSString *)theGroupName WithId:(NSInteger) groupid
{
    self = [super init];
    if(self)
    {
        _name = theGroupName;
        _members = [[NSMutableArray alloc]init];
        _groupId = groupid;
    }
    
    return self;
}


-(void)insertMember :(Member *)theMember
{
    if([self memberDoesNotHasSameEmailAsAGroupMember:theMember])
    {
         [_members insertObject:theMember atIndex:[_members count]];
    }
}

-(BOOL)memberDoesNotHasSameEmailAsAGroupMember:(Member *) theMember
{
    for(Member *otherMember in _members)
    {
        if([[theMember emailAddress] isEqualToString:[otherMember emailAddress]])
        {
            return NO;
        }
    }
    
    return YES;
}

-(void)removeMemberWithEmail :(NSString *)theEmail
{
    for(int i=0;i<[_members count];i++)
    {
        Member *m =[_members objectAtIndex:i];
        if([m.emailAddress isEqualToString:theEmail])
        {
            [_members removeObjectAtIndex:i];
        }
    }
}




@end
