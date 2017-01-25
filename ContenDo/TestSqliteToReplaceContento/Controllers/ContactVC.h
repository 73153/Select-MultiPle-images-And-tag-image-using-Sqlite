//
//  ContactVC.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 15/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CellTextField.h"
#import "CellTextView.h"
#import "CellPickerView.h"
@interface ContactVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextViewDelegate>
@property NSString *titleStr;
@property IBOutlet UILabel *titleLabel;
@property IBOutlet UITableView *tableView;
@property NSMutableArray *sectionArray, *textFieldArray, *pickerArray, *textViewArray;
@property IBOutlet UIView *headerView;


@property IBOutlet UIButton *doneButton;
@end
