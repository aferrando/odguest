//
//  HomeViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "HomeViewController.h"
#import "RootViewController.h"
#import "UserModel.h"
#import "CategoryModel.h"
#import "SkiViewController.h"
#import "EAViewController.h"
#import "goingOutViewController.h"
#import "CarsharingViewController.h"
#import "OportunitiesListViewController.h"


@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = nil;
    }
    return self;
}

- (void)dealloc
{
  [skiButton release];
  [aeButton release];
  [shopsButton release];
  [gointOutButton release];
  [carsharingButton release];
  [miscButton release];
  
  [skiLabel release];
  [aeLabel release];
  [shopsLabel release];
  [goingOutLabel release];
  [carsharingLabel release];
  [miscLabel release];
  
  [skiBadgetLabel release];
  [aeBadgetLabel release];
  [shopsBadgetLabel release];
  [goingOutBadgetLabel release];
  [carsharingBadgetLabel release];
  [miscBadgetLabel release];
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
  [self setCategory:[[[CategoryModel alloc] initWithId:0] autorelease]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) skiButtonPressed
{
  
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"1"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    CustomContentViewController * vc = [[SkiViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:1] autorelease]];
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) aeButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"2"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    EAViewController * vc = [[EAViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:2] autorelease]];
    vc.title = @"A&E";
    [(RootViewController *)[self.view.window rootViewController]
    pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) shopsButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"5"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] initWithNibName:@"OportunitiesListViewController" bundle:[NSBundle mainBundle]];
    [vc setCategory:[[[CategoryModel alloc] initWithId:5] autorelease]];
    vc.title = @"Shops";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


-(IBAction) goingOutButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"3"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    goingOutViewController * vc = [[goingOutViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:3] autorelease]];
    vc.title = @"Going Out";
    [(RootViewController *)[self.view.window rootViewController]
    pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) carsharingButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"4"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    CarsharingViewController * vc = [[CarsharingViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:4] autorelease]];
    vc.title = @"Mobility";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) miscButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"6"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:6] autorelease]];
    vc.title = @"Miscelaneous";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (void) reload
{
  skiBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"1"] objectForKey:@"numOportunitys"] stringValue];
  aeBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"2"] objectForKey:@"numOportunitys"] stringValue];
  shopsBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"5"] objectForKey:@"numOportunitys"] stringValue];
  goingOutBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"3"] objectForKey:@"numOportunitys"] stringValue];
  carsharingBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"4"] objectForKey:@"numOportunitys"] stringValue];
  miscBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"6"] objectForKey:@"numOportunitys"] stringValue];
  if ( ( [[[UserModel sharedUser] destinationName] length] > 0 ) && ( self.title == nil ) )
  {
    self.title = [[UserModel sharedUser] destinationName];
    [self setTitleLabelForHeader];
  }
}

@end
