//
//  Slot.h
//  Skedify
//
//  Created by Mohamed Emad on 2/3/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalVariables.h"

@interface Slot : NSObject

@property (nonatomic) Day day;
@property (nonatomic) NSDate* startTime;
@property (nonatomic) int weekNum;
@property (nonatomic) SlotStatus slotStatus;
- (id)initWithStartTime:(NSDate *)startTime withWeekNum:(int)weekNum withDay:(Day)day withSlotStatus:(SlotStatus)slotStatus;

@end
