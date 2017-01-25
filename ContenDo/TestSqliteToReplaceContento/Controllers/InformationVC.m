//
//  InformationVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 11/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "InformationVC.h"

@interface InformationVC ()

@end

@implementation InformationVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleLabel setText:self.titleStr];
    [self.headerView setBackgroundColor:THEME_BG_COLOR];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVC];
}


-(void) initVC
{
    if (self.content) {
        
        [self.webView loadHTMLString:[NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta      name='viewport' content='width=device-width' /> </head><body><style>#TestSqliteToReplaceContentoId{font-family :\"Lato\"!important; color: #171616; padding-left:15px!important;padding-right:15px!important; padding-top:10px; font-size:16px!important; }img {width:%fpx!important;padding:0!important;margin-left:-20px!important;margin-right:-15px!important;} h1 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h2 { font-family :\"Lato\"; font-size:24px; font-weight:500; } h3 { font-family :\"Lato\"; font-size:30px; font-weight:100; } .titles{ color:#656b6d}.authors{font-size:12px;text-transform: uppercase;color: #171616;}</style><body><div> %@ </div></body></html>", self.view.frame.size.width, self.content ] baseURL:nil];
    }
    
}

-(IBAction)btnclose:(id)sender{
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
