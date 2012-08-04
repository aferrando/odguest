//
//  DBSignupViewController.h
//  DBSignup
//
//  Created by Davide Bettio on 7/4/11.
//  Copyright 2011 03081340121. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface DBSignupViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITextField *nameTextField_;
    UITextField *lastNameTextField_;
    UITextField *emailTextField_;
    UITextField *passwordTextField_;
    UITextField *birthdayTextField_;
    UITextField *genderTextField_;
    UITextField *phoneTextField_;
    UIButton *photoButton_;
    UITextView *termsTextView_;
    
    UILabel *emailLabel_;
    UILabel *passwordLabel_;
    UILabel *birthdayLabel_;
    UILabel *genderLabel_;
    UILabel *phoneLabel_;
    
    UIToolbar *keyboardToolbar_;
    UIPickerView *genderPickerView_;
    UIDatePicker *birthdayDatePicker_;
    
    NSDate *birthday_;
    NSString *gender_;
    UIImage *photo_;
    
    
    UserModel * userModel;

}
@property ( nonatomic, retain ) UserModel * userModel;

@property(nonatomic) IBOutlet UITextField *nameTextField;
@property(nonatomic) IBOutlet UITextField *lastNameTextField;
@property(nonatomic) IBOutlet UITextField *emailTextField;
@property(nonatomic) IBOutlet UITextField *passwordTextField;
@property(nonatomic) IBOutlet UITextField *birthdayTextField;
@property(nonatomic) IBOutlet UITextField *genderTextField;
@property(nonatomic) IBOutlet UITextField *phoneTextField;
@property(nonatomic) IBOutlet UIButton *photoButton;
@property(nonatomic) IBOutlet UITextView *termsTextView;

@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property(nonatomic) IBOutlet UILabel *emailLabel;
@property(nonatomic) IBOutlet UILabel *passwordLabel;
@property(nonatomic) IBOutlet UILabel *birthdayLabel;
@property(nonatomic) IBOutlet UILabel *genderLabel;
@property(nonatomic) IBOutlet UILabel *phoneLabel;

@property(nonatomic) UIToolbar *keyboardToolbar;
@property(nonatomic) UIPickerView *genderPickerView;
@property(nonatomic) UIDatePicker *birthdayDatePicker;

@property(nonatomic) NSDate *birthday;
@property(nonatomic) NSString *gender;
@property(nonatomic) UIImage *photo;

- (IBAction)choosePhoto:(id)sender;

- (void)resignKeyboard:(id)sender;
- (void)previousField:(id)sender;
- (void)nextField:(id)sender;
- (id)getFirstResponder;
- (void)animateView:(NSUInteger)tag;
- (void)checkBarButton:(NSUInteger)tag;
- (void)checkSpecialFields:(NSUInteger)tag;
- (void)setBirthdayData;
- (void)setGenderData;
- (void)birthdayDatePickerChanged:(id)sender;
- (void)signup:(id)sender;
- (void)resetLabelsColors;

+ (UIColor *)labelNormalColor;
+ (UIColor *)labelSelectedColor;
@end
