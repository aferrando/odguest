//
//  GlobalConstants.h
//  chipspain
//
//  Created by Gerard Porto on 3/11/11.
//  Copyright 2011 kirubs.com. All rights reserved.
//

//#define DATABASE_NAME @"ShopAddict.db"

#define __DEBUB__



//HOSTNAMENES
#define kDEVELOPMENT_HOSTNAME @"http://beta.opendestination.com"
#define kPRODUCTION_HOSTNAME @"http://www.opendestination.com"

// SERVICE
#define URL_BASE_OD @"/services.php"

// OBJECTS
#define USER @"%@/user/"
#define OPPORTUNITY @"%@/opportunity/"

// WEB SERVICES

//users loginServieProvider ws
#define URL_LOGIN USER @"loginServiceProvider?destination_id=%@&username=%@&password=%@"
//users online ws
#define URL_USERS_ONLINE USER @"listOnline?uuid=%@&destination_id=%@&serviceprovider_id=%d"
//users interacting ws
#define URL_USERS_INTERACTING USER @"listAutomaticInteraction?uuid=%@&id=%@"
//users redeeming ws
#define URL_USERS_REDEEMING USER @"listDeal?uuid=%@&id=%@"
//users set location ws
#define URL_USERS_SETLOCATION  USER @"setProviderLocation?id=%d&latitude=%f&longitude=%f"
//users setProvider
#define URL_USERS_SETPROVIDER USER @"setProvider"

//URL send oportunities
#define URL_CREATE_DEAL OPPORTUNITY  @"create"
//users walkin ws
#define URL_USERS_WALKIN OPPORTUNITY @"listWalkin?destination_id=%d&serviceprovider_id=%d"
//users walkin ws
#define URL_USERS_CONSUMED OPPORTUNITY @"listConsumed?destination_id=%d&serviceprovider_id=%d"
//users check ws
#define URL_USERS_CHECK OPPORTUNITY @"check?destination_id=%d&serviceprovider_id=%d&user_id=%d&opportunity_id=%d"
//users list ws
#define URL_LIST USER @"listMadeByMe?destination_id=%d&uuid=%@&serviceprovider_id=%d"
//users list by Opportunity and Status
#define URL_USERS_STATUS OPPORTUNITY @"listStatus?status_id=%d&opportunity_id=%d&destination_id=%d&serviceprovider_id=%d"

//returned errors from services
#define ERROR_1001 @"User doesn't exist"
#define ERROR_1002 @"User cannot be logged in"
#define ERROR_1004 @"User is not logged in"
#define ERROR_1006 @"User does not have opportunities"

//Thyon destination
#define DESTINATION_ID @"26"
#define RADIUS @"20000"

//constants
#define kDefaultDest 26;
#define kTraveller 0; //Traveller 1 or Guest 0
#define background @"vertical_cloth.png"
                      //#define background @"crema.png"

#define CATEGORIES [[[NSArray alloc]initWithObjects:@"Lessons", @"Guided tour",@"Child Care", @"Events", @"Rentals", @"Buddies", nil]]

#define kMainColor [UIColor colorWithRed:0.9 green:0.4 blue:0 alpha:1] 
#define kCategoryWidth 65.0
#define kCategoryHeigth 65.0
#define kCategoryFontSize 12.0
#define kCategoryMaxPerPage 9
#define kCategoryFooterMargin 35
#define kCategoryTextColor [UIColor whiteColor]
#define kCategoryNavigation 0 //0 is Grid, 1 is TableView
#define kBackgroundColor [UIColor darkGrayColor] //[UIColor colorWithPatternImage:[UIImage imageNamed:@"vertical-cloth.png"]]
#define kTextColor [UIColor whiteColor]
    //#define kCategoryTextColor [UIColor blackColor]
#define MIXPANEL_WHISTLER @"890d68e5afed6da476ff1fbd468610cf" //odWhistler

#define MIXPANEL_VILANOVA @"168e8d5409920fea5c832b5d95e211f0" //odVilanova
#define MIXPANEL_THYON @"2857c0c6d9a4b3f719d93b136d896aa2" //odThyon
#define MIXPANEL_OTHERS @"b0a175d14e957eb31204022523b76a93" //odThyon

    //Categories settings
    //News feeds
#define NEWS_URL @"http://www.thyon.ch/feed"
#define FACEBOOK_URL @"http://www.facebook.com/thyon4vallees"
#define YOUTUBE_URL @"http://www.youtube.com/user/thyon4vallees"
#define WEBCAM_IMAGES [[NSArray alloc] initWithObjects:@"http://www.thyon-photo-video.ch/thyon2000.jpg", @"http://thyon-photo-video.ch/snowpark.jpg",@"http://www.alm.ch/wallis2.jpg",@"http://www.alm.ch/wallis.jpg",@"http://www.alm.ch/wallis3.jpg",nil];
#define WEBCAM_CAPTIONS [[NSArray alloc] initWithObjects:@"THYON", @"SNOWPARK CENTRALPARK",@"LES MASSES (THYON 1600)",@"GRANDE DIXENCE",@"DENT BLANCHE",nil];
    //Anzere color 1.0, 1.0, and 0.0
    //#define kMainColor [UIColor colorWithRed:1 green:0.8 blue:0.1 alpha:1]