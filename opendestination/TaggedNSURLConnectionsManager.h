//
//  TaggedNSURLConnectionManager.h
//  Created by David Hoyos on 12/11/10.
//  Under GNU/GPLv3 license
//

#define kMAX_CONECTIONS 3
#define kHTTPREQUEST_ENCODING @"gzip"


#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


extern const NSString * kDHConnectionsManagerDownloadsStartNotification;
extern const NSString * kDHConnectionsManagerDownloadsFinishNotification;
extern const NSString * kDHConnectionsManagerDownloadFailNotification;


@interface TaggedNSURLConnection : NSURLConnection
{
  NSString *_tag;
}
@property (nonatomic, retain) NSString *tag;
-(id) initWithRequest:(NSURLRequest *)request
             delegate: (id) delegate
     startImmediately: (BOOL) startImmediately
                  tag: (NSString *) aTag;
@end



@interface TaggedNSURLConnectionsManager : NSObject
<NSCoding, MBProgressHUDDelegate, UIAlertViewDelegate>
{
}
// Returns a singelton instance of this class
+ (TaggedNSURLConnectionsManager *) sharedTaggedNSURLConnectionsManager;

// Starts async URLConnection for the string and returns the data via notification;
- (void) getDataFromURLString:(NSString *)urlString
                    forTarget:(id)target
                       action:(SEL)selector
              hudActivied:(BOOL)flag
                 withString:(NSString *)text;


- (void) postDataFromURLString:(NSString *)urlString
                     forTarger:(id)target
                        action:(SEL)selector
                   hudActivied:(BOOL)flag
                    withString:(NSString *)text;


@end
