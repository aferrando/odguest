//
//  CategoryModel.h
//  opendestination
//
//  Created by David Hoyos on 05/09/11.
//  Copyright 2011 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockAlertView.h"

#define kCategoryUpdatedNotification @"kCategoryUpdatedNotification"

@interface CategoryModel : NSObject <NSCopying>
{
  NSDictionary * _userInfo;
  NSInteger categoryID;
  NSInteger parentID;
  NSInteger numOpportunities;
  NSString * __unsafe_unretained _language;
    NSString * _name;
    NSString * _description;
    NSString * _imageURL;
    NSString * _iconURL;
  NSArray * _tags;
  NSArray * _sons;
    BOOL widget;
    BOOL folder;
    BlockAlertView *alert;
}
@property ( nonatomic, readonly ) NSDictionary * userInfo;
@property ( nonatomic, assign ) NSInteger categoryID;
@property ( nonatomic, assign ) NSInteger parentID;
@property ( nonatomic, assign ) NSInteger numOpportunities;
@property ( nonatomic, unsafe_unretained ) NSString * language;
@property ( nonatomic ) NSString * name;
@property ( nonatomic ) NSString * description;
@property ( nonatomic ) NSString * imageURL;
@property ( nonatomic ) NSString * iconURL;
@property ( nonatomic ) NSArray * tags;
@property ( nonatomic ) NSArray * sons;
@property (assign) BOOL widget;
@property (assign) BOOL folder;
@property (strong, nonatomic) BlockAlertView *alert;

- (id) initWithId:(NSInteger)id;
- (id) initWithInfo:(NSDictionary *)userInfo;
- (void) reload;
- (void) parseDataDict:(NSDictionary *)dict;


@end
