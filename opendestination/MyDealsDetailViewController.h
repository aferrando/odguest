//
//  MyDealsDetailViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 12/26/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
@class mapaViewController;
#import "CustomContentViewController.h"

@interface MyDealsDetailViewController : UIViewController
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
    IBOutlet UIView *likeBarView;
    UIImageView * _pointsSplash;
    IBOutlet UIImageView *_checkedImageView;
    mapaViewController * map;
    IBOutlet UIView *rateandcommentView;
    IBOutlet UIButton *redeemBtn;
    IBOutlet UIButton *commentBtn;
    IBOutlet UIButton *rateBtn;
@private
    UIActivityIndicatorView * _spin;
}
@property ( nonatomic ) OpportunityModel * opportunity;
@property ( nonatomic ) IBOutlet UIImageView * imageView;
@property ( nonatomic ) IBOutlet UIImageView * checkedImageView;
- (IBAction) interestedButtonPressed:(id)sender;
- (IBAction) showMapLocation;
- (IBAction)notInterestedButtonPressed:(id)sender;
- (void) reload;
- (void) removePointsSplash;
- (void) showPoints;
- (void) showSpin;
- (void) removeSpin;
- (void) updateButtonTittle;
- (IBAction)redeemBtnPressed:(id)sender;
@end
