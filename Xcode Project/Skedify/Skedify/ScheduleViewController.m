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
    SlotStatus fullSchedule[NUMBER_DAYS][NUMBER_HOURS*4]; //TODO: increase schedule to accommodate for more weeks not a single one
    SlotStatus dummySchedule[NUMBER_DAYS][NUMBER_HOURS*4]; //TODO: to be removed after implementing the fullschedule with week support

    ScheduleScrollView* bufferedSchedules[NUM_BUFFERED_SCHEDULES];
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
    
    for(int i = 0;i<NUM_BUFFERED_SCHEDULES;i++)
    {
        if(i == ((int)(NUM_BUFFERED_SCHEDULES/2)))
            bufferedSchedules[i] = [[ScheduleScrollView alloc] initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480)
                                                 withSchedule:fullSchedule];
        else
            bufferedSchedules[i] = [[ScheduleScrollView alloc] initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480)
                                                                withSchedule:dummySchedule];
        
        bufferedSchedules[i].contentSize = CGSizeMake(320, ViewContentHeight);
        bufferedSchedules[i].delegate = (id)self;
        bufferedSchedules[i].backgroundColor=[UIColor clearColor];
        
        
        if(i == ((int)(NUM_BUFFERED_SCHEDULES/2)))
        {
            _scrollView = bufferedSchedules[i];
            [self.view addSubview:_scrollView];
            [_scrollView addWeekLabels];
        }
    }
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:swipeRight];
    [[self view] addGestureRecognizer:swipeLeft];
    
}

-(void)switchViewsToLeft
{
    ScheduleScrollView* temp = bufferedSchedules[0];
    ScheduleScrollView* oldScrollView = _scrollView;
    
 
   
    
    for(int i = 0;i<NUM_BUFFERED_SCHEDULES;i++)
    {
        if(i == NUM_BUFFERED_SCHEDULES-1)
            bufferedSchedules[i] = temp;
        else
            bufferedSchedules[i] = bufferedSchedules[i+1];
    }
    _scrollView = bufferedSchedules[((int)(NUM_BUFFERED_SCHEDULES/2))];
    

    
    [UIView transitionFromView:oldScrollView toView:_scrollView duration:0.5 options:UIViewAnimationOptionTransitionCurlDown completion:nil];
    
    //TODO: update the fullschedule accordingly and fetch more weeks
    
    
}

-(void)switchViewsToRight
{
    ScheduleScrollView* temp = bufferedSchedules[NUM_BUFFERED_SCHEDULES - 1];
    ScheduleScrollView* oldScrollView = _scrollView;
    

    
    
    
    for(int i = NUM_BUFFERED_SCHEDULES-1;i>=0;i--)
    {
        if(i == 0)
            bufferedSchedules[i] = temp;
        else
            bufferedSchedules[i] = bufferedSchedules[i-1];
    }
    _scrollView = bufferedSchedules[((int)(NUM_BUFFERED_SCHEDULES/2))];
    
    [UIView transitionFromView:oldScrollView toView:_scrollView duration:0.5 options:UIViewAnimationOptionTransitionCurlUp completion:nil];
    
    
    
    
    //TODO: update the fullschedule accordingly and fetch more weeks
}

-(void)leftSwipe:(UISwipeGestureRecognizer*)sender
{
    [self switchViewsToLeft];
}

-(void)rightSwipe:(UISwipeGestureRecognizer*)sender
{
    [self switchViewsToRight];
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
        
        //NSLog(@"Min:%d Hour:%d index:%d",minute,hour,hourIndex);
        
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
