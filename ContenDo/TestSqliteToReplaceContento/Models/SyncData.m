//
//  SyncData.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 24/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "SyncData.h"
#import "Database.h"
#import "MMMarkdown.h"
#import "Users.h"
#import "DashboardVC.h"
@class Database;
@implementation SyncData
-(instancetype)init{
    self = [super init];
    if(self) {
        self.db= [[Database alloc] init];
        self.channelSyncCount=0;
    }
    return self;
}
-(void)fillUpdatesChannelsWithCompletionBlock:(sync_completion_block)sync{
    @try{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *date;
        BOOL isDate=false;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNEL_TIME_STAMP]) {
            NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNEL_TIME_STAMP];
            NSString* myString = [dateFormat stringFromDate:now];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormat setTimeZone:timeZone];
            date = [dateFormat dateFromString:myString];
            isDate = true;
        }
        NSMutableArray *channels=MArray;
        channels=[Channels parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"channels"]];
        
        [sharedManager.channel getChannelsWithTimeStamp:date andCompletion:^(NSDictionary *results, NSString *str, int status){
            
            Globals *sharedManager=[Globals sharedManager];
            sharedManager.updatedChannelArray=MArray;
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormat setTimeZone:timeZone];
            
            
            if(status==1)
            {
                
                NSArray *result=[results objectForKey:@"data"];
                if ([result count]==0) {
                    if (sync) {
                        [sharedManager hideLoader];
                        
                        sync(SUCESS_DATABASE_SYNC,1);
                    }
                }
                else
                {
                    NSDate *date = [NSDate date];
                    
                    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
                    NSInteger minute = [components minute];
                    
                    [components setMinute:minute+1];
                    date= [CURRENT_CALENDAR dateFromComponents:components];
                    [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_CHANNEL_TIME_STAMP];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                for (int i=0; i<[result count]; i++) {
                    
                    Channels  *ch=[[Channels alloc] init];
                    ch.vv=[[result objectAtIndex:i] valueForKey:@"__v"];
                    ch.channelId=[[result objectAtIndex:i] valueForKey:@"_id"];
                    ch.channelType=[[result objectAtIndex:i] valueForKey:@"channelType"];
                    ch.clientId=[[result objectAtIndex:i] valueForKey:@"clientId" ];
                    ch.desc=[[result objectAtIndex:i] valueForKey:@"description"];
                    ch.icon=[[result objectAtIndex:i] valueForKey:@"icon"];
                    ch.label=[[result objectAtIndex:i] valueForKey:@"label"];
                    ch.uuid=[[result objectAtIndex:i] valueForKey:@"uuid"];
                    ch.meta.createdAt=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"createdAt"];
                    ch.meta.isActive=[[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"isActive"] boolValue];
                    ch.meta.isValidated=[[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"isValidated"] boolValue];
                    ch.meta.lastUpdated=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"lastUpdated"];
                    ch.meta.updatedAt=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"updatedAt"];
                    ch.aryUserAccess = [[result objectAtIndex:i] objectForKey:@"userAccess" ];
                    
                    
                    NSArray *arrTopics = [[result objectAtIndex:i] valueForKey:@"topics"];
                    for (int j=0; j< arrTopics.count; j++) {
                        //
                        NSDictionary *dictRecord = [[arrTopics objectAtIndex:j]valueForKey:@"record"];
                        Topics *tmpTopic=[[Topics alloc] init];
                        tmpTopic.topicId = [dictRecord valueForKey:@"_id"];
                        tmpTopic.uuid = [dictRecord valueForKey:@"uuid"];
                        tmpTopic.clientId = [dictRecord valueForKey:@"clientId"];
                        tmpTopic.topicname = [dictRecord valueForKey:@"topicname"];
                        tmpTopic.meta.createdAt=[[dictRecord objectForKey:@"meta" ] valueForKey:@"createdAt"];
                        tmpTopic.meta.isActive=[[[dictRecord objectForKey:@"meta" ] valueForKey:@"isActive"] boolValue];
                        tmpTopic.meta.isNotificationActive=[[[dictRecord objectForKey:@"meta" ] valueForKey:@"isNotificationActive"] boolValue];
                        tmpTopic.meta.updatedAt=[[dictRecord objectForKey:@"meta"] valueForKey:@"updatedAt"];
                        
                        tmpTopic.channelId=MArray;
                        tmpTopic.channelId=[NSMutableArray arrayWithArray:[dictRecord objectForKey:@"channelId"]];
                        if([ch.aryUserAccess containsObject:ch.meta.userTypeId])
                        {
                            if(ch.meta.isActive){
                                [ch.topicLists addObject:tmpTopic];
                            }
                        }
                    }
                    
                    
                    
                    NSString *url_String1=[NSString stringWithFormat:@"%@",API_VERIFY_CHANNEL];
                    [APICall callGetWebService:url_String1 andDictionary:nil withToken:sharedManager.user.activeToken completion:^(NSMutableDictionary *user1, NSError *error, long code){
                        if (error) {
                            //
                            
                        }
                        else{
                            self.check=true;
                            
                            if([[user1 valueForKey:@"success"]integerValue]==1){
                                
                                for (int i=0; i<[[user1 objectForKey:@"data"] count]; i++) {
                                    //
                                    if ([[[[user1 objectForKey:@"data"] objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:ch.channelType]) {
                                        ch.type=[[[user1 objectForKey:@"data"] objectAtIndex:i] valueForKey:@"label"];
                                        ch.url=[[[user1 objectForKey:@"data"] objectAtIndex:i] valueForKey:@"apiPath"];
                                    }
                                }
                                
                                [channelsArray addObject:ch];
                                [sharedManager.updatedChannelArray addObject:ch];
                                // For Database Insert
                                NSMutableDictionary *tmpDic=MDictionary;
                                
                                [tmpDic setObject:ch.uuid forKey:@"uuid"];
                                [tmpDic setObject:ch.label forKey:@"label"];
                                [tmpDic setObject:ch.icon forKey:@"icon"];
                                if (ch.desc && ![ch.desc isKindOfClass:[NSNull class]]) {
                                    NSString *htmlString=[ch.desc stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                                    [tmpDic setObject:htmlString forKey:@"desc"];
                                }
                                
                                [tmpDic setObject:ch.clientId forKey:@"clientId"];
                                [tmpDic setObject:ch.channelType forKey:@"channelType"];
                                [tmpDic setObject: [NSString stringWithFormat:@"%d", ch.meta.isValidated ]  forKey:@"isValidated"] ;
                                [tmpDic setObject:[NSString stringWithFormat:@"%d", ch.meta.isActive ] forKey:@"isActive"];
                                [tmpDic setObject:ch.meta.createdAt forKey:@"createdAt"];
                                @try {
                                    [tmpDic setObject:ch.meta.updatedAt forKey:@"updatedAt"];
                                }
                                @catch (NSException *exception) {
                                    
                                }
                                @finally {
                                    
                                }
                                
                                
                                NSError *error;
                                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[[result objectAtIndex:i]  valueForKeyPath:@"topics.record"]
                                                                                   options:kNilOptions
                                                                                     error:&error];
                                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                
                                
                                [tmpDic setObject:jsonString forKey:@"topics"];
                                [tmpDic setObject:ch.meta.lastUpdated forKey:@"lastUpdated"];
                                [tmpDic setObject:ch.type forKey:@"type"];
                                [tmpDic setObject:ch.url forKey:@"url"];
                                [tmpDic setObject:[NSString stringWithFormat:@"%d", ch.meta.isActive ] forKey:@"isActive"];
                                
                                
                                if(ch.meta.userTypeId.length==0){
                                    ch.meta.userTypeId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userTypeId"];
                                }
                                __block BOOL isMatched=false;
                                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                dispatch_sync(concurrentQueue, ^{
                                    
                                    for (int i=0; i<[channels count]; i++) {
                                        if([[[channels objectAtIndex:i] uuid] isEqualToString:ch.uuid] || ch.meta.isActive==false)
                                        {
                                            isMatched=true;
                                            NSString *condition = [NSString stringWithFormat:@"where uuid='%@'",ch.uuid];
                                            if ([self.db updateQueryWithDictionary:@"channels" withAttribute: tmpDic withSQLCondition:condition])
                                            {
                                            }
                                        }
                                    }
                                });
                                
                                if(!isMatched){
                                    dispatch_sync(concurrentQueue, ^{
                                        if([ch.aryUserAccess containsObject:ch.meta.userTypeId])
                                        {
                                            if(ch.meta.isActive){
                                                [self.db insertQueryWithDictionary:tmpDic inTable:@"channels"];
                                            }
                                        }
                                        else{
                                            
                                            NSString *condition = [NSString stringWithFormat:@"where uuid='%@'",ch.uuid];
                                            if ([self.db updateQueryWithDictionary:@"channels" withAttribute: tmpDic withSQLCondition:condition])
                                            {
                                            }
                                            
                                        }
                                    });
                                }
                                
                                if (i + 1 == [result count]) {
                                    if (sync) {
                                        [sharedManager hideLoader];
                                        
                                        sync(SUCESS_DATABASE_SYNC,1);
                                    }
                                }
                                
                            }
                            else{
                            }
                        }
                    }];
                    
                }
                
            }
            else{
                sync(ERROR_ARTICLE_LIST,1);
            }
        }];
    }
    @catch (NSException *exception) {
        
    }
}

// For Storing Data in Database
-(void)fillChannelsWithCompletionBlock:(sync_completion_block)sync{
    @try{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *date;
        BOOL isDate=false;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNEL_TIME_STAMP]) {
            NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNEL_TIME_STAMP];
            NSString* myString = [dateFormat stringFromDate:now];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormat setTimeZone:timeZone];
            date = [dateFormat dateFromString:myString];
            isDate = true;
        }
        
        __block BOOL isUpdateAtChanged=false;
        [sharedManager.db deleteQueryWithTable:@"channels"];
        
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(concurrentQueue, ^{
            [sharedManager.channel getChannels:^(NSDictionary *results, NSString *str, int status){
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                [dateFormat setTimeZone:timeZone];
                NSDate *now = [NSDate date];
                NSString* myString = [dateFormat stringFromDate:now];
                __block NSDate *date = [dateFormat dateFromString:myString];
                if(status==1)
                {
                    NSString *url_String1=[NSString stringWithFormat:@"%@",API_VERIFY_CHANNEL];
                    [APICall callGetWebService:url_String1 andDictionary:nil withToken:sharedManager.user.activeToken completion:^(NSMutableDictionary *user1, NSError *error, long code){
                        if (error) {
                            //
                        }
                        else{
                            [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_CHANNEL_TIME_STAMP];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            self.check=true;
                            if([[user1 valueForKey:@"success"]integerValue]==1){
                                NSArray*result=[results objectForKey:@"data"];
                                
                                channelsArray=[[NSMutableArray alloc] init];
                                
                                for (int i=0; i<[result count]; i++) {
                                    Channels  *ch=[[Channels alloc] init];
                                    ch.vv=[[result objectAtIndex:i] valueForKey:@"__v"];
                                    ch.channelId=[[result objectAtIndex:i] valueForKey:@"_id"];
                                    ch.channelType=[[result objectAtIndex:i] valueForKey:@"channelType"];
                                    ch.clientId=[[result objectAtIndex:i] valueForKey:@"clientId" ];
                                    ch.desc=[[result objectAtIndex:i] valueForKey:@"description"];
                                    ch.icon=[[result objectAtIndex:i] valueForKey:@"icon"];
                                    ch.label=[[result objectAtIndex:i] valueForKey:@"label"];
                                    ch.uuid=[[result objectAtIndex:i] valueForKey:@"uuid"];
                                    ch.meta.createdAt=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"createdAt"];
                                    ch.meta.isActive=[[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"isActive"] boolValue];
                                    ch.meta.isValidated=[[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"isValidated"] boolValue];
                                    ch.meta.lastUpdated=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"lastUpdated"];
                                    ch.meta.updatedAt=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"updatedAt"];
                                    ch.aryUserAccess = [[result objectAtIndex:i] objectForKey:@"userAccess" ];
                                    
                                    NSData *data1 = [NSJSONSerialization dataWithJSONObject:ch.aryUserAccess
                                                                                    options:kNilOptions
                                                                                      error:&error];
                                    
                                    NSString *jsonString1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                                    
                                    
                                    NSArray *arrTopics = [[result objectAtIndex:i] valueForKey:@"topics"];
                                    for (int j=0; j< arrTopics.count; j++) {
                                        //
                                        NSDictionary *dictRecord = [[arrTopics objectAtIndex:j]valueForKey:@"record"];
                                        Topics *tmpTopic=[[Topics alloc] init];
                                        tmpTopic.topicId = [dictRecord valueForKey:@"_id"];
                                        tmpTopic.uuid = [dictRecord valueForKey:@"uuid"];
                                        tmpTopic.clientId = [dictRecord valueForKey:@"clientId"];
                                        tmpTopic.topicname = [dictRecord valueForKey:@"topicname"];
                                        
                                        
                                        tmpTopic.meta.createdAt=[[dictRecord valueForKey:@"meta" ] valueForKey:@"createdAt"];
                                        tmpTopic.meta.isActive=[[[dictRecord valueForKey:@"meta" ] valueForKey:@"isActive"] boolValue];
                                        tmpTopic.meta.isNotificationActive=[[[dictRecord valueForKey:@"meta" ] valueForKey:@"isNotificationActive"] boolValue];
                                        tmpTopic.meta.updatedAt=[[dictRecord valueForKey:@"meta"] valueForKey:@"updatedAt"];
                                        
                                        tmpTopic.channelId=MArray;
                                        tmpTopic.channelId=[NSMutableArray arrayWithArray:[dictRecord objectForKey:@"channelId"]];
                                        
                                        [ch.topicLists addObject:tmpTopic];
                                    }
                                    
                                    for (int i=0; i<[[user1 objectForKey:@"data"] count]; i++) {
                                        //
                                        if ([[[[user1 objectForKey:@"data"] objectAtIndex:i] valueForKey:@"uuid"] isEqualToString:ch.channelType]) {
                                            ch.type=[[[user1 objectForKey:@"data"] objectAtIndex:i] valueForKey:@"label"];
                                            ch.url=[[[user1 objectForKey:@"data"] objectAtIndex:i] valueForKey:@"apiPath"];
                                        }
                                    }
                                    
                                    
                                    [channelsArray addObject:ch];
                                    
                                    // For Database Insert
                                    NSMutableDictionary *tmpDic=MDictionary;
                                    
                                    [tmpDic setObject:ch.uuid forKey:@"uuid"];
                                    [tmpDic setObject:ch.label forKey:@"label"];
                                    [tmpDic setObject:ch.icon forKey:@"icon"];
                  
                                    if(ch.desc && ![ch.desc isKindOfClass:[NSNull class]])
                                    {
                                        NSString *htmlString=[ch.desc stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                                        [tmpDic setObject:htmlString forKey:@"desc"];
                                    }
                                    
                                    [tmpDic setObject:ch.clientId forKey:@"clientId"];
                                    [tmpDic setObject:ch.channelType forKey:@"channelType"];
                                    [tmpDic setObject: [NSString stringWithFormat:@"%d", ch.meta.isValidated ]  forKey:@"isValidated"] ;
                                    [tmpDic setObject:[NSString stringWithFormat:@"%d", ch.meta.isActive ] forKey:@"isActive"];
                                    [tmpDic setObject:ch.meta.createdAt forKey:@"createdAt"];
                                    [tmpDic setObject:ch.meta.updatedAt forKey:@"updatedAt"];
                                    [tmpDic setObject:ch.meta.lastUpdated forKey:@"lastUpdated"];
                                    [tmpDic setObject:jsonString1 forKey:@"userAccess"];
                                    
                                    @try {
                                        if(isUpdateAtChanged==false){
                                            [channelsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                                
                                                NSString *strCurrentUpdatedAt = [NSString stringWithFormat:@"%@",ch.meta.updatedAt];
                                                NSString *strOldUpdatedAt;
                                                
                                                if([sharedManager isNotNull:[[obj valueForKey:@"meta"] valueForKey:@"updatedAt"]])
                                                    strOldUpdatedAt = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"meta"] valueForKey:@"updatedAt"]];
                                                if([strCurrentUpdatedAt isEqualToString:strOldUpdatedAt])
                                                {
                                                    
                                                }
                                                else{
                                                    *stop =true;
                                                    isUpdateAtChanged=true;
                                                    ch.meta.lastUpdated=[[obj valueForKey:@"meta"] valueForKey:@"lastUpdated"];
                                                    ch.meta.updatedAt=[[obj valueForKey:@"meta"] valueForKey:@"updatedAt"];
                                                }
                                            }];
                                        }
                                    }
                                    @catch (NSException *exception) {
                                        
                                    }
                                    @finally {
                                        
                                    }
                                    
                                    NSError *error;
                                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[[result objectAtIndex:i]  valueForKeyPath:@"topics.record"]
                                                                                       options:kNilOptions
                                                                                         error:&error];
                                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                    
                                    
                                    [tmpDic setObject:jsonString forKey:@"topics"];
                                    
                                    
                                    [tmpDic setObject:ch.type forKey:@"type"];
                                    [tmpDic setObject:ch.url forKey:@"url"];
                                    
                                    if(ch.meta.userTypeId.length==0)
                                    {
                                        ch.meta.userTypeId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userTypeId"];
                                    }
                                    [self.db insertQueryWithDictionary:tmpDic inTable:@"channels"];

//                                    if([ch.aryUserAccess containsObject:ch.meta.userTypeId])
//                                    {
//                                        if(ch.meta.isActive){
//                                            NSLog(@"Channel inserted success");
//                                        }
//                                    }
                                    
                                    NSLog(@"%@",sharedManager.getDatabasePath);
                                    
                                    if (i + 1 == [result count]) {
                                        if (sync) {
//                                            sharedManager.channelArray=[Channels parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"channels"]];;
                                            
                                            sync(SUCESS_DATABASE_SYNC,1);
                                        }
                                    }
                                    
                                }
                                
                                if ([result count]<=0) {
                                    if (sync) {
//                                        sharedManager.channelArray=[Channels parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"channels"]];;
                                        
                                        sync(SUCESS_DATABASE_SYNC,1);
                                    }
                                }
                            }
                            else{
                            }
                        }
                    }];
                    
                }
                else{
                    
                    sync(ERROR_CHANNEL_LIST,1);
                }
            }];
        });
        
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)getChannelsForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync{
    @try{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        NSString *udidstr=[udids componentsJoinedByString:@"','"];
        NSMutableArray *tagArray=[Channels parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"channels" andWithWhereCondition:[NSString stringWithFormat: @" uuid in ('%@')",udidstr ]] mutableCopy] ];
        if (sync) {
            sync(tagArray,SUCESS_DATABASE_SYNC,1);
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)saveBlogs:(NSDictionary *)parameters
{
    @try{
        //Parsing Blog List
        Globals *sharedManager = [Globals sharedManager];
        
        NSDictionary *result;
        if([sharedManager isNotNull:[parameters objectForKey:@"result"]])
            result=[parameters objectForKey:@"result"];
        
        get_completion_block sync;
        if([sharedManager isNotNull:[parameters objectForKey:@"sync"]])
            sync=[parameters objectForKey:@"sync"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *now = [NSDate date];
        NSString* myString = [dateFormat stringFromDate:now];
        NSDate *date = [dateFormat dateFromString:myString];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_BLOG_TIME_STAMP];
        NSMutableArray  *blogListArray=MArray;
        
        Blogs *tmpBlog;
        NSString *check;
        NSMutableArray *blogs=MArray;
        NSMutableDictionary *tmpDic=MDictionary;
        NSString *htmlString;
        NSData *jsonData;
        NSString *jsonString;
        BOOL isURL;
        NSError *error;
        NSArray *aryBlogs;
        if([sharedManager isNotNull:[result objectForKey:@"data"]]){
            aryBlogs = [result objectForKey:@"data"];
            sharedManager.totalBlogs= (int)[aryBlogs count];
        }
        NSDictionary *dictBlogData;
        blogs=[Blogs parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"blogs" ]];
        for (int i=0; i<[aryBlogs count]; i++) {
            
            if([sharedManager isNotNull:[aryBlogs objectAtIndex:i]]){
                dictBlogData = [aryBlogs objectAtIndex:i];
                tmpBlog=[[Blogs alloc] init];
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"_id"]])
                    tmpBlog.blogId=[dictBlogData valueForKey:@"_id"];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"title"]])
                    tmpBlog.title=[dictBlogData valueForKey:@"title"];
                if([tmpBlog.title isEqualToString:@"Welcome to Kate Wilsson1"])
                {
                }
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"uri"]])
                    tmpBlog.blogUri=[dictBlogData valueForKey:@"uri"];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"summary"]])
                    tmpBlog.summary=[dictBlogData valueForKey:@"summary"];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"body"]])
                    tmpBlog.body=[dictBlogData valueForKey:@"body"];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"channelId"]])
                    tmpBlog.channelId=[dictBlogData valueForKey:@"channelId"];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"uuid"]])
                    tmpBlog.uuid=[dictBlogData valueForKey:@"uuid"];
                
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"clientId"]])
                    tmpBlog.clientId=[dictBlogData valueForKey:@"clientId"];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"__v"]])
                    tmpBlog.vv=[dictBlogData valueForKey:@"__v"];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"hero_image"]])
                    tmpBlog.heroImage=[dictBlogData valueForKey:@"hero_image"];
                
                check=[dictBlogData  objectForKey:@"hero_image"];
                isURL = [[check lowercaseString] hasPrefix:@"https://"];
                if(!isURL)
                    isURL = [[check lowercaseString] hasPrefix:@"http://"];
                if ([check containsString:@"uploads/"])
                    isURL = FALSE;
                
                if (!isURL) {
                    //
                    check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                }
                tmpBlog.heroImage=[check mutableCopy];
                
                if([sharedManager isNotNull:[dictBlogData valueForKey:@"keywords"]])
                    tmpBlog.keywords=[dictBlogData valueForKey:@"keywords"];
                
                if([sharedManager isNotNull:[[dictBlogData  objectForKey:@"meta"]valueForKey:@"isActive"]])
                    // For Meta
                    tmpBlog.meta.isActive=[[[dictBlogData  objectForKey:@"meta"]valueForKey:@"isActive"] boolValue];
                
                if([sharedManager isNotNull:[[dictBlogData  objectForKey:@"meta"]valueForKey:@"createdAt"]])
                    tmpBlog.meta.createdAt=[[dictBlogData  objectForKey:@"meta"]valueForKey:@"createdAt"];
                
                if([sharedManager isNotNull:[[dictBlogData  objectForKey:@"meta"]valueForKey:@"updatedAt"]])
                    tmpBlog.meta.updatedAt=[[dictBlogData  objectForKey:@"meta"]valueForKey:@"updatedAt"];
                
                // For Adding Categories
                for (int x; x<[[[dictBlogData  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    if([sharedManager isNotNull:[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]])
                        
                        [tmpBlog.meta.category addObject:[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]];
                }
                // For Adding Tags
                for (int x; x<[[[dictBlogData  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    if([sharedManager isNotNull:[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]])
                        
                        [tmpBlog.meta.category addObject:[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]];
                }
                
                // For Topics
                if([[aryBlogs objectAtIndex:i ] objectForKey:@"topicId"] && ![[[aryBlogs objectAtIndex:i ] objectForKey:@"topicId"] isKindOfClass:[NSNull class]])
                {
                    tmpBlog.topicId=[[aryBlogs objectAtIndex:i ] objectForKey:@"topicId"];
                }
                
                if( tmpBlog.meta.author==nil)
                    tmpBlog.meta.author= [[Authors alloc] init];
                
                if([sharedManager isNotNull:[[[dictBlogData  objectForKey:@"meta"]valueForKey:@"author"] valueForKey:@"name"]])
                    // For Authors
                    tmpBlog.meta.author.name=[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"];
                
                if([sharedManager isNotNull:[[[dictBlogData  objectForKey:@"meta"]valueForKey:@"author"] valueForKey:@"company"]])
                    tmpBlog.meta.author.company=[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"];
                
                if([sharedManager isNotNull:[[[dictBlogData  objectForKey:@"meta"]valueForKey:@"author"] valueForKey:@"blurb"]])
                    tmpBlog.meta.author.blurb=[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"];
                
                if([sharedManager isNotNull:[[[dictBlogData  objectForKey:@"meta"]valueForKey:@"author"] valueForKey:@"uuid"]])
                    tmpBlog.meta.author.uuid=[[[dictBlogData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"];
                
                
                // For Database Dictionary
                tmpDic=MDictionary;
                if([sharedManager isNotNull:tmpBlog.uuid])
                    [tmpDic setObject:tmpBlog.uuid forKey:@"uuid"];
                
                if([sharedManager isNotNull:tmpBlog.title])
                    [tmpDic setObject:tmpBlog.title forKey:@"title"];
                if([sharedManager isNotNull:tmpDic[tmpBlog.blogUri]])
                {
                    [tmpDic setObject:tmpBlog.blogUri forKey:@"uri"];
                }
                if([sharedManager isNotNull:tmpBlog.summary])
                    [tmpDic setObject:tmpBlog.summary forKey:@"summary"];
                
                if([sharedManager isNotNull:tmpBlog.keywords])
                    [tmpDic setObject:tmpBlog.keywords forKey:@"keywords"];
                
                if([sharedManager isNotNull:tmpBlog.heroImage])
                    [tmpDic setObject:tmpBlog.heroImage forKey:@"hero_image"];
                
                
                
                if(tmpBlog.topicId && ![tmpBlog.topicId isKindOfClass:[NSNull class]])
                {
                    [tmpDic setObject:tmpBlog.topicId forKey:@"topicId"];
                }
                
                htmlString=[tmpBlog.body stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                
                [tmpDic setObject:htmlString forKey:@"body"];
                
                if([sharedManager isNotNull:tmpBlog.channelId])
                    [tmpDic setObject:tmpBlog.channelId forKey:@"channelId"];
                
                if([sharedManager isNotNull:tmpBlog.clientId])
                    [tmpDic setObject:tmpBlog.clientId forKey:@"clientId"];
                
                
                
                jsonData = [NSJSONSerialization dataWithJSONObject:[dictBlogData  objectForKey:@"meta"]
                                                           options:kNilOptions
                                                             error:&error];
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                
                [tmpDic setObject:jsonString forKey:@"meta"];
                if(!tmpBlog.keywords)
                {
                    tmpBlog.keywords=[@"" mutableCopy];
                }
                tmpBlog.keywords=[[self isNullOrEmpty:tmpBlog.keywords] mutableCopy];
                
                
                if([sharedManager isNotNull:[[dictBlogData  objectForKey:@"imageUrls"] valueForKey:@"phoneHero"]])
                {
                    NSString *check=[[dictBlogData  objectForKey:@"imageUrls"]valueForKey:@"phoneHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpBlog.imageUrls setObject:check forKey:@"phoneHero"];
                }
                if([sharedManager isNotNull:[[dictBlogData  objectForKey:@"imageUrls"] valueForKey:@"tabletHero"]])
                {
                    
                    NSString *check=[[dictBlogData  objectForKey:@"imageUrls"]valueForKey:@"tabletHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpBlog.imageUrls setObject:check forKey:@"tabletHero"];
                }
                if([sharedManager isNotNull:[[dictBlogData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"]])
                    
                {
                    NSString *check=[[dictBlogData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpBlog.imageUrls setObject:check forKey:@"thumbnail"];
                    
                }
                
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:tmpBlog.imageUrls
                                                                options:kNilOptions
                                                                  error:&error];
                
                NSString *jsonString1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                
                if([sharedManager isNotNull:jsonString1])
                    [tmpDic setObject:jsonString1 forKey:@"imageUrls"];
                
                
                [sharedManager.blogsArray addObject:tmpBlog];
                [blogListArray addObject:tmpBlog];
                __block BOOL isMatched=false;
                
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_sync(concurrentQueue, ^{
                    for (int i=0; i<[blogs count]; i++) {
                        //
                        if([[[blogs objectAtIndex:i] uuid] isEqualToString:tmpBlog.uuid] || tmpBlog.meta.isActive==false)
                        {
                            [self.db updateBlogs:tmpDic WithCompletionBlock:^(BOOL status) {
                                isMatched=true;
                                
                                sharedManager.tmpBlogCount=sharedManager.tmpBlogCount +  1;
                                if((sharedManager.totalBlogs  )==sharedManager.tmpBlogCount)
                                {
                                    sharedManager.channelSyncCount  = sharedManager.channelSyncCount  +1;
                                    sharedManager.tmpBlogCount=0;
                                    
                                    if(sync)
                                    {
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"syncCompleted"
                                         object:self];
                                        sync(blogListArray,SUCESS_DATABASE_SYNC,1);
                                    }
                                    else{
                                        //sync(nil,ERROR_DATABASE_SYNC,-1);
                                    }
                                }
                                
                            }];
                            
                            
                        }
                    }
                });
                
                
                if(!isMatched)
                    [self.db insertBlogs:tmpDic WithCompletionBlock:^(BOOL status) {
                        sharedManager.tmpBlogCount=sharedManager.tmpBlogCount +  1;
                        if((sharedManager.totalBlogs  )==sharedManager.tmpBlogCount)
                        {
                            sharedManager.channelSyncCount  = sharedManager.channelSyncCount  +1;
                            sharedManager.tmpBlogCount=0;
                            
                            if(sync)
                            {
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:@"syncCompleted"
                                 object:self];
                                sync(blogListArray,SUCESS_DATABASE_SYNC,1);
                            }
                            else{
                            }
                        }
                        
                    }];
                
            }
        }
        
        
        if ([aryBlogs count] <=0) {
            sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"syncCompleted"
                 object:self];
            });
            
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)saveVideos:(NSDictionary *)parameters
{
    @try{
        //Parsing Video List
        Globals *sharedManager = [Globals sharedManager];
        NSDictionary *result=[parameters objectForKey:@"result"];
        get_completion_block sync=[parameters objectForKey:@"sync"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *now = [NSDate date];
        NSString* myString = [dateFormat stringFromDate:now];
        NSDate *date = [dateFormat dateFromString:myString];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_VIDEO_TIME_STAMP];
        NSMutableArray  *videoListArray=MArray;
        
        NSArray *aryVideos;
        NSDictionary *dictVideoData;
        if([sharedManager isNotNull:[result objectForKey:@"data"]]){
            aryVideos = [result objectForKey:@"data"];
        }
        sharedManager.totalVideos=(int)[aryVideos count];
        
        NSMutableArray *videos=MArray;
        videos=[Video parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"videos" ]];
        for (int i=0; i<[aryVideos count]; i++) {
            Video *tmpVideo=[[Video alloc] init];
            
            if([sharedManager isNotNull:[aryVideos objectAtIndex:i]]){
                dictVideoData = [aryVideos objectAtIndex:i];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"_id"]])
                    tmpVideo.videoId=[dictVideoData valueForKey:@"_id"];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"title"]])
                    tmpVideo.title=[dictVideoData valueForKey:@"title"];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"uri"]])
                    tmpVideo.videoUri=[dictVideoData valueForKey:@"uri"];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"summary"]])
                    tmpVideo.summary=[dictVideoData valueForKey:@"summary"];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"channelId"]])
                    tmpVideo.channelId=[dictVideoData valueForKey:@"channelId"];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"uuid"]])
                    tmpVideo.uuid=[dictVideoData valueForKey:@"uuid"];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"clientId"]])
                    tmpVideo.clientId=[dictVideoData valueForKey:@"clientId"];
                
                if([sharedManager isNotNull:[dictVideoData valueForKey:@"__v"]])
                    tmpVideo.vv=[dictVideoData valueForKey:@"__v"];
                
                if([sharedManager isNotNull:[[dictVideoData objectForKey:@"imageUrls"] valueForKey:@"thumbnail"]])
                    tmpVideo.thumbnail =[[dictVideoData objectForKey:@"imageUrls"] valueForKey:@"thumbnail"];
                
                if([sharedManager isNotNull:[[dictVideoData objectForKey:@"imageUrls"] valueForKey:@"phoneHero"]])
                    tmpVideo.phoneHero =[[dictVideoData objectForKey:@"imageUrls"] valueForKey:@"phoneHero"];
                
                if([sharedManager isNotNull:[[dictVideoData objectForKey:@"imageUrls"] valueForKey:@"tabletHero"]])
                    tmpVideo.tabletHero =[[dictVideoData objectForKey:@"imageUrls"] valueForKey:@"tabletHero"];
                
                NSString *check;
                if([sharedManager isNotNull:[dictVideoData objectForKey:@"hero_image"]])
                    check=[dictVideoData  objectForKey:@"hero_image"];
                BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                if(!isURL)
                    isURL = [[check lowercaseString] hasPrefix:@"http://"];
                if ([check containsString:@"uploads/"])
                    isURL = FALSE;
                
                if (!isURL) {
                    //
                    check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                }
                if([sharedManager isNotNull:check])
                    tmpVideo.heroImage=[check mutableCopy];
                // For Meta
                if([sharedManager isNotNull:[[dictVideoData  objectForKey:@"meta"]valueForKey:@"isActive"]])
                    tmpVideo.meta.isActive=[[[dictVideoData  objectForKey:@"meta"]valueForKey:@"isActive"] boolValue];
                if([sharedManager isNotNull:[[dictVideoData  objectForKey:@"meta"]valueForKey:@"createdAt"]])
                    tmpVideo.meta.createdAt=[[dictVideoData  objectForKey:@"meta"]valueForKey:@"createdAt"];
                
                if([sharedManager isNotNull:[[dictVideoData  objectForKey:@"meta"]valueForKey:@"updatedAt"]])
                    tmpVideo.meta.updatedAt=[[dictVideoData  objectForKey:@"meta"]valueForKey:@"updatedAt"];
                
                // For Adding Categories
                for (int x; x<[[[dictVideoData  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    
                    if([sharedManager isNotNull:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]])
                        [tmpVideo.meta.category addObject:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]];
                }
                // For Adding Tags
                for (int x; x<[[[dictVideoData  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    
                    if([sharedManager isNotNull:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]])
                        [tmpVideo.meta.category addObject:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]];
                }
                
                // For Topics
                
                if([[aryVideos objectAtIndex:i ] objectForKey:@"topicId"] && ![[[aryVideos objectAtIndex:i ] objectForKey:@"topicId"] isKindOfClass:[NSNull class]])
                {
                    if([sharedManager isNotNull:[[aryVideos objectAtIndex:i ] objectForKey:@"topicId"]])
                        tmpVideo.topicId=[[aryVideos objectAtIndex:i ] objectForKey:@"topicId"];
                }
                
                // For Authors
                @try {
                    if([sharedManager isNotNull:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"]])
                        tmpVideo.meta.author.name=[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"];
                    
                    if([sharedManager isNotNull:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"]])
                        tmpVideo.meta.author.company=[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"];
                    
                    if([sharedManager isNotNull:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"]])
                        tmpVideo.meta.author.blurb=[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"];
                    
                    if([sharedManager isNotNull:[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"]])
                        tmpVideo.meta.author.uuid=[[[dictVideoData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"];
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                // For Database Dictionary
                NSMutableDictionary *tmpDic=MDictionary;
                if([sharedManager isNotNull:tmpVideo.uuid])
                    [tmpDic setObject:tmpVideo.uuid forKey:@"uuid"];
                
                
                if([sharedManager isNotNull:tmpVideo.title])
                    [tmpDic setObject:tmpVideo.title forKey:@"title"];
                
                if([sharedManager isNotNull:tmpVideo.videoUri])
                    [tmpDic setObject:tmpVideo.videoUri forKey:@"uri"];
                
                if([sharedManager isNotNull:tmpVideo.summary])
                    [tmpDic setObject:tmpVideo.summary forKey:@"summary"];
                if([sharedManager isNotNull:tmpVideo.heroImage])
                {
                    [tmpDic setObject:tmpVideo.heroImage forKey:@"hero_image"];
                }
                else{
                    [tmpDic setObject:@"" forKey:@"hero_image"];
                }
                
                if([sharedManager isNotNull:tmpVideo.channelId])
                    [tmpDic setObject:tmpVideo.channelId forKey:@"channelId"];
                
                if([sharedManager isNotNull:tmpVideo.clientId])
                    [tmpDic setObject:tmpVideo.clientId forKey:@"clientId"];
                if(tmpVideo.phoneHero==nil){
                    [tmpDic setObject:@"" forKey:@"phoneHero"];
                }
                else{
                    
                    if([sharedManager isNotNull:tmpVideo.phoneHero])
                        [tmpDic setObject:tmpVideo.phoneHero forKey:@"phoneHero"];
                }
                if(tmpVideo.tabletHero==nil){
                    
                    [tmpDic setObject:@"" forKey:@"tabletHero"];
                }
                else{
                    
                    if([sharedManager isNotNull:tmpVideo.phoneHero])
                        [tmpDic setObject:tmpVideo.phoneHero forKey:@"tabletHero"];
                }
                if(tmpVideo.thumbnail==nil){
                    [tmpDic setObject:@"" forKey:@"thumbnail"];
                }
                else{
                    
                    if([sharedManager isNotNull:tmpVideo.thumbnail])
                        [tmpDic setObject:tmpVideo.thumbnail forKey:@"thumbnail"];
                }
                if([sharedManager isNotNull:tmpVideo.topicId])
                {
                    if([sharedManager isNotNull:tmpVideo.topicId])
                        [tmpDic setObject:tmpVideo.topicId forKey:@"topicId"];
                }
                
                
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dictVideoData  objectForKey:@"meta"]
                                                                   options:kNilOptions
                                                                     error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                
                if([sharedManager isNotNull:jsonString])
                    
                    [tmpDic setObject:jsonString forKey:@"meta"];
                
                
                
                if([sharedManager isNotNull:[[dictVideoData  objectForKey:@"imageUrls"] valueForKey:@"phoneHero"]])
                {
                    NSString *check=[[dictVideoData  objectForKey:@"imageUrls"]valueForKey:@"phoneHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpVideo.imageUrls setObject:check forKey:@"phoneHero"];
                }
                if([sharedManager isNotNull:[[dictVideoData  objectForKey:@"imageUrls"] valueForKey:@"tabletHero"]])
                {
                    
                    NSString *check=[[dictVideoData  objectForKey:@"imageUrls"]valueForKey:@"tabletHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpVideo.imageUrls setObject:check forKey:@"tabletHero"];
                }
                if([sharedManager isNotNull:[[dictVideoData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"]])
                    
                {
                    NSString *check=[[dictVideoData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpVideo.imageUrls setObject:check forKey:@"thumbnail"];
                    
                }
                
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:tmpVideo.imageUrls
                                                                options:kNilOptions
                                                                  error:&error];
                
                NSString *jsonString1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                
                if([sharedManager isNotNull:jsonString1])
                    [tmpDic setObject:jsonString1 forKey:@"imageUrls"];

                
                [sharedManager.videosArray addObject:tmpVideo];
                [videoListArray addObject:tmpVideo];
                __block BOOL isMatched=false;
                
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_sync(concurrentQueue, ^{
                    for (int i=0; i<[videos count]; i++) {
                        //
                        if([[[videos objectAtIndex:i] uuid] isEqualToString:tmpVideo.uuid] || tmpVideo.meta.isActive==false)
                        {
                            [self.db updateVideos:tmpDic WithCompletionBlock:^(BOOL status) {
                                isMatched=true;
                                
                                sharedManager.tmpVideoCount=sharedManager.tmpVideoCount +  1;
                                if((sharedManager.totalVideos  )==sharedManager.tmpVideoCount)
                                {
                                    sharedManager.channelSyncCount  = sharedManager.channelSyncCount  +1;
                                    sharedManager.tmpVideoCount=0;
                                    
                                    if(sync)
                                    {
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"syncCompleted"
                                         object:self];
                                        sync(videoListArray,SUCESS_DATABASE_SYNC,1);
                                    }
                                    else{
                                    }
                                }
                                
                            }];
                            
                            
                        }
                    }
                });
                
                
                if(!isMatched)
                    [self.db insertVideos:tmpDic WithCompletionBlock:^(BOOL status) {
                        sharedManager.tmpVideoCount=sharedManager.tmpVideoCount +  1;
                        if((sharedManager.totalVideos  )==sharedManager.tmpVideoCount)
                        {
                            sharedManager.channelSyncCount  = sharedManager.channelSyncCount  +1;
                            sharedManager.tmpVideoCount=0;
                            
                            if(sync)
                            {
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:@"syncCompleted"
                                 object:self];
                                sync(videoListArray,SUCESS_DATABASE_SYNC,1);
                            }
                            else{
                            }
                        }
                        
                    }];
            }
        }
        
        if ([aryVideos count] <=0) {
            sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"syncCompleted"
                 object:self];
            });
            
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)saveArticles:(NSDictionary *)parameters
{
    @try{
        Globals *sharedManager = [Globals sharedManager];
        NSDictionary *result=[parameters objectForKey:@"result"];
        get_completion_block sync=[parameters objectForKey:@"sync"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *now = [NSDate date];
        NSString* myString = [dateFormat stringFromDate:now];
        NSDate *date = [dateFormat dateFromString:myString];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_ARTICLE_TIME_STAMP];
        NSMutableArray  *articleListArray=MArray;
        
        NSArray *aryArticles;
        if([sharedManager isNotNull:[result objectForKey:@"data"]]){
            sharedManager.totalArticles=(int)[[result objectForKey:@"data"] count];
            aryArticles = [result objectForKey:@"data"];
        }
        NSDictionary *dictArticleData;
        NSMutableArray *articles=MArray;
        articles=[Articles parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"articles"]];
        [articles addObjectsFromArray:sharedManager.updatedArticleArray];
        for (int i=0; i<[aryArticles count]; i++) {
            
            //Parsing Article List
            Articles *tmpArticle=[[Articles alloc] init];
            if([sharedManager isNotNull:[aryArticles objectAtIndex:i]])
            {
                dictArticleData = [aryArticles objectAtIndex:i];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"_id"]])
                    tmpArticle.articlelId=[dictArticleData valueForKey:@"_id"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"title"]])
                    tmpArticle.title=[dictArticleData valueForKey:@"title"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"articleUri"]])
                    //  "articleUri": "http://www.tomorrow-people.com/about-us",
                    tmpArticle.articleUri=[dictArticleData valueForKey:@"articleUri"];
                //tmpArticle.articleUri=[dictArticleData valueForKey:@"articleUri"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"summary"]])
                    tmpArticle.summary=[dictArticleData valueForKey:@"summary"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"description"]])
                    tmpArticle.desc=[dictArticleData valueForKey:@"description"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"channelId"]])
                    tmpArticle.channelId=[dictArticleData valueForKey:@"channelId"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"uuid"]])
                    tmpArticle.uuid=[dictArticleData valueForKey:@"uuid"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"clientId"]])
                    tmpArticle.clientId=[dictArticleData valueForKey:@"clientId"];
                
                if([sharedManager isNotNull:[dictArticleData valueForKey:@"__v"]])
                    tmpArticle.vv=[dictArticleData valueForKey:@"__v"];
                
                
                if([sharedManager isNotNull:[[dictArticleData  objectForKey:@"meta"]valueForKey:@"isActive"]])
                    // For Meta
                    tmpArticle.meta.isActive=[[[dictArticleData  objectForKey:@"meta"]valueForKey:@"isActive"] boolValue];
                
                if([sharedManager isNotNull:[[dictArticleData  objectForKey:@"meta"]valueForKey:@"createdAt"]])
                    tmpArticle.meta.createdAt=[[dictArticleData  objectForKey:@"meta"]valueForKey:@"createdAt"];
                
                if([sharedManager isNotNull:[[dictArticleData  objectForKey:@"meta"]valueForKey:@"updatedAt"]])
                    tmpArticle.meta.updatedAt=[[dictArticleData  objectForKey:@"meta"]valueForKey:@"updatedAt"];
                
                // For Topics
                if([[aryArticles objectAtIndex:i ] objectForKey:@"topicId"] && ![[[aryArticles objectAtIndex:i ] objectForKey:@"topicId"] isKindOfClass:[NSNull class]])
                {
                    if([sharedManager isNotNull:[[aryArticles objectAtIndex:i ] objectForKey:@"topicId"]])
                        tmpArticle.topicId=[[aryArticles objectAtIndex:i ] objectForKey:@"topicId"];
                }
                
                
                // For Adding Categories
                for (int x; x<[[[dictArticleData  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    
                    if([sharedManager isNotNull:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]])
                        
                        [tmpArticle.meta.category addObject:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]];
                }
                // For Adding Tags
                for (int x; x<[[[dictArticleData  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    
                    if([sharedManager isNotNull:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]])
                        [tmpArticle.meta.category addObject:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]];
                }
                
                if( tmpArticle.meta.author==nil)
                    tmpArticle.meta.author= [[Authors alloc] init];
                
                if([sharedManager isNotNull:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"]])
                    // For Authors
                    tmpArticle.meta.author.name=[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"];
                
                if([sharedManager isNotNull:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"]])
                    tmpArticle.meta.author.company=[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"];
                
                if([sharedManager isNotNull:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"]])
                    tmpArticle.meta.author.blurb=[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"];
                
                if([sharedManager isNotNull:[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"]])
                    tmpArticle.meta.author.uuid=[[[dictArticleData  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"];
                
                // For Images
                if([sharedManager isNotNull:[[dictArticleData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"]])
                {
                    NSString *check=[[dictArticleData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"thumbnail"];
                    
                }
                
                if([sharedManager isNotNull:[[dictArticleData  objectForKey:@"imageUrls"] valueForKey:@"phoneHero"]])
                {
                    NSString *check=[[dictArticleData  objectForKey:@"imageUrls"]valueForKey:@"phoneHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"phoneHero"];
                }
                if([sharedManager isNotNull:[[dictArticleData  objectForKey:@"imageUrls"] valueForKey:@"tabletHero"]])
                {
                    
                    NSString *check=[[dictArticleData  objectForKey:@"imageUrls"]valueForKey:@"tabletHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"tabletHero"];
                }
                
                
                NSMutableDictionary *tmpDic=MDictionary;
                
                if([sharedManager isNotNull:tmpArticle.uuid])
                    [tmpDic setObject:tmpArticle.uuid forKey:@"uuid"];
                
                if([sharedManager isNotNull:tmpArticle.title])
                    [tmpDic setObject:tmpArticle.title forKey:@"title"];
                
                if([sharedManager isNotNull:tmpArticle.articleUri])
                    [tmpDic setObject:tmpArticle.articleUri forKey:@"articleUri"];
                
                if([sharedManager isNotNull:tmpArticle.summary])
                    [tmpDic setObject:tmpArticle.summary forKey:@"summary"];
                NSString *htmlString=[tmpArticle.desc stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                [tmpDic setObject:htmlString forKey:@"desc"];
                
                if([sharedManager isNotNull:tmpArticle.channelId])
                    [tmpDic setObject:tmpArticle.channelId forKey:@"channelId"];
                
                if([sharedManager isNotNull:tmpArticle.clientId])
                    [tmpDic setObject:tmpArticle.clientId forKey:@"clientId"];
                @try{
                    if([sharedManager isNotNull:tmpArticle.topicId])
                        [tmpDic setObject:tmpArticle.topicId forKey:@"topicId"];
                }
                @catch(NSException *e)
                {
                    
                }
                @finally{
                    
                }
                
                
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dictArticleData  objectForKey:@"meta"]
                                                                   options:kNilOptions
                                                                     error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                
                [tmpDic setObject:jsonString forKey:@"meta"];
                [tmpDic setObject:[NSString stringWithFormat:@"%d", tmpArticle.meta.isActive] forKey:@"isActive"];
                
                if([sharedManager isNotNull:[[dictArticleData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"]])
                {
                    NSString *check=[[dictArticleData  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"thumbnail"];
                    
                }
                
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:tmpArticle.imageUrls
                                                                options:kNilOptions
                                                                  error:&error];
                
                NSString *jsonString1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                
                if([sharedManager isNotNull:jsonString1])
                    [tmpDic setObject:jsonString1 forKey:@"imageUrls"];
                
                [sharedManager.articleArray addObject:tmpArticle];
                [articleListArray addObject:tmpArticle];
                
                __block BOOL isMatched=false;
                
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_sync(concurrentQueue, ^{
                    for (int i=0; i<[articles count]; i++) {
                        //
                        if([[[articles objectAtIndex:i] uuid] isEqualToString:tmpArticle.uuid] )
                        {
                            if ([self.db updateArticles:tmpDic]) {
                                isMatched=true;
                                sharedManager.tmpArticleCount=sharedManager.tmpArticleCount +  1;
                                if(sharedManager.tmpArticleCount == sharedManager.totalArticles)
                                {
                                    sharedManager.tmpArticleCount=0;
                                    
                                    sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                                    dispatch_async(dispatch_get_main_queue(),^{
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"syncCompleted"
                                         object:self];
                                        sync(articleListArray,SUCESS_DATABASE_SYNC,1);
                                        
                                    });
                                }
                                
                            }
                        }
                    }
                    
                });
                if(!isMatched)
                    if ([self.db insertArticles:tmpDic]) {
                        
                        sharedManager.tmpArticleCount=sharedManager.tmpArticleCount +  1;
                        if(sharedManager.tmpArticleCount == sharedManager.totalArticles)
                        {
                            sharedManager.tmpArticleCount=0;
                            
                            sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                            dispatch_async(dispatch_get_main_queue(),^{
                                [[NSNotificationCenter defaultCenter]
                                 postNotificationName:@"syncCompleted"
                                 object:self];
                                sync(articleListArray,SUCESS_DATABASE_SYNC,1);
                                
                            });
                            
                        }
                    }
            }
        }
        if ([aryArticles count] <=0) {
            sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"syncCompleted"
                 object:self];
            });
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)savePages:(NSDictionary *)parameters
{
    @try{
        Globals *sharedManager = [Globals sharedManager];
        NSArray *aryPages;
        NSDictionary *dictPage;
        NSDictionary *result=[parameters objectForKey:@"result"];
        get_completion_block sync=[parameters objectForKey:@"sync"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *now = [NSDate date];
        NSString* myString = [dateFormat stringFromDate:now];
        NSDate *date = [dateFormat dateFromString:myString];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_ARTICLE_TIME_STAMP];
        NSMutableArray  *articleListArray=MArray;
        
        if([sharedManager isNotNull:[result objectForKey:@"data"]]){
            sharedManager.totalArticles=(int)[[result objectForKey:@"data"] count];
            aryPages = [result objectForKey:@"data"];
        }
        for (int i=0; i<[aryPages count]; i++) {
            
            //Parsing Article List
            Articles *tmpArticle=[[Articles alloc] init];
            if([sharedManager isNotNull:[aryPages objectAtIndex:i]])
            {
                dictPage = [aryPages objectAtIndex:i];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"_id"]])
                    tmpArticle.articlelId=[dictPage valueForKey:@"_id"];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"title"]])
                    tmpArticle.title=[dictPage valueForKey:@"title"];
                if([sharedManager isNotNull:[dictPage valueForKey:@"articleUri"]])
                    //  "articleUri": "http://www.tomorrow-people.com/about-us",
                    tmpArticle.articleUri=[dictPage valueForKey:@"articleUri"];
                //tmpArticle.articleUri=[dictPage valueForKey:@"articleUri"];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"summary"]])
                    tmpArticle.summary=[dictPage valueForKey:@"summary"];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"description"]])
                    tmpArticle.desc=[dictPage valueForKey:@"description"];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"channelId"]])
                    tmpArticle.channelId=[dictPage valueForKey:@"channelId"];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"uuid"]])
                    tmpArticle.uuid=[dictPage valueForKey:@"uuid"];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"clientId"]])
                    tmpArticle.clientId=[dictPage valueForKey:@"clientId"];
                
                if([sharedManager isNotNull:[dictPage valueForKey:@"__v"]])
                    tmpArticle.vv=[dictPage valueForKey:@"__v"];
                
                
                if([sharedManager isNotNull:[[dictPage  objectForKey:@"meta"]valueForKey:@"isActive"]])
                    // For Meta
                    tmpArticle.meta.isActive=[[[dictPage  objectForKey:@"meta"]valueForKey:@"isActive"] boolValue];
                
                if([sharedManager isNotNull:[[dictPage  objectForKey:@"meta"]valueForKey:@"createdAt"]])
                    tmpArticle.meta.createdAt=[[dictPage  objectForKey:@"meta"]valueForKey:@"createdAt"];
                
                if([sharedManager isNotNull:[[dictPage  objectForKey:@"meta"]valueForKey:@"updatedAt"]])
                    tmpArticle.meta.updatedAt=[[dictPage  objectForKey:@"meta"]valueForKey:@"updatedAt"];
                
                
                // For Topics
                if([[aryPages objectAtIndex:i ] objectForKey:@"topicId"] && ![[[aryPages objectAtIndex:i ] objectForKey:@"topicId"] isKindOfClass:[NSNull class]])
                {
                    if([sharedManager isNotNull:[[aryPages objectAtIndex:i ] objectForKey:@"topicId"]])
                        tmpArticle.topicId=[[aryPages objectAtIndex:i ] objectForKey:@"topicId"];
                }
                
                
                // For Adding Categories
                for (int x; x<[[[dictPage  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    
                    if([sharedManager isNotNull:[[[dictPage  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]])
                        [tmpArticle.meta.category addObject:[[[dictPage  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]];
                }
                // For Adding Tags
                for (int x; x<[[[dictPage  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
                    
                    if([sharedManager isNotNull:[[[dictPage  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]])
                        [tmpArticle.meta.category addObject:[[[dictPage  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]];
                }
                
                if([sharedManager isNotNull:[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"]])
                    // For Authors
                    tmpArticle.meta.author.name=[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"];
                
                if([sharedManager isNotNull:[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"]])
                    tmpArticle.meta.author.company=[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"];
                
                if([sharedManager isNotNull:[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"]])
                    tmpArticle.meta.author.blurb=[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"];
                
                if([sharedManager isNotNull:[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"]])
                    tmpArticle.meta.author.uuid=[[[dictPage  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"];
                
                // For Images
                if([sharedManager isNotNull:[[dictPage  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"]])
                    
                {
                    NSString *check=[[dictPage  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"thumbnail"];
                    
                }
                
                if([sharedManager isNotNull:[[dictPage  objectForKey:@"imageUrls"] valueForKey:@"phoneHero"]])
                {
                    NSString *check=[[dictPage  objectForKey:@"imageUrls"]valueForKey:@"phoneHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"phoneHero"];
                }
                if([sharedManager isNotNull:[[dictPage  objectForKey:@"imageUrls"] valueForKey:@"tabletHero"]])
                {
                    
                    NSString *check=[[dictPage  objectForKey:@"imageUrls"]valueForKey:@"tabletHero"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"tabletHero"];
                }
                
                // For Database Dictionary
                NSMutableDictionary *tmpDic=MDictionary;
                
                if([sharedManager isNotNull:tmpArticle.uuid])
                    [tmpDic setObject:tmpArticle.uuid forKey:@"uuid"];
                
                if([sharedManager isNotNull:tmpArticle.title])
                    [tmpDic setObject:tmpArticle.title forKey:@"title"];
                
                if([sharedManager isNotNull:tmpArticle.articleUri])
                    [tmpDic setObject:tmpArticle.articleUri forKey:@"articleUri"];
                
                if([sharedManager isNotNull:tmpArticle.summary])
                    [tmpDic setObject:tmpArticle.summary forKey:@"summary"];
                
                NSString *htmlString=[tmpArticle.desc stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                
                if([sharedManager isNotNull:htmlString])
                    [tmpDic setObject:htmlString forKey:@"desc"];
                
                if([sharedManager isNotNull:tmpArticle.channelId])
                    [tmpDic setObject:tmpArticle.channelId forKey:@"channelId"];
                
                if([sharedManager isNotNull:tmpArticle.clientId])
                    [tmpDic setObject:tmpArticle.clientId forKey:@"clientId"];
                
                if([sharedManager isNotNull:tmpArticle.topicId])
                    [tmpDic setObject:tmpArticle.topicId forKey:@"topicId"];
                
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dictPage  objectForKey:@"meta"]
                                                                   options:kNilOptions
                                                                     error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                if([sharedManager isNotNull:jsonString])
                    [tmpDic setObject:jsonString forKey:@"meta"];
                
                [tmpDic setObject:[NSString stringWithFormat:@"%d", tmpArticle.meta.isActive] forKey:@"isActive"];
                
                
                if([sharedManager isNotNull:[[dictPage  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"]])
                {
                    NSString *check=[[dictPage  objectForKey:@"imageUrls"] valueForKey:@"thumbnail"];
                    BOOL isURL = [[check lowercaseString] hasPrefix:@"https://"];
                    if(!isURL)
                        isURL = [[check lowercaseString] hasPrefix:@"http://"];
                    if ([check containsString:@"uploads/"])
                        isURL = FALSE;
                    
                    if (!isURL) {
                        //
                        check=[NSString stringWithFormat:@"%@%@",IMAGE_URL,check];
                    }
                    [tmpArticle.imageUrls setObject:check forKey:@"thumbnail"];
                    
                }
                
                
                NSData *data1 = [NSJSONSerialization dataWithJSONObject:tmpArticle.imageUrls
                                                                options:kNilOptions
                                                                  error:&error];
                
                NSString *jsonString1 = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                
                if([sharedManager isNotNull:jsonString1])
                    [tmpDic setObject:jsonString1 forKey:@"imageUrls"];
                
                if ([self.db insertArticles:tmpDic]) {
                    
                    sharedManager.tmpArticleCount=sharedManager.tmpArticleCount +  1;
                    if(sharedManager.tmpArticleCount == sharedManager.totalArticles)
                    {
                        sharedManager.tmpArticleCount=0;
                        if(sync)
                        {
                        }
                        else{
                        }
                        sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                            [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"syncCompleted"
                             object:self];
                        });
                        
                    }
                }
                else{
                    sharedManager.tmpArticleCount=sharedManager.tmpArticleCount +  1;
                }
                [sharedManager.articleArray addObject:tmpArticle];
                [articleListArray addObject:tmpArticle];
            }
        }
        if ([aryPages count] <=0) {
            sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"syncCompleted"
                 object:self];
            });
            
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)isSyncCompleted:(get_completion_block)sync
{
    @try{
        Globals *sharedManager=[Globals sharedManager];
        if ([sharedManager.updatedChannelArray count] == 0) {
            if (self.channelSyncCount == [sharedManager.channelArray count]) {
                [sharedManager hideLoader];
                //
                if(sync)
                {
                    sync(nil,SUCESS_DATABASE_SYNC,1);
                }
            }
            
        }
        else{
            if (self.channelSyncCount == [sharedManager.updatedChannelArray count]) {
                [sharedManager hideLoader];
                //
                if(sync)
                {
                    sync(nil,SUCESS_DATABASE_SYNC,1);
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}

-(void)fillPages:(sync_completion_block)sync{
    @try{
        
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *date;
        BOOL isDate=false;
        //Keys
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNEL_TIME_STAMP]) {
            NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNEL_TIME_STAMP];
            NSString* myString = [dateFormat stringFromDate:now];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormat setTimeZone:timeZone];
            date = [dateFormat dateFromString:myString];
            isDate = true;
        }
        // Checking for New Content -- First Time install
        NSArray *pages=[sharedManager.db selectAllQueryWithTableName:@"pages"];
        if([pages count]<=0)
        {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_sync(concurrentQueue, ^{
                [sharedManager.pages getAllPages:^(NSDictionary *results, NSString *str, int status){
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                    [dateFormat setTimeZone:timeZone];
                    NSDate *now = [NSDate date];
                    NSString* myString = [dateFormat stringFromDate:now];
                    NSDate *date = [dateFormat dateFromString:myString];
                    [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_CHANNEL_TIME_STAMP];
                    if(status==1)
                    {
                        self.check=true;
                        if([[results valueForKey:@"success"]integerValue]==1){
                            NSArray *aryResult;
                            if([sharedManager isNotNull:[results objectForKey:@"data"]])
                                aryResult=[results objectForKey:@"data"];
                            NSDictionary *dictPage;
                            NSMutableArray *pagesArray=[[NSMutableArray alloc] init];
                            for (int i=0; i<[aryResult count]; i++) {
                                Pages  *page=[[Pages alloc] init];
                                
                                if([sharedManager isNotNull:[aryResult objectAtIndex:i]])
                                    dictPage = [aryResult objectAtIndex:i];
                                
                                if([sharedManager isNotNull:[dictPage valueForKey:@"_id"]])
                                    page.pageId=[dictPage valueForKey:@"_id"];
                                
                                if([sharedManager isNotNull:[dictPage valueForKey:@"description"]])
                                    page.desc=[dictPage valueForKey:@"description"];
                                
                                if([sharedManager isNotNull:[dictPage valueForKey:@"summary"]])
                                    page.summary=[dictPage valueForKey:@"summary" ];
                                
                                NSString *typePage=@"";
                                if([sharedManager isNotNull:[dictPage valueForKey:@"pageType"]])
                                    typePage=[dictPage valueForKey:@"pageType"];
                                
                                if ([typePage isEqualToString:@"about-us"]) {
                                    page.pageType=(type)AboutUs;
                                }
                                else if ([typePage isEqualToString:@"policy-privacy"]) {
                                    page.pageType=(type)PrivacyPolicy;
                                }
                                else if ([typePage isEqualToString:@"Legal"]) {
                                    page.pageType=(type)Legal;
                                }
                                else if ([typePage isEqualToString:@"policy-cookie"]) {
                                    page.pageType=(type)Cookies;
                                }
                                else if ([typePage isEqualToString:@"terms-of-use"]) {
                                    page.pageType=(type)Terms;
                                }
                                
                                if([sharedManager isNotNull:[dictPage valueForKey:@"title"]])
                                    page.title=[dictPage valueForKey:@"title"];
                                
                                if([sharedManager isNotNull:[dictPage valueForKey:@"clientId"]])
                                    page.clientId=[dictPage valueForKey:@"clientId"];
                                
                                if([sharedManager isNotNull:[dictPage valueForKey:@"uuid"]])
                                    page.uuid=[dictPage valueForKey:@"uuid"];
                                
                                page.meta=[[Meta alloc] init];
                                page.meta.author=[[Authors alloc] init];
                                
                                if([sharedManager isNotNull:[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"blurb"]])
                                    page.meta.author.blurb=[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"blurb"];
                                
                                if([sharedManager isNotNull:[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"company"]])
                                    page.meta.author.company=[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"company"];
                                
                                if([sharedManager isNotNull:[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"name"]])
                                    page.meta.author.name=[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"name"];
                                
                                if([sharedManager isNotNull:[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"uuid"]])
                                    page.meta.author.uuid=[[[dictPage objectForKey:@"meta" ] objectForKey:@"author"] valueForKey:@"uuid"];
                                
                                if([sharedManager isNotNull:[[dictPage objectForKey:@"meta" ] valueForKey:@"createdAt"]])
                                    page.meta.createdAt=[[dictPage objectForKey:@"meta" ] valueForKey:@"createdAt"];
                                
                                if([sharedManager isNotNull:[[dictPage objectForKey:@"meta" ] valueForKey:@"isActive"]])
                                    page.meta.isActive=[[dictPage objectForKey:@"meta" ] valueForKey:@"isActive"];
                                
                                if([sharedManager isNotNull:[[dictPage objectForKey:@"meta" ] valueForKey:@"tags"]])
                                    page.meta.tags=[[dictPage objectForKey:@"meta" ] objectForKey:@"tags"];
                                
                                if([sharedManager isNotNull:[[dictPage objectForKey:@"meta" ] valueForKey:@"updatedAt"]])
                                    page.meta.updatedAt=[[dictPage objectForKey:@"meta" ] objectForKey:@"updatedAt"];
                                [pagesArray addObject:page];
                                
                                // For Database Insert
                                NSMutableDictionary *tmpDic=MDictionary;
                                
                                if([sharedManager isNotNull:page.pageId])
                                    [tmpDic setObject:page.pageId forKey:@"pageId"];
                                
                                if([sharedManager isNotNull:page.summary])
                                    [tmpDic setObject:page.summary forKey:@"summary"];
                                
                                NSString *htmlString=[page.desc stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                                
                                if([sharedManager isNotNull:htmlString])
                                    [tmpDic setObject:htmlString forKey:@"desc"];
                                
                                [tmpDic setObject:[NSString stringWithFormat:@"%d", page.meta.isActive] forKey:@"isActive"];
                                
                                if([sharedManager isNotNull:typePage])
                                    [tmpDic setObject:typePage  forKey:@"pageType"];
                                
                                if([sharedManager isNotNull:page.title])
                                    [tmpDic setObject:page.title forKey:@"title"];
                                
                                if([sharedManager isNotNull:page.clientId])
                                    [tmpDic setObject:page.clientId forKey:@"clientId"];
                                
                                if([sharedManager isNotNull:page.uuid])
                                    [tmpDic setObject:page.uuid forKey:@"uuid"];
                                NSError *error;
                                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dictPage  objectForKey:@"meta"]
                                                                                   options:kNilOptions
                                                                                     error:&error];
                                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                
                                
                                if([sharedManager isNotNull:jsonString])
                                    [tmpDic setObject:jsonString forKey:@"meta"];
                                
                                NSMutableArray *pages=[[NSMutableArray alloc] initWithArray:[[Pages parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"pages"]] mutableCopy]];
                                
                                for (int i=0; i<[pages count]; i++) {
                                    //
                                    if([[[pages objectAtIndex:i] uuid] isEqualToString:page.uuid] )
                                    {
                                        
                                    }
                                }
                                if(page.meta.isActive)
                                {
                                    [self.db insertQueryWithDictionary:tmpDic inTable:@"pages"];
                                }
                                
                                if (i + 1 == [aryResult count]) {
                                    if (sync) {
                                        sync(SUCESS_DATABASE_SYNC,1);
                                    }
                                }
                                
                            }
                            if ([aryResult count]<=0) {
                                if (sync) {
                                    sync(SUCESS_DATABASE_SYNC,1);
                                }
                            }
                        }
                        else{
                        }
                    }
                    else{
                        sync(ERROR_CHANNEL_LIST,1);
                    }
                }];
            });
        }
        // Checking for Updated Content -- Second time login or Pull to refresh
        else{
            
            [sharedManager.channel getChannelsWithTimeStamp:date andCompletion:^(NSDictionary *results, NSString *str, int status){
                Globals *sharedManager=[Globals sharedManager];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                [dateFormat setTimeZone:timeZone];
                NSDate *now = [NSDate date];
                NSString* myString = [dateFormat stringFromDate:now];
                NSDate *date = [dateFormat dateFromString:myString];
                [[NSUserDefaults standardUserDefaults] setObject:date forKey:KEY_CHANNEL_TIME_STAMP];
                if(status==1)
                {
                    NSArray *aryResult;
                    NSDictionary *dicPages;
                    if([sharedManager isNotNull:[results objectForKey:@"data"]])
                        aryResult=[results objectForKey:@"data"];
                    if ([aryResult count]==0) {
                        if (sync) {
                            sync(SUCESS_DATABASE_SYNC,1);
                        }
                    }
                    for (int i=0; i<[aryResult count]; i++) {
                        Pages  *page=[[Pages alloc] init];
                        
                        if([sharedManager isNotNull:[aryResult objectAtIndex:i]])
                            dicPages = [aryResult objectAtIndex:i];
                        
                        if([sharedManager isNotNull:[dicPages valueForKey:@"_id"]])
                            page.pageId=[dicPages valueForKey:@"_id"];
                        
                        if([sharedManager isNotNull:[dicPages valueForKey:@"description"]])
                            page.desc=[dicPages valueForKey:@"description"];
                        
                        if([sharedManager isNotNull:[dicPages valueForKey:@"summary"]])
                            page.summary=[dicPages valueForKey:@"summary" ];
                        
                        NSString *typePage=@"";
                        if([sharedManager isNotNull:[dicPages valueForKey:@"pageType"]])
                            typePage=[dicPages valueForKey:@"pageType"];
                        if ([typePage isEqualToString:@"about-us"]) {
                            page.pageType=(type)AboutUs;
                        }
                        else if ([typePage isEqualToString:@"policy-privacy"]) {
                            page.pageType=(type)PrivacyPolicy;
                        }
                        else if ([typePage isEqualToString:@"Legal"]) {
                            page.pageType=(type)Legal;
                        }
                        else if ([typePage isEqualToString:@"policy-cookie"]) {
                            page.pageType=(type)Cookies;
                        }
                        else if ([typePage isEqualToString:@"terms-of-use"]) {
                            page.pageType=(type)Terms;
                        }
                        
                        if([sharedManager isNotNull:[dicPages valueForKey:@"title"]])
                            page.title=[dicPages valueForKey:@"title"];
                        
                        if([sharedManager isNotNull:[dicPages valueForKey:@"clientId"]])
                            page.clientId=[dicPages valueForKey:@"clientId"];
                        
                        if([sharedManager isNotNull:[dicPages valueForKey:@"uuid"]])
                            page.uuid=[dicPages valueForKey:@"uuid"];
                        
                        
                        self.check=true;
                        // For Database Insert
                        NSMutableDictionary *tmpDic=MDictionary;
                        
                        if([sharedManager isNotNull:[dicPages valueForKey:@"pageId"]])
                            [tmpDic setObject:page.pageId forKey:@"pageId"];
                        if([sharedManager isNotNull:page.summary])
                            [tmpDic setObject:page.summary forKey:@"summary"];
                        
                        NSString *htmlString=[page.desc stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        
                        if([sharedManager isNotNull:htmlString])
                            [tmpDic setObject:htmlString forKey:@"desc"];
                        
                        if([sharedManager isNotNull:typePage])
                        {
                            [tmpDic setObject:typePage  forKey:@"pageType"];
                        }
                        if([sharedManager isNotNull:page.title])
                        {
                            [tmpDic setObject:page.title forKey:@"title"];
                        }
                        if([sharedManager isNotNull:page.clientId])
                        {
                            [tmpDic setObject:page.clientId forKey:@"clientId"];
                        }
                        if([sharedManager isNotNull:page.uuid])
                        {
                            [tmpDic setObject:page.uuid forKey:@"uuid"];
                        }
                        NSError *error;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dicPages  objectForKey:@"meta"]
                                                                           options:kNilOptions
                                                                             error:&error];
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        [tmpDic setObject:[NSString stringWithFormat:@"%d", page.meta.isActive] forKey:@"isActive"];
                        
                        if([sharedManager isNotNull:jsonString])
                            [tmpDic setObject:jsonString forKey:@"meta"];
                        NSMutableArray *pages=[[NSMutableArray alloc] initWithArray:[[Channels parseArrayToObjectsWithArray: [self.db selectAllQueryWithTableName:@"pages"]] mutableCopy]];
                        
                        for (int i=0; i<[pages count]; i++) {
                            //
                            if([[[pages objectAtIndex:i] uuid] isEqualToString:page.uuid])
                            {
                                
                            }
                        }
                        if(page.meta.isActive)
                        {
                            [self.db insertQueryWithDictionary:tmpDic inTable:@"pages"];
                        }
                        
                        if (i + 1 == [aryResult count]) {
                            if (sync) {
                                sync(SUCESS_DATABASE_SYNC,1);
                            }
                        }
                    }
                    
                }
                else{
                    sync(ERROR_ARTICLE_LIST,1);
                }
            }];
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)fillArticlesWithCompletionBlock:(get_completion_block)sync{
    @try{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        
        sharedManager.tmpArticleCount=0;
        sharedManager.tmpBlogCount=0;
        sharedManager.tmpVideoCount=0;
        NSArray *allControllersCopy = [[SlideNavigationController sharedInstance] viewControllers];
        
        for (id object in allControllersCopy) {
            if ([object isKindOfClass:[DashboardVC class]])
                sharedManager.syncCompleted=sync;
        }
        self.channelSyncCount=0;
        // Checking if we have updated Data
        __block int trackVideoArticleBlogCount=0;
        [self getAllChannelsWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
            
            if([result count]>0){
                
                sharedManager.totalArticles=0;
                
                [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                    [dateFormat setTimeZone:timeZone];
                    NSDate *date,*blogDate,*videoDate;
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP]) {
                        NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP];
                        NSString* myString = [dateFormat stringFromDate:now];
                        date = [dateFormat dateFromString:myString];
                        blogDate= [dateFormat dateFromString:myString];
                        videoDate = [dateFormat dateFromString:myString];
                    }
                    
                    if(sharedManager.isAllAticleReceived && sharedManager.isAllBlogsReceived && sharedManager.isAllVideoReceived)
                    {
                        [sharedManager hideLoader];
                    }
                    Channels *objChannels = (Channels *)obj;
//                    if(!([objChannels.channelsCountForFilter integerValue]==result.count)){
//                    if(sharedManager.isAllAticleReceived==NO){
                        // Checking if channel is of Articles
                        if ([[objChannels valueForKey:@"type"] isEqualToString:@"Articles"]) {
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_sync(concurrentQueue, ^{
                                [sharedManager.article getArticlesWithChannelId:[NSString stringWithFormat:@"%@",[objChannels valueForKey:@"uuid"]]:^(NSDictionary *result, NSString *str, int status) {
                                    
                                    if(sharedManager.intOffset==5)
                                        sharedManager.totalArticleCount =  [[NSString stringWithFormat:@"%@",[result valueForKey:@"count"]] intValue];
                                    NSArray *aryArticless;
                                    
                                    if([sharedManager isNotNull:[result valueForKey:@"data"]])
                                        aryArticless = [result valueForKey:@"data"];
                                    
                                    if(aryArticless.count>0)
                                    {
                                        
                                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                        
                                        [sharedManager.dictChannelDataCount setObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"count"]] forKey:[objChannels valueForKey:@"uuid"]];
                                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                        dispatch_sync(concurrentQueue, ^{
                                            [self saveArticles:tempDic];
                                        });
                                    }
                                    else{
                                        trackVideoArticleBlogCount++;
                                        //                                        [self.db deleteQueryWithTable:@"channels" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'", [result valueForKey:@"uuid"]]];
//                                        int count = [objChannels.channelsCountForFilter intValue];
//                                        objChannels.channelsCountForFilter= [[NSString stringWithFormat:@"%d",count++] mutableCopy];
                                        sharedManager.isAllAticleReceived=true;
                                        
                                        sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                                        if(sharedManager.isAllBlogsReceived==true && sharedManager.isAllVideoReceived==true  && sharedManager.isAllAticleReceived==true)
                                            
                                            
                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                                                [[NSNotificationCenter defaultCenter]
                                                 postNotificationName:@"syncCompleted"
                                                 object:self];
                                            });
                                    }
                                    
                                }];
                            });
                        }
//                    }
                    
                    
//                    if(sharedManager.isAllBlogsReceived==NO){
                    
                        // Checking if channel is of Blogs
                        if ([[objChannels valueForKey:@"type"] isEqualToString:@"Blog"]) {
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_sync(concurrentQueue, ^{
                                [sharedManager.blogs getBlogsWithChannelId:[NSString stringWithFormat:@"%@",[objChannels valueForKey:@"uuid"]] :^(NSDictionary *result, NSString *str, int status) {
                                    NSArray *aryBlogs;
                                    
                                    if([sharedManager isNotNull:[result valueForKey:@"data"]])
                                        aryBlogs = [result valueForKey:@"data"];
                                    
                                    if(aryBlogs.count>0)
                                    {
                                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                        
                                        [sharedManager.dictChannelDataCount setObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"count"]] forKey:[objChannels valueForKey:@"uuid"]];
                                        
                                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                        dispatch_sync(concurrentQueue, ^{
                                            [self saveBlogs:tempDic];
                                        });
                                    }
                                    else{
//                                        int count = [objChannels.channelsCountForFilter intValue];
//                                        objChannels.channelsCountForFilter= [[NSString stringWithFormat:@"%d",count++] mutableCopy];
                                        trackVideoArticleBlogCount++;

                                        sharedManager.isAllBlogsReceived=true;
                                        sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                                        if(sharedManager.isAllBlogsReceived==true && sharedManager.isAllVideoReceived==true  && sharedManager.isAllAticleReceived==true)
                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                                                [[NSNotificationCenter defaultCenter]
                                                 postNotificationName:@"syncCompleted"
                                                 object:self];
                                            });
                                        
                                        
                                    }
                                }];
                            });
                        }
//                    }
//                    if(sharedManager.isAllVideoReceived==NO){
                        // Checking if channel is of Video
                        if ([[objChannels valueForKey:@"type"] isEqualToString:@"Video"]) {
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_sync(concurrentQueue, ^{                                [sharedManager.videos getVideoWithChannelId:[NSString stringWithFormat:@"%@",[objChannels valueForKey:@"uuid"]]:^(NSDictionary *result, NSString *str, int status) {
                                    NSArray *aryVideos;
                                    
                                    if([sharedManager isNotNull:[result valueForKey:@"data"]])
                                        aryVideos = [result valueForKey:@"data"];
                                    
                                    if(aryVideos.count>0)
                                    {
                                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                        
                                        [sharedManager.dictChannelDataCount setObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"count"]] forKey:[NSString stringWithFormat:@"%@",[objChannels valueForKey:@"uuid"]]];
                                        
                                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                        dispatch_sync(concurrentQueue, ^{
                                            [self saveVideos:tempDic];
                                        });
                                        
                                    }
                                    else{
//                                        int count = [objChannels.channelsCountForFilter intValue];
//                                        objChannels.channelsCountForFilter= [[NSString stringWithFormat:@"%d",count++] mutableCopy];
                                        trackVideoArticleBlogCount++;

                                        sharedManager.isAllVideoReceived=true;
                                        
                                        sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                                        if(sharedManager.isAllBlogsReceived==true && sharedManager.isAllVideoReceived==true  && sharedManager.isAllAticleReceived==true)
                                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                                                [[NSNotificationCenter defaultCenter]
                                                 postNotificationName:@"syncCompleted"
                                                 object:self];
                                            });
                                        
                                    }
                                }];
                            });
                            
                        }
                    if(trackVideoArticleBlogCount>=3){
                        sharedManager.isAllAticleReceived = true;
                        sharedManager.isAllBlogsReceived  = true;
                        sharedManager.isAllVideoReceived = true;
                    }
//                    }
//                    }
                }];
            }
            else{
                [sharedManager hideLoader];
            }
        }];
    }
    @catch (NSException *exception) {
        
    }
}

-(void)fillAllUpdatedChannelsData:(get_completion_block)sync
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    sharedManager.tmpArticleCount=0;
    sharedManager.tmpBlogCount=0;
    sharedManager.tmpVideoCount=0;
    NSArray *allControllersCopy = [[SlideNavigationController sharedInstance] viewControllers];
    
    for (id object in allControllersCopy) {
        if ([object isKindOfClass:[DashboardVC class]])
            sharedManager.syncCompleted=sync;
    }
    self.channelSyncCount=0;
    sharedManager.totalArticles=0;
    [sharedManager hideLoader];
    NSArray *aryChannels = [Channels parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"channels"]];
    __block BOOL isReceivedData = false;
    
    for (int i=0; i<[aryChannels count]; i++) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDateFormatter *dateFormatterForGettingDate = [[NSDateFormatter alloc] init];
        [dateFormatterForGettingDate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatterForGettingDate setTimeZone:timeZone];
        NSDate *date;
        NSDate *blogDate,*videoDate;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP]) {
            NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP];
            NSString* myString = [dateFormat stringFromDate:now];
            date = [dateFormat dateFromString:myString];
            blogDate= [dateFormat dateFromString:myString];
            videoDate = [dateFormat dateFromString:myString];
        }
        sharedManager.updatedChannelArray=MArray;

        //   Checking if the channel is of Articles
        [sharedManager.article getArticlesWithChannelId:[[aryChannels objectAtIndex:i] uuid] andTimeStamp:date withCompletion:^(NSDictionary *result, NSString *str, int status) {
            NSArray *aryData = [result valueForKey:@"data"];
            if (aryData.count>0) {
                isReceivedData=true;
                NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                [sharedManager.dictChannelDataCount setObject:[result valueForKey:@"count"] forKey:[[aryChannels objectAtIndex:i] uuid]];
                
                NSArray *aryUpdatedArticles =  [result valueForKey:@"data"];
                [aryUpdatedArticles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSDictionary *dict = (NSDictionary*)obj;
                    if ([self.db deleteQueryWithTable:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'", [dict valueForKey:@"uuid"]]] ) {
                        [sharedManager.updatedChannelArray addObject:dict];
                        
                        
                    }
                }];
                
                [self saveArticles:tempDic];
            }
            
        }];
        
        [sharedManager.blogs getBlogsWithChannelId:[[aryChannels objectAtIndex:i] uuid] andTimeStamp:blogDate withCompletion:^(NSDictionary *result, NSString *str, int status) {
            NSArray *aryData = [result valueForKey:@"data"];
            
            if (aryData.count>0) {
                isReceivedData=true;
                
                NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                [sharedManager.dictChannelDataCount setObject:[result valueForKey:@"count"] forKey:[[aryChannels objectAtIndex:i] uuid]];
                
                NSArray *aryUpdatedArticles =  [result valueForKey:@"data"];
                [aryUpdatedArticles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSDictionary *dict = (NSDictionary*)obj;
                    if ([self.db deleteQueryWithTable:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'", [dict valueForKey:@"uuid"]]] ) {
                        [sharedManager.updatedChannelArray addObject:dict];
                        
                    }
                }];
                [self saveBlogs:tempDic];
            }
            
        }];
        
        
        //  Checking if the channel is of Video
        [sharedManager.videos getVideoWithChannelId:[[aryChannels objectAtIndex:i] uuid] andTimeStamp:blogDate withCompletion:^(NSDictionary *result, NSString *str, int status) {
            
            NSArray *aryData = [result valueForKey:@"data"];
            if (aryData.count>0) {
                isReceivedData=true;
                
                NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                [sharedManager.dictChannelDataCount setObject:[result valueForKey:@"count"] forKey:[[aryChannels objectAtIndex:i] uuid]];
                
                [aryData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSDictionary *dict = (NSDictionary*)obj;
                    if ([self.db deleteQueryWithTable:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'", [dict valueForKey:@"uuid"]]] ) {
                        [sharedManager.updatedChannelArray addObject:dict];
                    }
                }];
                [self saveVideos:tempDic];
                
            }
            
        }];
        
    }
    
//    sharedManager.isAllAticleReceived=true;
//    sharedManager.isAllBlogsReceived=true;
//    sharedManager.isAllVideoReceived=true;
    
    sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"syncCompleted"
     object:self];
    sync(sharedManager.updatedChannelArray,SUCESS_DATABASE_SYNC,1);
    
    
    
}

-(void)fillArticlesWithCompletionBlock1:(get_completion_block)sync{
    
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    sharedManager.tmpArticleCount=0;
    sharedManager.tmpBlogCount=0;
    sharedManager.tmpVideoCount=0;
    sharedManager.syncCompleted=sync;
    self.channelSyncCount=0;
    // Use NSPOOL for memory
    // Checking if there are any updated channels than fetch only updated channels
    if ([sharedManager.updatedChannelArray count] > 0) {
        
        sharedManager.totalArticles=0;
        
        for (int i=0; i<[sharedManager.updatedChannelArray count]; i++) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDateFormatter *dateFormatterForGettingDate = [[NSDateFormatter alloc] init];
            [dateFormatterForGettingDate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
            [dateFormatterForGettingDate setTimeZone:timeZone];
            //NSDate *date = [dateFormat dateFromString:@"2015-10-10T14:16:56.643Z"];
            NSDate *date;
            NSDate *blogDate,*videoDate;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP]) {
                NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP];
                NSString* myString = [dateFormat stringFromDate:now];
                
                date = [dateFormat dateFromString:myString];
                blogDate= [dateFormat dateFromString:myString];
                videoDate = [dateFormat dateFromString:myString];
            }
            
            NSArray *article=[sharedManager.db selectAllQueryWithTableName:@"articles"];
            NSArray *blogs=[sharedManager.db selectAllQueryWithTableName:@"blogs"];
            NSArray *videos=[sharedManager.db selectAllQueryWithTableName:@"videos"];
            
            // Checking for articles if there are articles already in the local db
            if ([article count]<=0) {
                if ([[(Channels *)[sharedManager.updatedChannelArray objectAtIndex:i] type] isEqualToString:@"Articles"]) {
                    [sharedManager.article getArticlesWithChannelId:[[sharedManager.updatedChannelArray objectAtIndex:i] uuid] :^(NSDictionary *result, NSString *str, int status) {
                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                        
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_sync(concurrentQueue, ^{
                            [self saveArticles:tempDic];
                        });
                        
                    }];
                }
            }
            else{
                if ([[(Channels *)[sharedManager.updatedChannelArray objectAtIndex:i] type] isEqualToString:@"Articles"]) {
                    [sharedManager.article getArticlesWithChannelId:[[sharedManager.updatedChannelArray objectAtIndex:i] uuid] andTimeStamp:date withCompletion:^(NSDictionary *result, NSString *str, int status) {
                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_sync(concurrentQueue, ^{
                            [self saveArticles:tempDic];
                        });
                        
                    }];
                }
            }
            
            
            // Checking for Blogs if there are articles already in the local db
            
            if([blogs count]<=0)
            {
                if ([[(Channels *)[sharedManager.updatedChannelArray objectAtIndex:i] type] isEqualToString:@"Blog"]) {
                    [sharedManager.blogs getBlogsWithChannelId:[[sharedManager.updatedChannelArray objectAtIndex:i] uuid] :^(NSDictionary *result, NSString *str, int status) {
                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_sync(concurrentQueue, ^{
                            [self saveBlogs:tempDic];
                        });
                        
                    }];
                    
                }
            }
            else{
                if ([[(Channels *)[sharedManager.updatedChannelArray objectAtIndex:i] type] isEqualToString:@"Blog"]) {
                    [sharedManager.blogs getBlogsWithChannelId:[[sharedManager.updatedChannelArray objectAtIndex:i] uuid] andTimeStamp:blogDate withCompletion :^(NSDictionary *result, NSString *str, int status) {
                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_sync(concurrentQueue, ^{
                            [self saveBlogs:tempDic];
                        });
                        
                    }];
                    
                }
                
            }
            
            
            //  Checking for Videos if there are videos already in the local db
            
            if([videos count]<=0)
            {
                if ([[(Channels *)[sharedManager.updatedChannelArray objectAtIndex:i] type] isEqualToString:@"Video"]) {
                    [sharedManager.videos getVideoWithChannelId:[[sharedManager.updatedChannelArray objectAtIndex:i] uuid] :^(NSDictionary *result, NSString *str, int status) {
                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_sync(concurrentQueue, ^{
                            [self saveVideos:tempDic];
                        });
                        
                        
                    }];
                    
                }
            }
            else{
                if ([[(Channels *)[sharedManager.updatedChannelArray objectAtIndex:i] type] isEqualToString:@"Video"]) {
                    [sharedManager.videos getVideoWithChannelId:[[sharedManager.updatedChannelArray objectAtIndex:i] uuid] andTimeStamp:blogDate withCompletion :^(NSDictionary *result, NSString *str, int status) {
                        NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_sync(concurrentQueue, ^{
                            [self saveVideos:tempDic];
                        });
                        
                    }];
                    
                }
                
            }
            
            
        }
    }
    // Checking if there are any updated channels than fetch only updated channels
    else{
        [self getAllChannelsWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
            //
            if([result count]>0){
                sharedManager.totalArticles=0;
                
                for (int i=0; i<[result count]; i++) {
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
                    [dateFormat setTimeZone:timeZone];
                    NSDate *date,*blogDate,*videoDate;
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP]) {
                        NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ARTICLE_TIME_STAMP];
                        NSString* myString = [dateFormat stringFromDate:now];
                        date = [dateFormat dateFromString:myString];
                    }
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_BLOG_TIME_STAMP]) {
                        NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BLOG_TIME_STAMP];
                        NSString* myString = [dateFormat stringFromDate:now];
                        blogDate = [dateFormat dateFromString:myString];
                    }
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_VIDEO_TIME_STAMP]) {
                        NSDate *now = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_VIDEO_TIME_STAMP];
                        NSString* myString = [dateFormat stringFromDate:now];
                        videoDate = [dateFormat dateFromString:myString];
                    }
                    NSArray *article=[sharedManager.db selectAllQueryWithTableName:@"articles"];
                    NSArray *blogs=[sharedManager.db selectAllQueryWithTableName:@"blogs"];
                    NSArray *videos=[sharedManager.db selectAllQueryWithTableName:@"videos"];
                    
                    // Checking if we have articles locally in DB
                    if([article count]<=0 )
                    {
                        if ([[(Channels *)[sharedManager.channelArray objectAtIndex:i] type] isEqualToString:@"Articles"]) {
                            
                            [sharedManager.article getArticlesWithChannelId:[[sharedManager.channelArray objectAtIndex:i] uuid] :^(NSDictionary *result, NSString *str, int status) {
                                if (result) {
                                    NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                    dispatch_sync(concurrentQueue, ^{
                                        [self saveArticles:tempDic];
                                    });
                                }
                                else{
                                    sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"syncCompleted"
                                         object:self];
                                    });
                                    
                                }
                                
                            }];
                        }
                        
                    }
                    else{
                        
                        if ([[(Channels *)[sharedManager.channelArray objectAtIndex:i] type] isEqualToString:@"Articles"]) {
                            [sharedManager.article getArticlesWithChannelId:[[sharedManager.channelArray objectAtIndex:i] uuid] andTimeStamp:date withCompletion:^(NSDictionary *result, NSString *str, int status) {
                                NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                dispatch_sync(concurrentQueue, ^{
                                    [self saveArticles:tempDic];
                                });
                                
                            }];
                        }
                        
                    }
                    
                    
                    // Checking if We have any blogs in local DB
                    if([blogs count]<=0 )
                    {
                        if ([[(Channels *)[sharedManager.channelArray objectAtIndex:i] type] isEqualToString:@"Blog"]) {
                            [sharedManager.blogs getBlogsWithChannelId:[[sharedManager.channelArray objectAtIndex:i] uuid]  :^(NSDictionary *result, NSString *str, int status) {
                                if (result) {
                                    NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                    dispatch_sync(concurrentQueue, ^{
                                        [self saveBlogs:tempDic];
                                    });
                                }
                                else{
                                    sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"syncCompleted"
                                         object:self];
                                    });
                                }
                            }];
                        }
                    }
                    else{
                        if ([[(Channels *)[sharedManager.channelArray objectAtIndex:i] type] isEqualToString:@"Blog"]) {
                            [sharedManager.blogs getBlogsWithChannelId:[[sharedManager.channelArray objectAtIndex:i] uuid] andTimeStamp:blogDate withCompletion :^(NSDictionary *result, NSString *str, int status) {
                                NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                dispatch_sync(concurrentQueue, ^{
                                    [self saveBlogs:tempDic];
                                });
                                
                            }];
                            
                        }
                        
                    }
                    
                    
                    if ([videos count]<=0) {
                        if ([[(Channels *)[sharedManager.channelArray objectAtIndex:i] type] isEqualToString:@"Video"]) {
                            
                            [sharedManager.videos getVideoWithChannelId:[[sharedManager.channelArray objectAtIndex:i] uuid]  :^(NSDictionary *result, NSString *str, int status) {
                                if(result)
                                {
                                    NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                    
                                    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                    dispatch_sync(concurrentQueue, ^{
                                        [self saveVideos:tempDic];
                                    });
                                    
                                }
                                else{
                                    sharedManager.channelSyncCount =sharedManager.channelSyncCount +1;
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"syncCompleted"
                                         object:self];
                                    });
                                    
                                    
                                }
                                
                                
                            }];
                            
                        }
                    }
                    else{
                        if ([[(Channels *)[sharedManager.channelArray objectAtIndex:i] type] isEqualToString:@"Video"]) {
                            [sharedManager.videos getVideoWithChannelId:[[sharedManager.channelArray objectAtIndex:i] uuid] andTimeStamp:videoDate withCompletion :^(NSDictionary *result, NSString *str, int status) {
                                NSDictionary *tempDic=[[NSDictionary alloc] initWithObjects:@[result,sync] forKeys:@[@"result",@"sync"]];
                                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                dispatch_sync(concurrentQueue, ^{
                                    [self saveVideos:tempDic];
                                });
                                
                            }];
                            
                        }
                    }
                    
                }
            }
            else{
                [sharedManager hideLoader];
            }
        }];
    }
}

-(void)fillBlogsWithCompletionBlock:(get_completion_block)sync{
}

#pragma mark Database Retrival
// For Getting Data from Database
-(NSString *)isNullOrEmpty:(NSString *)inString
{
    NSString *strText = @"";
    if ([inString isKindOfClass:[NSNull class]]) {
        return strText;
    }
    if (inString == nil || inString == (id)[NSNull null]||[inString isEqualToString:@""] || [inString isEqualToString:@"<null>"] || [inString isEqualToString:@"(null)"] || [inString isEqualToString:@"(null) (null)"]) {
        // nil branch
        return strText;
    } else {
        return inString;
    }
    return nil;
}

-(void)getAllChannelsWithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.channelArray=[Channels parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"channels"]];
    if (sync) {
        sync([self.db selectAllQueryWithTableName:@"channels"],SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getAllPagesWithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.pagesArray=[Pages parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"pages"]];
    if (sync) {
        sync([Pages parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"pages"]],SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getMenuChannelsWithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.channelArray=[Channels parseArrayToObjectsWithArray:[self.db selectAllFilledChannelsWithTableName]];
    if (sync) {
        sync([self.db selectAllFilledChannelsWithTableName],SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getUpdatedChannels:(NSArray *)channels WithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.channelArray=[Channels parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"channels"]];
    if (sync) {
        NSMutableString *tempString=[[NSMutableString alloc] init];
        for (int i=0; i<[channels count]; i++) {
            [tempString appendString:[NSString stringWithFormat:@"%@,",[channels objectAtIndex:i] ]];
        }
        sync([self.db selectWhereQueryWithTableName:@"channels" andWithWhereCondition:[NSString stringWithFormat: @"channelId in ('%@')",tempString ] withOrderbyID:YES ],SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getUpdatedBlogs:(NSArray *)blogs WithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.blogsArray=[Blogs parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"blogs"]];
    if (sync) {
        NSMutableString *tempString=[[NSMutableString alloc] init];
        for (int i=0; i<[blogs count]; i++) {
            [tempString appendString:[NSString stringWithFormat:@"%@,",[blogs objectAtIndex:i] ]];
        }
        sync([self.db selectWhereQueryWithTableName:@"blogs" andWithWhereCondition:[NSString stringWithFormat: @"blogId in ('%@')",tempString ] withOrderbyID:YES ],SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getUpdatedArticles:(NSArray *)articles WithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.articleArray=[Articles parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"articles"]];
    if (sync) {
        NSMutableString *tempString=[[NSMutableString alloc] init];
        for (int i=0; i<[articles count]; i++) {
            
            if (i+1 == [articles count]) {
                [tempString appendString:[NSString stringWithFormat:@"%@",[[articles objectAtIndex:i] channelId] ]];
            }
            else{
                [tempString appendString:[NSString stringWithFormat:@"%@,",[[articles objectAtIndex:i] channelId] ]];
            }
        }
        NSArray *tempArray=[self.db selectWhereQueryWithTableName:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"channelId in ('%@')",tempString ] withOrderbyID:YES ];
        sync(tempArray,SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getBlogChannelsWithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.channelArray=[Channels parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"channels"]];
    if (sync) {
        sync([self.db selectAllQueryWithTableName:@"channels"],SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getArticlesForChannel:(NSString *)channelId WithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.articleArray=[Articles parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"channelId='%@'",channelId ] withOrderbyID:YES ] mutableCopy] ];
    if (sync) {
        sync(sharedManager.articleArray,SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getBlogsForChannel:(NSString *)channelId WithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.blogsArray=[Blogs parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"blogs" andWithWhereCondition:[NSString stringWithFormat: @"channelId='%@'",channelId ] withOrderbyID:YES ] mutableCopy] ];
    if (sync) {
        sync(sharedManager.blogsArray,SUCESS_DATABASE_SYNC,1);
    }
}

-(NSMutableArray *)getBlogsWithTopics:(NSMutableArray *)blogs{
    
    NSMutableArray *newArticles=MArray;
    for (int i=0; i<[blogs count]; i++) {
        Blogs *tempBlog=[blogs objectAtIndex:i];
        Channels *tempChannel=[[self.db selectWhereQueryWithTableName:@"channels" andWithWhereCondition:[NSString stringWithFormat: @"uuid = '%@'" ,tempBlog.channelId]] objectAtIndex:0];
        tempBlog.topicsArray=tempChannel.topicLists;
        [newArticles addObject:tempBlog];
    }
    return newArticles;
}

-(void)getAllBlogsWithCompletionBlock:(get_completion_block)sync{
    @try{
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(concurrentQueue, ^{
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            sharedManager.blogsArray=[Blogs parseArrayToObjectsWithArray:[self.db selectWhereQueryWithTableName:@"blogs" andORDERBYString:@"order by id desc"]];
            [self getAllChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status){
                NSMutableArray *activeArticles=MArray;
                for (int i=0; i<[result count]; i++) {
                    for (int j=0; j<[sharedManager.blogsArray count];  j++) {
                        NSString *channelID=[[[sharedManager.blogsArray objectAtIndex:j] channelId] mutableCopy];
                        
                        if ( [ channelID isEqualToString:[[result objectAtIndex:i] valueForKey:@"uuid"] ] ) {
                            //
                            if ([[result objectAtIndex:i]  valueForKey:@"isActive"]) {
                                [activeArticles addObject:[sharedManager.blogsArray objectAtIndex:j] ];
                            }
                        }
                    }
                }
                
                if (sync) {
                    sync(activeArticles,SUCESS_DATABASE_SYNC,1);
                }
            }];
        });
    }
    @catch (NSException *exception) {
        
    }
    
}

-(void)getFilterArticlesWithCompletionBlock:(get_completion_block)sync{
    @try{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        sharedManager.articleArray=[Articles parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"articles" andORDERBYString:@"order by id desc" ] mutableCopy] ];
        [self getAllChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status){
            NSMutableArray *activeArticles=MArray;
            for (int i=0; i<[result count]; i++) {
                for (int j=0; j<[sharedManager.articleArray count];  j++) {
                    NSString *channelID=[[[sharedManager.articleArray objectAtIndex:j] channelId] mutableCopy];
                    
                    if ( [ channelID isEqualToString:[[result objectAtIndex:i] valueForKey:@"uuid"] ] ) {
                        if ([[result objectAtIndex:i]  valueForKey:@"isActive"]) {
                            [activeArticles addObject:[sharedManager.articleArray objectAtIndex:j] ];
                        }
                    }
                }
            }
            
            if (sync) {
                
                sync(activeArticles,SUCESS_DATABASE_SYNC,1);
            }
        }];
    }
    @catch (NSException *exception) {
        
    }
    
}
-(void)getAllArticlesWithCompletionBlock:(get_completion_block)sync{
    @try{
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(concurrentQueue, ^{
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            sharedManager.articleArray=[Articles parseArrayToObjectsWithArrayForAllArticles:[[self.db selectWhereQueryWithTableName:@"articles" andORDERBYString:@"order by id desc" ] mutableCopy]];
            [self getAllChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status){
                NSMutableArray *activeArticles=MArray;
                for (int i=0; i<[result count]; i++) {
                    for (int j=0; j<[sharedManager.articleArray count];  j++) {
                        NSString *channelID=[[[sharedManager.articleArray objectAtIndex:j] channelId] mutableCopy];
                        
                        if ( [ channelID isEqualToString:[[result objectAtIndex:i] valueForKey:@"uuid"] ] ) {
                            //
                            if ([[result objectAtIndex:i]  valueForKey:@"isActive"]) {
                                [activeArticles addObject:[sharedManager.articleArray objectAtIndex:j] ];
                            }
                        }
                    }
                }
                
                if (sync) {
                    
                    sync(activeArticles,SUCESS_DATABASE_SYNC,1);
                }
            }];
        });
    }
    @catch (NSException *exception) {
        
    }
    
}

-(NSMutableArray *)getArticlesWithTopics:(NSMutableArray *)articles{
    
    NSMutableArray *newArticles=MArray;
    for (int i=0; i<[articles count]; i++) {
        Articles *tempArticle=[articles objectAtIndex:i];
        Channels *tempChannel=[[self.db selectWhereQueryWithTableName:@"channels" andWithWhereCondition:[NSString stringWithFormat: @"uuid = '%@'" ,tempArticle.channelId]] objectAtIndex:0];
        tempArticle.topicsArray=tempChannel.topicLists;
        [newArticles addObject:tempArticle];
    }
    return newArticles;
}

#pragma mark Videos
-(void)getAllVideosWithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.videosArray=[Video parseArrayToObjectsWithArray:[self.db selectWhereQueryWithTableName:@"videos" andORDERBYString:@"order by id desc"]];
    [self getAllChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status){
        NSMutableArray *activeArticles=MArray;
        for (int i=0; i<[result count]; i++) {
            for (int j=0; j<[sharedManager.videosArray count];  j++) {
                NSString *channelID=[[[sharedManager.videosArray objectAtIndex:j] channelId] mutableCopy];
                
                if ( [ channelID isEqualToString:[[result objectAtIndex:i] valueForKey:@"uuid"] ] ) {
                    //
                    if ([[result objectAtIndex:i]  valueForKey:@"isActive"]) {
                        [activeArticles addObject:[sharedManager.videosArray objectAtIndex:j] ];
                    }
                }
            }
        }
        
        if (sync) {
            sync(activeArticles,SUCESS_DATABASE_SYNC,1);
        }
    }];
}

-(void)getVideosForChannel:(NSString *)channelId WithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.videosArray=[Video parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"videos" andWithWhereCondition:[NSString stringWithFormat: @"channelId='%@'",channelId ] withOrderbyID:YES ] mutableCopy] ];
    if (sync) {
        sync(sharedManager.videosArray,SUCESS_DATABASE_SYNC,1);
    }
}

-(NSMutableArray *)getVideosWithTopics:(NSMutableArray *)videos{
    
    NSMutableArray *newArticles=MArray;
    for (int i=0; i<[videos count]; i++) {
        Video *tempVideo=[videos objectAtIndex:i];
        Channels *tempChannel=[[self.db selectWhereQueryWithTableName:@"channels" andWithWhereCondition:[NSString stringWithFormat: @"uuid = '%@'" ,tempVideo.channelId]] objectAtIndex:0];
        tempVideo.topicsArray=tempChannel.topicLists;
        [newArticles addObject:tempVideo];
    }
    return newArticles;
}

-(void)getUpdatedVideos:(NSArray *)blogs WithCompletionBlock:(get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.videosArray=[Blogs parseArrayToObjectsWithArray:[self.db selectAllQueryWithTableName:@"videos"]];
    if (sync) {
        NSMutableString *tempString=[[NSMutableString alloc] init];
        for (int i=0; i<[blogs count]; i++) {
            [tempString appendString:[NSString stringWithFormat:@"%@,",[blogs objectAtIndex:i] ]];
        }
        sync([self.db selectWhereQueryWithTableName:@"videos" andWithWhereCondition:[NSString stringWithFormat: @"id in ('%@')",tempString ] withOrderbyID:YES ],SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getVideosForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync{
    
    NSString *udidstr=[udids componentsJoinedByString:@"','"];
    NSMutableArray *tagArray=[Video parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"videos" andWithWhereCondition:[NSString stringWithFormat: @" uuid in ('%@')",udidstr ]] mutableCopy] ];
    if (sync) {
        sync(tagArray,SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getAllCategories:(get_completion_block)sync{
    
    // Getting Categories from Article
    NSMutableArray *categoryArray=[Articles parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"articles" andORDERBYString:@"order by id desc" ] mutableCopy] ];
    Articles *tmpArticle;
    NSMutableArray *categories=MArray;
    
    for (tmpArticle in categoryArray) {
        for(int y=0; y<[tmpArticle.meta.category count]; y++)
        {
            //Looping All Articles for a category
            BOOL isCategoryExists=false;
            for(int i=0; i<[categories count]; i++)
            {
                // Checking if categories in article exists in Category Array
                if([[[categories objectAtIndex:i] valueForKey:@"name"] isEqualToString: [tmpArticle.meta.category objectAtIndex:y] ])
                {
                    BOOL isUUIDExists=false;
                    for (int j=0; j<[[[categories objectAtIndex:i] objectForKey:@"uuid"] count]; j++) {
                        // Checking if UUID exists in the particular category array
                        if ([[[categories objectAtIndex:i] objectForKey:@"uuid"] objectAtIndex:j]==tmpArticle.uuid) {
                            isUUIDExists=true;
                        }
                    }
                    if(!isUUIDExists)
                    {
                        [[[categories objectAtIndex:i] objectForKey:@"uuid"] addObject:tmpArticle.uuid];
                    }
                    isCategoryExists=true;
                }
            }
            if(!isCategoryExists)
            {
                NSMutableArray *uuids=MArray;
                [uuids addObject:tmpArticle.uuid];
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[tmpArticle.meta.category objectAtIndex:y],uuids,@"Article"] forKeys:@[@"name",@"uuid",@"type"]];
                [categories addObject:dic];
            }
        }
    }
    
    // Getting Categories from Article
    NSMutableArray *blogCategoryArray=[Blogs parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"blogs" andORDERBYString:@"order by id desc" ] mutableCopy] ];
    Blogs *tmpBlog;
    
    for (tmpBlog in blogCategoryArray) {
        for(int y=0; y<[tmpBlog.meta.category count]; y++)
        {
            //Looping All Articles for a category
            BOOL isCategoryExists=false;
            for(int i=0; i<[categories count]; i++)
            {
                // Checking if categories in article exists in Category Array
                if([[[categories objectAtIndex:i] valueForKey:@"name"] isEqualToString: [tmpBlog.meta.category objectAtIndex:y] ])
                {
                    BOOL isUUIDExists=false;
                    for (int j=0; j<[[[categories objectAtIndex:i] objectForKey:@"uuid"] count]; j++) {
                        // Checking if UUID exists in the particular category array
                        if ([[[categories objectAtIndex:i] objectForKey:@"uuid"] objectAtIndex:j]==tmpBlog.uuid) {
                            isUUIDExists=true;
                        }
                    }
                    if(!isUUIDExists)
                    {
                        [[[categories objectAtIndex:i] objectForKey:@"uuid"] addObject:tmpBlog.uuid];
                    }
                    isCategoryExists=true;
                }
            }
            if(!isCategoryExists)
            {
                NSMutableArray *uuids=MArray;
                [uuids addObject:tmpBlog.uuid];
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[tmpBlog.meta.category objectAtIndex:y],uuids,@"Blogs"] forKeys:@[@"name",@"uuid",@"type"]];
                [categories addObject:dic];
            }
        }
    }
    
    if (sync) {
        sync(categories,SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getAllTags:(get_completion_block)sync{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        
        
        //Getting all tags for Articles
        NSMutableArray *tagArray=[Channels parseArrayToObjectsWithArray:[[self.db selectAllQueryWithTableName:@"channels"] mutableCopy] ];
        Channels *tmpChannel;
        NSMutableArray *tags=MArray;
        
        for (tmpChannel in tagArray) {
            
            //Looping All Articles for a tag
            BOOL isTagsExists=false;
            
            
            for (int j=0; j<[tmpChannel.topicLists count]; j++) {
                // Checking if UUID exists in the particular category array
                isTagsExists=false;
                for (int y=0; y<[tags count]; y++) {
                    if ([[[tags objectAtIndex:y] topicId] isEqualToString:[[tmpChannel.topicLists objectAtIndex:j] topicId] ]) {
                        isTagsExists=true;
                    }
                    
                }
                //&& [[[tmpChannel.topicLists objectAtIndex:j] meta] isActive]
                if(!isTagsExists && [[[tmpChannel.topicLists objectAtIndex:j] meta] isActive] )
                {
                    [tags addObject:[tmpChannel.topicLists objectAtIndex:j] ];
                }
                
            }
            
        }
        
        // Cheking for First Install
        NSMutableArray *newTopicsAray=MArray;
        NSMutableArray *dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"topic"];
        if ([dic count]<=0) {
            for (int i=0; i<[tags count]; i++) {
                // add tags
                if (![newTopicsAray containsObject:[[tags objectAtIndex:i] topicname]]) {
                    [newTopicsAray addObject:[[tags objectAtIndex:i]topicname]];
                }
            }
            
            UDSetObject(newTopicsAray, @"topic");
        }
        
        
        
        if (sync) {
            sync(tags,SUCESS_DATABASE_SYNC,1);
        }
    });
}

-(void)getArticlesForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync{
    
    NSString *udidstr=[udids componentsJoinedByString:@"','"];
    NSMutableArray *tagArray=[Articles parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"articles" andWithWhereCondition:[NSString stringWithFormat: @" uuid in ('%@')",udidstr ]] mutableCopy] ];
    if (sync) {
        sync(tagArray,SUCESS_DATABASE_SYNC,1);
    }
}

-(void)getBlogsForUDIDs:(NSArray *)udids WithCompletionblock :(get_completion_block)sync{
    
    NSString *udidstr=[udids componentsJoinedByString:@"','"];
    NSMutableArray *tagArray=[Blogs parseArrayToObjectsWithArray:[[self.db selectWhereQueryWithTableName:@"blogs" andWithWhereCondition:[NSString stringWithFormat: @" uuid in ('%@')",udidstr ]] mutableCopy] ];
    if (sync) {
        sync(tagArray,SUCESS_DATABASE_SYNC,1);
    }
}

// For Reading List
-(void)getAllReadingListWithCompletionBlock: (get_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    NSMutableArray *readingListArray=[[NSMutableArray alloc] initWithArray:[[sharedManager.db selectAllQueryWithTableName:@"readinglists"] mutableCopy]];
    if(sync)
    {
        sync(readingListArray,SUCCESS_READING_LIST,1);
    }
    else{
        sync(readingListArray,ERROR_READING_LIST,0);
    }
}

-(void)insertReadingListWithName:(NSString *)name andWithUUID:(NSString *)uuid andType:(NSString *)type WithCompletionBlock: (sync_completion_block)sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[name,uuid,type] forKeys:@[@"name",@"uuid",@"type"]];
    if (![self checkDuplicateWithUDID:uuid]) {
        // IF no duplicate entry in Reading list
        BOOL isInserted=[sharedManager.db insertQueryWithDictionary:dic inTable:@"readinglists"];
        if(isInserted)
        {
            if(sync)
            {
                sync(SUCCESS_READING_INSERT,1);
            }
        }
        else{
            if(sync)
            {
                sync(ERROR_READING_INSERT,-1);
            }
        }
    }
    else{
        if(sync)
        {
            sync(ERROR_READING_DUPLICATE,0);
        }
    }
    
}

-(BOOL) checkDuplicateWithUDID:(NSString *)udid{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    NSMutableArray *readingList=[[NSMutableArray alloc] initWithArray:[[sharedManager.db selectAllQueryWithTableName:@"readinglists"] mutableCopy]];
    BOOL isDuplicate=false;
    for(int i=0; i<[readingList count]; i++)
    {
        if ([udid isEqualToString:[[readingList objectAtIndex:i] valueForKey:@"uuid"] ]) {
            isDuplicate=true;
            break;
        }
    }
    return isDuplicate;
}
@end
