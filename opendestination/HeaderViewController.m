//
//  HeaderViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 7/2/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "HeaderViewController.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "UIColor-Expanded.h"
#import "MyDealsTableViewController.h"
#import "NotificationsTableViewController.h"
#import "MySharesTableViewController.h"
#import "SettingsViewController.h"
#import "GlobalConstants.h"
#import "SelectSignInViewController.h"
#import "MeTableViewController.h"
#import "EmptyHeaderViewController.h"
@interface HeaderViewController ()

@end

@implementation HeaderViewController
@synthesize userImage;
@synthesize pointProgressView;
@synthesize realnameTextField;
@synthesize mySettingsButton;
@synthesize points;
@synthesize level;
@synthesize levelName;
@synthesize likesButton;
@synthesize notificationsButton;
@synthesize sharesButton;
@synthesize myLikesLabel;
@synthesize notificationsLabel;
@synthesize sharesLabel;
@synthesize backgroundView;
@synthesize myLikesView;
@synthesize myNotifiticationView;
@synthesize mySharesView;
@synthesize minLabel;
@synthesize completedLabel;
@synthesize signOutButton;
@synthesize pointsButton;
@synthesize levelButton;
@synthesize locationLabel;
@synthesize userModel = _userModel;

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
    
  /*  CALayer *capa = [self.navigationController navigationBar].layer;
    [capa setShadowColor: [[UIColor blackColor] CGColor]];
    [capa setShadowOpacity:0.85f];
    [capa setShadowOffset: CGSizeMake(0.0f, 1.5f)];
    [capa setShadowRadius:2.0f];  
    [capa setShouldRasterize:YES];
    
    
        //Round
    CGRect bounds = capa.bounds;
    bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds 
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;*/

 /*   UserModel *user=[UserModel sharedUser];
    realnameTextField.text=user.userName;
        //    [self setTitle:user.realName];
    [self setTitle:@"Profile"];
    [userImage setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 5.0;
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    likesButton.layer.masksToBounds = YES;
    likesButton.layer.cornerRadius = 5.0;
    likesButton.layer.borderWidth = 1.0;
    likesButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    notificationsButton.layer.masksToBounds = YES;
    notificationsButton.layer.cornerRadius = 5.0;
    notificationsButton.layer.borderWidth = 1.0;
    notificationsButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    sharesButton.layer.masksToBounds = YES;
    sharesButton.layer.cornerRadius = 5.0;
    sharesButton.layer.borderWidth = 1.0;
    sharesButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    mySettingsButton.layer.masksToBounds = YES;
    mySettingsButton.layer.cornerRadius = 5.0;
    mySettingsButton.layer.borderWidth = 0.5;
    mySettingsButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [mySettingsButton setTitle:NSLocalizedString(@"SettingsKey", @"Social Networks") forState:UIControlStateNormal];
    [likesButton setTitle:[NSString stringWithFormat:@"%d", user.opportunities] forState:UIControlStateNormal];
    [sharesButton setTitle:[NSString stringWithFormat:@"%d", user.shares]  forState:UIControlStateNormal];
    [notificationsButton setTitle:[NSString stringWithFormat:@"%d", user.notifications] forState:UIControlStateNormal];
    if (user.notifications==0){
        notificationsButton.enabled=FALSE;
        notificationsButton.titleLabel.textColor=[UIColor lightGrayColor];
    }
    if (user.shares==0){
        sharesButton.enabled=FALSE;
        sharesButton.titleLabel.textColor=[UIColor lightGrayColor];
    }
    if (user.opportunities==0){
        likesButton.enabled=FALSE;
        likesButton.titleLabel.textColor=[UIColor lightGrayColor];
    }
    NSDictionary *level=[user level];
    if ( ([[level objectForKey:@"range_min"]  isKindOfClass:[NSString class]] ) && ( [[level objectForKey:@"range_max"] isKindOfClass:[NSString class]] ))
        {
    int range_min = [[level objectForKey:@"range_min"] integerValue];
        //  if 
    int range_max = [[level objectForKey:@"range_max"] integerValue];
    
    double ratio=(double) ( user.points- range_min)/(range_max-range_min);
    [self.pointProgressView setProgressTintColor:[ UIColor colorWithHexString:[user.level objectForKey:@"color"]]];
    [self.level setTextColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
    [points setText:[NSString stringWithFormat:@"%d", user.points]];
    [self.level setText:[level objectForKey:@"name"]];
    [self.pointProgressView setProgress:ratio animated:TRUE];
        }
    myLikesLabel.text= NSLocalizedString(@"myDealsKey",@"My Deals");
    sharesLabel.text= NSLocalizedString(@"myProposalsKey",@"My Proposals");
    notificationsLabel.text= NSLocalizedString(@"notificationsKey",@"Notifications");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]]];
    backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
    myLikesView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    myLikesView.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    myLikesView.layer.shadowOpacity = 1.0f;
    
    myLikesView.layer.shadowRadius = 10.0f;
    
    myNotifiticationView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    myNotifiticationView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    myNotifiticationView.layer.shadowOpacity = 1.0f;
    
    myNotifiticationView.layer.shadowRadius = 10.0f;
    
    mySharesView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    mySharesView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    mySharesView.layer.shadowOpacity = 1.0f;
    
    mySharesView.layer.shadowRadius = 10.0f;
    */
  /*  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"signOutKey", @"signout")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(signOut)];
    self.navigationItem.rightBarButtonItem = barButton;*/
    [signOutButton setTitle:NSLocalizedString(@"signOutKey", @"signout") forState:UIControlStateNormal];
  
    // Do any additional setup after loading the view from its nib.
}
- (void) viewWillAppear:(BOOL)animated {
    self.userModel=[UserModel sharedUser];
    if ((self.userModel.userName==nil) || ([self.userModel isGuest])) {
            [self setTitle:NSLocalizedString(@"myprofileKey", @"")];
            empty=[[EmptyHeaderViewController alloc] initWithNibName:@"EmptyHeaderViewController" bundle:nil ];
            [self.view addSubview:empty.view];
        /*

        
        SelectSignInViewController *loginVC = [[SelectSignInViewController alloc] initWithNibName:@"SelectSignInViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:loginVC];
        [navigationController.navigationBar setTintColor:kMainColor];
            //  loginVC.delegate = self;
            // LoginViewController * vc = [[LoginViewController alloc] init];
            //[vc addCloseWindow];
        [self.navigationController presentModalViewController:navigationController animated:YES];*/
       
    } else {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUser)
                                                 name:kUserUpdatedNotification
                                               object:self.userModel];
    
        [self.userModel refresh]; 
    realnameTextField.text=self.userModel.userName;
        //    [self setTitle:user.realName];
    [self setTitle:self.userModel.realName];
    [userImage setImageWithURL:[NSURL URLWithString:self.userModel.image] placeholderImage:[UIImage imageNamed:@"addPhoto.png"]];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 5.0;
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    likesButton.layer.masksToBounds = YES;
    likesButton.layer.cornerRadius = 5.0;
    likesButton.layer.borderWidth = 1.0;
    likesButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    notificationsButton.layer.masksToBounds = YES;
    notificationsButton.layer.cornerRadius = 5.0;
    notificationsButton.layer.borderWidth = 1.0;
    notificationsButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    sharesButton.layer.masksToBounds = YES;
    sharesButton.layer.cornerRadius = 5.0;
    sharesButton.layer.borderWidth = 1.0;
    sharesButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    mySettingsButton.layer.masksToBounds = YES;
    mySettingsButton.layer.cornerRadius = 5.0;
    mySettingsButton.layer.borderWidth = 0.5;
    pointsButton.layer.masksToBounds = YES;
    pointsButton.layer.cornerRadius = 5.0;
    pointsButton.layer.borderWidth = 0.5;
    levelButton.layer.masksToBounds = YES;
    levelButton.layer.cornerRadius = 5.0;
    levelButton.layer.borderWidth = 0.5;
    mySettingsButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [mySettingsButton setTitle:NSLocalizedString(@"SettingsKey", @"Social Networks") forState:UIControlStateNormal];
    [likesButton setTitle:[NSString stringWithFormat:@"%d", self.userModel.opportunities] forState:UIControlStateNormal];
    [sharesButton setTitle:[NSString stringWithFormat:@"%d", self.userModel.shares]  forState:UIControlStateNormal];
    [notificationsButton setTitle:[NSString stringWithFormat:@"%d", self.userModel.notifications] forState:UIControlStateNormal];
    if (self.userModel.notifications==0){
        notificationsButton.enabled=FALSE;
        notificationsButton.titleLabel.textColor=[UIColor lightGrayColor];
    } else {
        notificationsButton.enabled=TRUE;
    }
    if (self.userModel.shares==0){
        sharesButton.enabled=FALSE;
        sharesButton.titleLabel.textColor=[UIColor lightGrayColor];
    } else {
        sharesButton.enabled=TRUE;
    }
    if (self.userModel.opportunities==0){
        likesButton.enabled=FALSE;
        likesButton.titleLabel.textColor=[UIColor lightGrayColor];
    } else {
        likesButton.enabled=YES;
    }
    NSDictionary *level=[self.userModel level];
    if ( ([[level objectForKey:@"range_min"]  isKindOfClass:[NSString class]] ) && ( [[level objectForKey:@"range_max"] isKindOfClass:[NSString class]] ))
        {
        int range_min = [[level objectForKey:@"range_min"] integerValue];
            //  if 
        int range_max = [[level objectForKey:@"range_max"] integerValue];
        
        double ratio=(double) ( self.userModel.points- range_min)/(range_max-range_min);
        [self.pointProgressView setProgressTintColor:[ UIColor colorWithHexString:[self.userModel.level objectForKey:@"color"]]];
        [self.pointsButton setBackgroundColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
        [self.levelButton setBackgroundColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
        [self.levelButton setTitle:[NSString stringWithFormat:@"%@", [level objectForKey:@"name"]] forState:UIControlStateNormal];
            //  [self.points setTextColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
        [points setText:NSLocalizedString(@"pointsKey","")];
        [self.levelName setTextColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
        [self.level setText:[NSString stringWithFormat:@"%d", range_max]];
    
        [self.levelName setText:[NSString stringWithFormat:@"%@", [level objectForKey:@"name"]]];
        [self.pointProgressView setProgress:ratio animated:TRUE];
        [minLabel setText:[NSString stringWithFormat:@"%d", range_min]];
        }
    myLikesLabel.text= NSLocalizedString(@"myDealsKey",@"My Deals");
    sharesLabel.text= NSLocalizedString(@"myProposalsKey",@"My Proposals");
    notificationsLabel.text= NSLocalizedString(@"notificationsKey",@"Notifications");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]]];
    backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
    myLikesView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    myLikesView.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    myLikesView.layer.shadowOpacity = 1.0f;
    
    myLikesView.layer.shadowRadius = 10.0f;
    
    myNotifiticationView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    myNotifiticationView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    myNotifiticationView.layer.shadowOpacity = 1.0f;
    
    myNotifiticationView.layer.shadowRadius = 10.0f;
    
    mySharesView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    mySharesView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    mySharesView.layer.shadowOpacity = 1.0f;
    
    mySharesView.layer.shadowRadius = 10.0f;
    }
   
}
- (void) reloadUser {
    [self setTitle:self.userModel.realName];
    CLGeocoder*  geocoder = [[CLGeocoder alloc] init];
      [geocoder reverseGeocodeLocation:self.userModel.myLocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
             {
                 //        CLPlacemark *placemark=[placemarks objectAtIndex:0];
             [self.locationLabel setText:[[placemarks objectAtIndex:0] thoroughfare]];
                 //           [placemark release];
             }
     }];
    [userImage setImageWithURL:[NSURL URLWithString:self.userModel.image] placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 5.0;
    userImage.layer.borderWidth = 1.0;
    userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    likesButton.layer.masksToBounds = YES;
    likesButton.layer.cornerRadius = 5.0;
    likesButton.layer.borderWidth = 1.0;
    likesButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    notificationsButton.layer.masksToBounds = YES;
    notificationsButton.layer.cornerRadius = 5.0;
    notificationsButton.layer.borderWidth = 1.0;
    notificationsButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    sharesButton.layer.masksToBounds = YES;
    sharesButton.layer.cornerRadius = 5.0;
    sharesButton.layer.borderWidth = 1.0;
    sharesButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    mySettingsButton.layer.masksToBounds = YES;
    mySettingsButton.layer.cornerRadius = 5.0;
    mySettingsButton.layer.borderWidth = 0.5;
    mySettingsButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    [mySettingsButton setTitle:NSLocalizedString(@"SettingsKey", @"Social Networks") forState:UIControlStateNormal];
    [likesButton setTitle:[NSString stringWithFormat:@"%d", self.userModel.opportunities] forState:UIControlStateNormal];
    [sharesButton setTitle:[NSString stringWithFormat:@"%d", self.userModel.shares]  forState:UIControlStateNormal];
    [notificationsButton setTitle:[NSString stringWithFormat:@"%d", self.userModel.notifications] forState:UIControlStateNormal];
    if (self.userModel.notifications==0){
        notificationsButton.enabled=FALSE;
        notificationsButton.titleLabel.textColor=[UIColor lightGrayColor];
    } else {
        notificationsButton.enabled=TRUE;
    }
    if (self.userModel.shares==0){
        sharesButton.enabled=FALSE;
        sharesButton.titleLabel.textColor=[UIColor lightGrayColor];
    } else {
        sharesButton.enabled=TRUE;
    }
    if (self.userModel.opportunities==0){
        likesButton.enabled=FALSE;
        likesButton.titleLabel.textColor=[UIColor lightGrayColor];
    } else {
        likesButton.enabled=YES;
    }
    NSDictionary *level=[self.userModel level];
    if ( ([[level objectForKey:@"range_min"]  isKindOfClass:[NSString class]] ) && ( [[level objectForKey:@"range_max"] isKindOfClass:[NSString class]] ))
        {
        int range_min = [[level objectForKey:@"range_min"] integerValue];
            //  if 
        int range_max = [[level objectForKey:@"range_max"] integerValue];
        
        double ratio=(double) ( self.userModel.points- range_min)/(range_max-range_min);
        [self.pointProgressView setProgressTintColor:[ UIColor colorWithHexString:[self.userModel.level objectForKey:@"color"]]];
        [self.pointsButton setBackgroundColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
        [self.levelButton setBackgroundColor:[ UIColor colorWithHexString:[level objectForKey:@"color"]]];
        [self.levelButton setTitle:[level objectForKey:@"name"] forState:UIControlStateNormal];
        [self.pointsButton setTitle:[NSString stringWithFormat:@"%d", self.userModel.points] forState:UIControlStateNormal];
        [completedLabel setText:[NSString stringWithFormat:@"(%0.0f%% completed)", ratio*100]];
        [self.level setText:[NSString stringWithFormat:@"%d", range_max]];
        [self.pointProgressView setProgress:ratio animated:TRUE];
        [minLabel setText:[NSString stringWithFormat:@"%d", range_min]];
        }
    myLikesLabel.text= NSLocalizedString(@"myDealsKey",@"My Deals");
    sharesLabel.text= NSLocalizedString(@"myProposalsKey",@"My Proposals");
    notificationsLabel.text= NSLocalizedString(@"notificationsKey",@"Notifications");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]]];
    backgroundView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"brillant.png"]];
    myLikesView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    myLikesView.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    
    myLikesView.layer.shadowOpacity = 1.0f;
    
    myLikesView.layer.shadowRadius = 10.0f;
    
    myNotifiticationView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    myNotifiticationView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    myNotifiticationView.layer.shadowOpacity = 1.0f;
    
    myNotifiticationView.layer.shadowRadius = 10.0f;
    
    mySharesView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    
    mySharesView.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    mySharesView.layer.shadowOpacity = 1.0f;
    
    mySharesView.layer.shadowRadius = 10.0f;
   
}
- (void)viewDidUnload
{
    [self setUserImage:nil];
    [self setPointProgressView:nil];
    [self setRealnameTextField:nil];
    [self setMySettingsButton:nil];
    [self setPoints:nil];
    [self setLevel:nil];
    [self setLikesButton:nil];
    [self setNotificationsButton:nil];
    [self setSharesButton:nil];
    [self setMyLikesLabel:nil];
    [self setNotificationsLabel:nil];
    [self setSharesLabel:nil];
    [self setBackgroundView:nil];
    [self setMyLikesView:nil];
    [self setMyNotifiticationView:nil];
    [self setMySharesView:nil];
    [self setMinLabel:nil];
    [self setCompletedLabel:nil];
    [self setSignOutButton:nil];
    [self setPointsButton:nil];
    [self setLevelButton:nil];
    [self setLocationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)singOutBtnPressed:(id)sender {
    [self signOut];
}

-(void) addCloseWindow{
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeKey", @"Close") style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(closeWindow)];      
    self.navigationItem.leftBarButtonItem = sendButton;
    
}
- (IBAction)settingBtnPressed:(id)sender {
 
        //SettingsViewController *vc = [[SettingsViewController alloc] init];
    MeTableViewController *vc= [[MeTableViewController alloc] init];
    vc.title = NSLocalizedString(@"SettingsKey", @"Social Networks");;
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)likesBtnPressed:(id)sender {
    MyDealsTableViewController * vc = [[MyDealsTableViewController alloc] init];
    vc.title = NSLocalizedString(@"MyOpportunitieskey", @"Social Networks");;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)notificationBtnPressed:(id)sender {
    NotificationsTableViewController * vc = [[NotificationsTableViewController alloc] init];
    vc.title = NSLocalizedString(@"MyNotificationskey", @"Social Networks");;
[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sharesBtnPressed:(id)sender {
    MySharesTableViewController *vc = [[MySharesTableViewController alloc] init];
    vc.title = NSLocalizedString(@"MySharesKey", @"Social Networks");;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) closeWindow {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}
- (void) signOut {
    [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SignOutTitleKey",@"Are you sure you'd like to sign out?") delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"signOutKey",@"Sign Out"), nil] showFromTabBar:self.view];
    
}
#pragma mark - UIActionSheetDelegate methods

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
    [self.navigationController presentModalViewController:imagePickerController animated:YES];
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
    
    [choosePhotoActionSheet showFromTabBar:self.tabBarController.tabBar];
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
        //self.photo = ;
    [self.userImage setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
    [self.userModel postImage:[info objectForKey:UIImagePickerControllerEditedImage]];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissModalViewControllerAnimated:YES];
}


@end
