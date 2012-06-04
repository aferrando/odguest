//
//  SkiViewController.h
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"


@interface SkiViewController : CustomContentViewController
{
  IBOutlet UIButton * lessonsButton;
  IBOutlet UIButton * guidedTourButton;
  IBOutlet UIButton * childcareButton;
  IBOutlet UIButton * eventsButton;
  IBOutlet UIButton * rentalButton;
  IBOutlet UIButton * buddiesButton;
  
  IBOutlet UILabel * lessonsLabel;
  IBOutlet UILabel * guidedTourLabel;
  IBOutlet UILabel * childcareLabel;
  IBOutlet UILabel * eventsLabel;
  IBOutlet UILabel * rentalLabel;
  IBOutlet UILabel * buddiesLabel;
  
  IBOutlet UILabel * lessonsBadgetLabel;
  IBOutlet UILabel * guidedTourBadgetLabel;
  IBOutlet UILabel * childcareBadgetLabel;
  IBOutlet UILabel * eventsBadgetLabel;
  IBOutlet UILabel * rentalBadgetLabel;
  IBOutlet UILabel * buddiesBadgetLabel;
}
- (IBAction) lessonsButtonPressed;
- (IBAction) guidedTourButtonPressed;
- (IBAction) childcareButtonPressed;
- (IBAction) eventsButtonPressed;
- (IBAction) rentalButtonPressed;
- (IBAction) buddiesButtonPressed;

@end
