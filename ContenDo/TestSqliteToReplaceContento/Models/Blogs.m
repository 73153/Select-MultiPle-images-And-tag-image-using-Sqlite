//
//  Blogs.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 04/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import "Blogs.h"

@implementation Blogs
@synthesize blogId,blogUri,channelId,clientId,body,meta,summary,title,uuid,vv,heroImage,keywords,imageUrls;

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    [encoder encodeObject:self.blogId forKey:@"_id"];
    [encoder encodeObject:self.blogUri forKey:@"uri"];
    [encoder encodeObject:self.channelId forKey:@"channelId"];
    [encoder encodeObject:self.clientId forKey:@"clientId"];
    [encoder encodeObject:self.body forKey:@"desc"];
    [encoder encodeObject:self.heroImage forKey:@"hero_image"];
    [encoder encodeObject:self.meta forKey:@"meta"];
    [encoder encodeObject:self.summary forKey:@"summary"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    [encoder encodeObject:self.vv forKey:@"vv"];
    [encoder encodeObject:self.keywords forKey:@"keywords"];
    [encoder encodeObject:self.imageUrls forKey:@"imageUrls"];

    

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.blogId = [decoder decodeObjectForKey:@"_id"];
        self.blogUri = [decoder decodeObjectForKey:@"uri"];
        self.channelId = [decoder decodeObjectForKey:@"channelId"];
        self.clientId = [decoder decodeObjectForKey:@"clientId"];
        self.body = [decoder decodeObjectForKey:@"desc"];
        self.heroImage = [decoder decodeObjectForKey:@"hero_image"];
        self.meta = [decoder decodeObjectForKey:@"meta"];
        self.summary = [decoder decodeObjectForKey:@"summary"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.vv = [decoder decodeObjectForKey:@"vv"];
        self.keywords = [decoder decodeObjectForKey:@"keywords"];
        self.imageUrls = [decoder decodeObjectForKey:@"imageUrls"];
        
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.blogId=[[NSMutableString alloc]init];
        self.blogUri=[[NSMutableString alloc]init];
        self.channelId=[[NSMutableString alloc]init];
        self.clientId=[[NSMutableString alloc]init];
        self.body=[[NSMutableString alloc]init];
        self.heroImage=[[NSMutableString alloc]init];
        self.meta=[[Meta alloc] init];
        self.summary=[[NSMutableString alloc] init];
        self.title=[[NSMutableString alloc] init];
        self.uuid=[[NSMutableString alloc]init];
        self.vv=[[NSMutableString alloc]init];
        self.keywords=[[NSMutableString alloc]init];
        self.isCategoryPresent=false;
        self.topicId=[[NSString alloc] init];
        self.currentTopic=[[Topics alloc] init];
        self.imageUrls=[[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)getAllBlogs:(blog_completion_block)completion
{
    NSString *url_String = [NSString stringWithFormat:@"%@", API_BLOG_LIST];
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
                    sharedManager.aryAllBlogs = [user valueForKey:@"data"];
                    if (![user valueForKey:@"message"]) {
                        completion(user,ERROR_BLOG_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_BLOG_LIST,1);
                }
                else{
                    completion(user,ERROR_BLOG_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getBlogsWithTimeStamp:(NSDate *)time withCompletion:(blog_completion_block)completion
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSString *stringFromDate = [dateFormat stringFromDate:time];
    NSString *url_String = [NSString stringWithFormat:@"%@/?ts=%@", API_BLOG_LIST,stringFromDate];
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
                        completion(user,ERROR_BLOG_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_BLOG_LIST,1);
                }
                else{
                    completion(user,ERROR_BLOG_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getBlogsWithChannelId:(NSString *)channelUUId :(blog_completion_block)completion
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    NSString *url_String = [NSString stringWithFormat:@"%@/%@?offset=%d&limit=%d", API_BLOG_LIST,channelUUId,sharedManager.intOffset,sharedManager.intLimit];
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
                        completion(user,ERROR_BLOG_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_BLOG_LIST,1);
                }
                else{
                    completion(user,ERROR_BLOG_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getBlogsWithChannelId:(NSString *)channelUUId andTimeStamp:(NSDate *)time withCompletion:(blog_completion_block)completion
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSString *stringFromDate = [dateFormat stringFromDate:time];
    
    NSString *url_String = [NSString stringWithFormat:@"%@/%@?ts=%@", API_BLOG_LIST,channelUUId,stringFromDate];
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
                        completion(user,ERROR_BLOG_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_BLOG_LIST,1);
                }
                else{
                    completion(user,ERROR_BLOG_LIST,0);
                }
            }
        }
        
    }];
}
+(void)filterArrayUsingString:(NSString *)searchString WithCompletion:(get_completion_block) sync{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        if(sharedManager.blogsArray)
        {
            NSMutableArray *resultArray=MArray;
            for (int i=0; i<[sharedManager.blogsArray count]; i++) {
                if([[sharedManager.blogsArray objectAtIndex:i] searchInBlogWithString:searchString])
                {
                    [resultArray addObject:[sharedManager.blogsArray objectAtIndex:i]];
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
-(BOOL) searchInBlogWithString:(NSString *)searchStr{
    BOOL isSearchStringFound=false;
    if(self){
        @try {
            if ([[NSString stringWithString:[self.title lowercaseString] ] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            } else if ([[self.summary lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
                isSearchStringFound=true;
                return isSearchStringFound;
            } else if ([[self.body lowercaseString] rangeOfString:[searchStr lowercaseString]].location != NSNotFound) {
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
            Blogs *tmpBlog=[[Blogs alloc] init];
            
            tmpBlog.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpBlog.blogUri=[[tmpArray objectAtIndex:i] valueForKey:@"uri"];
            tmpBlog.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            tmpBlog.body=[[tmpArray objectAtIndex:i] valueForKey:@"body"];
            tmpBlog.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
            tmpBlog.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            __block BOOL isAccess = false;
            [aryChannelsList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Channels *objChannels = (Channels*)obj;
                if([objChannels.uuid isEqualToString:tmpBlog.channelId])
                {
                    isAccess=true;
                    *stop=true;
                }
            }];
            tmpBlog.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            tmpBlog.heroImage=[[tmpArray objectAtIndex:i] valueForKey:@"hero_image"];
            tmpBlog.keywords=[[tmpArray objectAtIndex:i] valueForKey:@"keywords"];
            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            // For Topics
            
            if([[tmpArray objectAtIndex:i] valueForKey:@"topicId"] && ![[[tmpArray objectAtIndex:i] valueForKey:@"topicId"] isKindOfClass:[NSNull class]])
            {
                tmpBlog.topicId=[[tmpArray objectAtIndex:i] valueForKey:@"topicId"];
            }
            
            // For Meta
            tmpBlog.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            
            tmpBlog.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpBlog.meta.updatedAt=[json valueForKey:@"updatedAt"];
            if([[tmpArray objectAtIndex:i] valueForKey:@"_id"])
            {
                tmpBlog.blogId=[[tmpArray objectAtIndex:i] valueForKey:@"_id"];
            }
            if([[tmpArray objectAtIndex:i] valueForKey:@"__v"])
            {
                tmpBlog.blogId=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            }
            // For Adding Categories
            tmpBlog.meta.category= MArray;
            for (int x=0; x<[[json objectForKey:@"category"] count]; x++) {
                [tmpBlog.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
            }
            tmpBlog.meta.tags= MArray;
            // For Adding Tags
            for (int x=0; x<[[json valueForKey:@"tags"] count]; x++) {
                [tmpBlog.meta.tags addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
            }
            
            // For Images
            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
            
            
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            
            
            if(jsonDict && [jsonDict count]>0)
            {
                if([sharedManager isNotNull:[jsonDict valueForKey:@"thumbnail"]])
                {
                    [tmpBlog.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                }
                
                if([sharedManager isNotNull:[jsonDict valueForKey:@"tabletHero"]])
                {
                    [tmpBlog.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
                }
                if([sharedManager isNotNull:[jsonDict valueForKey:@"phoneHero"]])
                {
                    [tmpBlog.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];
                }
            }

            // For Authors
            tmpBlog.meta.author=[[Authors alloc] init];
            tmpBlog.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpBlog.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpBlog.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpBlog.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            
            if(isAccess)
            {
                if(tmpBlog.meta.isActive){
                    [newArray addObject:tmpBlog];
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
            Blogs *tmpBlog=[[Blogs alloc] init];
            
            tmpBlog.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpBlog.blogUri=[[tmpArray objectAtIndex:i] valueForKey:@"uri"];
            tmpBlog.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            tmpBlog.body=[[tmpArray objectAtIndex:i] valueForKey:@"body"];
            tmpBlog.channelId=[[tmpArray objectAtIndex:i] valueForKey:@"channelId"];
            tmpBlog.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            tmpBlog.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            tmpBlog.heroImage=[[tmpArray objectAtIndex:i] valueForKey:@"hero_image"];
            tmpBlog.keywords=[[tmpArray objectAtIndex:i] valueForKey:@"keywords"];
            //tmpArticle.vv=[[tmpArray objectAtIndex:i] valueForKey:@"__v"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            // For Meta
            tmpBlog.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            tmpBlog.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpBlog.meta.updatedAt=[json valueForKey:@"updatedAt"];
            
            // For Adding Categories
            for (int x; x<[[json valueForKey:@"category"] count]; x++) {
                [tmpBlog.meta.category addObject:[[json objectForKey:@"category"] objectAtIndex:x]];
            }
            // For Adding Tags
            for (int x; x<[[json valueForKey:@"category"] count]; x++) {
                [tmpBlog.meta.category addObject:[[json objectForKey:@"tags"] objectAtIndex:x]];
            }
            
            // For Authors
            tmpBlog.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpBlog.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpBlog.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpBlog.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            
            // For Topics
            if([[tmpArray objectAtIndex:i] valueForKey:@"topicId"] && ![[[tmpArray objectAtIndex:i] valueForKey:@"topicId"] isKindOfClass:[NSNull class]])
            {
                tmpBlog.topicId=[[tmpArray objectAtIndex:i] valueForKey:@"topicId"];
            }
            // For Images
            NSData *strData = [[[tmpArray objectAtIndex:i] objectForKey:@"imageUrls"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            
            [tmpBlog.imageUrls setObject:[jsonDict valueForKey:@"thumbnail"] forKey:@"thumbnail"];
            [tmpBlog.imageUrls setObject:[jsonDict valueForKey:@"tabletHero"] forKey:@"tabletHero"];
            [tmpBlog.imageUrls setObject:[jsonDict valueForKey:@"phoneHero"] forKey:@"phoneHero"];

            
            [newArray addObject:tmpBlog];
            
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
