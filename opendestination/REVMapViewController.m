//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVMapViewController.h"
#import "REVClusterMap.h"
#import "REVClusterAnnotationView.h"
#import "OpportunityModel.h"

#define BASE_RADIUS .5 // = 1 mile
#define MINIMUM_LATITUDE_DELTA 0.20
#define BLOCKS 4

#define MINIMUM_ZOOM_LEVEL 100000

@implementation REVMapViewController

- (void)dealloc
{
  //  [_mapView release],
    _mapView = nil;
  //  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    pins=[[NSMutableArray alloc] initWithCapacity:0];
    CGRect viewBounds = [[UIScreen mainScreen] applicationFrame];
    
    _mapView = [[REVClusterMapView alloc] initWithFrame:viewBounds];
    _mapView.delegate = self;

    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation=TRUE;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.06;
    span.longitudeDelta=0.06;
    region.span = span;
    
    CLLocationCoordinate2D myCoord = {_mapView.userLocation.location.coordinate.latitude,_mapView.userLocation.location.coordinate.longitude};    
    
    _mapView.region = MKCoordinateRegionMakeWithDistance(myCoord, 5000, 5000);
}
- (void) setOpportunities:(NSArray *)opportunities
{
    //  _opportunities = nil;
  //  _opportunities = [opportunities copy];
    //if (opportunities.count>0) [self setOpportunity:[opportunities objectAtIndex:0]];
    NSMutableArray *pins2 = [NSMutableArray array];
    
      

    for (int i=0; i<opportunities.count; i++) {
        OpportunityModel *opp=[opportunities objectAtIndex:i];
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        pin.title = opp.name;//  [NSString stringWithFormat:@"Pin %i",i+1];;
       // pin.subtitle = opp [NSString stringWithFormat:@"Pin %i subtitle",i+1];
        CLLocationCoordinate2D myCoord = {opp.latitude,opp.longitude};    
        
        pin.coordinate = myCoord;
       // [_mapView addAnnotation:pin];
        [pins addObject:pin];
        [pins2 addObject:pin];
        //[pin release]; 
    }
  [_mapView addAnnotations:pins2];
  /*  MKCoordinateRegion region;
     MKCoordinateSpan span;
     span.latitudeDelta=0.06;
     span.longitudeDelta=0.06;
     region.span = span;
     region.center = _mapView.userLocation.coordinate;
     
     [_mapView setRegion:region animated:TRUE];
     [_mapView regionThatFits:region];*/
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_mapView removeAnnotations:_mapView.annotations];
    _mapView.frame = self.view.bounds;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView;
    
    if( [pin nodeCount] > 0 ){
        pin.title = @"___";
        
        annView = (REVClusterAnnotationView*)
        [mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if( !annView )
            annView = (REVClusterAnnotationView*)
            [[REVClusterAnnotationView alloc] initWithAnnotation:annotation 
                                                  reuseIdentifier:@"cluster"] ;
        
        annView.image = [UIImage imageNamed:@"cluster.png"];
        
        [(REVClusterAnnotationView*)annView setClusterText:
         [NSString stringWithFormat:@"%i",[pin nodeCount]]];
        
        annView.canShowCallout = NO;
    } else {
        annView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        
        if( !annView )
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation 
                                                    reuseIdentifier:@"pin"] ;
        
        annView.image = [UIImage imageNamed:@"pinpoint.png"];
        annView.canShowCallout = YES;   
        
        annView.calloutOffset = CGPointMake(-6.0, 0.0);
    }
    return annView;
}

- (void)mapView:(MKMapView *)mapView 
didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"REVMapViewController mapView didSelectAnnotationView:");
    
    if (![view isKindOfClass:[REVClusterAnnotationView class]])
        return;
    
    CLLocationCoordinate2D centerCoordinate = [(REVClusterPin *)view.annotation coordinate];
    
    MKCoordinateSpan newSpan = 
    MKCoordinateSpanMake(mapView.region.span.latitudeDelta/2.0, 
                         mapView.region.span.longitudeDelta/2.0);
    
    //mapView.region = MKCoordinateRegionMake(centerCoordinate, newSpan);
    
    [mapView setRegion:MKCoordinateRegionMake(centerCoordinate, newSpan) 
              animated:YES];
}

@end
