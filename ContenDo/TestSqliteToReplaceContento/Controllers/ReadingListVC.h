//
//  ReadingListVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 03/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@interface ReadingListVC : TestSqliteToReplaceContentoVC <UITableViewDataSource, UITableViewDelegate >
@property IBOutlet UITableView *tableView;
@end
