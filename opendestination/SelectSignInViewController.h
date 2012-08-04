//
//  SelectSignInViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 7/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SelectSignInViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *guestButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *facebookMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *signupMessageLabel;
@property (strong, nonatomic) IBOutlet UIButton *logoButton;
@property (strong, nonatomic) IBOutlet UILabel *loginMessageLabel;
@property (strong, nonatomic) IBOutlet UILabel *guestMessageLabel;
- (IBAction)facebookBtnPressed:(id)sender;
- (IBAction)signupButtonPressed:(id)sender;
- (IBAction)guestButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
@end
