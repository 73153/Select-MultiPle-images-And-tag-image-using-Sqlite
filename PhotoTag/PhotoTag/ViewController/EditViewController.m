//
//  EditViewController.m
//  PhotoTag
//
//  Created by vivek on 4/21/16.
//  Copyright © 2016 vivek. All rights reserved.
//

#import "EditViewController.h"
#import "Globals.h"
#import "FMDBDataAccess.h"
#import "Base64.h"
#import "Constant.h"
@interface EditViewController ()<UIAlertViewDelegate,ADBannerViewDelegate>
{
    Globals *objGlobal;
    FMDBDataAccess *dbAccess;
}

@end

@implementation EditViewController{
    CIContext *_context;
    CIFilter *_filter;
    CIImage *_beginImage;
    UIImageOrientation _orientation;
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
    advertiseBanner.frame = CGRectMake(0, SCREEN_HEIGHT-170, SCREEN_WIDTH, 66);
    [self.view addSubview:advertiseBanner];
    advertiseBanner.delegate=self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dbAccess = [FMDBDataAccess new];
    objGlobal = [Globals sharedManager];
    advertiseBanner.delegate=self;

    ALAssetRepresentation *defaultRep = [_asset defaultRepresentation];
    _orientation=UIImageOrientationUp;
    UIImage*image= [UIImage imageWithCGImage:[defaultRep fullScreenImage]];
    _imageView.image=image;
    _beginImage =[[CIImage alloc] initWithImage:image];
    _context = [CIContext contextWithOptions:nil];
    _filter = [CIFilter filterWithName:@"CISepiaTone"
                         keysAndValues: kCIInputImageKey, _beginImage,
               @"inputIntensity", @0.5, nil];
    //    _textField.text=[defaultRep filename];
    _textField.text=@"";
    _textField.placeholder=@"Enter tag";
    
    NSString *strUrl1 = [NSString stringWithFormat:@"%@",_asset.defaultRepresentation.url];
    
    NSArray *aryLocalDB =  [objGlobal.aryGlobalSearchProduct mutableCopy];
    [aryLocalDB enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
        
            if([str isEqualToString:strUrl1] ){
                _textField.text= [NSString stringWithFormat:@"%@",[obj valueForKey:@"tagadded"]];
                *stop=YES;
        }
       
    }];
}

- (IBAction)saveImage:(id)sender {
    [self.view endEditing:true];
    objGlobal.isImageSavedPressed=false;
    //    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    //    CIImage *saveToSave = [_filter outputImage];
    //    CGImageRef cgImage = [_context createCGImage:saveToSave
    //                                        fromRect:[saveToSave extent]];
    //    [library writeImageToSavedPhotosAlbum:cgImage
    //                              orientation:(ALAssetOrientation)_orientation
    //                          completionBlock:^(NSURL *assetURL, NSError *error )
    //     {
    //
    //     }];
    //    CGImageRelease(cgImage);
    
    NSString *strUrl1 = [NSString stringWithFormat:@"%@",_asset.defaultRepresentation.url];
    NSDate *dateForImage = [_asset valueForProperty:ALAssetPropertyDate];
    NSString *strdate = [NSString stringWithFormat:@"%@",dateForImage];
    NSString *strLocation = [_asset valueForProperty:ALAssetPropertyLocation];
    NSString *strImageName = [NSString stringWithFormat:@"%@",[[_asset defaultRepresentation] filename]];
    
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",_asset.defaultRepresentation.url.absoluteString];
    
    //                NSLog(@"The URL of the asset: %@", result.defaultRepresentation.url);
    
    // Get the original date time
    NSMutableDictionary *dictGallery = [[NSMutableDictionary alloc] init];
    
    UIImage *thumbnail = [UIImage imageWithCGImage:[_asset thumbnail]];
    NSData *data = UIImageJPEGRepresentation(thumbnail, 0);
    NSString *strImageData = [Base64 encode:data];
    if([self isNotNull:strUrl1])
        [dictGallery setObject:strUrl1 forKey:@"id"];
    
    if([self isNotNull:strUrl1])
        [dictGallery setObject:strImageName forKey:@"name"];
    
    if([self isNotNull:strdate])
        [dictGallery setObject:strdate forKey:@"date"];
    
    if([self isNotNull:strLocation])
        [dictGallery setObject:strLocation forKey:@"location"];
    
    if([self isNotNull:_textField.text])
        [dictGallery setObject:_textField.text forKey:@"tagadded"];
    
    if([self isNotNull:strImageData])
        [dictGallery setObject:strImageData forKey:@"imagedata"];
    
    if([self isNotNull:strUrl])
        [dictGallery setObject:strUrl forKey:@"imageurl"];
    UIAlertView *alert;
    if([dbAccess insertImagedData:dictGallery]){
        
        alert = [[UIAlertView alloc] initWithTitle:@"Database updated"
                                           message:@"Tag added to your image"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Ok", nil];
    }
    else{
        
        alert = [[UIAlertView alloc] initWithTitle:@"Database updated"
                                           message:@"Tag updated to your image"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Ok", nil];
        [dbAccess updateImagedData:dictGallery];
        
    }
    
    
    [alert show];
    
}

- (BOOL) isNull:(NSObject*) object {
    if (!object)
        return YES;
    else if (object == [NSNull null])
        return YES;
    else if ([object isKindOfClass: [NSString class]]) {
        return ([((NSString*)object) isEqualToString:@""]
                || [((NSString*)object) isEqualToString:@"null"]
                || [((NSString*)object) isEqualToString:@"nil"]
                || [((NSString*)object) isEqualToString:@"(null)"]
                || [((NSString*)object) isEqualToString:@"<null>"]);
    }
    return NO;
}

- (BOOL) isNotNull:(NSObject*) object {
    return ![self isNull:object];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    @try{
        if(!dbAccess)
            dbAccess=[[FMDBDataAccess alloc] init];
        objGlobal.aryGlobalSearchProduct = [NSMutableArray arrayWithArray:[dbAccess fetchAllGalleryDataFromLocalDB]];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
- (IBAction)sliderValueChanged:(id)sender {
    
    CIImage *outputImage = [_filter outputImage];
    CGImageRef cgImage = [_context createCGImage:outputImage
                                        fromRect:[outputImage extent]];
    _imageView.image = [UIImage imageWithCGImage:cgImage
                                           scale:1.0
                                     orientation: _orientation];
    CGImageRelease(cgImage);
}

- (IBAction)rotateLeft:(id)sender {
    switch(_orientation) {
        case UIImageOrientationLeft:
        {
            _orientation=UIImageOrientationDown;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: _orientation];
        }
            break;
        case UIImageOrientationRight:
        {
            _orientation=UIImageOrientationUp;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: UIImageOrientationDown];
        }
            break;
        case UIImageOrientationDown:
        {
            _orientation=UIImageOrientationRight;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: UIImageOrientationLeft];
        }
            break;
        default:
        {
            _orientation=UIImageOrientationLeft;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: UIImageOrientationRight];
        }
            _beginImage =[_beginImage initWithImage:_imageView.image];
    }
}

- (IBAction)rotateRight:(id)sender {
    switch(_orientation) {
        case UIImageOrientationLeft:
        {
            _orientation=UIImageOrientationUp;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: _orientation];
        }
            break;
        case UIImageOrientationRight:
        {
            _orientation=UIImageOrientationDown;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: UIImageOrientationDown];
        }
            break;
        case UIImageOrientationDown:
        {
            _orientation=UIImageOrientationLeft;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: UIImageOrientationLeft];
        }
            break;
        default:
        {
            _orientation=UIImageOrientationRight;
            _imageView.image = [UIImage imageWithCGImage:[_imageView.image CGImage]
                                                   scale:1.0
                                             orientation: UIImageOrientationRight];
        }
            _beginImage =[_beginImage initWithImage:_imageView.image];
    }
}

- (IBAction)changeFilter:(id)sender {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _filter = [CIFilter filterWithName:@"CISepiaTone"
                                 keysAndValues: kCIInputImageKey, _beginImage,
                       @"inputIntensity", @0.5, nil];
            _slider.userInteractionEnabled = YES;
            break;
        case 1:
            _filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"
                                 keysAndValues: kCIInputImageKey, _beginImage, nil];
            _slider.userInteractionEnabled = NO;
            break;
        case 2:
            _filter = [CIFilter filterWithName:@"CIColorInvert"
                                 keysAndValues: kCIInputImageKey, _beginImage, nil];
            _slider.userInteractionEnabled = NO;
            break;
        case 3:
            _filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"
                                 keysAndValues: kCIInputImageKey, _beginImage, nil];
            _slider.userInteractionEnabled = NO;
            break;
        case 4:
            _filter = [CIFilter filterWithName:@"CIPhotoEffectMono"
                                 keysAndValues: kCIInputImageKey, _beginImage, nil];
            _slider.userInteractionEnabled = NO;
            break;
        case 5:
            _filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"
                                 keysAndValues: kCIInputImageKey, _beginImage, nil];
            _slider.userInteractionEnabled = NO;
            break;
        default:
            break;
    }
    CIImage *outputImage = [_filter outputImage];
    CGImageRef cgImage = [_context createCGImage:outputImage
                                        fromRect:[outputImage extent]];
    _imageView.image = [UIImage imageWithCGImage:cgImage
                                           scale:1.0
                                     orientation: _orientation];
    CGImageRelease(cgImage);
}

- (IBAction)btnBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
