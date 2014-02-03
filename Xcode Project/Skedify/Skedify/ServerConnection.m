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

@implementation ServerConnection

@synthesize createdGroupID;

#pragma mark -
#pragma mark Singleton stuff

static ServerConnection *sharedServerConnection = nil;
static NSString *serverAdress = @"https://www.gcmskit.com/skedify/ajax.php";
static NSString *user = @"yigit"; // TODO: remove later - this is temporary

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

    [self addScheduleSlotStartingAtDate:startingDate andEndingAtDate:endingDate withSlotStatusIsBusy:YES];


    //[[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];//deletes stored values
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


- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate andEndingAtDate:(NSDate *) endDate withSlotStatusIsBusy:(BOOL) busy
{
    while([endDate compare: startDate] == NSOrderedDescending)
    {
        [self addScheduleSlotStartingAtDate:startDate withSlotStatusIsBusy:busy];
        startDate = [startDate dateByAddingTimeInterval:+900]; //add 15minutes to the start date
    }
}

- (void) addScheduleSlotStartingAtDate:(NSDate *) startDate withSlotStatusIsBusy:(BOOL) busy
{
        NSDateComponents *startDateComponents = [self getNSDateComponents:startDate];
        
        int weekday=[startDateComponents weekday]-2;
        if(weekday==-1)
        {
            weekday = 6;
        }
        
        [self AddDateToMutableArrayWithWeekNumber: [startDateComponents weekOfYear] AndDay:weekday andStartingSlot:startDate  andSlotStatusIsBusy:busy];
}


-(void)AddDateToMutableArrayWithWeekNumber:(NSInteger)weekNumber AndDay :(Day) weekDay andStartingSlot: (NSDate *) startingSlot andSlotStatusIsBusy :(BOOL) busy
{
    [self logDate:startingSlot andSlotStatusIsBusy:busy andweekDay:weekDay];
    //TODO EMAD
}

-(void)logDate:(NSDate *) startingSlot andSlotStatusIsBusy :(BOOL) busy andweekDay:(Day) weekDay
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSString *theDate = [dateFormat stringFromDate:startingSlot];
    NSString *theTime = [timeFormat stringFromDate:startingSlot];
    NSLog(@" Adding this slot \n"
          "theDate: |%@| \n"
          "theStartTime: |%@| \n" "marked as %hhd and the weekday is %d"
          , theDate, theTime,busy,weekDay);
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self fetchNeededInformation];
        _dateOfLastShakeGesture= [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return self;
}

- (void) fetchNeededInformation
{
    //ServerCode Get Created Groups(If any ) From Server
    //for ex User added that was not there in the system or User just opened the app and
    // recieves his info
    
    //GetGroupsFromPreviouStorage
    
    _groupsList = [[NSMutableArray alloc]init];
    Group* g1 = [[Group alloc]initWithName:@"DIS" andID:0];
    Member *a = [[Member alloc]initWithName:@"Dil"];
    Member *b = [[Member alloc]initWithName:@"Daimon"];
    [g1 insertMember:a];
    [g1 insertMember:b];
    [_groupsList insertObject:g1 atIndex:0];
    
    
    Group* g2 = [[Group alloc]initWithName:@"Artificial Intellegience" andID:1];
    Member *c = [[Member alloc]initWithName:@"Alex"];
    Member *d = [[Member alloc]initWithName:@"Andrea"];
    [g2 insertMember:c];
    [g2 insertMember:d];
    [_groupsList insertObject:g2 atIndex:1];
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
    //TODO: KIKO change groupIdentifier from array position to group Id
    Group *theIdentifierGroup = [self getGroupGivenGroupId:groupId];
    return [theIdentifierGroup members];
}

#pragma mark -
#pragma mark Recieiving Data From Server methods


/* Recieve From Server Methods
 TODO: recieve Combin Schedule
 TODO: recieve created Meeting
 TODO: recieve meeting/group request
 TODO: recieve member acceptance in group(wheather he accepted/rejected the group reques)
 TODO: receive member acceptance in meeting(or rejection)
 


*/


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
    NSLog(@"should never happen getGroupGivnGroupId");
    return nil;
}


-(void)didReceiveFromServerRequestNotificationWithType: (BOOL)isGroupInvitation name:(NSInteger)groupId sender:(NSString*)senderName beginsAt:(NSDate*) beginTime endsAt:(NSDate*) endTime
{
    Notification *fetechedNotification = [[Notification alloc] init];
    fetechedNotification.isGroupInvitationNotification = isGroupInvitation;
    Group *g=[self getGroupGivenGroupId:groupId];
    fetechedNotification.groupName = g.name;
    fetechedNotification.senderName = senderName;
    fetechedNotification.meetingBeginningTime = beginTime;
    fetechedNotification.meetingEndingTime = endTime;
    
    [self.notificationsList addObject:fetechedNotification];
    self.notificationsNotReadCounter ++;
}

- (void)storeAccountInfoInUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_accountEmailAddress forKey:@"accountEmailAddress"];
    [defaults setObject:_accountNickName forKey:@"accountNickName"];
    [[NSUserDefaults standardUserDefaults] synchronize]; //just to be sure its saved ..even on simulator 
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
            //TODO We need to think of this a little about ... (probelm woth multple group names..)
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

-(void)didRecieveShakeMessageFromServer
{
   // [_notificationsViewDelegate shakeRecieved:NO];
}

/**Receive Notification from server and concatinate it in the notifications list
 Expected from server isGroupInvitation = Yes => GroupInvitation, NO => MeetingInvitation
 if group invitation: group name and group creator name
 else if meeting invitation: group name, meeting beginning time and meeting ending time
 **/
-(void)receiveFromServerNotificationWithType: (BOOL)isGroupInvitation name:(NSString*)groupName sender:(NSString*)senderName beginsAt:(NSDate*) beginTime endsAt:(NSDate*) endTime
{
    Notification *fetechedNotification = [[Notification alloc] init];
    fetechedNotification.isGroupInvitationNotification = isGroupInvitation;
    fetechedNotification.groupName = groupName;
    fetechedNotification.senderName = senderName;
    fetechedNotification.meetingBeginningTime = beginTime;
    fetechedNotification.meetingEndingTime = endTime;
    
    [self.notificationsList addObject:fetechedNotification];
    self.notificationsNotReadCounter ++;
}

#pragma mark -
#pragma mark Sending Data From Server methods


-(void)SendToServerShakeLocation:(CLLocation *)location
{
    // TODO: send location to Server
}

-(void)SendToServerAddMember:(Member *)member inGroup:(Group *) group
{
    // TODO: add member to group on server
}


/**
 this method creates a new group in server.
 observe @"createdGroupID" for receiving the new group id.
 */
-(void)SendToServerAddGroup:(Group *)group WithMembers:(NSArray *) members
{
    NSLog(@"creating group %@ with %lu members", [group name], (unsigned long)[members count]);
    
    NSDictionary* requestDictionary = @{@"action" : @"AddGroup",
                                        @"username" : user,
                                        @"groupname" : [group name]};
    HttpRequest* req = [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        // NSLog(@"Group created: %@", dictionary);
      
        for (NSDictionary *dict in dictionary) {
            NSNumber *groupID = [dict objectForKey:@"groupID"];
            // NSLog(@"Group id: %@", groupID);
            [sharedServerConnection setValue:groupID forKey:@"createdGroupID"];
        }
        
    } errorHandler:nil];
}

-(void)SendToServerRemoveGroup:(Group *)group
{
    // TODO: remove group from server from my list of groups
}

-(void) SendToServerAcceptGroupRequest:(Group *) group
{
    // TODO:
}

-(void) SendToServerRejectGroupRequest:(Group *) group
{
    // TODO:
}

-(void)SendToServerCreateMeeting:(Group *)group fromTimeSlot:(NSDate *) startingTimeSlot toTimeSlot:(NSDate *) endingTimeSlot
{
    // TODO: create meeting with group on server
}


-(void)SendToServerRejectMeeting:(Group *) group fromTimeSlot:(NSDate *) startingTimeSlot
{
    // TODO: reject the meeting that was created starting in this timeslot
}

-(void)SendToServerAcceptMeeting:(Group *) group fromTimeSlot:(NSDate *) startingTimeSlot
{
    // TODO: accept the meeting that was created starting in this timeslot
}

-(void)SendToServerSendSchedule
{
    // TODO: Data structure not yet implemented
}

-(void)SendToServerLogin
{
    // Example for HttpRequest:
    NSDictionary* requestDictionary = @{@"action" : @"Login",
                                        @"username" : @"yigit.guenay@rwth-aachen.de"};
    HttpRequest* req = [[HttpRequest alloc] initRequestWithURL:@"https://www.gcmskit.com/skedify/ajax.php" dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Login completed with dictionary: %@", dictionary);
    
    } errorHandler:nil];
}

-(void) SendToServerSetNickName :(Member *) member
{
    // TODO: setting/changing the nickname of this member(the signed in member)
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
