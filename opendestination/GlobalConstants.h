//
//  GlobalConstants.h
//  chipspain
//
//  Created by Gerard Porto on 3/11/11.
//  Copyright 2011 kirubs.com. All rights reserved.
//

//#define DATABASE_NAME @"ShopAddict.db"

#define __DEBUB__

#define DESTINATION_ID @"4"
#define RADIUS @"20000"



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

//constants
#define kDefaultDest 4;

#define CATEGORIES [[[NSArray alloc]initWithObjects:@"Lessons", @"Guided tour",@"Child Care", @"Events", @"Rentals", @"Buddies", nil]]

    //#define kMainColor [UIColor colorWithRed:0.9 green:0.4 blue:0 alpha:1] 
    //Anzere color 1.0, 1.0, and 0.0
#define kMainColor [UIColor colorWithRed:1 green:0.8 blue:0.1 alpha:1]