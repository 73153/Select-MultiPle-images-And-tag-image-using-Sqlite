//
//  ArticalListVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 17/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TestSqliteToReplaceContentoVC.h"
#import "AppDelegate.h"
#import "Articles.h"
#import "Channels.h"
#import <YTPlayerView.h>
#import <MediaPlayer/MediaPlayer.h>
@class DashboardVC;
@interface ArticalListVC : UIViewController<UITableViewDataSource,UITableViewDelegate, MPMediaPickerControllerDelegate, MPMediaPlayback,YTPlayerViewDelegate>{
    UIRefreshControl *refreshControl;
    CGFloat sizes;
}
@property IBOutlet UIButton *btnMenu;
@property IBOutlet UITableView *tableView;
@property NSMutableArray *articleListArray,*blogListArray,*dashboardList,*videoListArray,*articleListArrayForCategory,*blogListArrayForCategory,*videoListArrayForCategory;
@property Channels *currentChannel;
@property (nonatomic,strong) NSString *titleScreen;
@property IBOutlet UILabel *titleLabel, *totalArticles, *totalBlogs, *totalVideos;
@property BOOL isCategory,isChannel,canAnimate;
@property NSString *channelid;
@property IBOutlet YTPlayerView *playerView;
@property IBOutlet UIView *headerView;
@end
