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
- (void) groupsRefreshed;
@end
@interface ServerConnection : NSObject
{
  NSInteger createdGroupID;
    
}
@property NSInteger createdGroupID;


+ (ServerConnection *) sharedServerConnection;

//method called minimal times in the start of the App
- (void) appStart;
- (NSString*) getUserEmail;
- (NSString*) getNickname;
- (void) storeAccountInfoInUserDefaultsAndOnServer;

//Group related
- (Group *) getGroupGivenGroupId:(NSInteger) theGroupId;
- (NSArray *) getGroupList;
- (NSArray *) getGroupContacts: (NSInteger) groupIdentifier;
- (void) addGroup:(Group *) theGroup WithMembersEmails:(NSArray *) membersEmails;

- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatus:(SlotStatus) status;
- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatus:(SlotStatus) status withGroupId:(NSInteger)groupId;

-(void)didReceiveFromServerRequestNotificationWithType: (BOOL)isGroupInvitation group:(NSInteger)groupId sender:(NSString*)senderName beginsAt:(NSDate*) beginTime endsAt:(NSDate*) endTime groupName:(NSString *) groupName senderNickName:(NSString *) theSenderNick;

- (void) addMemberWithEmail:(NSString *)memberEmail inGroup:(NSInteger) theGroupId;

- (void) setShakelocation:(CLLocation *)location;
- (void) acceptGroupRequest:(NSInteger) groupId;
- (void) rejectGroupRequest:(Group *) group;
- (void) rejectMeeting:(Group *) group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot;
- (void) createMeeting:(Group *)group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot;
- (void) removeGroup:(Group *)group;
- (void) sendSlot: (NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot WithSlotStatus: (SlotStatus) slotStatus;
- (void) getFromServerPullData;


@property (nonatomic, readonly) NSMutableArray *savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer;


/*   Schedule Parameters  */
@property (nonatomic) NSInteger counterOfSentDatesFromIPhoneAndL2pToServer;
@property (nonatomic, readonly) NSMutableArray *userSlotsArray;
@property (nonatomic, readonly) NSMutableDictionary *userSchedules;
@property (nonatomic) BOOL alreadySignedIn;
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

