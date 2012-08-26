    //
    //  opendestinationAppDelegate.m
    //  opendestination
    //
    //  Created by David Hoyos on 04/07/11.
    //  Copyright 2011 None. All rights reserved.
    //

#import "opendestinationAppDelegate.h"
#import "UserModel.h"
#import "Destination.h"
#import "CustomContentViewController.h"
#import "HeaderViewController.h"
#import "GlobalConstants.h"
#import "CategoryModel.h"
#import "TODOTableViewController.h"
#import "SHKConfiguration.h"
#import "ShareKitDemoConfigurator.h"
#import "SHKFacebook.h"
#import "SDImageCache.h"
#import "MixpanelAPI.h"
    //#import <Parse/Parse.h>
#import "YRDropdownView.h"
#import "OpportunityModel.h"
#import "OportunityDetailViewController.h"

    // Your Facebook APP Id must be set before running this example
    // See http://www.facebook.com/developers/createapp.php
    // Also, your application must bind to the fb[app_id]:// URL
    // scheme (substitue [app_id] for your real Facebook app id).
static NSString* kAppId = @"255658224527885";

@implementation opendestinationAppDelegate
@synthesize window=_window;
@synthesize rootController=_rootController;
@synthesize category=_category;
@synthesize custom=_custom;
@synthesize categories=_categories;
@synthesize facebook;

@synthesize apiData;

@synthesize userPermissions;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        //         [Parse setApplicationId:@"QafOMBb1w0ZwCJMSxS3KgmbtGVlQtCovngc8mWjE" clientKey:@"DjaqlxQPftnjum8ED3oLTaTQEdzbBfXSnJOniwy9"];
        //
        // If you are using Facebook, uncomment and fill in with your Facebook App Id:
        // [PFFacebookUtils initializeWithApplicationId:@"your_facebook_app_id"];
        // ****************************************************************************
    
        //          [PFUser enableAutomaticUser];
        // PFACL *defaultACL = [PFACL ACL];
        // Optionally enable public read access by default.
        //[defaultACL setPublicReadAccess:YES];
        // [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    
        // Initialize Facebook. The delegate must be the LoginViewController and not the RootViewController
    /*   facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:(RootViewController *)[self.window rootViewController]];
     
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
     }*/
        //    [self.window setRootViewController:[[RootViewController alloc] init]];
    /*   if ( [[launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] isKindOfClass:[NSDictionary class]] ) {
     [(RootViewController *)[self.window rootViewController] parseNotificationData:[launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
     }
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
     [(RootViewController *)self.window.rootViewController showSignIn];
     */
    
    DefaultSHKConfigurator *configurator = [[ShareKitDemoConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    UserModel * user =[UserModel sharedUser];
    [user deviceRegister];
    user.userName = nil;
    user.password = nil;
        //  [user addObserver];
    [user signInAsGuest];
    
    [user setDestinationID:[(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"destination"] integerValue]];
    Destination *destination=[Destination sharedInstance];
    [destination setDestinationID:user.destinationID];
    switch (user.destinationID) {
        case 26:
            mixpanel = [MixpanelAPI sharedAPIWithToken:MIXPANEL_THYON];
            break;
            
        case 36:
            mixpanel = [MixpanelAPI sharedAPIWithToken:MIXPANEL_WHISTLER];
            break;
            
        case 43:
            mixpanel = [MixpanelAPI sharedAPIWithToken:MIXPANEL_VILANOVA];
            break;
            
        default:
            mixpanel = [MixpanelAPI sharedAPIWithToken:MIXPANEL_OTHERS];
            break;
    }
        // Override point for customization after application launch.
        //Initialize the MixpanelAPI object
    
    
        // Set the upload interval to 5 seconds for testing
        // If not set, it defaults to 30 seconds
    [mixpanel setUploadInterval:5];
    [mixpanel identifyUser:[NSString stringWithFormat:@"%d", user.userID]];
    [destination reload];
    [self customizeInterface];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    _custom = [[CustomContentViewController alloc] init];
    [_custom setCategory:[[CategoryModel alloc] initWithId:0]];
 /*   _categories = [[CategoriesTableViewController alloc] init];
    [_categories setCategory:[[CategoryModel alloc] initWithId:0]];
    
    _category = [[CategoryViewController alloc] init];*/
    /*  [custom reload];*/
    UINavigationController *navigationController1=[[UINavigationController alloc]
                                                   initWithRootViewController:_custom];
 /*       //                                               initWithRootViewController:_category];
    if (kCategoryNavigation == 0)
        navigationController1 = [[UINavigationController alloc]
                                 initWithRootViewController:_custom];
    else {
        navigationController1 = [[UINavigationController alloc]
                                 initWithRootViewController:_categories];
        
    }*/
    [navigationController1.navigationBar setTintColor:kMainColor];
    navigationController1.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:background]];
    
    UITabBarItem *tab1 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"exploreKey", @"explore") image:[UIImage imageNamed:@"73-radar.png"] tag:1];
    [navigationController1 setTabBarItem:tab1];
    
    
    TODOTableViewController *viewController2 = [[TODOTableViewController alloc] init];
    UITabBarItem *tab2 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"todoKey", @"profile")  
                                                       image:[UIImage imageNamed:@"259-list.png"] tag:2];
    UINavigationController *navigationController2 = [[UINavigationController alloc]
                                                     initWithRootViewController:viewController2];
    
    [navigationController2.navigationBar setTintColor:kMainColor];
    [navigationController2 setTabBarItem:tab2];
        //  [tab2 setEnabled:FALSE];
    HeaderViewController *viewController3 = [[HeaderViewController alloc] init];
    UITabBarItem *tab3 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"signInKey", @"profile") 
                                                       image:[UIImage imageNamed:@"register.png"] tag:3];
    [viewController3 setTabBarItem:tab3];
    UINavigationController *navigationController3 = [[UINavigationController alloc]
                                                     initWithRootViewController:viewController3];
    
    [navigationController3.navigationBar setTintColor:kMainColor];
    [navigationController3 setTabBarItem:tab3];
        //  [tab3 setEnabled:FALSE];
    
    UIViewController *viewController4 = [[UIViewController alloc] init];
    UITabBarItem *tab4 = [[UITabBarItem alloc] initWithTitle:@"Time" 
                                                       image:[UIImage imageNamed:@"clock-tab.png"] tag:4];
    [viewController4 setTabBarItem:tab4];    
    
    tabController.viewControllers = [NSArray arrayWithObjects:navigationController1, 
                                     navigationController2, 
                                     navigationController3,  nil];
    
    
    self.window.rootViewController = tabController;
    
    [self.window makeKeyAndVisible];
    
    	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}
- (void)customizeInterface
{
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab.png"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
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
    Destination *destination=[Destination sharedInstance];
    [mixpanel identifyUser:[NSString stringWithFormat:@"%d", user.userID]];
    
    [destination setDestinationID:user.destinationID];
        //  [destination reload];
    
    
    
        //      [_custom setCategory:[[CategoryModel alloc] initWithId:0]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    UserModel * u = [UserModel sharedUser];
    [u locate];
    [u setUserStatus:UserModelStatusOnline];
        //  [_custom setCategory:[[CategoryModel alloc] initWithId:0]];
        //  [_custom reload];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        //   [[self facebook] extendAccessTokenIfNeeded];
}


- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
        //               [PFPush storeDeviceToken:newDeviceToken];
        // [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	if ([error code] != 3010) // 3010 is for the iPhone Simulator
        {
            // show some alert or otherwise handle the failure to register.
        }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
        //            [PFPush handlePush:userInfo];
    
    application.applicationIconBadgeNumber = 0;
#ifdef __DEBUG__
    NSLog(@"didReceiveRemoteNotification ----- %@",[userInfo description]);
#endif
    [self parseNotificationData:userInfo];

}
- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}
- (void) parseNotificationData:(NSDictionary*)userInfo {
    NSNumber * opp_id = nil;
    if ( (opp_id = [[userInfo valueForKey:@"aps"] valueForKey:@"opportunity_id"]) && ( [[UserModel sharedUser] signedIn]) ) {
        if ( self.window.rootViewController.modalViewController != nil ) {
            [YRDropdownView showDropdownInView:self.window.rootViewController.modalViewController.view
                                         title:@"Important" 
                                        detail:@"New notifications arrived! Check My Notifications!"
                                         image:nil
                                      animated:YES
                                     hideAfter:3.0 type:1];
            
        } else {
            OportunityDetailViewController * vc = [[OportunityDetailViewController alloc] init];
    OpportunityModel * opp = [[OpportunityModel alloc] initWithId:3834];//[opp_id integerValue]];
            [vc setOpportunity:opp];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
           [self.window.rootViewController presentModalViewController:vc animated:YES];
        }
    }
}


/*
 
 #pragma mark - Push Notifications
 
 - (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
 
 UserModel * user = [UserModel sharedUser];
 /*  NSString *devToken = [[[[deviceToken description]
 stringByReplacingOccurrencesOfString:@"<"withString:@""]
 stringByReplacingOccurrencesOfString:@">" withString:@""]
 stringByReplacingOccurrencesOfString: @" " withString: @""];
 #ifdef __DEBUG__
 NSLog(@"%@: DEVICE TOKEN: %@ ",[self description], devToken);
 #endif*/

    //EASY APNS
/*    
 #if !TARGET_IPHONE_SIMULATOR
 
 // Get Bundle Info for Remote Registration (handy if you have more than one app)
 NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
 NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
 
 // Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
 NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
 
 // Set the defaults to disabled unless we find otherwise...
 NSString *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
 NSString *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
 NSString *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";	
 
 // Get the users Device Model, Display Name, Unique ID, Token & Version Number
 UIDevice *dev = [UIDevice currentDevice];
 NSString *deviceUuid;
 if ([dev respondsToSelector:@selector(uniqueIdentifier)])
 deviceUuid = dev.uniqueIdentifier;
 else {
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 id uuid = [defaults objectForKey:@"deviceUuid"];
 if (uuid)
 deviceUuid = (NSString *)uuid;
 else {
 CFStringRef cfUuid = CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
 deviceUuid = (__bridge NSString *)cfUuid;
 CFRelease(cfUuid);
 [defaults setObject:deviceUuid forKey:@"deviceUuid"];
 }
 }
 NSString *deviceName = dev.name;
 NSString *deviceModel = dev.model;
 NSString *deviceSystemVersion = dev.systemVersion;
 
 // Prepare the Device Token for Registration (remove spaces and < >)
 NSString *deviceToken2 = [[[[devToken description] 
 stringByReplacingOccurrencesOfString:@"<"withString:@""] 
 stringByReplacingOccurrencesOfString:@">" withString:@""] 
 stringByReplacingOccurrencesOfString: @" " withString: @""];
 
 // Build URL String for Registration
 // !!! CHANGE "www.mywebsite.com" TO YOUR WEBSITE. Leave out the http://
 // !!! SAMPLE: "secure.awesomeapp.com"
 NSString *host = @"beta.opendestination.com";
 
 // !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED 
 // !!! ( MUST START WITH / AND END WITH ? ). 
 // !!! SAMPLE: "/path/to/apns.php?"
 NSString *urlString = [NSString stringWithFormat:@"/apns.php?task=%@&appname=%@&appversion=%@&deviceuid=%@&devicetoken=%@&devicename=%@&devicemodel=%@&deviceversion=%@&pushbadge=%@&pushalert=%@&pushsound=%@", @"register", appName,appVersion, deviceUuid, deviceToken2, deviceName, deviceModel, deviceSystemVersion, pushBadge, pushAlert, pushSound];
 
 // Register the Device Data
 // !!! CHANGE "http" TO "https" IF YOU ARE USING HTTPS PROTOCOL
 NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
 NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
 NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 NSLog(@"Register URL: %@", url);
 NSLog(@"Return Data: %@", returnData);
 [user setUdid:deviceToken2];
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
 [defaults setValue:[NSNumber numberWithInt:1] forKey:@"register"];
 [defaults synchronize];  
 #endif
 UserModel * user = [UserModel sharedUser];*/
/*
 NSString *devToken2 = [[[[devToken description]
 stringByReplacingOccurrencesOfString:@"<"withString:@""]
 stringByReplacingOccurrencesOfString:@">" withString:@""]
 stringByReplacingOccurrencesOfString: @" " withString: @""];
 #ifdef __DEBUG__
 NSLog(@"%@: DEVICE TOKEN: %@ ",[self description], devToken2);
 #endif
 [user setUdid:devToken2];
 NSUserDefaults *settings = [NSUserDefaults standardUserDefaults]; 
 [settings setValue:[NSNumber numberWithInt:1] forKey:@"register"];
 [settings synchronize];   
 
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
    /*   NSString *devToken = [[[[deviceToken description]
     stringByReplacingOccurrencesOfString:@"<"withString:@""]
     stringByReplacingOccurrencesOfString:@">" withString:@""]
     stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%@",devToken);
    
    NSString *urlString = [NSString stringWithFormat:@"/opendes/device_registration_sw.php?device_id=%@&type=2",devToken];
    NSString *host = @"www.kirubslabs.com";
    NSLog(@"%@%@",host,urlString);
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:urlString];    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults]; 
    [settings setValue:[NSNumber numberWithInt:1] forKey:@"register"];
    [settings synchronize];   
    
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

*/
@end
