//
//  Contact.h
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
@property (nonatomic, readonly) NSString *nickName;


- (id)initWithName:(NSString *)theNickName;

@end
