    //
//  OportunitiesListViewController.m
//  opendestination
//
//  Created by David Hoyos on 13/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "OpportunitiesListViewController.h"
#import "OpportunityModel.h"
#import "CustomTableViewCell.h"
#import "RootViewController.h"
#import "OportunityDetailViewController.h"
#import "TaggedNSURLConnectionsManager.h"
#import "UserModel.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "Destination.h"
#import "CellViewController.h"
#import "ConnectViewController.h"
#import "GlobalConstants.h"
#import "MixpanelAPI.h"
@implementation OpportunitiesListViewController

@synthesize categoryID;
@synthesize category;
@synthesize dataDict = _dataDict;
@synthesize tableViewController = _tableViewController;
    //@synthesize tileController;
@synthesize map;
static NSString *CellClassName = @"CellViewController";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userModel = [UserModel sharedUser]; 
        self.title = nil;
            //self.transition = ContentPageTranistionTypeNone;
        _opportunities = nil;
        _opportunities = [[NSMutableArray alloc] initWithCapacity:0];
        _opportunities4 = nil;
        _opportunities4 = [[NSMutableArray alloc] initWithCapacity:0];
        _opportunities24 = nil;
        _opportunities24 = [[NSMutableArray alloc] initWithCapacity:0];
        _opportunitiesLater = nil;
        _opportunitiesLater = [[NSMutableArray alloc] initWithCapacity:0];
        self.categoryID = 11;
        lastSelectedIndex=nil;
        cellLoader = [UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]];
        map = nil;
        
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
    // Do any additional setup after loading the view from its nib.
    [self.tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableViewController.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableViewController.clearsSelectionOnViewWillAppear = YES;
    [self.tableViewController.tableView setFrame:CGRectMake(0, 0., 320, 420)];
    //Trying MGTileMenu
/*    menuButton = [[UIButton alloc] initWithFrame:CGRectMake(20., 398., 52, 52)];
    [menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    menuButton.center = CGPointMake(160, 390);
    [menuButton setImage:[UIImage imageNamed:@"icon-plus.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"bg-addbutton.png"] forState:UIControlStateNormal];*/
        //   [self.view addSubview:menuButton];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"mapKey", @"Mapa")
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(showMapLocation)];
    self.navigationItem.rightBarButtonItem = barButton;
        // [barButton release];
 /*   UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 320, 2)];
         [overlayView setBackgroundColor:kMainColor];
          [self.navigationController.navigationBar addSubview:overlayView]; // navBar is your UINavigationBar instance
                                                                      // [overlayView release];
    SlidingTabsControl* tabs = [[SlidingTabsControl alloc] initWithTabCount:2 delegate:self];
    [self.view addSubview:tabs];*/
     [self.navigationItem setTitle:self.category.name];


}
-(void) showMenu {
    // If there isn't already a visible TileMenu, we should create one if necessary, and show it.
/*    if (!tileController || tileController.isVisible == NO) {
        if (!tileController) {
            // Create a tileController.
            tileController = [[MGTileMenuController alloc] initWithDelegate:self];
            tileController.dismissAfterTileActivated = YES; // to make it easier to play with in the demo app.
        }
        // Display the TileMenu.
        [tileController displayMenuCenteredOnPoint:CGPointMake(160, 470) inView:self.view];
        
            //    [menuButton setHidden:TRUE];
    }*/
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh]; //TODO reachability
    if (lastSelectedIndex)
        [self.tableViewController.tableView deselectRowAtIndexPath:lastSelectedIndex animated:YES];
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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 45)];
    
    UIImageView * imageView2 = nil;
    
    UILabel * action = [[UILabel alloc] initWithFrame:CGRectMake(19,3, 150, 25)];
    [action setBackgroundColor:[UIColor clearColor]];
    [action setTextColor:[UIColor whiteColor]];
    [action setShadowColor:[UIColor blackColor]];
    [action setShadowOffset:CGSizeMake(1.0, 1.0)];
    [action setFont:[UIFont systemFontOfSize:15]];
    UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 30)];
    switch (section) {
        case 0:
            [action setText:NSLocalizedString(@"NowKey",@"Now")];
            [coverView setBackgroundColor:[UIColor greenColor]];
            [coverView setAlpha:0.8];
            [headerView addSubview:coverView];
            
            imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 380)];
            [imageView2 setImage:[UIImage imageNamed:@"ribbonleftGreen.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
            [imageView2 setCenter:CGPointMake(44, 15)];
            [headerView addSubview:imageView2];
            
            break;
            
        case 1:
            [action setText:NSLocalizedString(@"In 2hKey",@"Now")];
            [coverView setBackgroundColor:[UIColor orangeColor]];
            [coverView setAlpha:0.8];
            [headerView addSubview:coverView];
            imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 380)];
            [imageView2 setImage:[UIImage imageNamed:@"ribbonleftOrange.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
            [imageView2 setCenter:CGPointMake(44, 15)];
            [imageView2 setImage:[UIImage imageNamed:@"ribbonleftOrange.png"]];
            [headerView addSubview:imageView2];
            break;
            
        case 2:
            [action setText:NSLocalizedString(@"In 4hKey",@"Now")];
            [coverView setBackgroundColor:[UIColor redColor]];
            [coverView setAlpha:0.8];
            [headerView addSubview:coverView];
            imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 380)];
            [imageView2 setImage:[UIImage imageNamed:@"ribbonleftOrangeDark.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
            [imageView2 setCenter:CGPointMake(44, 15)];
            [headerView addSubview:imageView2];
            break;
            
        case 3:
            [action setText:NSLocalizedString(@"LaterKey",@"Now")];
            [coverView setBackgroundColor:[UIColor darkGrayColor]];
            [coverView setAlpha:0.8];
            [headerView addSubview:coverView];
            imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 380)];
            [imageView2 setImage:[UIImage imageNamed:@"ribbonleftGray.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
            [imageView2 setCenter:CGPointMake(44, 15)];
            [headerView addSubview:imageView2];
            break;
            
        default:
            break;
    }
    /*   NSString *imageName=@"78-stopwatch.png";
     UIImageView * time = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,24.0f,24.0f)];
     [time setImage:[UIImage imageNamed:imageName]];
     [time setCenter:CGPointMake(20, 15)];
     [headerView addSubview:[time autorelease]];
     
     imageName=@"07-map-marker.png";
     
     time = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,18.0f,24.0f)];
     [time setImage:[UIImage imageNamed:imageName]];
     [time setCenter:CGPointMake(70, 15)];
     [headerView addSubview:[time autorelease]];
     
     time = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,13.0f,13.0f)];
     [time setImage:[UIImage imageNamed:imageName]];
     [time setCenter:CGPointMake(120, 10)];
     [headerView addSubview:[time autorelease]];
     
     
     
     [barView addSubview:[action autorelease]];*/
    
    [headerView addSubview:action];
    
    return headerView;
}
#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}


# pragma mark -
# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [_opportunities count];
            break;
            
        case 1:
            return [_opportunities4 count];
            break;
            
        case 2:
            return [_opportunities24 count];
            break;
            
        case 3:
            return [_opportunitiesLater count];
            break;
            
        default:
            return 0;
            break;
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if ([self.categorys count] !=0) {
    //Category * c = [self.categories objectAtIndex:[indexPath row]];
    
	if (cell == nil) {		
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        /*      if (indexPath.row==0) 
         {
         [cell addSubview:[action autorelease]];
         return cell;
         }
         else {*/
        OpportunityModel * opp = nil;
        switch (indexPath.section) {
            case 0:
                opp = [_opportunities objectAtIndex:indexPath.row];
                
                break;
                
            case 1:
                opp = [_opportunities4 objectAtIndex:indexPath.row];
                
                break;
                
            case 2:
                opp = [_opportunities24 objectAtIndex:indexPath.row];
                
                break;
                
            case 3:
                opp = [_opportunitiesLater objectAtIndex:indexPath.row];
                
                break;
                
            default:
                break;
        }
        //     OpportunityModel * opp = [_opportunities objectAtIndex:indexPath.row-1];
        [cell loadViews:opp userModel:userModel];
        //   }
    }
	
    [self setDataDict:cell.subviewsDict];
    
	return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*   if (indexPath.row==0) {
     ConnectViewController *detailViewController = [[ConnectViewController alloc] initWithNibName:@"ConnectViewController" bundle:nil];
     [detailViewController setCategory:category];
     [detailViewController addCloseWindow];
     
     UINavigationController *navigationController = [[UINavigationController alloc]
     initWithRootViewController:detailViewController];
     
     [navigationController.navigationBar setTintColor:[UIColor orangeColor]];
     
     // Get our custom nav bar
           CustomNavigationBar* customNavigationBar = (CustomNavigationBar*) navigationController.navigationBar;
     
     // Set the nav bar's background
     [customNavigationBar setBackgroundWith:[UIImage imageNamed:@"nav_bg.png"]];    if([navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
     //iOS 5 new UINavigationBar custom background
     [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics: UIBarMetricsDefault];
     } */
    //  [navigationController.navigationBar setBackgroundColor:[UIColor orangeColor]];     
    //  [self presentModalViewController:navigationController animated:YES];
    // ...
    // Pass the selected object to the new view controller.
    //  [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
    /*      [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
     [navigationController release];    
     [detailViewController release];
     
     }
     else {*/
    
    OportunityDetailViewController * detail = [[OportunityDetailViewController alloc] init];
    OpportunityModel *opp = nil;
    switch (indexPath.section) {
        case 0:
            opp = [_opportunities objectAtIndex:indexPath.row];
            break;
            
        case 1:
            opp = [_opportunities4 objectAtIndex:indexPath.row];
            break;
            
        case 2:
            opp = [_opportunities24 objectAtIndex:indexPath.row];
            break;
            
        case 3:
            opp = [_opportunitiesLater objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    if (opp.status==OpportunityStatusPendant) {
        [opp setWatched];
    }
    [detail setOpportunity:opp];
    MixpanelAPI *mixpanel = [MixpanelAPI sharedAPI];
    [mixpanel setSendDeviceModel:YES];
    [mixpanel identifyUser:[[UserModel sharedUser] userName]];
    
    [mixpanel track:[NSString stringWithFormat:@"Opportunity %d %@ selected",opp.opportunityID,opp.title]];

    
  //  [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
    detail.hidesBottomBarWhenPushed = YES;  
    [self.navigationController pushViewController:detail animated:YES];
    //lastSelectedIndex = indexPath;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 //   [(RootViewController *)[self.view.window rootViewController] tabBarHidden:NO];
    // }
}


- (void) refresh
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSDate *endate = [today dateByAddingTimeInterval:60*60*24*7];
    //[dateFormatter setLocale:myLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //[myLocale release];
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/list?destination_id=%d&user_id=%d&uuid=%@&category_id=%d&status=%@&start_date=%@&end_date=%@&language_id=%@",[[Destination sharedInstance] destinationService], [userModel destinationID], [userModel userID], [userModel udid], [category categoryID],@"0,6", [dateFormatter stringFromDate:today], [dateFormatter stringFromDate:endate], [userModel localeID]];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponse:) hudActivied:YES withString:NSLocalizedString(@"loadingMsgKey",@"Loading")];
}


- (void) setResponse:(NSData *)data
{
    NSError * error = nil;
    NSString * responseString = nil;
    SBJsonParser * jsonParser = nil;
    NSDictionary * dict = nil;
    if ( data ) {
        jsonParser = [[SBJsonParser alloc] init];
        responseString = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
        id jsonObject = [jsonParser objectWithString:responseString];
        if ( error == nil ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            jsonParser = nil;
            if ( [jsonObject isKindOfClass:[NSDictionary class]] ) {
                dict = jsonObject;
                if ( [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0 ) {
                        //         NSLog(@"%@: opprotunity list for cat %d: %@", [self description], [_category categoryID], [dict description]);
                    [self setDataDict:dict];
                } else {
                    //TODO: Alert the user
                    NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
                    NSString * desc = (NSString *)[dict objectForKey:@"description"];
                    NSLog(@"%@: errorCode: %d: %@",[self description],errorCode, desc);
                }
            } else {
                //TODO:
            }
        } else {
#ifdef __DEBUG__
            NSLog(@"%@: Error at parsing json. Maybe an encoding problem. Error description: %@",[self description], [error description]);
#endif
        }
    } else {
#ifdef __DEBUG__
        NSLog(@"%@: Error response data with void data", [self description] );
#endif
    }
}


- (void) setDataDict:(NSDictionary *)dict
{
    if ( [[dict objectForKey:@"errorCode"] isKindOfClass:[NSNumber class]] ) {
        _dataDict = dict;
        [_opportunities removeAllObjects];
        [_opportunities4 removeAllObjects];
        [_opportunities24 removeAllObjects];
        [_opportunitiesLater removeAllObjects];
        for ( int i = 0; i < [_dataDict count]; i++ )
        {
            NSString * index = [NSString stringWithFormat:@"%d", i];
            if ( [[_dataDict objectForKey:index] isKindOfClass:[NSDictionary class]] )
            {
                OpportunityModel * opp = [[OpportunityModel alloc] init];
                [opp parseDataDict:(NSDictionary *)[_dataDict objectForKey:index]];
                
                NSDate *now=[[NSDate alloc] init];
                NSTimeInterval timeInSeconds = [[opp startDate] timeIntervalSinceDate:now];
                double hours = timeInSeconds / 3600;
                if (hours <=0)
                {
                    if ([[opp endDate] timeIntervalSinceDate:now]>0) {
                        [_opportunities addObject:opp];
                    }                }
                if (hours <= 2 && hours >0)
                {            [_opportunities addObject:opp];
                }
                if (hours > 2 && hours <=4) [_opportunities4  addObject:opp];
                if (hours > 4 && hours <= 24) [_opportunities24  addObject:opp];
                if (hours > 24) [_opportunitiesLater  addObject:opp];
            }
        }
        [self.tableViewController.tableView reloadData];
    } else {
        NSLog(@"%@: Error: Code %d:  %@", [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue], [dict objectForKey:@"description"]);
    }
}

- (void) setTitleLabelForHeader
{
    [self.navigationItem setTitle:category.name];
}
- (void) requestOpportunity {
    ConnectViewController *detailViewController = [[ConnectViewController alloc] initWithNibName:@"ConnectViewController" bundle:nil];
    [detailViewController setCategory:category];
    [detailViewController addCloseWindow];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:detailViewController];
    
    [navigationController.navigationBar setTintColor:kMainColor];
    [(RootViewController *)[self.view.window rootViewController] presentModalViewController:navigationController animated:YES];
  //  [self.navigationController pushViewController:detailViewController animated:YES];

}
- (IBAction) showMapLocation
{
    if ( map == nil ) {
     map = [[ClusterMapViewController alloc] init];
     }
    // map.title = self.title;
    [map setCategoryName:category.name];
    [map setOpportunities:_opportunities];
    [map.mapView setClusteringEnabled:FALSE];
    map.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:map animated:YES];
}

/*
#pragma mark - TileMenu delegate


- (NSInteger)numberOfTilesInMenu:(MGTileMenuController *)tileMenu
{
	return 3;
}


- (UIImage *)imageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *images = [NSArray arrayWithObjects:
					   @"Icon_Wish", 
					   @"103-map", 
					   @"Icon_Share", 
					   @"Icon_Wish", 
					   @"Icon_Share", 
					   @"actions", 
					   @"Text", 
					   @"heart", 
					   @"gear", 
					   nil];
	if (tileNumber >= 0 && tileNumber < images.count) {
		return [UIImage imageNamed:[images objectAtIndex:tileNumber]];
	}
	
	return [UIImage imageNamed:@"Text"];
}


- (NSString *)labelForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *labels = [NSArray arrayWithObjects:
					   @"Twitter", 
					   @"Key", 
					   @"Speech balloon", 
					   @"Magnifying glass", 
					   @"Scissors", 
					   @"Actions", 
					   @"Text", 
					   @"Heart", 
					   @"Settings", 
					   nil];
	if (tileNumber >= 0 && tileNumber < labels.count) {
		return [labels objectAtIndex:tileNumber];
	}
	
	return @"Tile";
}


- (NSString *)descriptionForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	NSArray *hints = [NSArray arrayWithObjects:
                      @"Sends a tweet", 
                      @"Unlock something", 
                      @"Sends a message", 
                      @"Zooms in", 
                      @"Cuts something", 
                      @"Shows export options", 
                      @"Adds some text", 
                      @"Marks something as a favourite", 
                      @"Shows some settings", 
                      nil];
	if (tileNumber >= 0 && tileNumber < hints.count) {
		return [hints objectAtIndex:tileNumber];
	}
	
	return @"It's a tile button!";
}


- (UIImage *)backgroundImageForTile:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 1) {
		return [UIImage imageNamed:@"orange_gradient"];
	} else if (tileNumber == 2) {
		return [UIImage imageNamed:@"orange_gradient"];
	} else if (tileNumber == 7) {
		return [UIImage imageNamed:@"red_gradient"];
	} else if (tileNumber == 5) {
		return [UIImage imageNamed:@"yellow_gradient"];
	} else if (tileNumber == 8) {
		return [UIImage imageNamed:@"green_gradient"];
	} else if (tileNumber == -1) {
		return [UIImage imageNamed:@"grey_gradient"];
	}
	
	return [UIImage imageNamed:@"blue_gradient"];
}


- (BOOL)isTileEnabled:(NSInteger)tileNumber inMenu:(MGTileMenuController *)tileMenu
{
	if (tileNumber == 0 ||  tileNumber == 3) {
		return NO;
	}
	
	return YES;
}


- (void)tileMenu:(MGTileMenuController *)tileMenu didActivateTile:(NSInteger)tileNumber
{
	NSLog(@"Tile %d activated (%@)", tileNumber, [self labelForTile:tileNumber inMenu:tileController]);
    switch (tileNumber) {
        case 0: //request
        {
            
        }
            break;
            
        case 1: //Map
        {
            [self showMapLocation];   
        }
            break;
            
        case 2: //propose
        {
            [self requestOpportunity];
        }
            break;
            
        default:
            break;
    }
}


- (void)tileMenuDidDismiss:(MGTileMenuController *)tileMenu
{
	tileController = nil;
        //   [menuButton setHidden:FALSE];
}*/
#pragma mark SlidingTabsControl Delegate
- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;
{
    UILabel* label = [[UILabel alloc] init] ;
    if (tabIndex==0) {
        label.text = [NSString stringWithFormat:NSLocalizedString(@"offersKey",@"")];
    }
    else {
        label.text = [NSString stringWithFormat:NSLocalizedString(@"servicesKey",@"")];
    }
    
    
    return label;
}

- (void) touchUpInsideTabIndex:(NSUInteger)tabIndex
{
    
}

- (void) touchDownAtTabIndex:(NSUInteger)tabIndex
{
    
}

@end
