//
//  JCPath.h
//  opendestination
//
//  Created by Albert Ferrando on 8/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCPathView;

@interface JCPath : NSObject{
    NSInteger typeofService;
}

@property (nonatomic, assign) CGPoint contentPosition;
@property (nonatomic, assign) CGPoint screenPosition;
@property (nonatomic, retain) JCPathView *view;
@property (nonatomic, assign ) NSInteger typeofService;

- (BOOL)isWithinBounds:(CGRect)bounds;

@end