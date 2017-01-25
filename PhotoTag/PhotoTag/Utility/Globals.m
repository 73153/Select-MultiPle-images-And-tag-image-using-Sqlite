//
//  Globals.m
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import "Globals.h"


@implementation Globals
+ (id)sharedManager {
    static Globals *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.aryMultipleImage = [[NSMutableArray alloc] init];
       self.aryKartDataGlobal = [[NSMutableArray alloc] init];
       }
    return self;
}


-(void)setNavigationTitleAndBGImageName:(NSString *)strImageName navigationController:(UINavigationController *)navigationController
{
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:strImageName] forBarMetrics:UIBarMetricsDefault];
    
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


-(void)makeTextFieldBorderRed:(UITextField*)textFieldForRedBorder
{
    textFieldForRedBorder.layer.cornerRadius=8.0f;
    textFieldForRedBorder.layer.masksToBounds=YES;
    textFieldForRedBorder.layer.borderColor=[[UIColor redColor]CGColor];
    textFieldForRedBorder.layer.borderWidth= 1.0f;
}

-(void)makeTextFieldNormal:(UITextField*)textFieldForNormal
{
    textFieldForNormal.layer.cornerRadius=1.0f;
    textFieldForNormal.layer.masksToBounds=YES;
    textFieldForNormal.layer.borderColor=[[UIColor clearColor]CGColor];
    textFieldForNormal.layer.borderWidth= 1.0f;
}

- (BOOL) isNotNull:(NSObject*) object {
    return ![self isNull:object];
}


-(NSArray*)sortArrayUsingKey:(NSArray*)aryToSort strKey:(NSString*)strKey;
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:strKey
                                        ascending:YES
                                        selector:@selector(compare:)];
    
    //IF WANT TO SORT WITH OTHER KEYS VIVEK
    //                    NSSortDescriptor *modelDescriptor = [NSSortDescriptor
    //                                                         sortDescriptorWithKey:@"model"
    //                                                         ascending:YES
    //                                                         selector:@selector(caseInsensitiveCompare:)];
    aryToSort=[aryToSort sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    return aryToSort;
}

#pragma textFieldDelegate
-(void)setTextFieldWithSpace:(UITextField*)txtField
{
        txtField.leftViewMode = UITextFieldViewModeAlways;
    
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,15, txtField.frame.size.height)];
        txtField.leftView = paddingView;
    
}

-(NSString*)maxDigitsInString:(NSString *)str
{
    NSString *lastFourChar = [str substringToIndex:5];
    return lastFourChar;
    
}
@end
