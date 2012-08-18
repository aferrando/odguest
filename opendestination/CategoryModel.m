    //
    //  CategoryModel.m
    //  opendestination
    //
    //  Created by David Hoyos on 05/09/11.
    //  Copyright 2011 None. All rights reserved.
    //

#import "CategoryModel.h"
#import "UserModel.h"
#import "TaggedNSURLConnectionsManager.h"
#import "JSON.h"
#import "Destination.h"


@interface CategoryModel ()
@property (nonatomic, unsafe_unretained) UserModel * user;
- (void) setResponseData:(NSData *)data;
- (void) parseDataDict:(NSDictionary *)dict;
@end


@implementation CategoryModel

@synthesize  categoryID, parentID, numOpportunities;
@synthesize language = _language;
@synthesize name = _name;
@synthesize description = _description;
@synthesize imageURL = _imageURL;
@synthesize iconURL = _iconURL;
@synthesize tags = _tags;
@synthesize sons = _sons;
@synthesize userInfo = _userInfo;
@synthesize user;
@synthesize widget, folder;

-(id) init {
    self = [super init];
    if (self) {
        categoryID = -1;
        _userInfo = nil;
        self.sons = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.language = @"en_US";
        self.user = [UserModel sharedUser];
    }
    return self;
}

-(id) initWithInfo:(NSDictionary *)userInfo
{
    self = [super init];
    if (self) {
        self.user = [UserModel sharedUser];
        [self parseDataDict:userInfo];
    }
    return self;
}

- (id) initWithId:(NSInteger)id
{
    self = [self init];
    if (self) {
        self.categoryID = id;
    }
    return self;
}



#pragma mark - 
- (id)copyWithZone:(NSZone *)zone {
    CategoryModel *copy = [[[self class] allocWithZone:zone] initWithInfo:_userInfo];
    return copy;
}

#pragma mark -

- (void) reload
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSDate *endate = [today dateByAddingTimeInterval:60*60*24*7];
        //[dateFormatter setLocale:myLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //[myLocale release];
    
        //if ( [user signedIn] ) {
        NSString * url = [NSString stringWithFormat:@"%@/category/get?destination_id=%d&user_id=%d&uuid=%@&category_id=%d&start_date=%@&end_date=%@&language_id=%@",[[Destination sharedInstance] destinationService], [user destinationID], [user userID], [user udid], categoryID, [dateFormatter stringFromDate:today], [dateFormatter stringFromDate:endate], [user localeID]];
        if (categoryID==0) {
            [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:NO withString:NSLocalizedString(@"Loading Categories",@"Loading categories")];
        } else {
            [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(setResponseData:) hudActivied:NO withString:NSLocalizedString(@"Loading Categories",@"Loading categories")];
            
        }
        // }
}


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
        id jsonObject = [jsonParser objectWithString:responseString];
        jsonParser = nil;
        if ( error == nil ) {
#ifdef __DEBUG__
                //       NSLog(@"%@: Received data: %@", [self description],  responseString);
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
}


- (void) parseDataDict:(NSDictionary *)dict
{
#ifdef __DEBUG__
    NSLog(@"%@: category: %@", [self description], [dict description]);
#endif
    _userInfo = nil;
    if ( [[dict objectForKey:@"list"] isKindOfClass:[NSArray class]] )
        _userInfo = [[dict objectForKey:@"list"] objectAtIndex:0];
    else 
        _userInfo = dict;
    
    if ( ( [[_userInfo objectForKey:@"category_id"] isKindOfClass:[NSNumber class]] ) || ( [[_userInfo objectForKey:@"category_id"] isKindOfClass:[NSString class]] ) )
        self.categoryID = [(NSNumber *)[_userInfo objectForKey:@"category_id"] integerValue];
    if ( ( [[_userInfo objectForKey:@"parent_id"] isKindOfClass:[NSNumber class]] ) || ( [[_userInfo objectForKey:@"parent_id"] isKindOfClass:[NSString class]] ) )
        self.parentID = [(NSNumber *)[_userInfo objectForKey:@"parent_id"] integerValue];
    if (( [[_userInfo objectForKey:@"numOpportunities"] isKindOfClass:[NSNumber class]] ) || ( [[_userInfo objectForKey:@"numOpportunities"] isKindOfClass:[NSString class]] ) )
        self.numOpportunities = [[_userInfo objectForKey:@"numOpportunities"] integerValue];
    if ( [[_userInfo objectForKey:@"name"] isKindOfClass:[NSString class]] )
        self.name = [_userInfo valueForKey:@"name"];
    if ( [[_userInfo objectForKey:@"image"] isKindOfClass:[NSString class]] ) {
            //self.imageURL = [NSString stringWithFormat:@"%@/%@", [[Destination sharedInstance] destinationHostName], [[_userInfo valueForKey:@"image"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.imageURL = [[_userInfo valueForKey:@"image"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ( [[_userInfo objectForKey:@"icon"] isKindOfClass:[NSString class]] ) {
            //self.imageURL = [NSString stringWithFormat:@"%@/%@", [[Destination sharedInstance] destinationHostName], [[_userInfo valueForKey:@"image"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.iconURL = [[_userInfo valueForKey:@"icon"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ( [[_userInfo objectForKey:@"tags"] isKindOfClass:[NSArray class]] )
        self.tags = [_userInfo valueForKey:@"tags"];
    if ( [[_userInfo objectForKey:@"sons"] isKindOfClass:[NSArray class]] ) {
        NSMutableArray* sonsArray = [[NSMutableArray alloc] initWithCapacity:0];
        for ( NSDictionary * d in (NSArray *)[_userInfo objectForKey:@"sons"] ) {
            CategoryModel * c = [[CategoryModel alloc] initWithInfo:d];
            [sonsArray addObject:c];
        }
        self.sons = [NSArray arrayWithArray:sonsArray];
    }
    self.widget = [(NSNumber *)[dict valueForKey:@"widget"] boolValue];
    self.folder = [(NSNumber *)[dict valueForKey:@"folder"] boolValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kCategoryUpdatedNotification object:self];
}


@end
