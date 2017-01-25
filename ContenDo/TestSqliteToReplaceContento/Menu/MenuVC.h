//
//  MenuVC.h
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 28/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchVC.h"
#import "TopicsVC.h"
#import "SettingsVC.h"
#import "headerCell.h"
@interface MenuVC : UIViewController <UITabBarDelegate,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UISearchControllerDelegate,UISearchResultsUpdating>{
    UIRefreshControl *refreshControl;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnReadingHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHomeHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnChannelHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopicHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewFooterHeightConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewReadingFooterHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHomeFooterHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewChannelFooterHeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopicFooterHeightConstant;

@property IBOutlet UITableView *homeTableView, *channelTableView, *topicsTableView, *readingTableView;
@property IBOutlet NSLayoutConstraint *searchTrailingMargin,*channeltableViewTrailingMargin,*topictableViewTrailingMargin,*readingtableViewTrailingMargin;
@property IBOutlet UISearchBar *searchbar;
@property IBOutlet UITabBar *tabBar;
@property IBOutlet UITabBarItem *homeTab;
@property IBOutlet UIView *homeView, *channelView, *topicView, *readingList,*transparentView;
@property int activeView;
@property NSMutableArray *homeArray,*channelsArray, *channelBlogArray, *topicsArray, *readingListArray, *articleListArray, *videoListArray, *blogListArray, *sectionArray;
@property NSMutableArray *channelList;
@property IBOutlet UIButton *homeBtn, *channelBtn, *readingBtn, *topicBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property IBOutlet UIView *whiteView;
@property IBOutlet UIView *channelColorView,*topicsColorView,*readingColorView,*headerView;
@property IBOutlet UILabel *nameChannel, *nameReadingList, *nameTopics;
typedef void(^get_completion_block)(NSArray *result,NSString *str, int status);
-(void)isSyncCompleted:(get_completion_block)sync;
@end
