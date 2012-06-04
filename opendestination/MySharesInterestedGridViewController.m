//
//  MySharesInterestedGridViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 1/25/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "MySharesInterestedGridViewController.h"
#import "GuestGridViewCell.h"
#import "TaggedNSURLConnectionsManager.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#import "Destination.h"
#import "UserModel.h"
@implementation MySharesInterestedGridViewController
@synthesize gridView=_gridView;
@synthesize guests=_guests;
@synthesize opportunity=_opportunity, messageBar, messageField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _guests=[[NSArray alloc] init];
        // Custom initialization
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
    
    
    [messageField setInputAccessoryView:messageBar];
    
    // Do any additional setup after loading the view from its nib.
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;  
	self.gridView.dataSource = self;
    self.gridView.scrollEnabled = YES;
    self.gridView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical_cloth.png"]];

    [self.gridView reloadData];


}

- (void)viewDidUnload
{
    messageBar = nil;
    messageField = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)resignKeyboard {
    [messageField resignFirstResponder];
}

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    /*    NSLog(@"Number of guests:%d",[_guests count]);
     return ( [_guests count] );
     */
    return ( [_guests count] );
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * FilledCellIdentifier = @"filledCellIdentifer";
    //static NSString * OffsetCellIdentifier = @"OffsetCellIdentifier";
    
    AQGridViewCell * cell = nil;
    GuestGridViewCell * filledCell = (GuestGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: FilledCellIdentifier];
    if ( filledCell == nil )
    {
        
        /*  [[NSBundle mainBundle] loadNibNamed:@"ActorCell" owner:self options:nil]; 
         filledCell = [self->tempCell autorelease];*/
        filledCell = [[GuestGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 90 , 90) reuseIdentifier:FilledCellIdentifier];
        filledCell.selectionStyle = AQGridViewCellSelectionStyleGlow;
        filledCell.selectionGlowColor = [UIColor orangeColor];
        
    }
    UserModel *user=(UserModel *)[_guests objectAtIndex:index];
    filledCell.user=user;
    NSString *urlImage=nil;
    if ([user.image isKindOfClass:[NSString class]])
        urlImage = [user.image stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //  [user release];
    NSLog(@"url photo: %@",urlImage);
    //   [o setImageWithURL:[NSURL URLWithString:urlImage] placeholderImage:[UIImage imageNamed:@"photo_default.png"]];
    [filledCell.imageView setImageWithURL:[NSURL URLWithString:urlImage] placeholderImage:[UIImage imageNamed:@"photo_default.png"]] ;
    
    [filledCell setTitle:user.userName];
    cell.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
    
    //   _title.text = title;
    //   [filledCell setNeedsLayout];
    
    /*  if (index==0){
     filledCell.image = [UIImage imageNamed:@"OD_logo.png"];
     //      filledCell.title = @"title1";
     }
     else {
     filledCell.image = [UIImage imageNamed:@"od_photodefault.png"];
     //   filledCell.title = @"title2";
     }       */
    cell = filledCell;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    /*  
     ActorCell *cell = (ActorCell *)[aGridView dequeueReusableCellWithIdentifier:@"cell"];
     if (!cell) {
     cell = [ActorCell cell];
     cell.reuseIdentifier = @"cell";
     }
     cell.backgroundColor = [UIColor clearColor];
     cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
     
     
     cell.nameLabel.text = [[_guests objectAtIndex:index] userName];
     
     return cell;*/
}
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(100, 110) );
}


#pragma mark -
#pragma mark AQGridView Delegate

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index  numFingersTouch:(NSUInteger)numFingers
{
    
    
    NSLog(@"Has tocat la cella %d", index);
}


- (void) gridView: (AQGridView *) gridView  deselectItemAtIndex: (NSUInteger) index animated: (BOOL) animated
{
    //	[self _deselectItemAtIndex: index animated: animated notifyDelegate: NO];
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
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/listStatus?status_id=1&destination_id=%d&udid=%d&user_id=%d&opportunity_id=%d",
                      [[Destination sharedInstance] destinationService], [[UserModel sharedUser] destinationID], [[UserModel sharedUser] udid], [[UserModel sharedUser] userID], _opportunity.opportunityID];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponse:) hudActivied:YES withString:@"Loading"];
//    [self stopLoading];
}
- (void)refresh {
    [self reload];
}

-(void) setOpportunity:(OpportunityModel *)opportunity {
    _opportunity=opportunity;
    [self setTitle:[opportunity name]];

    [self refresh];
}




- (void) setDataDict:(NSDictionary *)dict
{
    if ( [[dict objectForKey:@"errorCode"] isKindOfClass:[NSNumber class]] )
    {
 //       [dataDict release];
        NSMutableArray *newGuest=[[NSMutableArray alloc] init];
        NSArray * dataArray = (NSArray *) [dict objectForKey:@"list"];
     //   [_guests removeAllObjects];
        for ( int i = 0; i < [dataArray count]; i++ ) {
            //  NSString * index = [NSString stringWithFormat:@"%d", i];
            if ( [[dataArray objectAtIndex:i] isKindOfClass:[NSDictionary class]] ) {
                UserModel * user = [[UserModel alloc] init];
                [user parseDataDict:(NSDictionary *)[dataArray objectAtIndex:i]];
                [newGuest addObject:user];
                NSLog(@"User : %@",user.userName);
                
            }
        }
        _guests=[newGuest copy];
        [self.gridView reloadData];
    } else {
        NSLog(@"%@: Error: Code %d:  %@", [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue], [dict objectForKey:@"description"]);
    }
}


- (IBAction)sendMessage:(id)sender {
    [self resignKeyboard];
}
@end
