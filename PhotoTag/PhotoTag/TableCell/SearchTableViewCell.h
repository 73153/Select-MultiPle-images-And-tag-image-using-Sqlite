//
//  SearchTableViewCell.h
//  PantryKart
//
//  Created by vivek on 1/27/16.
//  Copyright © 2016 vivek. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ImageWithURL.h"

@interface SearchTableViewCell : UITableViewCell

@property NSInteger numberOfProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTag;

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;


@end
