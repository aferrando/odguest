//
//  CustomViewController.m g
//  opendestination
//
//  Created by David Hoyos on 04/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "CustomContentViewController.h"
#import "OportunitiesListViewController.h"
#import "CategoryModel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"

@implementation CustomContentViewController

@synthesize headerBackgroundImage, customView, titleLabel,
backButton, notificationsButton, transition, 
pageControl, customBadge;
@synthesize category = _category;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.transition = ContentPageTransitionTypeCurl;
    _categoriesButtons = nil;
    _categoriesBadgets = nil;
    _categoriesLabels = nil;
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_category release];
  [_categoriesButtons release];
  [_categoriesBadgets release];
  [_categoriesLabels release];
  [customView release];
    [pageControl release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark -
- (void) setCategory:(CategoryModel *)category {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kCategoryUpdatedNotification object:_category];
  [_category release];
  _category = nil;
  if (category) {
    _category = [category retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:(NSString *)kCategoryUpdatedNotification object:_category];
  }
}

#pragma mark -
- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.category.categoryID == 0) { 
    [backButton setHidden:YES];
  }
  [self setTitleLabelForHeader];
    customView.pagingEnabled = YES;
    customView = [[UIScrollView alloc] initWithFrame:CGRectMake(-2, 18, self.view.frame.size.width, self.view.frame.size.height)];

    customView.clipsToBounds = YES;
    customView.showsHorizontalScrollIndicator = NO;
//    [customView setBackgroundColor:[UIColor greenColor]];
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(141, 325, 38, 36);
    pageControl.hidesForSinglePage = YES;
    pageControl.userInteractionEnabled =YES;
    pageControlUsed = NO;
    [customView setDelegate:self];

    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
		// Add Badges to View
//	[self.view addSubview:customBadge];
 //   [self.view addSubview:notificationsButton];

}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:NO];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (_category)
  {
    [self reload];
    [self.category reload];
  }
}


-(void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}


- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (void) viewDidUnload {
  [super viewDidUnload];
  [backButton release];
  [headerBackgroundImage release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
 if(!pageControlUsed){   
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = pageNumber;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    customView.contentOffset = CGPointMake(320.0f * pageNumber, 0.0f);
    [UIView commitAnimations]; /*   static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed
        // Do your thing!
        previousPage = page;
    }*/
 }
}

- (void) pageTurn: (UIPageControl *) aPageControl
{
    pageControlUsed = YES;
    int whichPage = aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    customView.contentOffset = CGPointMake(320.0f * whichPage, 0.0f);
    [UIView commitAnimations];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


#pragma mark -
- (void) setTitleLabelForHeader {
  if ( ( self.title ) && !( [self.title isEqualToString:@""] ) )
  {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0,0.0,230, self.headerBackgroundImage.frame.size.height)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setText:self.title];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [self.titleLabel setMinimumFontSize:12.0];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setTextAlignment:UITextAlignmentCenter];
    [self.headerBackgroundImage addSubview:self.titleLabel];
    [self.titleLabel release];
  }
}

- (IBAction) goBack {
  [(RootViewController *)[self.view.window rootViewController] popViewControllerAnimated:YES];
}

- (IBAction) buttonPressed:(id)sender {
  CategoryModel * cat = [self.category.sons objectAtIndex:(NSUInteger)[(UIButton *)sender tag]];
  UIViewController * vc = nil;
  if ( ( cat.numOpportunities > 0) && ([cat.sons count] > 0) ) {
    vc = [[CustomContentViewController alloc] init];
    [(CustomContentViewController *)vc setCategory:cat];
  } else if (cat.numOpportunities > 0 ) {
     vc = [[OportunitiesListViewController alloc] init];
     [(OportunitiesListViewController *)vc setCategory:cat];
  } else {
    return;
  }
  [vc setTitle:cat.name];
  [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
  [vc release];
}

- (IBAction)notificationButtonPressed:(id)sender {
    
    NSLog(@"Notifications Pressed!");
}

- (void) reload {
  if (_categoriesButtons != nil) {
    for (UIView * v in _categoriesButtons) {
      [v removeFromSuperview];
    }
    [_categoriesButtons removeAllObjects];
  }else{
    _categoriesButtons = [[NSMutableArray alloc] initWithCapacity:0];
  }
  if (_categoriesBadgets != nil) {
    for (UIView * v in _categoriesBadgets) {
      [v removeFromSuperview];
    }
    [_categoriesBadgets removeAllObjects];
  }else{
    _categoriesBadgets = [[NSMutableArray alloc] initWithCapacity:0];
  }
  if (_categoriesLabels != nil) {
    for (UIView * v in _categoriesLabels) {
      [v removeFromSuperview];
    }
    [_categoriesLabels removeAllObjects];
  }else{
    _categoriesLabels = [[NSMutableArray alloc] initWithCapacity:0];
  }
  if ([_category.sons count] > 0) {
    for (NSUInteger i=0;i<[_category.sons count];i++) {
      CategoryModel *cat = [self.category.sons objectAtIndex:i];
      NSLog(@"%@",cat.name);
      UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0., 0., 78., 78.)];
      UILabel *bdgt = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 30., 30.)];
      UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., 98., 22.)];
      [btn setImageWithURL:[NSURL URLWithString:cat.imageURL] placeholderImage:[UIImage imageNamed:@"mistery_icon.png"]];
      [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
      [btn setTag:(NSInteger)i];
        //if the category has 0 opportunities set Enabled FALSE
        if( cat.numOpportunities == 0) [btn setEnabled:false];
      [_categoriesButtons addObject:btn];
      [bdgt setBackgroundColor:[UIColor orangeColor]];
      bdgt.layer.cornerRadius = 17.0;
      bdgt.layer.borderWidth = 3.0;
      bdgt.layer.borderColor = [[UIColor blackColor] CGColor];
      [bdgt setTextColor:[UIColor whiteColor]];
      [bdgt setTextAlignment:UITextAlignmentCenter];
      [bdgt setFont:[UIFont boldSystemFontOfSize:10.0]];
      [bdgt setText:[NSString stringWithFormat:@"%d",cat.numOpportunities]];
      [bdgt setTag:(NSInteger)i];
        //if the category has 0 opportunities set Enabled FALSE
        if( cat.numOpportunities == 0){ 
            [bdgt setBackgroundColor:[UIColor darkGrayColor]];
             [bdgt setTextColor:[UIColor lightGrayColor]];
        }
      [_categoriesBadgets addObject:bdgt];
      [lbl setBackgroundColor:[UIColor clearColor]];
      [lbl setTextColor:[UIColor whiteColor]];
        [lbl setShadowColor:[UIColor blackColor]];

      [lbl setFont:[UIFont systemFontOfSize:14.0]];
      [lbl setMinimumFontSize:10.0];
      [lbl setTextAlignment:UITextAlignmentCenter];
      [lbl setText:cat.name];
      [lbl setTag:(NSInteger)i];
        //if the category has 0 opportunities set Enabled FALSE
        if( cat.numOpportunities == 0) [lbl setTextColor:[UIColor grayColor]];
     [_categoriesLabels addObject:lbl];
      [btn release];
      [bdgt release];
      [lbl release];
    }
    [self showCategories];
  }
}


- (void) showCategories {
  if ([_categoriesButtons count] > 0) {
      // Init Page Control
       pageControl.numberOfPages = (([_categoriesButtons count]-1)/6)+1;
      pageControl.currentPage = 0;
      NSLog(@"Categories:%d, Num of pages:%u",[_categoriesButtons count], pageControl.numberOfPages);
    NSUInteger nn = [_categoriesButtons count];
      
      customView.contentSize = CGSizeMake(self.view.frame.size.width * pageControl.numberOfPages, self.view.frame.size.height);

      NSUInteger n=nn;
    CGFloat lines = 1.0;
    CGFloat row_max = 1.0;
    CGFloat inset = self.headerBackgroundImage.frame.size.height;
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height - inset*2;
    CGFloat row_width = 0.0;
    CGFloat row_height = 0.0;
      if (nn>6) n=6;
    if (n == 1) {
      lines = 1.;
      row_max = 1.0;
    } else if ((n%3)==0) {
      lines = floorf(n/3);
      row_max = 3.0;
    }  else if ((n%2) == 0) {
      lines = floorf(n/2);
      row_max = 2.0;
    } else {
      lines = (1.+floorf(n/3));
      row_max = 3.0;
    } 
    row_width = w/(row_max);
    row_height = h/lines;
    CGFloat line = 1.;
    CGFloat row = 1.0;
    for (NSUInteger i=0; i<nn; i++) {
      if (row>(NSUInteger)row_max) {
        line=line+1.0;
        row=1.0;
      }
        if (line>2.0) {
          //  pageControl.currentPage=pageControl.currentPage+1;
            line=1;
        }
      UIButton * btn = [_categoriesButtons objectAtIndex:i];
      UIButton * bdgt = [_categoriesBadgets objectAtIndex:i];
      UIButton * lbl = [_categoriesLabels objectAtIndex:i];
      btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0))+(320*(i/6)),floorf(inset+((line*row_height)-(row_height/2))));
      bdgt.center = CGPointMake(btn.frame.origin.x + btn.frame.size.width,btn.frame.origin.y + btn.frame.size.height);
      lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 4 + 11);
      [customView addSubview:btn];
      [customView addSubview:bdgt];
      [customView addSubview:lbl];
      row=row+1.0;
    }
      [self.view addSubview:customView];
      [self.view addSubview:pageControl];
  }
}
/*
 - (void) showCategories {
 if ([_categoriesButtons count] > 0) {
 NSUInteger n = [_categoriesButtons count];
 CGFloat lines = 1.0;
 CGFloat row_max = 1.0;
 CGFloat inset = self.headerBackgroundImage.frame.size.height;
 CGFloat w = self.view.frame.size.width;
 CGFloat h = self.view.frame.size.height - inset*2;
 CGFloat row_width = 0.0;
 CGFloat row_height = 0.0;
 if (n == 1) {
 lines = 1.;
 row_max = 1.0;
 } else if ((n%3)==0) {
 lines = floorf(n/3);
 row_max = 3.0;
 }  else if ((n%2) == 0) {
 lines = floorf(n/2);
 row_max = 2.0;
 } else {
 lines = (1.+floorf(n/3));
 row_max = 3.0;
 } 
 row_width = w/(row_max);
 row_height = h/lines;
 CGFloat line = 1.;
 CGFloat row = 1.0;
 for (NSUInteger i=0; i<n; i++) {
 if (row>(NSUInteger)row_max) {
 line=line+1.0;
 row=1.0;
 }
 UIButton * btn = [_categoriesButtons objectAtIndex:i];
 UIButton * bdgt = [_categoriesBadgets objectAtIndex:i];
 UIButton * lbl = [_categoriesLabels objectAtIndex:i];
 btn.center = CGPointMake(floorf((row*row_width)-(row_width/2.0)),floorf(inset+((line*row_height)-(row_height/2))));
 bdgt.center = CGPointMake(btn.frame.origin.x + btn.frame.size.width,btn.frame.origin.y + btn.frame.size.height);
 lbl.center = CGPointMake(btn.center.x, btn.center.y + btn.frame.size.height/2.0 + 4 + 11);
 [self.view addSubview:btn];
 [self.view addSubview:bdgt];
 [self.view addSubview:lbl];
 row=row+1.0;
 }
 }
 }*/

@end
