//
//  CommonRecordStatus.h
//  RuYiCai
//
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNormalLogin  @"NormalLogin"//博雅彩帐号
#define kQQLogin      @"QQLogin"//qq登录
#define kXLWeiBoLogin @"XLLogin"//新浪微博帐号登录

@interface CommonRecordStatus : NSObject {
    BOOL      m_remmberQuitStatus;//记住注销状态
    BOOL      m_isGetCashOK;  //提现是否成功
    NSString  *m_startImageId;  //服务器上保存的开机界面的id
    NSData    *m_startImage; //开机图片
    
    BOOL       m_useStartImage;//真时使用服务器上的，假时使用本地的
    BOOL       m_useADtImage;//真时使用服务器上的，假时使用本地的
    NSMutableDictionary *m_useADImageIds;//广告图片组ID
    NSMutableDictionary *m_useADImages;//广告图片组
        
    NSString*  m_netMissDate;
    
    NSString*  m_deviceToken;
    
    NSString*  m_chargeWarnStr;
    
    NSDictionary*  m_topActionDic;//头部新闻
    
    NSString*  m_sampleNetStr;//一般彩票信息查询；一般充值信息查询
    
    NSString*  m_resultWarn;//成功后提示语
    
    /*
     投注查询 lotno
     */
    NSString*   m_QueryBetlotNO;
    
    NSString*   m_loginWay;//登录方式：
    
    NSString*   m_lotteryInfor;//开奖公告
    
    NSString*   m_inProgressActivityCount;//正在进行的活动数量
    
    NSInteger   m_changeWay;//0表示普通充值，1表示余额不足时的充值(充值成功后的跳转)，2:余额不足时直接支付
}

+ (CommonRecordStatus *)commonRecordStatusManager;

@property (nonatomic, assign) BOOL remmberQuitStatus;
@property (nonatomic, assign) BOOL isGetCashOK;
@property (nonatomic, retain) NSString* startImageId;

@property (nonatomic, retain) NSData* startImage;
@property (nonatomic, assign) BOOL useStartImage;
@property (nonatomic, assign) BOOL useADImage;
@property (nonatomic, retain) NSMutableDictionary* useADImageIds;
@property (nonatomic, retain) NSMutableDictionary *useADImages;

@property (nonatomic, retain) NSString*  netMissDate;
@property (nonatomic, retain) NSString*  deviceToken; 

@property (nonatomic, retain) NSString*  chargeWarnStr;
@property (nonatomic, retain) NSDictionary*  topActionDic;
@property (nonatomic, retain) NSString * errerCode;//快三投注成功码
@property (nonatomic, retain) NSString*  sampleNetStr;

@property (nonatomic, retain) NSString*  resultWarn;

@property (nonatomic, retain) NSString*   loginWay;

@property (nonatomic, retain) NSString*   lotteryInfor;
@property (nonatomic, retain) NSString*   inProgressActivityCount;

@property (nonatomic, assign) NSInteger   changeWay;

- (BOOL)isHeighLotTitle:(NSString*)lotTitle;
- (BOOL)isHeighLot:(NSString*)lotNo;
- (NSString*)lotNameWithLotNo:(NSString*)lotNo;
- (NSString*)lotNameWithLotTitle:(NSString*)lotTitle;
- (void)setLotShowArray;
- (void)setLotteryShowArray;
- (void)defaultOrderLottery;
- (void)setLottoryBetWarnDic;
- (void)clearBetData;
-(void)initADimage;
- (void)setPayStationArray;//设置默认充值中心

- (NSString*)lotNoWithLotTitle:(NSString*)lotTitle;

/*
  彩种页面 右上角下拉按钮
 */
@property (nonatomic, retain) NSString*  QueryBetlotNO;

- (UIImageView*)creatFourButtonView;
- (UIImageView*)creatThreeButtonView;

- (UIButton*)creatIntroButton:(CGRect)rect;
- (UIButton*)creatNewIntroButton:(CGRect)rect;
- (UIButton*)creatHistoryButton:(CGRect)rect;
- (UIButton*)creatQuerybetLotButton:(CGRect)rect;
- (UIButton*)creatNewQuerybetLotButton:(CGRect)rect;
- (UIButton*)creatLuckButton:(CGRect)rect;
- (UIButton*)creatAnalogNumButton:(CGRect)rect;//模拟选号
- (UIButton*)creatPresentSituButton:(CGRect)rect;//开奖走势
- (UIButton*)creatJSButton:(CGRect)rect;

//应用注册scheme
- (NSString*) getAppScheme:(NSString*)appTag;
//判断 是哪个插件返回的
- (NSString*) getZhifuAppTag:(NSString*)appScheme;

//判断汉字；长度
- (NSUInteger) asciiLengthOfString: (NSString *) text;
- (NSUInteger) unicodeLengthOfString: (NSString *) text;

#pragma mark 控制输入框输入长度
- (NSString*)textMaxLengthWithString:(NSString*)oldString andLength:(NSInteger)maxLength;

@end
