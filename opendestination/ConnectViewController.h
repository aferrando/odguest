//
//  ConnectViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 11/27/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"
#import "IAMultipartRequestGenerator.h"
#import "MBProgressHUD.h"
#import "CategoryModel.h"
#import <MapKit/MapKit.h>

@interface ConnectViewController : UIViewController <UITextFieldDelegate,UIGestureRecognizerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate> {
    BOOL wasPublished;
    NSMutableArray *__unsafe_unretained imgArray;
    CLLocation *askLocation;
//    CategoryModel * _category;

    UISegmentedControl *wantSegControl;
    IBOutlet UIButton *locationBtn;
    IBOutlet UIButton *pictureBtn;
    IBOutlet UIButton *whenBtn;
    IBOutlet UITextField *titleTxtField;
    IBOutlet UITextField *descriptionTxtField;
    IBOutlet UIButton *shareBtn;
    IBOutlet UILabel *locationLbl;
    IBOutlet UILabel *pictureLbl;
    IBOutlet UILabel *whenLbl;
    IBOutlet UILabel *statusLbl;
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *startsInLbl;
    IBOutlet UILabel *minutesLbl;
    IBOutlet UILabel *whenViewLbl;
    IBOutlet UIStepper *whenStpr;
    IBOutlet UIView *whenView;
    IBOutlet UIImageView *pictureLblView;
    IBOutlet UIImageView *whenLblView;
    IBOutlet UIView *pictureView;
    IBOutlet UIView *locationView;
    IBOutlet MKMapView *mapView;
    IBOutlet UIImageView *locationLblView;
    IBOutlet UILabel *pressMsgLbl;
    IBOutlet UIButton *noPictureBtn;
    IBOutlet UIImageView *askImageView;
    IBOutlet UIScrollView *categoriesScrollView;
    IBOutlet UILabel *selectCategoryLbl;
    IBOutlet UILabel *categorySelectedLbl;
    IBOutlet UIView *resultView;
    IBOutlet UILabel *resultTitleLbl;
    IBOutlet UILabel *resultOpportunityLbl;
    IBOutlet UIImageView *resultImageView;
    IBOutlet UILabel *resultLocationLbl;
    IBOutlet UILabel *resultWhenLbl;
    IBOutlet UITextView *titleTextView;
    IBOutlet UIButton *resultButton;
    IBOutlet UISegmentedControl *activitySegCtrl;
    IBOutlet UIButton *selectActivityBtn;
    IBOutlet UIBarButtonItem *sendButton;
    IBOutlet UIBarButtonItem *closeButton;
    IBOutlet UIImageView *selectedTime;
    IBOutlet UIImageView *selectedLocation;
    IBOutlet UIImageView *selectedPicture;
@private
    BOOL _autoFirstResponder;
    BOOL fetchingData;
    BOOL photoTaken;
    BOOL camRoll;
}
@property ( assign ) BOOL wasPublished;
@property  CLLocation *askLocation;
@property ( unsafe_unretained ) NSMutableArray *imgArray;
@property ( nonatomic ) CategoryModel * category;
@property ( nonatomic) IBOutlet UISegmentedControl *wantSegControl;
@property ( nonatomic) IBOutlet UIButton *locationBtnPressed;
@property ( nonatomic) IBOutlet UIImageView *pictureLblView;
@property ( nonatomic) IBOutlet UIImageView *whenLblView;
@property ( nonatomic) IBOutlet UIImageView *locationLblView;
@property ( nonatomic) IBOutlet UIImageView *askImageView;
@property ( nonatomic) IBOutlet MKMapView *mapView;
@property ( nonatomic) IBOutlet UITextView *titleTextView;
- (IBAction)pictureButtonPressed:(id)sender;
- (IBAction)noPictureButtonPressed:(id)sender;
- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)rollButtonPressed:(id)sender;
- (IBAction)whenChanged:(id)sender;
- (IBAction)closeWindow:(id)sender;

- (IBAction)whenButtonPressed:(id)sender;
- (IBAction) publish;
- (IBAction) publishCommit;
- (IBAction) setLocation;
- (IBAction)closeResult:(id)sender;
- (IBAction)activityButtonPressed:(id)sender;
- (IBAction)activitySelected:(id)sender;
-(void) addCloseWindow;
-(void) addBackWindow;

@end
