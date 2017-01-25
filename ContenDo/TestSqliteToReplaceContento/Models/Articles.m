//
//  Articles.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "Articles.h"

@implementation Articles
@synthesize articlelId,articleUri,channelId,clientId,desc,imageUrls,meta,summary,title,uuid,vv,type,articleURL;
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.articlelId forKey:@"articlelId"];
    [encoder encodeObject:[NSString stringWithFormat:@"%@", self.articleUri ] forKey:@"articleUri"];
    [encoder encodeObject:[NSString stringWithFormat:@"%@", self.channelId ] forKey:@"channelId"];
    [encoder encodeObject:self.clientId forKey:@"clientId"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.imageUrls forKey:@"imageUrls"];
    [encoder encodeObject:self.meta forKey:@"meta"];
    [encoder encodeObject:self.summary forKey:@"summary"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    [encoder encodeObject:self.vv forKey:@"vv"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.articlelId = [decoder decodeObjectForKey:@"articlelId"];
        self.articleUri = [decoder decodeObjectForKey:@"articleUri"];
        self.channelId = [decoder decodeObjectForKey:@"channelId"];
        self.clientId = [decoder decodeObjectForKey:@"clientId"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.imageUrls = [decoder decodeObjectForKey:@"imageUrls"];
        self.meta = [decoder decodeObjectForKey:@"meta"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.vv = [decoder decodeObjectForKey:@"vv"];
        
    }
    return self;
}
+ (void)saveCustomObject:(Articles *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (Articles *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    Articles *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.articlelId=[[NSMutableString alloc]init];
        self.articleUri=[[NSMutableString alloc]init];
        self.channelId=[[NSMutableString alloc]init];
        self.clientId=[[NSMutableString alloc]init];
        self.desc=[[NSMutableString alloc]init];
        self.imageUrls=[[NSMutableDictionary alloc]init];
        self.meta=[[Meta alloc] init];
        self.summary=[[NSMutableString alloc] init];
        self.title=[[NSMutableString alloc] init];
        self.uuid=[[NSMutableString alloc]init];
        self.vv=[[NSMutableString alloc]init];
        self.type=[[NSMutableString alloc]init];
        self.articleURL=[[NSMutableString alloc]init];
        self.isCategoryPresent=false;
        self.topicsArray=MArray;
        self.topicId=[[NSString alloc] init];
        self.currentTopic=[[Topics alloc] init];
        self.updatedDate=[[NSMutableString alloc] init];
    }
    return self;
}
-(void)getArticlesWithChannelId:(NSString *)channelUUId :(article_completion_block)completion
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    NSString *url_String = [NSString stringWithFormat:@"%@/%@?offset=%d&limit=%d", API_ARTICLE_LIST,channelUUId,sharedManager.intOffset,sharedManager.intLimit];
    
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
                        completion(user,ERROR_ARTICLE_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_ARTICLE_LIST,1);
                }
                else{
                    completion(user,ERROR_ARTICLE_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getArticlesWithChannelId:(NSString *)channelUUId andTimeStamp:(NSDate *)time withCompletion:(article_completion_block)completion
{
    @try{
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSString *stringFromDate = [dateFormat stringFromDate:time];
        
        NSString *url_String = [NSString stringWithFormat:@"%@/%@?ts=%@", API_ARTICLE_LIST,channelUUId,stringFromDate];
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
                        sharedManager.aryAllArticles = [user valueForKey:@"data"];
                        
                        if (![user valueForKey:@"message"]) {
                            completion(user,ERROR_ARTICLE_LIST,0);
                        }
                        else{
                            completion(user,[user valueForKey:@"message"],0);
                        }
                        
                    }
                    else if([[user valueForKey:@"success"]integerValue]==1){
                        completion(user,SUCEESS_ARTICLE_LIST,1);
                    }
                    else{
                        completion(user,ERROR_ARTICLE_LIST,0);
                    }
                }
            }
            
        }];
    }
    @catch (NSException *exception) {
        
    }
}
-(BOOL) searchInArticleWithString:(NSString *)searchStr{
    BOOL isSearchStringFound=false;
    if(self){
        @try {
            if ([[NSString stringWithString:[self.title lowercaseString] ] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            } else if ([[self.summary lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            } else if ([[self.desc lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            }
            else if ([[self.meta.author.name lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            }
            else if(self.meta.author.blurb.length>0){
                if ([[self.meta.author.blurb lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                    isSearchStringFound=true;
                    return isSearchStringFound;
                }
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
+(void)filterArrayUsingString:(NSString *)searchString WithCompletion:(get_completion_block) sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        if(sharedManager.articleArray)
        {
            NSMutableArray *resultArray=MArray;
            for (int i=0; i<[sharedManager.articleArray count]; i++) {
                if([[sharedManager.articleArray objectAtIndex:i] searchInArticleWithString:searchString])
                {
                    [resultArray addObject:[sharedManager.articleArray objectAtIndex:i]];
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

+(NSMutableArray *)parseArrayToObjectsWithArrayForAllArticles:(NSArray *)result{
    NSMutableArray *tmpArray=[result mutableCopy];
    NSMutableArray *newArray=MArray;
    Globals *sharedManager = [Globals sharedManager];
    
    __block NSArray *aryChannelsList;
    aryChannelsList=[sharedManager.db selectAllQueryWithTableName:@"channels"];
    
    for (int i=0; i<[tmpArray count]; i++) {
        //Parsing Article List
        @try {
            Articles *tmpArticle=[[Articles alloc] init];
            
            tmpArticle.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpArticle.articleUri=[[tmpArray objectAtIndex:i] valueForKey:@"articleUri"];
            tmpArticle.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            tmpArticle.desc=[[tmpArray objectAtIndex:i] valueForKey:@"desc"];
            tmpArticle.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
            __block BOOL isAccess = false;
            [aryChannelsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Channels *objChannels = (Channels*)obj;
                if([objChannels.uuid isEqualToString:tmpArticle.channelId])
                {
                    isAccess=true;
                    *stop=true;
                }
            }];
            
            
            tmpArticle.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            tmpArticle.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            // For Meta
            tmpArticle.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            tmpArticle.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpArticle.meta.updatedAt=[json valueForKey:@"updatedAt"];
            if([[tmpArray objectAtIndex:i] valueForKey:@"_id"])
            {
                tmpArticle.articlelId=[[tmpArray objectAtIndex:i] valueForKey:@"_id"];
            }
            if([[tmpArray objectAtIndex:i] valueForKey:@"__v"])
            {
                tmpArticle.articlelId=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            }
            // For Adding Categories
            tmpArticle.meta.category= MArray;
            for (int x=0; x<[[json objectForKey:@"category"] count]; x++) {
                [tmpArticle.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
            }
            tmpArticle.meta.tags= MArray;
            // For Adding Tags
            for (int x=0; x<[[json valueForKey:@"tags"] count]; x++) {
                [tmpArticle.meta.tags addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
            }
            
            // For Topics
            if([[tmpArray objectAtIndex:i] valueForKey:@"topicId"] && ![[[tmpArray objectAtIndex:i] valueForKey:@"topicId"] isKindOfClass:[NSNull class]])
            {
                tmpArticle.topicId=[[tmpArray objectAtIndex:i] valueForKey:@"topicId"];
            }
            
            // For Authors
            tmpArticle.meta.author=[[Authors alloc] init];
            tmpArticle.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpArticle.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpArticle.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpArticle.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            
            // For Images
            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            if(jsonDict && [jsonDict count]>0)
            {
                if([sharedManager isNotNull:[jsonDict valueForKey:@"thumbnail"]])
                {
                    [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                }
                
                if([sharedManager isNotNull:[jsonDict valueForKey:@"tabletHero"]])
                {
                    [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
                }
                if([sharedManager isNotNull:[jsonDict valueForKey:@"phoneHero"]])
                {
                    [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];
                }
            }
            if(isAccess){
                if(tmpArticle.meta.isActive){
                    [newArray addObject:tmpArticle];
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
            Articles *tmpArticle=[[Articles alloc] init];
            
            tmpArticle.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpArticle.articleUri=[[tmpArray objectAtIndex:i] valueForKey:@"articleUri"];
            tmpArticle.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            tmpArticle.desc=[[tmpArray objectAtIndex:i] valueForKey:@"desc"];
            tmpArticle.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
            __block BOOL isAccess = false;
            [aryChannelsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Channels *objChannels = (Channels*)obj;
                if([objChannels.uuid isEqualToString:tmpArticle.channelId])
                {
                    isAccess=true;
                    *stop=true;
                }
            }];
            tmpArticle.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            tmpArticle.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            // For Meta
            tmpArticle.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            tmpArticle.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpArticle.meta.updatedAt=[json valueForKey:@"updatedAt"];
            if([[tmpArray objectAtIndex:i] valueForKey:@"_id"])
            {
                tmpArticle.articlelId=[[tmpArray objectAtIndex:i] valueForKey:@"_id"];
            }
            if([[tmpArray objectAtIndex:i] valueForKey:@"__v"])
            {
                tmpArticle.articlelId=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            }
            // For Adding Categories
            tmpArticle.meta.category= MArray;
            for (int x=0; x<[[json objectForKey:@"category"] count]; x++) {
                [tmpArticle.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
            }
            tmpArticle.meta.tags= MArray;
            // For Adding Tags
            for (int x=0; x<[[json valueForKey:@"tags"] count]; x++) {
                [tmpArticle.meta.tags addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
            }
            
            // For Topics
            if([[tmpArray objectAtIndex:i] valueForKey:@"topicId"] && ![[[tmpArray objectAtIndex:i] valueForKey:@"topicId"] isKindOfClass:[NSNull class]])
            {
                tmpArticle.topicId=[[tmpArray objectAtIndex:i] valueForKey:@"topicId"];
            }
            
            // For Authors
            tmpArticle.meta.author=[[Authors alloc] init];
            tmpArticle.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpArticle.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpArticle.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpArticle.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            
            // For Images
            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            
            
            if(jsonDict && [jsonDict count]>0)
            {
                if([sharedManager isNotNull:[jsonDict valueForKey:@"thumbnail"]])
                {
                    [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                }
                
                if([sharedManager isNotNull:[jsonDict valueForKey:@"tabletHero"]])
                {
                    [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
                }
                if([sharedManager isNotNull:[jsonDict valueForKey:@"phoneHero"]])
                {
                    [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];
                }
            }
            if(isAccess)
            {
                if(tmpArticle.meta.isActive){
                    [newArray addObject:tmpArticle];
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
            Articles *tmpArticle=[[Articles alloc] init];
            
            tmpArticle.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpArticle.articleUri=[[tmpArray objectAtIndex:i] valueForKey:@"articleUri"];
            tmpArticle.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            tmpArticle.desc=[[tmpArray objectAtIndex:i] valueForKey:@"desc"];
            tmpArticle.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
            tmpArticle.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            tmpArticle.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            // For Meta
            tmpArticle.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            tmpArticle.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpArticle.meta.updatedAt=[json valueForKey:@"updatedAt"];
            
            // For Adding Categories
            for (int x; x<[[json valueForKey:@"category"] count]; x++) {
                [tmpArticle.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
            }
            // For Adding Tags
            for (int x; x<[[json valueForKey:@"category"] count]; x++) {
                [tmpArticle.meta.category addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
            }
            
            // For Authors
            tmpArticle.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpArticle.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpArticle.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpArticle.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            
            // For Topics
            if([[tmpArray objectAtIndex:i] valueForKey:@"topicId"] && ![[[tmpArray objectAtIndex:i] valueForKey:@"topicId"] isKindOfClass:[NSNull class]])
            {
                tmpArticle.topicId=[[tmpArray objectAtIndex:i] valueForKey:@"topicId"];
            }
            
            // For Images
            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            
            [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
            [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
            [tmpArticle.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];
            
            
            [newArray addObject:tmpArticle];
            
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
-(BOOL)searchInArticle:(Articles *)article WithString:(NSString *)searchStr
{
    return 0;
}
@end
