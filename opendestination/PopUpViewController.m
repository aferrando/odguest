//
//  PopUpViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 7/27/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()

@end

@implementation PopUpViewController
@synthesize opportunity = _opportunity;
@synthesize codeLabel;

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
    [codeLabel setText:NSLocalizedString(@"waitingForReservationKey", @"")];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void) viewWillAppear:(BOOL)animated  {
        // codeLabel.text=[NSString stringWithFormat:@"%d",_opportunity.confirmationCode];
}
- (void)viewDidUnload
{
    [self setCodeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
