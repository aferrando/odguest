//
//  UserModel.h
//  opendestination
//
//  Created by David Hoyos on 01/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "IAMultipartRequestGenerator.h"

#define kUserUpdatedNotification @"kUserUpdatedNotification"
#define kUserRegisteredNotification @"kUserRegisteredNotification"

typedef enum {
  UserModelStatusSignedOut = 0,
  UserModelStatusOnline = 1,
  UserModelStatusBackground = 2
} UserModelStatus;

#define kUserModelGenderMale @"male";
#define kUserModelGenderFamale @"female";


@interface UserModel : NSObject
<NSCoding, UIAlertViewDelegate, CLLocationManagerDelegate, IAMultipartRequestGeneratorDelegate>
{
  CLLocationManager * _locationManager;
  CLLocation * _myLocation;
  BOOL deviceRegistered;
  BOOL locating;
  BOOL signedIn;
  BOOL guest;
  UserModelStatus userStatus;
  NSDictionary * dataDict;
  NSInteger _destinationID;
  NSInteger _userID;
  NSString * udid;
  NSString * destinationName;
  NSString * _userName;
  NSString * _password;
  NSString * _image;
  NSString * _thumb;
  NSString * _realName;
  NSString * _localeID;
  NSString * _gender;
  NSDate * _birthDate;
  NSInteger points;
  NSInteger goal;
    NSInteger opportunities;
    NSInteger notifications;
    NSInteger shares;
  NSInteger tags;
    NSDictionary * _level;

@private
  UIImage * _sendingImage;
  BOOL postingData;
}
@property  CLLocationManager * locationManager;
@property ( assign ) NSInteger destinationID;
@property ( readonly, assign ) BOOL deviceRegistered;
@property ( assign ) BOOL signedIn;
@property ( readonly, getter=isGuest) BOOL guest;
@property ( readonly, assign ) UserModelStatus userStatus;
@property ( readonly) CLLocation * myLocation;
@property ( readonly ) NSDictionary * dataDict;
@property ( nonatomic ) NSDictionary * level;
@property ( assign ) NSInteger userID;
@property  NSString * udid;
@property  NSString * destinationName;
@property  NSString * userName;
@property ( nonatomic ) NSString * password;
@property  NSString * image;
@property ( readonly ) NSString * thumb;
@property  NSString * realName;
@property  NSString * localeID;
@property  NSString * gender;
@property  NSDate * birthDate;
@property ( assign ) NSInteger points;
@property ( assign ) NSInteger goal;
@property ( assign ) NSInteger opportunities;
@property ( assign ) NSInteger notifications;
@property ( assign ) NSInteger shares;
@property ( assign ) NSInteger tags;

+ (id) sharedUser;
- (void) deviceRegister;
- (void) signInAsGuest;
- (void) signIn;
- (void) signInAndUp;
- (void) signOut;
- (void) signUp;
- (void) setUserStatus:(UserModelStatus)status;
- (void) refresh;
- (void) setLocation;
- (void) postImage:(UIImage *)image;
- (void) setParam:(id)property;
- (void) checkResponse:(NSData *)data;
- (void) deviceWasRegistered:(NSData *)data;
- (void) userDidSignOut:(NSData *)data;
- (void) locate;
- (NSString *) stringFromBirthdate;
- (void) parseDataDict:(NSDictionary *)dict;
- (void) setFullUser;
- (NSString *) genderValue;
- (NSString *) localeIDValue;
- (void) save;
@end
