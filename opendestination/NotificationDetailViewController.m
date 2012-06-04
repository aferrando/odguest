//
//  NotificationDetailViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 12/23/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImageDownloader.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@implementation NotificationDetailViewController
@synthesize opportunity = _opportunity;
@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _spin = nil;
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 10.0;
    _imageView.layer.borderWidth = 1.0;
    _imageView.layer.borderColor = [[UIColor colorWithRed:128 green:128 blue:100 alpha:1.0] CGColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSpin) name:SDWebImageDownloadStartNotification object:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"Back" 
                                   style:UIBarButtonItemStylePlain
                                   target:self 
                                   action:@selector(back:)];
    backButton.image=[UIImage imageNamed:@"back_btn.png"];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self reload];
    
}
- (IBAction)back:(id)sender {
    // Your custom logic here
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadStartNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


# pragma mark -
- (void) setOpportunity:(OpportunityModel *)opportunity
{
    _opportunity = nil;
    _opportunity = opportunity;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:(NSString *)kOpportunityUpdatedNotification
                                               object:self.opportunity];
}

- (void) addSpin {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSpin) name:SDWebImageDownloadStopNotification object:nil];
    _spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spin setCenter:self.imageView.center];
    [_spin startAnimating];
}


- (void) removeSpin
{
    [_spin stopAnimating];
    _spin = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SDWebImageDownloadStopNotification object:self];
}

- (void) reload
{
 //   titleLabel.text = [_opportunity.name capitalizedString];
    self.navigationItem.title=[_opportunity.name capitalizedString];
    descriptionTextField.text = _opportunity.description;
    if ( [[_opportunity.owner objectForKey:@"address"] isKindOfClass:[NSString class]] )
        detailLabel.text = [_opportunity.owner objectForKey:@"address"];
    senderLabel.text = ([_opportunity.owner objectForKey:@"real_name"] ?[_opportunity.owner objectForKey:@"real_name"]:[_opportunity.owner objectForKey:@"user_name"]);
    NSLog(@"%@: image: %@", [self description], [NSURL URLWithString:_opportunity.imageURL]);
    [self.imageView setImageWithURL:[NSURL URLWithString:_opportunity.imageURL] placeholderImage:[UIImage imageNamed:@"deal_photodefault.png"]];
    [self.view setNeedsDisplay];
}

-(IBAction) interestedButtonPressed:(id)sender
{
    
    
    //[(UIButton *)sender setSelected:YES];
    switch (self.opportunity.status) {
        case OpportunityStatusWatched:
            if (  [(UserModel *)[UserModel sharedUser] isGuest]  )
            {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitleKey",@"Alert")
                                             message:NSLocalizedString(@"nonRegisteredMsgKey",@"Must be registered to set your deals and add points to your profile") delegate:nil cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") otherButtonTitles:nil] show];
            }
            else
            {
                [self.opportunity setInterested];
                [self showPoints];
                // Your custom logic here
                [self.navigationController popViewControllerAnimated:YES];

            }
            self.opportunity.status = OpportunityStatusInterested;
            if ( [self.opportunity.type isEqualToString: @"deal"] )
            {
                [(UIButton *)sender setTitle:@"Walk In" forState:UIControlStateNormal];
                self.opportunity.status = OpportunityStatusInterested;
                //TODO: SPLASH DE PUTNS.
            }
            else if ( [self.opportunity.type isEqualToString: @"info"] )
            {
                [(UIButton *)sender setHidden:YES];
            }
            else if ( [self.opportunity.type isEqualToString: @"event"] )
            {
                [(UIButton *)sender setHidden:YES];
                [self.opportunity syncEvent];
            }
            else if ( [self.opportunity.type isEqualToString: @"ticket"] )
            {
            }
            break;
        case OpportunityStatusInterested:
            if ( [self.opportunity.type isEqualToString: @"deal"] )
            {
                [self.opportunity setWalkin];
                self.opportunity.status = OpportunityStatusWalkin;
                // Your custom logic here
                [self.navigationController popViewControllerAnimated:YES];

            }
            else if ( [self.opportunity.type isEqualToString: @"info"] )
            {
                
            }
            else if ( [self.opportunity.type isEqualToString: @"event"] )
            {
                
            }
            else if ( [self.opportunity.type isEqualToString: @"ticket"] )
            {
                self.opportunity.status = OpportunityStatusConsumed;
            }
            [(UIButton *)sender setHidden:YES];
            break;
        case OpportunityStatusWalkin:
            [(UIButton *)sender setHidden:YES];
            self.opportunity.status = OpportunityStatusConsumed;
            break;
        case OpportunityStatusConsumed:
            [(UIButton *)sender setHidden:YES];
            self.opportunity.status = OpportunityStatusConsumed;
            break;
        default:
            [(UIButton *)sender setHidden:YES];
            break;
    }
//    [delegate instantDealDidFinish];
}


-(IBAction) notInterestedButtonPressed:(id)sender
{
    [self.opportunity setNotInterested];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) instantDealDidFinish
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) showPoints
{
    if (  [(UserModel *)[UserModel sharedUser] isGuest]  )
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alertTitleKey",@"Alert")
                                     message:NSLocalizedString(@"nonRegisteredMsgKey",@"Must be registered to set your deals and add points to your profile") delegate:nil cancelButtonTitle:NSLocalizedString(@"cancelBtnKey",@"Cancel") otherButtonTitles:nil] show];
    }
    else
    {
        _pointsSplash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_badget"]];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 72.0, 72.0)];
        
        [_pointsSplash setCenter:self.view.center];
        [self.view addSubview:_pointsSplash];
        [label setCenter:CGPointMake(150, 150)];
        label.font = [UIFont boldSystemFontOfSize:58];
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%d", self.opportunity.points];
        [label setTextAlignment:UITextAlignmentCenter];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        [_pointsSplash addSubview:label];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removePointsSplash) userInfo:nil repeats:NO];
    }
}

- (void) removePointsSplash
{
    [UIView animateWithDuration:0.4
                     animations:^{  [_pointsSplash setContentScaleFactor:0.1];}
                     completion:^(BOOL finished){[_pointsSplash removeFromSuperview];_pointsSplash = nil;;}];
}

@end
