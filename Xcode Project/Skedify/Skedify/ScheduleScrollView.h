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

@protocol ScheduleTapRecognizerProtocol<NSObject,UIScrollViewDelegate>

- (void)singleTap:(UITapGestureRecognizer *)gestureRecognizer;
- (void)doubleTap:(UITapGestureRecognizer *)gestureRecognizer;

@end



@interface ScheduleScrollView : UIScrollView

@property (nonatomic, weak) id<ScheduleTapRecognizerProtocol> delegate;
-(void)addWeekLabels;

@end
