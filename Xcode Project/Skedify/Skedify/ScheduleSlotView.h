//
//  ScheduleSlotView.h
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface ScheduleSlotView : UIView

-(Day)getDay;
-(int)getTime;

- (id)initWithFrame:(CGRect)frame withDay:(Day)_day withTime:(int)_time withStates:(SlotStatus[4])hourStates;
- (void)fillSelectedQuartersMeeting:(int)startingMin endingMin:(int)endMin;
- (void)fillFullHourMeeting;
- (void)expandSlot;
- (void)collapseSlot;
@end
