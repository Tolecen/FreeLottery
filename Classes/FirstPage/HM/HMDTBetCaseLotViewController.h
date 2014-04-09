//
//  HMDTBetCaseLotViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-10-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDTBetCaseLotViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIView*        m_topView;
    BOOL           m_isGotoAuto_OrderView;//从用户中心合买查询进入的 ，禁止访问定制跟单修改页面
    NSString*      m_starterUserNo;
    UITextField*   m_buyAmtTextField;       //购买金额
    UITextField*   m_safeAmtTextField;      //保底金额
    //    UILabel*       m_leftBuyAmtLabel;       //剩余认购金额
    //    UILabel*       m_leftSafeAmtLabel;      //剩余保底金额
    //    UILabel*       m_buyAmtRatioLabel;      //购买金额占比
    //    UILabel*       m_safeAmtRatioLabel;     //保底金额占比
    
    NSString*      m_totalAmt;
    NSString*      m_caseLotId;
    NSString*      m_buyAmt;
    NSString*      m_safeAmt;
    NSString*      m_minAmt;
    NSString*      m_cancelCaselot;//是否可以撤单
    NSString*      m_lotName;
    NSString*      m_endTime;
    NSString*      m_lotNo;
    NSString*      m_batchCode;
    
    NSString*      m_prizeState;//兑奖标识	0未开奖，3未中奖，4中大奖，5中小奖
    NSString*      m_winAmount;//中奖金额
    
    UITableView*     m_myTableView;
    NSMutableArray   *m_titleButtonState;
    
    NSDictionary*           m_dataDic;
    NSMutableArray*         m_joinDataArr;
    NSInteger               m_currentJoinDataPage;
    NSInteger               m_joinDataPageTotal;
    UIButton*        m_shareButton;
    BOOL                  m_isPushHid;
}
@property (nonatomic, assign)  BOOL           isPushHid;
@property (nonatomic, retain)  UIView*        topView;
@property (nonatomic, retain)  NSString*      starterUserNo;
@property (nonatomic, assign)  BOOL           isGotoAuto_OrderView;

@property (nonatomic, retain)  UITextField* buyAmtTextField;
@property (nonatomic, retain)  UITextField* safeAmtTextField;
//@property (nonatomic, retain)  UILabel* leftBuyAmtLabel;
//@property (nonatomic, retain)  UILabel* leftSafeAmtLabel;
//@property (nonatomic, retain)  UILabel* buyAmtRatioLabel;
//@property (nonatomic, retain)  UILabel* safeAmtRatioLabel;

@property (nonatomic, retain) NSString* totalAmt;
@property (nonatomic, retain) NSString* caseLotId;
@property (nonatomic, retain) NSString* buyAmt;
@property (nonatomic, retain) NSString* safeAmt;
@property (nonatomic, retain) NSString* minAmt;
@property (nonatomic, retain) NSString* cancelCaselot;

@property (nonatomic, retain) NSString* lotName;
@property (nonatomic, retain) NSString* endTime;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* batchCode;

@property (nonatomic, retain) NSString*  prizeState;//兑奖标识
@property (nonatomic, retain) NSString*  winAmount;//中奖金额

@property (nonatomic, retain) UITableView*      myTableView;
@property (nonatomic, retain) NSMutableArray   *titleButtonState;
@property (nonatomic, retain) NSDictionary*     dataDic;
@property (nonatomic, retain) NSMutableArray*          joinDataArr;
@end
