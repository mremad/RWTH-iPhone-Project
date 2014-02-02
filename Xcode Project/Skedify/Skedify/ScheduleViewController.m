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
    BOOL fullSchedule[7][17*4];
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
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
