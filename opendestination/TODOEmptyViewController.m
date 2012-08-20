//
//  TODOEmptyViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/19/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "TODOEmptyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectSignInViewController.h"
#import "GlobalConstants.h"
#import "MixpanelAPI.h"

@interface TODOEmptyViewController ()

@end

@implementation TODOEmptyViewController
@synthesize signinButton;
@synthesize titleLabel;
@synthesize messageLabel;

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
    signinButton.layer.masksToBounds = YES;
    signinButton.layer.cornerRadius = 5.0;
    signinButton.layer.borderWidth = 1.0;
    signinButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    [signinButton setTitle:NSLocalizedString(@"signinKey", @"Social Networks") forState:UIControlStateNormal];
    
    titleLabel.text= NSLocalizedString(@"myjournalKey",@"My Journal");
    messageLabel.text= NSLocalizedString(@"myjournalMessageKey",@"My Journal");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:background]]];
    [titleLabel setTextColor:kTextColor];
    [messageLabel setTextColor:kTextColor];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSigninButton:nil];
    [self setTitleLabel:nil];
    [self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signinButtonPressed:(id)sender {
        MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
        [mixpanel setSendDeviceModel:YES];
            //[mixpanel identifyUser:[[UserModel sharedUser] userName]];
        
        [mixpanel track:[[NSString alloc]initWithFormat:@"SelectScreen click"]];
        
        SelectSignInViewController *loginVC = [[SelectSignInViewController alloc] initWithNibName:@"SelectSignInViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:loginVC];
        [navigationController.navigationBar setTintColor:kMainColor];
            //   loginVC.delegate = self;
            // LoginViewController * vc = [[LoginViewController alloc] init];
            //  [loginVC addCloseWindow];
        
        
        [[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
  
}
@end
