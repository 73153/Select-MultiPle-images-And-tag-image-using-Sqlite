//
//  Video.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 22/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import "Video.h"

@implementation Video

@synthesize videoId,videoUri,channelId,clientId,meta,summary,title,uuid,vv,heroImage;
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.videoId = [decoder decodeObjectForKey:@"_id"];
        self.videoUri = [decoder decodeObjectForKey:@"uri"];
        self.channelId = [decoder decodeObjectForKey:@"channelId"];
        self.clientId = [decoder decodeObjectForKey:@"clientId"];
        self.heroImage = [decoder decodeObjectForKey:@"hero_image"];
        self.meta = [decoder decodeObjectForKey:@"meta"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.vv = [decoder decodeObjectForKey:@"vv"];
      
        self.imageUrls = [decoder decodeObjectForKey:@"imageUrls"];
     
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.videoId=[[NSMutableString alloc]init];
        self.videoUri=[[NSMutableString alloc]init];
        self.channelId=[[NSMutableString alloc]init];
        self.clientId=[[NSMutableString alloc]init];
        self.heroImage=[[NSMutableString alloc]init];
        self.meta=[[Meta alloc] init];
        self.summary=[[NSMutableString alloc] init];
        self.title=[[NSMutableString alloc] init];
        self.uuid=[[NSMutableString alloc]init];
        self.vv=[[NSMutableString alloc]init];
        self.isCategoryPresent=false;
        self.topicId=[[NSString alloc] init];
        self.phoneHero=[[NSMutableString alloc] init];
        self.thumbnail=[[NSMutableString alloc] init];
        self.tabletHero=[[NSMutableString alloc] init];
        
        self.imageUrls=[[NSMutableDictionary alloc]init];
        self.currentTopic=[[Topics alloc] init];
    }
    return self;
}
-(void)getAllVideos:(video_completion_block)completion
{
    NSString *url_String = [NSString stringWithFormat:@"%@", API_VIDEO_LIST];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [APICall callGetWebService:url_String andDictionary:nil withToken:sharedManager.user.activeToken completion:^(NSMutableDictionary *user, NSError *error, long code){
        if(error)
        {
            if(completion)
            {
                completion(nil,[error localizedDescription],-1);
            }
        }
        else{
            if(completion)
            {
                //completion(user,@"User account registered successfully ",1);
                if([[user valueForKey:@"success"]integerValue]==0)
                {
                    sharedManager.aryAllVideos = [user valueForKey:@"data"];

                    if (![user valueForKey:@"message"]) {
                        completion(user,ERROR_VIDEO_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_VIDEO_LIST,1);
                }
                else{
                    completion(user,ERROR_VIDEO_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getVideosWithTimeStamp:(NSDate *)time withCompletion:(video_completion_block)completion
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSString *stringFromDate = [dateFormat stringFromDate:time];
    NSString *url_String = [NSString stringWithFormat:@"%@/?ts=%@", API_VIDEO_LIST,stringFromDate];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [APICall callGetWebService:url_String andDictionary:nil withToken:sharedManager.user.activeToken completion:^(NSMutableDictionary *user, NSError *error, long code){
        if(error)
        {
            if(completion)
            {
                completion(nil,[error localizedDescription],-1);
            }
        }
        else{
            if(completion)
            {
                //completion(user,@"User account registered successfully ",1);
                if([[user valueForKey:@"success"]integerValue]==0)
                {
                    if (![user valueForKey:@"message"]) {
                        completion(user,ERROR_VIDEO_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_VIDEO_LIST,1);
                }
                else{
                    completion(user,ERROR_VIDEO_LIST,0);
                }
            }
        }
        
    }];
}



-(void)getVideoWithChannelId:(NSString *)channelUUId :(video_completion_block)completion
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];

    NSString *url_String = [NSString stringWithFormat:@"%@/%@?offset=%d&limit=%d", API_VIDEO_LIST,channelUUId,sharedManager.intOffset,sharedManager.intLimit];
    [APICall callGetWebService:url_String andDictionary:nil withToken:sharedManager.user.activeToken completion:^(NSMutableDictionary *user, NSError *error, long code){
        if(error)
        {
            if(completion)
            {
                completion(nil,[error localizedDescription],-1);
            }
        }
        else{
            if(completion)
            {
                //completion(user,@"User account registered successfully ",1);
                if([[user valueForKey:@"success"]integerValue]==0)
                {
                    if (![user valueForKey:@"message"]) {
                        completion(user,ERROR_VIDEO_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_VIDEO_LIST,1);
                }
                else{
                    completion(user,ERROR_VIDEO_LIST,0);
                }
            }
        }
        
    }];
}

-(void)getVideoWithChannelId:(NSString *)channelUUId andTimeStamp:(NSDate *)time withCompletion:(video_completion_block)completion{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSString *stringFromDate = [dateFormat stringFromDate:time];
    NSString *url_String = [NSString stringWithFormat:@"%@/%@?ts=%@", API_VIDEO_LIST,channelUUId,stringFromDate];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [APICall callGetWebService:url_String andDictionary:nil withToken:sharedManager.user.activeToken completion:^(NSMutableDictionary *user, NSError *error, long code){
        if(error)
        {
            if(completion)
            {
                completion(nil,[error localizedDescription],-1);
            }
        }
        else{
            if(completion)
            {
                //completion(user,@"User account registered successfully ",1);
                if([[user valueForKey:@"success"]integerValue]==0)
                {
                    if (![user valueForKey:@"message"]) {
                        completion(user,ERROR_VIDEO_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_VIDEO_LIST,1);
                }
                else{
                    completion(user,ERROR_VIDEO_LIST,0);
                }
            }
        }
        
    }];
}
+(void)filterArrayUsingString:(NSString *)searchString WithCompletion:(get_completion_block) sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager.sync getAllVideosWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        if(sharedManager.videosArray)
        {
            NSMutableArray *resultArray=MArray;
            for (int i=0; i<[sharedManager.videosArray count]; i++) {
                if([[sharedManager.videosArray objectAtIndex:i] searchInVideoWithString:searchString])
                {
                    [resultArray addObject:[sharedManager.videosArray objectAtIndex:i]];
                }
            }
            if (sync) {
                //
                sync(resultArray,ERROR_SEARCH_RESULT,1);
            }
        }
        else{
            if (sync) {
                //
                sync(nil,@"",0);
            }
        }
    }];
    
}
-(BOOL) searchInVideoWithString:(NSString *)searchStr{
    BOOL isSearchStringFound=false;
    if(self){
        @try {
            if ([[NSString stringWithString:[self.title lowercaseString] ] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            } else if ([[self.summary lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            }
            else if ([[self.meta.author.name lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            }
            else if ([[self.meta.author.blurb lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            }
            else if ([[self.meta.author.company lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            }
            for (int x=0; x<[self.meta.category count]; x++) {
                if ([[[self.meta.category objectAtIndex:x] lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                    isSearchStringFound=true;
                    return isSearchStringFound;
                }
            }
            
            
            for (int x=0; x<[self.meta.tags count]; x++) {
                if ([[[self.meta.tags objectAtIndex:x] lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                    isSearchStringFound=true;
                    return isSearchStringFound;
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    }
    return isSearchStringFound;
}
//+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result{
//    NSMutableArray *tmpArray=[result mutableCopy];
//    NSMutableArray *newArray=MArray;
//    for (int i=0; i<[tmpArray count]; i++) {
//        //Parsing Article List
//        @try {
//            Video *tmpVideo=[[Video alloc] init];
//            
//            tmpVideo.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
//            tmpVideo.videoUri=[[tmpArray objectAtIndex:i] valueForKey:@"uri"];
//            tmpVideo.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
//            tmpVideo.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
//            tmpVideo.thumbnail=[[tmpArray objectAtIndex:i] valueForKey:@"thumbnail"];
//            tmpVideo.phoneHero=[[tmpArray objectAtIndex:i] valueForKey:@"phoneHero"];
//            tmpVideo.tabletHero=[[tmpArray objectAtIndex:i] valueForKey:@"tabletHero"];
//            
//            tmpVideo.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
//            tmpVideo.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
//            tmpVideo.heroImage=[[tmpArray objectAtIndex:i] valueForKey:@"hero_image"];
//            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
//            
//            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
//            
//            // For Meta
//            tmpVideo.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
//            tmpVideo.meta.createdAt=[json valueForKey:@"createdAt"];
//            tmpVideo.meta.updatedAt=[json valueForKey:@"updatedAt"];
//            if([[tmpArray objectAtIndex:i] valueForKey:@"_id"])
//            {
//                tmpVideo.videoId=[[tmpArray objectAtIndex:i] valueForKey:@"_id"];
//            }
//            if([[tmpArray objectAtIndex:i] valueForKey:@"__v"])
//            {
//                tmpVideo.videoId=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
//            }
//            // For Adding Categories
//            tmpVideo.meta.category= MArray;
//            for (int x=0; x<[[json objectForKey:@"category"] count]; x++) {
//                [tmpVideo.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
//            }
//            tmpVideo.meta.tags= MArray;
//            // For Adding Tags
//            for (int x=0; x<[[json valueForKey:@"tags"] count]; x++) {
//                [tmpVideo.meta.tags addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
//            }
//            // For Authors
//            tmpVideo.meta.author=[[Authors alloc] init];
//            tmpVideo.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
//            tmpVideo.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
//            tmpVideo.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
//            tmpVideo.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
//            // For Topics
//            if([[tmpArray objectAtIndex:i] valueForKey:@"topicId"] && ![[[tmpArray objectAtIndex:i] valueForKey:@"topicId"] isKindOfClass:[NSNull class]])
//            {
//                tmpVideo.topicId=[[tmpArray objectAtIndex:i] valueForKey:@"topicId"];
//            }
//
//            // For Images
//            //            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
//            //
//            //            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
//            
//            //            [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
//            //            [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
//            //            [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];
//            
//            
//            [newArray addObject:tmpVideo];
//            
//        }
//        @catch (NSException *exception) {
//            //
//        }
//        @finally {
//            //
//        }
//    }
//    return newArray;
//}

+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result{
    NSMutableArray *tmpArray=[result mutableCopy];
    NSMutableArray *newArray=MArray;
    Globals *sharedManager = [Globals sharedManager];
    __block NSArray *aryChannelsList;
    [sharedManager.sync getMenuChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        [sharedManager hideLoader];
        aryChannelsList =[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
    }];
    for (int i=0; i<[tmpArray count]; i++) {
        //Parsing Article List
        @try {
            Video *tmpVideo=[[Video alloc] init];
            
            tmpVideo.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpVideo.videoUri=[[tmpArray objectAtIndex:i] valueForKey:@"uri"];
            tmpVideo.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            tmpVideo.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
            tmpVideo.thumbnail=[[tmpArray objectAtIndex:i] valueForKey:@"thumbnail"];
            tmpVideo.phoneHero=[[tmpArray objectAtIndex:i] valueForKey:@"phoneHero"];
            tmpVideo.tabletHero=[[tmpArray objectAtIndex:i] valueForKey:@"tabletHero"];
            __block BOOL isAccess = false;
            [aryChannelsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Channels *objChannels = (Channels*)obj;
                if([objChannels.uuid isEqualToString:tmpVideo.channelId])
                {
                    isAccess=true;
                    *stop=true;
                }
            }];
            tmpVideo.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            tmpVideo.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            tmpVideo.heroImage=[[tmpArray objectAtIndex:i] valueForKey:@"hero_image"];
            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            // For Meta
            tmpVideo.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            tmpVideo.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpVideo.meta.updatedAt=[json valueForKey:@"updatedAt"];
            if([[tmpArray objectAtIndex:i] valueForKey:@"_id"])
            {
                tmpVideo.videoId=[[tmpArray objectAtIndex:i] valueForKey:@"_id"];
            }
            if([[tmpArray objectAtIndex:i] valueForKey:@"__v"])
            {
                tmpVideo.videoId=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            }
            // For Adding Categories
            tmpVideo.meta.category= MArray;
            for (int x=0; x<[[json objectForKey:@"category"] count]; x++) {
                [tmpVideo.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
            }
            tmpVideo.meta.tags= MArray;
            // For Adding Tags
            for (int x=0; x<[[json valueForKey:@"tags"] count]; x++) {
                [tmpVideo.meta.tags addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
            }
            // For Authors
            tmpVideo.meta.author=[[Authors alloc] init];
            tmpVideo.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpVideo.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpVideo.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpVideo.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            // For Topics
            if([[tmpArray objectAtIndex:i] valueForKey:@"topicId"] && ![[[tmpArray objectAtIndex:i] valueForKey:@"topicId"] isKindOfClass:[NSNull class]])
            {
                tmpVideo.topicId=[[tmpArray objectAtIndex:i] valueForKey:@"topicId"];
            }
            
            // For Images
            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            
            
            if(jsonDict && [jsonDict count]>0)
            {
                if([sharedManager isNotNull:[jsonDict valueForKey:@"thumbnail"]])
                {
                    [tmpVideo.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                }
                
                if([sharedManager isNotNull:[jsonDict valueForKey:@"tabletHero"]])
                {
                    [tmpVideo.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
                }
                if([sharedManager isNotNull:[jsonDict valueForKey:@"phoneHero"]])
                {
                    [tmpVideo.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];
                }
            }
            
            if(isAccess)
            {
                if(tmpVideo.meta.isActive){
                    [newArray addObject:tmpVideo];
                }
            }
            
        }
        @catch (NSException *exception) {
            //
        }
        @finally {
            //
        }
    }
    return newArray;
}

+(NSMutableArray *)parseArrayToObjectsWithArrayFromDB:(NSArray *)result{
    NSMutableArray *tmpArray=[result mutableCopy];
    NSMutableArray *newArray=MArray;
    for (int i=0; i<[tmpArray count]; i++) {
        //Parsing Article List
        @try {
            Video *tmpVideo=[[Video alloc] init];
            
            tmpVideo.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpVideo.videoUri=[[tmpArray objectAtIndex:i] valueForKey:@"uri"];
            tmpVideo.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            tmpVideo.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
            tmpVideo.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            tmpVideo.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            tmpVideo.heroImage=[[tmpArray objectAtIndex:i] valueForKey:@"hero_image"];
            
            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            // For Meta
            tmpVideo.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            tmpVideo.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpVideo.meta.updatedAt=[json valueForKey:@"updatedAt"];
            
            // For Adding Categories
            for (int x; x<[[json valueForKey:@"category"] count]; x++) {
                [tmpVideo.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
            }
            // For Adding Tags
            for (int x; x<[[json valueForKey:@"category"] count]; x++) {
                [tmpVideo.meta.category addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
            }
            
            // For Authors
            tmpVideo.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpVideo.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpVideo.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpVideo.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            
            // For Images
            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            
            [tmpVideo.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
            [tmpVideo.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
            [tmpVideo.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];
            
            
            [newArray addObject:tmpVideo];
            
        }
        @catch (NSException *exception) {
            //
        }
        @finally {
            //
        }
    }
    return newArray;
}
@end
