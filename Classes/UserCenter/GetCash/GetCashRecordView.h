//
//  GetCashRecordView.h
//  RuYiCai
//
//  Created by  on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 {"cashdetailid":"00000011","amount":"200","cashTime":"2012-04-20 15:47:42","rejectReason":"处理失败,账号有误,请更换","stateMemo":"驳回","state":"104"}
 */

@interface GetCashRecordView : UIView
{
    UILabel*     m_cashTimeLabel;
    UILabel*     m_amountLabel;
    UILabel*     m_stateMemoLabel;
    
    UIButton*    m_reasonButton;
    UIButton*    m_cancelCashButton;
    
    NSString*    m_cashTime;
    NSString*    m_amount;
    NSString*    m_rejectReason;
    NSString*    m_stateMemo;
    
    NSString*    m_cashdetailid;
    NSString*    m_state;
}

@property (nonatomic, retain)NSString*    cashTime;
@property (nonatomic, retain)NSString*    amount;
@property (nonatomic, retain)NSString*    rejectReason;
@property (nonatomic, retain)NSString*    stateMemo;
@property (nonatomic, retain)NSString*    cashdetailid;
@property (nonatomic, retain)NSString*    state;

- (void)refreshView;
- (void)reasonButtonClick:(id)sender;
- (void)cancelButtonClick:(id)sender;

@end
