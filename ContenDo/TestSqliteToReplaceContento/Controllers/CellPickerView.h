//
//  CellPickerView.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 15/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellPickerView : UITableViewCell
@property IBOutlet UIPickerView *pickerView;
@property IBOutlet UIImageView *img;
@property BOOL isValid;
@end
