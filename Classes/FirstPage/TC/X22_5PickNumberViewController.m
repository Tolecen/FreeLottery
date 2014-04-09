//
//  X22_5PickNumberViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-5-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "X22_5PickNumberViewController.h"
 
#import "RandomPickerViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "SSQRandomTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "RYCNormalBetView.h"
#import "LotteryAwardInfoViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "RandomNumViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSegmentedDirect  (0)
#define kSegmentedDrag  (1)

#define kLabelHeight      (35)
#define kLabelFontSize    (12)
#define kBackAlterTag     (55)

@interface X22_5PickNumberViewController (internal)

- (void)newThreadRun;
- (void)setupNavigationBar;
- (void)setupSubViewsOfDirectGroup;

- (void)setupSubViewsOfDragGroup;

- (void)segmentedChangeValue;
- (void)segmentedChangeValue:(int)index;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)updateBallState:(NSNotification *)notification;
- (void)deleteRandomBallCell:(NSNotification *)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;

- (void)randomNumSet;
- (void)refreshRandomTableView;
//- (void)batchCodeInformation:(NSNotification*)notification;
- (void)updateInformation:(NSNotification*)notification;

- (void)netFailed:(NSNotification*)notification;
- (void)setDetailView;
- (void)detailViewButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;
- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;

- (void) redDanBallClickChange;
- (void) redTuoBallClickChange;
- (void)randomUpdateBallState:(NSNotification*)notification;

- (IBAction)addBasketClick:(id)sender;
- (IBAction)basketButtonClick:(id)sender;
@end

@implementation X22_5PickNumberViewController

@synthesize topStatus = m_topStatus;
@synthesize scrollDirect = m_scrollDirect;
@synthesize scrollDrag = m_scrollDrag;
@synthesize segmented = m_segmented;
@synthesize segmentedView = m_segmentedView;
@synthesize buttonBuy = m_buttonBuy;
@synthesize buttonReselect = m_buttonReselect;
@synthesize totalCost = m_totalCost;
@synthesize batchCode = m_batchCode;
@synthesize batchEndTime = m_batchEndTime;
@synthesize str1Label = m_str1Label;
@synthesize str2Label = m_str2Label;
@synthesize lastBatchCode = m_lastBatchCode;

@synthesize addBasketButton = m_addBasketButton;
@synthesize basketButton = m_basketButton;
@synthesize basketNum = m_basketNum;
@synthesize bottomScrollView = m_bottomScrollView;


- (void)dealloc 
{
    if([m_timer isValid])
	{
		[m_timer invalidate];
		m_timer = nil;
	}
//    [m_backButton release];

    [m_scrollDirect release];
    [m_scrollDrag release];
    [m_segmented release];
    [m_segmentedView release];
    [m_topStatus release];
    [m_redBallViewDirect release];
    [m_randomNumView_redDirect release];
    
    [m_redDanBallViewDrag release];
    [m_randomNumView_redDan release];
    [m_redTuoBallViewDrag release];
    [m_randomNumView_redTuo release];
    
    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_totalCost release];
    [m_selectedRedBalls release];
    [m_selectedBlueBalls release];
    [m_str1Label release];
    [m_str2Label release];
    
    [m_addBasketButton release];
    [m_basketButton release];
    [m_basketNum release];
    
    [m_detailView release];
    [alreaderLabel release];
    [m_bottomScrollView release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBallState" object:nil];
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"submitLotNotification" object:nil];
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"randomUpdateBallState" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];

//    [m_detailButton removeFromSuperview];
//    [m_backButton removeFromSuperview];

    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBallState:) name:@"updateBallState" object:nil];
 
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitLotNotification:) name:@"submitLotNotification" object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(randomUpdateBallState:) name:@"randomUpdateBallState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLottery:) name:@"updateLottery" object:nil];

     //初始化导航栏
//    [self setupNavigationBar];
    
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
    [AdaptationUtils adaptation:self];
//     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"registered_images"] forBarMetrics:UIBarMetricsDefault];
    
//    [MobClick event:@"FCTC_selectPage"];
    alreaderLabel = [[UILabel alloc] init];
    alreaderLabel.textColor = [UIColor blackColor];
    alreaderLabel.text=@"已选:";
    alreaderLabel.backgroundColor = [UIColor clearColor];
    alreaderLabel.font = [UIFont systemFontOfSize:14];
    [m_bottomScrollView addSubview:alreaderLabel];

    [self setupNavigationBar];
    
    isMoreBet = NO;
    m_allZhuShu = 0;
    
    self.scrollDrag.frame = CGRectMake(0, 94, 320, [UIScreen mainScreen].bounds.size.height - 240);
    self.scrollDirect.frame = CGRectMake(0, 94, 320, [UIScreen mainScreen].bounds.size.height - 240);

    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self newThreadRun];
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNo22_5];

    [self.segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
    self.segmented.selectedSegmentIndex = 0;
    [self segmentedChangeValue];
    
    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                        andSelectImage:[NSArray arrayWithObjects:@"zixuan_click.png",@"dantuo_click.png", nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self.view addSubview:m_segmentedView];
    [self segmentedChangeValue:0];
    
    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];    
  
}
 
- (void)newThreadRun
{    
    //初始化直选、机选
    [self setupSubViewsOfDirectGroup];
    [self setupSubViewsOfDragGroup];
    
    m_str1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 120, 30)];
    self.str1Label.textAlignment = UITextAlignmentLeft;
    self.str1Label.backgroundColor = [UIColor clearColor];
    self.str1Label.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:self.str1Label];
    
    m_str2Label = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 170, 30)];
    self.str2Label.textAlignment = UITextAlignmentRight;
    self.str2Label.backgroundColor = [UIColor clearColor];
    m_str2Label.textColor = [UIColor redColor];
    self.str2Label.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:self.str2Label];    
    
//    [self setDetailView];
    self.str1Label.text = [NSString stringWithFormat:@"%@", @"期号获取中..."];
    self.str2Label.text = @"00:00:00";
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNo22_5];//获取期号
}

#pragma mark 截止时间
- (void)updateInformation:(NSNotification*)notification
{
    self.batchCode = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    self.str1Label.text = [NSString stringWithFormat:@"第%@期", self.batchCode];
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].highFrequencyInfo];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if (![errorCode isEqualToString:@"0000"])
    {
        self.batchEndTime = @"0";
        self.str2Label.text = @"00:00:00";
        [RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
        
        return;
    }
    self.batchEndTime = [parserDict objectForKey:@"time_remaining"];//剩余秒数
    int leftTime = [self.batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    self.str2Label.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                               numHour, numMinute, numSecond];
    }
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
    
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
	self.str2Label.text = @"00:00:00";
	int leftTime = [self.batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    self.str2Label.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                               numHour, numMinute, numSecond];
        self.batchEndTime = [NSString stringWithFormat:@"%d",[self.batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([m_timer isValid])
		{
			[m_timer invalidate];
			m_timer = nil;
		}
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"22选5 %@期时间已截止，投注时请确认您选择的期号！" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
//        [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNo22_5];//获取期号
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

- (void)netFailed:(NSNotification*)notification
{
    if([[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode].length == 0)
    {
        self.str1Label.text = @"期号获取失败";
    }
    if([[RuYiCaiNetworkManager sharedManager] highFrequencyEndTime].length == 0)
    {
//        self.str2Label.text = @"时间获取失败";
    }
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
    self.lastBatchCode = [[[parserDict objectForKey:@"result"] objectAtIndex:0] objectForKey:@"batchCode"];
    
    NSString*  winNo = [[[parserDict objectForKey:@"result"] objectAtIndex:0] objectForKey:@"winCode"];
    
    NSString* redStr = @"";
    for(int i = 0; i < 5; i++)
    {
        if(i != 4)
            redStr = [redStr stringByAppendingFormat:@"%@,", [winNo substringWithRange:NSMakeRange(i * 2, 2)]];
        else
            redStr = [redStr stringByAppendingFormat:@"%@", [winNo substringWithRange:NSMakeRange(i * 2, 2)]];
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

#pragma mark   右上角 下拉按钮
- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNo22_5;
    if (![[RuYiCaiNetworkManager sharedManager] hasLogin]) {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    else
    {
        [self setupQueryLotBetViewController];
    }
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
    [viewController setSelectLotNo:kLotNo22_5];
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
//    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 153, 160)];
//    m_detailView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView* imgBg = [[CommonRecordStatus commonRecordStatusManager] creatFourButtonView];
//    [m_detailView addSubview:imgBg];
//    
//    
//    UIButton* introButton = [[CommonRecordStatus commonRecordStatusManager] creatIntroButton:CGRectMake(5, 12, 140, 30)];
//    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIButton* historyButton = [[CommonRecordStatus commonRecordStatusManager] creatHistoryButton:CGRectMake(5, 47, 140, 30)];
//    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* PresentSituButton = [[CommonRecordStatus commonRecordStatusManager] creatPresentSituButton:CGRectMake(5, 87, 140, 30)];
//    [PresentSituButton addTarget:self action:@selector(PresentSituButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* QuerybetLotButton = [[CommonRecordStatus commonRecordStatusManager] creatQuerybetLotButton:CGRectMake(5, 125, 140, 30)];
//    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [m_detailView addSubview:introButton];
//    [m_detailView addSubview:historyButton];
//    [m_detailView addSubview:PresentSituButton];
//    [m_detailView addSubview:QuerybetLotButton];
//    
//    [self.view addSubview:m_detailView];
//    
//    m_detailView.hidden = YES;
    
    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 2, 153, 140)];
    m_detailView.backgroundColor = [UIColor clearColor];
    
    UIImageView* imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 140)];
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



}


- (void)setupSubViewsOfDirectGroup
{
    //选号区
    UILabel* labelRedBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    labelRedBall.text = @"   选号区（请选择5~18个号码）：";
    labelRedBall.textAlignment = UITextAlignmentLeft;
    labelRedBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelRedBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:labelRedBall];
    [labelRedBall release];
    
    CGRect frameRedBall = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight + kBallLineSpacing, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing) * 4);
    m_redBallViewDirect = [[PickBallViewController alloc] init];
    [m_redBallViewDirect createBallArray:22 withPerLine:9 startValue:1 selectBallCount:5];
	[m_redBallViewDirect setBallType:RED_BALL];
	[m_redBallViewDirect setSelectMaxNum:18];
    [m_redBallViewDirect setLViewFrame:LEFT_FRAME];
	m_redBallViewDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:m_redBallViewDirect.view];
    
    m_randomNumView_redDirect = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    [m_randomNumView_redDirect createNumBallList:14 withPerLine:8 startValue:5 withFrame:CGRectMake(0, 0, 320, kLabelHeight + frameRedBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDirect addSubview:m_randomNumView_redDirect];
 
    self.scrollDirect.contentSize = CGSizeMake(320, frameRedBall.origin.y + frameRedBall.size.height);
    self.scrollDirect.scrollEnabled = YES;    
}

- (void)setupSubViewsOfDragGroup
{
    //胆拖：前区（红球区）
    UILabel* labelRedDanBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    labelRedDanBall.text = @"   胆码区：（请选择1~4个）";
    labelRedDanBall.textAlignment = UITextAlignmentLeft;
    labelRedDanBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelRedDanBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelRedDanBall];
    [labelRedDanBall release];
    CGRect frameRedDanBall = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                        kLabelHeight + kBallLineSpacing, 
                                        9 * (kBallRectWidth + kBallVerticalSpacing), 
                                        (kBallRectHeight + kBallLineSpacing) * 3);
    m_redDanBallViewDrag = [[PickBallViewController alloc] init];
    [m_redDanBallViewDrag createBallArray:22 withPerLine:9 startValue:1 selectBallCount:1];
	[m_redDanBallViewDrag setBallType:RED_BALL];
	[m_redDanBallViewDrag setSelectMaxNum:4];
    [m_redDanBallViewDrag setLViewFrame:LEFT_FRAME];
	m_redDanBallViewDrag.view.frame = frameRedDanBall;
	[self.scrollDrag addSubview:m_redDanBallViewDrag.view];
    
    m_randomNumView_redDan = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    [m_randomNumView_redDan createNumBallList:4 withPerLine:8 startValue:1 withFrame:CGRectMake(0, 0, 320, kLabelHeight + frameRedDanBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDrag addSubview:m_randomNumView_redDan];
    
    // 胆拖 前区 ：拖码
    UILabel* labelRedTuoBall = [[UILabel alloc] initWithFrame:CGRectMake(0, frameRedDanBall.origin.y + frameRedDanBall.size.height,    320,  kLabelHeight)];
    labelRedTuoBall.text = @"   拖码区：（请选择2~21个）";
    labelRedTuoBall.textAlignment = UITextAlignmentLeft;
    labelRedTuoBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelRedTuoBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelRedTuoBall];
    [labelRedTuoBall release];
    
    CGRect frameRedTuoBall = CGRectMake(frameRedDanBall.origin.x, 
                                        frameRedDanBall.origin.y + frameRedDanBall.size.height + kLabelHeight + kBallLineSpacing, 
                                        frameRedDanBall.size.width, 
                                        (kBallRectHeight + kBallLineSpacing) * 3);
    m_redTuoBallViewDrag = [[PickBallViewController alloc] init];
    [m_redTuoBallViewDrag createBallArray:22 withPerLine:9 startValue:1 selectBallCount:2];
	[m_redTuoBallViewDrag setBallType:RED_BALL];
	[m_redTuoBallViewDrag setSelectMaxNum:21];
    [m_redTuoBallViewDrag setLViewFrame:LEFT_FRAME];
	m_redTuoBallViewDrag.view.frame = frameRedTuoBall;
	[self.scrollDrag addSubview:m_redTuoBallViewDrag.view];
    
    m_randomNumView_redTuo = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameRedDanBall.origin.y + frameRedDanBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_redTuo createNumBallList:20 withPerLine:8 startValue:2 withFrame:CGRectMake(0, frameRedDanBall.origin.y + frameRedDanBall.size.height, 320, kLabelHeight + frameRedTuoBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDrag addSubview:m_randomNumView_redTuo];
    
    self.scrollDrag.contentSize = CGSizeMake(320, frameRedTuoBall.origin.y + frameRedTuoBall.size.height);
    self.scrollDrag.scrollEnabled = YES;   

}

- (void)segmentedChangeValue
{
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = NO;
	    self.scrollDrag.hidden = YES;
	}
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = YES;
	    self.scrollDrag.hidden = NO;
	}
    [self updateBallState:nil];
}
- (void)segmentedChangeValue:(int)index
{
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = NO;
	    self.scrollDrag.hidden = YES;
	}
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = YES;
	    self.scrollDrag.hidden = NO;
	}
    [self updateBallState:nil];
}


- (void)submitLotNotification:(NSNotification*)notification
{
    //显示你的订单详情，并生成投注信息    
	
	NSString* disBetCode = @"";
    NSString* betCode = @"";
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        NSArray *redBalls = [m_redBallViewDirect selectedBallsArray];
        int nRedCount = [redBalls count];
        if (nRedCount > 5)
            betCode = [betCode stringByAppendingString:@"1@"];
        else
            betCode = [betCode stringByAppendingString:@"0@"];
        
        for (int i = 0; i < nRedCount; i++)
        {
            int nValue = [[redBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            
            if (i == (nRedCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"^"];
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
    }
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
        NSArray *redDanBalls = [m_redDanBallViewDrag selectedBallsArray];
        int nRedDanCount = [redDanBalls count];
        
        NSArray *redTuoBalls = [m_redTuoBallViewDrag selectedBallsArray];
        int nRedTuoCount = [redTuoBalls count];
        
        betCode = [betCode stringByAppendingString:@"2@"];
        for (int i = 0; i < nRedDanCount; i++)
        {
            int nValue = [[redDanBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            if (i == (nRedDanCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingString:@"*"];
        disBetCode = [disBetCode stringByAppendingFormat:@"%@", @"#"];
        for (int i = 0; i < nRedTuoCount; i++)
        {
            int nValue = [[redTuoBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            
            if (i == (nRedTuoCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingString:@"^"];
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
    }
    NSLog(@"%@  %@", betCode, disBetCode);
    //生成投注基本信息
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNo22_5;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_numZhu];
    
    //[[RuYiCaiNetworkManager sharedManager] showLotSubmitMessage:@"" withTitle:@"您的订单详情"];
    if(!isMoreBet)
        [self betNormal:nil];
}

- (void)pressedBuyButton:(id)sender
{
    if (0 == m_numZhu && m_allZhuShu == 0)
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
//        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_SUBMIT_LOT;
//        if ([RuYiCaiNetworkManager sharedManager].hasLogin)
            [self submitLotNotification:nil];
//        else
//            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
    }
}

- (void)pressedReselectButton:(id)sender
{
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
        [m_redBallViewDirect clearBallState];
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
        [m_redDanBallViewDrag clearBallState];
        [m_redTuoBallViewDrag clearBallState];
    }
 
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [m_redBallViewDirect clearBallState];
    
    [m_redDanBallViewDrag clearBallState];
    [m_redTuoBallViewDrag clearBallState];
    [self updateBallState:nil];
}

- (void)updateBallState:(NSNotification *)notification
{
    m_detailView.hidden = YES;
    
    NSString* totalStr = @"";
    m_numZhu = 0;
    m_numCost = 0;
    
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        int nRedBalls = [[m_redBallViewDirect selectedBallsArray] count];
        //注数 = zuhe(7,用户选中红球数量)
        m_numZhu = RYCChoose(5, nRedBalls);
        //金额 = 注数 * 倍数 *（2元）* 期数
        m_numCost = m_numZhu * 2;
        if (m_numZhu == 0) {
            alreaderLabel.frame = CGRectMake(5,7,35,21);
            m_totalCost.frame = CGRectMake(45,7,132,21);
            m_totalCost.textColor = [UIColor  redColor];
            totalStr = @"摇一摇可以机选一注";
        }
        else
        {
            m_totalCost.frame = CGRectMake(5,7,132,21);
            alreaderLabel.frame = CGRectMake(0, 0, 0, 0);
            m_totalCost.textColor = [UIColor  blackColor];
            totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
        }
    }
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
 
        NSObject *obj = [notification object];
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary*)obj;
            PickBallViewController *ballView = [dict objectForKey:@"ballView"];
            if(ballView == m_redDanBallViewDrag) //判断消息的发送者
            {
                [self redDanBallClickChange];
            }
            else if(ballView == m_redTuoBallViewDrag)
            {
                [self redTuoBallClickChange];
            }
        }
 
        int nRedDanBalls = [[m_redDanBallViewDrag selectedBallsArray] count];
        int nRedTuoBalls = [[m_redTuoBallViewDrag selectedBallsArray] count];
        //金额 = 注数 * 倍数 *（2元）* 期数
        if (nRedDanBalls >= 1) {
            m_numZhu = RYCChoose(5 - nRedDanBalls, nRedTuoBalls);
 
        }
        else
            m_numZhu = 0;
 
        if ([[m_redDanBallViewDrag selectedBallsArray] count] + [[m_redTuoBallViewDrag selectedBallsArray] count] < 6) {
            m_numZhu = 0;
        }
 
        m_numCost = m_numZhu * 2;
        m_totalCost.textColor = [UIColor  blackColor];
        totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
    }

    m_totalCost.text = totalStr;
    
    CGSize totalStrSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect frame1 = m_totalCost.frame;
    frame1.size.width = totalStrSize.width;
    m_totalCost.frame = frame1;
}
 

#pragma mark 多注投
- (IBAction)addBasketClick:(id)sender
{
    if(m_numZhu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一注进行添加！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (self.segmentedView.segmentedIndex == kSegmentedDrag)
    {
        if ([[m_redDanBallViewDrag selectedBallsArray] count] + [[m_redTuoBallViewDrag selectedBallsArray] count] < 6) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"胆码和拖码之和至少为6个！" withTitle:@"错误" buttonTitle:@"确定"];
            return; 
        }
    }
    m_allZhuShu = m_allZhuShu + m_numZhu;
    
    if(m_allZhuShu  > 10000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"投注注数不超过10000注！" withTitle:@"提示" buttonTitle:@"确定"];
        m_allZhuShu = m_allZhuShu - m_numZhu;
        
        return;
    }
    
    isMoreBet = YES;
//    
//    if(self.segmentedView.segmentedIndex == kSegmentedDirect)
//    {
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
//    }
    [self clearAllPickBall];

}

- (IBAction)basketButtonClick:(id)sender
{
    if(m_allZhuShu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"号码篮为空，请添加注码" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNo22_5;

    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"22选5";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark betNormal
- (void)betNormal:(NSNotification*)notification
{
    if(m_numCost > kMaxBetCost)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单个方案注数不能超过10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    [self setHidesBottomBarWhenPushed:YES];
	RYCNormalBetView* viewController = [[RYCNormalBetView alloc] init];
	viewController.navigationItem.title = @"22选5投注";
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
    viewController.lotNo = kLotNo22_5;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitle22_5;
    viewController.lotNo = kLotNo22_5;
    viewController.VRednumber = 22;
    viewController.VBluenumber = 0;
    viewController.batchCode = self.lastBatchCode == nil ? @"": self.lastBatchCode;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController refreshLotteryAwardInfo];
    [viewController lotteryButtonClick];
    viewController.isGoLottery = NO;

    [viewController release];
}


- (void)PresentSituButtonClick:(id)sender//走势
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitle22_5;
    viewController.lotNo = kLotNo22_5;
    viewController.VRednumber = 22;
    viewController.VBluenumber = 0;
    viewController.batchCode = self.lastBatchCode == nil ? @"": self.lastBatchCode;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController trendButtonClick];
    [viewController refreshLotteryAwardInfo];
    viewController.isGoLottery = NO;

    [viewController release];
}


#pragma mark 快速机选
- (void)randomUpdateBallState:(NSNotification*)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary*)obj;
        RandomNumViewController *numView = [dict objectForKey:@"numView"];
        NSInteger  numValue = [[dict objectForKey:@"numValue"] intValue];
        if(numView == m_randomNumView_redDirect) //判断消息的发送者
        {
            [m_redBallViewDirect randomBall:numValue];
        }
 
        
        else if(numView == m_randomNumView_redDan)
        {
            [m_redDanBallViewDrag randomBall:numValue];
 
            //用胆码做比较  去 拖码的数
            [self redDanBallClickChange];
            
        }
        else if(numView == m_randomNumView_redTuo)
        {
            [m_redTuoBallViewDrag randomBall:numValue];
            
            //用托马做比较  去胆码的数
            [self redTuoBallClickChange];
        }
 
    }
    [self updateBallState:nil];
}

#pragma mark 去掉 胆拖 相同的旋球
- (void) redDanBallClickChange
{
    //用胆码做比较  去 拖码的数
    for(int i = 0;i < [m_redDanBallViewDrag getSelectNum]; i++)
    {
        for(int j =0;j < [m_redTuoBallViewDrag getSelectNum]; j++)
        {
            NSMutableArray* tuoArray = [m_redTuoBallViewDrag selectedBallsArray];
            NSMutableArray* danArray = [m_redDanBallViewDrag selectedBallsArray];
            if([[tuoArray objectAtIndex:j] isEqual:[danArray objectAtIndex:i]])
            {
                [m_redTuoBallViewDrag resetStateForIndex:[[tuoArray objectAtIndex:j] intValue]-1];
                
                [tuoArray removeObjectAtIndex:j];
            }
        }
    }
    
}

- (void) redTuoBallClickChange
{
    //用托马做比较  去胆码的数
    for(int i = 0;i < [m_redTuoBallViewDrag getSelectNum]; i++)
    {
        for(int j =0;j < [m_redDanBallViewDrag getSelectNum]; j++)
        {
            NSMutableArray* tuoArray = [m_redTuoBallViewDrag selectedBallsArray];
            NSMutableArray* danArray = [m_redDanBallViewDrag selectedBallsArray];
            if([[danArray objectAtIndex:j] isEqual:[tuoArray objectAtIndex:i]])
            {
                [m_redDanBallViewDrag resetStateForIndex:[[danArray objectAtIndex:j] intValue]-1];
                
                [danArray removeObjectAtIndex:j];
            }
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

//- (void)viewWillDisappear:(BOOL)animated {
//    [self resignFirstResponder];
//    [super viewWillDisappear:animated];
//}

//最后在你的view控制器中添加motionEnded：
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentedDirect)
    {
        
        if ([m_redBallViewDirect getSelectNum] > 0) 
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alterView addButtonWithTitle:@"确定"];
            alterView.delegate = self;
            [alterView show];
            
            [alterView release];
            return;
        }
        else
        {
            [m_redBallViewDirect randomBall:5];
            
            [self updateBallState:nil];
        }
        
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
        }
    }
    else
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            if (kSegmentedDirect == self.segmentedView.segmentedIndex)
            {
                [m_redBallViewDirect randomBall:5];
                
            }
     
            [self updateBallState:nil];
        }
    }
}

#pragma mark -custom segmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self segmentedChangeValue:index];
}
@end
