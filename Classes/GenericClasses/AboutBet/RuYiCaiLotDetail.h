//
//  RuYiCaiLotDetail.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MORE_BETCODE  @"moreBetCode"
#define MORE_ZHUSHU    @"moreZhuShu"
#define MORE_AMOUNT    @"moreAmount"

@interface RuYiCaiLotDetail : NSObject
{
    NSString* m_batchCode;    //期号，投注的当前期:如2011083
	NSString* m_batchEndTime; //结束时间
    NSString* m_batchNum;     //追号期数，不追号，默认为1
    NSString* m_betCode;      //注码格式
	NSString* m_disBetCode;   //显示的注码
    NSString* m_lotNo;        //投注彩种，如：双色球为F47104
    NSString* m_lotMulti;     //倍数
    NSString* m_amount;       //投注金额，以分为单位
    NSString* m_betType;      //表示投注bet，表示赠彩gift
    NSString* m_sellWay;      //0表示自选，1表示机选 2表示多注投  3 表示幸运选号  4模拟选号
    NSString* m_toMobileCode; //被赠送手机号
	NSString* m_advice;       //赠言
	NSString* m_zhuShuNum;    //注数
    NSString* m_prizeend;     //中奖停止追期
    NSString* m_oneAmount;    //单注金额（除大乐透追加300，其他都是200）
    
    
    NSString* m_moreZuBetCode; //多注投注时注码格式
    NSString* m_moreZuAmount;  //多注投时投注金额，以分为单位(收益率计算里面 需要使用，其他时候和m_amount相同)
    NSString* m_subscribeInfo; //多注投、收益率投时的描述
    
    BOOL      m_isShouYiLv;//是否满足收益率追号,单注或复式投注时
        
    NSMutableArray  *m_moreBetCodeInfor;//多注投保存（字典：MORE_BETCODE,MORE_ZHUSHU,MORE_AMOUNT）
    NSMutableArray  *m_moreDisBetCodeInfor;
    
    NSString*  m_giftContentStr;
    
    BOOL      m_isDLTOr11X2;
}

@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* batchEndTime;
@property (nonatomic, retain) NSString* batchNum;
@property (nonatomic, retain) NSString* betCode;
@property (nonatomic, retain) NSString* disBetCode;
@property (nonatomic, retain) NSString* lotNo;
@property (nonatomic, retain) NSString* lotMulti;
@property (nonatomic, retain) NSString* amount;
@property (nonatomic, retain) NSString* betType;
@property (nonatomic, retain) NSString* sellWay;
@property (nonatomic, retain) NSString* toMobileCode;
@property (nonatomic, retain) NSString* advice;
@property (nonatomic, retain) NSString* zhuShuNum;
@property (nonatomic, retain) NSString* prizeend;
@property (nonatomic, retain) NSString* oneAmount;

@property (nonatomic, retain) NSString* moreZuBetCode;
@property (nonatomic, retain) NSString* moreZuAmount;
@property (nonatomic, retain) NSString* subscribeInfo;

@property (nonatomic, assign) BOOL      isShouYiLv;

@property (nonatomic, retain)  NSMutableArray  *moreBetCodeInfor;
@property (nonatomic, retain)  NSMutableArray  *moreDisBetCodeInfor;

@property (nonatomic, retain) NSString* giftContentStr;

@property (nonatomic, assign) BOOL isDLTOr11X2;
+ (RuYiCaiLotDetail*)sharedObject;

@end
