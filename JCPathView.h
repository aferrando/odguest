//
//  JCPathView.h
//  opendestination
//
//  Created by Albert Ferrando on 8/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JCPath;

@interface JCPathView : UIView
@property (nonatomic, retain) JCPath  *path;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGPoint centerOffset;
@property (nonatomic, retain) NSString *reuseIdentifier;

@end
