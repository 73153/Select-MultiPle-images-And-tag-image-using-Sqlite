//
//  DashboardVC.h
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 29/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "TopicsVC.h"
#import "Activities.h"
#import <YTPlayerView.h>
#import <MediaPlayer/MediaPlayer.h>
@interface DashboardVC : TestSqliteToReplaceContentoVC <UITableViewDelegate,UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating,SlideNavigationControllerDelegate, YTPlayerViewDelegate, MPMediaPickerControllerDelegate, MPMediaPlayback>
{
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIView *headerView,*buttonView;
    UIView *tmpView;
    BOOL isSearch,canAnimate,isFirstTime;
    UIRefreshControl *refreshControl;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *bannerImg;
    CGRect imgViewFrame;
    CGRect initialFrame;
    CGRect headerViewFrame;
    CGFloat sizes;
    Globals *sharedManager;
    IBOutlet UILabel *bannerTitle,*bannerDescription;

}
@property IBOutlet UITableView *tblView;
@property NSMutableArray *channelList,*articleListArray,*searchResults,*blogListArray,*dashboardList;

@property (weak, nonatomic) IBOutlet UIView *whiteViewForNoContent;
@property IBOutlet YTPlayerView *playerView;
@property IBOutlet UIButton *displayMenuButton;
@property UIView *loadingView;
@property     bool isPushed;
@property NSMutableArray   *videoListArray;
typedef NS_ENUM(NSUInteger, APParallaxTrackingState) {
    APParallaxTrackingActive = 0,
    APParallaxTrackingInactive
};
-(IBAction)searchClicked;
@end
