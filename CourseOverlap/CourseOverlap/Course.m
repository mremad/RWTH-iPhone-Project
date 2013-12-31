//
//  Course.m
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import "Course.h"


@implementation Course

-(id)initWithCourseName:(NSString*)name
{
    if([super init])
    {
        _courseName = name;
        courseID = [IDFactory createID];
    }

    return self;
}

@end
