//
//  Pages.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 08/04/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import "Pages.h"

@implementation Pages
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.pageId=[[NSMutableString alloc]init];
        self.desc=[[NSMutableString alloc]init];
        self.pageType=(type)AboutUs;
        self.clientId=[[NSMutableString alloc]init];
        self.summary=[[NSMutableString alloc] init];
        self.title=[[NSMutableString alloc] init];
        self.uuid=[[NSMutableString alloc]init];
    }
    return self;
}
-(void)getAllPages:(page_completion_block)completion
{
    NSString *url_String = [NSString stringWithFormat:@"%@", API_PAGE_LIST];
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
                if([[user valueForKey:@"success"]integerValue]==0)
                {
                    if (![user valueForKey:@"message"]) {
                        completion(user,ERROR_PAGE_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_PAGE_LIST,1);
                }
                else{
                    completion(user,ERROR_PAGE_LIST,0);
                }
            }
        }
        
    }];
}
-(void)getPagesWithTimeStamp:(NSDate *)time withCompletion:(page_completion_block)completion
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSString *stringFromDate = [dateFormat stringFromDate:time];
    NSString *url_String = [NSString stringWithFormat:@"%@/?ts=%@", API_PAGE_LIST,stringFromDate];
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
                if([[user valueForKey:@"success"]integerValue]==0)
                {
                    if (![user valueForKey:@"message"]) {
                        completion(user,ERROR_PAGE_LIST,0);
                    }
                    else{
                        completion(user,[user valueForKey:@"message"],0);
                    }
                    
                }
                else if([[user valueForKey:@"success"]integerValue]==1){
                    completion(user,SUCEESS_PAGE_LIST,1);
                }
                else{
                    completion(user,ERROR_PAGE_LIST,0);
                }
            }
        }
        
    }];
}
+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result{
    NSMutableArray *tmpArray=[result mutableCopy];
    NSMutableArray *newArray=MArray;
    for (int i=0; i<[tmpArray count]; i++) {
        //Parsing Article List
        @try {
            Pages *tmpPage=[[Pages alloc] init];
            tmpPage.pageId=[[tmpArray objectAtIndex:i] valueForKey:@"_id"];
            tmpPage.desc=[[tmpArray objectAtIndex:i] valueForKey:@"desc"];
            tmpPage.summary=[[tmpArray objectAtIndex:i] valueForKey:@"summary"];
            NSString *typePage=[[tmpArray objectAtIndex:i] valueForKey:@"pageType"];
            if ([typePage isEqualToString:@"about-us"]) {
                tmpPage.pageType=(type)AboutUs;
            }
            else if ([typePage isEqualToString:@"policy-privacy"]) {
                tmpPage.pageType=(type)PrivacyPolicy;
            }
            else if ([typePage isEqualToString:@"Legal"]) {
                tmpPage.pageType=(type)Legal;
            }
            else if ([typePage isEqualToString:@"policy-cookie"]) {
                tmpPage.pageType=(type)Cookies;
            }
            else if ([typePage isEqualToString:@"terms-of-use"]) {
                tmpPage.pageType=(type)Terms;
            }
            tmpPage.title=[[tmpArray objectAtIndex:i] valueForKey:@"title"];
            tmpPage.clientId=[[tmpArray objectAtIndex:i] valueForKey:@"clientId"];
            tmpPage.uuid=[[tmpArray objectAtIndex:i] valueForKey:@"uuid"];
            
            NSData *strData1 = [[[tmpArray objectAtIndex:i] objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            // For Meta
            tmpPage.meta.isActive=[[json valueForKey:@"isActive"] boolValue];
            tmpPage.meta.createdAt=[json valueForKey:@"createdAt"];
            tmpPage.meta.updatedAt=[json valueForKey:@"updatedAt"];
            // For Authors
            tmpPage.meta.author=[[Authors alloc] init];
            tmpPage.meta.author.name=[[json objectForKey:@"author"] valueForKey:@"name"];
            tmpPage.meta.author.company=[[json objectForKey:@"author"] valueForKey:@"company"];
            tmpPage.meta.author.blurb=[[json objectForKey:@"author"] valueForKey:@"blurb"];
            tmpPage.meta.author.uuid=[[json objectForKey:@"author"] valueForKey:@"uuid"];
            
            [newArray addObject:tmpPage];
            
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
    }
    return newArray;
}
@end
