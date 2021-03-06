//
//  AskViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 11/26/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"
#import "IAMultipartRequestGenerator.h"
#import "MBProgressHUD.h"
#import <MapKit/MapKit.h>

@interface AskViewController : CustomContentViewController <UITextFieldDelegate,UIGestureRecognizerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate> {
    BOOL wasPublished;
    CLLocation *askLocation;
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
@private
    BOOL _autoFirstResponder;
    BOOL fetchingData;
    BOOL photoTaken;
    BOOL camRoll;
}
@property ( assign ) BOOL wasPublished;
@property  CLLocation *askLocation;
@property ( nonatomic) IBOutlet UISegmentedControl *wantSegControl;
@property ( nonatomic) IBOutlet UIButton *locationBtnPressed;
@property ( nonatomic) IBOutlet UIImageView *pictureLblView;
@property ( nonatomic) IBOutlet UIImageView *whenLblView;
@property ( nonatomic) IBOutlet UIImageView *locationLblView;
@property ( nonatomic) IBOutlet UIImageView *askImageView;
@property ( nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)pictureButtonPressed:(id)sender;
- (IBAction)noPictureButtonPressed:(id)sender;
- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)rollButtonPressed:(id)sender;
- (IBAction)whenChanged:(id)sender;

- (IBAction)whenButtonPressed:(id)sender;
- (IBAction) publish;
- (IBAction) setLocation;

@end
