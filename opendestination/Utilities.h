//
//  Utilities.h
//
//http://www.saobart.com/md5-has-in-objective-c/

//#import <Cocoa/Cocoa.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utilities : NSObject {
	
}

//generates md5 hash from a string
+ (NSString *) returnMD5Hash:(NSString*)concat;
+ (NSString *) base64StringFromData: (NSData *)data;
+ (BOOL) validateMail:(NSString *)email;

@end
