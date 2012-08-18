//
//  SettingsViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 5/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BlockAlertView.h"

@interface SettingsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate> {
    UIToolbar *keyboardToolbar_;
    UIPickerView *genderPickerView_;
    UIPickerView *languagePickerView_;
    UIDatePicker *birthdayDatePicker_;
    
    NSDate *birthday_;
    NSString *gender_;
    UIImage *photo_;
    BlockAlertView *alert;

}
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (strong, nonatomic) IBOutlet UITextField *genderTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UITextField *phonteTextField;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) BlockAlertView *alert;

@property(nonatomic,strong) UIToolbar *keyboardToolbar;
@property(nonatomic,strong) UIPickerView *genderPickerView;
@property(nonatomic,strong) UIPickerView *languagePickerView;
@property(nonatomic,strong) UIDatePicker *birthdayDatePicker;

@property(nonatomic) NSDate *birthday;
@property(nonatomic) NSString *gender;
@property(nonatomic) UIImage *photo;
- (IBAction)choosePhoto:(id)sender;

@end
