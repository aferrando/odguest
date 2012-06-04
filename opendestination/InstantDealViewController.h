//
//  InstantDealViewController.h
//  opendestination
//
//  Created by David Hoyos on 29/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpportunityModel;

@protocol InstantDealViewControllerDelegate <NSObject>
@optional
- (void) instantDealDidFinish;
@end

@interface InstantDealViewController : UIViewController <InstantDealViewControllerDelegate> {
  id<InstantDealViewControllerDelegate> delegate;
  OpportunityModel * _opportunity;
  IBOutlet UILabel * titleLabel;
  IBOutlet UILabel * senderLabel;
  IBOutlet UILabel * detailLabel;
  IBOutlet UITextView * descriptionTextField;
  IBOutlet UIButton * interestedButton;
  IBOutlet UIButton * notInterestedButton;
  UIImageView * _pointsSplash;
  UIImageView * _imageView;
@private
  UIActivityIndicatorView * _spin;
}
@property ( nonatomic ) OpportunityModel * opportunity;
@property ( nonatomic ) IBOutlet UIImageView * imageView;
- (IBAction) interestedButtonPressed:(id)sender; 
- (IBAction) notInterestedButtonPressed:(id)sender;
- (void) reload;
- (void) removePointsSplash;
- (void) showPoints;
- (void) addSpin;
- (void) removeSpin;
@end
