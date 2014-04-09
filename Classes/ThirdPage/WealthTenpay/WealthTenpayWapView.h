//
//  AlipayPayWapView.h
//  RuYiCai
//
//  Created by  on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@interface WealthTenpayWapView : UIViewController<UIWebViewDelegate>
{
    UIWebView *mWebView;
    
    RuYiCaiAppDelegate *m_delegate;
    NSString           *m_wealthUrl;

}
@property (nonatomic,retain)NSString           *wealthUrl;
@property (nonatomic,retain) NSString * lotNo;
@end
