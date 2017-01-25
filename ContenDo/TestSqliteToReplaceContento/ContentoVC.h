//
//  TestSqliteToReplaceContentoVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 03/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import <SlideNavigationController.h>
@class Globals;
@interface TestSqliteToReplaceContentoVC : UIViewController <SlideNavigationControllerDelegate>{
    
}
@property Globals *sharedManager;
@property IBOutlet UIButton *btnMenu;
@end
