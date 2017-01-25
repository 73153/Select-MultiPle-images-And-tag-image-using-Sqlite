//
//  MenuVC.m
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 28/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "MenuVC.h"
#import "Constants.h"
#import "ArticalListVC.h"
#import "DashboardVC.h"
#import "ArticleDetailVC.h"
@implementation MenuVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initVC];
    [self hideViews];
    [self setMenu];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeMenu)
                                                 name:@"SlideNavigationControllerDidOpen"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closedMenu)
                                                 name:@"SlideNavigationControllerDidClose"
                                               object:nil];
    
    if(IS_IPAD){
        _viewFooterHeightConstant.constant=100;
        
        _btnReadingHeightConstant.constant=100;
        _btnHomeHeightConstant.constant=100;
        _btnChannelHeightConstant.constant=100;
        _btnTopicHeightConstant.constant=100;
        
        _viewReadingFooterHeightConstant.constant=100;
        _viewHomeFooterHeightConstant.constant=100;
        _viewChannelFooterHeightConstant.constant=100;
        _viewTopicFooterHeightConstant.constant=100;
    }
    else{
        _viewFooterHeightConstant.constant=62;
        _btnReadingHeightConstant.constant=62;
        _btnHomeHeightConstant.constant=62;
        _btnChannelHeightConstant.constant=62;
        _btnTopicHeightConstant.constant=62;
        _viewReadingFooterHeightConstant.constant=62;
        _viewHomeFooterHeightConstant.constant=62;
        _viewChannelFooterHeightConstant.constant=62;
        _viewTopicFooterHeightConstant.constant=62;
    }
    
    [self.btnMenu removeTarget:nil
                        action:NULL
              forControlEvents:UIControlEventAllEvents];
    [self.btnMenu addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [SlideNavigationController sharedInstance].enableShadow = false;
    
    //blur transpertn view
    [_transparentView setAlpha:0.7];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:_transparentView.bounds];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        toolBar.barTintColor = nil;
        toolBar.translucent = YES;
        toolBar.barStyle = UIBarStyleBlack;
    }
    else
        [toolBar setTintColor:[UIColor colorWithRed:5 green:31 blue:75 alpha:0.7]];
    [_transparentView insertSubview:toolBar atIndex:0];
    
    [self.whiteView setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
        //Close menu show
        [self.whiteView setHidden:NO];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
        // Open Menu hide
        [self.whiteView setHidden:YES];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.whiteView setHidden:YES];
    }];
    [self.channelBtn setImage:[UIImage imageNamed:@"channel-selected"] forState:UIControlStateNormal];
    
    
    [self.channelColorView setBackgroundColor:THEME_MENU_BG_COLOR];
    [self.topicsColorView setBackgroundColor:THEME_MENU_BG_COLOR];
    [self.readingColorView setBackgroundColor:THEME_MENU_BG_COLOR];
    [self.headerView setBackgroundColor:THEME_INNER_BG_COLOR];
    self.topicsArray=MArray;
    self.readingListArray=MArray;
    self.sectionArray=MArray;
    self.channelsArray=MArray;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchbar.showsCancelButton=YES;
    
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.btnMenu setHidden:YES];
    searchBar.frame=CGRectMake(self.btnMenu.frame.origin.x, self.searchbar.frame.origin.y, self.btnMenu.frame.size.width + self.searchbar.frame.size.width, self.searchbar.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    self.searchbar.showsCancelButton = false;
    UITextField *searchField;
    NSUInteger numViews = [_searchbar.subviews count];
    for(int i = 0; i < numViews; i++) {
        if([[_searchbar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [_searchbar.subviews objectAtIndex:i];
        }
    }
    if(!(searchField == nil)) {
        searchField.textColor = [UIColor whiteColor];
        [searchField setBackground: [UIImage imageNamed:@"yourImage"]];//just add here gray image which you display in quetion
        [searchField setBorderStyle:UITextBorderStyleNone];
    }
    
    // To change background color
    searchField.backgroundColor = [UIColor blueColor];
    
    // To change text color
    searchField.textColor = [UIColor redColor];
    
    // To change placeholder text color
    searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Some Text"];
    UILabel *placeholderLabel = [searchField valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = [UIColor grayColor];
    
    [_searchbar setBackgroundImage:[UIImage new]];
    [_searchbar setPlaceholder:@"Search"];
    
    if (_searchbar.text.length) {
        
        _searchbar.showsCancelButton=YES;
        
        
    }
    else{
        [self.searchDisplayController.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchDisplayController setActive:NO];
        [self searchBarCancelButtonClicked:self.searchDisplayController.searchBar];
    }
    [super viewWillAppear:animated];
    
    _searchbar.tintColor  = [UIColor blackColor];
    [_searchbar setPlaceholder:@"Search"];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor whiteColor]];

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    _searchbar.showsCancelButton=NO;
    [searchBar resignFirstResponder];
    
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        
    }];
    
}

-(void)initVC{
    
    self.topicsArray=nil;
    self.readingListArray=nil;
    self.sectionArray=nil;
    
    self.topicsArray=MArray;
    self.readingListArray=MArray;
    self.sectionArray=MArray;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager showLoaderIn:self.view];
    self.readingListArray=sharedManager.readingListArray;
    [self.readingTableView reloadData];
    if(sharedManager.channelArray.count>0){
        self.channelsArray = sharedManager.channelArray;
    }
    else{
        self.channelsArray=nil;
        self.channelsArray=MArray;
    }
    [self.channelTableView reloadData];
    [sharedManager.sync getMenuChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        sharedManager.isMenuOpenForActiveChannels = true;
        self.channelsArray=[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
        [self.channelTableView reloadData];
        [sharedManager hideLoader];
        
    }];
    [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
        [sharedManager hideLoader];
        self.topicsArray=MArray;
        NSMutableArray *tempTopicArray=MArray;
        tempTopicArray=UDGetObject(@"topic");
        for (int i=0; i<[result count]; i++) {
            if ([tempTopicArray containsObject:[[result objectAtIndex:i] topicname] ]) {
                [self.topicsArray addObject: [result objectAtIndex:i] ];
            }
        }
        
        self.sectionArray=MArray;
        
        for (int i=0; i<[sharedManager.channelArray count]; i++) {
            NSMutableArray *channelTopics=MArray;
            for (int j=0; j<[self.topicsArray count]; j++) {
                //
                if ([[[self.topicsArray objectAtIndex:j] channelId] containsObject:[[sharedManager.channelArray objectAtIndex:i] uuid]] )
                {
                    [channelTopics addObject:[self.topicsArray objectAtIndex:j]];
                }
            }
            if ([channelTopics count]>0) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[[sharedManager.channelArray objectAtIndex:i] label],channelTopics ,[[sharedManager.channelArray objectAtIndex:i] uuid]] forKeys:@[@"channelName",@"data",@"uuid"]];
                [self.sectionArray addObject:dic];
            }
            
        }
        
        [self.topicsTableView reloadData];
    }];
    [sharedManager.sync getAllReadingListWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        //
        [sharedManager hideLoader];
        if(status==1)
        {
            sharedManager.readingListArray = [result mutableCopy];
            self.readingListArray = [result mutableCopy];
            [self.readingTableView reloadData];
        }
    }];
    self.topicsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.readingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.channelTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.transparentView setHidden:YES];
    
    //For seperators
    self.topicsTableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.channelTableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    self.readingTableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    
    
    NSString *strFirstName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"userFirstName"];
    NSString *strLastName =  [[NSUserDefaults standardUserDefaults] valueForKey:@"userLastName"];
    
    if(sharedManager.user.firstName.length>0 || sharedManager.user.lastName.length>0){
        // Setting Logged in user details
        [self.nameChannel setText:[NSString stringWithFormat:@"%@ %@",sharedManager.user.firstName, sharedManager.user.lastName ]];
        [self.nameReadingList setText:[NSString stringWithFormat:@"%@ %@",sharedManager.user.firstName, sharedManager.user.lastName ]];
        [self.nameTopics setText:[NSString stringWithFormat:@"%@ %@",sharedManager.user.firstName, sharedManager.user.lastName ]];
        
    }
    else if(strFirstName.length>0)
    {
        [self.nameChannel setText:[NSString stringWithFormat:@"%@ %@",strFirstName,strLastName ]];
        [self.nameReadingList setText:[NSString stringWithFormat:@"%@ %@",strFirstName,strLastName ]];
        [self.nameTopics setText:[NSString stringWithFormat:@"%@ %@",strFirstName,strLastName ]];
    }
}


-(void)getLatestChannels
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    //    [sharedManager showLoader];
    if([Validations isconnectedToInternet] )
    {
        [self getChannels];
        if (refreshControl) {
            [refreshControl endRefreshing];
        }
    }
    else{
        [self.channelTableView reloadData];
        [self.channelTableView scrollsToTop];
        [sharedManager hideLoader];
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
    }
    if (refreshControl) {
        [refreshControl endRefreshing];
    }
}

-(void) getChannels{
    Globals *sharedManager=[Globals sharedManager];
    sharedManager.articlecount=(int)[[sharedManager.db selectAllQueryWithTableName:@"articles"] count];
    // Checking for cached data
    // Getting List of Articles for particular channels
    if([Validations isconnectedToInternet] )
    {
        //[sharedManager.db emptyDatabase];
        [sharedManager.sync fillChannelsWithCompletionBlock:^(NSString *str, int status) {
            //
            if(status==1)
            {
                [sharedManager.sync getMenuChannelsWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                    //
                    [sharedManager hideLoader];
                    sharedManager.channelArray=[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
                    self.channelsArray=[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
                    [self.channelTableView reloadData];
                    if (refreshControl) {
                        [refreshControl endRefreshing];
                    }
                }];
            }
            else{
                [self.channelTableView reloadData];
                [sharedManager hideLoader];
                [Globals ShowAlertWithTitle:@"Error" Message:str];
                
                if (refreshControl) {
                    [refreshControl endRefreshing];
                }
            }
        }];
    }
    else{
        [self.channelTableView reloadData];
        
        [sharedManager hideLoader];
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
    }
}
-(void)isSyncCompleted:(get_completion_block)sync
{
    Globals *sharedManager=[Globals sharedManager];
    if ([sharedManager.updatedChannelArray count] == 0) {
        if (sharedManager.channelSyncCount >= [sharedManager.channelArray count]) {
            sharedManager.channelSyncCount=0;
            //
            if(sync)
            {
                
                [sharedManager.sync getAllChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                    [sharedManager hideLoader];
                    self.channelsArray=[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
                    [self.channelTableView reloadData];
                }];
            }
        }
        
    }
    else{
        if (sharedManager.channelSyncCount >= [sharedManager.updatedChannelArray count]) {
            sharedManager.channelSyncCount=0;
            if(sync)
            {
                
                [sharedManager.sync getAllChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                    [sharedManager hideLoader];
                    self.channelsArray=[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
                    [self.channelTableView reloadData];
                }];
            }
        }
    }
}
-(void)setTabBarImages{
    
}
-(void)closeMenu
{
    [self initVC];
    [self.view endEditing:YES];
}
-(void)closedMenu
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.isMenuOpenForActiveChannels = false;
    [self.searchbar setText:@""];
    [self.view endEditing:YES];
}
-(IBAction)btnHomeClick:(id)sender
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    //    [sharedManager showLoaderIn:self.view];
    DashboardVC  *dashboard=(DashboardVC *)[story instantiateViewControllerWithIdentifier:@"DashboardVC"];
    [Globals pushNewViewController:dashboard];
    [self showViews:self.channelView];
    self.activeView=1;
    [self.channelTableView reloadData];
    [self deselectAllButton];
    [self.homeBtn setImage:[UIImage imageNamed:@"home-default"] forState:UIControlStateNormal];
    [self.channelBtn setImage:[UIImage imageNamed:@"channel-selected"] forState:UIControlStateNormal];
    
}
-(void) deselectAllButton{
    [self.homeBtn setImage:[UIImage imageNamed:@"home-default"] forState:UIControlStateNormal];
    [self.channelBtn setImage:[UIImage imageNamed:@"channel-default"] forState:UIControlStateNormal];
    [self.topicBtn setImage:[UIImage imageNamed:@"topic-default"] forState:UIControlStateNormal];
    [self.readingBtn setImage:[UIImage imageNamed:@"list-default"] forState:UIControlStateNormal];
}
-(IBAction)btnChannels:(id)sender
{
    [self showViews:self.channelView];
    self.activeView=1;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    if(self.channelsArray.count==0){
        [sharedManager.sync getMenuChannelsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
            [sharedManager hideLoader];
            self.channelsArray=[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
        }];
    }
    [self.channelTableView reloadData];
    [self deselectAllButton];
    [self.channelBtn setImage:[UIImage imageNamed:@"channel-selected"] forState:UIControlStateNormal];
}
-(IBAction)btnTopic:(id)sender
{
    [self showViews:self.topicView];
    self.activeView=2;
    [self.topicsTableView reloadData];
    [self deselectAllButton];
    [self.topicBtn setImage:[UIImage imageNamed:@"topic-selected"] forState:UIControlStateNormal];
}
-(IBAction)btnReadingList:(id)sender
{
    [self showViews:self.readingList];
    self.activeView=3;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager.sync getAllReadingListWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
        //
        [sharedManager hideLoader];
        if(status==1)
        {
            sharedManager.readingListArray = [result mutableCopy];
            self.readingListArray = [result mutableCopy];
            [self.readingTableView reloadData];
        }
    }];
    
    [self.readingTableView reloadData];
    [self deselectAllButton];
    [self.readingBtn setImage:[UIImage imageNamed:@"list-selected"] forState:UIControlStateNormal];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag)
    {
        case 0:
        {
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            //            [sharedManager showLoaderIn:self.view];
            DashboardVC  *dashboard=(DashboardVC *)[story instantiateViewControllerWithIdentifier:@"DashboardVC"];
            [Globals pushNewViewController:dashboard];
            
            [self showViews:self.channelView];
            self.activeView=1;
            [self.channelTableView reloadData];
            [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
            break;
        }
        case 1:
            [self showViews:self.channelView];
            self.activeView=1;
            [self.channelTableView reloadData];
            
            break;
        case 2:
            [self showViews:self.topicView];
            self.activeView=2;
            [self.topicsTableView reloadData];
            
            break;
        case 3:
        {
            [self showViews:self.readingList];
            self.activeView=3;
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager.sync getAllReadingListWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                //
                [sharedManager hideLoader];
                if(status==1)
                {
                    sharedManager.readingListArray = [result mutableCopy];
                    self.readingListArray = [result mutableCopy];
                    [self.readingTableView reloadData];
                }
            }];
            
            [self.readingTableView reloadData];
            
            break;
        }
    }
}
-(void)hideViews{
    [self.homeView setHidden:YES];
    [self.channelView setHidden:YES];
    [self.readingList setHidden:YES];
    [self.topicView setHidden:YES];
    
}
-(void)showViews:(UIView *)view{
    [self hideViews];
    [view setHidden:NO];
    
}
-(void) setMenu{
    self.homeArray=[[NSMutableArray alloc] initWithObjects:@"Title 1", @"Title 2", @"Title 3",@"Title 4", nil ];
    
    [self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:1]];
    self.activeView=1;
    [self deselectAllButton];
    [self.channelBtn setImage:[UIImage imageNamed:@"channel-selected"] forState:UIControlStateNormal];
    [self showViews:self.channelView];
    
}

/***** Table View Delegates **********/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(self.activeView==2)
    {
        return [self.sectionArray count];
    }
    else{
        return 1;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.activeView==2)
    {
        return [[self.sectionArray objectAtIndex:section]  valueForKey:@"channelName"];
    }
    else{
        return nil;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.activeView==0)
    {
        //Channel View
        if ([self.homeArray count] == 0) {
            return 1; // a single cell to report no data
        }
        return [self.homeArray count];
    }
    else if(self.activeView==1)
    {
        //Channel View
        if ([self.channelsArray count] == 0) {
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            return [sharedManager.channelArray count]; // a single cell to report no data
        }
        return [self.channelsArray count];
    }
    else if(self.activeView==2)
    {
        //Topics View
        //        if ([self.topicsArray count] == 0) {
        //            return 1; // a single cell to report no data
        //        }
        //        return [self.topicsArray count];
        
        // New Topics View
        if ([self.sectionArray count] == 0) {
            return 1;
        }
        return [[[self.sectionArray objectAtIndex:section] valueForKey:@"data"] count];
    }
    else if(self.activeView==3)
    {
        //Readinglist View
        if ([self.readingListArray count] == 0) {
            return 1; // a single cell to report no data
        }
        return [self.readingListArray count];
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell1) {
            //
            cell1=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        if(tableView == self.searchDisplayController.searchResultsTableView)
        {
            return cell1;
        }
        [cell1.textLabel setTextColor:THEME_MENU_COLOR];
        if(self.activeView==0)
        {
            //Home View
            
            [cell1.textLabel setText:[self.homeArray objectAtIndex:indexPath.row]];
        }
        else if(self.activeView==1)
        {
            //Channel View
            if ([self.channelsArray count] == 0) {
                // If there are no articles to display than we set default text
                [cell1.textLabel setText:ERROR_CHANNEL_NOT_FOUND];
            }
            else{
                if(self.channelsArray.count>indexPath.row){
                Channels *ch=[self.channelsArray objectAtIndex:indexPath.row];
                [cell1.textLabel setText:ch.label];
                }
            }
        }
        else if(self.activeView==2)
        {
            //Topics View
            if ([self.sectionArray count] == 0) {
                // If there are no articles to display than we set default text
                [cell1.textLabel setText:ERROR_TOPICS_NOT_FOUND];
            }
            else{
                [cell1.textLabel setText:[[[[[self.sectionArray objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row] topicname] capitalizedString]];
            }
        }
        else if(self.activeView==3)
        {
            //Reading List View
            if ([self.readingListArray count] == 0) {
                // If there are no articles to display than we set default text
                [cell1.textLabel setText:ERROR_READING_NOT_FOUND];
            }
            else{
                [cell1.textLabel setText:[[self.readingListArray objectAtIndex:indexPath.row] valueForKey:@"name"]  ];
            }
        }
        else{
            [cell1.textLabel setText:@"Title"];
        }
        [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell1;
    }
    @catch (NSException *exception) {
        //
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.activeView==0)
    {
        //Home View
        
    }
    else if(self.activeView==1)
    {
        //Channel View
        if ([self.channelsArray count] == 0) {
            // If there are no channels to display than no action to be performed
        }
        else{
            Channels *ch=[self.channelsArray objectAtIndex:indexPath.row];
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
            article.currentChannel=ch;
            article.isChannel=true;
            //[Globals pushNewViewController:article];
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager showLoaderIn:self.view];
            article.isCategory=YES;
            [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
        }
        //[sharedManager hideLoader];
    }
    else if(self.activeView==2)
    {
        //Topics View
        if ([self.sectionArray count] == 0) {
            // If there are no topics to display than no action to be performed
        }
        else{
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager showLoader];
            NSMutableArray *dashboardList=MArray;
            
            //Looping for Topics New LOGIC
            
            [sharedManager.sync getChannelsForUDIDs:@[[[self.sectionArray objectAtIndex:indexPath.section] valueForKey:@"uuid" ]] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                
                if ([result count]>0) {
                    
                    
                    Channels *ch1=(Channels *)[result objectAtIndex:0];
                    
                    
                    if ([[ch1 type] isEqualToString:@"Articles"]) {
                        self.articleListArray = MArray;
                        self.articleListArray = [[sharedManager getArticles:ch1.uuid] mutableCopy];
                        
                        for(int k=0; k<[self.articleListArray count]; k++)
                        {
                            
                            if ([[[self.articleListArray objectAtIndex:k] topicId] isEqualToString:[[[[self.sectionArray objectAtIndex:indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] uuid]]) {
                                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.articleListArray objectAtIndex:k],@"Articles"] forKeys:@[@"data",@"type"]];
                                [dashboardList addObject:dic];
                            }
                            
                        }
                    }
                    else if ([[ch1 type] isEqualToString:@"Blog"]) {
                        self.blogListArray = MArray;
                        self.blogListArray = [[sharedManager getBlogs:ch1.uuid] mutableCopy];
                        
                        
                        for(int k=0; k<[self.blogListArray count]; k++)
                        {
                            
                            if ([[[self.blogListArray objectAtIndex:k] topicId] isEqualToString:[[[[self.sectionArray objectAtIndex:indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] uuid]]) {
                                
                                
                                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.blogListArray objectAtIndex:k],@"Blog"] forKeys:@[@"data",@"type"]];
                                [dashboardList addObject:dic];
                                
                            }
                        }
                    }
                    else if ([[ch1 type] isEqualToString:@"Video"]) {
                        
                        self.videoListArray=[[NSMutableArray alloc] init];
                        self.videoListArray = [[sharedManager getVideos:ch1.uuid] mutableCopy];
                        
                        for(int k=0; k<[self.videoListArray count]; k++)
                        {
                            
                            if ([[[self.videoListArray objectAtIndex:k] topicId] isEqualToString:[[[[self.sectionArray objectAtIndex:indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] uuid]]) {
                                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.videoListArray objectAtIndex:k],@"Video"] forKeys:@[@"data",@"type"]];
                                [dashboardList addObject:dic];
                                
                            }
                        }
                    }
                }
            }];
            
            
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
            [[SlideNavigationController sharedInstance] toggleLeftMenu];
            article.dashboardList=[dashboardList mutableCopy];
            article.isCategory=YES;
            article.titleScreen=[[[[self.sectionArray objectAtIndex:indexPath.section] valueForKey:@"data"] objectAtIndex:indexPath.row] topicname];
            //[Globals pushNewViewController:article];
            
            //            NSArray *allControllersCopy = [[SlideNavigationController sharedInstance] viewControllers];
            //
            //            for (id object in allControllersCopy) {
            //                if ([object isKindOfClass:[DashboardVC class]])
            //                    sharedManager.syncCompleted=sync;
            //            }
            [UIView animateWithDuration:1.55 animations:^{
                article.tableView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                article.tableView.alpha = 0.0;
                article.tableView.frame=CGRectMake(article.tableView.frame.origin.x, 320-article.tableView.frame.origin.y, article.tableView.frame.size.width, article.tableView.frame.size.height);
            } completion:^(BOOL finished) {
                if (finished) {
                    article.tableView.frame=CGRectMake(article.tableView.frame.origin.x, 0, article.tableView.frame.size.width, article.tableView.frame.size.height);
                    article.tableView.alpha = 1.0;
                    article.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
                    
                }
            }];
            
        }
        
    }
    else if(self.activeView==3)
    {
        //Reading List View
        if ([self.readingListArray count] == 0) {
            // If there are no reading list to display than no action to be performed
        }
        else{
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            [sharedManager showLoader];
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ArticleDetailVC *articleDetail=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
            NSString *uuid=[[self.readingListArray objectAtIndex:indexPath.row] valueForKey:@"uuid"];
            if ([[[self.readingListArray objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"Articles"]) {
                //
                [sharedManager.sync getArticlesForUDIDs:@[uuid] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                    //
                    articleDetail.currentArticle=[result objectAtIndex:0];
                    
                    [[SlideNavigationController sharedInstance] pushViewController:articleDetail animated:NO];
                }];
            }
            else{
                [sharedManager.sync getBlogsForUDIDs:@[uuid] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                    //
                    articleDetail.currentBlog=[result objectAtIndex:0];
                    
                    [[SlideNavigationController sharedInstance] pushViewController:articleDetail animated:NO];
                }];
            }
            
        }
    }
}
-(IBAction)logOut:(id)sender
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsVC *topic=[story instantiateViewControllerWithIdentifier:@"SettingsVC"];
    [[SlideNavigationController sharedInstance] pushViewController:topic animated:YES];
    //[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:NO];
}

-(IBAction)editCategories:(id)sender
{
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TopicsVC *topic=[story instantiateViewControllerWithIdentifier:@"TopicsVC"];
    topic.isFromSettings=YES;
    [[SlideNavigationController sharedInstance] pushViewController:topic animated:YES];
}

// For Searchbar delegate
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    [self.transparentView setHidden:NO];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.searchTrailingMargin.constant=0;
    self.readingtableViewTrailingMargin.constant=0;
    self.topictableViewTrailingMargin.constant=0;
    self.channeltableViewTrailingMargin.constant=0;
    [self.view reloadInputViews];
    [self.view layoutIfNeeded];
    [SlideNavigationController sharedInstance].view.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight);
    
    [self.transparentView setHidden:NO];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.searchTrailingMargin.constant=40;
    self.readingtableViewTrailingMargin.constant=40;
    self.topictableViewTrailingMargin.constant=40;
    self.channeltableViewTrailingMargin.constant=20;
    [self.view reloadInputViews];
    [self.view layoutIfNeeded];
    [self.transparentView setHidden:YES];
    [self.btnMenu setHidden:NO];
    return YES;
}
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [self.transparentView setHidden:YES];
    [self.btnMenu setHidden:NO];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.transparentView setHidden:YES];
    [self resignFirstResponder];
    [[self view] endEditing:YES];
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchVC *search=[story instantiateViewControllerWithIdentifier:@"SearchVC"];
    search.searchstr= searchBar.text;
    [[SlideNavigationController sharedInstance   ] toggleLeftMenu];
    [[SlideNavigationController sharedInstance] pushViewController:search animated:NO];
    self.searchbar.showsCancelButton = false;
}
-(void)hideKeyboard{
    [self.view endEditing:YES];
}




#pragma mark searchdelegate

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{}

@end
