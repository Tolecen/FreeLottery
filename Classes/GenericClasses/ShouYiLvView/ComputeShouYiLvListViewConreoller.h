//
//  ComputeShouYiLvListViewConreoller.h
//  RuYiCai
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComputeShouYiLvListViewConreoller : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView           *m_myTableView;
    NSMutableArray        *m_dataArray;
    
    UISwitch*              m_zhuiQiSwitch;
    
    NSString*              m_description;
    
    NSString*              m_startBatchCode;

    UIScrollView*          m_bottomView;
}

@property(nonatomic, retain)UITableView           *myTableView;
@property(nonatomic, retain)NSMutableArray        *dataArray;
@property(nonatomic, retain)NSString*              description;
@property(nonatomic, retain)NSString*              startBatchCode;
@property(nonatomic, retain)NSString*              batchNum;//投入期数

- (void)setData;
- (void)buyButtonClick:(id)sender;
- (NSString*)buildSubscribeInfo;
- (void)betCompleteOK:(NSNotification*)notification;
@end
