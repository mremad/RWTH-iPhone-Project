//
//  Slot.m
//  Skedify
//
//  Created by Mohamed Emad on 2/3/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "Slot.h"

@implementation Slot

- (id)initWithStartDate:(NSDate *)startTime withWeekNum:(int)weekNum withDay:(Day)day withSlotStatus:(SlotStatus)slotStatus
{
   
    self = [super init];
    
    _startTime = startTime;
    _day = day;
    _slotStatus = slotStatus;
    _weekNum = weekNum;
    
    return self;
}

@end
