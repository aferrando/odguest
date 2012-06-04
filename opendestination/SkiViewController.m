//
//  SkiViewController.m
//  opendestination
//
//  Created by David Hoyos on 05/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "SkiViewController.h"
#import "RootViewController.h"
#import "OportunitiesListViewController.h"
#import "CategoryModel.h"


@implementation SkiViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = @"Ski";
    }
    return self;
}


- (void)dealloc
{
  [lessonsButton release];
  [guidedTourButton release];
  [childcareButton release];
  [eventsButton release];
  [rentalButton release];
  [buddiesButton release];
  
  [lessonsLabel release];
  [guidedTourLabel release];
  [childcareLabel release];
  [eventsLabel release];
  [rentalLabel release];
  [buddiesLabel release];
  
  [lessonsBadgetLabel release];
  [guidedTourBadgetLabel release];
  [childcareBadgetLabel release];
  [eventsBadgetLabel release];
  [rentalBadgetLabel release];
  [buddiesBadgetLabel release];
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
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) lessonsButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"7"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:7] autorelease]];
    vc.title = @"Lessons";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) guidedTourButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"8"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:8] autorelease]];
    vc.title = @"Guided tour";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) childcareButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"9"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:9] autorelease]];
    vc.title = @"Childcare";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) eventsButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"10"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:10] autorelease]];
    vc.title = @"Events";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) rentalButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"11"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:11] autorelease]];
    vc.title = @"Rentals";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (IBAction) buddiesButtonPressed
{
  if ( [(NSNumber *)[[self.category.sons objectForKey:@"12"] objectForKey:@"numOportunitys"] integerValue] > 0 )
  {
    OportunitiesListViewController * vc = [[OportunitiesListViewController alloc] init];
    [vc setCategory:[[[CategoryModel alloc] initWithId:12] autorelease]];
    vc.title = @"Buddies";
    [(RootViewController *)[self.view.window rootViewController] pushViewController:vc animated:YES];
    [vc release];
  }
}


- (void) reload
{
  lessonsBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"7"] objectForKey:@"numOportunitys"] stringValue];
  guidedTourBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"8"] objectForKey:@"numOportunitys"] stringValue];
  childcareBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"9"] objectForKey:@"numOportunitys"] stringValue];
  eventsBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"10"] objectForKey:@"numOportunitys"] stringValue];
  rentalBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"11"] objectForKey:@"numOportunitys"] stringValue];
  buddiesBadgetLabel.text = [(NSNumber *)[[self.category.sons objectForKey:@"12"] objectForKey:@"numOportunitys"] stringValue];
}

@end
