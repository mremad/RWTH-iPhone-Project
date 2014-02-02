//
//  Group.h
//  Skedify
//
//  Created by M on 1/15/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface Group : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger *groupId;
@property (nonatomic, readonly) NSMutableArray *members;

- (id)initWithName:(NSString *)theGroupName;
-(void)insertMember :(Member *)theMember;
-(void)removeMemberWithEmail :(NSString *)theEmail;
@end
