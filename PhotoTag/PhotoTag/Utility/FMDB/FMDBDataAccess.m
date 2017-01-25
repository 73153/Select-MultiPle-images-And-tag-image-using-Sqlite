//
//  FMDBDataAccess.m
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import "FMDBDataAccess.h"

@implementation FMDBDataAccess

-(BOOL) insertImagedData:(NSMutableDictionary *)dictData{
    // insert customer into database
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
//    NSString *strDescription=@"";
//    if([[dictData allKeys] containsObject:@"description"])
//        strDescription = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"description"]];
//    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
//    strDescription= [[strDescription componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@" "];
//    
//    
//    if(strDescription.length>100)
//        strDescription = [strDescription substringWithRange:NSMakeRange(0, 100)];
//    strDescription = [strDescription stringByReplacingOccurrencesOfString:@","
//                                                               withString:@""];
//    NSString *strBrand=@"";
//    if([[dictData allKeys] containsObject:@"brand"])
//        strBrand = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"brand"]];
//    strBrand = [[strBrand componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@" "];
//    
//
    NSString *strId=@"";
    if([[dictData allKeys] containsObject:@"id"])
        strId = [NSString stringWithFormat:@"%@",[dictData valueForKey:@"id"]];
    strId = [[strId componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ (date,id,imagedata,imageurl,location,name,tagadded) VALUES (%@,%@,%@,%@,%@,%@,%@);",@"PhotoTag",
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"date"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"id"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"imagedata"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"imageurl"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"location"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"name"]],
                             [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"tagadded"]]
                             ];
    
    BOOL success =  [db executeUpdate:insertQuery,nil];
    
    [db close];
    
    return success;
    
    return YES;
}

-(BOOL) updateImagedData:(NSMutableDictionary *)dictData{
    // insert customer into database
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    NSString *insertQuery =[NSString stringWithFormat:
                            @"UPDATE PhotoTag SET date = %@, imagedata = %@,imageurl = %@,location = %@,name = %@,tagadded = %@ WHERE id = %@ ",
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"date"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"imagedata"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"imageurl"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"location"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"name"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"tagadded"]],
                            [NSString stringWithFormat:@"'%@'",[dictData valueForKey:@"id"]]
                            ];
    
    
    BOOL success =  [db executeUpdate:insertQuery,nil];
    
    [db close];
    
    return success;
    
    return YES;
}
-(NSMutableArray*)fetchAllGalleryDataFromLocalDB
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    NSMutableArray *client = [[NSMutableArray alloc] init];
    NSString *getUserDataStr = [NSString stringWithFormat:@"select * from PhotoTag"];
    
    FMResultSet *results = [db executeQuery:getUserDataStr];
    
    while([results next])
    {
        NSDictionary *d =@{
                           @"date":[results stringForColumn:@"date"],
                           @"id":[results stringForColumn:@"id"],
                           @"imagedata":[results stringForColumn:@"imagedata"],
                           @"imageurl":[results stringForColumn:@"imageurl"],
                           @"location":[results stringForColumn:@"location"],
                           @"name":[results stringForColumn:@"name"],
                           @"tagadded":[results stringForColumn:@"tagadded"]
                           };
        [client addObject:d];
    }
    
    [db close];
    
    return client;
}
-(BOOL)deleteAllProductData{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *insertQuery = [NSString stringWithFormat:@"DELETE FROM LocalCartProduct"];
    BOOL success=[db executeUpdate:insertQuery,nil];
    
    return success;
}

-(BOOL)deleteProductData:(NSString *)strID{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *insertQuery = [NSString stringWithFormat:@"DELETE FROM LocalCartProduct WHERE id = %@",strID];
    BOOL success=[db executeUpdate:insertQuery,nil];
    
    return success;
}



@end
