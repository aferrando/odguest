//
//  MySharesTableViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 1/18/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "MySharesTableViewController.h"
#import "CustomTableViewCell.h"
#import "UserModel.h"
#import "Destination.h"
#import "OpportunityModel.h"
#import "MySharesInterestedGridViewController.h"
#import "TaggedNSURLConnectionsManager.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"


@interface MySharesTableViewController ()
@property ( nonatomic ) NSMutableArray * deals;
@property ( nonatomic ) NSMutableArray * hotdeals;
@property ( nonatomic ) NSMutableArray * waitingdeals;
@property ( nonatomic ) UserModel * userModel;
@property ( nonatomic ) NSDictionary * dataDict;
- (void) setDataDict:(NSDictionary *)dataDict;
@end

@implementation MySharesTableViewController
@synthesize transition, deals,hotdeals,waitingdeals,
userModel, dataDict, typeSegmentedCtrl, noItemLabel,
badgeNext, badgeRedeeming  ;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.userModel = [UserModel sharedUser];
        self.deals = [[NSMutableArray alloc] initWithCapacity:0];
        self.hotdeals = [[NSMutableArray alloc] initWithCapacity:0];
        self.waitingdeals = [[NSMutableArray alloc] initWithCapacity:0];
        self.transition =    ContentPageTranistionTypeSide;
        noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30,self.tableView.bounds.size.width, 60)];
        noItemLabel.text=NSLocalizedString(@"noItemsKey", @"No Item found");// @"NO ITEMS";
        [self.view addSubview:noItemLabel];
        noItemLabel.textAlignment=UITextAlignmentCenter;
        noItemLabel.backgroundColor=[UIColor clearColor];
        noItemLabel.textColor=[UIColor darkGrayColor];
        
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"MySharesKey",@"MyShares")];
    //  [self.tableView setSeparatorColor:[UIColor orangeColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    self.clearsSelectionOnViewWillAppear = YES;
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0,110.0, 0.0)];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]]];

    [self reload];
}
- (void) addSegmentedControl {
    NSArray * segmentItems = [NSArray arrayWithObjects:NSLocalizedString(@"todoNextKey",@"TO DO NEXT"), NSLocalizedString(@"interestedKey",@"Interested"), nil];
    typeSegmentedCtrl = [[UISegmentedControl alloc] initWithItems: segmentItems];
    typeSegmentedCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    typeSegmentedCtrl.tintColor = [UIColor darkGrayColor];
    
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
	[badgeNext setFrame:CGRectMake(100, 10,30, 20)];
    [self.view addSubview:badgeNext];
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self reload];
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
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0,tableView.bounds.size.width, 60)];
    typeSegmentedCtrl.frame = CGRectMake(0, 0, tableView.bounds.size.width, 33);
    [headerView addSubview:typeSegmentedCtrl]; 
    
    
    /*    
     UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
     
     if (section == 0){
     [headerView setBackgroundColor:[UIColor redColor]];
     label.text = NSLocalizedString(@"tocheckKey",@"To check");
     label.textColor = [UIColor whiteColor];
     label.backgroundColor = [UIColor clearColor];
     [headerView addSubview:label];
     }
     else {
     label.text = NSLocalizedString(@"watchedKey",@"Watched");
     label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
     label.backgroundColor = [UIColor clearColor];
     [headerView addSubview:label];
     
     [headerView setBackgroundColor:[UIColor darkGrayColor]];
     }*/
    return headerView;
}
- (void) onSegmentedControlChanged:(UISegmentedControl *) sender {
    
    //   typeSegmentedCtrl.selectedSegmentIndex=[(UISegmentedControl *)sender selectedSegmentIndex];
    [self.tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    noItemLabel.hidden=TRUE;
  /*  
    switch (typeSegmentedCtrl.selectedSegmentIndex) {
        case 0:
            if ([hotdeals count]==0) {
                noItemLabel.hidden=FALSE;
            } 
            return [hotdeals count];
            break;
            
             
        default:
            if ([deals count]==0) {
                noItemLabel.hidden=FALSE;
            } */
            
            return [deals count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OpportunityModel * opp = [deals objectAtIndex:indexPath.row];
/*    if (typeSegmentedCtrl.selectedSegmentIndex==0) opp=[hotdeals objectAtIndex:indexPath.row];
    if (typeSegmentedCtrl.selectedSegmentIndex==1) opp=[deals objectAtIndex:indexPath.row];*/
   // if (typeSegmentedCtrl.selectedSegmentIndex==2) opp=[deals objectAtIndex:indexPath.row];
    if (cell == nil) {		
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell setMyDeals:true];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell loadViews:opp userModel:userModel];
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
    MySharesInterestedGridViewController * detail = [[MySharesInterestedGridViewController alloc] init];
    OpportunityModel * opp = nil;
    if (typeSegmentedCtrl.selectedSegmentIndex==0) opp=[hotdeals objectAtIndex:indexPath.row];
    if (typeSegmentedCtrl.selectedSegmentIndex==1) opp=[deals objectAtIndex:indexPath.row];
    [detail setOpportunity:opp];
    //    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
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
                    NSLog(@"%@: opportunity list: %@", [self description], [dict description]);
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
    //Adding the type of opportunities status to be shown
    NSString * url = [NSString stringWithFormat:@"%@/user/ListMadeByMe?destination_id=%d&uuid=%@&user_id=%d",
                      [[Destination sharedInstance] destinationService], [userModel destinationID], [userModel udid], [userModel userID]];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponse:) hudActivied:YES withString:@"Loading"];
    [self stopLoading];
}


- (void) setDataDict:(NSDictionary *)dict
{
    if ( [[dict objectForKey:@"errorCode"] isKindOfClass:[NSNumber class]] )
    {
        NSArray * dataArray = (NSArray *) [dict objectForKey:@"list"];
        [deals removeAllObjects];
        [hotdeals removeAllObjects];
        [waitingdeals removeAllObjects];
        for ( int i = 0; i < [dataArray count]; i++ ) {
          //  NSString * index = [NSString stringWithFormat:@"%d", i];
            if ( [[dataArray objectAtIndex:i] isKindOfClass:[NSDictionary class]] ) {
                OpportunityModel * opp = [[OpportunityModel alloc] init];
                [opp parseDataDictTest:(NSDictionary *)[dataArray objectAtIndex:i]];
                NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:opp.modifyDate];
                NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
              /*  if([today day] == [otherDay day] &&
                   [today month] == [otherDay month] &&
                   [today year] == [otherDay year] &&
                   [today era] == [otherDay era]) {
                    //do stuff
                    [hotdeals addObject:opp];
                }
                else */
                [deals addObject:opp];
                
            }
        }
        [self.tableView reloadData];
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
