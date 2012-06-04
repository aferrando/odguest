//
//  AddOportunityViewController.h
//  opendestination
//
//  Created by David Hoyos on 07/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"
#import "IAMultipartRequestGenerator.h"
#import "MBProgressHUD.h"

@interface AddOportunityViewController : CustomContentViewController
<UITextFieldDelegate, IAMultipartRequestGeneratorDelegate, UIPickerViewDelegate,
UIPickerViewDataSource, UIAlertViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate>
{
  BOOL wasPublished;
  UIButton * _selectedCategory;
  IBOutlet UIButton * skiBuddy;
  IBOutlet UIButton * carSharingButton;
  IBOutlet UIButton * partyButton;
  IBOutlet UIButton * miscButton;
  IBOutlet UIView * categoryPicker;
  IBOutlet UITextField * oportunityName;
  IBOutlet UITextField * oportunityDescrition;
  IBOutlet UITextField * oportunityTags;
  IBOutlet UIButton * oportunityDelay;
  IBOutlet UIView * choseDelayView;
  IBOutlet UIPickerView * delayPicker;
  IBOutlet UIButton * choseDelayButton;
  IBOutlet UIButton * publishButton;
@private
  BOOL _autoFirstResponder;
  BOOL fetchingData;
  BOOL photoTaken;
  BOOL camRoll;
}
@property ( assign ) BOOL wasPublished;
- (IBAction) selectCategory:(id)sender;
- (IBAction) setOportunityStartDelay;
- (IBAction) delaySelectedButtonPressed;
- (IBAction) publish;
@end
