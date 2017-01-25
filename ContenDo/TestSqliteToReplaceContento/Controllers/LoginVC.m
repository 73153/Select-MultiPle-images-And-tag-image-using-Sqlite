//
//  LoginVC.m
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 29/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "LoginVC.h"
#import "SignupVC.h"
#import "AppDelegate.h"
#import <SlideNavigationController.h>
#import "Constants.h"
#import "DashboardVC.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "SocialLogin.h"
#import "ForgotPasswordVC.h"

@implementation LoginVC
-(void)viewDidLoad{
    //Forgot password button is set to hidden as it is not needed in this.
    [super viewDidLoad];
    
    [self.viewForLoin setBackgroundColor:THEME_BG_COLOR];
    [self.view setBackgroundColor:THEME_BG_COLOR];
    
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    
    if([Validations isconnectedToInternet])
    {
        sharedManager.isAllVideoReceived=false;
        sharedManager.isAllBlogsReceived=false;
        sharedManager.isAllAticleReceived=false;
    }
    
    sharedManager.intLimit=5;
    sharedManager.intOffset = 0;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:nil];
    __block DashboardVC *second=(DashboardVC *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
    
    NSString *tempLinkedIn = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsLinkedInLogin"];
    if(([tempLinkedIn isEqualToString:@"true"] ||  ([[NSUserDefaults standardUserDefaults] objectForKey:@"email"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) || ([[NSUserDefaults standardUserDefaults] objectForKey:@"IsLinkedInLogin"])))
        
    {
        
        if (([[NSUserDefaults standardUserDefaults] objectForKey:@"email"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"])){
            [self.txtEmail setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
            [self.txtPassword setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
        }
        [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
            second.articleListArray= [result mutableCopy];
            if(second.articleListArray.count>0)
                second.dashboardList= MArray;
            for (int i=0; i<[second.articleListArray count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[second.articleListArray objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                [second.dashboardList addObject:dic];
                
            }
            sharedManager.articleArray=[result mutableCopy];
            
            [second.tblView reloadData];
            [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                for (int i=0; i<[result1 count]; i++) {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                    [second.dashboardList addObject:dic];
                }
                [second.tblView reloadData];
            }];
            [sharedManager.sync getAllVideosWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                for (int i=0; i<[result1 count]; i++) {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Video"] forKeys:@[@"data",@"type"]];
                    [second.dashboardList addObject:dic];
                }
                [second.tblView reloadData];
            }];
            [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
                sharedManager.topicsArray = [result mutableCopy];
                [second.tblView reloadData];
            }];
            [second.tblView reloadData];
            
            [self pushToDahsBoard];
            
        }];
        
        return;
    }
    
    if ([tempLinkedIn isEqualToString:@"true"]){
        [self.txtEmail setText:@""];
        [self.txtPassword setText:@""];
        [self isAlreadyLinkedInLogin];
        return;
    }
    
    if (([[NSUserDefaults standardUserDefaults] objectForKey:@"email"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]) || ([[NSUserDefaults standardUserDefaults] objectForKey:@"IsLinkedInLogin"])) {
        [self.txtEmail setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
        [self.txtPassword setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
        [self onBtnLoginTapped:[UIButton new]];
    }
    [self.txtEmail setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtPassword addDoneOnKeyboardWithTarget:self action:@selector(onBtnLoginTapped:)];
    
}


-(void) getArticles{
    
    Globals    *sharedManager = [Globals sharedManager];
    sharedManager.intLimit=5;
    sharedManager.intOffset = 0;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:nil];
    __block DashboardVC *second=(DashboardVC *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
    
    
    // Checking for cached data
    // Getting List of Articles for particular channels
    if([Validations isconnectedToInternet] )
    {
        [sharedManager.sync fillChannelsWithCompletionBlock:^(NSString *str, int status) {
            
            if(status==1)
            {
                
                [sharedManager.sync getAllChannelsWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                    sharedManager.channelArray=[Channels parseArrayToObjectsWithArray:[result mutableCopy] ];
                    
                    
                    [sharedManager.sync fillArticlesWithCompletionBlock:^(id result,NSString *str, int status) {
                        
                    }];
                    
                    [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
                        //                    [sharedManager hideLoader];
                        second.articleListArray= [result mutableCopy];
                        if(second.articleListArray.count>0)
                            second.dashboardList= MArray;
                        for (int i=0; i<[second.articleListArray count]; i++) {
                            NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[second.articleListArray objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                            [second.dashboardList addObject:dic];
                            
                        }
                        sharedManager.articleArray=[result mutableCopy];
                        [sharedManager.sync fillPages:^(NSString *str, int status) {
                            if (status==1) {
                                [sharedManager.sync getAllPagesWithCompletionBlock:^(NSArray *result, NSString *str, int status) {
                                    if (status==1) {
                                    }
                                }];
                            }
                        }];
                        [second.tblView reloadData];
                        [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                            for (int i=0; i<[result1 count]; i++) {
                                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                                [second.dashboardList addObject:dic];
                            }
                            [second.tblView reloadData];
                        }];
                        [sharedManager.sync getAllVideosWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                            for (int i=0; i<[result1 count]; i++) {
                                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Video"] forKeys:@[@"data",@"type"]];
                                [second.dashboardList addObject:dic];
                            }
                            [second.tblView reloadData];
                            
                        }];
                        [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
                            sharedManager.topicsArray = [result mutableCopy];
                            [second.tblView reloadData];
                        }];
                        
                    }];
                    [self performSelector:@selector(pushToDahsBoard)
                               withObject: nil
                               afterDelay:1];
                }];
            }
            else{
                second.dashboardList=MArray;
                [second.tblView reloadData];
                //                [sharedManager hideLoader];
                [Globals ShowAlertWithTitle:@"Error" Message:str];
            }
        }];
        [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
            sharedManager.topicsArray = [result mutableCopy];
            [second.tblView reloadData];
        }];
    }
    else{
        
        [sharedManager.sync getFilterArticlesWithCompletionBlock:^(NSArray *result,NSString *str, int status) {
            second.articleListArray= [result mutableCopy];
            if(second.articleListArray.count>0)
                second.dashboardList= MArray;
            for (int i=0; i<[second.articleListArray count]; i++) {
                NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[second.articleListArray objectAtIndex:i],@"Articles"] forKeys:@[@"data",@"type"]];
                [second.dashboardList addObject:dic];
                
            }
            sharedManager.articleArray=[result mutableCopy];
            
            [second.tblView reloadData];
            [sharedManager.sync getAllBlogsWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                for (int i=0; i<[result1 count]; i++) {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Blog"] forKeys:@[@"data",@"type"]];
                    [second.dashboardList addObject:dic];
                }
                [second.tblView reloadData];
            }];
            [sharedManager.sync getAllVideosWithCompletionBlock:^(NSArray *result1, NSString *str, int status) {
                for (int i=0; i<[result1 count]; i++) {
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjects:@[[result1 objectAtIndex:i],@"Video"] forKeys:@[@"data",@"type"]];
                    [second.dashboardList addObject:dic];
                }
                [second.tblView reloadData];
            }];
            [sharedManager.sync getAllTags:^(NSArray *result, NSString *str, int status) {
                sharedManager.topicsArray = [result mutableCopy];
                [second.tblView reloadData];
            }];
            [self pushToDahsBoard];
            
            
            
        }];
        
        [second.tblView reloadData];
        
        //        [sharedManager hideLoader];
    }
    
}

-(void)pushToDahsBoard
{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [sharedManager hideLoader];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:nil];
        DashboardVC *second=(DashboardVC *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
        
        [[SlideNavigationController sharedInstance] pushViewController:second animated:YES];
    });
    
    
    
    
}
- (IBAction)onBtnSignUpTapped:(id)sender  {
    [self.view endEditing:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:nil];
    SignupVC *second=(SignupVC *)[storyboard instantiateViewControllerWithIdentifier:@"SignupVC"];
    [[SlideNavigationController sharedInstance] pushViewController:second animated:YES];
}

- (IBAction)onBtnForgotPasswordTapped:(id)sender  {
    [self.view endEditing:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:nil];
    ForgotPasswordVC *second=(ForgotPasswordVC *)[storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [[SlideNavigationController sharedInstance] pushViewController:second animated:YES];
}



- (IBAction)onBtnLoginTapped:(id)sender  {
    [self.view endEditing:YES];
    BOOL isValid=true;
    
    if(![Validations checkMinLength:self.txtEmail.text withLimit:3 ] || ![Validations isValidEmail:self.txtEmail.text ]  )
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_EMAIL];
    }
    else if(![Validations checkMinLength:self.txtPassword.text withLimit:6 ] )
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_PASSWORD];
    }
    if (isValid) {
        if([Validations isconnectedToInternet])
        {
            Globals *sharedManager;
            sharedManager=[Globals sharedManager];
            sharedManager.isFromLink=NO;
            sharedManager.user.email=[self.txtEmail.text mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:self.txtEmail.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:self.txtPassword.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsLinkedInLogin"];
            
            AppDelegate *app= (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if(![[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:app.deviceTokens forKey:@"deviceToken"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            sharedManager.user.password=[self.txtPassword.text mutableCopy];
            [sharedManager showLoader];
            [sharedManager.user authenticate:^(NSString *str, int status){
                
                if(status==1)
                {
                    [sharedManager.user loginUser:^(NSString *str, int status){
                        
                        if(status==1){
                            
                            [self getFirstFiveRecordsForChannels];
                        }
                        else{
                            [sharedManager hideLoader];
                            [Globals ShowAlertWithTitle:@"Error" Message:str];
                        }
                    }];
                }
                else{
                    [sharedManager hideLoader];
                    [Globals ShowAlertWithTitle:@"Error" Message:str ];
                }
            }];
        }
        else{
            
            [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
        }
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:false];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self.txtEmail setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtPassword addDoneOnKeyboardWithTarget:self action:@selector(onBtnLoginTapped:)];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:false];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==self.txtEmail) {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, -50, self.view.frame.size.width, self.view.frame.size.height)];
    }
    if (textField==self.txtPassword) {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, -50, self.view.frame.size.width, self.view.frame.size.height)];
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}



//Pradip changes
#pragma LinkedInSignUp


-(IBAction)linkedInLogin:(id)sender{
    self.app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.app.social=[[SocialLogin alloc] initWithSocialType:socialTypeLinkedInn];
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    sharedManager.isFromLink=YES;
    
    if(self.app.social.socialType == socialTypeLinkedInn)
    {
        if([Validations isconnectedToInternet]){
            [self.app.social loginWithLinkedInn:^(id result, NSError *error, NSString *msg, int status)
             {
                 if(status == 1)
                 {
                     if([Validations isconnectedToInternet])
                     {
                         [sharedManager.user authenticate:^(NSString *str, int status){
                             [sharedManager showLoader];
                             if(sharedManager.user==nil)
                             {
                                 sharedManager.user = [[Users alloc] init];
                             }
                             sharedManager.linkedToken = [result valueForKey:@"id"];
                             sharedManager.user.firstName=[[[ NSString stringWithFormat:@"%@",[result valueForKey:@"firstName"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
                             sharedManager.user.lastName= [[[ NSString stringWithFormat:@"%@",[result valueForKey:@"lastName"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
                             sharedManager.user.company=[@"" mutableCopy];
                             sharedManager.user.website=[@"" mutableCopy];
                             sharedManager.user.email= [result valueForKey:@"emailAddress"];
                             sharedManager.user.jobtitle=[@"" mutableCopy];
                             sharedManager.user.phonenumber=[@"" mutableCopy];
                             sharedManager.user.password=[@"" mutableCopy];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
                             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
                             
                             
                             [[NSUserDefaults standardUserDefaults] setObject:sharedManager.user.firstName forKey:@"userFirstName"];
                             [[NSUserDefaults standardUserDefaults] setObject:sharedManager.user.lastName forKey:@"userLastName"];
                             
                             [[NSUserDefaults standardUserDefaults] setObject:sharedManager.linkedToken forKey:@"linkedToken"];
                             
                             [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"IsLinkedInLogin"];
                             
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             [sharedManager.user oauth:^(NSString *str, int status){
                                 if(status==1)
                                 {
                                     [sharedManager.user getRegisterUserProfile:^(NSString *msg, int status) {
                                         
                                         if(status ==1)
                                             
                                         {
                                             [self getFirstFiveRecordsForChannels];
                                             
                                         }
                                         if(sharedManager.user==nil)
                                         {
                                             sharedManager.user = [[Users alloc] init];
                                         }
                                         
                                     }];
                                     
                                 }
                                 else{
                                     [sharedManager showLoaderIn:self.view];
                                     [sharedManager.user registerUserWithoauthResponse:^(NSString *str, int status){
                                         if(status==1){
                                             //                                         [sharedManager hideLoader];
                                             
                                             [sharedManager.user oauth:^(NSString *str, int status){
                                                 if(status==1)
                                                 {
                                                     [sharedManager.user getRegisterUserProfile:^(NSString *msg, int status) {
                                                         
                                                         if(status ==1)
                                                             
                                                         {
                                                             [self getFirstFiveRecordsForChannels];
                                                             
                                                         }
                                                         if(sharedManager.user==nil)
                                                         {
                                                             sharedManager.user = [[Users alloc] init];
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
                                         else
                                         {
                                             [sharedManager hideLoader];
                                             [Globals ShowAlertWithTitle:@"Error" Message:str];
                                         }
                                     }];
                                 }
                             }]; }];
                     }
                     else{
                         
                         [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
                     }
                     
                 }
                 else{
                     [Globals ShowAlertWithTitle:@"Error" Message:@"Could not connect to LinkedIn"];
                 }
             }];
        }else{
            [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
        }
        
    }
}
-(void)isAlreadyLinkedInLogin{
    
    Globals *sharedManager = [Globals sharedManager];
    
    sharedManager.user.email =   [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    
    sharedManager.user.firstName=  [[NSUserDefaults standardUserDefaults] valueForKey:@"userFirstName"];
    
    sharedManager.user.lastName= [[NSUserDefaults standardUserDefaults] valueForKey:@"userLastName"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"IsLinkedInLogin"];
    
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([Validations isconnectedToInternet]){
        
        [sharedManager.user authenticate:^(NSString *str, int status){
            
            [sharedManager showLoader];
            
            if(status==1)
                
            {
                [sharedManager.user oauth:^(NSString *str, int status){
                    if(status==1)
                    {
                        [sharedManager.user getRegisterUserProfile:^(NSString *msg, int status) {
                            
                            if(status ==1)
                                
                            {
                                [self getFirstFiveRecordsForChannels];
                                
                            }
                            if(sharedManager.user==nil)
                            {
                                sharedManager.user = [[Users alloc] init];
                            }
                            
                        }];
                        
                    }
                    else{
                        
                        [sharedManager showLoaderIn:self.view];
                        
                        [sharedManager.user registerUserWithoauthResponse:^(NSString *str, int status){
                            
                            if(status==1){
                                
                                [sharedManager.user oauth:^(NSString *str, int status){
                                    if(status==1)
                                    {
                                        [sharedManager.user getRegisterUserProfile:^(NSString *msg, int status) {
                                            
                                            if(status ==1)
                                                
                                            {
                                                [self getFirstFiveRecordsForChannels];
                                            }
                                            if(sharedManager.user==nil)
                                            {
                                                sharedManager.user = [[Users alloc] init];
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
                            else
                            {
                                [sharedManager hideLoader];
                                [Globals ShowAlertWithTitle:@"Error" Message:str];
                            }
                        }];
                    }
                }];
            }
            else{
                
                [sharedManager hideLoader];
                
                [Globals ShowAlertWithTitle:@"Error" Message:str ];
                
            }
            
        }];
    }
    else{
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
    }
}

-(void)getFirstFiveRecordsForChannels
{
    Globals *sharedManager = [Globals sharedManager];
    if(sharedManager.articleArray.count>0 || sharedManager.blogsArray.count>0)
        
    {
        [self pushToDahsBoard];
    }
    else{
        [self getArticles];
    }
    
}



@end
