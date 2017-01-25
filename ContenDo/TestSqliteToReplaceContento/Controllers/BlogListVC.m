//
//  BlogListVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 04/02/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import "BlogListVC.h"

@implementation BlogListVC
@synthesize titleScreen;
-(void)viewDidLoad{
    [super viewDidLoad];
    [self initVC];
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
    
    
    
    // Checking if We have channels or already set uuid of topics
    if(!self.blogListArray)
    {
        // Initializing Variables
        self.blogListArray=[[NSMutableArray alloc] init];
        
        // Getting List of Articles for particular channels
        
        [sharedManager.sync getBlogsForChannel:self.currentChannel.uuid WithCompletionBlock:^(id result,NSString *str, int status) {
            [self.tableView reloadData];
            self.blogListArray=[result mutableCopy];
            [self.totalBlogs setText:[NSString stringWithFormat:@"%lu Blogs",(unsigned long)[self.blogListArray count]]];
            [sharedManager hideLoader];
        }];
    }
    else{
        [sharedManager hideLoader];
        [self.totalBlogs setText:[NSString stringWithFormat:@"%lu Blogs",(unsigned long)[self.blogListArray count]]];
        [self.tableView reloadData];
    }
    if(self.isChannel)
    {
        refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.backgroundColor = [UIColor whiteColor];
        refreshControl.tintColor = [UIColor colorWithRed:174.0f/255.0f green:170.0f/255.0f blue:23.0f/255.0f alpha:1.0];
        [refreshControl addTarget:self
                           action:@selector(pullToRefresh)
                 forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:refreshControl];
    }
}

#pragma mark table
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellTextField *cell=[tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
    if(cell == nil)
    {
        cell = (CellTextField *) [[CellTextField alloc
                                   ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textFieldCell"];
    }
    return cell;
}

-(void)pullToRefresh{
    self.blogListArray=nil;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager showLoader];
    if([Validations isconnectedToInternet] )
    {
        
        [sharedManager.sync fillArticlesWithCompletionBlock:^(id result,NSString *str, int status) {
            [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                self.blogListArray= [result mutableCopy];
                
                [self.tableView scrollsToTop];
                
            }];
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
-(IBAction)backbtn:(id)sender{
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}
@end
