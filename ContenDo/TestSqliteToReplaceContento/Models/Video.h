//
//  Video.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 22/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICall.h"
#import "Constants.h"
#import "Topics.h"
@class Meta;
@interface Video : NSObject
typedef void(^video_completion_block)(NSDictionary *result,NSString *, int status);
typedef void(^get_completion_block)(NSArray *result,NSString *str, int status);
@property NSMutableString *videoId,*uuid,*title,*videoUri,*summary,*channelId,*vv,*clientId,*heroImage,*phoneHero,*thumbnail,*tabletHero;
@property NSMutableArray *topicsArray;
@property NSString *topicId;
@property NSMutableDictionary *imageUrls;

@property BOOL isCategoryPresent;
@property Meta *meta;
@property Topics *currentTopic;
-(void)getVideoWithChannelId:(NSString *)channelId :(video_completion_block)completion;
+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result;
+(void)filterArrayUsingString:(NSString *)searchString WithCompletion:(get_completion_block) sync;
-(void)getVideoWithChannelId:(NSString *)channelUUId andTimeStamp:(NSDate *)time withCompletion:(video_completion_block)completion;
-(void)getAllVideos:(video_completion_block)completion;
-(void)getVideosWithTimeStamp:(NSDate *)time withCompletion:(video_completion_block)completion;
@end
