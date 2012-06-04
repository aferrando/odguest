//
//  MyNotificationsTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 11/23/11.
//  Copyright (c) 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"


@interface MyNotificationsTableViewController : UITableViewController
{
    ContentPageTransitionType transition;
}
@property ( nonatomic, assign ) ContentPageTransitionType transition;
- (void) reload;
@end
