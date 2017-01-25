//
//  Globals.m
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import "Globals.h"
#import "FMDBDataAccess.h"
#import "Constants.h"
@implementation Globals
@synthesize user,isFromLink;
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
        self.user=[[Users alloc]init];
        self.article=[[Articles alloc] init];
        self.addObj=false;
        self.uploadV=false;
        self.isAccepted=false;
        self.channel=[[Channels alloc] init];
        self.db=[[Database alloc] init];
        self.pages=[[Pages alloc] init];
        self.channelArray=MArray;
        self.articleArray=MArray;
        self.videosArray=MArray;
        self.relatedUDIDs=MArray;
        self.readingListArray=MArray;
        self.topicsArray=MArray;
        self.categoryArray=MArray;
        self.updatedChannelArray=MArray;
        self.updatedArticleArray=MArray;
        self.updatedBlogsArray=MArray;
        self.pagesArray=MArray;
        self.aryAllChannels=MArray;
        self.updatedPageArray=MArray;
        self.aryAllArticles= MArray;
        self.aryAllVideos = MArray;
        self.aryAllBlogs=MArray;
        self.fontSize=[NSString stringWithFormat:@"%d",16];

        self.isAllAticleReceived=false;
        self.isAllBlogsReceived=false;
        self.isAllVideoReceived=false;
        self.isRefreshFromDashBoard=false;
        self.isShowLoaderForNextData=false;
        self.aryOldChannels = MArray;

        //Arpit Changes
        self.dictChannelDataCount = MDictionary;
        self.intLimit = 5;
        self.intOffset = 0;
        
        self.sync=[[SyncData alloc] init];
        self.tmpInt=0;
        self.tmpArticleCount=0;
        self.tmpBlogCount=0;
        self.tmpVideoCount=0;
        self.channelSyncCount=0;
        self.blogs=[[Blogs alloc] init];
        self.videos=[[Video alloc] init];
        self.isVideoPlaying=false;
        self.isAlreadyLoggedIn=false;
        self.isNotificationRecieved=false;
        self.notificationDictionary=MDictionary;
    }
    self.databaseName = @"TestSqliteToReplaceContentoDB1.sqlite";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
    [self createAndCheckDatabase];
    return self;
}
-(void) createAndCheckDatabase
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:self.databasePath];
    
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
}
-(NSString *) getDatabasePath
{
    
    return self.databasePath;
}
+ (void)ShowAlertWithTitle:(NSString *)title Message:(NSString *)message {
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
#pragma mark - ProgresLoader

- (void)showLoader {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    }
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)showLoaderWith:(MBProgressHUDMode)mode {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(!self.hud) {
        self.hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    }
    else {
        [app.window addSubview:self.hud];
    }
    self.hud.mode = mode;
}
- (void)showToast:(NSString *)msg WithViewController:(UIViewController *)vc{
//    dispatch_async(dispatch_get_main_queue(), ^{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
//    
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = msg;
//    hud.margin = 10.f;
//    hud.yOffset = 150.f;
//    hud.removeFromSuperViewOnHide = YES;
//    
//    [hud hide:YES afterDelay:3];
//    });
}
- (void)showLoaderIn:(UIView *)view {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!self.hud) {
        
        self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    else {
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.window addSubview:self.hud];
    }
}
- (void)hideLoader {
    if([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    if(self.hud)
    [self.hud removeFromSuperview];
}
+ (void)turnBackToAnOldViewController:(UIViewController *)AnOldViewController{
    
    for (UIViewController *controller in [SlideNavigationController sharedInstance].viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[AnOldViewController class]]) {
            
            [[SlideNavigationController sharedInstance] popToViewController:controller
                                                                   animated:YES];
            break;
        }
    }
    
}
+ (void)pushNewViewController:(UIViewController *)NewViewController{
    BOOL isIn=false;
    for (UIViewController *controller in [SlideNavigationController sharedInstance].viewControllers) {
        
        //Do not forget to import AnOldViewController.h
        if ([controller isKindOfClass:[NewViewController class]]) {
            [[SlideNavigationController sharedInstance] popToViewController:controller animated:NO];
            isIn=true;
            break;
        }
    }
    if(!isIn)
    {
        [[SlideNavigationController sharedInstance] pushViewController:NewViewController animated:NO];
    }
    Globals *sharedManager;
    sharedManager=[Globals sharedManager];
    [sharedManager hideLoader];
}
- (float)getTextHeightOfText:(NSString *)string font:(UIFont *)aFont width:(float)width {
    //    CGSize  textSize = { width, 10000.0 };
    //    CGSize size = [string sizeWithFont:aFont
    //                   constrainedToSize:textSize
    //                       lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize maximumLabelSize = CGSizeMake(width, CGFLOAT_MAX);
    CGRect textRect = [string boundingRectWithSize:maximumLabelSize
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName:aFont}
                                           context:nil];
    
    return textRect.size.height;
}

+ (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    if(!youtubeURL)
    {
        return nil;
    }
//    NSError *error = NULL;
//    NSRegularExpression *regex =
//    [NSRegularExpression regularExpressionWithPattern:@"?.*v=([^&]+)"
//                                              options:NSRegularExpressionCaseInsensitive
//                                                error:&error];
//    NSTextCheckingResult *match = [regex firstMatchInString:youtubeURL
//                                                    options:0
//                                                      range:NSMakeRange(0, [youtubeURL length])];
//    NSString *substringForFirstMatch=[[NSString alloc] init];
//    if (match) {
//        NSRange videoIDRange = [match rangeAtIndex:1];
//        substringForFirstMatch = [youtubeURL substringWithRange:videoIDRange];
//    }
//    
//    return substringForFirstMatch;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL options:NSMatchingReportProgress range:NSMakeRange(0, [youtubeURL length])];
    if(rangeOfFirstMatch.location != NSNotFound) {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        
        return substringForFirstMatch;
    }
    
    return nil;
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
                || [((NSString*)object) isEqualToString:@"<null>"]
                || [((NSString*)object) isEqualToString:@"(null) (null)"]);
    }
    return NO;
}
- (BOOL) isNotNull:(NSObject*) object {
    return ![self isNull:object];
}

-(NSArray*) getArticles:(NSString *)channelId{
    
    // Initializing Variables
   __block NSArray* articleListArray;
    
    // Getting List of Articles for particular channels
    [self.sync getArticlesForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        articleListArray=result;
        [self hideLoader];

    }];
    return articleListArray;
}
-(NSArray*)getVideos:(NSString *)channelId{
    
    // Initializing Variables
    __block NSArray* videoListArray;
    
    // Getting List of Articles for particular channels
    [self.sync getVideosForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        videoListArray=[result mutableCopy];
        [self hideLoader];
    }];
    return  videoListArray;
    
}
-(NSArray*) getBlogs:(NSString *)channelId{
    
    // Checking if We have channels or already set uuid of topics
    // Initializing Variables
    __block NSArray*  blogListArray;
    
    // Getting List of Articles for particular channels
    
    [self.sync getBlogsForChannel:channelId WithCompletionBlock:^(id result,NSString *str, int status) {
        blogListArray=[result mutableCopy];
    }];
    return blogListArray;
}

-(NSString *)isNullOrEmpty:(NSString *)inString
{
    NSString *strText = @"";
    if ([inString isKindOfClass:[NSNull class]]) {
        return strText;
    }
    if (inString == nil || inString == (id)[NSNull null]||[inString isEqualToString:@""] || [inString isEqualToString:@"<null>"] || [inString isEqualToString:@"(null)"] || [inString isEqualToString:@"(null) (null)"]) {
        // nil branch
        return strText;
    } else {
        return inString;
    }
    return nil;
}
@end
