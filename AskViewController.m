//
//  AskViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 11/26/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "AskViewController.h"
#import "UserModel.h"
#import "IAMultipartRequestGenerator.h"
#import "JSON.h"
#import "Destination.h"
#import "OpportunityModel.h"


@interface AskViewController ()
@property ( nonatomic, assign ) NSInteger delay;
@property ( nonatomic ) UIButton * selectedCategory;
@property ( nonatomic ) UIImage * photoDeal;
- (void ) releaseTextFieldsKeyboard;
- (void) useCamera;
- (void) useCameraRoll;
- (void) sendOpportunity;
@end

@implementation AskViewController
@synthesize locationBtnPressed;
@synthesize wantSegControl;
@synthesize wasPublished, delay, selectedCategory, photoDeal,
askLocation, pictureLblView, whenLblView, locationLblView, mapView, askImageView;

static NSString *anotiationIdentifier = @"Annotation_identifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"askDealTitleKey", @"ASK A DEAL");
        self.wasPublished = NO;
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
    // Do any additional setup after loading the view from its nib.
    [titleTxtField setPlaceholder:NSLocalizedString(@"iwantTitleKey", @"Type what you want here.")];
    [descriptionTxtField setPlaceholder:NSLocalizedString(@"iwantDescriptionKey", @"Description (optional)")];
//    [shareBtn setTitle:NSLocalizedString(@"shareKey", @"Share it!") forState:UIControlStateNormal];
    shareBtn.enabled=NO; 
    locationLbl.text = NSLocalizedString(@"locationKey", @"Current Location");
    pictureLbl.text = NSLocalizedString(@"pictureKey", @"No Picture");
    whenLbl.text = NSLocalizedString(@"whenKey", @"In 30 Minutes");
    statusLbl.text = NSLocalizedString(@"statusKey", @"Not ready");
    pressMsgLbl.text = NSLocalizedString(@"pressMsgKey", @"Press 2 seconds");
   	//Create the segmented control
	NSArray *itemArray = [NSArray arrayWithObjects: NSLocalizedString(@"iwantKey", @"I want..."), NSLocalizedString(@"icommentKey", @"I comment"), NSLocalizedString(@"iwarnKey", @"I warn."), nil];
	wantSegControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    whenView.hidden= YES;
    pictureView.hidden= YES;
    locationView.hidden= YES;
    
    //setting location
    self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;
    
    
    //CLLocation * location = mapView.userLocation.location;
    //CLLocationDistance distance = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:_opportunity.latitude longitude:_opportunity.longitude]];
    //location.latitude=41.387917;
    //location.longitude=2.1699187;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.01;
    span.longitudeDelta=0.01;
    region.span = span;
    //Center in Current Location
    UserModel * user = [UserModel sharedUser];
    region.center = user.myLocation.coordinate;
    askLocation = [[CLLocation alloc] initWithLatitude:user.myLocation.coordinate.latitude
                               longitude:user.myLocation.coordinate.longitude];

    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];

    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(closeWindow)];      
    self.navigationItem.leftBarButtonItem = sendButton;

}

- (void)viewDidUnload
{
    [self setWantSegControl:nil];
    locationBtn = nil;
    pictureBtn = nil;
    whenBtn = nil;
    titleTxtField = nil;
    descriptionTxtField = nil;
    shareBtn = nil;
    locationLbl = nil;
    pictureLbl = nil;
    whenLbl = nil;
    statusLbl = nil;
    titleLbl = nil;
    whenViewLbl = nil;
    whenStpr = nil;
    whenView = nil;
    [self setLocationBtnPressed:nil];
    pictureLblView = nil;
    whenLblView = nil;
    pictureView = nil;
    locationView = nil;
    mapView = nil;
    pressMsgLbl = nil;
    noPictureBtn = nil;
    askImageView = nil;
    locationLblView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) closeWindow {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

- (IBAction) setLocation

{
    [self releaseTextFieldsKeyboard];
    if (locationBtn.selected) {
        locationBtn.selected=NO;
        locationView.hidden= YES;
        locationLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
    }
    else {
        locationBtn.selected=YES;
        locationView.hidden= NO;
        whenView.hidden= YES;
        pictureView.hidden= YES;
        pictureBtn.selected=NO;
        whenBtn.selected=NO;
        locationLblView.image=[UIImage imageNamed:@"backgroundred.png"];
        whenLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
        pictureLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
    }
    
}
#pragma mark - 

- (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    MKAnnotationView * annView = [aMapView dequeueReusableAnnotationViewWithIdentifier:anotiationIdentifier];
    if (!annView)
    {
        annView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anotiationIdentifier];
    }
    if ([annotation isKindOfClass:[OpportunityModel class]]) {
        annView.image = [UIImage imageNamed:@"redpin"];
        //annView.animatesDrop=TRUE;
        [annView setCanShowCallout:YES];    
        [annView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        return annView;
    }
    else{
        return nil;
    }
    return annView;
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}


- (void)mapView:(MKMapView *)mapView  annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    //TODO:
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
    annot.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annot];
    CLGeocoder*  geocoder = [[CLGeocoder alloc] init];
    askLocation = [[CLLocation alloc] initWithLatitude:annot.coordinate.latitude
                               longitude:annot.coordinate.longitude];
    [geocoder reverseGeocodeLocation:askLocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
     //        CLPlacemark *placemark=[placemarks objectAtIndex:0];
             locationLbl.text=[[placemarks objectAtIndex:0] thoroughfare];
  //           [placemark release];
         }
     }];
 //   [clickedLocation release];
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


- (IBAction) publish
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
        //To be reviewed with the rights categories
        NSNumber *cat = [NSNumber numberWithInt:wantSegControl.selectedSegmentIndex];
        NSNumber *lat = [NSNumber numberWithDouble:askLocation.coordinate.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:askLocation.coordinate.longitude];
        NSNumber *dst = [NSNumber numberWithInteger:user.destinationID];
        NSNumber *prv = [NSNumber numberWithBool:FALSE];
        NSNumber *uid = [NSNumber numberWithInteger:user.userID];
        NSNumber *min = [NSNumber numberWithInteger:whenStpr.value];
        
        NSNumber *duration = [NSNumber numberWithInteger:24*60];
        
        
        NSLog(@"userLocation: %f,%f",[lat doubleValue],[lon doubleValue]);
        //TODO: Language
        NSDictionary * jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   lat,@"latitude",
                                   lon,@"longitude",
                                   cat,@"category_id",
                                   descriptionTxtField.text,@"body",
                                   @"en_US",@"language_code",
                                   titleTxtField.text,@"opp_name",
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
            [self.askImageView.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
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
    if (textField.text.length > 5) {
            [shareBtn setEnabled:YES];
            statusLbl.text= NSLocalizedString(@"titleOkKey", @"Title Ok! (Min 5)");
    }
    else {
        [shareBtn setEnabled:NO];
        statusLbl.text= NSLocalizedString(@"needMoreDataKey", @"Title too short! (Min 5)");
    }
    switch ( textField.tag )
    {
        case 1:
            [descriptionTxtField becomeFirstResponder];
            break;
        default:
            [self setLocation]; 
            break;
    }
	return NO;
}


- (void) textFieldDidEndEditing:(UITextField *)textField
{
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

- (IBAction)pictureButtonPressed:(id)sender {
    [self releaseTextFieldsKeyboard];
    if (pictureBtn.selected)
    {  
    pictureBtn.selected=NO;
        pictureView.hidden= YES;
        pictureLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
    }
    else { 
        locationView.hidden =YES;
        whenView.hidden= YES;
        pictureBtn.selected=YES;
        pictureView.hidden= NO;
        pictureLblView.image=[UIImage imageNamed:@"backgroundred.png"];
        whenBtn.selected=NO;
        locationBtn.selected=NO;
        whenLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
        locationLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
   }
   // pictureLblView. 
}

- (IBAction)noPictureButtonPressed:(id)sender {
}

- (IBAction)cameraButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self.view.window.rootViewController presentModalViewController:imagePicker animated:YES];
    }
}

- (IBAction)rollButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self.view.window.rootViewController presentModalViewController:imagePicker animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{ 
    photoTaken = YES;
    if ( [[info objectForKey:UIImagePickerControllerEditedImage] isKindOfClass:[UIImage class]] )
        self.askImageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    else if ( [[info objectForKey:UIImagePickerControllerOriginalImage] isKindOfClass:[UIImage class]] )
        self.askImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:YES];
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    photoTaken = NO;
    [picker dismissModalViewControllerAnimated:YES];
}



- (void) useCamera
{
    camRoll = NO;

}

- (void) useCameraRoll
{
    camRoll = YES;
   
}


- (IBAction)whenButtonPressed:(id)sender {
    [self releaseTextFieldsKeyboard];
    if (whenBtn.selected) {
        whenBtn.selected=NO;
        whenView.hidden= YES;
        whenLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];

    }
    else {    
        locationView.hidden =YES;
        pictureView.hidden = YES;
        whenView.hidden= NO;

        whenBtn.selected=YES;
        whenLblView.image=[UIImage imageNamed:@"backgroundred.png"];
        pictureBtn.selected=NO;
        locationBtn.selected=NO;
        locationLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
        pictureLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
   }
}
- (IBAction)whenChanged:(UIStepper *)sender {
    double value = [sender value];
    
    [whenLbl setText:[NSString stringWithFormat:@"%d '", (int)value]];
    [whenViewLbl setText:[NSString stringWithFormat:@"%d", (int)value]];
}
@end
