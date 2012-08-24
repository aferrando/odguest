//
//  FeedTableViewController.m
//  opendestination
//
//  Created by Albert Ferrando on 8/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "FeedTableViewController.h"
#import "NSString+HTML.h"
#import "MWFeedParser.h"
#import "FeedDetailViewController.h"
#import "GlobalConstants.h"


@implementation FeedTableViewController
@synthesize itemsToDisplay;

#pragma mark -
#pragma mark View lifecycle


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
        // Super
	[super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

        // Setup
	self.title = NSLocalizedString(@"loadingKey",@"");
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	parsedItems = [[NSMutableArray alloc] init];
	self.itemsToDisplay = [NSArray array];
	
        // Refresh button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																							target:self
																							action:@selector(refresh)] ;
        // Parse
	NSURL *feedURL = [NSURL URLWithString:NEWS_URL];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark Parsing

    // Reset and reparse
- (void)refresh {
	self.title = @"Refreshing...";
	[parsedItems removeAllObjects];
	[feedParser stopParsing];
	[feedParser parse];
	self.tableView.userInteractionEnabled = NO;
	self.tableView.alpha = 0.3;
}

- (void)updateTableWithParsedItems {
	self.itemsToDisplay = [parsedItems sortedArrayUsingDescriptors:
						   [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"date"
																				 ascending:NO] ]];
	self.tableView.userInteractionEnabled = YES;
	self.tableView.alpha = 1;
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.title = NSLocalizedString(@"newsKey", @"news");
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	NSLog(@"Parsed Feed Item: “%@”", item.title);
	if (item) [parsedItems addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
    [self updateTableWithParsedItems];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
    if (parsedItems.count == 0) {
        self.title = @"Failed"; // Show failed message in title
    } else {
            // Failed but some items parsed, so show and inform of error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Incomplete"
                                                         message:@"There was an error during the parsing of this feed. Not all of the feed items could parsed."
                                                        delegate:nil
                                               cancelButtonTitle:@"Dismiss"
                                               otherButtonTitles:nil] ;
        [alert show];
    }
    [self updateTableWithParsedItems];
}
#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark -
#pragma mark Table view data source

    // Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

    // Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsToDisplay.count;
}

    // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]  ;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
        // Configure the cell.
	MWFeedItem *item = [itemsToDisplay objectAtIndex:indexPath.row];
	if (item) {
		
            // Process
		NSString *itemTitle = item.title ? [item.title stringByConvertingHTMLToPlainText] : @"[No Title]";
		NSString *itemSummary = item.summary ? [item.summary stringByConvertingHTMLToPlainText] : @"[No Summary]";
		
            // Set
            //	cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            //	cell.textLabel.text = itemTitle;
		NSMutableString *subtitle = [NSMutableString string];
		if (item.date) [subtitle appendFormat:@"(%@) ", [formatter stringFromDate:item.date]];
		[subtitle appendString:itemSummary];
            //	cell.detailTextLabel.text = subtitle;
        UIView * content = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 80)];
        

        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 6.0, 270, 24)];
        textLabel.font = [UIFont boldSystemFontOfSize:17];
        textLabel.textColor = kTextLabelCellColor;
        [textLabel setShadowColor:[UIColor blackColor]];
        [textLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        [textLabel setMinimumFontSize:10.0];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 1;
        textLabel.text=itemTitle;
            // [[self subviewsDict] setObject:textLabel forKey:@"textLabel"];
        [content addSubview:textLabel];
        
               
        UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 270, 50)];
        descLabel.font = [UIFont systemFontOfSize:10];
        [descLabel setMinimumFontSize:10.0];
        descLabel.textColor = kDescriptionLabelCellColor;
        [descLabel setShadowColor:[UIColor blackColor]];
        [descLabel setShadowOffset:CGSizeMake(1.0, 1.0)];
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.numberOfLines = 2;
        descLabel.text=subtitle;
            //  [[self subviewsDict] setObject:descLabel forKey:@"descLabel"];
        [content addSubview:descLabel];
        [content setBackgroundColor:kCellBackgroundColor];
        [cell addSubview:content];

		
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        // Show detail
	FeedDetailViewController *detail = [[FeedDetailViewController alloc] initWithStyle:UITableViewStylePlain];
	detail.item = (MWFeedItem *)[itemsToDisplay objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:detail animated:YES];
        //[detail release];
	
        // Deselect
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
}

@end
