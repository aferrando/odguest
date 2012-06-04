//
//  CarsharingViewController.m
//  opendestination
//
//  Created by David Hoyos on 07/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "CarsharingViewController.h"
#import "RootViewController.h"
#import "OportunitiesListViewController.h"
#import "CategoryModel.h"

@implementation CarsharingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = @"Carsharing";
    }
    return self;
}

- (void)dealloc
{
  [carButton release];
  [busButton release];
  [taxiButton release];
  
  [carLabel release];
  [busLabel release];
  [taxiLabel release];

  [carBadgetLabel release];
  [busBadgetLabel release];
  [taxiBadgetLabel release];

  [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) carButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"23"] objectForKey:@"numOportunitys"] integerValue] )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:23] autorelease]];
    vc.title = @"Car";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) busButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"24"] objectForKey:@"numOportunitys"] integerValue] )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:24] autorelease]];
    vc.title = @"Bus";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) taxiButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"25"] objectForKey:@"numOportunitys"] integerValue] )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:25] autorelease]];
    vc.title = @"Taxi";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (void) reload
{
  carBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"23"] objectForKey:@"numOportunitys"] stringValue];
  busBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"24"] objectForKey:@"numOportunitys"] stringValue];
  taxiBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"25"] objectForKey:@"numOportunitys"] stringValue];
}


@end
