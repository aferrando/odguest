//
//  goingOutViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"


@interface goingOutViewController : CustomContentViewController
{
  IBOutlet UIButton * foodButton;
  IBOutlet UIButton * barButton;
  IBOutlet UIButton * wineBarButton;
  IBOutlet UIButton * nightClubButton;
  IBOutlet UIButton * pubButton;
  IBOutlet UIButton * sportsBarButton;
  
  IBOutlet UILabel * foodLabel;
  IBOutlet UILabel * barLabel;
  IBOutlet UILabel * wineBarLabel;
  IBOutlet UILabel * nightClubLabel;
  IBOutlet UILabel * pubLabel;
  IBOutlet UILabel * sportsBarLabel;
  
  IBOutlet UILabel * foodBadgetLabel;
  IBOutlet UILabel * barBadgetLabel;
  IBOutlet UILabel * wineBarBadgetLabel;
  IBOutlet UILabel * nightClubBadgetLabel;
  IBOutlet UILabel * pubBadgetLabel;
  IBOutlet UILabel * sportsBarBadgetLabel;
}

- (IBAction) foodButtonPressed;
- (IBAction) barButtonPressed;
- (IBAction) wineBarButtonPressed;
- (IBAction) nightClubButtonPressed;
- (IBAction) pubButtonPressed;
- (IBAction) sportsBarButtonPressed;

@end
