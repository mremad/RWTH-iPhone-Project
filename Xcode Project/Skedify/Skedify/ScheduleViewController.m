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

- (void)reserveMeetingAtStartingDay:(NSDate*)startingDate endingDate:(NSDate*)endingDate
{
    
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
