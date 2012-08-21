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
#import "ClusterMapViewController.h"
#import "BlockAlertView.h"
#import "PopUpViewController.h"


@class mapaViewController;
@interface OportunityDetailViewController : UIViewController <UIAlertViewDelegate, MGTileMenuDelegate, UIScrollViewDelegate >
{
        //  id<InstantDealViewControllerDelegate> delegate;
  OpportunityModel * _opportunity;
  IBOutlet UILabel * senderLabel;
  IBOutlet UILabel * addressLabel;
  IBOutlet UILabel * detailLabel;
    IBOutlet UILabel *shareLabel;
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
    IBOutlet UIView *contentView;
    IBOutlet UILabel *pointsFixedLabel;
    IBOutlet UIView *yesnoVIew;
    IBOutlet UILabel *interestedLbl;
    IBOutlet UILabel *notInterestedLbl;
    IBOutlet UILabel *scoreValueLabel;
    IBOutlet UILabel *interestedKeyLabel;
    IBOutlet UILabel *notInterestedKeyLabel;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *reservationBarView;
    IBOutlet UIButton *likeButton;
    IBOutlet UIView *waitingView;
    IBOutlet UIView *confirmationView;
    IBOutlet UILabel *reservationMessage;
    __unsafe_unretained IBOutlet UIImageView *ownerImage;
    IBOutlet UIButton *confirmationButton;
    IBOutlet UILabel *confirmationLabel;
    __unsafe_unretained IBOutlet UILabel *timeLabel;
  ClusterMapViewController * map;
    __unsafe_unretained IBOutlet UIView *buttonBackgroundView;
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *doNotLikeButton;
    BlockAlertView *alert;
    PopUpViewController *detailViewController;
@private
  UIActivityIndicatorView * _spin;
}
@property ( nonatomic ) OpportunityModel * opportunity;
@property ( nonatomic ) IBOutlet UIImageView * imageView;
@property ( nonatomic ) IBOutlet UIImageView * ownerImage;
@property ( nonatomic ) IBOutlet UILabel *interestedLbl;
@property ( nonatomic ) IBOutlet UILabel *notInterestedLbl;
@property ( nonatomic ) IBOutlet UIScrollView *scrollView;
@property ( nonatomic ) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *bookNowButton;
@property (strong, nonatomic) IBOutlet UIButton *walkinButton;
@property (strong, nonatomic) IBOutlet UILabel *walkinLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *waitingIndicator;
@property (strong, nonatomic) IBOutlet UILabel *waitingLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) BlockAlertView *alert;
@property (strong, nonatomic) PopUpViewController *detailViewController;

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
- (IBAction)shareBtnPressed:(id)sender;
- (void) showLogin;
- (IBAction)redeemBtnPressed:(id)sender;
- (IBAction)booknowBtnPressed:(id)sender;
@end