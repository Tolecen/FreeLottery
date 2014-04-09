//
//  BaseHelpViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-10-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseHelpViewController : UIViewController <UIWebViewDelegate> {
    UIWebView* m_webView;
    NSString*  m_htmlFileName;
}

@property (nonatomic, retain) NSString* htmlFileName;

- (void)refresh;

@end
