//
//  Channels.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 07/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "Channels.h"

@implementation Channels
@synthesize channelId,channelType,clientId,desc,deviceToken,icon,label,meta,uuid,vv,channelsCountForFilter;
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.channelId forKey:@"channelId"];
    [encoder encodeObject:self.channelType forKey:@"channelType"];
    [encoder encodeObject:self.clientId forKey:@"clientId"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.label forKey:@"label"];
    [encoder encodeObject:self.meta forKey:@"meta"];
    [encoder encodeObject:self.user forKey:@"user"];
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    [encoder encodeObject:self.vv forKey:@"vv"];
    [encoder encodeObject:self.aryUserAccess forKey:@"userAccess"];
    [encoder encodeObject:self.channelsCountForFilter forKey:@"count"];

    self.channelsCountForFilter=0;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.channelId = [decoder decodeObjectForKey:@"channelId"];
        self.channelType = [decoder decodeObjectForKey:@"channelType"];
        self.clientId = [decoder decodeObjectForKey:@"clientId"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.deviceToken = [decoder decodeObjectForKey:@"deviceToken"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.label = [decoder decodeObjectForKey:@"label"];
        self.meta = [decoder decodeObjectForKey:@"meta"];
        self.user = [decoder decodeObjectForKey:@"user"];
        
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
        self.vv = [decoder decodeObjectForKey:@"vv"];
        self.aryUserAccess= [decoder decodeObjectForKey:@"userAccess"];
        self.channelsCountForFilter= [decoder decodeObjectForKey:@"count"];

    }
    return self;
}
+ (void)saveCustomObject:(Channels *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (Channels *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    Channels *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
-(instancetype)init
{
    self = [super init];
    if(self) {
        
        self.channelId=[[NSMutableString alloc]init];
        self.channelType=[[NSMutableString alloc]init];
        self.clientId=[[NSMutableString alloc]init];
        self.desc=[[NSMutableString alloc]init];
        self.deviceToken=[[NSMutableString alloc]init];
        self.icon=[[NSMutableString alloc]init];
        self.label=[[NSMutableString alloc] init];
        self.uuid=[[NSMutableString alloc] init];
        self.vv=[[NSMutableString alloc] init];
        self.channelsCountForFilter=[[NSMutableString alloc] init];
        self.meta=[[Meta alloc] init];
        self.user=[[Users alloc] init];
        self.topicLists=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)getChannels:(channel_completion_block)completion{
    NSString *url_String = [NSString stringWithFormat:@"%@", API_CHANNEL_LIST];
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
                        completion(user,ERROR_CHANNEL_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    
                    completion(user,SUCCESS_READING_LIST,1);
                }
                else{
                    completion(user,ERROR_CHANNEL_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getChannelsWithTimeStamp:(NSDate *)timestamp andCompletion:(channel_completion_block)completion{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSString *stringFromDate = [dateFormat stringFromDate:timestamp];
    NSString *url_String = [NSString stringWithFormat:@"%@?ts=%@", API_CHANNEL_LIST,stringFromDate];
    
    
    Globals *sharedManager;
    
    sharedManager=[Globals sharedManager];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"activeToken"])
    {
        sharedManager.user.activeToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"activeToken"];
    }
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
                        completion(user,ERROR_CHANNEL_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    // Need to replace the url strin g
                    
                    completion(user,SUCCESS_READING_LIST,1);
                }
                else{
                    completion(user,ERROR_CHANNEL_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getChannelType:(NSString *)channelType withCompletionBlock:(channel_completion_block)completion
{
    NSString *url_String = [NSString stringWithFormat:@"%@", API_CHANNEL_LIST];
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
                        completion(user,ERROR_CHANNEL_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCCESS_USER_REGISTRATION,1);
                }
                else{
                    completion(user,ERROR_CHANNEL_LIST,0);
                }
            }
        }
        
    }];
}
+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result{
    NSMutableArray *tmpArray=MArray;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    @try {
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
            ch.meta.isActive=[[[result objectAtIndex:i] valueForKey:@"isActive"] boolValue];
            ch.meta.isValidated=[[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"isValidated"] boolValue];
            ch.meta.lastUpdated=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"lastUpdated"];
            ch.meta.updatedAt=[[[result objectAtIndex:i] objectForKey:@"meta" ] valueForKey:@"updatedAt"];
            ch.type=[[result objectAtIndex:i] valueForKey:@"type"];
            ch.aryUserAccess = MArray;
            ch.aryUserAccess=[[result objectAtIndex:i] valueForKey:@"userAccess"];
            ch.url=[[result objectAtIndex:i] valueForKey:@"url"];
            NSData *data = [[[result objectAtIndex:i] valueForKey:@"topics"] dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            ch.topicLists=MArray;
            for (int j=0; j<[json count]; j++) {
                //
                if([sharedManager isNotNull:[json objectAtIndex:j]]){
                Topics *tmpTopic=[[Topics alloc] init];
                tmpTopic.topicId = [[json objectAtIndex:j] valueForKey:@"_id"];
                tmpTopic.uuid = [[json objectAtIndex:j] valueForKey:@"uuid"];
                tmpTopic.clientId = [[json objectAtIndex:j] valueForKey:@"clientId"];
                tmpTopic.topicname = [[json objectAtIndex:j] valueForKey:@"topicname"];
                
                
                tmpTopic.meta.createdAt=[[[json  objectAtIndex:j]  objectForKey:@"meta"]valueForKey:@"createdAt"];
                tmpTopic.meta.isActive=[[[[json objectAtIndex:j]  objectForKey:@"meta"]valueForKey:@"isActive"] boolValue];
                tmpTopic.meta.isNotificationActive=[[[[json objectAtIndex:j]  objectForKey:@"meta"]valueForKey:@"isNotificationActive"] boolValue];
                tmpTopic.channelId=[[[json objectAtIndex:j]   valueForKey:@"channelId"] mutableCopy];
                ch.meta.updatedAt=[[[json objectAtIndex:j]  objectForKey:@"meta" ]valueForKey:@"updatedAt"];
                
                [ch.topicLists addObject:tmpTopic];
                }
            }
            if([sharedManager isNotNull:json]){

            NSData *strData = [[NSString stringWithFormat:@"%@",ch.aryUserAccess] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:strData options:0 error:nil];
            BOOL tempBool = false;
            
            NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userTypeId"]];
            for(int i = 0; i <= jsonDict.count;i++){
                if([[jsonDict objectAtIndex:i] isEqualToString:str]){
                    tempBool = true;
                    break;
                }
            }
            if(tempBool)
            {
                if(ch.meta.isActive){
                    [tmpArray addObject:ch];
                }
            }
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return tmpArray;
}
@end
