//
//  goingOutViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "goingOutViewController.h"
#import "RootViewController.h"
#import "OportunitiesListViewController.h"
#import "CategoryModel.h"


@implementation goingOutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      self.title = @"Going Out";
    }
    return self;
}

- (void)dealloc
{
  [foodButton release];
  [barButton release];
  [wineBarButton release];
  [nightClubButton release];
  [pubButton release];
  [sportsBarButton release];
  
  [foodLabel release];
  [barLabel release];
  [wineBarLabel release];
  [nightClubLabel release];
  [pubLabel release];
  [sportsBarLabel release];
  
  [foodBadgetLabel release];
  [barBadgetLabel release];
  [wineBarBadgetLabel release];
  [nightClubBadgetLabel release];
  [pubBadgetLabel release];
  [sportsBarBadgetLabel release];
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


- (IBAction) foodButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"17"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:17] autorelease]];

    vc.title = @"Food";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) barButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"18"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:18] autorelease]];

    vc.title = @"Bar"; 
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) wineBarButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"19"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:19] autorelease]];
    vc.title = @"Wine bar";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) nightClubButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"20"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:20] autorelease]];
    vc.title = @"Night Club";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) pubButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"21"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:21] autorelease]];
    vc.title = @"Pub";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (IBAction) sportsBarButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"22"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:22] autorelease]];
    vc.title = @"Sports Bar";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}

- (void) reload
{
  foodBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"17"] objectForKey:@"numOportunitys"] stringValue];
  barBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"18"] objectForKey:@"numOportunitys"] stringValue];
  wineBarBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"19"] objectForKey:@"numOportunitys"] stringValue];
  nightClubBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"20"] objectForKey:@"numOportunitys"] stringValue];
  pubBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"21"] objectForKey:@"numOportunitys"] stringValue];
  sportsBarBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"22"] objectForKey:@"numOportunitys"] stringValue];
}

@end
