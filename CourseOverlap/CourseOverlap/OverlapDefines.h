//
//  OverlapDefines.h
//  CourseOverlap
//
//  Created by Mohamed Emad on 12/31/13.
//  Copyright (c) 2013 Mohamed Emad. All rights reserved.
//

#ifndef CourseOverlap_OverlapDefines_h
#define CourseOverlap_OverlapDefines_h

#define MAX_COURSES 30

typedef enum
{
    MON = 0,
    TUE,
    WED,
    THU,
    FRI,
    SAT,
    SUN
} Day;

typedef struct
{
    int timeHour;
    int timeMin;
    
} Time;

#endif
