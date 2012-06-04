//
//  opendestinationAppDelegate.m
//  opendestination
//
//  Created by David Hoyos on 04/07/11.
//  Copyright 2011 None. All rights reserved.
//

#import "opendestinationAppDelegate.h"
#import "RootViewController.h"
#import "UserModel.h"
#import "Destination.h"


// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
static NSString* kAppId = @"255658224527885";

@implementation opendestinationAppDelegate
@synthesize window=_window;
@synthesize facebook;

@synthesize apiData;

@synthesize userPermissions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Initialize Facebook. The delegate must be the LoginViewController and not the RootViewController
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:(RootViewController *)[self.window rootViewController]];
    
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    // Initialize API data (for views, etc.)
    apiData = [[DataSet alloc] init];
    
    // Initialize user permissions
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    application.applicationIconBadgeNumber = 0; //icono a 0
    if ( (NSInteger)[defaults valueForKey:@"register"] != 1 )
    {         
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];    
    }
    [self.window setRootViewController:[[RootViewController alloc] init]];
    if ( [[launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] isKindOfClass:[NSDictionary class]] ) {
        [(RootViewController *)[self.window rootViewController] parseNotificationData:[launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    }
   // [(RootViewController *)self.window.rootViewController showSignIn];
    [self.window makeKeyAndVisible];
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
  //      [alertView release];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
//[alertView release];
        }
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[UserModel sharedUser] setUserStatus:UserModelStatusBackground];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    UserModel * user =[UserModel sharedUser];
    [user setDestinationID:[(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"destination"] integerValue]];
    [(RootViewController *)[self.window rootViewController] reload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    UserModel * u = [UserModel sharedUser];
    [u locate];
    [u setUserStatus:UserModelStatusOnline];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[self facebook] extendAccessTokenIfNeeded];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[NSUserDefaults standardUserDefaults] synchronize];
}




#pragma mark - Push Notifications

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    UserModel * user = [UserModel sharedUser];
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
#ifdef __DEBUG__
    NSLog(@"%@: DEVICE TOKEN: %@ ",[self description], devToken);
#endif
    [user setUdid:devToken];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults setValue:[NSNumber numberWithInt:1] forKey:@"register"];
    [defaults synchronize];   
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"fail register%@",str);  
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
    [defaults setValue:[NSNumber numberWithInt:0] forKey:@"register"];
    [defaults synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{    
    application.applicationIconBadgeNumber = 0;
#ifdef __DEBUG__
    NSLog(@"didReceiveRemoteNotification ----- %@",[userInfo description]);
#endif
    [(RootViewController *)[self.window rootViewController] parseNotificationData:userInfo];
}

@end
