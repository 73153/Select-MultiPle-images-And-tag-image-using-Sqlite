//
//  Database.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 23/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "Database.h"


@implementation Database
-(instancetype)init{
    self = [super init];
    if(self) {
        self.dbAccess= [FMDBDataAccess new];
    }
    return self;
}
-(void)emptyDatabase{
    [self executeQuery:@"DELETE FROM channels; "];
    [self executeQuery:@"DELETE FROM articles;"];
    [self executeQuery:@"DELETE FROM readinglists;"];
}
#pragma mark Database Storage

-(BOOL)insertArticles:(NSDictionary *)dict {
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"desc"]];
        NSData *dataSummary = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"summary"]];
        NSData *dataTitle = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"title"]];
        success = [db executeUpdate:@"insert into articles (title,articleUri,summary,desc,channelId, clientId,meta,imageUrls,uuid,topicId,id) VALUES(?,?,?,?,?,?,?,?,?,?,?)",dataTitle, [dict valueForKey:@"articleUri"],dataSummary,data,[dict valueForKey:@"channelId"],[dict valueForKey:@"clientId"],[dict valueForKey:@"meta"],[dict valueForKey:@"imageUrls"],[dict valueForKey:@"uuid"],[dict valueForKey:@"topicId"],[dict valueForKey:@"uuid"]];
        
        
        
//        if([[dict allKeys] containsObject:@"meta"])
//        {
//            NSError *jsonError;
//            NSData *objectData = [[dict objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//            }
//        }
        [db close];
        
    });
    
    //    if ([[dict valueForKey:@"isActive"]isEqualToString:@"0"]) {
    //        [self deleteQueryWithTable:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
    //    }
    return success;
    // NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:dataForColumn:"yourcololumname"];
}
-(BOOL)updateArticles:(NSDictionary *)dict {
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        
        
        NSString *updateQuery =[NSString stringWithFormat:@"UPDATE articles SET title = %@,articleUri = %@,summary = %@,desc = %@,channelId =%@,topicId = %@,meta = %@,imageUrls = %@,clientId = %@ WHERE uuid=%@",
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"title"]]
                                ,
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"articleUri"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"summary"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"desc"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"channelId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"topicId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"meta"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"imageUrls"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"clientId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"uuid"]]
                                
                                ];
        
        success = [db executeUpdate:updateQuery];
        
        
        
//        if([[dict allKeys] containsObject:@"meta"])
//        {
//            NSError *jsonError;
//            NSData *objectData = [[dict objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//            }
//        }
        [db close];
        
    });
    
    
    //    if ([[dict valueForKey:@"isActive"]isEqualToString:@"0"]) {
    //        [self deleteQueryWithTable:@"articles" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
    //    }
    return success;
    // NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:dataForColumn:"yourcololumname"];
}
-(BOOL)insertBlogs:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion{
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"body"]];
        NSData *dataSummary = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"summary"]];
        NSData *dataTitle = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"title"]];
        NSData *dataKeywords = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"keywords"]];
        
        success = [db executeUpdate:@"insert into blogs (title,uri,summary,body,channelId, clientId,meta,imageUrls,hero_image,keywords,uuid,topicId,id) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",dataTitle, [dict valueForKey:@"uri"],dataSummary,data,[dict valueForKey:@"channelId"],[dict valueForKey:@"clientId"],[dict valueForKey:@"meta"],[dict valueForKey:@"imageUrls"],[dict valueForKey:@"hero_image"],dataKeywords,[dict valueForKey:@"uuid"],[dict valueForKey:@"topicId"],[dict valueForKey:@"uuid"]];
        
        
        //        NSString *strUserTypeId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userTypeId"];
        //        if([[dict allValues]containsObject:strUserTypeId])
        //            [self deleteQueryWithTable:@"blogs" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//        if([[dict allKeys] containsObject:@"meta"])
//        {
//            NSError *jsonError;
//            NSData *objectData = [[dict objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:@"blogs" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//            }
//        }
        [db close];
        
        if (completion) {
            completion(success);
        }
    });
    //    [db close];
    return success;
    
    // NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:dataForColumn:"yourcololumname"];
}
-(BOOL)updateBlogs:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion{
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        
        
        NSString *updateQuery =[NSString stringWithFormat:@"UPDATE blogs SET title = %@,uri = %@,summary = %@,body = %@,channelId =%@,topicId=%@,meta = %@,imageUrls = %@,hero_image = %@,keywords = %@,clientId = %@ WHERE uuid=%@",
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"title"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"uri"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"summary"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"body"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"channelId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"topicId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"meta"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"imageUrls"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"hero_image"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"keywords"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"clientId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"uuid"]]
                                
                                ];
        
        
        
        success = [db executeUpdate:updateQuery];
        
//        if([[dict allKeys] containsObject:@"meta"])
//        {
//            NSError *jsonError;
//            NSData *objectData = [[dict objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:@"blogs" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//            }
//        }
        [db close];
        
        if (completion) {
            completion(success);
        }
    });
    return success;
    
}
-(BOOL)updateVideos:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion{
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        NSString *updateQuery =[NSString stringWithFormat:@"UPDATE videos SET title=%@,uri=%@,summary=%@,channelId=%@, clientId=%@,meta=%@,imageUrls=%@,hero_image=%@,topicId=%@,thumbnail=%@,phonehero=%@,tablethero=%@  WHERE uuid=%@",
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"title"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"uri"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"summary"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"channelId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"clientId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"meta"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"imageUrls"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"hero_image"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"topicId"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"thumbnail"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"phoneHero"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"tabletHero"]],
                                [NSString stringWithFormat:@"'%@'",[dict valueForKey:@"uuid"]]
                                
                                ];
        
        success = [db executeUpdate:updateQuery];
        
        
        
//        if([[dict allKeys] containsObject:@"meta"])
//        {
//            NSError *jsonError;
//            NSData *objectData = [[dict objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:@"videos" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//            }
//        }
        [db close];
        
        if (completion) {
            completion(success);
        }
        
    });
    
    return success;
}

-(BOOL)insertVideos:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion{
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        NSData *dataSummary = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"summary"]];
        NSData *dataTitle = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"title"]];
        success = [db executeUpdate:@"insert into videos (title,uri,summary,channelId, clientId,meta,imageUrls,hero_image,uuid,topicId,thumbnail,phonehero,tablethero) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)",dataTitle, [dict valueForKey:@"uri"],dataSummary,[dict valueForKey:@"channelId"],[dict valueForKey:@"clientId"],[dict valueForKey:@"meta"],[dict valueForKey:@"imageUrls"],[dict valueForKey:@"hero_image"],[dict valueForKey:@"uuid"],[dict valueForKey:@"topicId"],[dict valueForKey:@"thumbnail"],[dict valueForKey:@"phoneHero"],[dict valueForKey:@"tabletHero"]];
        
//        if([[dict allKeys] containsObject:@"meta"])
//        {
//            NSError *jsonError;
//            NSData *objectData = [[dict objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:@"videos" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//            }
//        }
        [db close];
        
        if (completion) {
            completion(success);
        }
    });
    return success;
}
// Core functions to Insert Query
-(BOOL)insertQueryWithDictionary:(NSDictionary *)dic inTable:(NSString *)table
{
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        
        NSMutableString *insertQ=MString;
        NSArray *keys=[[NSArray alloc] initWithArray:[dic allKeys]];
        NSArray *values=[[NSArray alloc] initWithArray:[dic allValues]];
        [insertQ appendString:[NSString stringWithFormat: @"insert into %@(",table ]];
        for (int i=0; i<[keys count]; i++) {
            if(i==([keys count]-1))
            {
                [insertQ appendString:[NSString stringWithFormat: @" %@ ",[keys objectAtIndex:i] ]];
            }
            else{
                [insertQ appendString:[NSString stringWithFormat: @" %@ , ",[keys objectAtIndex:i] ]];
            }
        }
        [insertQ appendString:@") values ("];
        for (int i=0; i<[values count]; i++) {
            if(i==([values count]-1))
            {
                [insertQ appendString:[NSString stringWithFormat: @" '%@' ",[values objectAtIndex:i] ]];
            }
            else{
                [insertQ appendString:[NSString stringWithFormat: @" '%@' , ",[values objectAtIndex:i] ]];
            }
        }
        [insertQ appendString:@");"];
        
        success =  [db executeUpdate:insertQ,nil];
        [db close];
        
        
    });
    
    
    return success;
}

- (BOOL)updateQueryWithDictionary:(NSString *)table withAttribute:(NSDictionary *)attribute withSQLCondition:(NSString *)condition
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    __block BOOL updateResult = NO;
    if ([db open]) {
        NSArray *allValues = [attribute allValues];
        NSMutableString *prefixBindString = [[NSMutableString alloc] init];
        [prefixBindString appendFormat:@"update %@ set ",table];
        
        for (int i = 0; i != [[attribute allKeys] count]; ++ i) {
            NSString *keyString = [[attribute allKeys] objectAtIndex:i];
            [prefixBindString appendFormat:@"%@=? ",keyString];
            if (i != [[attribute allKeys] count] - 1) {
                [prefixBindString appendString:@","];
            } else {
                [prefixBindString appendString:[self realForString:condition]];
            }
        }
        updateResult = [db executeUpdate:prefixBindString withArgumentsInArray:allValues];
        if (!updateResult) {
        }
        if (![db close]) {
        }
    }
    return updateResult;
}
- (NSString *)realForString:(NSString *)value
{
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",value];
    } else {
        return value;
    }
}

-(BOOL)insertChannel:(NSDictionary *)dict WithCompletionBlock:(db_completion_block)completion{
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        NSData *dataDesc = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"desc"]];
        NSData *dataChannelType = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"channelType"]];
        NSData *dataClientId = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"clientId"]];
        NSData *dataUrl = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"url"]];
        NSData *dataUuid = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"uuid"]];
        NSData *dataLastUpdated = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"lastUpdated"]];
        NSData *dataCreatedAt = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"createdAt"]];
        NSData *dataUpdatedAt = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"updatedAt"]];
        NSData *dataLabel = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"label"]];
        NSData *dataTopics = [NSKeyedArchiver archivedDataWithRootObject:[dict valueForKey:@"topics"]];
        
        success = [db executeUpdate:@"insert into channels (channelType,clientId,createdAt,desc, icon,isActive,isValidated,label,lastUpdated,topics,type,updatedAt,url,uuid) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",dataChannelType, dataClientId,dataCreatedAt,dataDesc,[dict valueForKey:@"icon"],[dict valueForKey:@"isActive"],[dict valueForKey:@"isValidated"],dataLabel,dataLastUpdated,dataTopics,[dict valueForKey:@"type"],dataUpdatedAt,dataUrl,dataUuid];
        
        if([[dict allKeys] containsObject:@"meta"])
        {
//            NSError *jsonError;
//            NSData *objectData = [[dict objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:@"channels" andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dict valueForKey:@"uuid"]]];
//            }
        }
        [db close];
        
        if (completion) {
            completion(success);
        }
    });
    //    [db close];
    return success;
    // NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:dataForColumn:"yourcololumname"];
}


-(void)insertQueryWithDictionary:(NSDictionary *)dic inTable:(NSString *)table WithCompletionBlock:(db_completion_block)completion
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        
        NSMutableString *insertQ=MString;
        NSArray *keys=[[NSArray alloc] initWithArray:[dic allKeys]];
        NSArray *values=[[NSArray alloc] initWithArray:[dic allValues]];
        [insertQ appendString:[NSString stringWithFormat: @"insert into %@(",table ]];
        for (int i=0; i<[keys count]; i++) {
            if(i==([keys count]-1))
            {
                [insertQ appendString:[NSString stringWithFormat: @" %@ ",[keys objectAtIndex:i] ]];
            }
            else{
                [insertQ appendString:[NSString stringWithFormat: @" %@ , ",[keys objectAtIndex:i] ]];
            }
        }
        [insertQ appendString:@") values ("];
        for (int i=0; i<[values count]; i++) {
            if(i==([values count]-1))
            {
                [insertQ appendString:[NSString stringWithFormat: @" '%@' ",[values objectAtIndex:i] ]];
            }
            else{
                [insertQ appendString:[NSString stringWithFormat: @" '%@' , ",[values objectAtIndex:i] ]];
            }
        }
        [insertQ appendString:@");"];
        
        
//        NSString *strUserTypeId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userTypeId"];
//        if([values containsObject:strUserTypeId])
//            [self deleteQueryWithTable:table andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dic valueForKey:@"uuid"]]];
        
        
        BOOL success =  [db executeUpdate:insertQ,nil];
//        if([[dic allKeys] containsObject:@"meta"])
//        {
//            NSError *jsonError;
//            NSData *objectData = [[dic objectForKey:@"meta"] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                 options:NSJSONReadingMutableContainers
//                                                                   error:&jsonError];
//            if ([[json objectForKey:@"isActive"] boolValue]==0) {
//                [self deleteQueryWithTable:table andWithWhereCondition:[NSString stringWithFormat: @"uuid='%@'",[dic valueForKey:@"uuid"]]];
//            }
//        }
        
        [db close];
        if (completion) {
            completion(success);
        }
    });
}
-(BOOL)insertBatchQuery:(NSString *)query
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    
    
    BOOL success =  [db executeUpdate:query,nil];
    [db close];
    
    return success;
}

-(NSArray *)selectAllQueryWithTableName :(NSString *)tableName
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    NSString *query=[NSString stringWithFormat:@"select * from %@",tableName];
    FMResultSet *results = [db executeQuery:query];
    NSMutableArray *data=[[NSMutableArray alloc] init];
    while([results next])
    {
        NSMutableDictionary *d= [[NSMutableDictionary alloc] init];
        for (int j=0; j<[results columnCount]; j++) {
            NSString *value;
            if ([results stringForColumnIndex:j]) {
                value=[results stringForColumnIndex:j];
            }
            else{
                NSData *data = [results dataForColumnIndex:j];
                if (data.bytes>0) {
                    NSMutableString *bodyStr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if (bodyStr) {
                        value = [bodyStr copy];
                    }
                    else
                        value=@"0";
                }
                else
                    value=@"0";
            }
            [d setObject:value forKey:[results columnNameForIndex:j] ];
            
        }
        [data addObject:d];
    }
    
    [db close];
    return data;
}
-(NSArray *)selectAllFilledChannelsWithTableName
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    NSString *query=[NSString stringWithFormat:@"select * from channels"];

    //    NSString *query=[NSString stringWithFormat:@"select * from channels where uuid in  (select distinct(channelId) from articles ) OR uuid in (select distinct(channelId) from videos) OR uuid in (select distinct(channelId) from blogs)"];
    FMResultSet *results = [db executeQuery:query];
    NSMutableArray *data=[[NSMutableArray alloc] init];
    while([results next])
    {
        NSMutableDictionary *d= [[NSMutableDictionary alloc] init];
        for (int j=0; j<[results columnCount]; j++) {
            NSString *value;
            if ([results stringForColumnIndex:j]) {
                value=[results stringForColumnIndex:j];
            }
            else{
                NSData *data = [results dataForColumnIndex:j];
                if (data.bytes>0) {
                    NSMutableString *bodyStr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if (bodyStr) {
                        value = [bodyStr copy];
                    }
                    else
                        value=@"0";
                }
                else
                    value=@"0";
            }
            [d setObject:value forKey:[results columnNameForIndex:j] ];
            
        }
        [data addObject:d];
    }
    
    [db close];
    return data;
}
-(NSString *)generateQuery:(NSDictionary *)dic inTable:(NSString *)table{
    NSMutableString *insertQ=MString;
    NSArray *keys=[[NSArray alloc] initWithArray:[dic allKeys]];
    NSArray *values=[[NSArray alloc] initWithArray:[dic allValues]];
    [insertQ appendString:[NSString stringWithFormat: @"insert into %@(",table ]];
    for (int i=0; i<[keys count]; i++) {
        if(i==([keys count]-1))
        {
            [insertQ appendString:[NSString stringWithFormat: @" %@ ",[keys objectAtIndex:i] ]];
        }
        else{
            [insertQ appendString:[NSString stringWithFormat: @" %@ , ",[keys objectAtIndex:i] ]];
        }
    }
    [insertQ appendString:@") values ("];
    for (int i=0; i<[values count]; i++) {
        if(i==([values count]-1))
        {
            [insertQ appendString:[NSString stringWithFormat: @" '%@' ",[values objectAtIndex:i] ]];
        }
        else{
            [insertQ appendString:[NSString stringWithFormat: @" '%@' , ",[values objectAtIndex:i] ]];
        }
    }
    [insertQ appendString:@");"];
    return insertQ;
}
-(NSArray *)selectWhereQueryWithTableName :(NSString *)tableName andWithWhereCondition:(NSString *) where{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    NSString *query=[NSString stringWithFormat:@"select * from %@ where %@",tableName, where];
    FMResultSet *results = [db executeQuery:query];
    NSMutableArray *data=[[NSMutableArray alloc] init];
    int i=0;
    while([results next])
    {
        NSMutableDictionary *d= [[NSMutableDictionary alloc] init];
        for (int j=0; j<[results columnCount]; j++) {
            NSString *value;
            if ([results stringForColumnIndex:j]) {
                value=[results stringForColumnIndex:j];
            }
            else{
                NSData *data = [results dataForColumnIndex:j];
                if (data.bytes>0) {
                    NSMutableString *bodyStr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if (bodyStr) {
                        value = [bodyStr copy];
                    }
                    else
                        value=@"0";
                }
                else
                    value=@"0";
            }
            [d setObject:value  forKey:[results columnNameForIndex:j] ];
        }
        [data addObject:d];
        i++;
    }
    [db close];
    return data;
}
-(NSArray *)selectWhereQueryWithTableName :(NSString *)tableName andWithWhereCondition:(NSString *) where withOrderbyID:(BOOL)isOrderby{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    NSString *query;
    if (isOrderby) {
        query=[NSString stringWithFormat:@"select * from %@ where %@ order by id desc",tableName, where];
    }
    else{
        query=[NSString stringWithFormat:@"select * from %@ where %@",tableName, where];
    }
    
    FMResultSet *results = [db executeQuery:query];
    NSMutableArray *data=[[NSMutableArray alloc] init];
    int i=0;
    
    while([results next])
    {
        NSMutableDictionary *d= [[NSMutableDictionary alloc] init];
        for (int j=0; j<[results columnCount]; j++) {
            NSString *value;
            if ([results stringForColumnIndex:j]) {
                value=[results stringForColumnIndex:j];
            }
            else{
                NSData *data = [results dataForColumnIndex:j];
                if (data.bytes>0) {
                    NSMutableString *bodyStr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if (bodyStr) {
                        value = [bodyStr copy];
                    }
                    else
                        value=@"0";
                }
                else
                    value=@"0";
            }
            [d setObject:value  forKey:[results columnNameForIndex:j] ];
        }
        [data addObject:d];
        i++;
    }
    [db close];
    return data;
}
-(NSArray *)selectWhereQueryWithTableName :(NSString *)tableName andORDERBYString:(NSString *) orderby{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    NSString *query=[NSString stringWithFormat:@"select * from %@ %@",tableName, orderby];
    FMResultSet *results = [db executeQuery:query];
    NSMutableArray *data=[[NSMutableArray alloc] init];
    int i=0;
    while([results next])
    {
        NSMutableDictionary *d= [[NSMutableDictionary alloc] init];
        for (int j=0; j<[results columnCount]; j++) {
            NSString *value;
            if ([results stringForColumnIndex:j]) {
                value=[results stringForColumnIndex:j];
            }
            else{
                NSData *data = [results dataForColumnIndex:j];
                if (data.bytes>0) {
                    NSMutableString *bodyStr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    if (bodyStr) {
                        value = [bodyStr copy];
                    }
                    else
                        value=@"0";
                }
                else
                    value=@"0";
            }
            [d setObject:value forKey:[results columnNameForIndex:j] ];
        }
        [data addObject:d];
        i++;
    }
    [db close];
    return data;
}

-(BOOL)deleteQueryWithTable: (NSString *)table{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM %@",table];
    BOOL success=[db executeUpdate:deleteQuery,nil];
    if(success){
        // Success
        success=true;
    }
    [db close];
    return success;
}
-(BOOL)deleteQueryWithTable :(NSString *)tableName andWithWhereCondition:(NSString *) where
{
    __block BOOL success ;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
        [db open];
        NSString *query=[NSString stringWithFormat:@"DELETE FROM %@ where %@",tableName, where];
        success=[db executeUpdate:query,nil];
        if(success){
            // Success
            success=true;
        }
        [db close];
    });
    return success;
}
-(BOOL)executeQuery: (NSString *)query{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
    [db open];
    
    NSString *deleteQuery = [NSString stringWithFormat:@"%@",query];
    BOOL success=[db executeUpdate:deleteQuery,nil];
    if(success){
        // Success
        // success=true;
    }
    [db close];
    return success;
}
@end
