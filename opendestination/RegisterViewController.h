//  LoginViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.

#import <UIKit/UIKit.h>

@class UserModel;

@protocol RegisterViewControllerDelegate <NSObject>
- (void) registrationDidFinish;
- (void) registrationDidFail;
@end

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
  id<RegisterViewControllerDelegate> delegate;
  UserModel * userModel;
  UITextField * usernameTextField;
  UITextField * passwordTextField;
  UITextField * rePasswordTextField;
  IBOutlet UITextField * genderTextField;
  IBOutlet UITextField * birthTextField;
  IBOutlet UIButton * registerButton;
  IBOutlet UIButton * cancelButton;
@private
  BOOL _autoFirstResponder;
}
@property ( nonatomic ) id<RegisterViewControllerDelegate> delegate;
@property ( nonatomic ) UserModel * userModel;
@property ( nonatomic ) IBOutlet UITextField * usernameTextField;
@property ( nonatomic ) IBOutlet UITextField * passwordTextField;
@property ( nonatomic ) IBOutlet UITextField * rePasswordTextField;
@property ( nonatomic ) IBOutlet UIButton * birthdateButton;
@property ( nonatomic ) IBOutlet UIButton * genderButton;

- (IBAction) birthdateButtonPressed;
- (IBAction) genderButtonWasPressed;
- (IBAction) signUp;
- (IBAction) cancel;
- (void) userDataWasRegistered;
- (void) birthdateWasSelected:(NSDate *)birthdate;
- (void) genderWasSelected:(NSNumber *)index;

@end