//
//  SecondViewController.m
//  PhotoTag
//
//  Created by vivek on 4/21/16.
//  Copyright © 2016 vivek. All rights reserved.
//
#import "SecondViewController.h"
#import "EditViewController.h"
#import "SearchViewController.h"
#import "AssetPicker.h"
#import "Globals.h"
#import "Constant.h"
#define IsPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define StatusBarHeight     ([UIApplication sharedApplication].statusBarHidden ? 0 : 20)
#define NavBarHeightFor(vc) (vc.navigationController.navigationBarHidden ? 0 : 44)


@interface SecondViewController ()<ADBannerViewDelegate>
{
    Globals *objGlobal;
}

@end

@implementation SecondViewController {
    BOOL _fullScreen;
    CGRect _scrollFrame;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if(advertiseBanner){
        [advertiseBanner setDelegate:nil];
        [advertiseBanner removeFromSuperview];
        advertiseBanner=nil;
        [advertiseBanner cancelBannerViewAction];
    }
    advertiseBanner = [[ADBannerView alloc] init];
    advertiseBanner.frame = CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 66);
    [self.view addSubview:advertiseBanner];
    advertiseBanner.delegate=self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _fullScreen=NO;
    objGlobal = [Globals sharedManager];
    [self initScrollWithImage];
    self.advertiseBanner.delegate=self;
    
    UILongPressGestureRecognizer *longPressRecognizer =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(fullScreen)];
    longPressRecognizer.minimumPressDuration = 1;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPressRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitFullSceen)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:tapRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_scrollView addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [_scrollView addGestureRecognizer:swipeGestureLeft];
}

- (void)initScrollWithImage{
    ALAsset *asset = _photos[_numberOfPhoto];
    ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
    UIImage*image=[UIImage imageWithCGImage:[defaultRep fullScreenImage]];
    
    [_imageView removeFromSuperview];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.frame = (CGRect){.origin=CGPointMake(0.0, 0.0), .size=image.size};
    _scrollView.contentSize = image.size;
    [_scrollView addSubview:_imageView];
    
    CGRect scrollViewFrame = _scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / _scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / _scrollView.contentSize.height;
    _scrollView.minimumZoomScale = MIN(scaleWidth, scaleHeight);
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.zoomScale = MIN(scaleWidth, scaleHeight);;
    [_scrollView zoomScale];
}



- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)swipeGesture
{
    [self prevPhoto:nil];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)swipeGesture
{
    [self nextPhoto:nil];
    
}


- (IBAction)prevPhoto:(id)sender {
    if (_numberOfPhoto>0) {
        _numberOfPhoto-=1;
        [self initScrollWithImage];
    }
}

- (IBAction)nextPhoto:(id)sender {
    if (_numberOfPhoto<[_photos count]-1) {
        _numberOfPhoto+=1;
        [self initScrollWithImage];
    }
}

- (void)fullScreen{
    if (!_fullScreen) {
        _scrollFrame=_scrollView.frame;
        _scrollView.frame = self.view.frame;
        _fullScreen=YES;
    }
}

- (void)exitFullSceen{
    if (_fullScreen) {
        _scrollView.frame=_scrollFrame;
        _fullScreen=NO;
    }
}

- (IBAction)zoomIn:(id)sender {
    CGFloat newZoomScale = _scrollView.zoomScale * 1.5f;
    _scrollView.zoomScale = MIN(newZoomScale, _scrollView.maximumZoomScale);
    [_scrollView zoomScale];
}

- (IBAction)zoomOut:(id)sender {
    CGFloat newZoomScale = _scrollView.zoomScale / 1.5f;
    _scrollView.zoomScale = MAX(newZoomScale, _scrollView.minimumZoomScale);
    [_scrollView zoomScale];
}

- (IBAction)editImage:(id)sender {
    EditViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditViewController"];
    controller.asset=_photos[_numberOfPhoto];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnSearchPressed:(id)sender {
    SearchViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnSelectMultipleImages:(id)sender {
    [AssetPicker showAssetPickerIn:self.navigationController
              maximumAllowedPhotos:10000
              maximumAllowedVideos:10000
                 completionHandler:^(AssetPicker* picker, NSArray* assets)
     {
         objGlobal.aryMultipleImage = [[NSMutableArray alloc] initWithArray:assets];
         NSLog(@"Assets --> %@", assets);
         
         // Do your stuff here
         
         // All done with the resources, let's reclaim disk memory
         [AssetPicker clearLocalCopiesForAssets];
     }
                     cancelHandler:^(AssetPicker* picker)
     {
         NSLog(@"Cancelled.");
     }];
    
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
    advertiseBanner.frame = CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 66);
    [self.view addSubview:advertiseBanner];
    advertiseBanner.delegate=self;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
