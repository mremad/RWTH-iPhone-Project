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
    }
    
    return self;
}


-(void)insertMember :(Member *)theMember
{
 [_members insertObject:theMember atIndex:[_members count]];
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
