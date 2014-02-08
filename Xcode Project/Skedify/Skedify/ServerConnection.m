//
//  ServerConnection.m
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//


#import "ServerConnection.h"
#import "Member.h"
#import "HttpRequest.h"
#import "Notification.h"
#import "GlobalVariables.h"

@implementation ServerConnection

@synthesize createdGroupID;

#pragma mark -
#pragma mark Inisilaisation

static ServerConnection *sharedServerConnection = nil;
static NSString *serverAdress = @"https://www.gcmskit.com/skedify/ajax.php";

/*
 * returns the singleton instance of ServerConnection.
 */
+ (ServerConnection *)sharedServerConnection
{
    if (nil != sharedServerConnection) {
        return sharedServerConnection;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedServerConnection = [[ServerConnection alloc] init];
    });
    
    return sharedServerConnection;
}



- (id)init
{
    self = [super init];
    
    if (self)
    {
        _dateOfLastShakeGesture= [NSDate dateWithTimeIntervalSince1970:0];
        _userSlotsArray = [NSMutableArray arrayWithObjects:nil];
        _userSchedules = [[NSMutableDictionary alloc] initWithObjects:[NSMutableArray arrayWithObjects:nil]
                                                              forKeys:[NSMutableArray arrayWithObjects:nil]];
        _savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer =[[NSMutableArray alloc] initWithArray:@[[[NSMutableArray alloc]init],[[NSMutableArray alloc]init], [[NSMutableArray alloc]init]]];
        _counterOfSentDatesFromIPhoneAndL2pToServer=0;
        _notificationsList = [[NSMutableArray alloc]init];
        
        //dispatch_async(dispatch_get_main_queue(), ^{
          //  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateAllDateTimerMethod:) userInfo:nil repeats:YES];
           // [[NSRunLoop currentRunLoop] run];
       // });
    }
    
    return self;
}
#pragma mark -
#pragma mark some convenience methods


- (void) appStart
{
     [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    //deletes stored NsUserDefaults values
    // TODO: make sure the line above is removed
}

-(NSDateComponents *) getNSDateComponents :(NSDate *) theDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitWeekday|NSCalendarUnitWeekOfYear;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:theDate];
    return components;
}

- (void) logDate:(NSDate *) startingSlot andSlotStatus :(SlotStatus) status andweekDay:(Day) weekDay
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSString *theDate = [dateFormat stringFromDate:startingSlot];
    NSString *theTime = [timeFormat stringFromDate:startingSlot];
    NSLog(@" Adding this slot \n"
          "theDate: |%@| \n"
          "theStartTime: |%@| \n" "marked as %u and the weekday is %d"
          , theDate, theTime,status,weekDay);
}

- (void) navigateToScheduleView:(NSInteger) thegroupId andGroupName:(NSString*) groupName
{
    [_delegatenotificationsView shakeGroupCreationActionRecieved:thegroupId];
}

-(BOOL) existsEquivalentNotification :(Notification*)fetchedNotification
{
    for (Notification *notification in self.notificationsList)
    {
        if ([self compareNotification:notification isEqualNotification:fetchedNotification])
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL) compareNotification:(Notification *)firstNotification isEqualNotification:(Notification *)secondNotification{
    
    if ((firstNotification.isGroupInvitationNotification == secondNotification.isGroupInvitationNotification) && (firstNotification.group.groupId== secondNotification.group.groupId) && ([firstNotification.senderName isEqualToString:secondNotification.senderName]) && ([firstNotification.meetingBeginningTime isEqual:secondNotification.meetingBeginningTime]) && ([firstNotification.meetingEndingTime isEqual:secondNotification.meetingEndingTime]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString*) getUserEmail
{
    if ([_accountEmailAddress length] == 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _accountEmailAddress = [defaults objectForKey:@"accountEmailAddress"];
    }
    return _accountEmailAddress;
}

- (NSString*) getNickname
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return[defaults objectForKey:@"accountNickName"];
}

- (void) updateAllDateTimerMethod:(NSTimer *)timer
{
    return ; //TODO: think about how to to this
    if(!_alreadySignedIn)
    {
        return;
    }
    if (YES) { //if there is shaking motion
       // dispatch_async(dispatch_get_main_queue(), ^{
         //   [self getFromServerPullData];
        //});
    }
    
    for(int i=0;i<[_groupsList count];i++)
    {
        Group* g = [_groupsList objectAtIndex:i];
        if(g.groupId!=0) //some groups are added in the grouplist but did not yet retieve their id
        {
            [self fetchGroupSchedule:g fromTimeSlot:[NSDate dateWithTimeIntervalSince1970:1259539200] toTimeSlot:[NSDate dateWithTimeIntervalSince1970:1417305600]];
        }
    }
}

-(void) memberAcceptedGroupInvitation:(Member *) memberThatAcceptedGroupInvitation
{
    memberThatAcceptedGroupInvitation.hasAcceptedGroupInvitation=YES;
    if ([_delegatenotificationsView respondsToSelector:@selector(memberAcceptRejectinGroupNotification)])
    {
        [_delegatenotificationsView memberAcceptRejectinGroupNotification];
    }
}

#pragma theL2PIphone Begginig Calls

- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatus:(SlotStatus) status
{
    [(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:0] addObject:startDate];
    [(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:1] addObject:endDate];
    [(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:2] addObject:[NSString stringWithFormat: @"%d", status]];
}

-(void) sendPrivateSchedule
{   //called once
    
    return; //To be removed
    
    _counterOfSentDatesFromIPhoneAndL2pToServer = [[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:0]  count] ;
    for(int i=0;i<[(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:0]  count];i++)
    {
        NSDate *startDate = (NSDate *) [(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:0] objectAtIndex:i];
        NSDate *endDate = (NSDate *) [[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:1] objectAtIndex:i];
        int status = [(NSString *) [[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:2] objectAtIndex:i] intValue];
        [self sendSlot:startDate toTimeSlot:endDate WithSlotStatus:status];
    }
}


- (void) storeAccountInfoInUserDefaultsAndOnServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountEmailAddress forKey:@"accountEmailAddress"];
    [defaults setObject:_accountNickName forKey:@"accountNickName"];
    [[NSUserDefaults standardUserDefaults] synchronize]; //just to be sure its saved ..even on simulator
    [self login];
}


#pragma Schedule Methods

- (void) addDateToMutableArrayWithWeekNumber:(NSInteger)weekNumber AndDay :(Day) weekDay andStartingSlot: (NSDate *) startingSlot andSlotStatus :(SlotStatus) status
{
    [self logDate:startingSlot andSlotStatus:status andweekDay:weekDay];
    
    Slot* newSlot = [[Slot alloc] initWithStartTime:startingSlot withWeekNum:weekNumber withDay:weekDay withSlotStatus:status];
    [_userSlotsArray addObject:newSlot];
}


/*Specialized (per group) Schedule functions*/
- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatus:(SlotStatus) status withGroupId:(NSInteger)groupId
{
    while([endDate compare: startDate] == NSOrderedDescending)
    {
        [self addScheduleSlotStartingAtDate:startDate withSlotStatus:status withGroupId:groupId];
        startDate = [startDate dateByAddingTimeInterval:+900]; //add 15minutes to the start date
    }
}

/*Specialized (per group) Schedule functions*/
- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate withSlotStatus:(SlotStatus) status withGroupId:(NSInteger)groupId
{
    NSDateComponents *startDateComponents = [self getNSDateComponents:startDate];
    
    int weekday=[startDateComponents weekday]-2;
    if(weekday==-1)
    {
        weekday = 6;
    }
    
    [self addDateToMutableArrayWithWeekNumber: [startDateComponents weekOfYear] AndDay:weekday andStartingSlot:startDate  andSlotStatus:status andGroupId:groupId];
}

/*Specialized (per group) Schedule functions*/
-(void) addDateToMutableArrayWithWeekNumber:(NSInteger)weekNumber
                                    AndDay:(Day) weekDay
                           andStartingSlot: (NSDate *) startingSlot
                            andSlotStatus :(SlotStatus) status
                                andGroupId:(NSInteger)groupId
{
    [self logDate:startingSlot andSlotStatus:status andweekDay:weekDay];
    
    Slot* newSlot = [[Slot alloc] initWithStartTime:startingSlot withWeekNum:weekNumber withDay:weekDay withSlotStatus:status];
    
    NSMutableArray* groupSched = [self getGroupGivenGroupId:groupId].groupSchedule;
    [groupSched addObject:newSlot];
}


#pragma mark -
#pragma mark Group Handling INTERNAL methods

- (NSArray *) getGroupList
{
    return _groupsList; //we do not have an instance of this class thats why we retrive properties this way
}

- (Group *) getGroupGivenGroupId:(NSInteger) theGroupId
{
    for(int i =0;i<[_groupsList count];i++)
    {
        Group* g =[_groupsList objectAtIndex:i];
        if(g.groupId==theGroupId)
        {
            return g;
        }
    }
    [NSException raise:@"Unrecognized Id" format:@"should never happen getGroupGivnGroupId"];
    NSLog(@"should never happen getGroupGivnGroupId");
    return nil;
}

- (Group *) getGroupGivenName:(NSString *) groupName
{
    for(int i=0;i<[_groupsList count];i++)
    {
        Group *g =[_groupsList objectAtIndex:i];
        if([g.name isEqualToString:groupName])
        {
            return g;
        }
    }
    return nil;
}

- (void) addGroupInternally:(Group *) theGroup WithMembersEmails:(NSArray *) members
{
    return; //needs to be thought about
    for(int i=0;i<[members count];i++)
    {
        [theGroup insertMember: [[Member alloc] initWithEmail:[members objectAtIndex:i]]];
    }
    
    [_groupsList insertObject:theGroup atIndex:[_groupsList count]];//insert in last slot
}



// receive KVO notification
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //not sure if we need such methods
    NSLog(@"kvo received: %@", keyPath);
    if([keyPath isEqualToString:@"createdGroupID"])
    {
        //NSNumber *groupID = [change objectForKey:@"new"];
        // TODO: do whatever you want to do with this id
    }
    else
    {
        NSLog(@"unknown kvo received: %@", keyPath);
        for (id key in change)
        {
            NSLog(@"key: %@, value: %@ \n", key, [change objectForKey:key]);
        }
    }
    /*
     //[self addObserver:self forKeyPath:@"createdGroupID" options:NSKeyValueObservingOptionNew +
     NSKeyValueObservingOptionOld context:nil];
     */
}



#pragma mark -
#pragma mark Recieiving Data From Server methods

- (void) fetchGroupSchedule: (Group*) group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot
{
    //TODO : change after Yigit changes the last day bug
    NSString *startDate = [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]];
    NSString *endDate = [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]];

    NSDictionary* requestDictionary = @{@"action" : @"CalculateGroupSchedule",
                                        @"username" : [self getUserEmail],
                                        @"groupID" : [NSNumber numberWithInt:[group groupId]],
                                        @"start" : startDate,
                                        @"end" : endDate};
    
    NSMutableArray *startDates=(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:0];
    NSMutableArray *endDates=(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:1];
    NSMutableArray *statuses=(NSMutableArray *)[_savedIphoneAndL2pEventsToSendToServerOnceNickNameAndEmailSentToServer objectAtIndex:2];
    int size = [startDates count];
    for(int i=0;i<100;i++)
    {
        int random=(i*group.groupId)%size;
        NSDate *startDate = (NSDate *) [startDates objectAtIndex:random ];
        NSDate *endDate = (NSDate *) [endDates objectAtIndex:random ];
        int status = [(NSString *) [statuses objectAtIndex:random ] intValue];
        [self addScheduleSlotStartingAtDate:startDate andEndingAtDate:endDate withSlotStatus:status withGroupId:[group groupId]];
    }
    return;//TODO: REMOVE all this
    
    
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary)
            {
                NSLog(@"Schedule received: %@", dictionary);
                int i = 0;
                for (NSDictionary *dict in dictionary) {
                    NSLog(@"Dict: %@", dict);
                    for (NSDictionary *slot in dict) {
                        if ([[slot allKeys] containsObject:@"start"]) {
                        NSTimeInterval intStart=[[slot objectForKey:@"start"] doubleValue];
                        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:intStart];
                        
                        NSTimeInterval intEnd=[[slot objectForKey:@"end"] doubleValue];
                        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:intEnd];
                        
                        SlotStatus slotStaus;
                        NSString *state = [slot objectForKey:@"state"];
                        if ([state isEqualToString:@"appointment_fixed"]) {
                            slotStaus = SlotStateMeeting;
                        } else if ([state isEqualToString:@"busy"]) {
                            slotStaus = SlotStateBusy;
                        } else {
                            slotStaus = SlotStateFree;
                        }
                        NSLog(@"state %u", slotStaus);
                        
                        [self addScheduleSlotStartingAtDate:startDate andEndingAtDate:endDate withSlotStatus:slotStaus withGroupId:[group groupId]];
                        i++;
                        }
                    }
                }
                NSLog(@"%d groups received", i);
            } errorHandler:nil];
}



/*
 
 RequestNotification: Group Invitation , Meeting Invitation
 
 AcceptRejectNotification: MemberAcceptGroup, MemberRejectMeeting, MemberRejectGroup
 
 */



#pragma Notification Handling 

/**Receive Notification from server and concatinate it in the notifications list
 Expected from server isGroupInvitation = Yes => GroupInvitation, NO => MeetingInvitation
 if group invitation: group name and group creator name
 else if meeting invitation: group name, meeting beginning time and meeting ending time
 **/

-(void) didReceiveFromServerRequestNotificationWithType: (BOOL)isGroupInvitation group:(NSInteger)groupId sender:(NSString*)senderName beginsAt:(NSDate*) beginTime endsAt:(NSDate*) endTime groupName:(NSString *) groupName senderNickName:(NSString *) theSenderNick
{
    Notification *fetechedNotification = [[Notification alloc] init];
    fetechedNotification.isGroupInvitationNotification = isGroupInvitation;
   // Group *g=[self getGroupGivenGroupId:groupId]; group not yet here
    Group *g=nil;
    fetechedNotification.group = g;
    fetechedNotification.groupName = groupName;
    fetechedNotification.senderName = theSenderNick;
    fetechedNotification.meetingBeginningTime = beginTime;
    fetechedNotification.meetingEndingTime = endTime;
    fetechedNotification.groupId=groupId;
    
    
    if (![self existsEquivalentNotification:fetechedNotification])
    {
        [self.notificationsList addObject:fetechedNotification];
        
        self.notificationsNotReadCounter ++;
        
        if ([_delegatenotificationsView respondsToSelector:@selector(notificationRecieved)])
        {
            [_delegatenotificationsView notificationRecieved];
        }
    }
}


/*
 * handles all notfication messages recieved from the server
 */
- (void) didReceiveFromServerAcceptRejectNotification
{
    if(YES) // member accepted Group
    {
        Member *theFetchedMember=[[Member alloc]init];
            [self memberAcceptedGroupInvitation:theFetchedMember];
    }
    if(YES) // member declined Group
    {
            // TODO: We need to think of this a little about ... (probelm woth multple group names..)
            NSString *emailOfMember = @"theDeclinedMembersEmail";
            NSString *theGroupName =@"theGroupName";
            Group *g = [self getGroupGivenName:theGroupName];
            [g removeMemberWithEmail:emailOfMember];
    }
        // here the situation is that you get a notification in one of the add group or add contact view.
        // in thoose views you do not have a notification icon as designed
        // The question was if we need to generate a kind of alert to the user that something is recieved
        // Solution 1 vibrate (easy) . Solution 2 do nothing (easy) . Solution 3 build some kind of notification label
        // appearing showing short discription of the notification and if we built such a thing, we could use it in all other
        // views(Views containg the notification icon)
}






#pragma Server HTTP Requests

//this clang diagnostic pragma is to ignore the warning about the selector causing a leak
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void) sendToServerTemplate : (NSDictionary *) jsonArguments withHandler:(SEL) selectorToCall usingHTTPResultInHandler: (BOOL) useResult withObjectToHandler:(NSObject*) handlerObject withBeforeLogMessage:(NSString *) beforeLog withAfterLogMessage:(NSString *) afterLog
{
    NSLog(@"%@",beforeLog);
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:jsonArguments completionHandler:^(NSDictionary* dictionary)
            {
                NSLog(@"%@",afterLog);
                if(useResult && handlerObject != nil)
                {
                    [self performSelector:selectorToCall withObject:dictionary withObject:handlerObject];
                }
                else if(useResult)
                {
                    [self performSelector:selectorToCall withObject:dictionary];
                }
                else
                {
                    [self performSelector:selectorToCall withObject:handlerObject];
                }
            } errorHandler:nil];
    
}

#pragma clang diagnostic warning "-Warc-performSelector-leaks"

- (void) acceptGroupRequest:(NSInteger) groupId;
{
    NSDictionary* requestDictionary = @{@"action"   : @"AcceptInvitation",
                                        @"username" : [self getUserEmail],
                                        @"groupID"  : [NSString stringWithFormat: @"%ld", (long)groupId]};
    
    [self sendToServerTemplate:requestDictionary withHandler:nil usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"Accepting group request %ld", (long)groupId] withAfterLogMessage:[NSString stringWithFormat:@"Accepted group request %@", requestDictionary]];
}



- (void) addMemberWithEmail:(NSString *)memberEmail inGroup:(NSInteger) theGroupId
{
    NSDictionary* requestDictionary = @{@"action"   : @"AddGroupUser",
                                        @"username" : memberEmail,
                                        @"groupID"  : [NSString stringWithFormat: @"%ld", (long)theGroupId],
                                        @"adder"    : [self getUserEmail]};
    
    [self sendToServerTemplate:requestDictionary withHandler:nil usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"Adding user %@ to group %ld", memberEmail, (long)theGroupId] withAfterLogMessage:[NSString stringWithFormat:@"User added: %@", requestDictionary]];
}

-(void) addGroup:(Group *)group WithMembersEmails:(NSArray *) members
{
    NSDictionary* requestDictionary = @{@"action" : @"AddGroup",
                                        @"username" : [self getUserEmail],
                                        @"groupname" : [group name]};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(addGroupHandler:withArrayContainingMembersAndGroup:) usingHTTPResultInHandler:YES withObjectToHandler:@[members,group] withBeforeLogMessage:[NSString stringWithFormat:@"Creating group %@ with %lu members", [group name], (unsigned long)[members count]] withAfterLogMessage:[NSString stringWithFormat:@"User added: %@", requestDictionary]];
}

- (void) createMeeting:(Group *)group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot
{
    NSDictionary* requestDictionary = @{@"action"   : @"SetAppointment",
                                        @"groupID"  : [NSString stringWithFormat: @"%ld", (long)group.groupId],
                                        @"start"    : [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]],
                                        @"end"      : [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]]};
    
    [self sendToServerTemplate:requestDictionary withHandler:nil usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"Setting Appointment for group  %ld", (long)[group groupId]] withAfterLogMessage:@""];
}

- (void) fetchGroups
{
    NSDictionary* requestDictionary = @{@"action"   : @"GetGroups",
                                        @"username" : [self getUserEmail]};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(fetchGroupHandler:) usingHTTPResultInHandler:YES  withObjectToHandler:nil withBeforeLogMessage:@"Fetching Groups" withAfterLogMessage:@"Groups received"];
}

- (void) getFromServerPullData
{
    NSDictionary* requestDictionary = @{@"action"   : @"PullData",
                                        @"username" : [self getUserEmail]};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(pullDataHanlder:) usingHTTPResultInHandler:YES  withObjectToHandler:nil withBeforeLogMessage:@"Pulling data from server" withAfterLogMessage:[NSString stringWithFormat:@"Data pulled from server"]];
}

/*
 logs in with email.
 */
- (void) login
{
    NSDictionary* requestDictionary = @{@"action"   : @"Login",
                                        @"username" : [self getUserEmail]};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(setNickName) usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"logging in %@", [self getUserEmail]] withAfterLogMessage:[NSString stringWithFormat:@"Login completed with dictionary: %@", requestDictionary]];
}

- (void) removeGroup:(Group *)group
{
    NSDictionary* requestDictionary = @{@"action"   : @"RemoveGroup",
                                        @"username" : [self getUserEmail]};
    
    [self sendToServerTemplate:requestDictionary withHandler:nil usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"Removing a group %ld", (long)group.groupId] withAfterLogMessage:[NSString stringWithFormat:@"Group removed: %@", requestDictionary]];
}

- (void) rejectGroupRequest:(Group *) group
{
    NSDictionary* requestDictionary = @{@"action"   : @"RejectInvitation",
                                        @"username" : [self getUserEmail],
                                        @"groupID"  : [NSString stringWithFormat: @"%ld", (long)group.groupId]};
    
    [self sendToServerTemplate:requestDictionary withHandler:nil usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"Rejecting group request %@", [group name]] withAfterLogMessage:[NSString stringWithFormat:@"Rejected group request %@", [group name]]];
}

- (void) rejectMeeting:(Group *) group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot
{
    NSDictionary* requestDictionary = @{@"action"   : @"DeleteAppointment",
                                        @"username" : _accountEmailAddress,
                                        @"groupID"  : [NSString stringWithFormat: @"%ld", (long)group.groupId],
                                        @"start"    : [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]],
                                        @"end"      : [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]]};
    
    [self sendToServerTemplate:requestDictionary withHandler:nil usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"Rejecting group request %@", [group name]] withAfterLogMessage:[NSString stringWithFormat:@"Group Meeting rejected. %@", requestDictionary]];
}

- (void) sendSlot: (NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot WithSlotStatus: (SlotStatus) slotStatus
{
    NSString *action = slotStatus==SlotStateFree ? @"SetAvailable" : @"SetBusy" ;
    NSDictionary* requestDictionary = @{@"action"   : action,
                                        @"username" : [self getUserEmail],
                                        @"start"    : [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]],
                                        @"end"      : [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]]};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(sendSlotHandler) usingHTTPResultInHandler:NO withObjectToHandler:nil withBeforeLogMessage:@"" withAfterLogMessage:[NSString stringWithFormat:@"Appointment set: %@", requestDictionary]];
}

- (void) setNickName
{
    NSDictionary* requestDictionary = @{@"action"   : @"Login",
                                        @"username" : [self getUserEmail],
                                        @"nickname" : [self getNickname]};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(sendPrivateSchedule) usingHTTPResultInHandler:NO  withObjectToHandler:nil withBeforeLogMessage:[NSString stringWithFormat:@"Sending Nickname %@", [self getNickname]] withAfterLogMessage:[NSString stringWithFormat:@"Nickname sent: %@", requestDictionary]];
}

-(void) setShakelocation:(CLLocation *)location
{
    NSDictionary* requestDictionary = @{@"action"   : @"Shake",
                                        @"username" : [self getUserEmail],
                                        @"latitude" : [NSNumber numberWithDouble:[location coordinate].latitude],
                                        @"longitude": [NSNumber numberWithDouble:[location coordinate].longitude]};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(shakeLocationHandler:) usingHTTPResultInHandler:YES withObjectToHandler:nil withBeforeLogMessage:@"sending shake action to server" withAfterLogMessage:@""];
}

-(void) getShakeMessageFromServer
{
    NSDictionary* requestDictionary = @{@"action"   : @"PullData",
                                        @"username" : [self getUserEmail],
                                        @"getShakeInfo" : @1};
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(getShakeMessageFromServerHandler:) usingHTTPResultInHandler:YES withObjectToHandler:nil withBeforeLogMessage:@"Pulling Shake info from server" withAfterLogMessage:@""];
    
}

- (NSArray *) getGroupContacts: (NSInteger) groupId
{
    NSDictionary* requestDictionary = @{@"action"   : @"GetGroupUsers",
                                        @"username" : [self getUserEmail], //is not necesary theoritical
                                        @"groupID"  : [NSNumber numberWithInt:groupId]};
    _groupMembers = [[NSMutableArray alloc]init];//TODO: proabbly change
    
    [self sendToServerTemplate:requestDictionary withHandler:@selector(getGroupHandler:) usingHTTPResultInHandler:YES withObjectToHandler:nil withBeforeLogMessage:@"Fetching group members" withAfterLogMessage:@""];
    
    
    // TODO: KIKO change groupIdentifier from array position to group Id
    Group *theIdentifierGroup = [self getGroupGivenGroupId:groupId]; // TODO: check what this does
    return [theIdentifierGroup members];
}

#pragma Method Calls Handler

- (void) sendSlotHandler
{
    //
    
    _counterOfSentDatesFromIPhoneAndL2pToServer--;
    if(_counterOfSentDatesFromIPhoneAndL2pToServer==0)
    {
        _alreadySignedIn=YES;
        [self fetchGroups];
        [self updateAllDateTimerMethod:Nil];
    }
    //[self updateAllDateTimerMethod:Nil];
}

-(void) pullDataHanlder :(NSDictionary *) dictionary
{
    for (NSDictionary *dict in dictionary)
    {
        NSDictionary * invites = [dict objectForKey:@"invites"];
        for (NSDictionary *invite in invites)
        {
            NSLog(@"Got invite");
            NSNumber *groupID = [invite objectForKey:@"groupID"];
            NSString *senderName = [invite objectForKey:@"senderUsername"];
            NSString *groupName = [invite objectForKey:@"groupname"];
            
            NSDate *date;
            [self didReceiveFromServerRequestNotificationWithType:YES group:[groupID integerValue] sender:senderName beginsAt:date endsAt:date groupName:groupName senderNickName:senderName];
        }
        
        NSDictionary * appointments = [dict objectForKey:@"invites"];
        for (NSDictionary *app in appointments)
        {
            NSLog(@"Got appointment");
            NSNumber *groupID = [app objectForKey:@"groupID"];
            NSString *senderName = [app objectForKey:@"senderUsername"];
            
            NSTimeInterval intStart=[[app objectForKey:@"start"] doubleValue];
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:intStart];
            
            NSTimeInterval intEnd =[[app objectForKey:@"end"] doubleValue];
            NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:intEnd];
            
            [self didReceiveFromServerRequestNotificationWithType:NO group:[groupID integerValue] sender:senderName beginsAt:startDate endsAt:endDate groupName:@"" senderNickName:@""];
        }
    }
}

- (void) fetchGroupHandler:(NSDictionary *) dictionary
{
    _groupsList = [[NSMutableArray alloc]init];
    int i = 0;
    for (NSDictionary *dict in dictionary)
    {
        NSLog(@"Dict: %@", dict);
        NSDictionary * groups = [dict objectForKey:@"groups"];
        for (NSDictionary *group in groups)
        {
            NSNumber *groupID = [group objectForKey:@"groupID"];
            NSString *groupName = [group objectForKey:@"groupname"];
            //TODO:add members here
            NSLog(@"Group %@ with id %@", groupName, groupID);
            
            Group* g = [[Group alloc]initWithName:groupName andID:[groupID integerValue]];
            [_groupsList insertObject:g atIndex:i];
            i++;
        }
    }
    if ([_delegatenotificationsView respondsToSelector:@selector(groupsRefreshed)])
    {
        [_delegatenotificationsView groupsRefreshed];
    }
}

-(void) shakeLocationHandler:(NSDictionary *) dictionary
{
    NSLog(@"Shake sent: %@", dictionary);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getShakeMessageFromServer) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] run];
    });
}

-(void) addGroupHandler :(NSDictionary *) dictionary withArrayContainingMembersAndGroup:(NSArray *) membersAndGroup
{
    
    NSArray *members = [membersAndGroup objectAtIndex:0];
    for (NSDictionary *dict in dictionary)
    {
        NSNumber *groupID = [dict objectForKey:@"groupID"];
        for (NSString *email in members)
        {
            [self addMemberWithEmail:email inGroup:[groupID intValue]];
        }
    }
    
    [self fetchGroups];
}

- (void) getShakeMessageFromServerHandler:(NSDictionary *) dictionary
{
    for (NSDictionary *dict in dictionary)
    {
        // will be something like
        // [{"shakeInfo":{"groupID":"66","groupname":"New Group"}}]
        NSDictionary * info = [dict objectForKey:@"shakeInfo"];
        createdGroupID = [[info objectForKey:@"groupID"] integerValue];
        NSString *groupName = [info objectForKey:@"groupname"];
        [self navigateToScheduleView:createdGroupID andGroupName:groupName];
    }
}

-(void) getGroupHandler :(NSDictionary *) dictionary
{
    int i = 0;
    for (NSDictionary *dict in dictionary)
    {
        NSLog(@"Dict: %@", dict);
        NSDictionary * users = [dict objectForKey:@"users"];
        NSLog(@"Users of group: %@", users);
        for (NSDictionary *user in users)
        {
            // NSNumber *userID = [user objectForKey:@"groupID"];
            NSString *name = [user objectForKey:@"username"];
            
            // create group object and add it to the list
            Member *m = [[Member alloc]initWithName: name];
            [_groupMembers insertObject:m atIndex:i];
            i++;
        }
    }
}


@end
