//
//  FeedTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"

@interface FeedTableViewController :  UITableViewController <MWFeedParserDelegate> {
	
        // Parsing
	MWFeedParser *feedParser;
	NSMutableArray *parsedItems;
	
        // Displaying
	NSArray *itemsToDisplay;
	NSDateFormatter *formatter;
	
}

    // Properties
@property (nonatomic, retain) NSArray *itemsToDisplay;

@end
