//
//  TODOTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 7/11/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClusterMapViewController.h"
#import "UserModel.h"
#import "TODOEmptyViewController.h"
@interface TODOTableViewController : UITableViewController
{
    NSMutableArray * _opportunities;
    NSMutableArray * _opportunities4;
    NSMutableArray * _opportunities24;
    ClusterMapViewController * map;
    NSMutableArray * _opportunitiesLater;
    int selectedControl;
    TODOEmptyViewController *empty;

}
@property ( nonatomic)  UISegmentedControl *typeSegmentedCtrl;
@property ( nonatomic ) ClusterMapViewController * map;
@property ( nonatomic ) UserModel * userModel;
@property ( nonatomic ) NSMutableArray * doneTODO;
@property ( nonatomic ) NSDictionary * dataDict;

@end
