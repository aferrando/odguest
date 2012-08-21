//
//  FeedDetailViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/20/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedItem.h"
@interface FeedDetailViewController : UITableViewController{
	MWFeedItem *item;
	NSString *dateString, *summaryString;
}

@property (nonatomic, retain) MWFeedItem *item;
@property (nonatomic, retain) NSString *dateString, *summaryString;

@end
