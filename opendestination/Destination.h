//
//  Destination.h
//  opendestination
//
//  Created by David Hoyos on 18/10/11.
//  Copyright 2011 None. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDestinationDidUpdateNotification @"kDestinationUpdateNotification"


@interface Destination : NSObject {
  NSInteger destinationID;
    NSString * _destinationName;
    NSString * _destinationImage;
  NSString * _destinationHostName;
  NSString * _destinationService;
    NSDictionary * _points;
    NSDictionary * _languages;
    NSArray * _levels;
    double latitude;
    double longitude;
    
  BOOL usersPoints;
  BOOL usersCanCreateOpportunities;
}
@property (assign) NSInteger destinationID;
@property  NSString * destinationName;
@property  NSString * destinationImage;
@property  NSString * destinationHostName;
@property  NSString * destinationService;
@property  NSDictionary * points;
@property  NSDictionary * languages;
@property  NSArray * levels;
@property ( nonatomic, assign ) double latitude;
@property ( nonatomic, assign ) double longitude;
@property (assign) BOOL usersPoints;
@property (assign) BOOL usersCanCreateOpportunities;

+(id) sharedInstance;
//Depending on the parameter retrieves the points
- (int) getValueFrom:(NSString *)parameter;
- (NSString *) getLevelFrom:(NSInteger)userPoints;
- (int) getGoalFrom:(NSInteger)userPoints;
- (int) getStartingFrom:(NSInteger)userPoints;
- (void) reload;
@end
