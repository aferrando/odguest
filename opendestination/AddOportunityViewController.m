//
//  AddOportunityViewController.m
//  opendestination
//
//  Created by David Hoyos on 07/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "AddOportunityViewController.h"
#import "UserModel.h"
#import "IAMultipartRequestGenerator.h"
#import "JSON.h"
#import "Destination.h"


@interface AddOportunityViewController ()
  @property ( nonatomic, assign ) NSInteger delay;
  @property ( nonatomic ) UIButton * selectedCategory;
  @property ( nonatomic ) UIImage * photoDeal;
  - (void ) releaseTextFieldsKeyboard;
  - (void) useCamera;
  - (void) useCameraRoll;
  - (void) sendOpportunity;
@end


@implementation AddOportunityViewController

@synthesize wasPublished;
@synthesize delay, selectedCategory, photoDeal;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = NSLocalizedString(@"CreateDealTitleKey", @"CREATE A DEAL");
      self.wasPublished = NO;
      self.selectedCategory = nil;
      self.delay = 5;
      fetchingData = NO;
      photoTaken = NO;
      camRoll = NO;
      _autoFirstResponder = YES;
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

- (void)viewDidLoad
{
  [super viewDidLoad];
  [miscButton setSelected:YES];
  self.selectedCategory = miscButton;
    [oportunityName setPlaceholder:NSLocalizedString(@"opportunityTitleKey", @"Opportunity title..")];
    [oportunityDescrition setPlaceholder:NSLocalizedString(@"opportunityDescriptionKey", @"description")];
    [oportunityTags setPlaceholder:NSLocalizedString(@"opportunityWhereKey", @"Where?")];
    
  [oportunityDelay setTitle:[NSString stringWithFormat:@"%@ %d %@",
                             NSLocalizedString(@"startsKey", @"Starts in "), 
                             self.delay, 
                             NSLocalizedString(@"minutesKey", @"minutes")]
                   forState:UIControlStateNormal];
    [publishButton setTitle:NSLocalizedString(@"publishKey", @"Publish") forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillDisappear:(BOOL)animated {
  for (UIView* view in self.view.subviews) {
		if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
	}
  [choseDelayView setHidden:YES];
  [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setTitleLabelForHeader
{
  if ( ( self.title ) && !( [self.title isEqualToString:@""] ) )
  {
    self.titleLabel = [[UILabel alloc] initWithFrame:self.headerBackgroundImage.frame];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setText:self.title];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setTextAlignment:UITextAlignmentCenter];
    [self.headerBackgroundImage addSubview:self.titleLabel];
    self.titleLabel;
  }
}


#pragma mark - instance methods

- (IBAction) selectCategory:(id)sender
{
  [sender setSelected:YES];
  self.selectedCategory.selected = NO;
  self.selectedCategory = sender;
  self.selectedCategory.selected = YES;
}


- (IBAction) setOportunityStartDelay
{
  [self releaseTextFieldsKeyboard];
  [choseDelayView setHidden:NO];
}


- (IBAction) delaySelectedButtonPressed {
  [choseDelayView setHidden:YES];
}

- (IBAction) publish
{
  [self releaseTextFieldsKeyboard];
  if ( ( [oportunityName.text length] > 0 ) && ( [oportunityDescrition.text length] > 0 ) )
  {
    [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"AttachAPictureKey", @"Attach a picture?") delegate:self cancelButtonTitle:NSLocalizedString(@"CancelBtnKey", @"")  destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TakeAPhotoKey", @"Take a photo"), 
       NSLocalizedString(@"CameraRollKey", @"Camera Roll"),
       NSLocalizedString(@"NoPhotoKey", @"No photo"), nil] showInView:self.view.window.rootViewController.view];
  }
  else
  {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AlertKey", @"Alert") 
                        message:NSLocalizedString(@"NameMandatoryMsgKey", @"Name and description are mandatory fields.") delegate:nil 
                       cancelButtonTitle:NSLocalizedString(@"OkBtnKey", @"OK") 
                       otherButtonTitles:nil] show];
  }
}


- (void) sendOpportunity
{

  
  //Test if any field is empty and alert the user.
  

  if(!fetchingData){
    fetchingData = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    @try
    {
      [MBProgressHUD showHUDAddedTo:self.view.window.rootViewController.view animated:YES];
    }
    @catch (NSException * exception)
    {
      // Print exception information
      NSLog( @"NSException caught" );
      NSLog( @"Name: %@", exception.name);
      NSLog( @"Reason: %@", exception.reason );
    }
    UserModel * user = [UserModel sharedUser];
    
    NSString * type = @"info";
    NSNumber *cat = [NSNumber numberWithInt:selectedCategory.tag];
    NSNumber *lat = [NSNumber numberWithDouble:user.myLocation.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:user.myLocation.coordinate.longitude];
    NSNumber *dst = [NSNumber numberWithInteger:user.destinationID];
    NSNumber *prv = [NSNumber numberWithBool:FALSE];
    NSNumber *uid = [NSNumber numberWithInteger:user.userID];
    NSNumber *min = [NSNumber numberWithInteger:self.delay];
    NSNumber *duration = [NSNumber numberWithInteger:24*60];

    
    NSLog(@"userLocation: %f,%f",[lat doubleValue],[lon doubleValue]);
    //TODO: Language
    NSDictionary * jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                          lat,@"latitude",
                          lon,@"longitude",
                          cat,@"category_id",
                          oportunityDescrition.text,@"body",
                          @"en_US",@"language_code",
                          oportunityName.text,@"opp_name",
                          dst,@"destination_id",
                          user.udid, @"udid",
                          uid,@"id_owner",
                          prv, @"is_provider",
                          type,@"type",
                          min,@"delay",
                          duration,@"duration",
                          @"now",@"triggered",
                          [NSNull null],@"address",
                          [NSNull null],@"to",
                               nil];
        
    SBJsonWriter *jw = [[SBJsonWriter alloc]init];
    NSString *json = [jw stringWithObject:jsonDict];
    NSLog(@"jsonRep: %@",json );
    
    NSString * url = [[NSString stringWithFormat:@"%@/opportunity/create",[[Destination sharedInstance] destinationService]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@ Create Deal at %@",[self description], url);
    IAMultipartRequestGenerator *request = [[IAMultipartRequestGenerator alloc] initWithUrl:url andRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setString:json forField:@"json"];

    if(photoTaken)
    {
      CGSize newSize = CGSizeMake(280.0, 280.0);
      UIGraphicsBeginImageContext( newSize );
      [self.photoDeal drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
      UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate]; 
      NSString *fn = [NSString stringWithFormat:@"%d.%@", [user userID], [[NSNumber numberWithDouble:timestamp] stringValue] ];
      NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(newImage)];
      [request setData:imageData forField:@"image" type:1 fileName:fn];
      photoTaken = NO;
      camRoll = NO;
    }
    [request startRequest];
  }
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
    [self.view.window.rootViewController presentModalViewController:imagePicker animated:YES];
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
      [self.view.window.rootViewController presentModalViewController:imagePicker animated:YES];
  }
}


- (void ) releaseTextFieldsKeyboard
{
  for (UIView* view in self.view.subviews)
  {
		if ([view isKindOfClass:[UITextField class]])
    {
      if ( [view isFirstResponder] )
        [view resignFirstResponder];
    }
	}
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  _autoFirstResponder = NO;
  [self releaseTextFieldsKeyboard]; 
  _autoFirstResponder = YES;
	return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  switch ( textField.tag )
  {
    case 1:
      [oportunityDescrition becomeFirstResponder];
      break;
    case 2:
      [oportunityTags becomeFirstResponder];
      break;
    default:
      return YES;
      break;
  }
	return NO;
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
  switch ( textField.tag )
  {
    case 3:
      [self setOportunityStartDelay];
      break;
    default:
      [textField resignFirstResponder];
      break;
  }
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return 8;
}


#pragma mark -
#pragma mark UIPickerviewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSString * str = nil;
  switch (row) {
    case 0:
      str = NSLocalizedString(@"5minutesKey", @"5 minutes");
      break;
    case 1:
      str = NSLocalizedString(@"10minutesKey", @"10 minutes");
      break;
    case 2:
      str = NSLocalizedString(@"15minutesKey", @"15 minutes");
      break;
    case 3:
      str = NSLocalizedString(@"30minutesKey", @"30 minutes");
      break;
    case 4:
      str = NSLocalizedString(@"45minutesKey", @"45 minutes");
      break;
    case 5:
      str = NSLocalizedString(@"1hourKey", @"1 hour");
      break;
    case 6:
      str =  NSLocalizedString(@"2hoursKey", @"2 hours");
      break;
    case 7:
      str = NSLocalizedString(@"3hoursKey", @"3 hours");
      break;
    default:
      break;
  }
  return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  [oportunityDelay setTitle:[NSString stringWithFormat:@"Starts in %@", [self pickerView:pickerView
                                                                             titleForRow:row
                                                                            forComponent:component]]
                   forState:UIControlStateNormal];
  
  switch (row) {
    case 0:
      self.delay = 5;
      break;
    case 1:
      self.delay = 10;
      break;
    case 2:
      self.delay = 15;
      break;
    case 3:
      self.delay = 30;
      break;
    case 4:
      self.delay = 45;
      break;
    case 5:
      self.delay = 60;
      break;
    case 6:
      self.delay = 2 * 60;
      break;
    case 7:
      self.delay = 3 * 60;
      break;
    default:
      break;
  }
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  /*
    if (self.view.window.rootViewController.modalViewController)
      [self.view.window.rootViewController.modalViewController dismissModalViewControllerAnimated:YES]
  */
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
    case 2:
      [self sendOpportunity];
      break;
    default:
      break;
  }
}


# pragma mark - UINavigationControllerDelegate methods

- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  
}

#pragma mark - MBProgressHUDDelegateMethods

- (void)hudWasHidden:(MBProgressHUD *)hud
{

}


#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{ 
  photoTaken = YES;
  if ( [[info objectForKey:UIImagePickerControllerEditedImage] isKindOfClass:[UIImage class]] )
    self.photoDeal = [info objectForKey:UIImagePickerControllerEditedImage];
  else if ( [[info objectForKey:UIImagePickerControllerOriginalImage] isKindOfClass:[UIImage class]] )
    self.photoDeal = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self sendOpportunity];
  [picker dismissModalViewControllerAnimated:YES];
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  photoTaken = NO;
  [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark IAMultipartRequestGenerator delegate methods

-(void)requestDidFinishWithResponse:(NSData *)responseData {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [MBProgressHUD hideHUDForView:self.view.window.rootViewController.view animated:YES];
  
  NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  NSLog(@"opportunity created: %@", responseString);
  NSDictionary *dict = [responseString JSONValue];
  
  int error = [[dict objectForKey:@"errorCode"]intValue];
  UIAlertView *alert;
  switch(error)
  {
    case 0:
      alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealCreatedTitleKey", @"Deal Created")
                                         message:NSLocalizedString(@"dealCreatedMsgKey", @"Your deal was sent successfully")
                                        delegate:self cancelButtonTitle:NSLocalizedString(@"okBtnKey", @"")
                               otherButtonTitles: nil];
      break;
    case -1:
      alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                         message:NSLocalizedString(@"dealFailedMsgKey",@"Error. It hasn't been possible to set up a connection with APNS.")
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                               otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
      break;
    case -2:
      alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                         message:NSLocalizedString(@"udidMsgKey",@"Error. UDID are wrong.")
                                        delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                               otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
      break;
    case -3:
      alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                         message:NSLocalizedString(@"missingRequiredMsgKey",@"Error. Missing required parameter.")
                                        delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                               otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
      break;
    default:
      alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                         message:NSLocalizedString(@"unknownMsgKey",@"Unknown error")
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                               otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
      break;
  }
  [alert show];    
  fetchingData = NO;
  self.photoDeal = nil;
}


-(void)requestDidFailWithError:(NSError *)error
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [MBProgressHUD hideHUDForView:self.view.window.rootViewController.view animated:YES];
  NSLog(@"error: %@", [error description]);
  fetchingData = NO;
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"errorTitleKey",@"Error")
                                                   message:NSLocalizedString(@"connectionErrorMsgKey",@"Connection Error")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                                         otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
  [alert show];
}

@end