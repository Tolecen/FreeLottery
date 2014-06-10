//
//  WebContentViewController.h
//  Boyacai
//
//  Created by Tolecen on 14-6-9.
//
//

#import <UIKit/UIKit.h>
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
#import "RuYiCaiNetworkManager.h"
@interface WebContentViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView * agreeWebView;
}
@property (assign,nonatomic)int webType;
@end
