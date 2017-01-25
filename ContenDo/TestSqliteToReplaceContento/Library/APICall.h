//
//  APICall.h
//  Rover
//
//  Created by letsnurture on 3/4/15.
//  Copyright (c) 2015 letsnurture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface APICall : NSObject
typedef void(^completion_handler_t)(NSMutableDictionary *, NSError*error, long code);
+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion;
+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token completion:(completion_handler_t)completion;
+(void)callGetWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion;
+(void)callPutWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter;
+(void)callDeleteWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter;
+(void)callGetWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token completion:(completion_handler_t)completion;
+(void)callPostMultipleImageWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter andImageData:(NSArray *)imageData andImageParameterName:(NSArray *)imageParameterName completion:(completion_handler_t)completion;
+(void)callPostImageWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter andImageData:(NSData *)imageData andImageParameterName:(NSString *)imageParameterName completion:(completion_handler_t)completion;
+(void)callPutWebServiceForUpdateProfile:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token withUUID:(NSString *)uuid completion:(completion_handler_t)completion;
+(void)callGetWebServiceForUserProfile:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token withUUID:(NSString *)uuid completion:(completion_handler_t)completion;
@end
