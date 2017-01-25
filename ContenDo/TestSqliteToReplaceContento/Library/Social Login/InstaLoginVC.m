//
//  InstaLoginVC.m
//  SocialLogin
//
//  Created by aadil on 27/10/15.
//  Copyright © 2015 zaptechsolutions. All rights reserved.
//

#import "InstaLoginVC.h"
#import "AppDelegate.h"
@interface InstaLoginVC ()

@end

@implementation InstaLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.web.delegate=self;
    [self.view addSubview:self.web];
    
    
    // Do any additional setup after loading the view.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
    {
        if(!error)
        {
            //self.objInstagramBlock(@"",nil,@"User is Logged in",1);
        }
        else
        {
            //self.objInstagramBlock(@"",error,@"User not Logged in",-1);
        }
        [self authenticationSuccess];
    }
    return YES;
}

- (void)authenticationSuccess
{
    //
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
