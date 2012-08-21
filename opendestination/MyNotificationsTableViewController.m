//
//  MyDealsTableViewController.m
//  opendestination
//
//  Created by David Hoyos on 04/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import "MyNotificationsTableViewController.h"
#import "CustomTableViewCell.h"
#import "UserModel.h"
#import "Destination.h"
#import "OpportunityModel.h"
#import "OportunityDetailViewController.h"
#import "TaggedNSURLConnectionsManager.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"


@interface MyNotificationsTableViewController ()
@property ( nonatomic ) NSMutableArray * deals;
@property ( nonatomic ) UserModel * userModel;
@property ( nonatomic ) NSDictionary * dataDict;
- (void) setDataDict:(NSDictionary *)dataDict;
@end

@implementation MyNotificationsTableViewController
@synthesize deals, userModel, dataDict;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.userModel = [UserModel sharedUser];
        self.deals = [[NSMutableArray alloc] initWithCapacity:0];
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
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    self.clearsSelectionOnViewWillAppear = YES;
     [self.tableView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 36.0, 0.0)];
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
    return 62.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";	
	CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if ([self.categorys count] !=0) {
    //Category * c = [self.categories objectAtIndex:[indexPath row]];
    
	if (cell == nil) {		
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIView * content = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 62)];
        [content setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background.png"]]];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 6.0, 50.0, 50.0)];
        [[cell subviewsDict] setObject:imageView forKey:@"imageView"];
        [content addSubview:imageView];
        
        
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 6.0, 192, 24)];
        textLabel.font = [UIFont boldSystemFontOfSize:14];
        [textLabel setMinimumFontSize:10.0];
        textLabel.textColor = [UIColor whiteColor];
        [textLabel setShadowColor:[UIColor blackColor]];
        [textLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 1;
        [[cell subviewsDict] setObject:textLabel forKey:@"textLabel"];
        [content addSubview:textLabel];
        
        UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0f, 26.0, 200, 40)];
        descLabel.font = [UIFont systemFontOfSize:12];
        [descLabel setMinimumFontSize:10.0];
        descLabel.textColor = [UIColor whiteColor];
        [descLabel setShadowColor:[UIColor blackColor]];
        [descLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.numberOfLines = 1;
        [[cell subviewsDict] setObject:descLabel forKey:@"descLabel"];
        [content addSubview:descLabel];
        
        /*
         UIImageView * status = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_point.png"]];
         [status setCenter:CGPointMake(212, 16)];
         [content addSubview:[status autorelease]];
         [[cell subviewsDict] setObject:status forKey:@"status"];
         //TODO: Comprovar data
         */
        
        
        UIImageView *  ribbon= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new-ribbon.png"]];
        [ribbon setCenter:CGPointMake(31, 31)];
        [content addSubview:ribbon];
        [ribbon setHidden:YES];
        [[cell subviewsDict] setObject:ribbon forKey:@"ribbon"];
        
        UIImageView * dealStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pendent.png"]];
        [dealStatus setCenter:CGPointMake(248, 24-(dealStatus.bounds.size.height/2))];
        [content addSubview:dealStatus];
        [[cell subviewsDict] setObject:dealStatus forKey:@"dealStatus"];
        //TODO: Comprovar data
        
        UIImageView * badget = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,24.0f,24.0f)];
        [badget setImage:[UIImage imageNamed:@"bola.png"]];
        [badget setCenter:CGPointMake(280, 16)];
        [content addSubview:badget];
        [[cell subviewsDict] setObject:badget forKey:@"badget"];
        
        UILabel * pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(00.0f, 0.0, 24.0, 24.0)];
        [pointsLabel setCenter:CGPointMake(280, 16)];
        pointsLabel.font = [UIFont boldSystemFontOfSize:10];
        pointsLabel.textColor = [UIColor darkTextColor];
        pointsLabel.backgroundColor = [UIColor clearColor];
        pointsLabel.numberOfLines = 1;
        [pointsLabel setTextAlignment:UITextAlignmentCenter];
        [[cell subviewsDict] setObject:pointsLabel forKey:@"pointsLabel"];
        [content addSubview:pointsLabel];
        
        
        
        [cell.contentView addSubview:content];
	}
    NSMutableDictionary * dict = cell.subviewsDict;
    OpportunityModel * opp = [deals objectAtIndex:indexPath.row];
    NSURL * url = [NSURL URLWithString:[opp thumbURL]];
    [(UIImageView *)[dict objectForKey:@"imageView"] setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cell_image_placeholder.png"]];
    if ( ( opp.status == OpportunityStatusPendant ) && (opp.points > 0 ) )
    {
        [(UILabel *)[dict objectForKey:@"pointsLabel"] setText:[NSString stringWithFormat:@"%d",[opp points]]];
        [(UIImageView *)[dict objectForKey:@"badget"] setHidden:NO];
        [(UILabel *)[dict objectForKey:@"pointsLabel"] setHidden:NO];
    }
    else
    {
        [(UIImageView *)[dict objectForKey:@"badget"] setHidden:YES];
        [(UILabel *)[dict objectForKey:@"pointsLabel"] setHidden:YES];
    }
    if ( [[opp.owner valueForKey:@"id"] integerValue] == userModel.userID )
    {
        [(UIImageView *)[dict objectForKey:@"dealStatus"] setHidden:NO];
        [(UIImageView *)[dict objectForKey:@"dealStatus"] setImage:[UIImage imageNamed:@"propia.png"]];
    }
    else
    {
        switch ( opp.status )
        {
            case OpportunityStatusPendant:
                [(UIImageView *)[dict objectForKey:@"dealStatus"] setHidden:NO];
                [(UIImageView *)[dict objectForKey:@"dealStatus"] setImage:[UIImage imageNamed:@"pendent.png"]];
                [(UIImageView *)[dict objectForKey:@"ribbon"] setHidden:NO];
                
                
                break;
            case OpportunityStatusInterested:
                [(UIImageView *)[dict objectForKey:@"dealStatus"] setHidden:NO];
                [(UIImageView *)[dict objectForKey:@"dealStatus"] setImage:[UIImage imageNamed:@"per_consumir.png"]];
                
                
                break;
            default:
                [(UIImageView *)[dict objectForKey:@"dealStatus"] setHidden:YES];
                
                break;
        }
    }
    [[dict objectForKey:@"textLabel"] setText:[opp name]];
    [[dict objectForKey:@"descLabel"] setText:[opp.owner objectForKey:@"real_name"]];
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
    OpportunityModel *opp = [deals objectAtIndex:indexPath.row];
    [detail setOpportunity:opp];
    [self.navigationController     pushViewController:detail animated:YES];
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


- (void) reload
{
    //Adding the type of opportunities status to be shown
    NSString * url = [NSString stringWithFormat:@"%@/user/listHistory?destination_id=%d&uuid=%@&user_id=%d&status=%@",
                      [[Destination sharedInstance] destinationService], [userModel destinationID], [userModel udid], [userModel userID],@"'0'"];
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
                [deals addObject:opp];
                [opp parseDataDict:(NSDictionary *)[dataDict objectForKey:index]];
            }
        }
        [self.tableView reloadData];
    } else {
        NSLog(@"%@: Error: Code %d:  %@", [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue], [dict objectForKey:@"description"]);
    }
}

@end
