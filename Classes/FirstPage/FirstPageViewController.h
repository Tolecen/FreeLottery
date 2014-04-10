//
//  FirstPageViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RuYiCaiAppDelegate.h"
#import "RuYiCaiNetworkManager.h"
#import "UINavigationBarCustomBg.h"
#import "AOScrollerView.h"
#import "PullRefreshTableViewController.h"
#import "LotteryInfoTableViewCell.h"
#import "LotteryAwardInfoViewController.h"
#import "Custom_tabbar.h"
#import "JCLotteryView.h"
#import "ZCOpenLotteryViewController.h"
#import "InstantScoreViewController.h"
#import "AnimationTabView.h"
#import "FirstPageTopCell.h"
typedef enum{
    LOTTERY_SHUANG_SE_QIU = 0,
    LOTTERY_DA_LE_TOU,
    LOTTERY_FU_CAI_3D,
    LOTTERY_JING_CAI_ZU_QIU,
    LOTTERY_BEI_JING_DAN_CHANG,
    LOTTERY_NEI_MENG_KUAI_SAN,
    LOTTERY_CHONG_QING_11_5,
    LOTTERY_SHAN_DONG_SHI_YI_YUN_DUO_JIN,
    LOTTERY_JIANG_XI_11_XUAN_5,
    LOTTERY_SHI_SHI_CAI,
    LOTTERY_GUANG_DONG_KUAI_LE_10_FEN,
    LOTTERY_GUANG_DONG_11_XUAN_5,
    LOTTERY_QI_LE_CAI,
    LOTTERY_PAI_LIE_SAN,
    LOTTERY_PAI_LIE_WU,
    LOTTERY_QI_XING_CAI,
//    LOTTERY_22_XUAN_5,
    LOTTERY_ZU_CAI,
    LOTTERY_JING_CAI_LAN_QIU,
    LOTTERY_CHONG_QING_KAUI_SHI,
}LotteryType;
typedef enum {
    
    JC_ZQ_TYPE2 = 0,
    JC_LQ_TYPE2,
    JC_BD_TYPE2,
    
} JCType2;
@interface FirstPageViewController : UIViewController <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ValueClickDelegate,UIAlertViewDelegate>
{
    BOOL canShowM;
    CAKeyframeAnimation * animation;
    UITableView        *m_tableView;
    UIButton           *m_adBtnView;
    UIButton           *m_closeADBtn;
//	UIScrollView       *m_scroll;
    UILabel            *m_versionLabel;
    NSArray*            m_versionStrArray;
    
    UIButton           *m_button_HMDT; //合买大厅
    UIButton           *m_button_ZJJH; //专家荐号
    UIButton           *m_button_XYXH; //幸运选号

	UIButton           *m_button_SSQ;  //双色球
	UIButton           *m_button_FC3D; //福彩3D
    
    UIButton           *m_button_115;  //11选5
    UIButton           *m_button_DLT;  //大乐透
    UIButton           *m_button_SSC;  //时时彩
    
	UIButton           *m_button_QLC;  //七乐彩
	UIButton           *m_button_PLS;  //排列3
   	UIButton           *m_button_7XC;  //七星彩
	
	UIButton           *m_button_PLW;  //排列5
	UIButton           *m_button_ZC;   //胜负彩
//	UIButton           *m_button_RJC;   //任九场
//	UIButton           *m_button_JQC;   //进球彩
//	UIButton           *m_button_LCB;   //六场半
    UIButton           *m_button_11YDJ;   //十一运夺金
    UIButton           *m_button_JCLQ;   //精彩篮球
    UIButton           *m_button_22_5;   //22选5
    
    UIButton*          m_button_jczu;    //竞彩足球
    UIButton*          m_button_gz115;  //广东11选5
    UIButton*          m_button_klsf;  //广东快乐十分
    
    UILabel         *label_HMDT;
    UILabel         *label_ZJJH;
    UILabel         *label_XYXH;
    
    UILabel         *label_SSQ;
    UILabel         *label_DLT;
    UILabel         *label_FC3D;
    UILabel         *label_SSC ;
    UILabel         *label_115;
    UILabel         *label_JCLQ;
    UILabel         *label_jczu;
    UILabel         *label_11YDJ;
    UILabel         *label_PLS;
    UILabel         *label_QLC;
    UILabel         *label_22_5;
    UILabel         *label_PLW;
    UILabel         *label_7XC;
    UILabel         *label_ZC;
    UILabel         *label_gz115;
    UILabel         *label_klsf;
    

    
    UILabel            *m_loginStatus; //登录状态
    UIBarButtonItem    *m_button_Login;//登录
	
//    NSTimer*            m_timer;
	RuYiCaiAppDelegate *m_delegate;
	
	//UIPageControl      *m_pageController;
	
	UIImageView        *m_imagePageOne;
	UIImageView        *m_imagePageTwo;
    UIImageView        *m_imagePageThere;
    
    BOOL netFailedAlertShown;
    
    
    UIBarButtonItem * buyButton;
    UIBarButtonItem * infoButton;
    
    UIImageView * btnNormalBtnImgv;
    UIImageView * btnHilightBtnImgV;
    
    UIButton * buyButton1;
    UIButton * buyButton2;
    
#ifndef isBOYA
    UIImageView        *m_imagePageFour;
    
    UIButton           *zhouButton;
    UIButton           *yueButton;
    UIButton           *zongButton;
    
    NSArray            *m_topWinArray;
    
    BOOL               isRefresWinner;
    int                topWay;
    
//    UITableView        *m_winTableView;
//    
//    UIView                  *refreshHeaderView;
//    UILabel                 *refreshLabel;
//	UILabel                 *refreshDate;
//    UIImageView             *refreshArrow;
//    UIActivityIndicatorView *refreshSpinner;
//    BOOL                    isDragging;
//    BOOL                    isLoading;
    
    BOOL                    isAddHeadView;
    BOOL                    _tableViewType;
    NSTimer*                    timer_11YDJ;
    NSTimer*                    timer_115;
    NSTimer*                    timer_SSC;
    NSTimer*                    timer_JCLQ;
    NSTimer*                    timer_BJDC;
    NSTimer*                    timer_JCZQ;
    NSTimer*                    timer_KLSF;
    NSTimer*                    timer_CQSF;
    NSTimer*                    timer_NMKS;
    NSTimer*                    timer_CQ115;
    NSTimer*                    timer_GD115;
    NSTimer*                    timer_QLC;
    NSTimer*                    timer_PLS;
    NSTimer*                    timer_PLW;
    NSTimer*                    timer_QXC;
    NSTimer*                    timer_22X5;
    NSMutableArray              *m_activityIdArray;
//    NSString                    *m_lastEventStr;
//    NSString                    *m_jZLastEventStr;
    NSMutableDictionary              *m_ticketPropagandaDic;
    
#endif
    
    NSUInteger          m_cellCount;
    
    NSMutableArray*            m_cellTitleArray;
    JCType2 m_jcType;
}
//@property (nonatomic, retain) NSString *jZLastEventStr;
//@property (nonatomic, retain) NSString *lastEventStr;
//@property (nonatomic, retain) UIScrollView *scroll;
@property (nonatomic, retain) NSMutableArray    *activityIdArray;
@property (nonatomic, retain) NSMutableDictionary    *ticketPropagandaDic;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIScrollView *bgScrollV;
@property (nonatomic, retain) UITableView *tableView2;
@property (nonatomic, retain) UIButton *adBtnView;
@property (nonatomic, retain) UIButton *closeADBtn;
@property (nonatomic, retain) UIButton *setMoreLotteryButton;
@property (nonatomic, retain) UIButton *button_HMDT;
@property (nonatomic, retain) UIButton *button_SSQ;
@property (nonatomic, retain) UIButton *button_FC3D;

@property (nonatomic, retain) UIButton *button_115;
@property (nonatomic, retain) UIButton *button_DLT;
@property (nonatomic, retain) UIButton *button_SSC;

@property (nonatomic, retain) UIButton *button_QLC;
@property (nonatomic, retain) UIButton *button_PLS;
@property (nonatomic, retain) UIButton *button_ZC;
@property (nonatomic, retain) UIButton *button_PLW;
@property (nonatomic, retain) UIButton *button_7XC;
//@property (nonatomic, retain) UIButton  *button_RJC;   //任九场
//@property (nonatomic, retain) UIButton  *button_JQC;   //进球彩
//@property (nonatomic, retain) UIButton  *button_LCB;   //六场半
@property (nonatomic, retain) UIButton  *button_11YDJ;   //十一运夺金
@property (nonatomic, retain) UIButton  *button_22_5;//22 选5
@property (nonatomic, retain) UIButton  *button_JCLQ;   //竞彩篮球
@property (nonatomic, assign) LotteryType lotterType;
@property (nonatomic, retain) NSArray *lotNoAry;
@property (nonatomic, retain) NSMutableArray *lotNoEndTimeAry;
@property (nonatomic, retain) NSMutableArray *lotNoBatchCodeNoAry;
@property (nonatomic, retain) NSMutableDictionary *lotNoEndTimeDictionary;
@property (nonatomic, retain) NSMutableDictionary *lotNoBatchEndTimeDictionary;
@property (nonatomic, retain) NSMutableDictionary *lotNoBatchCodeDictionary;
@property (nonatomic, retain) NSMutableArray *isShowPrizeLotteryArray;
@property (nonatomic, retain) NSMutableDictionary *prizeInfomationDictionary;
@property (nonatomic, retain) UITextView *theInfoTextView;
@property (nonatomic, retain) UIView * metionVBG;

@property (nonatomic, assign) BOOL tableViewType;



@property(nonatomic, retain) NSMutableArray          *buttonStatuArr;
@property(nonatomic, retain) NSMutableArray*         cellTitleArray;
@property(nonatomic, assign) JCType2 jcType;
@property (nonatomic, retain) NSMutableArray *showArray2;


- (void)updateLoginStatus;

#ifndef isBOYA
//@property (nonatomic, retain) NSArray            *topWinArray;
//@property (nonatomic, retain) UITableView        *winTableView;
//
//@property (nonatomic, retain) UIView  *refreshHeaderView;
//@property (nonatomic, retain) UILabel *refreshLabel;
//@property (nonatomic, retain) UILabel *refreshDate;
//@property (nonatomic, retain) UIImageView *refreshArrow;
//@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;

- (void)addPullToRefreshHeader;
//- (void)userLoginOK:(NSNotification*)notification;
#endif
@end

@interface FirstPageViewController (FirstPageViewController_category)

- (void)pushLUCkView;//幸运选号

@end
