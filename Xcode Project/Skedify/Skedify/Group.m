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




@end
