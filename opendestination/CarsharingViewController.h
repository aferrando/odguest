//
//  CarsharingViewController.h
//  opendestination
//
//  Created by David Hoyos on 07/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"


@interface CarsharingViewController : CustomContentViewController
{
  IBOutlet UIButton * carButton;
  IBOutlet UIButton * busButton;
  IBOutlet UIButton * taxiButton;
  
  IBOutlet UILabel * carLabel;
  IBOutlet UILabel * busLabel;
  IBOutlet UILabel * taxiLabel;
  
  IBOutlet UILabel * carBadgetLabel;
  IBOutlet UILabel * busBadgetLabel;
  IBOutlet UILabel * taxiBadgetLabel;
}

- (IBAction) carButtonPressed;
- (IBAction) busButtonPressed;
- (IBAction) taxiButtonPressed;

@end
