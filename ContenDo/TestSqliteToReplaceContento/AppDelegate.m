//
//  AppDelegate.m
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 28/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import <SlideNavigationController.h>
#import "DashboardVC.h"

@interface AppDelegate ()
@property UINavigationController *navigationManger;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *content = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
     sleep(5);
    MenuVC *main = [story instantiateViewControllerWithIdentifier:@"MenuVC"];
    SlideNavigationController *nav=[[SlideNavigationController alloc] initWithRootViewController:content];
    [nav setNavigationBarHidden:YES];
    self.navigationManger=nav;
    [SlideNavigationController sharedInstance].leftMenu = main;
    [SlideNavigationController sharedInstance].portraitSlideOffset=40;
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    //
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    NSSetUncaughtExceptionHandler(&myExceptionHandler);
    // Register for Remote Notifications
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIUserNotificationType types = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [application registerUserNotificationSettings:mySettings];
        [application registerForRemoteNotifications];
        
        
    }else{
        [application registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
   
    application.applicationIconBadgeNumber = 0;
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo == NULL)
    {
    }
    else
    {
        Globals *sharedManager=[Globals sharedManager];
        sharedManager.isNotificationRecieved=true;
        application.applicationIconBadgeNumber = 0;
        [sharedManager.notificationDictionary setObject:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] valueForKey:@"uuid"] forKey:@"uuid"];
        
    }
    
    // Override point for customization after application launch.
    return YES;
}
void myExceptionHandler(NSException *exception)
{
}

- (void) setMenu{
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
   
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    @try{
        for(UIViewController * viewController in [SlideNavigationController sharedInstance].viewControllers){
            if([viewController isKindOfClass:[ArticleDetailVC class]]){
                ArticleDetailVC * second=(ArticleDetailVC *)viewController;
                second.slider.value = [UIScreen mainScreen].brightness;
                break;
            }
        }
    } @catch (NSException *exception) {
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
//    if (self.social.socialType==socialTypeFaceBook)
//    {
//        return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                              openURL:url
//                                                    sourceApplication:sourceApplication
//                                                           annotation:annotation];
//    }
//    else if (self.social.socialType==socialTypeGoogle){
//        return [GPPURLHandler handleURL:url
//                      sourceApplication:sourceApplication
//                             annotation:annotation];
//    }
     if (self.social.socialType==socialTypeLinkedInn) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else{
        return true;
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    
    self.deviceTokens=devToken;
    
    [[NSUserDefaults standardUserDefaults]setObject:self.deviceTokens forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState != UIApplicationStateActive ) {
    Globals *sharedManager=[Globals sharedManager];
    sharedManager.isNotificationRecieved=true;
    application.applicationIconBadgeNumber = 0;
    [sharedManager.notificationDictionary setObject:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] valueForKey:@"uuid"] forKey:@"uuid"];

    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:nil];
        DashboardVC *second=(DashboardVC *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
    
        BOOL isDashboard=false;
        for(UIViewController * viewController in [SlideNavigationController sharedInstance].viewControllers){
                            if([viewController isKindOfClass:[DashboardVC class]]){
                                isDashboard=true;
                                second=(DashboardVC *)viewController;
                                break;
                            }
            }
        if (isDashboard) {
            second.isPushed=true;
            [second  viewWillAppear:NO];
            [[SlideNavigationController sharedInstance] popToViewController:second animated:NO];
        }
        else{
            //[Globals ShowAlertWithTitle:@"Does not Exists" Message:@"Dashboard do not exists"];
            //[[SlideNavigationController sharedInstance] pushViewController:second animated:NO];
        }
    }
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)windowx
{
    Globals *sharedManager=[Globals sharedManager];
    if ([[self.window.rootViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]] ||
        [[self.window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"MPInlineVideoFullscreenViewController")] || sharedManager.isVideoPlaying )
    {
        if ([self.window.rootViewController presentedViewController].isBeingDismissed)
        {
            return UIInterfaceOrientationMaskPortrait;
        }
        else
        {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end
