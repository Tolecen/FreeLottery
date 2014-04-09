//
//  SetWeiBoViewController.h
//  RuYiCai
//
//  Created by  on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface SetWeiBoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SinaWeiboDelegate, SinaWeiboRequestDelegate>
{
    UITableView*     m_myTableView;
    
    BOOL             m_xinLangState;
    BOOL             m_tengXunState;
    
    
    RuYiCaiAppDelegate   *m_delegate;
    
    SinaWeibo      *sinaweibo;
}
@property(nonatomic, retain)UITableView*     myTableView;

- (void)queryWeiBoState;
- (void)xinLangViewHideOk:(NSNotification*)notification;
- (void)SinaHandleOpenURL:(NSNotification*)notification;
- (void)SinaBecomeActive:(NSNotification*)notification;
@end
