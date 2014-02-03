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
#import "Slot.h"
#import "GlobalVariables.h"

//enum _acceptRejectNotification {
  //Kiko
@protocol ServerConnectionCurrentNotifiableShakableViewDelegate <NSObject>
@required
- (void)shakeGroupCreationActionRecieved:(NSInteger) groupID;
@optional
- (void) notificationRecieved;
- (void) memberAcceptRejectinGroupNotification;
@end
@interface ServerConnection : NSObject
{
  NSInteger createdGroupID;
}
@property NSInteger createdGroupID;

+ (ServerConnection *) sharedServerConnection;
- (NSArray *) GetGroupList;
- (NSArray *) GetGroupContacts: (NSInteger) groupIdentifier;
- (void) addGroup:(Group *) theGroup WithMembersEmails:(NSArray *) membersEmails;
- (void) AppStart;
- (void) SendToServerShakeLocation:(CLLocation *)location;
- (void) SendToServerRemoveGroup:(Group *)group;
- (void) SendToServerAcceptGroupRequest:(Group *) group;
- (void) SendToServerRejectGroupRequest:(Group *) group;
- (void) SendToServerRejectMeeting:(Group *) group fromTimeSlot:(NSDate *) startingTimeSlot;
- (void) SendToServerAcceptMeeting:(Group *) group fromTimeSlot:(NSDate *) startingTimeSlot;
- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatus:(SlotStatus) status;

- (void) storeAccountInfoInUserDefaultsAndOnServer;
- (NSString*) getUserEmail;
- (NSString*) getNickname;

-(Group *) getGroupGivenGroupId:(NSInteger) theGroupId;


/*   Schedule Parameters  */

@property (nonatomic, readonly) NSMutableArray *userSlotsArray;
@property (nonatomic, readonly) NSMutableDictionary *userSchedules;

/*   Schedule Parameters  */

@property (nonatomic, readonly) NSMutableArray *groupsList;
@property (nonatomic, readonly) NSMutableArray *groupMembers;
@property (nonatomic, weak) id<ServerConnectionCurrentNotifiableShakableViewDelegate> delegatenotificationsView;
@property NSMutableArray *notificationsList;
@property int notificationsNotReadCounter;
@property (nonatomic) NSString *accountEmailAddress;
@property (nonatomic) NSString  *accountNickName;
@property (nonatomic) NSDate* dateOfLastShakeGesture;

@end

