//
//  MyDealsDetailViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 12/26/11.
//  Copyright (c) 2011 None. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "OportunityDetailViewController.h"
#import "OpportunityModel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "mapaViewController.h"
#import "UserModel.h"
#import "ConfirmationViewController.h"

#import "MyDealsDetailViewController.h"

@implementation MyDealsDetailViewController

@synthesize opportunity = _opportunity;
@synthesize imageView = _imageView;
@synthesize checkedImageView = _checkedImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        map = nil;
        _opportunity = nil;
   //     self.transition = ContentPageTransitionTypeFlip;
        
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
  //  [self.backButton setHidden:NO];
    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 10.0;
    _imageView.layer.borderWidth = 2.0;
    _imageView.layer.borderColor = [[UIColor colorWithRed:128 green:128 blue:100 alpha:1.0] CGColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSpin) name:SDWebImageDownloadStartNotification object:nil];
    if ( self.opportunity ) [self reload];
    // [interestedButton setTitle:NSLocalizedString(@"interestedBtnKey", @"Add to my deals") forState:UIControlStateNormal];
    // [notInterestedButton setTitle:NSLocalizedString(@"notInterestedBtnKey", @"NotInterested") forState:UIControlStateNormal];
    if ( [self.opportunity.type isEqualToString: @"event"] ){
        [interestedButton setTitle:NSLocalizedString(@"syncAgendaKey",@"") forState:UIControlStateNormal];
    }
    _checkedImageView.hidden=YES;
    if ([self.opportunity.type isEqualToString:@"deal"]){
        redeemBarVIew.hidden=NO;
        likeBarView.hidden=YES;
    }
    [rateBtn setTitle:NSLocalizedString(@"rateKey",@"rate") forState:UIControlStateNormal];
    [commentBtn setTitle:NSLocalizedString(@"commentKey",@"comment") forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Back" 
                                   style:UIBarButtonItemStylePlain
                                   target:self 
                                   action:@selector(back:)];
    backButton.image=[UIImage imageNamed:@"back_btn.png"];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];    
    [self reload];
    
}
- (IBAction)back:(id)sender {
    // Your custom logic here
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload
{
    _checkedImageView = nil;
    notInterestedButton = nil;
    redeemBarVIew = nil;
    likeBarView = nil;
    redeemBtn = nil;
    rateandcommentView = nil;
    commentBtn = nil;
    rateBtn = nil;
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


- (void) reload
{
    self.title = [_opportunity.name capitalizedString];
   // [self setTitleLabelForHeader];
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

-(void) showSocialQuestion {
    ConfirmationViewController * detail = [[ConfirmationViewController alloc] init];
    //    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
    [self.navigationController presentModalViewController:detail animated:YES];
  //  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(IBAction) interestedButtonPressed:(id)sender
{
//    [self showSocialQuestion];
    [self animateSnapshotOfView:self.imageView toTab:(RootViewController *)[self.view.window rootViewController]];
    
    
    switch (self.opportunity.status) {
        case OpportunityStatusPendant:
            if (  [(UserModel *)[UserModel sharedUser] isGuest]  )
            {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitleKey",@"Alert")
                                             message:NSLocalizedString(@"nonRegisteredMsgKey",@"Must be registered to set your deals and add points to your profile") delegate:nil cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") otherButtonTitles:nil] show];
            }
            else
            {
                if ( [self.opportunity.type isEqualToString: @"deal"] )
                {
                    [(UIButton *)sender setTitle:@"Walk In" forState:UIControlStateNormal];
                }
                else if ( [self.opportunity.type isEqualToString: @"info"] )
                {
                    [(UIButton *)sender setHidden:YES];
                }
                else if ( [self.opportunity.type isEqualToString: @"event"] )
                {
                    [(UIButton *)sender setHidden:YES];
                    [self.opportunity syncEvent];
                }
                else if ( [self.opportunity.type isEqualToString: @"ticket"] )
                {
                    [(UIButton *)sender setHidden:YES];
                }
                else
                {
                    [(UIButton *)sender setHidden:YES];
                }
                self.opportunity.status = OpportunityStatusInterested;
                [self.opportunity setInterested];
                if ( self.opportunity.points > 0 )
                    [self showPoints];            
            }
            break;
        case OpportunityStatusInterested:
            if ( [self.opportunity.type isEqualToString: @"deal"] )
            {
                [self.opportunity setWalkin];
                self.opportunity.status = OpportunityStatusWalkin;
            }
            else if ( [self.opportunity.type isEqualToString: @"info"] )
            {
                
            }
            else if ( [self.opportunity.type isEqualToString: @"event"] )
            {
                
            }
            else if ( [self.opportunity.type isEqualToString: @"ticket"] )
            {
                self.opportunity.status = OpportunityStatusConsumed;
            }
            [(UIButton *)sender setHidden:YES];
            break;
        case OpportunityStatusWalkin:
            [(UIButton *)sender setHidden:YES];
            self.opportunity.status = OpportunityStatusConsumed;
            break;
        case OpportunityStatusConsumed:
            [(UIButton *)sender setHidden:YES];
            self.opportunity.status = OpportunityStatusConsumed;
            break;
        default:
            [(UIButton *)sender setHidden:YES];
            break;
    }
    [self updateButtonTittle];
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
    
    
}


- (void) updateButtonTittle
{
    switch (self.opportunity.status)
    {
        case OpportunityStatusPendant:
            [interestedButton setHidden:NO];
            if ( [self.opportunity.type isEqualToString: @"event"] ){
                [interestedButton setTitle:NSLocalizedString(@"syncAgendaKey",@"") forState:UIControlStateNormal];
            }
            break;
        default:
        case OpportunityStatusInterested:
            [notInterestedButton setHidden:YES];
            if ( [self.opportunity.type isEqualToString: @"deal"] )
            {
                [interestedButton setTitle:NSLocalizedString(@"walkInKey",@"") forState:UIControlStateNormal];
                [interestedButton setHidden:NO];
            }
            else {
                [redeemBarVIew setHidden:YES];
                [likeBarView setHidden:YES];
                [rateandcommentView setHidden:NO];
                
            }
            break;
        case OpportunityStatusWalkin:
            [redeemBtn setEnabled:FALSE];
            [redeemBtn setTitle:NSLocalizedString(@"ValidatingKey",@"validating..!") forState:UIControlStateNormal];
            [redeemBtn setImage:[UIImage imageNamed:@"34-coffee.png"] forState:UIControlStateNormal];
           break;
        case OpportunityStatusConsumed:{
            [redeemBarVIew setHidden:YES];
            [likeBarView setHidden:YES];
            [rateandcommentView setHidden:NO];
        }
            break;
        case OpportunityStatusNotInterested:
            [interestedButton setHidden:YES];
            break;
            [interestedButton setHidden:YES];
            break;
    }
}
- (IBAction)redeemBtnPressed:(id)sender {
//    [self showSocialQuestion];
    
    [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"congratulationsMsgKey",@"Congratulations!")
                                 message: NSLocalizedString(@"reedemingMsgKey",@"You just need to show up at the front desk!. Our crew is waiting for you. See you in a minute!")
                                delegate:self
                       cancelButtonTitle:NSLocalizedString(@"cancelKey",@"Cancel")
                       otherButtonTitles:NSLocalizedString(@"reedemKey",@"Redeem"), nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		// No, do something
	}
	else if (buttonIndex == 1)
	{
        //SHow alert explaining the process
        [redeemBtn setEnabled:FALSE];
        [self.opportunity setWalkin];
        [redeemBtn setTitle:NSLocalizedString(@"ValidatingKey",@"validating..!") forState:UIControlStateNormal];
        [redeemBtn setImage:[UIImage imageNamed:@"34-coffee.png"] forState:UIControlStateNormal];
	}
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


@end