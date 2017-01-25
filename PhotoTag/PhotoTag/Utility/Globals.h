//
//  Globals.h
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Globals : NSObject
+ (id)sharedManager;
//@property Video *video;
@property NSMutableArray *users, *aryKartDataGlobal, *aryGlobalSearchProduct, *arrPaypalData,*aryFavoriteListGlobal;
@property NSMutableArray *aryMultipleImage;
@property NSMutableString *cat_id_LeftSideDashBoard;
@property   NSInteger selectedIndexPathForRightMenu;
@property NSDictionary *dictLastKartProduct;
@property NSMutableString *strEmailId;
@property BOOL isImageSavedPressed;

- (BOOL) isNotNull:(NSObject*) object;

-(NSMutableString*)checkForFlagEditOrUpdate:(NSArray*)aryKartitems dictForItemToCheck:(NSDictionary*)dictForItemToCheck;

-(void)setNavigationTitleAndBGImageName:(NSString *)strImageName navigationController:(UINavigationController *)navigationController;
-(void)setTextFieldWithSpace:(UITextField*)txtField;

-(NSString*)maxDigitsInString:(NSString*)str;

-(NSArray*)sortArrayUsingKey:(NSArray*)aryToSort strKey:(NSString*)strKey;
-(void)makeTextFieldBorderRed:(UITextField*)textFieldForRedBorder;
-(void)makeTextFieldNormal:(UITextField*)textFieldForNormal;
@end
