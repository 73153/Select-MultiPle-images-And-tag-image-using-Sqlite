//
//  AppDelegate.h
//  PhotoTag
//
//  Created by vivek on 4/21/16.
//  Copyright © 2016 vivek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *databaseName;
@property (nonatomic,strong) NSString *databasePath;
@property (nonatomic,strong) NSMutableDictionary *dictAppNewAddress;
@property(nonatomic,strong) NSArray *photos;
@end

