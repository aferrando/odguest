//
//  AskViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 11/26/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "ConnectViewController.h"
#import "UserModel.h"
#import "IAMultipartRequestGenerator.h"
#import "JSON.h"
#import "Destination.h"
#import "CustomNavigationBar.h"
#import "YRDropdownView.h"
#import "OpportunityModel.h"


@interface ConnectViewController ()
@property ( nonatomic, assign ) NSInteger delay;
@property ( nonatomic ) UIButton * selectedCategory;
@property ( nonatomic ) UIImage * photoDeal;
- (void ) releaseTextFieldsKeyboard;
- (void) useCamera;
- (void) useCameraRoll;
- (void) sendOpportunity;
@end

@implementation ConnectViewController
@synthesize locationBtnPressed;
@synthesize category=_category;
@synthesize wantSegControl, imgArray;
@synthesize wasPublished, delay, selectedCategory, photoDeal,
askLocation, pictureLblView, whenLblView, locationLblView, mapView, askImageView, titleTextView;

static NSString *anotiationIdentifier = @"Annotation_identifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:12.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor]; // change this color
        label.text = [_category name];
 //       self.navigationController.navigationBar.topItem.titleView = label;
  //      self.navigationItem.titleView = label;
        self.wasPublished = NO;
        self.delay = 5;
        fetchingData = NO;
        photoTaken = NO;
        camRoll = NO;
        _autoFirstResponder = YES;
        selectedTime.hidden =YES;
        selectedPicture.hidden = YES;
        selectedLocation.hidden = YES;
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
    //[super viewDidLoad];
    sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"sendKey", @"Send") style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(publishCommit)];      
    
    //    [shareBtn setTitle:NSLocalizedString(@"shareKey", @"Share it!") forState:UIControlStateNormal];
    shareBtn.enabled=NO; 
    locationLbl.text = NSLocalizedString(@"locationKey", @"Current Location");
    pictureLbl.text = NSLocalizedString(@"pictureKey", @"No Picture");
    whenLbl.text = NSLocalizedString(@"whenKey", @"In 30 Minutes");
    startsInLbl.text = NSLocalizedString(@"startsInKey", @"Starts in");
    minutesLbl.text = NSLocalizedString(@"minutesKey", @"Minutes");
    statusLbl.text = NSLocalizedString(@"140", @"Not ready");
    pressMsgLbl.text = NSLocalizedString(@"pressMsgKey", @"Press 2 seconds");
    resultTitleLbl.text = NSLocalizedString(@"resultTitleKey", @"is this What do you want?");
    titleLbl.text=NSLocalizedString(@"shareActivityKey", @"Share an activity");
   	//Create the segmented control
    whenView.hidden= YES;
    pictureView.hidden= YES;
    locationView.hidden= YES;
    resultView.hidden=YES;
    activitySegCtrl.hidden=YES;
 //   titleTextView.enabled=NO;
  //  titleTextView.placeholder=NSLocalizedString(@"selectActivityFirstKey", @"selectActivityFirst !!");
    sendButton.enabled=NO;
 //   [resultButton setTitle:NSLocalizedString(@"shareKey", @"Share it!") forState:UIControlStateNormal];
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
#warning NoLocation must be treated
    askLocation = [[CLLocation alloc] initWithLatitude:user.myLocation.coordinate.latitude
                                             longitude:user.myLocation.coordinate.longitude];
    
    
    [mapView setRegion:region animated:TRUE];
    [mapView regionThatFits:region];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    whenBtn.enabled=YES;
    locationBtn.enabled=YES;
    pictureBtn.enabled=YES;
 //   [titleTextView setEditable:YES];
    self.navigationItem.rightBarButtonItem = sendButton;
    [titleTxtField becomeFirstResponder];
    
      
    self.navigationItem.title=[_category name];
    [titleTxtField setPlaceholder:NSLocalizedString(@"adddescriptionKey", @"Add a description...")];
    titleTextView.text = NSLocalizedString(@"adddescriptionKey", @"Add a description...");
/*    
    
    // Get our custom nav bar
    CustomNavigationBar* customNavigationBar = (CustomNavigationBar*) self.navigationController.navigationBar;
    
    // Set the nav bar's background
    [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"nav_bg.png"]];*/
    // Create a custom back button
 /*   UIButton* backButton = [customNavigationBar backButtonWith:[UIImage imageNamed:@"navigationBarBackButton.png"] highlight:nil leftCapWidth:14.0];
    backButton.titleLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:239.0/255.0 blue:218.0/225.0 alpha:1];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];*/

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
    categoriesScrollView = nil;
    selectCategoryLbl = nil;
    categorySelectedLbl = nil;
    resultView = nil;
    resultTitleLbl = nil;
    resultOpportunityLbl = nil;
    resultImageView = nil;
    resultLocationLbl = nil;
    resultWhenLbl = nil;
    resultButton = nil;
    activitySegCtrl = nil;
    selectActivityBtn = nil;
    sendButton = nil;
    titleTextView = nil;
    closeButton = nil;
    startsInLbl = nil;
    minutesLbl = nil;
    selectedTime = nil;
    selectedLocation = nil;
    selectedPicture = nil;
    [super viewDidUnload];
    
/*   sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(publishCommit:)];      
    self.navigationItem.rightBarButtonItem = sendButton;*/
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -

- (void) setCategory:(CategoryModel *)category
{
    _category = nil;
    _category = category;

}
- (IBAction) setLocation

{
    [self releaseTextFieldsKeyboard];
    selectedLocation.hidden=NO;
    selectedTime.hidden=YES;
    selectedPicture.hidden=YES;
    
    if (locationBtn.selected) {
        locationBtn.selected=NO;
        [locationLbl setTextColor:[UIColor darkGrayColor]];
  //      locationView.hidden= YES;
 //       locationLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
    }
    else {
        locationBtn.selected=YES;
        [locationLbl setTextColor:[UIColor orangeColor]];

        locationView.hidden= NO;
        whenView.hidden= YES;
        pictureView.hidden= YES;
        if (whenBtn.selected==YES)
            sendButton.enabled=YES;
 /*       pictureBtn.selected=NO;
        whenBtn.selected=NO;
        locationLblView.image=[UIImage imageNamed:@"backgroundred.png"];
        whenLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
        pictureLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];*/
    }
    
}

- (IBAction)back:(id)sender {
    // Your custom logic here
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)closeResult:(id)sender {
    
    resultView.hidden=YES;
}

- (IBAction)activityButtonPressed:(id)sender {
    
    selectActivityBtn.hidden=NO;
    activitySegCtrl.hidden=NO;
    
}

- (IBAction)activitySelected:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    int value = segmentedControl.selectedSegmentIndex;
    
//    UISegmentedControl *
    selectActivityBtn.titleLabel.text=NSLocalizedString(@"activitySelected MsgKey %d",@"activity selected");
    [titleTextView setEditable:YES];
//    titleTextView.text=NSLocalizedString(@"activitySampleMsgKey", @"ActivitysampleMsgkey !!");
 //   titleTextView.enabled=YES;
    activitySegCtrl.hidden=YES;
    selectActivityBtn.hidden=NO;
    whenBtn.enabled=YES;
    [whenBtn setSelected:NO]; 
    [whenLbl setTextColor:[UIColor darkGrayColor]];
    locationBtn.enabled=YES;
    [locationBtn setSelected:NO]; 
    [locationLbl setTextColor:[UIColor darkGrayColor]];
    pictureBtn.enabled=YES;
    [pictureBtn setSelected:NO]; 
    [pictureLbl setTextColor:[UIColor darkGrayColor]];
    
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
             resultLocationLbl.text=[[placemarks objectAtIndex:0] thoroughfare];
             //           [placemark release];
         }
     }];
    //   [clickedLocation release];
}
- (void ) releaseTextFieldsKeyboard
{
    [titleTxtField resignFirstResponder];
 /*   for (UIView* view in self.view.subviews)
    {
		if ([view isKindOfClass:[UITextField class]])
        {
            if ( [view isFirstResponder] )
                [view resignFirstResponder];
        }
	}  */
}

- (IBAction) publish
{
    resultView.hidden=NO;
}

- (IBAction) publishCommit
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
        NSNumber *cat = [NSNumber numberWithInt:_category.categoryID];
        NSNumber *lat = [NSNumber numberWithDouble:askLocation.coordinate.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:askLocation.coordinate.longitude];
        NSNumber *dst = [NSNumber numberWithInteger:user.destinationID];
        NSNumber *prv = [NSNumber numberWithBool:FALSE];
        NSNumber *uid = [NSNumber numberWithInteger:user.userID];
        NSNumber *min = [NSNumber numberWithInteger:whenStpr.value];
        
        NSNumber *duration = [NSNumber numberWithInteger:2*60];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *startdate =  [dateFormatter stringFromDate:now];
        NSString *enddate = [dateFormatter stringFromDate:now];
        NSLog(@"userLocation: %f,%f",[lat doubleValue],[lon doubleValue]);
        //TODO: Language
#warning The GPS is wrong then we send the opportunity with the center of the destination as position
        if (([lat doubleValue] ==0.0) && ([lon doubleValue]==0.0)){
            lat=[NSNumber numberWithInt:1]; lon=[NSNumber numberWithInt:1];
        }
        NSDictionary * jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   lat,@"latitude",
                                   lon,@"longitude",
                                   cat ,@"category_id",
                                   titleTxtField.text,@"body",
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
                                  
startdate,@"startDate",
                                   enddate
,@"endDate",
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
    
        if ([titleTextView.text isEqualToString:NSLocalizedString(@"adddescriptionKey", @"Add a description...")]) {
            titleTextView.text = @"";
        }
        [titleTextView becomeFirstResponder];
  
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
    if ([titleTextView.text isEqualToString:@""]) {
        titleTextView.text = NSLocalizedString(@"adddescriptionKey", @"Add a description...");
    }
    if (titleTextView.text.length > 5) {
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
        case 2:
            [textField resignFirstResponder];   
        default:    
            return NO;
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
            [YRDropdownView showDropdownInView:[self.view.window rootViewController].view
                                         title:NSLocalizedString(@"dealCreatedTitleKey", @"Deal Created")
                                        detail:NSLocalizedString(@"dealCreatedMsgKey", @"Your deal was sent successfully")
                                         image:nil
                                      animated:YES
                                     hideAfter:3.0
                                          type:1];

/*            alert = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealCreatedTitleKey", @"Deal Created")
                                               message:NSLocalizedString(@"dealCreatedMsgKey", @"Your deal was sent successfully")
                                              delegate:self cancelButtonTitle:NSLocalizedString(@"okBtnKey", @"")
                                     otherButtonTitles: nil] autorelease];*/
            [self closeWindow];
            break;
            
        case -1:
            alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                               message:NSLocalizedString(@"dealFailedMsgKey",@"Error. It hasn't been possible to set up a connection with APNS.")
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                                     otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
             [alert show]; 
            break;
        case -2:
            alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                               message:NSLocalizedString(@"udidMsgKey",@"Error. UDID are wrong.")
                                              delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                                     otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
             [alert show]; 
            break;
        case -3:
            alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                               message:NSLocalizedString(@"missingRequiredMsgKey",@"Error. Missing required parameter.")
                                              delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                                     otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
             [alert show]; 
            break;
        default:
            alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"dealFailedTitleKey", @"Deal Failed")
                                               message:NSLocalizedString(@"unknownMsgKey",@"Unknown error")
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel")
                                     otherButtonTitles:NSLocalizedString(@"sendAgainBtnKey",@"Send again"), nil];
             [alert show]; 
            break;
    }
  //    
    fetchingData = NO;
    self.photoDeal = nil;
}

-(void) resetValues {
    
    selectActivityBtn.titleLabel.text=NSLocalizedString(@"selectActivityKey",@"Press to Select an Activity");
    titleTextView.text=NSLocalizedString(@"firstSelectAnActivityKey", @"firstSelectAnActivityKey !!");

    locationLbl.text = NSLocalizedString(@"locationKey", @"Current Location");
    pictureLbl.text = NSLocalizedString(@"pictureKey", @"No Picture");
    whenLbl.text = NSLocalizedString(@"whenKey", @"In 30 Minutes");
    statusLbl.text = NSLocalizedString(@"statusKey", @"Not ready");
    pressMsgLbl.text = NSLocalizedString(@"pressMsgKey", @"Press 2 seconds");
    resultTitleLbl.text = NSLocalizedString(@"resultTitleKey", @"is this What do you want?");
    titleLbl.text=NSLocalizedString(@"shareActivityKey", @"Share an activity");
   	//Create the segmented control
    whenView.hidden= YES;
    pictureView.hidden= YES;
    locationView.hidden= YES;
    resultView.hidden=YES;
    activitySegCtrl.hidden=YES;
    sendButton.enabled=NO;
    [resultButton setTitle:NSLocalizedString(@"shareKey", @"Share it!") forState:UIControlStateNormal];
    //setting location
    self.mapView.delegate = self;
	self.mapView.showsUserLocation = YES;
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
    whenBtn.enabled=NO;
    locationBtn.enabled=NO;
    pictureBtn.enabled=NO;
    [titleTextView setEditable:FALSE];
    [activitySegCtrl removeAllSegments];
    
    [whenLbl setTextColor:[UIColor whiteColor]];
    [locationLbl setTextColor:[UIColor whiteColor]];
     [pictureLbl setTextColor:[UIColor whiteColor]];

    //Configure Activities type
    [activitySegCtrl insertSegmentWithTitle: NSLocalizedString(@"buddiesKey", @"Buddies") atIndex: 0 animated: NO];
    [activitySegCtrl insertSegmentWithTitle: NSLocalizedString(@"carsharingKey", @"Carsharing") atIndex: 1 animated: NO];
    [activitySegCtrl insertSegmentWithTitle: NSLocalizedString(@"partyKey", @"Party") atIndex: 2 animated: NO];
    [activitySegCtrl insertSegmentWithTitle: NSLocalizedString(@"othersKey", @"Others") atIndex: 3 animated: NO];
    

}
-(void) closeWindow {
    [self resetValues];
    [self dismissModalViewControllerAnimated:YES];
  //  [(RootViewController *)self.view.window.rootViewController newOportunityPressed];
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
    selectedLocation.hidden=YES;
    selectedTime.hidden=YES;
    selectedPicture.hidden=NO;

    if (pictureBtn.selected)
    {  
        pictureBtn.selected=NO;
   //     pictureView.hidden= YES;
        [pictureLbl setTextColor:[UIColor darkGrayColor]];
        
//        pictureLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
    }
    else { 
        locationView.hidden =YES;
        whenView.hidden= YES;
        [pictureLbl setTextColor:[UIColor orangeColor]];
        pictureBtn.selected=YES;
        pictureView.hidden= NO;
        //       pictureLblView.image=[UIImage imageNamed:@"backgroundred.png"];
  //      whenBtn.selected=NO;
  //      locationBtn.selected=NO;
 //       whenLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
//locationLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
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
        [self presentModalViewController:imagePicker animated:YES];
    }
}

- (IBAction)rollButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        [self presentModalViewController:imagePicker animated:YES];
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
    resultImageView.image=askImageView.image;
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
    selectedLocation.hidden=YES;
    selectedTime.hidden=NO;
    selectedPicture.hidden=YES;

    if (whenBtn.selected) {
        whenBtn.selected=NO;
        whenView.hidden= YES;
        [whenLbl setTextColor:[UIColor darkGrayColor]];
        //     whenLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
        
    }
    else {    
        locationView.hidden =YES;
        pictureView.hidden = YES;
        whenView.hidden= NO;
        [whenLbl setTextColor:[UIColor orangeColor]];
    
        whenBtn.selected=YES;
        if (locationBtn.selected==YES)
            sendButton.enabled=YES;
   
        
    //    whenLblView.image=[UIImage imageNamed:@"backgroundred.png"];
//        pictureBtn.selected=NO;
  //      locationBtn.selected=NO;
    //    locationLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
    //    pictureLblView.image=[UIImage imageNamed:@"tabbarbackground.png"];
    }
}
- (IBAction)whenChanged:(UIStepper *)sender {
    double value = [sender value];
    
    [whenLbl setText:[NSString stringWithFormat:@"In %d '", (int)value]];
    [whenViewLbl setText:[NSString stringWithFormat:@"%d", (int)value]];
}
-(void) addCloseWindow{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeWindow2)];      
    
}
/*
-(void) addBackWindow{

UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                               initWithTitle:@"Back" 
                               style:UIBarButtonItemStylePlain
                               target:self 
                               action:@selector(back:)];
backButton.image=[UIImage imageNamed:@"back_btn.png"];

self.navigationItem.leftBarButtonItem = backButton;
}*/
- (void) closeWindow2 {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)closeWindow:(id)sender {
        //[self.navigationController newOportunityPressed];
//    [self.view removeFromSuperview];
}
@end
