//
//  main.m
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 28/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"Caught exception %@", exception);
        }
       // return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
