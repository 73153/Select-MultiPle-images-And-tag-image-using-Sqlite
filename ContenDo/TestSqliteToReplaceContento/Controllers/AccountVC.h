//
//  AccountVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@interface AccountVC : UIViewController
@property IBOutlet UITextField *txtFirstName,*txtCompany, *txtEmail, *txtPassword;
-(IBAction)btnclose:(id)sender;
@property IBOutlet UIButton *btnDone;
@property IBOutlet UIView *headerView;
@property IBOutlet UIButton *doneButton;


@end
