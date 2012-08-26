//
//  PistePlanViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/2/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "PistePlanViewController.h"
#import "JCTiledScrollView.h"
#import "JCAnnotation.h"
#import "JCPath.h"
#import "JCPathView.h"
#import "DemoAnnotationView.h"
#import "math.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalConstants.h"
#import "AwesomeMenu.h"
#import "UserModel.h"
#import "SkiLiftView.h"
#import <MapKit/MapKit.h>

#define PistePlanImageSize CGSizeMake(895., 421.)

@interface PistePlanViewController ()

@end

@implementation PistePlanViewController
@synthesize scrollView = _scrollView;
@synthesize detailView = _detailView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - View lifecycle
/*
- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)] ;
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.view = view;
}
*/
- (void)viewDidLoad
{
    _staticGPS= POIS_GPS;
    _staticPoints= POIS_XY;
    
    self.detailView = [[DetailView alloc] initWithFrame:CGRectZero] ;
    self.detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGSize size_for_detail = [self.detailView sizeThatFits:self.view.bounds.size];
    [self.detailView setFrame:CGRectMake(0,430,size_for_detail.width, size_for_detail.height)];
        //  [self.view addSubview:self.detailView];
    
    CGRect scrollView_frame =CGRectMake(0,0, 320, 460);
        //CGRectOffset(CGRectInset(self.view.bounds,0.,size_for_detail.height/2.0f),0.,size_for_detail.height/2.0f);
    
        //PDF
        //_scrollView = [[JCTiledPDFScrollView alloc] initWithFrame:scrollView_frame URL:[[NSBundle mainBundle] URLForResource:@"Map" withExtension:@"pdf"]];
    
        //Bitmap
    _scrollView = [[JCTiledScrollView alloc] initWithFrame:scrollView_frame contentSize:PistePlanImageSize];
    self.scrollView.dataSource = self;
    
    self.scrollView.tiledScrollViewDelegate = self;
    self.scrollView.zoomScale = 1.0f;
    
        // totals 4 sets of tiles across all devices, retina devices will miss out on the first 1x set
    self.scrollView.levelsOfZoom = 3;
    self.scrollView.levelsOfDetail = 2;
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.borderWidth = 1.5;
    self.view.layer.borderColor = [kMainColor CGColor];

    [self.view addSubview:self.scrollView];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setTitle:@"+ Annotations" forState:UIControlStateNormal];
    addButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 115, 25., 110, 38);
    addButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        //  [addButton addTarget:self action:@selector(addRandomAnnotations) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
        //   [self.view addSubview:addButton];
    [self tiledScrollViewDidZoom:self.scrollView]; //force the detailView to update the frist time
                                                   // [self addRandomAnnotations];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self 
               action:@selector(closeWindow)
     forControlEvents:UIControlEventTouchDown];
    [button setImage:[UIImage imageNamed:@"CloseButton.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(5.0, 5.0, 25, 25);
    [button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:button];
    UIButton *buttonZ = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonZ addTarget:self 
               action:@selector(zoomout)
     forControlEvents:UIControlEventTouchDown];
    [buttonZ setImage:[UIImage imageNamed:@"zoomout.png"] forState:UIControlStateNormal];
    buttonZ.frame = CGRectMake(275, 435, 30, 30);
    [buttonZ setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:buttonZ];
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"buddies_icon70.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:[UIImage imageNamed:@"winebar_icon70.png"] 
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:[UIImage imageNamed:@"rental_icon70.png"] 
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage 
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage 
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem7 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem8 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem9 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed 
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5,starMenuItem6, starMenuItem7, starMenuItem8,  nil];
       
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menus];
    menu.frame = CGRectMake(0, 210, 40, 40);
        // customize menu
    menu.rotateAngle = -M_PI/2;
    menu.menuWholeAngle = M_PI;
 	/*
     menu.rotateAngle = M_PI/3;
     menu.timeOffset = 0.2f;
     menu.farRadius = 180.0f;
     menu.endRadius = 100.0f;
     menu.nearRadius = 50.0f;
     */
	
    menu.delegate = self;
    [self.view addSubview:menu];
}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    [_scrollView removeAllAnnotations];
    [_scrollView removeAllPaths];
    switch (idx) {
        case 0:
            [self addRestaurants];
            break;
            
        case 1:
            [self addPOS];
            break;
        case 2:
            [self addStaticGPS];
            break;
        case 3:
            [self addMe];
            break;
            
        case 4:
            [self addCableLift];
            break;
            
        default:
            break;
    }
    
}

- (void) closeWindow {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.scrollView refreshAnnotations];
    [self.scrollView refreshPaths];
    [self becomeFirstResponder];
}



#pragma mark - Responder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake)
        {
        [_scrollView removeAllAnnotations];
        [_scrollView removeAllPaths];
        }
}
- (void) zoomout {
    [_scrollView setZoomScale:1.0 animated:YES];
}
- (void) zoomInOutChanged {
    
}
#pragma mark - Annotations

- (void)addRandomAnnotations
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand(42);
    });
    
    CGSize size = PistePlanImageSize;  
    for (int i = 0; i < 5; i++)
        {
        JCAnnotation *a = [[JCAnnotation alloc] init];
        a.contentPosition = CGPointMake((float)(rand() % (int)size.width), (float)(rand() % (int)size.height));
        [self.scrollView addAnnotation:a];
        }
}

#pragma mark - Annotations

- (void)addRestaurants
{
    
        // CGSize size = PistePlanImageSize;  
    JCAnnotation *a = [[JCAnnotation alloc] init];
    a.typeofService = 0;
    a.contentPosition = CGPointMake(158, 264);
    [self.scrollView addAnnotation:a];
    JCAnnotation *a2 = [[JCAnnotation alloc] init];
    a2.contentPosition = CGPointMake(151, 67);
    [self.scrollView addAnnotation:a2];
    JCAnnotation *a3 = [[JCAnnotation alloc] init];
    a3.contentPosition = CGPointMake(309, 153);
    [self.scrollView addAnnotation:a3];
    JCAnnotation *a4 = [[JCAnnotation alloc] init];
    a4.contentPosition = CGPointMake(284, 318);
    [self.scrollView addAnnotation:a4];
    /*    a.contentPosition = CGPointMake(55.0, 55.0);
     [self.scrollView addAnnotation:a];
     a.contentPosition = CGPointMake(60.0, 60.0);
     [self.scrollView addAnnotation:a];
     a.contentPosition = CGPointMake(70.0, 70.0);
     [self.scrollView addAnnotation:a];
     a.contentPosition = CGPointMake(80.0, 80.0);
     [self.scrollView addAnnotation:a];*/
}

- (void)addPOS
{
    
        // CGSize size = PistePlanImageSize;  
    JCAnnotation *a = [[JCAnnotation alloc] init];
    a.typeofService = 1;
    a.contentPosition = CGPointMake(428, 230);
    [self.scrollView addAnnotation:a];
    JCAnnotation *a2 = [[JCAnnotation alloc] init];
    a2.typeofService = 1;
    a2.contentPosition = CGPointMake(161, 67);
    [self.scrollView addAnnotation:a2];
    JCAnnotation *a3 = [[JCAnnotation alloc] init];
    a3.contentPosition = CGPointMake(800, 153);
    a3.typeofService = 1;
    [self.scrollView addAnnotation:a3];
    JCAnnotation *a4 = [[JCAnnotation alloc] init];
    a4.contentPosition = CGPointMake(284, 318);
    a4.typeofService = 1;
   [self.scrollView addAnnotation:a4];
    /*    a.contentPosition = CGPointMake(55.0, 55.0);
     [self.scrollView addAnnotation:a];
     a.contentPosition = CGPointMake(60.0, 60.0);
     [self.scrollView addAnnotation:a];
     a.contentPosition = CGPointMake(70.0, 70.0);
     [self.scrollView addAnnotation:a];
     a.contentPosition = CGPointMake(80.0, 80.0);
     [self.scrollView addAnnotation:a];*/
}
-(void) addCableLift {
    JCPathView *skilift=[[JCPathView alloc] initWithFrame:CGRectMake(0, 0, 800,800)];
    JCPath *p1= [[JCPath alloc] init];
    [p1 setView:skilift];
    p1.contentPosition = CGPointMake(284, 318);
        // [self.scrollView addPath:p1];
    
    [_scrollView addToCanvas:skilift];
}
- (CLLocation *) calculate2ndGPS:(CLLocation *)location {
    UserModel* me=[UserModel sharedUser];
    CLLocationCoordinate2D topLeftCorner;
    CLLocationCoordinate2D bottomRightCorner;
    if (location.coordinate.latitude<me.myLocation.coordinate.latitude)
        {
        topLeftCorner.latitude=location.coordinate.latitude;
        topLeftCorner.longitude=location.coordinate.longitude;
        }
    else {
        bottomRightCorner.latitude = location.coordinate.latitude;
        bottomRightCorner.longitude = location.coordinate.longitude;
    }
    for (int i=0; i<_staticGPS.count; i++) {
        CLLocation *locB = [_staticGPS objectAtIndex:i];
        if (location.coordinate.latitude<me.myLocation.coordinate.latitude) {
            bottomRightCorner.latitude = locB.coordinate.latitude;
            bottomRightCorner.longitude = locB.coordinate.longitude;
        } else {
            topLeftCorner.latitude=locB.coordinate.latitude;
            topLeftCorner.longitude=locB.coordinate.longitude;
        }
        CLLocationCoordinate2D targetCoordinate;
        targetCoordinate.latitude = me.myLocation.coordinate.latitude;
        targetCoordinate.longitude = me.myLocation.coordinate.longitude;
         BOOL isInside = FALSE;
        if ((targetCoordinate.latitude>topLeftCorner.latitude) && (bottomRightCorner.latitude>targetCoordinate.latitude))
            {
             if ((targetCoordinate.longitude>topLeftCorner.longitude) && (bottomRightCorner.longitude>targetCoordinate.longitude))
                 {
                  isInside = TRUE;
                  NSLog(@"Is INSIDE :%d ",i);
                 }
            }
/*         MKMapPoint topLeftPoint = MKMapPointForCoordinate(topLeftCorner);
        MKMapPoint bottomRightPoint = MKMapPointForCoordinate(bottomRightCorner);
        MKMapRect mapRect = MKMapRectMake(topLeftPoint.x, topLeftPoint.y, bottomRightPoint.x - topLeftPoint.x, bottomRightPoint.y - topLeftPoint.y);
        MKMapPoint targetPoint = MKMapPointForCoordinate(targetCoordinate);   
        
        BOOL isInside = MKMapRectContainsPoint(mapRect, targetPoint);  */
        NSLog(@"Is INSIDE :%d  VALUE:%d",i,isInside);
        NSLog(@"Top left: (%0.4f ,%0.4f)  Bottom right: (%0.4f ,%0.4f)",topLeftCorner.latitude,topLeftCorner.longitude,bottomRightCorner.latitude,bottomRightCorner.longitude);
        if (isInside) return locB;
    }
    return nil;
}
- (CGPoint ) coordinateToPoint:(CLLocation *)location
{
   
    CLLocationDistance minDistance=0;
    int minIndex=0;
    for (int i=0; i<_staticGPS.count; i++) {
        CLLocation *locB = [_staticGPS objectAtIndex:i];
        CLLocationDistance distanceBetween = [location
                                              distanceFromLocation:locB];
        NSLog(@"Current Distance: %0.2f  index:%d",distanceBetween ,i);
        if (minDistance==0) minDistance=distanceBetween;
        else {
            if (minDistance>distanceBetween) {
                minDistance=distanceBetween;
                minIndex=i;
            }
        }
    }
    NSValue *val = [_staticPoints objectAtIndex:minIndex];
    CLLocation *closestGPS = [_staticGPS objectAtIndex:minIndex];
    CLLocation *secondGPSofRectangle = [self calculate2ndGPS:closestGPS];
        //
    CGPoint p = [val CGPointValue];
    return p;
}
- (void) addMe
{
    UserModel* me=[UserModel sharedUser];
    JCAnnotation *a4 = [[JCAnnotation alloc] init];
    a4.contentPosition = [self coordinateToPoint:me.myLocation];
    a4.typeofService = 3;
    [self.scrollView addAnnotation:a4];
}
- (void) addStaticGPS
{
     for (int i=0; i<_staticPoints.count; i++) {
        NSValue *val = [_staticPoints objectAtIndex:i];
        CGPoint p = [val CGPointValue];  
        JCAnnotation *a4 = [[JCAnnotation alloc] init];
        a4.contentPosition = p;
        a4.typeofService = 2;
        [self.scrollView addAnnotation:a4];
    }
  
}

#pragma mark - JCTiledScrollViewDelegate

- (void)tiledScrollViewDidZoom:(JCTiledScrollView *)scrollView
{
        //    self.detailView.textLabel.text = [NSString stringWithFormat:@"zoomScale: %0.2f", scrollView.zoomScale];
}

- (void)tiledScrollView:(JCTiledScrollView *)scrollView didReceiveSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint tapPoint = [gestureRecognizer locationInView:(UIView *)scrollView.tiledView];
    
        //tap point on the tiledView does not inlcude the zoomScale applied by the scrollView
    self.detailView.textLabel.text = [NSString stringWithFormat:@"zoomScale: %0.2f, x: %0.0f y: %0.0f", scrollView.zoomScale, tapPoint.x, tapPoint.y];
    NSLog(@"zoomScale: %0.2f, x: %0.0f y: %0.0f", scrollView.zoomScale, tapPoint.x, tapPoint.y);
}

- (JCAnnotationView *)tiledScrollView:(JCTiledScrollView *)scrollView viewForAnnotation:(JCAnnotation *)annotation
{
    NSString static *reuseIdentifier = @"JCAnnotationReuseIdentifier";
    DemoAnnotationView *view = (id)[scrollView dequeueReusableAnnotationViewWithReuseIdentifier:reuseIdentifier];
    
    if (nil == view)
        {
        view = [[DemoAnnotationView alloc] initWithFrame:CGRectZero annotation:annotation reuseIdentifier:@"Identifier"];
        switch (annotation.typeofService) {
            case 0:
                view.imageView.image = [UIImage imageNamed:@"winebar_icon70.png"];
                break;
                
            case 1:
                view.imageView.image = [UIImage imageNamed:@"rental_icon70.png"];
                break;
                
            case 3:
                view.imageView.image = [UIImage imageNamed:@"regular.png"];
                break;
                
            default:
                 view.imageView.image = [UIImage imageNamed:@"buddies_icon70.png"];
                break;
        }
       
        [view sizeToFit];
        }
    
    return view;
}
- (JCPathView *)tiledScrollView:(JCTiledScrollView *)scrollView viewForPath:(JCPath *)path  
{
        //     NSString static *reuseIdentifier = @"JCPathReuseIdentifier";
        // DemoAnnotationView *view = (id)[scrollView dequeueReusableAnnotationViewWithReuseIdentifier:reuseIdentifier];
    
       
    return path.view;
}


#pragma mark - JCTileSource

#define SkippingGirlImageName @"SkippingGirl"

- (UIImage *)tiledScrollView:(JCTiledScrollView *)scrollView imageForRow:(NSInteger)row column:(NSInteger)column scale:(NSInteger)scale
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"4vallees_%dx_%d_%d.jpg", scale, row, column]]; 
}


@end
