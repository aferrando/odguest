    //
    //  mapaViewController.h
    //  e-noticies
    //
    //  Created by Gerard Porto on 6/16/11.
    //  Copyright 2011 Kirubs Applications. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "OCMapView.h"

@class OpportunityModel;

@interface mapaViewController : UIViewController <MKMapViewDelegate>
{
    UIImageView * headerBackgroundImage;
    IBOutlet UILabel * titleLabel;
    UIButton * backButton;
    UIViewController *managingViewController;
    IBOutlet OCMapView *mapView;    
    
    OpportunityModel * _opportunity;
    NSArray * _opportunities;
	MBProgressHUD *HUD;
    
}
@property ( nonatomic ) OpportunityModel * opportunity;
@property ( nonatomic ) NSArray * opportunities;
@property ( nonatomic ) IBOutlet UILabel * titleLabel;
@property ( nonatomic ) IBOutlet UIImageView * headerBackgroundImage;
@property ( nonatomic ) IBOutlet UIButton * backButton;
@property ( nonatomic, retain ) IBOutlet OCMapView *mapView;

- (void) setTitleLabelForHeader;
- (IBAction) goBack;
- (IBAction)zoomChanged:(UIStepper *)sender;

@end

