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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set scrollView
    
    
    
    _scrollView=[[ScheduleScrollView alloc] initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480)];
    _scrollView.contentSize = CGSizeMake(320, ViewContentHeight);
    _scrollView.delegate = (id)self;
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
    [_scrollView addWeekDays];
    
   
    
	// Do any additional setup after loading the view.
}


-(void)singleTap:(UITapGestureRecognizer*)sender
{
    Day day =[(ScheduleSlotView*)sender.view getDay];
    int time = [(ScheduleSlotView*)sender.view getTime];
    NSLog(@"Tapped at time:%d and Day:%d!",time,day);
    
    int leftDay  = (int)day - 1;
    int rightDay = (int)day + 1;
    
    int topHour = time-1;
    int bottomHour = time+1;
    
    //_scrollView.scrollEnabled = NO;
    
    [_scrollView toggleExpansionWithLeftDay:leftDay rightDay:rightDay topHour:topHour bottomHour:bottomHour];
    
    
    
}

-(void)doubleTap:(UITapGestureRecognizer*)sender
{
    NSLog(@"Double Tapped!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
