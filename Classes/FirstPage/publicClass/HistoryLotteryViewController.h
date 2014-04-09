//
//  HistoryLotteryViewController.h
//  RuYiCai
//
//  Created by  on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullUpRefreshView;

@interface HistoryLotteryViewController : UITableViewController
{
    NSString*  m_lotNo; //开奖查询时使用
    NSString*  m_lotTitle;//kLotTitleSSQ 开奖号码显示时使用
    
    PullUpRefreshView      *refreshView;
    
    NSMutableArray   *m_lotteryDataArray;
    NSUInteger       m_curPageIndex;
    NSUInteger       m_totalPageCount; 
}

@property(nonatomic, retain)NSString*  lotNo;
@property(nonatomic, retain)NSString*  lotTitle;
@property (nonatomic, retain) NSMutableArray    *lotteryDataArray;

- (void)goBack:(id)sender;
- (void)updateLotteryList:(NSNotification*)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;

@end

