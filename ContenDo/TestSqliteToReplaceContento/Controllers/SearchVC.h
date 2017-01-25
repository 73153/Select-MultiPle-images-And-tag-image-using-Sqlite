//
//  SearchVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 09/12/15.
//  Copyright © 2015 73153. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <SlideNavigationController.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "CellArticle.h"
#import "ArticleDetailVC.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CategoryButtons.h"
#import "ArticalListVC.h"
#import "TopicsVC.h"
#import <YTPlayerView.h>
#import <MediaPlayer/MediaPlayer.h>
@interface SearchVC : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating,SlideNavigationControllerDelegate, YTPlayerViewDelegate, MPMediaPickerControllerDelegate,MPMediaPlayback>
{
    IBOutlet UITableView *tblView;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIView *headerView,*buttonView;
    UIView *tmpView;
    NSMutableArray *channelList,*articleListArray,*searchResultsAry,*commonArray,*blogListArray, *videoListArray;
    BOOL canAnimate;
    UIRefreshControl *refreshControl;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *bannerImg;
    CGRect imgViewFrame;
    CGRect initialFrame;
    CGRect headerViewFrame;
    CGFloat sizes;
    IBOutlet UILabel *bannerTitle,*bannerDescription;
    BOOL isSearchTable;
}
@property NSString *searchstr;
@property BOOL isSearch;
@property IBOutlet UIButton *btnMenu,*btnHMenu;
@property IBOutlet YTPlayerView *playerView;
@property IBOutlet UILabel *noData,*searchResults;
@property (strong, nonatomic) UISearchController *searchController;
@end
