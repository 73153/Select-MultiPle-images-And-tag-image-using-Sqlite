//
//  TopicsVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 10/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTopics.h"
#import "Constants.h"

@interface TopicsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray *topicsAray;
@property NSMutableArray *selectedTopics;
@property IBOutlet UITableView *tableView;
@property BOOL isFromSettings;
@property IBOutlet UIView *headerView;
@property IBOutlet UIButton *doneButton;
@end
