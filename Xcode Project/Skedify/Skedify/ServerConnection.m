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
{
    
}
@synthesize createdGroupID;

#pragma mark -
#pragma mark Singleton stuff

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

- (void) AppStart
{
    //method called as soon as app starts
    //still testing NsDate
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *cal1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp =[[NSDateComponents alloc] init];
    [comp setYear:2014];
    [comp setMonth:1];
    [comp setDay:13];
    [comp setHour:23];
    [comp setMinute:15];
   // [comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *startingDate =[cal dateFromComponents:comp];
    
    NSDateComponents *compEnd =[[NSDateComponents alloc] init];
    [compEnd setYear:2014];
    [compEnd setMonth:1];
    [compEnd setDay:13];
    [compEnd setHour:23];
    [compEnd setMinute:45];
    //[compEnd setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *endingDate =[cal1 dateFromComponents:compEnd];

    [self addScheduleSlotStartingAtDate:startingDate andEndingAtDate:endingDate withSlotStatus:SlotStateBusy];


     [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];//deletes stored values
    // TODO: make sure the line above is removed
}

-(NSDateComponents *)getNSDateComponents :(NSDate *) theDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitWeekday|NSCalendarUnitWeekOfYear;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:theDate];
    return components;
}

/*One time (per user) Schedule functions*/
- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatus:(SlotStatus) status
{
    NSMutableArray *startDates=(NSMutableArray *)[_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer objectAtIndex:0];
    NSMutableArray *endDates=(NSMutableArray *)[_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer objectAtIndex:1];
    NSMutableArray *statuses=(NSMutableArray *)[_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer objectAtIndex:2];
    [startDates addObject:startDate];
    [endDates addObject:endDate];
    [statuses addObject:[NSString stringWithFormat: @"%d", status]];
    
}



-(void) SendScheduleToOurServerOnlyCalledOnce
{
    NSMutableArray *startDates = (NSMutableArray *)[_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer objectAtIndex:0];
    NSMutableArray *endDates = [_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer objectAtIndex:1];
    NSMutableArray *statuses = [_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer objectAtIndex:2];

    for(int i=0;i<[startDates count];i++)
    {
        NSDate *startDate = (NSDate *) [startDates objectAtIndex:i ];
        NSDate *endDate = (NSDate *) [endDates objectAtIndex:i ];
        int status = [(NSString *) [statuses objectAtIndex:i ] intValue];
        [self SendToServerSendSlot:startDate toTimeSlot:endDate isAvailable:status];
    }
}




-(void)AddDateToMutableArrayWithWeekNumber:(NSInteger)weekNumber AndDay :(Day) weekDay andStartingSlot: (NSDate *) startingSlot andSlotStatus :(SlotStatus) status
{
    [self logDate:startingSlot andSlotStatus:status andweekDay:weekDay];
    
    Slot* newSlot = [[Slot alloc] initWithStartTime:startingSlot withWeekNum:weekNumber withDay:weekDay withSlotStatus:status];
    [_userSlotsArray addObject:newSlot];
    
    
    
    

}
/*One time (per user) Schedule functions*/




/*Specialized (per group) Schedule functions*/
- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatus:(SlotStatus) status withGroupId:(NSInteger)groupId
{
    while([endDate compare: startDate] == NSOrderedDescending)
    {
        [self addScheduleSlotStartingAtDate:startDate withSlotStatus:status withGroupId:groupId];
        startDate = [startDate dateByAddingTimeInterval:+900]; //add 15minutes to the start date
    }
}


- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate withSlotStatus:(SlotStatus) status withGroupId:(NSInteger)groupId
{
    NSDateComponents *startDateComponents = [self getNSDateComponents:startDate];
    
    int weekday=[startDateComponents weekday]-2;
    if(weekday==-1)
    {
        weekday = 6;
    }
    
    [self AddDateToMutableArrayWithWeekNumber: [startDateComponents weekOfYear] AndDay:weekday andStartingSlot:startDate  andSlotStatus:status];
}


-(void)AddDateToMutableArrayWithWeekNumber:(NSInteger)weekNumber
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
/*Specialized (per group) Schedule functions*/

-(void)logDate:(NSDate *) startingSlot andSlotStatus :(SlotStatus) status andweekDay:(Day) weekDay
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

- (id)init
{
    self = [super init];
    if (self)
    {
        
        _dateOfLastShakeGesture= [NSDate dateWithTimeIntervalSince1970:0];
        
        _userSlotsArray = [NSMutableArray arrayWithObjects:nil];
        _userSchedules = [[NSMutableDictionary alloc] initWithObjects:[NSMutableArray arrayWithObjects:nil]
                                                              forKeys:[NSMutableArray arrayWithObjects:nil]];
     
        _savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer =[[NSMutableArray alloc] init];
        
        [_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer addObject:[[NSMutableArray alloc]init]];
        [_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer addObject:[[NSMutableArray alloc]init]];
        [_savedIphoneAndL2pEventsTosendToServerOnceNickNameAndEmailSentToServer addObject:[[NSMutableArray alloc]init]];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] run];
            
            
        });
        
        
        
     
    
  
        
    }
    
    return self;
}

- (void)timerFireMethod:(NSTimer *)timer{
    
    if(!_alreadySignedIn)
    {
        return;
    }
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *cal1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    if (YES) { //if there is shaking motion
        dispatch_async(dispatch_get_main_queue(), ^{
            [self GetFromServerPullData];
        });
    }
    NSDateComponents *comp =[[NSDateComponents alloc] init];
    [comp setYear:2010];
    [comp setMonth:1];
    [comp setDay:1];
    [comp setHour:2];
    [comp setMinute:15];
    NSDate *startingDate =[cal dateFromComponents:comp];
    
    NSDateComponents *compEnd =[[NSDateComponents alloc] init];
    [compEnd setYear:2015];
    [compEnd setMonth:1];
    [compEnd setDay:1];
    [compEnd setHour:2];
    [compEnd setMinute:15];
    NSDate *endingDate =[cal1 dateFromComponents:compEnd];
    
    for(int i=0;i<[_groupsList count];i++)
    {
        Group* g = [_groupsList objectAtIndex:i];
        [self fetchGroupSchedule:g fromTimeSlot:startingDate toTimeSlot:endingDate];
    }
    
}

- (void) fetchNeededInformation
{
    _groupsList = [[NSMutableArray alloc]init];
    NSLog(@"fetching froups");
    NSDictionary* requestDictionary = @{@"action" : @"GetGroups",
                                        @"username" : [self getUserEmail]};
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        int i = 0;
        for (NSDictionary *dict in dictionary) {
            NSLog(@"Dict: %@", dict);
            NSDictionary * groups = [dict objectForKey:@"groups"];
                // NSLog(@"Groups: %@", groups);
                for (NSDictionary *group in groups) {
                    NSNumber *groupID = [group objectForKey:@"groupID"];
                    NSString *groupName = [group objectForKey:@"groupname"];
                    NSLog(@"Group %@ with id %@", groupName, groupID);
                    
                    // create group object and add it to the list
                    Group* g = [[Group alloc]initWithName:groupName andID:[groupID integerValue]];
                    [_groupsList insertObject:g atIndex:i];
                    i++;
                }
            
        }
        NSLog(@"%d groups received", i);
    } errorHandler:nil];
    

    
/*
    Member *a = [[Member alloc]initWithName:@"Dil"];
    Member *b = [[Member alloc]initWithName:@"Daimon"];
    [g1 insertMember:a];
    [g1 insertMember:b];
    [_groupsList insertObject:g1 atIndex:0];
     */

}

#pragma mark -
#pragma mark Group Handling methods
- (NSArray *) GetGroupList
{
    return _groupsList; //we do not have an instance of this class thats why we retrive properties this way
}



- (Group *) GetGroupGivenName:(NSString *) groupName
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

- (void) addGroup:(Group *) theGroup WithMembersEmails:(NSArray *) members
{
    for(int i=0;i<[members count];i++)
    {
        [theGroup insertMember: [[Member alloc] initWithEmail:[members objectAtIndex:i]]];
    }
    
    [_groupsList insertObject:theGroup atIndex:[_groupsList count]];
    
    // add observer
    [self addObserver:self forKeyPath:@"createdGroupID" options:NSKeyValueObservingOptionNew +
     NSKeyValueObservingOptionOld context:nil];
    // send to server
    [self SendToServerAddGroup:theGroup WithMembers:members];
    }

// receive KVO notification
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"kvo received: %@", keyPath);
    if([keyPath isEqualToString:@"createdGroupID"])
    {
        NSNumber *groupID = [change objectForKey:@"new"];
        // TODO: do whatever you want to do with this id
    } else {
        NSLog(@"unknown kvo received: %@", keyPath);
        for (id key in change) {
            NSLog(@"key: %@, value: %@ \n", key, [change objectForKey:key]);
        }
    }
}


- (NSArray *) GetGroupContacts: (NSInteger) groupId
{
    _groupMembers = [[NSMutableArray alloc]init];
    NSLog(@"fetching members of group %D", groupId);
    NSDictionary* requestDictionary = @{@"action" : @"GetGroupUsers",
                                        @"username" : [self getUserEmail],
                                        @"groupID" : [NSNumber numberWithInt:groupId]};
    (void)  [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        int i = 0;
        for (NSDictionary *dict in dictionary) {
            NSLog(@"Dict: %@", dict);
            
            NSDictionary * users = [dict objectForKey:@"users"];
            NSLog(@"Users of group: %@", users);
            for (NSDictionary *user in users) {
                // NSNumber *userID = [user objectForKey:@"groupID"];
                NSString *name = [user objectForKey:@"username"];
                
                // create group object and add it to the list
                Member *m = [[Member alloc]initWithName: name];
                [_groupMembers insertObject:m atIndex:i];
                i++;
            }
            
        }
        NSLog(@"%d users for group received", i);
    } errorHandler:nil];
    
    
    // TODO: KIKO change groupIdentifier from array position to group Id
    Group *theIdentifierGroup = [self getGroupGivenGroupId:groupId];
    return [theIdentifierGroup members];
}

#pragma mark -
#pragma mark Recieiving Data From Server methods

- (void) fetchGroupSchedule: (Group*) group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot
{
    NSString *startDate = [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]];
    NSString *endDate = [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]];

    NSDictionary* requestDictionary = @{@"action" : @"CalculateGroupSchedule",
                                        @"username" : [self getUserEmail],
                                        @"groupID" : [NSNumber numberWithInt:[group groupId]],
                                        @"start" : startDate,
                                        @"end" : endDate};
    
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary)
            {
                NSLog(@"Schedule received: %@", dictionary);
                int i = 0;
                for (NSDictionary *dict in dictionary) {
                    NSLog(@"Dict: %@", dict);
                    for (NSDictionary *slot in dict) {

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
                NSLog(@"%d groups received", i);
            } errorHandler:nil];
}



/*
 
 RequestNotification: Group Invitation , Meeting Invitation
 
 AcceptRejectNotification: MemberAcceptGroup, MemberRejectMeeting, MemberRejectGroup
 
 */

-(Group *) getGroupGivenGroupId:(NSInteger) theGroupId
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

/**Receive Notification from server and concatinate it in the notifications list
 Expected from server isGroupInvitation = Yes => GroupInvitation, NO => MeetingInvitation
 if group invitation: group name and group creator name
 else if meeting invitation: group name, meeting beginning time and meeting ending time
 **/

-(void)didReceiveFromServerRequestNotificationWithType: (BOOL)isGroupInvitation group:(NSInteger)groupId sender:(NSString*)senderName beginsAt:(NSDate*) beginTime endsAt:(NSDate*) endTime
{
    Notification *fetechedNotification = [[Notification alloc] init];
    fetechedNotification.isGroupInvitationNotification = isGroupInvitation;
    Group *g=[self getGroupGivenGroupId:groupId];
    fetechedNotification.group = g;
    fetechedNotification.groupName = g.name;
    fetechedNotification.senderName = senderName;
    fetechedNotification.meetingBeginningTime = beginTime;
    fetechedNotification.meetingEndingTime = endTime;
    
    for (Notification *notification in self.notificationsList){
    if (![self compareNotification:notification isEqualNotification:fetechedNotification])
    {
        [self.notificationsList addObject:fetechedNotification];
        self.notificationsNotReadCounter ++;
        
        if ([_delegatenotificationsView respondsToSelector:@selector(notifitcationRecieved:)]){
            [_delegatenotificationsView notificationRecieved];
        }
    }
    }
}
-(BOOL) compareNotification:(Notification *)firstNotification isEqualNotification:(Notification *)secondNotification{
    
    if ((firstNotification.isGroupInvitationNotification == secondNotification.isGroupInvitationNotification) && (firstNotification.group.groupId== secondNotification.group.groupId) && ([firstNotification.senderName isEqualToString:secondNotification.senderName]) && ([firstNotification.meetingBeginningTime isEqual:secondNotification.meetingBeginningTime]) && ([firstNotification.meetingEndingTime isEqual:secondNotification.meetingEndingTime])) {
        return YES;
    }
    else {
        return NO;
    }
 }

- (void)storeAccountInfoInUserDefaultsAndOnServer
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountEmailAddress forKey:@"accountEmailAddress"];
    [defaults setObject:_accountNickName forKey:@"accountNickName"];
    [[NSUserDefaults standardUserDefaults] synchronize]; //just to be sure its saved ..even on simulator
    [self SendToServerLogin];
    
}

- (NSString*) getUserEmail
{
    if ([_accountEmailAddress length] == 0) {
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

/*
 * handles all notfication messages recieved from the server
 */
- (void)didReceiveFromServerAcceptRejectNotification
{
    if(YES) // member accepted Group
    {
        Member *theFetchedMember=[[Member alloc]init];
            [self MemberAcceptedGroupInvitation:theFetchedMember];
    }
    if(YES) // member declined Group
    {
            // TODO: We need to think of this a little about ... (probelm woth multple group names..)
            NSString *emailOfMember = @"theDeclinedMembersEmail";
            NSString *theGroupName =@"theGroupName";
            Group *g = [self GetGroupGivenName:theGroupName];
            [g removeMemberWithEmail:emailOfMember];
    }
        
        
        
        // here the situation is that you get a notification in one of the add group or add contact view.
        // in thoose views you do not have a notification icon as designed
        // The question was if we need to generate a kind of alert to the user that something is recieved
        // Solution 1 vibrate (easy) . Solution 2 do nothing (easy) . Solution 3 build some kind of notification label
        // appearing showing short discription of the notification and if we built such a thing, we could use it in all other
        // views(Views containg the notification icon)
}

-(void)didRecieveShakeMessageFromServer:(NSInteger) groupId
{
    NSLog(@"Pulling data from server");
    NSDictionary* requestDictionary = @{@"action" : @"PullData",
                                        @"username" : [self getUserEmail],
                                        @"getShakeInfo" : @1};
    
    // add observer
    [self addObserver:self forKeyPath:@"createdGroupID" options:NSKeyValueObservingOptionNew +
     NSKeyValueObservingOptionOld context:nil];
    
    (void)  [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Pulles shake result: %@", dictionary);
        
        for (NSDictionary *dict in dictionary)
        {
            // will be something like
            // [{"shakeInfo":{"groupID":"66","groupname":"New Group"}}]
            NSDictionary * info = [dict objectForKey:@"shakeInfo"];
            createdGroupID = [[info objectForKey:@"groupID"] integerValue];
            
            [self navigateToScheduleView:createdGroupID];
        }
    } errorHandler:nil];
}


#pragma mark -
#pragma mark Sending Data From Server methods


-(void)SendToServerShakeLocation:(CLLocation *)location
{
    NSLog(@"sending shake action to server");
    
    CLLocationCoordinate2D coord = [location coordinate];
    
    NSDictionary* requestDictionary = @{@"action" : @"Shake",
                                        @"username" : [self getUserEmail],
                                        @"latitude" : [NSNumber numberWithDouble:coord.latitude],
                                        @"longitude" : [NSNumber numberWithDouble:coord.longitude]};
    
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary)
            {
                NSLog(@"Shake sent: %@", dictionary);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    
                    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(askServerForAnyGroupsCreatedByShake:) userInfo:nil repeats:NO];
                    
                    [[NSRunLoop currentRunLoop] run];
                    
                    
                });
            } errorHandler:nil];
}


-(void)askServerForAnyGroupsCreatedByShake
{
    
}

-(void)navigateToScheduleView:(NSInteger) thegroupId
{
    [_delegatenotificationsView shakeGroupCreationActionRecieved:thegroupId];
}

-(void)SendToServerAddMember:(Member *)member inGroup:(NSNumber*) group
{
    NSLog(@"Adding user %@ to group %@", member, group);

    NSDictionary* requestDictionary = @{@"action" : @"AddGroupUser",
                                        @"username" : member,
                                        @"groupID" : group,
                                        @"adder" : [self getUserEmail]};
    NSLog(@"Request: %@", requestDictionary);
    (void)  [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"User added: %@", dictionary);
        
        for (NSDictionary *dict in dictionary)
        {
            // TODO: do anything with the response...
        }
    } errorHandler:nil];

}


/**
 this method creates a new group in server.
 */
-(void)SendToServerAddGroup:(Group *)group WithMembers:(NSArray *) members
{
    NSLog(@"creating group %@ with %lu members", [group name], (unsigned long)[members count]);
    
    NSDictionary* requestDictionary = @{@"action" : @"AddGroup",
                                        @"username" : [self getUserEmail],
                                        @"groupname" : [group name]};
    
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary)
    {
        for (NSDictionary *dict in dictionary)
        {
            NSNumber *groupID = [dict objectForKey:@"groupID"];
            group.groupId=[groupID intValue];
            
            // add Members:
            for (Member *m in members) {
                //
                [self SendToServerAddMember:m inGroup:(groupID)];
            }
        }
        [self SendtoServerInviteGroupMembers:group];
    } errorHandler:nil];
    
}
/**
 this method invites all group members to the group
 */
-(void)SendtoServerInviteGroupMembers :(Group *) theGroup
{
    for(int i=0;i<[theGroup.members count];i++)
    {
        Member *memberToInvite= [theGroup.members objectAtIndex:i];
        NSString *groupIdString = [NSString stringWithFormat: @"%d", theGroup.groupId];
        NSDictionary* requestDictionary = @{@"action" : @"AddGroupUser",
                                            @"username" : memberToInvite.emailAddress,
                                            @"groupID" : groupIdString ,
                                            @"adder" : _accountEmailAddress};
        
        (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary)
                            {
                                NSLog(@"Member invited: %@", dictionary);
                            } errorHandler:nil];
    }
}

-(void)SendToServerRemoveGroup:(Group *)group
{
    NSLog(@"Removing group %@", [group name]);    
    NSDictionary* requestDictionary = @{@"action" : @"RemoveGroup",
                                        @"username" : [self getUserEmail]};
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Group removed: %@", dictionary);
    } errorHandler:nil];
}

-(void) SendToServerAcceptGroupRequest:(Group *) group
{
    NSString *groupIdString = [NSString stringWithFormat: @"%d", group.groupId];
    NSLog(@"Accepting group request %@", [group name]);
    NSDictionary* requestDictionary = @{@"action" : @"AcceptInvitation",
                                        @"username" : [self getUserEmail],
                                        @"groupID" : groupIdString};
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Invitation accepted: %@", dictionary);
    } errorHandler:nil];
    //- **action=AcceptInvitation&username=<username>&groupID=<groupID>**
}

-(void) SendToServerRejectGroupRequest:(Group *) group
{
    NSString *groupIdString = [NSString stringWithFormat: @"%d", group.groupId];
    NSLog(@"Rejecting group request %@", [group name]);
    NSDictionary* requestDictionary = @{@"action" : @"RejectInvitation",
                                        @"username" : [self getUserEmail],
                                        @"groupID" : groupIdString};
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Invitation accepted: %@", dictionary);
    } errorHandler:nil];
    //- **action=RejectInvitation&username=<username>&groupID=<groupID>**
}


//- **action=SetAppointment&groupID=<groupID>&start=<unix_timestamp>&end=<unix_timestamp>**

-(void)SendToServerCreateMeeting:(Group *)group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot
{
    NSString *startDate = [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]];
    NSString *endDate = [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]];
    NSString *groupIdString = [NSString stringWithFormat: @"%d", group.groupId];
    NSLog(@"Rejecting group request %@", [group name]);
    NSDictionary* requestDictionary = @{@"action" : @"SetAppointment",
                                        @"groupID" : groupIdString,
                                        @"start" : startDate,
                                        @"end" : endDate};
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Invitation accepted: %@", dictionary);
    } errorHandler:nil];
}


-(void)SendToServerRejectMeeting:(Group *) group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot
{
    NSString *startDate = [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]];
    NSString *endDate = [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]];
    NSString *groupIdString = [NSString stringWithFormat: @"%d", group.groupId];
    NSLog(@"Rejecting group request %@", [group name]);
    NSDictionary* requestDictionary = @{@"action" : @"DeleteAppointment",
                                        @"username" : _accountEmailAddress,
                                        @"groupID" : groupIdString,
                                        @"start" : startDate,
                                        @"end" : endDate};
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Invitation accepted: %@", dictionary);
    } errorHandler:nil];
    //- **action=DeleteAppointment&groupID=<groupID>&start=<unix_timestamp>&end=<unix_timestamp>**
}


-(void)SendToServerSendSlot: (NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot isAvailable: (SlotStatus) slotStatus
{
    NSString *startDate = [NSString stringWithFormat: @"%f", [startingTimeSlot timeIntervalSince1970]];
    NSString *endDate = [NSString stringWithFormat: @"%f", [endingTimeSlot timeIntervalSince1970]];
    
    NSDictionary* requestDictionary;
    if (slotStatus == SlotStateFree) {
        requestDictionary = @{@"action" : @"SetAvailable",
                                        @"username" : [self getUserEmail],
                                        @"start" : startDate,
                                        @"end" : endDate};
    } else if(slotStatus == SlotStateBusy) {
        requestDictionary = @{@"action" : @"SetBusy",
                              @"username" : [self getUserEmail],
                              @"start" : startDate,
                              @"end" : endDate};
    }
    (void) [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Appointment set: %@", dictionary);
    } errorHandler:nil];
}

/**
 logs in with email.
 Make shure that account information was stored before!
 */
-(void)SendToServerLogin
{
    NSLog(@"logging in %@", [self getUserEmail]);
    NSDictionary* requestDictionary = @{@"action" : @"Login",
                                        @"username" : [self getUserEmail]};
    (void)  [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Login completed with dictionary: %@", dictionary);
        [self SendToServerSetNickName];
    
    } errorHandler:nil];
}

-(void) SendToServerSetNickName
{
    NSLog(@"Sending nickname %@", [self getNickname]);
    NSDictionary* requestDictionary = @{@"action" : @"SetNickname",
                                        @"username" : [self getUserEmail],
                                        @"nickname" : [self getNickname]};
    (void)  [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Nickname sent: %@", dictionary);
        [self SendScheduleToOurServerOnlyCalledOnce];
        [self fetchNeededInformation];
        _alreadySignedIn=YES;
        [self timerFireMethod:Nil];
    } errorHandler:nil];
}

- (void) GetFromServerPullData {
    NSLog(@"Pulling data from server");
    NSDictionary* requestDictionary = @{@"action" : @"PullData",
                                        @"username" : [self getUserEmail]};
    
    (void)  [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Pull Result: %@", dictionary);
        
        for (NSDictionary *dict in dictionary)
        {
            NSDictionary * invites = [dict objectForKey:@"invites"];
            for (NSDictionary *invite in invites) {
                NSLog(@"Got invite");
                NSNumber *groupID = [dict objectForKey:@"groupID"];
                NSString *senderName = [dict objectForKey:@"senderUsername"];
                
                NSDate *date;
                [self didReceiveFromServerRequestNotificationWithType:YES group:[groupID integerValue] sender:senderName beginsAt:date endsAt:date];
            }
            
            NSDictionary * appointments = [dict objectForKey:@"invites"];
            for (NSDictionary *app in appointments) {
                NSLog(@"Got appointment");
                NSNumber *groupID = [dict objectForKey:@"groupID"];
                NSString *senderName = [dict objectForKey:@"senderUsername"];
                
                NSTimeInterval intStart=[[app objectForKey:@"start"] doubleValue];
                NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:intStart];

                NSTimeInterval intEnd =[[app objectForKey:@"end"] doubleValue];
                NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:intEnd];
                
                [self didReceiveFromServerRequestNotificationWithType:NO group:[groupID integerValue] sender:senderName beginsAt:startDate endsAt:endDate];
            }
        }

        
    } errorHandler:nil];
}

-(void) MemberAcceptedGroupInvitation:(Member *) memberThatAcceptedGroupInvitation
{
    memberThatAcceptedGroupInvitation.hasAcceptedGroupInvitation=YES;
    if ([_delegatenotificationsView respondsToSelector:@selector(memberAcceptRejectinGroupNotification)])
    {
        [_delegatenotificationsView memberAcceptRejectinGroupNotification];
    }
}

@end
