//
//  SSC_PickNumberViewController.m
//  RuYiCai
//
//  Created by haojie on 11-10-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SSC_PickNumberViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "RYCHighBetView.h"
#import "NSLog.h"
#import "LotteryAwardInfoViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "LuckViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSegmented1xing  (0)
#define kSegmented2xing  (1)
#define kSegmented3xing  (2)
#define kSegmented5xing  (3)
#define kSegmenteddxsd   (4)

#define kLabelHeight      (20)
#define kLabelFontSize    (12)
#define kBackAlterTag     (55)

#define kMissDateIndex5X   (0)
#define kMissDateIndexDD   (1)
#define kMissDateIndex2XZ  (2)
#define kMissDateIndex2XH  (3)

#define kPerMinuteTimeInterval (60.0)

@interface SSC_PickNumberViewController (internal)

- (void)newThreadRun;
- (void)setupNavigationBar;
- (void)setDetailView;
- (void)setupSubViewsOf1xing;
- (void)updateSubViewsOf1xing;

- (void)setupSubViewsOf2xing;
- (void)updateSubViewsOf2xing;

- (void)setupSubViewsOf3xing;
- (void)updateSubViewsOf3xing;

- (void)setupSubViewsOf5xing;
- (void)updateSubViewsOf5xing;

- (void)setupSubViewsOfDxds;
- (void)updateSubViewsOfDxds;
- (void)directButtonClick;
- (void)zuButtonClick:(UIButton*)tempButton;
- (void)sumButtonClick;
- (void)tongButtonClick;

- (void)updateInformation:(NSNotification*)notification;

- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)updateBallState:(NSNotification *)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;

- (void)refreshLeftTime;

- (void)getMissDateOK:(NSNotification*)notification;
- (void)refreshMissView;
- (void)getMissDateNet;
- (void)detailViewButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;
- (void)luckButtonClick:(id)sender;

- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;
- (void)setMoreBet;

- (IBAction)addBasketClick:(id)sender;
- (IBAction)basketButtonClick:(id)sender;
@end

@implementation SSC_PickNumberViewController

@synthesize scroll1xing = m_scroll1xing;
@synthesize scroll2xing = m_scroll2xing;
@synthesize scroll3xing = m_scroll3xing;
@synthesize scroll5xing = m_scroll5xing;
@synthesize scrollDxds = m_scrollDxds;
@synthesize segmentedView = m_segmentedView;
@synthesize ballView1Direct = m_ballView1Direct;
@synthesize ballView2x1 = m_ballView2x1;
@synthesize ballView2x10 = m_ballView2x10;
@synthesize ballView2xSum = m_ballView2xSum;
@synthesize ballView3x1 = m_ballView3x1;
@synthesize ballView3x10 = m_ballView3x10;
@synthesize ballView3x100 = m_ballView3x100;
@synthesize ballView5x1 = m_ballView5x1;
@synthesize ballView5x10 = m_ballView5x10;
@synthesize ballView5x100 = m_ballView5x100;
@synthesize ballView5x1000 = m_ballView5x1000;
@synthesize ballView5x10000 = m_ballView5x10000;
@synthesize ballViewDxds1 = m_ballViewDxds1;
@synthesize ballViewDxds10 = m_ballViewDxds10;
@synthesize buttonBuy = m_buttonBuy;
@synthesize buttonReselect = m_buttonReselect;
@synthesize totalCost = m_totalCost;
@synthesize batchCode = m_batchCode;
@synthesize batchEndTime = m_batchEndTime;
@synthesize recoderYiLuoDateArr = m_recoderYiLuoDateArr;

@synthesize addBasketButton = m_addBasketButton;
@synthesize basketButton = m_basketButton;
@synthesize basketNum = m_basketNum;

- (void)viewWillDisappear:(BOOL)animated
{
    if([m_timer isValid])
	{
		[m_timer invalidate];
		m_timer = nil;
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBallState" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMissDateOK" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];
    
    //    [m_detailButton removeFromSuperview];
    [m_refreshButton removeFromSuperview];
    [m_refreshButton release], m_refreshButton = nil;
    
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [m_scroll1xing release];
    [m_scroll2xing release];
    [m_scroll3xing release];
    [m_scroll5xing release];
	[m_scrollDxds release];
    [m_segmentedView release];
    
	[m_ballView1Direct release];
    
	[m_ballView2x1 release];
	[m_ballView2x10 release];
	[m_ballView2xSum release];
	[m_label2x1 release];
	[m_label2x10 release];
	[m_directButton2x release];
	[m_zuButton2x release];
	[m_sumButton2x release];
	
	[m_ballView3x1 release];
	[m_ballView3x10 release];
	[m_ballView3x100 release];
    [m_3XingZuScroll release];
    [m_ballView3xZu release];
	[m_directButton3x release];
    [m_zu3Button3x release];
    [m_zu6Button3x release];
    
	[m_ballView5x1 release];
	[m_ballView5x10 release];
	[m_ballView5x100 release];
	[m_ballView5x1000 release];
	[m_ballView5x10000 release];
    [m_directButton5x release];
	[m_tongButton5x release];
	
	[m_ballViewDxds1 release];
	[m_ballViewDxds10 release];
	
    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_totalCost release];
	
	[m_leftTimeLabel release];
	[m_batchCodeLabel release];
    [m_recoderYiLuoDateArr release], m_recoderYiLuoDateArr = nil;
    
    [m_addBasketButton release];
    [m_basketButton release];
    [m_basketNum release];
    
    [m_detailView release], m_detailView = nil;
    
    [m_lastBatchCodeLabel release];
    [m_winRedNumLabel release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBallState:) name:@"updateBallState" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMissDateOK:) name:@"getMissDateOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLottery:) name:@"updateLottery" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoSSC];//上期开奖
    [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiry:kLotNoSSC];
    
    if (m_refreshButton != nil) {
        [m_refreshButton release], m_refreshButton = nil;
    }
    m_refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(256, 10, 20, 24)];
    [m_refreshButton addTarget:self action: @selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_refreshButton setImage:[UIImage imageNamed:@"refresh_button.png"] forState:UIControlStateNormal];
    m_refreshButton.showsTouchWhenHighlighted = TRUE;
    [self.navigationController.navigationBar addSubview:m_refreshButton];
    
    self.basketNum.text = [NSString stringWithFormat:@"%d", [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]];//刷新购物车数字
    
    m_allZhuShu = 0;//刷新注数
    for(int i = 0; i < [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]; i++)
    {
        NSString*  zhuShuStr = [[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor objectAtIndex:i] objectForKey:MORE_ZHUSHU];
        m_allZhuShu += [zhuShuStr intValue];
    }
    [self clearAllPickBall];//清空所选数据
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [MobClick event:@"GPC_selectPage"];
    
    [self setupNavigationBar];
    
    isMoreBet = NO;
    m_allZhuShu = 0;
    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:@"ssc_1x_btn.png",
                                                                        @"ssc_2x_btn.png",
                                                                        @"ssc_3x_btn.png",
                                                                        @"ssc_5x_btn.png",
                                                                        @"ssc_dxds_btn.png",
                                                                        nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:@"ssc_1x_btn.png",
                                                                        @"ssc_2x_btn.png",
                                                                        @"ssc_3x_btn.png",
                                                                        @"ssc_5x_btn.png",
                                                                        @"ssc_dxds_btn.png",
                                                                        nil]
                                                        andSelectImage:[NSArray arrayWithObjects:@"ssc_1x_hover_btn.png",
                                                                        @"ssc_2x_hov_btn.png",
                                                                        @"ssc_3x_hov_btn.png",
                                                                        @"ssc_5x_hov_btn.png",
                                                                        @"ssc_dxds_hov_btn.png",
                                                                        nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self.view addSubview:m_segmentedView];
    [self segmentedChangeValue:0];
    
    self.scroll5xing.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scroll1xing.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scroll2xing.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scroll3xing.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scrollDxds.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    
	m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setupSubViewsOf3xing];
	m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 150, 30)];
	m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",self.batchCode];
    m_batchCodeLabel.textAlignment = UITextAlignmentLeft;
    m_batchCodeLabel.backgroundColor = [UIColor clearColor];
    m_batchCodeLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_batchCodeLabel];
	
	m_leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 150, 30)];
	m_leftTimeLabel.text = @"本期剩余时间：0分0秒";
	m_leftTimeLabel.textAlignment = UITextAlignmentRight;
    m_leftTimeLabel.backgroundColor = [UIColor clearColor];
    m_leftTimeLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_leftTimeLabel];
    
    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self newThreadRun];
}

- (void)newThreadRun
{
    //初始化直选、机选、组选、和值
    [self setupSubViewsOf1xing];
    [self setupSubViewsOf2xing];
    [self setupSubViewsOf5xing];
	[self setupSubViewsOfDxds];
    
    NSDictionary *startDic = [[NSDictionary alloc] init];
    m_recoderYiLuoDateArr = [[NSMutableArray alloc] initWithObjects:startDic, startDic, startDic, startDic, nil];
    [startDic release];
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:@"T01007" sellWay:@"T01007MV_5X"];
    
    [self setDetailView];
}

#pragma mark 刷新上期开奖
- (void)refreshButtonClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoSSC];//上期开奖
}
#pragma mark   右上角 下拉按钮
- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoSSC;
    if (![[RuYiCaiNetworkManager sharedManager] hasLogin]) {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    else
    {
        [self setupQueryLotBetViewController];
    }
}

- (void)luckButtonClick:(id)sender
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
	[self setHidesBottomBarWhenPushed:YES];
	LuckViewController *pickNumberView = [[LuckViewController alloc]init];
	pickNumberView.navigationItem.title = @"幸运选号";
    
	[self.navigationController pushViewController:pickNumberView animated:YES];
    pickNumberView.randomPickType = 2;
    m_delegate.randomPickerView.pickerType = LUCK_LOT_TYPE;
    [m_delegate.randomPickerView setPickerNum:2 withMinNum:1 andMaxNum:3];
    //    双色球
    //    大乐透
    //    福彩3D
    //    时时彩
    //    江西11选5
    //    广东11选5
    //    十一运夺金
    //    广东快乐十分
    [pickNumberView randomPickerView:m_delegate.randomPickerView selectRowNum:3];
    [pickNumberView release];
}

- (void)queryBetlot_loginOK:(NSNotification*)notification
{
    [self setupQueryLotBetViewController];
}

- (void)setupQueryLotBetViewController
{
    [self setHidesBottomBarWhenPushed:YES];
    QueryLotBetViewController* viewController = [[QueryLotBetViewController alloc] init];
    viewController.navigationItem.title = @"投注查询";
    [viewController setSelectLotNo:kLotNoSSC];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}


- (void)back:(id)sender
{
    if([self.basketNum.text isEqualToString:@"0"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *backWarn = [[UIAlertView alloc]
                                 initWithTitle:@"提示"
                                 message:@"退出该页面将清空号码篮里的数据,\n是否退出？"
                                 delegate:self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@"确定", nil];
        [backWarn show];
        backWarn.tag = kBackAlterTag;
        [backWarn release];
    }
}

- (void)setupNavigationBar
{
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    UIButton* detailButton = [[UIButton alloc] initWithFrame:CGRectMake(266, 0, 44, 44)];
    [detailButton addTarget:self action: @selector(detailViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_normal"] forState:UIControlStateNormal];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_click"] forState:UIControlStateHighlighted];
    detailButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    detailButton.showsTouchWhenHighlighted = TRUE;
    //    [self.navigationController.navigationBar addSubview:m_detailButton];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:detailButton] autorelease];
    [detailButton release];
    
    m_detailView.hidden = YES;
}

- (void)setDetailView
{
    //    UITapGestureRecognizer *oneFingersOneTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingersOneTaps:)];
    //    [oneFingersOneTaps setNumberOfTapsRequired:1];
    //    [oneFingersOneTaps setNumberOfTouchesRequired:1];
    //    [self.view addGestureRecognizer:oneFingersOneTaps];
    //    [oneFingersOneTaps release];//手势,忽略其他点击事件
    
    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 2, 153, 140)];
    m_detailView.backgroundColor = [UIColor clearColor];
    
    UIImageView* imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 141)];
    imgBg.image = RYCImageNamed(@"tzy_xlmenu_bg.png");
    [imgBg setBackgroundColor:[UIColor clearColor]];
    [m_detailView addSubview:imgBg];
    [imgBg release];
    
    UIButton* introButton = [[CommonRecordStatus commonRecordStatusManager] creatIntroButton:CGRectMake(0, 0, 145, 47)];
    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* historyButton = [[CommonRecordStatus commonRecordStatusManager] creatHistoryButton:CGRectMake(0, 47, 145, 47)];
    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* QuerybetLotButton = [[CommonRecordStatus commonRecordStatusManager] creatQuerybetLotButton:CGRectMake(0, 94, 145, 47)];
    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [m_detailView addSubview:introButton];
    [m_detailView addSubview:historyButton];
    [m_detailView addSubview:QuerybetLotButton];
    [self.view addSubview:m_detailView];
    
    m_detailView.hidden = YES;
    
    
    //    UIButton* PresentSituButton = [[CommonRecordStatus commonRecordStatusManager] creatPresentSituButton:CGRectMake(5, 87, 140, 30)];
    //    [PresentSituButton addTarget:self action:@selector(PresentSituButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //    UIButton* luckButton = [[CommonRecordStatus commonRecordStatusManager] creatLuckButton:CGRectMake(5, 160, 140, 30)];
    //    [luckButton addTarget:self action:@selector(luckButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    //    UIButton* AnalogNumButton = [[CommonRecordStatus commonRecordStatusManager] creatAnalogNumButton:CGRectMake(5, 197, 140, 30)];
    //    [AnalogNumButton addTarget:self action:@selector(AnalogNumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [m_detailView addSubview:introButton];
    [m_detailView addSubview:historyButton];
    [m_detailView addSubview:QuerybetLotButton];
    [self.view addSubview:m_detailView];
    
    m_detailView.hidden = YES;
    //    [m_detailView addSubview:PresentSituButton];
    //    [m_detailView addSubview:luckButton];
    //    [m_detailView addSubview:AnalogNumButton];
    
    
}

#pragma mark build View
- (void)setupSubViewsOf1xing
{
    //奖金描述
    m_winDescribtionLable_X1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    m_winDescribtionLable_X1.text = @"至少选择1个号码投注，命中开奖号码的个位即中奖！";
    m_winDescribtionLable_X1.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable_X1.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable_X1.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable_X1.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable_X1.numberOfLines = 2;
    m_winDescribtionLable_X1.textColor = [UIColor redColor];
    [self.scroll1xing addSubview:m_winDescribtionLable_X1];
    
    //奖金：6元
    m_winMonneyLable_X1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 15)];
    m_winMonneyLable_X1.text = @"奖金：10元";
    m_winMonneyLable_X1.font = [UIFont systemFontOfSize:12];
    m_winMonneyLable_X1.textAlignment = UITextAlignmentLeft;
    m_winMonneyLable_X1.backgroundColor = [UIColor clearColor];
    m_winMonneyLable_X1.textColor = [UIColor redColor];
    [self.scroll1xing addSubview:m_winMonneyLable_X1];
    
    //直选
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 310, kLabelHeight)];
	label1.text = @"个位区（至少选择1个）：";
	label1.textAlignment = UITextAlignmentLeft;
	label1.backgroundColor = [UIColor clearColor];
	label1.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll1xing addSubview:label1];
	[label1 release];
    
    
    //	CGRect frameBall = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2,
    //									 70 ,
    //									 9 * (kBallRectWidth + kBallVerticalSpacing),
    //									 (kBallRectHeight + kBallLineSpacing+ kYiLuoHeight) * 2);
    CGRect frameBall = CGRectMake((320 - (9 * kBallVerticalSpacing) - 10 * kSmallBallRectWidth) / 2,
                                  50 + kLabelHeight,
                                  10 * (kSmallBallRectWidth + kBallVerticalSpacing),
                                  (kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight));
	m_ballView1Direct = [[PickBallViewController alloc] init];
    [m_ballView1Direct setBallSize:SMALL_BALL];
    m_ballView1Direct.isHasYiLuo = YES;
	[m_ballView1Direct createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView1Direct setBallType:RED_BALL];
	[m_ballView1Direct setSelectMaxNum:10];
	m_ballView1Direct.view.frame = frameBall;
	[self.scroll1xing addSubview:m_ballView1Direct.view];
	
    self.scroll1xing.contentSize = CGSizeMake(320, frameBall.origin.y + frameBall.size.height + 100);
    self.scroll1xing.scrollEnabled = YES;
    
    [self updateSubViewsOf1xing];
}

- (void)updateSubViewsOf1xing
{
    m_winDescribtionLable_X1.text = @"至少选择1个号码投注，命中开奖号码的个位即中奖！";
    m_winMonneyLable_X1.text = @"奖金：10元";
    [self updateBallState:nil];
}

- (void)setupSubViewsOf2xing
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scroll2xing addSubview:mode_bg];
    [mode_bg release];
    
	//2星：
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 40, 30)];
    numLabel.text = @"模式：";
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:13];
    [self.scroll2xing addSubview:numLabel];
    [numLabel release];
    
    //模式设置
    m_type2x = 0;
    m_directButton2x = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 23, 23)];
	[m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
	[m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
	[m_directButton2x addTarget:self action:@selector(directButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll2xing addSubview:m_directButton2x];
	
    UILabel *lable_direct = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 50, 23)];
    lable_direct.text = @"直选";
    lable_direct.textColor = [UIColor blackColor];
    lable_direct.backgroundColor = [UIColor clearColor];
    lable_direct.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll2xing addSubview:lable_direct];
    [lable_direct release];
    
	m_zuButton2x = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 23, 23)];
	[m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_zuButton2x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[m_zuButton2x setTitle:@"组选" forState:UIControlStateNormal];
	[m_zuButton2x addTarget:self action:@selector(zuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll2xing addSubview:m_zuButton2x];
    
    UILabel *lable_zu = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 50, 23)];
    lable_zu.text = @"组选";
    lable_zu.textColor = [UIColor blackColor];
    lable_zu.backgroundColor = [UIColor clearColor];
    lable_zu.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll2xing addSubview:lable_zu];
    [lable_zu release];
	
	m_sumButton2x = [[UIButton alloc] initWithFrame:CGRectMake(190, 10, 23, 23)];
	[m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_sumButton2x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[m_sumButton2x setTitle:@"和选" forState:UIControlStateNormal];
	[m_sumButton2x addTarget:self action:@selector(sumButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll2xing addSubview:m_sumButton2x];
    
    UILabel *lable_sum = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 50, 23)];
    lable_sum.text = @"和值";
    lable_sum.textColor = [UIColor blackColor];
    lable_sum.backgroundColor = [UIColor clearColor];
    lable_sum.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll2xing addSubview:lable_sum];
    [lable_sum release];
	
    //奖金描述
    m_winDescribtionLable_X2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    m_winDescribtionLable_X2.text = @"个、十位各选1个号码投注，按位置分别命中开奖号码的个、十位即中奖！";
    m_winDescribtionLable_X2.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable_X2.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable_X2.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable_X2.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable_X2.numberOfLines = 2;
    m_winDescribtionLable_X2.textColor = [UIColor redColor];
    [self.scroll2xing addSubview:m_winDescribtionLable_X2];
    
    //奖金：6元
    m_winMonneyLable_X2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 15)];
    m_winMonneyLable_X2.text = @"奖金：100元";
    m_winMonneyLable_X2.font = [UIFont systemFontOfSize:12];
    m_winMonneyLable_X2.textAlignment = UITextAlignmentLeft;
    m_winMonneyLable_X2.backgroundColor = [UIColor clearColor];
    m_winMonneyLable_X2.textColor = [UIColor redColor];
    [self.scroll2xing addSubview:m_winMonneyLable_X2];
    
    //直选
	m_label2x10  = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + 45, 310, kLabelHeight)];
	m_label2x10.textAlignment = UITextAlignmentLeft;
	m_label2x10.backgroundColor = [UIColor clearColor];
	m_label2x10.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll2xing addSubview:m_label2x10];
	
	CGRect frameBall10 = CGRectMake((320 - (9 * kBallVerticalSpacing) - 10 * kSmallBallRectWidth) / 2,
                                    50 + kLabelHeight  + 45,
                                    10 * (kSmallBallRectWidth + kBallVerticalSpacing),
                                    (kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight));
	m_ballView2x10 = [[PickBallViewController alloc] init];
    [m_ballView2x10 setBallSize:SMALL_BALL];
    m_ballView2x10.isHasYiLuo = YES;
	[m_ballView2x10 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView2x10 setBallType:RED_BALL];
	[m_ballView2x10 setSelectMaxNum:10];
	m_ballView2x10.view.frame = frameBall10;
	[self.scroll2xing addSubview:m_ballView2x10.view];
	
	m_label2x1 = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall10.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight), 310, kLabelHeight)];
	m_label2x1.text = @"个位区（至少选择1个球）：";
	m_label2x1.textAlignment = UITextAlignmentLeft;
	m_label2x1.backgroundColor = [UIColor clearColor];
	m_label2x1.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll2xing addSubview:m_label2x1];
	
	CGRect frameBall = CGRectMake((320 - (9 * kBallVerticalSpacing) - 10 * kSmallBallRectWidth) / 2,
								  frameBall10.origin.y + frameBall10.size.height + kLabelHeight + kBallLineSpacing,
								  frameBall10.size.width,
								  frameBall10.size.height);
	m_ballView2x1 = [[PickBallViewController alloc] init];
    [m_ballView2x1 setBallSize:SMALL_BALL];
    m_ballView2x1.isHasYiLuo = YES;
	[m_ballView2x1 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView2x1 setBallType:RED_BALL];
	[m_ballView2x1 setSelectMaxNum:10];
	m_ballView2x1.view.frame = frameBall;
	[self.scroll2xing addSubview:m_ballView2x1.view];
	
	CGRect frameBallSum = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2,
                                     50 + kLabelHeight + 45,
                                     9 * (kBallRectWidth + kBallVerticalSpacing),
                                     (kBallRectHeight + kBallLineSpacing + kYiLuoHeight) * 3);
	m_ballView2xSum = [[PickBallViewController alloc] init];
    m_ballView2xSum.isHasYiLuo = YES;
	[m_ballView2xSum createBallArray:19 withPerLine:9 startValue:0 selectBallCount:1];
	[m_ballView2xSum setBallType:RED_BALL];
	[m_ballView2xSum setSelectMaxNum:19];
	m_ballView2xSum.view.frame = frameBallSum;
	[m_scroll2xing addSubview:m_ballView2xSum.view];
	
	self.scroll2xing.contentSize = CGSizeMake(320, frameBallSum.origin.y + frameBallSum.size.height);
	self.scroll2xing.scrollEnabled = YES;
	
	[self updateSubViewsOf2xing];
}

- (void)updateSubViewsOf2xing
{
	if(0 == m_type2x)
	{
		m_label2x10.text = @"十位区（至少选择1个球）：";
		m_label2x1.hidden = NO;
		m_label2x10.hidden = NO;
		m_ballView2x1.view.hidden = NO;
		m_ballView2x10.view.hidden = NO;
		m_ballView2xSum.view.hidden = YES;
        m_winDescribtionLable_X2.text = @"个、十位各选1个号码投注，按位置分别命中开奖号码的个、十位即中奖！";
        m_winMonneyLable_X2.text = @"奖金：100元";
	}
	else if(1 == m_type2x)
	{
		m_label2x10.hidden = NO;
		m_label2x1.hidden = YES;
		m_label2x10.text = @"球区（至少选择2个球）：";
		m_ballView2x1.view.hidden = NO;
		m_ballView2x10.view.hidden = NO;
		m_ballView2x10.m_selectBallCount = 2;//至少2个球
		[m_ballView2x10 setSelectMaxNum:10];// 最多10个
		m_ballView2x1.view.hidden = YES;
		m_ballView2xSum.view.hidden = YES;
        
        m_winDescribtionLable_X2.text = @"选择2个或多个号码投注，命中开奖号码的个、十位号码即中奖！（开出对子号不逄中奖）";
        m_winMonneyLable_X2.text = @"奖金：50元";
	}
	else
	{
		m_label2x1.hidden = YES;
		m_label2x10.hidden = NO;
		m_label2x10.text = @"球区（至少选择1个球）：";
		m_ballView2x1.view.hidden = YES;
		m_ballView2x10.view.hidden = YES;
		m_ballView2xSum.view.hidden = NO;
        
        m_winDescribtionLable_X2.text = @"至少选择一个号码投注，命中开奖号码后面两位的数字相加之和即中奖！";
        m_winMonneyLable_X2.text = @"奖金：100/50元";
	}
    
    [self updateBallState:nil];
}


- (void)setupSubViewsOf3xing
{
    
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scroll3xing addSubview:mode_bg];
    [mode_bg release];
    
	//3星：
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 40, 30)];
    numLabel.text = @"模式：";
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:13];
    [self.scroll3xing addSubview:numLabel];
    [numLabel release];
    
    //模式设置
    m_type3x = 0;
    m_directButton3x = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 23, 23)];
	[m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
	[m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
	[m_directButton3x addTarget:self action:@selector(directButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll3xing addSubview:m_directButton3x];
	
    UILabel *lable_direct = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 50, 23)];
    lable_direct.text = @"直选";
    lable_direct.textColor = [UIColor blackColor];
    lable_direct.backgroundColor = [UIColor clearColor];
    lable_direct.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll3xing addSubview:lable_direct];
    [lable_direct release];
    
	m_zu3Button3x = [[UIButton alloc] initWithFrame:CGRectMake(120, 10, 23, 23)];
	[m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_zu3Button3x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[m_zu3Button3x addTarget:self action:@selector(zuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll3xing addSubview:m_zu3Button3x];
    
    UILabel *lable_zu = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 50, 23)];
    lable_zu.text = @"组三";
    lable_zu.textColor = [UIColor blackColor];
    lable_zu.backgroundColor = [UIColor clearColor];
    lable_zu.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll3xing addSubview:lable_zu];
    [lable_zu release];
	
	m_zu6Button3x = [[UIButton alloc] initWithFrame:CGRectMake(190, 10, 23, 23)];
	[m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_zu6Button3x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[m_zu6Button3x addTarget:self action:@selector(zuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll3xing addSubview:m_zu6Button3x];
    
    UILabel *lable_sum = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 50, 23)];
    lable_sum.text = @"组六";
    lable_sum.textColor = [UIColor blackColor];
    lable_sum.backgroundColor = [UIColor clearColor];
    lable_sum.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll3xing addSubview:lable_sum];
    [lable_sum release];
    
    //奖金描述
    m_winDescribtionLable_X3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    m_winDescribtionLable_X3.text = @"个、十、百位各选1个或多个号码投注，按位置分别命中开奖号码的个、十、百位即中奖！";
    m_winDescribtionLable_X3.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable_X3.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable_X3.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable_X3.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable_X3.numberOfLines = 2;
    m_winDescribtionLable_X3.textColor = [UIColor redColor];
    [self.scroll3xing addSubview:m_winDescribtionLable_X3];
    
    //奖金：6元
    m_winMonneyLable_X3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 15)];
    m_winMonneyLable_X3.text = @"奖金：1000元";
    m_winMonneyLable_X3.font = [UIFont systemFontOfSize:12];
    m_winMonneyLable_X3.textAlignment = UITextAlignmentLeft;
    m_winMonneyLable_X3.backgroundColor = [UIColor clearColor];
    m_winMonneyLable_X3.textColor = [UIColor redColor];
    [self.scroll3xing addSubview:m_winMonneyLable_X3];
    
    //直选
	UILabel *label3x100  = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, 310, kLabelHeight)];
	label3x100.text = @"百位区（至少选择1个）：";
	label3x100.textAlignment = UITextAlignmentLeft;
	label3x100.backgroundColor = [UIColor clearColor];
	label3x100.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll3xing addSubview:label3x100];
	[label3x100 release];
    
	CGRect frameBall100 = CGRectMake((320 - (9 * kBallVerticalSpacing) - 10 * kSmallBallRectWidth) / 2,
									 95 + kLabelHeight,
									 10 * (kSmallBallRectWidth + kBallVerticalSpacing),
									 (kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight));
	m_ballView3x100 = [[PickBallViewController alloc] init];
    [m_ballView3x100 setBallSize:SMALL_BALL];
    m_ballView3x100.isHasYiLuo = YES;
	[m_ballView3x100 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView3x100 setBallType:RED_BALL];
	[m_ballView3x100 setSelectMaxNum:10];
	m_ballView3x100.view.frame = frameBall100;
	[self.scroll3xing addSubview:m_ballView3x100.view];
	
    UILabel* m_label3x10  = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall100.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight), 310, kLabelHeight)];
	m_label3x10.text = @"十位区（至少选择1个）：";
	m_label3x10.textAlignment = UITextAlignmentLeft;
	m_label3x10.backgroundColor = [UIColor clearColor];
	m_label3x10.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll3xing addSubview:m_label3x10];
    [m_label3x10 release];
	
	CGRect frameBall10 = CGRectMake(frameBall100.origin.x,
									frameBall100.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight) + kLabelHeight,
									frameBall100.size.width,
									frameBall100.size.height);
	m_ballView3x10 = [[PickBallViewController alloc] init];
    [m_ballView3x10 setBallSize:SMALL_BALL];
    m_ballView3x10.isHasYiLuo = YES;
	[m_ballView3x10 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView3x10 setBallType:RED_BALL];
	[m_ballView3x10 setSelectMaxNum:10];
	m_ballView3x10.view.frame = frameBall10;
	[self.scroll3xing addSubview:m_ballView3x10.view];
	
    UILabel* m_label3x1 = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall10.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight), 310, kLabelHeight)];
	m_label3x1.text = @"个位区（至少选择1个）：";
	m_label3x1.textAlignment = UITextAlignmentLeft;
	m_label3x1.backgroundColor = [UIColor clearColor];
	m_label3x1.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll3xing addSubview:m_label3x1];
	[m_label3x1 release];
    
	CGRect frameBall = CGRectMake(frameBall100.origin.x,
                                  frameBall10.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight) + kLabelHeight,
                                  frameBall100.size.width,
                                  frameBall100.size.height);
	m_ballView3x1 = [[PickBallViewController alloc] init];
    [m_ballView3x1 setBallSize:SMALL_BALL];
    m_ballView3x1.isHasYiLuo = YES;
	[m_ballView3x1 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView3x1 setBallType:RED_BALL];
	[m_ballView3x1 setSelectMaxNum:10];
	m_ballView3x1.view.frame = frameBall;
	[self.scroll3xing addSubview:m_ballView3x1.view];
	
	self.scroll3xing.contentSize = CGSizeMake(320, frameBall.origin.y + frameBall.size.height);
	self.scroll3xing.scrollEnabled = YES;
	
    [self set3XingZuView];
    
	[self updateSubViewsOf3xing];
}

- (void)set3XingZuView//3星组选：组3 组6玩法
{
    m_3XingZuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 95, 320, m_scroll3xing.contentSize.height)];
    m_3XingZuScroll.backgroundColor = [UIColor whiteColor];
    [m_scroll3xing addSubview:m_3XingZuScroll];
    
	UILabel* label3xZu = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, kLabelHeight)];
    label3xZu.text = @"球区：";
	label3xZu.textAlignment = UITextAlignmentLeft;
	label3xZu.backgroundColor = [UIColor clearColor];
	label3xZu.font = [UIFont systemFontOfSize:kLabelFontSize];
	[m_3XingZuScroll addSubview:label3xZu];
	[label3xZu release];
    
    CGRect frameBallZu = CGRectMake((320 - (9 * kBallVerticalSpacing) - 10 * kSmallBallRectWidth) / 2,
                                    kLabelHeight,
                                    10 * (kSmallBallRectWidth + kBallVerticalSpacing),
                                    (kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight));
	m_ballView3xZu = [[PickBallViewController alloc] init];
    [m_ballView3xZu setBallSize:SMALL_BALL];
    m_ballView3xZu.isHasYiLuo = YES;
	[m_ballView3xZu createBallArray:10 withPerLine:10 startValue:0 selectBallCount:2];
	[m_ballView3xZu setBallType:RED_BALL];
	[m_ballView3xZu setSelectMaxNum:10];
	m_ballView3xZu.view.frame = frameBallZu;
	[m_3XingZuScroll addSubview:m_ballView3xZu.view];
}

- (void)updateSubViewsOf3xing
{
    if (0 == m_type3x) {
        m_3XingZuScroll.hidden = YES;
        
        m_winDescribtionLable_X3.text = @"个、十、百位各选1个或多个号码投注，按位置分别命中开奖号码的个、十、百位即中奖！";
        m_winMonneyLable_X3.text = @"奖金：1000元";
    }
    else if(1 == m_type3x)
    {
        m_3XingZuScroll.hidden = NO;
        m_ballView3xZu.m_selectBallCount = 2;//至少2个球
        
        m_winDescribtionLable_X3.text = @"选择2个或以上号码进行投注，与开奖号码的连续后3位数字相同并且包含两个相同号码，即为中奖，顺序不限!";
        m_winMonneyLable_X3.text = @"奖金：320元";
    }
    else
    {
        m_3XingZuScroll.hidden = NO;
        m_ballView3xZu.m_selectBallCount = 3;//至少3个球
        
        m_winDescribtionLable_X3.text = @"选择3个或以上号码进行投注，与开奖号码的连续后3位数字相同，即为中奖，顺序不限!";
        m_winMonneyLable_X3.text = @"奖金：160元";
    }
    
    [self updateBallState:nil];
}

- (void)setupSubViewsOf5xing
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scroll5xing addSubview:mode_bg];
    [mode_bg release];
    
	//5星：
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 40, 30)];
    numLabel.text = @"模式：";
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:13];
    [self.scroll5xing addSubview:numLabel];
    [numLabel release];
	
    //模式设置
    m_type5x = 0;
    m_directButton5x = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 23, 23)];
	[m_directButton5x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
	[m_directButton5x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
    [m_directButton5x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[m_directButton5x setTitle:@"直选" forState:UIControlStateNormal];
	[m_directButton5x addTarget:self action:@selector(directButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll5xing addSubview:m_directButton5x];
	
    UILabel *lable_direct = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 100, 23)];
    lable_direct.text = @"五星直选";
    lable_direct.textColor = [UIColor blackColor];
    lable_direct.backgroundColor = [UIColor clearColor];
    lable_direct.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll5xing addSubview:lable_direct];
    [lable_direct release];
    
	m_tongButton5x = [[UIButton alloc] initWithFrame:CGRectMake(190, 10, 23, 23)];
	[m_tongButton5x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_tongButton5x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_tongButton5x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	//[m_tongButton5x setTitle:@"五星通选" forState:UIControlStateNormal];
	[m_tongButton5x addTarget:self action:@selector(tongButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll5xing addSubview:m_tongButton5x];
    
    UILabel *lable_tong = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 100, 23)];
    lable_tong.text = @"五星通选";
    lable_tong.textColor = [UIColor blackColor];
    lable_tong.backgroundColor = [UIColor clearColor];
    lable_tong.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll5xing addSubview:lable_tong];
    [lable_tong release];
    
    //奖金描述
    m_winDescribtionLable_X5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    m_winDescribtionLable_X5.text = @"每位各选1个或多个号码投注，按位置全部命中即中奖！";
    m_winDescribtionLable_X5.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable_X5.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable_X5.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable_X5.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable_X5.numberOfLines = 2;
    m_winDescribtionLable_X5.textColor = [UIColor redColor];
    [self.scroll5xing addSubview:m_winDescribtionLable_X5];
    
    //奖金：6元
    m_winMonneyLable_X5 = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 15)];
    m_winMonneyLable_X5.text = @"奖金：100000元";
    m_winMonneyLable_X5.font = [UIFont systemFontOfSize:12];
    m_winMonneyLable_X5.textAlignment = UITextAlignmentLeft;
    m_winMonneyLable_X5.backgroundColor = [UIColor clearColor];
    m_winMonneyLable_X5.textColor = [UIColor redColor];
    [self.scroll5xing addSubview:m_winMonneyLable_X5];
    
    //直选
	UILabel *label5x10000  = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + 45, 310, kLabelHeight)];
	label5x10000.text = @"万位区（至少选择1个）：";
	label5x10000.textAlignment = UITextAlignmentLeft;
	label5x10000.backgroundColor = [UIColor clearColor];
	label5x10000.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll5xing addSubview:label5x10000];
	[label5x10000 release];
    
	CGRect frameBall10000 = CGRectMake((320 - (9 * kBallVerticalSpacing) - 10 * kSmallBallRectWidth) / 2,
									   50 + kLabelHeight + 45,
									   10 * (kSmallBallRectWidth + kBallVerticalSpacing),
									   (kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight) );
	m_ballView5x10000 = [[PickBallViewController alloc] init];
    [m_ballView5x10000 setBallSize:SMALL_BALL];
    m_ballView5x10000.isHasYiLuo = YES;
	[m_ballView5x10000 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView5x10000 setBallType:RED_BALL];
	[m_ballView5x10000 setSelectMaxNum:10];
	m_ballView5x10000.view.frame = frameBall10000;
	[self.scroll5xing addSubview:m_ballView5x10000.view];
	
    UILabel* m_label5x1000  = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall10000.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight), 310, kLabelHeight)];
	m_label5x1000.text = @"千位区（至少选择1个）：";
	m_label5x1000.textAlignment = UITextAlignmentLeft;
	m_label5x1000.backgroundColor = [UIColor clearColor];
	m_label5x1000.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll5xing addSubview:m_label5x1000];
    [m_label5x1000 release];
	
	CGRect frameBall1000 = CGRectMake(frameBall10000.origin.x,
									  frameBall10000.origin.y+(kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight) + kLabelHeight,
									  frameBall10000.size.width,
									  frameBall10000.size.height);
	m_ballView5x1000 = [[PickBallViewController alloc] init];
    [m_ballView5x1000 setBallSize:SMALL_BALL];
    m_ballView5x1000.isHasYiLuo = YES;
	[m_ballView5x1000 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView5x1000 setBallType:RED_BALL];
	[m_ballView5x1000 setSelectMaxNum:10];
	m_ballView5x1000.view.frame = frameBall1000;
	[self.scroll5xing addSubview:m_ballView5x1000.view];
	
	UILabel* m_label5x100  = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall1000.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight), 310, kLabelHeight)];
	m_label5x100.text = @"百位区（至少选择1个）：";
	m_label5x100.textAlignment = UITextAlignmentLeft;
	m_label5x100.backgroundColor = [UIColor clearColor];
	m_label5x100.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll5xing addSubview:m_label5x100];
	[m_label5x100 release];
    
	CGRect frameBall100 = CGRectMake(frameBall10000.origin.x,
                                     frameBall1000.origin.y+(kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight) + kLabelHeight,
                                     frameBall10000.size.width,
                                     frameBall10000.size.height);
	m_ballView5x100 = [[PickBallViewController alloc] init];
    [m_ballView5x100 setBallSize:SMALL_BALL];
    m_ballView5x100.isHasYiLuo = YES;
	[m_ballView5x100 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView5x100 setBallType:RED_BALL];
	[m_ballView5x100 setSelectMaxNum:10];
	m_ballView5x100.view.frame = frameBall100;
	[self.scroll5xing addSubview:m_ballView5x100.view];
	
	
    UILabel* m_label5x10  = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall100.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight), 310, kLabelHeight)];
	m_label5x10.text = @"十位区（至少选择1个）：";
	m_label5x10.textAlignment = UITextAlignmentLeft;
	m_label5x10.backgroundColor = [UIColor clearColor];
	m_label5x10.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll5xing addSubview:m_label5x10];
    [m_label5x10 release];
	
	CGRect frameBall10 = CGRectMake(frameBall10000.origin.x,
                                    frameBall100.origin.y+(kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight) + kLabelHeight,
                                    frameBall10000.size.width,
                                    frameBall10000.size.height);
	m_ballView5x10 = [[PickBallViewController alloc] init];
    [m_ballView5x10 setBallSize:SMALL_BALL];
    m_ballView5x10.isHasYiLuo = YES;
	[m_ballView5x10 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView5x10 setBallType:RED_BALL];
	[m_ballView5x10 setSelectMaxNum:10];
	m_ballView5x10.view.frame = frameBall10;
	[self.scroll5xing addSubview:m_ballView5x10.view];
	
	UILabel* m_label5x1 = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall10.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight), 310, kLabelHeight)];
	m_label5x1.text = @"个位区（至少选择1个）：";
	m_label5x1.textAlignment = UITextAlignmentLeft;
	m_label5x1.backgroundColor = [UIColor clearColor];
	m_label5x1.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scroll5xing addSubview:m_label5x1];
	[m_label5x1 release];
    
	CGRect frameBall = CGRectMake(frameBall10000.origin.x,
                                  frameBall10.origin.y+(kSmallBallRectHeight + kBallLineSpacing + kYiLuoHeight) + kLabelHeight,
                                  frameBall10000.size.width,
                                  frameBall10000.size.height);
	m_ballView5x1 = [[PickBallViewController alloc] init];
    [m_ballView5x1 setBallSize:SMALL_BALL];
    m_ballView5x1.isHasYiLuo = YES;
	[m_ballView5x1 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView5x1 setBallType:RED_BALL];
	[m_ballView5x1 setSelectMaxNum:10];
	m_ballView5x1.view.frame = frameBall;
	[self.scroll5xing addSubview:m_ballView5x1.view];
	
	self.scroll5xing.contentSize = CGSizeMake(320, frameBall.origin.y + frameBall.size.height);
	self.scroll5xing.scrollEnabled = YES;
	
	[self updateSubViewsOf5xing];
}

- (void)updateSubViewsOf5xing
{
    if (0 == m_type5x )
    {
        m_winDescribtionLable_X5.text = @"每位各选1个或多个号码投注，按位置全部命中即中奖！";
        m_winMonneyLable_X5.text = @"奖金：100000元";
    }
    else
    {
        m_winDescribtionLable_X5.text = @"每位选1个或多个号码，按顺序全部猜中，猜中前三或后三、前二或后二都可中奖！";
        m_winMonneyLable_X5.text = @"奖金：20000/200/20元";
        
    }
    
    [self updateBallState:nil];
}

- (void)setupSubViewsOfDxds
{
    //奖金描述
    m_winDescribtionLable_Dxds = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    m_winDescribtionLable_Dxds.text = @"每位各选1个号码投注，所选号码与开奖的个位十位号码性质按位置相符即中奖！";
    m_winDescribtionLable_Dxds.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable_Dxds.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable_Dxds.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable_Dxds.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable_Dxds.numberOfLines = 2;
    m_winDescribtionLable_Dxds.textColor = [UIColor redColor];
    [self.scrollDxds addSubview:m_winDescribtionLable_Dxds];
    
    //奖金：6元
    m_winMonneyLable_Dxds = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 15)];
    m_winMonneyLable_Dxds.text = @"奖金：4元";
    m_winMonneyLable_Dxds.font = [UIFont systemFontOfSize:12];
    m_winMonneyLable_Dxds.textAlignment = UITextAlignmentLeft;
    m_winMonneyLable_Dxds.backgroundColor = [UIColor clearColor];
    m_winMonneyLable_Dxds.textColor = [UIColor redColor];
    [self.scrollDxds addSubview:m_winMonneyLable_Dxds];
    
    //直选
	UILabel *m_label10  = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 , 310, kLabelHeight)];
	m_label10.text = @"十位区（选择1个）：";
	m_label10.textAlignment = UITextAlignmentLeft;
	m_label10.backgroundColor = [UIColor clearColor];
	m_label10.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDxds addSubview:m_label10];
	[m_label10 release];
	
	CGRect frameBall10 = CGRectMake((320 - 8 * kBallRectWidth) / 2,
									50 + kLabelHeight,
									8 * kBallRectWidth,
									kBallRectHeight * 2);
	m_ballViewDxds10 = [[PickBallViewController alloc] init];
    m_ballViewDxds10.isHasYiLuo = YES;
	[m_ballViewDxds10 createBallArrayDxds:4 withPerLine:4 startValue:0 selectBallCount:1];
	[m_ballViewDxds10 setBallType:RED_BALL];
	[m_ballViewDxds10 setSelectMaxNum:1];
	m_ballViewDxds10.view.frame = frameBall10;
	[self.scrollDxds addSubview:m_ballViewDxds10.view];
	
    UILabel* m_label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall10.origin.y+kBallRectHeight + kYiLuoHeight, 310, kLabelHeight)];
	m_label1.text = @"个位区（选择1个）：";
	m_label1.textAlignment = UITextAlignmentLeft;
	m_label1.backgroundColor = [UIColor clearColor];
	m_label1.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDxds addSubview:m_label1];
	[m_label1 release];
    
	CGRect frameBall = CGRectMake((320 - 8 * kBallRectWidth) / 2,
								  frameBall10.origin.y+kBallRectHeight + kLabelHeight + kYiLuoHeight,
								  8 * kBallRectWidth,
								  kBallRectHeight * 2);
	m_ballViewDxds1 = [[PickBallViewController alloc] init];
    m_ballViewDxds1.isHasYiLuo = YES;
	[m_ballViewDxds1 createBallArrayDxds:4 withPerLine:4 startValue:0 selectBallCount:1];
	[m_ballViewDxds1 setBallType:RED_BALL];
	[m_ballViewDxds1 setSelectMaxNum:1];
	m_ballViewDxds1.view.frame = frameBall;
	[self.scrollDxds addSubview:m_ballViewDxds1.view];
	
	self.scrollDxds.contentSize = CGSizeMake(320, frameBall.origin.y + frameBall.size.height);
	self.scrollDxds.scrollEnabled = YES;
	
	[self updateSubViewsOfDxds];
	
}

- (void)updateSubViewsOfDxds
{
    m_winDescribtionLable_Dxds.text = @"每位各选1个号码投注，所选号码与开奖的个位十位号码性质按位置相符即中奖！";
    m_winMonneyLable_Dxds.text = @"奖金：4元";
    [self updateBallState:nil];
	
}

#pragma mark ButtonClick

- (void)directButtonClick
{
	switch (self.segmentedView.segmentedIndex)
	{
        case kSegmented2xing:
		{
			if(0 != m_type2x)
			{
				m_type2x = 0;
				[m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
				[m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
                [m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
				[m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
				[m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
				[m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
				[self updateSubViewsOf2xing];
				[self pressedReselectButton:nil];
                
                [self getMissDateNet];
			}
			break;
        }
        case kSegmented3xing:
		{
			if(0 != m_type3x)
			{
				m_type3x = 0;
				[m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
				[m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
                [m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
				[m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
				[m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
				[m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
				[self updateSubViewsOf3xing];
                
                //                [self getMissDateNet];
			}
			break;
        }
            
		case kSegmented5xing:
		{
			if(0 != m_type5x)
			{
				m_type5x = 0;
				[m_directButton5x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
				[m_directButton5x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
                [m_tongButton5x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
				[m_tongButton5x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
				[self updateSubViewsOf5xing];
				[self pressedReselectButton:nil];
			}
			break;
		}
        default:
			break;
	}
}

- (void)tongButtonClick
{
	if(1 != m_type5x)
	{
		m_type5x = 1;
        [m_directButton5x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
		[m_directButton5x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
		[m_tongButton5x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
		[m_tongButton5x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
		[self updateSubViewsOf5xing];
		[self pressedReselectButton:nil];
	}
}

- (void)zuButtonClick:(UIButton*)tempButton
{
    if (tempButton == m_zuButton2x) {//2星组选
        if(1 != m_type2x)
        {
            m_type2x = 1;
            
            [m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
            [m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
            [m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
            [m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
            [m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
            [m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
            
            [self pressedReselectButton:nil];
            [self updateSubViewsOf2xing];
            
            [self getMissDateNet];//遗漏值
        }
    }
	else if(tempButton == m_zu3Button3x)//3星组3
    {
        if (1 != m_type3x) {
            m_type3x = 1;
            
            [m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
            [m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
            [m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
            [m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
            [m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
            [m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
            
            [self pressedReselectButton:nil];
            [self updateSubViewsOf3xing];
            
            //            [self getMissDateNet];//遗漏值
        }
    }
    else//3星组6
    {
        if (2 != m_type3x) {
            m_type3x = 2;
            
            [m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
            [m_directButton3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
            [m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
            [m_zu3Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
            [m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
            [m_zu6Button3x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
            
            [self pressedReselectButton:nil];
            [self updateSubViewsOf3xing];
            
            //          [self getMissDateNet];//遗漏值
        }
    }
}

- (void)sumButtonClick
{
	if(2 != m_type2x)
	{
		m_type2x = 2;
        [m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
		[m_directButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
		[m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
		[m_zuButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
		[m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
		[m_sumButton2x setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
		[self updateSubViewsOf2xing];
        
        [self getMissDateNet];//遗漏值
	}
    
}

- (void)segmentedChangeValue
{
	if (kSegmented1xing == self.segmentedView.segmentedIndex)
    {
		self.scroll1xing.hidden = NO;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf1xing];
	}
    else if (kSegmented2xing == self.segmentedView.segmentedIndex)
    {
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = NO;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf2xing];
	}
    else if (kSegmented3xing == self.segmentedView.segmentedIndex)
    {
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = NO;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf3xing];
    }
    else if (kSegmented5xing == self.segmentedView.segmentedIndex)
    {
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = NO;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf5xing];
    }
	else
	{
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = NO;
		[self updateSubViewsOfDxds];
        
        [self getMissDateNet];
	}
    
    [self updateBallState:nil];
}
- (void)segmentedChangeValue:(int)index
{
	if (kSegmented1xing == index)
    {
		self.scroll1xing.hidden = NO;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf1xing];
	}
    else if (kSegmented2xing == index)
    {
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = NO;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf2xing];
	}
    else if (kSegmented3xing == index)
    {
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = NO;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf3xing];
    }
    else if (kSegmented5xing == index)
    {
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = NO;
		self.scrollDxds.hidden = YES;
        [self updateSubViewsOf5xing];
    }
	else
	{
		self.scroll1xing.hidden = YES;
	    self.scroll2xing.hidden = YES;
        self.scroll3xing.hidden = YES;
        self.scroll5xing.hidden = YES;
		self.scrollDxds.hidden = NO;
		[self updateSubViewsOfDxds];
        
        [self getMissDateNet];
	}
    
    [self updateBallState:nil];
}

- (void)pressedBuyButton:(id)sender
{
	if (0 == m_numZhu &&  m_allZhuShu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一注" withTitle:@"错误" buttonTitle:@"确定"];
        return;
    }
    
    if(m_allZhuShu > 0)//购物篮笔数大于0时  进行多注投
    {
        if (m_numZhu > 0) {
            [self addBasketClick:nil];
        }
        [self basketButtonClick:nil];
    }
    else
    {
        isMoreBet = NO;
        [self submitLotNotification:nil];
    }
}

- (void)pressedReselectButton:(id)sender
{
	switch (self.segmentedView.segmentedIndex)
	{
		case kSegmented1xing:
		{
            [self.ballView1Direct clearBallState];
			break;
		}
		case kSegmented2xing:
		{
			if(0 == m_type2x)
			{
				[self.ballView2x1 clearBallState];
				[self.ballView2x10 clearBallState];
			}
			else if(1 == m_type2x)
			{
				[self.ballView2x10 clearBallState];
			}
			else if(2 == m_type2x)
			{
				[self.ballView2xSum clearBallState];
			}
			break;
		}
		case kSegmented3xing:
		{
            [self.ballView3x1 clearBallState];
            [self.ballView3x10 clearBallState];
            [self.ballView3x100 clearBallState];
            
            [m_ballView3xZu clearBallState];
            break;
		}
		case kSegmented5xing:
        {
            [self.ballView5x1 clearBallState];
            [self.ballView5x10 clearBallState];
            [self.ballView5x100 clearBallState];
            [self.ballView5x1000 clearBallState];
            [self.ballView5x10000 clearBallState];
            
			break;
		}
		case kSegmenteddxsd:
		{
            [self.ballViewDxds1 clearBallState];
            [self.ballViewDxds10 clearBallState];
			break;
		}
		default:
			break;
	}
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [self.ballView1Direct clearBallState];
    [self.ballView2x1 clearBallState];
    [self.ballView2x10 clearBallState];
    [self.ballView2x10 clearBallState];
    [self.ballView2xSum clearBallState];
    [self.ballView3x1 clearBallState];
    [self.ballView3x10 clearBallState];
    [self.ballView3x100 clearBallState];
    
    [m_ballView3xZu clearBallState];
    
    [self.ballView5x1 clearBallState];
    [self.ballView5x10 clearBallState];
    [self.ballView5x100 clearBallState];
    [self.ballView5x1000 clearBallState];
    [self.ballView5x10000 clearBallState];
    [self.ballViewDxds1 clearBallState];
    [self.ballViewDxds10 clearBallState];
    
    [self updateBallState:nil];
}

- (void)updateBallState:(NSNotification *)notification
{
    m_detailView.hidden = YES;
    
	NSTrace();
    NSString* totalStr = @"";
    //    NSString* redStr = @"";
	
    m_numZhu = 0;
    m_numCost = 0;
	
    switch (self.segmentedView.segmentedIndex)
	{
		case kSegmented1xing:
		{
            NSArray *balls = [self.ballView1Direct selectedBallsArray];
            int nBalls = [balls count];
            //            for (int i = 0; i < nBalls; i++)
            //            {
            //                if (i == (nBalls - 1))
            //                    redStr = [redStr stringByAppendingFormat:@"%d", [[balls objectAtIndex:i] intValue]];
            //                else
            //                    redStr = [redStr stringByAppendingFormat:@"%d,", [[balls objectAtIndex:i] intValue]];
            //            }
            
            //注数 = zuhe(5,用户选中红球数量)
            m_numZhu = RYCChoose(1, nBalls);
            //金额 = 注数 * 倍数 *（2元）* 期数
            m_numCost = m_numZhu * 2;
            if (m_numZhu == 0) {
                self.totalCost.textColor = [UIColor redColor];
                totalStr = [NSString stringWithFormat:@"  摇一摇可以机选一注"];
            }
            else
            {
                self.totalCost.textColor = [UIColor blackColor];
                int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
                totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
            }
			break;
		}
		case kSegmented2xing:
		{
			if(0 == m_type2x)
			{
				NSArray *shiBalls = [self.ballView2x10 selectedBallsArray];
				int nShiBalls = [shiBalls count];
                
				
				NSArray *geBalls = [self.ballView2x1 selectedBallsArray];
				int nGeBalls = [geBalls count];
                
				m_numZhu = RYCChoose(1, nGeBalls) * RYCChoose(1, nShiBalls);
				//金额 = 注数 * 倍数 *（2元）* 期数
                m_numCost = m_numZhu * 2;
                if (m_numZhu == 0) {
                    self.totalCost.textColor = [UIColor redColor];
                    totalStr = [NSString stringWithFormat:@"  摇一摇可以机选一注"];
                }
                else
                {
                    self.totalCost.textColor = [UIColor blackColor];
                    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
                    totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
                }
                
			}
            else if(1 == m_type2x)
			{
				NSArray *zuBalls = [self.ballView2x10 selectedBallsArray];
				int nZuBalls = [zuBalls count];
                
				m_numZhu = RYCChoose(2, nZuBalls);
				m_numCost = m_numZhu * 2;
                if (m_numZhu == 0) {
                    self.totalCost.textColor = [UIColor redColor];
                    totalStr = [NSString stringWithFormat:@"  摇一摇可以机选一注"];
                }
                else
                {
                    self.totalCost.textColor = [UIColor blackColor];
                    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
                    totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
                }
			}
			else
			{
				NSArray *indexArray = [self.ballView2xSum selectedIndexArray];
                
				m_numZhu = NumberOf2XingSum(indexArray);
				m_numCost = m_numZhu * 2;
                self.totalCost.textColor = [UIColor blackColor];
                int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
				totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
			}
            
			break;
		}
        case kSegmented3xing:
		{
            if(0 == m_type3x)
			{
                NSArray *baiBalls = [self.ballView3x100 selectedBallsArray];
                int nBaiBalls = [baiBalls count];
                
                NSArray *shiBalls = [self.ballView3x10 selectedBallsArray];
                int nShiBalls = [shiBalls count];
                
                NSArray *geBalls = [self.ballView3x1 selectedBallsArray];
                int nGeBalls = [geBalls count];
                
                //注数 = zuhe(6,用户选中红球数量) * zuhe(1,用户选中蓝球数量)
                m_numZhu = RYCChoose(1, nGeBalls) * RYCChoose(1, nShiBalls) * RYCChoose(1, nBaiBalls);
                //金额 = 注数 * 倍数 *（2元）* 期数
                m_numCost = m_numZhu * 2;
            }
            else//组3  组6
            {
                NSArray *zuBalls = [m_ballView3xZu selectedBallsArray];
                int nZuBalls = [zuBalls count];
                
                if (1 == m_type3x) {//组3
                    m_numZhu = RYCChoose(2, nZuBalls) * 2;
                    m_numCost = m_numZhu * 2;
                }
                else
                {
                    m_numZhu = RYCChoose(3, nZuBalls);
                    m_numCost = m_numZhu * 2;
                }
            }
            if (m_numZhu == 0) {
                self.totalCost.textColor = [UIColor redColor];
                totalStr = [NSString stringWithFormat:@"  摇一摇可以机选一注"];
            }
            else
            {
                self.totalCost.textColor = [UIColor blackColor];
                int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
                totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
            }
			break;
		}
        case kSegmented5xing:
		{
            NSArray *wangBalls = [self.ballView5x10000 selectedBallsArray];
            int nWangBalls = [wangBalls count];
            
            NSArray *qianBalls = [self.ballView5x1000 selectedBallsArray];
            int nQianBalls = [qianBalls count];
            
            NSArray *baiBalls = [self.ballView5x100 selectedBallsArray];
            int nBaiBalls = [baiBalls count];
            
            NSArray *shiBalls = [self.ballView5x10 selectedBallsArray];
            int nShiBalls = [shiBalls count];
            
            NSArray *geBalls = [self.ballView5x1 selectedBallsArray];
            int nGeBalls = [geBalls count];
            
            
            m_numZhu = RYCChoose(1, nGeBalls) * RYCChoose(1, nShiBalls) * RYCChoose(1, nBaiBalls)
            * RYCChoose(1, nQianBalls) * RYCChoose(1, nWangBalls);
            //金额 = 注数 * 倍数 *（2元）* 期数
            m_numCost = m_numZhu * 2;
            if (m_numZhu == 0) {
                self.totalCost.textColor = [UIColor redColor];
                totalStr = [NSString stringWithFormat:@"  摇一摇可以机选一注"];
            }
            else
            {
                self.totalCost.textColor = [UIColor blackColor];
                int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
                totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
            }
			break;
		}
		case kSegmenteddxsd:
		{
            //			redStr =@"";
			NSArray *array = [[NSArray alloc]initWithObjects:@"大",@"小",@"单",@"双",nil];
            //            int index = 0;
            NSArray *shiBalls = [self.ballViewDxds10 selectedIndexArray];
            int nShiBalls = [shiBalls count];
            //            for (int i = 0; i < nShiBalls; i++)
            //            {
            //                index = [[shiBalls objectAtIndex:i] intValue];
            //
            //                if (i == (nShiBalls - 1))
            //                    redStr = [redStr stringByAppendingFormat:@"%@+", [array objectAtIndex:index]];
            //                else
            //                    redStr = [redStr stringByAppendingFormat:@"%@,", [array objectAtIndex:index]];
            //            }
            
            NSArray *geBalls = [self.ballViewDxds1 selectedIndexArray];
            int nGeBalls = [geBalls count];
            //            for (int i = 0; i < nGeBalls; i++)
            //            {
            //                index = [[geBalls objectAtIndex:i] intValue];
            //                if (0 == nShiBalls)
            //                    redStr = [redStr stringByAppendingFormat:@" +"];
            //
            //                if (i == (nGeBalls - 1))
            //                    redStr = [redStr stringByAppendingFormat:@"%@", [array objectAtIndex:index]];
            //                else
            //                    redStr = [redStr stringByAppendingFormat:@"%@,", [array objectAtIndex:index]];
            //            }
            
            //注数 = zuhe(6,用户选中红球数量) * zuhe(1,用户选中蓝球数量)
            m_numZhu = RYCChoose(1, nGeBalls) * RYCChoose(1, nShiBalls);
            //金额 = 注数 * 倍数 *（2元）* 期数
            m_numCost = m_numZhu * 2;
            self.totalCost.textColor = [UIColor blackColor];
            int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
            totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
			[array release];
			
			break;
		}
		default:
			break;
            
	}
	self.totalCost.text = totalStr;
    
    CGSize totalStrSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:14]];
	
    CGRect frame1 = self.totalCost.frame;
    frame1.size.width = totalStrSize.width;
    self.totalCost.frame = frame1;
}

- (void)submitLotNotification:(NSNotification*)notification
{
	NSTrace();
    
    NSString* disBetCode = @"";
    
    NSString* betCode = @"";
    if (kSegmented1xing == self.segmentedView.segmentedIndex)
    {
        NSArray *redBalls = [self.ballView1Direct selectedBallsArray];
        int nRedCount = [redBalls count];
        betCode = [betCode stringByAppendingString:@"1D|-,-,-,-,"];
        disBetCode = [disBetCode stringByAppendingString:@"-,-,-,-,"];
        
        for (int i = 0; i < nRedCount; i++)
        {
            int nValue = [[redBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
        }
        [RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
    }
    else if (kSegmented2xing == self.segmentedView.segmentedIndex)
    {
		NSArray *sBalls = [self.ballView2x10 selectedBallsArray];
		int nSCount = [sBalls count];
		NSArray *gBalls = [self.ballView2x1 selectedBallsArray];
		int nGCount = [gBalls count];
		NSArray *sumBalls = [self.ballView2xSum selectedBallsArray];
		int nSumCount = [sumBalls count];
		if(0 == m_type2x)
		{
			betCode = [betCode stringByAppendingFormat:@"2D|-,-,-,"];
            disBetCode = [disBetCode stringByAppendingString:@"-,-,-,"];
            
			for (int i = 0; i < nSCount; i++)
			{
				int nValue = [[sBalls objectAtIndex:i] intValue];
				betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
			}
			betCode = [betCode stringByAppendingFormat:@","];
			disBetCode = [disBetCode stringByAppendingFormat:@","];
			for(int j = 0; j < nGCount; j++)
			{
				int nValue = [[gBalls objectAtIndex:j] intValue];
				betCode = [betCode stringByAppendingFormat:@"%d",nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
			}
			[RuYiCaiLotDetail sharedObject].sellWay = @"0";
            [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
		}
		else if(1 == m_type2x)
		{
			betCode = [betCode stringByAppendingFormat:@"F2|"];
			for (int i = 0; i < nSCount; i++)
			{
				int nValue = [[sBalls objectAtIndex:i] intValue];
				betCode = [betCode stringByAppendingFormat:@"%d", nValue];
				if((nSCount -1) == i)
				{
					disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
				}
				else
				{
					disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
				}
			}
			[RuYiCaiLotDetail sharedObject].sellWay = @"0";
            [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
		}
		else
		{
			betCode = [betCode stringByAppendingFormat:@"S2|"];
			for (int i = 0; i < nSumCount; i++)
			{
				int nValue = [[sumBalls objectAtIndex:i] intValue];
				if((nSumCount -1) == i)
				{
					betCode = [betCode stringByAppendingFormat:@"%d", nValue];
					disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
				}
				else
				{
					betCode = [betCode stringByAppendingFormat:@"%d,", nValue];
					disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
				}
			}
		    [RuYiCaiLotDetail sharedObject].sellWay = @"0";
            [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
		}
	}
    else if (kSegmented3xing == self.segmentedView.segmentedIndex)
    {
        if(0 == m_type3x)
        {
            NSArray *bBalls = [self.ballView3x100 selectedBallsArray];
            int nBCount = [bBalls count];
            NSArray *sBalls = [self.ballView3x10 selectedBallsArray];
            int nSCount = [sBalls count];
            NSArray *gBalls = [self.ballView3x1 selectedBallsArray];
            int nGCount = [gBalls count];
            
            betCode = [betCode stringByAppendingFormat:@"3D|-,-,"];
            disBetCode = [disBetCode stringByAppendingString:@"-,-,"];
            for (int i = 0; i < nBCount; i++)
            {
                int nValue = [[bBalls objectAtIndex:i] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
            }
            betCode = [betCode stringByAppendingFormat:@","];
            disBetCode = [disBetCode stringByAppendingFormat:@","];
            for(int k = 0; k < nSCount; k++)
            {
                int nValue = [[sBalls objectAtIndex:k] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d",nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
            }
            betCode = [betCode stringByAppendingFormat:@","];
            disBetCode = [disBetCode stringByAppendingFormat:@","];
            for(int j = 0; j < nGCount; j++)
            {
                int nValue = [[gBalls objectAtIndex:j] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d",nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
            }
        }
        else
        {
            NSArray *zuBalls = [m_ballView3xZu selectedBallsArray];
            int nZuCount = [zuBalls count];
            
            if (1 == m_type3x) {//组三
                betCode = [betCode stringByAppendingString:@"Z3F|"];
            }
            else//组6
            {
                if (m_numZhu > 1) {
                    betCode = [betCode stringByAppendingString:@"Z6F|"];
                }
                else
                    betCode = [betCode stringByAppendingString:@"6|"];
            }
            for (int z = 0; z < nZuCount; z++) {
                int nValue = [[zuBalls objectAtIndex:z] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                if (z != nZuCount - 1) {
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
                }
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
            }
        }
        [RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
    }
    else if (kSegmented5xing == self.segmentedView.segmentedIndex)
    {
        NSArray *wBalls = [self.ballView5x10000 selectedBallsArray];
        int nWCount = [wBalls count];
        NSArray *qBalls = [self.ballView5x1000 selectedBallsArray];
        int nQCount = [qBalls count];
        NSArray *bBalls = [self.ballView5x100 selectedBallsArray];
        int nBCount = [bBalls count];
        NSArray *sBalls = [self.ballView5x10 selectedBallsArray];
        int nSCount = [sBalls count];
        NSArray *gBalls = [self.ballView5x1 selectedBallsArray];
        int nGCount = [gBalls count];
        
        if( 0 == m_type5x)
        {
            betCode = [betCode stringByAppendingFormat:@"5D|"];
        }
        else
        {
            betCode = [betCode stringByAppendingFormat:@"5T|"];
        }
        for (int i = 0; i < nWCount; i++)
        {
            int nValue = [[wBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@","];
        disBetCode = [disBetCode stringByAppendingFormat:@","];
        for (int i = 0; i < nQCount; i++)
        {
            int nValue = [[qBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@","];
        disBetCode = [disBetCode stringByAppendingFormat:@","];
        for (int i = 0; i < nBCount; i++)
        {
            int nValue = [[bBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
          	
        }
        betCode = [betCode stringByAppendingFormat:@","];
        disBetCode = [disBetCode stringByAppendingFormat:@","];
        for(int k = 0; k < nSCount; k++)
        {
            int nValue = [[sBalls objectAtIndex:k] intValue];
            betCode = [betCode stringByAppendingFormat:@"%d",nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@","];
        disBetCode = [disBetCode stringByAppendingFormat:@","];
        for(int j = 0; j < nGCount; j++)
        {
            int nValue = [[gBalls objectAtIndex:j] intValue];
            betCode = [betCode stringByAppendingFormat:@"%d",nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
        }
        [RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
    }
    else if (kSegmenteddxsd == self.segmentedView.segmentedIndex)
    {
        NSArray *sBalls = [self.ballViewDxds10 selectedBallsArray];
        NSArray *gBalls = [self.ballViewDxds1 selectedBallsArray];
        int nValue = 0;
        NSString *subValue;
        
        betCode = [betCode stringByAppendingFormat:@"DD|"];
        int sValue = [[sBalls objectAtIndex:0]intValue];
        if(0 == sValue)
        {
            nValue = 2;
            subValue = @"大";
        }
        else if(1 == sValue)
        {
            nValue = 1;
            subValue = @"小";
        }
        else if(2 == sValue )
        {
            nValue = 5;
            subValue = @"单";
        }
        else if(3 == sValue)
        {
            nValue = 4;
            subValue = @"双";
        }
        betCode = [betCode stringByAppendingFormat:@"%d", nValue];
        disBetCode = [disBetCode stringByAppendingFormat:@"%@",subValue];
        
        int gValue = [[gBalls objectAtIndex:0]intValue];
        if(0 == gValue)
        {
            nValue = 2;
            subValue = @"大";
        }
        else if(1 == gValue)
        {
            nValue = 1;
            subValue = @"小";
        }
        else if(2 == gValue )
        {
            nValue = 5;
            subValue = @"单";
        }
        else if(3 == gValue)
        {
            nValue = 4;
            subValue = @"双";
        }
        betCode = [betCode stringByAppendingFormat:@"%d",nValue];
        disBetCode = [disBetCode stringByAppendingFormat:@"%@", subValue];
        [RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
    }
    NSLog(@"betcode:%@",betCode);
    //生成投注基本信息
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSC;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    //[RuYiCaiLotDetail sharedObject].sellWay = @"1";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_numZhu];
    
    if(!isMoreBet)
        [self betNormal:nil];
}

#pragma mark 上期开奖
- (void)updateLottery:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].lotteryInformation];
    [jsonParser release];
    if([[parserDict objectForKey:@"result"] count] <= 0)
        return;
    NSString*  winNo = [[[parserDict objectForKey:@"result"] objectAtIndex:0] objectForKey:@"winCode"];
    
    NSString* redStr = @"";
    for(int i = 0; i < 5; i++)
    {
        if(i !=4)
            redStr = [redStr stringByAppendingFormat:@"%@,", [winNo substringWithRange:NSMakeRange(i, 1)]];
        else
            redStr = [redStr stringByAppendingFormat:@"%@", [winNo substringWithRange:NSMakeRange(i, 1)]];
    }
    CGSize winRedSize = [redStr sizeWithFont:[UIFont systemFontOfSize:kLabelFontSize]];
    
    UILabel* winRedNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, winRedSize.width, 30)];
    winRedNumLabel.text = redStr;
    winRedNumLabel.textColor = [UIColor redColor];
    winRedNumLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    winRedNumLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:winRedNumLabel];
    [winRedNumLabel release];
    
    [self setDetailView];
}

#pragma mark getmissDate
- (void)getMissDateOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].netMissDate];
    [jsonParser release];
    
    switch (self.segmentedView.segmentedIndex)
    {
        case kSegmented1xing:
        case kSegmented3xing:
        case kSegmented5xing:
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex5X withObject:[parserDict objectForKey:@"result"]];
        }break;
        case kSegmented2xing:
        {
            if(0 == m_type2x)
            {
                [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex5X withObject:[parserDict objectForKey:@"result"]];
            }
            else if(1 == m_type2x)
            {
                [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex2XZ withObject:[parserDict objectForKey:@"result"]];
            }
            else if(2 == m_type2x)
            {
                [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex2XH withObject:[parserDict objectForKey:@"result"]];
            }
        }break;
        case kSegmenteddxsd:
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexDD withObject:[parserDict objectForKey:@"result"]];
        }break;
        default:
            break;
    }
    [self refreshMissView];
}

- (void)refreshMissView
{
    switch (self.segmentedView.segmentedIndex)
    {
        case kSegmented1xing:
        case kSegmented3xing:
        case kSegmented5xing:
        {
            [self.ballView1Direct creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"ge"] rowNumber:10];
            [self.ballView2x10 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"shi"] rowNumber:10];
            [self.ballView2x1 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"ge"] rowNumber:10];
            [self.ballView3x100 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"bai"] rowNumber:10];
            [self.ballView3x10 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"shi"] rowNumber:10];
            [self.ballView3x1 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"ge"] rowNumber:10];
            [self.ballView5x10000 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"wan"] rowNumber:10];
            [self.ballView5x1000 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"qian"] rowNumber:10];
            [self.ballView5x100 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"bai"] rowNumber:10];
            [self.ballView5x10 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"shi"] rowNumber:10];
            [self.ballView5x1 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"ge"] rowNumber:10];
        }break;
        case kSegmented2xing:
        {
            if(0 == m_type2x)
            {
                [self.ballView2x10 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"shi"] rowNumber:10];
                [self.ballView2x1 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] objectForKey:@"ge"] rowNumber:10];
            }
            else if(1 == m_type2x)
            {
                [self.ballView2x10 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex2XZ] objectForKey:@"miss"] rowNumber:10];
            }
            else if(2 == m_type2x)
            {
                [self.ballView2xSum creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex2XH] objectForKey:@"miss"] rowNumber:9];
            }
        }break;
        case kSegmenteddxsd:
        {
            [self.ballViewDxds10 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexDD] objectForKey:@"shiDX"] rowNumber:9];
            [self.ballViewDxds1 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexDD] objectForKey:@"geDX"] rowNumber:9];
        }break;
        default:
            break;
    }
}

- (void)getMissDateNet
{
    switch (self.segmentedView.segmentedIndex)
    {
        case kSegmented2xing:
        {
            if(0 == m_type2x)
            {
                if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] allKeys] count] == 0)
                {
                    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:@"T01007" sellWay:@"T01007MV_5X"];
                }
                else
                {
                    [self refreshMissView];
                }
            }
            else if(1 == m_type2x)
            {
                if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex2XZ] allKeys] count] == 0)
                {
                    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:@"T01007" sellWay:@"T01007MV_2ZX"];
                }
                else
                {
                    [self refreshMissView];
                }
            }
            else if(2 == m_type2x)
            {
                if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex2XH] allKeys] count] == 0)
                {
                    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:@"T01007" sellWay:@"T01007MV_2ZXHZ"];
                }
                else
                {
                    [self refreshMissView];
                }
            }
        }break;
        case kSegmenteddxsd:
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexDD] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:@"T01007" sellWay:@"T01007MV_DD"];
            }
            else
            {
                [self refreshMissView];
            }
        }break;
        default:
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndex5X] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:@"T01007" sellWay:@"T01007MV_5X"];
            }
            else
            {
                [self refreshMissView];
            }
        }break;
    }
}

#pragma mark 多注投
- (IBAction)addBasketClick:(id)sender
{
    if(m_numZhu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一注进行添加！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    m_allZhuShu = m_allZhuShu + m_numZhu;
    
    if(m_allZhuShu  > 10000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"投注注数不超过10000注！" withTitle:@"提示" buttonTitle:@"确定"];
        m_allZhuShu = m_allZhuShu - m_numZhu;
        
        return;
    }
    
    isMoreBet = YES;
    
    [self setMoreBet];
    [self clearAllPickBall];
    
    // NSLog(@"多倍投数据：%@", [RuYiCaiLotDetail sharedObject].moreBetCodeInfor);
}

- (IBAction)basketButtonClick:(id)sender
{
    if(m_allZhuShu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"号码篮为空，请添加注码" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSC;
    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"时时彩";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)setMoreBet
{
    if(self.segmentedView.segmentedIndex == kSegmented1xing)
    {
        self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + 1)];
        
        [self submitLotNotification:nil];
        
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].betCode forKey:MORE_BETCODE];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
        
        NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].disBetCode forKey:MORE_BETCODE];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
        
    }
    else if(self.segmentedView.segmentedIndex == kSegmented2xing)
    {
        self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + 1)];
        
        [self submitLotNotification:nil];
        
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].betCode forKey:MORE_BETCODE];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
        
        NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].disBetCode forKey:MORE_BETCODE];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    }
    else if(self.segmentedView.segmentedIndex == kSegmented3xing)
    {
        self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + 1)];
        
        [self submitLotNotification:nil];
        
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].betCode forKey:MORE_BETCODE];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
        
        NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].disBetCode forKey:MORE_BETCODE];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    }
    else if(self.segmentedView.segmentedIndex == kSegmented5xing)
    {
        self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + 1)];
        
        [self submitLotNotification:nil];
        
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].betCode forKey:MORE_BETCODE];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
        
        NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].disBetCode forKey:MORE_BETCODE];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    }
    else if (kSegmenteddxsd == self.segmentedView.segmentedIndex)
    {
        self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + 1)];
        
        [self submitLotNotification:nil];
        
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].betCode forKey:MORE_BETCODE];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
        
        NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].disBetCode forKey:MORE_BETCODE];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:MORE_ZHUSHU];
        [disTempDic setObject:[RuYiCaiLotDetail sharedObject].amount forKey:MORE_AMOUNT];//以分为单位
        [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    }
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSC;
    [RuYiCaiLotDetail sharedObject].isShouYiLv = NO;
}

#pragma mark bet
- (void)betNormal:(NSNotification*)notification
{
    if(m_numCost > kMaxBetCost)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单个方案注数不能超过10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    [self setHidesBottomBarWhenPushed:YES];
	RYCHighBetView* viewController = [[RYCHighBetView alloc] init];
	viewController.navigationItem.title = @"时时彩投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark 详情页
- (void)detailViewButtonClick:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    if(m_detailView.hidden)
    {
        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_detailView.layer addAnimation:transition forKey:nil];
        m_detailView.hidden = NO;
    }
    else
    {
        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_detailView.layer addAnimation:transition forKey:nil];
        m_detailView.hidden = YES;
    }
}

- (void)playIntroButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    PlayIntroduceViewController* viewController = [[PlayIntroduceViewController alloc] init];
    viewController.lotNo = kLotNoSSC;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleSSC;
    viewController.lotNo = kLotNoSSC;
    viewController.VRednumber = 50;
    viewController.VBluenumber = 0;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController refreshLotteryAwardInfo];
    [viewController lotteryButtonClick];
    
    [viewController release];
}

- (void)PresentSituButtonClick:(id)sender//走势
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleSSC;
    viewController.lotNo = kLotNoSSC;
    viewController.VRednumber = 50;
    viewController.VBluenumber = 0;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController refreshLotteryAwardInfo];
    [viewController release];
    
}

#pragma mark NSTimer method
- (void)updateInformation:(NSNotification*)notification
{
//    if (![notification.object isEqualToString:kLotNoSSC]) {
//        self.batchCode = @"";
//        return;
//    }
	NSLog(@"updatefor******");
	self.batchCode = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    self.batchEndTime = [[RuYiCaiNetworkManager sharedManager] highFrequencyLeftTime];
	m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",self.batchCode];
	if(m_timer != nil)
	{
		[m_timer invalidate];
		m_timer = nil;
	}
	else
	{
		m_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshLeftTime)
												 userInfo:nil repeats:YES];
	}
}

- (void)refreshLeftTime
{
    if (0 == self.batchEndTime.length)
    {
		return;
    }
	m_leftTimeLabel.text = @"本期剩余时间：0分0秒";
	int leftTime = [self.batchEndTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / kPerMinuteTimeInterval);
		leftTime -= numMinute * kPerMinuteTimeInterval;
		int numSecond = (int)(leftTime);
	    m_leftTimeLabel.text = [NSString stringWithFormat:@"本期剩余时间：%d分%d秒",
								numMinute, numSecond];
		self.batchEndTime = [NSString stringWithFormat:@"%d",[self.batchEndTime intValue]-1];
	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([m_timer isValid])
		{
			[m_timer invalidate];
			m_timer = nil;
		}
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"时时彩%@期时间已到，进入下一期" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
 	    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoSSC];
        //        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoSSC];//上期开奖
        
        //重新获取遗漏值
        NSDictionary *startDic = [[NSDictionary alloc] init];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex5X withObject:startDic];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexDD withObject:startDic];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex2XZ withObject:startDic];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex2XH withObject:startDic];
        [startDic release];//初始化数组
        
        [self getMissDateNet];
	}
	else //时间为负时，停止调用
	{
		if([m_timer isValid])
		{
			[m_timer invalidate];
			m_timer = nil;
		}
	}
}

#pragma mark 摇一摇（机选一注）
//然后在你的View控制器中添加/重载canBecomeFirstResponder, viewDidAppear:以及viewWillDisappear:
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

//最后在你的view控制器中添加motionEnded：
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //直选普通
    BOOL isSelectBall = FALSE;
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && kSegmented1xing == self.segmentedView.segmentedIndex)
    {
        if ([m_ballView1Direct getSelectNum] == 0) {
            [m_ballView1Direct randomBall:1];
            [self updateBallState:nil];
        }
        else
        {
            isSelectBall = TRUE;
        }
    }
    else if(motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && kSegmented2xing == self.segmentedView.segmentedIndex  && (m_type2x == 0 || m_type2x == 1))
    {
        if (m_type2x == 0) {
            if ([m_ballView2x1 getSelectNum] == 0 && [m_ballView2x10 getSelectNum] == 0) {
                [m_ballView2x1 randomBall:1];
                [m_ballView2x10 randomBall:1];
                [self updateBallState:nil];
            }
            else
            {
                isSelectBall = TRUE;
            }
        }
        else
        {
            if ([m_ballView2x10 getSelectNum] == 0) {
                [m_ballView2x10 randomBall:2];
                [self updateBallState:nil];
            }
            else
            {
                isSelectBall = TRUE;
            }
        }
        
    }
    else if(motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && kSegmented3xing == self.segmentedView.segmentedIndex)
    {
        if (m_type3x == 0) {
            if ([m_ballView3x1 getSelectNum] == 0 && [m_ballView3x10 getSelectNum] == 0 && [m_ballView3x100 getSelectNum] == 0) {
                [m_ballView3x1 randomBall:1];
                [m_ballView3x10 randomBall:1];
                [m_ballView3x100 randomBall:1];
                [self updateBallState:nil];
            }
            else
                isSelectBall = TRUE;
        }
        else
        {
            if ([m_ballView3xZu getSelectNum] == 0) {
                if (1 == m_type3x) {
                    [m_ballView3xZu randomBall:2];
                }
                else
                    [m_ballView3xZu randomBall:3];
            }
            else
                isSelectBall = TRUE;
        }
    }
    else if(motion == UIEventSubtypeMotionShake  && m_delegate.isStartYaoYiYao && kSegmented5xing == self.segmentedView.segmentedIndex)
    {
        if ([m_ballView5x1 getSelectNum] == 0 &&
            [m_ballView5x10 getSelectNum] == 0 &&
            [m_ballView5x100 getSelectNum] == 0 &&
            [m_ballView5x1000 getSelectNum] == 0 &&
            [m_ballView5x10000 getSelectNum] == 0
            )
        {
            [m_ballView5x1 randomBall:1];
            [m_ballView5x10 randomBall:1];
            [m_ballView5x100 randomBall:1];
            [m_ballView5x1000 randomBall:1];
            [m_ballView5x10000 randomBall:1];
            [self updateBallState:nil];
        }
        else
            isSelectBall = TRUE;
    }
    
    if (isSelectBall) {
        UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        
        [alterView addButtonWithTitle:@"确定"];
        alterView.delegate = self;
        [alterView show];
        
        [alterView release];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kBackAlterTag)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
            [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
        }
    }
    else
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            if (kSegmented1xing == self.segmentedView.segmentedIndex)
            {
                [m_ballView1Direct randomBall:1];
            }
            else if(kSegmented2xing == self.segmentedView.segmentedIndex)
            {
                if (m_type2x == 0) {
                    [m_ballView2x1 randomBall:1];
                    [m_ballView2x10 randomBall:1];
                }
                else
                    [m_ballView2x10 randomBall:2];
            }
            else if(kSegmented3xing == self.segmentedView.segmentedIndex)
            {
                if (0 == m_type3x) {
                    [m_ballView3x1 randomBall:1];
                    [m_ballView3x10 randomBall:1];
                    [m_ballView3x100 randomBall:1];
                }
                else if(1 == m_type3x)
                    [m_ballView3xZu randomBall:2];
                else
                    [m_ballView3xZu randomBall:3];
                
            }
            else if(kSegmented5xing == self.segmentedView.segmentedIndex)
            {
                [m_ballView5x1 randomBall:1];
                [m_ballView5x10 randomBall:1];
                [m_ballView5x100 randomBall:1];
                [m_ballView5x1000 randomBall:1];
                [m_ballView5x10000 randomBall:1];
            }
            
            [self updateBallState:nil];
        }
    }
}

#pragma mark - CustomerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self segmentedChangeValue:index];
}
@end
