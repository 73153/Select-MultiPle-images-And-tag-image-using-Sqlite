//
//  SignupVC.m
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 29/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "SignupVC.h"
#import "Globals.h"

@implementation SignupVC
@synthesize txtEmail,txtName,txtCompany,txtConfirmPassword,txtJobTitle,txtPassword,txtPhoneNumber,txtWebsite;
-(void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:THEME_BG_COLOR];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
    txtEmail.delegate=self;
    txtName.delegate=self;
    txtCompany.delegate=self;
    txtConfirmPassword.delegate=self;
    txtJobTitle.delegate=self;
    txtPassword.delegate=self;
    txtPhoneNumber.delegate=self;
    txtWebsite.delegate=self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(IBAction)btnSignupTapped:(id)sender{
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    BOOL isValid=true;
    if(![Validations checkMinLength:self.txtName.text withLimit:3 ] || ![Validations isValidUnicodeName:self.txtName.text])
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_NAME];
    }
    
    else if(![Validations isValidEmail:self.txtEmail.text ] || ![Validations checkMinLength:self.txtEmail.text withLimit:3 ])
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_EMAIL];
    }
    
    else if(![Validations checkMinLength:self.txtPassword.text withLimit:8 ] )
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_PASSWORD];
    }
    else if(![Validations checkMinLength:self.txtConfirmPassword.text withLimit:8 ] || ![Validations checkEqual:self.txtPassword.text withField:self.txtConfirmPassword.text])
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_CONFIRM_PASSWORD];
    }
    else if([self.txtPassword.text containsString:@" "])
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_SPACEALLOWED];
    }
    else if([self.txtConfirmPassword.text containsString:@" "])
    {
        isValid=false;
        [Globals ShowAlertWithTitle:@"Error" Message:ERROR_SPACEALLOWED];
    }
    if(isValid)
    {
        if([Validations isconnectedToInternet])
        {
            sharedManager.user.firstName=[self.txtName.text mutableCopy];
            sharedManager.user.lastName=[self.txtLastName.text mutableCopy];
            sharedManager.user.company=[self.txtCompany.text mutableCopy];
            sharedManager.user.website=[self.txtWebsite.text mutableCopy];
            sharedManager.user.email=[self.txtEmail.text mutableCopy];
            sharedManager.user.jobtitle=[self.txtJobTitle.text mutableCopy];
            sharedManager.user.phonenumber=[self.txtPhoneNumber.text mutableCopy];
            sharedManager.user.password=[self.txtPassword.text mutableCopy];
            [sharedManager showLoaderIn:self.view];
            [sharedManager.user authenticate:^(NSString *str, int status){
                [sharedManager hideLoader];
                if(status==1)
                {
                    [sharedManager.user registerUser:^(NSString *str, int status){
                        if(status==1){
                            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:SUCCESS_USER_REGISTRATION delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [alert show];
                        }
                        
                        else{
                            [Globals ShowAlertWithTitle:@"Error" Message:str ];
                        }
                    }];
                }
                
                else{
                    [Globals ShowAlertWithTitle:@"Error" Message:str ];
                }
            }];
        }
        else{
            [Globals ShowAlertWithTitle:@"Error" Message:ERROR_INTERNET];
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == txtPassword)
    {
        if ([string isEqualToString:@" "] )
        {
            return NO;
        }
    }
    if (textField == txtConfirmPassword)
    {
        if ([string isEqualToString:@" "] )
        {
            return NO;
        }
    }
    if (textField == txtEmail)
    {
        if ([string isEqualToString:@" "] )
        {
            return NO;
        }
    }
    return YES;
}
-(void)insertNewUserToLocalDatabase:(BOOL)IsAdded
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:txtName.text forKey:@"sFirstName"];
    [dict setValue:txtCompany.text forKey:@"sLastName"];
    [dict setValue:txtEmail.text forKey:@"sEmail"];
    [dict setValue:txtPassword.text forKey:@"password"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"SlideNavigationControllerDidOpen"
                                               object:nil];
}
- (IBAction)btnBackTapped:(id)sender {
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}
-(void)receiveTestNotification:(id)result{
    
}
@end
