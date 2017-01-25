//
//  ArticleDetailVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 18/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "ArticleDetailVC.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DashboardVC.h"
#import "Database.h"
#import <Social/Social.h>

@interface ArticleDetailVC ()
{
    int pos;
    NSString *fontSize;
    int repeate;
    Globals *sharedManager;
}
@end

@implementation ArticleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!sharedManager)
        sharedManager = [Globals sharedManager];
    [self initVC];
    self.scrollView.delegate = self;
    [self manageActivity];
    [self.relatedListLabel setTextColor:THEME_TEXT_COLOR];
    [self.lblTopicName  setTextColor:THEME_TAG_COLOR];
    _relatedArticleCollecionView.hidden=true;
    _relatedArticleView.hidden=true;
    _relatedListLabel.hidden=true;
    [sharedManager hideLoader];
    self.contentWebView.scrollView.scrollEnabled = false;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    
    self.relatedArticleCollecionView.delegate=self;
    [self.relatedArticleCollecionView reloadData];
    self.contentWebView.hidden=false;
    
    self.footerView.alpha = 1;
    self.scrollView.delegate=self;
    self.isScrolled=YES;
    [_relatedArticleCollecionView setBackgroundColor:THEME_MENU_BG_COLOR];
    [_relatedArticleView setBackgroundColor:THEME_MENU_BG_COLOR];
    [_relatedListLabel setTextColor:RELATED_THEME_TITLE_COLOR];
    [self.lblTopicName  setTextColor:THEME_BG_COLOR];
    [self.titleLabel setTextColor:THEME_BG_COLOR];
    [[UIScreen mainScreen] setBrightness:[UIScreen mainScreen].brightness];
    
}
-(void) initVC{
    // Initializing Variables and views
    self.currentTopic=[[Topics alloc] init];
    self.app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (self.currentArticle) {
        [self.titleLabel setText:self.currentArticle.title];
        
        [self.banneImage sd_setImageWithURL:[NSURL URLWithString:[self.currentArticle.imageUrls valueForKey:@"phoneHero"]] placeholderImage:nil options:SDWebImageRefreshCached];
        
        NSString *styles=[NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width' /> </head><body><style>#TestSqliteToReplaceContentoId{font-family :\"Lato\"!important; color: #171616; padding-left:15px!important;padding-right:15px!important; padding-top:0px; font-size:16px!important; }img {width:%fpx!important;padding:0!important;margin-left:-20px!important;margin-right:-15px!important;} h1 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h2 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h3 { font-family :\"Lato\"; font-size:30px; font-weight:100; } .titles{ color:#656b6d}.authors{font-size:12px;text-transform: uppercase;color: #171616;}</style>", self.view.frame.size.width];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        
        
        self.currentArticle.meta.createdAt=[[self.currentArticle.meta.createdAt stringByReplacingOccurrencesOfString:@"dash" withString:@"-"] mutableCopy];
        NSDate *date = [dateFormat dateFromString:self.currentArticle.meta.createdAt];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
        NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
        [calMonth setDateFormat:@"MMMM"];
        
        [components month]; //gives you month
        [components day]; //gives you day
        [components year]; // gives you year
        NSString *formateDates=[NSString stringWithFormat:@"%@ %ld",[calMonth stringFromDate:date],(long)[components year]];
        
        [self.contentWebView loadHTMLString:[NSString stringWithFormat:@"%@<div id='TestSqliteToReplaceContentoId' ><h3>%@</h3><div class='authors'><span class='titles'>Author :</span> %@ </div><div class='authors'><span class='titles'>Date :</span> %@</div> <div style='height:10px;'></div> %@</div></body></html>", styles, self.currentArticle.title,self.currentArticle.meta.author.name,formateDates,self.currentArticle.desc ] baseURL:nil];
        // Initialining Collection View Fior Related Articles
        pos=0;
        [self.relatedListLabel setText:@"Related Articles"];
    }
    else{
        
        [self.relatedListLabel setText:@"Related Blogs"];
        [self.titleLabel setText:self.currentBlog.title];
        
        [self.banneImage sd_setImageWithURL:[NSURL URLWithString:self.currentBlog.heroImage] placeholderImage:nil options:SDWebImageRefreshCached];
        
        NSString *styles=[NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width' /> </head> <body> <style>#TestSqliteToReplaceContentoId{font-family :\"Lato\"!important; color: #171616;padding-left:15px!important;padding-right:15px!important; padding-top:10px; font-size:16px!important;}img {width:%fpx!important;margin-left:-24px!important;margin-right:-15px!important;padding:0!important;} h1 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h2 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h3 { font-family :\"Lato\"; font-size:30px; font-weight:100; } .titles{ color:#656b6d}.authors{font-size:12px;text-transform: uppercase;color: #171616;}</style>", self.view.frame.size.width];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormat setTimeZone:timeZone];
        NSDate *date = [dateFormat dateFromString:self.currentBlog.meta.createdAt];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
        NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
        [calMonth setDateFormat:@"MMMM"];
        
        [components month]; //gives you month
        [components day]; //gives you day
        [components year]; // gives you year
        NSString *formateDates;
        if(date)
        {
            formateDates=[NSString stringWithFormat:@"%@ %ld",[calMonth stringFromDate:date],(long)[components year]];
        }
        else{
            formateDates=@"";
        }
        [self.contentWebView loadHTMLString:[NSString stringWithFormat:@"%@<div id='TestSqliteToReplaceContentoId' style='font-family:Lato'><h3>%@</h3>Author : %@<br/>Date : %@ <div style='height:10px;'></div> %@</div></body></html>", styles, self.currentBlog.title,self.currentBlog.meta.author.name,formateDates,self.currentBlog.body ] baseURL:nil];
        // Initialining Collection View Fior Related Articles
        pos=0;
        self.relatedBlogsArray = [[NSMutableArray alloc] init];
    }
    
    // Adding Swipe Gesture for Next Previous
    UISwipeGestureRecognizer *SWIPR=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeDateLeft)];
    SWIPR.direction=UISwipeGestureRecognizerDirectionLeft;
    SWIPR.numberOfTouchesRequired = 1;
    SWIPR.delegate=self;
    [self.view addGestureRecognizer:SWIPR];
    
    UISwipeGestureRecognizer *SWIPL=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeDateRight)];
    SWIPL.direction=UISwipeGestureRecognizerDirectionRight;
    SWIPL.numberOfTouchesRequired = 1;
    SWIPL.delegate=self;
    [self.view addGestureRecognizer:SWIPL];
    
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:SWIPL];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:SWIPR];
    
    [self.relatedArticleCollecionView.panGestureRecognizer requireGestureRecognizerToFail:SWIPL];
    [self.relatedArticleCollecionView.panGestureRecognizer requireGestureRecognizerToFail:SWIPR];
    
    //Adding Parallax Effect
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to our image view
    [self.banneImage addMotionEffect:group];
    fontSize=[NSString stringWithFormat:@"%d",16];
    repeate=0;
    
    // Making related article hidden till webview loads
    [self.relatedArticleView setHidden:true];
    [self.relatedArticleCollecionView setHidden:true];
    if (self.currentArticle) {
        [self getRelatedArticles];
    }
    else if (self.currentBlog) {
        [self getRelatedBlogs];
    }
    [self.actionsheetView setHidden:YES];
    [self.slider setValue:[[UIScreen mainScreen] brightness]];
    self.previousYaxis=0;
    self.contentWebView.scrollView.delegate = self;
    self.isScrolled = false;
    [self getTopic];
}
-(void) getTopic
{
    @try{
        if (self.currentArticle) {
            //
        }
        else if (self.currentBlog){
            Blogs *tmpBlog=self.currentBlog;
            tmpBlog.isCategoryPresent=false;
            for(int i=0; i<[sharedManager.topicsArray count]; i++)
            {
                Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
                for (int j=0; j<[tempTopic.channelId count]; j++) {
                    if ([[tempTopic.channelId objectAtIndex:j] isEqualToString:tmpBlog.channelId]) {
                        tmpBlog.isCategoryPresent=true;
                        tmpBlog.topicId=tempTopic.topicId;
                        tmpBlog.currentTopic=tempTopic;
                        
                        CategoryButtons *btn=[[CategoryButtons alloc] init];
                        
                        [self.lblTopicName  setText:[tempTopic.topicname uppercaseString] ];
                        btn.name=[NSString stringWithFormat:@"%@",tempTopic.topicname];
                        [btn setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                        [self.btnTopic setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                        
                        [self.btnTopic.titleLabel setFont: [btn.titleLabel.font fontWithSize: 12.0]];
                        [self.btnTopic setTitleColor:[UIColor colorWithRed:(188.0f/255.0f) green:(182.0f/255.0f) blue:(11.0f/255.0f) alpha:1.0] forState:UIControlStateNormal  ];
                        self.btnTopic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [self.btnTopic addTarget:self action:@selector(redirectToCategoryWithTopic:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                }
                
            }
        }
    } @catch (NSException *exception) {
        
    }
}
-(void)manageActivity{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    NSDate *now = [NSDate date];
    NSString* myString = [dateFormat stringFromDate:now];
    NSMutableDictionary *dic;
    if (self.currentArticle) {
        dic=[[NSMutableDictionary alloc] initWithObjects:@[self.currentArticle.clientId,self.currentArticle.uuid,self.currentArticle.channelId,self.currentArticle.title,@"viewRecord",myString] forKeys:@[@"clientId",@"objectId",@"channelId",@"title",@"logType",@"timestamp"]];
        for (int i=0; i<[self.currentArticle.meta.tags count]; i++) {
            //
            [dic setObject:[self.currentArticle.meta.tags objectAtIndex:i] forKey:@"topics"];
        }
    }
    else{
        dic=[[NSMutableDictionary alloc] initWithObjects:@[self.currentBlog.clientId,self.currentBlog.uuid,self.currentBlog.channelId,self.currentBlog.title,@"viewRecord",myString] forKeys:@[@"clientId",@"objectId",@"channelId",@"title",@"logType",@"timestamp"]];
        for (int i=0; i<[self.currentBlog.meta.tags count]; i++) {
            //
            [dic setObject:[self.currentBlog.meta.tags objectAtIndex:i] forKey:@"topics"];
        }
    }
    
    Activities *activity=[[Activities alloc] init];
    [activity saveActivity:dic withCompletion:^(NSDictionary *result, NSString *str, int status) {
        if (status==1) {
            //
        }
    }];
}

-(void) getRelatedArticles{
    @try{
        if(!sharedManager)
            sharedManager=[Globals sharedManager];
        [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
            
            sharedManager.topicsArray=[result mutableCopy];
            NSMutableArray *relatedUDIDs=MArray;
            if(status==1)
            {
                if(status==1)
                {
                    
                    
                    [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
                        
                        sharedManager.topicsArray=[result mutableCopy];
                        
                        [sharedManager.topicsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            
                            
                            [self.currentArticle.meta.tags enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                                if(self.currentArticle.meta.isActive==false)
                                {
                                    Database *db= [[Database alloc] init];
                                    [db insertArticles:obj];
                                    return ;
                                }
                                if ([[obj valueForKey:@"name"] isEqualToString:obj1]) {
                                    //
                                    for (int j=0; j<[[obj objectForKey:@"uuid"] count]; j++) {
                                        if(![[[obj objectForKey:@"uuid"]objectAtIndex:j] isEqualToString: self.currentArticle.uuid])
                                        {
                                            if (![relatedUDIDs containsObject:[[obj objectForKey:@"uuid"]objectAtIndex:j]]) {
                                                // does not contain.
                                                [relatedUDIDs addObject:[[obj objectForKey:@"uuid"]objectAtIndex:j]];
                                                sharedManager.relatedUDIDs = [[NSMutableArray alloc] initWithArray:relatedUDIDs];
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }];
                        }];
                        
                    }];
                    [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                        sharedManager.articleArray=[result mutableCopy];
                        [sharedManager.articleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            Articles *tmpAr=(Articles *)obj;
                            
                            
                            if ([tmpAr.channelId isEqualToString:self.currentArticle.channelId] && ![tmpAr.uuid isEqualToString: self.currentArticle.uuid ] && [tmpAr.topicId isEqualToString:self.currentArticle.topicId]) {
                                //
                                // does not contain.
                                [relatedUDIDs addObject:tmpAr.uuid];
                                sharedManager.relatedUDIDs = [[NSMutableArray alloc] initWithArray:relatedUDIDs];
                            }
                        }];
                    } ];
                    if(relatedUDIDs.count==0 || relatedUDIDs==nil)
                    {
                        
                        [sharedManager.sync getArticlesForUDIDs:sharedManager.relatedUDIDs WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                            
                            self.relatedArticleArray = [[NSMutableArray alloc] initWithArray:result];
                            
                            [self.relatedArticleCollecionView reloadData];
                        }];
                        return ;
                        
                    }
                    else{
                        
                        
                        [sharedManager.sync getArticlesForUDIDs:relatedUDIDs WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                            //
                            
                            self.relatedArticleArray = [[NSMutableArray alloc] initWithArray:result];
                            
                            [self.relatedArticleCollecionView reloadData];
                        }];
                    }
                    
                }
                else{
                    [Globals ShowAlertWithTitle:@"Error" Message:str];
                }
            }
            else{
                [Globals ShowAlertWithTitle:@"Error" Message:str];
            }
            
            
        }];
    } @catch (NSException *exception) {
        
    }
}

-(void) getRelatedBlogs{
    @try{
        if(!sharedManager)
            sharedManager=[Globals sharedManager];
        [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
            
            sharedManager.topicsArray=[result mutableCopy];
            NSMutableArray *relatedUDIDs=MArray;
            if(status==1)
            {
                if(status==1)
                {
                    
                    
                    [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
                        //
                        
                        sharedManager.topicsArray=[result mutableCopy];
                        
                        [sharedManager.topicsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if(self.currentBlog.meta.isActive==false)
                            {
                                Database *db= [[Database alloc] init];
                                [db insertBlogs:obj WithCompletionBlock:^(BOOL status) {
                                }];
                                return ;
                            }
                            [self.currentBlog.meta.tags enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                                if ([[obj valueForKey:@"name"] isEqualToString:obj1]) {
                                    //
                                    for (int j=0; j<[[obj objectForKey:@"uuid"] count]; j++) {
                                        if(![[[obj objectForKey:@"uuid"]objectAtIndex:j] isEqualToString: self.currentBlog.uuid] )
                                        {
                                            if (![relatedUDIDs containsObject:[[obj objectForKey:@"uuid"]objectAtIndex:j]]) {
                                                // does not contain.
                                                [relatedUDIDs addObject:[[obj objectForKey:@"uuid"]objectAtIndex:j]];
                                                if(self.currentBlog.meta)
                                                    sharedManager.relatedUDIDs = [[NSMutableArray alloc] initWithArray:relatedUDIDs];
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }];
                        }];
                        
                    }];
                    
                    [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                        sharedManager.blogsArray=[result mutableCopy];
                        sharedManager.relatedUDIDs = [[NSMutableArray alloc] init];
                        
                        [sharedManager.blogsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            Blogs *tmpAr=(Blogs *)obj;
                            
                            if ([tmpAr.channelId isEqualToString:self.currentBlog.channelId] && ![tmpAr.uuid isEqualToString: self.currentBlog.uuid ] && [tmpAr.topicId isEqualToString: self.currentBlog.topicId ] ) {
                                //
                                if (![relatedUDIDs containsObject:tmpAr.uuid]) {
                                    // does not contain.
                                    [relatedUDIDs addObject:tmpAr.uuid];
                                    sharedManager.relatedUDIDs = [[NSMutableArray alloc] initWithArray:relatedUDIDs];
                                }
                            }
                            else{
                                [sharedManager.relatedUDIDs addObject:self.currentBlog.uuid];
                            }
                        }];
                    }];
                    
                    
                    
                    if(relatedUDIDs.count==0 || relatedUDIDs==nil)
                    {
                        
                        [sharedManager.sync getBlogsForUDIDs:sharedManager.relatedUDIDs WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                            self.relatedBlogsArray = [[NSMutableArray alloc] initWithArray:result];
                            
                            [self.relatedArticleCollecionView reloadData];
                        }];
                        return ;
                        
                    }
                    else{
                        [sharedManager.sync getBlogsForUDIDs:relatedUDIDs WithCompletionblock:^(NSArray *result, NSString *str, int status) {
                            //
                            if(result)
                            {
                                self.relatedBlogsArray=[result mutableCopy];
                                [self.relatedArticleCollecionView reloadData];
                            }
                        }];
                    }
                }
                else{
                    [Globals ShowAlertWithTitle:@"Error" Message:str];
                }
            }
            else{
                [Globals ShowAlertWithTitle:@"Error" Message:str];
            }
            
            
        }];
    } @catch (NSException *exception) {
        
    }
}

#pragma mark CollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.relatedArticleArray count]>0) {
        return [self.relatedArticleArray count];
    }
    else if ([self.relatedBlogsArray count]>0){
        return [self.relatedBlogsArray count];
    }
    else{
        return 0;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.contentWebView.hidden=true;
    
    if([self.relatedArticleArray count] > 0)
    {
        if(!sharedManager)
            sharedManager=[Globals sharedManager];
        Articles *currentArticle=(Articles*)[self.relatedArticleArray objectAtIndex:indexPath.row];
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
        article.currentArticle = currentArticle;
        
        [sharedManager showLoaderIn:self.view];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        [UIView animateWithDuration:.55 animations:^{
            self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            if (finished) {
                self.contentWebView.hidden=false;
                
                [sharedManager hideLoader];
                [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
                
                self.view.alpha = 1.0;
                self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
        }];
    }
    else if([self.relatedBlogsArray count] > 0 )
    {
        Blogs *currentBlog=[self.relatedBlogsArray objectAtIndex:indexPath.row];
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ArticleDetailVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticleDetailVC"];
        article.currentBlog =currentBlog;
        
        if(!sharedManager)
            sharedManager=[Globals sharedManager];
        [sharedManager showLoaderIn:self.view];
        [UIView animateWithDuration:.55 animations:^{
            self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            if (finished) {
                [sharedManager hideLoader];
                self.contentWebView.hidden=false;
                
                [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
                
                self.view.alpha = 1.0;
                self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }
        }];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    relatedArticleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"relatedArticle" forIndexPath:indexPath];
    
    if([self.relatedArticleArray count] > 0)
    {
        Articles *tmpArticle=[self.relatedArticleArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:tmpArticle.title];
        [cell.descriptionLabel setText:tmpArticle.summary];
        
        [cell.thumbImage sd_setImageWithURL:[NSURL URLWithString:[tmpArticle.imageUrls valueForKey:@"thumbnail"]] placeholderImage:nil options:SDWebImageRefreshCached];
        
        if(indexPath.row==0)
        {
            [cell.btnLeft setHidden:YES];
        }
        else{
            [cell.btnLeft setHidden:NO];
        }
        if(indexPath.row == ([self.relatedArticleArray count]-1))
        {
            [cell.btnRight setHidden:YES];
        }
        else{
            [cell.btnRight setHidden:NO];
        }
        tmpArticle.isCategoryPresent=false;
        [cell.btnDigitalEnterprise setTitleColor:RELATED_THEME_TAG_COLOR forState:UIControlStateNormal];
        for(int i=0; i<[sharedManager.topicsArray count]; i++)
        {
            Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
            //            for (int j=0; j<[tempTopic.channelId count]; j++) {
            if ([tempTopic.uuid isEqualToString:tmpArticle.topicId]) {
                tmpArticle.isCategoryPresent=true;
                tmpArticle.topicId=tempTopic.topicId;
                tmpArticle.currentTopic=tempTopic;
                CategoryButtons *btn=[[CategoryButtons alloc] init];
                btn.name=[NSString stringWithFormat:@"%@",tempTopic.topicname];
                [self.lblTopicName  setText:[tempTopic.topicname uppercaseString] ];
                
                [btn setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                [cell.btnDigitalEnterprise setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                
                
                [btn.titleLabel setFont: [btn.titleLabel.font fontWithSize: 12.0]];
                [btn setTitleColor:[UIColor colorWithRed:(188.0f/255.0f) green:(182.0f/255.0f) blue:(11.0f/255.0f) alpha:1.0] forState:UIControlStateNormal  ];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                [btn addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
        }
        
    }
    else if([self.relatedBlogsArray count] > 0)
    {
        Blogs *tmpBlog=[self.relatedBlogsArray objectAtIndex:indexPath.row];
        [cell.titleLabel setText:tmpBlog.title];
        [cell.descriptionLabel setText:tmpBlog.summary];
        [cell.thumbImage sd_setImageWithURL:[NSURL URLWithString:tmpBlog.heroImage] placeholderImage:nil options:SDWebImageRefreshCached];
        
        [cell.btnDigitalEnterprise setTitleColor:RELATED_THEME_TAG_COLOR forState:UIControlStateNormal];
        
        if(indexPath.row==0)
        {
            [cell.btnLeft setHidden:YES];
        }
        else{
            [cell.btnLeft setHidden:NO];
        }
        if(indexPath.row == ([self.relatedBlogsArray count]-1))
        {
            [cell.btnRight setHidden:YES];
        }
        else{
            [cell.btnRight setHidden:NO];
        }
        tmpBlog.isCategoryPresent=false;
        for(int i=0; i<[sharedManager.topicsArray count]; i++)
        {
            Topics *tempTopic=(Topics *)[sharedManager.topicsArray objectAtIndex:i];
            if ([tempTopic.uuid isEqualToString:tmpBlog.topicId]) {
                tmpBlog.isCategoryPresent=true;
                tmpBlog.topicId=tempTopic.topicId;
                tmpBlog.currentTopic=tempTopic;
                CategoryButtons *btn=[[CategoryButtons alloc] init];
                btn.name=[NSString stringWithFormat:@"%@",tempTopic.topicname];
                [btn setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                [cell.btnDigitalEnterprise setTitle:[tempTopic.topicname uppercaseString] forState:UIControlStateNormal] ;
                
                [btn.titleLabel setFont: [btn.titleLabel.font fontWithSize: 12.0]];
                [btn setTitleColor:[UIColor colorWithRed:(188.0f/255.0f) green:(182.0f/255.0f) blue:(11.0f/255.0f) alpha:1.0] forState:UIControlStateNormal  ];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                cell.btnDigitalEnterprise.tag=indexPath.row+1000;
                [cell.btnDigitalEnterprise addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                [btn addTarget:self action:@selector(redirectToCategory:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
        }
        
        
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ButtonLeftRelatedArticles
- (IBAction)btnRightSwipe:(UIButton *)sender {
    [self changeDateLeft];
}

- (IBAction)btnLeftSwipe:(UIButton *)sender {
    [self changeDateRight];
}
-(IBAction)changeBrightness:(id)sender{
    UISlider *slider=sender;
    
    [[UIScreen mainScreen] setBrightness:slider.value];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _relatedArticleCollecionView.hidden=false;
    _relatedArticleView.hidden=false;
    _relatedListLabel.hidden=false;
    // assuming your self.viewer is a UIWebView
    [self.contentWebView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:
      @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
      (int)self.contentWebView.frame.size.width]];
    
    CGRect newBounds = webView.bounds;
    newBounds.size.height = webView.scrollView.contentSize.height;
    webView.bounds = newBounds;
    NSString *output= [NSString stringWithFormat:@"%f", webView.scrollView.contentSize.height ];
    
    if(IS_IPHONE_4)
    {
        [self.scrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, (self.mainView.frame.size.height+[output floatValue ]) - ((self.view.frame.size.height/480)*102))]; // Added 59
        self.heightWebview.constant=[output floatValue]+((self.view.frame.size.height/480)*480); // it was 300
        self.contentWebView.frame=CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, [output floatValue]+30);
    }
    if(IS_IPHONE_5)
    {
        [self.scrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, (self.mainView.frame.size.height+[output floatValue ]) - ((self.view.frame.size.height/480)*102))];
        self.heightWebview.constant=[output floatValue]+260;
        self.contentWebView.frame=CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, [output floatValue]+30);
    }
    if(IS_IPHONE_6)
    {
        [self.scrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, (self.mainView.frame.size.height+[output floatValue ]) - 202)];
        self.heightWebview.constant=[output floatValue]+260;
        self.contentWebView.frame=CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, [output floatValue]+30);
    }
    if(IS_IPHONE_6P)
    {
        [self.scrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, (self.mainView.frame.size.height+[output floatValue ]) - 250)];
        self.heightWebview.constant=[output floatValue]+260;
        self.contentWebView.frame=CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, [output floatValue]+30);
    }
    if(IS_IPAD)
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            // Retina display
            
            [self.scrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, (self.mainView.frame.size.height+[output floatValue ]) - 250)];
            self.heightWebview.constant=[output floatValue]+260;
            self.contentWebView.frame=CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, [output floatValue]+30);
            
        } else {
            // non-Retina display
            [self.scrollView setContentSize:CGSizeMake(self.mainView.frame.size.width, (self.mainView.frame.size.height+[output floatValue ]) - 250)];
            self.heightWebview.constant=[output floatValue]+260;
            self.contentWebView.frame=CGRectMake(self.contentWebView.frame.origin.x, self.contentWebView.frame.origin.y, self.contentWebView.frame.size.width, [output floatValue]+30);
        }
        
    }
    
    // Making related article visible
    [self.relatedArticleView setHidden:false];
    [self.relatedArticleCollecionView setHidden:false];
    
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    [sharedManager hideLoader];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, 140);
}
-(void)changeDateLeft
{
    if ([self.relatedArticleArray count] > 0) {
        if (pos<(self.relatedArticleArray.count-1)) {
            pos=pos+1;
            [self.relatedArticleCollecionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:pos inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            
        }
    }
    else if ([self.relatedBlogsArray count] > 0) {
        if (pos<(self.relatedBlogsArray.count-1)) {
            pos=pos+1;
            [self.relatedArticleCollecionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:pos inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            
        }
    }
    
    
}
-(void)changeDateRight
{
    if(pos>0)
    {
        pos=pos-1;
        if ([self.relatedArticleArray count] > 0) {
            [self.relatedArticleCollecionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:pos inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        }
        else if ([self.relatedBlogsArray count] > 0) {
            [self.relatedArticleCollecionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:pos inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        }
    }
    else{
        
    }
    
}
-(IBAction)btnReadingListClick:(id)sender
{
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    [sharedManager showLoader];
    if (self.currentArticle) {
        [sharedManager.sync insertReadingListWithName:self.currentArticle.title andWithUUID:self.currentArticle.uuid andType:@"Articles" WithCompletionBlock:^(NSString *str, int status) {
            if(status==1)
            {
                [sharedManager.sync getAllReadingListWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                    //
                    [sharedManager hideLoader];
                    [Globals ShowAlertWithTitle:@"Success" Message:str];
                    if(status==1)
                    {
                        sharedManager.readingListArray = [result mutableCopy];
                    }
                }];
                
            }
            else
            {
                [sharedManager hideLoader];
                [Globals ShowAlertWithTitle:@"Error" Message:str];
            }
        }];
        
    }
    else if(self.currentBlog){
        [sharedManager.sync insertReadingListWithName:self.currentBlog.title andWithUUID:self.currentBlog.uuid andType:@"Blog" WithCompletionBlock:^(NSString *str, int status) {
            if(status==1)
            {
                [sharedManager.sync getAllReadingListWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                    //
                    [sharedManager hideLoader];
                    [Globals ShowAlertWithTitle:@"Success" Message:str];
                    if(status==1)
                    {
                        sharedManager.readingListArray = [result mutableCopy];
                    }
                }];
                
            }
            else
            {
                [sharedManager hideLoader];
                [Globals ShowAlertWithTitle:@"Error" Message:str];
            }
        }];
        
    }
}
// Share Buttons
-(IBAction)promptDownload:(id)sender{
    NSURL *url = [NSURL URLWithString:@"https://www.esilicon.com/wp-content/uploads/lesson2.pdf"];
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    [sharedManager showLoader];
    [self calculateSizeWithURL:url withComletion:^(float size) {
        //
        
        self.action=[[UIActionSheet alloc] initWithTitle:@"Download" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat: @"Download %.2f MB", ceil(size)/1024/1024 ], nil];
        [self.action showInView:self.view];
        [sharedManager hideLoader];
    }];
    
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self btnDownload:nil];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
    
}
-(IBAction)btnDownload:(id)sender{
    
    //create NSURL to that path
    NSURL *url = [NSURL URLWithString:@"https://www.esilicon.com/wp-content/uploads/lesson2.pdf"];
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    [sharedManager showLoader];
    [self downloadPDFWithURL:url andCompletionBlock:^(NSString *str, int status) {
        //
        [sharedManager hideLoader];
        if (status==1) {
            NSURL *url1 = [NSURL fileURLWithPath:str];
            self.docController = [UIDocumentInteractionController interactionControllerWithURL:url1];
            self.docController.delegate=self;
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
                
                [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
                
            } else {
                UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WebviewVC *web=[story instantiateViewControllerWithIdentifier:@"WebviewVC"];
                web.title=@"PDF";
                web.url=@"https://www.esilicon.com/wp-content/uploads/lesson2.pdf";
                [self presentViewController:web animated:YES completion:^{
                }];
                
            }
            
        }
    }];
    
}
-(IBAction)btnShareClick:(id)sender{
    NSString *textToShare;
    NSURL *myWebsite;
    NSURL *imageToShare;
    NSString *textDescription;
    if (self.currentArticle) {
        //
        textToShare = self.currentArticle.title;
        myWebsite = [NSURL URLWithString:self.currentArticle.articleUri];
        imageToShare = [NSURL URLWithString:[self.currentArticle.imageUrls valueForKey:@"phoneHero"]];
        textDescription=self.currentArticle.summary;
    }
    else if (self.currentBlog){
        textToShare = self.currentBlog.title;
        myWebsite = [NSURL URLWithString:self.currentBlog.blogUri];
        imageToShare = [NSURL URLWithString:self.currentBlog.heroImage];
        textDescription=self.currentBlog.summary;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self googlePlusAction];

        return;
    }

    dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Facebook"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self shareAction:@"Facebook"];
                                  return ;
                                  
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"LinkedIn"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  // LinkedIn Share
                                  self.app.social=[[SocialLogin alloc] initWithSocialType:socialTypeLinkedInn];
                                  if(self.app.social.socialType == socialTypeLinkedInn)
                                  {
                                      [self.app.social loginWithLinkedInn:^(id result, NSError *error, NSString *msg, int status)
                                       {
                                           NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[textToShare,[myWebsite absoluteString],textDescription,[imageToShare absoluteString] ] forKeys:@[@"title",@"link",@"description",@"image-url"]];
                                           if(status==1)
                                           {
                                               [self.app.social postLinkedInnWithMessage:dic withCompletionBlock:^(id result, NSError *error, NSString *msg, int status){
                                                   if(status==1)
                                                   {
                                                       // Success
                                                       [sharedManager showToast:@"Content shared on LinkedIn" WithViewController:self];
                                                   }
                                                   else{
                                                       // Error
                                                       [Globals ShowAlertWithTitle:@"Error" Message:@"Could not share content to LinkedIn App"];
                                                   }
                                               }];
                                           }
                                           else{
                                               [Globals ShowAlertWithTitle:@"Error" Message:@"Could not share content to LinkedIn App"];
                                           }
                                       }];
                                  }
                              }];
    
    UIAlertAction* button3 = [UIAlertAction
                              actionWithTitle:@"Google+"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  // Google+ Share
                                  [self googlePlusAction];
                                  return ;
//                                  self.app.social=[[SocialLogin alloc] initWithSocialType:socialTypeGoogle];
                                  
                              }];
    
    UIAlertAction* button4 = [UIAlertAction
                              actionWithTitle:@"Twitter"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  // Twitter Share
                                  [self shareAction:@"Twitter"];
                                  return ;
//                                  self.app.social=[[SocialLogin alloc] initWithSocialType:socialTypeTwitter];
//                                  if(self.app.social.socialType == socialTypeTwitter)
//                                  {
//                                      self.app.social.strTwitterId=[@"QTSecFKjtZyFt9UZa2G0UU8bX" mutableCopy];
//                                      self.app.social.strTwitterSecretKey=[@"6CxBTkJrGlr7ikUvPuuOhHrXlVFWAEtVRKolZGJ9ZEZWV4JXZp" mutableCopy];
//                                      
//                                      ;
//                                  }
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [alert addAction:button3];
    [alert addAction:button4];
    [self presentViewController:alert animated:YES completion:nil];
    // send initialization of UIActivityViewController in background
    dispatch_async(queue, ^{
        
    });
}

-(void)googlePlusAction
{
    @try{
        // Code that creates autoreleased objects.
        
        //73153 TODO
        NSString *strPropadUrl = @"admin.TestSqliteToReplaceContento.mobi/channels/list";
        NSString *addCommentStr;
        
        addCommentStr = [NSString stringWithFormat:@"%@ \n %@ \n %@", @"",@"Shared via TestSqliteToReplaceContento",strPropadUrl];
        
        NSArray *ary;
        
        ary =[[NSArray alloc]initWithObjects:addCommentStr,nil];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:ary applicationActivities:nil];
        
        NSArray *excludeActivities = @[UIActivityTypeMessage,
                                       UIActivityTypeMail,
                                       UIActivityTypePrint,
                                       UIActivityTypeCopyToPasteboard,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo,
                                       UIActivityTypePostToTencentWeibo,
                                       UIActivityTypeAirDrop,
                                       ];
        [activityViewController setValue:addCommentStr forKey:@"subject"];
        activityViewController.excludedActivityTypes = excludeActivities;
        [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
            NSLog(@"completed");
            [self.navigationController popViewControllerAnimated:YES];
            //             [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"Google+" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
        //if iPad
        else {
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

- (void)shareAction:(NSString*)strToShareWith
{
    @try{
        SLComposeViewController *twitterShare;
        
        if([strToShareWith isEqualToString:@"Twitter"])
            twitterShare = [SLComposeViewController
                            composeViewControllerForServiceType:SLServiceTypeTwitter];
        else if ([strToShareWith isEqualToString:@"Facebook"])
            twitterShare = [SLComposeViewController
                            composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock =
        ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
                [twitterShare dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"Posted" message:[NSString stringWithFormat:@"%@ comment",strToShareWith]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            [twitterShare dismissViewControllerAnimated:YES completion:nil];
        };
        twitterShare.completionHandler =myBlock;
        
        [twitterShare removeAllImages];
        [twitterShare removeAllURLs];
        //73153 TODO
        NSString *strPropadUrl = @"admin.TestSqliteToReplaceContento.mobi/channels/list";
        
        [twitterShare setInitialText:[NSString stringWithFormat:@"%@ \n %@ \n %@", @"",@"Shared via TestSqliteToReplaceContento",strPropadUrl]];
        
        //    [twitterShare addURL:[NSURL URLWithString:strPropadUrl]];
        //Adding the Text to the facebook post value from iOS
        [self presentViewController:twitterShare animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

-(IBAction)btnShareClick1:(id)sender{
    NSString *textToShare;
    NSURL *myWebsite;
    //    NSURL *imageToShare;
    if (self.currentArticle) {
        //
        textToShare = self.currentArticle.title;
        myWebsite = [NSURL URLWithString:self.currentArticle.articleUri];
    }
    else if (self.currentBlog){
        textToShare = self.currentBlog.title;
        myWebsite = [NSURL URLWithString:self.currentBlog.blogUri];
    }
    
    [sharedManager showLoader];
    
    dispatch_queue_t queue = dispatch_queue_create("openActivityIndicatorQueue", NULL);
    
    
    
    // send initialization of UIActivityViewController in background
    dispatch_async(queue, ^{
        [sharedManager hideLoader];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *objectsToShare = @[textToShare, myWebsite];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                           UIActivityTypePrint,
                                           UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList,
                                           UIActivityTypePostToFlickr,
                                           UIActivityTypePostToVimeo];
            
            activityVC.excludedActivityTypes = excludeActivities;
            
            [self presentViewController:activityVC animated:YES completion:nil];
            //            [self presentViewController:activityViewController animated:YES completion:nil];
        });
    });
}
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return [self navigationController];
}
-(IBAction)btnSize:(id)sender{
    [self.actionsheetView setHidden:NO];
}
-(IBAction)btnCancel:(id)sender{
    [self.actionsheetView setHidden:YES];
}
-(IBAction)btnFontSizeIncrease:(id)sender{
    
    if(repeate < 5)
    {
        fontSize=[NSString stringWithFormat:@"%d", [fontSize intValue]+ 1 ];
        
        NSString *styles=[NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width' /> </head><body><style>#TestSqliteToReplaceContentoId{font-family :\"Lato\"!important; color: #171616; padding-left:15px!important;padding-right:15px!important; padding-top:10px; }img {width:%fpx!important;padding:0!important;margin-left:-20px!important;margin-right:-15px!important;} h1 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h2 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h3 { font-family :\"Lato\"; font-size:30px; font-weight:100; } .titles{ color:#656b6d}.authors{font-size:12px;text-transform: uppercase;color: #171616;}</style>", self.view.frame.size.width];
        if (self.currentArticle) {
            [self.contentWebView loadHTMLString:[NSString stringWithFormat:@"%@<div id='TestSqliteToReplaceContentoId' style='font-size:%@px;font-family:Lato'><h3>%@</h3>%@</div></body></html>", styles,fontSize, self.currentArticle.title,self.currentArticle.desc ] baseURL:nil];
        }
        else if (self.currentBlog) {
            [self.contentWebView loadHTMLString:[NSString stringWithFormat:@"%@<div id='TestSqliteToReplaceContentoId' style='font-size:%@px;font-family:Lato'><h3>%@</h3>%@</div></body></html>", styles,fontSize, self.currentBlog.title,self.currentBlog.body ] baseURL:nil];
        }
        
        repeate=repeate+1;
    }
}
-(IBAction)btnFontSizeDecrease:(id)sender{
    
    if(repeate > 0)
    {
        fontSize=[NSString stringWithFormat:@"%d", [fontSize intValue]- 1 ];
        NSString *styles=[NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta name='viewport' content='width=device-width' /> </head><body><style>#TestSqliteToReplaceContentoId{font-family :\"Lato\"!important; color: #171616; padding-left:15px!important;padding-right:15px!important; padding-top:10px; }img {width:%fpx!important;padding:0!important;margin-left:-20px!important;margin-right:-15px!important;} h1 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h2 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h3 { font-family :\"Lato\"; font-size:30px; font-weight:100; } .titles{ color:#656b6d}.authors{font-size:12px;text-transform: uppercase;color: #171616;}</style>", self.view.frame.size.width];
        
        if (self.currentArticle) {
            [self.contentWebView loadHTMLString:[NSString stringWithFormat:@"%@<div id='TestSqliteToReplaceContentoId' style='font-size:%@px;font-family:Lato'><h3>%@</h3>%@</div></body></html>", styles,fontSize, self.currentArticle.title,self.currentArticle.desc ] baseURL:nil];
        }
        else if (self.currentBlog) {
            [self.contentWebView loadHTMLString:[NSString stringWithFormat:@"%@<div id='TestSqliteToReplaceContentoId' style='font-size:%@px;font-family:Lato'><h3>%@</h3>%@</div></body></html>", styles,fontSize, self.currentBlog.title,self.currentBlog.body ] baseURL:nil];
        }
        repeate=repeate-1;
    }
}
-(void)downloadPDFWithURL:(NSURL *)url andCompletionBlock:(sync_completion_block)sync{
    // turn it into a request and use NSData to load its content
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *fileName = [url lastPathComponent];
    AFHTTPRequestOperation *downloadRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downloadRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = [[NSData alloc] initWithData:responseObject];
        // Here 'pathToFile' must be path to directory 'Documents' on your device + filename, of course
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *yourArtPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"/%@",fileName ] ];
        [data writeToFile:yourArtPath atomically:YES];
        if(sync)
        {
            sync(yourArtPath,1);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(sync)
        {
            sync(@"Failure",-1);
        }
    }];
    
    
    [downloadRequest start];
    
}
-(void) calculateSizeWithURL:(NSURL *)url withComletion:(size_completion_block)completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    AFHTTPRequestOperation *getTotalImagesBytesOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [getTotalImagesBytesOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completion([operation.response expectedContentLength]);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         completion(0);
     }];
    [getTotalImagesBytesOperation start];
}


-(IBAction)btnBack:(id)sender
{
    self.contentWebView.hidden=true;
    [UIView animateWithDuration:.55 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        //        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.contentWebView.hidden=false;
            
            [[SlideNavigationController sharedInstance] popViewControllerAnimated:NO];
            
            
            self.view.alpha = 1.0;
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        [self.relatedArticleCollecionView reloadData];
    }
    
    if (scrollView.TestSqliteToReplaceContentoffset.y > (self.previousYaxis )  && scrollView.TestSqliteToReplaceContentoffset.y>200) {
        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.alpha = 0;
        } completion: ^(BOOL finished) {
            [self.footerView setHidden:YES];
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.alpha = 1;
        } completion: ^(BOOL finished) {
            [self.footerView setHidden:NO];
        }];
        
    }
    if(scrollView.TestSqliteToReplaceContentoffset.y<200)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.alpha = 1;
        } completion: ^(BOOL finished) {
            [self.footerView setHidden:NO];
        }];
    }
    self.previousYaxis = scrollView.TestSqliteToReplaceContentoffset.y;
}
-(void) redirectToCategory:(id)btn{
    UIButton *tmpBtn=(UIButton *)btn;
    Topics *tempTopic;
    Articles *tempArticle;
    Blogs *tempBlog;
    
    if([self.relatedArticleArray count] > 0)
    {
        tempArticle=[self.relatedArticleArray objectAtIndex:(tmpBtn.tag -1000)];
        tempTopic=tempArticle.currentTopic;
    }
    if([self.relatedBlogsArray count] > 0)
    {
        tempBlog=[self.relatedBlogsArray objectAtIndex:(tmpBtn.tag -1000)];
        tempTopic=tempArticle.currentTopic;
    }
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    
    [sharedManager showLoader];
    NSMutableArray *dashboardListAry=MArray;
    
    
    
    // Looping for Topic
    for (int j=0; j<[[tempTopic channelId] count]; j++) {
        
        NSString *channelId=[[tempTopic channelId] objectAtIndex:j];
        
        [sharedManager.sync getChannelsForUDIDs:@[channelId] WithCompletionblock:^(NSArray *result, NSString *str, int status) {
            Channels *ch1=(Channels *)[result objectAtIndex:0];
            
            if ([[ch1 type] isEqualToString:@"Articles"]) {
                self.articleListArray = MArray;
                self.articleListArray = [[sharedManager getArticles:ch1.uuid] mutableCopy];
                for(int k=0; k<[self.articleListArray count]; k++)
                {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.articleListArray objectAtIndex:k],@"Articles"] forKeys:@[@"data",@"type"]];
                    [dashboardListAry addObject:dic];
                }
            }
            else if ([[ch1 type] isEqualToString:@"Blog"]) {
                self.blogListArray = MArray;
                self.blogListArray = [[sharedManager getBlogs:ch1.uuid] mutableCopy];
                
                for(int k=0; k<[self.blogListArray count]; k++)
                {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[self.blogListArray objectAtIndex:k],@"Blog"] forKeys:@[@"data",@"type"]];
                    [dashboardListAry addObject:dic];
                }
                
            }
            
        }];
        
    }
    
    
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ArticalListVC  *article=[story instantiateViewControllerWithIdentifier:@"ArticalListVC"];
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
    article.dashboardList=[dashboardListAry mutableCopy];
    article.isCategory=YES;
    article.titleScreen=[tempTopic topicname];
    [self.lblTopicName  setText:[tempTopic.topicname uppercaseString] ];
    
    [[SlideNavigationController sharedInstance] pushViewController:article animated:NO];
}

-(void) getArticles:(NSString *)channelId{
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    
    // Initializing Variables
    self.articleListArray=[[NSMutableArray alloc] init];
    
    // Getting List of Articles for particular channels
    [sharedManager.sync getArticlesForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        self.articleListArray=[result mutableCopy];
    }];
    
}
-(void)getVideos:(NSString *)channelId{
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    
    // Initializing Variables
    self.videoListArray=[[NSMutableArray alloc] init];
    
    // Getting List of Articles for particular channels
    [sharedManager.sync getVideosForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        self.videoListArray=[result mutableCopy];
        [sharedManager hideLoader];
    }];
    
}
-(void) getBlogs:(NSString *)channelId{
    if(!sharedManager)
        sharedManager=[Globals sharedManager];
    // Checking if We have channels or already set uuid of topics
    
    // Initializing Variables
    self.blogListArray=[[NSMutableArray alloc] init];
    
    // Getting List of Articles for particular channels
    
    [sharedManager.sync getBlogsForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        self.blogListArray=[result mutableCopy];
    }];
}
-(void)redirectToCategoryWithTopic :(id) result{
    // Here we have currentTopic
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isScrolled=false;
    self.contentWebView.delegate = nil;
    [self.contentWebView stopLoading];
    self.scrollView.delegate=nil;
    self.relatedArticleCollecionView.delegate=nil;
}
-(void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker{}

@end
