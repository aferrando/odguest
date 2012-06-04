//
//  OportunitiesListViewController.h
//  opendestination
//
//  Created by David Hoyos on 13/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"

@interface OportunitiesListViewController : CustomContentViewController
<UITableViewDelegate, UITableViewDataSource>
{
  UserModel * userModel;
  UITableViewController * _tableViewController;
  NSInteger categoryID;
  NSMutableArray * _opportunities;
  NSDictionary * _dataDict;
    UINib *cellLoader;

@ private
  NSIndexPath * lastSelectedIndex;
    
}
@property ( nonatomic, assign ) NSInteger categoryID;
@property ( nonatomic, retain ) IBOutlet UITableViewController * tableViewController;
@property ( nonatomic, retain ) NSDictionary * dataDict;

- (void) refresh;
- (void) setDataDict:(NSDictionary *)dict;

@end
