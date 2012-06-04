//
//  Oportunity.m
//  opendestination
//
//  Created by David Hoyos on 22/08/11.
//  Copyright 2011 Kirubs. All rights reserved.
//

#import "OpportunityModel.h"
#import "TaggedNSURLConnectionsManager.h"
#import "SBJsonParser.h"
#import "UserModel.h"
#import <EventKit/EventKit.h>
#import "Destination.h"

@interface OpportunityModel ()
- (void) setResponseData:(NSData *)data;
- (void) parseDataDict:(NSDictionary *)dict;
- (NSDate *) dateFromString:(NSString *)date;
@end

@implementation OpportunityModel;

@synthesize opportunityID, categoryID, longitude, latitude, numOpportunities, numComments, numInterests, numNotInterests, numWalkin, numWatchs, numConsume;
@synthesize points, interestedPeople, consumers, visible, status;
@synthesize language = _language;
@synthesize userInfo = _userInfo;
@synthesize owner = _owner;
@synthesize name = _name;
@synthesize description = _description;
@synthesize type = _type;
@synthesize imageURL = _imageURL;
@synthesize thumbURL = _thumbURL;
@synthesize startDate = _startDate;
@synthesize modifyDate = _modifyDate;
@synthesize endDate = _endDate;
@synthesize tags = _tags;
@synthesize targets = _targets;

-(id) init {
    self = [super init];
    if (self) {
        _userInfo = nil;
        self.language = @"en_US";
    }
    return self;
}

- (id) initWithId:(NSInteger)id
{
    self = [self init];
    if (self) {
        opportunityID = id;
        [self reload];
    }
    return self;
}

-(void)dealloc
{
    [_name release];
    [_type release];
    [_description release];
    [_owner release];
    [_imageURL release];
    [_thumbURL release];
    [_language release];
    [_startDate release];
    [_modifyDate release];
    [_endDate release];
    [_tags release];
    [_targets release];
    [_userInfo release];
    [super dealloc];
}

- (void) reload
{
    
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/get?destination_id=%d&user_id=%d&uuid=%@&opportunity_id=%d",
                      [[Destination sharedInstance] destinationService], [[UserModel sharedUser] destinationID], [[UserModel sharedUser] userID], [[UserModel sharedUser] udid], opportunityID];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:YES withString:nil];
}

#pragma mark -

- (CLLocationCoordinate2D) coordinate
{
    
    coordinate.latitude = self.latitude;
    coordinate.longitude = self.longitude;
    return coordinate;
}

- (NSString *)subtitle
{
    return [self.owner objectForKey:@"user_name"];
}


- (NSString *)title
{
    return self.name;
}

# pragma mark -

- (void) setResponseData:(NSData *)data
{
    [data retain];
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
                                               error:&error];
        [jsonParser release]; jsonParser = nil;
        if ( error == nil ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            if ( [jsonObject isKindOfClass:[NSDictionary class]] ) { 
                dict = jsonObject;
                if ( [(NSNumber *)[dict objectForKey:@"errorcode"] integerValue] > 0 ) {
                    NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
                    NSString * desc = (NSString *)[dict objectForKey:@"description"];
                    NSLog(@"%@: errorCode: %d: %@",[self description], errorCode, desc);
                } else {
                    [self parseDataDict:dict];
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
    [responseString release];
    [jsonParser release];
    [data release];
}


- (void) parseDataDict:(NSDictionary *)dict
{
#ifdef __DEBUG__
    NSLog(@"%@: opportunity: %@", [self description], [dict description]);
#endif
    [_userInfo release];
    _userInfo = nil;
    _userInfo = [dict retain];
    
    if ( [[_userInfo objectForKey:@"id"] isKindOfClass:[NSNumber class]] )
        self.opportunityID = [(NSNumber *)[_userInfo objectForKey:@"id"] integerValue];
    if ( [[_userInfo objectForKey:@"points"] isKindOfClass:[NSNumber class]] ) 
        self.points = [(NSNumber *)[_userInfo objectForKey:@"points"] integerValue];
    if ( [[_userInfo objectForKey:@"category"] isKindOfClass:[NSString class]] ) 
        self.categoryID = [(NSNumber *)[_userInfo objectForKey:@"category"] integerValue];
    if ( [[_userInfo objectForKey:@"owner"] isKindOfClass:[NSDictionary class]] )
        self.owner = [dict objectForKey:@"owner"];
    if ( [[_userInfo objectForKey:@"latitude"] isKindOfClass:[NSNumber class]])
        self.latitude = [(NSNumber *)[_userInfo valueForKey:@"latitude"] doubleValue];
    if ( [[_userInfo objectForKey:@"longitude"] isKindOfClass:[NSNumber class]]) 
        self.longitude = [(NSNumber *)[_userInfo valueForKey:@"longitude"] doubleValue];
    if ( [[_userInfo objectForKey:@"numOpportunities"] isKindOfClass:[NSNumber class]] )
        numOpportunities = [(NSNumber *)[_userInfo valueForKey:@"numOpportunities"] integerValue];
    if ( [[_userInfo objectForKey:@"num_consume"] isKindOfClass:[NSNumber class]] )
        numConsume = [(NSNumber *)[_userInfo valueForKey:@"num_consume"] integerValue];
    if ( [[_userInfo objectForKey:@"num_interests"] isKindOfClass:[NSNumber class]] )
        numInterests = [(NSNumber *)[_userInfo valueForKey:@"num_interests"] integerValue];
    if ( [[_userInfo objectForKey:@"num_notinterests"] isKindOfClass:[NSNumber class]] )
        numNotInterests = [(NSNumber *)[_userInfo valueForKey:@"num_notinterests"] integerValue];
    if ( [[_userInfo objectForKey:@"num_walkin"] isKindOfClass:[NSNumber class]] )
        numWalkin = [(NSNumber *)[_userInfo valueForKey:@"num_walkin"] integerValue];
    if ( [[_userInfo objectForKey:@"num_watchs"] isKindOfClass:[NSNumber class]] )
        numWatchs = [(NSNumber *)[_userInfo valueForKey:@"num_watchs"] integerValue];
    if ( [[_userInfo objectForKey:@"interestedPeople"] isKindOfClass:[NSNumber class]] )
        interestedPeople = [(NSNumber *)[_userInfo valueForKey:@"interestedPeople"] integerValue];
    if ( [[_userInfo objectForKey:@"consumers"] isKindOfClass:[NSNumber class]] )
        consumers= [(NSNumber *)[_userInfo valueForKey:@"consumers"] integerValue];
    if ( [[_userInfo objectForKey:@"name"] isKindOfClass:[NSString class]] )
        self.name = [_userInfo objectForKey:@"name"];
    if ( [[_userInfo objectForKey:@"opp_description"] isKindOfClass:[NSString class]] )
        self.description = [_userInfo  objectForKey:@"opp_description"];
    if ( [[_userInfo objectForKey:@"image"] isKindOfClass:[NSString class]] ) 
        self.imageURL = [NSString stringWithFormat:@"%@", [[_userInfo valueForKey:@"image"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ( [[_userInfo objectForKey:@"thumb"] isKindOfClass:[NSString class]] ) 
        self.thumbURL = [NSString stringWithFormat:@"%@",[[_userInfo valueForKey:@"thumb"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ( [[_userInfo objectForKey:@"type"] isKindOfClass:[NSString class]] ) 
        self.type = [_userInfo valueForKey:@"type"];
    if ( [[_userInfo objectForKey:@"status"] isKindOfClass:[NSNumber class]] )
        self.status = (OpportunityStatus)[[_userInfo objectForKey:@"status"] integerValue];
    if ( [[_userInfo objectForKey:@"startDate"] isKindOfClass:[NSString class]] )
        self.startDate = [self dateFromString:[_userInfo objectForKey:@"startDate"]];
    if ( [[_userInfo objectForKey:@"endDate"] isKindOfClass:[NSString class]] )
        self.endDate = [self dateFromString:[_userInfo objectForKey:@"endDate"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kOpportunityUpdatedNotification object:self];
}

- (NSDate *) dateFromString:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter dateFromString:date];
}

#pragma mark - 

- (void) parseStatus:(NSString *)stat {
    if ( [stat isEqualToString:@"pendant"] )
        status = OpportunityStatusPendant;
    else if ( [stat isEqualToString:@"interested"] )
        status = OpportunityStatusInterested;
    else if ( [stat isEqualToString:@"walkin"] )
        status = OpportunityStatusWalkin;
    else if ( [stat isEqualToString:@"consumed"] )
        status = OpportunityStatusConsumed;
}


- (void) setInterested {
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/interest?destination_id=%d&user_id=%d&uuid=%@&opportunity_id=%d",
                      [[Destination sharedInstance] destinationService], [[UserModel sharedUser] destinationID], [[UserModel sharedUser] userID], [[UserModel sharedUser] udid], opportunityID ];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:NO withString:nil];
}

- (void) setWatched {
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/setStatus?destination_id=%d&user_id=%d&uuid=%@&opportunity_id=%d&status=%d",
                      [[Destination sharedInstance] destinationService], [[UserModel sharedUser] destinationID], [[UserModel sharedUser] userID], [[UserModel sharedUser] udid], opportunityID, OpportunityStatusWatched];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:NO withString:nil];
}

- (void) setNotInterested {
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/setStatus?destination_id=%d&user_id=%d&uuid=%@&opportunity_id=%d&status=%d",
                      [[Destination sharedInstance] destinationService], [[UserModel sharedUser] destinationID], [[UserModel sharedUser] userID], [[UserModel sharedUser] udid], opportunityID, OpportunityStatusNotInterested];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:NO withString:nil];
}



- (void) syncEvent {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [[EKEvent eventWithEventStore:eventStore] autorelease];
    event.title     = self.name;
    event.startDate = self.startDate;
    event.endDate   = self.endDate;
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    UIAlertView * alert = [[UIAlertView  alloc] initWithTitle:@"Synced with your Agenda" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert autorelease];
}

- (void) setWalkin {
    NSString * url = [NSString stringWithFormat:@"%@/opportunity/walkin?destination_id=%d&user_id=%d&uuid=%@&opportunity_id=%d",
                      [[Destination sharedInstance] destinationService], [[UserModel sharedUser] destinationID], [[UserModel sharedUser] userID], [[UserModel sharedUser] udid], opportunityID ];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]
     getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:NO withString:nil];
}


@end