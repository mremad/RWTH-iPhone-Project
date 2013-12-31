//
//  ViewController.m
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Course* course1 = [[Course alloc] initWithCourseName:@"Course 1"];
    course1->startTime.timeHour = 13;
    course1->startTime.timeMin = 15;
    
    course1->endTime.timeHour = 14;
    course1->endTime.timeMin = 30;
    
    course1->courseDay = MON;
    
    Course* course2 = [[Course alloc] initWithCourseName:@"Course 2"];
    
    course2->startTime.timeHour = 14;
    course2->startTime.timeMin = 0;
    
    course2->endTime.timeHour = 15;
    course2->endTime.timeMin = 0;
    
    course2->courseDay = MON;
    
    NSMutableArray* coursesPool = [[NSMutableArray alloc] initWithObjects:course1,course2, nil];
    
    OverlapChecker* overlapChecker = [[OverlapChecker alloc] init];
    
    [overlapChecker getBestSchedule:coursesPool];
    
    
    
    NSLog(@"CourseID1: %i    CourseID2: %i",course1->courseID,course2->courseID);
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
