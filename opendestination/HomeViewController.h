//
//  HomeViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"


@interface HomeViewController : CustomContentViewController
{
  IBOutlet UIButton * skiButton;
  IBOutlet UIButton * aeButton;
  IBOutlet UIButton * shopsButton;
  IBOutlet UIButton * gointOutButton;
  IBOutlet UIButton * carsharingButton;
  IBOutlet UIButton * miscButton;
  
  IBOutlet UILabel * skiLabel;
  IBOutlet UILabel * aeLabel;
  IBOutlet UILabel * shopsLabel;
  IBOutlet UILabel * goingOutLabel;
  IBOutlet UILabel * carsharingLabel;
  IBOutlet UILabel * miscLabel;
  
  IBOutlet UILabel * skiBadgetLabel;
  IBOutlet UILabel * aeBadgetLabel;
  IBOutlet UILabel * shopsBadgetLabel;
  IBOutlet UILabel * goingOutBadgetLabel;
  IBOutlet UILabel * carsharingBadgetLabel;
  IBOutlet UILabel * miscBadgetLabel;
}

- (IBAction) skiButtonPressed;
- (IBAction) aeButtonPressed;
- (IBAction) shopsButtonPressed;
- (IBAction) goingOutButtonPressed;
- (IBAction) carsharingButtonPressed;
- (IBAction) miscButtonPressed;

@end
