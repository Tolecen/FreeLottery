//
//  AlipayPayWapView.h
//  RuYiCai
//
//  Created by  on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@interface AlipayPayWapView : UIViewController<UIWebViewDelegate>
{
    UIWebView *mWebView;
    
    RuYiCaiAppDelegate *m_delegate;

}
@end
