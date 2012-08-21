//
//  MySharesTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 1/18/12.
//  Copyright (c) 2012 None. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "PullRefreshTableViewController.h"
#import "CustomBadge.h"

@interface MySharesTableViewController : PullRefreshTableViewController
{
    UILabel *noItemLabel;
    CustomBadge *badgeNext;
    CustomBadge *badgeRedeeming;
}
@property ( nonatomic)  UISegmentedControl *typeSegmentedCtrl;
@property ( nonatomic)  UILabel *noItemLabel;
@property ( nonatomic)  CustomBadge *badgeNext;;
@property ( nonatomic)  CustomBadge *badgeRedeeming;

- (void) reload;
-(void) addCloseWindow;
@end
