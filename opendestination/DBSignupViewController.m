    //
    //  DBSignupViewController.m
    //  DBSignup
    //
    //  Created by Davide Bettio on 7/4/11.
    //  Copyright 2011 03081340121. All rights reserved.
    //

#import "DBSignupViewController.h"
#import "UserModel.h"
#import "YRDropdownView.h"

    // Safe releases
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT            6
#define BIRTHDAY_FIELD_TAG      4
#define GENDER_FIELD_TAG        5

@implementation DBSignupViewController

@synthesize nameTextField = nameTextField_;
@synthesize lastNameTextField = lastNameTextField_;
@synthesize emailTextField = emailTextField_;
@synthesize passwordTextField = passwordTextField_;
@synthesize birthdayTextField = birthdayTextField_;
@synthesize genderTextField = genderTextField_;
@synthesize phoneTextField = phoneTextField_;
@synthesize photoButton = photoButton_;
@synthesize termsTextView = termsTextView_;

@synthesize emailLabel = emailLabel_;
@synthesize passwordLabel = passwordLabel_;
@synthesize birthdayLabel = birthdayLabel_;
@synthesize genderLabel = genderLabel_;
@synthesize phoneLabel = phoneLabel_;

@synthesize keyboardToolbar = keyboardToolbar_;
@synthesize genderPickerView = genderPickerView_;
@synthesize birthdayDatePicker = birthdayDatePicker_;

@synthesize birthday = birthday_;
@synthesize gender = gender_;
@synthesize photo = photo_;

@synthesize userModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
        self.userModel = [[UserModel alloc] init] ;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
        // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


    // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
        // Signup button
    UIBarButtonItem *signupBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"registerBtnKey", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(signup:)];
    self.navigationItem.rightBarButtonItem = signupBarItem;
    
        // Birthday date picker
    if (self.birthdayDatePicker == nil) {
        self.birthdayDatePicker = [[UIDatePicker alloc] init];
        [self.birthdayDatePicker addTarget:self action:@selector(birthdayDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
        self.birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
        NSDate *currentDate = [NSDate date];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setYear:-18];
        NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate  options:0];
        [self.birthdayDatePicker setDate:selectedDate animated:NO];
        [self.birthdayDatePicker setMaximumDate:currentDate];
    }
    
        // Gender picker
    if (self.genderPickerView == nil) {
        self.genderPickerView = [[UIPickerView alloc] init];
        self.genderPickerView.delegate = self;
        self.genderPickerView.showsSelectionIndicator = YES;
    }
    
        // Keyboard toolbar
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"previousKey", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nextKey", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"doneKey", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [self.keyboardToolbar setItems:[NSArray arrayWithObjects:previousBarItem, nextBarItem, spaceBarItem, doneBarItem, nil]];
        
        self.nameTextField.inputAccessoryView = self.keyboardToolbar;
            //     self.lastNameTextField.inputAccessoryView = self.keyboardToolbar;
        self.emailTextField.inputAccessoryView = self.keyboardToolbar;
        self.passwordTextField.inputAccessoryView = self.keyboardToolbar;
        self.birthdayTextField.inputAccessoryView = self.keyboardToolbar;
        self.birthdayTextField.inputView = self.birthdayDatePicker;
        self.genderTextField.inputAccessoryView = self.keyboardToolbar;
        self.genderTextField.inputView = self.genderPickerView;
        self.phoneTextField.inputAccessoryView = self.keyboardToolbar;
        
    }
    
        // Set localization
    self.nameTextField.placeholder = NSLocalizedString(@"firstNameKey", @"");
        // self.lastNameTextField.placeholder = NSLocalizedString(@"lastNameKey", @"");
    self.emailLabel.text = [NSLocalizedString(@"emailKey", @"") uppercaseString]; 
    self.passwordLabel.text = [NSLocalizedString(@"passwordKey", @"") uppercaseString];
    self.birthdayLabel.text = [NSLocalizedString(@"birthdateKey", @"") uppercaseString]; 
    self.genderLabel.text = [NSLocalizedString(@"genderKey", @"") uppercaseString]; 
    self.phoneLabel.text = [NSLocalizedString(@"phoneKey", @"") uppercaseString];
    self.phoneTextField.placeholder = NSLocalizedString(@"optionalKey", @"");
    self.termsTextView.text = NSLocalizedString(@"termsKey", @"");
    
        // Reset labels colors
    [self resetLabelsColors];
    [self.navigationItem setTitle: userModel.destinationName];
    [self.navigationItem setTitle:NSLocalizedString(@"registerKey", @"")];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - IBActions

- (IBAction)choosePhoto:(id)sender
{
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choosePhotoKey", @"")
                                                             delegate:self 
                                                    cancelButtonTitle:NSLocalizedString(@"cancelKey", @"") 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"photoFromCameraKey", @""), NSLocalizedString(@"photoFromLibraryKey", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choosePhotoKey", @"")
                                                             delegate:self 
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"") 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"photoFromLibraryKey", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
}

#pragma mark -

- (void) addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasRegistered)
                                                 name:(NSString *)kUserRegisteredNotification
                                               object:userModel];
}

- (void) userDataWasUpdated 
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.photo != nil)
        [userModel postImage:self.photo];
    [userModel setParam:userModel.birthDate];
    [userModel setParam:userModel.gender];
    [userModel setParam:userModel.realName];
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
    
}
- (void) userDataWasRegistered
{
    /* [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"userCreatedTitleKey", @"User created !")
     message:nil
     delegate:self
     cancelButtonTitle:NSLocalizedString(@"OkBtnKey", @"Ok")
     otherButtonTitles:nil] show]; //TODO: Language;*/
    [YRDropdownView showDropdownInView:self.view
                                 title:@"Important" 
                                detail:NSLocalizedString(@"userCreatedTitleKey", @"User created !")
                                 image:nil
                              animated:YES
                             hideAfter:3.0 type:1];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasUpdated)
                                                 name:(NSString *)kUserUpdatedNotification
                                               object:userModel];
    [userModel signIn];
    
    
    
        //   [delegate registrationDidFinish];
}


#pragma mark - Others

- (void)signup:(id)sender
{
    [self resignKeyboard:nil];
    
        // Check fields
    if ( ( [self.nameTextField.text length] > 4 ) &&
        ( [self.passwordTextField.text length] > 4 ) &&
        //  ( [self.lastNameTextField.text length] > 4 )&&
        ( [self.emailTextField.text length] > 4 ) && 
        ([self.emailTextField.text rangeOfString:@"@"].location != NSNotFound ) 
        
        )
        {
        [self addObserver];
        userModel.userName = self.emailTextField.text;
        userModel.password = self.passwordTextField.text;
        userModel.realName = self.nameTextField.text;
        userModel.birthDate = self.birthday;
        userModel.Gender=self.gender;
        [userModel signUp];
        
        
        } else {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WrongUsernameTitleKey", @"") 
                                        message:NSLocalizedString(@"WrongUsernameMsgKey",@"Username must have more than 2 characters.\nPassword must have more than 4 characters.") 
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"CancelBtnKey", @"")
                              otherButtonTitles:nil] show];
        }
    
        // Make request
}

- (void)resignKeyboard:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        [firstResponder resignFirstResponder];
        [self animateView:1];
        [self resetLabelsColors];
    }
}

- (void)previousField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger previousTag = tag == 1 ? 1 : tag - 1;
        [self checkBarButton:previousTag];
        [self animateView:previousTag];
        UITextField *previousField = (UITextField *)[self.view viewWithTag:previousTag];
        [previousField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:previousTag + 10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        }
        [self checkSpecialFields:previousTag];
    }
}

- (void)nextField:(id)sender
{
    id firstResponder = [self getFirstResponder];
    if ([firstResponder isKindOfClass:[UITextField class]]) {
        NSUInteger tag = [firstResponder tag];
        NSUInteger nextTag = tag == FIELDS_COUNT ? FIELDS_COUNT : tag + 1;
        [self checkBarButton:nextTag];
        [self animateView:nextTag];
        UITextField *nextField = (UITextField *)[self.view viewWithTag:nextTag];
        [nextField becomeFirstResponder];
        UILabel *nextLabel = (UILabel *)[self.view viewWithTag:nextTag + 10];
        if (nextLabel) {
            [self resetLabelsColors];
            [nextLabel setTextColor:[DBSignupViewController labelSelectedColor]];
        }
        [self checkSpecialFields:nextTag];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = 1;
    while (index <= FIELDS_COUNT) {
        UITextField *textField = (UITextField *)[self.view viewWithTag:index];
        if ([textField isFirstResponder]) {
            return textField;
        }
        index++;
    }
    
    return nil;
}

- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 2) {
        rect.origin.y = -44.0f * (tag - 2);
    } else {
        rect.origin.y = 0;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)checkBarButton:(NSUInteger)tag
{
    UIBarButtonItem *previousBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:0];
    UIBarButtonItem *nextBarItem = (UIBarButtonItem *)[[self.keyboardToolbar items] objectAtIndex:1];
    
    [previousBarItem setEnabled:tag == 1 ? NO : YES];
    [nextBarItem setEnabled:tag == FIELDS_COUNT ? NO : YES];
}

- (void)checkSpecialFields:(NSUInteger)tag
{
    if (tag == BIRTHDAY_FIELD_TAG && [self.birthdayTextField.text isEqualToString:@""]) {
        [self setBirthdayData];
    } else if (tag == GENDER_FIELD_TAG && [self.genderTextField.text isEqualToString:@""]) {
        [self setGenderData];
    }
}

- (void)setBirthdayData
{
    self.birthday = self.birthdayDatePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.birthdayTextField.text = [dateFormatter stringFromDate:self.birthday];
}

- (void)setGenderData
{
    if ([self.genderPickerView selectedRowInComponent:0] == 0) {
        self.genderTextField.text = NSLocalizedString(@"maleKey", @"");
        self.gender = @"0";
    } else {
        self.genderTextField.text = NSLocalizedString(@"femaleKey", @"");
        self.gender = @"1";
    }
}

- (void)birthdayDatePickerChanged:(id)sender
{
    [self setBirthdayData];
}

- (void)resetLabelsColors
{
    self.emailLabel.textColor = [DBSignupViewController labelNormalColor];
    self.passwordLabel.textColor = [DBSignupViewController labelNormalColor];
    self.birthdayLabel.textColor = [DBSignupViewController labelNormalColor];
    self.genderLabel.textColor = [DBSignupViewController labelNormalColor];
    self.phoneLabel.textColor = [DBSignupViewController labelNormalColor];
}

+ (UIColor *)labelNormalColor
{
    return [UIColor lightGrayColor];// colorWithRed:0.016 green:0.216 blue:0.286 alpha:1.000];
}

+ (UIColor *)labelSelectedColor
{
    return [UIColor whiteColor];// colorWithRed:0.114 green:0.600 blue:0.737 alpha:1.000];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSUInteger tag = [textField tag];
    [self animateView:tag];
    [self checkBarButton:tag];
    [self checkSpecialFields:tag];
    UILabel *label = (UILabel *)[self.view viewWithTag:tag + 10];
    if (label) {
        [self resetLabelsColors];
        [label setTextColor:[DBSignupViewController labelSelectedColor]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger tag = [textField tag];
    if (tag == BIRTHDAY_FIELD_TAG || tag == GENDER_FIELD_TAG) {
        return NO;
    }
    
    return YES;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}


#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *image = row == 0 ? [UIImage imageNamed:@"male.png"] : [UIImage imageNamed:@"female.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];        
    imageView.frame = CGRectMake(0, 0, 32, 32);
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 32)];
    genderLabel.text = [row == 0 ? NSLocalizedString(@"male", @"") : NSLocalizedString(@"female", @"") uppercaseString];
    genderLabel.textAlignment = UITextAlignmentLeft;
    genderLabel.backgroundColor = [UIColor clearColor];
    
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    [rowView insertSubview:imageView atIndex:0];
    [rowView insertSubview:genderLabel atIndex:1];
    
    
    return rowView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setGenderData];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
	[self presentModalViewController:imagePickerController animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
	[picker dismissModalViewControllerAnimated:YES];
	self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
	[self.photoButton setImage:self.photo forState:UIControlStateNormal];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
