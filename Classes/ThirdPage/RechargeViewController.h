//
//  RechargeViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

@interface RechargeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView        *m_myTabelView;
    
    UILabel            *m_loginStatus; //登录状态
    RuYiCaiAppDelegate *m_delegate;
    int                 m_didSelectRow;
    
    NSInteger          cell_count;
    BOOL               *m_isHidePush;
}
@property (nonatomic, assign) BOOL          isExpend;
@property (nonatomic, retain) UITableView*  myTabelView;
@property (nonatomic, assign) BOOL          *isHidePush;
@property (nonatomic, retain) NSString * lotNo;

- (void)updateLoginStatus;

@end
