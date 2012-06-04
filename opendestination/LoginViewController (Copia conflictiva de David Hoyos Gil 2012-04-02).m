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
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email", nil];

}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if ( userModel.userName ) {
    self.usernameTextField.text = userModel.userName;
  }
  /*
  if ( userModel.userName )
  {
    [anonymousButton setEnabled:NO];
  } else {
    [anonymousButton setEnabled:YES];
  }
  */
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
  if ( userModel.userID > 0 ) {
    [self.delegate userDidSingIn];
  } else {
    [self.delegate userSingInFailed];
  }
}


- (IBAction) signIn
{
  if ( ! self.userModel.deviceRegistered ) 
    [self.userModel deviceRegister];
  if ( ( [self.usernameTextField.text length] > 3 ) && ( [self.passwordTextField.text length] > 4) ) {
    self.userModel.userName = (NSString *)self.usernameTextField.text;
    self.userModel.password = (NSString *)self.passwordTextField.text;
    [self addObserver];
    [userModel signIn];
    [self releaseTextFieldsKeyboard];
  } else {
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
  [self dismissModalViewControllerAnimated:NO];
}


- (IBAction) guest
{
  if ( ! self.userModel.deviceRegistered ) 
    [self.userModel deviceRegister];
  self.userModel.userName = nil;
  self.userModel.password = nil;
  [self addObserver];
  [self.userModel signInAsGuest];
  [self releaseTextFieldsKeyboard];
}

- (IBAction)signInWithFacebook:(id)sender {
    
    if ( ! self.userModel.deviceRegistered ) 
        [self.userModel deviceRegister];
    opendestinationAppDelegate *delegateFB = (opendestinationAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegateFB facebook] isSessionValid]) {
        [[delegateFB facebook] authorize:permissions];
        [self showLoggedIn];
    } else {
        [self showLoggedIn];
    }

}


#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
}


#pragma mark -

- (IBAction) showActionSheetPicherFor:(id)sender
{
  
}



#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, pic, username FROM user WHERE uid=me()", @"query",
                                   nil];
    opendestinationAppDelegate *delegateFB = (opendestinationAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegateFB facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)apiGraphUserPermissions {
    opendestinationAppDelegate *delegateFB = (opendestinationAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegateFB facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}

/**
 * Show the logged in menu
 */

- (void)showLoggedIn {
    /*   [self.navigationController setNavigationBarHidden:NO animated:NO];
     
     self.backgroundImageView.hidden = YES;
     loginButton.hidden = YES;
     self.menuTableView.hidden = NO;
     */
     [self apiFQLIMe];
    [self addObserver];
    [userModel signInAndUp];

    
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}


#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        // If basic information callback, set the UI objects to
        // display this.
        if ( ! self.userModel.deviceRegistered ) 
            [self.userModel deviceRegister];
            self.userModel.userName = [result objectForKey:@"uid"];
            self.userModel.realName =  [result objectForKey:@"name"];
     //       self.userModel.realName =  [result objectForKey:@"email"];
        self.userModel.password = @"odfacebook";
       // Get the profile image
        self.userModel.image = [result objectForKey:@"pic"];
        
        // Resize, crop the image to make sure it is square and renders
        // well on Retina display
     /*   float ratio;
        float delta;
        float px = 100; // Double the pixels of the UIImageView (to render on Retina)
        CGPoint offset;
        CGSize size = image.size;
        if (size.width > size.height) {
            ratio = px / size.width;
            delta = (ratio*size.width - ratio*size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = px / size.height;
            delta = (ratio*size.height - ratio*size.width);
            offset = CGPointMake(0, delta/2);
        }
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * size.width) + delta,
                                     (ratio * size.height) + delta);
        UIGraphicsBeginImageContext(CGSizeMake(px, px));
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();*/
        // [_user SET:imgThumb];
        // [profilePhotoImageView setImage:imgThumb];
        
        //  [self apiGraphUserPermissions];
    } else {
        // Processing permissions information
        opendestinationAppDelegate *delegateFB = (opendestinationAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegateFB setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}


@end