//
//  UserLotBetDetailView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QueryLotBetViewController;

@protocol  UserLotBetDetailViewDelgate<NSObject>

-(void)pushVC;

@end


@interface UserLotBetDetailView : UIView <UIAlertViewDelegate>
{
    UILabel*   m_lotNameLabel;
    UILabel*   m_batchCodeLabel;
    UILabel*   m_cashAmountLabel;
    UILabel*   m_prizeAmountLabel;
    //    UIButton*  m_againBet;
    //    UIButton*  m_viewButton;
    
    NSString*  m_lotNo;     //F47103
    NSString*  m_lotName;   //福彩3D
    NSString*  m_betCode;   //340103010203^
    //    NSString*  m_betCodeMsg;
    //    NSString*  m_betCodeHtmlMsg;//注码:01,02,03
    NSString*  m_cashAmount;//200
    NSString*  m_winCode;
    NSString*  m_prizeAmount; //"prizeAmt":"0"
    NSString*  m_batchCode; //2011521
    NSString*  m_lotMulti;  //lotMulti":"1"
    //    NSString*  m_playType;  //"play":"单式"
    NSString*  m_orderTime;  //投注时间:2011-09-05 11:29:20
    NSString*  m_isRepeatBuy;
    NSString*  m_prizeState;//兑奖标识(0 未开奖， 3 未中奖， 4 中大奖， 5 中小奖)
    
    NSString*  m_orderId;//订单号
    NSString*  m_betNum;//注数
    NSString*  m_stateMemo;//已出票等描述
    
    NSString*  m_oneAmount;
    //投注内容 表格显示
    BOOL       m_showInTable;//可以表格显示
    //    NSDictionary*  m_betCodeJson;
    id    _delegate;
}
@property (nonatomic, assign) BOOL showInTable;
@property (nonatomic, retain) NSDictionary* betCodeJson;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* lotName;
@property (nonatomic, retain) NSString* betCode;
//@property (nonatomic, retain) NSString* betCodeHtmlMsg;
//@property (nonatomic, retain) NSString* betCodeMsg;
@property (nonatomic, retain) NSString* cashAmount;
@property (nonatomic, retain) NSString* winCode;
@property (nonatomic, retain) NSString* prizeAmount;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* lotMulti;
//@property (nonatomic, retain) NSString* playType;
@property (nonatomic, retain) NSString* orderTime;
@property (nonatomic, retain) NSString* isRepeatBuy;
@property (nonatomic, retain) NSString* prizeState;

@property (nonatomic, retain) NSString*  orderId;//订单号
@property (nonatomic, retain) NSString*  betNum;//注数
@property (nonatomic, retain) NSString*  stateMemo;//已出票等描述

@property (nonatomic, retain) NSString*  oneAmount;

@property (nonatomic, assign) id    delegate;
- (void)refreshView;

@end