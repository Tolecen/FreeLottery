//
//  FirstPageViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FirstPageViewController.h"
#import "RYCImageNamed.h"
#import "HMDTGroupByViewController.h"

#import "SSQ_PickNumberViewController.h"
#import "FC3D_PickNumberViewController.h"
#import "DLT_PickNumberViewController.h"
#import "QLC_PickNumberViewController.h"
#import "PLS_PickNumberViewController.h"
#import "X115_PickNumberViewController.h"
#import "SSC_PickNumberViewController.h"
#import "ZC_pickNumberViewController.h"
#import "PLW_PickNumberViewController.h"
#import "QXC_PickNumberViewController.h"
#import "NMKS_PickNumberViewController.h"
#import "KS_PickNumberViewController.h"

#import "FourthPageViewController.h"
#import "RuYiCaiCommon.h"
#import "ZipArchive.h"
#import "NSLog.h"
#import "TopWinnerTableViewCell.h"
#import "BuyLotteryTableViewCell.h"
#import "SBJsonParser.h"
#import "X11YDJ_PickNumberViewController.h"
#import "JCLQ_PickGameViewController.h"
#import "BJDC_pickNumViewController.h"
#import "ActionCenterViewController.h"
#import "ZJJHViewController.h"
#import "X22_5PickNumberViewController.h"
#import "JCZQ_PickGameViewController.h"
#import "GZ11X5_PickNumberViewController.h"
#import "KLSF_PickNumberViewController.h"
#import "ColorUtils.h"
#import "LotteryTypeEditorViewController.h"
#import "BoyacaiADView.h"
#import "CQ115_PickNumberViewController.h"
#import "ActionCenterDetailViewController.h"
#import "CQSF_PickNumberViewController.h"
#import "AdaptationUtils.h"
#import "JZ_MainGameViewController.h"
#import "HXBX_KSBet_ViewController.h"

#define kRYCLabelFontSize  (12)
#define kRYCMainLabelFontSize (14)
#define REFRESH_HEADER_HEIGHT 52.0f

#define kKaiJiangImgTag (412)
#define kJiaJiangImgTag (413)

#define kPerMinuteTimeInterval (60.0)

@interface FirstPageViewController ()
{
    @private
    NSMutableArray* _showLotArray;
    NSMutableArray *_showArray;
    NSMutableArray  *_stateSwitchArr;//总共15个，1表示开，0表示关

}

@property (nonatomic, retain) NSMutableArray *showLotArray;
@property (nonatomic, retain) NSMutableArray *showArray;
@property (nonatomic, retain) NSMutableArray  *stateSwitchArr;//总共15个，1表示开，0表示关
@property (nonatomic, retain) AOScrollerView *ADScrollView;
- (void)setUpShowLotteryList;
- (void)setRecordArray;
@end

@interface FirstPageViewController (internal)

- (void)queryOpenState;
- (void)queryTodayOpenOrAddOK:(NSNotification*)notification;//今日开奖、加奖
- (void)queryADInformationOK:(NSNotification*)notification;//广告url

//- (void)startVersionInfoUpdateTimer;
- (void)setupNavigationBarLeftTitle;
- (void)setupNavigationBarStatus;
- (void)setupTipView;
- (void)newsButtonClick:(id)sender;
- (void)setupMainButtons;
- (void)setupMainTableView;
- (void)setNewButtonFrame;
- (void)addAD;
- (void)actionAD:(NSString *)sender;
- (void)actionCloseAD;
- (void)clearBetData;
- (void)actionSetMoreLottery:(id)sender;


- (void)newThreadRun;


- (void)updateSSQInformation:(NSNotification*)notification;
- (void)updateDLTInformation:(NSNotification*)notification;
- (void)updateFC3DInformation:(NSNotification*)notification;
- (void)update11YDJInformation:(NSNotification*)notification;
- (void)update115Information:(NSNotification*)notification;
- (void)updateSSCInformation:(NSNotification*)notification;

- (void)updateKLSFInformation:(NSNotification*)notification;
- (void)updateGD115Information:(NSNotification*)notification;
- (void)updateQLCInformation:(NSNotification *)notification;
- (void)updatePLSInformation:(NSNotification *)notification;
- (void)updatePLWInformation:(NSNotification *)notification;
- (void)updateQXCInformation:(NSNotification *)notification;
- (void)update22X5Information:(NSNotification *)notification;
- (void)updateZCInformation:(NSNotification*)notification;
- (void)updateNMKSInformation:(NSNotification*)notification;
- (void)updateCQ115Information:(NSNotification*)notification;



- (void)refresh11YDJTime;
- (void)refresh115Time;
- (void)refreshSSCTime;
- (void)refreshKLSFTime;
- (void)refreshGD115Time;
- (void)refreshQLCTime;
- (void)refreshPLSTime;
- (void)refreshPLWTime;
- (void)refreshQXCTime;
- (void)refresh22X5Time;
- (void)refreshNMKSTime;


#ifndef isBOYA
- (void)setupTopwinners;
- (void)pushZhouButton;
- (void)pushYueButton;
- (void)pushZongButton;

- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void)netFailed:(NSNotification*)notification;
#endif
- (void)loginClick;
- (void)changeUserClick;
//- (void)ontimeToRefreshVersionLabel;
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void)pushHMDTView;
- (void)pushSSQView;
- (void)pushFC3DView;
- (void)push115View;
- (void)pushDLTView;
- (void)pushSSCView;
- (void)pushQLCView;
- (void)pushPLSView;
- (void)pushPLWView;
- (void)push7XCView;
- (void)pushNMKSView;
- (void)pushZCView;
- (void)pushBJDCView;

- (void)push11YDJView;
- (void)pushJCLQView;
- (void)pushZJJHView;
- (void)push22_5View;
- (void)pushJCZUView;
- (void)pushGZ115View;

- (void)pushKLSFView;

@end


@implementation FirstPageViewController

@synthesize showLotArray = _showLotArray;
@synthesize showArray = _showArray;
@synthesize stateSwitchArr = _stateSwitchArr;
//@synthesize scroll = m_scroll;
@synthesize button_HMDT = m_button_HMDT;
@synthesize button_SSQ = m_button_SSQ;
@synthesize button_FC3D = m_button_FC3D;
@synthesize button_115 = m_button_115;
@synthesize button_DLT = m_button_DLT;
@synthesize button_SSC = m_button_SSC;
@synthesize button_QLC = m_button_QLC;
@synthesize button_PLS = m_button_PLS;
@synthesize button_ZC = m_button_ZC;
@synthesize button_PLW = m_button_PLW;
@synthesize button_7XC = m_button_7XC;
@synthesize tableView = m_tableView;
@synthesize tableView2;
@synthesize bgScrollV;
@synthesize adBtnView = m_adBtnView;
@synthesize closeADBtn = m_closeADBtn;
@synthesize setMoreLotteryButton = m_setMoreLotteryButton;
@synthesize ADScrollView = _ADScrollView;
@synthesize theInfoTextView;
@synthesize metionVBG;

@synthesize buttonStatuArr = m_buttonStatuArr;
@synthesize cellTitleArray = m_cellTitleArray;
@synthesize jcType = m_jcType;
@synthesize showArray2;
//@synthesize lastEventStr = m_lastEventStr;
//@synthesize jZLastEventStr = m_jZLastEventStr;

//@synthesize button_RJC = m_button_RJC;   
//@synthesize button_JQC = m_button_JQC;  
//@synthesize button_LCB = m_button_LCB;

@synthesize button_11YDJ = m_button_11YDJ;
@synthesize button_JCLQ = m_button_JCLQ;

@synthesize button_22_5 = m_button_22_5;
@synthesize lotterType;
@synthesize lotNoAry;
@synthesize lotNoEndTimeAry;
@synthesize lotNoBatchCodeNoAry;
@synthesize lotNoBatchCodeDictionary;
@synthesize lotNoEndTimeDictionary;
@synthesize lotNoBatchEndTimeDictionary;
@synthesize prizeInfomationDictionary;
@synthesize isShowPrizeLotteryArray;
@synthesize tableViewType = _tableViewType;
@synthesize activityIdArray = m_activityIdArray;
@synthesize ticketPropagandaDic = m_ticketPropagandaDic;

#ifndef isBOYA
//@synthesize topWinArray = m_topWinArray;
//@synthesize winTableView = m_winTableView;
//@synthesize refreshHeaderView, refreshLabel, refreshDate, refreshArrow, refreshSpinner;
#endif

- (void)dealloc 
{
    [self.tableView2 release];
    [self.bgScrollV release];
    [m_cellTitleArray release], m_cellTitleArray = nil;
    [m_buttonStatuArr release], m_buttonStatuArr = nil;
    
    
    
    
    [btnHilightBtnImgV release];
    [theInfoTextView release];
    [metionVBG release];
    [m_ticketPropagandaDic release];
    [m_activityIdArray release];
    //    [m_timer invalidate];
//    [m_jZLastEventStr release];
//	[m_lastEventStr release];
    [_showLotArray release];
    [_showArray release];
    [_stateSwitchArr release];
    [_ADScrollView release];
    
//	[m_scroll release];
    [m_tableView release];
    [m_adBtnView release];
    [m_closeADBtn release];
    [m_setMoreLotteryButton release];
    [m_versionLabel release];
	
	[m_button_HMDT release];
    [m_button_ZJJH release]; //专家荐号
    [m_button_XYXH release];
    
	[m_button_SSQ release];
	[m_button_FC3D release];
	[m_button_115 release];
	[m_button_DLT release];
    [m_button_SSC release];
	[m_button_QLC release];
	[m_button_PLS release];
	[m_button_ZC release];
	[m_button_PLW release];
	[m_button_7XC release];
    //	[m_button_RJC release];   
    //	[m_button_JQC release];  
    //	[m_button_LCB release];
    [m_button_11YDJ release];
    [m_button_JCLQ release];
    [m_button_22_5 release];
    
    [m_button_jczu release];    //竞彩足球
    [m_button_gz115 release];  //广东11选5
    [m_button_klsf release];
    
    [label_HMDT release];
    [label_ZJJH release];
    [label_XYXH release];
    
    [label_SSQ release];
    [label_DLT release];
    [label_FC3D release];
    [label_SSC release];
    [label_115 release];
    [label_JCLQ release];
    [label_jczu release];
    [label_11YDJ release];
    [label_PLS release];
    [label_QLC release];
    [label_22_5 release];
    [label_PLW release];
    [label_7XC release];
    [label_ZC release];
    [label_gz115 release];
    [label_klsf release];
	
    [m_loginStatus release];
    [m_button_Login release];
	//[m_pageController release];
	[m_imagePageOne release];
	[m_imagePageTwo release];
	[m_imagePageThere release];
    
#ifndef isBOYA
    [m_imagePageFour release];
    
    [zhouButton release];
    [yueButton release];
    [zongButton release];
    
    [m_topWinArray release], m_topWinArray = nil;

//    [m_winTableView release];
//    
//    [refreshHeaderView release];
//    [refreshLabel release];
//    [refreshArrow release];
//    [refreshDate release];
//    [refreshSpinner release];
    
    [lotNoAry release];
    [lotNoBatchCodeNoAry release];
    [lotNoEndTimeAry release];
    [lotNoBatchCodeDictionary release];
    [lotNoEndTimeDictionary release];
    [lotNoBatchEndTimeDictionary release];
    [prizeInfomationDictionary release];
    [isShowPrizeLotteryArray release];
#endif
	[super dealloc];
}
-(void)viewDidAppear:(BOOL)animated
{
//    [self performSelector:@selector(showMentionView) withObject:nil afterDelay:2];
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    if ([BuyAndInfoSeparated isEqualToString:@"1"]) {
        self.navigationItem.title = @"购彩大厅";
    }
    
    
    canShowM = YES;
    topmsgShowed = NO;
    [self.navigationController.navigationBar setBackground];
    [self.view setBackgroundColor:[ColorUtils parseColorFromRGB:@"#F5F5F5"]];
    int miunesWithed = 320;
    
    netFailedAlertShown = NO;

#ifndef isBOYA
	isRefresWinner = YES;
    topWay = 1;
    isAddHeadView = YES;
    miunesWithed = 0;
#endif
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [RuYiCaiNetworkManager sharedManager].firstViewController = self;

    [self setupNavigationBarStatus];
    [self setupMainTableView];
    [self updateLoginStatus];
    
    
    [[RuYiCaiNetworkManager sharedManager] readTopActionIdPath];//活动内容显示
    
    self.lotNoAry = [NSArray arrayWithObjects:kLotNoSSQ,kLotNoDLT,kLotNoFC3D,kLotNo11YDJ,kLotNo115,kLotNoSSC,kLotNoJCZQ,kLotNoGD115, nil];
    self.lotNoEndTimeAry = [NSMutableArray array];
    self.lotNoBatchCodeNoAry = [NSMutableArray array];
    self.lotNoEndTimeDictionary = [NSMutableDictionary dictionary];
    self.lotNoBatchCodeDictionary = [NSMutableDictionary dictionary];
    self.lotNoBatchEndTimeDictionary  = [NSMutableDictionary dictionary];
    self.prizeInfomationDictionary = [NSMutableDictionary dictionary];//开奖信息
    [[RuYiCaiNetworkManager sharedManager] checkNewVersion];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newVersionCheckOK:) name:@"newVersionCheckOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailedAlert:) name:@"netFailedAlert" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager] getTopOneMessage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTopOneMessageOK:) name:@"WXRGetTopOneMessageOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationOK:) name:@"WXRGetNotificationOK" object:nil];
    
}
-(void)newVersionCheckOK:(NSNotification *)notification
{
    NSDictionary * message = notification.object;
    NSString * isUpgrade = [message objectForKey:@"isUpgrade"];
    if ([isUpgrade isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"检测到有新版本\n%@",[message objectForKey:@"description"]] delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立刻升级", nil];
        alert.tag = kNewVersionAlertViewTag;
        [alert show];
        [alert release];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newVersionCheckOK" object:nil];
}

-(void)setUpKaiJiangZhongXin
{
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"QueryLot" forKey:@"command"];
    [dict setObject:@"winInfo" forKey:@"type"];
    m_cellTitleArray = [[NSMutableArray alloc] initWithCapacity:1];
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOTTERY_INFOR;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:dict isShowProgress:YES];
}

- (void)setNewTableTitle
{
    [self.cellTitleArray removeAllObjects];
    
    m_cellCount = 0;
    
    NSMutableArray*  showLotArray = [NSMutableArray array];
    
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
    self.showArray2 = [NSMutableArray array];
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
        showLotArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        showLotArray = [[NSMutableArray alloc] initWithArray:mutableArr];
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].lotteryInfor];
        [jsonParser release];
        
    }
    
    for(int i = 0; i < [showLotArray count]; i ++)
    {
        if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
        {
            [self.showArray2 addObject:[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0]]];
            
        }
    }
    
    NSLog(@"开奖中心-showLotArray:%@",showLotArray);
    for(int i = 0; i < [showLotArray count]; i ++)
    {
        
        if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleSSQ])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleSSQ];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleFC3D])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleFC3D];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleDLT])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleDLT];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleSSC])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleSSC];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitle11X5])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitle11X5];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleJCZQ])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleJCZQ];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitle11YDJ])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitle11YDJ];
                m_cellCount ++;
            }
        }
        
    }
    
    [self.tableView2 reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (alertView.tag==kNewVersionAlertViewTag) {
        if (buttonIndex==1) {
            [self gotoUpgrade];
        }
    }
     else if (alertView.tag==1011){
         netFailedAlertShown = NO;
     }
}
-(void)gotoUpgrade
{
    NSURL *url = [NSURL URLWithString:kAppStorPingFen];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    
    NSLog(@"test svn");
    if([timer_11YDJ isValid])
	{
		[timer_11YDJ invalidate];
		timer_11YDJ = nil;
	}
    
    if([timer_SSC isValid])
	{
		[timer_SSC invalidate];
		timer_SSC = nil;
	}
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryRecentlyEvent" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSSQInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateDLTInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateFC3DInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"update11YDJInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSSCInformation" object:nil];
    
    //足彩通知
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryTodayOpenOrAddOK" object:nil];//今日开奖、加奖
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryADInformationOK" object:nil];//广告url
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryTicketPropaganda" object:nil];//彩种宣传语
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryRemainingChanceOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sofrWareUpdateOK" object:nil];
    
    

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailedAlert" object:nil];
    [super viewWillDisappear:animated];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackground];
    [self updateLoginStatus];
    [self clearBetData];//清空投注数据
    
    [self setNewTableTitle];
    
    [[CommonRecordStatus commonRecordStatusManager] clearBetData];
    
    
    [self setUpShowLotteryList];
    self.isShowPrizeLotteryArray = [NSMutableArray array];//当前显示的彩票数组
    if (!m_activityIdArray)
    {
      self.activityIdArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease]; 
    }
//    else
//    {
//        [self.activityIdArray removeAllObjects];
//    }
    if (!m_ticketPropagandaDic)
    {
        self.ticketPropagandaDic =[[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    }

    

	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSSQInformation:) name:@"updateSSQInformation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jzQueryRecentlyEvent:) name:@"jzQueryRecentlyEvent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRecentlyEvent:) name:@"queryRecentlyEvent" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDLTInformation:) name:@"updateDLTInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFC3DInformation:) name:@"updateFC3DInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update11YDJInformation:) name:@"update11YDJInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSSCInformation:) name:@"updateSSCInformation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryTodayOpenOrAddOK:) name:@"queryTodayOpenOrAddOK" object:nil];//今日开奖、加奖
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryADInformationOK:) name:@"queryADInformationOK" object:nil];//获取广告url
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryTicketPropaganda:) name:@"queryTicketPropaganda" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRemainingChanceOK:) name:@"queryRemainingChanceOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sofrWareUpdateOK:) name:@"sofrWareUpdateOK" object:nil];

    self.tableViewType = YES;
    
    [[RuYiCaiNetworkManager sharedManager] lotterySSQInquiry];//双色球 获取期号时间
    [[RuYiCaiNetworkManager sharedManager] lotteryDLTInquiry];//大乐透 获取期号时间
    [[RuYiCaiNetworkManager sharedManager] lotteryFC3DInquiry];//福彩3D 获取期号时间
    [[RuYiCaiNetworkManager sharedManager] lottery11YDJInquiry];//山东十一运夺金 获取期号时间
    [[RuYiCaiNetworkManager sharedManager] lotterySSCInquiry];//时时彩 获取期号时间
    [[RuYiCaiNetworkManager sharedManager] queryTodayOpenOrAdd];//今日开奖、加奖
    [[RuYiCaiNetworkManager sharedManager] queryADInformation];//获取广告url
    
    //此处还差查询剩余投注次数接口！！！！！
    
    
    
    [[RuYiCaiNetworkManager sharedManager] requestTicketPropaganda];//查询彩种宣传语
    
    if ([RuYiCaiNetworkManager sharedManager].hasLogin)//取余额
    {
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_BALANCE;
        [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
        [[RuYiCaiNetworkManager sharedManager] queryRemainingChanceForLot];
        
    }
    
    
    

}
-(void)sofrWareUpdateOK:(NSNotification *)noti
{
    if ([RuYiCaiNetworkManager sharedManager].hasLogin)//取余额
    {
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_BALANCE;
        [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
        [[RuYiCaiNetworkManager sharedManager] queryRemainingChanceForLot];
        
    }
}
-(void)queryRemainingChanceOK:(NSNotification *)noti
{
    [RuYiCaiNetworkManager sharedManager].remainingChance = noti.object;
    [self.tableView reloadData];
}
-(void)netFailedAlert:(NSNotification *)noti
{
    if (!netFailedAlertShown) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络提示"
                                                        message:@"请求失败，请检查网络"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles: nil];
        alert.tag = 1011;
        [alert show];
        [alert release];
    }

    netFailedAlertShown = YES;
}
- (void)setupNavigationBarLeftTitle
{
    UILabel *m_left_label = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)]autorelease];
    m_left_label.text = [NSString stringWithFormat:@"购彩大厅"];
    [m_left_label setBackgroundColor:[UIColor clearColor]];
    [m_left_label setTextColor:[UIColor whiteColor]];
    [m_left_label setLineBreakMode:UILineBreakModeWordWrap];
    [m_left_label setFont:[UIFont fontWithName:@"Baiti" size:42]];
    UIBarButtonItem *m_left_title = [[[UIBarButtonItem alloc] initWithCustomView:m_left_label]autorelease];
    self.navigationItem.leftBarButtonItem = m_left_title;
}

- (void)setupNavigationBarStatus
{
    if ([BuyAndInfoSeparated isEqualToString:@"1"]) {
        m_loginStatus = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 100, 44)];
        m_loginStatus.textAlignment = UITextAlignmentRight;
        m_loginStatus.lineBreakMode = UILineBreakModeWordWrap;
        m_loginStatus.numberOfLines = 2;
        m_loginStatus.font = [UIFont systemFontOfSize:12];
        m_loginStatus.textColor = [UIColor whiteColor];
        m_loginStatus.backgroundColor = [UIColor clearColor];
        
        
        CGRect backframe = CGRectMake(0,0,66,30);
        UIButton *loginButton = [[[UIButton alloc] initWithFrame:backframe]autorelease];
        [loginButton setTitle:@"用户登录" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_hover.png"] forState:UIControlStateHighlighted];
        [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        m_button_Login = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
        self.navigationController.navigationBar.topItem.rightBarButtonItem = m_button_Login;

    }
    else
    {
        
        buyButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyButton1 setFrame:CGRectMake(0, 0, 150, 44)];
        [buyButton1 setBackgroundColor:[UIColor clearColor]];
        [buyButton1 setTitle:@"购彩大厅" forState:UIControlStateNormal];
        [buyButton1 addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buyButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
            [buyButton1.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
            [buyButton1.titleLabel setShadowColor:[UIColor grayColor]];
            [buyButton1.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        }
        
        buyButton = [[UIBarButtonItem alloc] initWithCustomView:buyButton1];
        self.navigationController.navigationBar.topItem.leftBarButtonItem = buyButton;
        
        buyButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [buyButton2 setFrame:CGRectMake(160, 0, 150, 44)];
        [buyButton2 setTitle:@"  开奖中心" forState:UIControlStateNormal];
        [buyButton2 setBackgroundColor:[UIColor clearColor]];
//        [buyButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton2 addTarget:self action:@selector(infoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
            [buyButton2.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
            [buyButton2.titleLabel setShadowColor:[UIColor grayColor]];
            [buyButton2.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        }
        
        infoButton = [[UIBarButtonItem alloc] initWithCustomView:buyButton2];
        self.navigationController.navigationBar.topItem.rightBarButtonItem = infoButton;
        
        UIImageView * tbgVR = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 5.5)];
        [tbgVR setBackgroundColor:[UIColor blueColor]];
        [tbgVR setImage:[UIImage imageNamed:@"first-btnnormal"]];
        [self.view addSubview:tbgVR];
        [tbgVR release];
        
        btnHilightBtnImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 5.5)];
        [btnHilightBtnImgV setImage:[UIImage imageNamed:@"first-btnhilighted"]];
        [self.view addSubview:btnHilightBtnImgV];
        
    }
    
}
-(void)buyBtnClicked:(UIButton *)sender
{
//    [buyButton2 setTitleColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1] forState:UIControlStateNormal];
//    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollV.contentOffset = CGPointMake(0, 0);
        [btnHilightBtnImgV setFrame:CGRectMake(0, 0, 160, 5.5)];
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)infoBtnClicked:(UIButton *)sender
{
//    [buyButton1 setTitleColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1] forState:UIControlStateNormal];
//    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollV.contentOffset = CGPointMake(320, 0);
        [btnHilightBtnImgV setFrame:CGRectMake(160, 0, 160, 5.5)];
    } completion:^(BOOL finished) {
        
    }];
    
}
//广告事件
- (void)actionAD:(NSString *)sender{
    
    ActionCenterDetailViewController *viewController = [[ActionCenterDetailViewController alloc] init];
    viewController.navigationItem.title = @"活动内容";
    viewController.activityId = sender;
    viewController.pushType = @"SHOWTYPE";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}
- (void)updateLoginStatus
{
    if ([[RuYiCaiNetworkManager sharedManager] hasLogin])
    {
        if ([BuyAndInfoSeparated isEqualToString:@"1"]) {
            if (([appStoreORnormal isEqualToString:@"appStore"] &&
                 [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
                NSString * yy = [[RuYiCaiNetworkManager sharedManager] userLotPea];
//                yy = [yy substringToIndex:(yy.length-1)];
                NSString * jiaMoney = [[NSUserDefaults standardUserDefaults] objectForKey:@"jiaMoney"];
                if (!jiaMoney) {
                    jiaMoney = @"0";
                }
                m_loginStatus.text = [NSString stringWithFormat:@"彩豆:%.0f",[yy floatValue]+ [jiaMoney floatValue]];
            }
            else
            {
                m_loginStatus.text = [NSString stringWithFormat:kLoginStatusFormat,
                                      [[RuYiCaiNetworkManager sharedManager] userLotPea]];
            }
            //UILabel *label = [[[UILabel alloc] init] autorelease];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:m_loginStatus] autorelease]; //消掉系统的按钮
            //        m_loginStatus.frame = CGRectMake(0, 0, 320, 20);

        }
    }
    else
    {
        if ([BuyAndInfoSeparated isEqualToString:@"1"]) {
            //        m_loginStatus.frame = CGRectMake(0, 0, 320, 20);
            //        m_loginStatus.text = @"尚未登录";
            [m_button_Login release];
            
            CGRect backframe = CGRectMake(0,0,66,30);
            UIButton *loginButton = [[[UIButton alloc] initWithFrame:backframe]autorelease];
            [loginButton setTitle:@"用户登录" forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"login_btn_hover.png"] forState:UIControlStateHighlighted];
            [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
            m_button_Login = [[UIBarButtonItem alloc]initWithCustomView:loginButton];
            self.navigationController.navigationBar.topItem.rightBarButtonItem = m_button_Login;

        }
        
    }
}
- (void)newsButtonClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] getTopNewsContent];
}

- (void) actionSetMoreLottery:(id)sender
{
    NSLog(@"action set more lottery");
    
    LotteryTypeEditorViewController *viewController = [[LotteryTypeEditorViewController alloc]init];
    viewController.title = @"彩种编辑";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
#pragma mark -可显示彩种数据获取
-(void)setUpShowLotteryList{
    
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
    self.showArray = [NSMutableArray array];
//    if(!mutableArr)//没调开机介绍图里的初始化时
//    {
//        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
//        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
//        _showLotArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
//    }
//    else
//    {
        _showLotArray = [[NSMutableArray alloc] initWithArray:mutableArr];
//    }
    _stateSwitchArr = [[NSMutableArray alloc] initWithCapacity:1];
    [self setRecordArray];
}

- (void)setRecordArray{
    NSLog(@"setRecordArray$$$$ %@", self.showLotArray);
    for(int i = 0; i < [self.showLotArray count]; i ++)
    {
        if([[[[self.showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
        {
            [self.stateSwitchArr addObject:@"1"];
            
            NSLog(@"%@",[[[self.showLotArray objectAtIndex:i] allKeys] objectAtIndex:0]);
            
            [self.showArray addObject:[[[self.showLotArray objectAtIndex:i] allKeys] objectAtIndex:0]];
        }
    }
}

#pragma mark -tableView 住图标建立
- (void)setupMainTableView{

//    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 29)];
////    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
////    titleLabel.numberOfLines = 0;
//    [titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setTextColor:[UIColor colorWithRed:51.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:1.0]];
//    [titleLabel setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efede9"]];
//    [self.view addSubview:titleLabel];
//    [titleLabel release];
//    [titleLabel setText:@"理性博大奖，每天都有免费买5注的机会!"];
//    
//    UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 29, 320, 1)];
//    [lineImgView setImage:[UIImage imageNamed:@"gou_cai_da_ting_cell_separator.png"]];
//    [self.view addSubview:lineImgView];
//    [lineImgView release];
    
    [self setUpKaiJiangZhongXin];
    
    self.bgScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, 320, [UIScreen mainScreen].bounds.size.height - 113)];
    self.bgScrollV.delegate = self;
    self.bgScrollV.contentSize = CGSizeMake(640, [UIScreen mainScreen].bounds.size.height - 113);
    self.bgScrollV.contentOffset = CGPointMake(0, 0);
    self.bgScrollV.pagingEnabled=YES;
	self.bgScrollV.showsHorizontalScrollIndicator=NO;
	self.bgScrollV.showsVerticalScrollIndicator=NO;
    self.bgScrollV.bounces = YES;
    [self.view addSubview:self.bgScrollV];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 113)] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 68;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tag = 1;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self.bgScrollV addSubview:m_tableView];
    
    self.tableView2 = [[[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, [UIScreen mainScreen].bounds.size.height - 113)] autorelease];
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    self.tableView2.rowHeight = 68;
    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView2.tag = 2;
    [self.tableView2 setBackgroundColor:[UIColor clearColor]];
    
    [self.bgScrollV addSubview:self.tableView2];
    
    metionVBG = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 280, 320)];
    [metionVBG setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:metionVBG];
    UIImageView * topBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    [topBG setImage:[UIImage imageNamed:@"bottom_redbg"]];
    [metionVBG addSubview:topBG];
    [topBG release];
    UILabel * tishiL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    [tishiL setText:@"温馨提示"];
    [tishiL setBackgroundColor:[UIColor clearColor]];
    [tishiL setTextColor:[UIColor whiteColor]];
    [tishiL setTextAlignment:NSTextAlignmentCenter];
    [metionVBG addSubview:tishiL];
    [tishiL release];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setFrame:CGRectMake(20, 270, 240, 40)];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"redbg"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTintColor:[UIColor whiteColor]];
    [metionVBG addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(closeMetionView) forControlEvents:UIControlEventTouchUpInside];
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [animation retain];

    
    self.theInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 45, 270, 265-45)];
    [self.theInfoTextView setBackgroundColor:[UIColor clearColor]];
    self.theInfoTextView.editable = NO;
    self.theInfoTextView.font = [UIFont systemFontOfSize:16];
    [metionVBG addSubview:self.theInfoTextView];
    NSString * path=[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"tishitext"ofType:@"txt"]];
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    self.theInfoTextView.text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    metionVBG.hidden = YES;
    
}
-(void)closeMetionView
{
    metionVBG.hidden = YES;
//    [metionVBG removeFromSuperview];
}
- (void)getNotificationOK:(NSNotification*)notification
{
    NSDictionary* dic = [notification.userInfo objectForKey:@"value"];
    if (metionVBG.hidden) {
        self.theInfoTextView.text = dic[@"content"];
        metionVBG.hidden = NO;
    }
}
- (void)getTopOneMessageOK:(NSNotification*)notification
{
    NSDictionary* dic = [notification.userInfo objectForKey:@"value"];
    if (metionVBG.hidden) {
        self.theInfoTextView.text = dic[@"content"];
        metionVBG.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        [metionVBG.layer addAnimation:animation forKey:nil];
        [UIView commitAnimations];
    }
}
-(void)showMentionView
{
    NSString * ifNeedMetion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ifNeedMetion"];
    
    if (!ifNeedMetion&&![[RuYiCaiNetworkManager sharedManager].userno isEqualToString:TestUNum]&&![@"appStore" isEqualToString:appStoreORnormal]) {
        metionVBG.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.8];
        [metionVBG.layer addAnimation:animation forKey:nil];
        [UIView commitAnimations];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ifNeedMetion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        canShowM = NO;
    }


}

- (void)queryOpenState
{
//    [[RuYiCaiNetworkManager sharedManager] queryTodayOpenOrAdd];//今日开奖、加奖
}

#pragma mark 清空投注数据
- (void)clearBetData
{
    //每次到第一界面就清空
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];

    [RuYiCaiLotDetail sharedObject].batchCode = @"";
    [RuYiCaiLotDetail sharedObject].batchEndTime = @"";
    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].betCode = @"";
    [RuYiCaiLotDetail sharedObject].disBetCode = @"";
    [RuYiCaiLotDetail sharedObject].lotNo = @"";
    [RuYiCaiLotDetail sharedObject].lotMulti = @"";
    [RuYiCaiLotDetail sharedObject].amount = @"";
    [RuYiCaiLotDetail sharedObject].betType = @"";
    [RuYiCaiLotDetail sharedObject].sellWay = @"";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
    [RuYiCaiLotDetail sharedObject].advice = @"";
    [RuYiCaiLotDetail sharedObject].zhuShuNum = @"";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    [RuYiCaiLotDetail sharedObject].oneAmount = @"";
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
    [RuYiCaiLotDetail sharedObject].moreZuAmount = @"";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    [RuYiCaiLotDetail sharedObject].giftContentStr = @"";
}

#pragma mark Button Clicks

- (void)loginClick
{
    //    [self startVersionInfoUpdateTimer];
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
    [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
    
//    [MobClick event:@"firstPage_login_regist"];
}

- (void)changeUserClick
{
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
    [[RuYiCaiNetworkManager sharedManager] showChangeUserAlertView];
}

- (void)pushSSQView
{
//    [MobClick event:@"main_SSQ_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
	[self setHidesBottomBarWhenPushed:YES];
    SSQ_PickNumberViewController *pickNumberView = [[SSQ_PickNumberViewController alloc] init];
	pickNumberView.navigationItem.title = @"双色球";
	[self.navigationController pushViewController:pickNumberView animated:YES];
    
    [pickNumberView release];
}

- (void)pushFC3DView
{
//    [MobClick event:@"main_FC3D_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [self setHidesBottomBarWhenPushed:YES];
    FC3D_PickNumberViewController *pickNumberView = [[FC3D_PickNumberViewController alloc] init];
	pickNumberView.navigationItem.title = @"福彩3D";
	[self.navigationController pushViewController:pickNumberView animated:YES];
    [pickNumberView release];
}



- (void)pushDLTView
{
//    [MobClick event:@"main_DLT_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [self setHidesBottomBarWhenPushed:YES];
	DLT_PickNumberViewController *pickNumberView = [[DLT_PickNumberViewController alloc]init];
	pickNumberView.navigationItem.title = @"大乐透";
	[self.navigationController pushViewController:pickNumberView animated:YES];
    [pickNumberView release];
}

- (void)pushSSCView
{
//    [MobClick event:@"main_SSC_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
	[self setHidesBottomBarWhenPushed:YES];
	SSC_PickNumberViewController *pickNumberView = [[SSC_PickNumberViewController alloc]init];
	pickNumberView.navigationItem.title = @"时时彩";
	[self.navigationController pushViewController:pickNumberView animated:YES];
    [pickNumberView release];
}

- (void)pushQLCView
{
    NSTrace();
//    [MobClick event:@"main_QLC_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [self setHidesBottomBarWhenPushed:YES];
    QLC_PickNumberViewController *pickNumberView = [[QLC_PickNumberViewController alloc]init];
	pickNumberView.navigationItem.title = @"七乐彩";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];

	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
}

- (void)pushPLSView
{
//    [MobClick event:@"main_PLS_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [self setHidesBottomBarWhenPushed:YES];
	PLS_PickNumberViewController *pickNumberView = [[PLS_PickNumberViewController alloc]init];
	pickNumberView.navigationItem.title = @"排列三";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
}

- (void)pushZCView
{
//    [MobClick event:@"main_ZC_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [self setHidesBottomBarWhenPushed:YES];
	ZC_pickNumberViewController *pickNumberView = [[ZC_pickNumberViewController alloc]init];
	pickNumberView.navigationItem.title = @"足彩";
    pickNumberView.ZCTag = IZCLotTag_SFC;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];

	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
}

- (void)pushPLWView
{
//    [MobClick event:@"main_PL5_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [self setHidesBottomBarWhenPushed:YES];
	PLW_PickNumberViewController *pickNumberView = [[PLW_PickNumberViewController alloc]init];
	pickNumberView.navigationItem.title = @"排列五";
	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
}

- (void)push7XCView
{
//    [MobClick event:@"main_QXC_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [self setHidesBottomBarWhenPushed:YES];
	QXC_PickNumberViewController *pickNumberView = [[QXC_PickNumberViewController alloc]init];
    pickNumberView.navigationItem.title = @"七星彩";
	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
	
}


- (void)push11YDJView
{
//    [MobClick event:@"main_11YDJ_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
	[self setHidesBottomBarWhenPushed:YES];
	X11YDJ_PickNumberViewController *pickNumberView = [[X11YDJ_PickNumberViewController alloc]init];
	pickNumberView.navigationItem.title = @"十一运夺金";
	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
}
- (void)pushJCLQView
{
    //    [MobClick event:@"main_JCLQ_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
	[self setHidesBottomBarWhenPushed:YES];
    JCLQ_PickGameViewController *pickGameView = [[JCLQ_PickGameViewController alloc]init];
//	pickGameView.navigationItem.title = @"竞彩篮球";/*@"竞彩篮球胜负（过关）";*/
	[self.navigationController pushViewController:pickGameView animated:YES];
	[pickGameView release];
}
- (void)pushBJDCView
{
    //    [MobClick event:@"main_JCLQ_button"];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
	[self setHidesBottomBarWhenPushed:YES];
    BJDC_pickNumViewController *pickGameView = [[BJDC_pickNumViewController alloc]init];
//	pickGameView.navigationItem.title = @"北京单场";
	[self.navigationController pushViewController:pickGameView animated:YES];
	[pickGameView release];
}

- (void)pushZJJHView
{
	ZJJHViewController *pickNumberView = [[ZJJHViewController alloc]init];
	pickNumberView.navigationItem.title = @"专家荐号";
	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
}
- (void)push22_5View
{
	X22_5PickNumberViewController *pickNumberView = [[X22_5PickNumberViewController alloc]initWithNibName:@"X22_5PickNumberViewController" bundle:nil];
	pickNumberView.navigationItem.title = @"22选5";
	[self.navigationController pushViewController:pickNumberView animated:YES];
	[pickNumberView release];
}

- (void)pushJCZUView
{
    JCZQ_PickGameViewController *pickGameView = [[JCZQ_PickGameViewController alloc]init];
    //	pickGameView.navigationItem.title = @"竞彩足球";/*@"竞彩足球胜平负（过关）";*/
    NSLog(@"压站一次－－－－－－");
	[self.navigationController pushViewController:pickGameView animated:YES];
	[pickGameView release];
    
}
- (void)pushNMKSView
{
    KS_PickNumberViewController *pickGameView = [[KS_PickNumberViewController alloc]init];
	pickGameView.navigationItem.title = @"快三";
    
    
    
    if ([[KSBettingModel share] kSBettingArrayModel].count != 0) {
        
        pickGameView.view.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray * controllerArray = [self.navigationController.viewControllers mutableCopy];
        [controllerArray addObject:pickGameView];
        self.navigationController.viewControllers = controllerArray;
        
        HXBX_KSBet_ViewController * controller = [[HXBX_KSBet_ViewController alloc] init];
        
        controller.dataSource = [[KSBettingModel share] kSBettingArrayModel];
        controller.delegate = pickGameView.ksPNVC;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    }else{
        [self.navigationController pushViewController:pickGameView animated:YES];
    }
	[pickGameView release];
    
}

- (void)pushGZ115View
{
    GZ11X5_PickNumberViewController *pickGameView = [[GZ11X5_PickNumberViewController alloc]init];
	pickGameView.navigationItem.title = @"广东11选5";
	[self.navigationController pushViewController:pickGameView animated:YES];
	[pickGameView release];
}
- (void)pushCQ115View
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    CQ115_PickNumberViewController *pickGameView = [[CQ115_PickNumberViewController alloc]init];
	pickGameView.navigationItem.title = @"重庆11选5";
	[self.navigationController pushViewController:pickGameView animated:YES];
	[pickGameView release];
}

- (void)pushCQSFView
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    CQSF_PickNumberViewController *pickGameView = [[CQSF_PickNumberViewController alloc]init];
	pickGameView.navigationItem.title = @"重庆快乐十分";
	[self.navigationController pushViewController:pickGameView animated:YES];
	[pickGameView release];
}
- (void)pushKLSFView
{
//    [MobClick event:@"main_KLSF_button"];

    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    KLSF_PickNumberViewController *pickGameView = [[KLSF_PickNumberViewController alloc]init];
	pickGameView.navigationItem.title = @"广东快乐十分";
	[self.navigationController pushViewController:pickGameView animated:YES];
	[pickGameView release];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{  
    if ([animationID compare:@"exitApplication"] == 0)
        exit(0);  
}
#ifndef isBOYA	
#pragma  mark tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    if (tableView.tag==1) {
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 15;
//    if (tableView==self.tableView) {
    if (tableView.tag==1) {
        if (section==1) {
            NSInteger i = 0;
            
            for (NSString *switchString in self.stateSwitchArr) {
                if ([switchString isEqualToString:@"1"]) {
                    i++;
                }
            }
            return  i;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        NSInteger i = 0;
        
        for (NSString *switchString in self.stateSwitchArr) {
            if ([switchString isEqualToString:@"1"]) {
                i++;
            }
        }
        return  i;
    }
        //每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
//    }
//    else
//    {
//    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag==1) {
        if (indexPath.section==1) {
            return 80;
        }
        else
            return 65.0f;
    }
    else
    {
        return 90.0f;
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
        if (indexPath.section==1) {
            static NSString *m_cell = @"buyLotteryCell";
            BuyLotteryTableViewCell *cell = (BuyLotteryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:m_cell];
            
            if (cell == nil)
            {
                cell = [[[BuyLotteryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:m_cell] autorelease];
            }
            
            NSMutableDictionary *orderLottery = [[NSUserDefaults standardUserDefaults] objectForKey:kDefultLotteryShowDicKey];
            
            NSInteger orderInteger = [[orderLottery objectForKey:[self.showArray objectAtIndex:indexPath.row]] integerValue];
            
            if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleSSQ])
            {
                
                cell.iconImg.image = RYCImageNamed(@"scc_c_main.png");
                cell.lotteryName = @"双色球";
                cell.kLotNoType = kLotNoSSQ;
                cell.endTime = @"0时0分";
                cell.lotteryADContent = @"2元赢取1000万";
                
                
            }
            else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleDLT])
            {
                
                cell.iconImg.image = RYCImageNamed(@"dlt_c_main.png");
                cell.lotteryName = @"大乐透";
                cell.kLotNoType = kLotNoDLT;
                cell.endTime = @"0时0分";
                cell.lotteryADContent = @"3元赢取最高奖1600万";
                
                
            }
            else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleFC3D])
            {
                
                cell.iconImg.image = RYCImageNamed(@"fc3d_c_main.png");
                cell.lotteryName = @"福彩3D";
                cell.kLotNoType = kLotNoFC3D;
                cell.endTime = @"0时0分";
                cell.lotteryADContent = @"2元赢取1000元";
                
                
            }
            else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleSSC])
            {
                
                cell.iconImg.image = RYCImageNamed(@"ssc_c_main.png");
                cell.lotteryName = @"时时彩";
                cell.kLotNoType = kLotNoSSC;
                cell.endTime = @"0分0秒";
                cell.lotteryADContent = @"每天120期中奖机会";
                
                
                
            }
            else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitle11YDJ])
            {
                
                cell.iconImg.image = RYCImageNamed(@"11ydj_c_.png");
                cell.lotteryName = @"十一运夺金";
                cell.kLotNoType = kLotNo11YDJ;
                cell.endTime = @"0分0秒";
                cell.lotteryADContent = @"10分钟赢千元";
                
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.prizeType = TodayNothing;
            
            
            
            if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleSSQ]){
                
                if ([self.ticketPropagandaDic objectForKey:kLotNoSSQ]) {
                    cell.lotteryADContent = [self.ticketPropagandaDic objectForKey:kLotNoSSQ];
                }
                
                if ([self.lotNoBatchCodeDictionary objectForKey:kLotNoSSQ] ) {
                    NSString *numStr = [self.lotNoBatchCodeDictionary objectForKey:kLotNoSSQ];
                    cell.numStage = [NSNumber numberWithDouble:[numStr doubleValue]];
                }
                if ([self.lotNoEndTimeDictionary objectForKey:kLotNoSSQ]) {
                    NSString *timeStr = [self.lotNoEndTimeDictionary objectForKey:kLotNoSSQ];
                    cell.endTime = timeStr;
                }
                if ([self.prizeInfomationDictionary objectForKey:kLotNoSSQ]) {
                    cell.prizeType = [(NSNumber *)[self.prizeInfomationDictionary objectForKey:kLotNoSSQ] integerValue];
                }
                
                
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleDLT]){
                
                if ([self.lotNoBatchCodeDictionary objectForKey:kLotNoDLT]) {
                    NSString *numStr = [self.lotNoBatchCodeDictionary objectForKey:kLotNoDLT];
                    cell.numStage = [NSNumber numberWithDouble:[numStr doubleValue]];
                }
                if ([self.lotNoEndTimeDictionary objectForKey:kLotNoDLT]) {
                    NSString *timeStr = [self.lotNoEndTimeDictionary objectForKey:kLotNoDLT];
                    cell.endTime = timeStr;
                }
                if ([self.prizeInfomationDictionary objectForKey:kLotNoDLT]) {
                    cell.prizeType = [(NSNumber *)[self.prizeInfomationDictionary objectForKey:kLotNoDLT] integerValue];
                }
                if ([self.ticketPropagandaDic objectForKey:kLotNoDLT]) {
                    cell.lotteryADContent = [self.ticketPropagandaDic objectForKey:kLotNoDLT];
                }
                
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleFC3D]){
                
                if ([self.lotNoBatchCodeDictionary objectForKey:kLotNoFC3D]) {
                    NSString *numStr = [self.lotNoBatchCodeDictionary objectForKey:kLotNoFC3D];
                    cell.numStage = [NSNumber numberWithDouble:[numStr doubleValue]];
                }
                if ([self.ticketPropagandaDic objectForKey:kLotNoFC3D]) {
                    cell.lotteryADContent = [self.ticketPropagandaDic objectForKey:kLotNoFC3D];
                }
                if ([self.lotNoEndTimeDictionary objectForKey:kLotNoFC3D]) {
                    NSString *timeStr = [self.lotNoEndTimeDictionary objectForKey:kLotNoFC3D];
                    cell.endTime = timeStr;
                }
                if ([self.prizeInfomationDictionary objectForKey:kLotNoFC3D]) {
                    cell.prizeType = [(NSNumber *)[self.prizeInfomationDictionary objectForKey:kLotNoFC3D] integerValue];
                }
                
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleSSC]){
                
                if ([self.lotNoBatchCodeDictionary objectForKey:kLotNoSSC] ) {
                    NSString *numStr = [self.lotNoBatchCodeDictionary objectForKey:kLotNoSSC];
                    cell.numStage = [NSNumber numberWithDouble:[numStr doubleValue]];
                }
                if ([self.lotNoEndTimeDictionary objectForKey:kLotNoSSC] ) {
                    NSString *timeStr = [self.lotNoEndTimeDictionary objectForKey:kLotNoSSC];
                    cell.endTime = timeStr;
                }
                if ([self.prizeInfomationDictionary objectForKey:kLotNoSSC] ) {
                    cell.prizeType = [(NSNumber *)[self.prizeInfomationDictionary objectForKey:kLotNoSSC] integerValue];
                }
                if ([self.ticketPropagandaDic objectForKey:kLotNoSSC]) {
                    cell.lotteryADContent = [self.ticketPropagandaDic objectForKey:kLotNoSSC];
                }
                
                
                
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitle11YDJ]){
                
                if ([self.lotNoBatchCodeDictionary objectForKey:kLotNo11YDJ] ){
                    NSString *numStr = [self.lotNoBatchCodeDictionary objectForKey:kLotNo11YDJ];
                    cell.numStage = [NSNumber numberWithDouble:[numStr doubleValue]];
                }
                if ([self.lotNoEndTimeDictionary objectForKey:kLotNo11YDJ])  {
                    NSString *timeStr = [self.lotNoEndTimeDictionary objectForKey:kLotNo11YDJ];
                    cell.endTime = timeStr;
                }
                if ([self.prizeInfomationDictionary objectForKey:kLotNo11YDJ]) {
                    cell.prizeType = [(NSNumber *)[self.prizeInfomationDictionary objectForKey:kLotNo11YDJ] integerValue];
                }
                if ([self.ticketPropagandaDic objectForKey:kLotNo11YDJ]) {
                    cell.lotteryADContent = [self.ticketPropagandaDic objectForKey:kLotNo11YDJ];
                }
                
                
                
            }
            [cell refreshDate];
            
            return cell;

        }
        else
        {
            static NSString *myCellIdentifier = @"firstPagetopcell";
            FirstPageTopCell *cell = (FirstPageTopCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
            if (cell == nil)
            {
                cell = [[[FirstPageTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateLogInStatus];
            if ([RuYiCaiNetworkManager sharedManager].hasLogin) {
                [cell setRemainingBuyTimes:[[RuYiCaiNetworkManager sharedManager].remainingChance intValue]];
            }
            else
            {
                [cell setRemainingBuyTimes:5];
            }
            
            return cell;

        }
    }
    else if(tableView.tag==2){
        static NSString *myCellIdentifier = @"MyCellIdentifier";
        LotteryInfoTableViewCell *cell = (LotteryInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[LotteryInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        //	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        NSUInteger row = indexPath.row;
//        cell.superViewController = self;
        cell.lotTitle = [self.cellTitleArray objectAtIndex:row];
        if([cell.lotTitle isEqual: kLotTitleJCLQ] || [cell.lotTitle isEqual: kLotTitleJCZQ] || [cell.lotTitle isEqual: kLotTitleBJDC])
        {
            cell.batchCode = @"";
            cell.winNo = @"";
            cell.dateStr = @"";
            [cell refresh];
            
            return cell;
        }
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].lotteryInfor];
        [jsonParser release];
        
        NSDictionary* subDict = (NSDictionary*)[parserDict objectForKey:cell.lotTitle];
        
        if([[subDict allKeys] count] == 0)
        {
            NSArray *array01 = [[NSArray alloc] initWithObjects:@"",@"",@"", @"",nil];
            NSArray *array02 = [[NSArray alloc] initWithObjects:@"batchCode",@"winCode",@"openTime", @"tryCode", nil];
            subDict = [NSDictionary dictionaryWithObjects:array01 forKeys:array02 ];
            [array01 release];
            [array02 release];
        }
        
        cell.batchCode = [subDict objectForKey:@"batchCode"];
        cell.winNo = [subDict objectForKey:@"winCode"];
        cell.dateStr = [subDict objectForKey:@"openTime"];
        cell.tryCodeBatchCode = [subDict objectForKey:@"tryCodeBatchCode"];
        if([cell.lotTitle isEqual: kLotTitleFC3D])
        {
            cell.tryCode = [subDict objectForKey:@"tryCode"];
            
        }
        if([cell.lotTitle isEqual: kLotTitleNMK3])
        {
            cell.tryCode = [subDict objectForKey:@"sumValue"];
        }
        NSLog(@"--------lotTitle:%@,  batchCode:%@   winNO:%@", cell.lotTitle, cell.batchCode, cell.winNo);
        [cell refresh];
      
        return cell;

    }
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==2) {
        NSString* lotTitle = [(LotteryInfoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] lotTitle];
        if([lotTitle isEqualToString:kLotTitleJCLQ])
        {
            return;
        }
        else if([lotTitle isEqualToString:kLotTitleJCZQ])
        {
            return;
        }
        else if([lotTitle isEqualToString:kLotTitleBJDC])
        {
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        if([lotTitle isEqualToString:kLotTitleSFC])//足彩开奖
        {
            ZCOpenLotteryViewController* viewController = [[ZCOpenLotteryViewController alloc] init];
            viewController.isPushShow = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            viewController.animationTabView.selectButtonTag = 0;
            [viewController tabButtonChanged:nil];
            [viewController release];
            return;
        }
        
        NSString *batchCodeStr = [(LotteryInfoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] batchCode];
        NSLog(@"batchCodeStr %@", batchCodeStr);
        
        LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
        viewController.delegate = self;
        viewController.isPushShow = YES;
        if([lotTitle isEqualToString:kLotTitleSSQ])
        {
            //        [MobClick event:@"openPage_SSQ"];
            
            viewController.lotTitle = kLotTitleSSQ;
            viewController.lotNo = kLotNoSSQ;
            viewController.VRednumber = 33;//红球个数
            viewController.VBluenumber = 16;//篮球个数
        }
        else if([lotTitle isEqualToString:kLotTitleFC3D])
        {
            viewController.lotTitle = kLotTitleFC3D;
            viewController.lotNo = kLotNoFC3D;
            viewController.VRednumber = 30;
            viewController.VBluenumber = 0;
        }
        else if([lotTitle isEqualToString:kLotTitleDLT])
        {
            viewController.lotTitle = kLotTitleDLT;
            viewController.lotNo = kLotNoDLT;
            viewController.VRednumber = 35;
            viewController.VBluenumber = 12;
        }
        else if([lotTitle isEqualToString:kLotTitleSSC])
        {
            viewController.lotTitle = kLotTitleSSC;
            viewController.lotNo = kLotNoSSC;
            viewController.VRednumber = 50;
            viewController.VBluenumber = 0;
        }
        
        else if([lotTitle isEqualToString:kLotTitle11YDJ])
        {
            viewController.lotTitle = kLotTitle11YDJ;
            viewController.lotNo = kLotNo11YDJ;
            viewController.VRednumber = 11;
            viewController.VBluenumber = 0;
        }
        if(batchCodeStr)
            viewController.batchCode = batchCodeStr;
        else
            viewController.batchCode = @"";
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController refreshLotteryAwardInfo];
        
        [viewController release];

    }
    else{
        
        if (indexPath.section==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
            if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleSSQ]){
                
                [self pushSSQView];
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleDLT]){
                
                [self pushDLTView];
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleFC3D]){
                
                [self pushFC3DView];
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitleSSC]){
                
                [self pushSSCView];
                
            }else  if([[self.showArray objectAtIndex:indexPath.row]isEqualToString:kLotTitle11YDJ]){
                
                [self push11YDJView];
                
            }

        }
        else
        {
            if ([[RuYiCaiNetworkManager sharedManager] hasLogin])
            {
                
            }
            else{
                [self loginClick];
            }
        }
    }
    
}
- (void)querySampleNetOK:(NSNotification*)notification
{
	[self.tableView2 reloadData];
	[self setNewTableTitle];
//	[self stopLoading];
}

- (void)netFailed:(NSNotification*)notification
{
//	[self stopLoading];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.bgScrollV) {
        btnHilightBtnImgV.frame = CGRectMake(scrollView.contentOffset.x*160/320, btnHilightBtnImgV.frame.origin.y, 160, 5.5);
    }
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    if (scrollView!=self.bgScrollV) {
        [self performSelector:@selector(refreshWhich:) withObject:[NSNumber numberWithInt:scrollView.tag] afterDelay:0];
    }
    
    /****
    if (scrollView.tag==1) {
        //山东11运夺金 时间重新获取并重置定时器
        
        
        if(timer_11YDJ != nil )
        {
            if([timer_11YDJ isValid])
            {
                [timer_11YDJ invalidate];
                timer_11YDJ = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lottery11YDJInquiry];
        }
        //竞猜篮球 赛事重新获取并重置定时器
        
        
        if(timer_JCLQ != nil )
        {
            if([timer_JCLQ isValid])
            {
                [timer_JCLQ invalidate];
                timer_JCLQ = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] getRecentlyEvent:@"0"];
        }
        //竞猜足球 赛事重新获取并重置定时器
        if(timer_JCZQ != nil )
        {
            if([timer_JCZQ isValid])
            {
                [timer_JCZQ invalidate];
                timer_JCZQ = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] getZQRecentlyEvent:@"1"];
        }
        
        //北京单场 赛事重新获取并重置定时器
        if(timer_BJDC != nil )
        {
            if([timer_BJDC isValid])
            {
                [timer_BJDC invalidate];
                timer_BJDC = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] getBDRecentlyEvent:@"2"];
        }
        
        
        //时时彩 时间重新获取并重置定时器
        if(timer_SSC != nil)
        {
            if([timer_SSC isValid])
            {
                [timer_SSC invalidate];
                timer_SSC = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotterySSCInquiry];
        }
        //广东11选5 时间重新获取并重置定时器
        if(timer_GD115 != nil )
        {
            if([timer_GD115 isValid])
            {
                [timer_GD115 invalidate];
                timer_GD115 = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryGD115Inquiry];
        }
        //江西11选5 时间重新获取并重置定时器
        if(timer_115 != nil )
        {
            if([timer_115 isValid])
            {
                [timer_115 invalidate];
                timer_115 = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lottery115Inquiry];
        }
        
        //广东快乐十分 时间重新获取并重置定时器
        if(timer_KLSF != nil)
        {
            if([timer_KLSF isValid])
            {
                [timer_KLSF invalidate];
                timer_KLSF = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryKLSFInquiry];
        }
        
        //重庆快乐十分 时间重新获取并重置定时器
        if(timer_CQSF != nil)
        {
            if([timer_CQSF isValid])
            {
                [timer_CQSF invalidate];
                timer_CQSF = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryCQSFInquiry];
        }
        
        //内蒙快三 时间重新获取并重置定时器
        if(timer_NMKS != nil )
        {
            if([timer_NMKS isValid])
            {
                [timer_NMKS invalidate];
                timer_NMKS = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryNMKSInquiry];
        }
        //重庆115 时间重新获取并重置定时器
        if(timer_CQ115 != nil )
        {
            if([timer_CQ115 isValid])
            {
                [timer_CQ115 invalidate];
                timer_CQ115 = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryCQ115Inquiry];
        }
        

    }
    else
    {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
        [dict setObject:@"QueryLot" forKey:@"command"];
        [dict setObject:@"winInfo" forKey:@"type"];
        
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOTTERY_INFOR;
        [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:dict isShowProgress:NO];
    }
    
    ***/
    
}

-(void)refreshWhich:(NSNumber *)index
{
    if ([index intValue]==1) {
        //山东11运夺金 时间重新获取并重置定时器
        
        
        if(timer_11YDJ != nil )
        {
            if([timer_11YDJ isValid])
            {
                [timer_11YDJ invalidate];
                timer_11YDJ = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lottery11YDJInquiry];
        }
        //竞猜篮球 赛事重新获取并重置定时器
        
        
        if(timer_JCLQ != nil )
        {
            if([timer_JCLQ isValid])
            {
                [timer_JCLQ invalidate];
                timer_JCLQ = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] getRecentlyEvent:@"0"];
        }
        //竞猜足球 赛事重新获取并重置定时器
        if(timer_JCZQ != nil )
        {
            if([timer_JCZQ isValid])
            {
                [timer_JCZQ invalidate];
                timer_JCZQ = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] getZQRecentlyEvent:@"1"];
        }
        
        //北京单场 赛事重新获取并重置定时器
        if(timer_BJDC != nil )
        {
            if([timer_BJDC isValid])
            {
                [timer_BJDC invalidate];
                timer_BJDC = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] getBDRecentlyEvent:@"2"];
        }
        
        
        //时时彩 时间重新获取并重置定时器
        if(timer_SSC != nil)
        {
            if([timer_SSC isValid])
            {
                [timer_SSC invalidate];
                timer_SSC = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotterySSCInquiry];
        }
        //广东11选5 时间重新获取并重置定时器
        if(timer_GD115 != nil )
        {
            if([timer_GD115 isValid])
            {
                [timer_GD115 invalidate];
                timer_GD115 = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryGD115Inquiry];
        }
        //江西11选5 时间重新获取并重置定时器
        if(timer_115 != nil )
        {
            if([timer_115 isValid])
            {
                [timer_115 invalidate];
                timer_115 = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lottery115Inquiry];
        }
        
        //广东快乐十分 时间重新获取并重置定时器
        if(timer_KLSF != nil)
        {
            if([timer_KLSF isValid])
            {
                [timer_KLSF invalidate];
                timer_KLSF = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryKLSFInquiry];
        }
        
        //重庆快乐十分 时间重新获取并重置定时器
        if(timer_CQSF != nil)
        {
            if([timer_CQSF isValid])
            {
                [timer_CQSF invalidate];
                timer_CQSF = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryCQSFInquiry];
        }
        
        //内蒙快三 时间重新获取并重置定时器
        if(timer_NMKS != nil )
        {
            if([timer_NMKS isValid])
            {
                [timer_NMKS invalidate];
                timer_NMKS = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryNMKSInquiry];
        }
        //重庆115 时间重新获取并重置定时器
        if(timer_CQ115 != nil )
        {
            if([timer_CQ115 isValid])
            {
                [timer_CQ115 invalidate];
                timer_CQ115 = nil;
            }
            [[RuYiCaiNetworkManager sharedManager] lotteryCQ115Inquiry];
        }
        
        
    }
    else
    {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
        [dict setObject:@"QueryLot" forKey:@"command"];
        [dict setObject:@"winInfo" forKey:@"type"];
        
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOTTERY_INFOR;
        [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:dict isShowProgress:NO];
    }

}

- (void)queryTicketPropaganda:(NSNotification*)notification
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    
    NSMutableArray* dictArray = (NSMutableArray*)[parserDict objectForKey:@"result"];
    for (int i=0; i<[dictArray count]; i++)
    {
        if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoSSQ])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoSSQ];
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoDLT])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoDLT];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoFC3D])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoFC3D];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoJCZQ])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoJCZQ];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoNMK3])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoNMK3];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoBJDC])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoBJDC];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNo11YDJ])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNo11YDJ];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNo115])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNo115];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoSSC])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoSSC];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoKLSF])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoKLSF];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoCQSF])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoCQSF];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoGD115])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoGD115];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoQLC])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoQLC];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoPLS])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoPLS];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoPL5])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoPL5];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoQXC])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoQXC];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoZC])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoZC];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoJCLQ])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoJCLQ];
                    
                }
                
            }
            
        }
        else if([[[[dictArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotNoCQ115])
        {
            for(int j=0; j<[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] count]; j++) {
                
                if([[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allKeys] objectAtIndex:j] isEqualToString:@"lotpublicity"])
                {
                    [self.ticketPropagandaDic setObject:[[[[[dictArray objectAtIndex:i] allValues] objectAtIndex:0] allValues] objectAtIndex:j] forKey:kLotNoCQ115];
                    
                }
                
            }
            
        }

        
        

        
    }


    
}


#pragma mark -notification 回调
-(void)queryADInformationOK:(NSNotification *)notification{
    NSLog(@"queryADInformationOK:(NSNotification *)notification");
    NSObject *obj = [notification object];
    NSString *str = (NSString*)obj;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:str];
    [jsonParser release];
    
    NSArray *imagesArr = [NSArray arrayWithArray:[parserDict objectForKey:@"images"]];

    NSMutableArray *urlArr = [NSMutableArray array];

    
    for (int i = 0 ; i<[imagesArr count]; i++) {
        NSDictionary* urlDict = (NSDictionary*) [imagesArr objectAtIndex:i];
        NSString *urlStr = [urlDict objectForKey:@"url"];
        
        NSString *activityStr = [urlDict objectForKey:@"activityId"];
        NSLog(@"%@",urlStr);
        [urlArr addObject:urlStr];
        [self.activityIdArray addObject:activityStr];
    }
    
    if (![[RuYiCaiNetworkManager sharedManager] sameADImageIdWithNewUrl:urlArr]) {
        [[RuYiCaiNetworkManager sharedManager] getADImage:urlArr];
    }
    
    
}
- (void)queryTodayOpenOrAddOK:(NSNotification*)notification//今日开奖、加奖
{
    NSObject *obj = [notification object];
    NSString *str = (NSString*)obj;
    NSLog(@"%@",str);
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* requestDict = (NSDictionary*)[jsonParser objectWithString:str];
    [jsonParser release];
    NSLog(@"%@",requestDict);
    [CommonRecordStatus commonRecordStatusManager].inProgressActivityCount = [NSString stringWithFormat:@"%@", [requestDict objectForKey:@"inProgressActivityCount"]];
    
    
    NSArray* lotStateArray = [requestDict objectForKey:@"result"];
    NSMutableDictionary* lotStateDic = [NSMutableDictionary dictionaryWithCapacity:1];
    for (int i = 0; i < [lotStateArray count]; i++) {
        [lotStateDic addEntriesFromDictionary:[lotStateArray objectAtIndex:i]];
    }
    NSLog(@"%@", lotStateDic);
    
    
    [self refreshLotState:lotStateDic haveLotNo:[lotStateDic allKeys]];
    
    [self.tableView reloadData];
    
        
}

- (void)jzQueryRecentlyEvent:(NSNotification *)notification{
    
    NSTrace();
    NSString *jZLastEventStr = [[RuYiCaiNetworkManager sharedManager] jzHighFrequencyLastEvent];
    [self.lotNoBatchCodeDictionary setObject:jZLastEventStr forKey:kLotNoJCZQ];
    
    
	//NSLog(@"%@,%@",self.batchCode,self.batchEndTime);
	if(timer_JCZQ != nil)
	{
		[timer_JCZQ invalidate];
		timer_JCZQ = nil;
	}
	else
	{
		timer_JCZQ = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshJCZQTime)
                                                    userInfo:nil repeats:YES];
	}
    
    
    
}


- (void)bdQueryRecentlyEvent:(NSNotification *)notification{
    
    NSTrace();
    NSString *lastEventStr = [[RuYiCaiNetworkManager sharedManager] bdHighFrequencyLastEvent];
    [self.lotNoBatchCodeDictionary setObject:lastEventStr forKey:kLotNoBJDC];
    
    
	//NSLog(@"%@,%@",self.batchCode,self.batchEndTime);
	if(timer_BJDC != nil)
	{
		[timer_BJDC invalidate];
		timer_BJDC = nil;
	}
	else
	{
		timer_BJDC = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshBJDCTime)
                                                    userInfo:nil repeats:YES];
	}
    
    
    
}

- (void)queryRecentlyEvent:(NSNotification *)notification{
   
    NSTrace();
    NSString *lastEventStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyLastEvent];
    [self.lotNoBatchCodeDictionary setObject:lastEventStr forKey:kLotNoJCLQ];
    
    //NSLog(@"%@,%@",self.batchCode,self.batchEndTime);
	if(timer_JCLQ != nil)
	{
		[timer_JCLQ invalidate];
		timer_JCLQ = nil;
	}
	else
	{
		timer_JCLQ = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshJCLQTime)
                                                    userInfo:nil repeats:YES];
	}

}



-(void)updateSSQInformation:(NSNotification *)notification{
    NSString *numStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    NSString *endTimeStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyEndTime];
    //    self.numStage = [NSNumber numberWithDouble:[numStr doubleValue]];
    NSString *timeStr = @"";
    NSLog(@"%@",numStr);
    NSLog(@"%@",endTimeStr);

    [self.lotNoBatchCodeDictionary setObject:numStr forKey:kLotNoSSQ];
    [self.lotNoEndTimeDictionary setObject:endTimeStr forKey:kLotNoSSQ];
    [RuYiCaiLotDetail sharedObject].batchCode = numStr;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].highFrequencyInfo];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if (![errorCode isEqualToString:@"0000"])
    {
        endTimeStr = @"0";
        timeStr = @"00时00分";
        [RuYiCaiLotDetail sharedObject].batchEndTime = endTimeStr;
        
        return;
    }
    endTimeStr = [parserDict objectForKey:@"time_remaining"];//剩余秒数
    int leftTime = [endTimeStr intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
//		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%02d时%02d分",
                               numHour, numMinute];
    }
	[RuYiCaiLotDetail sharedObject].batchEndTime = endTimeStr;
    [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoSSQ];
    [self.tableView reloadData];
    
}
-(void)updateDLTInformation:(NSNotification *)notification{
    NSString *numStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    NSString *endTimeStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyEndTime];
    NSString *timeStr = @"";
    NSLog(@"%@",numStr);
    NSLog(@"%@",endTimeStr);
    
    [self.lotNoBatchCodeDictionary setObject:numStr forKey:kLotNoDLT];
    [self.lotNoEndTimeDictionary setObject:endTimeStr forKey:kLotNoDLT];
    [RuYiCaiLotDetail sharedObject].batchCode = numStr;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].highFrequencyInfo];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if (![errorCode isEqualToString:@"0000"])
    {
        endTimeStr = @"0";
        timeStr = @"00时00分";
        [RuYiCaiLotDetail sharedObject].batchEndTime = endTimeStr;
        
        return;
    }
    endTimeStr = [parserDict objectForKey:@"time_remaining"];//剩余秒数
    int leftTime = [endTimeStr intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
//		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%02d时%02d分",
                   numHour, numMinute];
    }
	[RuYiCaiLotDetail sharedObject].batchEndTime = endTimeStr;
    [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoDLT];
    [self.tableView reloadData];
}
- (void)updateFC3DInformation:(NSNotification *)notification{
    NSString *numStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    NSString *endTimeStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyEndTime];
    NSString *timeStr = @"";
    NSLog(@"%@",numStr);
    NSLog(@"%@",endTimeStr);
    
    [self.lotNoBatchCodeDictionary setObject:numStr forKey:kLotNoFC3D];
    [self.lotNoEndTimeDictionary setObject:endTimeStr forKey:kLotNoFC3D];
    [RuYiCaiLotDetail sharedObject].batchCode = numStr;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].highFrequencyInfo];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if (![errorCode isEqualToString:@"0000"])
    {
        endTimeStr = @"0";
        timeStr = @"00时00分";
        [RuYiCaiLotDetail sharedObject].batchEndTime = endTimeStr;
        
        return;
    }
    endTimeStr = [parserDict objectForKey:@"time_remaining"];//剩余秒数
    int leftTime = [endTimeStr intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
//		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%02d时%02d分",
                   numHour, numMinute];
    }
	[RuYiCaiLotDetail sharedObject].batchEndTime = endTimeStr;
    [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoFC3D];
    [self.tableView reloadData];
}
- (void)update11YDJInformation:(NSNotification *)notification{
    NSLog(@"update11YDJInformation");
    NSTrace();
	NSString *numStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    NSString *endTimeStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyLeftTime];
    [self.lotNoBatchCodeDictionary setObject:numStr forKey:kLotNo11YDJ];
    [self.lotNoBatchEndTimeDictionary setObject:endTimeStr forKey:kLotNo11YDJ];

	//NSLog(@"%@,%@",self.batchCode,self.batchEndTime);
	if(timer_11YDJ != nil)
	{
		[timer_11YDJ invalidate];
		timer_11YDJ = nil;
	}
	else
	{
		timer_11YDJ = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refresh11YDJTime)
												 userInfo:nil repeats:YES];
	}

    
}

- (void)updateSSCInformation:(NSNotification *)notification{
    NSLog(@"updateSSCInformation");
    NSTrace();
	NSString *numStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    NSString *endTimeStr = [[RuYiCaiNetworkManager sharedManager] highFrequencyLeftTime];
    [self.lotNoBatchCodeDictionary setObject:numStr forKey:kLotNoSSC];
    [self.lotNoBatchEndTimeDictionary setObject:endTimeStr forKey:kLotNoSSC];
    
	//NSLog(@"%@,%@",self.batchCode,self.batchEndTime);
	if(timer_SSC != nil)
	{
		[timer_SSC invalidate];
		timer_SSC = nil;
	}
	else
	{
		timer_SSC = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshSSCTime)
                                                   userInfo:nil repeats:YES];
	}
}


#pragma mark - 界面时间刷新控制
- (void)refresh11YDJTime{
//    NSLog(@"十一运夺金NSTimer^^^^^");
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNo11YDJ];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                                numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNo11YDJ];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNo11YDJ];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_11YDJ isValid])
		{
			[timer_11YDJ invalidate];
			timer_11YDJ = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNo11YDJ];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lottery11YDJInquiry];
        
        //重新获取遗漏值
//        NSDictionary *startDic = [[NSDictionary alloc] init];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexRX withObject:startDic];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ3 withObject:startDic];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ2Z withObject:startDic];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ3Z withObject:startDic];
//        [startDic release];//初始化数组
//        
//        [self getMissDateNet];
	}
	else //时间为负时，停止调用
	{
		if([timer_11YDJ isValid])
		{
			[timer_11YDJ invalidate];
			timer_11YDJ = nil;
		}
	}
}

-(void)refresh115Time{
//    NSLog(@"江西115NSTimer^^^^^");
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNo115];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNo115];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNo115];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_115 isValid])
		{
			[timer_115 invalidate];
			timer_115 = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNo115];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lottery115Inquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_115 isValid])
		{
			[timer_115 invalidate];
			timer_115 = nil;
		}
	}
}


- (void)refreshJCZQTime{
    //    NSLog(@"时时彩NSTimer^^^^^");
    NSString *jZLastEventStr = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoJCZQ];
    
    if (0 == jZLastEventStr.length)
    {
        return;
    }
	
    if([timer_JCZQ isValid])
    {
        [timer_JCZQ invalidate];
        timer_JCZQ = nil;
    }
    [[RuYiCaiNetworkManager sharedManager] getZQRecentlyEvent:@"1"];
    
	[self.tableView reloadData];
}


- (void)refreshJCLQTime{
    //    NSLog(@"时时彩NSTimer^^^^^");
    NSString *lastEventStr = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoJCLQ];
    
    if (0 == lastEventStr.length)
    {
        return;
    }
	
    if([timer_JCLQ isValid])
    {
        [timer_JCLQ invalidate];
        timer_JCLQ = nil;
    }
    [[RuYiCaiNetworkManager sharedManager] getRecentlyEvent:@"0"];
    
	[self.tableView reloadData];
}

- (void)refreshBJDCTime{
    //    NSLog(@"时时彩NSTimer^^^^^");
    NSString *lastEventStr = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoBJDC];

    if (0 == lastEventStr.length)
    {
        return;
    }
	
		if([timer_BJDC isValid])
		{
			[timer_BJDC invalidate];
			timer_BJDC = nil;
		}
	    [[RuYiCaiNetworkManager sharedManager] getBDRecentlyEvent:@"2"];

	[self.tableView reloadData];
}

-(void)refreshSSCTime{
    //    NSLog(@"时时彩NSTimer^^^^^");
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoSSC];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNoSSC];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoSSC];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_SSC isValid])
		{
			[timer_SSC invalidate];
			timer_SSC = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoSSC];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lotterySSCInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_SSC isValid])
		{
			[timer_SSC invalidate];
			timer_SSC = nil;
		}
	}
}
-(void)refreshKLSFTime{
    //    NSLog(@"广东快乐十分NSTimer^^^^^");
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoKLSF];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNoKLSF];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoKLSF];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_KLSF isValid])
		{
			[timer_KLSF invalidate];
			timer_KLSF = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoKLSF];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lotteryKLSFInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_KLSF isValid])
		{
			[timer_KLSF invalidate];
			timer_KLSF = nil;
		}
	}
}

-(void)refreshCQSFTime{
    //    NSLog(@"广东快乐十分NSTimer^^^^^");
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoCQSF];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNoCQSF];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoCQSF];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_CQSF isValid])
		{
			[timer_CQSF invalidate];
			timer_CQSF = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoCQSF];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lotteryCQSFInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_CQSF isValid])
		{
			[timer_CQSF invalidate];
			timer_CQSF = nil;
		}
	}
}

-(void)refreshCQ115Time{
    //    NSLog(@"重庆115 NSTimer^^^^^");
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoCQ115];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNoCQ115];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoCQ115];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_CQ115 isValid])
		{
			[timer_CQ115 invalidate];
			timer_CQ115 = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoCQ115];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lotteryCQ115Inquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_CQ115 isValid])
		{
			[timer_CQ115 invalidate];
			timer_CQ115 = nil;
		}
	}
}


-(void)refreshNMKSTime{
    //    NSLog(@"内蒙快三 NSTimer^^^^^");
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoNMK3];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNoNMK3];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoNMK3];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_NMKS isValid])
		{
			[timer_NMKS invalidate];
			timer_NMKS = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoNMK3];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lotteryNMKSInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_NMKS isValid])
		{
			[timer_NMKS invalidate];
			timer_NMKS = nil;
		}
	}
}

-(void)refreshGD115Time{
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoGD115];
    NSString *timeStr = @"";
    if (0 == batchEndTime.length)
    {
        return;
    }
    timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
        [self.lotNoBatchEndTimeDictionary setObject:batchEndTime forKey:kLotNoGD115];
        [self.lotNoEndTimeDictionary setObject:timeStr forKey:kLotNoGD115];
        [self.tableView reloadData];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_GD115 isValid])
		{
			[timer_GD115 invalidate];
			timer_GD115 = nil;
		}
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoGD115];//上期开奖
	    [[RuYiCaiNetworkManager sharedManager] lotteryGD115Inquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_GD115 isValid])
		{
			[timer_GD115 invalidate];
			timer_GD115 = nil;
		}
	}
}

- (void)refreshQLCTime
{
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoQLC];
    NSString *timeStr = @"";
    
    if (0 == batchEndTime.length)
    {
        return;
    }
	timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_QLC isValid])
		{
			[timer_QLC invalidate];
			timer_QLC = nil;
		}
	    [[RuYiCaiNetworkManager sharedManager] lotteryQLCInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_QLC isValid])
		{
			[timer_QLC invalidate];
			timer_QLC = nil;
		}
	}
}

- (void)refreshPLSTime{
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoPLS];
    NSString *timeStr = @"";
    
    if (0 == batchEndTime.length)
    {
        return;
    }
	timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_PLS isValid])
		{
			[timer_PLS invalidate];
			timer_PLS = nil;
		}
	    [[RuYiCaiNetworkManager sharedManager] lotteryPLSInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_PLS isValid])
		{
			[timer_PLS invalidate];
			timer_PLS = nil;
		}
	}
}
- (void)refreshPLWTime{
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoPL5];
    NSString *timeStr = @"";
    
    if (0 == batchEndTime.length)
    {
        return;
    }
	timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_PLW isValid])
		{
			[timer_PLW invalidate];
			timer_PLW = nil;
		}
	    [[RuYiCaiNetworkManager sharedManager] lotteryPLWInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_PLW isValid])
		{
			[timer_PLW invalidate];
			timer_PLW = nil;
		}
	}
}
- (void)refreshQXCTime{
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNoQXC];
    NSString *timeStr = @"";
    
    if (0 == batchEndTime.length)
    {
        return;
    }
	timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_QXC isValid])
		{
			[timer_QXC invalidate];
			timer_QXC = nil;
		}
	    [[RuYiCaiNetworkManager sharedManager] lotteryQXCInquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_QXC isValid])
		{
			[timer_QXC invalidate];
			timer_QXC = nil;
		}
	}
}
- (void)refresh22X5Time{
    NSString *batchEndTime = [self.lotNoBatchEndTimeDictionary objectForKey:kLotNo22_5];
    NSString *timeStr = @"";
    
    if (0 == batchEndTime.length)
    {
        return;
    }
	timeStr = @"0分0秒";
	int leftTime = [batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    timeStr = [NSString stringWithFormat:@"%d分%d秒",
                   numMinute, numSecond];
		batchEndTime = [NSString stringWithFormat:@"%d",[batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([timer_22X5 isValid])
		{
			[timer_22X5 invalidate];
			timer_22X5 = nil;
		}
	    [[RuYiCaiNetworkManager sharedManager] lottery22X5Inquiry];
	}
	else //时间为负时，停止调用
	{
		if([timer_22X5 isValid])
		{
			[timer_22X5 invalidate];
			timer_22X5 = nil;
		}
	}

}
- (void)refresh
{
    [[RuYiCaiNetworkManager sharedManager] getTopWinnerInformation];
}

//- (void)netFailed:(NSNotification*)notification
//{
//	[self stopLoading];
//}
#endif

#pragma AOScrollViewDelegate
-(void)buttonClick:(int)vid{
    if ([self.activityIdArray count]>0)
    {
        [self actionAD:[self.activityIdArray objectAtIndex:vid]];
    }else
    {
        UIAlertView *alertAD = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有配置该广告" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alertAD show];
        [alertAD release];
    }

}


#pragma mark 今日开奖
- (void)refreshLotState:(NSDictionary*)lotStateDic haveLotNo:(NSArray*)haveLotNoArray
{
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
    NSMutableArray* showLotArray;
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
        showLotArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        showLotArray = [[NSMutableArray alloc] initWithArray:mutableArr];
    }
    for(int i = 0; i < [showLotArray count]; i ++)
    {
        
        //--------------------双色球
        if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleSSQ])
        {
            [self refreshLotteryCell:KISDictionaryHaveKey(lotStateDic, kLotNoSSQ) forLottery:kLotNoSSQ] ;
        }
        //--------------------大乐透
        if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleDLT])
        {
            [self refreshLotteryCell:KISDictionaryHaveKey(lotStateDic, kLotNoDLT) forLottery:kLotNoDLT] ;
        }
        //--------------------福彩3D
        if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleFC3D])
        {
            
            [self refreshLotteryCell:KISDictionaryHaveKey(lotStateDic, kLotNoFC3D) forLottery:kLotNoFC3D] ;
        }
       
        //--------------------SSC
        if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleSSC])
        {
            [self refreshLotteryCell:KISDictionaryHaveKey(lotStateDic, kLotNoSSC) forLottery:kLotNoSSC] ;
        }
       
        //--------------------11YDJ
        if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitle11YDJ])
        {
             [self refreshLotteryCell:KISDictionaryHaveKey(lotStateDic, kLotNo11YDJ) forLottery:kLotNo11YDJ] ;
        }
    
    }
    
}

-(void) refreshLotteryCell:(NSDictionary*)stateDic forLottery:(NSString *)lotteryLot{
    
    NSTrace();
    NSLog(@"----%@-----",stateDic);
    if ([stateDic isEqual:@""]) {
        return;
    }
    NSLog(@"lotteryLot:%@",lotteryLot);
    BOOL isAddAwardBool = NO;
    BOOL isTodayOpenPrizeBool = NO;
    
    if([KISDictionaryHaveKey(stateDic, @"addAwardState") isEqualToString:@"1"])
    {
        isAddAwardBool = YES;
    }
    else
    {
        isAddAwardBool = NO;
    }
    if([KISDictionaryHaveKey(stateDic, @"isTodayOpenPrize") isEqualToString:@"true"])
    {
        isTodayOpenPrizeBool = YES;
    }
    else
    {
        isTodayOpenPrizeBool = NO;
    }
    if (isAddAwardBool && isTodayOpenPrizeBool) {
        [self.prizeInfomationDictionary setObject:[NSNumber numberWithInteger:TodayAddAwardAndOpenPrize] forKey:lotteryLot];
    }else if (isAddAwardBool){
        [self.prizeInfomationDictionary setObject:[NSNumber numberWithInteger:TodayAddAward] forKey:lotteryLot];
    }else if (isTodayOpenPrizeBool){
        [self.prizeInfomationDictionary setObject:[NSNumber numberWithInteger:TodayOpenPrize]forKey:lotteryLot];
    }else{
        [self.prizeInfomationDictionary setObject:[NSNumber numberWithInteger:TodayNothing] forKey:lotteryLot];
    }

}
@end
