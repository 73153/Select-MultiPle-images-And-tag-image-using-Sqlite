//
//  Constants.h
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 28/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#import "MenuVC.h"
#import "LoginVC.h"
#import "Globals.h"
#import "FMDBDataAccess.h"
#import "TestSqliteToReplaceContentoVC.h"
#import <SlideNavigationController.h>
#import "cellDashBoard.h"
#import "Validations.h"
#import "Meta.h"
#import "Channels.h"

//#define BASE_URL        @"http://10.100.100.240:8080/api/"
// Live
//#define BASE_URL        @"http://202.131.115.110:8080/api/" 
//#define IMAGE_URL        @"http://202.131.115.110:8080/"

//#define BASE_URL        @"http://api.test.TestSqliteToReplaceContento.mobi:8080/api/"
//#define IMAGE_URL        @"http://api.test.TestSqliteToReplaceContento.mobi:8080/"

//#define BASE_URL        @"http://api.TestSqliteToReplaceContento.mobi/api/"
//#define IMAGE_URL        @"http://admin.TestSqliteToReplaceContento.mobi/"


#define BASE_URL        @"http://api.staging.TestSqliteToReplaceContento.mobi/api/"
#define IMAGE_URL        @"http://admin.staging.TestSqliteToReplaceContento.mobi/api/"



//#define BASE_URL        @"http://192.168.15.41:8080/api/"
//#define BASE_URL        @"http://202.131.115.109:8080/api/"


//#define BASE_URL        @"http://192.168.15.159:8080/api/"
//#define IMAGE_URL        @"http://192.168.15.159:8080/"

#define API_AUTHENTICATE  (BASE_URL@"client/authenticate")
#define API_USER          (BASE_URL@"user/")
#define API_USER_LOGIN    (BASE_URL@"user/authenticate")
#define API_CHANNEL_LIST    (BASE_URL@"v2/channels")
#define API_VERIFY_CHANNEL    (BASE_URL@"channel-types")
#define API_ARTICLE_LIST    (BASE_URL@"v2/articles")
#define API_ACTIVITY    (BASE_URL@"activity")
#define API_BLOG_LIST    (BASE_URL@"v2/blogs")
#define API_VIDEO_LIST    (BASE_URL@"v2/videos")
#define API_PAGE_LIST    (BASE_URL@"pages")
#define API_CONTACT_US    (BASE_URL@"contact-us")
#define API_OAUTH_LIST    (BASE_URL@"user/authenticate/oauth")
#define API_FORGOT_PASSWORD  (BASE_URL@"user/forgotpwd")


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)


#define UDSetObject(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetValue(value, key) [[NSUserDefaults standardUserDefaults] setValue:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetBool(value, key) [[NSUserDefaults standardUserDefaults] setInteger:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetInt(value, key) [[NSUserDefaults standardUserDefaults] setFloat:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetFloat(value, key) [[NSUserDefaults standardUserDefaults] setBool:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define MDictionary [[NSMutableDictionary alloc] init];
#define MString [[NSMutableString alloc] init];
#define MArray [[NSMutableArray alloc] init];

#define UDGetObject(key) [[NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define UDGetValue(key) [[NSUserDefaults standardUserDefaults] valueForKey:(key)]
#define UDGetInt(key) [[NSUserDefaults standardUserDefaults] integerForKey:(key)]
#define UDGetFloat(key) [[NSUserDefaults standardUserDefaults] floatForKey:(key)]
#define UDGetBool(key) [[NSUserDefaults standardUserDefaults] boolForKey:(key)]

#define UDRemoveObject(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:(key)]
#define topDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define dt_time_formatter @"yyyy-MM-dd HH:mm:ss"
#define dt_formatter @"yyyy-mm-dd"
#define time_formatter @"HH:mm:ss"


#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]
// For Validation Messages
#define ERROR_NAME @"Please enter Valid Name."
#define ERROR_EMAIL @"Please enter Valid Email Address."
#define ERROR_COMPANY @"Please enter Valid Company Name."
#define ERROR_WEBSITE @"Please enter Valid Website"
#define ERROR_JOBTITLE @"Please enter Valid Job Title"
#define ERROR_PHONENUMBER @"Please enter Valid Phone Number of 10 digits"
#define ERROR_PASSWORD @"Please enter Valid Password of minimum 8 characters"
#define ERROR_CONFIRM_PASSWORD @"Please enter Valid Password and Password & Confirm Password should be same"
#define ERROR_USER_REGISTRATION @"User Registration Failed"
#define ERROR_USER_UPDATE @"User update Failed"

#define ERROR_LOGIN_ERROR @"User Login Failed"
#define ERROR_TOKEN_FAILED @"Client token is invalid"
#define ERROR_INTERNET @"No Internet Available"
#define ERROR_CHANNEL_LIST @"Channel list could not be retrived"
#define ERROR_CHANNEL_NOT_FOUND @"No Channels Found"
#define ERROR_TOPICS_NOT_FOUND @"No Topics Found"
#define ERROR_ARTICLE_LIST @"Article list could not be retrived"
#define ERROR_ARTICLE_NOT_FOUND @"No Articles Found"
#define ERROR_BLOG_LIST @"Blog list could not be retrived"
#define ERROR_VIDEO_LIST @"Video list could not be retrived"
#define ERROR_BLOG_NOT_FOUND @"No Blog Found"
#define ERROR_DATABASE_SYNC @"Could not sync Database"
#define ERROR_SEARCH_RESULT @"No Result Found"
#define ERROR_READING_LIST @"Reading list could not be retrived"
#define ERROR_READING_NOT_FOUND @"No Reading List Found"
#define ERROR_READING_INSERT @"Reading List could not be inserted"
#define ERROR_READING_DUPLICATE @"This article already exists in reading list"
#define ERROR_PAGE_LIST @"Page list could not be retrived"
#define ERROR_SPACEALLOWED @"Sorry, space is not allowed in password"

// For No Data retrived from Web services
#define UNAVAILBLE_ARTICLE_TITLE @"No Articles Found"
#define UNAVAILBLE_ARTICLE_DESCRIPTION @"There are no articles available for this channel"

// For Keys
#define KEY_ARTICLE_TIME_STAMP @"articleTimeStamp"
#define KEY_CHANNEL_TIME_STAMP @"channelTimeStamp"
#define KEY_BLOG_TIME_STAMP @"blogTimeStamp"
#define KEY_VIDEO_TIME_STAMP @"videoTimeStamp"

// For Success Messages.
#define SUCCESS_USER_UPDATE @"Profile updated successfully"
#define SUCCESS_PASSWORD_UPDATE @"Password changed successfully"

#define SUCCESS_USER_REGISTRATION @"Thanks for registering. An email has been sent to you to verify your details."
#define SUCEESS_CHANNEL_LIST @"Channel list retrived successfully"
#define SUCEESS_TOKEN @"Client token is valid"
#define SUCEESS_ARTICLE_LIST @"Article list retrived successfully"
#define SUCEESS_BLOG_LIST @"Blog list retrived successfully"
#define SUCEESS_VIDEO_LIST @"Video list retrived successfully"
#define SUCEESS_PAGE_LIST @"Video list retrived successfully"
#define SUCESS_DATABASE_SYNC @"Database Sync Completed"
#define SUCCESS_READING_LIST @"Article has been added to Reading List"
#define SUCCESS_READING_INSERT @"Reading List inserted successfully"
#endif /* Constants_h */

//Tech Data  Theme Colors
//#define THEME_TAG_COLOR [UIColor colorWithRed:0.0f/255.0f green:172.0f/255.0f blue:219.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:0.0f/255.0f green:172.0f/255.0f blue:219.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:82.0f/255.0f blue:141.0f/255.0f alpha:1.0]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:82.0f/255.0f blue:141.0f/255.0f alpha:1.0]
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:82.0f/255.0f blue:141.0f/255.0f alpha:1.0]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR [UIColor blackColor]
//#define THEME_NAME @"Tech Data"

// Apteco Colors
//#define THEME_TAG_COLOR [UIColor colorWithRed:157.0f/255.0f green:216.0f/255.0f blue:218.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:157.0f/255.0f green:216.0f/255.0f blue:218.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:46.0f/255.0f green:172.0f/255.0f blue:177.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR [UIColor blackColor]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:46.0f/255.0f green:172.0f/255.0f blue:177.0f/255.0f alpha:1.0]
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:46.0f/255.0f green:172.0f/255.0f blue:177.0f/255.0f alpha:1.0]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]

//#define THEME_NAME @"Apteco"


// Thomas Cook Theme Colors
#define THEME_TAG_COLOR [UIColor colorWithRed:238.0f/255.0f green:156.0f/255.0f blue:10.0f/255.0f alpha:1.0]
#define THEME_TEXT_COLOR [UIColor colorWithRed:255.0f/255.0f green:164.0f/255.0f blue:0.0f/255.0f alpha:1.0]
#define THEME_BG_COLOR [UIColor colorWithRed:238.0f/255.0f green:156.0f/255.0f blue:10.0f/255.0f alpha:1.0]
#define THEME_INNER_BG_COLOR [UIColor colorWithRed:238.0f/255.0f green:156.0f/255.0f blue:10.0f/255.0f alpha:1.0]

#define THEME_MENU_BG_COLOR [UIColor colorWithRed:238.0f/255.0f green:156.0f/255.0f blue:10.0f/255.0f alpha:1.0]
#define THEME_MENU_COLOR [UIColor colorWithRed:238.0f/255.0f green:156.0f/255.0f blue:10.0f/255.0f alpha:1.0]
#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
#define THEME_NAME @"Thomas Cook"
#define UUID @"957c122b-5e41-4cb1-b581-6dfe166f9651"

//// TestSqliteToReplaceContento Theme Colors
//#define THEME_TAG_COLOR [UIColor colorWithRed:188.0f/255.0f green:182.0f/255.0f blue:11.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:255.0f/255.0f green:164.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:188.0f/255.0f green:182.0f/255.0f blue:11.0f/255.0f alpha:1.0]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:188.0f/255.0f green:182.0f/255.0f blue:11.0f/255.0f alpha:1.0]
//
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:255.0f/255.0f green:164.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR [UIColor colorWithRed:255.0f/255.0f green:164.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define THEME_NAME @"TestSqliteToReplaceContento"
//#define UUID @"acab8234-5930-421f-9845-ee585e0cfc52"

// T3 SOAK Theme Colors
//#define THEME_TAG_COLOR [UIColor colorWithRed:253.0f/255.0f green:147.0f/255.0f blue:9.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:253.0f/255.0f green:147.0f/255.0f blue:9.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:214.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:214.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0]
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:214.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR [UIColor colorWithRed:214.0f/255.0f green:24.0f/255.0f blue:24.0f/255.0f alpha:1.0]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:253.0f/255.0f green:147.0f/255.0f blue:9.0f/255.0f alpha:1.0]
//#define THEME_NAME @"SOAK"
//#define UUID @"f794fc62-dbea-4c87-ae9e-593bd8c38343"

// Arkadin Color
//#define THEME_TAG_COLOR [UIColor colorWithRed:250.0f/255.0f green:183.0f/255.0f blue:2.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:250.0f/255.0f green:183.0f/255.0f blue:2.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:228.0f/255.0f green:0.0f/255.0f blue:59.0f/255.0f alpha:1.0]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:228.0f/255.0f green:0.0f/255.0f blue:59.0f/255.0f alpha:1.0]
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:228.0f/255.0f green:0.0f/255.0f blue:59.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR [UIColor blackColor]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define THEME_NAME @"Arkadin"

// ETQ Color
//#define THEME_TAG_COLOR [UIColor colorWithRed:250.0f/255.0f green:183.0f/255.0f blue:2.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:250.0f/255.0f green:183.0f/255.0f blue:2.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:228.0f/255.0f green:0.0f/255.0f blue:59.0f/255.0f alpha:1.0]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:228.0f/255.0f green:0.0f/255.0f blue:59.0f/255.0f alph a:1.0]
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:228.0f/255.0f green:0.0f/255.0f blue:59.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR [UIColor blackColor]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define THEME_NAME @"ETQ"

//ITV Color
// TestSqliteToReplaceContento Theme Colors
//#define THEME_TAG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:66.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR  [UIColor colorWithRed:66.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//
//#define THEME_NAME @"My Development"
//#define UUID @"acab8234-5930-421f-9845-ee585e0cfc02"

//Enerm Color
//#define THEME_TAG_COLOR [UIColor colorWithRed:220.0f/255.0f green:183.0f/255.0f blue:5.0f/255.0f alpha:1.0]
//#define THEME_TEXT_COLOR [UIColor colorWithRed:220.0f/255.0f green:183.0f/255.0f blue:5.0f/255.0f alpha:1.0]
//#define THEME_BG_COLOR [UIColor colorWithRed:237.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define THEME_INNER_BG_COLOR [UIColor colorWithRed:237.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define THEME_MENU_BG_COLOR [UIColor colorWithRed:237.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define THEME_MENU_COLOR [UIColor colorWithRed:237.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0]
//#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
//#define THEME_NAME @"KCom"
//#define UUID @"2f1ceaaf-5b1b-4522-8e30-37051f629a98"


//Vistage Color
// Vistage Theme Colors
/* #define THEME_TAG_COLOR [UIColor colorWithRed:207.0f/255.0f green:174.0f/255.0f blue:18.0f/255.0f alpha:1.0]
 #define THEME_TEXT_COLOR [UIColor colorWithRed:207.0f/255.0f green:174.0f/255.0f blue:18.0f/255.0f alpha:1.0]
 #define THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:62.0f/255.0f blue:95.0f/255.0f alpha:1.0]
 #define THEME_INNER_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:62.0f/255.0f blue:95.0f/255.0f alpha:1.0]
 #define THEME_INNER_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:62.0f/255.0f blue:95.0f/255.0f alpha:1.0]
 #define THEME_MENU_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:62.0f/255.0f blue:95.0f/255.0f alpha:1.0]
 #define THEME_MENU_COLOR [UIColor blackColor]
 //#define RELATED_THEME_BG_COLOR [UIColor colorWithRed:0.0f/255.0f green:202.0f/255.0f blue:209.0f/255.0f alpha:1.0]
 //#define RELATED_THEME_TITLE_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
 //#define RELATED_THEME_TAG_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]
 #define THEME_NAME @"Vistage"
 #define UUID @"acab8234-5930-421f-9845-ee585e0cfc52" */
