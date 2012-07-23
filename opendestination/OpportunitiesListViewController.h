//
//  OportunitiesListViewController.h
//  opendestination
//
//  Created by David Hoyos on 13/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"
#import "CategoryModel.h"
#import "ClusterMapViewController.h"
#import "PullRefreshTableViewController.h"
#import "MGTileMenuController.h"
#import "SlidingTabsControl.h"


@interface OpportunitiesListViewController :UIViewController
<UITableViewDelegate, UITableViewDataSource, MGTileMenuDelegate, SlidingTabsControlDelegate>
{
  UserModel * userModel;
  PullRefreshTableViewController * _tableViewController;
  NSInteger categoryID;
    NSMutableArray * _opportunities;
    NSMutableArray * _opportunities4;
    NSMutableArray * _opportunities24;
    NSMutableArray * _opportunitiesLater;
  NSDictionary * _dataDict;
    UINib *cellLoader;
    CategoryModel * category;       
    ClusterMapViewController * map;

@ private
  NSIndexPath * lastSelectedIndex;
    
}
@property ( nonatomic, assign ) NSInteger categoryID;
@property ( nonatomic ) IBOutlet PullRefreshTableViewController * tableViewController;
@property ( nonatomic ) NSDictionary * dataDict;
@property ( nonatomic ) CategoryModel * category;
@property ( nonatomic ) ClusterMapViewController * map;
@property (strong, nonatomic) MGTileMenuController *tileController;
- (IBAction) showMapLocation;

- (void) refresh;
- (void) setDataDict:(NSDictionary *)dict;

@end
