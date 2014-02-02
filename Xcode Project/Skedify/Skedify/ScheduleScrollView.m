//
//  ScheduleScrollView.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ScheduleScrollView.h"

#define UIVIEWS_STARTING_YPOSITION 64



@implementation ScheduleScrollView
{
    ScheduleSlotView * scheduleArr[NUMBER_DAYS][NUMBER_HOURS]; //TODO: add #define for the constant numbers
    CGPoint slotOriginalPositions[NUMBER_DAYS][NUMBER_HOURS];
    
    UILabel * dayLabels[NUMBER_DAYS];
    CGPoint dayLabelOriginalPositions[NUMBER_DAYS];
    
    UIView * timeLabels[NUMBER_HOURS][2];
    CGPoint timeOriginalPositions[NUMBER_HOURS][2];
    
    UIView* extraTimeLabels[9];
    
    BOOL expanded;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        expanded = FALSE;
        
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleSingleCollapseTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        tapRecognizer.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
    }
    [self AddSlots];
    return self;
}

-(NSString *) getTime:(NSInteger)time withMinutes:(NSInteger)minutes
{
    NSMutableString *result;
    if(time<10)
    {
        result = [NSMutableString stringWithFormat: @"0%d", (int)time];
    }
    else
    {
        result = [NSMutableString stringWithFormat: @"%d", (int)time];
        
    }
    
    [result appendString:[NSString stringWithFormat:@":%d",minutes]];
    
    return result;
}

-(NSString *) getTime:(NSInteger) time
{
    NSMutableString *result;
    if(time<10)
    {
         result = [NSMutableString stringWithFormat: @"0%d", (int)time];
    }
    else
    {
        result = [NSMutableString stringWithFormat: @"%d", (int)time];
        
    }
    [result appendString:@":00"];
    
    return result;
}

-(void)AddSlots
{
  
    for(int i=STARTING_HOUR;i<ENDING_HOUR;i++)
    {
        UILabel *label =[[UILabel alloc] init];
        label.text=[NSString stringWithFormat:@"%@", [self getTime:i]];
        label.bounds =CGRectMake(0, 0, TIME_WIDTH, TIME_HEIGHT);
        label.layer.borderColor = [UIColor blackColor].CGColor;
        //label.layer.borderWidth = 0;
        label.center=CGPointMake((TIME_WIDTH/2) + 10,15+((i-STARTING_HOUR)*TIME_HEIGHT));
        label.backgroundColor=[UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        label.textColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.6 alpha:1];
        
        
        CGFloat borderWidth = 0.5;
        UIColor *borderColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.6 alpha:0.7];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(7,((i-STARTING_HOUR)*TIME_HEIGHT)+5, self.layer.bounds.size.width-14, borderWidth)];
        topView.opaque = YES;
        topView.backgroundColor = borderColor;
        
        timeLabels[i-STARTING_HOUR][0] = label;
        timeOriginalPositions[i-STARTING_HOUR][0] = label.center;
        
        timeLabels[i-STARTING_HOUR][1] = topView;
        timeOriginalPositions[i-STARTING_HOUR][1] = topView.center;
        
        [self addSubview:topView];
        [self addSubview:label];
    }
    
    
    float startingPointX = TIME_WIDTH;
    for (int i=0; i<NUMBER_DAYS; i++)
    {
        for (int j=STARTING_HOUR; j<ENDING_HOUR; j++)
        {
            float startingPointY = TIME_STARTING_CENTER_POINT - (3*TIME_HEIGHT/2)  + ((j-STARTING_HOUR)*TIME_HEIGHT);
            
            CGRect r = CGRectMake(startingPointX + i*DAY_WIDTH,startingPointY + TIME_HEIGHT + TIME_HEIGHT/4, SCHEDULES_SLOT_WIDTH, SCHEDULES_SLOT_HEIGHT);
            
            ScheduleSlotView *slot =[[ScheduleSlotView alloc] initWithFrame:r withDay:(Day)i withTime:j];
            
            /*UITapGestureRecognizer* doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                  action:@selector(handleDoubleTap:)];
            [doubleTapRecognizer setNumberOfTapsRequired:2];
            doubleTapRecognizer.numberOfTouchesRequired = 1;
             [slot addGestureRecognizer:doubleTapRecognizer];*/ //TODO: double tap
            
            UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleSingleExpandTap:)];
            [tapRecognizer setNumberOfTapsRequired:1];
            tapRecognizer.numberOfTouchesRequired = 1;
            //[tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
            
            
            
            [slot addGestureRecognizer:tapRecognizer];
            
            scheduleArr[i][j-STARTING_HOUR] = slot;
            slotOriginalPositions[i][j-STARTING_HOUR] = slot.center;
            [self addSubview:slot];
            
        }
    }

}

-(void)handleSingleExpandTap:(UITapGestureRecognizer*)sender
{
    
    Day day =[(ScheduleSlotView*)sender.view getDay];
    int time = [(ScheduleSlotView*)sender.view getTime];
    NSLog(@"Tapped at time:%d and Day:%d!",time,day);
    
    int leftDay  = (int)day - 1;
    int rightDay = (int)day + 1;
    
    int topHour = time-1;
    int bottomHour = time+1;
    
    //_scrollView.scrollEnabled = NO;
    
    if(!expanded)
        [self expandScheduleAtLeftDay:leftDay rightDay:rightDay topHour:topHour bottomHour:bottomHour];
    else [self collapseSchedule];
    
}

-(void)handleSingleCollapseTap:(UITapGestureRecognizer*)sender
{
    if(expanded)
        [self collapseSchedule];
}

-(void) addWeekDays
{
    self.superview.opaque = NO;
    self.superview.clipsToBounds = YES;

    
    
    NSArray *weekDays = @[@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa",@"Su"];
    for(int i=0;i<NUMBER_DAYS;i++)
    {
        UILabel *label =[[UILabel alloc] init];
        label.text=[NSString stringWithFormat:@"%@", [weekDays objectAtIndex:i]];
        label.bounds = CGRectMake(0,0 ,DAY_WIDTH, DAY_HEIGHT);
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.center=CGPointMake(DAY_STARTING_CENTER_POINT+i*((int)DAY_WIDTH) + DAY_WIDTH/4,UIVIEWS_STARTING_YPOSITION+ (DAY_HEIGHT/2));
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        label.textColor = [UIColor colorWithHue:29 saturation:100 brightness:100 alpha:1];
        NSLog(@"%d",DAY_WIDTH);
        dayLabels[i] = label;
        dayLabelOriginalPositions[i] = label.center;
        [self.superview addSubview:label];
    }
}

-(void)collapseSchedule
{
    for(int i = 0;i<NUMBER_DAYS;i++)
    {
        for(int j = 0;j<NUMBER_HOURS;j++)
        {
            ScheduleSlotView* slot = scheduleArr[i][j];
            
            [slot collapseSlot];
            
            [UIView animateWithDuration:0.7
                             animations:^{
                                 slot.center = slotOriginalPositions[i][j];
                                    }
                             completion:^(BOOL finished){expanded = false;}];
            
            [UIView animateWithDuration:0.6
                             animations:^{
                                 slot.alpha = 1;}
                             completion:^(BOOL finished){}];
            
            

        }
    }
    
    for(int i = 0;i<NUMBER_HOURS;i++)
    {
        for(int j = 0;j<2;j++)
        {
            [UIView animateWithDuration:0.7
                             animations:^{timeLabels[i][j].center = timeOriginalPositions[i][j];}
                             completion:^(BOOL finished){expanded = false;}];

        }
    }
    
    for(int i = 0;i<NUMBER_DAYS;i++)
    {
        [UIView animateWithDuration:0.7
                         animations:^{dayLabels[i].center = dayLabelOriginalPositions[i];}
                         completion:^(BOOL finished){expanded = false;}];

        

    }
    
    for(int i = 0;i<9;i++)
    {
        [UIView animateWithDuration:0.7 animations:^{
            extraTimeLabels[i].alpha = 0; } completion:^(BOOL finished){
            [extraTimeLabels[i] removeFromSuperview];
                expanded = false;}];
        
        
        
    }
}



-(void)expandTimeWithTopHour:(int)topHour bottomHour:(int)bottomHour
{
    int shiftOffset = 0;
    int extraLabelsCounter = 0;
    for(int i = STARTING_HOUR;i<ENDING_HOUR;i++)
    {
        NSLog(@"%d %d",topHour,bottomHour);

        for(int j = 0;j < NUMBER_DAYS;j++)
        {
            ScheduleSlotView* slot = scheduleArr[j][i-STARTING_HOUR];
            
            
            [UIView animateWithDuration:0.35
                             animations:^{
                                 slot.center = CGPointMake(slot.center.x, slot.center.y+shiftOffset);}
                             completion:^(BOOL finished){
                                 expanded = true;
                             }];
            if(i>=topHour && i<= bottomHour)
                [slot expandSlot];
            
            
        }
        
        
        UIView* timeLabel = timeLabels[i-STARTING_HOUR][0];
        UIView* timeLine = timeLabels[i-STARTING_HOUR][1];
        
        
        [UIView animateWithDuration:0.35
                         animations:^{
                             timeLabel.center = CGPointMake(timeLabel.center.x, timeLabel.center.y+shiftOffset);
                             timeLine.center = CGPointMake(timeLine.center.x, timeLine.center.y+shiftOffset); }
                         completion:^(BOOL finished){
                             expanded = true;
                         }];
        
        

        

        
        if(i>=topHour && i<= bottomHour)
        {
            for(int j = 1;j<4;j++)
            {
                if(j == 1)
                    shiftOffset += SCHEDULE_SLOT_QUARTER_HEIGHT;
                
                UILabel *label =[[UILabel alloc] init];
                label.text=[NSString stringWithFormat:@"%@", [self getTime:i withMinutes:15*j]];
                label.bounds =CGRectMake(0, 0, TIME_WIDTH, TIME_HEIGHT);
                label.center = CGPointMake(timeLabels[i-STARTING_HOUR][0].center.x, timeLabels[i-STARTING_HOUR][0].center.y);
                label.layer.borderColor = [UIColor blackColor].CGColor;
                label.alpha = 0;
                
                [UIView animateWithDuration:0.35
                                 animations:^{
                                     label.center=CGPointMake((TIME_WIDTH/2) + 10,
                                                              SCHEDULE_SLOT_QUARTER_HEIGHT+((i-STARTING_HOUR)*TIME_HEIGHT + (j)*SCHEDULE_SLOT_QUARTER_HEIGHT + shiftOffset));
                                     label.alpha = 1; }
                                 completion:^(BOOL finished){
                                     expanded = true;
                                 }];
                

                label.backgroundColor=[UIColor clearColor];
                label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
                label.textColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.6 alpha:1];
                extraTimeLabels[extraLabelsCounter] = label;
                extraLabelsCounter++;
                [self addSubview:label];
                
                if(j == 3)
                    shiftOffset += SCHEDULE_SLOT_QUARTER_HEIGHT;
                
                shiftOffset += SCHEDULE_SLOT_QUARTER_HEIGHT;
            }
        }
        
        
        
    }
}
-(void)expandDaysWithLeft:(int)leftDay withRight:(int)rightDay
{
    
    for(int i = leftDay;i>=0;i--)
    {
        int offset = (((i)*2))*(2*(SCHEDULES_SLOT_WIDTH - SCHEDULES_SLOT_EFFECTIVE_WIDTH)/4);
        
        for(int j = STARTING_HOUR;j<ENDING_HOUR;j++)
        {

            
            ScheduleSlotView* slot = scheduleArr[i][j-STARTING_HOUR];
            
            [UIView animateWithDuration:0.35
                             animations:^{ slot.center = CGPointMake(slot.center.x-offset, slot.center.y);
                                 
                             }
                             completion:^(BOOL finished){
                                 expanded = true;
                             }];
            
            [UIView animateWithDuration:0.6
                             animations:^{
                                 
                                 slot.alpha = 0.3;}
                             completion:^(BOOL finished){}];
           
            
        }
        

        
        
        UILabel* dayLabel = dayLabels[i];
        
        [UIView animateWithDuration:0.35
                         animations:^{dayLabel.center = CGPointMake(dayLabel.center.x-offset, dayLabel.center.y); }
                         completion:^(BOOL finished){
                             expanded = true;
                         }];
        

        
        
    }
    
    for(int i = rightDay;i<NUMBER_DAYS;i++)
    {
        int offset = (((6-i)*2))*(2*(SCHEDULES_SLOT_WIDTH - SCHEDULES_SLOT_EFFECTIVE_WIDTH)/4);
        for(int j = STARTING_HOUR;j<ENDING_HOUR;j++)
        {
            ScheduleSlotView* slot = scheduleArr[i][j-STARTING_HOUR];
            
            [UIView animateWithDuration:0.35
                             animations:^{
                                 slot.center = CGPointMake(slot.center.x+offset, slot.center.y);
                                 }
                             completion:^(BOOL finished){
                                 expanded = true;
                             }];
            
            [UIView animateWithDuration:0.6
                             animations:^{
                                 
                                 slot.alpha = 0.3;}
                             completion:^(BOOL finished){}];
            
            
        }
        

        
        UILabel* dayLabel = dayLabels[i];
        
        [UIView animateWithDuration:0.35
                         animations:^{dayLabel.center = CGPointMake(dayLabel.center.x+offset, dayLabel.center.y); }
                         completion:^(BOOL finished){
                expanded = true;
            }];
        
    }
    
}

-(void)expandScheduleAtLeftDay:(int)leftDay
                      rightDay:(int)rightDay
                       topHour:(int)topHour
                    bottomHour:(int)bottomHour
{
    [self expandDaysWithLeft:leftDay withRight:rightDay];
    [self expandTimeWithTopHour:topHour bottomHour:bottomHour];
}

@end
