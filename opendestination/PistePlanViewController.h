//
//  PistePlanViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/2/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTiledScrollView.h"
#import "DetailView.h"
#import "AwesomeMenu.h"

@interface PistePlanViewController : UIViewController <JCTileSource, JCTiledScrollViewDelegate, AwesomeMenuDelegate> {
    NSArray * _staticGPS;
    NSArray * _staticPoints;
    
}
@property (nonatomic, retain) JCTiledScrollView *scrollView;
@property (nonatomic, retain) DetailView *detailView;

@end
