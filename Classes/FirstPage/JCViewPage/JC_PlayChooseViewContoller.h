//
//  JCLQ_PlayChooseViewContoller.h
//  RuYiCai
//
//  Created by ruyicai on 12-4-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
/*
 weiliang
 竞彩玩法 赛事 筛选
 */
#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"

#import "JCLQ_PickGameViewController.h"

@class JCZQ_PickGameViewController;
@interface JC_PlayChooseViewContoller : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    BOOL                        m_isJCLQView;
    UITableView                *m_tableView;
    UIBarButtonItem            *m_rightTitleBarItem;
    
    NSInteger                   m_playChooseType;
    JCZQ_PickGameViewController *m_JCZQ_parentController;
    JCLQ_PickGameViewController *m_JCLQ_parentController;
    
    BOOL                        m_playTypeHeaderButtonSelect;
    
    int                         m_SectionN[1];
}
 
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, assign) NSInteger playChooseType;
@property(nonatomic, retain) JCZQ_PickGameViewController *JCZQ_parentController;

@property(nonatomic, retain) JCLQ_PickGameViewController* JCLQ_parentController;
//@property(nonatomic, retain) JCZQ_PickGameViewController* JCZQ_parentController;
@property(nonatomic, assign) BOOL isJCLQView;

@end
