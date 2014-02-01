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
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self fetchNeededInformation];
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
    Group* g1 = [[Group alloc]initWithName:@"DIS"];
    Member *a = [[Member alloc]initWithName:@"Dil"];
    Member *b = [[Member alloc]initWithName:@"Daimon"];
    [g1 insertMember:a];
    [g1 insertMember:b];
    [_groupsList insertObject:g1 atIndex:0];
    
    
    Group* g2 = [[Group alloc]initWithName:@"Artificial Intellegience" ];
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

- (Group *) GetGroup:(NSInteger) index
{
    return (Group *)[_groupsList objectAtIndex:index];
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
    
    [self SendToServerAddGroup:theGroup WithMembers:members];
}


- (NSArray *) GetGroupContacts: (NSInteger) groupIdentifier
{
    Group *theIdentifierGroup = (Group *)[_groupsList objectAtIndex:groupIdentifier];
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



-(void) MemberAcceptedGroupInvitation:(Member *) memberThatAcceptedGroupInvitation
{
    memberThatAcceptedGroupInvitation.hasAcceptedGroupInvitation=YES;
    [_delegatenotificationsView notifitcationRecieved];
}

/*
 * handles all notfication messages recieved from the server
 */
- (void)didReceiveNotificationFromServer
{
    if ([_delegatenotificationsView respondsToSelector:@selector(notifitcationRecieved)])
    {
        [_delegatenotificationsView notifitcationRecieved];
    }
    else
    {
        if(YES) // member accepted Group
        {
            Member *theFetchedMember=[[Member alloc]init];
            [self MemberAcceptedGroupInvitation:theFetchedMember];
        }
        else if(YES) // member declined Group
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


-(void)SendToServerAddGroup:(Group *)group WithMembers:(NSArray *) members
{
    NSLog(@"creating group %@ with %lu members", [group name], (unsigned long)[members count]);
    // TODO: create group with members on server
    
    NSDictionary* requestDictionary = @{@"action" : @"AddGroup",
                                        @"username" : user};
    HttpRequest* req = [[HttpRequest alloc] initRequestWithURL:serverAdress dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
        NSLog(@"Group created: %@", dictionary);
        
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

-(void)SendToServerCreateMeeting:(Group *)group fromTimeSlot:(NSNumber *) startingTimeSlot toTimeSlot:(NSNumber *) endingTimeSlot
{
    // TODO: create meeting with group on server
}


-(void)SendToServerRejectMeeting:(Group *) group fromTimeSlot:(NSNumber *) startingTimeSlot
{
    // TODO: reject the meeting that was created starting in this timeslot
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



@end
