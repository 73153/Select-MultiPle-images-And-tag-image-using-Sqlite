//
//  Channels.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 07/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICall.h"
#import "Constants.h"
#import "Topics.h"
@class Topics;
@class Meta;
@interface Channels : NSObject
typedef void(^channel_completion_block)(NSDictionary *result,NSString *, int status);
@property NSMutableString *channelId,*uuid,*label,*icon,*desc,*clientId,*channelType,*vv,*deviceToken,*type,*url,*channelsCountForFilter;
@property Meta *meta;
@property Users *user;

@property NSMutableArray *topicLists,*aryUserAccess;
-(void)getChannels:(channel_completion_block)completion;
-(void)getChannelType:(NSString *)channelType withCompletionBlock:(channel_completion_block)completion;
+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result;
+ (void)saveCustomObject:(Channels *)object key:(NSString *)key;
+ (Channels *)loadCustomObjectWithKey:(NSString *)key;
-(void)getChannelsWithTimeStamp:(NSDate *)timestamp andCompletion:(channel_completion_block)completion;
@end
