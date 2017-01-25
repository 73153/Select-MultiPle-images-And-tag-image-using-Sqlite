//
//  Database.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 23/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Authors.h"
#import "Users.h"
#import "Articles.h"
#import "FMDBDataAccess.h"
@class FMDBDataAccess;
@interface Database : NSObject
@property FMDBDataAccess *dbAccess;
-(void)emptyDatabase;
-(BOOL)insertQueryWithDictionary:(NSDictionary *)dic inTable:(NSString *)table;

-(NSArray *)selectAllQueryWithTableName :(NSString *)tableName;
-(NSArray *)selectWhereQueryWithTableName :(NSString *)tableName andWithWhereCondition:(NSString *) where;
-(NSArray *)selectWhereQueryWithTableName :(NSString *)tableName andORDERBYString:(NSString *) orderby;
-(NSString *)generateQuery:(NSDictionary *)dic inTable:(NSString *)table;
-(BOOL)deleteQueryWithTable :(NSString *)tableName andWithWhereCondition:(NSString *) where;
-(NSArray *)selectWhereQueryWithTableName :(NSString *)tableName andWithWhereCondition:(NSString *) where withOrderbyID:(BOOL)isOrderby;
-(BOOL)executeQuery: (NSString *)query;
-(BOOL)insertBatchQuery:(NSString *)query;
typedef void(^db_completion_block)(BOOL status);
-(void)insertQueryWithDictionary:(NSDictionary *)dic inTable:(NSString *)table WithCompletionBlock:(db_completion_block)completion;
-(NSArray *)selectAllFilledChannelsWithTableName;
-(BOOL)insertArticles:(NSDictionary *)dict;
-(BOOL)insertBlogs:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion;

- (BOOL)updateQueryWithDictionary:(NSString *)table withAttribute:(NSDictionary *)attribute withSQLCondition:(NSString *)condition;
-(BOOL)updateArticles:(NSDictionary *)dict;
-(BOOL)updateBlogs:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion;
-(BOOL)updateVideos:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion;
-(BOOL)insertVideos:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion;
-(BOOL)insertChannel:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion;
-(BOOL)deleteQueryWithTable: (NSString *)table;
@end
