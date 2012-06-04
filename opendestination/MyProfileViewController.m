//
//  MyProfileViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import "MyProfileViewController.h"
#import "LoginViewController.h"
#import "MyDealsTableViewController.h"
#import "MySharesTableViewController.h"
#import "NotificationsTableViewController.h"
#import "CreatedTableViewController.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
#import "ActionSheetPicker.h"
#import "RootViewController.h"
#import "CustomBadge.h"
#import "DDMenuController.h"
#import "opendestinationAppDelegate.h"
#import "CategoryModel.h"
#import "GlobalConstants.h"
#import "Destination.h"
#import "SettingsViewController.h"

CGRect originalFrame;


@implementation MyProfileViewController

@synthesize avatar, menuTableView;

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
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeWindow)];      
    [sendButton setTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItem = sendButton;
    
    detailImageButton.layer.masksToBounds = YES;
    detailImageButton.layer.cornerRadius = 5.0;
    detailImageButton.layer.borderWidth = 1.0;
    detailImageButton.layer.borderColor = [[UIColor whiteColor] CGColor];
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
    if ([userModel isGuest]) [titleLabel setText:NSLocalizedString(@"guestKey", @"Guest")];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];
#warning If Points are not active
    if (![[Destination sharedInstance] usersPoints]) {
        [detailLabel setHidden:TRUE];
        [myPointsLbl setHidden:TRUE];
        [levelLabel setHidden:TRUE];
        [pointsBar setHidden:TRUE];
         
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
    if ([userModel isGuest]) [titleLabel setText:NSLocalizedString(@"guestKey", @"Guest")];
  // originalFrame = self.view.frame;
}


- (void)viewDidUnload
{
    languageLabel = nil;
    newPasswordLabel = nil;
    retypePasswordLabel = nil;
    birthdateLabel = nil;
    genderLabel = nil;
    myDealsLabel = nil;
    notificationsLabel = nil;
    statusImageView = nil;
    locationLbl = nil;
    tapToCustomizeLbl = nil;
    myWishesLbl = nil;
    myProposalsLbl = nil;
    myOpportunitiiesCounterLbl = nil;
    mySharesCounterLbl = nil;
    myNotificationsCounterLbl = nil;
    myWishesCounterLbl = nil;
    mySharesButton = nil;
    myNotificationsButton = nil;
    myPointsLbl = nil;
    menuTableView = nil;
    pointsBar = nil;
    levelLabel = nil;
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

- (void) showSignIn {
    [[UserModel sharedUser] signOut];
  //  if ( [delegate conformsToProtocol:@protocol(CollapseViewControllerDelegate)] )
   // opendestinationAppDelegate *appDelegate= ((opendestinationAppDelegate*)[[UIApplication sharedApplication] delegate]);

    //    [appDelegate mustShowSignIn];
    
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

- (void) showRegister{
    
}
#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //sign out confirmed
            [[UserModel sharedUser] signOut];
            
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
          //  loginVC.delegate = self;
           // LoginViewController * vc = [[LoginViewController alloc] init];
           // [vc addCloseWindow];
            UINavigationController *navigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:loginVC];
            [navigationController.navigationBar setTintColor:[UIColor clearColor]];
            opendestinationAppDelegate *appDelegate= ((opendestinationAppDelegate*)[[UIApplication sharedApplication] delegate]);
                     [(RootViewController *)[appDelegate.window rootViewController] presentModalViewController:navigationController animated:YES];
        }
            break;
        case 1:
            [self useCameraRoll];
            break;
        default:
            break;
    }
}
-(void) userDidSignIn {
    opendestinationAppDelegate *appDelegate= ((opendestinationAppDelegate*)[[UIApplication sharedApplication] delegate]);
    RootViewController *root=(RootViewController *)[appDelegate.window rootViewController];
    
    DDMenuController *menuController = (DDMenuController*) root.myRootViewController;
    CustomContentViewController * vc = [[CustomContentViewController alloc] init];
    [vc setCategory:[[CategoryModel alloc] initWithId:0]];
    
    vc.title =NSLocalizedString(@"LiveKey",@"Live");
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController.navigationBar setTintColor:kMainColor];
    
    [menuController setRootController:navController animated:YES];
}
-(void) userSignInFailed {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ErrorTitleKey", @"")
                                message:NSLocalizedString(@"SiginFailedMsgKey", @"") 
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"CancelBtnKey", @"")
                      otherButtonTitles:nil] show];
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
}

- (IBAction) myNotificationsButtonWasPressed
{
    
    NotificationsTableViewController * vc = [[NotificationsTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES]; 
}

- (IBAction) changeImageButtonWasPressed
{
    if (![userModel isGuest]){
    opendestinationAppDelegate *appDelegate= ((opendestinationAppDelegate*)[[UIApplication sharedApplication] delegate]);
    RootViewController *root=(RootViewController *)[appDelegate.window rootViewController];
    
    DDMenuController *menuController = (DDMenuController*) root.myRootViewController;

    SettingsViewController *vc = [[SettingsViewController alloc] init];
    vc.title = NSLocalizedString(@"SettingsKey", @"Social Networks");;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [navController.navigationBar setTintColor:kMainColor];
    
    [menuController setRootController:navController animated:YES];
    }
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
    if ([[userModel userName] isEqualToString:@""]) [titleLabel setText:NSLocalizedString(@"guestKey", @"Guest")];
    else {
        [titleLabel setText:[userModel userName]];
        [self setTitle:[userModel userName]];
    }
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
    [myOpportunitiiesCounterLbl setText:[NSString stringWithFormat:@"%d", [userModel opportunities]]];
    [mySharesCounterLbl setText:[NSString stringWithFormat:@"%d", [userModel shares]]];
    if ([userModel shares]==0) mySharesButton.enabled=FALSE;
    else {
        mySharesButton.enabled=TRUE;
    }
    [myNotificationsCounterLbl setText:[NSString stringWithFormat:@"%d", [userModel notifications]]];
    if ([userModel notifications]==0) myNotificationsButton.enabled=FALSE;
    [myPointsLbl setText:[NSString stringWithFormat:NSLocalizedString(@"%d points",@""), [userModel points]]];
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
    [self.menuTableView reloadData];
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
    }
}

- (IBAction)MySharesButtonPressed:(id)sender {
    MySharesTableViewController * vc = [[MySharesTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES]; 

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
    
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.5;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
   // cell.contentView.backgroundColor=[UIColor clearColor];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    UILabel *counterLbl=[[UILabel alloc] initWithFrame:CGRectMake(220, 15   , 30, 20)];
    [counterLbl setTextAlignment:UITextAlignmentCenter];
    counterLbl.backgroundColor=[UIColor clearColor];
    counterLbl.textColor=[UIColor orangeColor];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item.png"]]];
    [cell.contentView addSubview:counterLbl];
    cell.textLabel.textColor=[UIColor whiteColor];
    [counterLbl setFont:[UIFont boldSystemFontOfSize:22]];
    cell.userInteractionEnabled=TRUE;

    switch (indexPath.row) {
        case 0: cell.textLabel.text=NSLocalizedString(@"Livekey", @"Live");
            cell.textLabel.textColor=[UIColor whiteColor];
        
            cell.userInteractionEnabled = YES;
          //  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1: cell.textLabel.text=NSLocalizedString(@"MyOpportunitieskey", @"Social Networks");         //   cell.detailTextLabel.text=@"Opportunities you showed interest in";
          //  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
             [counterLbl setText:[[NSString alloc]initWithFormat:@"%d", [userModel opportunities]]];
             if ([userModel opportunities]==0)
             {
                 cell.textLabel.textColor=[UIColor darkGrayColor];
                 cell.userInteractionEnabled=FALSE;
 
             }
            
            // Add Badges to View

            break;
            
        case 2: cell.textLabel.text=NSLocalizedString(@"MyNotificationskey", @"Social Networks");         //   cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
         //   cell.detailTextLabel.text=@"Opportunities received by push"    ;
           [counterLbl setText:[[NSString alloc]initWithFormat:@"%d", [userModel notifications]]];
            if ([userModel notifications]==0)
            {
                cell.textLabel.textColor=[UIColor darkGrayColor];
                cell.userInteractionEnabled=FALSE;
                
            }
           
            break;
            
        case 3: cell.textLabel.text=NSLocalizedString(@"MySharesKey", @"Social Networks");
          //  cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //    cell.detailTextLabel.text=@"Opportunities shared by you";
           [counterLbl setText:[[NSString alloc]initWithFormat:@"%d", [userModel shares]]];
            if ([userModel shares]==0)
            {
                cell.textLabel.textColor=[UIColor darkGrayColor];
                cell.userInteractionEnabled=FALSE;
                
            }

            break;
            
        case 4: cell.textLabel.text=NSLocalizedString(@"MyWishesKey", @"Social Networks");;
        //    cell.detailTextLabel.text=@"Opportunities requested by you";
          //  cell.textLabel.textColor=[UIColor lightGrayColor];
           //[counterLbl setText:[[NSString alloc]initWithFormat:@"%d", [userModel wish]]];
           
            cell.userInteractionEnabled = YES;
            cell.accessoryType=UITableViewCellAccessoryNone;
          //  if ([userModel opportunities]==0)
           // {
                cell.textLabel.textColor=[UIColor darkGrayColor];
                cell.userInteractionEnabled=FALSE;
                
           // }

            break;
        case 5: cell.textLabel.text=NSLocalizedString(@"SocialNetworkskey", @"Social Networks");
          //  cell.textLabel.textColor=[UIColor whiteColor];
            cell.userInteractionEnabled = YES;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.textColor=[UIColor darkGrayColor];
            cell.userInteractionEnabled=FALSE;
            break;
            
       case 6: cell.textLabel.text=NSLocalizedString(@"SettingsKey", @"Configurations");
        //   cell.textLabel.textColor=[UIColor lightGrayColor];
           cell.userInteractionEnabled = YES;
           cell.accessoryType=UITableViewCellAccessoryNone;
            if ( ([userModel isGuest])) {
                cell.textLabel.textColor=[UIColor darkGrayColor];
                cell.userInteractionEnabled=NO;
               
            } else {
                cell.textLabel.textColor=[UIColor whiteColor];
                cell.userInteractionEnabled=YES;
               
            }
           break;
           
           
        case 7: {
            if (userModel.guest) {
                cell.textLabel.text=NSLocalizedString(@"SignInKey", @"Sign In") ;
                
            } else {
                cell.textLabel.text=NSLocalizedString(@"SignOutKey", @"Sign Out") ;
                
            }
           cell.textLabel.textColor=[UIColor whiteColor];
           cell.userInteractionEnabled = YES;
           cell.accessoryType=UITableViewCellAccessoryNone;
           break;
        }   
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    opendestinationAppDelegate *appDelegate= ((opendestinationAppDelegate*)[[UIApplication sharedApplication] delegate]);
    RootViewController *root=(RootViewController *)[appDelegate.window rootViewController];
    
    DDMenuController *menuController = (DDMenuController*) root.myRootViewController;
    UIViewController *vc=nil;
    switch (indexPath.row) {
        
        case 0: {
            // Live
            NSLog(@"");
            CustomContentViewController * vc = [[CustomContentViewController alloc] init];
            [vc setCategory:[[CategoryModel alloc] initWithId:0]];

            vc.title =NSLocalizedString(@"LiveKey",@"Live");
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navController.navigationBar setTintColor:kMainColor];

            [menuController setRootController:navController animated:YES];
    
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;}
        case 1: {             
            
            
            MyDealsTableViewController * vc = [[MyDealsTableViewController alloc] init];
            vc.title = NSLocalizedString(@"MyOpportunitieskey", @"Social Networks");;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navController.navigationBar setTintColor:kMainColor];
            
            [menuController setRootController:navController animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case 2: {             
            
            
            NotificationsTableViewController * vc = [[NotificationsTableViewController alloc] init];
            vc.title = NSLocalizedString(@"MyNotificationskey", @"Social Networks");;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navController.navigationBar setTintColor:kMainColor];
            
            [menuController setRootController:navController animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case 3:{
                // My Opportunities
            NSLog(@"");
            vc = [[MySharesTableViewController alloc] init];
            vc.title = NSLocalizedString(@"MySharesKey", @"Social Networks");;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navController.navigationBar setTintColor:kMainColor];
            
            [menuController setRootController:navController animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
                //       [self MySharesButtonPressed:self];            
            break;
            
        }       
        case 6:{
                // My Opportunities
            NSLog(@"");
            vc = [[SettingsViewController alloc] init];
            vc.title = NSLocalizedString(@"SettingsKey", @"Social Networks");;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            [navController.navigationBar setTintColor:kMainColor];
            
            [menuController setRootController:navController animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
                //       [self MySharesButtonPressed:self];            
            break;
            
        }       
        case 7:{
            // set the root controller
            NSLog(@"");
            if (userModel.guest) {
                LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                loginVC.delegate = self;
                // LoginViewController * vc = [[LoginViewController alloc] init];
                // [vc addCloseWindow];
                UINavigationController *navigationController = [[UINavigationController alloc]
                                                                initWithRootViewController:loginVC];
                [navigationController.navigationBar setTintColor:[UIColor clearColor]];
                [navigationController.navigationItem setTitle:NSLocalizedString(@"signInKey",@"Sign in")];
                [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];

//                [menuController setRootController:navigationController animated:YES];
       
            } else {
             [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SignOutTitleKey",@"Are you sure you'd like to sign out?") delegate:self cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"signOutKey",@"Sign Out"), nil] showFromTabBar:menuController.view];
            }
         
            break;
            
        }       
     }
   
}


@end