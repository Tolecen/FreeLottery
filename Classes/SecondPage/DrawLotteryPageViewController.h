//
//  DrawLotteryPageViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "PullRefreshTableViewController.h"

typedef enum {
    
    JC_ZQ_TYPE = 0,
    JC_LQ_TYPE,
    JC_BD_TYPE,
    
} JCType;

//@interface SecondPageViewController : PullRefreshTableViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
@interface DrawLotteryPageViewController : PullRefreshTableViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
//    enum WXScene _scene;
    RuYiCaiAppDelegate *m_delegate;
    NSUInteger          m_cellCount;
    
    NSMutableArray*            m_cellTitleArray;
    JCType m_jcType;
    
}
//由于开奖中心首页彩种编辑公用的一个数据源，但是，pk10和江西ss猜只在开奖中心显示，所以要隔离出来数据存储单独追加这俩彩种
//@property(nonatomic, retain) NSMutableArray          *pkSSCMutableArray;
@property(nonatomic, retain) NSMutableArray          *buttonStatuArr;
@property(nonatomic, retain) NSMutableArray*         cellTitleArray;
@property(nonatomic, assign) JCType jcType;

- (void)JCCheckButtonSelected:(BOOL) isJclq;

- (void)JCCheckButtonSelectedForType:(JCType) jcType;

- (void)JCInstantScoreButtonSelected:(BOOL) isJclq;
@end
