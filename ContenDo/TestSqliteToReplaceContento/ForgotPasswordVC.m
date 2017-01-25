//
//  ForgotPasswordVC.m
//  TestSqliteToReplaceContento
//
//  Created by vivek on 10/06/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "Constants.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:THEME_BG_COLOR];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (IBAction)btnSignInPressed:(id)sender {
    BOOL isValid=true;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    if ([Validations isEmpty:self.txtEmail.text] || ![Validations isValidEmail:self.txtEmail.text]) {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_EMAIL];
    }
    
    
    if(isValid)
    {
        if([Validations isconnectedToInternet])
        {
            sharedManager.user.email=[self.txtEmail.text mutableCopy];
            [sharedManager showLoaderIn:self.view];
            
            [sharedManager.user authenticate:^(NSString *str, int status){
                
                if(status==1)
                {
                    
                    [sharedManager.user forgotPassword:^(NSString *str, int status){
                        if([str isEqualToString:@"Check your email id for further instructions"]){
                            [sharedManager hideLoader];
                            
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Check your email id for further instructions" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [alert show];
                        }
                        
                        else{
                            [sharedManager hideLoader];
                            
                            [Globals ShowAlertWithTitle:@"Failed" Message:str ];
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

- (IBAction)btnBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
