//
//  JCPathView.m
//  opendestination
//
//  Created by Albert Ferrando on 8/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "JCPathView.h"

@implementation JCPathView
@synthesize path = _path;
@synthesize position = _position;
@synthesize centerOffset = _centerOffset;
@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
            // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
 CGContextSetLineWidth(context, 2.0);
 CGContextMoveToPoint(context,30,40);
 CGContextAddLineToPoint(context,130,120);
 CGContextAddLineToPoint(context,200,260);
 CGContextAddLineToPoint(context,280,300);
 CGContextStrokePath(context);
 }


@end
