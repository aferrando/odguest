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

@implementation RootViewController;
@synthesize liveBar,navBar, noSocialTabBarView, collapseView, contentView, oportunityButton, askButton, tabBarView, permissions;
@synthesize viewControllers = _viewControllers;
@synthesize createOpportunityViewController = _createOpportunityViewController;
@synthesize askOpportunityViewController = _askOpportunityViewController;
@synthesize loginViewController = _loginViewController;
@synthesize segmentedNavigation;
@synthesize collapseViewController;
@synthesize user = _user;
@synthesize myRootViewController = _myRootViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:0];
        _user = [UserModel sharedUser];
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
   // [self.navigationItem set
   //     [navigationController.navigationBar se
    UIBarButtonItem * doneButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
     target:self
     action:@selector( doneFunc ) ];
    
    [self.navigationItem setRightBarButtonItem:doneButton] ;
    [self.navigationItem setTitle:@"test"];
    [custom setCategory:[[CategoryModel alloc] initWithId:0]];
    
    
    // Override point for customization after application launch.
    
   // FeedController *mainController = [[FeedController alloc] init];
   // UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navigationController];
   // _menuController = rootController;
    
    MyProfileViewController *leftController = [[MyProfileViewController alloc] init];
    rootController.leftViewController = leftController;
    
 //   MyDealsTableViewController *rightController = [[MyDealsTableViewController alloc] init];
 //   rootController.rightViewController = rightController;
    
//    self.window.rootViewController = rootController;
    
 //   self.window.backgroundColor = [UIColor whiteColor];

    
    _myRootViewController = rootController;
    _myVisibleViewController = _myRootViewController;
  //  [self.viewControllers addObject:_myRootViewController];
    [self.contentView addSubview:_myRootViewController.view];
  //  [self.collapseViewController.homeButton     setSelected:YES];
    //   [self.collapseViewController.homeButton     setEnabled:NO];
    // [self.collapseViewController.homeButton setHidden:YES];
    [self.collapseViewController setDelegate:self];
//    [self.segmentedNavigation addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    [self tabBarHidden:YES];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];
//    self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];
    //   self.tabBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];
    //   self.noSocialTabBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"offline_access",@"email", nil];
 // Test Awesome Menu
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"Icon_Profile+.png"];
    UIImage *likeImage = [UIImage imageNamed:@"29-heart+.png"];
    UIImage *pushImage = [UIImage imageNamed:@"40-inbox+.png"];
    UIImage *shareImage = [UIImage imageNamed:@"56-cloud+.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage 
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:likeImage 
                                                    highlightedContentImage:nil];
    
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:pushImage 
                                                    highlightedContentImage:nil];
    
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:shareImage 
                                                    highlightedContentImage:nil];
    
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4,  nil];
   
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.contentView.bounds menus:menus];
    
	// customize menu
	/*
     menu.rotateAngle = M_PI/3;
     menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
     menu.nearRadius = 50.0f;
     */
    menu.menuWholeAngle = -M_PI/2;
    menu.farRadius = 50.0f;
    menu.timeOffset = 0.1f;
 	
    menu.delegate = self;
  //  [self.contentView addSubview:menu];
    menu.startPoint = CGPointMake(290, 450);
}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    
    if (idx==0)
    {
        MyProfileViewController * vc = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor: kMainColor]; //[UIColor orangeColor]];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
        
    }
    
    if (idx==1)
    {
        MyDealsTableViewController * vc = [[MyDealsTableViewController alloc] init];
        [vc addCloseWindow];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
        
    }
    
    if (idx==2)
    {
        NotificationsTableViewController * vc = [[NotificationsTableViewController alloc] init];
        [vc addCloseWindow];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
    }
    if (idx==3)
    [self newOportunityPressed];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_myVisibleViewController viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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

- (void) setDestinationSettings {
    NSLog(@"%@: Settings update!", [self description]);
#warning Users can Create Opportunities
    self.oportunityButton.hidden = ![_destination usersCanCreateOpportunities];
    self.segmentedNavigation.hidden = YES;
    self.navBar.hidden=YES;
    
    
    UIImage *image = [UIImage imageNamed:@"OD_header.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    [self.navBar addSubview:imageView];
    
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
    if ( (_destination = [Destination sharedInstance] )) {
        [self setDestinationSettings];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDestinationSettings) name:kDestinationDidUpdateNotification object:nil];
        [_destination reload];
    }
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

#pragma mark - FBSessionDelegate Methods
- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
  //  [self showLoggedIn];
    
    opendestinationAppDelegate *delegateFB = (opendestinationAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self storeAuthData:[[delegateFB facebook] accessToken] expiresAt:[[delegateFB facebook] expirationDate]];
    [YRDropdownView showDropdownInView:[self.view.window rootViewController].view
                                 title:NSLocalizedString(@"Logged in with Facebook", @"Not registered") 
                                detail:NSLocalizedString(@"You're successfully logged into od", @"To view the profile you must be a registered user")
                                 image:nil
                              animated:YES
                             hideAfter:2.0 type:1];
    //   [pendingApiCallsController userDidGrantPermission];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    //   [pendingApiCallsController userDidNotGrantPermission];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    //    pendingApiCallsController = nil;
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    //   [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    //us  [alertView release];
    [self fbDidLogout];
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
    [self apiFQLIMe];
    [self addObserver];
    [_user signInAndUp];
    
    
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
        if ( ! _user.deviceRegistered ) 
            [_user deviceRegister];
        _user.userName = [result objectForKey:@"uid"];
        _user.realName =  [result objectForKey:@"name"];
        //       self.userModel.realName =  [result objectForKey:@"email"];
        _user.password = @"odfacebook";
        // Get the profile image
        _user.image = [result objectForKey:@"pic"];
        
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