//
//  IDFactory.m
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#import "IDFactory.h"

@implementation IDFactory

+(int)createID
{
    static int ID = 0;
    
    ID++;
    
    return ID-1;
}

@end
