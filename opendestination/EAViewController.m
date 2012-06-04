//
//  EAViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "EAViewController.h"
#import "RootViewController.h"
#import "OportunitiesListViewController.h"
#import "CategoryModel.h"

@implementation EAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = @"A & E";
    }
    return self;
}

- (void)dealloc
{
  [museumButton release];
  [swimmingPoolButton release];
  [cinemasButton release];
  [sportCentersButton release];
  
  [museumLabel release];
  [swimmingPoolLabel release];
  [cinemasLabel release];
  [sportCentersLabel release];
  
  [museumBadgetLabel release];
  [swimmingPoolBadgetLabel release];
  [cinemasBadgetLabel release];
  [sportCentersBadgetLabel release];
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


- (IBAction) museumButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"13"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:13] autorelease]];
    vc.title = @"Museums";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) swimmingPoolButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"14"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:14] autorelease]];
    vc.title = @"Swimming pool";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) cinemasButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"15"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:15] autorelease]];
    vc.title = @"Cinema";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) sportCentersButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"16"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:16] autorelease]];
    vc.title = @"Sport centers";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (void) reload
{
  museumBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"13"] objectForKey:@"numOportunitys"] stringValue];
  swimmingPoolBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"14"] objectForKey:@"numOportunitys"] stringValue];
  cinemasBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"15"] objectForKey:@"numOportunitys"] stringValue];
  sportCentersBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"16"] objectForKey:@"numOportunitys"] stringValue];
}


@end
