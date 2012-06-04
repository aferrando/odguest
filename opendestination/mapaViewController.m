#import "mapaViewController.h"
#import "RootViewController.h"
#import "JSON.h"
#import "OpportunityModel.h"
#import "OCMapViewSampleHelpAnnotation.h"
#import <math.h>


@implementation mapaViewController

@synthesize titleLabel, backButton, headerBackgroundImage;
@synthesize opportunity = _opportunity;
@synthesize opportunities = _opportunities;
@synthesize mapView;


static NSString *anotiationIdentifier = @"Annotation_identifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
if (self) {

    // Custom initialization
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
[self setTitleLabelForHeader];
self.mapView.delegate = self;
    //mapView. = 0.2;
self.mapView.showsUserLocation = YES;
[mapView setZoomEnabled:YES];
[mapView setScrollEnabled:YES];
mapView.showsUserLocation=TRUE;
MKCoordinateRegion region;
MKCoordinateSpan span;
span.latitudeDelta=0.06;
span.longitudeDelta=0.06;
region.span = span;

CLLocationCoordinate2D myCoord = {mapView.userLocation.location.coordinate.latitude,mapView.userLocation.location.coordinate.longitude};
[mapView setCenterCoordinate:myCoord animated:YES];
[mapView setRegion:region animated:YES]; 




    //CLLocation * location = mapView.userLocation.location;
    //CLLocationDistance distance = [location distanceFromLocation:[[CLLocation alloc] initWithLatitude:_opportunity.latitude longitude:_opportunity.longitude]];
    //location.latitude=41.387917;
    //location.longitude=2.1699187;
[mapView regionThatFits:region];
}


- (void) setOpportunity:(OpportunityModel *)opportunity
{
    //  [_opportunity release];
_opportunity = nil;
_opportunity = opportunity;

[self.mapView addAnnotation:_opportunity];
/*    MKCoordinateRegion region;
 MKCoordinateSpan span;
 span.latitudeDelta=0.06;
 span.longitudeDelta=0.06;
 region.span = span;
 region.center = self.mapView.userLocation.coordinate;
 
 [mapView setRegion:region animated:TRUE];
 [mapView regionThatFits:region];*/
}

- (void) setOpportunities:(NSArray *)opportunities
{
    //  _opportunities = nil;
_opportunities = [opportunities copy];
if (opportunities.count>0) [self setOpportunity:[_opportunities objectAtIndex:0]];
for (int i=0; i<opportunities.count; i++) {
[self.mapView addAnnotation:[_opportunities objectAtIndex:i]];
}
/*    MKCoordinateRegion region;
 MKCoordinateSpan span;
 span.latitudeDelta=0.06;
 span.longitudeDelta=0.06;
 region.span = span;
 region.center = self.mapView.userLocation.coordinate;
 
 [mapView setRegion:region animated:TRUE];
 [mapView regionThatFits:region];*/

}

    // ==============================
#pragma mark - map delegate
- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation{
MKAnnotationView *annotationView;

    // if it's a cluster
if ([annotation isKindOfClass:[OCAnnotation class]]) {

OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;

annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterView"];
    //[annotationView retain];
if (!annotationView) {
annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusterView"];
annotationView.canShowCallout = YES;
annotationView.centerOffset = CGPointMake(0, -20);
}
    //calculate cluster region
    //CLLocationDistance clusterRadius = mapView.region.span.longitudeDelta * mapView.clusterSize * 111000; //static circle size of cluster
CLLocationDistance clusterRadius = mapView.region.span.longitudeDelta/log(mapView.region.span.longitudeDelta*mapView.region.span.longitudeDelta) * log(pow([clusterAnnotation.annotationsInCluster count], 4)) * mapView.clusterSize * 50000; //circle size based on number of annotations in cluster

MKCircle *circle = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
[circle setTitle:@"background"];
[mapView addOverlay:circle];

MKCircle *circleLine = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
[circleLine setTitle:@"line"];
[mapView addOverlay:circleLine];

    // set title
clusterAnnotation.title = @"Cluster";
clusterAnnotation.subtitle = [NSString stringWithFormat:@"Containing annotations: %d", [clusterAnnotation.annotationsInCluster count]];

    // set its image
annotationView.image = [UIImage imageNamed:@"regular.png"];

    // change pin image for group
if (mapView.clusterByGroupTag) {
/*if ([clusterAnnotation.groupTag isEqualToString:kTYPE1]) {
 annotationView.image = [UIImage imageNamed:@"bananas.png"];
 }
 else if([clusterAnnotation.groupTag isEqualToString:kTYPE2]){
 annotationView.image = [UIImage imageNamed:@"oranges.png"];
 }*/
clusterAnnotation.title = clusterAnnotation.groupTag;
}
}
    // If it's a single annotation
else if([annotation isKindOfClass:[OCMapViewSampleHelpAnnotation class]]){
OCMapViewSampleHelpAnnotation *singleAnnotation = (OCMapViewSampleHelpAnnotation *)annotation;
annotationView = (MKAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"singleAnnotationView"];
    //[annotationView retain];
if (!annotationView) {
annotationView = [[MKAnnotationView alloc] initWithAnnotation:singleAnnotation reuseIdentifier:@"singleAnnotationView"];
annotationView.canShowCallout = YES;
annotationView.centerOffset = CGPointMake(0, -20);
}
singleAnnotation.title = singleAnnotation.groupTag;
/*
 if ([singleAnnotation.groupTag isEqualToString:kTYPE1]) {
 annotationView.image = [UIImage imageNamed:@"banana.png"];
 }
 else if([singleAnnotation.groupTag isEqualToString:kTYPE2]){
 annotationView.image = [UIImage imageNamed:@"orange.png"];
 }*/
}
    // Error
else{
annotationView = (MKPinAnnotationView *)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"errorAnnotationView"];
    //[annotationView retain];
if (!annotationView) {
annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"errorAnnotationView"];
annotationView.canShowCallout = NO;
((MKPinAnnotationView *)annotationView).pinColor = MKPinAnnotationColorRed;
}
}

return annotationView ;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
MKCircle *circle = overlay;
MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];

if ([circle.title isEqualToString:@"background"])
{
circleView.fillColor = [UIColor yellowColor];
circleView.alpha = 0.25;
}
else if ([circle.title isEqualToString:@"helper"])
{
circleView.fillColor = [UIColor redColor];
circleView.alpha = 0.25;
}
else
{
circleView.strokeColor = [UIColor blackColor];
circleView.lineWidth = 0.5;
}

return circleView ;
}

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated{
[mapView removeOverlays:mapView.overlays];
[mapView doClustering];
}


/*
 
 #pragma mark - 
 
 - (MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>) annotation
 {
 
 MKAnnotationView * annView = [aMapView dequeueReusableAnnotationViewWithIdentifier:anotiationIdentifier];
 if (!annView)
 {
 annView =[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anotiationIdentifier];
 }
 if ([annotation isKindOfClass:[OpportunityModel class]]) {
 annView.image = [UIImage imageNamed:@"redPin.png"];
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
 
 */

- (void) setTitleLabelForHeader
{
[self.titleLabel setText:self.title];
}



- (IBAction) goBack
{
    //  [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];
[self.view removeFromSuperview];
}

- (IBAction)zoomChanged:(UIStepper *)sender {
double value = [sender value];

MKCoordinateRegion region;
MKCoordinateSpan span;
span.latitudeDelta=value;
span.longitudeDelta=value;
region.span = span;
region.center = self.opportunity.coordinate;

[mapView setRegion:region animated:TRUE];
[mapView regionThatFits:region];

}


- (IBAction) mapButtonPressed
{
[self.view removeFromSuperview];
}


@end
