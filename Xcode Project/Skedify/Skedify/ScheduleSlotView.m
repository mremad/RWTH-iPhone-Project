//
//  ScheduleSlotView.m
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "ScheduleSlotView.h"

@implementation ScheduleSlotView


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        int r = arc4random() % 35;
        
        if(r<25)
        {
            self.backgroundColor = [UIColor redColor];
        }
        else if(r<30)
        {
            self.backgroundColor = [UIColor whiteColor];
        }
        else if(r<33)
        {
            self.backgroundColor = [UIColor blueColor];
        }
        else
        {
            self.backgroundColor = [UIColor greenColor];
        }
      
        
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        [self setIsAccessibilityElement:YES];
        [self setAccessibilityTraits:UIAccessibilityTraitButton];
    }
    return self;
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
