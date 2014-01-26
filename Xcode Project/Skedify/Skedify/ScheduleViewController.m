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
#define UIVIEWS_STARTING_YPOSITION 64


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
    [self addWeekDays];
    _scrollView=[[ScheduleScrollView alloc] initWithFrame:CGRectMake(0, ViewContentXStart, 320, 480)];
    _scrollView.contentSize = CGSizeMake(320, ViewContentHeight);
    _scrollView.delegate =self;
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
   
    
	// Do any additional setup after loading the view.
}
-(void) addWeekDays
{
    self.view.opaque = NO;
    self.view.clipsToBounds = YES;
    
    /*UILabel *label =[[UILabel alloc] init];
    label.bounds = CGRectMake(0,0 ,TIME_WIDTH, TIME_HEIGHT);
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 0.5;
    label.center=CGPointMake(TIME_WIDTH/2,UIVIEWS_STARTING_YPOSITION+ (DAY_HEIGHT/2));
    NSLog(@"%d",DAY_WIDTH);
    //label.backgroundColor=[UIColor blackColor];
    [self.view addSubview:label];*/

    
    NSArray *weekDays = @[@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa",@"Su"];
    for(int i=0;i<7;i++)
    {
        UILabel *label =[[UILabel alloc] init];
        label.text=[NSString stringWithFormat:@" %@", [weekDays objectAtIndex:i]];
        label.bounds = CGRectMake(0,0 ,DAY_WIDTH, DAY_HEIGHT);
        label.layer.borderColor = [UIColor blackColor].CGColor;
        //label.layer.borderWidth = 0.5;
        label.center=CGPointMake(DAY_STARTING_CENTER_POINT+i*((int)DAY_WIDTH) + DAY_WIDTH/4,UIVIEWS_STARTING_YPOSITION+ (DAY_HEIGHT/2));
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        label.textColor = [UIColor colorWithHue:29 saturation:100 brightness:100 alpha:1];
        NSLog(@"%d",DAY_WIDTH);
        //label.backgroundColor=[UIColor blackColor];
        [self.view addSubview:label];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
