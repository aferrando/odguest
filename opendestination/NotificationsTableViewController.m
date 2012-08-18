//
//  NotificationsTableViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 12/12/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "CustomTableViewCell.h"
#import "OpportunityModel.h"
#import "UserModel.h"
#import "TaggedNSURLConnectionsManager.h"
#import "JSON.h"
#import "Destination.h"
#import "NotificationDetailViewController.h"
#import "OportunityDetailViewController.h"


@interface NotificationsTableViewController ()
@property ( nonatomic ) NSMutableArray * deals;
@property ( nonatomic ) NSMutableArray * hotdeals;
@property ( nonatomic ) UserModel * userModel;
@property ( nonatomic ) NSDictionary * dataDict;
- (void) setDataDict:(NSDictionary *)dataDict;
@end

@implementation NotificationsTableViewController
@synthesize typeSegmentedCtrl;
@synthesize  hotdeals,deals, userModel, dataDict, noItemLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.userModel = [UserModel sharedUser];
        self.deals = [[NSMutableArray alloc] initWithCapacity:0];
        self.hotdeals = [[NSMutableArray alloc] initWithCapacity:0];
        noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30,self.tableView.bounds.size.width, 60)];
        noItemLabel.text=NSLocalizedString(@"noItemsKey", @"No Item found");// @"NO ITEMS";
        [self.view addSubview:noItemLabel];
        noItemLabel.textAlignment=UITextAlignmentCenter;
        noItemLabel.backgroundColor=[UIColor clearColor];
        noItemLabel.textColor=[UIColor darkGrayColor];

            //      [self addSegmentedControl];
 //       self.transition =  ContentPageTransitionTypeFlip;
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
    self.title = NSLocalizedString(@"myNotificationsKey", @"My Notifications");
/*    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeKey", @"Close") style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(closeWindow)];      
    self.navigationItem.leftBarButtonItem = sendButton;
    [sendButton release];*/
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  //  [self.tableView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:typeSegmentedCtrl];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]]];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) addSegmentedControl {
    NSArray * segmentItems = [NSArray arrayWithObjects: NSLocalizedString(@"tocheckKey",@"To check"), NSLocalizedString(@"watchedKey",@"Watched"), nil];
        typeSegmentedCtrl = [[UISegmentedControl alloc] initWithItems: segmentItems];
        typeSegmentedCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
        typeSegmentedCtrl.tintColor = [UIColor darkGrayColor];
        typeSegmentedCtrl.selectedSegmentIndex = 0;
        [typeSegmentedCtrl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [self setTypeSegmentedCtrl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reload];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0,tableView.bounds.size.width, 50)];
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
    }
    return headerView;
}*/

- (void) onSegmentedControlChanged:(UISegmentedControl *) sender forEvent:(UIEvent *)event {

 //   typeSegmentedCtrl.selectedSegmentIndex=[(UISegmentedControl *)sender selectedSegmentIndex];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    noItemLabel.hidden=TRUE;
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
            } 
            
            return [deals count];
            break;
    }   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    OpportunityModel *opp = nil;
    if (typeSegmentedCtrl.selectedSegmentIndex==0) opp = [hotdeals objectAtIndex:indexPath.row];
    else opp = [deals objectAtIndex:indexPath.row];
	if (cell == nil) {		
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OportunityDetailViewController * detail = [[OportunityDetailViewController alloc] init];
    OpportunityModel *opp =  [hotdeals objectAtIndex:indexPath.row];
    if (opp.status==OpportunityStatusPendant) {
        [opp setWatched];
    }
    [detail setOpportunity:opp];
    detail.hidesBottomBarWhenPushed = YES;  

    [self.navigationController pushViewController:detail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void) addCloseWindow{
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"closeKey", @"Close") style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(closeWindow)];      
    self.navigationItem.leftBarButtonItem = sendButton;
    
}

- (IBAction)changeType:(id)sender {
}

- (void) closeWindow {
    
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
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


- (void) reload
{
    [deals removeAllObjects];
    [hotdeals removeAllObjects];
    //Adding the type of opportunities status to be shown
    NSString * url = [NSString stringWithFormat:@"%@/user/listHistory?destination_id=%d&uuid=%@&user_id=%d&status=%@",
                      [[Destination sharedInstance] destinationService], [userModel destinationID], [userModel udid], [userModel userID],@"0,5"];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponse:) hudActivied:YES withString:@"Loading"];
}


- (void) setDataDict:(NSDictionary *)dict
{
    if ( [[dict objectForKey:@"errorCode"] isKindOfClass:[NSNumber class]] )
    {
        dataDict = dict;
        [deals removeAllObjects];
        for ( int i = 0; i < [dataDict count]; i++ ) {
            NSString * index = [NSString stringWithFormat:@"%d", i];
            if ( [[dataDict objectForKey:index] isKindOfClass:[NSDictionary class]] ) {
                OpportunityModel * opp = [[OpportunityModel alloc] init];
                [opp parseDataDict:(NSDictionary *)[dataDict objectForKey:index]];
              if (opp.status==OpportunityStatusPendant) {
                    [hotdeals addObject:opp];
                }
              else {
                  NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:opp.modifyDate];
                  NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
                  if([today day] == [otherDay day] &&
                     [today month] == [otherDay month] &&
                     [today year] == [otherDay year] &&
                     [today era] == [otherDay era]) {
                      //do stuff
                      [deals addObject:opp];
                  }
                  else  {
                      [deals addObject:opp];
                  }
                  
              }
            }
        }
        [self.tableView reloadData];
    } else {
        NSLog(@"%@: Error: Code %d:  %@", [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue], [dict objectForKey:@"description"]);
    }
}


@end
