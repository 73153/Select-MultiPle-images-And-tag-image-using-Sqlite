//
//  SearchViewController.h
//  PhotoTag
//
//  Created by vivek on 4/22/16.
//  Copyright © 2016 vivek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SearchViewController : UIViewController
{
    ADBannerView *advertiseBanner;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblSearch;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchField;

@end
