//
//  SettingsVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 11/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileSection=[NSArray arrayWithObjects:@"Edit your topics",@"Edit your account",@"Sign out", nil] ;
    self.generalSection=[NSArray arrayWithObjects:@"Contact Thomas Cook",@"About Thomas Cook",@"Privacy policy",@"Terms of use", nil];
    
    [self.headerView setBackgroundColor:THEME_INNER_BG_COLOR];
    [self.footerBrandingLabel setTextColor:THEME_BG_COLOR];
    [self.footerBrandingLabel setText:THEME_NAME];
}

#pragma mark UITableView Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"Profile";
    }
    else{
        return @"General";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return [self.profileSection count];
    }
    else if (section==1){
        return [self.generalSection count];
    }
    else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell1=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (indexPath.section==0) {
        [cell1.textLabel setText:[self.profileSection objectAtIndex:indexPath.row]];
    }
    else if (indexPath.section==1){
        [cell1.textLabel setText:[self.generalSection objectAtIndex:indexPath.row]];
    }
    else{
        
    }
    return cell1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if ([[self.profileSection objectAtIndex:indexPath.row] isEqualToString:@"Edit your topics"]) {
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TopicsVC *topic=[story instantiateViewControllerWithIdentifier:@"TopicsVC"];
            [self presentViewController:topic animated:YES completion:^{
                //
            }];
        }
        else if ([[self.profileSection objectAtIndex:indexPath.row] isEqualToString:@"Edit your account"]){
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AccountVC *account=[story instantiateViewControllerWithIdentifier:@"AccountVC"];
            [self presentViewController:account animated:YES completion:^{
                //
            }];
            
        }
        else if ([[self.profileSection objectAtIndex:indexPath.row] isEqualToString:@"Sign out"]){
            Globals *sharedManager=[Globals sharedManager];
            sharedManager.isAlreadyLoggedIn=true;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsLinkedInLogin"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
            
            sharedManager.isAllBlogsReceived=false;
            sharedManager.isAllVideoReceived=false;
            sharedManager.isAllAticleReceived=false;
            
            sharedManager.addObj=false;
            sharedManager.uploadV=false;
            sharedManager.isAccepted=false;
            sharedManager.channelArray=MArray;
            sharedManager.articleArray=MArray;
            sharedManager.videosArray=MArray;
            sharedManager.relatedUDIDs=MArray;
            sharedManager.readingListArray=MArray;
            sharedManager.topicsArray=MArray;
            sharedManager.categoryArray=MArray;
            sharedManager.updatedChannelArray=MArray;
            sharedManager.updatedArticleArray=MArray;
            sharedManager.updatedBlogsArray=MArray;
            sharedManager.pagesArray=MArray;
            sharedManager.aryAllChannels=MArray;
            sharedManager.updatedPageArray=MArray;
            sharedManager.dictChannelDataCount = [[NSMutableDictionary alloc] init];
            sharedManager.intLimit = 5;
            sharedManager.intOffset = 0;
            for(UIViewController * viewController in [SlideNavigationController sharedInstance].viewControllers){
                if([viewController isKindOfClass:[LoginVC class]]){
                    LoginVC * second=(LoginVC *)viewController;
                    second.txtEmail.text = @"";
                    second.txtPassword.text = @"";
                    break;
                }
            }
            
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:NO];
        }
    }
    else if (indexPath.section==1)
    {
        if ([[self.generalSection objectAtIndex:indexPath.row] isEqualToString:@"Contact Thomas Cook"]) {
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ContactVC *contact=[story instantiateViewControllerWithIdentifier:@"ContactVC"];
            contact.title=@"Contact Thomas Cook";
            [[SlideNavigationController sharedInstance] presentViewController:contact animated:YES completion:^{
                //
            }];
        }
        else if ([[self.generalSection objectAtIndex:indexPath.row] isEqualToString:@"About Thomas Cook"]){
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InformationVC *info=[story instantiateViewControllerWithIdentifier:@"InformationVC"];
            info.title=@"About Thomas Cook";
            Globals *sharedManager=[Globals sharedManager];
            for (int i=0; i<[sharedManager.pagesArray count]; i++) {
                if ([[sharedManager.pagesArray objectAtIndex:i] pageType] == AboutUs) {
                    info.content=[[sharedManager.pagesArray objectAtIndex:i] desc];
                    
                }
            }
            
            [[SlideNavigationController sharedInstance] pushViewController:info animated:YES];
        }
        else if ([[self.generalSection objectAtIndex:indexPath.row] isEqualToString:@"Privacy policy"]){
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InformationVC *info=[story instantiateViewControllerWithIdentifier:@"InformationVC"];
            info.title=@"Privacy Policy";
            Globals *sharedManager=[Globals sharedManager];
            for (int i=0; i<[sharedManager.pagesArray count]; i++) {
                if ([[sharedManager.pagesArray objectAtIndex:i] pageType] == PrivacyPolicy) {
                    info.content=[[sharedManager.pagesArray objectAtIndex:i] desc];
                    
                }
            }
            [[SlideNavigationController sharedInstance] pushViewController:info animated:YES];
        }
        else if ([[self.generalSection objectAtIndex:indexPath.row] isEqualToString:@"Terms of use"]){
            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            InformationVC *info=[story instantiateViewControllerWithIdentifier:@"InformationVC"];
            info.title=@"Terms of Use";
            Globals *sharedManager=[Globals sharedManager];
            for (int i=0; i<[sharedManager.pagesArray count]; i++) {
                if ([[sharedManager.pagesArray objectAtIndex:i] pageType] == Terms) {
                    info.content=[[sharedManager.pagesArray objectAtIndex:i] desc];
                    
                }
            }
            
            [[SlideNavigationController sharedInstance] pushViewController:info animated:YES];
        }
    }
}
-(IBAction)btnclose:(id)sender{
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
