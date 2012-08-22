//
//  SelectSignInViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 7/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "SelectSignInViewController.h"
#import "DBSignupViewController.h"
#import "LoginViewController.h"
#import "GlobalConstants.h"
#import "Destination.h"
#import "UIButton+WebCache.h"
#import "SHKFacebook.h"
#import "MixpanelAPI.h"

@interface SelectSignInViewController ()

@end

@implementation SelectSignInViewController
@synthesize facebookButton;
@synthesize signupButton;
@synthesize loginButton;
@synthesize guestButton;
@synthesize facebookMessageLabel;
@synthesize signupMessageLabel;
@synthesize logoButton;
@synthesize loginMessageLabel;
@synthesize guestMessageLabel;
@synthesize alert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:background]];
    // Do any additional setup after loading the view from its nib.
    facebookButton.layer.masksToBounds = YES;
    facebookButton.layer.cornerRadius = 5.0;
    facebookButton.layer.borderWidth = 0.5;
    facebookButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [facebookButton setTitle:NSLocalizedString(@"signInWithFacebookKey", @"Social Networks") forState:UIControlStateNormal];
    signupButton.layer.masksToBounds = YES;
    signupButton.layer.cornerRadius = 5.0;
    signupButton.layer.borderWidth = 0.5;
    signupButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [signupButton setTitle:NSLocalizedString(@"signUpKey", @"Social Networks") forState:UIControlStateNormal];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5.0;
    loginButton.layer.borderWidth = 0.5;
    loginButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [loginButton setTitle:NSLocalizedString(@"loginKey", @"Social Networks") forState:UIControlStateNormal];
    [loginMessageLabel setText:NSLocalizedString(@"loginMessageKey", @"Social Networks") ];
    [guestMessageLabel setText:NSLocalizedString(@"guestMessageKey", @"Social Networks") ];
    [facebookMessageLabel setText:NSLocalizedString(@"facebookMessageKey", @"Social Networks") ];
    [signupMessageLabel setText:NSLocalizedString(@"signupMessageKey", @"Social Networks") ];
    guestButton.layer.masksToBounds = YES;
    guestButton.layer.cornerRadius = 5.0;
    guestButton.layer.borderWidth = 0.5;
    guestButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [guestButton setTitle:NSLocalizedString(@"guestKey", @"Social Networks") forState:UIControlStateNormal];
    [self.navigationController.navigationBar setHidden:YES];
    [logoButton setImageWithURL:[NSURL URLWithString:[[Destination sharedInstance] destinationImage]] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
        // [self addRandomAnnotations];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(closeWindow)
     forControlEvents:UIControlEventTouchDown];
    [button setImage:[UIImage imageNamed:@"CloseButton.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(5.0, 5.0, 25, 25);
    [button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:button];
  

}
- (void) closeWindow {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setFacebookButton:nil];
    [self setSignupButton:nil];
    [self setLoginButton:nil];
    [self setGuestButton:nil];
    [self setFacebookMessageLabel:nil];
    [self setSignupMessageLabel:nil];
    [self setLoginMessageLabel:nil];
    [self setGuestMessageLabel:nil];
    [self setLoginButton:nil];
    [self setLogoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) viewWillAppear:(BOOL)animated {
        [self.navigationController.navigationBar setHidden:YES];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kSHKFacebookUserInfo"]){
        NSDictionary *facebookUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSHKFacebookUserInfo"];
        NSLog(@"FBid-- %@", [facebookUserInfo objectForKey:@"id"]);
            //       NSLog(@"FBid-- %@",fbUseremail);
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kSHKFacebookUserInfo"]){
        NSDictionary *facebookUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSHKFacebookUserInfo"];
        NSLog(@"FBName-- %@",[facebookUserInfo objectForKey:@"name"]);
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasUpdated)
                                                 name:(NSString *)kUserUpdatedNotification
                                               object:[UserModel sharedUser]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasUpdated)
                                                 name:(NSString *)kUserRegisteredNotification
                                               object:[UserModel sharedUser]];
}


- (void) userDataWasUpdated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:(NSString *)kUserUpdatedNotification
                                                  object:[UserModel sharedUser]];
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    UserModel *userModel = [UserModel sharedUser];
    if ( userModel.userID > 0 ) {
        [mixpanel setSendDeviceModel:YES];
        [mixpanel identifyUser:[NSString stringWithFormat:@"%d", userModel.userID]];
        [mixpanel setUserProperty:userModel.realName forKey:@"name"];
        [mixpanel setUserProperty:userModel.userName forKey:@"email"];
        
        [mixpanel track:[[NSString alloc]initWithFormat:@"Sign in successfull"]];
        
        [self.navigationController dismissModalViewControllerAnimated:YES];
        
    } else {
        [self addObserver];
        [userModel signUp];
    }
}

- (IBAction)facebookBtnPressed:(id)sender {
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
        //[mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:[[NSString alloc]initWithFormat:@"Signin Facebook click"]];
    SHKSharer *fb = [[SHKFacebook alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookDone) name:@"SHKSendDidFinish" object:nil];
    [fb authorize];
}
- (void) facebookDone {
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
        //[mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:[[NSString alloc]initWithFormat:@"Facebook succesfull"]];

    NSDictionary *facebookUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSHKFacebookUserInfo"];
    NSString *fbUserName = [facebookUserInfo objectForKey:@"name"];
    NSLog(@"FB username: %@", fbUserName);
}
- (IBAction)signupButtonPressed:(id)sender {
/*    if ( ! self.userModel.deviceRegistered ) 
        [self.userModel deviceRegister];
    [self releaseTextFieldsKeyboard];
    mustShowRegister = YES;*/
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
        //[mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:@"Sign up click"];

    [self.navigationController.navigationBar setHidden:NO];
    DBSignupViewController * registerVC = [[DBSignupViewController alloc] initWithNibName:@"DBSignupViewController" bundle:nil];
        // registerVC.delegate = self;
        // [self dismissModalViewControllerAnimated:NO];
    [self.navigationController pushViewController:registerVC animated:TRUE];

}

- (IBAction)loginButtonPressed:(id)sender {
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
        //[mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:[[NSString alloc]initWithFormat:@"Signin click"]];

    [self.navigationController.navigationBar setHidden:NO];
    LoginViewController *loginVC =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:TRUE];
    
}

- (IBAction)guestButtonPressed:(id)sender {
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
        //[mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:[[NSString alloc]initWithFormat:@"Enter as Guest click"]];

    [self.navigationController dismissModalViewControllerAnimated:YES];

}


@end
