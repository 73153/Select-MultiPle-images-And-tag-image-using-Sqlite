//
//  ForgotPasswordVC.h
//  TestSqliteToReplaceContento
//
//  Created by vivek on 10/06/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnSignInPressed:(id)sender;
- (IBAction)btnBackTapped:(id)sender;
@end
