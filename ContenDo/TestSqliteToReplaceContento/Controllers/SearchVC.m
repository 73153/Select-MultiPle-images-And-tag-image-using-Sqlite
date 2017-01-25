//
//  SearchVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 09/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "SearchVC.h"

@interface SearchVC ()

@end

@implementation SearchVC

@synthesize isSearch,isPreparedToPlay,currentPlaybackRate,currentPlaybackTime;
-(void)viewWillAppear:(BOOL)animated{
    
    [self.noData setHidden:YES];
    [super viewWillAppear:animated];
    searchBar.delegate = self;
    
    [searchBar setBackgroundImage:[UIImage new]];
    searchBar.tintColor  = [UIColor blackColor];
    searchBar.barTintColor = [UIColor blackColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor whiteColor]];
    [self.searchDisplayController setActive:NO];
    [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager showLoader];
    
    [self.btnMenu addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.btnHMenu addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [SlideNavigationController sharedInstance].enableShadow = false;
    [self initVC];
    sharedManager.articlecount=(int)[[sharedManager.db selectAllQueryWithTableName:@"articles"] count];
    // Checking for cached data
    if([commonArray count] == 0)
    {
        
        // Getting List of Articles for particular channels
        articleListArray=[Articles parseArrayToObjectsWithArray:[sharedManager.db selectWhereQueryWithTableName:@"articles" andORDERBYString:@"order by id desc"]];
        
        // Converting Articles to comman array
        for (int i=0; i<[articleListArray count]; i++) {
            NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[articleListArray objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
            [commonArray addObject:dic];
        }
        
        
        // Getting List of Blogs for particular channels
        blogListArray=[Blogs parseArrayToObjectsWithArray:[sharedManager.db selectWhereQueryWithTableName:@"blogs" andORDERBYString:@"order by id desc"]];
        
        // Converting Blogs to common array
        for (int i=0; i<[blogListArray count]; i++) {
            NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[blogListArray objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
            [commonArray addObject:dic];
        }
        
        
        
        // Getting List of Videos for particular channels
        videoListArray=[Video parseArrayToObjectsWithArray:[sharedManager.db selectWhereQueryWithTableName:@"videos" andORDERBYString:@"order by id desc"]];
        
        // Converting Video to common array
        for (int i=0; i<[videoListArray count]; i++) {
            NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[videoListArray objectAtIndex:i],@"Video"] forKeys:@[@"data",@"type"]];
            [commonArray addObject:dic];
        }
        
        [tblView reloadData];
        [sharedManager hideLoader];
        
        
    }
    else{
        [tblView reloadData];
        [tblView scrollsToTop];
        [sharedManager hideLoader];
    }
    
    [sharedManager.sync getAllReadingListWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        if(status==1)
        {
            sharedManager.readingListArray=[result mutableCopy];
        }
        else{
            [Globals ShowAlertWithTitle:@"Error" Message:str];
        }
    }];
    
    if (self.searchstr) {
        self.searchDisplayController.active = YES;
        [self.searchDisplayController setActive:YES animated:YES];
        [searchBar setText:self.searchstr];
        [self.searchDisplayController.searchBar becomeFirstResponder];
        [self.searchDisplayController.searchBar setText:self.searchstr];
        [self.searchDisplayController.searchResultsTableView reloadData];
        self.searchDisplayController.searchResultsTableView.rowHeight = UITableViewAutomaticDimension ;
        [searchBar becomeFirstResponder];
        [self filterContentForSearchText:self.searchstr
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                         selectedScopeButtonIndex]]];
        
        [tblView reloadData];
        [self.noData setHidden:YES];
        [self.searchDisplayController.searchBar setFrame:CGRectMake(self.searchDisplayController.searchBar.frame.origin.x, self.searchDisplayController.searchBar.frame.origin.y, self.searchDisplayController.searchBar.frame.size.width-32, self.searchDisplayController.searchBar.frame.size.height)];

        
    }
    else{
        [self.searchDisplayController setActive:NO];
        [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
    }
}
- (void)searchDisplayController:(UISearchDisplayController *)controller
 willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setRowHeight:[tblView rowHeight]];
    [self.searchResults setText:[NSString stringWithFormat:@"%lu Results",(unsigned long)[searchResultsAry count] ]];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self manageActivity];
    [headerView setBackgroundColor:THEME_INNER_BG_COLOR];
    // Do any additional setup after loading the view.
}

-(void) initVC{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [app setMenu];
    [self.searchDisplayController.searchResultsTableView registerClass:[CellArticle class]
                                                forCellReuseIdentifier:@"cellArticle"];
    tmpView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [tmpView setBackgroundColor:[UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:206.0f/255.0f alpha:1 ] ];
    [self.view addSubview:tmpView];
    [tmpView setHidden:YES];
    tblView.sectionIndexBackgroundColor=[UIColor clearColor];
    [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(0, 0, tblView.frame.size.width, tblView.frame.size.height)];
    tblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    searchResultsAry=MArray;
    commonArray=MArray;
    videoListArray=MArray;
    blogListArray=MArray;
    searchBar.frame=CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, self.view.frame.size.width, 44);
    canAnimate=true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closedFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
    
}
-(void)closedFullScreen{
    [self.playerView removeFromSuperview];
}
-(void)manageActivity{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSDate *now = [NSDate date];
    NSString* myString = [dateFormat stringFromDate:now];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjects:@[self.searchstr,@"search",myString] forKeys:@[@"title",@"logType",@"timestamp"]];
    
    Activities *activity=[[Activities alloc] init];
    [activity saveActivity:dic withCompletion:^(NSDictionary *result, NSString *str, int status) {
        if (status==1) {
            //
        }
    }];
}
-(IBAction)searchClicked
{
    [searchBar setHidden:NO];
    [btnSearch setHidden:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ( isSearch) {
        [self.searchResults setText:[NSString stringWithFormat:@"%lu Results",(unsigned long)[searchResultsAry count] ]];
        return [searchResultsAry count];
        
    }
    else{
        [self.searchResults setText:[NSString stringWithFormat:@"%lu Results",(unsigned long)[commonArray count] ]];
        return [commonArray count];
    }
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block CellArticle *cell;
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(concurrentQueue, ^{
        static NSString *CellIdentifier = @"cellArticle";
        
        if (indexPath.row==0) {
            cell=[tblView dequeueReusableCellWithIdentifier:@"cellArticle" forIndexPath:indexPath];
        }
        else
        {
            cell =[tblView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (cell == nil) {
            if (indexPath.row==0) {
                cell =[[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellArticle"];
            }
            else{
                cell =[[CellArticle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellArticle"] ;
            }
        }
        [cell.btnDigitalEnterprise setTitleColor:THEME_TAG_COLOR forState:UIControlStateNormal ];
        if ([commonArray count] == 0) {
            // If there are no articles to display than we set default text
            [cell.txtTitle setText:@"No Content Found"];
            [cell.txtDesc setText:@"There are no content available for this channel"];
            [cell.imgContent setImage:[UIImage imageNamed:@"placeholder"]];
            [cell.videoIcon setHidden:YES];
        }
        else if ([searchResultsAry count] == 0 && isSearch) {
            // If there are no articles to display than we set default text
            [cell.txtTitle setText:@"No Articles Found"];
            [cell.txtDesc setText:@"There are no articles available for this channel"];
            [cell.imgContent setImage:[UIImage imageNamed:@"placeholder"]];
            [cell.videoIcon setHidden:YES];
        }
        else{
            // Setting up the Values to the cell if there are articles available
            [cell.videoIcon setHidden:YES];
            
            Articles *tmpArticle;
            Blogs *tmpBlog;
            Video *tmpVideo;
            NSDictionary *tmpDic;
            
            if(!isSearch)
            {
                tmpDic=[commonArray objectAtIndex:indexPath.row];
                
            }
            else{
                tmpDic=[searchResultsAry objectAtIndex:indexPath.row];
            }
            if ([[tmpDic valueForKey:@"type"] isEqualToString:@"Articles"]) {
                tmpArticle=[tmpDic objectForKey:@"data"];;
                
                [cell.txtTitle setText:tmpArticle.title];
                [cell.txtDesc setText:tmpArticle.summary];
                [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[tmpArticle.imageUrls valueForKey:@"thumbnail"]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
                
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
                int heightForCategory=23;
                Globals *sharedManager=[Globals sharedManager];
                tmpArticle.isCategoryPresent=false;
                if ([self getTopicWithUUDI:tmpArticle.topicId]) {
                    Topics *highlightedTopic=[self getTopicWithUUDI:tmpArticle.topicId];
                    [cell.btnDigitalEnterprise setTitle:[highlightedTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                    tmpArticle.isCategoryPresent=true;
                    cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                    tmpArticle.currentTopic=highlightedTopic;
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
                cell.heightForCategory=heightForCategory;
                
                
            }
            else if ([[tmpDic valueForKey:@"type"] isEqualToString:@"Blog"]) {
                tmpBlog=[tmpDic objectForKey:@"data"];
                [cell.txtTitle setText:tmpBlog.title];
                [cell.txtDesc setText:tmpBlog.summary];
                
                [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:tmpBlog.heroImage]
                                   placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
                
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
                int heightForCategory=23;
                Globals *sharedManager=[Globals sharedManager];
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
                cell.heightForCategory=heightForCategory;
                
                
            }
            else if ([[tmpDic valueForKey:@"type"] isEqualToString:@"Video"]) {
                tmpVideo=[tmpDic objectForKey:@"data"];
                [cell.videoIcon setHidden:NO];
                [cell.txtTitle setText:tmpVideo.title];
                [cell.txtDesc setText:tmpVideo.summary];
                NSString *youtubeId=[Globals extractYoutubeID:tmpVideo.videoUri];
                if (youtubeId) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://img.youtube.com/vi/%@/1.jpg",youtubeId ] ] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
                        
                    });
                }
                else{
                    [cell.imgContent sd_setImageWithURL:[NSURL URLWithString:tmpVideo.heroImage]
                                       placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRefreshCached];
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
                int heightForCategory=23;
                Globals *sharedManager=[Globals sharedManager];
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
                cell.heightForCategory=heightForCategory;
                
            }
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    });
    return cell;
    
}
-(void) redirectToCategory:(id)btn{
    Globals *sharedManager;
    UIButton *tmpBtn=(UIButton *)btn;
    NSDictionary *dic;
    if (isSearch) {
        dic=[searchResultsAry objectAtIndex:tmpBtn.tag-1000];
    }
    else{
        dic=[commonArray objectAtIndex:tmpBtn.tag-1000];
    }
    
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
    sharedManager=[Globals sharedManager];
    
    [sharedManager showLoader];
    NSMutableArray *dashboardList=MArray;
    
    // Looping for Topic New Logic
    [sharedManager.sync getChannelsForUDIDs:@[channelId] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
        
        if ([result count]>0) {
            
            
            Channels *ch1=(Channels *)[result objectAtIndex:0];
            
            if ([[ch1 type] isEqualToString:@"Articles"]) {
                articleListArray = MArray;
                articleListArray = [[sharedManager getArticles:ch1.uuid] mutableCopy];
                
                for(int k=0; k<[articleListArray count]; k++)
                {
                    
                    if ([[[articleListArray objectAtIndex:k] topicId] isEqualToString:topicId]) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[articleListArray objectAtIndex:k],@"Articles"] forKeys:@[@"data",@"type"]];
                        [dashboardList addObject:dic];
                    }
                    
                }
            }
            else if ([[ch1 type] isEqualToString:@"Blog"]) {
                blogListArray = MArray;
                blogListArray = [[sharedManager getBlogs:ch1.uuid] mutableCopy];
                
                
                for(int k=0; k<[blogListArray count]; k++)
                {
                    
                    if ([[[blogListArray objectAtIndex:k] topicId] isEqualToString:topicId]) {
                        
                        
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[blogListArray objectAtIndex:k],@"Blog"] forKeys:@[@"data",@"type"]];
                        [dashboardList addObject:dic];
                        
                    }
                    
                }
                
            }
            else if ([[ch1 type] isEqualToString:@"Video"]) {
                videoListArray=[[NSMutableArray alloc] init];
                videoListArray = [[sharedManager getVideos:ch1.uuid] mutableCopy];
                for(int k=0; k<[videoListArray count]; k++)
                {
                    
                    if ([[[videoListArray objectAtIndex:k] topicId] isEqualToString:topicId]) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[videoListArray objectAtIndex:k],@"Video"] forKeys:@[@"data",@"type"]];
                        [dashboardList addObject:dic];
                        
                    }
                }
            }
        }
    }];

    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
//    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    article.dashboardList=[dashboardList mutableCopy];
    article.isCategory=YES;
    article.titleScreen=[tempTopic topicname];
    [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
    
    
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.noData setHidden:YES];
    
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView{
    [tableView setFrame:CGRectMake(0, 40, tblView.frame.size.width, tblView.frame.size.height)];
    
    
}
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    @try{
        NSString *strSearchName =searchController.searchBar.text;
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(concurrentQueue, ^{
            if ([strSearchName isEqualToString:@""] ) {
                isSearch = NO;
            }
            else {
                isSearch = YES;
                
                
                
                [Articles filterArrayUsingString:strSearchName WithCompletion:^(NSArray *result, NSString *str, int status) {
                    //
                    isSearch=true;
                    
                    for (int i=0; i<[result count]; i++) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                        [searchResultsAry addObject:dic];
                    }
                    
                    
                }];
                [Blogs filterArrayUsingString:strSearchName WithCompletion:^(NSArray *result, NSString *str, int status) {
                    //
                    isSearch=true;
                    for (int i=0; i<[result count]; i++) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                        [searchResultsAry addObject:dic];
                    }
                    
                    
                }];
                [Video filterArrayUsingString:strSearchName WithCompletion:^(NSArray *result, NSString *str, int status) {
                    //
                    isSearch=true;
                    for (int i=0; i<[result count]; i++) {
                        NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result objectAtIndex:i],@"Video"] forKeys:@[@"data",@"type"]];
                        [searchResultsAry addObject:dic];
                    }
                    
                    
                }];
                [self.searchDisplayController.searchResultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [self.searchDisplayController.searchResultsTableView reloadData];
                
                [tblView reloadData];
                [self.searchDisplayController.searchResultsTableView beginUpdates];
                [self.searchDisplayController.searchResultsTableView endUpdates];
                [self.searchResults setText:[NSString stringWithFormat:@"%lu Results",(unsigned long)[searchResultsAry count] ]];
                
                if([searchResultsAry count]==0 && self.searchstr)
                {
                    [self.noData setHidden:NO];
                }
                else{
                    [self.noData setHidden:YES];
                }
                
            }
        });
    } @catch (NSException *exception) {
        
    }
    @finally {
    }
}
-(IBAction)btnMenuClicked:(id)sender
{
    //
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [self.searchDisplayController.searchResultsTableView beginUpdates];
    
    [self.searchDisplayController.searchResultsTableView endUpdates];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([commonArray count] == 0) {
        return 140;
    }
    else{
        CellArticle *cell = (CellArticle *)[tableView dequeueReusableCellWithIdentifier:@"cellArticle"];
        Articles *tmpArticle,*tmpBlog, *tmpVideo;
        NSDictionary *tmpDic=[[NSDictionary alloc] init];
        if (!isSearch) {
            tmpDic=[commonArray objectAtIndex:indexPath.row];
        }
        else{
            if (searchResultsAry > 0) {
                tmpDic=[searchResultsAry objectAtIndex:indexPath.row];
            }
            
        }
        if ([[tmpDic valueForKey:@"type"] isEqualToString:@"Articles"]) {
            tmpArticle=[tmpDic objectForKey:@"data"];
            [cell.txtTitle setText:tmpArticle.title];
            [cell.txtDesc setText:tmpArticle.summary];
            CGRect frame=cell.categoryView.frame;
            if ([tmpArticle.meta.category count] > 2) {
                frame.size.height=23 * ([tmpArticle.meta.category count] /2 );
            }
            frame.size.height=23;
            cell.categoryView.frame=frame;
        }
        else if ([[tmpDic valueForKey:@"type"] isEqualToString:@"Blog"]) {
            tmpBlog=[tmpDic objectForKey:@"data"];
            [cell.txtTitle setText:tmpBlog.title];
            [cell.txtDesc setText:tmpBlog.summary];
            CGRect frame=cell.categoryView.frame;
            if ([tmpBlog.meta.category count] > 2) {
                frame.size.height=23 * ([tmpBlog.meta.category count] /2 );
            }
            frame.size.height=23;
            cell.categoryView.frame=frame;
        }
        else if ([[tmpDic valueForKey:@"type"] isEqualToString:@"Video"]) {
            tmpVideo=[tmpDic objectForKey:@"data"];
            [cell.txtTitle setText:tmpVideo.title];
            [cell.txtDesc setText:tmpVideo.summary];
            CGRect frame=cell.categoryView.frame;
            if ([tmpVideo.meta.category count] > 2) {
                frame.size.height=23 * ([tmpBlog.meta.category count] /2 );
            }
            frame.size.height=23;
            cell.categoryView.frame=frame;
        }
        
        
        
        [self performSelectorOnMainThread:@selector(calculaeHeightForTableViewCell:) withObject:cell waitUntilDone:YES];
        if( tmpArticle.isCategoryPresent || tmpBlog.isCategoryPresent || tmpVideo.isCategoryPresent)
        {
            return 155;
        }
        else{
            return 140;
        }
        
    }
}
-(void)calculaeHeightForTableViewCell:(CellArticle *)sizingCell{
    
    CGFloat tmpheight=[self heightNeededForText:sizingCell.txtDesc.text withFont:[UIFont fontWithName:@"Lato-Bold" size:12.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping] + [self heightNeededForText:sizingCell.txtTitle.text withFont:[UIFont fontWithName:@"Lato-Regular" size:18.0] width:sizingCell.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
    tmpheight=tmpheight + sizingCell.categoryView.frame.size.height;
    CGFloat tmph=MAX(tmpheight, 140);
    
    CGSize size = CGSizeMake(sizingCell.frame.size.width, tmph);
    int padding = 20.0;
    if (isSearch) {
        sizes= size.height + padding + 30;
    }
    else{
        sizes= size.height + padding;
    }
    sizes= size.height +10;
    
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
    if ( isSearch) {
        if ([searchResultsAry count] != 0) {
            NSDictionary *dic;
            dic=[searchResultsAry objectAtIndex:indexPath.row];
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
            if ([[dic valueForKey:@"type"] isEqualToString:@"Articles"]) {
                article.currentArticle =[dic objectForKey:@"data"];
            }
            else if ([[dic valueForKey:@"type"] isEqualToString:@"Blog"]) {
                article.currentBlog =[dic objectForKey:@"data"];
            }
            else if ([[dic valueForKey:@"type"] isEqualToString:@"Video"])
            {
                Video *currentVideo=[dic  objectForKey:@"data"];
                NSString *youtubeId=[Globals extractYoutubeID:currentVideo.videoUri];
                if (youtubeId) {
                    //
                    
                    self.playerView=[[YTPlayerView alloc] initWithFrame:self.view.frame];
                    NSDictionary *param=[[NSDictionary alloc] initWithObjects:@[@"0"] forKeys:@[@"showinfo"]];
                    [self.playerView loadWithVideoId:youtubeId playerVars:param];
                    [self.playerView playVideo];
                    [self.view addSubview:self.playerView];
                    [self.playerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                    self.playerView.delegate=self;
                    Globals *sharedManager=[Globals sharedManager];
                    [sharedManager showLoader];
                    [self.playerView playVideo];
                    sharedManager.isVideoPlaying=true;
                    
                }
                else{
                    NSURL *movieURL = [NSURL URLWithString:currentVideo.videoUri];
                    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
                    [self presentMoviePlayerViewControllerAnimated:movieController];
                    [movieController.moviePlayer play];
                    
                }
                return;
            }
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager showLoaderIn:self.view];
            [self.searchDisplayController setActive:NO];
            [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
            [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
        }
        
    }
    else{
        if ([commonArray count] != 0) {
            NSDictionary *dic;
            dic=[commonArray objectAtIndex:indexPath.row];
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
            if ([[dic valueForKey:@"type"] isEqualToString:@"Articles"]) {
                article.currentArticle =[dic objectForKey:@"data"];
            }
            else if ([[dic valueForKey:@"type"] isEqualToString:@"Blog"]) {
                article.currentBlog =[dic objectForKey:@"data"];
            }
            else if ([[dic valueForKey:@"type"] isEqualToString:@"Video"])
            {
                Video *currentVideo=[dic  objectForKey:@"data"];
                NSString *youtubeId=[Globals extractYoutubeID:currentVideo.videoUri];
                if (youtubeId) {
                    //
                    
                    self.playerView=[[YTPlayerView alloc] initWithFrame:self.view.frame];
                    NSDictionary *param=[[NSDictionary alloc] initWithObjects:@[@"0"] forKeys:@[@"showinfo"]];
                    [self.playerView loadWithVideoId:youtubeId playerVars:param];
                    [self.playerView playVideo];
                    [self.view addSubview:self.playerView];
                    [self.playerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
                    self.playerView.delegate=self;
                    Globals *sharedManager=[Globals sharedManager];
                    [sharedManager showLoader];
                    [self.playerView playVideo];
                    sharedManager.isVideoPlaying=true;
                    
                    
                }
                else{
                    NSURL *movieURL = [NSURL URLWithString:currentVideo.videoUri];
                    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
                    [self presentMoviePlayerViewControllerAnimated:movieController];
                    [movieController.moviePlayer play];
                    
                }
                return;
            }
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager showLoaderIn:self.view];
            [self.searchDisplayController setActive:NO];
            [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
            [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
        }
    }
}
- (void)hideSearchBar {
    tblView.TestSqliteToReplaceContentoffset = CGPointMake(0, 64);
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if(![searchText isEqualToString:@""])
    {
        searchResultsAry=MArray;
        [Articles filterArrayUsingString:searchText WithCompletion:^(NSArray *result, NSString *str, int status) {
            //
            isSearch=true;
            
            for (int i=0; i<[result count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                [searchResultsAry addObject:dic];
            }
            
            
        }];
        [Blogs filterArrayUsingString:searchText WithCompletion:^(NSArray *result, NSString *str, int status) {
            //
            isSearch=true;
            for (int i=0; i<[result count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                [searchResultsAry addObject:dic];
            }
            
        }];
        [Video filterArrayUsingString:searchText WithCompletion:^(NSArray *result, NSString *str, int status) {
            //
            isSearch=true;
            for (int i=0; i<[result count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result objectAtIndex:i],@"Video"] forKeys:@[@"data",@"type"]];
                [searchResultsAry addObject:dic];
            }
            
        }];
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(concurrentQueue, ^{
            [self.searchDisplayController.searchResultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self.searchDisplayController.searchResultsTableView reloadData];
            
            [tblView reloadData];
            [self.searchDisplayController.searchResultsTableView beginUpdates];
            [self.searchDisplayController.searchResultsTableView endUpdates];
        });
        
        if([searchResultsAry count]==0 && self.searchstr)
        {
            [self.noData setHidden:NO];
        }
        else{
            [self.noData setHidden:YES];
        }
        tblView.frame = CGRectMake(0, 0, tblView.frame.size.width, self.view.frame.size.height);
        
        [self.searchDisplayController.searchResultsTableView setFrame:CGRectMake(0, 0, tblView.frame.size.width, tblView.frame.size.height)];
        
    }
    else{
        isSearch=false;
        [tblView reloadData];
        [tblView reloadInputViews];
    }
    
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearch=false;
    [self.noData setHidden:YES];
    [tblView reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [searchBar setText:self.searchstr];
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}
-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    if (state==kYTPlayerStateEnded) {
        [playerView removeFromSuperview];
        Globals *sharedManager=[Globals sharedManager];
        [sharedManager hideLoader];
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
}

-(void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error
{
    Globals *sharedManager=[Globals sharedManager];
    [sharedManager hideLoader];
    sharedManager.isVideoPlaying=false;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


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
    Globals *sharedManager=[Globals sharedManager];
    for(int i=0; i<[sharedManager.topicsArray count]; i++)
    {
        if ([[[sharedManager.topicsArray objectAtIndex:i] uuid] isEqualToString:topicId]) {
            return [sharedManager.topicsArray objectAtIndex:i];
        }
    }
    return nil;
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
