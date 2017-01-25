//
//  TestSqliteToReplaceContentoVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 03/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "TestSqliteToReplaceContentoVC.h"

@interface TestSqliteToReplaceContentoVC ()

@end

@implementation TestSqliteToReplaceContentoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnMenu addTarget:self action:@selector(openMenu) forControlEvents:UIControlEventTouchUpInside];
    [SlideNavigationController sharedInstance].enableShadow = false;
    self.sharedManager=[Globals sharedManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}
-(void) openMenu{
    [[SlideNavigationController sharedInstance] toggleLeftMenu];
}



@end
