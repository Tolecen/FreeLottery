//
//  UserLotTrackDetailView.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QueryLotTrackViewController;

/*{"id":"0000000000301934","lotNo":"T01007","lotName":"时时彩","lotMulti":"1","bet_code":"1D|-,-,-,-,37_1_200_400","betCode":"玩法:一星\n-,-,-,-,37\n","batchNum":10,"lastNum":1,"beginBatch":"20120711009","lastBatch":"20120711009","betNum":"57","amount":"113200","state":"0","orderTime":"2012-07-12 18:23:39","prizeEnd":"1","isRepeatBuy":"false"}*/

@interface UserLotTrackDetailView : UIView <UIAlertViewDelegate>
{
    UILabel*   m_lotNameLabel;
    UILabel*   m_stateLabel;
    UILabel*   m_batchNumLabel;
    UILabel*   m_cashAmountLabel;
    UILabel*   m_lastNumLabel;
	UIButton*   m_stopButton;
    UIButton*  m_viewButton;
    UIButton*  m_againButton;
    
    NSString*  m_idNo;      //"id":"0000000000038824"
    NSString*  m_lotNo;     //F47103
    NSString*  m_lotName;   //福彩3D
    NSString*  m_betCode;   //340103010203^
    NSString*  m_betCodeMsg;//注码:01,02,03
    NSString*  m_batchNum;  //"batchNum":2,追号期数
    NSString*  m_lastNum;   //"lastNum":1,已追期数
    NSString*  m_beginBatch;//"beginBatch":"2011110",起始追期
    NSString*  m_betNum;    //"betNum":"2
    NSString*  m_cashAmount;//200
    NSString*  m_state;     //"state":"0",0表示进行中，1表示已追完
    NSString*  m_orderTime;  //投注时间:2011-09-05 11:29:20
    NSString*  m_lotMulti; //倍数
    NSString*  m_prizeEnd;  //中奖后是否停止追期
    NSString*  m_oneAmount;  //用于判断是否是大乐透追加（200／300）
    
    NSString*  m_isRepeatBuy;//是否可以继续追期
        
    QueryLotTrackViewController* m_supViewController;
    
}

@property (nonatomic, retain) NSString* idNo;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* lotName;
@property (nonatomic, retain) NSString* betCode;
@property (nonatomic, retain) NSString* betCodeMsg;
@property (nonatomic, retain) NSString* batchNum;
@property (nonatomic, retain) NSString* lastNum;
@property (nonatomic, retain) NSString* beginBatch;
@property (nonatomic, retain) NSString* betNum;
@property (nonatomic, retain) NSString* cashAmount;
@property (nonatomic, retain) NSString* stateType;
@property (nonatomic, retain) NSString* orderTime;
@property (nonatomic, retain) NSString* prizeEnd;
@property (nonatomic, retain) NSString* lotMulti;
@property (nonatomic, retain) NSString* isRepeatBuy;
@property (nonatomic, retain) NSString* oneAmount;

@property (nonatomic, retain) QueryLotTrackViewController* supViewController;

- (void)refreshView;

@end
