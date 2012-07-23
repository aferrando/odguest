//
//  MyProfileViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CustomContentViewController.h"
#import "LoginViewController.h"

@class UserModel;

@interface MyProfileViewController : UIViewController 
<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource,LoginViewControllerDelegate>
{
  UserModel * userModel;

  IBOutlet UIButton * detailImageButton;
    IBOutlet UILabel * detailLabel;
    IBOutlet UILabel *languageLabel;
    IBOutlet UILabel *newPasswordLabel;
    IBOutlet UILabel *retypePasswordLabel;
    IBOutlet UILabel *birthdateLabel;
    IBOutlet UILabel *genderLabel;
    IBOutlet UILabel *myDealsLabel;
    IBOutlet UILabel *myWishesLbl;
    IBOutlet UILabel *myProposalsLbl;
    IBOutlet UILabel *notificationsLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *statusImageView;
    IBOutlet UILabel *tapToCustomizeLbl;
  IBOutlet UITextField * realNameTextField;
  IBOutlet UITextField * passwordTextField;
  IBOutlet UITextField * birthdateTextField;
  IBOutlet UITextField * genderTextField;
  IBOutlet UIButton * birthdateButton;
    IBOutlet UIButton * genderButton;
    IBOutlet UIButton * languageButton;
    IBOutlet UILabel *locationLbl;
    IBOutlet UILabel *myOpportunitiiesCounterLbl;
    IBOutlet UILabel *mySharesCounterLbl;
    IBOutlet UILabel *myNotificationsCounterLbl;
    IBOutlet UILabel *myWishesCounterLbl;
    __unsafe_unretained IBOutlet UILabel *levelLabel;
     IBOutlet UIProgressView *pointsBar;
    __unsafe_unretained IBOutlet UILabel *myPointsLbl;
    __unsafe_unretained IBOutlet UIButton *mySharesButton;
    __unsafe_unretained IBOutlet UIButton *myNotificationsButton;
@private
  BOOL camRoll;
  BOOL photoTaken;
  UIImage * avatar;
  IBOutlet UITableView *menuTableView;
}
@property ( nonatomic ) UITableView * menuTableView;
@property ( nonatomic ) UIImage * avatar;
@property ( nonatomic ) IBOutlet UIProgressView *pointsBar;
- (IBAction) changeImageButtonWasPressed;
- (IBAction) birthdateButtonWasPressed;
- (IBAction) languageButtonWasPressed;
- (IBAction) genderButtonWasPressed;
-(IBAction) myDealsButtonPressed;
- (IBAction)createdButtonPressed:(id)sender;
- (IBAction)myNotificationsButtonWasPressed;
- (void) birthdateWasSelected:(NSDate *)birthdate;
- (void) genderWasSelected:(NSNumber *)index;
- (void) languageWasSelected:(NSNumber *)index;
- (void) refresh;
- (void) useCamera;
- (void) useCameraRoll;
- (IBAction)MySharesButtonPressed:(id)sender;

@end
