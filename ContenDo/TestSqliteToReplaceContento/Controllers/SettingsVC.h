//
//  SettingsVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 11/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TopicsVC.h"
#import "InformationVC.h"
#import "ContactVC.h"
#import "AccountVC.h"
@interface SettingsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSArray *profileSection, *generalSection;
@property IBOutlet UIView *headerView;
@property IBOutlet UILabel *footerBrandingLabel;
@end
