//
//  BlogListVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 04/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestSqliteToReplaceContentoVC.h"
#import "CellArticle.h"
#import "Validations.h"
#import "AppDelegate.h"
#import "Blogs.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CategoryButtons.h"
#import "Constants.h"
@interface BlogListVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UIRefreshControl *refreshControl;
}
@property IBOutlet UIButton *btnMenu;
@property IBOutlet UITableView *tableView;
@property NSMutableArray *blogListArray;
@property Channels *currentChannel;
@property (nonatomic,strong) NSString *titleScreen;
@property IBOutlet UILabel *titleLabel, *totalBlogs;
@property BOOL isCategory,isChannel,canAnimate;
@property NSString *channelid;
@end
