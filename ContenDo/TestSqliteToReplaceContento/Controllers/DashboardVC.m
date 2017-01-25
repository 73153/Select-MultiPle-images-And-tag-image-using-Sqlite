//
//  DashboardVC.m
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 29/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "DashboardVC.h"
#import "CellArticle.h"
#import "ArticleDetailVC.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CategoryButtons.h"
#import "ArticalListVC.h"
#import <AVFoundation/AVFoundation.h>

@implementation DashboardVC
{
    UIActivityIndicatorView *spinner;
    BOOL isCallDashboardService;
    
}
@synthesize tblView,channelList,articleListArray,searchResults,blogListArray,dashboardList,isPreparedToPlay,currentPlaybackRate,currentPlaybackTime;

#pragma mark view method for loading
-(void)viewDidLoad{
    [super viewDidLoad];
    isCallDashboardService=true;
    
    sharedManager = [Globals sharedManager];
    sharedManager.isAllAticleReceived =false;
    sharedManager.isAllBlogsReceived =false;
    sharedManager.isAllVideoReceived=false;
    if ([dashboardList count] > 0) {
        [self sortDashboardList];
    }
    [sharedManager hideLoader];
    sharedManager.isShowLoaderForNextData=false;
    self.whiteViewForNoContent.hidden=true;
    
    sharedManager=[Globals sharedManager];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"activeToken"]){
        sharedManager.user.activeToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"activeToken"];
        sharedManager.user.token = [[NSUserDefaults standardUserDefaults] valueForKey:@"activeToken"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isSyncCompleted:)
                                                 name:@"syncCompleted"
                                               object:sharedManager.syncCompleted];
    self.isPushed=true;
    isFirstTime=true;
    [self getUserProfile];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = THEME_BG_COLOR;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self
                       action:@selector(getLatestArticles)
             forControlEvents:UIControlEventValueChanged];
    
    [tblView addSubview:refreshControl];
    initialFrame=bannerImg.frame;
    blogListArray=MArray;
    [self initVC];
    if(!self.sharedManager.isAlreadyLoggedIn)
    {
    }
    else{
        [self loggedInAgain];
    }
    if(([[NSUserDefaults standardUserDefaults] objectForKey:@"email"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) || [[NSUserDefaults standardUserDefaults] objectForKey:@"IsLinkedInLogin"])
    {
        [self loggedInAgain];
    }
    
    [self getReadingList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:UIContentSizeCategoryDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closedFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        //Close menu show
        if (tblView.TestSqliteToReplaceContentoffset.y > 120) {
            [self.btnMenu setHidden:YES];
            [self.displayMenuButton setHidden:YES];
        }
        else{
            [self.btnMenu setHidden:NO];
            [self.displayMenuButton setHidden:NO];
        }
        [tblView setUserInteractionEnabled:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        if (tblView.TestSqliteToReplaceContentoffset.y > 120) {
            [self.btnMenu setHidden:YES];
            [self.displayMenuButton setHidden:YES];
        }
        else{
            [self.btnMenu setHidden:NO];
            [self.displayMenuButton setHidden:NO];
        }
        // Open Menu hide
        [tblView setUserInteractionEnabled:NO];
    }];
    if(!spinner){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner stopAnimating];
        [spinner setHidden:true];
        spinner.hidesWhenStopped = NO;
        [tblView.tableFooterView setBackgroundColor:[UIColor clearColor]];
        tblView.tableFooterView.hidden = TRUE;
    }
    [self getNextDataInBackground];
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [sharedManager hideLoader];
    
    if(!spinner){
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner stopAnimating];
        [spinner setHidden:true];
        spinner.hidesWhenStopped = NO;
        [tblView.tableFooterView setBackgroundColor:[UIColor clearColor]];
        tblView.tableFooterView.hidden = TRUE;
    }
    
    
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    
    [self.displayMenuButton setHidden:NO];
    [self.btnMenu setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [searchBar setBackgroundImage:[UIImage new]];
    
    [self.searchDisplayController setActive:NO];
    
    [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
    
    [self manageActivitySync];
    
    if ([dashboardList count] > 0) {
        [self sortDashboardList];
    }
    
    tblView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if(self.sharedManager.isNotificationRecieved)
    {
        [self getLatestArticles ];
    }
    
}

-(void) initVC{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [app setMenu];
    [self.searchDisplayController.searchResultsTableView registerClass:[CellArticle class]
                                                forCellReuseIdentifier:@"cellArticle"];
    tmpView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [tmpView setBackgroundColor:[UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:206.0f/255.0f alpha:1 ] ];
    [tmpView setHidden:YES];
    
    [self.view addSubview:tmpView];
    tblView.sectionIndexBackgroundColor=[UIColor clearColor];
    [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(0, 20, tblView.frame.size.width, tblView.frame.size.height)];
    
    [self performSelector:@selector(hideSearchBar) withObject:nil afterDelay:0.0f];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    searchResults=MArray;
    searchBar.frame=CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, self.view.frame.size.width, 44);
    
    @try {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor blackColor]];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
        [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
        
        
        //New
        
        NSDictionary *placeholderAttributes = @{
                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14],
                                                };
        
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search"
                                                                                    attributes:placeholderAttributes];
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
        
    }
    @catch (NSException *exception) {
        //
    }
    @finally {
        //
    }
    canAnimate=true;
    
}

-(void) getUserProfile
{
    
    [sharedManager.user getRegisterUserProfile:^(NSString *msg, int status) {
        if(sharedManager.user==nil)
        {
            sharedManager.user = [[Users alloc] init];
        }
    }];
}

#pragma mark theme add and remove
-(void) setThemeView{
    if (isFirstTime) {
        self.loadingView=[[UIView alloc]init];
        [self.loadingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.loadingView setBackgroundColor:THEME_BG_COLOR];
        isFirstTime=false;
    }
    
}

-(void) removeThemeView{
    [self.loadingView removeFromSuperview];
}

-(void)closedFullScreen{
    
    [self.playerView removeFromSuperview];
    sharedManager.isVideoPlaying=false;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    for (UIView *yt in self.view.subviews)
    {
        if([yt isKindOfClass:[YTPlayerView class]])
        {
            [yt removeFromSuperview];
        }
    }
}
-(void) reloadTableView
{
    [tblView reloadData];
}

-(void)isSyncCompleted:(get_completion_block)sync
{
    if(sharedManager.isAllAticleReceived && sharedManager.isAllVideoReceived && sharedManager.isAllBlogsReceived)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:@"syncCompleted"];
    }
    if ([sharedManager.updatedChannelArray count] == 0) {
        sharedManager.channelSyncCount=0;
        if(sync)
        {
            
            isCallDashboardService=true;
            [sharedManager hideLoader];
            
            [self getFilterArticlesFromLocalDB];
            // For Push Notification
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getNextDataInBackground) object:nil];
            
            [self performSelector:@selector(getNextDataInBackground) withObject:nil afterDelay:10.0f];
        }
    }
    else{
        
        if (sharedManager.isRefreshFromDashBoard) {
            sharedManager.isRefreshFromDashBoard=false;
            sharedManager.channelSyncCount=0;
            if(sync)
            {
                isCallDashboardService=true;
                [sharedManager hideLoader];
                sharedManager.isShowLoaderForNextData=false;
                
                [self getFilterArticlesFromLocalDB];
                
                
            }
        }
    }
    [self sortDashboardList];
    
    
    if(spinner){
        [spinner setHidden:true];
        [spinner stopAnimating];
        [sharedManager hideLoader];
    }
}

-(void) checkForPushNotification{
    if(self.sharedManager.isNotificationRecieved)
    {
        for(int i=0; i<[dashboardList count]; i++)
        {
            if([[[dashboardList objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Articles"])
            {
                Articles *article=[[dashboardList objectAtIndex:i] objectForKey:@"data"];
                if([article.uuid isEqualToString:[self.sharedManager.notificationDictionary valueForKey:@"uuid"]])
                {
                    
                    self.sharedManager.isNotificationRecieved=false;
                    self.sharedManager.notificationDictionary=MDictionary;
                    
                    if (self.isPushed)
                    {
                        // For navigation
                        self.isPushed=false;
                        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ArticleDetailVC  *article2=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
                        article2.currentArticle=article;
                        [[SlideNavigationController sharedInstance] pushViewController:article2 animated:NO];
                        
                    }
                    break;
                }
                
            }
            else if([[[dashboardList objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Blog"])
            {
                Blogs *blog=[[dashboardList objectAtIndex:i] objectForKey:@"data"];
                if([blog.uuid isEqualToString:[self.sharedManager.notificationDictionary valueForKey:@"uuid"]])
                {
                    
                    self.sharedManager.isNotificationRecieved=false;
                    self.sharedManager.notificationDictionary=MDictionary;
                    
                    if (self.isPushed)
                    {
                        // For navigation
                        self.isPushed=false;
                        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
                        article.currentBlog=blog;
                        [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
                    }
                    break;
                }
            }
            else if([[[dashboardList objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"Video"])
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closedFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
                
                
                Video *currentVideo=[[dashboardList objectAtIndex:i]  objectForKey:@"data"];
                if([currentVideo.uuid isEqualToString:[self.sharedManager.notificationDictionary valueForKey:@"uuid"]])
                {
                    self.sharedManager.isNotificationRecieved=false;
                    self.sharedManager.notificationDictionary=MDictionary;
                    NSString *youtubeId=[Globals extractYoutubeID:currentVideo.videoUri];
                    if (youtubeId) {
                        
                        self.playerView=[[YTPlayerView alloc] initWithFrame:self.view.frame];
                        NSDictionary *param=[[NSDictionary alloc] initWithObjects:@[@"0"] forKeys:@[@"showinfo"]];
//                        NSDictionary *playerVars = @{
//                                                     @"playsinline" : @1,
//                                                     @"autoplay" : @1,
//                                                     @"showinfo" : @0,
//                                                     @"rel" : @0,
//                                                     @"modestbranding" : @1,
//                                                     }
                        [self.playerView loadWithVideoId:youtubeId playerVars:param];
                        
                        [self.playerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                        self.playerView.delegate=self;
                        
                        
                        [self.playerView playVideo];
                        sharedManager.isVideoPlaying=true;
                        [self.view addSubview:self.playerView];
                    }
                    else{
                        [Globals ShowAlertWithTitle:@"TestSqliteToReplaceContento" Message:@"Video cannot be played at this time."];
                        return;
                        
                        
                    }
                    break;
                }
                
            }
        }
    }
}
-(void) sortDashboardList{
    
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"updatesDate"
                                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
  
    
    if(dashboardList.count>0){
        NSArray *sortedArray = [dashboardList sortedArrayUsingDescriptors:sortDescriptors];
        
        dashboardList= [[NSMutableArray alloc] initWithArray:[sortedArray mutableCopy]];
        sharedManager.isShowLoaderForNextData=false;
        self.whiteViewForNoContent.hidden=true;
        [tblView reloadData];
        
    }
    
}
-(void) loggedInAgain{
    
    [self getFilterArticlesFromLocalDB];
    
}


-(void) manageActivitySync{
    Activities *activity=[[Activities alloc] init];
    [activity getUnSyncActivity:^(NSArray *result, NSString *str, int status) {
        for (int i=0; i<[result count]; i++) {
            //
            NSData *strData1 = [[[result objectAtIndex:i] valueForKey:@"json"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:strData1 options:0 error:nil];
            
            [activity saveActivityWithoutInsert:json withCompletion:^(NSDictionary *result1, NSString *str, int status) {
                //
                if (status == 1) {
                    // Set their isSync =1
                    
                    ;
                    FMDatabase *db = [FMDatabase databaseWithPath:[sharedManager getDatabasePath]];
                    [db open];
                    NSString *insertQ= [NSString stringWithFormat: @"update activities set isSync=1 where id = %@", [[result objectAtIndex:i] valueForKey:@"id"]];
                    BOOL success =  [db executeUpdate:insertQ,nil];
                    if(success){}
                    [db close];
                }
            }];
        }
    }];
}
-(void) getTopics{
    
    [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
        [sharedManager hideLoader];
        [self removeThemeView];
        if (UDGetObject(@"topic")) {
            //
        }
        else{
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TopicsVC *topic=[story instantiateViewControllerWithIdentifier:@"TopicsVC"];
            sharedManager.topicsArray = [result mutableCopy];
            [self presentViewController:topic animated:YES completion:^{
                //
            }];
        }
        
    }];
}
-(void)getReadingList{
    
    [sharedManager.sync getAllReadingListWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        if(status==1)
        {
            sharedManager.readingListArray=[result mutableCopy];
        }
        else{
            [Globals ShowAlertWithTitle:@"Error" Message:str];
        }
    }];
}




-(void) getArticles{
    
    sharedManager.articlecount=(int)[[sharedManager.db selectAllQueryWithTableName:@"articles"] count];
    
    if (!sharedManager.isNotificationRecieved) {
        [self setThemeView];
    }
    
    // Checking for cached data
    // Getting List of Articles for particular channels
    if([Validations isconnectedToInternet] )
    {
        [sharedManager.sync fillChannelsWithCompletionBlock:^(NSString *str, int status) {
            
            if(status==1)
            {
                [sharedManager.sync getAllChannelsWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                    
                    if([result count]==0)
                    {
                        dashboardList=MArray;
                        [sharedManager hideLoader];
                        if(spinner){
                            [spinner stopAnimating];
                            [spinner setHidesWhenStopped:true];
                        }
                        [tblView reloadData];
                        return ;
                    }
                    
                    if(sharedManager.isRefreshFromDashBoard){
                        [sharedManager.sync fillAllUpdatedChannelsData:^(NSArray *result, NSString *str, int status) {
                            sharedManager.isRefreshFromDashBoard=false;
                            [self getFilterArticlesFromLocalDB];
                        }];
                    }
                    else{
                        [sharedManager.sync fillArticlesWithCompletionBlock:^(id result,NSString *str, int status) {
                            
                            [self getFilterArticlesFromLocalDB];
                        }];
                        
                    }
                    
                    [sharedManager hideLoader];
                    
                    [self removeThemeView];
                    
                }];
            }
            else{
                dashboardList=MArray;
                [tblView reloadData];
                [sharedManager hideLoader];
                [self removeThemeView];
                [Globals ShowAlertWithTitle:@"Error" Message:str];
            }
        }];
        
    }
    else{
        
        [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
            articleListArray= [result mutableCopy];
            if(articleListArray.count>0)
                dashboardList= MArray;
            for (int i=0; i<[articleListArray count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[articleListArray objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                [dashboardList addObject:dic];
                
            }
            sharedManager.articleArray=[result mutableCopy];
            
            [tblView reloadData];
            [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                for (int i=0; i<[result1 count]; i++) {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                    [dashboardList addObject:dic];
                }
                [tblView reloadData];
                [sharedManager hideLoader];
                [self removeThemeView];
                //                NSLog(@"calling Topic");
            }];
            [sharedManager.sync getAllVideosWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                for (int i=0; i<[result1 count]; i++) {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Video"] forKeys:@[@"data",@"type"]];
                    [dashboardList addObject:dic];
                }
                [tblView reloadData];
                [sharedManager hideLoader];
                [self removeThemeView];
                
            }];
            
        }];
        
        [tblView reloadData];
        
        [sharedManager hideLoader];
        [self removeThemeView];
        [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
            sharedManager.topicsArray = [result mutableCopy];
            [tblView reloadData];
        }];
    }
    
}

-(void) getBlogs{
    
    sharedManager.blogcount=(int)[[sharedManager.db selectAllQueryWithTableName:@"blogs"] count];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    // Checking for cached data
    if([blogListArray count] == 0)
    {
        
        // Getting List of Articles for particular channels
        if([Validations isconnectedToInternet] )
        {
            [sharedManager.sync fillBlogsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [sharedManager hideLoader];
                [self removeThemeView];
                if(status==1)
                {
                    [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        blogListArray= [result mutableCopy];
                        sharedManager.blogsArray=[result mutableCopy];
                        [tblView reloadData];
                    }];
                }
                else{
                    [tblView reloadData];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self removeThemeView];
                    [Globals ShowAlertWithTitle:@"Error" Message:str];
                }
            }];
        }
        else{
            [tblView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self removeThemeView];
            [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
        }
    }
    else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [sharedManager hideLoader];
        [self removeThemeView];
        [tblView reloadData];
        [tblView scrollsToTop];
    }
    
}
-(void) showAnimation{
    // With Completion
    [UIView animateWithDuration:0.4f animations:^(void){
        tblView.alpha = 1.0f;
        [tblView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    }completion:^(BOOL finished) {
        [tblView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
}
-(void)getLatestArticles
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        
        //        [[NSNotificationCenter defaultCenter] removeObserver:@"syncCompleted"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(isSyncCompleted:)
                                                     name:@"syncCompleted"
                                                   object:sharedManager.syncCompleted];
        sharedManager.isRefreshFromDashBoard=true;
        
        if([Validations isconnectedToInternet] )
        {
            //            sharedManager.isAllAticleReceived =false;
            //            sharedManager.isAllBlogsReceived =false;
            //            sharedManager.isAllVideoReceived=false;
            
            [sharedManager.user getRegisterUserProfile:^(NSString *msg, int status) {
                
                [self getArticles];
                [self getReadingList];
            }];
            
            [self performSelector:@selector(callFillPages) withObject:nil afterDelay:5.0f];
        }
        else{
            [tblView reloadData];
            [tblView scrollsToTop];
            [sharedManager hideLoader];
            [self removeThemeView];
            [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
        }
        if (refreshControl) {
            [refreshControl endRefreshing];
        }
    });
}

-(void)callFillPages{
    [sharedManager.sync fillPages:^(NSString *str, int status) {
        if (status==1) {
            [sharedManager.sync getAllPagesWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                if (status==1) {
                }
            }];
        }
        [self removeThemeView];
        
    }];
}
-(IBAction)searchClicked
{
    [searchBar setHidden:NO];
    [btnSearch setHidden:YES];
}


#pragma mark Table methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try{
        static NSString *cellIdentifier = @"cellArticle";
        __block CellArticle *cell;
        
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(concurrentQueue, ^{
            if (indexPath.row==0) {
                cell=[tblView dequeueReusableCellWithIdentifier:@"zeroCell" forIndexPath:indexPath];
            }
            else
            {
                cell =[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
            }
            if (cell == nil) {
                if (indexPath.row==0) {
                    cell =[[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zeroCell"];
                }
                else{
                    cell =[[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellArticle"] ;
                }
            }
            for(UIView *subview in cell.contentView.subviews)
            {
                if ([subview isKindOfClass:[YTPlayerView class]]) {
                    [subview removeFromSuperview];
                }
                
            }
            for(UIView *subview in cell.categoryView.subviews)
            {
                [subview removeFromSuperview];
            }
            [cell.btnDigitalEnterprise setTitleColor:THEME_TAG_COLOR forState:UIControlStateNormal];
            [cell.videoIcon setHidden:YES];
            if ([dashboardList count] == 0) {
                // If there are no articles to display than we set default text
                [cell.txtTitle setText:@""];
                [cell.videoIcon setHidden:YES];
                //[cell.txtTitle setTextColor:[UIColor blackColor]];
                [cell.txtDesc setText:@""];
                [cell.imgContent setImage:[UIImage imageNamed:@""]];
            }
            else if ([searchResults count] == 0 && isSearch) {
                [cell.txtTitle setText:@""];
                [cell.videoIcon setHidden:YES];
                //[cell.txtTitle setTextColor:[UIColor blackColor]];
                [cell.txtDesc setText:@""];
                [cell.imgContent setImage:[UIImage imageNamed:@""]];
            }
            else{
                // Setting up the Values to the cell if there are articles available
                [cell.videoIcon setHidden:YES];
                
                
                if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Articles"]) {
                    Articles *tmpArticle;
                    [cell.videoIcon setHidden:YES];
                    
                    tmpArticle=[[dashboardList objectAtIndex:indexPath.row]  objectForKey:@"data"];
                    
                    [cell.txtTitle setText:tmpArticle.title];
                    [cell.txtDesc setText:tmpArticle.summary];
                    if (indexPath.row==0) {
                        NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpArticle.imageUrls valueForKey:@"phoneHero"]];
                        if([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"]){
                            strImageUrl =  [NSString stringWithFormat:@"%@",[tmpArticle.imageUrls valueForKey:@"tabletHero"]];
                            
                        }
                        
                        if([sharedManager isNotNull:strImageUrl])
                            [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                        
                    }
                    else{
                        NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpArticle.imageUrls valueForKey:@"thumbnail"]];
                        if([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"])
                        {
                            strImageUrl =  [NSString stringWithFormat:@"%@",[tmpArticle.imageUrls valueForKey:@"phoneHero"]];
                        }
                        if([sharedManager isNotNull:strImageUrl])
                            [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                    }
                    
                    
                    cell.imgContent.contentMode = UIViewContentModeScaleAspectFill;
                    cell.imgContent.clipsToBounds = YES;
                    
                    float ypos=cell.txtDesc.frame.origin.y +  [self heightNeededForText:cell.txtDesc.text withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] width:cell.txtDesc.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
                    float xpos=cell.txtDesc.frame.origin.x;
                    CGRect frame=CGRectMake(5, 5, 50, 23);
                    for(UIView *subview in cell.contentView.subviews)
                    {
                        if([subview isKindOfClass: [CategoryButtons class]])
                        {
                            [subview removeFromSuperview];
                        }
                    }
                    tmpArticle.isCategoryPresent=false;
                    
                    
                    if ([self getTopicWithUUDI:tmpArticle.topicId]) {
                        Topics *highlightedTopic=[self getTopicWithUUDI:tmpArticle.topicId];
                        [cell.btnDigitalEnterprise setTitle:[highlightedTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                        tmpArticle.isCategoryPresent=true;
                        tmpArticle.currentTopic=highlightedTopic;
                        cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                        [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else{
                        for(int i=0; i<[self.sharedManager.topicsArray count]; i++)
                        {
                            Topics *tempTopic=(Topics *)[self.sharedManager.topicsArray objectAtIndex:i];
                            for (int j=0; j<[tempTopic.channelId count]; j++) {
                                if ([[tempTopic.channelId objectAtIndex:j] isEqualToString:tmpArticle.channelId]) {
                                    tmpArticle.isCategoryPresent=true;
                                    tmpArticle.topicId=tempTopic.topicId;
                                    tmpArticle.currentTopic=tempTopic;
                                    CategoryButtons *btn=[[CategoryButtons alloc] init];
                                    btn.name=[NSString stringWithFormat:@"%@",tempTopic.topicname];
                                    [btn setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                                    [cell.btnDigitalEnterprise setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                                    
                                    frame.size.width=[self widthNeededForText:[tempTopic.topicname uppercaseString] withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] height:cell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping]+10;
                                    [btn.titleLabel setFont: [btn.titleLabel.font fontWithSize: 12.0]];
                                    [btn setTitleColor:[UIColor colorWithRed:(188.0f/255.0f) green:(182.0f/255.0f) blue:(11.0f/255.0f) alpha:1.0] forState:UIControlStateNormal  ];
                                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                    btn.frame=frame;
                                    [btn addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                                    cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                                    [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                                    if (i%2==0) {
                                        xpos=xpos+frame.size.width+20;
                                        frame.origin.x=xpos;
                                    }
                                    else{
                                        ypos=ypos+110;
                                        frame.origin.y=ypos;
                                    }
                                    cell.categoryView.frame=CGRectMake(cell.categoryView.frame.origin.x, cell.categoryView.frame.origin.y, cell.categoryView.frame.size.width, ypos);
                                }
                            }
                            
                        }
                    }
                    if (!tmpArticle.isCategoryPresent) {
                        [cell.btnDigitalEnterprise setHidden:YES];
                    }
                    else{
                        [cell.btnDigitalEnterprise setHidden:NO];
                    }
                }
                else if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Blog"]){
                    Blogs *tmpBlog;
                    [cell.videoIcon setHidden:YES];
                    if(!isSearch)
                    {
                        tmpBlog=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                        
                    }
                    else{
                        tmpBlog=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                    }
                    [cell.txtTitle setText:tmpBlog.title];
                    [cell.txtDesc setText:tmpBlog.summary];
                    if (indexPath.row==0) {
                        NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpBlog.imageUrls valueForKey:@"phoneHero"]];
                        if([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"]){
                            strImageUrl =  [NSString stringWithFormat:@"%@",[tmpBlog.imageUrls valueForKey:@"tabletHero"]];
                            
                        }
                        if([sharedManager isNotNull:strImageUrl])
                            [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                        
                    }
                    else{
                        NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpBlog.imageUrls valueForKey:@"thumbnail"]];
                        if([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"])
                        {
                            strImageUrl =  [NSString stringWithFormat:@"%@",[tmpBlog.imageUrls valueForKey:@"phoneHero"]];
                        }
                        if([sharedManager isNotNull:strImageUrl])
                            [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                    }
                    float ypos=cell.txtDesc.frame.origin.y +  [self heightNeededForText:cell.txtDesc.text withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] width:cell.txtDesc.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
                    float xpos=cell.txtDesc.frame.origin.x;
                    CGRect frame=CGRectMake(5, 5, 80, 23);
                    for(UIView *subview in cell.categoryView.subviews)
                    {
                        
                        [subview removeFromSuperview];
                        
                    }
                    tmpBlog.isCategoryPresent=false;
                    
                    if ([self getTopicWithUUDI:tmpBlog.topicId]) {
                        Topics *highlightedTopic=[self getTopicWithUUDI:tmpBlog.topicId];
                        [cell.btnDigitalEnterprise setTitle:[highlightedTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                        tmpBlog.isCategoryPresent=true;
                        tmpBlog.currentTopic=highlightedTopic;
                        cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                        [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else{
                        for(int i=0; i<[self.sharedManager.topicsArray count]; i++)
                        {
                            Topics *tempTopic=(Topics *)[self.sharedManager.topicsArray objectAtIndex:i];
                            for (int j=0; j<[tempTopic.channelId count]; j++) {
                                if ([[tempTopic.channelId objectAtIndex:j] isEqualToString:tmpBlog.channelId]) {
                                    tmpBlog.isCategoryPresent=true;
                                    tmpBlog.topicId=tempTopic.topicId;
                                    tmpBlog.currentTopic=tempTopic;
                                    CategoryButtons *btn=[[CategoryButtons alloc] init];
                                    btn.name=[NSString stringWithFormat:@"%@",tempTopic.topicname];
                                    [btn setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                                    [cell.btnDigitalEnterprise setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                                    frame.size.width=[self widthNeededForText:[tempTopic.topicname uppercaseString] withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] height:cell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping]+10;
                                    [btn.titleLabel setFont: [btn.titleLabel.font fontWithSize: 12.0]];
                                    [btn setTitleColor:[UIColor colorWithRed:(188.0f/255.0f) green:(182.0f/255.0f) blue:(11.0f/255.0f) alpha:1.0] forState:UIControlStateNormal  ];
                                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                    btn.frame=frame;
                                    cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                                    [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                                    [btn addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                                    if (i%2==0) {
                                        xpos=xpos+frame.size.width+20;
                                        frame.origin.x=xpos;
                                    }
                                    else{
                                        ypos=ypos+110;
                                        frame.origin.y=ypos;
                                    }
                                    cell.categoryView.frame=CGRectMake(cell.categoryView.frame.origin.x, cell.categoryView.frame.origin.y, cell.categoryView.frame.size.width, ypos);
                                }
                            }
                            
                        }
                        
                    }
                    if (!tmpBlog.isCategoryPresent) {
                        cell.categoryView.frame=CGRectMake(cell.categoryView.frame.origin.x, cell.categoryView.frame.origin.y, cell.categoryView.frame.size.width, 0);
                        [cell.btnDigitalEnterprise setHidden:YES];
                        
                    }
                    else{
                        [cell.btnDigitalEnterprise setHidden:NO];
                    }
                }
                else if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Video"]){
                    Video *tmpVideo;
                    [cell.videoIcon setHidden:NO];
                    if(!isSearch)
                    {
                        tmpVideo=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                    }
                    else{
                        tmpVideo=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                    }
                    [cell.txtTitle setText:tmpVideo.title];
                    [cell.txtDesc setText:tmpVideo.summary];
                    
                    
                    NSString *youtubeId=[Globals extractYoutubeID:tmpVideo.videoUri];
                    if (youtubeId) {
                        //
                        self.playerView=[[YTPlayerView alloc] initWithFrame:cell.imgContent.frame];
                        
                        if (indexPath.row==0) {
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_sync(concurrentQueue, ^{
                                
                                NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpVideo.imageUrls valueForKey:@"phoneHero"]];
                                if([sharedManager isNotNull:strImageUrl] && !([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"]))
                                {
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                                }
                                else
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://img.youtube.com/vi/%@/1.jpg",youtubeId ] ]  placeholderImage:nil options:SDWebImageRefreshCached];
                                
                            });
                        }
                        else{
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_sync(concurrentQueue, ^{
                                NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpVideo.imageUrls valueForKey:@"thumbnail"]];
                                if([sharedManager isNotNull:strImageUrl] && !([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"]))
                                {
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                                }
                                
                                else
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://img.youtube.com/vi/%@/1.jpg",youtubeId ] ]  placeholderImage:nil options:SDWebImageRefreshCached];
                            });
                            
                        }
                    }
                    else{
                        if (indexPath.row==0) {
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_sync(concurrentQueue, ^{
                                
                                NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpVideo.imageUrls valueForKey:@"phoneHero"]];
                                if([sharedManager isNotNull:strImageUrl] && !([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"]))
                                {
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                                }
                                else
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://img.youtube.com/vi/%@/1.jpg",youtubeId ] ]  placeholderImage:nil options:SDWebImageRefreshCached];
                                
                            });
                        }
                        else{
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_sync(concurrentQueue, ^{
                                NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpVideo.imageUrls valueForKey:@"thumbnail"]];
                                if([sharedManager isNotNull:strImageUrl] && !([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"]))
                                {
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                                }
                                
                                else
                                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://img.youtube.com/vi/%@/1.jpg",youtubeId ] ]  placeholderImage:nil options:SDWebImageRefreshCached];
                            });
                            
                        }
                    }
                    
                    float ypos=cell.txtDesc.frame.origin.y +  [self heightNeededForText:cell.txtDesc.text withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] width:cell.txtDesc.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
                    float xpos=cell.txtDesc.frame.origin.x;
                    CGRect frame=CGRectMake(5, 5, 50, 40);
                    for(UIView *subview in cell.categoryView.subviews)
                    {
                        
                        [subview removeFromSuperview];
                        
                    }
                    tmpVideo.isCategoryPresent=false;
                    
                    if ([self getTopicWithUUDI:tmpVideo.topicId]) {
                        Topics *highlightedTopic=[self getTopicWithUUDI:tmpVideo.topicId];
                        [cell.btnDigitalEnterprise setTitle:[highlightedTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                        tmpVideo.isCategoryPresent=true;
                        tmpVideo.currentTopic=highlightedTopic;
                        cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                        [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else{
                        for(int i=0; i<[self.sharedManager.topicsArray count]; i++)
                        {
                            Topics *tempTopic=(Topics *)[self.sharedManager.topicsArray objectAtIndex:i];
                            for (int j=0; j<[tempTopic.channelId count]; j++) {
                                if ([[tempTopic.channelId objectAtIndex:j] isEqualToString:tmpVideo.channelId]) {
                                    tmpVideo.topicId=tempTopic.topicId;
                                    tmpVideo.isCategoryPresent=true;
                                    tmpVideo.currentTopic=tempTopic;
                                    CategoryButtons *btn=[[CategoryButtons alloc] init];
                                    btn.name=[NSString stringWithFormat:@"%@",tempTopic.topicname];
                                    [btn setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                                    [cell.btnDigitalEnterprise setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                                    frame.size.width=[self widthNeededForText:[tempTopic.topicname uppercaseString] withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] height:cell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping]+10;
                                    [btn.titleLabel setFont: [btn.titleLabel.font fontWithSize: 12.0]];
                                    [btn setTitleColor:[UIColor colorWithRed:(188.0f/255.0f) green:(182.0f/255.0f) blue:(11.0f/255.0f) alpha:1.0] forState:UIControlStateNormal  ];
                                    cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                                    [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                                    btn.frame=frame;
                                    [btn addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                                    if (i%2==0) {
                                        xpos=xpos+frame.size.width+20;
                                        frame.origin.x=xpos;
                                    }
                                    else{
                                        ypos=ypos+110;
                                        frame.origin.y=ypos;
                                    }
                                    cell.categoryView.frame=CGRectMake(cell.categoryView.frame.origin.x, cell.categoryView.frame.origin.y, cell.categoryView.frame.size.width, ypos);
                                }
                            }
                            
                        }
                    }
                    if (!tmpVideo.isCategoryPresent) {
                        cell.categoryView.frame=CGRectMake(cell.categoryView.frame.origin.x, cell.categoryView.frame.origin.y, cell.categoryView.frame.size.width, 0);
                        [cell.btnDigitalEnterprise setHidden:YES];
                        cell.btnDigitalEnterprise.frame=CGRectMake(cell.btnDigitalEnterprise.frame.origin.x, cell.btnDigitalEnterprise.frame.origin.y, cell.btnDigitalEnterprise.frame.size.width, 0);
                    }
                    else{
                        [cell.btnDigitalEnterprise setHidden:NO];
                        cell.btnDigitalEnterprise.frame=CGRectMake(cell.btnDigitalEnterprise.frame.origin.x, cell.btnDigitalEnterprise.frame.origin.y, cell.btnDigitalEnterprise.frame.size.width, 20);
                    }
                }
                
                
            }
            cell.imgContent.contentMode = UIViewContentModeScaleToFill;
            cell.imgContent.clipsToBounds = YES;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        });
        return cell;
    }
    @catch (NSException *exception) {
        //
    }
}
-(void) redirectToCategory:(id)btn{
    
    UIButton *tmpBtn=(UIButton *)btn;
    NSDictionary *dic=[dashboardList objectAtIndex:tmpBtn.tag-1000];
    Topics *tempTopic;
    Articles *tempArticle;
    Blogs *tempBlog;
    Video *tempVideo;
    NSString *channelId=@"";
    NSString *topicId=@"";
    if ([[dic valueForKey:@"type"] isEqualToString:@"Articles"]) {
        tempArticle=(Articles *)[dic objectForKey:@"data"];
        tempTopic=tempArticle.currentTopic;
        channelId=tempArticle.channelId;
        topicId=tempArticle.topicId;
    }
    else if ([[dic valueForKey:@"type"] isEqualToString:@"Blog"]) {
        tempBlog=(Blogs *)[dic objectForKey:@"data"];
        tempTopic=tempBlog.currentTopic;
        channelId=tempBlog.channelId;
        topicId=tempBlog.topicId;
    }
    else if ([[dic valueForKey:@"type"] isEqualToString:@"Video"]) {
        tempVideo=(Video *)[dic objectForKey:@"data"];
        tempTopic=tempVideo.currentTopic;
        channelId=tempVideo.channelId;
        topicId=tempVideo.topicId;
    }
    
    NSMutableArray *dashboardListAry = MArray;
    // Looping for Topic New Logic
    [sharedManager.sync getChannelsForUDIDs:@[channelId] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
        
        if ([result count]>0) {
            
            
            Channels *ch1=(Channels *)[result objectAtIndex:0];
            
            if ([[ch1 type] isEqualToString:@"Articles"]) {
                
                self.articleListArray = MArray;
                self.articleListArray = [[sharedManager getArticles:ch1.uuid] mutableCopy];
                
                for(int k=0; k<[self.articleListArray count]; k++)
                {
                    
                    if ([[[self.articleListArray objectAtIndex:k] topicId] isEqualToString:[tempTopic uuid]]) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.articleListArray objectAtIndex:k],@"Articles"] forKeys:@[@"data",@"type"]];
                        [dashboardListAry addObject:dic];
                    }
                    
                }
            }
            else if ([[ch1 type] isEqualToString:@"Blog"]) {
                self.blogListArray = MArray;
                self.blogListArray = [[sharedManager getBlogs:ch1.uuid] mutableCopy];
                
                
                for(int k=0; k<[self.blogListArray count]; k++)
                {
                    
                    if ([[[self.blogListArray objectAtIndex:k] topicId] isEqualToString:[tempTopic uuid]]) {
                        
                        
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.blogListArray objectAtIndex:k],@"Blog"] forKeys:@[@"data",@"type"]];
                        [dashboardListAry addObject:dic];
                        
                    }
                    
                }
                
            }
            else if ([[ch1 type] isEqualToString:@"Video"]) {
                self.videoListArray=[[NSMutableArray alloc] init];
                self.videoListArray = [[sharedManager getVideos:ch1.uuid] mutableCopy];
                
                for(int k=0; k<[self.videoListArray count]; k++)
                {
                    
                    if ([[[self.videoListArray objectAtIndex:k] topicId] isEqualToString:topicId]) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.videoListArray objectAtIndex:k],@"Video"] forKeys:@[@"data",@"type"]];
                        [dashboardListAry addObject:dic];
                        
                    }
                }
            }
        }
    }];
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    article.dashboardList=[dashboardListAry mutableCopy];
    article.isCategory=YES;
    article.titleScreen=[tempTopic topicname];
    [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
    
}
-(void) redirectToCategory1:(id)btn{
    
    CategoryButtons *tmpBtn=(CategoryButtons *)btn;
    [sharedManager.sync getAllCategories:^(NSArray *result, NSString *str, int status) {
        [sharedManager hideLoader];
        [self removeThemeView];
        sharedManager.categoryArray=[result mutableCopy];
        for (int i=0; i<[sharedManager.categoryArray count]; i++) {
            //
            if ([[[sharedManager.categoryArray objectAtIndex:i] valueForKey:@"name"] isEqualToString:tmpBtn.name] ) {
                [sharedManager.sync getArticlesForUDIDs:[[sharedManager.categoryArray objectAtIndex:i] objectForKey:@"uuid"] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                    //
                    if(status==1)
                    {
                        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
                        article.articleListArray=[result mutableCopy];
                        article.titleScreen=[[sharedManager.categoryArray objectAtIndex:i] valueForKey:@"name"];
                        article.isCategory=true;
                        
                        [UIView animateWithDuration:.95 animations:^{
                            self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
                            self.view.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            if (finished) {
                                self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                self.view.alpha = 1.0;
                                [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
                            }
                        }];
                    }
                }];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([dashboardList count] == 0) {
        {
            
        }
        if(tableView.isHidden)
            tableView.hidden=false;
        return 1;
    }
    if(tableView.isHidden)
        tableView.hidden=false;
    //    NSLog(@"dashboardList total count %lu",(unsigned long)dashboardList.count);
    return [dashboardList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        if(indexPath.row==0)
        {
            return 341;
        }
        
        else{
            
            Articles *tmpArticle;
            Blogs *tmpBlog;
            Video *tmpVideo;
            if (!isSearch) {
                if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Articles"]) {
                    tmpArticle=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                    
                    if(tmpArticle.isCategoryPresent)
                    {
                        return 160;
                    }
                    else{
                        return 140;
                    }
                }
                else if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Blog"]) {
                    tmpBlog=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                    
                    if(tmpBlog.isCategoryPresent)
                    {
                        return 160;
                    }
                    else{
                        return 140;
                    }
                }
                else if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Video"]) {
                    tmpVideo=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                    
                    if(tmpVideo.isCategoryPresent)
                    {
                        return 160;
                    }
                    else{
                        return 140;
                    }
                }
            }
            else{
                if (searchResults > 0) {
                    return 140;
                }
                
            }
            return 140;
        }
    }
    @catch (NSException *exception) {
        //
    }
}
-(CGFloat)calculaeHeightForTableViewCell1:(CellArticle *)sizingCell{
    
    CGFloat tmpheight=[self heightNeededForText:sizingCell.txtDesc.text withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping] + [self heightNeededForText:sizingCell.txtTitle.text withFont:[UIFont fontWithName:@"Lato-Bold" size:18.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
    tmpheight=tmpheight + sizingCell.categoryView.frame.size.height;
    CGFloat tmph=MAX(tmpheight, 140);
    
    CGSize size = CGSizeMake(sizingCell.frame.size.width, tmph);
    int padding = 20.0;
    if (tmpheight >= 70 && tmpheight < 500) {
        sizes= size.height + padding + 30;
    }
    else{
        sizes= size.height + padding;
    }
    return size.height;
    
}

-(CGFloat)calculaeHeightForTableViewCell:(CellArticle *)sizingCell{
    
    CGFloat tmpheight=[self heightNeededForText:sizingCell.txtDesc.text withFont:[UIFont fontWithName:@"Lato-Regular" size:12.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping] + [self heightNeededForText:sizingCell.txtTitle.text withFont:[UIFont fontWithName:@"Lato-Bold" size:18.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
    tmpheight=tmpheight + sizingCell.categoryView.frame.size.height;
    CGFloat tmph=MAX(tmpheight, 140);
    
    CGSize size = CGSizeMake(sizingCell.frame.size.width, tmph);
    int padding = 20.0;
    if (tmpheight >= 70 && tmpheight < 500) {
        sizes= size.height + padding + 30;
    }
    else{
        sizes= size.height + padding;
    }
    return size.height;
    
}

- (float)getTextHeightOfText:(NSString *)string font:(UIFont *)aFont width:(float)width {
    
    CGSize maximumLabelSize = CGSizeMake(width, CGFLOAT_MAX);
    
    CGRect textRect = [string boundingRectWithSize:maximumLabelSize
                       
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                       
                                        attributes:@{NSFontAttributeName:aFont}
                       
                                           context:nil];
    
    
    
    return textRect.size.height;
    
}

- (CGFloat)heightNeededForText:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                  attributes:@{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle }
                                     context:nil].size;
    
    return ceilf(size.height);
}

- (CGFloat)widthNeededForText:(NSString *)text withFont:(UIFont *)font height:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,width )
                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                  attributes:@{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle }
                                     context:nil].size;
    
    return ceilf(size.width);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([dashboardList count] != 0) {
        
        Video *currentVideo;
        
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
        
        if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Articles"]) {
            Articles *currentArticle=[[dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
            article.currentArticle=currentArticle;
        }
        else if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Blog"]) {
            Blogs *currentBlog=[[dashboardList objectAtIndex:indexPath.row]  objectForKey:@"data"];
            article.currentBlog=currentBlog;
        }
        
        else if ([[[dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Video"])
        {
            currentVideo=[[dashboardList objectAtIndex:indexPath.row]  objectForKey:@"data"];
            NSString *youtubeId=[Globals extractYoutubeID:currentVideo.videoUri];
            if (youtubeId) {
                
                self.playerView=[[YTPlayerView alloc] initWithFrame:self.view.frame];
                NSDictionary *param=[[NSDictionary alloc] initWithObjects:@[@"0"] forKeys:@[@"showinfo"]];
                [self.playerView loadWithVideoId:youtubeId playerVars:param];
                
                
                [self.view addSubview:self.playerView];
                [self.playerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                self.playerView.delegate=self;
                
                [sharedManager showLoader];
                [self.playerView playVideo];
                sharedManager.isVideoPlaying=true;
                
                
            }
            else{
                
                [Globals ShowAlertWithTitle:@"TestSqliteToReplaceContento" Message:@"Video cannot be played at this time."];
                return;
                
                //                NSURL *movieURL = [NSURL URLWithString:currentVideo.videoUri];
                //                MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
                //                [self presentMoviePlayerViewControllerAnimated:movieController];
                //                [movieController.moviePlayer play];
                
            }
            return;
        }
        [sharedManager showLoaderIn:self.view];
        
        tableView.hidden=true;
        
        [self.searchDisplayController setActive:NO];
        [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
        
        [UIView animateWithDuration:.35 animations:^{
            self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
            [self.view setBackgroundColor:[UIColor whiteColor]];
            //            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                tableView.hidden=false;
                
                [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
                self.view.alpha = 1.0;
                self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
        }];
        
    }
}

#pragma mark search methods
- (void)hideSearchBar {
    tblView.TestSqliteToReplaceContentoffset = CGPointMake(0, 0);
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    tblView.frame=CGRectMake(tblView.frame.origin.x, 20, tblView.frame.size.width, tblView.frame.size.height);
    [tmpView setHidden:NO];
    [headerView setHidden:YES];
    [tmpView sendSubviewToBack:tblView];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [headerView setHidden:NO];
    [tmpView setHidden:YES];
    return YES;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    [tableView setFrame:CGRectMake(0, 20, tblView.frame.size.width, tblView.frame.size.height)];
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    @try{
        NSString *strSearchName =searchController.searchBar.text;
        
        if ([strSearchName isEqualToString:@""] ) {
            isSearch = NO;
        }
        else {
            isSearch = YES;
            [Articles filterArrayUsingString:strSearchName WithCompletion:^(NSArray *result, NSString *str, int status) {
                //
                searchResults=[result mutableCopy];
                [tblView reloadData];
            }] ;
            
        }
    } @catch (NSException *exception) {
    }
    @finally {
    }
}
-(IBAction)btnMenuClicked:(id)sender
{
    //
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

// For Searchbar search function
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if(![searchText isEqualToString:@""])
    {
        [Articles filterArrayUsingString:searchText WithCompletion:^(NSArray *result, NSString *str, int status) {
            //
            isSearch=true;
            searchResults=[result mutableCopy];
            [tblView reloadData];
            
        }];
    }
    else{
        isSearch=false;
        [tblView reloadData];
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBarTab
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearch=false;
    [tblView reloadData];
    
}


// For animation in UITableView Cell
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //vivek
    canAnimate=false;
    if (canAnimate && indexPath.row!=0) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [cell.layer addAnimation:transition forKey:kCATransition];
        
        //2. Define the initial state (Before the animation)
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0.9;
        
        
        //3. Define the final state (After the animation) and commit the animation
        [UIView beginAnimations:@"fade" context:NULL];
        [UIView setAnimationDuration:1.0];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    }
    
    if (indexPath.row==([articleListArray count] -1)) {
        canAnimate=false;
    }
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView1{
    
    if (scrollView1.TestSqliteToReplaceContentoffset.y > 120) {
        [self.btnMenu setHidden:YES];
        [self.displayMenuButton setHidden:YES];
    }
    else{
        [self.btnMenu setHidden:NO];
        [self.displayMenuButton setHidden:NO];
    }
}

-(void)getNextDataInBackground
{
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        
        sharedManager.intOffset=sharedManager.intOffset+5;
        sharedManager.intLimit=5;
        
        if(sharedManager.isAllAticleReceived && sharedManager.isAllBlogsReceived && sharedManager.isAllVideoReceived){
            self.tblView.TestSqliteToReplaceContentoffset = CGPointMake(0, 0);
            
            [spinner setHidden:true];
            [refreshControl endRefreshing];
            
            [spinner stopAnimating];
            [sharedManager hideLoader];
            
            [[NSNotificationCenter defaultCenter] removeObserver:@"syncCompleted"];
        }
        else{
            [sharedManager hideLoader];
            [self getArticles];
        }
        
    });
    
}

-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    if (state==kYTPlayerStateEnded || state==kYTPlayerStatePaused) {
        [playerView removeFromSuperview];
        
        [self.playerView removeFromSuperview];
        sharedManager.isVideoPlaying=false;
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    
}
-(UIColor *)playerViewPreferredWebViewBackgroundColor:(YTPlayerView *)playerView
{
    return [UIColor blackColor];
}
-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView{
    
    [sharedManager hideLoader];
    [playerView playVideo];

}

-(void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    
    [sharedManager hideLoader];
    [self.playerView removeFromSuperview];
    sharedManager.isVideoPlaying=false;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
#pragma mark Margins

-(void)viewDidLayoutSubviews
{
    if ([tblView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tblView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tblView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tblView setLayoutMargins:UIEdgeInsetsZero];
    }
}


-(Topics *) getTopicWithUUDI:(NSString *)topicId{
    for(int i=0; i<[self.sharedManager.topicsArray count]; i++)
    {
        if ([[[self.sharedManager.topicsArray objectAtIndex:i] uuid] isEqualToString:topicId]) {
            return [self.sharedManager.topicsArray objectAtIndex:i];
        }
    }
    return nil;
}


#pragma mark Memory release
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:false];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}
-(void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"syncCompleted"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getFilterArticlesFromLocalDB
{
    [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
        
        articleListArray= [result mutableCopy];
        if(articleListArray.count>0)
            dashboardList= MArray;
        sharedManager.articleArray=[result mutableCopy];
        
        for (int i=0; i<[articleListArray count]; i++) {
            NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[articleListArray objectAtIndex:i],@"Articles",[[[articleListArray objectAtIndex:i] meta] updatedAt]] forKeys:@[@"data",@"type",@"updatesDate"]];
            
            //            for (int j=0; j<sharedManager.topicsArray.count; j++) {
            //                //
            //
            //                Topics *objTopics = (Topics*)[sharedManager.topicsArray objectAtIndex:j];
            //                if ([[objTopics channelId] containsObject:[[articleListArray objectAtIndex:i] uuid]] )
            //                {
            //
            //                    [dashboardList addObject:dic];
            //                }
            //            }
            [dashboardList addObject:dic];
            
            //            for (int j=0; j<sharedManager.channelArray.count; j++) {
            //
            //                Channels *objTopics = (Channels*)[sharedManager.channelArray objectAtIndex:j];
            //                if ([objTopics.uuid isEqualToString:[[articleListArray objectAtIndex:i] topicId]] )
            //                {
            //                }
            //            }
            
            //            [dashboardList addObject:dic];
            
        }
        
        [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
            sharedManager.blogsArray=[result mutableCopy];
            blogListArray=[result mutableCopy];
            for (int i=0; i<[result count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[blogListArray objectAtIndex:i],@"Blog",[[[blogListArray objectAtIndex:i] meta] updatedAt]] forKeys:@[@"data",@"type",@"updatesDate"]];
                //                [dashboardList addObject:dic];
                //                for (int j=0; j<sharedManager.topicsArray.count; j++) {
                //                    //
                //
                //                    Topics *objTopics = (Topics*)[sharedManager.topicsArray objectAtIndex:j];
                //                    if ([[objTopics channelId] containsObject:[[result objectAtIndex:i] uuid]] )
                //                    {
                //
                //                        [dashboardList addObject:dic];
                //                    }
                //                }
                //                [dashboardList addObject:dic];
                //                for (int j=0; j<sharedManager.topicsArray.count; j++) {
                //                    //
                //
                //                    Topics *objTopics = (Topics*)[sharedManager.topicsArray objectAtIndex:j];
                //                    if ([objTopics.topicId isEqualToString:[[blogListArray objectAtIndex:i] topicId]] )
                //                    {
                //                        [dashboardList addObject:dic];
                //                    }
                //                }
                [dashboardList addObject:dic];
                
                
            }
            
        }];
        [sharedManager.sync getAllVideosWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
            for (int i=0; i<[result1 count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Video",[[[result1 objectAtIndex:i] meta] updatedAt]] forKeys:@[@"data",@"type",@"updatesDate"]];
                //                for (int j=0; j<sharedManager.topicsArray.count; j++) {
                //                    //
                //
                //                    Topics *objTopics = (Topics*)[sharedManager.topicsArray objectAtIndex:j];
                //                    if ([objTopics.topicId isEqualToString:[[result1 objectAtIndex:i] topicId]] )
                //                    {
                //                        [dashboardList addObject:dic];
                //                    }
                //                }
                //                [dashboardList addObject:dic];
                [dashboardList addObject:dic];
                
            }
            
        }];
        [self checkForPushNotification];
        [self sortDashboardList];
        [sharedManager hideLoader];
        [self performSelector:@selector(getTopics) withObject:nil afterDelay:2.0f];
        
        [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
            //                        sharedManager.categoryArray = [result mutableCopy];
            sharedManager.topicsArray = [result mutableCopy];
            [tblView reloadData];
            [self removeThemeView];
            
        }];
        [self removeThemeView];
        
    }];
}
#pragma mark MPMediaPlayback
- (void)beginSeekingForward{}

- (void)beginSeekingBackward{}

- (void)endSeeking{}

- (void)prepareToPlay{}

- (void)play{}

- (void)pause{}

- (void)stop{}

@end
