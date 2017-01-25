//
//  AppDelegate.h
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 28/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <YTPlayerView.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SocialLogin.h"
#import "Globals.h"
//#import "DashboardVC.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) SocialLogin *social;
@property (strong, nonatomic) NSString *deviceTokens;
- (void) setMenu;

@end

