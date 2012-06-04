//
//  Destination.m
//  opendestination
//
//  Created by David Hoyos on 18/10/11.
//  Copyright 2011 None. All rights reserved.
//

#import "Destination.h"
#import "TaggedNSURLConnectionsManager.h"
#import "JSON.h"

@interface Destination ()
- (void) setResponseData:(NSData *)data;
- (void) parseDataDict:(NSDictionary *)dict;
@end


@implementation Destination

static Destination * sharedInstance = nil;

@synthesize destinationID, usersPoints, usersCanCreateOpportunities;
@synthesize destinationHostName = _destinationHostName;
@synthesize destinationService = _destinationService;
@synthesize destinationName = _destinationName;
@synthesize points = _points;


-(id) init
{
    self = [super init];
    if (self) {
        self.destinationID = kDESTINATION_ID;
        self.destinationHostName = kPRODUCTION_HOST;
        usersCanCreateOpportunities = YES;
        usersPoints = YES;
        NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
        if ( [(NSNumber *)[settings valueForKey:@"production"] boolValue] == NO )
        {
            self.destinationHostName = kDEVELOPMENT_HOST;
        }
        self.destinationService = [NSString stringWithFormat:@"%@%@", self.destinationHostName,kSERVICEBASE];
        self.destinationID = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"destination"] integerValue];
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
        responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        id jsonObject = [jsonParser objectWithString:responseString ];
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kDestinationDidUpdateNotification object:self];
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

- (int) getValueFrom:(NSString *)parameter
{
    if ([self.points valueForKey:parameter]==[NSNull null]) return 0;
    return [(NSNumber *) [self.points valueForKey:parameter] intValue];
}

- (void) parseDataDict:(NSDictionary *)dict
{
#ifdef __DEBUG__
    NSLog(@"%@: Destination Settings: %@", [self description], [dict description]);
#endif
    
    if ( [[dict objectForKey:@"destination_name"] isKindOfClass:[NSString class]] )
    {
        @synchronized(self) {
            self.destinationName = [dict objectForKey:@"destination_name"];
            self.points = [dict objectForKey:@"points"];
            self.usersPoints = [(NSNumber *)[dict valueForKey:@"users_points"] boolValue];
            self.usersCanCreateOpportunities = [(NSNumber *)[dict valueForKey:@"users_can_create_opportunities"] boolValue];
          /*   points =     {
                consumed = "<null>";
                created = "<null>";
                feedback = "<null>";
                interested = "<null>";
                "points_per_opp" = "<null>";
                starting = "<null>";
            };*/
        }
    }
}


#pragma mark - public methods

+(id) sharedInstance
{
    static dispatch_once_t pred;
    if (!sharedInstance) {
        dispatch_once(&pred,^{sharedInstance =[[self alloc] init];});
    }
    return sharedInstance;
}


- (void) reload
{
    NSString * url = [NSString stringWithFormat:@"%@/destination/get?destination_id=%d&device_type=ios",[[Destination sharedInstance] destinationService], self.destinationID];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:YES withString:NSLocalizedString(@"Loading Destination info..", @"Init")];
}

@end
