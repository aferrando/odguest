//
//  LoginViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class UserModel;

@protocol LoginViewControllerDelegate <NSObject>
  -(void) userDidSingIn;
  -(void) userSingInFailed;
  -(void) showRegister;
@end

@interface LoginViewController : UIViewController
<UITextFieldDelegate, UIAlertViewDelegate, FBRequestDelegate,
FBDialogDelegate>
{
  id<LoginViewControllerDelegate> __unsafe_unretained delegate;
  UserModel * userModel;
  @private
  BOOL mustShowRegister;
  IBOutlet UIButton * loginButton;
  IBOutlet UIButton * registerButton;
  IBOutlet UIButton * anonymousButton;
  UITextField * usernameTextField;
  UITextField * passwordTextField;
    NSArray *permissions;
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
