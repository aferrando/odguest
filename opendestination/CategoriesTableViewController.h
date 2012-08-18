//
//  CategoriesTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/5/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
#import "UserModel.h"

@interface CategoriesTableViewController : UITableViewController {
CategoryModel * _category;
UserModel * _userModel;
}
@property ( nonatomic ) CategoryModel * category;
@property ( nonatomic ) UserModel * userModel; 
-(void) update;

@end
