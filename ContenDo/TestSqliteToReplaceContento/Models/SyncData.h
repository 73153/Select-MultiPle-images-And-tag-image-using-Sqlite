//
//  SyncData.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 24/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import "Video.h"
@class Database;

@interface SyncData : NSObject
{
    NSMutableArray *channelsArray;
}
@property Database *db;
@property BOOL check;
@property int channelSyncCount;
typedef void(^sync_completion_block)(NSString *str, int status);
typedef void(^get_completion_block)(NSArray *result,NSString *str, int status);
typedef void(^size_completion_block)(float size);

// DB Sync Methods
-(void)fillChannelsWithCompletionBlock:(sync_completion_block)sync;
-(void)getBlogChannelsWithCompletionBlock:(get_completion_block)sync;
-(void)fillArticlesWithCompletionBlock:(get_completion_block)sync;
-(void)fillBlogsWithCompletionBlock:(get_completion_block)sync;

// DB Select From Database Methods
-(void)getAllChannelsWithCompletionBlock:(get_completion_block)sync;
-(void)getAllArticlesWithCompletionBlock:(get_completion_block)sync;
-(void)getChannelsForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync;
-(void)getArticlesForChannel:(NSString *)channelId WithCompletionBlock:(get_completion_block)sync;
-(NSMutableArray *)getArticlesWithTopics:(NSMutableArray *)articles;
-(void)getBlogsForChannel:(NSString *)channelId WithCompletionBlock:(get_completion_block)sync;
-(void)getArticlesForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync;
-(void)getAllBlogsWithCompletionBlock:(get_completion_block)sync;
-(void)getBlogsForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync;
-(NSMutableArray *)getBlogsWithTopics:(NSMutableArray *)blogs;

// For videos
-(void)getVideosForChannel:(NSString *)channelId WithCompletionBlock:(get_completion_block)sync;
-(void)getAllVideosWithCompletionBlock:(get_completion_block)sync;
-(void)getVideosForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync;
-(NSMutableArray *)getVideosWithTopics:(NSMutableArray *)videos;
-(void)getMenuChannelsWithCompletionBlock:(get_completion_block)sync;
-(void)fillPages:(sync_completion_block)sync;
// To Extract Categories & Tags from Articles
-(void)getAllCategories:(get_completion_block)sync;
-(void)getAllTags:(get_completion_block)sync;
-(void)saveVideos:(NSDictionary *)parameters;
// For Reading List
-(void)getAllReadingListWithCompletionBlock: (get_completion_block)sync;
-(void)insertReadingListWithName:(NSString *)name andWithUUID:(NSString *)uuid andType:(NSString *)type WithCompletionBlock: (sync_completion_block)sync;
// For Pages
-(void)getAllPagesWithCompletionBlock:(get_completion_block)sync;
-(void)fillUpdatesChannelsWithCompletionBlock:(sync_completion_block)sync;
#define isNull(value) value == nil || [value isKindOfClass:[NSNull class]]

-(void)getFilterArticlesWithCompletionBlock:(get_completion_block)sync;

-(void)fillAllUpdatedChannelsData:(get_completion_block)sync;

@end
