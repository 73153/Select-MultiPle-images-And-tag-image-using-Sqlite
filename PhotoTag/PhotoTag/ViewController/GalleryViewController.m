//
//  GalleryViewController.m
//  PhotoTag
//
//  Created by vivek on 4/21/16.
//  Copyright © 2016 vivek. All rights reserved.
//
#import "GalleryViewController.h"
#import "FMDBDataAccess.h"
#import <CoreLocation/CoreLocation.h>
#import "Base64.h"
#import "ApplicationData.h"
#import "Globals.h"

@interface GalleryViewController ()<ADBannerViewDelegate>
{
    FMDBDataAccess *dbAccess;
    Globals *objGlobal;
}
@end

@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dbAccess = [FMDBDataAccess new];
    [self.collectionView setHidden:true];
    objGlobal = [Globals sharedManager];
    objGlobal.isImageSavedPressed=false;
    advertiseBanner.delegate=self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if(objGlobal.isImageSavedPressed){
        objGlobal.isImageSavedPressed=false;
        [self.collectionView setHidden:true];
        [self.btnSync setHidden:false];
    }
    if(advertiseBanner){
        [advertiseBanner setDelegate:nil];
        [advertiseBanner removeFromSuperview];
        advertiseBanner=nil;
        [advertiseBanner cancelBannerViewAction];
    }
    advertiseBanner = [[ADBannerView alloc] init];
    advertiseBanner.frame = CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 66);
    [self.collectionView addSubview:advertiseBanner];
    advertiseBanner.delegate=self;
    
    
}

-(BOOL)isImageInLocalDB:(NSString*)strImgaeDetail aryTotalImage:(NSArray*)aryTotalImage
{
    __block BOOL isImageAdded=false;
    
    NSString *strImageCheckingPresent = strImgaeDetail;
    if(strImageCheckingPresent.length>0){
        [aryTotalImage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block NSString *strImageId;
            strImageId = [obj valueForKey:@"id"];
            if([strImageCheckingPresent isEqualToString:strImageId])
            {
                isImageAdded=true;
                *stop=YES;
                return;
            }
        }];
    }
    
    return isImageAdded;
}


+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (IBAction)btnSyncImagePressed:(id)sender {
    NSMutableArray *aryGalleryDataFromLocalDB = [NSMutableArray arrayWithArray:[dbAccess fetchAllGalleryDataFromLocalDB]];
    NSMutableDictionary *dictGallery = [[NSMutableDictionary alloc] init];
    objGlobal.aryGlobalSearchProduct = [NSMutableArray arrayWithArray:aryGalleryDataFromLocalDB];
    __block NSMutableArray *tmpAssets = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    [APPDATA showLoader];
    ALAssetsLibrary *assetsLibrary = [GalleryViewController defaultAssetsLibrary];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                [tmpAssets addObject:result];
                //                NSDictionary *dictPhotoDetal = result.defaultRepresentation.metadata;
                //                NSLog(@"Photo Detail %@",dictPhotoDetal);
                NSString *strUrl1 = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url];
                
                NSDate *dateForImage = [result valueForProperty:ALAssetPropertyDate];
                NSString *strdate = [NSString stringWithFormat:@"%@",dateForImage];
                NSString *strLocation = [NSString stringWithFormat:@"%@",[result valueForProperty: ALAssetPropertyLocation]];
                NSString *strImageName = [NSString stringWithFormat:@"%@",[[result defaultRepresentation] filename]];
                NSString *strUrl = [NSString stringWithFormat:@"%@",result.defaultRepresentation.url.absoluteString];
                
                //                NSLog(@"The URL of the asset: %@", result.defaultRepresentation.url);
                
                // Get the original date time
                
                UIImage *thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                NSData *data = UIImageJPEGRepresentation(thumbnail, 0);
                NSString *strImageData = [Base64 encode:data];
                [dictGallery setObject:strUrl1 forKey:@"id"];
                [dictGallery setObject:strImageName forKey:@"name"];
                [dictGallery setObject:strdate forKey:@"date"];
                [dictGallery setObject:strLocation forKey:@"location"];
                [dictGallery setObject:@"" forKey:@"tagadded"];
                [dictGallery setObject:strImageData forKey:@"imagedata"];
                [dictGallery setObject:strUrl forKey:@"imageurl"];
                if([self isImageInLocalDB:strUrl1 aryTotalImage:aryGalleryDataFromLocalDB]){
                    
                }else{
                    [dbAccess insertImagedData:dictGallery];
                }
            }
        }];
        
        objGlobal.aryGlobalSearchProduct = [NSMutableArray arrayWithArray:[dbAccess fetchAllGalleryDataFromLocalDB]];
        
        AppDelegate *delGate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delGate.photos = [[NSArray alloc] initWithArray:tmpAssets];
        _photos = [[NSArray alloc] initWithArray:tmpAssets];
        [self.collectionView setHidden:false];
        [self.btnSync setHidden:true];
        [_collectionView reloadData];
        
        if(advertiseBanner){
            [advertiseBanner setDelegate:nil];
            [advertiseBanner removeFromSuperview];
            advertiseBanner=nil;
            [advertiseBanner cancelBannerViewAction];
        }
        advertiseBanner = [[ADBannerView alloc] init];
        advertiseBanner.frame = CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 66);
        [self.collectionView addSubview:advertiseBanner];
        advertiseBanner.delegate=self;
        [APPDATA hideLoader];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photos.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    ALAsset *asset = _photos[indexPath.row];
    cell.asset = asset;
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondViewController"];
    controller.photos=_photos;
    controller.numberOfPhoto=indexPath.row;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - ADBannerView Proxy method
//Advertising will load
- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
    NSLog(@"Advertising will load");
}
//Ads load is complete
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Ads load is complete");
}
//Before clicking Banner after leaving, returns NO is not full-screen ads expand
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"Before clicking Banner after leaving, returns NO is not full-screen ads expand.");
    return YES;
}

//Click the banner after the full-screen display, after close calls
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"Click the banner after the full-screen display, after close calls");
}
//Get ad Failed
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Get ad Failed.");
    advertiseBanner.hidden=YES;
    if(advertiseBanner){
        [advertiseBanner setDelegate:nil];
        [advertiseBanner removeFromSuperview];
        advertiseBanner=nil;
        [advertiseBanner cancelBannerViewAction];
    }
    advertiseBanner = [[ADBannerView alloc] init];
    advertiseBanner.frame = CGRectMake(0, SCREEN_HEIGHT-180, SCREEN_WIDTH, 66);
    [self.view addSubview:advertiseBanner];
    advertiseBanner.delegate=self;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
