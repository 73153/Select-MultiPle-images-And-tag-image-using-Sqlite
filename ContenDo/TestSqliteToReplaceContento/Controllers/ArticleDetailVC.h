//
//  ArticleDetailVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 18/11/15.
//  Copyright © 2015 73153. All rights reserved.
//
#import "WebviewVC.h"
#import "TestSqliteToReplaceContentoVC.h"
#import "Constants.h"
#import "Articles.h"
#import "relatedArticleCell.h"
#import "Activities.h"
#import "Blogs.h"

#import "AppDelegate.h"
@class Topics;
@class AppDelegate;
@interface ArticleDetailVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate, UIDocumentInteractionControllerDelegate,UIDocumentMenuDelegate, UIActionSheetDelegate, UIWebViewDelegate,UIGestureRecognizerDelegate>
@property Articles *currentArticle;
@property Blogs *currentBlog;
@property IBOutlet UIImageView *banneImage;
@property IBOutlet UIWebView *contentWebView;
@property IBOutlet UICollectionView *relatedArticleCollecionView;
@property IBOutlet UILabel *titleLabel,*lblTopicName;
@property  AppDelegate *app;
@property IBOutlet NSLayoutConstraint *heightWebview,*bottomRelatedArticles;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property IBOutlet UIView *mainView,*relatedArticleView,*actionsheetView, *footerView;
@property IBOutlet UIScrollView *scrollView;
@property NSMutableArray *relatedArticleArray,*relatedBlogsArray;
@property IBOutlet UILabel *relatedListLabel;
@property IBOutlet UIButton *btnClose, *btnBook, *btnShare, *btnDownload;
@property IBOutlet UISlider *slider;
@property (nonatomic, retain) UIDocumentInteractionController  *docController;
@property UIActionSheet *action;
@property BOOL isScrolled;
@property NSMutableArray *presentedArray;
@property UIButton *btnTopic;
@property Topics *currentTopic;
@property UILabel *relatedArticleLabel;
@property NSMutableArray  *articleListArray, *videoListArray, *blogListArray;
- (IBAction)btnRightSwipe:(UIButton *)sender;
- (IBAction)btnLeftSwipe:(UIButton *)sender;
@property float previousYaxis;
@end
