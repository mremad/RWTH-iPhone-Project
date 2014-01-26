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
        label.text=[NSString stringWithFormat:@" %@", [self getTime:i]];
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
        
        [self addSubview:topView];
        [self addSubview:label];
    }
    
    float startingPointX = TIME_WIDTH;
    for (int i=0; i<7; i++)
    {
        for (int j=7; j<24; j++)
        {
            float startingPointY = TIME_STARTING_CENTER_POINT - (3*TIME_HEIGHT/2)  + ((j-7)*TIME_HEIGHT) + 7;
            
            CGRect r = CGRectMake(startingPointX + i*DAY_WIDTH + DAY_WIDTH/4,startingPointY + TIME_HEIGHT + TIME_HEIGHT/4, SCHEDULES_SLOT_WIDTH, SCHEDULES_SLOT_HEIGHT);
            
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
