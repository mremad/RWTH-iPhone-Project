//
//  Member.h
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (nonatomic, readonly) NSString *nickName;
@property (nonatomic, readonly) NSString *emailAddress;
@property (nonatomic) BOOL hasAcceptedGroupInvitation;


- (id)initWithNickName:(NSString *)theNickName;
- (id)initWithEmail:(NSString *)theEmail;
- (NSString *) getStrongestIdentifier;
+(BOOL) NSStringIsValidRWTHAachenEmail:(NSString *)checkString;
@end
