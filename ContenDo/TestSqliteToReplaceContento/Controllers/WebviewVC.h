//
//  WebviewVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 14/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@interface WebviewVC : UIViewController <UIWebViewDelegate >
@property NSString *titleStr,*url;
@property IBOutlet UIWebView *webView;
@property IBOutlet UILabel *titleLabel;
@end
