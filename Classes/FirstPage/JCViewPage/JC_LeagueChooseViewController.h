//
//  JC_LeagueChooseViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "JCLQ_PickGameViewController.h"
#import "JCZQ_PickGameViewController.h"
#import "BJDC_pickNumViewController.h"

@interface JC_LeagueChooseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    int                        m_isJCLQView;////1为篮球  2为北京单场  0为竞彩足球
    UITableView                *m_tableView;
    UIBarButtonItem            *m_rightTitleBarItem;
 
    JCZQ_PickGameViewController *m_JCZQ_parentController;
    JCLQ_PickGameViewController *m_JCLQ_parentController;
 
    BOOL                        m_leagueHeaderButtonSelect;
    
    int                         m_SectionN[1];
    NSMutableArray              *m_selectedLeagueArrayTag;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
 
@property (nonatomic,retain) NSMutableArray* selectedLeagueArrayTag;

@property(nonatomic, retain) JCLQ_PickGameViewController* JCLQ_parentController;
@property(nonatomic, retain) JCZQ_PickGameViewController* JCZQ_parentController;
@property(nonatomic, retain) BJDC_pickNumViewController*  BJDC_parentController;
@property(nonatomic, assign) int isJCLQView;

-(void) appendSelectedLeagueTag:(NSString*)tag;
 
@end
