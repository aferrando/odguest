//
//  LoginViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"
#import "UserModel.h"
#import "ActionSheetPicker.h"
#import "opendestinationAppDelegate.h"
#import "CPPickerView.h"
#import "Destination.h"
#import "DBSignupViewController.h"
#import "GlobalConstants.h"
#import "MixpanelAPI.h"

@implementation LoginViewController

@synthesize delegate,usernameTextField, passwordTextField, userModel, loginButton, 
registerButton, anonymousButton;
@synthesize permissions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      delegate = nil;
      self.userModel = [UserModel sharedUser];
      mustShowRegister = NO;
    }
    return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [usernameTextField setPlaceholder:NSLocalizedString(@"usernameKey",@"username")];
    [passwordTextField setPlaceholder:NSLocalizedString(@"passwordKey",@"password")];
    [loginButton setTitle:NSLocalizedString(@"loginBtnKey",@"Sign in") forState:UIControlStateNormal];
    [registerButton setTitle:NSLocalizedString(@"registerBtnKey",@"Sign up") forState:UIControlStateNormal];
    [anonymousButton setTitle:NSLocalizedString(@"guestBtnKey",@"Enter as guest") forState:UIControlStateNormal];
    [destinationLabel setText:NSLocalizedString(@"selectDestinationKey", @"Select Destination")];
    [destinationLabel setHidden:TRUE];
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email", nil];
    destinationsData = [[NSArray alloc] initWithObjects:@"Thyon", @"Lausanne", @"Diprotech", @"Test", @"Vail", @"Region X", @"Amusement", @"Post Reestructuració", @"Diprotech 2012", @"destination prova", @"Mountain", @"F.C. Barcelona", @"Costa Brava",@"Garrotxa", @"Engadin", @"Davos", @"Verbier", @"Vilanova",@"New vilanova", @"Vilafranca",@"UVIC",@"Anzère",@"Stop", @"Stop 2",  nil];
    
    defaultPickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(125, 18.0, 170, 40)];
    defaultPickerView.selectedItem =    [[[NSUserDefaults standardUserDefaults] objectForKey:@"destination"] integerValue]-26;

    defaultPickerView.backgroundColor = [UIColor whiteColor];
    defaultPickerView.dataSource = self;
    defaultPickerView.delegate = self;
    [defaultPickerView reloadData];
    [self.navigationItem setTitle:@"Welcome to"];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5.0;
    loginButton.layer.borderWidth = 0.5;
    loginButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [loginButton setTitle:NSLocalizedString(@"loginKey", @"Social Networks") forState:UIControlStateNormal];
    forgotPasswordBtn.layer.masksToBounds = YES;
    forgotPasswordBtn.layer.cornerRadius = 5.0;
    forgotPasswordBtn.layer.borderWidth = 0.5;
    forgotPasswordBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [forgotPasswordBtn setTitle:NSLocalizedString(@"forgotKey", @"Social Networks") forState:UIControlStateNormal];

        //If the app is a traveller app we can select among multiple destinations
    int traveller=kTraveller;
    if (traveller==1) {
        [self.view addSubview:defaultPickerView];
        [destinationLabel setHidden:FALSE];
    }
     
}


#pragma mark - CPPickerViewDataSource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 100;
}




- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%@", [destinationsData objectAtIndex:item] ];
}



#pragma mark - CPPickerViewDelegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    UserModel *user=[UserModel sharedUser];
    [user setDestinationID:item+26];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:item+26 forKey:@"destination"];
    [defaults synchronize];
}

- (void)viewDidUnload
{
    destinationLabel = nil;
    forgotPasswordBtn = nil;
  [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if ( userModel.userName ) {
    self.usernameTextField.text = userModel.userName;
  }
    defaultPickerView.selectedItem =    [[[NSUserDefaults standardUserDefaults] objectForKey:@"destination"] integerValue]-26;
    [self setTitleView];
  /*
  if ( userModel.userName )
  {
    [anonymousButton setEnabled:NO];
  } else {
    [anonymousButton setEnabled:YES];
  }
  */
}
-(void) setTitleView {
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, 30)]; 
    UILabel *welcome = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 160, 10)];
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(20, 10, 160, 20)];
    
    title.text = [[Destination sharedInstance] destinationName];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    
    welcome.text = NSLocalizedString(@"welcomeKey","");
    [welcome setTextColor:[UIColor whiteColor]];
    [welcome setFont:[UIFont boldSystemFontOfSize:10.0]];
    
    [title setBackgroundColor:[UIColor clearColor]];
    [welcome setBackgroundColor:[UIColor clearColor]];
    [title setTextAlignment:UITextAlignmentCenter];  
    [welcome setTextAlignment:UITextAlignmentCenter];  
    [myView addSubview:welcome];
    [myView addSubview:title];
    [myView setBackgroundColor:[UIColor  clearColor]];
        //   [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;

}
- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:YES];
  if ( mustShowRegister )
    [self.delegate showRegister];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void ) releaseTextFieldsKeyboard
{
  for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  if ( textField.tag == 1 ) {
      [passwordTextField becomeFirstResponder];
      return NO;
  }
	return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
  [textField resignFirstResponder];
}


# pragma mark - private methods

- (void) addObserver
{
   [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(userDataWasUpdated)
                                               name:(NSString *)kUserUpdatedNotification
                                             object:userModel];
}


- (void) userDataWasUpdated
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:(NSString *)kUserUpdatedNotification 
                                                object:userModel];
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
 if ( userModel.userID > 0 ) {
       [mixpanel setSendDeviceModel:YES];
      [mixpanel identifyUser:[NSString stringWithFormat:@"%d", userModel.userID]];
     [mixpanel setUserProperty:userModel.realName forKey:@"name"];
     [mixpanel setUserProperty:userModel.userName forKey:@"email"];

      [mixpanel track:[[NSString alloc]initWithFormat:@"Sign in successfull"]];

    [self.delegate userDidSignIn];
      [self.navigationController dismissModalViewControllerAnimated:YES];
      
  } else {
    [self.delegate userSignInFailed];
      [mixpanel setSendDeviceModel:YES];
      [mixpanel identifyUser:[[UserModel sharedUser] userName]];
      
      [mixpanel track:[[NSString alloc]initWithFormat:@"Sign in failed"]];
  }
}


- (IBAction) signIn
{
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
    [mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:[[NSString alloc]initWithFormat:@"Sign in button clicked"]];

  if ( ! self.userModel.deviceRegistered ) 
    [self.userModel deviceRegister];
  if ( ( [self.usernameTextField.text length] > 3 ) && ( [self.passwordTextField.text length] > 4) ) {
      [mixpanel identifyUser:[[UserModel sharedUser] userName]];
      
      [mixpanel track:[[NSString alloc]initWithFormat:@"Sign in correct form"]];

    self.userModel.userName = (NSString *)self.usernameTextField.text;
    self.userModel.password = (NSString *)self.passwordTextField.text;
    [self addObserver];
    [userModel signIn];
    [self releaseTextFieldsKeyboard];
  } else {
      [mixpanel identifyUser:[[UserModel sharedUser] userName]];
      
      [mixpanel track:[[NSString alloc]initWithFormat:@"Sign in wrong data"]];

    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WrongUsernameTitleKey", @"") 
                                message:NSLocalizedString(@"WrongUsernameMsgKey",@"Username must have more than 2 characters.\nPassword must have more than 4 characters.") 
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"CancelBtnKey", @"")
                      otherButtonTitles:nil] show];
  }
}


- (IBAction) signUp
{
  if ( ! self.userModel.deviceRegistered ) 
    [self.userModel deviceRegister];
  [self releaseTextFieldsKeyboard];
  mustShowRegister = YES;
    DBSignupViewController * registerVC = [[DBSignupViewController alloc] initWithNibName:@"DBSignupViewController" bundle:nil];
   // registerVC.delegate = self;
 // [self dismissModalViewControllerAnimated:NO];
    [self.navigationController pushViewController:registerVC animated:TRUE];
}


- (IBAction) guest
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
 // if ( ! self.userModel.deviceRegistered ) 
  /*  [self.userModel deviceRegister];
  self.userModel.userName = nil;
  self.userModel.password = nil;
  [self addObserver];
  [self.userModel signInAsGuest];
  [self releaseTextFieldsKeyboard];*/
}

- (IBAction)signInWithFacebook:(id)sender {
    
    if ( ! self.userModel.deviceRegistered ) 
        [self.userModel deviceRegister];
    [self.delegate signInWithFacebook];

  /*  opendestinationAppDelegate *delegateFB = (opendestinationAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegateFB facebook] isSessionValid]) {
        [[delegateFB facebook] authorize:permissions];
        [self showLoggedIn];
    } else {
        [self showLoggedIn];
    }
*/
}

- (void) registrationDidFinish{
    [self.navigationController dismissModalViewControllerAnimated:YES];
 
}
- (void) registrationDidFail{
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
}


#pragma mark -

- (IBAction) showActionSheetPicherFor:(id)sender
{
  
}



@end