//
//  MyDealsTableViewController.h
//  opendestination
//
//  Created by David Hoyos on 04/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "CustomBadge.h"
#import "ClusterMapViewController.h"
@interface MyDealsTableViewController : PullRefreshTableViewController 
{
    UILabel *noItemLabel;
    CustomBadge *badgeNext;
    CustomBadge *badgeRedeeming;
    NSMutableArray * _deals;
    NSMutableArray * _opportunities4;
    NSMutableArray * _opportunities24;
    ClusterMapViewController * map;
    NSMutableArray * _opportunitiesLater;
    int selectedControl;

}
@property ( nonatomic)  UISegmentedControl *typeSegmentedCtrl;
@property ( nonatomic)  UILabel *noItemLabel;
@property ( nonatomic)  CustomBadge *badgeNext;;
@property ( nonatomic)  CustomBadge *badgeRedeeming;
@property ( nonatomic ) ClusterMapViewController * map;

- (void) reload;
-(void) addCloseWindow;
@end
