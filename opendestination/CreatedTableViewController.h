//
//  CreatedTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 11/30/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface CreatedTableViewController : UITableViewController
{
    ContentPageTransitionType transition;
}
@property ( nonatomic, assign ) ContentPageTransitionType transition;
- (void) reload;
@end
