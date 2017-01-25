//
//  Activities.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import "Activities.h"

@implementation Activities
-(instancetype)init{
    self = [super init];
    if(self) {
        self.db= [[Database alloc] init];
        self.json=[[NSMutableDictionary alloc] init];
        self.isSync=false;
    }
    return self;
}
-(void)getUnSyncActivity :(activity_db_completion_block)completion{
    if (completion) {
        NSArray *results=[self.db selectWhereQueryWithTableName:@"activities" andWithWhereCondition:@"isSync=0 order by id desc" ];
        completion(results,@"Success",1);
    }
}
-(void)saveActivity:(NSDictionary *)dic withCompletion:(activity_completion_block)completion{
    Globals *sharedManager=[Globals sharedManager];
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc] init];
    
    [APICall callPostWebService:API_ACTIVITY andDictionary:dic withToken:sharedManager.user.token completion:^(NSMutableDictionary *result, NSError *error, long code) {
        //
        if ([[result valueForKey:@"success"] boolValue]) {
            //Success
            self.isSync=true;
            [tmpDic setObject:jsonString forKey:@"json"];
            [tmpDic setObject:@"1" forKey:@"isSync"];
            if ([self.db insertQueryWithDictionary:tmpDic inTable:@"activities"]) {
            }
            if (completion) {
                completion(result,@"Success",1);
            }
        }
        else{
            //Error
            self.isSync=false;
            [tmpDic setObject:jsonString forKey:@"json"];
            [tmpDic setObject:@"0" forKey:@"isSync"];
            if ([self.db insertQueryWithDictionary:tmpDic inTable:@"activities"]) {
            }
            if (completion) {
                completion(result,@"Failed",0);
            }
        }
    }];
}

-(void)saveActivityWithoutInsert:(NSDictionary *)dic withCompletion:(activity_completion_block)completion{
    Globals *sharedManager=[Globals sharedManager];
    NSError * error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:kNilOptions
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *tmpDic=[[NSMutableDictionary alloc] init];
    
    [APICall callPostWebService:API_ACTIVITY andDictionary:dic withToken:sharedManager.user.token completion:^(NSMutableDictionary *result, NSError *error, long code) {
        //
        if ([[result valueForKey:@"success"] boolValue]) {
            //Success
            self.isSync=true;
            [tmpDic setObject:jsonString forKey:@"json"];
            [tmpDic setObject:@"1" forKey:@"isSync"];
            
            if (completion) {
                completion(result,@"Success",1);
            }
        }
        else{
            //Error
            self.isSync=false;
            [tmpDic setObject:jsonString forKey:@"json"];
            [tmpDic setObject:@"0" forKey:@"isSync"];
            
            if (completion) {
                completion(result,@"Failed",0);
            }
        }
    }];
}
@end
