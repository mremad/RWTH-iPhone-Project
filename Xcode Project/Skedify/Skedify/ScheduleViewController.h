//
//  ScheduleViewController.h
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleScrollView.h"
#import "GlobalVariables.h"
#import "ServerConnection.h"


@interface ScheduleViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) ScheduleScrollView *scrollView;
@property NSInteger groupID;

- (void)reserveMeetingAtStartingHour:(int)startingHour startingMin:(int)startingMin endingHour:(int)endingHour endingMin:(int)endingMin day:(Day)meetingDay;

@end