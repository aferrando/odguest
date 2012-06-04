//
//  TagsModel.h
//  opendestination
//
//  Created by David Hoyos on 05/09/11.
//  Copyright 2011 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

#define kTagsUpdatedNotification @"kTagsUpdatedNotification"
#define kTagsCreatedNotification @"kTagsUpdatedNotification"


@interface TagsModel : NSObject
{
  NSDictionary * _userInfo;
  NSMutableArray * _tags;
  UserModel * _user;
}
@property ( nonatomic, readonly ) NSDictionary * userInfo;
@property ( nonatomic, readonly ) NSMutableArray * tags;
@property ( nonatomic ) UserModel * user;

- (void) reload;
- (void) create:(NSString *)tag;
- (void) associate:(BOOL)flag tag:(NSInteger)tagID toOpportunitu:(NSInteger *)oppID ;

@end
