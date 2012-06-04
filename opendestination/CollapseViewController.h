//
//  CollapseViewController.h
//  opendestination
//
//  Created by David Hoyos on 06/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@protocol CollapseViewControllerDelegate <NSObject>
- (void) mustShowSignIn;
@optional
- (void) collapseViewWillSwitchContentView;
- (void) collapseViewDidSwitchContentView;
@end

@interface CollapseViewController : UIViewController <CollapseViewControllerDelegate>
{
  id<CollapseViewControllerDelegate> __unsafe_unretained delegate;
  BOOL isExpanded;
  UIButton * homeButton;
  UIButton * myPointsButton;
  IBOutlet UIButton * signOutButton;
  IBOutlet UIButton * expandButton;
  UIImageView * userImage;
    IBOutlet UIView *tabBarVuew;
  UILabel * userNameLabel;
  UILabel * meLabel;
  IBOutlet UIImageView * statusImageView;
  UIView * progressView;
  UILabel * __unsafe_unretained goalCountLabel;
  UILabel * pointsCountLabel;
  UILabel * dealsLabel;
  UILabel * dealsCountLabel;
    IBOutlet UILabel *exploreLabel;
    IBOutlet UILabel *connectLabel;
    IBOutlet UILabel *requestLabel;
    IBOutlet UILabel *myDealsLabel;
    IBOutlet UILabel *levelLabel;
    IBOutlet UILabel *goalLabel;
    IBOutlet UILabel *pointsLabel;
  UIButton * dealsButtons;
  UILabel * interestsLabel;
  UILabel * interestsCountLabel;
  UIButton * interestsButton;
    IBOutlet UIView *progressGlobalView;
  UserModel * _userModel;
    IBOutlet UIButton *notificationsBtn;
}
@property ( nonatomic, unsafe_unretained ) id delegate;
@property ( assign, readonly ) BOOL isExpanded;
@property ( nonatomic ) IBOutlet UIButton * signOutButton;
@property ( nonatomic ) IBOutlet UIButton * homeButton;
@property ( nonatomic ) IBOutlet UIButton * myPointsButton;
@property ( nonatomic ) IBOutlet UIButton * notificationsBtn;
@property ( nonatomic ) IBOutlet UIView * progressView;
@property ( nonatomic ) IBOutlet UIView * tabBarVuew;
@property ( nonatomic ) IBOutlet UIView * progressGlobalView;
@property ( unsafe_unretained, nonatomic, readonly ) IBOutlet UILabel * goalCountLabel;
@property ( nonatomic ) IBOutlet UILabel * pointsCountLabel;
@property ( nonatomic ) IBOutlet UIImageView * userImage;
@property ( nonatomic ) IBOutlet UILabel * userNameLabel;
@property ( nonatomic ) IBOutlet UILabel * meLabel; 
@property ( nonatomic ) IBOutlet UIImageView * statusImageView;
@property ( nonatomic ) IBOutlet UILabel * interestsLabel;
@property ( nonatomic ) IBOutlet UILabel * interestsCountLabel;
@property ( nonatomic ) IBOutlet UIButton * interestsButton;
@property ( nonatomic ) IBOutlet UILabel * dealsLabel;
@property ( nonatomic ) IBOutlet UILabel * dealsCountLabel;
@property ( nonatomic ) IBOutlet UILabel * goalsLabel;
@property ( nonatomic ) IBOutlet UILabel * pointsLabel;

@property ( nonatomic ) IBOutlet UIButton * dealsButton;
@property ( nonatomic ) UserModel * userModel; 

- (IBAction) signOutButtonPressed:(id)sender;
- (IBAction) dealsButtonPressed;
- (IBAction) notificationsButtonPressed;
- (IBAction) interestsButtonPressed;
- (IBAction) homeButtonPressed;
- (IBAction) myPointsButtonPressed;
- (IBAction) expandButtonPressed;
- (IBAction)myDealsModalBtnPressed:(id)sender;
- (void) expand;
- (void) collapse;
- (void) setDealsCount:(NSInteger)count;
- (void) reload;

@end
