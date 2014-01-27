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
    ScheduleSlotView * scheduleArr[7][17]; //TODO: add #define for the constant numbers
    CGPoint slotOriginalPositions[7][17];
    
    UILabel * dayLabels[7];
    CGPoint dayLabelOriginalPositions[7];
    
    UIView * timeLabels[17][2];
    CGPoint timeOriginalPositions[17][2];
    
    UIView* extraTimeLabels[9];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
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
  
    for(int i=7;i<24;i++)
    {
        UILabel *label =[[UILabel alloc] init];
        label.text=[NSString stringWithFormat:@"%@", [self getTime:i]];
        label.bounds =CGRectMake(0, 0, TIME_WIDTH, TIME_HEIGHT);
        label.layer.borderColor = [UIColor blackColor].CGColor;
        //label.layer.borderWidth = 0;
        label.center=CGPointMake((TIME_WIDTH/2) + 10,15+((i-7)*TIME_HEIGHT));
        label.backgroundColor=[UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        label.textColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.6 alpha:1];
        
        
        CGFloat borderWidth = 0.5;
        UIColor *borderColor = [UIColor colorWithRed:0.5 green:0.6 blue:0.6 alpha:0.7];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(7,((i-7)*TIME_HEIGHT)+5, self.layer.bounds.size.width-14, borderWidth)];
        topView.opaque = YES;
        topView.backgroundColor = borderColor;
        
        timeLabels[i-7][0] = label;
        timeOriginalPositions[i-7][0] = label.center;
        
        timeLabels[i-7][1] = topView;
        timeOriginalPositions[i-7][1] = topView.center;
        
        [self addSubview:topView];
        [self addSubview:label];
    }
    
    
    float startingPointX = TIME_WIDTH - 3;
    for (int i=0; i<7; i++)
    {
        for (int j=7; j<24; j++)
        {
            float startingPointY = TIME_STARTING_CENTER_POINT - (3*TIME_HEIGHT/2)  + ((j-7)*TIME_HEIGHT) + 7;
            
            CGRect r = CGRectMake(startingPointX + i*DAY_WIDTH + DAY_WIDTH/4,startingPointY + TIME_HEIGHT + TIME_HEIGHT/4, SCHEDULES_SLOT_WIDTH, SCHEDULES_SLOT_HEIGHT);
            
            ScheduleSlotView *slot =[[ScheduleSlotView alloc] initWithFrame:r withDay:(Day)i withTime:j];
            
            /*UITapGestureRecognizer* doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                  action:@selector(handleDoubleTap:)];
            [doubleTapRecognizer setNumberOfTapsRequired:2];
            doubleTapRecognizer.numberOfTouchesRequired = 1;
             [slot addGestureRecognizer:doubleTapRecognizer];*/ //TODO: double tap
            
            UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleSingleTap:)];
            [tapRecognizer setNumberOfTapsRequired:1];
            tapRecognizer.numberOfTouchesRequired = 1;
            //[tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
            [slot addGestureRecognizer:tapRecognizer];
            
            scheduleArr[i][j-7] = slot;
            slotOriginalPositions[i][j-7] = slot.center;
            [self addSubview:slot];
            
        }
    }

}

-(void)handleSingleTap:(UITapGestureRecognizer*)sender
{
    [self.delegate singleTap:sender];
}

-(void)handleDoubleTap:(UITapGestureRecognizer*)sender
{
    [self.delegate doubleTap:sender];
}

-(void) addWeekDays
{
    self.superview.opaque = NO;
    self.superview.clipsToBounds = YES;

    
    
    NSArray *weekDays = @[@"Mo",@"Tu",@"We",@"Th",@"Fr",@"Sa",@"Su"];
    for(int i=0;i<7;i++)
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
    for(int i = 0;i<7;i++)
    {
        for(int j = 0;j<17;j++)
        {
            ScheduleSlotView* slot = scheduleArr[i][j];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            slot.center = slotOriginalPositions[i][j];
            [UIView commitAnimations];
        }
    }
    
    for(int i = 0;i<17;i++)
    {
        for(int j = 0;j<2;j++)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelay:0.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            timeLabels[i][j].center = timeOriginalPositions[i][j];
            [UIView commitAnimations];
        }
    }
    
    for(int i = 0;i<7;i++)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        dayLabels[i].center = dayLabelOriginalPositions[i];
        [UIView commitAnimations];
    }
    
    for(int i = 0;i<9;i++)
    {
        [UIView animateWithDuration:0.4 animations:^{
            extraTimeLabels[i].alpha = 0; } completion:^(BOOL finished){
            [extraTimeLabels[i] removeFromSuperview];}];
        
        
        
    }
}

-(void)toggleExpansionWithLeftDay:(int)leftDay rightDay:(int)rightDay topHour:(int)topHour bottomHour:(int)bottomHour
{
    static BOOL expanded = FALSE;
    
    if(!expanded)
    {
        [self expandScheduleAtLeftDay:leftDay rightDay:rightDay topHour:topHour bottomHour:bottomHour];
        expanded = TRUE;
    }
    else
    {
        [self collapseSchedule];
        expanded = FALSE;
    }
}

-(void)expandTimeWithTopHour:(int)topHour bottomHour:(int)bottomHour
{
    int shiftOffset = 0;
    int extraLabelsCounter = 0;
    for(int i = 7;i<24;i++)
    {
        NSLog(@"%d %d",topHour,bottomHour);

        for(int j = 0;j < 7;j++)
        {
            ScheduleSlotView* slot = scheduleArr[j][i-7];
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.6];
            [UIView setAnimationDelay:0.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            slot.center = CGPointMake(slot.center.x, slot.center.y+shiftOffset);
            [UIView commitAnimations];
            
            
        }
        
        
        UIView* timeLabel = timeLabels[i-7][0];
        UIView* timeLine = timeLabels[i-7][1];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        timeLabel.center = CGPointMake(timeLabel.center.x, timeLabel.center.y+shiftOffset);
        timeLine.center = CGPointMake(timeLine.center.x, timeLine.center.y+shiftOffset);
        
        [UIView commitAnimations];
        

        
        if(i>=topHour && i<= bottomHour)
        {
            for(int j = 1;j<4;j++)
            {
                UILabel *label =[[UILabel alloc] init];
                label.text=[NSString stringWithFormat:@"%@", [self getTime:i withMinutes:15*j]];
                label.bounds =CGRectMake(0, 0, TIME_WIDTH, TIME_HEIGHT);
                label.center = CGPointMake(timeLabels[i-7][0].center.x, timeLabels[i-7][0].center.y);
                label.layer.borderColor = [UIColor blackColor].CGColor;
                label.alpha = 0;
                //label.layer.borderWidth = 0;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.6];
                [UIView setAnimationDelay:0.0];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                label.center=CGPointMake((TIME_WIDTH/2) + 10,15+((i-7)*TIME_HEIGHT + (j+1)*10 + shiftOffset));
                label.alpha = 1;
                [UIView commitAnimations];
                label.backgroundColor=[UIColor clearColor];
                label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
                label.textColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.6 alpha:1];
                extraTimeLabels[extraLabelsCounter] = label;
                extraLabelsCounter++;
                [self addSubview:label];
                
                if(j == 3)
                    shiftOffset += 15;
                
                shiftOffset += 10;
            }
        }
        
        
        
    }
}
-(void)expandDaysWithLeft:(int)leftDay withRight:(int)rightDay
{
    
    for(int i = leftDay;i>=0;i--)
    {
        int offset = (((i)*2))*(3*(DAY_WIDTH - SCHEDULES_SLOT_WIDTH)/4);
        
        for(int j = 7;j<24;j++)
        {

            
            ScheduleSlotView* slot = scheduleArr[i][j-7];
            slot.center = CGPointMake(slot.center.x-offset, slot.center.y);
            
        }
        

        
        UILabel* dayLabel = dayLabels[i];
        dayLabel.center = CGPointMake(dayLabel.center.x-offset, dayLabel.center.y);

        
        
    }
    
    for(int i = rightDay;i<7;i++)
    {
        int offset = (((6-i)*2))*(3*(DAY_WIDTH - SCHEDULES_SLOT_WIDTH)/4);
        for(int j = 7;j<24;j++)
        {
            

            
            ScheduleSlotView* slot = scheduleArr[i][j-7];
            slot.center = CGPointMake(slot.center.x+offset, slot.center.y);
            
    
        }
        

        
        UILabel* dayLabel = dayLabels[i];
        dayLabel.center = CGPointMake(dayLabel.center.x+offset, dayLabel.center.y);
        
    }
    
}

-(void)expandScheduleAtLeftDay:(int)leftDay
                      rightDay:(int)rightDay
                       topHour:(int)topHour
                    bottomHour:(int)bottomHour
{
    [UIView animateWithDuration:0.2 animations:^{ [self expandDaysWithLeft:leftDay withRight:rightDay]; } completion:^(BOOL finished){
        [self expandTimeWithTopHour:topHour bottomHour:bottomHour];}];

    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
