//
//  Contact.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "Contact.h"

@implementation Contact


- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    return self;
}

- (id)initWithName:(NSString *)theNickName
{
    self = [super init];
    _nickName=theNickName;
    return self;
}
@end
