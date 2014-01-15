//
//  ServerConnection.h
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@protocol ServerConnectionCurrentNotifiableViewDelegate <NSObject>
@required
- (void)notifitcationRecieved;

@end
@interface ServerConnection : NSObject
{
    NSInteger * userIdentifier;
}

+ (ServerConnection *)sharedServerConnection;
- (NSArray *) GetGroupList;
- (NSArray *) GetGroupContacts: (int) groupIdentifier;

@property (nonatomic, readonly) NSMutableArray *groupsList;
@property (nonatomic, weak) id<ServerConnectionCurrentNotifiableViewDelegate> notificationsViewDelegate;

@end
