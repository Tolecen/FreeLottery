//
//  AdaptationUtiks.m
//  Boyacai
//
//  Created by qiushi on 13-9-18.
//
//

#import "AdaptationUtils.h"

@implementation AdaptationUtils


+(void)adaptation:(UIViewController *)controller
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        controller.edgesForExtendedLayout = UIRectEdgeNone;
        controller.automaticallyAdjustsScrollViewInsets = YES;
//        controller.extendedLayoutIncludesOpaqueBars = YES;
//        [controller setNeedsStatusBarAppearanceUpdate];
    }
    
}

@end
