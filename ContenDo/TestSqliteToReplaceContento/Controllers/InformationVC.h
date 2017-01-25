//
//  InformationVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 11/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@interface InformationVC : UIViewController
@property NSString *titleStr;
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UIView *headerView;
@property NSString *content;
@property IBOutlet UIWebView *webView;
@end
