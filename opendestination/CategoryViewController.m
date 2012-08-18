//
//  CategoryViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/6/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "CategoryViewController.h"
#import "GlobalConstants.h"
#import "Destination.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface CategoryViewController ()
@end

@implementation CategoryViewController
@synthesize custom=_custom;
@synthesize categories=_categories;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        active=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _custom = [[CustomContentViewController alloc] init];
    [_custom setCategory:[[CategoryModel alloc] initWithId:0]];
    _categories = [[CategoriesTableViewController alloc] init];
    [_categories setCategory:[[CategoryModel alloc] initWithId:0]];
    [self.view setBackgroundColor:[UIColor redColor]];
    [_categories.view setBackgroundColor:[UIColor yellowColor]];
    [_custom.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_categories.view];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                              target:self
                                              action:@selector(reload)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                              target:self
                                              action:@selector(changeView)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void) viewWillAppear:(BOOL)animated {
    [self setTitleLabelForHeader];

}
-(void) reload {
    switch (active) {
        case 0:
            [_categories update];
            break;
            
        default:[_custom reload];
            break;
    }
    
    
}
-(void) changeView {
    switch (active) {
        case 0:
            [self.view addSubview:_custom.view];
            active=1;
            break;
            
        default:[self.view addSubview:_categories.view];
            active=0;
            break;
    }
   
   
}
- (void) setTitleLabelForHeader {
    
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 300, 30)]; 
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, 160, 30)];
    
    title.text = [[Destination sharedInstance] destinationName];
    [title setTextColor:[UIColor whiteColor]];
    [title setFont:[UIFont boldSystemFontOfSize:20.0]];
    
    [title setBackgroundColor:[UIColor clearColor]];
    UIImageView *myImageView = [[UIImageView alloc] init];
    [myImageView setImageWithURL:[NSURL URLWithString:[[Destination sharedInstance] destinationImage]] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
    
    myImageView.frame = CGRectMake(0, 0, 130, 30); 
    myImageView.layer.cornerRadius = 5.0;
    myImageView.layer.masksToBounds = YES;
    myImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    myImageView.layer.borderWidth = 0.1;
    
    [myView addSubview:title];
    [myView setBackgroundColor:[UIColor  clearColor]];
        //   [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
