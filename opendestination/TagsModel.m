//
//  TagsModel.m
//  opendestination
//
//  Created by David Hoyos on 05/09/11.
//  Copyright 2011 None. All rights reserved.
//

#import "TagsModel.h"
#import "UserModel.h"
#import "TaggedNSURLConnectionsManager.h"
#import "JSON.h"
#import "Destination.h"


@interface TagsModel ()
- (void) setResponseData:(NSData *)data;
- (void) checkResponseData:(NSData *)data;
- (void) parseDataDict:(NSDictionary *)dict;
@end


@implementation TagsModel


@synthesize tags = _tags;
@synthesize userInfo = _userInfo;
@synthesize user = _user;


-(id) init {
  self = [super init];
  if (self) {
    _userInfo = nil;
    _user = [UserModel sharedUser];
  }
  return self;
}





#pragma mark - private methods


- (void) setResponseData:(NSData *)data
{
  NSError * error = nil;
  NSString * responseString = nil;
  SBJsonParser * jsonParser = nil;
  NSDictionary * dict = nil;
  if ( data )
  {
    jsonParser = [[SBJsonParser alloc] init];
    responseString = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    id jsonObject = [jsonParser objectWithString:responseString 
                                           ];
     jsonParser = nil;
    if ( error == nil ) {
#ifdef __DEBUG__
      NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
      if ( [jsonObject isKindOfClass:[NSDictionary class]] ) { 
        dict = jsonObject;
        if ( [(NSNumber *)[dict objectForKey:@"errorcode"] integerValue] != 0 ) {
          NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
          NSString * desc = (NSString *)[dict objectForKey:@"description"];
          NSLog(@"%@: errorCode: %d: %@",[self description], errorCode, desc);
        } else {
          [self parseDataDict:dict];
          [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kTagsUpdatedNotification object:self];
        }
      }
    } else {
#ifdef __DEBUG__
      NSLog(@"%@: Error at parsing json. Maybe an encoding problem. Error description: %@",[self description], [error description]);
#endif
    }
    
  } else {
#ifdef __DEBUG__
    NSLog(@"%@: Error response data with void data", [self description] );
#endif
  }
}

- (void) checkResponseData:(NSData *)data
{
  NSError * error = nil;
  NSString * responseString = nil;
  SBJsonParser * jsonParser = nil;
  NSDictionary * dict = nil;
  if ( data )
  {
    jsonParser = [[SBJsonParser alloc] init];
    responseString = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    id jsonObject = [jsonParser objectWithString:responseString 
                                           ];
     jsonParser = nil;
    if ( error == nil ) {
#ifdef __DEBUG__
      NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
      if ( [jsonObject isKindOfClass:[NSDictionary class]] ) { 
        dict = jsonObject;
        if ( [(NSNumber *)[dict objectForKey:@"errorcode"] integerValue] != 0 ) {
          NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
          NSString * desc = (NSString *)[dict objectForKey:@"description"];
          NSLog(@"%@: errorCode: %d: %@",[self description], errorCode, desc);
        } else {
          [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kTagsCreatedNotification object:self];
        }
      }
    } else {
#ifdef __DEBUG__
      NSLog(@"%@: Error at parsing json. Maybe an encoding problem. Error description: %@",[self description], [error description]);
#endif
    }
    
  } else {
#ifdef __DEBUG__
    NSLog(@"%@: Error response data with void data", [self description] );
#endif
  }
}


- (void) parseDataDict:(NSDictionary *)dict
{
#ifdef __DEBUG__
  NSLog(@"%@: category: %@", [self description], [dict description]);
#endif
  _userInfo = nil;
  _userInfo = dict;
  
  if ( [[dict objectForKey:@"list"] isKindOfClass:[NSArray class]] )
  {
    _tags = [_userInfo objectForKey:@"list"];
  }
  
}


#pragma mark - public methods

- (void) reload
{
  if ( [_user signedIn] ) {
    NSString * url = [NSString stringWithFormat:@"%@/tags/list?destination_id=%d&user_id=%d&uuid=%@",[[Destination sharedInstance] destinationService], [_user destinationID], [_user userID]];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:NO withString:nil];
  }
}

- (void) create:(NSString *)tag
{
  if ( [_user signedIn] ) {
    NSString * url = [NSString stringWithFormat:@"%@/tags/create?destination_id=%d&user_id=%d&uuid=%@&name=%@",[[Destination sharedInstance] destinationService], [_user destinationID], [_user userID], tag];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(checkResponseData:) hudActivied:NO withString:nil];
  }
  
}

- (void) associate:(BOOL)flag tag:(NSInteger)tagID toOpportunitu:(NSInteger *)oppID ;
{
  if ( [_user signedIn] ) {
    NSString * url = [NSString stringWithFormat:@"%@/tags/associate?destination_id=%d&user_id=%d&uuid=%@&opportunity_id=%d&tag_id=%d&value=&d",[[Destination sharedInstance] destinationService], [_user destinationID], [_user userID], oppID, tagID, (flag?1:0)];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(checkResponseData:) hudActivied:NO withString:nil];
  }
}



@end
