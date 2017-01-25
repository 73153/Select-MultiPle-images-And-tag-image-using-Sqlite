//
//  CellTextView.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 15/12/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTextView : UITableViewCell
@property IBOutlet UITextView *inputField;
@property IBOutlet UIImageView *img;
@property BOOL isValid;
@end
