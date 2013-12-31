//
//  OverlapChecker.m
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import "OverlapChecker.h"

@implementation OverlapChecker

-(NSMutableArray*)getBestSchedule:(NSMutableArray*)coursesPool
{
    NSMutableArray* bestSched = [[NSMutableArray alloc] initWithObjects:nil];
    NSMutableArray* rootNodes = [[NSMutableArray alloc] initWithObjects:nil];
    StateNode* currNode;
    
    
    while([coursesPool count] != 0)
    {
        BOOL addedNode = false;
        
        if([bestSched count] == 0)
        {
            BOOL exists = false;
            for(Course* course in coursesPool)
            {
                exists = false;
                
                for(StateNode* state in rootNodes)
                {
                    if(state.stateCourse->courseID == course->courseID)
                        exists = true;
                }
                
                if(!exists)
                {
                    
                    StateNode* newNode = [[StateNode alloc] initNodeWithCourse:course parent:nil];
                    [rootNodes addObject:newNode];
                    [bestSched addObject:course];
                    [coursesPool removeObject:course];
                    currNode = newNode;
                    break;
                }
                
            }
            
            if(exists)
            {
                NSLog(@"EXHAUSTED SEARCH!");
                break;
            }
            
        }
        
        
        for(Course* course in coursesPool)
        {
            BOOL remembered=false,overlaps=false;
            
            /**********************/
            for(StateNode* futureState in currNode.stateChildNodes)
            {
                if(futureState.stateCourse->courseID == course->courseID)
                {
                    remembered = true;
                    break;
                }
            }
            
            if(remembered)
                continue;
            /**********************/
            
            
            
            /**********************/
            for(Course* bestSchedCourse in bestSched)
            {
                if(bestSchedCourse->courseID == course->courseID)
                {
                    overlaps = true;
                    break;
                }
                
                if([self checkOverlapWithFirstCourse:bestSchedCourse secondCourse:course])
                {
                    overlaps = true;
                    break;
                }
            }
            
            if(overlaps)
                continue;
            /**********************/
            
            StateNode* newNode = [[StateNode alloc] initNodeWithCourse:course parent:currNode];
            [currNode.stateChildNodes addObject:newNode];
            [bestSched addObject:course];
            [coursesPool removeObject:course];
            currNode = newNode;
            addedNode = true;
            break;
        }
        
        if(!addedNode)
        {
            [coursesPool addObject:currNode.stateCourse];
            [bestSched removeObject:currNode.stateCourse];
            currNode = currNode.stateParent;
        }
        
        
        
    }
    
    return bestSched;
}

-(BOOL)checkOverlapWithFirstCourse:(Course*)firstCourse secondCourse:(Course*)secondCourse
{
    BOOL overlap = true;
    
    if(firstCourse->courseDay != secondCourse->courseDay)
        return false;
    
    int fCourseStartStamp = (firstCourse->startTime.timeHour*60) + firstCourse->startTime.timeMin;
    int fCourseEndStamp = (firstCourse->endTime.timeHour*60) + firstCourse->endTime.timeMin;
    
    int sCourseStartStamp = (secondCourse->startTime.timeHour*60) + secondCourse->startTime.timeMin;
    int sCourseEndStamp = (secondCourse->endTime.timeHour*60) + secondCourse->endTime.timeMin;
    
    if(fCourseEndStamp <= sCourseStartStamp)
        overlap = false;
    else if(fCourseStartStamp >= sCourseEndStamp)
        overlap = false;
    
    
    return overlap;
}

@end
