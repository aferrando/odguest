//
//  opendestinationAppDelegate.h
//  opendestination
//
//  Created by David Hoyos on 04/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "DataSet.h"
#import "RootViewController.h"
#import "CustomContentViewController.h"
#import "CategoriesTableViewController.h"
#import "CategoryViewController.h"
@class MixpanelAPI;

@interface opendestinationAppDelegate : NSObject <UIApplicationDelegate> {
    Facebook *facebook;
    DataSet *apiData;
    NSMutableDictionary *userPermissions;
	MixpanelAPI *mixpanel;
}
@property ( nonatomic ) IBOutlet UIWindow * window;
@property (nonatomic, retain) Facebook *facebook;
@property (strong, nonatomic) RootViewController *rootController;
@property (strong, nonatomic) CustomContentViewController *custom;
@property (strong, nonatomic) CategoriesTableViewController *categories;
@property (strong, nonatomic) CategoryViewController *category;
@property (nonatomic, retain) DataSet *apiData;

@property (nonatomic, retain) NSMutableDictionary *userPermissions;

@end
