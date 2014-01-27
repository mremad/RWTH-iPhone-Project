//
//  ServerConnection.h
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Member.h"
#import "Group.h"

@protocol ServerConnectionCurrentNotifiableShakableViewDelegate <NSObject>
@required
- (void)shakeRecieved;
@optional
- (void)notifitcationRecieved;
@end
@interface ServerConnection : NSObject
{
    NSInteger * userIdentifier;
}

+ (ServerConnection *) sharedServerConnection;
- (NSArray *) GetGroupList;
- (NSArray *) GetGroupContacts: (NSInteger) groupIdentifier;
- (void) addGroup:(Group *) theGroup;
- (Group *) GetGroup:(NSInteger) index;
@property (nonatomic, readonly) NSMutableArray *groupsList;
@property (nonatomic, weak) id<ServerConnectionCurrentNotifiableShakableViewDelegate> notificationsViewDelegate;

@end
