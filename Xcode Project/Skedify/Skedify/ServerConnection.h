//
//  ServerConnection.h
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface ServerConnection : NSObject
{
    NSInteger * userIdentifier;
}

+ (ServerConnection *)sharedServerConnection;
- (NSArray *) GetGroupList;
- (NSArray *) GetGroupContacts: (int) groupIdentifier;

@end
