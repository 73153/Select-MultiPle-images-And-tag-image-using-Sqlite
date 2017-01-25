//
//  GalleryViewController.h
//  PhotoTag
//
//  Created by vivek on 4/21/16.
//  Copyright © 2016 vivek. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCell.h"
#import "SecondViewController.h"
#import <iAd/iAd.h>

@interface GalleryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    ADBannerView *advertiseBanner;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSync;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *photos;


+ (ALAssetsLibrary *)defaultAssetsLibrary;
- (IBAction)btnSyncImagePressed:(id)sender;
@end
