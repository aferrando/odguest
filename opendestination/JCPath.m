//
//  JCPath.m
//  opendestination
//
//  Created by Albert Ferrando on 8/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "JCPath.h"
#import "JCPathView.h"

@implementation JCPath
@synthesize contentPosition = _contentPosition;
@synthesize screenPosition = _screenPosition;
@synthesize view = _view;
@synthesize typeofService;

- (id)init
{
    if ((self = [super init]))
        {
        _view = nil;
        _screenPosition = CGPointZero;
        _contentPosition = CGPointZero;
        }
    return self;
}

- (void)dealloc
{
        //  [_view release];
        //  [super dealloc];
}

- (BOOL)isWithinBounds:(CGRect)bounds
{
    return CGRectContainsPoint(CGRectInset(bounds, -25.0f, -25.0f), self.screenPosition);
}

- (void)setScreenPosition:(CGPoint)screenPosition
{
    if (!CGPointEqualToPoint(_screenPosition, screenPosition))
        {
        _screenPosition = screenPosition;
        
        if (nil != _view)
            {
            _view.position = screenPosition;
            }
        }
}

- (void)setView:(JCPathView *)view
{
    if (view != _view)
        {
        [_view removeFromSuperview];
            //  [_view release];
        _view = nil;
        
        if (nil != view)
            {
            _view = view;
            _view.path = self;
            _view.position = self.screenPosition;
            }
        }
}

@end
