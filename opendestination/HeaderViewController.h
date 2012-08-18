//
//  HeaderViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 7/2/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"

@interface HeaderViewController : UIViewController <UIImagePickerControllerDelegate>
{
    UserModel * _userModel;

}
@property (strong, nonatomic) IBOutlet UIButton *userImage;
@property (strong, nonatomic) IBOutlet UIProgressView *pointProgressView;
@property (strong, nonatomic) IBOutlet UITextField *realnameTextField;
@property (strong, nonatomic) IBOutlet UIButton *mySettingsButton;
@property (strong, nonatomic) IBOutlet UILabel *points;
@property (strong, nonatomic) IBOutlet UILabel *level;
@property (strong, nonatomic) IBOutlet UIButton *likesButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationsButton;
@property (strong, nonatomic) IBOutlet UIButton *sharesButton;
@property (strong, nonatomic) IBOutlet UILabel *myLikesLabel;
@property (strong, nonatomic) IBOutlet UILabel *notificationsLabel;
@property (strong, nonatomic) IBOutlet UILabel *sharesLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelName;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *myLikesView;
@property (strong, nonatomic) IBOutlet UIView *myNotifiticationView;
@property (strong, nonatomic) IBOutlet UIView *mySharesView;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (strong, nonatomic) IBOutlet UILabel *completedLabel;
@property (strong, nonatomic) IBOutlet UIButton *signOutButton;
@property (strong, nonatomic) IBOutlet UIButton *pointsButton;
@property (strong, nonatomic) IBOutlet UIButton *levelButton;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property ( nonatomic ) UserModel * userModel; 
- (IBAction)singOutBtnPressed:(id)sender;
-(void) addCloseWindow;
- (IBAction)settingBtnPressed:(id)sender;
- (IBAction)likesBtnPressed:(id)sender;
- (IBAction)notificationBtnPressed:(id)sender;
- (IBAction)sharesBtnPressed:(id)sender;
@end
