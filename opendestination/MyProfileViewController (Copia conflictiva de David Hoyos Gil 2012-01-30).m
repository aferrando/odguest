//
//  MyProfileViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyDealsTableViewController.h"
#import "MySharesTableViewController.h"
#import "NotificationsTableViewController.h"
#import "CreatedTableViewController.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "ActionSheetPicker.h"
#import "RootViewController.h"


CGRect originalFrame;


@implementation MyProfileViewController
@synthesize MySharesButtonPressed;

@synthesize avatar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //       self.transition = ContentPageTranistionTypeSide;
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [statusImageView release];
    [locationLbl release];
    [tapToCustomizeLbl release];
    [myWishesLbl release];
    [myProposalsLbl release];
    [MySharesButtonPressed release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"profileKey", @"My Notifications");
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeKey", @"Close") style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(closeWindow)];      
    self.navigationItem.leftBarButtonItem = sendButton;
    [sendButton release];
    
    detailImageButton.layer.masksToBounds = YES;
    detailImageButton.layer.cornerRadius = 5.0;
    detailImageButton.layer.borderWidth = 1.0;
    detailImageButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [[UserModel sharedUser] refresh];
    
    languageLabel.text= NSLocalizedString(@"languageKey",@"Language");
    newPasswordLabel.text= NSLocalizedString(@"newPasswordKey",@"New Password");
    retypePasswordLabel.text= NSLocalizedString(@"retypePasswordKey",@"Retype Password");
    birthdateLabel.text= NSLocalizedString(@"birthdateKey",@"Birthdate");
    genderLabel.text= NSLocalizedString(@"genderKey",@"Gender");
    myDealsLabel.text= NSLocalizedString(@"myDealsKey",@"My Deals");
    myWishesLbl.text= NSLocalizedString(@"myWishesKey",@"My Wishes");
    myProposalsLbl.text= NSLocalizedString(@"myProposalsKey",@"My Proposals");
    notificationsLabel.text= NSLocalizedString(@"notificationsKey",@"Notifications");
    [tapToCustomizeLbl setText:NSLocalizedString(@"tapToCustomizeKey",@"TAP TO CUSTOMIZE")];
    [titleLabel setText:[userModel userName]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];

}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
    originalFrame = self.view.frame;
}


- (void)viewDidUnload
{
    [languageLabel release];
    languageLabel = nil;
    [newPasswordLabel release];
    newPasswordLabel = nil;
    [retypePasswordLabel release];
    retypePasswordLabel = nil;
    [birthdateLabel release];
    birthdateLabel = nil;
    [genderLabel release];
    genderLabel = nil;
    [myDealsLabel release];
    myDealsLabel = nil;
    [notificationsLabel release];
    notificationsLabel = nil;
    [statusImageView release];
    statusImageView = nil;
    [locationLbl release];
    locationLbl = nil;
    [tapToCustomizeLbl release];
    tapToCustomizeLbl = nil;
    [myWishesLbl release];
    myWishesLbl = nil;
    [myProposalsLbl release];
    myProposalsLbl = nil;
    [self setMySharesButtonPressed:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ( self.view.frame.origin.y == originalFrame.origin.y )
    {
        [UIView animateWithDuration:0.3
                         animations:^{[self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-128, self.view.frame.size.width, self.view.frame.size.height)];}];
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( ( (textField == passwordTextField) && !([realNameTextField isFirstResponder]) )
        || ( (textField == realNameTextField) && !([passwordTextField isFirstResponder]) ) )
        [UIView animateWithDuration:0.3 animations:^{self.view.frame = originalFrame;}];
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ( (textField == realNameTextField) && ( [textField.text length] > 0 ) && !([textField.text isEqualToString:userModel.realName]) )
    {
        [userModel setRealName:realNameTextField.text];
        [userModel setParam:userModel.realName];
    }
    else if ( (textField == passwordTextField) && ( [textField.text length] > 0 ) && !([textField.text isEqualToString:userModel.realName]) )
    {
        [userModel setPassword:passwordTextField.text];
        [userModel setParam:userModel.password];
    }
    if ( [textField isFirstResponder])
        [textField resignFirstResponder];
}


#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self useCamera];
            break;
        case 1:
            [self useCameraRoll];
            break;
        default:
            break;
    }
}


# pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{ 
    photoTaken = YES;
    if ( [[info objectForKey:UIImagePickerControllerEditedImage] isKindOfClass:[UIImage class]] )
        self.avatar = [info objectForKey:UIImagePickerControllerEditedImage];
    else if ( [[info objectForKey:UIImagePickerControllerOriginalImage] isKindOfClass:[UIImage class]] )
        self.avatar = [info objectForKey:UIImagePickerControllerOriginalImage];
    [detailImageButton setBackgroundImage:self.avatar forState:UIControlStateNormal];
    [userModel postImage:self.avatar];
    [picker dismissModalViewControllerAnimated:YES];
    [self refresh];
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    photoTaken = NO;
    [picker dismissModalViewControllerAnimated:YES];
}


# pragma mark - public methods

- (IBAction) myDealsButtonPressed
{
    
    MyDealsTableViewController * vc = [[MyDealsTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES]; 
    [vc release];
}

- (IBAction) myNotificationsButtonWasPressed
{
    
    NotificationsTableViewController * vc = [[NotificationsTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES]; 
    [vc release];
}

- (IBAction) changeImageButtonWasPressed
{
    [[[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"attachAPictureTitleKey",@"Attach a picture?") delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"takeAPhotoMsgKey",@"Take a photo"), 
       NSLocalizedString(@"cameraRollMsgKey",@"Camera Roll"), nil]
      autorelease] showFromTabBar:self.view];
}


- (IBAction) birthdateButtonWasPressed
{
    [ActionSheetPicker displayActionPickerWithView:self.view
                                    datePickerMode:UIDatePickerModeDate
                                      selectedDate:(userModel.birthDate ?userModel.birthDate : [NSDate date])
                                            target:self
                                            action:@selector(birthdateWasSelected:)
                                             title:NSLocalizedString(@"birthdateKey",@"Birthdate")];
    
}


- (IBAction) genderButtonWasPressed
{
    [ActionSheetPicker displayActionPickerWithView:self.view
                                              data:[NSArray arrayWithObjects:NSLocalizedString(@"maleKey",@"Male"), NSLocalizedString(@"femaleKey",@"Female"), nil]
                                     selectedIndex:0
                                            target:self
                                            action:@selector(genderWasSelected:)
                                             title:NSLocalizedString(@"genderKey",@"Gender")];
}


- (IBAction) languageButtonWasPressed
{
    [ActionSheetPicker displayActionPickerWithView:self.view
                                              data:[NSArray arrayWithObjects:@"English",@"French", @"Spanish", nil]
                                     selectedIndex:0
                                            target:self
                                            action:@selector(languageWasSelected:)
                                             title:NSLocalizedString(@"languageKey",@"Language")];
}


- (void) birthdateWasSelected:(NSDate *)birthdate
{
    [userModel setBirthDate:birthdate];
    birthdateTextField.text = [userModel stringFromBirthdate];
    [userModel setParam:userModel.birthDate];
}


-(void) genderWasSelected:(NSNumber *)index
{
    NSString * gender = nil;
    if ([index integerValue] == 0)
        gender = NSLocalizedString(@"maleKey",@"male");
    else
        gender = NSLocalizedString(@"femaleKey",@"Female");
    genderTextField.text = [gender capitalizedString];
    [userModel setGender:gender];
    [userModel setParam:userModel.gender];
}

-(void) languageWasSelected:(NSNumber *)index
{
    [userModel setLocaleID:@"EN"];
    [userModel setParam:userModel.localeID];
}


- (void) refresh
{
    if (!userModel)
    {
        userModel = [UserModel sharedUser];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kUserUpdatedNotification object:userModel];
    }
    if (userModel.image)
    {
        [detailImageButton setImageWithURL:[NSURL URLWithString:userModel.image] 
                          placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
   //     [detailImageButton setImage:[UIImage imageNamed:@"taptocustom.png"]
    //                       forState:UIControlStateNormal];
    }
    if ( [userModel.userName length] > 0 ) 
        //  titleLabel.text = userModel.userName;
        if ( [userModel points] )
            detailLabel.text = [NSString stringWithFormat:@"%d %@", userModel.points, NSLocalizedString(@"pointsKey",@"points to date")];
    /*
     if ( [userModel.realName length] > 0 )
     realNameTextField.text = userModel.realName;
     */
    if ( [userModel birthDate] )
        birthdateTextField.text = [userModel stringFromBirthdate];
    if ( ( [userModel.gender length] == 4 ) ) 
        genderTextField.text = userModel.gender;
    else
        genderTextField.text = NSLocalizedString(@"maleKey",@"male");
    
    if ([userModel deviceRegistered]) 
    {
        [statusImageView setImage:[UIImage imageNamed:@"greenStatus.png"]];
    } 
    else {
        [statusImageView setImage:[UIImage imageNamed:@"redStatus.png"]];
        
    }
    [titleLabel setText:[userModel userName]];
    CLGeocoder*  geocoder = [[CLGeocoder alloc] init];
    [userModel locate];
    [geocoder reverseGeocodeLocation:[userModel myLocation] completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             //        CLPlacemark *placemark=[placemarks objectAtIndex:0];
             locationLbl.text=[[placemarks objectAtIndex:0] thoroughfare];
         }
     }];
   [geocoder release];
}


- (void) useCamera
{
    camRoll = NO;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    }
}


- (void) useCameraRoll
{
    camRoll = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self.navigationController presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    }
}

- (IBAction)MySharesButtonPressed:(id)sender {
    MySharesTableViewController * vc = [[MySharesTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES]; 
    [vc release];

}

-(IBAction) myDealsButtonWasPressed
{
    
}
- (void) closeWindow {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)createdButtonPressed:(id)sender {
    CreatedTableViewController * vc = [[CreatedTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    /*  [self.navigationController pushViewController:vc
     animated:NO];*/
    [vc release];
    
}


@end