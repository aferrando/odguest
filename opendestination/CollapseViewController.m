//
//  CollapseViewController.m
//  opendestination
//
//  Created by David Hoyos on 06/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "CollapseViewController.h"
#import "RootViewController.h"
#import "MyProfileViewController.h"
#import "MyDealsTableViewController.h"
#import "NotificationsTableViewController.h"
#import "OportunityDetailViewController.h"
#import "UserModel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "YRDropdownView.h"
#import "GlobalConstants.h"

@interface CollapseViewController ()
- (void) showSignIn;
- (void) reloadPointsProgress;
@end


@implementation CollapseViewController


@synthesize delegate;
@synthesize isExpanded, signOutButton, homeButton, myPointsButton, notificationsBtn;
@synthesize goalCountLabel, pointsCountLabel, userNameLabel,meLabel, statusImageView, progressGlobalView, goalsLabel, pointsLabel;
@synthesize progressView, interestsLabel, interestsCountLabel, interestsButton;
@synthesize dealsLabel, dealsCountLabel, dealsButton, userImage;
@synthesize userModel = _userModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate= self;
    }
    return self;
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImage.layer.cornerRadius = 0.0;
    self.userImage.layer.borderWidth = 1.0;
    self.userImage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.userModel = [UserModel sharedUser];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:kUserUpdatedNotification
                                               object:self.userModel];
    isExpanded = NO;
    delegate = nil;
    exploreLabel.text= NSLocalizedString(@"exploreKey",@"Explore");
    connectLabel.text= NSLocalizedString(@"connectKey",@"Connect");
    requestLabel.text= NSLocalizedString(@"wishKey",@"Wish");
    myDealsLabel.text= NSLocalizedString(@"myDealsKey",@"My Deals");
    levelLabel.text= NSLocalizedString(@"levelKey",@"Level");
    goalLabel.text= NSLocalizedString(@"goalKey",@"Goal");
    pointsLabel.text= NSLocalizedString(@"pointsKey",@"Points");
    dealsLabel.text=NSLocalizedString(@"myDealsKey",@"My Deals");
    interestsLabel.text=NSLocalizedString(@"myNotificationsKey",@"My Notifications");
    [self reload];
}

- (void)viewDidUnload {
    self.homeButton = nil;
    self.myPointsButton = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewWillAppear:(BOOL)animated {
    [self reload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
- (void) collapseViewWillSwitchContentView {}
- (void) collapseViewDidSwitchContentView {}
- (void) mustShowSignIn {}

# pragma mark -
- (IBAction) signOutButtonPressed:(id)sender {
    if ( self.isExpanded ) [self collapse];
    [self showSignIn];
}

- (IBAction) dealsButtonPressed {
    [self collapse];
    if ( self.myPointsButton.selected )
    {
        
    }
    else
    {
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewWillSwitchContentView)]) )
            [delegate collapseViewWillSwitchContentView];
        [self.modalViewController dismissModalViewControllerAnimated:YES];
        //   [self.myPointsButton setSelected:YES];
        MyDealsTableViewController * vc = [[MyDealsTableViewController alloc] init];
        [vc addCloseWindow];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewDidSwitchContentView)]) )
            [delegate collapseViewDidSwitchContentView];
    }
}
- (IBAction) notificationsButtonPressed {
    [self collapse];
    if ( self.myPointsButton.selected )
    {
        
    }
    else
    {
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewWillSwitchContentView)]) )
            [delegate collapseViewWillSwitchContentView];
        
        [self.modalViewController dismissModalViewControllerAnimated:YES];
        NotificationsTableViewController * vc = [[NotificationsTableViewController alloc] init];
        [vc addCloseWindow];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
      [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewDidSwitchContentView)]) )
            [delegate collapseViewDidSwitchContentView];
    }
}




- (IBAction) homeButtonPressed {
    if (!self.homeButton.selected) {
       [self collapse];
        [(RootViewController *)[self.view.window rootViewController] popToRootViewControllerAnimated:!(self.myPointsButton.selected)];
    }
    //    if (self.homeButton.selected) {
    [self.myPointsButton setEnabled:YES];
    [self.myPointsButton setSelected:NO];
    [self.homeButton setSelected:YES];
    
}

//Profile button pressed

- (IBAction) myPointsButtonPressed {
    [self collapse];
    if ([_userModel isGuest])
    {
        [self showSignIn];
    }
    else
    {
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewWillSwitchContentView)]) )
            [delegate collapseViewWillSwitchContentView];
        
        [self.modalViewController dismissModalViewControllerAnimated:YES];
    /*    [self.myPointsButton setSelected:YES];
        [self.homeButton setEnabled:YES];
        [self.homeButton setSelected:NO];*/
        MyProfileViewController * vc = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor: kMainColor]; //[UIColor orangeColor]];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewDidSwitchContentView)]) )
            [delegate collapseViewDidSwitchContentView];
        
    } /*
       if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewDidSwitchContentView)]) )
       [delegate collapseViewDidSwitchContentView];
       }*/
}

- (IBAction) interestsButtonPressed {
    if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewWillSwitchContentView)]) )
        [delegate collapseViewWillSwitchContentView];
    /*
     if ( self.myPointsButton.selected ) {
     [self.myPointsButton setSelected:NO];
     if ( [[[(RootViewController *)[self.view.window rootViewController] viewControllers]lastObject] isKindOfClass:[OportunityDetailViewController class]]) {
     [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:NO];
     }
     [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:NO];
     } else {
     [self collapse];
     [self.myPointsButton setSelected:YES];
     UserAccountViewController * vc = [[UserAccountViewController alloc] init];
     [vc setSelectedIndex:1];
     [(RootViewController *)[self.view.window rootViewController] pushViewController:vc
     animated:NO];
     [vc release];
     }
     [delegate collapseViewDidSwitchContentView];
     */
}

- (IBAction) expandButtonPressed {
    if ([_userModel isGuest])
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
        if (isExpanded)
        {
            [self collapse];
            isExpanded = NO;
        } else {
            [self expand];
            isExpanded = YES;
        }
    }
}

- (IBAction)myDealsModalBtnPressed:(id)sender {
    [self collapse];
    if ( self.myPointsButton.selected )
    {
        [self    showSignIn];
    }
    else
    {
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewWillSwitchContentView)]) )
            [delegate collapseViewWillSwitchContentView];
        
        [self.modalViewController dismissModalViewControllerAnimated:YES];
        MyDealsTableViewController * vc = [[MyDealsTableViewController alloc] init];
        [vc addCloseWindow];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:vc];
        [navigationController.navigationBar setTintColor:kMainColor];
        [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
        if ( ([delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)]) && ([delegate respondsToSelector:@selector(collapseViewDidSwitchContentView)]) )
            [delegate collapseViewDidSwitchContentView];
    }
  
    
    
}

# pragma mark - private methods


- (void) showSignIn {
    [self.userModel signOut];
    if ( [delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)] )
        [self.delegate mustShowSignIn];
}



- (void) expand {
    [self reload];
    [self.userModel refresh];
    [UIView animateWithDuration:0.3
                     animations:^{ 
                         self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                      self.view.frame.origin.y + 115.0,
                                                      self.view.frame.size.width,
                                                      self.view.frame.size.height);
                     }];
    
}

- (void) collapse {
    if ( isExpanded) {
        [UIView animateWithDuration:0.3
                         animations:^{ 
                             self.view.frame = CGRectMake(self.view.frame.origin.x,
                                                          self.view.frame.origin.y - 115.0,
                                                          self.view.frame.size.width,
                                                          self.view.frame.size.height);
                         }];
        isExpanded = NO;
    }
}

- (void) setDealsCount:(NSInteger)countf {}

- (void) reloadPointsProgress {
    [UIView animateWithDuration:1.0 animations:^{
        [self.progressView setFrame:CGRectMake(self.progressView.frame.origin.x,self.progressView.frame.origin.y,
                                               1.0 + ( 210.0 * ( self.userModel.points / (self.userModel.goal==0?1.0:self.userModel.goal) ) ),
                                               self.progressView.frame.size.height)];
    }];
}


- (void) reload {
    /*
     if ( (self.userModel.realName) && (![self.userModel.realName isEqual:@""]) )
     {
     self.userNameLabel.text = self.userModel.realName;
     }
     else
     */
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
    [self.view setNeedsDisplay];
}

@end