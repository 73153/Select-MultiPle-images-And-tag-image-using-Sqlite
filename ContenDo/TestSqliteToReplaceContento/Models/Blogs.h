//
//  Blogs.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 04/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICall.h"
#import "Constants.h"
#import "Topics.h"
@class Meta;
@interface Blogs : NSObject
typedef void(^blog_completion_block)(NSDictionary *result,NSString *, int status);
typedef void(^get_completion_block)(NSArray *result,NSString *str, int status);
@property NSMutableString *blogId,*uuid,*title,*blogUri,*body,*summary,*channelId,*vv,*clientId,*keywords,*heroImage;
@property NSMutableArray *topicsArray;
@property BOOL isCategoryPresent;
@property NSString *topicId;
@property NSMutableDictionary *imageUrls;

@property Meta *meta;
@property Topics *currentTopic;
-(void)getBlogsWithChannelId:(NSString *)channelId :(blog_completion_block)completion;
+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result;
+(void)filterArrayUsingString:(NSString *)searchString WithCompletion:(get_completion_block) sync;
-(void)getBlogsWithChannelId:(NSString *)channelUUId andTimeStamp:(NSDate *)time withCompletion:(blog_completion_block)completion;
-(void)getAllBlogs:(blog_completion_block)completion;
-(void)getBlogsWithTimeStamp:(NSDate *)time withCompletion:(blog_completion_block)completion;

@end
