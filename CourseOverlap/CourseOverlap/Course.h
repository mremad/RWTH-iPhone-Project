//
//  Course.h
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OverlapDefines.h"
#import "IDFactory.h"



@interface Course : NSObject
{
    @public
    Day courseDay;
    @public
    Time startTime;
    @public
    Time endTime;
    @public
    int courseID;
}

@property (nonatomic,strong) NSString* courseName;


-(id)initWithCourseName:(NSString*)name;

@end
