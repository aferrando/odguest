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

@class UserModel;

@interface MyProfileViewController : CustomContentViewController
<UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
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
@private
  BOOL camRoll;
  BOOL photoTaken;
  UIImage * avatar;
}
@property ( nonatomic, retain ) UIImage * avatar;
- (IBAction) changeImageButtonWasPressed;
- (IBAction) birthdateButtonWasPressed;
- (IBAction) languageButtonWasPressed;
- (IBAction) genderButtonWasPressed;
-(IBAction) myDealsButtonPressed;
- (IBAction)createdButtonPressed:(id)sender;
- (IBAction)myNotificationsButtonWasPressed;
@property (retain, nonatomic) IBOutlet UIButton *MySharesButtonPressed;

- (void) birthdateWasSelected:(NSDate *)birthdate;
- (void) genderWasSelected:(NSNumber *)index;
- (void) languageWasSelected:(NSNumber *)index;
- (void) refresh;
- (void) useCamera;
- (void) useCameraRoll;
- (IBAction)MySharesButtonPressed:(id)sender;

@end
