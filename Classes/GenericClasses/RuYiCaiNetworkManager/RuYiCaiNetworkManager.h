//
//  RuYiCaiNetworkManager.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYCProcessView.h"
#import "RuYiCaiAppDelegate.h"

#import "ASIFormDataRequest.h"
#import "NSData-AES.h"
#import "RuYiCaiCommon.h"
#import "RYCImageNamed.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RYCProcessView.h"
#import "RuYiCaiAppDelegate.h"
#import "FirstPageViewController.h"
#import "DrawLotteryPageViewController.h"
#import "RechargeViewController.h"
#import "FourthPageViewController.h"
#import "FifthPageViewController.h"
#import "LaunchHMViewController.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "Reachability.h"
#import "GTMBase64.h"
#import "CommonRecordStatus.h"
#import "Custom_tabbar.h"
#import "UserInformationAlertView.h"
#import "BindPhoneViewController.h"
#import "BindPhoneCheckViewController.h"
#import "SettingNicknameVC.h"

//#import "MobClick.h"//友盟

#define kNomalAlertViewTag      (0x100)
#define kBindCertidAlertViewTag (0x101)
#define kRegisterAlertViewTag   (0x102)
#define kChangeUserAlertViewTag (0x103)
#define kLotSubmitAlertViewTag  (0x104)
#define kChangePswAlertViewTag  (0x105)
#define kFeedbackAlertViewTag   (0x106)
#define kBindPhoneAlertViewTag  (0x107)
#define kBindPhoneSecurityAlertViewTag (0x108)
#define kCancelBindPhoneAlterViewTag   (0x109)
#define kCancelOKBindPhoneAlterViewTag (0x110)
#define kNickNameAlterViewTag   (0x111)
#define kBindEmailAlertViewTag  (0x112)
#define kCancelBindEmailAlterViewTag   (0x113)
#define kCancelOKBindEmailAlterViewTag (0x114)
#define kBindSucPhoneAlterViewTag (0x115)
#define kNewVersionAlertViewTag  (0x116)

//判断返回的功能时往那跳转
typedef enum
{
    GO_GCDT_TYPE = 0,
    GO_GDSZ_TYPE,
} GoBackType;

typedef enum 
{
    NET_APP_BASE = 0,
	NET_APP_LOGIN,           //登陆
    NET_APP_REGISTER,        //注册
    NET_APP_QUERY_BALANCE,   //余额查询
//	NET_APP_SUBMIT_LOT,      //投注
    NET_APP_QUERY_LOT_WIN,   //中奖查询
    NET_APP_QUERY_LOT_BET,   //投注查询
    NET_APP_QUERY_TRACK,     //追号查询
    NET_APP_QUERY_GIFT,      //赠送查询
    NET_APP_ACCOUNT_DETAIL,  //账户明细
    NET_APP_CAIDOU_DETAIL,   //彩豆明细
    NET_APP_GET_CASH,        //账户提现
    NET_APP_TOP_UP_MONEY,    //充值中心
    NET_APP_QUERY_DNA,       //银行卡电话充值
    NET_APP_JOIN_ACTION,     //加入合买
    NET_APP_BET_CASE_LOT_LOGIN,  //合买登陆
    NET_APP_AUTO_ORDER_LOGIN,  //自动跟单登陆
    NET_APP_BIND_CERTID, //绑定身份证
    NET_APP_BIND_PHONE, //绑定手机
    NET_APP_BIND_EMAIL, //绑定邮箱
    NET_APP_USER_CENTER,//用户中心
    //    NET_APP_USER_CENTER2,//帮助里的用户中心
    NET_APP_FEED_BACK,//用户反馈
    NET_APP_ADWALL_LOGIN, //积分墙页面登陆
    
//    NET_APP_JOIN_CUSTOMBAR_USER_CENTER,// 
//    NET_APP_HELP_SET,//更多，设置
} NetAppType;

typedef enum 
{
    NET_MORE_BASE = 0,
    NET_QUERY_MESSAGE_SET,
    NET_MESSAGE_SET,
    NET_HELP_QUERY_TITLE,
    NET_HELP_QUERY_CONTENT,
} NetHelpCenterType;

typedef enum 
{
    NET_CHARGE_BASE = 0,
    NET_QUERY_CHARGE_WARN,
    NET_SAMPLE_QUERY,
    NET_ACCOUNT_TAKE_CASH,
} NetChargeType;

typedef enum
{
    NET_LOT_BASE = 0,
    NET_LOT_MISSDATE,
    NET_LOT_SHOUYILV_BATCH,
    NET_LOT_SHOUYILV_COMPUTE,
    NET_LOT_HISTORY_TRACK,
    NET_QUXIAO,
    NET_LOTTERY_TREND,//走势图开奖号码
    NET_LOTTERY_HISTORY,//历史开奖号码
    NET_DONT_RESULT,//不需要返回值，不解析结果
    NET_LOTTERY_INFOR,//开奖公告
    NET_DONT_SHOWALTER,//不要没结果时弹框提示
}NetLotType;

@class FirstPageViewController;
@class DrawLotteryPageViewController;
@class RechargeViewController;
@class FourthPageViewController;
@class FifthPageViewController;
@class RankingViewController;

@interface RuYiCaiNetworkManager : NSObject <UITextFieldDelegate,UserInformationAlertViewDelegate,UIAlertViewDelegate> {
    RuYiCaiAppDelegate  *m_delegate;
    BOOL            m_hasLogin;
    NSString*       m_loginName;
    NSString*       m_userno;
    NSString*       m_phonenum;
    NSString*       m_password;
    NSString*       m_certid;
    NSString*       m_bindName;
    NSString*       m_newsPassword;
    NSString*       m_keyUrl;
    
    NSString*       m_bindPhoneNum;
    
    BOOL            m_loginAutoRememberPsw;
    
    //    BOOL            m_autoRememberMystatus;//自动登录
    NSString*       m_bindEmail;
    
    UIAlertView*    m_changeUserAlertView;
//    RYCProcessView* m_progressAlertView;
    
    NSString*       m_softwareInfo;
    NSString*       m_userBalance;
    
    NSString*       m_responseText;
    
    NetAppType      m_netAppType;
    NetHelpCenterType  m_netHelpCenterCenter;
    NetChargeType      m_netChargeQuestType;
    NetLotType         m_netLotType;
    GoBackType         m_goBackType;
    
    FirstPageViewController*  m_firstViewController;
    DrawLotteryPageViewController* m_secondViewController;
    RechargeViewController*  m_thirdViewController;
    FourthPageViewController* m_fourthViewController;
    FifthPageViewController*  m_fifthViewController;
    RankingViewController*    m_rankingViewController;
    
    BindPhoneViewController         *m_bindPhoneVC;
    BindPhoneCheckViewController    *m_bindPhoneCheckVC;
    SettingNicknameVC               *m_settingNickNameVC;
    
    
	
	NSString*       m_highFrequencyInfo;
    NSString*       m_recentEventInfo;
    NSString        *m_jzRecentEventInfo;
    NSString        *m_bdRecentEventInfo;
	
	NSMutableString *tempString;
	NSString        *m_giftMessageText;
	
	NSString*       m_lotteryInformation;
    NSString*       m_lotteryInfoList;
	
	BOOL            isRefresh;//是否刷新发起的合买页面
    
    NSString        *m_TopWinnerInformation;
    
    BOOL            isSafari;// 是否跳转网页，appStore版
    
    BOOL            isBindPhone;
    
    UIAlertView     *m_bindPhoneAlterView;
    UITextField     *m_bindPhoneField;
    
    UIAlertView     *m_bindEmailAlterView;
    UITextField     *m_bindEmailField;
    
    UIAlertView     *m_bindPhoneSecurityAlterView;
    UITextField     *m_bindPhoneSecurityField;
    
    UIAlertView     *m_cancelBindPhoneAlterView;
    
    UIAlertView     *m_cancelBindEmailAlterView;
    
    UIAlertView     *m_cancelOKbindPhoneAlterView;
    UIAlertView     *m_cancelOKbindEmailAlterView;
    
    NSString*       m_newsTitle; //彩票资讯
    
    UIAlertView     *m_setUpNicknameAlterView;
    UITextField     *m_nickNameField;
    
    BOOL            isRefreshUserCenter;//返回到用户中心时刷新
    NSString        *m_userCenterInfo; //用户中心信息：积分 余额等
    
    NSString        *m_presentId;
    
//    BOOL            isHideTabbar;
    
    NSString        *m_activityTitleStr;
    
    NSString        *m_queryRecordCashStr;
    NSString        *m_ticketPropagandaInfo;
    //用来临时保存绑定的手机号；
    NSString        *m_bindNewPhoneNum;
    
    BOOL haveAlert;
}
@property (nonatomic,retain) NSString    *bindNewPhoneNum;
@property (nonatomic,retain) NSString    *ticketPropagandaInfo;
//@property (nonatomic, assign) BOOL isHideTabbar;
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, assign) BOOL m_loginAutoRememberPsw;

@property (nonatomic, assign) BOOL isBindPhone;
@property (nonatomic, assign) BOOL isRefreshUserCenter;
@property (assign) id delegate;
@property (assign) GoBackType goBackType;
@property (assign) NetAppType netAppType;
@property (assign) NetHelpCenterType netHelpCenterCenter;
@property (assign) NetChargeType  netChargeQuestType;
@property (assign) NetLotType netLotType;
@property (nonatomic, retain) NSString* loginName;
@property (nonatomic, retain) NSString* bindName;
@property (nonatomic, retain) NSString* userno;
@property (nonatomic, retain) NSString* phonenum;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* certid;
@property (nonatomic, retain) NSString* bindPhoneNum;
@property (nonatomic, retain) NSString* bindEmail;
@property (nonatomic, retain) NSString* newsPassword;
@property (nonatomic, retain) NSString* softwareInfo;
@property (nonatomic, retain) NSString* highFrequencyInfo;
@property (nonatomic, retain) NSString* recentEventInfo;
@property (nonatomic, retain) NSString* jzRecentEventInfo;
@property (nonatomic, retain) NSString* bdRecentEventInfo;
@property (nonatomic, retain) NSString* realServerURL;
@property (nonatomic, assign) BOOL shouldCheat;
@property (nonatomic, assign) BOOL shouldTurnToAdWall;
@property (nonatomic, assign) BOOL shouldRefreshShaiZiTimer;
@property (nonatomic, assign) int choumaXiao;
@property (nonatomic, assign) int choumaDa;

@property (nonatomic, assign) BOOL requestedAdwallSuccess;
@property (nonatomic, assign) double beginCalOutComment;
@property (nonatomic, retain) NSString* userBalance;
@property (nonatomic, retain) NSString* userLotPea;
@property (nonatomic, retain) NSString* userPrizeBalance;
@property (nonatomic, retain) NSString* remainingChance;
@property (nonatomic, retain) NSString* responseText;
@property (nonatomic, retain) NSString* giftMessageText;
@property (nonatomic, retain) NSString* lotteryInformation;
@property (nonatomic, retain) NSString* lotteryInfoList;
@property (nonatomic, retain) NSString* TopWinnerInformation;
@property (nonatomic, retain) NSString* newsTitle;
@property (assign) FirstPageViewController* firstViewController;
@property (assign) RankingViewController* rankingViewController;
@property (assign) DrawLotteryPageViewController* secondViewController;
@property (assign) RechargeViewController* thirdViewController;
@property (assign) FourthPageViewController* fourthViewController;
@property (assign) FifthPageViewController* fifthViewController;
@property (nonatomic, retain) NSString *m_presentId;
@property (nonatomic, retain) NSString *userCenterInfo; 
@property (nonatomic, retain) NSString* activityTitleStr;
@property (nonatomic, retain) NSString* queryRecordCashStr;
@property (nonatomic, retain) NSString*       newPassword;

@property (nonatomic, assign) BOOL isSafari;
@property (nonatomic, retain) NSString  *thirdOpenId;
@property (nonatomic, retain) NSString  *thirdSource;

+ (RuYiCaiNetworkManager *)sharedManager;
-(int)oneYuanToCaidou;
- (void)requestFinish_Two:(ASINetworkReqestTypeTwo)ASIType withStr:(NSString*)reqStr;


- (NSString*)constructJson:(NSMutableDictionary*)data;
- (NSMutableDictionary*)getCommonCookieDictionary;

- (void)regWithPhonenum:(NSString*)phone withPassword:(NSString*)psw 
			 withCertid:(NSString*)certid withName:(NSString*)name withRecPhonenum:(NSString*)RecPhonenum;
- (void)loginWithPhonenum:(NSString*)phone withPassword:(NSString*)psw;
- (void)loginWithSource:(NSString*)source withOpenId:(NSString*)openId withNickName:(NSString*)nickname;

- (void)selectUsernoWithPhonenum:(NSString*)phone withPassword:(NSString*)psw;

//第三方登录第一次注册并绑定的请求
- (void)thirdRegisterWithPhonenum:(NSString*)phone withPassword:(NSString*)psw
			 withOpenId:(NSString*)openId withSource:(NSString*)source;

- (void)thirdLoginBindWithUserno:(NSString*)userno withOpenId:(NSString*)openId withSource:(NSString*)source;

//软件更新（用以获取软件基本信息及各彩种的期号、开奖日期信息）
- (void)updateImformationOfLotteryInServers;//获取彩种后台配置的顺序和显示信息
- (void)updateImformationOfPayStationInServers;//获取充值中心支付方式

-(void)cancelAutoLoginStatus;
-(void)checkNewVersion;
-(void)getExchangeScaleForAdwall;
-(void)queryRecommandedAppList:(NSString *)theType;
-(void)doShakeCheckInWithActID:(NSString *)actID AndCheckID:(NSString *)checkID;
-(void)queryShakeActList;
-(void)queryshakeSigninDescription:(NSString *)keyStr;
-(void)queryMyAwardCardListWithPage:(NSString *)thePage;
- (void)softwareUpdate;
- (void)updateUserInformation;
-(void)getAdWallImportantInfo;
// 首页广告信息获取
- (void)queryADInformation;
// 今日开奖、加奖
- (void)queryTodayOpenOrAdd;

//投注
- (void)betLotery:(NSMutableDictionary*)otherDict;
- (void)getGiftMessage;

//参与合买查询
- (void)queryCaseLotOfPage:(NSUInteger)pageIndex;

//足彩信息
- (void)zcInquiry:(NSString*)batchCode withLotNo:(NSString*)lotNo;

//竞彩篮球 对阵
- (void)QueryJCLQDuiZhen:(NSString*)jingcaiType JingCaiValueType:(NSString*)jingcaivalueTypel;
- (void)getBJDCDuiZhen:(NSString*)_batchCode withLotNo:(NSString*)lotno;
- (void)getBJDCDuiZhenComplete:(NSString*)reqStr;

//竞彩 获得球队数据分析 篮球：requestType = dataAnalysisJcl    足球：requestType = dataAnalysis
- (void)getDataAnalysis:(NSString*)event REQUESTTYPE:(NSString*)requestType ISZC:(int)lotType;
- (void)getDataAnalysis:(NSString*)event REQUESTTYPE:(NSString*)requestType;
//- (void)getInstantScore:(NSString*)state  DATE:(NSString*)date  REQUESTTYPE:(NSString*)requestType;
- (void)getInstantScore:(NSMutableDictionary*) dictionary;
//- (void)getInstantScoreDetail:(NSString*)event REQUESTTYPE:(NSString*)requestType;
- (void)getInstantScoreDetail:(NSMutableDictionary*)dictionary;
//参与合买
- (void)betCaseLot:(NSMutableDictionary*)otherDict;
//- (void)betWayButton:(UIButton*)sender;

//所有合买查询
- (void)queryAllCaseLot:(NSMutableDictionary*)otherDict;

//合买详情
- (void)queryCaseLotDetail:(NSMutableDictionary*)otherDict;

//发起合买
- (void)launchLot:(NSMutableDictionary*)otherDict;
//合买成功后分享内容从后台获取
- (void)launchLotShareDetile:(NSString*)caseLotId;
/*合买--定制跟单
    starter	String	发起人用户编号
    times	String	跟单次数	 
    joinAmt	String	跟单金额
    joinType	String	跟单类型
 
 */
- (void)createAutoJoin:(NSString*)starter LOTNO:(NSString*)lotNo JOINAMT:(NSString*)joinAmt TIMES:(NSString*)times  JOINTYPE:(NSString*)joinType PERCENT:(NSString*)percent  MAXAMT:(NSString*)maxAmt FORCEJOIN:(NSString*)forceJoin;
//查询合买发起人信息
- (void)queryLaunchLotStater:(NSString*)starterUserNo LOTNO:(NSString*)lotNo;
//定制跟单查询
- (void)queryCaseLot_autoOrderOfPage:(NSUInteger)pageIndex;
//撤销定制跟单
- (void)cancelAutoOrder:(NSString*)caseId;
//更新（修改定制跟单）----次数不可以修改
- (void)modifyAutoOrder:(NSString*)caseId JOINAMT:(NSString*)joinAmt /*TIMES:(NSString*)times */ JOINTYPE:(NSString*)joinType PERCENT:(NSString*)percent  MAXAMT:(NSString*)maxAmt FORCEJOIN:(NSString*)forceJoin;

//开奖公告
- (void)getLotteryInformation:(NSString*)maxResult lotno:(NSString*)lotno;
- (void)getLotteryInfoList:(NSString*)pageIndex lotNo:(NSString*)lotno;
- (void)getLotteryDetailInfo:(NSString*)lotno batchCode:(NSString*)batchCode;
- (void)getLotteryAwardInfoDetailInfo:(NSString*)lotno batchCode:(NSString*)batchCode;
- (void)getJCLotteryInfor:(NSString*)date JCtype:(NSString*)JCtype;
- (void)getJCLotteryInfor:(NSMutableDictionary*)otherDict;

//登陆对话框
- (void)setupLoginAlertView;
- (void)setupLoginAlertViewAndAddAnimation:(BOOL)animationType;
- (void)showLoginAlertView;
- (void)showLoginAlertViewAndAddAnimation:(BOOL)animationType;
//- (void)forgetPasswordClick:(id)sender;
- (void)readUserPlist;

- (void)findPasswordWithPhone:(NSString*)userName bindPhone:(NSString*)phoneNum;

//更改用户对话框
- (void)showChangeUserAlertView;

//基本提示视图
- (void)showMessage:(NSString*)message withTitle:(NSString*)title buttonTitle:(NSString*)buttonTitle;

//进度提示视图
- (void)showProgressViewWithTitle:(NSString*)title message:(NSString*)message net:(ASIHTTPRequest*)myRequest;
//- (void)showURLProgressViewWithTitle:(NSString*)title message:(NSString*)message;

//投注订单详情视图
//- (void)showLotSubmitMessage:(NSString*)messsage withTitle:(NSString*)title;

//获取软件版本信息（第一个逗号之前的文字内容，中间使用逗号分隔开）
- (NSArray*)getSoftwareVersionInfo;

//检测软件升级
- (BOOL)checkSoftwareVersion;

//获取彩种的期号
- (NSString*)getBatchCodeOfLot:(NSString*)lotCode;

//获取彩种的开奖日期
- (NSString*)getEndtimeOfLot:(NSString*)lotCode;

-(void)queryRemainingIDFA;
-(void)doGoodCommentWithID:(NSString *)theID;
-(void)queryADWallList;
-(void)doQianDaoWithID:(NSString *)theID;
-(void)queryRemainingChanceForLot;
-(void)queryActListWithPage:(NSString *)thePage;
//获取高频彩种的剩余时间和当前期数
- (void)highFrequencyInquiry:(NSString*)lotNo;
- (NSString*)highFrequencyLeftTime;
- (NSString*)highFrequencyLastEvent;
- (NSString*)jzHighFrequencyLastEvent;
- (NSString*)bdHighFrequencyLastEvent;
- (NSString*)highFrequencyCurrentCode;
- (NSString*)highFrequencyEndTime;
//获取高频彩种的开奖信息。（除当前期以外包括未开奖的期都会返回开奖信息）
- (void)highFrequencyInquiryTheWinningInformation:(NSString*)lotNo Maxresult:(NSInteger)maxresult;

//彩种信息获取
- (void)lotteryInquiry:(NSString*)lotNo reqestType:(ASINetworkReqestType)type;
- (void)lotterySSQInquiry;
- (void)lotteryDLTInquiry;
- (void)lotteryFC3DInquiry;
- (void)lottery11YDJInquiry;
- (void)lottery115Inquiry;
- (void)lotterySSCInquiry;
- (void)lotteryJCZQInquiry;
- (void)lotteryKLSFInquiry;
- (void)lotteryCQSFInquiry;
- (void)lotteryGD115Inquiry;
- (void)lotteryQLCInquiry;
- (void)lotteryPLSInquiry;
- (void)lotteryPLWInquiry;
- (void)lotteryQXCInquiry;
- (void)lottery22X5Inquiry;
- (void)lotteryNMKSInquiry;
- (void)lotteryCQ115Inquiry;

//查询彩种宣传语
- (void)requestTicketPropaganda;

- (void)highFrequencyAllInquiry:(NSString*)lotNo;
//获得排行榜
- (void)getTopWinnerInformation;
//检查网络
- (BOOL)testConnection;

//彩票资讯
- (void)getInformation:(NSInteger)type  withLotNo:(NSString*)lotNo maxresult:(NSInteger)maxNum;
- (void)getInformation:(NSInteger)type withLotNo:(NSString*)lotNo;
- (void)getInformationContent:(NSInteger)typeId;

//活动中心
- (void)getActivityTitle:(NSInteger)pageIndex;
- (void)getActivityDetail:(NSString*)activityId;

//专家荐号
- (void)getExpertCode:(NSString*)type;

+ (NSData * )decodeBase64:(NSData * )data;
+ (NSString*)encodeBase64:(NSData*)data;


/* 
 ///////////////////////////////////////////////////
 RuYiCaiNetworkManager 请求响应
 ///////////////////////////////////////////////////
 */
- (void)updateInformationOfLotteryInServers:(NSString*)resText;
- (void)updatePayStationInServers:(NSString*)resText;
- (void)softUpdateComplete:(NSString*)resText;
- (void)updateImformationComplete:(NSString*)resText;
//- (void)unionLoginComplete:(NSString*)resText;
- (void)loginComplete:(NSString*)resText;
- (void)selectUsernoComplete:(NSString*)resText;
- (void)loginOKLater;
- (void)regComplete:(NSString*)resText;
- (void)thirdRegisterComplete:(NSString*)resText;
- (void)thirdLoginBindComplete:(NSString*)resText;

- (void)sendFeedbackComplete:(NSString*)resText;
- (void)highFrequencyComplete:(NSString*)resText;
- (void)highFrequencyALLComplete:(NSString*)resText;
- (void)highFrequencyComplete:(NSString*)resText notifacationType:(NSString *)type;
- (void)getGiftMessageComplete:(NSString*)resText;
- (void)findpasswordComplete:(NSString*)resText;

// 近日开奖、加奖
- (void)queryTodayOpenOrAddComplete:(NSString*)resText;

//彩民英雄榜
- (void)getTopWinnerComplete:(NSString*)resText;

//彩票资讯
#define CAI_MIN_ZHUAN_QU (1)
#define ZHUAN_JIA_TUI_JIAN (2)
#define ZU_CAI_TIAN_DI (3)
#define ZHAN_NEI_GONG_GAO (4)
- (void)getInformationComplete:(NSString*)resText RequestType:(NSInteger)type;
- (void)getInformationComplete:(NSString*)resText;
- (void)getInformationContentComplete:(NSString*)resText;

//合买大厅
- (void)queryCaseLotComplete:(NSString*)resText;
- (void)betCaseLotComplete:(NSString*)resText;
- (void)queryAllCaseLotComplete:(NSString*)resText;
- (void)queryCaseLotDetailComplete:(NSString *)resText;
- (void)launchLotComplete:(NSString*)resText;
- (void)launchLotGeShareComplete:(NSString*)resText;


//合买大厅--定制跟单
- (void)createAutoJoinComplete:(NSString*)resText;
//定制跟单--查询合买发起人信息
- (void)queryLaunchLotStaterComplete:(NSString*)resText;
//定制跟单--定制跟单查询
- (void)queryCaseLot_autoOrderComplete:(NSString*)resText;
//撤销定制跟单
- (void)cancelAutoOrderComplete:(NSString*)resText;
//更新（修改定制跟单）----次数不可以修改
- (void)modifyAutoOrderComplete:(NSString*)resText;

//获取开奖公告响应
- (void)getLotteryInformationComplete:(NSString*)resText;
- (void)getLotteryInfoListComplete:(NSString*)resText;
- (void)getLotteryDetailInfoComplete:(NSString*)resText;
- (void)getLotteryAwardInfoComplete:(NSString *)resText;
- (void)getJCLotteryInforComplete:(NSString*)resText;

//投注响应
- (void)submitLotComplete:(NSString*)resText;

//活动中心
- (void)getActivityTitleComplete:(NSString*)resText;
- (void)getActivityContentComplete:(NSString*)resText;

//专家荐号
- (void)getExpertCodeComplete:(NSString*)resText;

- (void)geJCLQDuiZhenComplete:(NSString*)resText;
- (void)getDataAnalysisOKComplete:(NSString*)resText;
- (void)getInstantScoreComplete:(NSString*)resText;
- (void)getInstantScoreDetailComplete:(NSString*)resText;
//头部新闻
- (void)getTopNewsContent;
- (void)getTopNewsContentComplete:(NSString*)resText;
//猜大小游戏
- (void)queryCurrentLotDetailWithgameNo:(NSString *)gameNum AndissueNo:(NSString *)issueNo;
- (void)queryCurrIssueMessage;
- (void)queryIssueHistoryWithPage:(NSString*)page count:(NSString*)count;
- (void)betWithIssueNo:(NSString*)issueNo beanNoWithBig:(NSString*)Bbean beanNoWithSmall:(NSString*)Sbean;
- (void)queryGameOrdersWithPage:(NSString*)page count:(NSString*)count;
// 邀请好友
- (void)promotionInviter;
- (void)queryInviteRecordWithPage:(NSString*)page count:(NSString*)count;
@end

/* 
 ///////////////////////////////////////////////////
 用户中心 --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiNetworkManager_Catagory_Center_Request)
//用户中心
- (void)UpdateUserInfo;
- (void)handleUserCenterClick;
- (void)handleUserCenterClick2;
- (void)queryLotWinOfPage:(NSUInteger)pageIndex;
- (void)queryLotBetOfPage:(NSUInteger)pageIndex lotNo:(NSString*)lotno;
- (void)queryTrackOfPage:(NSUInteger)pageIndex;
- (void)cancelTrack:(NSString*)tsubscribeNo;
- (void)queryGiftOfPage:(NSUInteger)pageIndex hasGift:(BOOL)isGift;
- (void)queryAccountDetailOfPage:(NSUInteger)pageIndex transactionType:(NSUInteger)type;
- (void)queryCaidouDetailOfPage:(NSUInteger)pageIndex requestType:(NSString*)type;
- (void)queryUserBalance;

- (void)getZQRecentlyEvent:(NSString*)numId;
- (void)getBDRecentlyEvent:(NSString*)numId;


- (void)getRecentlyEvent:(NSString*)numId;
- (void)queryCash;
- (void)queryRecordCash:(NSString*)pageIndex maxResult:(NSString*)maxResult;
- (void)getCash:(NSMutableDictionary*)otherDict;
- (void)cancelCash:(NSMutableDictionary*)otherDict;

- (void)updateUserCenter:(NSString*)resText;
- (void)nickNameSet:(NSString*)nickname;
- (void)queryLeaveMessage:(NSString*)pageIndex;
//- (void)receiveLotterySecurity:(NSString*)presentId;
//- (void)receiveLottery:(NSString*)security;
- (void)getIntegralInfo:(NSString*)pageIndex;
- (void)integralTransMoneyNeedsScores;
- (void)transIntegral:(NSString*)score;

- (void)getBetDetailWithDic:(NSMutableDictionary*)inforDic;//投注明细

//领取彩票
- (void)showReceiveLotteryAlterView;
- (void)cancelSecurityReceiveClick:(id)sender;
- (void)submitSecurityReceiveClick:(id)sender;

//账户充值
- (void)queryDNA;
- (void)chargeDNA:(NSMutableDictionary*)otherDict;
- (void)chargeByPhoneCard:(NSMutableDictionary*)otherDict;
- (void)chargeByAlipay:(NSMutableDictionary*)otherDict;
- (void)chargeByUnionBankCard:(NSMutableDictionary*)otherDict;
- (void)umpayByCredit:(NSMutableDictionary*)otherDict;
- (void)wealthTenpayFor:(NSMutableDictionary*)otherDict;

//绑定身份证和手机对话框
- (void)bindWithCertid:(NSString*)certNum tureName:(NSString*)turename;
- (void)getBindPhoneSecurityCode:(NSString*)bindEmail;
- (void)getBindEmailSecurityCode:(NSString*)bindPhone;
- (void)bindPhoneNumWithSecurity:(NSString*)securityCode;
- (void)bindNewEmail;
- (void)cancelBindPhone;
- (void)cancelBindEmail;

- (void)bindCertid;
//- (void)setUpBindCertidView;
//- (void)cancelCertidClick:(id)sender;
//- (void)submitCertidClick:(id)sender;

- (void)bindPhone;
- (void)setUpBindPhoneView;
- (void)cancelPhoneClick:(id)sender;
- (void)submitPhoneClick:(id)sender;

- (void)setUpBindPhoneSecurityView;
- (void)cancelSecurityPhoneClick:(id)sender;
- (void)submitSecurityPhoneClick:(id)sender;

- (void)setUpCancelBindPhoneView;
- (void)cancelCancelBindPhoneClick:(id)sender;
- (void)submitCancelBindPhoneClick:(id)sender;

- (void)setCancelOKbindPhoneView;
- (void)setCancelOKbindEmailView;
- (void)cancelCancelOKBindPhoneClick:(id)sender;
- (void)submitCancelOKBindPhoneClick:(id)sender;

//设置昵称
- (void)setUpNickName;
- (void)cancelNicknameClick:(id)sender;
- (void)submitNickNameClick:(id)sender;

//密码修改
- (void)changeUserPsw:(NSString*)oldPsw withNewPsw:(NSString*)newPsw;

//用户反馈
- (void)sendFeedBack:(NSString*)content contactWay:(NSString*)contactway;
//- (void)sendFeedBack:(NSString*)content contactWay:(NSString*)contactway qNumTextField:(NSString*)qNumTextField;
//获取验证码
- (void)getCheckoutNoWithPhongNo:(NSString*)phoneNo requestType:(NSString*)type;
//验证yanzhengma
- (void)checkoutCaptchaNoWithPjoneNo:(NSString*)phoneNo CaptchaNo:(NSString*)CaptchaNo;
@end
/*
 ///////////////////////////////////////////////////
 用户中心 请求响应  --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiNetwork_Category_UserCenter_ReqComplete) 
//用户中心响应
- (void)queryLotWinComplete:(NSString*)resText;
- (void)queryLotBetComplete:(NSString*)resText;
- (void)queryTrackComplete:(NSString*)resText;
- (void)cancelTrackComplete:(NSString*)resText;
- (void)queryBalanceComplete:(NSString*)resText;
- (void)queryRecentlyEventComplete:(NSString *)resText notifacationType:(NSString *)type;

- (void)queryADInformationComplete:(NSString*)resText;

- (void)queryGiftComplete:(NSString*)resText;
- (void)queryAccountDetailComplete:(NSString*)resText;
- (void)queryCashComplete:(NSString*)resText;
- (void)getCashComplete:(NSString*)resText;
- (void)cancelCashComplete:(NSString*)resText;
- (void)queryRecordCashComplete:(NSString*)resText;

- (void)bindCertidComplete:(NSString*)resText;
- (void)bindPhoneSecurityComplete:(NSString*)resText;
- (void)bindEmailSecurityComplete:(NSString*)resText;
- (void)bindPhoneComplete:(NSString*)resText;
- (void)cancelBindPhoneComplete:(NSString*)resText;
- (void)cancelBindEmailComplete:(NSString*)resText;

- (void)setNicknameComplete:(NSString*)resText;

- (void)queryLeaveMessageComplete:(NSString *)resText;
//- (void)receiveLotterySecurityComplete:(NSString*)resText;
//- (void)receiveLotteryComplete:(NSString*)resText;
- (void)getIntegralInfoComplete:(NSString*)resText;
- (void)integralTransMoneyNeedsScoresComplete:(NSString*)resText;
- (void)transIntegralComplete:(NSString*)resText;

- (void)updatePassComplete:(NSString *)resText;

- (void)getBetDetailComplete:(NSString*)resText;
//账户充值响应
- (void)queryDNAComplete:(NSString*)resText;
- (void)chargeDNAComplete:(NSString*)resText;
- (void)chargeByPhoneCardComplete:(NSString *)resText;
- (void)chargeByAlipayComplete:(NSString *)resText;
- (void)chargeByUnionBankCardComplete:(NSString*)resText;
- (void)chargeByUmpayCreDitComplete:(NSString*)resText;
- (void)chargeByWealthTenpayComplete:(NSString*)resText;
@end

/* 
 ///////////////////////////////////////////////////
 彩种请求 --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiLotNet_Request)

//NET_LOT_BASE ；合买参与人员;新版本介绍；银行充值中银行查询; 各彩种玩法介绍; 高频彩订单页期号查询；代理充值；合买各彩种截止时间倒计时查询；
//开奖公告 NET_LOTTERY_INFOR
- (void)querySampleLotNetRequest:(NSDictionary*)dict isShowProgress:(BOOL)showPro;
//NET_QUXIAO合买撤单；合买撤资；分享增加积分
- (void)quXiaoNetRequest:(NSDictionary*)dict;
- (void)getLotMissdateWithLotno:(NSString*)lotno sellWay:(NSString*)sellWay;//获取彩种遗落值
- (NSString *)configurationMissdateDictWithLotno:(NSString*)lotno sellWay:(NSString*)sellWay;//构造遗漏请求字典
- (void)getLotMissdateWithString:(NSString*)configurationString;//获取彩种遗落值(大接口，即多个类型的遗漏值)
- (void)getShouYiLvBatchList:(NSString*)lotno;//收益率期号

- (void)computeShouYiLvWithLotno:(NSString*)lotno batchcode:(NSString*)batchcode batchnum:(NSString*)batchnum lotmulti:(NSString*)lotmulti wholeYield:(NSString*)wholeYield beforeBatchNum:(NSString*)beforeBatchNum beforeYield:(NSString*)beforeYield afterYield:(NSString*)afterYield;
- (void)queryHistoryTrackDetail:(NSString*)trackId;

- (void)lotteryZCInquiry;
- (void)queryZCIssueBatchCode:(NSString*)lotNo;//足彩预售期

@end

/* 
 ///////////////////////////////////////////////////
 彩种请求响应 --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiLotNet_ReqComplete)

- (void)getLotDateOk:(NSString*)resText;

- (void)querySampleLotNetRequestComplete:(NSString*)resText;
- (void)quXiaoNetRequestComplete:(NSString*)resText;
//彩种遗落值响应
- (void)getLotMissdateComplete:(NSString*)resText;
- (void)getShouYiLvBatchListComplete:(NSString*)resText;
- (void)computeShouYiLvComplete:(NSString*)resText;
- (void)queryHistoryTrackDetailComplete:(NSString*)resText;
- (void)queryZCIssueBatchCodeComplete:(NSString*)resText;
- (void)updateZCInformationBatchCodeComplete:(NSString*)resText;

@end

/* 
 ///////////////////////////////////////////////////
 充值请求 --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiNetCharge_Request)

//NET_SAMPLE_QUERY 
- (void)querySampleChargeNetRequest:(NSDictionary*)dict isShowProgress:(BOOL)showPro;
- (void)chargeBySecurityAlipay:(NSMutableDictionary*)otherDict;
- (void)chargeByLaKaLa:(NSMutableDictionary*)otherDict;

- (void)queryChargeWarnStr:(NSString*)keyStr;
- (void)exchangeLotPeaWithAmount:(NSString*)amount;
- (void)getMessageListWithPage:(NSString*)page;
- (void)getMessageDetailWithID:(NSString*)ID;
- (void)getNotificationWithID: (NSString *)ID;
- (void)getTopOneMessage;
@end

/* 
 ///////////////////////////////////////////////////
 充值请求响应 --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiNetCharge_ReqComplete)
//
- (void)querySampleChargeNetRequestComplete:(NSString*)resText;

- (void)chargePageWithType:(NSString*)resText;
- (void)chargeBySecurityAlipayComplete:(NSString*)resText;
- (void)chargeByLaKaLaComplete:(NSString*)resText;
- (void)queryChargeWarnStrComplete:(NSString*)resText;

@end
/* 
 ///////////////////////////////////////////////////
 下载连网 --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiDownLoad_Net)

- (void)sendException:(NSString*)excContent;//异常处理
/*获取服务器上开机图片 */
- (void)getStartImage:(NSString*)image_url;
- (void)getStartImageComplete:(NSData*)imageData;

- (BOOL)sameStartImageId;
- (NSString*)getStartImagePath;
- (void)readStartImagePath;
- (void)saveStartImagePath;
- (void)resetImagePlist;

- (NSString*)getStartImgRecordPath;
- (void)readStartImgRecordPath;
- (void)saveStartImgRecordPath;



/*获取服务器上广告图片 */
- (void)getADImage:(NSArray*)imageUrls;
- (void)getADImageComplete:(NSData*)imageData andImageId:(NSString *)imageId withIndex:(NSInteger)index;
- (BOOL)sameADImageIdWithNewUrl:(NSArray *)urls;
- (void)saveADImagePath;
- (void)readADImagePath;

- (void)readADImgRecordPath;



//头部活动请求
- (NSString*)getTopActionIdPath;
- (void)readTopActionIdPath;
- (void)saveTopActionIdPath;

@end

/* 
 ///////////////////////////////////////////////////
 更多页面里的连网 --- RuYiCaiNetworkManager的类别
 ///////////////////////////////////////////////////
 */
@interface RuYiCaiNetworkManager(RuYiCaiNetHelpCenter)

- (void)helpCenterNetType:(NSString*)resText;
- (void)helpCenterNetType:(NSString*)resText withType:(NSInteger)type;
//服务设置
- (void)queryMessageSetting;
- (void)queryMessageSettingComplete:(NSString*)resText;
- (void)messageSetting:(NSString*)info;
- (void)messageSettingComplete:(NSString*)resText;

//帮助中心查询
- (void)queryHelpTitleWithType:(NSString*)type;
- (void)queryHelpTitleComplete:(NSString*)resText;
- (void)queryHelpTitleComplete:(NSString*)resText withType:(NSInteger)type;
- (void)queryHelpContentWithId:(NSString*)contentId;
- (void)queryHelpContentComplete:(NSString*)resText;

@end