//
//  ScheduleScrollView.h
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleSlotView.h"
#import "GlobalVariables.h"

@protocol ScheduleControllerProtocol<NSObject,UIScrollViewDelegate>

- (void)singleTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)reserveMeetingAtStartingHour:(int)startingHour startingMin:(int)startingMin endingHour:(int)endingHour endingMin:(int)endingMin day:(Day)meetingDay;

@end



@interface ScheduleScrollView : UIScrollView

@property (nonatomic, weak) id<ScheduleControllerProtocol> delegate;
- (id)initWithFrame:(CGRect)frame withSchedule:(SlotStatus[NUMBER_DAYS][NUMBER_HOURS*4])fullSchedule;
-(void)updateViewForNewMeeting;
-(void)addWeekLabels;

@end
