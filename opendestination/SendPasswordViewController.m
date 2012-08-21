//
//  SendPasswordViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/21/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "SendPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserModel.h"
#import "GlobalConstants.h"
#import "MixpanelAPI.h"

@interface SendPasswordViewController ()

@end

@implementation SendPasswordViewController
@synthesize emailTextField;
@synthesize sendpassword;
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
    emailTextField.text=[[UserModel sharedUser ] userName];
    sendpassword.layer.masksToBounds = YES;
    sendpassword.layer.cornerRadius = 5.0;
    sendpassword.layer.borderWidth = 0.5;
    sendpassword.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [sendpassword setTitle:NSLocalizedString(@"forgotKey", @"Social Networks") forState:UIControlStateNormal];
    [self setTitle:NSLocalizedString(@"forgotKey", @"Social Networks")];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setSendpassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) userDataWasUpdated
{
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
    [mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:[[NSString alloc]initWithFormat:@"Send password finished"]];
    alert = [BlockAlertView alertWithTitle:NSLocalizedString(@"alertTitleKey",@"Alert") message:NSLocalizedString(@"sendPasswordMsgKey",@"")];
    
       [alert setCancelButtonWithTitle:NSLocalizedString(@"okKey",@"Cancel") block:nil];
    
        //  UIAlertView *alert= [UIAlertView
    /*  UIAlertView *alert = [[UIAlertView alloc] init];
     [alert setTag:0];
     [alert setTitle:NSLocalizedString(@"alertTitleKey",@"Alert")];
     [alert setMessage:NSLocalizedString(@"nonRegisteredMsgKey",@"Must be registered to set your deals and add points to your profile")];
     [alert setDelegate:self];
     [alert addButtonWithTitle:NSLocalizedString(@"signInKey",@"Sign in")];
     [alert addButtonWithTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")];
     [alert show];*/
    
    /*        [alert addButtonWithTitle:NSLocalizedString(@"signInKey",@"Sign in") block: ^{
     [self showLogin];
     }];*/
    [alert show];

}

- (IBAction)sendPassword:(id)sender {
    UserModel *user=[UserModel sharedUser];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasUpdated)
                                                 name:(NSString *)kUserUpdatedNotification
                                               object:user];
    [user sendPassword:emailTextField.text];
    
}

@end
