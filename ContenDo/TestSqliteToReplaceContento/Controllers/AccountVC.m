//
//  AccountVC.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "AccountVC.h"

@interface AccountVC ()

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVC];
    
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager showLoaderIn:self.view];
    [self.doneButton setBackgroundColor:THEME_INNER_BG_COLOR];
    [self.headerView setBackgroundColor:THEME_INNER_BG_COLOR];
    [sharedManager.user getRegisterUserProfile:^(NSString *str, int status) {
        if(status==1){            [sharedManager hideLoader];
            
            self.txtFirstName.text = sharedManager.user.firstName;
            self.txtCompany.text= [sharedManager.user.company stringByReplacingOccurrencesOfString:@"%20" withString:@" "];

            self.txtEmail.text = sharedManager.user.email;
            [self.txtEmail setEnabled:false];
            [self.txtEmail setTextColor:[UIColor lightGrayColor]];
            self.txtPassword.secureTextEntry=YES;
            
        }
        
        else{
            [Globals ShowAlertWithTitle:@"Error" Message:str ];
        }
    }];
}
-(void)initVC{
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [UIColor darkGrayColor].CGColor;
    border.frame = CGRectMake(0, self.txtFirstName.frame.size.height - borderWidth, self.txtFirstName.frame.size.width, self.txtFirstName.frame.size.height);
    border.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor darkGrayColor]);
    border.borderWidth = borderWidth;
    [self.view setBackgroundColor:THEME_INNER_BG_COLOR];
    [self.btnDone setBackgroundColor:THEME_INNER_BG_COLOR];
    
}
-(IBAction)btndone:(id)sender{
    BOOL isValid=true;
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    
    if ([Validations isEmpty:self.txtEmail.text] || ![Validations isValidEmail:self.txtEmail.text]) {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_EMAIL];
    }
    else if([Validations isEmpty:self.txtFirstName.text] || ![Validations isValidUnicodeName:self.txtFirstName.text]){
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_NAME];
    }

    if(isValid)
    {
        if([Validations isconnectedToInternet])
        {
            sharedManager.user.name=[self.txtFirstName.text mutableCopy];
            sharedManager.user.company=[self.txtCompany.text mutableCopy];
            sharedManager.user.email=[self.txtEmail.text mutableCopy];
            if(self.txtPassword.text.length>0)
                sharedManager.user.password=[self.txtPassword.text mutableCopy];
            [sharedManager showLoaderIn:self.view];
            
            [sharedManager.user updateRegisterUser:^(NSString *str, int status){
                if(status==1){
                    [sharedManager hideLoader];
                    
                    Globals *sharedManager;
                    sharedManager=[Globals sharedManager];
                    [sharedManager.user getRegisterUserProfile:^(NSString *msg, int status) {
                        if(sharedManager.user==nil)
                        {
                            sharedManager.user = [[Users alloc] init];
                        }
                        
                    }];
                    
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:SUCCESS_USER_UPDATE delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    self.txtPassword.text = @"";
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
                
                else{
                    [Globals ShowAlertWithTitle:@"Error" Message:str ];
                    self.txtPassword.text = @"";

                }
            }];
            
        }
        else{
            [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
            self.txtPassword.text = @"";

        }
    }
    
}
-(IBAction)btnclose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:true];
    [self.view endEditing:true];
}


@end
