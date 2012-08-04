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
        NSLog(@"FBid-- %@", [facebookUserInfo objectForKey:@"email"]);
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

- (IBAction)facebookBtnPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookDone) name:@"SHKSendDidFinish" object:nil];       //  [SHKTwitter release];
    [[[SHKFacebook alloc] init] authorize];
}
- (void) facebookDone {
    NSDictionary *facebookUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSHKFacebookUserInfo"];
    NSString *fbUserName = [facebookUserInfo objectForKey:@"name"];
    NSLog(@"FB username: %@", fbUserName);
}
- (IBAction)signupButtonPressed:(id)sender {
/*    if ( ! self.userModel.deviceRegistered ) 
        [self.userModel deviceRegister];
    [self releaseTextFieldsKeyboard];
    mustShowRegister = YES;*/
    [self.navigationController.navigationBar setHidden:NO];
    DBSignupViewController * registerVC = [[DBSignupViewController alloc] initWithNibName:@"DBSignupViewController" bundle:nil];
        // registerVC.delegate = self;
        // [self dismissModalViewControllerAnimated:NO];
    [self.navigationController pushViewController:registerVC animated:TRUE];

}

- (IBAction)loginButtonPressed:(id)sender {
    [self.navigationController.navigationBar setHidden:NO];
    LoginViewController *loginVC =[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:TRUE];
    
}

- (IBAction)guestButtonPressed:(id)sender {
    [self.navigationController dismissModalViewControllerAnimated:YES];

}


@end
