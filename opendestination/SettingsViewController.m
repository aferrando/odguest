  //
//  SettingsViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 5/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//
// Safe releases
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#define FIELDS_COUNT            6 
#define BIRTHDAY_FIELD_TAG      4
#define GENDER_FIELD_TAG        5

#import "SettingsViewController.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "YRDropdownView.h"
#import "RootViewController.h"
#import "Destination.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize nameTextField;
@synthesize lastnameTextField;
@synthesize imageButton;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize birthdayTextField;
@synthesize genderTextField;
@synthesize emailLabel;
@synthesize passwordLabel;


@synthesize birthdayLabel;
@synthesize genderLabel;
@synthesize phoneLabel;
@synthesize pointsLabel;
@synthesize levelLabel;
@synthesize progressView;
@synthesize phonteTextField;
@synthesize backgroundView;
@synthesize minLabel;
@synthesize keyboardToolbar = keyboardToolbar_;
@synthesize genderPickerView = genderPickerView_;
@synthesize languagePickerView = languagePickerView_;
@synthesize birthdayDatePicker = birthdayDatePicker_;

@synthesize birthday = birthday_;
@synthesize gender = gender_;
@synthesize photo = photo_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *signupBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"saveKey", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(saveSettings)];
    self.navigationItem.rightBarButtonItem = signupBarItem;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];

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
        self.languagePickerView.tag=1;
    }
        // Language picker
    if (self.languagePickerView == nil) {
        self.languagePickerView = [[UIPickerView alloc] init];
        self.languagePickerView.delegate = self;
        self.languagePickerView.showsSelectionIndicator = YES;
        self.languagePickerView.tag=2;
    }
    
        // Keyboard toolbar
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"previous", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", @"")
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
        self.phonteTextField.inputAccessoryView = self.keyboardToolbar;
        self.phonteTextField.inputView = self.languagePickerView;
            //  self.phoneTextField.inputAccessoryView = self.keyboardToolbar;
        
    }
    
        // Set localization
    self.nameTextField.placeholder = NSLocalizedString(@"firstNameKey", @"");
        // self.lastNameTextField.placeholder = NSLocalizedString(@"lastNameKey", @"");
    self.emailLabel.text = [NSLocalizedString(@"emailKey", @"") uppercaseString]; 
    self.passwordLabel.text = [NSLocalizedString(@"passwordKey", @"") uppercaseString];
    self.birthdayLabel.text = [NSLocalizedString(@"birthdateKey", @"") uppercaseString]; 
    self.genderLabel.text = [NSLocalizedString(@"genderKey", @"") uppercaseString]; 
    self.phoneLabel.text = [NSLocalizedString(@"languageKey", @"") uppercaseString];
        // self.phoneTextField.placeholder = NSLocalizedString(@"optionalKey", @"");
        // self.termsTextView.text = NSLocalizedString(@"termsKey", @"");
    
        // Reset labels colors
    [self resetLabelsColors];
    
    UserModel *user=[UserModel sharedUser];
    nameTextField.text=user.realName;
    lastnameTextField.text=user.realName;
        // imageButton setBackgroundImage: forState:<#(UIControlState)#>=user.realName;
    emailTextField.text=user.userName;
    if ([user.gender intValue]== 0) {
        self.genderTextField.text = NSLocalizedString(@"maleKey", @"");
    } else {
        self.genderTextField.text = NSLocalizedString(@"femaleKey", @"");
    }

    passwordTextField.text=user.password;
    NSArray *values = [[[Destination sharedInstance] languages] allKeys];
        // Configure the cell...
    
    for (int i = 0; i < [values count]; i++) {
        NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:i]];
        if ([(NSNumber *)[currentObject valueForKey:@"id"] intValue]  == [user.localeID intValue] ){
            NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
                //    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[values objectAtIndex:indexPath.row]  objectForKey:@"code"] ] ;
            phonteTextField.text=currentLocale.localeIdentifier; 
        }
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    birthdayTextField.text=[dateFormatter stringFromDate:user.birthDate];
        //  [imageButton setBackgroundImage: forState:<#(UIControlState)#> setImageWithURL:user.image 
        //        placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
        //birthdayTextField.text=user.birthDate;
    [imageButton setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
    imageButton.layer.masksToBounds = YES;
    imageButton.layer.cornerRadius = 5.0;
    imageButton.layer.borderWidth = 1.0;
    imageButton.layer.borderColor = [[UIColor whiteColor] CGColor];
     [pointsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%d points",@""), [user points]]];
     NSDictionary *level=[user level];
    if (( [[level objectForKey:@"range_min"]  isKindOfClass:[NSNumber class]] ) &&( [[level objectForKey:@"range_max"] isKindOfClass:[NSNumber class]] )
        ) {
    int range_min = [[level objectForKey:@"range_min"] integerValue];
        //  if ( [[level objectForKey:@"range_max"] isKindOfClass:[NSNumber class]] )
    int range_max = [[level objectForKey:@"range_max"] integerValue];
    
    double ratio=(double) ( user.points- range_min)/(range_max-range_min);
    [levelLabel setText:[NSString stringWithFormat:@"%d", range_max]];
     
    [self.progressView setProgress:ratio animated:TRUE];
    [self.minLabel setText:[NSString stringWithFormat:@"%d", range_min]];
    }
    backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
        // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setLastnameTextField:nil];
    [self setImageButton:nil];
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setBirthdayTextField:nil];
    [self setGenderTextField:nil];
    [self setEmailLabel:nil];
    [self setPasswordLabel:nil];
    [self setBirthdayLabel:nil];
    [self setGenderLabel:nil];
    [self setPhoneLabel:nil];
    [self setPointsLabel:nil];
    [self setLevelLabel:nil];
    [self setProgressView:nil];
    [self setPhonteTextField:nil];
    [self setBackgroundView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) saveSettings {
    UserModel *user=[UserModel sharedUser];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasUpdated)
                                                 name:(NSString *)kUserUpdatedNotification
                                               object:user];
  /*  [user postImage:self.photo];
    [user setParam:userModel.birthDate];
    [user setParam:userModel.gender];*/
    
    [user postImage:imageButton.imageView.image];
    [user setGender:[self gender]];
    [user setParam:user.gender];
    [user setBirthDate:[self birthday]];
    [user setParam:user.birthDate];
    [user setRealName:nameTextField.text]; 
    [user setParam:user.realName];
    [user setParam:user.localeID];

  
    
}


- (void) userDataWasUpdated 
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [YRDropdownView showDropdownInView:self.navigationController.view
                                 title:@"Important" 
                                detail:NSLocalizedString(@"userUpdatedTitleKey", @"User created !")
                                 image:nil
                              animated:YES
                             hideAfter:3.0 type:1];
    
    
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
  /*  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataWasRegistered)
                                                 name:(NSString *)kUserRegisteredNotification
                                               object:userModel];*/
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
            [nextLabel setTextColor:[SettingsViewController labelSelectedColor]];
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
            [nextLabel setTextColor:[SettingsViewController labelSelectedColor]];
        }
        [self checkSpecialFields:nextTag];
    }
}

- (id)getFirstResponder
{
    NSUInteger index = 0;
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
        rect.origin.y = -44.0f * (tag - 1);
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
- (void)setLocaleData
{
 /*   NSUInteger selectedRow = [myPickerView selectedRowInComponent:0];
    self.phonteTextField.text = self.languagePickerView 
    
    if ([self.genderPickerView selectedRowInComponent:0] == 0) {
        self.genderTextField.text = NSLocalizedString(@"maleKey", @"");
        self.gender = @"0";
    } else {
        self.genderTextField.text = NSLocalizedString(@"femaleKey", @"");
        self.gender = @"1";
    }*/
}

- (void)birthdayDatePickerChanged:(id)sender
{
    [self setBirthdayData];
}

- (void)resetLabelsColors
{
    self.emailLabel.textColor = [SettingsViewController labelNormalColor];
    self.passwordLabel.textColor = [SettingsViewController labelNormalColor];
    self.birthdayLabel.textColor = [SettingsViewController labelNormalColor];
    self.genderLabel.textColor = [SettingsViewController labelNormalColor];
    self.phoneLabel.textColor = [SettingsViewController labelNormalColor];
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
        [label setTextColor:[SettingsViewController labelSelectedColor]];
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
    switch (pickerView.tag) {
    case 1:
            return 2;
        case 2: return [[[[Destination sharedInstance] languages] allKeys] count];
    }
    return 0;       
}


#pragma mark - UIPickerViewDelegate
/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    switch (pickerView.tag) {
        case 1:{
            UIImage *image = row == 0 ? [UIImage imageNamed:@"male.png"] : [UIImage imageNamed:@"female.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];        
            imageView.frame = CGRectMake(0, 0, 32, 32);
            
            genderLabel.text = [row == 0 ? NSLocalizedString(@"maleKey", @"") : NSLocalizedString(@"femaleKey", @"") uppercaseString];
            genderLabel.textAlignment = UITextAlignmentLeft;
            genderLabel.backgroundColor = [UIColor clearColor];
            
            UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
            [rowView insertSubview:imageView atIndex:0];
            [rowView insertSubview:genderLabel atIndex:0];
            
            
            return rowView;

            break;
        }
        case 2:{
            NSArray *values = [[[Destination sharedInstance] languages] allKeys];
                // Configure the cell...
            NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:row]];
            NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
                //    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[values objectAtIndex:indexPath.row]  objectForKey:@"code"] ] ;
            UILabel *language=[[UILabel alloc]init];
            language.text= currentLocale.localeIdentifier;
           
            UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
                //[rowView insertSubview:imageView atIndex:0];
            [rowView insertSubview:language  atIndex:0];
            return rowView;
        }
         
        default:
            break;
    }
    return nil;
}
*/
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    switch (pickerView.tag) {
        case 1:{
            if (row==0) return NSLocalizedString(@"maleKey", @"");
            else return NSLocalizedString(@"femaleKey", @"");
            break;
        }
        case 2:{
            NSArray *values = [[[Destination sharedInstance] languages] allKeys];
                // Configure the cell...
            
            for (int i = 0; i < [values count]; i++) {
                NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:i]];
                if ([(NSNumber *)[currentObject valueForKey:@"id"] intValue]  == row){
                    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
                        //    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[values objectAtIndex:indexPath.row]  objectForKey:@"code"] ] ;
                    return currentLocale.localeIdentifier; 
                }
                       }
            return nil;
        }
            
        default:
            break;
    }
    return nil;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:{ [self setGenderData];
            break;
        }
        case 2:{
            NSArray *values = [[[Destination sharedInstance] languages] allKeys];
                // Configure the cell...
            [[UserModel sharedUser] setLocaleID:[NSString stringWithFormat:@"%d", row]];
            
            for (int i = 0; i < [values count]; i++) {
                NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:i]];
                if ([(NSNumber *)[currentObject valueForKey:@"id"] intValue]  == row){
                    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
                    self.phonteTextField.text = currentLocale.localeIdentifier;                }
            }           
            break;
        }
    }
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
 /*   opendestinationAppDelegate *appDelegate= ((opendestinationAppDelegate*)[[UIApplication sharedApplication] delegate]);
    RootViewController *root=(RootViewController *)[appDelegate.window rootViewController];
    
    DDMenuController *menuController = (DDMenuController*) root.myRootViewController;*/
[(RootViewController *)[self.view.window rootViewController] presentModalViewController:imagePickerController animated:YES];    
        //[self presentModalViewController:imagePickerController animated:YES];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
	[picker dismissModalViewControllerAnimated:YES];
	self.photo = [info objectForKey:UIImagePickerControllerEditedImage];
	[self.imageButton setImage:self.photo forState:UIControlStateNormal];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - progressView
- (void) reloadPointsProgress {
    /*    [UIView animateWithDuration:1.0 animations:^{
                [self.progressView setFrame:CGRectMake(self.progressView.frame.origin.x,self.progressView.frame.origin.y,
                                               1.0 + ( 210.0 * ( self.userModel.points / (self.userModel.goal==0?1.0:self.userModel.goal) ) ),
                                               self.progressView.frame.size.height)];
    }];*/
}

/*

     - (void)viewDidUnload {
         [self setMinLabel:nil];
         [super viewDidUnload];
     }*/
@end
