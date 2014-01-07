//
//  OverlapChecker.m
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import "OverlapChecker.h"

@implementation OverlapChecker
{
    bool overlapMap[MAX_COURSES][MAX_COURSES];
}

-(NSMutableArray*)getBestSchedule:(NSMutableArray*)coursesPool withMaxCourses:(int)maxCourses
{
    NSMutableArray* bestSched = [[NSMutableArray alloc] initWithObjects:nil];
    NSMutableArray* rootNodes = [[NSMutableArray alloc] initWithObjects:nil];
    StateNode* currNode;
    StateNode* prevNode;
    BOOL backtracking = false;
    int maxSchedFound = 0;
    
    [self constructOverlaps:coursesPool];
    
    while([bestSched count] < maxCourses)
    {
        
        NSLog(@"**********");
        for(Course* course in bestSched)
        {
            NSLog(@"%@",course.courseName);
        }
        NSLog(@"**********");
        BOOL addedNode = false;
        
        NSMutableArray* coursesPoolSelector;
        
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
        
        if(backtracking)
            coursesPoolSelector = [self getCourseOverlaps:prevNode.stateCourse fromCourseList:coursesPool];
        else coursesPoolSelector = coursesPool;
        
        for(Course* course in coursesPoolSelector)
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
            backtracking = false;
            break;
        }
        
        if(!addedNode)
        {
            [coursesPool addObject:currNode.stateCourse];
            [bestSched removeObject:currNode.stateCourse];
            prevNode = currNode;
            currNode = currNode.stateParent;
            backtracking = true;
        }
        
        
        if([bestSched count] > maxSchedFound)
            maxSchedFound = [bestSched count];
    }
    
    NSLog(@"MAXIMUM FOUND: %i",maxSchedFound);
    return bestSched;
}

-(NSMutableArray*)getCourseOverlaps:(Course*)course fromCourseList:(NSMutableArray*)courseList
{
    NSMutableArray* courseOverlaps = [[NSMutableArray alloc] initWithObjects:nil];

    for(int j = 0;j<[courseList count];j++)
    {
        if(overlapMap[course->courseID][((Course*)[courseList objectAtIndex:j])->courseID] == true)
        {
            [courseOverlaps addObject:[courseList objectAtIndex:j]];
            break;
        }
    }
    
    return courseOverlaps;
}

-(void)constructOverlaps:(NSMutableArray*)courses
{
    for(int i = 0;i<MAX_COURSES;i++)
        for(int j = 0;j<MAX_COURSES;j++)
            overlapMap[i][j] = false;
    
    
    for(int i = 0;i<[courses count];i++)
    {
        for(int j = i+1;j<[courses count];j++)
        {
            int fCourseId = ((Course*)[courses objectAtIndex:i])->courseID;
            int sCourseId = ((Course*)[courses objectAtIndex:j])->courseID;
            
            if([self checkOverlapWithFirstCourse:[courses objectAtIndex:i] secondCourse:[courses objectAtIndex:j]])
            {
                overlapMap[fCourseId][sCourseId] = true;
                overlapMap[sCourseId][fCourseId] = true;
            }
            
        }
    }
        
    
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
