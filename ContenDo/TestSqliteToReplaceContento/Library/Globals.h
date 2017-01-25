//
//  Globals.h
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"
#import "Constants.h"
#import "Channels.h"
#import "Articles.h"
#import "Blogs.h"
#import "Pages.h"
#import "Database.h"
#import "SyncData.h"
#import <MBProgressHUD.h>
@class Channels;
@class Articles;
@class Database;
@class SyncData;
@class Blogs;
@class Video;
@class Pages;
@interface Globals : NSObject
+ (id)sharedManager;
typedef void(^get_completion_block)(NSArray *result,NSString *str, int status);
@property Users *user;
@property Articles *article;
@property Blogs *blogs;
@property Video *videos;
@property Pages *pages;
@property Channels *channel;
@property NSMutableArray *users,*relatedUDIDs,*aryOldChannels;
@property NSMutableDictionary *notificationDictionary;
@property MBProgressHUD *hud;
@property BOOL addObj,isVideoPlaying,isNotificationRecieved;
@property BOOL uploadV,IsLinkedInLogin,isRefreshFromDashBoard,isHomePressed,isAllAticleReceived,isAllBlogsReceived,isAllVideoReceived,isFromLink;
@property BOOL isAccepted,isAlreadyLoggedIn,isShowLoaderForNextData;
@property BOOL isMenuOpenForActiveChannels;

@property (nonatomic,strong) NSString *databaseName,*fontSize;

@property (nonatomic,strong) NSString *databasePath,*linkedToken;@property Database *db;
@property SyncData *sync;
@property int tmpInt,tmpBlogCount, tmpArticleCount, tmpPageCount, tmpVideoCount,totalArticles, totalBlogs, totalVideos, totalPages,totalArticleCount,totalBlogsCount,totalVideoCount;
@property int articlecount, blogcount;
@property (nonatomic, strong) get_completion_block syncCompleted;
@property int channelSyncCount;
// For Caching Articles, Channels and other Data from Database
@property NSMutableArray *channelArray,*updatedChannelArray, *articleArray,*updatedArticleArray,*blogsArray,*updatedBlogsArray,*readingListArray,*topicsArray,*categoryArray,*videosArray,*pagesArray, *updatedPageArray,*aryAllChannels,*aryAllArticles,*aryAllBlogs,*aryAllVideos;
@property NSMutableDictionary *dictChannelDataCount;
@property int intOffset, intLimit, intTotalArticles, intTotalBlogs, intTotalVideos;
- (BOOL) isNotNull:(NSObject*) object;
+ (void)ShowAlertWithTitle:(NSString *)title Message:(NSString *)message;
- (void)showLoader;
- (void)showLoaderWith:(MBProgressHUDMode)mode ;
- (void)showLoaderIn:(UIView *)view;
- (void)hideLoader;
-(NSArray*) getArticles:(NSString *)channelId;
-(NSArray*)getVideos:(NSString *)channelId;
-(NSArray*) getBlogs:(NSString *)channelId;
+ (void)pushNewViewController:(UIViewController *)NewViewController;
+ (void)turnBackToAnOldViewController:(UIViewController *)AnOldViewController;
+ (NSString *)extractYoutubeID:(NSString *)youtubeURL;
-(NSString *) getDatabasePath;
- (float)getTextHeightOfText:(NSString *)string font:(UIFont *)aFont width:(float)width ;
- (void)showToast:(NSString *)msg WithViewController:(UIViewController *)vc;
@end
