//
//  TopicsVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 10/12/15.
//  Copyright © 2015 73153. All rights reserved.
//
#import "TopicsVC.h"
@interface TopicsVC ()

@end

@implementation TopicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topicsAray=[UDGetObject(@"topic") mutableCopy];
    if(!self.topicsAray)
    {
        self.topicsAray=MArray;
    }
    self.selectedTopics=MArray;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
        sharedManager.topicsArray=[result mutableCopy];
        for (int i=0; i<[result count]; i++) {
            
            [self.selectedTopics addObject:@"false"];
            NSMutableArray *dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"topic"];
            if ([dic count]>0) {
                BOOL isSelected=false;
                for (int j=0; j<[dic count]; j++) {
                    if ([[dic objectAtIndex:j] isEqualToString:[[sharedManager.topicsArray objectAtIndex:i]topicname] ]) {
                        isSelected=true;
                    }
                }
                
                if (isSelected) {
                    
                    [self.selectedTopics replaceObjectAtIndex:i withObject:@"true"];
                }
                else{
                    [self.selectedTopics replaceObjectAtIndex:i withObject:@"false"];
                }
            }
        }
        [self.tableView reloadData];
    }];
    [self.tableView reloadData];
    [self.doneButton setBackgroundColor:THEME_INNER_BG_COLOR];
    [self.headerView setBackgroundColor:THEME_INNER_BG_COLOR];
}

#pragma mark TableView Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    return [sharedManager.topicsArray  count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTopics *cell=(CellTopics *)[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [cell.titleLabel setText:[[sharedManager.topicsArray objectAtIndex:indexPath.row] topicname]];
    [cell.addToSelected setImage:[UIImage imageNamed:@"btnplus"] forState:UIControlStateNormal];
    
    if ([self.selectedTopics count] > 0 ) {
        if ([[self.selectedTopics objectAtIndex:indexPath.row] boolValue]) {
            [cell.addToSelected setImage:[UIImage imageNamed:@"btncheck"] forState:UIControlStateNormal];
            cell.isSelected=true;
        }
        else{
            [cell.addToSelected setImage:[UIImage imageNamed:@"btnplus"] forState:UIControlStateNormal];
            cell.isSelected=false;
        }
    }
    else{
        [cell.addToSelected setImage:[UIImage imageNamed:@"btnplus"] forState:UIControlStateNormal];
        cell.isSelected=false;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CellTopics *cell=(CellTopics *)[tableView cellForRowAtIndexPath:indexPath];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    if (!cell.isSelected) {
        cell.isSelected=true;
        [cell.addToSelected setImage:[UIImage imageNamed:@"btncheck"] forState:UIControlStateNormal];
        [self.selectedTopics replaceObjectAtIndex:indexPath.row withObject:@"true"];
        
        if (![self.topicsAray containsObject:[[sharedManager.topicsArray objectAtIndex:indexPath.row]topicname]]) {
            [self.topicsAray addObject:[[sharedManager.topicsArray objectAtIndex:indexPath.row]topicname]];
        }
    } else {
        cell.isSelected=false;
        [cell.addToSelected setImage:[UIImage imageNamed:@"btnplus"] forState:UIControlStateNormal];
        [self.selectedTopics replaceObjectAtIndex:indexPath.row withObject:@"false"];
        
        if ([self.topicsAray containsObject:[[sharedManager.topicsArray objectAtIndex:indexPath.row]topicname]]) {
            [self.topicsAray removeObject:[[sharedManager.topicsArray objectAtIndex:indexPath.row]topicname]];
        }
    }
    
}

#pragma mark Top bar Button
-(IBAction)btnDone:(id)sender{
    if([self.topicsAray count] <= 0)
    {
        [Globals ShowAlertWithTitle:@"Error" Message:@"Select Atleast one topic"];
        return;
    }
    UDSetObject(self.topicsAray, @"topic");
    if (self.isFromSettings) {
        [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(IBAction)btnCancel:(id)sender{
    
    if (self.isFromSettings) {
        [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
