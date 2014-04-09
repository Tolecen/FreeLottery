//
//  GiftedDetailView.h
//  RuYiCai
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QueryGiftViewController;

@interface GiftedDetailView : UIView
{
    UILabel*   m_lotNameLabel;
    UILabel*   m_toMobileIdLabel;
    UILabel*   m_orderTimeLabel;
    UILabel*   m_amountLabel;
//    UIButton*  m_reciveButton;
    UIButton*  m_viewButton;
    
    NSString*  m_toMobileId; //"toMobileId":"18618118264"
    NSString*  m_orderTime;   //"orderTime":"2011-09-09 14:41:42"
    NSString*  m_cashAmount;
    NSString*  m_batchCode; //2011521
    NSString*  m_lotMulti;  //lotMulti":"1"
    NSString*  m_betCodeMsg;//注码:01,02,03
    NSString*  m_lotNo;  //"lotNo":"F47104"
    NSString*  m_lotName; //"lotName":"双色球"
    NSString*  m_playType;  //"play":"单式"
//    NSString*  m_reciveState; //"reciveState"是否领取
    NSString*  m_presentId;//领取彩票的编号 
    
    NSString*  m_orderId;//订单号
    NSString*  m_betNum;//注数
    NSString*  m_stateMemo;//已出票等描述
    NSString*  m_winCode;//开奖号码

    QueryGiftViewController* m_supViewController;
}

@property (nonatomic, retain) NSString* toMobileId;
@property (nonatomic, retain) NSString* orderTime;
@property (nonatomic, retain) NSString* cashAmount;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* lotMulti;
@property (nonatomic, retain) NSString* betCodeMsg;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* lotName;
@property (nonatomic, retain) NSString* playType;
//@property (nonatomic, retain) NSString* reciveState;
@property (nonatomic, retain) NSString* presentId;

@property (nonatomic, retain) NSString*  orderId;//订单号
@property (nonatomic, retain) NSString*  betNum;//注数
@property (nonatomic, retain) NSString*  stateMemo;//已出票等描述
@property (nonatomic, retain) NSString*  winCode;//开奖号码

@property (nonatomic, retain) QueryGiftViewController* supViewController;

- (void)refreshView;
@end
