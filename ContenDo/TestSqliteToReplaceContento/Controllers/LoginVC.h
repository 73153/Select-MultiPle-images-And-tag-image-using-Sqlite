//
//  LoginVC.h
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 29/10/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"
#import "AppDelegate.h"
@class AppDelegate;
@interface LoginVC : UIViewController <UITextFieldDelegate>
@property  AppDelegate *app;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)onBtnSignUpTapped:(id)sender;
-(IBAction)linkedInLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewForLoin;
- (IBAction)onBtnForgotPasswordTapped:(id)sender;
@end
