//
//  OportunitiesListViewController.m
//  opendestination
//
//  Created by David Hoyos on 13/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "OportunitiesListViewController.h"
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


@implementation OportunitiesListViewController

@synthesize categoryID;
@synthesize dataDict = _dataDict;
@synthesize tableViewController = _tableViewController;
static NSString *CellClassName = @"CellViewController";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userModel = [UserModel sharedUser]; 
        self.title = nil;
        self.transition = ContentPageTranistionTypeNone;
        _opportunities = nil;
        _opportunities = [[NSMutableArray alloc] initWithCapacity:0];
        self.categoryID = 11;
        lastSelectedIndex=nil;
        cellLoader = [[UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]] retain];

    }
    return self;
}

- (void) dealloc  
{
    [_tableViewController release];
    [_opportunities  release];
    [_dataDict release];
    [cellLoader release];
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
    [self.tableViewController.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableViewController.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableViewController.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableViewController.clearsSelectionOnViewWillAppear = YES;
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


#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}


# pragma mark -
# pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_opportunities count];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
/*
    CellViewController *cell = (CellViewController *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellClassName owner:self options:nil];
        cell = (CellViewController *)[nib objectAtIndex:0];
    }
    
    // perform additional custom work...
    
    return cell;

    
    
    
    // Note: I set the cell's Identifier property in Interface Builder to DemoTableViewCell.
    CellViewController *cell = (CellViewController *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    if (!cell)
    {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
    }
    return cell;*/
   
	static NSString *CellIdentifier = @"Cell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if ([self.categorys count] !=0) {
    //Category * c = [self.categories objectAtIndex:[indexPath row]];
    OpportunityModel * opp = [_opportunities objectAtIndex:indexPath.row];
  
	if (cell == nil) {		
		cell = [[[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell loadViews:opp userModel:userModel];
        }
	
    [self setDataDict:cell.subviewsDict];
   
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OportunityDetailViewController * detail = [[OportunityDetailViewController alloc] init];
    OpportunityModel *opp = [_opportunities objectAtIndex:indexPath.row];
    if (opp.status==OpportunityStatusPendant) {
        [opp setWatched];
    }
    [detail setOpportunity:opp];
    
    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:YES];
    [(RootViewController *)[self.view.window rootViewController] pushViewController:detail animated:YES];
    //lastSelectedIndex = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [(RootViewController *)[self.view.window rootViewController] tabBarHidden:NO];
    [detail release];
}


- (void) refresh
{
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/list?destination_id=%d&user_id=%d&uuid=%@&category_id=%d",
                      [[Destination sharedInstance] destinationService], [userModel destinationID], [userModel userID], [userModel udid], [_category categoryID],@"0,6"];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponse:) hudActivied:YES withString:NSLocalizedString(@"loadingMsgKey",@"Loading")];
}


- (void) setResponse:(NSData *)data
{
    [data retain];
    NSError * error = nil;
    NSString * responseString = nil;
    SBJsonParser * jsonParser = nil;
    NSDictionary * dict = nil;
    if ( data ) {
        jsonParser = [[SBJsonParser alloc] init];
        responseString = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
        id jsonObject = [jsonParser objectWithString:responseString 
                                               error:&error];
        if ( error == nil ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            [jsonParser release]; jsonParser = nil;
            if ( [jsonObject isKindOfClass:[NSDictionary class]] ) {
                dict = jsonObject;
                if ( [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0 ) {
                    NSLog(@"%@: opprotunity list for cat %d: %@", [self description], [_category categoryID], [dict description]);
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
    [responseString release];
    [jsonParser release];
    [data release];
}


- (void) setDataDict:(NSDictionary *)dict
{
    if ( [[dict objectForKey:@"errorCode"] isKindOfClass:[NSNumber class]] ) {
        [_dataDict release];
        _dataDict = [dict retain];
        [_opportunities removeAllObjects];
        for ( int i = 0; i < [_dataDict count]; i++ )
        {
            NSString * index = [NSString stringWithFormat:@"%d", i];
            if ( [[_dataDict objectForKey:index] isKindOfClass:[NSDictionary class]] )
            {
                OpportunityModel * opp = [[OpportunityModel alloc] init];
                [_opportunities addObject:opp];
                [opp parseDataDict:(NSDictionary *)[_dataDict objectForKey:index]];
                [opp release];
            }
        }
        [self.tableViewController.tableView reloadData];
    } else {
        NSLog(@"%@: Error: Code %d:  %@", [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue], [dict objectForKey:@"description"]);
    }
}



@end
