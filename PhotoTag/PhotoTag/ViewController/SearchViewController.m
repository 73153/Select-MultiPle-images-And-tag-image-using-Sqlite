//
//  SearchViewController.m
//  PhotoTag
//
//  Created by vivek on 4/22/16.
//  Copyright © 2016 vivek. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "Globals.h"
#import "Base64.h"
#import "SecondViewController.h"
#import "AppDelegate.h"
#import "FMDBDataAccess.h"
#import "Constant.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ADBannerViewDelegate>
{
    NSArray *arySearchProduct;
    Globals *objGlobal;
    FMDBDataAccess *dbAccess;
}
@property (nonatomic, strong)NSMutableArray *results;
@property (nonatomic)BOOL isSearching;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    advertiseBanner.delegate=self;
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    _txtSearchField.delegate=self;
    
    objGlobal = [Globals sharedManager];
    dbAccess = [FMDBDataAccess new];
    objGlobal.aryGlobalSearchProduct = [NSMutableArray arrayWithArray:[dbAccess fetchAllGalleryDataFromLocalDB]];
    
    arySearchProduct = objGlobal.aryGlobalSearchProduct;
    [self.tableView reloadData];
    
    
    if(advertiseBanner){
        [advertiseBanner setDelegate:nil];
        [advertiseBanner removeFromSuperview];
        advertiseBanner=nil;
        [advertiseBanner cancelBannerViewAction];
    }
    advertiseBanner = [[ADBannerView alloc] init];
    advertiseBanner.frame = CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 66);
    [self.view addSubview:advertiseBanner];
    advertiseBanner.delegate=self;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    @try
    {
        SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil)
        {
            cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        [cell.subviews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[UIImageView class]])
                [obj removeFromSuperview];
            else if ([obj isKindOfClass:[UILabel class]])
                [obj removeFromSuperview];
        }];
        //        _imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
        NSDictionary *dictImageDetail;
        if(_isSearching)
        {
            dictImageDetail = [_results objectAtIndex:indexPath.row];
        }
        else{
            dictImageDetail = [arySearchProduct objectAtIndex:indexPath.row];
        }
        cell.imgProduct.image = [UIImage imageWithData:[Base64 decode:[dictImageDetail valueForKey:@"imagedata"]]];
        cell.lblName.text = [dictImageDetail valueForKey:@"name"];
        cell.lblDate.text = [dictImageDetail valueForKey:@"date"];
        cell.lblTag.text = [dictImageDetail valueForKey:@"tagadded"];
        
        return cell;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    if(_isSearching)
        return _results.count;
    return arySearchProduct.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    @try{
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        NSString *newString;
        
        if(newLength==0)
        {
            _isSearching = NO;
            newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            [self updateTextLabelsWithText:newString index:newLength];
            
            [_tableView reloadData];
            _lblSearch.hidden=true;
            
        }
        else{
            _isSearching = YES;
            _lblSearch.hidden=false;
            _results=nil;
            newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            [self updateTextLabelsWithText:newString index:newLength];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSArray *allControllersCopy = self.navigationController.viewControllers ;
    //
    //    for (id object in allControllersCopy) {
    //        if ([object isKindOfClass:[SecondViewController class]])
    //        {
    //
    //        }
    //    }
    SecondViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SecondViewController"];
    AppDelegate *delGate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
    controller.photos=delGate.photos;
    controller.numberOfPhoto=indexPath.row;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)updateTextLabelsWithText:(NSString *)string index:(NSInteger)index
{
    @try{
        NSMutableString* theString = [NSMutableString string];
        
        [theString appendString:string];
        
        _txtSearchField.text = theString;
        _results=nil;
        _results = [[NSMutableArray alloc] init];
        //            NSString * strSearchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"tagadded",[NSString stringWithFormat:@"%@",theString]];//keySelected is NSString itself
        NSArray *resultArray = [arySearchProduct filteredArrayUsingPredicate:predicateString] ;
        _lblSearch.hidden=false;
        
        _results = [resultArray mutableCopy];
        [_tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)txtSearchField:(id)sender {
}
@end
