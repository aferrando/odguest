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
}
@property ( nonatomic, readonly, retain ) NSMutableDictionary * userInfo;
@property ( nonatomic, retain ) NSString * language;
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
@property ( nonatomic, retain ) NSString * name;
@property ( nonatomic, retain ) NSDictionary * owner;
@property ( nonatomic, retain ) NSString * description;
@property ( nonatomic, assign ) OpportunityStatus status;
@property ( nonatomic, retain ) NSString * imageURL;
@property ( nonatomic, retain ) NSString * thumbURL;
@property ( nonatomic, retain ) NSString * type;
@property ( nonatomic, retain ) NSDate * startDate;
@property ( nonatomic, retain ) NSDate * modifyDate;
@property ( nonatomic, retain ) NSDate * endDate;
@property ( nonatomic, retain ) NSArray * tags;
@property ( nonatomic, retain ) NSArray * targets;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id) initWithId:(NSInteger)id;
- (void) reload;
- (void) setInterested;
- (void) setNotInterested;
- (void) setWatched;
- (void) syncEvent;
- (void) setWalkin;
- (void) parseDataDict:(NSDictionary *)dict;

@end