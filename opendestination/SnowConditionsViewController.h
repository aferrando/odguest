//
//  SnowConditionsViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/22/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SnowConditionsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *totalSlopes;
@property (strong, nonatomic) IBOutlet UILabel *openSlopes;
@property (strong, nonatomic) IBOutlet UILabel *highestTemp;
@property (strong, nonatomic) IBOutlet UILabel *lowestTemp;
@property (strong, nonatomic) IBOutlet UILabel *highestWind;
@property (strong, nonatomic) IBOutlet UILabel *lowestWind;
@property (strong, nonatomic) IBOutlet UILabel *highestNewSnow;
@property (strong, nonatomic) IBOutlet UILabel *highestTotalSnow;
@property (strong, nonatomic) IBOutlet UILabel *lowestNewSnow;
@property (strong, nonatomic) IBOutlet UILabel *lowestTotalSnow;
@property (strong, nonatomic) IBOutlet UILabel *highestLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestLabel;
@property (strong, nonatomic) IBOutlet UILabel *highestWindLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestWindLabel;
@property (strong, nonatomic) IBOutlet UILabel *highestNewSnowLabel;
@property (strong, nonatomic) IBOutlet UILabel *highestTotalSnowLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestNewSnowLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowestTotalSnowLabel;

@property (strong, nonatomic) IBOutlet UILabel *totalLifts;
@property (strong, nonatomic) IBOutlet UILabel *openLifts;
@property (strong, nonatomic) IBOutlet UIButton *overall;
@property (strong, nonatomic) IBOutlet UIButton *liftButton;
@property (strong, nonatomic) IBOutlet UIButton *slopesButton;
@property (strong, nonatomic) IBOutlet UIView *snowView;
@end
