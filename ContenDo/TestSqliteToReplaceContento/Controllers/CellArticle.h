//
//  CellReadingList.h
//  TestSqliteToReplaceContento
//
//  Created by Aadil on 03/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellArticle : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *txtTitle;
@property (strong, nonatomic) IBOutlet UILabel *txtDesc;
@property (strong, nonatomic) IBOutlet UIButton *btnDigitalEnterprise;
@property (strong, nonatomic) IBOutlet UIImageView *imgContent,*videoIcon;
@property (strong,nonatomic) IBOutlet UIView *categoryView;
@property int heightForCategory;
@property BOOL canAnimate;
@property BOOL isCategoryPresent;
@property CGRect frameCat;
@end
