//
//  ReadingListVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 03/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "ReadingListVC.h"
#import "Constants.h"
#import "CellArticle.h"
@interface ReadingListVC ()

@end

@implementation ReadingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TableView Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView    {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellReadingList";
    CellArticle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil && tableView != self.tableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



@end
