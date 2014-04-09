//
//  IntegralViewController.h
//  RuYiCai
//
//  Created by  on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullUpRefreshView;

@interface IntegralViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UILabel        *m_integralLabel;
    
    UIButton       *m_mingXiButton; //明细
    UIButton       *m_duiHuanButton;//兑换
    BOOL           isMingXi;

    UITableView    *m_tableView;    
    NSMutableArray *m_dataArray;
    UIImageView    *m_imageBottom;

    UIImageView    *m_duiHuanbg;
    UIImageView    *m_duiHuanBottombg;
    UITextField    *m_integralNum;
    UILabel        *m_getMoney;
    UIButton*      duiHuanButton;
        
    PullUpRefreshView      *refreshView;

    
    NSUInteger              m_curPageIndex;
    NSUInteger              m_totalPageCount;
    
//    UILabel                 *m_transMoneyLabel;
    UILabel                 *m_transMoneyLabelDescription;
    NSUInteger              m_transMoneyNeedsScores;
    NSString*               m_transMoneyNeedsScoresDescription;
}
@property (nonatomic, retain) NSMutableArray *dataArray;


- (void)setMainView;
- (void)setUpDuihuanView;

@end
