//
//  FMDBDataAccess.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDBDataAccess.h"
#import "FMResultSet.h"
#import "Utility.h"

@interface FMDBDataAccess : NSObject
{
    
}

-(BOOL) insertImagedData:(NSMutableDictionary *)dictData;

-(NSMutableArray*) getUsers:(NSString *)userID;
-(BOOL) updateImagedData:(NSMutableDictionary *)dictData;
-(NSMutableArray*)fetchAllGalleryDataFromLocalDB;
-(BOOL)deleteProductData:(NSString *)strID;
-(BOOL) updateproductdData:(NSString *)productId dictData:(NSMutableDictionary *)dictData;
-(BOOL)deleteAllProductData;




@end
