//
//  SnowConditionsViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/22/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "SnowConditionsViewController.h"
#import "GlobalConstants.h"
@interface SnowConditionsViewController ()

@end

@implementation SnowConditionsViewController
@synthesize totalSlopes;
@synthesize openSlopes;
@synthesize highestTemp;
@synthesize lowestTemp;
@synthesize highestWind;
@synthesize lowestWind;
@synthesize highestNewSnow;
@synthesize highestTotalSnow;
@synthesize lowestNewSnow;
@synthesize lowestTotalSnow;
@synthesize highestLabel;
@synthesize lowestLabel;
@synthesize highestWindLabel;
@synthesize lowestWindLabel;
@synthesize highestNewSnowLabel;
@synthesize highestTotalSnowLabel;
@synthesize lowestNewSnowLabel;
@synthesize lowestTotalSnowLabel;
@synthesize totalLifts;
@synthesize openLifts;
@synthesize overall;
@synthesize liftButton;
@synthesize slopesButton;
@synthesize snowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:background]]];
    [self setTitle:NSLocalizedString(@"snowConditionsKey", @"")];
    overall.layer.masksToBounds = YES;
    overall.layer.cornerRadius = 5.0;
    overall.layer.borderWidth = 1.0;
    overall.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    liftButton.layer.masksToBounds = YES;
    liftButton.layer.cornerRadius = 5.0;
    liftButton.layer.borderWidth = 1.0;
    liftButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    slopesButton.layer.masksToBounds = YES;
    slopesButton.layer.cornerRadius = 5.0;
    slopesButton.layer.borderWidth = 1.0;
    slopesButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    snowView.layer.masksToBounds = YES;
    snowView.layer.cornerRadius = 5.0;
    snowView.layer.borderWidth = 1.0;
    snowView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setOverall:nil];
    [self setLiftButton:nil];
    [self setSlopesButton:nil];
    [self setSnowView:nil];
    [self setTotalLifts:nil];
    [self setOpenLifts:nil];
    [self setTotalSlopes:nil];
    [self setOpenSlopes:nil];
    [self setHighestTemp:nil];
    [self setLowestTemp:nil];
    [self setHighestWind:nil];
    [self setLowestWind:nil];
    [self setHighestNewSnow:nil];
    [self setHighestTotalSnow:nil];
    [self setLowestNewSnow:nil];
    [self setLowestTotalSnow:nil];
    [self setHighestLabel:nil];
    [self setLowestLabel:nil];
    [self setHighestWindLabel:nil];
    [self setLowestWindLabel:nil];
    [self setHighestNewSnowLabel:nil];
    [self setHighestTotalSnowLabel:nil];
    [self setLowestNewSnowLabel:nil];
    [self setLowestTotalSnowLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
