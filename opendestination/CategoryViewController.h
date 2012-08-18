//
//  CategoryViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/6/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomContentViewController.h"
#import "CategoriesTableViewController.h"

@interface CategoryViewController : UIViewController{
    int active;
}
@property (strong, nonatomic) CustomContentViewController *custom;
@property (strong, nonatomic) CategoriesTableViewController *categories;

@end
