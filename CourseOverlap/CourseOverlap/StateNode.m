//
//  StateNode.m
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import "StateNode.h"

@implementation StateNode

-(id)initNodeWithCourse:(Course*) course parent:(StateNode*)parent
{
    if([super init])
    {
        _stateCourse = course;
        _stateParent = parent;
        _stateChildNodes = [[NSMutableArray alloc] initWithObjects:nil];
    }
    return self;
}

@end
