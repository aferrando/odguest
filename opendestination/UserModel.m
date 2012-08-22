    //
//  UserModel.m
//  opendestination
//
//  Created by David Hoyos on 01/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import "UserModel.h"
#import "JSON.h"
#import "opendestinationAppDelegate.h"
#import "TaggedNSURLConnectionsManager.h"
#import "Utilities.h"
#import "IAMultipartRequestGenerator.h"
#import "Destination.h"
#import "YRDropdownView.h"
#import "BlockAlertView.h"


@interface UserModel ()
- (void) setDataDict:(NSDictionary *)dict;
- (void) saveSettings;
- (void) getUserInfoForLoginResponseData:(NSData *)data;
- (void) setResponseUserData:(NSData *)data;
@end


@implementation UserModel

@synthesize signedIn, dataDict, udid, deviceRegistered, guest, userStatus;
@synthesize points, goal, opportunities,notifications, shares, tags, destinationName;
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize image = _image;
@synthesize thumb = _thumb;
@synthesize realName = _realName;
@synthesize localeID = _localeID;
@synthesize gender = _gender;
@synthesize birthDate = _birthDate;
@synthesize myLocation = _myLocation;
@synthesize userID = _userID;
@synthesize destinationID = _destinationID;
@synthesize locationManager = _locationManager;
@synthesize level = _level;

static UserModel * sharedInstance = nil;



+(id) sharedUser
{
  static dispatch_once_t pred;
  if (!sharedInstance) {
    dispatch_once(&pred, ^{sharedInstance = [[self alloc] init];});
  }
  return sharedInstance;
}

-(id) init
{
  self = [super init];
  if (self) {
    _myLocation = nil;
    locating = NO;
    deviceRegistered = NO;
    signedIn = NO;
    guest = YES;
    self.udid = [[UIDevice currentDevice] uniqueIdentifier];
      self.points = [[Destination sharedInstance] getValueFrom:@"starting"];
    self.userID = 0;
    self.password = nil;
#warning the Locale is hardcode to en_US
      
    self.localeID = @"en_US"; //NSLocale *locale = [NSLocale currentLocale];
    self.birthDate = [[NSDate alloc] init];
      self.opportunities = 0;
      self.notifications = 0;
    self.tags = 0;
    self.points = 0;
    self.goal = 50;
    postingData = NO;
    _image = nil;
    _thumb = nil;
    userStatus = UserModelStatusSignedOut;
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ( ! [settings objectForKey:@"destination"] )
    {
      [settings setObject:[NSNumber numberWithInteger:kDESTINATION_ID]
                   forKey:@"destination"];
      [settings synchronize];
      self.destinationID = kDESTINATION_ID;
    }
    else
    {
      self.destinationID = [(NSNumber *)[settings objectForKey:@"destination"] integerValue];
    }
    signedIn = [settings boolForKey:@"signedIn"];
    guest = [settings boolForKey:@"guest"];
    if (  [settings valueForKey:@"deviceRegistered"] )
      deviceRegistered = [(NSNumber *)[settings valueForKey:@"deviceRegistered"] boolValue];
    if ( [settings integerForKey:@"userID"] )
      _userID = [settings integerForKey:@"userID"];
    if ( signedIn && [settings objectForKey:@"userInfo"] ) {
      NSData *myEncodedObject = [settings objectForKey:@"userInfo"];
      [self setDataDict:(NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject]];
      if ( self.userID > 0 )
        [self refresh];
    }
  }
  return self;
}


-(void)dealloc
{
  [self saveSettings];
        //  nil;
        //  nil;
}


# pragma mark - NSCodingProtocol Methods

- (id) initWithCoder: (NSCoder *)coder
{
  if ( (self = [super init]) )
  {
    //[self setDataDict:[coder decodeObjectForKey:@"userInfo"]];
  }
  return self;
}


- (void) encodeWithCoder:(NSCoder *)coder
{
  //NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataDict];
  //[coder encodeObject:myEncodedObject forKey:@"userInfo"];
}
- (void) setLocaleIDValue:(NSString *) localeIDvalue{
}
- (NSString *) localeIDValue{
    NSArray *values = [[[Destination sharedInstance] languages] allKeys];
        // Configure the cell...
        //   NSMutableArray *languages=[[NSMutableArray alloc] init];
        //  for (int i = 0; i < [values count]; i++) {
        NSDictionary *currentObject= [[[Destination sharedInstance] languages] objectForKey:[values objectAtIndex:[self.localeID integerValue]]];
            // if ([(NSNumber *)[currentObject valueForKey:@"id"] intValue]  == row){
        NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[currentObject  objectForKey:@"code"] ] ;
            //    NSLocale *currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:[[values objectAtIndex:indexPath.row]  objectForKey:@"code"] ] ;
        NSArray *myArray = [[currentLocale  displayNameForKey:NSLocaleIdentifier value:[currentObject  objectForKey:@"code"]] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"("]];
    return [myArray objectAtIndex:0];
}

 
- (void) setGenderValue:(NSString *) genderValue{
    if ([genderValue isEqualToString:NSLocalizedString(@"maleKey", @"")]) {
        _gender=@"0";
    } else
        _gender=@"1";
}
- (NSString *) genderValue{
    switch ([_gender integerValue]) {
        case 0:
            return  NSLocalizedString(@"maleKey", @"");
            break;
            
        default:
            return  NSLocalizedString(@"femaleKey", @"");
            break;
    }
}

# pragma mark - Private methods

- (void) setDataDict:(NSDictionary *)dict
{
  dataDict = nil;
  dataDict = dict;
  
  if ( [[self.dataDict objectForKey:@"id"] isKindOfClass:[NSNumber class]] )
    self.userID = [[dict objectForKey:@"id"] integerValue];
  if ( [[self.dataDict objectForKey:@"destination_name"] isKindOfClass:[NSString class]] )
    self.destinationName = [self.dataDict objectForKey:@"destination_name"];
  if ( [[self.dataDict objectForKey:@"username"] isKindOfClass:[NSString class]] )
    self.userName = [self.dataDict objectForKey:@"username"];
  if ( [[self.dataDict objectForKey:@"realname"] isKindOfClass:[NSString class]] )
    self.realName = [self.dataDict objectForKey:@"realname"];
  self.gender = [self.dataDict objectForKey:@"gender"];
  if ( [[self.dataDict objectForKey:@"language_id"] isKindOfClass:[NSString class]] )
    self.localeID = [self.dataDict objectForKey:@"language_id"];
  if ( [[self.dataDict objectForKey:@"birthday"] isKindOfClass:[NSString class]] )
  {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:_localeID] autorelease]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birthDate = [formatter dateFromString:[self.dataDict objectForKey:@"birthday"]];
  }
  if ( [[self.dataDict objectForKey:@"image"] isKindOfClass:[NSString class]])
  {
    _image = nil;
    _image = [(NSString *)[self.dataDict objectForKey:@"image"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  }
  if ( [[self.dataDict objectForKey:@"thumb"] isKindOfClass:[NSString class]])
  {
    _thumb = nil;
    _thumb = [(NSString *)[self.dataDict objectForKey:@"thumb"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  }
  if ( [[self.dataDict objectForKey:@"points"] isKindOfClass:[NSNumber class]] )
    self.points = [[self.dataDict objectForKey:@"points"] integerValue];
  if ( [[self.dataDict objectForKey:@"goal"] isKindOfClass:[NSNumber class]] )
  {
    self.goal = [[self.dataDict objectForKey:@"goal"] integerValue];
    if ( self.goal == 0 ) self.goal = 100;
  }
    if ( [[self.dataDict objectForKey:@"opportunities"] isKindOfClass:[NSNumber class]] )
        self.opportunities = [[self.dataDict objectForKey:@"opportunities"] integerValue];
    if ( [[self.dataDict objectForKey:@"notifications"] isKindOfClass:[NSNumber class]] )
        self.notifications = [[self.dataDict objectForKey:@"notifications"] integerValue];
    if ( [[self.dataDict objectForKey:@"shares"] isKindOfClass:[NSNumber class]] )
        self.shares = [[self.dataDict objectForKey:@"shares"] integerValue];
  if ( [[self.dataDict objectForKey:@"tags"] isKindOfClass:[NSNumber class]] )
    self.tags = [[self.dataDict objectForKey:@"tags"] integerValue];
    
    self.level=[dict objectForKey:@"level"];

  [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kUserUpdatedNotification object:self];
}

# pragma mark - Private methods

- (void) parseDataDict:(NSDictionary *)dict
{
    dataDict = nil;
    dataDict = dict;
    self.level=[dict objectForKey:@"level"];
    if ( [[self.dataDict objectForKey:@"user_id"] isKindOfClass:[NSNumber class]] )
        self.userID = [[dict objectForKey:@"user_id"] integerValue];
    if ( [[self.dataDict objectForKey:@"destination_name"] isKindOfClass:[NSString class]] )
        self.destinationName = [self.dataDict objectForKey:@"destination_name"];
    if ( [[self.dataDict objectForKey:@"username"] isKindOfClass:[NSString class]] )
        self.userName = [self.dataDict objectForKey:@"username"];
    if ( [[self.dataDict objectForKey:@"realname"] isKindOfClass:[NSString class]] )
        self.realName = [self.dataDict objectForKey:@"realname"];
    self.gender = [self.dataDict objectForKey:@"gender"];
    if ( [[self.dataDict objectForKey:@"language_id"] isKindOfClass:[NSNumber class]] )
        self.localeID = [self.dataDict objectForKey:@"language_id"];
    if ( [[self.dataDict objectForKey:@"birthday"] isKindOfClass:[NSString class]] )
    {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        //[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:_localeID] autorelease]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        self.birthDate = [formatter dateFromString:[self.dataDict objectForKey:@"birthday"]];
    }
    if ( [[self.dataDict objectForKey:@"photo"] isKindOfClass:[NSString class]])
    {
        _image = nil;
        _image = [(NSString *)[self.dataDict objectForKey:@"photo"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ( [[self.dataDict objectForKey:@"thumb"] isKindOfClass:[NSString class]])
    {
        _thumb = nil;
        _thumb = [(NSString *)[self.dataDict objectForKey:@"thumb"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ( [[self.dataDict objectForKey:@"points"] isKindOfClass:[NSNumber class]] )
        self.points = [[self.dataDict objectForKey:@"points"] integerValue];
    if ( [[self.dataDict objectForKey:@"goal"] isKindOfClass:[NSNumber class]] )
    {
        self.goal = [[self.dataDict objectForKey:@"goal"] integerValue];
        if ( self.goal == 0 ) self.goal = 100;
    }
    if ( [[self.dataDict objectForKey:@"opportunities"] isKindOfClass:[NSNumber class]] )
        self.opportunities = [[self.dataDict objectForKey:@"opportunities"] integerValue];
    if ( [[self.dataDict objectForKey:@"notifications"] isKindOfClass:[NSNumber class]] )
        self.notifications = [[self.dataDict objectForKey:@"notifications"] integerValue];
    if ( [[self.dataDict objectForKey:@"tags"] isKindOfClass:[NSNumber class]] )
        self.tags = [[self.dataDict objectForKey:@"tags"] integerValue];
    self.level = [self.dataDict objectForKey:@"level"];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kUserUpdatedNotification object:self];
}

- (void) saveSettings
{
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
  [settings setBool:deviceRegistered forKey:@"deviceRegistered"];
  [settings setBool:signedIn forKey:@"signedIn"];
  [settings setBool:guest forKey:@"guest"];
  [settings setInteger:_userID forKey:@"userID"];
  [settings setObject:_userName forKey:@"userName"]; 
  NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataDict];
  [settings setObject:myEncodedObject forKey:@"userInfo"];
  [settings synchronize];
}

- (NSString *) getPasswordValue {
    return @"protected";
}
- (void) setPasswordValue:(NSString *)password{
[self setPassword:password];
}
- (void) setPassword:(NSString *)password
{
    @synchronized(self) {
      _password = nil;
    if ( password )
      _password = [Utilities returnMD5Hash:password];
    
  }
}


#pragma mark - public methods

- (void) deviceRegister
{
  NSString * url = [NSString stringWithFormat:@"%@/user/register?destination_id=%d&device_type=ios&uuid=%@", [[Destination sharedInstance] destinationService], _destinationID, udid];
  if ( (signedIn) && (guest) && (_userID > 0) )
    url = [NSString stringWithFormat:@"%@&user_id=%d",url,_userID];
  if ( _realName )
    url = [NSString stringWithFormat:@"%@&real_name=%@",url,_realName];
  if ( _gender )
    url = [NSString stringWithFormat:@"%@&gender=%@",url,_gender];
  /*
   if ( _birthDate )
   url = [NSString stringWithFormat:@"%@&birthdate=%@",url,[self stringFromBirthdate]];
   */
  [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url 
                                                                                  forTarget:self 
                                                                                     action:@selector(deviceWasRegistered:)
                                                                                hudActivied:NO
                                                                                 withString:nil];
}


- (void) signUp
{
  if  ( ( _userName != nil) && ( _password != nil) ) {
    guest = NO;
    NSString * url = [NSString stringWithFormat:@"%@/user/register?destination_id=%d&device_type=ios&uuid=%@&username=%@&password=%@&realname=%@",
                      [[Destination sharedInstance] destinationService], self.destinationID, udid, _userName, _password, _realName];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(deviceWasRegistered:) hudActivied:YES withString:NSLocalizedString(@"signingUpKey", @"signingUp")];
  }
}


- (void) signInAsGuest
{
  guest = YES;
  self.userName = nil;
  NSString * url = [NSString stringWithFormat:@"%@/user/login?destination_id=%d&device_type=ios&uuid=%@",
                    [[Destination sharedInstance] destinationService], _destinationID, udid];
  [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url
                                                                                  forTarget:self
                                                                                     action:@selector(getUserInfoForLoginResponseData:)
                                                                                hudActivied:YES
                                                                                 withString:nil];
}


- (void) signIn
{
  if ( ( _userName ) && ( _password ) ) {
    guest = NO;
    NSString * url = [NSString stringWithFormat:@"%@/user/login?destination_id=%d&device_type=ios&uuid=%@&username=%@&password=%@",
                      [[Destination sharedInstance] destinationService], _destinationID, udid, _userName, _password];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url
                                                                                    forTarget:self 
                                                                                       action:@selector(getUserInfoForLoginResponseData:) 
                                                                                  hudActivied:YES 
                                                                                   withString:nil];
  }
}
- (void) signInSilent
{
    if ( ( _userName ) && ( _password ) ) {
        guest = NO;
        NSString * url = [NSString stringWithFormat:@"%@/user/login?destination_id=%d&device_type=ios&uuid=%@&username=%@&password=%@",
                          [[Destination sharedInstance] destinationService], _destinationID, udid, _userName, _password];
        [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url
                                                                                        forTarget:self
                                                                                           action:@selector(getUserInfoForLoginResponseDataSilent:)
                                                                                      hudActivied:NO
                                                                                       withString:nil];
    }
}

- (void) signInAndUp
{
    if ( ( _userName ) && ( _password ) ) {
        guest = NO;
        NSString * url = [NSString stringWithFormat:@"%@/user/login?destination_id=%d&device_type=ios&uuid=%@&username=%@&password=%@",
                          [[Destination sharedInstance] destinationService], _destinationID, udid, _userName, _password];
        [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url
                                                                                        forTarget:self 
                                                                                           action:@selector(getUserInfoForLoginSignupResponseData:) 
                                                                                      hudActivied:YES 
                                                                                       withString:nil];
    }
}



- (void) signOut
{
  if ( ( signedIn ) && (_userID > 0) ) {
    NSString * url = [NSString stringWithFormat:@"%@/user/logout?destination_id=%d&uuid=%@&id=%d",
                      [[Destination sharedInstance] destinationService], _destinationID, udid, _userID];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(userDidSignOut:) hudActivied:NO withString:nil];
    signedIn = NO;
    self.userID = 0;
    userStatus = UserModelStatusSignedOut;
    [self saveSettings];
    self.dataDict = nil;
  }
}


- (void) refresh
{
  if ( ( signedIn ) && (_userID > 0) ) {
    NSString * url = [NSString stringWithFormat:@"%@/user/get?destination_id=%d&uuid=%@&id=%d",
                    [[Destination sharedInstance] destinationService], _destinationID, udid, _userID];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(setResponseUserData:) hudActivied:NO withString:nil];
    [self locate];
  }
}


- (void) setUserStatus:(UserModelStatus)status
{
  if ( ( signedIn ) && (_userID > 0) ) {
    NSString * ws = [NSString stringWithFormat:@"%@/user/setStatus?destination_id=%d&user_id=%d&uuid=%@&status=%d",
                     [[Destination sharedInstance] destinationService], _destinationID, _userID, udid, status];
    //[[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:ws forTarget:self action:@selector(checkResponse:) hudActivied:NO withString:nil];
    
    NSURL * url = [NSURL URLWithString:[[NSString stringWithString:ws] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * res = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
#ifdef __DEBUG__
    NSLog(@"%@: setStatus response: %@ for url %@", [self description], res, ws);
#endif
  }
  userStatus = status;
}


- (void) postImage:(UIImage *)image
{
  if (!postingData && (image) )
  {
    postingData = YES;
    
    _sendingImage = nil;
    _sendingImage = image;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString * url = [[NSString stringWithFormat:@"%@/user/set",[[Destination sharedInstance] destinationService]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@ Create Deal at %@",[self description], url);
    IAMultipartRequestGenerator *request = [[IAMultipartRequestGenerator alloc] initWithUrl:url andRequestMethod:@"POST"];
    [request setDelegate:self];
    
    CGSize newSize = CGSizeMake(166.0, 166.0);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate]; 
    NSString *fn = [NSString stringWithFormat:@"%d.%@", self.userID, [[NSNumber numberWithDouble:timestamp] stringValue] ];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(newImage)];
   
    [request setString:[NSString stringWithFormat:@"%d", _destinationID] forField:@"destination_id"];
    [request setString:[NSString stringWithFormat:@"%d",self.userID] forField:@"user_id"];
    [request setString:self.udid forField:@"uuid"];
    [request setData:imageData forField:@"image" type:1 fileName:fn];                    
    [request performSelectorOnMainThread:@selector(startRequest) withObject:nil waitUntilDone:NO];
  }
}

- (void) sendPassword:(NSString *)email;
{
        //  if ( (signedIn) && (_userID == 0 ) ) {
    NSString * url = [NSString stringWithFormat:@"%@/user/sendPassword?uuid=%@&id=%d&email=%@&longitude=%f&latitude=%f", [[Destination sharedInstance] destinationService], udid, _userID ,email, _myLocation.coordinate.longitude, _myLocation.coordinate.latitude];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(checkResponse:) hudActivied:NO withString:nil];
    
        //  }
}


- (void) setLocation
{
//  if ( (signedIn) && (_userID == 0 ) ) {
    NSString * url = [NSString stringWithFormat:@"%@/user/setLocation?uuid=%@&id=%d&longitude=%f&latitude=%f", [[Destination sharedInstance] destinationService], udid, _userID ,_myLocation.coordinate.longitude, _myLocation.coordinate.latitude];
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url forTarget:self action:@selector(checkResponse:) hudActivied:NO withString:nil];
      
//  }
}



- (void) setParam:(id)property
{
  NSString * url = [NSString stringWithFormat:@"%@/user/set?destination_id=%d&uuid=%@&user_id=%d", [[Destination sharedInstance] destinationService], _destinationID, udid, _userID];
  NSString * fullURLString = nil;
  if ( property == _realName )
    fullURLString = [NSString stringWithFormat:@"%@&real_name=""%@""",url,_realName];
  if ( property == _password )
    fullURLString = [NSString stringWithFormat:@"%@&password=%@",url,_password];
  if ( property == _gender )
    fullURLString = [NSString stringWithFormat:@"%@&gender=%@",url,_gender];
  if ( property == _localeID)
    fullURLString = [NSString stringWithFormat:@"%@&language_id=%@",url,_localeID];
  if ( property == _birthDate )
    fullURLString = [NSString stringWithFormat:@"%@&birthday=%@",url,[self stringFromBirthdate]];
  
  if ( fullURLString )
    [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:fullURLString
                                                                                    forTarget:self 
                                                                                       action:@selector(deviceWasRegistered:)
                                                                                  hudActivied:NO
                                                                                   withString:nil];
}
- (void) save {
    [self setFullUser];
}
- (void) setFullUser
{
    NSString * url = [NSString stringWithFormat:@"%@/user/set?destination_id=%d&uuid=%@&user_id=%d&real_name=""%@""&gender=%@&language_id=%@&birthday=%@&password=%@", [[Destination sharedInstance] destinationService], _destinationID, udid, _userID, [_realName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], _gender, _localeID, [self stringFromBirthdate],_password ];
          [[TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager] getDataFromURLString:url
                                                                                        forTarget:self
                                                                                           action:@selector(userWasUpdated:)
                                                                                      hudActivied:NO
                                                                                       withString:nil];
}




- (void) userDidSignOut:(NSData *)data
{
  //TODO:
}



- (NSString *) stringFromBirthdate
{
#warning Current Locale not used for Birthdate
  //NSLocale *myLocale = [[NSLocale alloc] initWithLocaleIdentifier:_localeID];
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  //[dateFormatter setLocale:myLocale];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  //[myLocale release];
  return [dateFormatter stringFromDate:self.birthDate];
}


#pragma  mark - CLLocationDelegate methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
  if ( status == kCLAuthorizationStatusAuthorized ) {
    if(!self.locationManager) {
      self.locationManager = [[CLLocationManager alloc] init];
      self.locationManager.delegate  = self;
    }
    //locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //bestEffortAtLocation = nil;
    [self.locationManager startUpdatingLocation];
    locating = YES;
    [self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:30.0];
  }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
  
  NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
  if (locationAge > 5.0) {
    return; 
  }
  if (newLocation.horizontalAccuracy < 0)
  {
    return;
  }
  if ( _myLocation == nil || oldLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
    _myLocation = nil;
    _myLocation = newLocation;
#ifdef __DEBUG__
    NSLog(@"%@: location: %f, %f", [self description], _myLocation.coordinate.latitude, _myLocation.coordinate.longitude);
#endif
  // test the measurement to see if it meets the desired accuracy
  // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
  // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
  // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
  //
    if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
      [self.locationManager stopUpdatingLocation];
      [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation) object:nil];
    }
  }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"%@: LocationManager did fail: %@", [self description], [error description]);
}

- (void)stopUpdatingLocation
{
  if(self.locationManager){
    [self.locationManager stopUpdatingLocation];
    if ( (self.signedIn) ) 
      [self setLocation];
    self.locationManager = nil;
  }
  locating = NO;
}

-(void) locate {
  if(!locating){
    if ([CLLocationManager locationServicesEnabled] == YES) {
      if (! self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
      }
      self.locationManager.delegate = self;
      // ((locationManager.distanceFilter = kCLDistanceFilterNone;
      // locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      [self.locationManager startUpdatingLocation];
      [self performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:10.0];
    }
   }
}


# pragma mark - UIAlertViewDelegate methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if ( (buttonIndex == 1) && (_sendingImage != nil) )
    [self postImage:_sendingImage];
}


#pragma mark -

- (void) showAlert:(NSString *)string
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"errorTitleKey",@"error")
                                                    message:string
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancelKey",@"Cancel")
                                          otherButtonTitles:nil, nil]; 
    [alert show];

    
}
- (void) userWasUpdated:(NSData *)data
{
    NSError * error = nil;
    NSString * responseString = nil;
    SBJsonParser * jsonParser = nil;
    deviceRegistered = NO;
    if ( data ) {
        jsonParser = [[SBJsonParser alloc] init];
        responseString = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
        id jsonObject = [jsonParser objectWithString:responseString ];
        if ( ( error == nil ) && ([TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]) ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            jsonParser = nil;
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = jsonObject;
                if ([(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0)
                    {
                    deviceRegistered = YES;
                        //if the device is registered, and the user is not SIGN IN
                    if ( !signedIn && guest )
                        {
                        [self signIn];
                        }
                    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kUserUpdatedNotification object:self];
                    }
                else
                    {
                    NSLog(@"%@: error code %d when registering the device",
                          [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue]);
                    if ( [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 1003)
                        [self showAlert:NSLocalizedString(@"usernameExistsKey",  @"User name already exists")];
                    else
                        [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
                    
                    }
            } else {
                NSLog(@"%@: error when parsing registering the device response, recibed object is a king of %@",
                      [self description], [jsonObject class] );
                
                [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
            }
        } else {
            NSLog(@"%@: Error at parsing json. Maybe an encoding problem: %@",[self description], [error description] );
            [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
        }
    } else {
#ifdef __DEBUG__
        NSLog(@"%@: Error response data with void data", [self description] );
#endif
        [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
    }
}

- (void) deviceWasRegistered:(NSData *)data
{
  NSError * error = nil;
  NSString * responseString = nil;
  SBJsonParser * jsonParser = nil;
  deviceRegistered = NO;
  if ( data ) {
    jsonParser = [[SBJsonParser alloc] init];
    responseString = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    id jsonObject = [jsonParser objectWithString:responseString ];
    if ( ( error == nil ) && ([TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]) ) {
#ifdef __DEBUG__
      NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
       jsonParser = nil;
      if ([jsonObject isKindOfClass:[NSDictionary class]]) { 
        NSDictionary * dict = jsonObject;
        if ([(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0)
        {
          deviceRegistered = YES;
            //if the device is registered, and the user is not SIGN IN
          if ( !signedIn && guest )
          {
            [self signIn];
          }
          [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kUserRegisteredNotification object:self];
        }
        else
        {
          NSLog(@"%@: error code %d when registering the device",
                [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue]);
          if ( [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 1003)
            [self showAlert:NSLocalizedString(@"usernameExists",  @"User name already exists")];
          else
            [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
  
        }
      } else {
        NSLog(@"%@: error when parsing registering the device response, recibed object is a king of %@",
              [self description], [jsonObject class] );

        [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
      }
    } else {
      NSLog(@"%@: Error at parsing json. Maybe an encoding problem: %@",[self description], [error description] );
      [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
    }
  } else {
#ifdef __DEBUG__
    NSLog(@"%@: Error response data with void data", [self description] );
#endif
    [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
  }
}


- (void) getUserInfoForLoginResponseData:(NSData *)data
{
    NSError * error = nil;
    NSString * responseString = nil;
    SBJsonParser * jsonParser = nil;
    signedIn = NO;
    if ( data ) {
        jsonParser = [[SBJsonParser alloc] init];
        responseString = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
        id jsonObject = [jsonParser objectWithString:responseString 
                         ];
        if ( error == nil ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            jsonParser = nil;
            if ([jsonObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * dict = jsonObject;
                if ([(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0 )
                    //&& ( [[dict objectForKey:@"id"] isKindOfClass:[NSNumber class]] ) )
                {
                    if ([[dict objectForKey:@"id"] integerValue] > 0)
                    {
                        signedIn = YES;             
                        userStatus = UserModelStatusOnline;
                        [self setDataDict:dict];
                        [self saveSettings];
                    }
                    else [self showAlert:@"Sign in failed"];
                }
                else
                {
                    NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
                    NSString * desc = (NSString *)[dict objectForKey:@"description"];
                    NSLog(@"%@: errorCode: %d: %@",[self description],errorCode, desc);
                    [ self showAlert:NSLocalizedString(@"WrongUsernameTitleKey",@"")];
                }
            }
            else
            {
                NSLog(@"%@: Error when parsing registering the device response, received object is a kind of %@",
                      [self description], [jsonObject class] );
                [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
            }
        }
        else
        {
            NSLog(@"%@: Error at parsing json. Maybe an encoding problem: %@",[self description], [error description] );
            [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
        }
    }
    else
    {
        NSLog(@"%@: Error response data with void data", [self description] );
        [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
    }
}

- (void) getUserInfoForLoginResponseDataSilent:(NSData *)data
{
    NSError * error = nil;
    NSString * responseString = nil;
    SBJsonParser * jsonParser = nil;
    signedIn = NO;
    if ( data ) {
        jsonParser = [[SBJsonParser alloc] init];
        responseString = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
        id jsonObject = [jsonParser objectWithString:responseString
                         ];
        if ( error == nil ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            jsonParser = nil;
            if ([jsonObject isKindOfClass:[NSDictionary class]])
                {
                NSDictionary * dict = jsonObject;
                if ([(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0 )
                        //&& ( [[dict objectForKey:@"id"] isKindOfClass:[NSNumber class]] ) )
                    {
                    if ([[dict objectForKey:@"id"] integerValue] > 0)
                        {
                        signedIn = YES;
                        userStatus = UserModelStatusOnline;
                        [self setDataDict:dict];
                        [self saveSettings];
                        }
                    else [self showAlert:@"Sign in failed"];
                    }
                else
                    {
                    NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
                    NSString * desc = (NSString *)[dict objectForKey:@"description"];
                    NSLog(@"%@: errorCode: %d: %@",[self description],errorCode, desc);
                    [self signUp];
                        //  [ self showAlert:NSLocalizedString(@"WrongUsernameTitleKey",@"")];
                    }
                }
            else
                {
                NSLog(@"%@: Error when parsing registering the device response, received object is a kind of %@",
                      [self description], [jsonObject class] );
                    // [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
                }
        }
        else
            {
            NSLog(@"%@: Error at parsing json. Maybe an encoding problem: %@",[self description], [error description] );
                // [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
            }
    }
    else
        {
        NSLog(@"%@: Error response data with void data", [self description] );
            //    [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
        }
}


- (void) getUserInfoForLoginSignupResponseData:(NSData *)data
{
    NSError * error = nil;
    NSString * responseString = nil;
    SBJsonParser * jsonParser = nil;
    signedIn = NO;
    if ( data ) {
        jsonParser = [[SBJsonParser alloc] init];
        responseString = [[NSString alloc] initWithData:data
                                               encoding:NSUTF8StringEncoding];
        id jsonObject = [jsonParser objectWithString:responseString 
                         ];
        if ( error == nil ) {
#ifdef __DEBUG__
            NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
            jsonParser = nil;
            if ([jsonObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary * dict = jsonObject;
                if ([(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0 )
                    //&& ( [[dict objectForKey:@"id"] isKindOfClass:[NSNumber class]] ) )
                {
                    if ([[dict objectForKey:@"id"] integerValue] > 0)
                    {
                        signedIn = YES;             
                        userStatus = UserModelStatusOnline;
                        [self setDataDict:dict];
                        [self saveSettings];
                    }
                    else [self showAlert:@"Sing in failed"];
                }
                else
                {
                    NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
                    //user does not exist
                    if (errorCode==1001)
                    {
                        [self signUp]; 
                    }
                    else {
                    NSString * desc = (NSString *)[dict objectForKey:@"description"];
                    NSLog(@"%@: errorCode: %d: %@",[self description],errorCode, desc);
                    [ self showAlert:@"Sing in failed"];
                    }
                }
            }
            else
            {
                NSLog(@"%@: Error when parsing registering the divice response, recibed object is a king of %@",
                      [self description], [jsonObject class] );
                [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
            }
        }
        else
        {
            NSLog(@"%@: Error at parsing json. Maybe an encoding problem: %@",[self description], [error description] );
            [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
        }
    }
    else
    {
        NSLog(@"%@: Error response data with void data", [self description] );
        [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
    }
}




- (void) setResponseUserData:(NSData *)data
{
  NSError * error = nil;
  NSString * responseString = nil;
  SBJsonParser * jsonParser = nil;
  NSDictionary * dict = nil;
  if ( data ) {
    jsonParser = [[SBJsonParser alloc] init];
    responseString = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    id jsonObject = [jsonParser objectWithString:responseString 
                                           ];
    if ( error == nil ) {
#ifdef __DEBUG__
      NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
       jsonParser = nil;
      if ( [jsonObject isKindOfClass:[NSDictionary class]] ) { 
        dict = jsonObject;
        if ( [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] == 0 ) {
          [self setDataDict:dict];
          [self saveSettings];
        }
        else
        {
          //TODO: Alert the user
          NSInteger errorCode = [[dict objectForKey:@"errorCode"] integerValue];
          NSString * desc = (NSString *)[dict objectForKey:@"description"];
          NSLog(@"%@: errorCode: %d: %@",[self description],errorCode, desc);
        }
      } else {
        //TODO:
      }
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


- (void) checkResponse:(NSData *)data
{
  NSError * error = nil;
  NSString * responseString = nil;
  SBJsonParser * jsonParser = nil;
  if ( data )
  {
    jsonParser = [[SBJsonParser alloc] init];
    responseString = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];
    id jsonObject = [jsonParser objectWithString:responseString 
                                           ];
    if ( ( error == nil ) && ([TaggedNSURLConnectionsManager sharedTaggedNSURLConnectionsManager]) )
    {
#ifdef __DEBUG__
      NSLog(@"%@: Received data: %@", [self description],  responseString);
#endif
       jsonParser = nil;
      if ([jsonObject isKindOfClass:[NSDictionary class]])
      { 
        NSDictionary * dict = jsonObject;
        if ([(NSNumber *)[dict objectForKey:@"errorCode"] integerValue] != 0)
        {
          NSLog(@"%@: reponse with error code %d",
                [self description], [(NSNumber *)[dict objectForKey:@"errorCode"] integerValue]);
          [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
        }
      } else {
        NSLog(@"%@: error when parsing registering the divice response, recibed object is a king of %@",
              [self description], [jsonObject class] );
        
        [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
      }
    } else {
      NSLog(@"%@: Error at parsing json. Maybe an encoding problem: %@",[self description], [error description] );
      [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
    }
  } else {
#ifdef __DEBUG__
    NSLog(@"%@: Error response data with void data", [self description] );
#endif
    [self showAlert:NSLocalizedString(@"connectionErrorMsgKey",@"")];
  }
}

#pragma mark - IAMultipartRequestGenerator delegate methods

-(void)requestDidFinishWithResponse:(NSData *)responseData {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  NSDictionary *dict = nil;
  NSString *responseString = nil;
  responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
  NSLog(@"UserImage response: %@", responseString);
  if ( [[responseString JSONValue] isKindOfClass:[NSDictionary class]] )
  {
    dict = [responseString JSONValue];
  }
  int error = -1;
  if ( [[dict objectForKey:@"errorCode"] isKindOfClass:[NSNumber class]])
    error = [[dict objectForKey:@"errorCode"] intValue];
  UIAlertView *alert;
  switch(error)
    {
    case 0:
      _sendingImage;
      _sendingImage = nil;
       alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"imageUpdatedKey",@"Connection Error")
                                           message:nil
                                          delegate:self cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil];
      break;
    default:
      alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"updateFailedKey",@"Connection Error")
                                         message:nil
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"cancelKey",@"Cancel")
                               otherButtonTitles:NSLocalizedString(@"sendAgainKey",@"Send Again"), nil];
      break;
  }
  [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];    
  postingData = NO;
}


-(void)requestDidFailWithError:(NSError *)error
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  NSLog(@"error: %@", [error description]);
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"errorKey",@"Connection Error")
                                                   message:NSLocalizedString(@"connectionErrorMsgKey",@"Connection Error")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"cancelKey",@"Connection Error")
                                         otherButtonTitles:NSLocalizedString(@"retryKey",@"Connection Error"), nil]; [alert show];
  postingData = NO;
}

  
@end