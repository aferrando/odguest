//
//  Oportunity.h
//  opendestination
//
//  Created by David Hoyos on 22/08/11.
//  Copyright 2011 Kirubs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define kOpportunityUpdatedNotification @"kOpportunityUpdatedNotification"

typedef enum {
  OpportunityStatusPendant,
  OpportunityStatusInterested,
  OpportunityStatusWalkin,
  OpportunityStatusConsumed,
  OpportunityStatusNotInterested,
  OpportunityStatusWatched
} OpportunityStatus;
  
@interface OpportunityModel : NSObject <MKAnnotation>
{
  NSMutableDictionary * _userInfo;
  NSString * _language;
  NSInteger opportunityID;
  NSInteger points;
  NSInteger categoryID;
  NSInteger numOpportunities;
    
    NSInteger  numComments;
    NSInteger  numConsume;
    NSInteger  numInterests;
    NSInteger  numNotInterests;
    NSInteger  numWalkin;
    NSInteger  numWatchs;
    
    NSInteger interestedPeople;
  NSInteger conumers;
  double latitude;
  double longitude;
  NSString * _name;
  NSDictionary * _owner;
  NSString * _description;
  NSString * _imageURL;
    NSString * _thumbURL;
    NSString * _ownerImageURL;
  NSString * _type;
  OpportunityStatus status;
  NSArray * _interests;
  NSDate * _startDate;
  NSDate * _modifyDate;
  NSDate * _endDate;
  NSNumber * _visible;
  NSArray * _tags;
  NSArray * _targets;
  CLLocationCoordinate2D coordinate;
    NSString *_groupTag;

}
@property ( nonatomic, readonly ) NSMutableDictionary * userInfo;
@property ( nonatomic ) NSString * language;
@property ( nonatomic, assign ) NSInteger opportunityID;
@property ( nonatomic, assign ) NSInteger categoryID;
@property ( nonatomic, assign ) NSInteger points;
@property ( nonatomic, assign ) NSInteger numOpportunities;
@property ( nonatomic, assign ) NSInteger numComments;
@property ( nonatomic, assign ) NSInteger numConsume;
@property ( nonatomic, assign ) NSInteger numInterests;
@property ( nonatomic, assign ) NSInteger numNotInterests;
@property ( nonatomic, assign ) NSInteger numWalkin;
@property ( nonatomic, assign ) NSInteger numWatchs;
@property ( nonatomic, assign ) NSInteger interestedPeople;
@property ( nonatomic, assign ) NSInteger consumers;
@property ( nonatomic, assign ) double latitude;
@property ( nonatomic, assign ) double longitude;
@property ( nonatomic, assign ) BOOL visible;
@property ( nonatomic ) NSString * name;
@property ( nonatomic ) NSDictionary * owner;
@property ( nonatomic ) NSString * description;
@property ( nonatomic, assign ) OpportunityStatus status;
@property ( nonatomic ) NSString * ownerImageURL;
@property ( nonatomic ) NSString * imageURL;
@property ( nonatomic ) NSString * thumbURL;
@property ( nonatomic ) NSString * type;
@property ( nonatomic ) NSDate * startDate;
@property ( nonatomic ) NSDate * modifyDate;
@property ( nonatomic ) NSDate * endDate;
@property ( nonatomic ) NSArray * tags;
@property ( nonatomic ) NSArray * targets;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id) initWithId:(NSInteger)id;
- (void) reload;
- (void) setInterested;
- (void) setNotInterested;
- (void) setWatched;
- (void) syncEvent;
- (void) setWalkin;
- (void) parseDataDict:(NSDictionary *)dict;
- (void) parseDataDictTest:(NSDictionary *)dict;
- (NSString *)groupTag;
- (void)setGroupTag:(NSString *)tag;
- (int) getScore;
@end