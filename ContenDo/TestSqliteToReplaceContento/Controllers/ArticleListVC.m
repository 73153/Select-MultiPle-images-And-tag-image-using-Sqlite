//
//  ArticleListVC.m
//  Contento
//
//  Created by aadil on 16/11/15.
//  Copyright © 2015 Zaptech. All rights reserved.
//

#import "ArticleListVC.h"
#import "CellArticle.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContentoVC.h"
@interface ArticleListVC ()

@end

@implementation ArticleListVC

- (void)viewDidLoad {
    [super viewDidLoad];
//     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.articleListArray=[[NSMutableArray alloc] init];
//    Globals *sharedManager;
//    sharedManager=[Globals sharedManager];
//    [sharedManager showLoaderIn:self.view];
//    [sharedManager.article getArticlesWithChannelId:self.channelUUID :^(NSDictionary *result, NSString *str, int status){
//        [sharedManager hideLoader];
//        for (int i=0; i<[[result objectForKey:@"data"] count]; i++) {
//            //
//            Articles *tmpArticle=[[Articles alloc] init];
//            tmpArticle.articlelId=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"_id"];
//            tmpArticle.title=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"title"];
//            tmpArticle.articleUri=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"articleUri"];
//            tmpArticle.summary=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"summary"];
//            tmpArticle.desc=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"description"];
//            tmpArticle.channelId=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"channelId"];
//            tmpArticle.uuid=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"uuid"];
//            tmpArticle.clientId=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"clientId"];
//            tmpArticle.vv=[[[result objectForKey:@"data"] objectAtIndex:i] valueForKey:@"__v"];
//            // For Meta
//            tmpArticle.meta.isActive=[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]valueForKey:@"isActive"] boolValue];
//            tmpArticle.meta.createdAt=[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]valueForKey:@"createdAt"];
//            tmpArticle.meta.updatedAt=[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]valueForKey:@"updatedAt"];
//            // For Adding Categories
//            for (int x; x<[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
//               [tmpArticle.meta.category addObject:[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]objectForKey:@"category"] objectAtIndex:x]];
//            }
//            // For Adding Tags
//            for (int x; x<[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]valueForKey:@"category"] count]; x++) {
//                [tmpArticle.meta.category addObject:[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]objectForKey:@"tags"] objectAtIndex:x]];
//            }
//            
//            // For Authors
//            tmpArticle.meta.author.name=[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"name"];
//            tmpArticle.meta.author.company=[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"company"];
//            tmpArticle.meta.author.blurb=[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"blurb"];
//            tmpArticle.meta.author.uuid=[[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"meta"]objectForKey:@"author"] valueForKey:@"uuid"];
//            
//            // For Images
//            [tmpArticle.imageUrls setObject:[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"imageUrls"]valueForKey:@"thumbnail"] forKey:@"thumbnail"];
//            [tmpArticle.imageUrls setObject:[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"imageUrls"]valueForKey:@"thumbnail"] forKey:@"thumbnail"];
//            [tmpArticle.imageUrls setObject:[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"imageUrls"]valueForKey:@"phoneHero"] forKey:@"phoneHero"];
//            [tmpArticle.imageUrls setObject:[[[[result objectForKey:@"data"] objectAtIndex:i]  objectForKey:@"imageUrls"]valueForKey:@"tabletHero"] forKey:@"tabletHero"];
//            
//            [self.articleListArray addObject:tmpArticle];
//        }
//        [self.tableView reloadData];
//    }];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
