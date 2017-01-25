//
//  Users.m
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import "Users.h"
#import "APICall.h"
#import "Constants.h"
@implementation Users
@synthesize name,password,userid,accountid,phonenumber,pin,company,jobtitle,website,email,token,activeToken;
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.name=[[NSMutableString alloc]init];
        self.firstName=[[NSMutableString alloc] init];
        self.lastName=[[NSMutableString alloc] init];
        self.password=[[NSMutableString alloc]init];
        self.email=[[NSMutableString alloc]init];
        self.company=[[NSMutableString alloc]init];
        self.website=[[NSMutableString alloc]init];
        self.jobtitle=[[NSMutableString alloc]init];
        self.imgPath=[[NSMutableString alloc] init];
        self.deviceToken=[[NSString alloc] init];
        self.activeToken=[[NSMutableString alloc] init];
        self.accountid=0;
        self.userid=0;
        self.pin=0;
        self.userTypeId = [[NSMutableString alloc]init];
        self.fbid=[[NSMutableString alloc]init];
        self.phonenumber=[[NSMutableString alloc]init];
        self.token=[[NSMutableString alloc]init];
    }
    return self;
}
-(void)authenticate:(user_completion_block)completion{
    //acab8234-5930-421f-9845-ee585e0cfc03
    NSDictionary *parameters = @{@"uuid":UUID,@"password": @"kXbV5G*hOiUieWQlRg3HabK*HI%GZsblnqJcB%W3cE0X6XMKyM@oJOk$TypsYQ1u"};
    NSString *url_String = [NSString stringWithFormat:@"%@", API_AUTHENTICATE];
    
    [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                completion([error localizedDescription],-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"success"]integerValue]==1)
                {
                    self.token=[user valueForKey:@"token"];
//                    [[NSUserDefaults standardUserDefaults]setObject:self.token forKey:@"deviceToken"];
                    [[NSUserDefaults standardUserDefaults]setObject:[user valueForKey:@"userTypeId"] forKey:@"userTypeId"];
                    
                    [[NSUserDefaults standardUserDefaults]synchronize];

                    if ([user valueForKey:@"userTypeId"] && ![[user valueForKey:@"userTypeId"] isKindOfClass:[NSNull class]]) {
                        Meta *metaObj = [[Meta alloc] init];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[user valueForKey:@"userTypeId"]] forKey:@"userTypeId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        metaObj.userTypeId=[[user valueForKey:@"userTypeId"] mutableCopy];
                    }
                    completion(SUCEESS_TOKEN,1);
                }
                else if([[user valueForKey:@"success"]integerValue]==0){
                    if(![user valueForKey:@"message"])
                    {
                        completion(ERROR_TOKEN_FAILED,0);
                    }
                    else{
                        completion([user valueForKey:@"message"],0);
                    }
                    
                }
            }
        }
    }];
}

-(void)updateRegisterUser:(user_completion_block)completion{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if(self.email.length>0)
        
        [parameters setObject:[self.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"email"];
    
    if(self.name.length>0 )
        [parameters setObject:[self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"firstName"];
    if(self.firstName.length>0)
        [parameters setObject:[self.firstName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"firstName"];
    
    if(self.lastName.length>0)
        [parameters setObject:[self.lastName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"lastName"];
    
    if(self.company.length>0)
        [parameters setObject:[self.company stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"company"];
    
    if(self.password.length>0)
        [parameters setObject:[self.password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
    
    if(self.website.length>0)
        [parameters setObject:[self.website stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"website"];
    
    if(self.jobtitle.length>0)
        [parameters setObject:[self.jobtitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"jobtitle"];
    
    if(self.phonenumber.length>0)
        [parameters setObject:[self.phonenumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"phonenumber"];
    
    NSString *url_String = [NSString stringWithFormat:@"%@", API_USER];
    
    
    
    [APICall callPutWebServiceForUpdateProfile:url_String andDictionary:parameters withToken:self.token withUUID:UUID completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                NSString *msg=[user valueForKey:@"message"];
                completion(msg,-1);
            }
            //[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"success"]integerValue]==1)
                {
                    completion(SUCCESS_USER_UPDATE,1);
                }
                else{
                    if(![user valueForKey:@"msg"])
                    {
                        completion(ERROR_USER_UPDATE,0);
                    }
                    else{
                        completion([user valueForKey:@"msg"],0);
                    }
                    //completion([user valueForKey:@"msg"],0);
                }
            }
        }
    }];
    
    
}

-(void)getRegisterUserProfile:(user_completion_block)completion{
    
    NSString *url_String = [NSString stringWithFormat:@"%@", API_USER];
    
    [APICall callGetWebServiceForUserProfile:url_String andDictionary:nil withToken:self.token withUUID:UUID completion:^(NSDictionary* user, NSError*error, long code){
        
        if(error)
        {
            if(completion)
            {
                NSString *msg=[user valueForKey:@"message"];
                completion(msg,-1);
            }
            //[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"success"]integerValue]==1)
                {
                    NSDictionary *dataDict = [user valueForKey:@"data"];
                    
                    if ([dataDict valueForKey:@"firstName"] && ![[dataDict valueForKey:@"firstName"] isKindOfClass:[NSNull
                                                                                                                    class]]) {
                        
                        
                        self.firstName=[[[dataDict valueForKey:@"firstName"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "] mutableCopy];
                        [[NSUserDefaults standardUserDefaults] setObject:self.firstName forKey:@"userFirstName"];
                        
                    }
                    if ([dataDict valueForKey:@"lastName"] && ![[dataDict valueForKey:@"lastName"] isKindOfClass:[NSNull
                                                                                                                  class]]) {
                        self.lastName=[[[dataDict valueForKey:@"lastName"] stringByReplacingOccurrencesOfString:@"%20" withString:@" "]mutableCopy];
                        [[NSUserDefaults standardUserDefaults] setObject:self.lastName forKey:@"userLastName"];
                        
                    }
                    if ([dataDict valueForKey:@"company"] && ![[dataDict valueForKey:@"company"] isKindOfClass:[NSNull
                                                                                                                class]]) {
                        self.company=[[dataDict valueForKey:@"company"] mutableCopy];
                    }
                    if ([dataDict valueForKey:@"email"] && ![[dataDict valueForKey:@"email"] isKindOfClass:[NSNull
                                                                                                            class]]) {
                        self.email=[[dataDict valueForKey:@"email"] mutableCopy];
                    }
                    
                    if ([dataDict valueForKey:@"userTypeId"] && ![[dataDict valueForKey:@"userTypeId"] isKindOfClass:[NSNull class]]) {
                        Meta *metaObj = [[Meta alloc] init];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dataDict valueForKey:@"userTypeId"]] forKey:@"userTypeId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        metaObj.userTypeId=[[user valueForKey:@"data"] valueForKey:@"userTypeId"];
                        [[NSUserDefaults standardUserDefaults] setObject:metaObj.userTypeId forKey:@"userTypeId"];

                    }
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    completion(SUCCESS_USER_REGISTRATION,1);
                }
                else{
                    if(![user valueForKey:@"msg"])
                    {
                        completion(ERROR_USER_REGISTRATION,0);
                    }
                    else{
                        completion([user valueForKey:@"msg"],0);
                    }
                    //completion([user valueForKey:@"msg"],0);
                }
            }
        }
    }];
}

-(void)registerUser:(user_completion_block)completion{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if(self.email.length>0)
        
        [parameters setObject:[self.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"email"];
    
    if(self.name.length>0 )
        [parameters setObject:[self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"firstName"];
    if(self.firstName.length>0)
        [parameters setObject:[self.firstName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"firstName"];
    
    if(self.lastName.length>0)
        [parameters setObject:[self.lastName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"lastName"];
    
    if(self.company.length>0)
        [parameters setObject:self.company forKey:@"company"];
    
    if(self.password.length>0)
        [parameters setObject:self.password forKey:@"password"];
    
    if(self.website.length>0)
        [parameters setObject:self.website forKey:@"website"];
    
    if(self.jobtitle.length>0)
        [parameters setObject:self.jobtitle forKey:@"jobtitle"];
    
    if(self.phonenumber.length>0)
        [parameters setObject:self.phonenumber forKey:@"phonenumber"];
    
    NSString *url_String = [NSString stringWithFormat:@"%@", API_USER];
    
    [APICall callPostWebService:url_String andDictionary:parameters withToken:self.token completion:^(NSDictionary* user, NSError*error, long code){
        
        
        if(error)
        {
            if(completion)
            {
                NSString *msg=[user valueForKey:@"message"];
                completion(msg,-1);
            }
            //[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"success"]integerValue]==1)
                {
                    completion(SUCCESS_USER_REGISTRATION,1);
                }
                else{
                    if(![user valueForKey:@"msg"])
                    {
                        completion(ERROR_USER_REGISTRATION,0);
                    }
                    else{
                        completion([user valueForKey:@"msg"],0);
                    }
                    //completion([user valueForKey:@"msg"],0);
                }
            }
        }
    }];
}



-(void)verifyUser{
    NSString *url_String = [NSString stringWithFormat:@"%@/%i/verify?pin=%i", API_USER,self.userid,self.pin];
    [APICall callPostWebService:url_String andDictionary:nil completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
        }
        else{
        }
    }];
}

-(void)loginUser:(user_completion_block)completion
{
    NSString *url_String = [NSString stringWithFormat:@"%@", API_USER_LOGIN];
    AppDelegate *app= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *appToken;
    if (app.deviceTokens) {
        appToken=app.deviceTokens;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
    {
        appToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    }
    else{
        appToken=@"aea11ab58c6e547f53a11fc61beb850bf194d3d4d1cd43c9e4ad73af579a56f2";
    }
    NSDictionary *parameters = @{@"email":self.email,@"password":self.password,@"deviceType":@"ios",@"deviceToken":appToken};
    [APICall callPostWebService:url_String andDictionary:parameters withToken:self.token completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                NSString *msg=[user valueForKey:@"message"];
                completion(msg,-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"success"]integerValue]==1)
                {
                    if ([user valueForKey:@"user"] && ![[user valueForKey:@"user"] isKindOfClass:[NSNull class]]) {
                        Meta *metaObj = [[Meta alloc] init];
                        metaObj.userTypeId=[[user valueForKey:@"user"] valueForKey:@"userTypeId"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",metaObj.userTypeId] forKey:@"userTypeId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }
                    self.activeToken=[user valueForKey:@"token"];
                    self.token=[[user valueForKey:@"token"] mutableCopy];
                    [[NSUserDefaults standardUserDefaults] setObject:self.activeToken forKey:@"activeToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    if ([user valueForKey:@"firstName"] && ![[user valueForKey:@"firstName"] isKindOfClass:[NSNull
                                                                                                            class]]) {
                        self.firstName=[[user valueForKey:@"firstName"] mutableCopy];
                    }
                    if ([user valueForKey:@"lastName"] && ![[user valueForKey:@"lastName"] isKindOfClass:[NSNull
                                                                                                          class]]) {
                        self.lastName=[[user valueForKey:@"lastName"] mutableCopy];
                    }
                    completion(@"Login success",1);
                    
                }
                else{
                    completion(@"Email ID or Password is invalid",0);
                }
            }
        }
    }];
}

-(void)updateProfile:(user_completion_block)completion{
    NSString *url_String = @"";
    NSDictionary *parameters = @{@"sFirstName":self.email,@"sLastName":self.company,@"nUserId":[NSString stringWithFormat:@"%d",self.userid]};
    [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                completion(@"There was some error in updating your profile. Try again",-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"status"]integerValue]==1)
                {
                    completion(@"Update Profile success",0);
                }
                else{
                    completion(@"There was some error in updating your profile. Try again",-1);
                }
            }
        }
    }];
}
-(void)changePassword:(user_completion_block)completion{
    NSString *url_String = @"";
    NSDictionary *parameters = @{@"sCurrPassword":self.currentPassword,@"sPassword":self.password,@"nUserId":[NSString stringWithFormat:@"%d",self.userid]};
    [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                completion(@"There was some error in changing password. Try again",-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"status"]integerValue]==1)
                {
                    completion(@"Password changed successfully",0);
                }
                else{
                    completion(@"Current password is incorrect. Try again",-1);
                }
            }
        }
    }];
}

-(void)forgotPassword:(user_completion_block)completion{
    NSString *url_String = [NSString stringWithFormat:@"%@", API_FORGOT_PASSWORD];
    
    NSDictionary *parameters = @{@"email":self.email};
    [APICall callPostWebService:url_String andDictionary:parameters withToken:[[NSString stringWithFormat:@"%@",self.token] mutableCopy] completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                completion(@"There was some error. Try again",-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"success"]integerValue]==1)
                {
                    completion(@"Check your email id for further instructions",0);
                }
                else if([[user valueForKey:@"success"]integerValue]==0){
                    completion([user valueForKey:@"message"],0);

                }
                
            }
        }
    }];
}
-(void)uploadPicture:(user_completion_block)completion{
    NSString *url_String = @"";
    NSDictionary *parameters = @{@"nUserId":[NSString stringWithFormat:@"%d", self.userid ]};
    [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                completion(@"There was some error. Try again",-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"status"]integerValue]==1)
                {
                    completion(@"Check your email id for further instructions",0);
                }
                else{
                    completion(@"This email id is not registered with us",-1);
                }
            }
        }
    }];
}

-(void)logOut:(user_completion_block)completion{
    NSString *url_String = @"";
    NSDictionary *parameters = @{@"nUserId":[NSString stringWithFormat:@"%d",self.userid ]};
    [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                completion(@"There was some error, please try again later",-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"status"]integerValue]==1)
                {
                    completion(@"Logout success",0);
                }
                else{
                    completion(@"There was some error, please try again later",-1);
                }
            }
        }
    }];
}


-(void)oauth:(user_completion_block)completion{
    //acab8234-5930-421f-9845-ee585e0cfc03
    Globals *objShared = [Globals sharedManager];
    AppDelegate *app= (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *appToken;
    if (app.deviceTokens) {
        appToken=app.deviceTokens;
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
    {
        appToken=[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    }
    else{
        appToken=@"aea11ab58c6e547f53a11fc61beb850bf194d3d4d1cd43c9e4ad73af579a56f2";
        
    }
    
    if(objShared.linkedToken.length==0)
    {
       objShared.linkedToken= [[NSUserDefaults standardUserDefaults] valueForKey:@"linkedToken"];

    }
    NSDictionary *parameters = @{@"oAuthToken":[NSString stringWithFormat:@"%@",objShared.linkedToken],@"deviceType":@"ios",@"deviceToken":appToken};
    NSString *url_String = [NSString stringWithFormat:@"%@", API_OAUTH_LIST];
    
    [APICall callPostWebService:url_String andDictionary:parameters withToken:[[NSString stringWithFormat:@"%@",self.token] mutableCopy] completion:^(NSDictionary* user, NSError*error, long code){
        
        if(error)
        {
            if(completion)
            {
                NSString *msg=[user valueForKey:@"message"];
                completion(msg,-1);
            }
        }
        else{
            if([[user valueForKey:@"success"]integerValue]==1)
            {
                self.activeToken=[user valueForKey:@"token"];
                self.token=[user valueForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:self.activeToken forKey:@"activeToken"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                completion(SUCEESS_TOKEN,1);
            }
            else if([[user valueForKey:@"success"]integerValue]==0){
                if(![user valueForKey:@"message"])
                {
                    completion(ERROR_TOKEN_FAILED,0);
                }
                else{
                    completion([user valueForKey:@"message"],0);
                }
                
            }
            
        }
    }];
}

-(void)registerUserWithoauthResponse:(user_completion_block)completion{
    
    Globals *objShared;
    objShared = [Globals sharedManager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if(self.email.length>0)
        
        [parameters setObject:[self.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"email"];
    
    if(self.name.length>0 )
        [parameters setObject:[self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"firstName"];
    if(self.firstName.length>0)
        [parameters setObject:[self.firstName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"firstName"];
    
    if(self.lastName.length>0)
        [parameters setObject:[self.lastName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"lastName"];
    
    
    if(self.company.length>0)
        [parameters setObject:[self.company stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"company"];
    
    //    if(self.password.length>0)
    [parameters setObject:[self.password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
    
    if(self.website.length>0)
        [parameters setObject:[self.website stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"website"];
    
    if(self.jobtitle.length>0)
        [parameters setObject:[self.jobtitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"jobtitle"];
    
    if(self.phonenumber.length>0)
        [parameters setObject:[self.phonenumber stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"phonenumber"];
    
    if(self.jobtitle.length>0)
        [parameters setObject:[[NSString stringWithFormat:@"%@",objShared.linkedToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"jobtitle"];
    
    if([NSString stringWithFormat:@"%@",objShared.linkedToken].length>0)
        [parameters setObject:[[NSString stringWithFormat:@"%@",objShared.linkedToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"oAuthToken"];
    
    NSString *url_String = [NSString stringWithFormat:@"%@", API_USER];
    
    [APICall callPostWebService:url_String andDictionary:parameters withToken:self.token completion:^(NSDictionary* user, NSError*error, long code){
        if(error)
        {
            if(completion)
            {
                NSString *msg=[user valueForKey:@"message"];
                completion(msg,-1);
            }
        }
        else{
            if(completion)
            {
                if([[user valueForKey:@"success"]integerValue]==1)
                {
                    completion(SUCCESS_USER_REGISTRATION,1);
                }
                else{
                    if(![user valueForKey:@"msg"])
                    {
                        completion(ERROR_USER_REGISTRATION,0);
                    }
                    else{
                        completion([user valueForKey:@"msg"],0);
                    }
                }
            }
        }
    }];
}

@end
