//
//  Notification.m
//  Skedify
//
//  Created by Mariam Abouelfadl on 2/1/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (int) getIndexOfNotificationInArray:(NSMutableArray*) array{
    for (int i=0; i<[array count];i++) {
        Notification *notification = [array objectAtIndex:i];
        
        if ((notification.isGroupInvitationNotification == self.isGroupInvitationNotification) && (notification.groupId== self.groupId) && ([notification.senderName isEqualToString:self.senderName]) && ([notification.meetingBeginningTime compare:self.meetingBeginningTime] == NSOrderedSame) && ([notification.meetingEndingTime compare:self.meetingEndingTime] == NSOrderedSame))
        {
            return i;
        }
    }
    return -1;
}

@end
