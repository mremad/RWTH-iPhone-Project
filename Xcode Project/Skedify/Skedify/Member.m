//
//  Member.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "Member.h"

@implementation Member



- (id)initWithNickName:(NSString *)theNickName
{
    //TODO: REMOVE This method should be never called..
    self = [super init];
    _nickName = theNickName;
    
    return self;
}

- (id)initWithEmail:(NSString *)theEmail;
{
    self = [super init];
    _emailAddress = [theEmail lowercaseString];
    return self;
}

-(NSString *) getStrongestIdentifier
{
    if(_nickName!=nil)
    {
        return _nickName;
    }
    else
    {
        return _emailAddress;
    }
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(BOOL) NSStringIsValidRWTHAachenEmail:(NSString *)toCheckString
{
    NSString *checkString = [toCheckString lowercaseString];
    return [checkString hasSuffix:@"rwth-aachen.de"] && [self NSStringIsValidEmail:checkString];
}

@end
