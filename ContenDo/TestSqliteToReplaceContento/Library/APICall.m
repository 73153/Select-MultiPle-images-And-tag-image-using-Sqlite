
//
//  APICall.m
//  Rover
//
//  Created by letsnurture on 3/4/15.
//  Copyright (c) 2015 letsnurture. All rights reserved.
//

#import "APICall.h"

@implementation APICall

+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion 
{
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (completion) {
                long code=200;
                completion(responseObject, nil,code);
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (completion) {
                long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
                completion(nil, error,code);
            }
        }
         ];
}

+(void)callPutWebServiceForUpdateProfile:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token withUUID:(NSString *)uuid completion:(completion_handler_t)completion
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", token] forHTTPHeaderField:@"x-access-token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", uuid] forHTTPHeaderField:@"UUID"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager PUT:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion([operation responseObject], error,code);
        }
    }
     ];
}
+(void)callGetWebServiceForUserProfile:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token withUUID:(NSString *)uuid completion:(completion_handler_t)completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", token] forHTTPHeaderField:@"x-access-token"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", uuid] forHTTPHeaderField:@"UUID"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion([operation responseObject], error,code);
        }
    }
     ];
}
+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token completion:(completion_handler_t)completion
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", token] forHTTPHeaderField:@"x-access-token"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion([operation responseObject], error,code);
        }
    }
     ];
}

+(void)callGetWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion{
    
    NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion(nil, error,code);
        }
    }
     ];

}
+(void)callGetWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter withToken:(NSString *)token completion:(completion_handler_t)completion{
    
    NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", token] forHTTPHeaderField:@"x-access-token"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion(nil, error,code);
        }
    }
     ];
    
}

+(void)callPutWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter {
    
    NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager PUT:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }
     ];
    
}

+(void)callDeleteWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter {
    
    NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager DELETE:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}
+(void)callPostImageWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter andImageData:(NSData *)imageData andImageParameterName:(NSString *)imageParameterName completion:(completion_handler_t)completion
{
    /********************* Sample Code for getting Image Data ****************/
    
    //    UIImage *imgBlob=[[glob.arrItems objectAtIndex:i ]valueForKey:@"img"];
    //
    //    CGSize size = CGSizeMake(100, 100);
    //    CGRect rect;
    //    rect.origin = CGPointZero;
    //    rect.size   = size;
    //
    //    UIGraphicsBeginImageContext(size);
    //    [imgBlob drawInRect:rect];
    //    UIImage * itemImg = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    NSData * jpegDataItem = UIImageJPEGRepresentation(itemImg, 0.5);
    
    
    /*************************************************************************/
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:imageParameterName fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion(nil, error,code);
        }
    }];
    [op start];
}
+(void)callPostMultipleImageWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter andImageData:(NSArray *)imageData andImageParameterName:(NSArray *)imageParameterName completion:(completion_handler_t)completion
{
    /********************* Sample Code for getting Image Data ****************/
    
    //    UIImage *imgBlob=[[glob.arrItems objectAtIndex:i ]valueForKey:@"img"];
    //
    //    CGSize size = CGSizeMake(100, 100);
    //    CGRect rect;
    //    rect.origin = CGPointZero;
    //    rect.size   = size;
    //
    //    UIGraphicsBeginImageContext(size);
    //    [imgBlob drawInRect:rect];
    //    UIImage * itemImg = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    NSData * jpegDataItem = UIImageJPEGRepresentation(itemImg, 0.5);
    
    
    /*************************************************************************/
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    AFHTTPRequestOperation *op = [manager POST:@"" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        for(int i=0; i<[imageData count]; i++)
        {
            [formData appendPartWithFileData:[imageData objectAtIndex:i] name:[imageParameterName  objectAtIndex:i] fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion(nil, error,code);
        }
    }];
    [op start];
}

@end
