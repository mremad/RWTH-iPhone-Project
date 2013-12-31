//
//  StateNode.h
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"

@interface StateNode : NSObject
{
    
}

@property (nonatomic,strong) NSMutableArray* stateChildNodes;
@property (nonatomic,strong) StateNode* stateParent;
@property (nonatomic,strong) Course* stateCourse;


-(id)initNodeWithCourse:(Course*) course parent:(StateNode*)parent;

@end
