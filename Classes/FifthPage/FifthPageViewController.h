//
//  FifthPageViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@interface FifthPageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
//    enum WXScene _scene;
    UITableView        *m_myTableView;
    
//    UILabel            *m_loginStatus; //登录状态
//    UIBarButtonItem    *m_button_Login;//登录
    RuYiCaiAppDelegate *m_delegate;
}

@property (nonatomic, retain)UITableView        *myTableView;
//@property (retain, nonatomic) ShareViewController *shareviewController;
- (void)userLoginOK2:(NSNotification*)notification;

@end