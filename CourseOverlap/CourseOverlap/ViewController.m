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
    
    NSMutableArray* coursesPool = [[NSMutableArray alloc] initWithObjects:nil];
    Course* course1 = [[Course alloc] initWithCourseName:@"Course 1"];
    course1->startTime.timeHour = 13;
    course1->startTime.timeMin = 15;
    
    course1->endTime.timeHour = 14;
    course1->endTime.timeMin = 30;
    
    course1->courseDay = MON;
    
    
    for(int i = 0;i<20;i++)
    {
        Course* course = [[Course alloc] initWithCourseName:[NSString stringWithFormat:@"Course %i",i+1]];
        
        course->startTime.timeHour = arc4random()%24;
        course->startTime.timeMin = 15*(arc4random()%4);
        
        course->endTime.timeHour = course->startTime.timeHour + 1;
        course->endTime.timeMin = course->startTime.timeMin + 30;
        if(course->endTime.timeMin>=60)
        {
            course->endTime.timeMin = course->endTime.timeMin - 60;
            course->endTime.timeHour++;
        }
        course->courseDay = (Day)(arc4random()%7);
        
        [coursesPool addObject:course];
        
        NSLog(@"%@     Start: %i:%i       End %i:%i       Day:%i",course.courseName,course->startTime.timeHour,course->startTime.timeMin,course->endTime.timeHour,course->endTime.timeMin,course->courseDay);
    }
    
    
    NSLog(@"Starting Algorithm!");
    
    
    OverlapChecker* overlapChecker = [[OverlapChecker alloc] init];
    
    NSMutableArray* arr = [overlapChecker getBestSchedule:coursesPool withMaxCourses:17];
    
    for(Course* course in arr)
    {
         NSLog(@"%@     Start: %i:%i       End %i:%i       Day:%i",course.courseName,course->startTime.timeHour,course->startTime.timeMin,course->endTime.timeHour,course->endTime.timeMin,course->courseDay);
    }
    
    
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
