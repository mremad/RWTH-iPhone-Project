//
//  GlobalVariables.h
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#ifndef Skedify_GlobalVariables_h
#define Skedify_GlobalVariables_h




#define TIME_HEIGHT 33
#define TIME_WIDTH 60
#define TIME_STARTING_CENTER_POINT (TIME_HEIGHT/2)

#define DAY_HEIGHT  20
#define DAY_WIDTH ((320-TIME_WIDTH)/7)
#define DAY_STARTING_CENTER_POINT (TIME_WIDTH +(DAY_WIDTH/2))

#define SCHEDULE_SLOT_DIFFERENCE_WIDTH 10
#define SCHEDULE_SLOT_DIFFERENCE_HEIGHT 7
#define SCHEDULES_SLOT_HEIGHT 28
#define SCHEDULES_SLOT_WIDTH DAY_WIDTH
#define SCHEDULES_SLOT_EFFECTIVE_WIDTH (SCHEDULES_SLOT_WIDTH - (SCHEDULE_SLOT_DIFFERENCE_WIDTH))
#define SCHEDULES_SLOT_EFFECTIVE_HEIGHT SCHEDULES_SLOT_HEIGHT - (SCHEDULE_SLOT_DIFFERENCE_HEIGHT)
#define SCHEDULES_SLOT_CENTER_POINT TIME_WIDTH + (DAY_WIDTH/2)
#define SCHEDULE_SLOT_QUARTER_HEIGHT 15

#define NUMBER_DAYS 7
#define NUMBER_HOURS 17
#define STARTING_HOUR 7
#define ENDING_HOUR 24

#define NUM_BUFFERED_SCHEDULES 3

#endif

typedef enum
{
    SlotStateBusy,
    SlotStateFree,
    SlotStateMeeting
}
SlotStatus;



typedef enum
{
    Mo = 0,
    Tu,
    We,
    Th,
    Fr,
    Sa,
    Su
}Day;
