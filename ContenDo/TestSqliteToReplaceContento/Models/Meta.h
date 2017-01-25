//
//  Meta.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 07/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Authors.h"
@interface Meta : NSObject
@property BOOL isValidated,isActive, isNotificationActive;
@property NSMutableString *createdAt,*updatedAt,*lastUpdated,*userTypeId;
@property NSMutableArray *category, *tags;
@property Authors *author;
+ (void)saveCustomObject:(Meta *)object key:(NSString *)key;
+ (Meta *)loadCustomObjectWithKey:(NSString *)key;
@end
