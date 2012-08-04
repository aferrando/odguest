//
//  LoginViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import "RegisterViewController.h"
#import "Utilities.h"
#import "UserModel.h"
#import "ActionSheetPicker.h"
#import "YRDropdownView.h"

@implementation RegisterViewController

@synthesize delegate, userModel, usernameTextField, passwordTextField,rePasswordTextField, birthdateButton, genderButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.userModel = [UserModel sharedUser];
    delegate = nil;
    _autoFirstResponder = YES;
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [usernameTextField setPlaceholder:NSLocalizedString(@"usernameKey",@"username")];
    [passwordTextField setPlaceholder:NSLocalizedString(@"passwordKey",@"password")];
    [rePasswordTextField setPlaceholder:NSLocalizedString(@"retypePasswordKey",@"retype password")];
    [birthTextField setPlaceholder:NSLocalizedString(@"birthdateLblKey",@"Birthdate (optional)")];
    [genderTextField setPlaceholder:NSLocalizedString(@"genderLblKey",@"Gender (optional)")];
   [registerButton setTitle:NSLocalizedString(@"registerBtnKey",@"Sign Up") forState:UIControlStateNormal];
    [cancelButton setTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") forState:UIControlStateNormal];
    [self.navigationItem setTitle:@"Register"];
   
}


- (void)viewDidUnload
{
  [super viewDidUnload];
}
- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void ) releaseTextFieldsKeyboard
{
  for (UIView* view in self.view.subviews)
  {
		if ( ([view isKindOfClass:[UITextField class]]) && ([view isFirstResponder]) )
			[view resignFirstResponder];
  }
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  _autoFirstResponder = YES;
  [self resignFirstResponder];
  if ( _autoFirstResponder )
  {
    //[self releaseTextFieldsKeyboard]; 
    if ( textField.tag == 1 ) {
      [passwordTextField becomeFirstResponder];
      return NO;
    }
    else if ( textField.tag == 2 )
    {
      [rePasswordTextField becomeFirstResponder];
      return NO;
    }
  }
  return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark -

- (void) addObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(userDataWasRegistered)
                                               name:(NSString *)kUserRegisteredNotification
                                             object:userModel];
}


- (void) userDataWasRegistered
{
 /* [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"userCreatedTitleKey", @"User created !")
                               message:nil
                              delegate:self
                     cancelButtonTitle:NSLocalizedString(@"OkBtnKey", @"Ok")
                     otherButtonTitles:nil] show]; //TODO: Language;*/
    [YRDropdownView showDropdownInView:self.view
                                 title:@"Important" 
                                detail:NSLocalizedString(@"userCreatedTitleKey", @"User created !")
                                 image:nil
                              animated:YES
                             hideAfter:3.0 type:1];

    
    
  [delegate registrationDidFinish];
}


- (void) birthdateWasSelected:(NSDate *)birthdate
{
  [userModel setBirthDate:birthdate];
  birthTextField.text = [userModel stringFromBirthdate];
}


-(void) genderWasSelected:(NSNumber *)index
{
  NSString * gender = nil;
  if ([index integerValue] == 0)
    gender = NSLocalizedString(@"maleKey", @"male");
  else
    gender = NSLocalizedString(@"femaleKey", @"female");
  genderTextField.text = [gender capitalizedString];
  [userModel setGender:gender];
}


- (IBAction) birthdateButtonPressed
{
  [self releaseTextFieldsKeyboard];
  [ActionSheetPicker displayActionPickerWithView:self.view
                                  datePickerMode:UIDatePickerModeDate
                                    selectedDate:userModel.birthDate
                                          target:self
                                          action:@selector(birthdateWasSelected:)
                                           title:NSLocalizedString(@"birthdateKey", @"Birthdate")];
}


- (IBAction) genderButtonWasPressed
{
  [self releaseTextFieldsKeyboard];
  [ActionSheetPicker displayActionPickerWithView:self.view
                                            data:[NSArray arrayWithObjects:NSLocalizedString(@"maleKey", @"male"), NSLocalizedString(@"femaleKey", @"female"), nil]
                                   selectedIndex:0
                                          target:self
                                          action:@selector(genderWasSelected:)
                                           title:NSLocalizedString(@"genderKey", @"Gender")];
}


- (IBAction) signUp
{
  [self resignFirstResponder];
  if ( ( [self.usernameTextField.text length] > 2 ) &&
      ( [self.passwordTextField.text length] > 4 ) &&
      ( [self.rePasswordTextField.text length] > 4 ) &&
      ( [self.passwordTextField.text isEqualToString:self.rePasswordTextField.text] ) )
  {
    [self addObserver];
    userModel.userName = self.usernameTextField.text;
    userModel.password = self.passwordTextField.text;
    [userModel signUp];
  } else {
      [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WrongUsernameTitleKey", @"") 
                                   message:NSLocalizedString(@"WrongUsernameMsgKey",@"Username must have more than 2 characters.\nPassword must have more than 4 characters.") 
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"CancelBtnKey", @"")
                         otherButtonTitles:nil] show];
  }
}


- (IBAction) cancel
{
//  [self dismissModalViewControllerAnimated:NO];
  [self.delegate registrationDidFail];
}

@end