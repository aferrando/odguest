//
//  NotificationDetailViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 12/23/11.
//  Copyright (c) 2011 None. All rights reserved.
//
#import "OpportunityModel.h"
#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"

@interface NotificationDetailViewController : CustomContentViewController
{
OpportunityModel * _opportunity;
//IBOutlet UILabel * titleLabel;
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
