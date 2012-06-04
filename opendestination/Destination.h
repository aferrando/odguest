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
  NSString * _destinationHostName;
  NSString * _destinationService;
  NSDictionary * _points;
    
  BOOL usersPoints;
  BOOL usersCanCreateOpportunities;
}
@property (assign) NSInteger destinationID;
@property  NSString * destinationName;
@property  NSString * destinationHostName;
@property  NSString * destinationService;
@property  NSDictionary * points;
@property (assign) BOOL usersPoints;
@property (assign) BOOL usersCanCreateOpportunities;

+(id) sharedInstance;
//Depending on the parameter retrieves the points
- (int) getValueFrom:(NSString *)parameter;
- (void) reload;
@end
