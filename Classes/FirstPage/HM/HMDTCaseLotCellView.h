//
//  HMDTCaseLotCellView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*{"caseLotId":"C00000000291777",
 "lotNo":"T01004",
 "batchCode":"2012079",
 "content":"彩种:足球任九场\n倍数:2\n玩法:复式\n注码:1,1,1,1,1,0,31,0,0,#,#,#,#,#\n",
 displayState":"5",
 "displayStateMemo":"流单",
 "amt":"0",
 "prizeAmt":"0",
 "commisionPrizeAmt":"0",
 "commisionRatio":"10",
 "totalAmt":"800",
 "safeAmt":"200",
 "progress":50,
 "safeRate":25,"buyTime":"2012-07-16 14:11:11","starter":"我是谁","prizeState":"0",
 "winCode":""},*/

@class HMDTQueryCaseLotViewController;

@interface HMDTCaseLotCellView : UIView {
    UILabel*   m_lotNoLabel;
    UILabel*   m_buyTimeLabel;
    UILabel*   m_stateLabel;
    UILabel*   m_starterLabel;
    UILabel*   m_amountLabel;
    
    NSString*  m_lotTitle;
    
    NSString*  m_caseLotId;
    NSString*  m_lotNo;
    NSString*  m_displayState;//1认购中，2满员，3成功，4撤单，5流单，6已中奖
    //    NSString*  m_displayStateMemo;
    NSString*  m_amount;
    //    NSString*  m_totalAmount;
    //    NSString*  m_saftAmount;
    //    NSString*  m_progressInfo;
    NSString*  m_buyTime;
    //    NSString*  m_contentInfo;
    NSString*  m_prizeState;//0未开奖，3未中奖，4中大奖，5中小奖
    NSString*  m_prizeAmount;
    //    NSString*  m_batchCode;
    NSString*  m_starter;//发起人
    
    CGPoint    m_beganTouchPt;
    
    //    NSString*  m_winCode;
    
    HMDTQueryCaseLotViewController*   m_supViewController;
}

@property (nonatomic, retain) NSString* caseLotId;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* displayState;
//@property (nonatomic, retain) NSString* displayStateMemo;
@property (nonatomic, retain) NSString* amount;
//@property (nonatomic, retain) NSString* totalAmount;
//@property (nonatomic, retain) NSString* saftAmount;
//@property (nonatomic, retain) NSString* progressInfo;
@property (nonatomic, retain) NSString* buyTime;
//@property (nonatomic, retain) NSString* contentInfo;
@property (nonatomic, retain) NSString* prizeState;
@property (nonatomic, retain) NSString* prizeAmount;
//@property (nonatomic, retain) NSString* winCode;
//@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* lotTitle;
@property (nonatomic, retain) NSString* starter;//发起人
@property (nonatomic, retain) HMDTQueryCaseLotViewController*   supViewController;

- (void)refreshView;

@end
