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
#import "DemoAnnotationView.h"
#import "math.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalConstants.h"
#import "AwesomeMenu.h"

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(closeWindow)
     forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(5.0, 5.0, 25.0, 25.0);
    [self.view addSubview:button];
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
    menu.frame = CGRectMake(0, 200, 40, 40);
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
    switch (idx) {
        case 0:
            [self addRestaurants];
            break;
            
        case 1:
            [self addPOS];
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
        }
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
    a.contentPosition = CGPointMake(418, 230);
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
                
            default:
                 view.imageView.image = [UIImage imageNamed:@"buddies_icon70.png"];
                break;
        }
       
        [view sizeToFit];
        }
    
    return view;
}

#pragma mark - JCTileSource

#define SkippingGirlImageName @"SkippingGirl"

- (UIImage *)tiledScrollView:(JCTiledScrollView *)scrollView imageForRow:(NSInteger)row column:(NSInteger)column scale:(NSInteger)scale
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"4vallees_%dx_%d_%d.jpg", scale, row, column]]; 
}


@end
