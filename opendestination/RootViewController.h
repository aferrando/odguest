//
//  RootViewController.h
//  opendestination
//
//  Created by David Hoyos on 04/07/11.
//  Copyright 2011 Kirubs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "InstantDealViewController.h"
#import "FBConnect.h"
#import "AwesomeMenu.h"

@class ConnectViewController;
@class AskViewController;
@class UserModel;
@class Destination;

typedef enum ContentPageTransitionType {
    ContentPageTranistionTypeNone,
    ContentPageTransitionTypeCurl,
    ContentPageTransitionTypeFlip,
    ContentPageTranistionTypeSide
} ContentPageTransitionType;

@interface RootViewController : UIViewController <CollapseViewControllerDelegate, LoginViewControllerDelegate, RegisterViewControllerDelegate, InstantDealViewControllerDelegate > {
    UIView * liveBar;
    IBOutlet UINavigationBar *navBar;
    UIView * collapseView;
    IBOutlet UIView *tabBarVIew;
    UIView * contentView;
    UIButton * oportunityButton;
    UIButton * askButton;
    IBOutlet UIView *noSocialTabBarView;
    NSMutableArray * _viewControllers;
    UIViewController * myRootViewController;
    UIViewController * _myVisibleViewController;
    CollapseViewController * collapseViewController;
    ConnectViewController * _newOportunityViewController;
    AskViewController * _askOpportunityViewController;
    LoginViewController * _loginViewController;
    UserModel * _user;
    Destination * _destination;
    NSArray *permissions;
}
@property (nonatomic, retain) NSArray *permissions;
@property ( nonatomic ) IBOutlet CollapseViewController * collapseViewController;
@property ( nonatomic ) IBOutlet UIView * liveBar;
@property ( nonatomic ) IBOutlet UINavigationBar *navBar;
@property ( nonatomic ) IBOutlet UIView * collapseView;
@property ( nonatomic ) IBOutlet UIView * tabBarView;
@property ( nonatomic ) IBOutlet UIView * noSocialTabBarView;
@property ( nonatomic ) IBOutlet UIView * contentView;
@property ( nonatomic ) IBOutlet UIButton * oportunityButton;
@property ( nonatomic ) IBOutlet UIButton * askButton;
@property ( nonatomic ) IBOutlet UISegmentedControl * segmentedNavigation;
@property ( nonatomic ) NSMutableArray * viewControllers;
@property ( nonatomic ) ConnectViewController * createOpportunityViewController;
@property ( nonatomic ) AskViewController * askOpportunityViewController;
@property ( nonatomic ) LoginViewController * loginViewController;
@property ( nonatomic, readonly ) UserModel * user;
@property ( nonatomic, readonly ) Destination * destination;
@property ( nonatomic, readonly ) UIViewController * myRootViewController;
- (IBAction) newOportunityPressed;
- (IBAction) askOpportunityPressed;
- (IBAction) segAction:(id)sender;
- (void) pushViewController:(UIViewController * )viewController animated:(BOOL)animated;
- (void) pushViewController2:(UIViewController * )viewController animated:(BOOL)animated;
- (void) popViewControllerAnimated:(BOOL)animated;
- (void) popToRootViewControllerAnimated:(BOOL)animated;
- (void) parseNotificationData:(NSDictionary*)userInfo;
- (void) showSignIn;
- (void) showRegister;
- (void) setDestinationSettings;
- (void) reload;
- (void) tabBarHidden:(BOOL)animated;
@end