//
//  MeteoViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/8/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeteoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (strong, nonatomic) IBOutlet UIImageView *currentImage;
@property (strong, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UILabel *tempFLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageplus1;
@property (strong, nonatomic) IBOutlet UIImageView *imageplus3;
@property (strong, nonatomic) IBOutlet UIImageView *imageplus2;
@property (strong, nonatomic) IBOutlet UILabel *dayplus1;
@property (strong, nonatomic) IBOutlet UILabel *dayplus2;
@property (strong, nonatomic) IBOutlet UILabel *dayplus3;
@property (strong, nonatomic) IBOutlet UILabel *tempplus1;
@property (strong, nonatomic) IBOutlet UILabel *tempplus2;
@property (strong, nonatomic) IBOutlet UILabel *tempplus3;
@property (strong, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *templow1;
@property (strong, nonatomic) IBOutlet UILabel *templow2;
@property (strong, nonatomic) IBOutlet UILabel *templow3;
@end
