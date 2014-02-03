//
//  ScheduleSlotView.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ScheduleSlotView.h"

@implementation ScheduleSlotView
{
    Day day;
    int time;
    BOOL expanded;
    
    UIView* Q1;
    UIView* Q2;
    UIView* Q3;
    UIView* Q4;
    
    NSArray* quarterArray;
}


- (id)initWithFrame:(CGRect)frame withDay:(Day)_day withTime:(int)_time
{
    day = _day;
    time = _time;
    expanded = false;
    
    
    if ((self = [super initWithFrame:frame])) {
      
        Q1 = [[UIView alloc] initWithFrame:CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                      0+7,
                                                      SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                      SCHEDULES_SLOT_HEIGHT/4)];
        
        Q2 = [[UIView alloc] initWithFrame:CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                      SCHEDULES_SLOT_HEIGHT/4 +7,
                                                      SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                      SCHEDULES_SLOT_HEIGHT/4)];
        
        Q3 = [[UIView alloc] initWithFrame:CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                      SCHEDULES_SLOT_HEIGHT/2 +7,
                                                      SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                      SCHEDULES_SLOT_HEIGHT/4)];
        
        Q4 = [[UIView alloc] initWithFrame:CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                      (3*SCHEDULES_SLOT_HEIGHT/4 +7),
                                                      SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                      SCHEDULES_SLOT_HEIGHT/4)];
        
        Q1.userInteractionEnabled = NO;
        Q2.userInteractionEnabled = NO;
        Q3.userInteractionEnabled = NO;
        Q4.userInteractionEnabled = NO;
        
        
        quarterArray = [NSArray arrayWithObjects:Q1,Q2,Q3,Q4,nil];
        
        
        Q1.backgroundColor = [UIColor greenColor];
        Q2.backgroundColor = [UIColor redColor];
        Q3.backgroundColor = [UIColor blueColor];
        Q4.backgroundColor = [UIColor blackColor];
        
        
        self.backgroundColor = [UIColor clearColor];
        
        
        
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.cornerRadius = 1;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        
        [self addSubview:Q1];
        [self addSubview:Q2];
        [self addSubview:Q3];
        [self addSubview:Q4];

    }
    return self;
}

-(void)expandSlot
{
    if(!expanded)
    {
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height + SCHEDULE_SLOT_QUARTER_HEIGHT*5);
        
        [UIView animateWithDuration:0.7
                         animations:^{
                         
                             Q1.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   (self.frame.size.height/4) - (self.frame.size.height/6),
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/2);
                             
                             Q2.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   (2*self.frame.size.height/4) - (self.frame.size.height/6),
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/2);
                             
                             Q3.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   (3*self.frame.size.height/4) - (self.frame.size.height/6),
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/2);
                             
                             Q4.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   (4*self.frame.size.height/4) - (self.frame.size.height/6),
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/2);
                             
                         }
                         completion:^(BOOL finished){
                             expanded = true;
                         }];
       
        
    }
}

-(void)collapseSlot
{
    if(expanded)
    {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - SCHEDULE_SLOT_QUARTER_HEIGHT*5);
        
        [UIView animateWithDuration:0.6
                         animations:^{
                             
                             Q1.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   0 + 7,
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/4);
                             
                             Q2.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   SCHEDULES_SLOT_HEIGHT/4 + 7,
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/4);
                             
                             Q3.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   SCHEDULES_SLOT_HEIGHT/2 + 7,
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/4);
                             
                             Q4.frame = CGRectMake(SCHEDULE_SLOT_DIFFERENCE_WIDTH/2,
                                                   (3*SCHEDULES_SLOT_HEIGHT/4) + 7,
                                                   SCHEDULES_SLOT_EFFECTIVE_WIDTH,
                                                   SCHEDULES_SLOT_HEIGHT/4);
                             
                         }
                         completion:^(BOOL finished){
                             expanded = false;
                         }];
        
        
    }
}

-(Day)getDay
{
    return day;
}

-(int)getTime
{
    return time;
}

- (void)drawRect:(CGRect)rect
{
   
   /* CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context,
                                     [UIColor blueColor].CGColor);
    CGRect rectangle = CGRectMake(0,0,10,10);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);*/
}


@end
