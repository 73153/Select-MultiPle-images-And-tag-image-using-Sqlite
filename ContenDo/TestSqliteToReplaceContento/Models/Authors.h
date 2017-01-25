//
//  Authors.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authors : NSObject
@property NSMutableString *name,*blurb,*uuid,*company;
+ (void)saveCustomObject:(Authors *)object key:(NSString *)key;
+ (Authors *)loadCustomObjectWithKey:(NSString *)key;
@end
