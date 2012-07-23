    //
    //  ProfileBarViewController.m
    //  opendestination
    //
    //  Created by Albert Ferrando on 7/4/12.
    //  Copyright (c) 2012 None. All rights reserved.
    //

#import "ProfileBarViewController.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "UIColor-Expanded.h"
#import "LoginViewController.h"
#import "GlobalConstants.h"
#import "HeaderViewController.h"
#import "RootViewController.h"
#import "CustomBadge.h"

@interface ProfileBarViewController ()

@end

@implementation ProfileBarViewController
@synthesize realnameTextField;
@synthesize imageButton;
@synthesize backgroundVIew;
@synthesize progressView;
@synthesize currentPointsLabel;
@synthesize loginButton;
@synthesize goalLabel;
@synthesize minLabel;

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
        // Do any additional setup after loading the view from its nib.
   
    [self refresh];
    
}

- (void)viewDidUnload
{
    [self setImageButton:nil];
    [self setRealnameTextField:nil];
    [self setBackgroundVIew:nil];
    [self setProgressView:nil];
    [self setCurrentPointsLabel:nil];
    [self setGoalLabel:nil];
    [self setMinLabel:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showProfile:(id)sender {
    if ([[UserModel sharedUser] isGuest]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
        [navigationController.navigationItem setTitle:NSLocalizedString(@"signInKey",@"Sign in")];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
        
    }
    else {
        HeaderViewController *vc = [[HeaderViewController alloc] initWithNibName:@"HeaderViewController" bundle:nil];
        
            //   MyDealsTableViewController *vc = [[MyDealsTableViewController alloc] init];
        [vc addCloseWindow];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
    }
    
    
}
- (void) refresh {
    UserModel *user=[UserModel sharedUser];
    realnameTextField.text=user.userName;
    realnameTextField.hidden=FALSE;
    [imageButton setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5.0;
        //  backgroundVIew.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"black_gradient@2x.png"]];
    if ([user isGuest])
        {
        realnameTextField.text=NSLocalizedString(@"signInKey",@"" );
        realnameTextField.hidden=TRUE;
        loginButton.hidden=FALSE;
        loginButton.titleLabel.text=NSLocalizedString(@"signInKey",@"" );
        }
    else {
        [self setTitle:user.realName];
        
        imageButton.layer.masksToBounds = YES;
        imageButton.layer.cornerRadius = 5.0;
        imageButton.layer.borderWidth = 1.0;
        imageButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        NSDictionary *level=[user level];
        if (( [[level objectForKey:@"range_min"]  isKindOfClass:[NSString class]] ) && ([[level objectForKey:@"range_max"] isKindOfClass:[NSString class]]))
            {
            int range_min = [[level objectForKey:@"range_min"] integerValue];
                //  if ( [[level objectForKey:@"range_max"] isKindOfClass:[NSNumber class]] )
            int range_max = [[level objectForKey:@"range_max"] integerValue];
            
            double ratio=(double) ( user.points- range_min)/(range_max-range_min);
            [self.progressView setProgressTintColor:[ UIColor colorWithHexString:[user.level objectForKey:@"color"]]];
                // [self.level setTextColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
                //  [points setText:[NSString stringWithFormat:@"%d", user.points]];
                //  [self.level setText:[level objectForKey:@"name"]];
            [self.progressView setProgress:ratio animated:TRUE];
            goalLabel.text=[NSString stringWithFormat:@"%d", range_max] ;      
            minLabel.text=[NSString stringWithFormat:@"%d", range_min] ;      
            currentPointsLabel.text=[NSString stringWithFormat:@"%d (%@)", user.points, [user.level objectForKey:@"name"]]; 
                // [self.currentPointsLabel setTextColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
            CustomBadge *customBadge2 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", user.opportunities] 
                                                           withStringColor:[UIColor whiteColor] 
                                                            withInsetColor:[UIColor greenColor] 
                                                            withBadgeFrame:YES 
                                                       withBadgeFrameColor:[UIColor whiteColor] 
                                                                 withScale:1.2
                                                               withShining:YES];
            [customBadge2 setFrame:CGRectMake(230, 15, customBadge2.frame.size.width, customBadge2.frame.size.height)];
            CustomBadge *customBadge1 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", user.notifications] 
                                                           withStringColor:[UIColor whiteColor] 
                                                            withInsetColor:[UIColor redColor] 
                                                            withBadgeFrame:YES 
                                                       withBadgeFrameColor:[UIColor whiteColor] 
                                                                 withScale:0.8
                                                               withShining:YES];
            [customBadge1 setFrame:CGRectMake(270, 15, customBadge1.frame.size.width, customBadge1.frame.size.height)];
            CustomBadge *customBadge3 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", user.notifications] 
                                                           withStringColor:[UIColor whiteColor] 
                                                            withInsetColor:[UIColor blueColor] 
                                                            withBadgeFrame:YES 
                                                       withBadgeFrameColor:[UIColor whiteColor] 
                                                                 withScale:0.8
                                                               withShining:YES];
            [customBadge3 setFrame:CGRectMake(290, 15, customBadge3.frame.size.width, customBadge3.frame.size.height)];
            [self.view addSubview:customBadge2];
            [self.view addSubview:customBadge1];
            [self.view addSubview:customBadge3];
            } 
    }
}
@end
