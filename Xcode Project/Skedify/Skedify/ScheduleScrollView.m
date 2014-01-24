//
//  ScheduleScrollView.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ScheduleScrollView.h"


@implementation ScheduleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self AddSlots];
    return self;
}

-(NSString *) getTime:(NSInteger) time
{
    NSMutableString *result;
    if(time<10)
    {
         result = [NSMutableString stringWithFormat: @"%0d", (int)time];
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
  
    for(int i=0;i<24;i++)
    {
        UILabel *label =[[UILabel alloc] init];
        label.text=[NSString stringWithFormat:@" %@", [self getTime:i]];
        label.bounds =CGRectMake(0, 0, TIME_WIDTH, TIME_HEIGHT);
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 3.0;
        label.center=CGPointMake(TIME_WIDTH/2,TIME_STARTING_CENTER_POINT+(i*TIME_HEIGHT));
        label.backgroundColor=[UIColor whiteColor];
        [self addSubview:label];
    }
    
    float startingPointX = SCHEDULES_SLOT_CENTER_POINT - (DAY_WIDTH/2);
    for (int i=0; i<7; i++)
    {
        for (int j=0; j<24; j++)
        {
            float startingPointY = TIME_STARTING_CENTER_POINT - (3*TIME_HEIGHT/2)  + (j*SCHEDULES_SLOT_HEIGHT);
            
            CGRect r = CGRectMake(startingPointX + i*SCHEDULES_SLOT_WIDTH,startingPointY + SCHEDULES_SLOT_HEIGHT, SCHEDULES_SLOT_WIDTH, SCHEDULES_SLOT_HEIGHT);
            
            ScheduleSlotView *slot =[[ScheduleSlotView alloc] initWithFrame:r];
            [self addSubview:slot];
        }
    }

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
