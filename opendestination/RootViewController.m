    //
//  RootViewController.m
//  opendestination
//
//  Created by David Hoyos on 04/07/11.
//  Copyright 2011 Kirubs. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
//#import "HomeViewController.h"
#import "CustomContentViewController.h"
#import "UserAccountViewController.h"
#import "MyDealsTableViewController.h"
#import "ConnectTableViewController.h"
//#import "AskViewController.h"
#import "InstantDealViewController.h"
#import "Destination.h"
#import "OpportunityModel.h"
#import "UserModel.h"
#import "JSON.h"
#import "CategoryModel.h"
#import "CustomNavigationBar.h"
#import "YRDropdownView.h"
#import "opendestinationAppDelegate.h"
#import "GlobalConstants.h"
#import "AwesomeMenu.h"
#import "MyProfileViewController.h"
#import "NotificationsTableViewController.h"
#import "DDMenuController.h"
#import "LanguageTableViewController.h"
#import "UIImageView+WebCache.h"

@implementation RootViewController;
@synthesize liveBar,navBar, noSocialTabBarView, collapseView, contentView, oportunityButton, askButton, tabBarView, permissions;
@synthesize viewControllers = _viewControllers;
@synthesize createOpportunityViewController = _createOpportunityViewController;
@synthesize askOpportunityViewController = _askOpportunityViewController;
@synthesize loginViewController = _loginViewController;
@synthesize segmentedNavigation;
@synthesize collapseViewController;
@synthesize user = _user;
@synthesize destination = _destination;
@synthesize myRootViewController = _myRootViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:0];
        _user = [UserModel sharedUser];
        _destination = [Destination sharedInstance];
        if (_user.signedIn) {
            //reload destination info
            [self reload];
        } else {
            [self reload];
            [self showSignIn];
        }
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ( ( _newOportunityViewController != nil ) && ( self.oportunityButton.selected == NO ) )
    {
        // [_newOportunityViewController release];
        _newOportunityViewController = nil;
    }
    if ( ( _askOpportunityViewController != nil ) && ( self.askButton.selected == NO ) )
    {
        _askOpportunityViewController = nil;
    }
    for ( UIViewController * vc in _viewControllers )
    {
        [vc didReceiveMemoryWarning];
    }
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    //_myRootViewController = [[HomeViewController alloc] init];
    CustomContentViewController *custom=[[CustomContentViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:custom];
    
    [navigationController.navigationBar setTintColor:kMainColor];
    [_destination reload];
    
     [custom setCategory:[[CategoryModel alloc] initWithId:0]];
    
    
    // Override point for customization after application launch.
    
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navigationController];
     
    _myRootViewController = rootController;
    _myVisibleViewController = _myRootViewController;
    [self.contentView addSubview:_myRootViewController.view];
    [self.collapseViewController setDelegate:self];
    [self tabBarHidden:YES];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:background]];
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email", nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_myVisibleViewController viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (![[UserModel sharedUser] isGuest] ) {
        MyProfileViewController *leftController = [[MyProfileViewController alloc] init];
        (( DDMenuController *) _myRootViewController).leftViewController = leftController;
    }


}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_myVisibleViewController viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_myVisibleViewController viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_myVisibleViewController viewDidDisappear:animated];
}

- (void)viewDidUnload {
    tabBarVIew = nil;
    navBar = nil;
    noSocialTabBarView = nil;
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDestinationDidUpdateNotification object:nil];
    self.viewControllers = nil;
    self.segmentedNavigation = nil;
    self.collapseViewController = nil;
    self.liveBar = nil;
    self.collapseView = nil;
    self.contentView = nil;
    self.oportunityButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
/*
 - (void) pushViewController2:(UIViewController * )viewController animated:(BOOL)animated {
 [self.navigationController pushViewController:viewController animated:animated];
 }*/

- (void) tabBarHidden:(BOOL)animated {
    if (![_destination usersCanCreateOpportunities])
        [self.noSocialTabBarView setHidden:animated];
   // else
     //   [self.tabBarView setHidden:animated];
/*    if (animated)
        [self.contentView setFrame:CGRectMake(0.0,41.0,320,400)];
    else [self.contentView setFrame:CGRectMake(0.0,41.0,320,361)];*/
    
}
/*
- (void) pushViewController:(UIViewController * )viewController animated:(BOOL)animated {
    [self.viewControllers addObject:viewController];
    [_myVisibleViewController viewWillDisappear:YES];
    [viewController viewWillAppear:YES];
    void (^fin)(BOOL) = ^(BOOL test) {[[self.viewControllers objectAtIndex:[self.viewControllers count]-1] viewDidDisappear:YES];[[self.viewControllers lastObject]  viewDidAppear:YES];};
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionNone;
    if ( [(CustomContentViewController *)viewController transition] == ContentPageTransitionTypeCurl )
        options = UIViewAnimationOptionTransitionCurlUp;
    else if ( [(CustomContentViewController *)viewController transition] == ContentPageTransitionTypeFlip )
        options = UIViewAnimationOptionTransitionFlipFromLeft;
    else if ( [(CustomContentViewController *)viewController transition] == ContentPageTranistionTypeSide)
        options = UIViewAnimationOptionTransitionFlipFromLeft;
    
    [UIView transitionFromView:_myVisibleViewController.view
                        toView:viewController.view
                      duration:0.4
                       options:options
                    completion:fin];
    
    _myVisibleViewController = viewController;
    
    [self.collapseViewController.homeButton setSelected:NO];
    [self.collapseViewController.homeButton setEnabled:YES];
}

- (void) popViewControllerAnimated:(BOOL)animated {
    void (^fin)(BOOL) = ^(BOOL test) {[[self.viewControllers lastObject] viewDidDisappear:YES];[[self.viewControllers objectAtIndex:[self.viewControllers count]-1]  viewDidAppear:YES];};
    if ( [self.viewControllers count] > 0 ) {
        [_myVisibleViewController viewWillDisappear:YES];
        [[self.viewControllers objectAtIndex:[self.viewControllers count]-1] viewWillAppear:YES];
        [UIView transitionFromView:_myVisibleViewController.view
                            toView:[(UIViewController *)[_viewControllers objectAtIndex:[_viewControllers count]-2] view]
                          duration:0.4f
                           options:(UIViewAnimationOptions) (animated ? UIViewAnimationOptionTransitionCurlDown : UIViewAnimationOptionTransitionFlipFromRight)
                        completion:fin];
        [self.viewControllers removeObject:_myVisibleViewController];
        _myVisibleViewController = [self.viewControllers lastObject];
        if ( [self.viewControllers count] == 1 ) {
            [self.collapseViewController.homeButton setSelected:YES];
            //    [self.collapseViewController.homeButton setEnabled:NO];
        }
    }
}

- (void) popToRootViewControllerAnimated:(BOOL)animated {
    void (^fin)(BOOL) = ^(BOOL test) { 
        [[self.viewControllers lastObject] viewDidDisappear:YES];
        for (int i=[_viewControllers count]-1; i>0; i--) {
            [self.viewControllers removeLastObject];
        }
        [[self.viewControllers lastObject] viewDidAppear:YES];
    };
    [_myVisibleViewController viewWillDisappear:YES];
    [_myRootViewController viewWillAppear:YES];
    [UIView transitionFromView:_myVisibleViewController.view
                        toView:_myRootViewController.view
                      duration:0.4f
                       options:(UIViewAnimationOptions) (animated ? UIViewAnimationOptionTransitionCurlDown : UIViewAnimationOptionTransitionFlipFromRight)
                    completion:fin];
    _myVisibleViewController = _myRootViewController;
    [self.collapseViewController.homeButton setSelected:YES];
    //  [self.collapseViewController.homeButton setEnabled:NO]; 
}
*/


- (void) setDestinationSettings {
    NSLog(@"%@: Settings update!", [self description]);
        // _destination=[Destination sharedInstance];
#warning Users can Create Opportunities
 /*   self.oportunityButton.hidden = ![_destination usersCanCreateOpportunities];
    self.segmentedNavigation.hidden = YES;
    self.navBar.hidden=YES;
    */
    
        UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:_destination.destinationImage]];
    [self.navigationController.navigationBar.topItem setTitleView:imageView];
   
    // self.navBar.layer.contents =(id)[UIImage imageNamed:@"OD_header.png"].CGImage;
    //    [self tabBarHidden:![_destination usersCanCreateOpportunities]];
    self.noSocialTabBarView.hidden=[_destination usersCanCreateOpportunities];
   // self.tabBarView.hidden=![_destination usersCanCreateOpportunities];
    if ([[UserModel sharedUser] userID] == 0 )   {
 //       [self mustShowSignIn];
    }
    if (![_destination usersPoints]) {
     //   [self mustShowSignIn];
        self.collapseView.hidden=YES;
        self.navBar.hidden=NO;
        self.collapseViewController.progressGlobalView.hidden=YES;
        self.collapseViewController.goalCountLabel.hidden=YES;
        self.collapseViewController.pointsCountLabel.hidden=YES;
        self.collapseViewController.pointsLabel.hidden=YES;
        self.collapseViewController.pointsCountLabel.hidden=YES;
        self.collapseViewController.notificationsBtn.hidden=YES;
    }
    
   // [((* UINavigationController) _myRootViewController) setTitle:[_destination destinationName]];
    [self.navigationController setTitle:[_destination destinationName]];

 //   [_myRootViewController setTitleLabelForHeader];
}

- (IBAction) newOportunityPressed {
    //    self.collapseViewController.view.hidden = YES;
    if ([self.user isGuest])
    {
        [YRDropdownView showDropdownInView:[self.view.window rootViewController].view
                                     title:NSLocalizedString(@"NotRegisteredTitleKey", @"Not registered") 
                                    detail:NSLocalizedString(@"NotRegisterdMsgKey", @"To view the profile you must be a registered user")
                                     image:nil
                                  animated:YES
                                 hideAfter:2.0 type:2];
    }
    else
    {
        if ( [self.collapseViewController isExpanded] )
            [self.collapseViewController collapse];
        if ( self.modalViewController != nil )
            [self.modalViewController dismissModalViewControllerAnimated:YES];
        ConnectTableViewController * loginVC = [[ConnectTableViewController alloc] initWithNibName:@"ConnectTableViewController" bundle:nil];
        //    loginVC.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:loginVC];
        
        [navigationController.navigationBar setTintColor:kMainColor];
        // Get our custom nav bar
        /*      CustomNavigationBar* customNavigationBar = (CustomNavigationBar*) navigationController.navigationBar;
         
         // Set the nav bar's background
         [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"nav_bg.png"]];    if([navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
         //iOS 5 new UINavigationBar custom background
         [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics: UIBarMetricsDefault];
         } */
        //  [navigationController.navigationBar setBackgroundColor:[UIColor orangeColor]];     
        [self presentModalViewController:navigationController animated:YES];
        // [loginVC autorelease];
        
        
        /*
         if (self.oportunityButton.selected)
         {
         if (_newOportunityViewController != nil)
         {
         [UIView animateWithDuration:0.4
         animations:^{_newOportunityViewController.view.frame = CGRectMake(_newOportunityViewController.view.frame.origin.x, _newOportunityViewController.view.frame.origin.y + _newOportunityViewController.view.frame.size.height, _newOportunityViewController.view.frame.size.width,_newOportunityViewController.view.frame.size.height);}completion:^(BOOL finished){[_newOportunityViewController.view removeFromSuperview];}];
         [self.oportunityButton setSelected:NO];
         }
         self.collapseViewController.homeButton.enabled = YES;
         self.collapseViewController.view.hidden = NO;
         self.askButton.enabled= YES;
         self.collapseViewController.myPointsButton.enabled = YES;
         
         [self.oportunityButton setSelected:NO];
         }
         else
         {
         if (_newOportunityViewController == nil)
         {
         self.newOportunityViewController = [[[ConnectViewController alloc] init] autorelease];
         _newOportunityViewController.view.frame = CGRectMake(_newOportunityViewController.view.frame.origin.x,
         self.contentView.frame.size.height,
         _newOportunityViewController.view.frame.size.width,
         _newOportunityViewController.view.frame.size.height);
         }
         if (_newOportunityViewController != nil)
         {
         //[_newOportunityViewController.view removeFromSuperview];
         [self.contentView insertSubview:_newOportunityViewController.view aboveSubview:_myVisibleViewController.view];
         [UIView animateWithDuration:0.4
         animations:^{ _newOportunityViewController.view.frame = CGRectMake(_newOportunityViewController.view.frame.origin.x, _newOportunityViewController.view.frame.origin.y - _newOportunityViewController.view.frame.size.height,_newOportunityViewController.view.frame.size.width,_newOportunityViewController.view.frame.size.height);}];
         }
         self.collapseViewController.homeButton.enabled = NO;
         self.askButton.enabled= NO;
         self.collapseViewController.myPointsButton.enabled = NO;
         [self.oportunityButton setSelected:YES];
         }*/
    }
}  
/*
- (IBAction) askOpportunityPressed {
    //    self.collapseViewController.view.hidden = YES;
    if ([self.user isGuest])
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NotRegisteredKey", @"")
                                    message:NSLocalizedString(@"OnlyRegisteredMsgKey", @"") 
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"DismissBtnKey", @"")
                          otherButtonTitles:nil] show];
    }
    else
    {
        if ( [self.collapseViewController isExpanded] )
            [self.collapseViewController collapse];
        
        if ( self.modalViewController != nil )
            [self.modalViewController dismissModalViewControllerAnimated:YES];
        AskViewController * loginVC = [[AskViewController alloc] initWithNibName:@"AskViewController" bundle:nil];
        //    loginVC.delegate = self;
        // Create the navigation controller and present it modally.
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:loginVC];
        
        [self presentModalViewController:navigationController animated:YES];
        
        /*  
         if (self.askButton.selected)
         {
         if (_askOpportunityViewController != nil)
         {
         [UIView animateWithDuration:0.4
         animations:^{_askOpportunityViewController.view.frame = CGRectMake(_askOpportunityViewController.view.frame.origin.x, _askOpportunityViewController.view.frame.origin.y + _askOpportunityViewController.view.frame.size.height, _askOpportunityViewController.view.frame.size.width,_askOpportunityViewController.view.frame.size.height);}completion:^(BOOL finished){[_askOpportunityViewController.view removeFromSuperview];}];
         [self.askButton setSelected:NO];
         }
         self.collapseViewController.homeButton.enabled = YES;
         self.collapseViewController.view.hidden = NO;
         self.oportunityButton.enabled= YES;
         self.collapseViewController.myPointsButton.enabled = YES;
         
         [self.askButton setSelected:NO];
         }
         else
         {
         if (_askOpportunityViewController == nil)
         {
         self.askOpportunityViewController = [[[AskViewController alloc] init] autorelease];
         _askOpportunityViewController.view.frame = CGRectMake(_askOpportunityViewController.view.frame.origin.x,
         self.contentView.frame.size.height,
         _askOpportunityViewController.view.frame.size.width,
         _askOpportunityViewController.view.frame.size.height);
         }
         if (_askOpportunityViewController != nil)
         {
         //[_newOportunityViewController.view removeFromSuperview];
         [self presentModalViewController:_askOpportunityViewController animated:YES];
         // [self.contentView insertSubview:_askOpportunityViewController.view aboveSubview:_myVisibleViewController.view];
         [UIView animateWithDuration:0.4
         animations:^{ _askOpportunityViewController.view.frame = CGRectMake(_askOpportunityViewController.view.frame.origin.x, _askOpportunityViewController.view.frame.origin.y - _askOpportunityViewController.view.frame.size.height,_askOpportunityViewController.view.frame.size.width,_askOpportunityViewController.view.frame.size.height);}];
         }
         self.collapseViewController.homeButton.enabled = NO;
         self.collapseViewController.myPointsButton.enabled = NO;
         self.oportunityButton.enabled = NO;
         [self.askButton setSelected:YES];
         }
    }
}  */
/*
- (void) segAction:(id)sender {
    UserAccountViewController * vc = nil;
    switch ([segmentedNavigation selectedSegmentIndex]) {
        case 0:
            [self popToRootViewControllerAnimated:YES];
            break;
        case 1:
            vc = [[MyDealsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self pushViewController:vc animated:NO];
            break;
        case 2:
            //vc = [[MyDealsTableViewController alloc] initWithStyle:UITableViewStylePlain];
            vc = [[UserAccountViewController alloc] init];
            [self pushViewController:vc animated:NO];
            break;
            break;
        default:
            break;
    }
}*/

- (void) parseNotificationData:(NSDictionary*)userInfo {
    NSNumber * opp_id = nil;
    if ( (opp_id = [[userInfo valueForKey:@"aps"] valueForKey:@"opportunity_id"]) && ( [[UserModel sharedUser] signedIn]) ) {
        if ( self.modalViewController != nil ) {
            [YRDropdownView showDropdownInView:self.modalViewController.view
                                         title:@"Important" 
                                        detail:@"New notifications arrived! Check My Notifications!"
                                         image:nil
                                      animated:YES
                                     hideAfter:3.0 type:1];
            
        } else {
            InstantDealViewController * vc = [[InstantDealViewController alloc] init];
            OpportunityModel * opp = [[OpportunityModel alloc] initWithId:[opp_id integerValue]];
            [vc setOpportunity:opp];
            [self presentModalViewController:vc animated:YES];
        }
    }
}

- (void) showSignIn {
    if ( (_user.signedIn == NO ) ){
        if ( self.modalViewController != nil )
            [self.modalViewController dismissModalViewControllerAnimated:NO];
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.delegate = self;
       UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:loginVC];
        
        [navigationController.navigationBar setTintColor:kMainColor];


        [self presentModalViewController:navigationController animated:YES];
        //  [loginVC autorelease];
    }
    
}

- (void) showRegister {
    if ( _user.signedIn == NO ) {
        RegisterViewController * registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        registerVC.delegate = self;
        [self presentModalViewController:registerVC animated:NO];
        //  [registerVC autorelease];
    }
}

- (void) reload {
        //  if ( (_destination = [Destination sharedInstance] )) {
            //   [self setDestinationSettings];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDestinationSettings) name:kDestinationDidUpdateNotification object:_destination];
                    [_destination reload];
            //   }
}

#pragma mark -
-(void) mustShowSignIn {
    [self showSignIn];
}


-(void) userDidSignIn {
    [self.modalViewController dismissModalViewControllerAnimated:YES];
}

-(void) userSignInFailed {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitleKey", @"")
                                message:NSLocalizedString(@"SiginFailedMsgKey", @"") 
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"CancelBtnKey", @"")
                      otherButtonTitles:nil] show];
}
-(void) signInWithFacebook {
    opendestinationAppDelegate *delegateFB = (opendestinationAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegateFB facebook] isSessionValid]) {
        [[delegateFB facebook] authorize:permissions];
        [self showLoggedIn];
    } else {
        [self showLoggedIn];
    }
}
- (void) registrationDidFinish {
    [self.modalViewController dismissModalViewControllerAnimated:NO];
//    LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    loginVC.delegate = self;
    [self presentModalViewController:_loginViewController animated:NO];
    //  [loginVC autorelease];
}

- (void) registrationDidFail {
    self.user.signedIn = NO;
    //[self.modalViewController dismissModalViewControllerAnimated:NO];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitleKey", @"") message:NSLocalizedString(@"SingupFailedMsgKey", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"CancelBtnKey", @"") otherButtonTitles:nil] show];
}



/**
 * Show the logged in menu
 */

- (void) addObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasUpdated)
                                                 name:(NSString *)kUserUpdatedNotification
                                               object:_user];
}

- (void)showLoggedIn {
    /*   [self.navigationController setNavigationBarHidden:NO animated:NO];
     
     self.backgroundImageView.hidden = YES;
     loginButton.hidden = YES;
     self.menuTableView.hidden = NO;
     */
    [self addObserver];
    [_user signInAndUp];
    
    
}


@end