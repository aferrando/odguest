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
  NSInteger tags;
@private
  UIImage * _sendingImage;
  BOOL postingData;
}
@property ( retain ) CLLocationManager * locationManager;
@property ( assign ) NSInteger destinationID;
@property ( readonly, assign ) BOOL deviceRegistered;
@property ( assign ) BOOL signedIn;
@property ( readonly, getter=isGuest) BOOL guest;
@property ( readonly, assign ) UserModelStatus userStatus;
@property ( readonly, retain) CLLocation * myLocation;
@property ( readonly, retain ) NSDictionary * dataDict;
@property ( assign ) NSInteger userID;
@property ( retain ) NSString * udid;
@property ( retain ) NSString * destinationName;
@property ( retain ) NSString * userName;
@property ( nonatomic, retain ) NSString * password;
@property ( readonly, retain ) NSString * image;
@property ( readonly, retain ) NSString * thumb;
@property ( retain ) NSString * realName;
@property ( retain ) NSString * localeID;
@property ( retain ) NSString * gender;
@property ( retain ) NSDate * birthDate;
@property ( assign ) NSInteger points;
@property ( assign ) NSInteger goal;
@property ( assign ) NSInteger opportunities;
@property ( assign ) NSInteger tags;

+ (id) sharedUser;
- (void) deviceRegister;
- (void) signInAsGuest;
- (void) signIn;
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

@end
