//
//  ProfileBarViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 7/4/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProfileBarViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *realnameTextField;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIView *backgroundVIew;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *currentPointsLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *goalLabel;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
- (IBAction)showProfile:(id)sender;
- (void) refresh;
@end
