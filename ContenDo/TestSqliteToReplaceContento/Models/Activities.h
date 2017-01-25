//
//  Activities.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APICall.h"
#import "Constants.h"
@class Database;
@interface Activities : NSObject
typedef void(^activity_completion_block)(NSDictionary *result,NSString *str, int status);
typedef void(^activity_db_completion_block)(NSArray *result,NSString *str, int status);
@property NSMutableDictionary *json;
@property Database *db;
@property BOOL isSync;
-(void)getUnSyncActivity :(activity_db_completion_block)completion;
-(void)saveActivity:(NSDictionary *)dic withCompletion:(activity_completion_block)completion;
-(void)saveActivityWithoutInsert:(NSDictionary *)dic withCompletion:(activity_completion_block)completion;
@end
