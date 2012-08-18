//
//  MeTableViewController.h
//  opendestination
//
//  Created by Albert Ferrando on 8/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockAlertView.h"
@class FKFormModel;
@class UserModel;

@interface MeTableViewController : UITableViewController{
    BlockAlertView *alert;
    BOOL valueChanged;
}
@property (nonatomic, strong) FKFormModel *formModel;
@property (nonatomic, strong) UserModel *user;
@property (strong, nonatomic) BlockAlertView *alert;

@end
