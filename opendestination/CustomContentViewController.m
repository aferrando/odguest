    //
    //  CustomViewController.m g
    //  opendestination
    //
    //  Created by David Hoyos on 04/07/11.
    //  Copyright 2011 None. All rights reserved.
    //

#import "CustomContentViewController.h"
#import "OpportunitiesListViewController.h"
#import "CategoryModel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "DAReloadActivityButton.h"
#import "AwesomeMenu.h"
#import "UserModel.h"
#import "GlobalConstants.h"
#import "MyDealsTableViewController.h"
#import "Destination.h"
#import "HeaderViewController.h"
#import "ProfileBarViewController.h"
#import "AnonymousBarViewController.h"

#import "PistePlanViewController.h"
#import "MeteoViewController.h"
#import "MixpanelAPI.h"

    //#import "OpenSpringBoardVC.h"

@implementation CustomContentViewController

@synthesize headerBackgroundImage, customView, titleLabel,
backButton, notificationsButton, transition, 
pageControl, customBadge,  progressView, anonymousBar;
@synthesize category = _category;
@synthesize userModel = _userModel;
@synthesize destination = _destination;
    //@synthesize tileController;
@synthesize menuButton = _menuButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.transition = ContentPageTransitionTypeCurl;
        _categoriesButtons = nil;
        _categoriesBadgets = nil;
        _categoriesLabels = nil;
        _category = nil;
    }
    return self;
}

- (void)dealloc {
        //   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark -
- (void) setCategory:(CategoryModel *)category {
   /* _category=category;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];*/
        //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategoryUpdatedNotification object:_category];
          _category = nil;
     if (category) {
     _category = category;
             //     [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategoryUpdatedNotification object:_category];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
         [self.category reload];
         }
}

#pragma mark -
- (void)viewDidLoad {
        // [super viewDidLoad];
    /*    if (self.category.categoryID == 0) { 
     
     self.navigationController.navigationBar.layer.contents = (id)[UIImage 
     imageNamed:@"OD_header.png"].CGImage;
     backButton=[[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
     target:self
     action:@selector(goBack:)];
     } else {
     backButton=[[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl
     target:self
     action:@selector(goBack:)];
     [backButton setImage:[UIImage imageNamed:@"back_btn.png"] ];
     
     }*/
    self.userModel=[UserModel sharedUser];
        // [self setCategory:[[CategoryModel alloc] initWithId:0]];
        //  [self.category reload];
        //       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
        //   [self.category reload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUser)
                                                 name:kUserUpdatedNotification
                                               object:self.userModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTitleLabelForHeader) name:kDestinationDidUpdateNotification object:_destination];
       //   [[Destination sharedInstance] reload];
    
    customView.pagingEnabled = YES;
    customView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    
    customView.clipsToBounds = YES;
    customView.showsHorizontalScrollIndicator = NO;
        //  [customView setBackgroundColor:[UIColor greenColor]];
        //  [self.view setBackgroundColor:[UIColor redColor]];
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(141, 345, 38, 36);
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled =YES;
    pageControlUsed = NO;
        // [customView addSubview:[[OpenSpringBoardVC alloc] initWithNibName:@"OpenSpringBoardVC" bundle:nil].view];
           [customView setDelegate:self];
    
          [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                              target:self
                                              action:@selector(update)];
    
    /*  CALayer *capa = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]. layer;
     [capa setShadowColor: [[UIColor blackColor] CGColor]];
     [capa setShadowOpacity:0.85f];
     [capa setShadowOffset: CGSizeMake(0.0f, 1.5f)];
     [capa setShadowRadius:2.0f];  
     [capa setShouldRasterize:YES];
     
     
     //Round
     CGRect bounds = capa.bounds;
     bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
     UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds 
     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
     cornerRadii:CGSizeMake(5.0, 5.0)];
     
     CAShapeLayer *maskLayer = [CAShapeLayer layer];
     maskLayer.frame = bounds;
     maskLayer.path = maskPath.CGPath;
     
     [capa addSublayer:maskLayer];
     capa.mask = maskLayer;*/
    [self update];
}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/*
 - (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
 {
 NSLog(@"Select the index : %d",idx);
 /*  
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
 
 */
- (void)animate:(DAReloadActivityButton *)button
{
    
    if ([button isAnimating])
        {
        [button stopAnimating]; 
        }
    else
        {
        [button startAnimating];
        }
    
}
- (void) viewWillAppear:(BOOL)animated {
        //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
    
        // [super viewWillAppear:animated];
    /*    if (self.category.categoryID == 0) { 
     [self.navigationItem setTitle:@"destination"];
     backButton=[[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
     target:self
     action:@selector(goBack:)];
     UIBarButtonItem * doneButton =
     [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh        
     target:self
     action:@selector( reload ) ];
     UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
     [infoButton addTarget:self action:@selector(toggleInfo:) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *iButton = [[UIBarButtonItem alloc] initWithCustomView: infoButton];
     //       self.navigationItem.rightBarButtonItem = iButton;
     //        [self.navigationItem setLeftBarButtonItem:doneButton] ;
     [self.navigationItem setTitle:self.title];
     } else {
     backButton=[[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl
     target:self
     action:@selector(goBack:)];
     
     }
     
     [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
     */
        //  [self showCategories];
        // [self.userModel refresh];
        //  [tileController dismissMenu];
    /*  DAReloadActivityButton *viewButton2 = [[DAReloadActivityButton alloc] init];
     [viewButton2 addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
     viewButton2.center = CGPointMake(10, 450);
     viewButton2.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
     UIViewAutoresizingFlexibleBottomMargin |
     UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin);
     [self.view addSubview:viewButton2];*/
        // profileBar=[[ProfileBarViewController alloc] initWithNibName:@"ProfileBarViewController" bundle:nil];
        // profileBar.view.frame = CGRectMake(0, 365, 320, 50);
    
        //[self.view addSubview:profileBar.view];
    [self setTitleLabelForHeader];
    [self.category reload];

        // [self reload];
}

- (void) viewDidAppear:(BOOL)animated {
        //   [super viewDidAppear:animated];
    /*if (_category)
        {
        [self setCategory:[[CategoryModel alloc] initWithId:0]];
        [viewButton startAnimating];
        [self.category reload];
        [viewButton stopAnimating];
        [self reload];
        }*/
        //[self setTitleLabelForHeader];
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void) viewDidUnload {
    topToolBar = nil;
    registerGuest = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!pageControlUsed){   
        CGFloat pageWidth = scrollView.bounds.size.width;
        NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = pageNumber;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        customView.contentOffset = CGPointMake(320.0f * pageNumber, 0.0f);
        [UIView commitAnimations]; 
            /*   static NSInteger previousPage = 0;
                                    CGFloat pageWidth = scrollView.frame.size.width;
                                    float fractionalPage = scrollView.contentOffset.x / pageWidth;
                                    NSInteger page = lround(fractionalPage);
                                    if (previousPage != page) {
                                    // Page has changed
                                    // Do your thing!
                                    previousPage = page;
                                    }*/
    }
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
    pageControlUsed = YES;
    int whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    customView.contentOffset = CGPointMake(320.0f * whichPage, 0.0f);
    [UIView commitAnimations];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}
 


#pragma mark -
- (void) setTitleLabelForHeader {
    
    if ( ( self.title ) && !( [self.title isEqualToString:@""] ) )
        {
        /*   self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0,0.0,230, self.headerBackgroundImage.frame.size.height)];
         [self.titleLabel setBackgroundColor:[UIColor clearColor]];
         [self.titleLabel setText:self.title];
         [self.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
         [self.titleLabel setMinimumFontSize:12.0];
         [self.titleLabel setTextColor:[UIColor whiteColor]];
         [self.titleLabel setTextAlignment:UITextAlignmentCenter];
         [self.headerBackgroundImage addSubview:self.titleLabel];
         [self.titleLabel release];*/
            // [self.navigationBar titleLabel setText:self.title]; 
            //[self.navigationItem setTitle:((RootViewController *)[self.view.window rootViewController] getDestination .];
        } else {
            [self.navigationItem setTitle:self.category.name];
        }
    if (self.category.categoryID == 0) { 
            //  [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, 30)]; 
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, 160, 30)];
        
        title.text = [[Destination sharedInstance] destinationName];
        [title setTextColor:[UIColor whiteColor]];
        [title setFont:[UIFont boldSystemFontOfSize:20.0]];
        
        [title setBackgroundColor:[UIColor clearColor]];
        UIImageView *myImageView = [[UIImageView alloc] init];
        [myImageView setImageWithURL:[NSURL URLWithString:[[Destination sharedInstance] destinationImage]] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
        
        myImageView.frame = CGRectMake(0, 0, 130, 30); 
        myImageView.layer.cornerRadius = 5.0;
        myImageView.layer.masksToBounds = YES;
        myImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        myImageView.layer.borderWidth = 0.1;
        
        [myView addSubview:title];
        CustomBadge *customBadge2 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", self.category.numOpportunities]
                                                       withStringColor:[UIColor whiteColor]
                                                        withInsetColor:[UIColor redColor]
                                                        withBadgeFrame:YES
                                                   withBadgeFrameColor:[UIColor whiteColor]
                                                             withScale:1.3
                                                           withShining:YES];
        [customBadge2 setFrame:CGRectMake(140, -3, customBadge2.frame.size.width, customBadge2.frame.size.height)];
        [myView addSubview:customBadge2];
        [myView setBackgroundColor:[UIColor  clearColor]];
            //   [myView addSubview:myImageView];
        self.navigationItem.titleView = myView;
        
            //       [self.navigationItem setTitle:[[Destination sharedInstance] destinationName]];
    }
}
/*
 - (IBAction) goBack {
 if (self.category.categoryID == 0) { 
 [self reload];
 [self.category reload];
 }
 else {
 [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];
 }
 }*/
/*
 - (void) profilePressed:(id)sender {
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
 
 
 }*/
- (IBAction) buttonPressed:(id)sender {
	MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
    [mixpanel identifyUser:[[UserModel sharedUser] userName]];
    CategoryModel * cat = [self.category.sons objectAtIndex:(NSUInteger)[(UIButton *)sender tag]];
    
    [mixpanel track:[[NSString alloc]initWithFormat:@"Category %d click", cat.categoryID]];
        //Categories that require specific Controllers such as: PistePlan, Meteo and Snow conditions.
#warning AddCode for the PistePlan
    if ([cat.name isEqualToString:@"Trail Map"])
        {
        PistePlanViewController * piste = [[PistePlanViewController alloc] initWithNibName:@"PistePlanViewController" bundle:nil];
            // [detail setCategory:cat];
        piste.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:piste animated:YES];
        
        }
    if ([cat.name isEqualToString:@"Weather"])
        {
        MeteoViewController * piste = [[MeteoViewController alloc] initWithNibName:@"MeteoViewController" bundle:nil];
            // [detail setCategory:cat];
        piste.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:piste animated:YES];
        
        }
        //  UIViewController * vc = nil;
    if ( ( cat.numOpportunities > 0) && ([cat.sons count] > 0) ) {
        CustomContentViewController * detail = [[CustomContentViewController alloc] init];
        [detail setCategory:cat];
        [self.navigationController pushViewController:detail animated:YES];
    } else if (cat.numOpportunities > 0 ) {
        OpportunitiesListViewController * detail = [[OpportunitiesListViewController alloc] init];
        [detail setCategory:cat];
        detail.hidesBottomBarWhenPushed = YES;  
        
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        return;
    }
}
/*
 - (IBAction)notificationButtonPressed:(id)sender {
 
 NSLog(@"Notifications Pressed!");
 }*/

- (void) update {
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
    if ([[UserModel sharedUser] userName] !=nil) {
    [mixpanel identifyUser:[[UserModel sharedUser] userName]];
    [mixpanel track:[[NSString alloc]initWithFormat:@"Update %d click", self.category.categoryID]];
    }
    [self setTitleLabelForHeader];
   [self.category reload];
    
        // [self reload];
}

- (void) reload {
    if (![self.userModel isGuest]){
        
        UITabBarItem *mapTabBarItem= [[((UITabBarController *)[self.view.window rootViewController]).tabBar items] objectAtIndex:1]; // I want to desable the second tab for example (index 1)
        UITabBarItem *mapTabBarItem2= [[((UITabBarController *)[self.view.window rootViewController]).tabBar items] objectAtIndex:2]; // I want to desable
        [mapTabBarItem setEnabled:YES];
        [mapTabBarItem2 setEnabled:YES];
        [mapTabBarItem2 setTitle:[self.userModel realName]];
        ((UITabBarController *)[self.view.window rootViewController]).hidesBottomBarWhenPushed=TRUE;
    }
    [self setTitleLabelForHeader];
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    for (UIView *view in [self.customView subviews]) {
        [view removeFromSuperview];
    }
    if (_categoriesButtons != nil) {
        for (UIView * v in _categoriesButtons) {
            [v removeFromSuperview];
        }
        [_categoriesButtons removeAllObjects];
    }else{
        _categoriesButtons = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (_categoriesBadgets != nil) {
        for (UIView * v in _categoriesBadgets) {
            [v removeFromSuperview];
        }
        [_categoriesBadgets removeAllObjects];
    }else{
        _categoriesBadgets = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (_categoriesLabels != nil) {
        for (UIView * v in _categoriesLabels) {
            [v removeFromSuperview];
        }
        [_categoriesLabels removeAllObjects];
    }else{
        _categoriesLabels = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if ([_category.sons count] > 0) {
        for (NSUInteger i=0;i<[_category.sons count];i++) {
            CategoryModel *cat = [self.category.sons objectAtIndex:i];
            NSLog(@"%@",cat.name);
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., kCategoryWidth, kCategoryHeigth)];
                //  UILabel *bdgt = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 30., 30.)];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 98., 22.)];
            [btn setImageWithURL:[NSURL URLWithString:cat.iconURL] placeholderImage:[UIImage imageNamed:@"mistery_icon.png"]];
            [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:(NSInteger)i];
                //if the category has 0 opportunities and is a FOLDER set Enabled FALSE
            if( cat.numOpportunities == 0 && cat.folder) [btn setEnabled:false];
            [_categoriesButtons addObject:btn];
            CustomBadge *customBadge2 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", cat.numOpportunities] 
                                                           withStringColor:[UIColor whiteColor] 
                                                            withInsetColor:[UIColor redColor] 
                                                            withBadgeFrame:YES 
                                                       withBadgeFrameColor:[UIColor whiteColor] 
                                                                 withScale:1.0
                                                               withShining:YES];
            if (cat.numOpportunities==0) customBadge2 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", cat.numOpportunities] 
                                                                           withStringColor:[UIColor lightGrayColor] 
                                                                            withInsetColor:[UIColor darkGrayColor] 
                                                                            withBadgeFrame:YES 
                                                                       withBadgeFrameColor:[UIColor lightGrayColor] 
                                                                                 withScale:1.0
                                                                               withShining:NO];
            
            [customBadge2 setFrame:CGRectMake(210, 25, customBadge2.frame.size.width, customBadge2.frame.size.height)];
            
            
                // Add Badges to View
            /*        [cell addSubview:customBadge2];
             
             
             
             [bdgt setBackgroundColor:[UIColor orangeColor]];
             bdgt.layer.cornerRadius = 15.0;
             bdgt.layer.borderWidth = 3.0;
             bdgt.layer.borderColor = [[UIColor blackColor] CGColor];
             [bdgt setTextColor:[UIColor whiteColor]];
             [bdgt setTextAlignment:UITextAlignmentCenter];
             [bdgt setFont:[UIFont boldSystemFontOfSize:10.0]];
             [bdgt setText:[NSString stringWithFormat:@"%d",cat.numOpportunities]];
             [bdgt setTag:(NSInteger)i];
             //if the category has 0 opportunities set Enabled FALSE
             if( cat.numOpportunities == 0){ 
             [bdgt setBackgroundColor:[UIColor darkGrayColor]];
             [bdgt setTextColor:[UIColor lightGrayColor]];
             }*/
                //if (cat.folder)
                [_categoriesBadgets addObject:customBadge2];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextColor:kCategoryTextColor];
            [lbl setShadowColor:[UIColor blackColor]];
            
            [lbl setFont:[UIFont systemFontOfSize:kCategoryFontSize]];
            [lbl setMinimumFontSize:kCategoryFontSize];
            [lbl setTextAlignment:UITextAlignmentCenter];
            [lbl setText:cat.name];
            [lbl setTag:(NSInteger)i];
                //if the category has 0 opportunities set Enabled FALSE
            if( cat.numOpportunities == 0 && cat.folder) [lbl setTextColor:[UIColor grayColor]];
            [_categoriesLabels addObject:lbl];
        }
        [self showCategories];
    }

}



- (void) reloadUser {
    
        //  [profileBar refresh];
    
        // [self showCategories];
    
        //   [self reloadPointsProgress];
    
    /*
     if ( (self.userModel.realName) && (![self.userModel.realName isEqual:@""]) )
     {
     self.userNameLabel.text = self.userModel.realName;
     }
     else
     
     if ( (self.userModel.userName) && (![self.userModel.userName isEqual:@""]) )
     {
     self.userNameLabel.text = self.userModel.userName;
     self.meLabel.text = self.userModel.userName;
     }
     else
     {
     self.userNameLabel.text =NSLocalizedString(@"GuestKey", @"Guest");
     self.meLabel.text = NSLocalizedString(@"SignInKey", @"Sign In");
     }
     if ( self.userModel.image )
     {
     NSURL * url = [NSURL URLWithString:self.userModel.image];
     NSLog(@"User Image: %@", url);
     [self.userImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
     }
     self.dealsCountLabel.text = [NSString stringWithFormat:@"%d", [self.userModel opportunities]];
     self.interestsCountLabel = [NSString stringWithFormat:@"%d", [self.userModel tags]];
     [self reloadPointsProgress];
     self.pointsCountLabel.text = [NSString stringWithFormat:@"%d", [self.userModel points]];
     self.goalCountLabel.text = [NSString stringWithFormat:@"%d", [self.userModel goal]];
     [self.view setNeedsDisplay];*/
}


- (void) showCategories {
    if ([_categoriesButtons count] > 0) {
            // Init Page Control
        NSUInteger nn = [_categoriesButtons count];
        /*     if (_category.categoryID==0) {
         nn = [_categoriesButtons count]+1;
         
         } */
        pageControl.numberOfPages = ((nn-1)/kCategoryMaxPerPage)+1;
        pageControl.currentPage = 0;
        NSLog(@"Categories:%d, Num of pages:%u",nn, pageControl.numberOfPages);
        customView.contentSize = CGSizeMake(self.view.frame.size.width * pageControl.numberOfPages, self.view.frame.size.height-kCategoryFooterMargin);
        
        NSUInteger n=nn;
        CGFloat lines = 1.0;
        CGFloat row_max = 1.0;
        CGFloat inset = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height - kCategoryFooterMargin ;
        CGFloat row_width = 0.0;
        CGFloat row_height = 0.0;
        if (nn>kCategoryMaxPerPage) n=kCategoryMaxPerPage;
        if (n == 1) {
            lines = 1.;
            row_max = 1.0;
        } else if ((n%3)==0) {
            lines = floorf(n/3);
            row_max = 3.0;
        }
        /*else if ((n%2) == 0) {
         lines = floorf(n/3);
         row_max = 3.0;
         } */
        else {
            lines = (1.+floorf(n/3));
            row_max = 3.0;
        } 
        row_width = w/(row_max);
        row_height = h/lines;
        CGFloat line = 1.;
        CGFloat row = 1.0;
        for (NSUInteger i=0; i<nn; i++) {
            if (row>(NSUInteger)row_max) {
                line=line+1.0;
                row=1.0;
            }
            if (line>3.0) {
                pageControl.currentPage=pageControl.currentPage+1;
                line=1;
            }
            /* if (_category.categoryID==0) {
             if (i==0) {
             UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 80., 80.)];
             if ([self.userModel isGuest]) {
             [btn setImageWithURL:[NSURL URLWithString:[self.userModel image]] placeholderImage:[UIImage imageNamed:@"register.png"]];
             }
             else {
             [btn setImageWithURL:[NSURL URLWithString:[self.userModel image]] placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
             }
             
             btn.layer.cornerRadius = 5.0;
             btn.layer.borderWidth = 1.0;
             btn.layer.borderColor = [[UIColor whiteColor] CGColor];
             btn.layer.masksToBounds = YES;
             
             
             ///
             UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0., 98., 98., 22.)];
             [btn addTarget:self action:@selector(profilePressed:) forControlEvents:UIControlEventTouchUpInside];
             //  [btn setTag:(NSInteger)i];
             //if the category has 0 opportunities set Enabled FALSE
             CustomBadge *customBadge2 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", [self.userModel opportunities] ]
             withStringColor:[UIColor whiteColor] 
             withInsetColor:kMainColor 
             withBadgeFrame:YES 
             withBadgeFrameColor:[UIColor whiteColor] 
             withScale:1.0
             withShining:YES];
             [customBadge2 setFrame:CGRectMake(65, 12, customBadge2.frame.size.width, customBadge2.frame.size.height)];
             
             progressView=[[UIProgressView alloc] initWithFrame:CGRectMake(19, 85, 65, 3)] ;
             [progressView setProgress:1.0];
             // [progressView setFrame:CGRectMake(19, 85, 65, 3)];
             CustomBadge *customBadge3 = [CustomBadge customBadgeWithString:[[NSString alloc]initWithFormat:@"%d", [self.userModel points] ]
             withStringColor:[UIColor whiteColor] 
             withInsetColor:[UIColor darkGrayColor] 
             withBadgeFrame:YES 
             withBadgeFrameColor:[UIColor whiteColor] 
             withScale:0.7
             withShining:NO];
             [customBadge3 setFrame:CGRectMake(15, 8, customBadge3.frame.size.width, customBadge3.frame.size.height)];
             
             
             // Add Badges to View
             /*        [cell addSubview:customBadge2];
             
             
             
             [bdgt setBackgroundColor:[UIColor orangeColor]];
             bdgt.layer.cornerRadius = 15.0;
             bdgt.layer.borderWidth = 3.0;
             bdgt.layer.borderColor = [[UIColor blackColor] CGColor];
             [bdgt setTextColor:[UIColor whiteColor]];
             [bdgt setTextAlignment:UITextAlignmentCenter];
             [bdgt setFont:[UIFont boldSystemFontOfSize:10.0]];
             [bdgt setText:[NSString stringWithFormat:@"%d",cat.numOpportunities]];
             [bdgt setTag:(NSInteger)i];
             //if the category has 0 opportunities set Enabled FALSE
             if( cat.numOpportunities == 0){ 
             [bdgt setBackgroundColor:[UIColor darkGrayColor]];
             [bdgt setTextColor:[UIColor lightGrayColor]];
             }*/
            /*      [lbl setBackgroundColor:[UIColor clearColor]];
             [lbl setTextColor:[UIColor whiteColor]];
             [lbl setShadowColor:[UIColor blackColor]];
             
             [lbl setFont:[UIFont boldSystemFontOfSize:12]];
             [lbl setMinimumFontSize:12];
             [lbl setTextAlignment:UITextAlignmentCenter];
             [lbl setText:[self.userModel userName]];
             if ([self.userModel isGuest])  {
             [lbl setFont:[UIFont boldSystemFontOfSize:16]];
             [lbl setMinimumFontSize:16];
             [lbl setText:NSLocalizedString(@"signInKey",@"Sign in")];
             // [btn setTitle:NSLocalizedString(@"signInKey",@"Sign in") forState:UIControlStateNormal];
             }
             
             
             
             
             ///
             btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0))+(320*(i/9)),floorf(inset+((line*row_height)-(row_height/2))));
             //   lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 4 + 11);
             [customView addSubview:btn];
             if (![self.userModel isGuest]) {
             [customView addSubview:customBadge2];
             int range_min =0; 
             int range_max =0;
             if ( [[[self.userModel level] objectForKey:@"range_min"]  isKindOfClass:[NSNumber class]] )
             range_min = [[[self.userModel level] objectForKey:@"range_min"] integerValue];
             if ( [[[self.userModel level] objectForKey:@"range_max"] isKindOfClass:[NSNumber class]] )
             range_max = [[[self.userModel level] objectForKey:@"range_max"] integerValue];
             double ratio=0.0;
             if (range_max!=0)     
             ratio=(double) ( [self.userModel points]- range_min)/(range_max-range_min);
             [self.progressView setProgressViewStyle:UIProgressViewStyleDefault];
             [self.progressView setProgressTintColor:kMainColor];          
             [self.progressView setTrackTintColor:[UIColor darkGrayColor]];          
             [self.progressView setProgress:ratio animated:TRUE];
             if ([[Destination sharedInstance] usersPoints]) [customView addSubview:progressView];
             
             
             }
             [customView addSubview:lbl];
             }
             else {
             UIButton * btn = [_categoriesButtons objectAtIndex:i-1];
             UIButton * bdgt = [_categoriesBadgets objectAtIndex:i-1];
             UIButton * lbl = [_categoriesLabels objectAtIndex:i-1];
             btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0))+(320*(i/9)),floorf(inset+((line*row_height)-(row_height/2))));
             bdgt.center = CGPointMake(btn.frame.origin.x + btn.frame.size.width,btn.frame.origin.y );
             lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 4 + 11);
             [customView addSubview:btn];
             [customView addSubview:bdgt];
             [customView addSubview:lbl];
             }
             }*/
            else {
                CategoryModel *cat = [self.category.sons objectAtIndex:i];
                UIButton * btn = [_categoriesButtons objectAtIndex:i];
                UIButton * bdgt = [_categoriesBadgets objectAtIndex:i];
                UIButton * lbl = [_categoriesLabels objectAtIndex:i];
                btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0))+(320*(i/kCategoryMaxPerPage)),floorf(inset+((line*row_height)-(row_height/2))));
                bdgt.center = CGPointMake(btn.frame.origin.x + btn.frame.size.width,btn.frame.origin.y );
                lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 11);
                [customView addSubview:btn];
                if (cat.folder ){
                [customView addSubview:bdgt];
                }
                [customView addSubview:lbl];
            }
            row=row+1.0;
        }
        [self.view addSubview:customView];
        [self.view addSubview:pageControl];
/*
        viewButton = [[DAReloadActivityButton alloc] initWithFrame:CGRectMake(290  , 390, 20, 20.)];
        [viewButton addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
        viewButton.center = CGPointMake(40, 350);
        viewButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                       UIViewAutoresizingFlexibleBottomMargin |
                                       UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleRightMargin);
        [self.navigationController.navigationBar addSubview:viewButton];*/
            //     [viewButton setBackgroundColor:[UIColor redColor]];
            //      [self.view setBackgroundColor:[UIColor redColor]];
        /* profileBar=[[ProfileBarViewController alloc] initWithNibName:@"ProfileBarViewController" bundle:nil];
         profileBar.view.frame = CGRectMake(0, 345, 320, 50);
         //  [profileBar.view removeFromSuperview];
         if (![self.view.subviews containsObject:profileBar])
         [self.view addSubview:profileBar.view];*/
            //Trying MGTileMenu
        /*        UIButton * menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20., 398., 52, 52)];
         [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
         menuButton.center = CGPointMake(290, 390);
         [menuButton setImage:[UIImage imageNamed:@"icon-plus.png"] forState:UIControlStateNormal];
         [menuButton setBackgroundImage:[UIImage imageNamed:@"bg-addbutton.png"] forState:UIControlStateNormal];
         */
            //There is no menu in the root
            // if (_category.categoryID!=0) [self.view addSubview:menuButton];
    }  else {
        UILabel *noCategoriesLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
        noCategoriesLabel.text=NSLocalizedString(@"noCategoriesKey",  @"NO CATEGORIES AVAILABLE");
        [self.navigationController.navigationBar addSubview:noCategoriesLabel]; 
    }
    if (![self.view.subviews containsObject:anonymousBar])
        {
        if ([self.userModel isGuest]) {
            anonymousBar=[[AnonymousBarViewController alloc] initWithNibName:@"AnonymousBarViewController" bundle:nil];
            anonymousBar.view.frame = CGRectMake(0, 355, 320, 30);
            [self.view addSubview:anonymousBar.view];
        }
        }
 
}
/*
 -(void) showMenu {
 // If there isn't already a visible TileMenu, we should create one if necessary, and show it.
 if (!tileController || tileController.isVisible == NO) {
 if (!tileController) {
 // Create a tileController.
 tileController = [[MGTileMenuController alloc] initWithDelegate:self];
 tileController.dismissAfterTileActivated = NO; // to make it easier to play with in the demo app.
 }
 // Display the TileMenu.
 [tileController displayMenuCenteredOnPoint:CGPointMake(160, 470) inView:self.view];
 
 
 }
 
 }*/
@end
