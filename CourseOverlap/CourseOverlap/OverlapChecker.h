//
//  OverlapChecker.h
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "StateNode.h"
@interface OverlapChecker : NSObject

-(NSMutableArray*)getBestSchedule:(NSMutableArray*)coursesPool withMaxCourses:(int)maxCourses;

@end
