    //
    //  TODOTableViewController.m
    //  opendestination
    //
    //  Created by Albert Ferrando on 7/11/12.
    //  Copyright (c) 2012 None. All rights reserved.
    //

#import "TODOTableViewController.h"
#import "GlobalConstants.h"
#import "SVSegmentedControl.h"
#import "OpportunityModel.h"
#import "CustomTableViewCell.h"
#import "OportunityDetailViewController.h"
#import "Destination.h"

#import "TaggedNSURLConnectionsManager.h"

@interface TODOTableViewController ()

@end

@implementation TODOTableViewController
@synthesize dataDict, userModel, doneTODO, map, typeSegmentedCtrl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        selectedControl=0;
        self.userModel = [UserModel sharedUser];
        self.doneTODO = [[NSMutableArray alloc] initWithCapacity:0];
        _opportunities = [[NSMutableArray alloc] initWithCapacity:0];
        _opportunities4 = [[NSMutableArray alloc] initWithCapacity:0];
        _opportunities24 = [[NSMutableArray alloc] initWithCapacity:0];
        _opportunitiesLater = [[NSMutableArray alloc] initWithCapacity:0];
        /*    deals = [[NSMutableArray alloc] initWithCapacity:0];
         self.waitingdeals = [[NSMutableArray alloc] initWithCapacity:0];
         self.transition =    ContentPageTranistionTypeSide;
         noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30,self.tableView.bounds.size.width, 60)];
         noItemLabel.text=NSLocalizedString(@"noItemsKey", @"No Item found");// @"NO ITEMS";
         //    [self.view addSubview:noItemLabel];
         noItemLabel.textAlignment=UITextAlignmentCenter;
         noItemLabel.backgroundColor=[UIColor clearColor];
         noItemLabel.textColor=[UIColor whiteColor];
         //There is no need to add the TimeScroller as a subview.
         //  _timeScroller = [[TimeScroller alloc] initWithDelegate:self];*/
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"mapKey", @"Mapa")
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(showMapLocation)];
        self.navigationItem.rightBarButtonItem = barButton;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 40)];
        self.tableView.tableHeaderView = headerView;
        [self addSegmentedControl];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
        // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
        // Release any cached data, images, etc that aren't in use.
}
- (IBAction) showMapLocation
{
    if ( map == nil ) {
        map = [[ClusterMapViewController alloc] init];
    }
        // map.title = self.title;
    [map setCategoryName:NSLocalizedString(@"myDealsKey", @"")];
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[_opportunities count] + [_opportunities24 count]+ [_opportunities4 count]+ [_opportunitiesLater count]];
    [ret addObjectsFromArray:_opportunities];
    [ret addObjectsFromArray:_opportunities4];
    [ret addObjectsFromArray:_opportunities24];
    [ret addObjectsFromArray:_opportunitiesLater];
    
    [map setOpportunities:ret];
    [map.mapView setClusteringEnabled:FALSE];
    map.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:map animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"todoNextKey",@"TO DO NEXT")];
        //  [self.tableView setSeparatorColor:[UIColor orangeColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:background ]]];
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0,110.0, 0.0)];
    [self reload];
}
- (void) addSegmentedControl {
        // 2nd CONTROL
	
	SVSegmentedControl *redSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:NSLocalizedString(@"todoNextKey",@"TO DO NEXT"),  NSLocalizedString(@"usedKey",@"Used"), nil]];
    [redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	
	redSC.crossFadeLabelsOnDrag = YES;
	redSC.thumb.tintColor =  [UIColor colorWithRed:0 green:0.5 blue:0.1 alpha:1];
	redSC.selectedIndex = 0;
    redSC.font = [UIFont boldSystemFontOfSize:17];
        //redSC.titleEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 14);
        //redSC.height = 36;
    ;
	
	[self.tableView.tableHeaderView addSubview:redSC];
	
	redSC.center = CGPointMake(160, 20);
    
    /*    
     NSArray * segmentItems = [NSArray arrayWithObjects:NSLocalizedString(@"todoNextKey",@"TO DO NEXT"),   NSLocalizedString(@"interestedKey",@"Interested"), nil];
     typeSegmentedCtrl = [[UISegmentedControl alloc] initWithItems: segmentItems];
     typeSegmentedCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
     typeSegmentedCtrl.tintColor = kMainColor;
     [typeSegmentedCtrl setFrame:CGRectMake(0, 5,320, 30)];
     typeSegmentedCtrl.selectedSegmentIndex = 0;
     [typeSegmentedCtrl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
     badgeNext=[CustomBadge customBadgeWithString:@"012" 
     withStringColor:[UIColor whiteColor] 
     withInsetColor:[UIColor blackColor] 
     withBadgeFrame:YES 
     withBadgeFrameColor:[UIColor yellowColor] 
     withScale:1.25 
     withShining:YES];
     // Set Position of Badge 1
     [badgeNext setFrame:CGRectMake(100, 10,30, 40)];
     [self.tableView.tableHeaderView addSubview:typeSegmentedCtrl];*/
    
}
#pragma mark -
#pragma mark SPSegmentedControl

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
	NSLog(@"segmentedControl %i did select index %i (via UIControl method)", segmentedControl.tag, segmentedControl.selectedIndex);
    selectedControl=segmentedControl.selectedIndex;
    [self.tableView reloadData];
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reload];
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


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (selectedControl==0) return 4;
    else return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    UIImageView * imageView2 = nil;
    
    
        //    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 0, 180, 44)];
        //  [barView setImage:[UIImage imageNamed:@"Barra_Descripcion_Gris.png"]];
    /*
     UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 8.0, 30, 30)];
     [imageView setImageWithURL:[NSURL URLWithString:category.imageURL] placeholderImage:[UIImage imageNamed:@"mistery_icon.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
     [barView addSubview:[imageView autorelease]];*/
    UILabel * action = [[UILabel alloc] initWithFrame:CGRectMake(19,3, 80, 25)];
    [action setBackgroundColor:[UIColor clearColor]];
    [action setTextColor:[UIColor whiteColor]];
    [action setShadowColor:[UIColor blackColor]];
    [action setShadowOffset:CGSizeMake(1.0, 1.0)];
    [action setFont:[UIFont systemFontOfSize:15]];
    UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 30)];
    if (selectedControl!=0) { 
        [action setText:NSLocalizedString(@"DoneKey",@"Now")];
        [coverView setBackgroundColor:[UIColor darkGrayColor]];
        [coverView setAlpha:0.8];
        [headerView addSubview:coverView];
        
        imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 380)];
        [imageView2 setImage:[UIImage imageNamed:@"ribbonleftGray.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
        [imageView2 setCenter:CGPointMake(44, 15)];
        [headerView addSubview:imageView2];
        [headerView addSubview:action];
        
        return headerView;
    }
    switch (section) {
            /*    case 0:
             NSLog(@"%@",@"");
             UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
             [barView setImage:[UIImage imageNamed:@"Barra_Descripcion_Gris.png"]];
             [headerView addSubview:[barView autorelease]];
             
             UIImageView * imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(68, 12.0, 12, 12)];
             [imageView2 setImage:[UIImage imageNamed:@"50-plus.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
             [headerView addSubview:[imageView2 autorelease]];
             UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(78, 8.0, 30, 30)];
             [imageView setImageWithURL:[NSURL URLWithString:category.imageURL] placeholderImage:[UIImage imageNamed:@"mistery_icon.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
             [headerView addSubview:[imageView autorelease]];
             action = [[UILabel alloc] initWithFrame:CGRectMake(120, 10.0, 150, 25)];
             [action setBackgroundColor:[UIColor clearColor]];
             [action setTextColor:[UIColor whiteColor]];
             action.numberOfLines = 2;
             
             [action setFont:[UIFont systemFontOfSize:12]];
             [action setText:[NSString stringWithFormat:@"ASK FOR %@",category.name]];
             [headerView addSubview:action];
             break;*/
            /*   case 0:
             [action setText:NSLocalizedString(@"DoneKey",@"Now")];
             [coverView setBackgroundColor:[UIColor darkGrayColor]];
             [coverView setAlpha:0.8];
             [headerView addSubview:coverView];
             
             imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 380)];
             [imageView2 setImage:[UIImage imageNamed:@"ribbonleftGray.png"]];//  [self subviewsDict] setObject:imageView forKey:@"imageView"];
             [imageView2 setCenter:CGPointMake(44, 15)];
             [headerView addSubview:imageView2];
             
             break;*/
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

- (void) scrollToToday:(BOOL)animate {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:animate];
        //if (animate == NO) [self.tableView showFirstHeaderLine:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*   noItemLabel.hidden=TRUE;
     
     switch (typeSegmentedCtrl.selectedSegmentIndex) {
     case 0:
     if ([hotdeals count]==0) {
     noItemLabel.hidden=FALSE;
     } 
     return [hotdeals count];
     break;
     
     case 1:
     if ([waitingdeals count]==0) {
     noItemLabel.hidden=FALSE;
     } 
     return [waitingdeals count];
     break;
     
     default:
     if ([deals count]==0) {
     noItemLabel.hidden=FALSE;
     } 
     
     return [deals count];
     break;
     }   */
    if (selectedControl==0){
        switch (section) {
                
            case 0: if ([_opportunities count]==0) return 1;
                return [_opportunities count];
                break;
                
            case 1: if ([_opportunities4 count]==0) return 1;
                return [_opportunities4 count];
                break;
                
            case 2:if ([_opportunities24 count]==0) return 1;
                return [_opportunities24 count];
                break;
            case 3:if ([_opportunitiesLater count]==0) return 1;
                return [_opportunitiesLater count];
                break;
        }
    }
    return [self.doneTODO count];
}

- (UITableViewCell *) noPlansCell {
        //    return nil;
    UITableViewCell *cell2 =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    
      cell2.textLabel.text=NSLocalizedString(@"NothingPlannedKey", @"Nothing planned!!. Click to see options!");
     cell2.textLabel.textColor=[UIColor lightGrayColor];
 /*    UIImageView *buttonView=[[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,142,43.0f)];
     [buttonView setImage:[UIImage imageNamed:@"button_grey.png"]];
     //   [cell2.contentView addSubview:buttonView];
     UILabel *noPlansLabel=[[UILabel alloc] initWithFrame:CGRectMake(50,0.0,220,20)];
     noPlansLabel.text=NSLocalizedString(@"NothingPlannedKey", @"Nothing planned!!. Click to see options!");
     noPlansLabel.backgroundColor=[UIColor clearColor];
     noPlansLabel.textColor=[UIColor whiteColor];
     [noPlansLabel setFont:[UIFont systemFontOfSize:12]];
     noPlansLabel.textAlignment=UITextAlignmentCenter;
     UILabel *orLabel=[[UILabel alloc] initWithFrame:CGRectMake(150,30.0,20,20)];
     orLabel.text=NSLocalizedString(@"orKey", @"OR");
     orLabel.backgroundColor=[UIColor clearColor];
     orLabel.textColor=[UIColor whiteColor];
     orLabel.textAlignment=UITextAlignmentCenter;
     [orLabel setFont:[UIFont systemFontOfSize:13]];
     UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(5, 21., 142, 43)];
     [btn setBackgroundImage:[UIImage imageNamed:@"button_grey.png.png"] forState:UIControlStateNormal ];
     [btn setTitle:NSLocalizedString(@"requestKey", @"Ask for options") forState:UIControlStateNormal];
     UIButton * btn2 = [[UIButton alloc] initWithFrame:CGRectMake(175, 20., 142, 43)];
     [btn2 setBackgroundImage:[UIImage imageNamed:@"button_red.png.png"] forState:UIControlStateNormal ];
     [btn2 setTitle:NSLocalizedString(@"seeKey", @"See options") forState:UIControlStateNormal];
     [cell2 addSubview:btn];
     [cell2 addSubview:btn2];
     [cell2 addSubview:noPlansLabel];
     [cell2 addSubview:orLabel];*/
     cell2.userInteractionEnabled = NO;
    return cell2;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OpportunityModel * opp = nil;
    if (selectedControl!=0) opp=[self.doneTODO objectAtIndex:indexPath.row];
    else {
        switch (indexPath.section) {
                /*  case 0:{
                 opp=[deals objectAtIndex:indexPath.row];
                 break;
                 }*/
            case 0:
                if ([_opportunities count]==0){
                    return [self noPlansCell];
                }
                else {
                    opp=[_opportunities objectAtIndex:indexPath.row];
                }
                
                break;
                
            case 1:
                if ([_opportunities4 count]==0) {
                    return [self noPlansCell];
                }
                else opp=[_opportunities4 objectAtIndex:indexPath.row];
                break;
                
            case 2:
                if ([_opportunities24 count]==0) {
                    return [self noPlansCell];
                }
                else opp=[_opportunities24 objectAtIndex:indexPath.row];
                break;
            case 3:
                if ([_opportunitiesLater count]==0) {
                    return [self noPlansCell];
                }
                else opp=[_opportunitiesLater objectAtIndex:indexPath.row];
                break;
                
                
            default:
                break;
        }
    }
    if (cell == nil) {		
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell setMyDeals:true];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell loadViews:opp userModel:self.userModel];
    }
	
    [self setDataDict:cell.subviewsDict];
    
	return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OportunityDetailViewController * detail = [[OportunityDetailViewController alloc] init];
    OpportunityModel * opp = nil;
    if (selectedControl!=0) opp=[self.doneTODO objectAtIndex:indexPath.row];
    else {
        switch (indexPath.section) {
                /*  case 0:
                 opp=[deals objectAtIndex:indexPath.row];
                 break;
                 */
            case 0:
                opp=[_opportunities objectAtIndex:indexPath.row];
                break;
                
            case 1:
                opp=[_opportunities4 objectAtIndex:indexPath.row];
                break;
                
            case 2:
                opp=[_opportunities24 objectAtIndex:indexPath.row];
                break;
            case 3:
                opp=[_opportunitiesLater objectAtIndex:indexPath.row];
                break;
                
                
            default:
                break;
        }
    }
    
    [detail setOpportunity:opp];
        //    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark -

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
        id jsonObject = [jsonParser objectWithString:responseString 
                         ];
        if ( error == nil ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            jsonParser = nil;
            if ( [jsonObject isKindOfClass:[NSDictionary class]] ) {
                dict = jsonObject;
                if ( [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0 ) {
                    NSLog(@"%@: opprotunity list: %@", [self description], [dict description]);
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



- (void)refresh {
    [self reload];
}

- (void) reload
{
        //Adding the type of opportunities status to    be shown
    NSString * url = [NSString stringWithFormat:@"%@/user/listHistory?destination_id=%d&uuid=%@&user_id=%d&status=%@",
                      [[Destination sharedInstance] destinationService], [self.self.userModel destinationID], [self.userModel udid], [self.userModel userID],@"2,3"];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponse:) hudActivied:YES withString:@"Loading"];
        //  [self stopLoading];
}


- (void) setDataDict:(NSDictionary *)dict
{
    if ( [[dict objectForKey:@"errorCode"] isKindOfClass:[NSNumber class]] )
        {
        dataDict = dict;
        [self.doneTODO removeAllObjects];
        [_opportunities removeAllObjects];
        [_opportunities4 removeAllObjects];
        [_opportunities24 removeAllObjects];
        [_opportunitiesLater removeAllObjects];
            //      [waitingdeals removeAllObjects];
        for ( int i = 0; i < [dataDict count]; i++ ) {
            NSString * index = [NSString stringWithFormat:@"%d", i];
            if ( [[dataDict objectForKey:index] isKindOfClass:[NSDictionary class]] ) {
                OpportunityModel * opp = [[OpportunityModel alloc] init];
                [opp parseDataDict:(NSDictionary *)[dataDict objectForKey:index]];
                if ([opp.type isEqualToString:@"deal"]) {
                    if ((opp.status==OpportunityStatusInterested) || (opp.status==OpportunityStatusWalkin)){
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
                    else {
                        [doneTODO addObject:opp];
                    }
                }
                
                else {
                    
                    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:opp.startDate];
                    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
                    if([today day] == [otherDay day] &&
                       [today month] == [otherDay month] &&
                       [today year] == [otherDay year] &&
                       [today era] == [otherDay era]) {
                            //do stuff
                            //             [hotdeals addObject:opp];
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
                    else  {
                        [doneTODO addObject:opp];
                    }
                    
                    
                }
            }
        }
        [self.tableView reloadData];
            //   [self scrollToToday:YES];
        
        } else {
            NSLog(@"%@: Error: Code %d:  %@", [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue], [dict objectForKey:@"description"]);
        }
}
-(void) addCloseWindow{
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeKey", @"Close") style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(closeWindow)];      
    self.navigationItem.leftBarButtonItem = sendButton;
    
}
- (void) closeWindow {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
}


@end
