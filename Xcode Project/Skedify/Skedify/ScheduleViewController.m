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
    SlotStates fullSchedule[NUMBER_DAYS][NUMBER_HOURS*4];
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
            SlotStates rand = (SlotStates)arc4random()%3;
            fullSchedule[i][j] = rand;
        }
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
