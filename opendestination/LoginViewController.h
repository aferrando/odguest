//
//  LoginViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "CPPickerView.h"
#import "RegisterViewController.h"

@class UserModel;

@protocol LoginViewControllerDelegate <NSObject>
  -(void) userDidSignIn;
  -(void) userSignInFailed;
  -(void) showRegister; 
    -(void) signInWithFacebook;
@end

@interface LoginViewController : UIViewController
<UITextFieldDelegate, UIAlertViewDelegate, RegisterViewControllerDelegate, CPPickerViewDelegate, CPPickerViewDataSource>
{
  id<LoginViewControllerDelegate> __unsafe_unretained delegate;
  UserModel * userModel;
  @private
  BOOL mustShowRegister;
    IBOutlet UIButton *forgotPasswordBtn;
  IBOutlet UIButton * loginButton;
  IBOutlet UIButton * registerButton;
  IBOutlet UIButton * anonymousButton;
  UITextField * usernameTextField;
  UITextField * passwordTextField;
    NSArray *permissions;
    CPPickerView *defaultPickerView;
    NSArray *destinationsData;
    __unsafe_unretained IBOutlet UILabel *destinationLabel;

}
@property ( nonatomic, unsafe_unretained ) id<LoginViewControllerDelegate> delegate;
@property ( nonatomic ) UserModel * userModel;
@property ( nonatomic ) IBOutlet UITextField * usernameTextField;
@property ( nonatomic ) IBOutlet UITextField * passwordTextField;
@property ( nonatomic ) IBOutlet UIButton * loginButton;
@property ( nonatomic ) IBOutlet UIButton * registerButton;
@property ( nonatomic ) IBOutlet UIButton * anonymousButton;
@property (nonatomic, retain) NSArray *permissions;

- (IBAction) signIn;
- (IBAction) signUp;
- (IBAction) guest;
- (IBAction)signInWithFacebook:(id)sender;
- (void) userDataWasUpdated;

@end
