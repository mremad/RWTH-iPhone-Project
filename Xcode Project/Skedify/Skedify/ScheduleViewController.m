//
//  ScheduleViewController.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ScheduleViewController.h"

#define ViewContentHeight (TIME_HEIGHT*(24-4))
#define SLIDER_VIEW_START_POSITION DAY_HEIGHT
#define ViewContentXStart 64 + SLIDER_VIEW_START_POSITION



@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
{
    SlotStatus fullSchedule[NUMBER_DAYS][NUMBER_HOURS*4];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set scrollView
    
    [self createSchedule];
    
    _scrollView=[[ScheduleScrollView alloc] initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480) withSchedule:fullSchedule];
    _scrollView.contentSize = CGSizeMake(320, ViewContentHeight);
    _scrollView.delegate = (id)self;
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [_scrollView addWeekLabels];

}

- (void)reserveMeetingAtStartingHour:(int)startingHour
                         startingMin:(int)startingMin
                          endingHour:(int)endingHour
                           endingMin:(int)endingMin
                                 day:(Day)meetingDay
{
    
    BOOL selectedFreeArea = TRUE;
    
    int startIndex = ((startingHour - STARTING_HOUR)*4) + (startingMin/15);
    int endIndex = ((endingHour - STARTING_HOUR)*4) + (endingMin/15);
    
    for(int i = startIndex;i<=endIndex;i++)
    {
        if(fullSchedule[(int)meetingDay][i] == SlotStateBusy || fullSchedule[(int)meetingDay][i] == SlotStateMeeting)
        {
            selectedFreeArea = FALSE;
            break;
        }
    }
    
    if(!selectedFreeArea)
        return;
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *cal1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp =[[NSDateComponents alloc] init];
    [comp setYear:2015];
    [comp setMonth:1];
    [comp setDay:meetingDay];
    [comp setHour:startingHour];
    [comp setMinute:startingMin];
    // [comp setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *startingDate =[cal dateFromComponents:comp];
    
    NSDateComponents *compEnd =[[NSDateComponents alloc] init];
    [compEnd setYear:2015];
    [compEnd setMonth:1];
    [compEnd setDay:meetingDay];
    [compEnd setHour:endingHour];
    [compEnd setMinute:endingMin];
    //[compEnd setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *endingDate =[cal1 dateFromComponents:compEnd];
    
    ServerConnection* sharedConnection = [ServerConnection sharedServerConnection];
    [sharedConnection createMeeting:[sharedConnection getGroupGivenGroupId:_groupID] fromTimeSlot:startingDate toTimeSlot:endingDate];
    
    for(int i = startIndex;i<=endIndex;i++)
    {
        fullSchedule[(int)meetingDay][i] = SlotStateMeeting;
    }
    
    [_scrollView updateViewForNewMeeting];
    
}

- (void)createSchedule
{
    
    for(int i = 0;i<NUMBER_DAYS;i++)
    {
        for(int j = 0;j<NUMBER_HOURS*4;j++)
        {
            
            fullSchedule[i][j] = SlotStateFree;
        }
    }
    
    ServerConnection* sharedConnection = [ServerConnection sharedServerConnection];
    NSMutableArray* schedToDisplay = [sharedConnection getGroupGivenGroupId:_groupID].groupSchedule;
    
    for(Slot* slot in schedToDisplay)
    {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:slot.startTime];
        
        int hour = [components hour];
        int minute = [components minute];
        
        
        
        int hourIndex = ((hour - STARTING_HOUR)*4) + (minute/15);
        int dayIndex = (int)slot.day;
        
        NSLog(@"Min:%d Hour:%d index:%d",minute,hour,hourIndex);
        
        int weekDay = slot.weekNum;
        
        SlotStatus slotStatus = slot.slotStatus;
        
        fullSchedule[dayIndex][hourIndex] = slotStatus;
        
        
    }
    
     

}

- (void) cancelMeetingAtDay:(NSDate*)meetingDate
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
