//
//  SecondViewController.h
//  PhotoTag
//
//  Created by vivek on 4/21/16.
//  Copyright © 2016 vivek. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <iAd/iAd.h>
@interface SecondViewController : UIViewController <UIScrollViewDelegate>
{
    ADBannerView *advertiseBanner;
}
@property(nonatomic, assign) NSArray *photos;
@property(nonatomic, assign) NSInteger numberOfPhoto;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ADBannerView *advertiseBanner;

- (IBAction)btnBackPressed:(id)sender;
- (IBAction)prevPhoto:(id)sender;
- (IBAction)nextPhoto:(id)sender;
- (IBAction)zoomOut:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)editImage:(id)sender;
- (IBAction)btnSearchPressed:(id)sender;
- (IBAction)btnSelectMultipleImages:(id)sender;

@end
