//
//  UIViewController+ClusterMapViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 5/24/12.
//  Copyright (c) 2012 None. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "OCMapView.h"
#import "CategoryModel.h"

#import <UIKit/UIKit.h>

@interface ClusterMapViewController: UIViewController <MKMapViewDelegate>
{
    OCMapView *mapView;    
    NSString *categoryName;
}
@property ( nonatomic, retain )  OCMapView *mapView;
@property (nonatomic, retain) NSString *categoryName;

- (void) setTitleLabelForHeader;
- (IBAction) goBack;
- (IBAction)zoomChanged:(UIStepper *)sender;
- (void) setOpportunities:(NSArray *)opportunities;

@end
