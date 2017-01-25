//
//  Users.h
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject
@property int userid,pin, accountid;
typedef void(^user_completion_block)(NSString *, int status);
@property NSMutableString *email,*name,*firstName,*lastName,*company,*website,*jobtitle,*phonenumber,*password,*fbid,*imgPath,*currentPassword,*token,*activeToken,*userTypeId;
@property NSString *deviceToken;
-(void)authenticate:(user_completion_block)completion;
-(void)registerUser:(user_completion_block)completion;
-(void)verifyUser;
-(void)loginUser:(user_completion_block)completion;
-(void)updateProfile:(user_completion_block)completion;
-(void)changePassword:(user_completion_block)completion;
-(void)logOut:(user_completion_block)completion;
//-(void)fbloginUser:(user_completion_block)completion;
//-(void)fbregisterUser:(user_completion_block)completion;
-(void)forgotPassword:(user_completion_block)completion;
-(void)uploadPicture:(user_completion_block)completion;
-(void)oauth:(user_completion_block)completion;
-(void)registerUserWithoauthResponse:(user_completion_block)completion;
-(void)getRegisterUserProfile:(user_completion_block)completion;
-(void)updateRegisterUser:(user_completion_block)completion;
@end
