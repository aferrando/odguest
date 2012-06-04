//
//  OportunityDetailViewController.m
//  opendestination
//
//  Created by David Hoyos on 14/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OportunityDetailViewController.h"
#import "OpportunityModel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "mapaViewController.h"
#import "UserModel.h"
#import "YRDropdownView.h"
#import "BlockAlertView.h"
#import "GlobalConstants.h"
#import "AwesomeMenu.h"
#import "Destination.h"
@implementation OportunityDetailViewController

@synthesize opportunity = _opportunity;
@synthesize imageView = _imageView;
@synthesize ownerImage = _ownerImage;
@synthesize interestedLbl, notInterestedLbl;
@synthesize tileController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    map = nil;
    _opportunity = nil;
    self.transition = ContentPageTransitionTypeFlip;
      
  }
  return self;
}


-(void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  //[self.backButton setHidden:NO];
    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5.0;
    _imageView.layer.borderWidth = 1.5;
    _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _ownerImage.layer.masksToBounds = YES;
    _ownerImage.layer.cornerRadius = 5.0;
    _ownerImage.layer.borderWidth = 0.5;
    _ownerImage.layer.borderColor = [[UIColor whiteColor] CGColor];
          descriptionBackgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
          buttonBackgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
    descriptionBackgroundView.layer.cornerRadius = 5.0;
    descriptionBackgroundView.layer.borderWidth = 1.5;
    descriptionBackgroundView.layer.borderColor = [[UIColor whiteColor] CGColor];
    pointsLabel.text=[NSString stringWithFormat:@"%d",[[Destination sharedInstance] getValueFrom:@"interested"]];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSpin) name:SDWebImageDownloadStartNotification object:nil];
  if ( self.opportunity ) [self reload];
   // [interestedButton setTitle:NSLocalizedString(@"interestedBtnKey", @"Add to my deals") forState:UIControlStateNormal];
   // [notInterestedButton setTitle:NSLocalizedString(@"notInterestedBtnKey", @"NotInterested") forState:UIControlStateNormal];
    if ( [self.opportunity.type isEqualToString: @"event"] ){
        [interestedButton setTitle:NSLocalizedString(@"syncAgendaKey",@"") forState:UIControlStateNormal];
    }
    _checkedImageView.hidden=YES;
    commentBarView.hidden=YES;
    if ([self.opportunity.type isEqualToString:@"deal"]){
        redeemBarVIew.hidden=NO;
        likeBarView.hidden=YES;
    }
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.font = [UIFont boldSystemFontOfSize:18];
    navLabel.textAlignment = UITextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    navLabel.text=_opportunity.title;
    self.navigationItem.title=_opportunity.title;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, HH:mm"];
    [timeLabel setText:[[NSString alloc] 
                                               initWithFormat:@"(%@ - %@)",[format stringFromDate:[_opportunity startDate] ]
                                               ,[format stringFromDate:[_opportunity endDate] ]
                                               ]];
  //  titleLabel.text = _opportunity.title;
    // Test Awesome Menu
 /*   UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
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
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];
    
	// customize menu
	/*
     menu.rotateAngle = M_PI/3;
     menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
     menu.nearRadius = 50.0f;
     */
  /*  menu.menuWholeAngle = -M_PI/3;
    menu.farRadius = 50.0f;
    menu.timeOffset = 0.01f;
 	
    menu.delegate = self;
//    [self.view addSubview:menu];
    menu.startPoint = CGPointMake(250, 440);*/
    
    //Trying MGTileMenu
    menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20., 398., 52, 52)];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    menuButton.center = CGPointMake(160, 390);
    [menuButton setImage:[UIImage imageNamed:@"icon-plus.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"bg-addbutton.png"] forState:UIControlStateNormal];
    [self.view addSubview:menuButton];
    [scoreValueLabel setText:[NSString stringWithFormat:@"%d",[_opportunity getScore]]];
#warning If points are not activated
    if (![[Destination sharedInstance] usersPoints]) {
        [pointsLabel setHidden:TRUE];
        [pointsImageView setHidden:TRUE];
        [pointsFixedLabel setHidden:TRUE];
        
    }

}

- (void)sendEasyTweet:(id)sender {
        // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    NSString *tweetContent= [NSString stringWithFormat:NSLocalizedString(@"Check %@ at %@ ",@""), _opportunity.title, @"odestination"];
        // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:tweetContent];
    
        // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                    // The cancel button was tapped.
                output = @"Tweet cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                    // The tweet was sent.
                output = @"Tweet done.";
                break;
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
        
            // Dismiss the tweet composition view controller.
        [self dismissModalViewControllerAnimated:YES];
    }];
        // Present the tweet composition view controller modally.
        //  [self.navigationController.view addSubview:tweetViewController.view animated:YES];
        // [(RootViewController *)[self.view.window rootViewController] presentModalViewController:tweetViewController animated:YES];
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
        
        [menuButton setHidden:TRUE];
    }
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


- (void)viewDidUnload
{
    _checkedImageView = nil;
    notInterestedButton = nil;
    redeemBarVIew = nil;
    likeBarView = nil;
    commentBarView = nil;
    interestedLbl = nil;
    notInterestedLbl = nil;
    ownerImage = nil;
    descriptionBackgroundView = nil;
    timeLabel = nil;
    buttonBackgroundView = nil;
    pointsLabel = nil;
    pointsImageView = nil;
    pointsLabel = nil;
    scoreValueLabel = nil;
  [super viewDidUnload];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadStartNotification object:nil];
}


#pragma mark -

- (void) setOpportunity:(OpportunityModel *)opportunity
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  _opportunity = nil;
  _opportunity = opportunity;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(reload)
                                               name:(NSString *)kOpportunityUpdatedNotification
                                             object:self.opportunity];
}


- (void) showSpin
{
  _spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [_spin setCenter:self.imageView.center];
  [_spin startAnimating];
}


- (void) removeSpin
{
  [_spin stopAnimating];
  _spin = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadStopNotification object:self];
}

- (IBAction) goBack {
        [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];
}

- (void) reload
{
  self.title = [_opportunity.name capitalizedString];

        // [self setTitleLabelForHeader];
    [self.interestedLbl setText:[NSString stringWithFormat:@"%d", _opportunity.numInterests]];
    [self.notInterestedLbl setText:[NSString stringWithFormat:@"%d", _opportunity.numNotInterests]];
    
  descriptionTextField.text = _opportunity.description;
    NSString *realname = (NSString *)[_opportunity.owner objectForKey:@"real_name"];
    if ([realname isEqualToString:@""] || [realname isEqualToString:@" "]) 
        senderLabel.text= [_opportunity.owner objectForKey:@"user_name"];
    else 
     senderLabel.text =  realname;
  if ( [[_opportunity.owner objectForKey:@"address"] isKindOfClass:[NSString class]] )
    addressLabel.text = [_opportunity.owner objectForKey:@"address"];
  
  //TODO: if ( [[_opportunity._owner objectForKey:@"phone"] isKindOfClass:[NSString class]] )
  [self.imageView setImageWithURL:[NSURL URLWithString:_opportunity.imageURL] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
    [self.ownerImage setImageWithURL:[NSURL URLWithString:_opportunity.ownerImageURL] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
  [self.view setNeedsDisplay];
  [self updateButtonTittle];
}

- (void)animateSnapshotOfView:(UIView *)view toTab:(UIViewController *)navController
{
/*    NSUInteger targetTabIndex = [self.tabBarController.viewControllers indexOfObject:navController];
    NSUInteger tabCount = [self.tabBarController.tabBar.items count];
    // AFAIK there's no API (as of iOS 4) to get the frame of a tab bar item, so guesstimate using the index and the tab bar frame.
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;*/
   // CGPoint targetPoint = CGPointMake((targetTabIndex + 0.5) * tabBarFrame.size.width / tabCount, CGRectGetMidY(tabBarFrame));
    CGPoint targetPoint = CGPointMake(310,460);
    
    targetPoint = [self.view convertPoint:targetPoint fromView:navController.view];
    
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect frame = [self.view convertRect:view.frame fromView:view.superview];
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (id)image.CGImage;
    imageLayer.opaque = NO;
    imageLayer.opacity = 0;
    imageLayer.frame = frame;
    [self.view.layer insertSublayer:imageLayer above:self.tabBarController.view.layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint startPoint = imageLayer.position;
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddCurveToPoint(path,NULL,
                          startPoint.x + 100, startPoint.y,
                          targetPoint.x, targetPoint.y - 100,
                          targetPoint.x, targetPoint.y);
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *sizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    sizeAnimation.fromValue = [NSValue valueWithCGSize:imageLayer.frame.size];
    sizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(50, 50)];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.75];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:positionAnimation, sizeAnimation, opacityAnimation, nil];
    animationGroup.duration = 1.0;
    animationGroup.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationGroup.delegate = self;
    [animationGroup setValue:imageLayer forKey:@"animatedImageLayer"];
    
    [imageLayer addAnimation:animationGroup forKey:@"animateToTab"];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        NSLog(@"ok");
        [[UserModel sharedUser] signOut];
        [self.navigationController popToRootViewControllerAnimated:YES];
        

        [self showLogin];
    }
    else
    {
        NSLog(@"cancel");
    }
}
-(void) showLogin {
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:vc];
    [navigationController.navigationBar setTintColor:kMainColor];
    [navigationController.navigationItem setTitle:NSLocalizedString(@"signInKey",@"Sign in")];
    [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
}

-(IBAction) interestedButtonPressed:(id)sender
{
    
        //If the user is not registered is not allowed to show interest and get rewarded
      if (  [(UserModel *)[UserModel sharedUser] isGuest]  )
      {
       /*   BlockAlertView *alert = [BlockAlertView alertWithTitle:NSLocalizedString(@"alertTitleKey",@"Alert") message:NSLocalizedString(@"nonRegisteredMsgKey",@"Must be registered to set your deals and add points to your profile")];
          
          [alert setCancelButtonWithTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") block:nil];*/
          
        //  UIAlertView *alert= [UIAlertView
                               UIAlertView *alert = [[UIAlertView alloc] init];
                               [alert setTitle:NSLocalizedString(@"alertTitleKey",@"Alert")];
                               [alert setMessage:NSLocalizedString(@"nonRegisteredMsgKey",@"Must be registered to set your deals and add points to your profile")];
                               [alert setDelegate:self];
                               [alert addButtonWithTitle:NSLocalizedString(@"signInKey",@"Sign in")];
                               [alert addButtonWithTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")];
                               [alert show];

  /*        [alert addButtonWithTitle:NSLocalizedString(@"signInKey",@"Sign in") block: ^{
              [self showLogin];
          }];*/
          [alert show];
      }
      else
      {
          [self animateSnapshotOfView:self.imageView toTab:(RootViewController *)[self.view.window rootViewController]];

          [self.opportunity setInterested];
          [likeBarView setHidden:YES];
          [redeemBarVIew setHidden:YES];
          [commentBarView setHidden:FALSE];
    //      sleep(2);
          [YRDropdownView showDropdownInView:[self.view.window rootViewController].view
                                       title:@"Congrats!" 
                                      detail:@"You are getting closer to your next goal"
                                       image:nil
                                    animated:YES
                                   hideAfter:2.0
                                        type:1];
         // [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];
          [self.navigationController popToRootViewControllerAnimated:YES];

       }
  
 // [self updateButtonTittle];
}


- (IBAction) showMapLocation
{
  if ( map == nil ) {
    map = [[mapaViewController alloc] init];
    map.title = self.title;
    map.opportunity = self.opportunity;
  }
  [self.view addSubview:map.view];
}

- (IBAction)notInterestedButtonPressed:(id)sender {
    [self.opportunity setNotInterested];
    [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];
    
    
}


- (void) updateButtonTittle
{
  switch (self.opportunity.status)
  {
    case OpportunityStatusPendant:
          [likeBarView setHidden:NO];
          [redeemBarVIew setHidden:YES];
          [commentBarView setHidden:YES];
      [interestedButton setHidden:NO];
          if ( [self.opportunity.type isEqualToString: @"event"] ){
              [interestedButton setTitle:NSLocalizedString(@"syncAgendaKey",@"") forState:UIControlStateNormal];
          }
      break;
    case OpportunityStatusWatched:
          [likeBarView setHidden:NO];
          [redeemBarVIew setHidden:YES];
          [commentBarView setHidden:YES];
          [interestedButton setHidden:NO];
          if ( [self.opportunity.type isEqualToString: @"event"] ){
              [interestedButton setTitle:NSLocalizedString(@"syncAgendaKey",@"") forState:UIControlStateNormal];
          }
          break;
    default:
          [likeBarView setHidden:YES];
          [redeemBarVIew setHidden:YES];
          [commentBarView setHidden:FALSE];
          break;
  }
}

- (IBAction)redeemBtnPressed:(id)sender {
}

- (void) showPoints
{
  [[UserModel sharedUser] refresh];
  _pointsSplash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_badget"]];
  
  UILabel * upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 225.0, 32.0)];
  [upperLabel setCenter:CGPointMake(150, 85)];
  upperLabel.font = [UIFont boldSystemFontOfSize:18];
  [upperLabel setMinimumFontSize:16];
  upperLabel.textColor = [UIColor whiteColor];
  upperLabel.text = NSLocalizedString(@"congratulationsMsgKey",@"Congratulations!");
  [upperLabel setTextAlignment:UITextAlignmentCenter];
  upperLabel.backgroundColor = [UIColor clearColor];
  upperLabel.numberOfLines = 1;
  [_pointsSplash addSubview:upperLabel];
  
  UILabel * pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 72.0, 72.0)];
  [pointsLabel setCenter:CGPointMake(150, 150)];
  pointsLabel.font = [UIFont boldSystemFontOfSize:58];
  pointsLabel.textColor = [UIColor whiteColor];
  pointsLabel.text = [NSString stringWithFormat:@"%d", self.opportunity.points];
  [pointsLabel setTextAlignment:UITextAlignmentCenter];
  pointsLabel.backgroundColor = [UIColor clearColor];
  pointsLabel.numberOfLines = 1;
  [_pointsSplash addSubview:pointsLabel];
  
  
  UILabel * msgLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 225.0, 22.0)];
  [msgLabel2 setCenter:CGPointMake(150, 205)];
  msgLabel2.font = [UIFont boldSystemFontOfSize:18];
  [msgLabel2 setMinimumFontSize:14];
  msgLabel2.textColor = [UIColor whiteColor];
  msgLabel2.numberOfLines = 1;
  msgLabel2.text = [NSString stringWithFormat:@"Points", self.opportunity.points];
  [msgLabel2 setTextAlignment:UITextAlignmentCenter];
  msgLabel2.backgroundColor = [UIColor clearColor];
  [_pointsSplash addSubview:msgLabel2];
  
  [self.view addSubview:_pointsSplash];
  //[_pointsSplash setContentMode:UIViewContentModeScaleAspectFill];
  [_pointsSplash setCenter:self.view.center];
  [_pointsSplash setContentScaleFactor:0.1];
  [UIView animateWithDuration:0. animations:^{[_pointsSplash setContentScaleFactor:4.0];}];

  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removePointsSplash) userInfo:nil repeats:NO];
}

- (void) removePointsSplash
{
  [_pointsSplash removeFromSuperview];
  _pointsSplash = nil;
  [self.view setNeedsDisplay];
}
#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu                 
{
	return 3;
}


- (UIImage *)imageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *images = [NSArray arrayWithObjects:
					   @"103-map", 
					   @"29-heart", 
					   @"Icon_Negative_Lleno", 
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
		return [UIImage imageNamed:@"orange_gradient"];
	} else if (tileNumber == 2) {
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
	if (tileNumber == 0 ||  tileNumber == 4) {
		return NO;
	}
	
	return YES;
}


- (void)tileMenu:(MGTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber
{
	NSLog(@"Tile %d activated (%@)", tileNumber, [self labelForTile:tileNumber inMenu:tileController]);
    switch (tileNumber) {
        case 0: //request
        {
            
        }
            break;
            
        case 1: //Map
        {
            [self interestedButtonPressed:nil];   
        }
            break;
            
        case 2: //propose
        {
        [ self notInterestedButtonPressed:nil];
        }
            break;
        case 3: //tweet
        {
        [ self sendEasyTweet:nil];
        }
            break;
            
        default:
            break;
    }
}


- (void)tileMenuDidDismiss:(MGTileMenuController *)tileMenu
{
	tileController = nil;
    [menuButton setHidden:FALSE];
}


@end