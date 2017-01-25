//
//  WebviewVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 14/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "WebviewVC.h"

@interface WebviewVC ()

@end

@implementation WebviewVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleLabel setText:self.titleStr];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:self.url]]];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager showLoader];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager hideLoader];
}
-(IBAction)btnclose:(id)sender{
    [self  dismissViewControllerAnimated:YES completion:^{
        //
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
