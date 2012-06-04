//
//  CustomViewController.m g
//  opendestination
//
//  Created by David Hoyos on 04/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "CustomContentViewController.h"
#import "OportunitiesListViewController.h"
#import "CategoryModel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "DAReloadActivityButton.h"
#import "AwesomeMenu.h"
#import "UserModel.h"
#import "GlobalConstants.h"
#import "MyDealsTableViewController.h"
#import "Destination.h"

@implementation CustomContentViewController

@synthesize headerBackgroundImage, customView, titleLabel,
backButton, notificationsButton, transition, 
pageControl, customBadge, viewButton, progressView;
@synthesize category = _category;
@synthesize userModel = _userModel;
@synthesize tileController;
@synthesize menuButton = _menuButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.transition = ContentPageTransitionTypeCurl;
        _categoriesButtons = nil;
        _categoriesBadgets = nil;
        _categoriesLabels = nil;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark -
- (void) setCategory:(CategoryModel *)category {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategoryUpdatedNotification object:_category];
    _category = nil;
    if (category) {
        _category = category;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUser)
                                                 name:kUserUpdatedNotification
                                               object:self.userModel];
    [self setTitleLabelForHeader];
    customView.pagingEnabled = YES;
    customView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-60)];
    
    customView.clipsToBounds = YES;
    customView.showsHorizontalScrollIndicator = NO;
    //  [customView setBackgroundColor:[UIColor greenColor]];
    //  [self.view setBackgroundColor:[UIColor redColor]];
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(141, 355, 38, 36);
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled =YES;
    pageControlUsed = NO;
    [customView setDelegate:self];
    
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    DAReloadActivityButton *viewButton = [[DAReloadActivityButton alloc] init];
    [viewButton addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
    viewButton.center = CGPointMake(10, 450);
    viewButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleBottomMargin |
                                   UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleRightMargin);
    [self.view addSubview:viewButton];
    
    // Add Badges to View
    //	[self.view addSubview:customBadge];
    //   [self.view addSubview:notificationsButton];
    
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
    
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem4,  nil];
    
     _menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];
    
	// customize menu
	/*
     menu.rotateAngle = M_PI/3;
     menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
     menu.nearRadius = 50.0f;
     */
    _menu.menuWholeAngle = -M_PI/3;
    _menu.farRadius = 50.0f;
    _menu.timeOffset = 0.01f;
 	
    _menu.delegate = self;
    //    [self.view addSubview:menu];
    _menu.startPoint = CGPointMake(250, 440);
}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */

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
     [self newOportunityPressed];*/
}


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
    [self.userModel refresh];
    [tileController dismissMenu];
}

- (void) viewDidAppear:(BOOL)animated {
 //   [super viewDidAppear:animated];
    if (_category)
    {
        [viewButton startAnimating];
        [self reload];
        [viewButton stopAnimating];
        [self.category reload];
    }
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
        [UIView commitAnimations]; /*   static NSInteger previousPage = 0;
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
        [self.navigationItem setTitle:[[Destination sharedInstance] destinationName]];
    }
}

- (IBAction) goBack {
    if (self.category.categoryID == 0) { 
        [self reload];
        [self.category reload];
    }
    else {
        [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];
    }
}
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
        MyDealsTableViewController *vc = [[MyDealsTableViewController alloc] init];
        [vc addCloseWindow];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
    }
    

}
- (IBAction) buttonPressed:(id)sender {
    CategoryModel * cat = [self.category.sons objectAtIndex:(NSUInteger)[(UIButton *)sender tag]];
    //  UIViewController * vc = nil;
    if ( ( cat.numOpportunities > 0) && ([cat.sons count] > 0) ) {
        CustomContentViewController * detail = [[CustomContentViewController alloc] init];
        [detail setCategory:cat];
        
        [self.navigationController pushViewController:detail animated:YES];
    } else if (cat.numOpportunities > 0 ) {
        OportunitiesListViewController * detail = [[OportunitiesListViewController alloc] init];
        [detail setCategory:cat];
        
        [self.navigationController pushViewController:detail animated:YES];
    } else {
        return;
    }
}

- (IBAction)notificationButtonPressed:(id)sender {
    
    NSLog(@"Notifications Pressed!");
}

- (void) reload {
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
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 70., 70.)];
            UILabel *bdgt = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 30., 30.)];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 98., 22.)];
            [btn setImageWithURL:[NSURL URLWithString:cat.iconURL] placeholderImage:[UIImage imageNamed:@"mistery_icon.png"]];
            [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:(NSInteger)i];
            //if the category has 0 opportunities set Enabled FALSE
            if( cat.numOpportunities == 0) [btn setEnabled:false];
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
            
            [customBadge2 setFrame:CGRectMake(230, 25, customBadge2.frame.size.width, customBadge2.frame.size.height)];
            
            
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
            [_categoriesBadgets addObject:customBadge2];
            [lbl setBackgroundColor:[UIColor clearColor]];
            [lbl setTextColor:[UIColor whiteColor]];
            [lbl setShadowColor:[UIColor blackColor]];
            
            [lbl setFont:[UIFont systemFontOfSize:12]];
            [lbl setMinimumFontSize:12];
            [lbl setTextAlignment:UITextAlignmentCenter];
            [lbl setText:cat.name];
            [lbl setTag:(NSInteger)i];
            //if the category has 0 opportunities set Enabled FALSE
            if( cat.numOpportunities == 0) [lbl setTextColor:[UIColor grayColor]];
            [_categoriesLabels addObject:lbl];
        }
        [self showCategories];
    }
}


#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu
{
	return 5;
}


- (UIImage *)imageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *images = [NSArray arrayWithObjects:
					   @"twitter", 
					   @"103-map", 
					   @"speech", 
					   @"Icon_Wish", 
					   @"Icon_Share", 
					   @"actions", 
					   @"Text", 
					   @"heart", 
					   @"gear", 
					   nil];
	if (tileNumber >= 0 && tileNumber < images.count) {
		return [UIImage imageNamed:[images objectAtIndex:tileNumber]];
	}
	
	return [UIImage imageNamed:@"Text"];
}


- (NSString *)labelForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *labels = [NSArray arrayWithObjects:
					   @"Twitter", 
					   @"Key", 
					   @"Speech balloon", 
					   @"Magnifying glass", 
					   @"Scissors", 
					   @"Actions", 
					   @"Text", 
					   @"Heart", 
					   @"Settings", 
					   nil];
	if (tileNumber >= 0 && tileNumber < labels.count) {
		return [labels objectAtIndex:tileNumber];
	}
	
	return @"Tile";
}


- (NSString *)descriptionForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *hints = [NSArray arrayWithObjects:
                      @"Sends a tweet", 
                      @"Unlock something", 
                      @"Sends a message", 
                      @"Zooms in", 
                      @"Cuts something", 
                      @"Shows export options", 
                      @"Adds some text", 
                      @"Marks something as a favourite", 
                      @"Shows some settings", 
                      nil];
	if (tileNumber >= 0 && tileNumber < hints.count) {
		return [hints objectAtIndex:tileNumber];
	}
	
	return @"It's a tile button!";
}


- (UIImage *)backgroundImageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 1) {
		return [UIImage imageNamed:@"purple_gradient"];
	} else if (tileNumber == 4) {
		return [UIImage imageNamed:@"orange_gradient"];
	} else if (tileNumber == 7) {
		return [UIImage imageNamed:@"red_gradient"];
	} else if (tileNumber == 5) {
		return [UIImage imageNamed:@"yellow_gradient"];
	} else if (tileNumber == 8) {
		return [UIImage imageNamed:@"green_gradient"];
	} else if (tileNumber == -1) {
		return [UIImage imageNamed:@"grey_gradient"];
	}
	
	return [UIImage imageNamed:@"blue_gradient"];
}


- (BOOL)isTileEnabled:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 0 || tileNumber == 2 || tileNumber == 3) {
		return NO;
	}
	
	return YES;
}


- (void)tileMenu:(MGTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber
{
	NSLog(@"Tile %d activated (%@)", tileNumber, [self labelForTile:tileNumber inMenu:tileController]);
    
}


- (void)tileMenuDidDismiss:(MGTileMenuController *)tileMenu
{
	tileController = nil;
}



- (void) reloadPointsProgress {
    [UIView animateWithDuration:1.0 animations:^{
        [self.progressView setFrame:CGRectMake(self.progressView.frame.origin.x,self.progressView.frame.origin.y,
                                               1.0 + ( 210.0 * ( self.userModel.points / (self.userModel.goal==0?1.0:self.userModel.goal) ) ),
                                               self.progressView.frame.size.height)];
    }];
}

- (void) reloadUser {
    [self showCategories];
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
        if (_category.categoryID==0) {
            nn = [_categoriesButtons count]+1;
            
        } 
        pageControl.numberOfPages = ((nn-1)/9)+1;
        pageControl.currentPage = 0;
        NSLog(@"Categories:%d, Num of pages:%u",nn, pageControl.numberOfPages);
        customView.contentSize = CGSizeMake(self.view.frame.size.width * pageControl.numberOfPages, self.view.frame.size.height-60);
        
        NSUInteger n=nn;
        CGFloat lines = 1.0;
        CGFloat row_max = 1.0;
        CGFloat inset = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height - 60;
        CGFloat row_width = 0.0;
        CGFloat row_height = 0.0;
        if (nn>9) n=9;
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
                //  pageControl.currentPage=pageControl.currentPage+1;
                line=1;
            }
            if (_category.categoryID==0) {
                if (i==0) {
                    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 80., 80.)];
                    [btn setImageWithURL:[NSURL URLWithString:[self.userModel image]] placeholderImage:[UIImage imageNamed:@"photo_default.png.png"]];

                    btn.layer.cornerRadius = 5.0;
                    btn.layer.borderWidth = 1.0;
                    btn.layer.borderColor = [[UIColor whiteColor] CGColor];

                    
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
                    
                    progressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] ;
                    [progressView setProgress:10.0];
                    [progressView setFrame:CGRectMake(19, 85, 65, 3)];
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
                    [lbl setBackgroundColor:[UIColor clearColor]];
                    [lbl setTextColor:[UIColor whiteColor]];
                    [lbl setShadowColor:[UIColor blackColor]];
                    
                    [lbl setFont:[UIFont boldSystemFontOfSize:12]];
                    [lbl setMinimumFontSize:12];
                    [lbl setTextAlignment:UITextAlignmentCenter];
                    [lbl setText:[self.userModel userName]];
                    if ([self.userModel isGuest]) [lbl setText:NSLocalizedString(@"signInKey",@"Sign in")];
                                       
                    
                    
                    
                    ///
                    btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0))+(320*(i/9)),floorf(inset+((line*row_height)-(row_height/2))));
                 //   lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 4 + 11);
                    [customView addSubview:btn];
                    if (![self.userModel isGuest]) {
                    [customView addSubview:customBadge2];
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
            }
            else {
                UIButton * btn = [_categoriesButtons objectAtIndex:i];
                UIButton * bdgt = [_categoriesBadgets objectAtIndex:i];
                UIButton * lbl = [_categoriesLabels objectAtIndex:i];
                btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0))+(320*(i/9)),floorf(inset+((line*row_height)-(row_height/2))));
                bdgt.center = CGPointMake(btn.frame.origin.x + btn.frame.size.width,btn.frame.origin.y );
                lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 4 + 11);
                [customView addSubview:btn];
                [customView addSubview:bdgt];
                [customView addSubview:lbl];
            }
            row=row+1.0;
        }
        [self.view addSubview:customView];
        [self.view addSubview:pageControl];
        // Test Awesome Menu
/*        UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
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
        
        AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];
        
        // customize menu
        
         menu.rotateAngle = M_PI/3;
         menu.timeOffset = 0.2f;
         menu.farRadius = 180.0f;
         menu.endRadius = 100.0f;
         menu.nearRadius = 50.0f;
         
 /*       menu.menuWholeAngle = -M_PI/2;
        menu.farRadius = 50.0f;
        menu.timeOffset = 0.05f;
        
        menu.delegate = self;
        UserModel *user=[UserModel sharedUser];
        
        //Only Show Menu to the users logged in
        if  ( !user.guest)
            [self.view addSubview:menu];
        else {
            registerGuest.hidden=FALSE;
        }
        menu.startPoint = CGPointMake(290, 390);*/
        viewButton = [[DAReloadActivityButton alloc] initWithFrame:CGRectMake(290  , 390, 20, 20.)];
        [viewButton addTarget:self action:@selector(animate:) forControlEvents:UIControlEventTouchUpInside];
        viewButton.center = CGPointMake(20, 390);
        viewButton.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                                       UIViewAutoresizingFlexibleBottomMargin |
                                       UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleRightMargin);
        [self.view addSubview:viewButton];
   //     [viewButton setBackgroundColor:[UIColor redColor]];
        //  [self.view setBackgroundColor:[UIColor redColor]];*/
        
        //Trying MGTileMenu
        UIButton * menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20., 398., 52, 52)];
        [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
        menuButton.center = CGPointMake(290, 390);
        [menuButton setImage:[UIImage imageNamed:@"icon-plus.png"] forState:UIControlStateNormal];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"bg-addbutton.png"] forState:UIControlStateNormal];
        //There is no menu in the root
       // if (_category.categoryID!=0) [self.view addSubview:menuButton];
        
        
    }
}

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
}
/*
 - (void) showCategories {
 if ([_categoriesButtons count] > 0) {
 NSUInteger n = [_categoriesButtons count];
 CGFloat lines = 1.0;
 CGFloat row_max = 1.0;
 CGFloat inset = self.headerBackgroundImage.frame.size.height;
 CGFloat w = self.view.frame.size.width;
 CGFloat h = self.view.frame.size.height - inset*2;
 CGFloat row_width = 0.0;
 CGFloat row_height = 0.0;
 if (n == 1) {
 lines = 1.;
 row_max = 1.0;
 } else if ((n%3)==0) {
 lines = floorf(n/3);
 row_max = 3.0;
 }  else if ((n%2) == 0) {
 lines = floorf(n/2);
 row_max = 2.0;
 } else {
 lines = (1.+floorf(n/3));
 row_max = 3.0;
 } 
 row_width = w/(row_max);
 row_height = h/lines;
 CGFloat line = 1.;
 CGFloat row = 1.0;
 for (NSUInteger i=0; i<n; i++) {
 if (row>(NSUInteger)row_max) {
 line=line+1.0;
 row=1.0;
 }
 UIButton * btn = [_categoriesButtons objectAtIndex:i];
 UIButton * bdgt = [_categoriesBadgets objectAtIndex:i];
 UIButton * lbl = [_categoriesLabels objectAtIndex:i];
 btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0)),floorf(inset+((line*row_height)-(row_height/2))));
 bdgt.center = CGPointMake(btn.frame.origin.x + btn.frame.size.width,btn.frame.origin.y + btn.frame.size.height);
 lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 4 + 11);
 [self.view addSubview:btn];
 [self.view addSubview:bdgt];
 [self.view addSubview:lbl];
 row=row+1.0;
 }
 }
 }*/

@end
