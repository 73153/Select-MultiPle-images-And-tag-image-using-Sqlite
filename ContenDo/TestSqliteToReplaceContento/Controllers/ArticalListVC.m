//
//  ArticalListVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 17/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "ArticalListVC.h"
#import "CellArticle.h"
#import "Validations.h"
#import "ArticleDetailVC.h"
#import "UIImageView+WebCache.h"
#import "CategoryButtons.h"
#import "Constants.h"
@interface ArticalListVC ()

@end

@implementation ArticalListVC
@synthesize titleScreen,currentPlaybackRate,currentPlaybackTime,isPreparedToPlay;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVC];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closedFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        //Close menu show
        [self.btnMenu setHidden:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        // Open Menu hide
        [self.btnMenu setHidden:YES];
    }];
    [self.headerView setBackgroundColor:THEME_INNER_BG_COLOR];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.btnMenu setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isSyncCompleted:)
                                                 name:@"syncCompleted"
                                               object:nil];
    
}
-(void)closedFullScreen{
    Globals *sharedManager=[Globals sharedManager];
    [self.playerView removeFromSuperview];
    sharedManager.isVideoPlaying=false;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(void) isSyncCompleted:(get_completion_block)sync
{
    @try{
        Globals *sharedManager=[Globals sharedManager];
        if ([sharedManager.updatedChannelArray count] == 0) {
            if (sharedManager.channelSyncCount == [sharedManager.channelArray count]) {
                [sharedManager hideLoader];
                //
                if(sync)
                {
                    [sharedManager hideLoader];
                    [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                        [sharedManager hideLoader];
                        self.dashboardList= MArray;
                        for (int i=0; i<[self.articleListArray count]; i++) {
                            NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.articleListArray objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                            [self.dashboardList addObject:dic];
                        }
                        sharedManager.articleArray=[result mutableCopy];
                        [self.tableView reloadData];
                        [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                            for (int i=0; i<[result1 count]; i++) {
                                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                                [self.dashboardList addObject:dic];
                            }
                            [self.tableView reloadData];
                        }];
                        [sharedManager.sync getAllCategories:^(NSArray *result, NSString *str, int status) {
                            [sharedManager hideLoader];
                            sharedManager.categoryArray = [result mutableCopy];
                            
                        }];
                    }];
                }
            }
            
        }
        else{
            if (sharedManager.channelSyncCount == [sharedManager.updatedChannelArray count]) {
                [sharedManager hideLoader];
                //
                if(sync)
                {
                    [sharedManager hideLoader];
                    [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                        [sharedManager hideLoader];
                        self.dashboardList= MArray;
                        sharedManager.articleArray=[result mutableCopy];
                        [self.tableView reloadData];
                        for (int i=0; i<[sharedManager.articleArray count]; i++) {
                            NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.articleListArray objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                            [self.dashboardList addObject:dic];
                        }
                        [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                            for (int i=0; i<[result count]; i++) {
                                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.articleListArray objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                                [self.dashboardList addObject:dic];
                            }
                            [self.tableView reloadData];
                        }];
                        [sharedManager.sync getAllCategories:^(NSArray *result, NSString *str, int status) {
                            [sharedManager hideLoader];
                            sharedManager.categoryArray = [result mutableCopy];
                            
                        }];
                        
                    }];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}
-(void) initVC{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    //Setting & hiding menu
    if (self.isCategory) {
        [self.btnMenu setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        [self.btnMenu removeTarget:nil
                            action:NULL
                  forControlEvents:UIControlEventAllEvents];
        [self.btnMenu addTarget:self action:@selector(backbtn) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        //For menu
        [self.btnMenu removeTarget:nil
                            action:NULL
                  forControlEvents:UIControlEventAllEvents];
        [self.btnMenu addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
        [SlideNavigationController sharedInstance].enableShadow = false;
    }
    
    //Setting LABEL FOR CHANNEL
    if(!self.titleScreen )
    {
        [self.titleLabel setText:self.currentChannel.label];
    }
    else
    {
        [self.titleLabel setText:[self.titleScreen capitalizedString]];
    }
    
    // Setting TableView
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if ([self.currentChannel.type isEqualToString:@"Articles"]) {
        [self getArticles];
    }
    else if ([self.currentChannel.type isEqualToString:@"Blog"]) {
        [self getBlogs];
    }
    else if ([self.currentChannel.type isEqualToString:@"Video"]) {
        [self getVideos];
    }
    else{
        [sharedManager hideLoader];
        [self.tableView reloadData];
    }
    if(self.isChannel)
    {
        refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.backgroundColor = [UIColor whiteColor];
        refreshControl.tintColor = THEME_INNER_BG_COLOR;
        [refreshControl addTarget:self
                           action:@selector(pullToRefresh)
                 forControlEvents:UIControlEventValueChanged];
        //[self.tableView addSubview:refreshControl];
    }
    if([self.articleListArray count] > 0)
    {
        [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Articles",(unsigned long)[self.articleListArray count]]];
    }
    else if([self.blogListArray count] > 0)
    {
        [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Blogs",(unsigned long)[self.blogListArray count]]];
    }
    else if([self.dashboardList count] > 0)
    {
        [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Contents",(unsigned long)[self.dashboardList count]]];
    }
    [self manageActivity];
}
-(void) getArticles{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    if(!self.articleListArray)
    {
        // Initializing Variables
        self.articleListArray=[[NSMutableArray alloc] init];
        // Getting List of Articles for particular channels
        [sharedManager.sync getArticlesForChannel:self.currentChannel.uuid WithCompletionBlock:^(id result,NSString *str, int status) {
            
            self.articleListArray=[result mutableCopy];
            [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Articles",(unsigned long)[self.articleListArray count]]];
            [sharedManager hideLoader];
            [self.tableView reloadData];
        }];
    }
    else{
        [sharedManager hideLoader];
        [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Articles",(unsigned long)[self.articleListArray count]]];
        [self.tableView reloadData];
    }
}
-(void)getVideos{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    if(!self.videoListArray)
    {
        // Initializing Variables
        self.videoListArray=[[NSMutableArray alloc] init];
        
        // Getting List of Articles for particular channels
        
        [sharedManager.sync getVideosForChannel:self.currentChannel.uuid WithCompletionBlock:^(id result,NSString *str, int status) {
            [self.tableView reloadData];
            self.videoListArray=[result mutableCopy];
            [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Videos",(unsigned long)[self.videoListArray count]]];
            [sharedManager hideLoader];
        }];
    }
    else{
        [sharedManager hideLoader];
        [self.totalBlogs setText:[NSString stringWithFormat:@"     %lu Blogs",(unsigned long)[self.articleListArray count]]];
        [self.tableView reloadData];
    }
}
-(void) getBlogs{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    if(!self.blogListArray)
    {
        // Initializing Variables
        self.blogListArray=[[NSMutableArray alloc] init];
        
        // Getting List of Articles for particular channels
        
        [sharedManager.sync getBlogsForChannel:self.currentChannel.uuid WithCompletionBlock:^(id result,NSString *str, int status) {
            [self.tableView reloadData];
            self.blogListArray=[result mutableCopy];
            [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Blogs",(unsigned long)[self.blogListArray count]]];
            [sharedManager hideLoader];
        }];
    }
    else{
        [sharedManager hideLoader];
        [self.totalBlogs setText:[NSString stringWithFormat:@"     %lu Blogs",(unsigned long)[self.articleListArray count]]];
        [self.tableView reloadData];
    }
}
-(void)manageActivity{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSDate *now = [NSDate date];
    NSString* myString = [dateFormat stringFromDate:now];
    if(self.currentChannel)
    {
        NSDictionary *dic11=[[NSDictionary alloc] initWithObjects:@[self.currentChannel.clientId,self.currentChannel.uuid,self.currentChannel.label,@"viewChannel",myString] forKeys:@[@"clientId",@"channelId",@"title",@"logType",@"timestamp"]];
        
        Activities *activity=[[Activities alloc] init];
        [activity saveActivity:dic11 withCompletion:^(NSDictionary *result, NSString *str, int status) {
            if (status==1) {
                //
            }
        }];
    }
}
-(void)pullToRefresh{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager showLoader];
    if([Validations isconnectedToInternet] )
    {
        [sharedManager.sync fillChannelsWithCompletionBlock:^(NSString *str, int status) {
            //
            if(status==1)
            {
                [sharedManager.sync getAllChannelsWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                    [sharedManager hideLoader];
                    sharedManager.channelSyncCount=0;
                    [sharedManager.sync fillArticlesWithCompletionBlock:^(id result,NSString *str, int status) {
                        [sharedManager hideLoader];
                    }];
                }];
            }
            else{
                [self.tableView reloadData];
                // [tblView scrollsToTop];
                [sharedManager hideLoader];
                [Globals ShowAlertWithTitle:@"Error" Message:str];
            }
        }];
    }
    else{
        [self.tableView reloadData];
        [self.tableView scrollsToTop];
        [sharedManager hideLoader];
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
    }
    if (refreshControl) {
        [refreshControl endRefreshing];
    }
}
// For back button
-(void)backbtn{
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}
-(void) redirectToCategory:(id)btn{
    Globals *sharedManager;
    UIButton *tmpBtn=(UIButton *)btn;
    NSDictionary *dic;
    Topics *tempTopic;
    Articles *tempArticle;
    Blogs *tempBlog;
    Video *tempVideo;
    NSString *channelId;
    if (self.isCategory && [_dashboardList count]>0) {
        
        dic=[_dashboardList objectAtIndex:tmpBtn.tag-1000];
        if ([[dic valueForKey:@"type"] isEqualToString:@"Articles"]) {
            tempArticle=(Articles *)[dic objectForKey:@"data"];
            tempTopic=tempArticle.currentTopic;
            channelId=tempArticle.channelId;
        }
        else if ([[dic valueForKey:@"type"] isEqualToString:@"Blog"]) {
            tempBlog=(Blogs *)[dic objectForKey:@"data"];
            tempTopic=tempBlog.currentTopic;
            channelId=tempBlog.channelId;
        }
        else if ([[dic valueForKey:@"type"] isEqualToString:@"Video"]) {
            tempVideo=(Video *)[dic objectForKey:@"data"];
            tempTopic=tempVideo.currentTopic;
            channelId=tempVideo.channelId;
        }
        
    }
    
    if ([self.articleListArray count] != 0) {
        tempArticle=[self.articleListArray objectAtIndex:tmpBtn.tag-1000];
        tempTopic=tempArticle.currentTopic;
        channelId=tempArticle.channelId;
    }
    else if ([self.blogListArray count] != 0) {
        tempBlog=[self.blogListArray objectAtIndex:tmpBtn.tag-1000];
        tempTopic=tempBlog.currentTopic;
        channelId=tempBlog.channelId;
    }
    else if ([self.videoListArray count] != 0) {
        tempVideo=[self.videoListArray objectAtIndex:tmpBtn.tag-1000];
        tempTopic=tempVideo.currentTopic;
        channelId=tempVideo.channelId;
    }
    
    
    sharedManager=[Globals sharedManager];
    
    [sharedManager showLoader];
    NSMutableArray *dashboardList=MArray;
    
    
    // Looping for Topic New Logic
    [sharedManager.sync getChannelsForUDIDs:@[channelId] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
        
        if ([result count]>0) {
            
            
            Channels *ch1=(Channels *)[result objectAtIndex:0];
            
            if ([[ch1 type] isEqualToString:@"Articles"]) {
                self.articleListArrayForCategory = MArray;
                self.articleListArrayForCategory = [[sharedManager getArticles:ch1.uuid] mutableCopy];
                for(int k=0; k<[self.articleListArrayForCategory count]; k++)
                {
                    
                    if ([[[self.articleListArrayForCategory objectAtIndex:k] topicId] isEqualToString:[tempTopic uuid]]) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.articleListArrayForCategory objectAtIndex:k],@"Articles"] forKeys:@[@"data",@"type"]];
                        [dashboardList addObject:dic];
                    }
                    
                }
            }
            else if ([[ch1 type] isEqualToString:@"Blog"]) {
                self.blogListArrayForCategory = MArray;
                self.blogListArrayForCategory = [[sharedManager getBlogs:ch1.uuid] mutableCopy];
                
                for(int k=0; k<[self.blogListArrayForCategory count]; k++)
                {
                    
                    if ([[[self.blogListArrayForCategory objectAtIndex:k] topicId] isEqualToString:[tempTopic uuid]]) {
                        
                        
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.blogListArrayForCategory objectAtIndex:k],@"Blog"] forKeys:@[@"data",@"type"]];
                        [dashboardList addObject:dic];
                        
                    }
                    
                }
                
            }
            else if ([[ch1 type] isEqualToString:@"Video"]) {
                self.videoListArrayForCategory = MArray;
                self.videoListArrayForCategory = [[sharedManager getVideos:ch1.uuid] mutableCopy];
                for(int k=0; k<[self.videoListArrayForCategory count]; k++)
                {
                    
                    if ([[[self.videoListArrayForCategory objectAtIndex:k] topicId] isEqualToString:[tempTopic uuid]]) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.videoListArray objectAtIndex:k],@"Video"] forKeys:@[@"data",@"type"]];
                        [dashboardList addObject:dic];
                        
                    }
                }
            }
        }
    }];
    
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];

    article.dashboardList=[dashboardList mutableCopy];
    article.isCategory=YES;
    article.titleScreen=[tempTopic topicname];
    [UIView animateWithDuration:1 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
            self.view.alpha = 1.0;
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    }];
}
-(void) redirectToCategory1:(id)btn{
    Globals *sharedManager;
    CategoryButtons *tmpBtn=(CategoryButtons *)btn;
    sharedManager=[Globals sharedManager];
    [sharedManager.sync getAllCategories:^(NSArray *result, NSString *str, int status) {
        [sharedManager hideLoader];
        sharedManager.categoryArray=[result mutableCopy];
        for (int i=0; i<[sharedManager.categoryArray count]; i++) {
            //
            if ([[[sharedManager.categoryArray objectAtIndex:i] valueForKey:@"name"] isEqualToString:tmpBtn.name] ) {
                [sharedManager.sync getArticlesForUDIDs:[[sharedManager.categoryArray objectAtIndex:i] objectForKey:@"uuid"] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                    //
                    if(status==1)
                    {
                        if (!self.currentChannel.channelId) {
                            //
                            self.currentChannel.channelId = [self.channelid mutableCopy];
                        }
                        else{
                            self.channelid=self.currentChannel.channelId;
                        }
                        NSMutableArray *filterChannelCategory=MArray;
                        for (Articles *art in result) {
                            
                            if(art.channelId==self.currentChannel.channelId)
                            {
                                [filterChannelCategory addObject:art];
                            }
                        }
                        
                        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
                        article.articleListArray=[result mutableCopy];
                        article.titleScreen=[[sharedManager.categoryArray objectAtIndex:i] valueForKey:@"name"];
                        article.isCategory=true;
                        article.channelid=self.channelid;
                        
                        
                        [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
                    }
                }];
            }
        }
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.currentChannel.type isEqualToString:@"Articles"])
    {
        if ([self.articleListArray count] == 0) {
            return 1; // a single cell to report no data
        }
        else{
            return [self.articleListArray count];
        }
    }
    else if ([self.currentChannel.type isEqualToString:@"Blog"])
    {
        if ([self.blogListArray count] == 0) {
            return 1; // a single cell to report no data
        }
        else{
            return [self.blogListArray count];
        }
    }
    else if ([self.currentChannel.type isEqualToString:@"Video"])
    {
        if ([self.videoListArray count] == 0) {
            return 1; // a single cell to report no data
        }
        else{
            return [self.videoListArray count];
        }
    }
    else if([self.articleListArray count]>0)
    {
        return [self.articleListArray count];
    }
    else if([self.blogListArray count]>0)
    {
        return [self.blogListArray count];
    }
    else if([self.videoListArray count]>0)
    {
        return [self.videoListArray count];
    }
    else if([self.dashboardList count] > 0 && self.isCategory){
        return [self.dashboardList count];
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellReadingList";
    Globals *sharedManager=[Globals sharedManager];
    CellArticle *cell;
    if (indexPath.row==0) {
        cell=[self.tableView dequeueReusableCellWithIdentifier:@"zeroCell" forIndexPath:indexPath];
    }
    else
    {
        cell =[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if (cell == nil && tableView != self.tableView) {
        if (indexPath.row==0) {
            cell =[[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zeroCell"];
        }
        else{
            cell =[[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
    }
    cell.canAnimate=true;
    [cell.videoIcon setHidden:YES];
    [cell.btnDigitalEnterprise setTitleColor:THEME_TAG_COLOR forState:UIControlStateNormal ];
    // Setting up the Values to the cell
    if([self.currentChannel.type isEqualToString:@"Articles"] || [self.articleListArray count] > 0)
    {
        [cell.videoIcon setHidden:YES];
        if ([self.articleListArray count] == 0) {
            // If there are no articles to display than we set default text
            [cell.txtTitle setText:@"No Articles Found"];
            [cell.txtDesc setText:@"There are no articles available for this channel"];
            [cell.imgContent setImage:[UIImage imageNamed:@"placeholder"]];
        }
        else{
            // Setting up the Values to the cell if there are articles available
            Articles *tmpArticle=[self.articleListArray objectAtIndex:indexPath.row];
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
                for(int i=0; i<[sharedManager.topicsArray count]; i++)
                {
                    Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
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
                            // [cell.categoryView addSubview:btn];
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
        
    }
    else if ([self.currentChannel.type isEqualToString:@"Blog"] || [self.blogListArray count] > 0)
    {
        [cell.videoIcon setHidden:YES];
        if ([self.blogListArray count] == 0) {
            // If there are no articles to display than we set default text
            [cell.txtTitle setText:@"No Blogs Found"];
            [cell.txtDesc setText:@"There are no blogs available for this channel"];
            [cell.imgContent setImage:[UIImage imageNamed:@"placeholder"]];
        }
        else{
            // Setting up the Values to the cell if there are articles available
            Blogs *tmpBlog=[self.blogListArray objectAtIndex:indexPath.row];
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
            CGRect frame=CGRectMake(5, 5, 50, 23);
            for(UIView *subview in cell.contentView.subviews)
            {
                if([subview isKindOfClass: [CategoryButtons class]])
                {
                    [subview removeFromSuperview];
                }
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
                for(int i=0; i<[sharedManager.topicsArray count]; i++)
                {
                    Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
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
                            //[cell.categoryView addSubview:btn];
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
    }
    else if ([self.currentChannel.type isEqualToString:@"Video"] || [self.videoListArray count] > 0)
    {
        [cell.videoIcon setHidden:NO];
        if ([self.videoListArray count] == 0) {
            // If there are no articles to display than we set default text
            [cell.txtTitle setText:@"No Video Found"];
            [cell.txtDesc setText:@"There are no video available for this channel"];
            [cell.imgContent setImage:nil];
        }
        else{
            // Setting up the Values to the cell if there are articles available
            Video *tmpVideo=[self.videoListArray objectAtIndex:indexPath.row];
            [cell.txtTitle setText:tmpVideo.title];
            [cell.txtDesc setText:tmpVideo.summary];
            
            NSString *youtubeId=[Globals extractYoutubeID:tmpVideo.videoUri];
            if (youtubeId) {
                //
                self.playerView=[[YTPlayerView alloc] initWithFrame:cell.imgContent.frame];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (indexPath.row==0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *strImageUrl = [NSString stringWithFormat:@"%@",[tmpVideo.imageUrls valueForKey:@"thumbnail"]];
                            if([sharedManager isNotNull:strImageUrl] && !([strImageUrl isEqualToString:@"http://admin.staging.TestSqliteToReplaceContento.mobi/api//images/icons/imageplaceholder.png"]))
                            {
                                [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                            }
                            
                            else
                                [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://img.youtube.com/vi/%@/1.jpg",youtubeId ] ]  placeholderImage:nil options:SDWebImageRefreshCached];
                        });
                        
                        
                    }
                    
                });
            }
            else{
                if (indexPath.row==0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
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
                    dispatch_async(dispatch_get_main_queue(), ^{
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
            CGRect frame=CGRectMake(5, 5, 50, 23);
            for(UIView *subview in cell.contentView.subviews)
            {
                if([subview isKindOfClass: [CategoryButtons class]])
                {
                    [subview removeFromSuperview];
                }
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
                for(int i=0; i<[sharedManager.topicsArray count]; i++)
                {
                    Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
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
    else if([self.dashboardList count] > 0 && self.isCategory)
    {
        [cell.videoIcon setHidden:YES];
        if ([self.dashboardList count] == 0) {
            // If there are no articles to display than we set default text
            [cell.txtTitle setText:@"No Content Found"];
            [cell.txtDesc setText:@"There are no content available for this Category"];
            [cell.imgContent setImage:nil];
        }
        else{
            if ([[[self.dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Articles"]) {
                // For Articles
                
                // Setting up the Values to the cell if there are articles available
                Articles *tmpArticle=[[self.dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                [cell.txtTitle setText:tmpArticle.title];
                [cell.txtDesc setText:tmpArticle.summary];
                if (indexPath.row==0) {
                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[tmpArticle.imageUrls valueForKey:@"tabletHero"]]
                                       placeholderImage:nil];
                }
                else{
                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[tmpArticle.imageUrls valueForKey:@"thumbnail"]]
                                       placeholderImage:nil];
                }
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
                    for(int i=0; i<[sharedManager.topicsArray count]; i++)
                    {
                        Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
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
            else if ([[[self.dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Blog"]) {
                // For Blogs
                Blogs *tmpBlog=[[self.dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                [cell.txtTitle setText:tmpBlog.title];
                [cell.txtDesc setText:tmpBlog.summary];
                if (indexPath.row==0) {
                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:tmpBlog.heroImage]
                                       placeholderImage:nil];
                }
                else{
                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:tmpBlog.heroImage]
                                       placeholderImage:nil];
                }
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
                    for(int i=0; i<[sharedManager.topicsArray count]; i++)
                    {
                        Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
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
            else if ([[[self.dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Video"]) {
                [cell.videoIcon setHidden:NO];
                // For Blogs
                Video *tmpVideo=[[self.dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
                [cell.txtTitle setText:tmpVideo.title];
                [cell.txtDesc setText:tmpVideo.summary];
                NSString *youtubeId=[Globals extractYoutubeID:tmpVideo.videoUri];
                if (youtubeId) {
                    //
                    self.playerView=[[YTPlayerView alloc] initWithFrame:cell.imgContent.frame];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://img.youtube.com/vi/%@/1.jpg",youtubeId ] ]
                                           placeholderImage:nil];
                    });
                }
                else{
                    if (indexPath.row==0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:tmpVideo.heroImage]
                                               placeholderImage:nil];
                        });
                        
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:tmpVideo.heroImage]
                                               placeholderImage:nil];
                        });
                        
                    }
                }
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
                // Changes to be made
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
                    for(int i=0; i<[sharedManager.topicsArray count]; i++)
                    {
                        Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
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
    }
    else{
        [cell.videoIcon setHidden:YES];
        // If there are no articles to display than we set default text
        [cell.txtTitle setText:@"No Data Found"];
        [cell.txtDesc setText:@"There are no content available for this channel"];
        [self.totalArticles setText:[NSString stringWithFormat:@"     %lu Data",(unsigned long)0]];
        [cell.imgContent setImage:[UIImage imageNamed:@"placeholder"]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
//OLD
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.articleListArray count] == 0 && [self.blogListArray count] == 0 && [self.videoListArray count] == 0 && [self.dashboardList count] == 0 ) {
        return 140;
    }
    else if(indexPath.row==0)
    {
        if ([self.videoListArray count]>0) {
            return 341;
        }
        return 341;
    }
    else{
        CellArticle *cell = (CellArticle *)[tableView dequeueReusableCellWithIdentifier:@"CellReadingList"];
        
        Articles *tmpArticle=[self.articleListArray objectAtIndex:indexPath.row];
        [cell.txtTitle setText:tmpArticle.title];
        [cell.txtDesc setText:tmpArticle.summary];
        CGRect frame=cell.categoryView.frame;
        
        frame.size.height=40 * ([tmpArticle.meta.category count] /2 );
        cell.categoryView.frame=frame;
        [self performSelectorOnMainThread:@selector(calculaeHeightForTableViewCell:) withObject:cell waitUntilDone:YES];
        Articles *tempArticle;
        Blogs *tempBlog;
        Video *tempVideo;
        if( self.isCategory && [self.dashboardList count] > 0)
        {
            
            NSDictionary *dic=[self.dashboardList objectAtIndex:indexPath.row];
            if ([[dic valueForKey:@"type"] isEqualToString:@"Articles"]) {
                tempArticle=[dic objectForKey:@"data"];
                if (tempArticle.isCategoryPresent) {
                    return 160;
                }
                else{
                    return 140;
                }
            }
            else if ([[dic valueForKey:@"type"] isEqualToString:@"Blog"])
            {
                tempBlog=[dic objectForKey:@"data"];
                if (tempBlog.isCategoryPresent) {
                    return 160;
                }
                else{
                    return 140;
                }
            }
            else if ([[dic valueForKey:@"type"] isEqualToString:@"Video"])
            {
                tempVideo=[dic objectForKey:@"data"];
                if (tempVideo.isCategoryPresent) {
                    return 160;
                }
                else{
                    return 140;
                }
            }
            return 140;
        }
        else if ([self.articleListArray count] != 0) {
            tempArticle=[self.articleListArray objectAtIndex:indexPath.row];
            if (tempArticle.isCategoryPresent) {
                return 160;
            }
            else{
                return 140;
            }
        }
        else if ([self.blogListArray count] != 0) {
            tempBlog=[self.blogListArray objectAtIndex:indexPath.row];
            if (tempBlog.isCategoryPresent) {
                return 160;
            }
            else{
                return 140;
            }
        }
        else if ([self.videoListArray count] != 0) {
            tempVideo=[self.videoListArray objectAtIndex:indexPath.row];
            if (tempVideo.isCategoryPresent) {
                return 160;
            }
            else{
                return 140;
            }
        }
        else{
            return 140;
        }
        //return sizes;
    }
}

//New
-(void)calculaeHeightForTableViewCell:(CellArticle *)sizingCell{
    
    CGFloat tmpheight=[self heightNeededForText:sizingCell.txtDesc.text withFont:[UIFont fontWithName:@"Lato-Bold" size:12.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping] + [self heightNeededForText:sizingCell.txtTitle.text withFont:[UIFont fontWithName:@"Lato-Regular" size:18.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
    tmpheight=tmpheight + sizingCell.categoryView.frame.size.height;
    CGFloat tmph=MAX(tmpheight, 140);
    
    CGSize size = CGSizeMake(sizingCell.frame.size.width, tmph);
//    NSLog(@"%f",size.height);
    int padding = 20.0;
    if (tmpheight >= 70 && tmpheight < 500) {
        sizes= size.height + padding + 30;
    }
    else{
        sizes= size.height + padding;
    }
    sizes=size.height;
    
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

- (CGFloat)heightNeededForText:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                  attributes:@{ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle }
                                     context:nil].size;
    
    return ceilf(size.height);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.articleListArray count] != 0 || [self.blogListArray count] != 0 ) {
        
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
        if ([self.currentChannel.type isEqualToString:@"Articles"] || [self.articleListArray count] > 0) {
            Articles *currentArticle=[self.articleListArray objectAtIndex:indexPath.row];
            article.currentArticle =currentArticle;
        }
        else if ([self.currentChannel.type isEqualToString:@"Blog"] || [self.blogListArray count] > 0) {
            Blogs *currentBlog=[self.blogListArray objectAtIndex:indexPath.row];
            article.currentBlog = currentBlog;
        }
        
        Globals *sharedManager;
        sharedManager=[Globals sharedManager];
        [sharedManager showLoaderIn:self.view];
        
        [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
    }
    else if ([self.videoListArray count]!=0)
    {
        Video *currentVideo=[self.videoListArray objectAtIndex:indexPath.row]  ;
        NSString *youtubeId=[Globals extractYoutubeID:currentVideo.videoUri];
        if (youtubeId) {
            //
            
            self.playerView=[[YTPlayerView alloc] initWithFrame:self.view.frame];
            NSDictionary *param=[[NSDictionary alloc] initWithObjects:@[@"0"] forKeys:@[@"showinfo"]];
            [self.playerView loadWithVideoId:youtubeId playerVars:param];
            
            [self.view addSubview:self.playerView];
            [self.playerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
            self.playerView.delegate=self;
            Globals *sharedManager=[Globals sharedManager];
            [sharedManager showLoader];
            [self.playerView playVideo];
            sharedManager.isVideoPlaying=true;
            
        }
        else{
            [Globals ShowAlertWithTitle:@"TestSqliteToReplaceContento" Message:@"Video cannot be played at this time."];
            return;
            //            NSURL *movieURL = [NSURL URLWithString:currentVideo.videoUri];
            //            MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
            //            [self presentMoviePlayerViewControllerAnimated:movieController];
            //            [movieController.moviePlayer play];
        }
        return;
        
    }
    else if(self.isCategory && [self.dashboardList count]!=0){
        if ([[[self.dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Articles"])
        {
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
            
            Articles *currentArticle=[[self.dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
            article.currentArticle =currentArticle;
            
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager showLoaderIn:self.view];
            
            [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
        }
        else if ([[[self.dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Blog"])
        {
            
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
            
            Blogs *currentBlog=[[self.dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"];
            article.currentBlog = currentBlog;
            
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager showLoaderIn:self.view];
            
            
            [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
        }
        else if ([[[self.dashboardList objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Video"])
        {
            
            Video *currentVideo=[[self.dashboardList objectAtIndex:indexPath.row] objectForKey:@"data"]  ;
            NSString *youtubeId=[Globals extractYoutubeID:currentVideo.videoUri];
            if (youtubeId) {
                //
                
                self.playerView=[[YTPlayerView alloc] initWithFrame:self.view.frame];
                NSDictionary *param=[[NSDictionary alloc] initWithObjects:@[@"0"] forKeys:@[@"showinfo"]];
                [self.playerView loadWithVideoId:youtubeId playerVars:param];
                
                [self.view addSubview:self.playerView];
                [self.playerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                self.playerView.delegate=self;
                Globals *sharedManager=[Globals sharedManager];
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
    }
}
// For animation in UITableView Cell
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.canAnimate && indexPath.row!=0) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.9;
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
        [UIView setAnimationDuration:1.8];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    }
    
    if (indexPath.row==([self.articleListArray count] -1)) {
        self.canAnimate=false;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    if (state==kYTPlayerStateEnded) {
        [playerView removeFromSuperview];
        Globals *sharedManager=[Globals sharedManager];
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
    Globals *sharedManager=[Globals sharedManager];
    [sharedManager hideLoader];
    [playerView playVideo];
}

-(void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    Globals *sharedManager=[Globals sharedManager];
    [sharedManager hideLoader];
    sharedManager.isVideoPlaying=false;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}
-(void) getArticles:(NSString *)channelId{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    
    // Initializing Variables
    self.articleListArrayForCategory=[[NSMutableArray alloc] init];
    
    // Getting List of Articles for particular channels
    [sharedManager.sync getArticlesForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        self.articleListArrayForCategory=[result mutableCopy];
    }];
    
}
-(void)getVideos:(NSString *)channelId{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    
    // Initializing Variables
    self.videoListArrayForCategory=[[NSMutableArray alloc] init];
    
    // Getting List of Articles for particular channels
    [sharedManager.sync getVideosForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        self.videoListArrayForCategory=[result mutableCopy];
        [sharedManager hideLoader];
    }];
    
}
-(void) getBlogs:(NSString *)channelId{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    
    // Initializing Variables
    self.blogListArrayForCategory=[[NSMutableArray alloc] init];
    
    // Getting List of Articles for particular channels
    
    [sharedManager.sync getBlogsForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        self.blogListArrayForCategory=[result mutableCopy];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(Topics *) getTopicWithUUDI:(NSString *)topicId{
    Globals *sharedManager=[Globals sharedManager];
    for(int i=0; i<[sharedManager.topicsArray count]; i++)
    {
        if ([[[sharedManager.topicsArray objectAtIndex:i] uuid] isEqualToString:topicId]) {
            return [sharedManager.topicsArray objectAtIndex:i];
        }
    }
    return nil;
}
-(IBAction)backbtn:(id)sender{
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
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
