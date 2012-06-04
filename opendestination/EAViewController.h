//
//  EAViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"


@interface EAViewController : CustomContentViewController
{
  IBOutlet UIButton * museumButton;
  IBOutlet UIButton * swimmingPoolButton;
  IBOutlet UIButton * cinemasButton;
  IBOutlet UIButton * sportCentersButton;
  
  IBOutlet UILabel * museumLabel;
  IBOutlet UILabel * swimmingPoolLabel;
  IBOutlet UILabel * cinemasLabel;
  IBOutlet UILabel * sportCentersLabel;
  
  IBOutlet UILabel * museumBadgetLabel;
  IBOutlet UILabel * swimmingPoolBadgetLabel;
  IBOutlet UILabel * cinemasBadgetLabel;
  IBOutlet UILabel * sportCentersBadgetLabel;
}

- (IBAction) museumButtonPressed;
- (IBAction) swimmingPoolButtonPressed;
- (IBAction) cinemasButtonPressed;
- (IBAction) sportCentersButtonPressed;


@end
