//
//  SkiLiftView.m
//  opendestination
//
//  Created by Albert Ferrando on 8/24/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "SkiLiftView.h"

@implementation SkiLiftView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
        // Create an oval shape to draw.
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context,300,400);
    CGContextAddLineToPoint(context,320,420);
    CGContextAddLineToPoint(context,500,560);
    CGContextAddLineToPoint(context,580,700);
    CGContextStrokePath(context);
    
}


@end
