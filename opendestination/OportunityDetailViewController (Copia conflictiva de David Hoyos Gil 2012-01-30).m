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

@implementation OportunityDetailViewController

@synthesize opportunity = _opportunity;
@synthesize imageView = _imageView;
@synthesize checkedImageView = _checkedImageView;
@synthesize interestedLbl, notInterestedLbl;

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
  [_imageView release];
  [map release];
    [_checkedImageView release];
    [notInterestedButton release];
    [redeemBarVIew release];
    [likeBarView release];
    [commentBarView release];
    [interestedLbl release];
    [notInterestedLbl release];
  [super dealloc];
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
  [self.backButton setHidden:NO];
    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
/*  _imageView.layer.masksToBounds = YES;
  _imageView.layer.cornerRadius = 10.0;
  _imageView.layer.borderWidth = 2.0;
  _imageView.layer.borderColor = [[UIColor colorWithRed:128 green:128 blue:100 alpha:1.0] CGColor];*/
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
}


- (void)viewDidUnload
{
    [_checkedImageView release];
    _checkedImageView = nil;
    [notInterestedButton release];
    notInterestedButton = nil;
    [redeemBarVIew release];
    redeemBarVIew = nil;
    [likeBarView release];
    likeBarView = nil;
    [commentBarView release];
    commentBarView = nil;
    [interestedLbl release];
    interestedLbl = nil;
    [notInterestedLbl release];
    notInterestedLbl = nil;
  [super viewDidUnload];
  [_imageView release];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadStartNotification object:nil];
}


#pragma mark -

- (void) setOpportunity:(OpportunityModel *)opportunity
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_opportunity release];
  _opportunity = nil;
  _opportunity = [opportunity retain];
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
  [_spin release];
  _spin = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadStopNotification object:self];
}


- (void) reload
{
  self.title = [_opportunity.name capitalizedString];

  [self setTitleLabelForHeader];
    [self.interestedLbl setText:[NSString stringWithFormat:@"%d", _opportunity.numInterests]];
    [self.notInterestedLbl setText:[NSString stringWithFormat:@"%d", _opportunity.numNotInterests]];
    
  descriptionTextField.text = _opportunity.description;
  NSString * desc = ([_opportunity.owner objectForKey:@"real_name"] ?[_opportunity.owner objectForKey:@"real_name"]:[_opportunity.owner objectForKey:@"user_name"]);
  senderLabel.text =  desc;
  if ( [[_opportunity.owner objectForKey:@"address"] isKindOfClass:[NSString class]] )
    addressLabel.text = [_opportunity.owner objectForKey:@"address"];
  
  //TODO: if ( [[_opportunity._owner objectForKey:@"phone"] isKindOfClass:[NSString class]] )
  [self.imageView setImageWithURL:[NSURL URLWithString:_opportunity.imageURL] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
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



-(IBAction) interestedButtonPressed:(id)sender
{
    
    
    [self animateSnapshotOfView:self.imageView toTab:(RootViewController *)[self.view.window rootViewController]];
 
      if (  [(UserModel *)[UserModel sharedUser] isGuest]  )
      {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitleKey",@"Alert")
                                     message:NSLocalizedString(@"nonRegisteredMsgKey",@"Must be registered to set your deals and add points to your profile") delegate:nil cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") otherButtonTitles:nil] autorelease] show];
      }
      else
      {
          [self.opportunity setInterested];
          [likeBarView setHidden:YES];
          [redeemBarVIew setHidden:YES];
          [commentBarView setHidden:FALSE];
    //      sleep(2);
          [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];

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
  [_pointsSplash release];
  [pointsLabel release];
  [upperLabel release];
  [msgLabel2 release];

  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removePointsSplash) userInfo:nil repeats:NO];
}

- (void) removePointsSplash
{
  [_pointsSplash removeFromSuperview];
  _pointsSplash = nil;
  [self.view setNeedsDisplay];
}


@end