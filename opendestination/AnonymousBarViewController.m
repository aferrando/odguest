//
//  AnonymousBarViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 7/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "AnonymousBarViewController.h"
#import "SelectSignInViewController.h"
#import "GlobalConstants.h"

@interface AnonymousBarViewController ()

@end

@implementation AnonymousBarViewController
@synthesize messageLabel;

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
    messageLabel.text=NSLocalizedString(@"engageSignInKey",  @"NO CATEGORIES AVAILABLE");

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signInBtnPressed:(id)sender {
    SelectSignInViewController *loginVC = [[SelectSignInViewController alloc] initWithNibName:@"SelectSignInViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:loginVC];
    [navigationController.navigationBar setTintColor:kMainColor];
        //   loginVC.delegate = self;
        // LoginViewController * vc = [[LoginViewController alloc] init];
        //  [loginVC addCloseWindow];
    

    [[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
}
@end
