//
//  UserLotWinDetailView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QueryLotWinViewController;

@interface UserLotWinDetailView : UIView {
    UILabel*   m_lotNameLabel;
    UILabel*   m_batchCodeLabel;
    UILabel*   m_winAmountLabel;
    UILabel*   m_cashTimeLabel;
    UIButton*  m_viewButton;
    
    NSString*  m_lotNo;     //F47103
    NSString*  m_lotName;   //福彩3D
    NSString*  m_betCode;   //340103010203^
    NSString*  m_betCodeMsg;//注码:01,02,03
    NSString*  m_winAmount; //中奖金额:100000
    NSString*  m_batchCode; //2011521
    NSString*  m_cashTime;  //2011-09-05 11:29:20
    NSString*  m_sellTime;  //2011-09-01 17:52:08
    
    NSString*  m_orderId;//订单号
    NSString*  m_betNum;//注数
    NSString*  m_lotMulti;//倍数
    NSString*  m_cashAmount;//投注金额
    NSString*  m_winCode;//开奖号码
    
    QueryLotWinViewController*    m_supViewController;
}

@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* lotName;
@property (nonatomic, retain) NSString* betCode;
@property (nonatomic, retain) NSString* betCodeMsg;
@property (nonatomic, retain) NSString* winAmount;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* cashTime;
@property (nonatomic, retain) NSString* sellTime;

@property (nonatomic, retain) NSString*  orderId;//订单号
@property (nonatomic, retain) NSString*  betNum;//注数
@property (nonatomic, retain) NSString*  lotMulti;
@property (nonatomic, retain) NSString*  cashAmount;
@property (nonatomic, retain) NSString*  winCode;

@property (nonatomic, retain) QueryLotWinViewController*    supViewController;

- (void)refreshView;

@end
