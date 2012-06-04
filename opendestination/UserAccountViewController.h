//
//  UserAccountViewController.h
//  opendestination
//
//  Created by David Hoyos on 15/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"


@interface UserAccountViewController : CustomContentViewController
{
  IBOutlet UIButton * myDealsButton;
  IBOutlet UIButton * myInterestsButton;
  IBOutlet UIButton * profileButton;
  IBOutlet UIImageView * fakeImageView;
  UIViewController * detailViewController;
  NSInteger selectedIndex;
}
@property (nonatomic, assign) NSInteger selectedIndex;
-(IBAction) myDealsButtonPressed;
-(IBAction) myInterestsButtonPressed;
-(IBAction) myProfileButtonPressed;

@end
