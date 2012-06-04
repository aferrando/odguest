//
//  OportunityDetailViewController.h
//  opendestination
//
//  Created by David Hoyos on 14/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomContentViewController.h"
#import "MGTileMenuController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@class mapaViewController;
@interface OportunityDetailViewController : CustomContentViewController <UIAlertViewDelegate, MGTileMenuDelegate>
{
  id<InstantDealViewControllerDelegate> delegate;
  OpportunityModel * _opportunity;
  IBOutlet UILabel * senderLabel;
  IBOutlet UILabel * addressLabel;
  IBOutlet UILabel * detailLabel;
  IBOutlet UITextView * descriptionTextField;
  IBOutlet UIButton * interestedButton;
    IBOutlet UIButton *notInterestedButton;
    IBOutlet UIView *redeemBarVIew;
  UIImageView * _imageView;
    __unsafe_unretained IBOutlet UIView *descriptionBackgroundView;
    IBOutlet UIView *likeBarView;
  UIImageView * _pointsSplash;
    __unsafe_unretained IBOutlet UIImageView *pointsImageView;
    __unsafe_unretained IBOutlet UILabel *pointsLabel;
    IBOutlet UIImageView *_checkedImageView;
    IBOutlet UIView *commentBarView;
    IBOutlet UILabel *pointsFixedLabel;
    IBOutlet UILabel *interestedLbl;
    IBOutlet UILabel *notInterestedLbl;
    IBOutlet UILabel *scoreValueLabel;
    __unsafe_unretained IBOutlet UIImageView *ownerImage;
    __unsafe_unretained IBOutlet UILabel *timeLabel;
  mapaViewController * map;
    __unsafe_unretained IBOutlet UIView *buttonBackgroundView;
@private
  UIActivityIndicatorView * _spin;
}
@property ( nonatomic ) OpportunityModel * opportunity;
@property ( nonatomic ) IBOutlet UIImageView * imageView;
@property ( nonatomic ) IBOutlet UIImageView * ownerImage;
@property ( nonatomic ) IBOutlet UILabel *interestedLbl;
@property ( nonatomic ) IBOutlet UILabel *notInterestedLbl;
@property (strong, nonatomic) MGTileMenuController *tileController;
- (IBAction) interestedButtonPressed:(id)sender;
- (IBAction) showMapLocation;
- (IBAction)notInterestedButtonPressed:(id)sender;
- (void) reload;
- (void) removePointsSplash;
- (void) showPoints;
- (void) showSpin;
- (void) removeSpin;
- (void) updateButtonTittle;
- (void) showLogin;
- (IBAction)redeemBtnPressed:(id)sender;

@end