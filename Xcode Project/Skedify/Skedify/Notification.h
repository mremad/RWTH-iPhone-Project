//
//  Notification.h
//  Skedify
//
//  Created by Mariam Abouelfadl on 2/1/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property BOOL isGroupInvitationNotification; // else meeting invitation notification
@property NSString *groupName;
@property NSString *senderName;
@property NSDate *meetingBeginningTime;
@property NSDate *meetingEndingTime;

@end
