//
//  Articles.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICall.h"
#import "Constants.h"
#import "Topics.h"
@class Meta;
@interface Articles : NSObject
typedef void(^article_completion_block)(NSDictionary *result,NSString *, int status);
typedef void(^get_completion_block)(NSArray *result,NSString *str, int status);
@property NSMutableString *articlelId,*uuid,*title,*articleUri,*desc,*summary,*channelId,*vv,*clientId,*type, *articleURL,*updatedDate;
@property NSMutableArray *topicsArray;
@property NSMutableDictionary *imageUrls;
@property NSString *topicId;
@property Meta *meta;
@property BOOL isCategoryPresent;
@property Topics *currentTopic;
-(void)getArticlesWithChannelId:(NSString *)channelId :(article_completion_block)completion;
+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result;
+(void)filterArrayUsingString:(NSString *)searchString WithCompletion:(get_completion_block) sync;
-(BOOL) searchInArticle:(Articles *)article WithString:(NSString *)searchStr;
+(NSMutableArray *)parseArrayToObjectsWithArrayForAllArticles:(NSArray *)result;

+ (void)saveCustomObject:(Articles *)object key:(NSString *)key;
+ (Articles *)loadCustomObjectWithKey:(NSString *)key;
-(void)getArticlesWithChannelId:(NSString *)channelUUId andTimeStamp:(NSDate *)time withCompletion:(article_completion_block)completion;
@end
