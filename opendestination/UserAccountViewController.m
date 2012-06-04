//
//  UserAccountViewController.m
//  opendestination
//
//  Created by David Hoyos on 15/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "UserAccountViewController.h"
#import "MyDealsTableViewController.h"
#import "MyInterestsTableviewController.h"
#import "MyProfileViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface UserAccountViewController ()
-(void) setFrameForView:(UIView *)view;
@end

@implementation UserAccountViewController

@synthesize selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.transition = ContentPageTransitionTypeFlip;
      detailViewController = nil;
      self.selectedIndex = 0;
    }
    return self;
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
    [detailViewController.view removeFromSuperview];
    detailViewController = nil;
    detailViewController = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
 //   [self setFrameForView:detailViewController.view];
    [self.view addSubview:detailViewController.view];
    [detailViewController viewWillAppear:YES];
/*
    // Do any additional setup after loading the view from its nib.
  if (selectedIndex == 0)
    [self myDealsButtonPressed];
  else if ( selectedIndex == 1 )
    [self myInterestsButtonPressed];
  else if ( selectedIndex == 2 )
    [self myProfileButtonPressed];*/
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
  [detailViewController viewDidAppear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (void) setFrameForView:(UIView *)view
{
//  [view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 39, self.view.frame.size.width, self.view.frame.size.height)];
}*/


-(IBAction) myDealsButtonPressed
{
  if ( !(myDealsButton.selected) )
  {
    [myDealsButton setSelected:YES];
    [myInterestsButton setSelected:NO];
    [profileButton setSelected:NO];
    [detailViewController.view removeFromSuperview];
    detailViewController = nil;
    detailViewController = [[MyDealsTableViewController alloc] initWithStyle:UITableViewStylePlain];
 //   [self setFrameForView:detailViewController.view];
    [self.view addSubview:detailViewController.view];
    [detailViewController viewDidAppear:YES];
  }
}


-(IBAction) myInterestsButtonPressed
{
  if ( !(myInterestsButton.selected) )
  {
    [myDealsButton setSelected:NO];
    [myInterestsButton setSelected:YES];
    [profileButton setSelected:NO];
    [detailViewController.view removeFromSuperview];
    detailViewController = nil;
    detailViewController = [[MyInterestsTableViewController alloc] initWithStyle:UITableViewStylePlain];
 //   [self setFrameForView:detailViewController.view];
    [self.view addSubview:detailViewController.view];
  }
}


-(IBAction) myProfileButtonPressed
{
  if (!(profileButton.selected) )
  {
    [myDealsButton setSelected:NO];
    [myInterestsButton setSelected:NO];
    [profileButton setSelected:YES];
    [detailViewController.view removeFromSuperview];
    detailViewController = nil;
    detailViewController = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
 //   [self setFrameForView:detailViewController.view];
    [self.view addSubview:detailViewController.view];
    [detailViewController viewWillAppear:YES];
  }
}

@end