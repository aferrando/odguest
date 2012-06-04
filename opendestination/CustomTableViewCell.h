//
//  CustomTableViewCell.h
//  Created by David Hoyos on 14/04/10.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpportunityModel.h"
#import "UserModel.h"
@interface CustomTableViewCell : UITableViewCell {
  NSMutableDictionary * subviewsDict;
    BOOL mydeals;
}
@property (nonatomic, readonly) NSMutableDictionary * subviewsDict;
- (void) loadViews:(OpportunityModel *)opportunity userModel:(UserModel *)user;
- (void) setMyDeals:(BOOL) mydeals;
@end
