//
//  Pages.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 08/04/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "APICall.h"
@class Meta;
@interface Pages : NSObject
typedef enum
{
    AboutUs = 1,
    PrivacyPolicy,
    Cookies,
    Legal,
    Terms,
}type;
@property NSMutableString *pageId,*uuid,*clientId, *title, *desc, *summary;
@property type pageType;
@property Meta *meta;

typedef void(^page_completion_block)(NSDictionary *result,NSString *, int status);
typedef void(^get_completion_block)(NSArray *result,NSString *str, int status);

// For Web Service Calling
-(void)getAllPages:(page_completion_block)completion;
-(void)getPagesWithTimeStamp:(NSDate *)time withCompletion:(page_completion_block)completion;

// For Parsing
+(NSMutableArray *)parseArrayToObjectsWithArray:(NSArray *)result;

@end
