//
//  Notification.h
//  Skedify
//
//  Created by Mariam Abouelfadl on 2/1/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"

@interface Notification : NSObject

@property BOOL isGroupInvitationNotification; // else meeting invitation notification
@property Group *group;
@property NSString *groupName;
@property NSInteger groupId;
@property NSString *senderName;
@property NSDate *meetingBeginningTime;
@property NSDate *meetingEndingTime;

@end
