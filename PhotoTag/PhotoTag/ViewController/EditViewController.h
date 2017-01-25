//
//  EditViewController.h
//  PhotoTag
//
//  Created by vivek on 4/21/16.
//  Copyright © 2016 vivek. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GalleryViewController.h"
#import <iAd/iAd.h>
@interface EditViewController : UIViewController
{
    ADBannerView *advertiseBanner;
}
@property (assign, nonatomic) ALAsset *asset;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)saveImage:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)rotateLeft:(id)sender;
- (IBAction)rotateRight:(id)sender;
- (IBAction)changeFilter:(id)sender;
- (IBAction)btnBackPressed:(id)sender;

@end
