//
//  DLT_PickNumberViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DLT_PickNumberViewController.h"
#import "RandomPickerViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "SSQRandomTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "LotteryAwardInfoViewController.h"
#import "NSLog.h"
#import "RYCNormalBetView.h"
#import "RandomNumViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "LuckViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSegmentedDirect  (0)
#define kSegmentedDrag  (1)
#define kSegmented12Xuan2 (2)

#define kLabelHeight      (35)
#define kLabelFontSize    (12)
#define kBackAlterTag     (55)

@interface DLT_PickNumberViewController (internal)

- (void)newThreadRun;
- (void)setupNavigationBar;
- (void)setupSubViewsOfDirectGroup;
- (void)setupSubViewsOfDragGroup;
 
- (void)setupSubViewsOfYiLouDirectGroup;

//- (void)setupSubViewsOfRandomGroup;
- (void)setUpSubViewsOf12X2;
- (void)segmentedChangeValue;
- (void)segmentedChangeValue:(int)type;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)updateBallState:(NSNotification *)notification;
 
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;
 
 
- (void)updateInformation:(NSNotification*)notification;

- (void)netFailed:(NSNotification*)notification;

- (void)setDetailView;
- (void)detailViewButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;
- (void)luckButtonClick:(id)sender;

- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;

//快速机选
- (void)randomUpdateBallState:(NSNotification*)notification;

- (void) redDanBallClickChange;
- (void) redTuoBallClickChange;
- (void) blueDanBallClickChange;
- (void) blueTuoBallClickChange;

- (IBAction)addBasketClick:(id)sender;
- (IBAction)basketButtonClick:(id)sender;
@end

@implementation DLT_PickNumberViewController
 
@synthesize topStatus = m_topStatus;
@synthesize scrollDirect = m_scrollDirect;
@synthesize scrollDrag = m_scrollDrag;
 
@synthesize scroll12X2 = m_scroll12X2;
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
@synthesize isHidePush    = m_isHidePush;


- (void)dealloc
{
    if([m_timer isValid])
	{
		[m_timer invalidate];
		m_timer = nil;
	}
//    [m_backButton release];
    [m_bottomScrollView release];
    [m_scrollDirect release];
    [m_scrollDrag release];
    [m_scroll12X2 release];
    [m_segmented release];
    [m_segmentedView release];
    [m_topStatus release];
    [m_redBallViewDirect release];
    [m_blueBallViewDirect release];
    [m_redDanBallViewDrag release];
    [m_redTuoBallViewDrag release];
    [m_blueDanBallViewDrag release];
    [m_blueTuoBallViewDrag release];
    
    [m_randomNumView_redDan release];
    [m_randomNumView_redTuo release];
    [m_randomNumView_blueDan release];
    [m_randomNumView_blueTuo release];
    
    [m_12X2BallView release];
    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_totalCost release];
    [m_selectedRedBalls release];
    [m_selectedBlueBalls release];

    [m_str1Label release];
    [m_str2Label release];
    
    [m_randomNumView_red release];
    [m_randomNumView_blue release];
    
    [m_addBasketButton release];
    [m_basketButton release];
    [m_basketNum release];
    
    [m_detailView release];
    
    [m_yiLouRedBallViewDirect release];
    [m_yiLouBlueBallViewDirect release];
    [m_randomNumView_yiLou_red release];
    [m_randomNumView_yiLou_blue release];
    [m_recordPickPageImag release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBallState" object:nil];  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];	

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"randomUpdateBallState" object:nil];
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMissDateOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];

//    [m_detailButton removeFromSuperview];
//    [m_backButton removeFromSuperview];
    
    [self resignFirstResponder];//摇一摇
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBallState:) name:@"updateBallState" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(randomUpdateBallState:) name:@"randomUpdateBallState" object:nil]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMissDateOK:) name:@"getMissDateOK" object:nil]; 
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
    
    m_recordPickPageImag.frame = CGRectMake(260, self.bottomScrollView.frame.origin.y - 20, 60, 20);
    m_recordPickPageImag.image = RYCImageNamed(@"ylz_biao.png");
    [m_recordPickPageImag setHidden:YES];
    [self clearAllPickBall];//清空所选数据
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [self setupNavigationBar];
    
    alreaderLabel = [[UILabel alloc] init];
    alreaderLabel.textColor = [UIColor blackColor];
    alreaderLabel.text=@"已选:";
    alreaderLabel.backgroundColor = [UIColor clearColor];
    alreaderLabel.font = [UIFont systemFontOfSize:14];
    [m_bottomScrollView addSubview:alreaderLabel];
    
//    [MobClick event:@"FCTC_selectPage"];

    isMoreBet = NO;
    m_allZhuShu = 0;
    
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
     
    [self newThreadRun];

    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoDLT];

//    [self.segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
//    self.segmented.selectedSegmentIndex = 0;
//    [self segmentedChangeValue];
    
    
    
//    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
//                                                       andNormalImages:[NSArray arrayWithObjects:@"dlt_zx_btn.png",@"dlt_dt_btn.png",@"dlt_12xuan2_btn.png", nil]
//                                                  andHighlightedImages:[NSArray arrayWithObjects:@"dlt_zx_btn.png",@"dlt_dt_btn.png",@"dlt_12xuan2_btn.png", nil]
//                                                        andSelectImage:[NSArray arrayWithObjects:@"dlt_zx_hover_btn.png",@"dlt_dt_hov_btn.png",@"dlt_12xuan2_hov_btn.png", nil]]autorelease];
//    
//    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                        andSelectImage:[NSArray arrayWithObjects:@"zixuan_click.png",@"dantuo_click.png", nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self.view addSubview:m_segmentedView];
    [self.segmentedView setHidden:YES];
    
    self.scrollDirect.frame = CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height - 200);
    self.scrollDirect.showsHorizontalScrollIndicator = NO;
    self.scrollDirect.showsVerticalScrollIndicator = NO;
    self.scrollDirect.delegate = self;
    self.scrollDirect.directionalLockEnabled = YES;
    self.scrollDirect.bounces = NO;//不超过边界
    self.scrollDrag.frame = CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height - 200);
//    self.scrollDrag.bounces = NO;//不超过边界
//    self.scrollDrag.showsVerticalScrollIndicator = NO;

    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)newThreadRun
{    
    //初始化直选、机选
    [self setupSubViewsOfDirectGroup];
    [self setupSubViewsOfDragGroup];
    [self setupSubViewsOfYiLouDirectGroup];
    [self setUpSubViewsOf12X2];
    
    m_str1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 120, 30)];
    m_str1Label.textAlignment = UITextAlignmentLeft;
    m_str1Label.backgroundColor = [UIColor clearColor];
    m_str1Label.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_str1Label];
    
    m_str2Label = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 170, 30)];
    m_str2Label.textAlignment = UITextAlignmentRight;
    m_str2Label.backgroundColor = [UIColor clearColor];
    m_str2Label.textColor = [UIColor redColor];
    m_str2Label.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_str2Label];
    
//    [self setDetailView];
    
//    m_recordPickPageImag = [[UIImageView alloc] initWithFrame:CGRectMake(260,self.bottomScrollView.frame.origin.y - 20,60,20)];
//    m_recordPickPageImag.image = RYCImageNamed(@"ylz_biao.png");
//    [self.view addSubview:m_recordPickPageImag];
    
    self.str1Label.text = [NSString stringWithFormat:@"%@", @"期号获取中..."];
    self.str2Label.text = @"00:00:00";
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoDLT];//获取期号
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoDLT sellWay:@"T01001MV_X"];
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
//		if([m_timer isValid])
//		{
//			[m_timer invalidate];
//			m_timer = nil;
//		}
        if (m_timer != nil) {
            if( [m_timer isValid])
            {
                [m_timer invalidate];
            }
            m_timer = nil;
        }
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"大乐透 %@期时间已截止，投注时请确认您选择的期号！" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
//        [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoDLT];//获取期号
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

- (void)back:(id)sender
{
    if([self.basketNum.text isEqualToString:@"0"])
    {
        if (m_isHidePush) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        }
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
//    UILabel *label = [[[UILabel alloc] init] autorelease];
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:label] autorelease]; //消掉系统的按钮
    
    //返回按钮
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
    NSString* blueStr = [winNo substringWithRange:NSMakeRange(winNo.length - 5, 2)];
    blueStr = [blueStr stringByAppendingFormat:@",%@", [winNo substringWithRange:NSMakeRange(winNo.length - 2, 2)]];
    
    for(int i = 0; i < 5; i++)
    {
        redStr = [redStr stringByAppendingFormat:@"%02d,", [[winNo substringWithRange:NSMakeRange(i * 3, 2)] intValue]];
    }
    CGSize winRedSize = [redStr sizeWithFont:[UIFont systemFontOfSize:kLabelFontSize]];
    
    UILabel* winRedNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, winRedSize.width, 30)];
    winRedNumLabel.text = redStr;
    winRedNumLabel.textColor = [UIColor redColor];
    winRedNumLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    winRedNumLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:winRedNumLabel];
    [winRedNumLabel release];
    
    UILabel* winBlueNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 + winRedSize.width, 0, 50, 30)];
    winBlueNumLabel.text = blueStr;
    winBlueNumLabel.textColor = [UIColor blueColor];
    winBlueNumLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    winBlueNumLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:winBlueNumLabel];
    [winBlueNumLabel release];
    
    [self setDetailView];
}

#pragma mark   右上角 下拉按钮
- (void)setDetailView
{
//    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 153, 97)];
//    m_detailView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView* imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 195)];
//    imgBg.image = RYCImageNamed(@"jcchooselist_5.png");
//    [imgBg setBackgroundColor:[UIColor clearColor]];
//    [m_detailView addSubview:imgBg];
//    [imgBg release];
//        
//    UIButton* PresentSituButton = [[CommonRecordStatus commonRecordStatusManager] creatPresentSituButton:CGRectMake(5, 87, 140, 30)];
//    [PresentSituButton addTarget:self action:@selector(PresentSituButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* introButton = [[CommonRecordStatus commonRecordStatusManager] creatIntroButton:CGRectMake(5, 12, 140, 30)];
//    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* historyButton = [[CommonRecordStatus commonRecordStatusManager] creatHistoryButton:CGRectMake(5, 47, 140, 30)];
//    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* QuerybetLotButton = [[CommonRecordStatus commonRecordStatusManager] creatQuerybetLotButton:CGRectMake(5, 125, 140, 30)];
//    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* luckButton = [[CommonRecordStatus commonRecordStatusManager] creatLuckButton:CGRectMake(5, 162, 140, 30)];
//    [luckButton addTarget:self action:@selector(luckButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [m_detailView addSubview:introButton];
//    [m_detailView addSubview:historyButton];
//    [m_detailView addSubview:PresentSituButton];
//    [m_detailView addSubview:QuerybetLotButton];
//    [m_detailView addSubview:luckButton];
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
 
- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoDLT;
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
    [viewController setSelectLotNo:kLotNoDLT];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}



- (void)setupSubViewsOfDirectGroup
{
    //直选：前区（红球区）
    UILabel* labelRedBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    labelRedBall.text = @"   前区（至少选择5个）";
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
    [m_redBallViewDirect createBallArray:35 withPerLine:9 startValue:1 selectBallCount:5];
	[m_redBallViewDirect setBallType:RED_BALL];
	[m_redBallViewDirect setSelectMaxNum:18];
    [m_redBallViewDirect setLViewFrame:LEFT_FRAME];

	m_redBallViewDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:m_redBallViewDirect.view];
    
    m_randomNumView_red = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    [m_randomNumView_red createNumBallList:14 withPerLine:8 startValue:5 withFrame:CGRectMake(0, 0, 320, kLabelHeight + frameRedBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDirect addSubview:m_randomNumView_red];
    
    //直选：后区（蓝球区）
    UILabel* labelBlueBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                                       frameRedBall.origin.y + frameRedBall.size.height, 
                                                                       320, 
                                                                       kLabelHeight)];
    labelBlueBall.text = @"   后区（至少选择2个）";
    labelBlueBall.textAlignment = UITextAlignmentLeft;
    labelBlueBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelBlueBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:labelBlueBall];
    [labelBlueBall release];
    
    CGRect frameBlueBall = CGRectMake(frameRedBall.origin.x, 
                                      frameRedBall.origin.y + frameRedBall.size.height + kLabelHeight + kBallLineSpacing, 
                                      frameRedBall.size.width, 
                                      (kBallRectHeight + kBallLineSpacing) * 2);
    m_blueBallViewDirect = [[PickBallViewController alloc] init];
    [m_blueBallViewDirect createBallArray:12 withPerLine:9 startValue:1 selectBallCount:2];
	[m_blueBallViewDirect setBallType:BLUE_BALL];
	[m_blueBallViewDirect setSelectMaxNum:12];
    [m_blueBallViewDirect setLViewFrame:LEFT_FRAME];
	m_blueBallViewDirect.view.frame = frameBlueBall;
	[self.scrollDirect addSubview:m_blueBallViewDirect.view];
    
    m_randomNumView_blue = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_blue createNumBallList:11 withPerLine:8 startValue:2 withFrame:CGRectMake(0, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight + frameBlueBall.size.height) andBallType:RANDOM_BLUE_BALL];
    [self.scrollDirect addSubview:m_randomNumView_blue];

    self.scrollDirect.contentSize = CGSizeMake(320, frameBlueBall.origin.y + frameBlueBall.size.height);
    self.scrollDirect.scrollEnabled = YES;    
}
- (void)setupSubViewsOfDragGroup
{
    //胆拖：前区（红球区）
    UILabel* labelRedDanBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    labelRedDanBall.text = @"   前区胆码：（请选择1~4个）";
    labelRedDanBall.textAlignment = UITextAlignmentLeft;
    labelRedDanBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelRedDanBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelRedDanBall];
    [labelRedDanBall release];
CGRect frameRedDanBall = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight + kBallLineSpacing, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing) * 4);
    m_redDanBallViewDrag = [[PickBallViewController alloc] init];
    [m_redDanBallViewDrag createBallArray:35 withPerLine:9 startValue:1 selectBallCount:1];
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
    labelRedTuoBall.text = @"   前区拖码：（请选择2~20个）";
    labelRedTuoBall.textAlignment = UITextAlignmentLeft;
    labelRedTuoBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelRedTuoBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelRedTuoBall];
    [labelRedTuoBall release];
    
    CGRect frameRedTuoBall = CGRectMake(frameRedDanBall.origin.x, 
                                      frameRedDanBall.origin.y + frameRedDanBall.size.height + kLabelHeight + kBallLineSpacing, 
                                      frameRedDanBall.size.width, 
                                      (kBallRectHeight + kBallLineSpacing) * 4);
    m_redTuoBallViewDrag = [[PickBallViewController alloc] init];
    [m_redTuoBallViewDrag createBallArray:35 withPerLine:9 startValue:1 selectBallCount:2];
	[m_redTuoBallViewDrag setBallType:RED_BALL];
	[m_redTuoBallViewDrag setSelectMaxNum:20];
    [m_redTuoBallViewDrag setLViewFrame:LEFT_FRAME];
	m_redTuoBallViewDrag.view.frame = frameRedTuoBall;
	[self.scrollDrag addSubview:m_redTuoBallViewDrag.view];
    
    m_randomNumView_redTuo = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameRedDanBall.origin.y + frameRedDanBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_redTuo createNumBallList:19 withPerLine:8 startValue:2 withFrame:CGRectMake(0, frameRedDanBall.origin.y + frameRedDanBall.size.height, 320, kLabelHeight + frameRedTuoBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDrag addSubview:m_randomNumView_redTuo];
    
    //后区
    //胆码
    UILabel* labelBlueDanBall = [[UILabel alloc] initWithFrame:CGRectMake(0, frameRedTuoBall.origin.y + frameRedTuoBall.size.height,  320, kLabelHeight)];
    labelBlueDanBall.text = @"后区胆码：（请选择1个）";
    labelBlueDanBall.textAlignment = UITextAlignmentLeft;
    labelBlueDanBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelBlueDanBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelBlueDanBall];
    [labelBlueDanBall release];
    
    CGRect frameBlueDanBall = CGRectMake(frameRedTuoBall.origin.x, 
                                      frameRedTuoBall.origin.y + frameRedTuoBall.size.height + kLabelHeight + kBallLineSpacing, 
                                      frameRedTuoBall.size.width, 
                                      (kBallRectHeight + kBallLineSpacing) * 2);
    m_blueDanBallViewDrag = [[PickBallViewController alloc] init];
    [m_blueDanBallViewDrag createBallArray:12 withPerLine:9 startValue:1 selectBallCount:1];
	[m_blueDanBallViewDrag setBallType:BLUE_BALL];
	[m_blueDanBallViewDrag setSelectMaxNum:1];
    [m_blueDanBallViewDrag setLViewFrame:LEFT_FRAME];
	m_blueDanBallViewDrag.view.frame = frameBlueDanBall;
	[self.scrollDrag addSubview:m_blueDanBallViewDrag.view];
    
    m_randomNumView_blueDan = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameRedTuoBall.origin.y + frameRedTuoBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_blueDan createNumBallList:1 withPerLine:8 startValue:1 withFrame:CGRectMake(0, frameRedTuoBall.origin.y + frameRedTuoBall.size.height, 320, kLabelHeight + frameRedTuoBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDrag addSubview:m_randomNumView_blueDan];
    
    //拖码
    UILabel* labelBlueTuoBall = [[UILabel alloc] initWithFrame:CGRectMake(0, frameBlueDanBall.origin.y + frameBlueDanBall.size.height, 320, kLabelHeight)];
    
    labelBlueTuoBall.text = @"后区拖码：（请选择2~11个）";
    labelBlueTuoBall.textAlignment = UITextAlignmentLeft;
    labelBlueTuoBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelBlueTuoBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelBlueTuoBall];
    [labelBlueTuoBall release];
    
    CGRect frameBlueTuoBall = CGRectMake(frameBlueDanBall.origin.x, 
                                         frameBlueDanBall.origin.y + frameBlueDanBall.size.height + kLabelHeight + kBallLineSpacing, 
                                         frameBlueDanBall.size.width, 
                                         (kBallRectHeight + kBallLineSpacing) * 2);
    m_blueTuoBallViewDrag = [[PickBallViewController alloc] init];
    [m_blueTuoBallViewDrag createBallArray:12 withPerLine:9 startValue:1 selectBallCount:2];
	[m_blueTuoBallViewDrag setBallType:BLUE_BALL];
	[m_blueTuoBallViewDrag setSelectMaxNum:11];
    [m_blueTuoBallViewDrag setLViewFrame:LEFT_FRAME];
	m_blueTuoBallViewDrag.view.frame = frameBlueTuoBall;
	[self.scrollDrag addSubview:m_blueTuoBallViewDrag.view];
    
    m_randomNumView_blueTuo = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameBlueDanBall.origin.y + frameBlueDanBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_blueTuo createNumBallList:10 withPerLine:8 startValue:2 withFrame:CGRectMake(0, frameBlueDanBall.origin.y + frameBlueDanBall.size.height, 320, kLabelHeight + frameBlueDanBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDrag addSubview:m_randomNumView_blueTuo];
 
    
    self.scrollDrag.contentSize = CGSizeMake(320, frameBlueTuoBall.origin.y + frameBlueTuoBall.size.height);
    self.scrollDrag.scrollEnabled = YES;    
 
}

- (void)setupSubViewsOfYiLouDirectGroup//遗漏
{
    //直选：红球区
    UILabel* labelRedBall = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 320, kLabelHeight)];
    labelRedBall.text = @"   前区（至少选择5个）";
    labelRedBall.textAlignment = UITextAlignmentLeft;
    labelRedBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelRedBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:labelRedBall];
    [labelRedBall release];
    
    CGRect frameRedBall = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2 + 320, 
                                     kLabelHeight + kBallLineSpacing, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing + kYiLuoHeight) * 4);
    m_yiLouRedBallViewDirect = [[PickBallViewController alloc] init];
    m_yiLouRedBallViewDirect.isHasYiLuo = YES;
    [m_yiLouRedBallViewDirect createBallArray:35 withPerLine:9 startValue:1 selectBallCount:5];
	[m_yiLouRedBallViewDirect setBallType:RED_BALL];
    [m_yiLouRedBallViewDirect setSelectMaxNum:18];
    [m_yiLouRedBallViewDirect setLViewFrame:LEFT_FRAME];
	m_yiLouRedBallViewDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:m_yiLouRedBallViewDirect.view];
    
    m_randomNumView_yiLou_red = [[RandomNumViewController alloc] initWithFrame:CGRectMake(320, 0, 320, kLabelHeight)];
    [m_randomNumView_yiLou_red createNumBallList:14 withPerLine:8 startValue:5 withFrame:CGRectMake(320, 0, 320, kLabelHeight+frameRedBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDirect addSubview:m_randomNumView_yiLou_red];
    
    //直选：篮球区
    UILabel* labelBlueBall = [[UILabel alloc] initWithFrame:CGRectMake(320, 
                                                                       frameRedBall.origin.y + (kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*4, 
                                                                       320, 
                                                                       kLabelHeight)];
    labelBlueBall.text = @"   后区（至少选择2个）";
    labelBlueBall.textAlignment = UITextAlignmentLeft;
    labelBlueBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelBlueBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:labelBlueBall];
    [labelBlueBall release];
    
    CGRect frameBlueBall = CGRectMake(frameRedBall.origin.x, 
                                      kLabelHeight + frameRedBall.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*4 + kBallLineSpacing, 
                                      frameRedBall.size.width, 
                                      (kBallRectHeight + kBallLineSpacing +kYiLuoHeight) * 2);
    m_yiLouBlueBallViewDirect = [[PickBallViewController alloc] init];
    m_yiLouBlueBallViewDirect.isHasYiLuo = YES;
    [m_yiLouBlueBallViewDirect createBallArray:12 withPerLine:9 startValue:1 selectBallCount:2];
	[m_yiLouBlueBallViewDirect setBallType:BLUE_BALL];
	[m_yiLouBlueBallViewDirect setSelectMaxNum:12];
    [m_yiLouBlueBallViewDirect setLViewFrame:LEFT_FRAME];
	m_yiLouBlueBallViewDirect.view.frame = frameBlueBall;
	[self.scrollDirect addSubview:m_yiLouBlueBallViewDirect.view];
    
    m_randomNumView_yiLou_blue= [[RandomNumViewController alloc] initWithFrame:CGRectMake(320, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_yiLou_blue createNumBallList:11 withPerLine:8 startValue:2 withFrame:CGRectMake(320, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight + frameBlueBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDirect addSubview:m_randomNumView_yiLou_blue];
    
    self.scrollDirect.contentSize = CGSizeMake(320, frameBlueBall.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2);
    self.scrollDirect.scrollEnabled = YES;
}



- (void)setUpSubViewsOf12X2
{
    UILabel* labelBall = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, kLabelHeight)];
    labelBall.text = @"球区（至少选择2个）：";
    labelBall.textAlignment = UITextAlignmentLeft;
    labelBall.backgroundColor = [UIColor clearColor];
    labelBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scroll12X2 addSubview:labelBall];
    [labelBall release];
    
    CGRect frameBall = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing + kYiLuoHeight)* 2);
    m_12X2BallView = [[PickBallViewController alloc] init];
    m_12X2BallView.isHasYiLuo = YES;
    [m_12X2BallView createBallArray:12 withPerLine:9 startValue:1 selectBallCount:2];
	[m_12X2BallView setBallType:RED_BALL];
	[m_12X2BallView setSelectMaxNum:12];
	m_12X2BallView.view.frame = frameBall;
	[self.scroll12X2 addSubview:m_12X2BallView.view];

    self.scroll12X2.contentSize = CGSizeMake(320, frameBall.origin.y + frameBall.size.height + 30);
    self.scroll12X2.scrollEnabled = YES;    
}

- (void)segmentedChangeValue
{
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = NO;
	    self.scrollDrag.hidden = YES;
        self.scroll12X2.hidden = YES;
//        m_recordPickPageImag.hidden = NO;
	}
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = YES;
	    self.scrollDrag.hidden = NO;
        self.scroll12X2.hidden = YES;
//        m_recordPickPageImag.hidden = YES;
	}
    else if(kSegmented12Xuan2 == self.segmentedView.segmentedIndex)
    {
        self.scrollDirect.hidden = YES;
        self.scrollDrag.hidden = YES;
        self.scroll12X2.hidden = NO;
//        m_recordPickPageImag.hidden = YES;
    }
    [self updateBallState:nil];
}
- (void)segmentedChangeValue:(int)type{
    
    if (kSegmentedDirect == type)
    {
		self.scrollDirect.hidden = NO;
	    self.scrollDrag.hidden = YES;
        self.scroll12X2.hidden = YES;
//        m_recordPickPageImag.hidden = NO;
	}
    else if (kSegmentedDrag == type)
    {
		self.scrollDirect.hidden = YES;
	    self.scrollDrag.hidden = NO;
        self.scroll12X2.hidden = YES;
//        m_recordPickPageImag.hidden = YES;
	}
    else if(kSegmented12Xuan2 == type)
    {
        self.scrollDirect.hidden = YES;
        self.scrollDrag.hidden = YES;
        self.scroll12X2.hidden = NO;
//        m_recordPickPageImag.hidden = YES;
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
        NSArray *blueBalls = [m_blueBallViewDirect selectedBallsArray];
        int nRedCount = [redBalls count];
        int nBlueCount = [blueBalls count];
        
        for (int i = 0; i < nRedCount; i++)
        {
            int nValue = [[redBalls objectAtIndex:i] intValue];
            if (i == (nRedCount - 1))
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            else
                betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
            
            if (i == (nRedCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"-"];
        disBetCode = [disBetCode stringByAppendingFormat:@"|"];
        
        for (int i = 0; i < nBlueCount; i++)
        {
            int nValue = [[blueBalls objectAtIndex:i] intValue];
            if (i == (nBlueCount - 1))
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            else
                betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
            
            if (i == (nBlueCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isDLTOr11X2 = YES;
    }
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
        NSArray *redDanBalls = [m_redDanBallViewDrag selectedBallsArray];
        NSArray *redTuoBalls = [m_redTuoBallViewDrag selectedBallsArray];
        NSArray *blueDanBalls = [m_blueDanBallViewDrag selectedBallsArray];
        NSArray *blueTuoBalls = [m_blueTuoBallViewDrag selectedBallsArray];
 
        
        NSInteger nRedDanCount = [redDanBalls count];
        NSInteger nRedTuoCount = [redTuoBalls count];
        NSInteger nBlueDanCount = [blueDanBalls count];
        NSInteger nBlueTuoCount = [blueTuoBalls count];
        //前区 胆码
        for (int i = 0; i < nRedDanCount; i++)
        {
            int nValue = [[redDanBalls objectAtIndex:i] intValue];
            if (i == (nRedDanCount - 1))
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            else
                betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
            
            if (i == (nRedDanCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"$"];
        disBetCode = [disBetCode stringByAppendingFormat:@"#"];
        //前区 拖码
        for (int i = 0; i < nRedTuoCount; i++)
        {
            int nValue = [[redTuoBalls objectAtIndex:i] intValue];
            if (i == (nRedTuoCount - 1))
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            else
                betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
            
            if (i == (nRedTuoCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"-"];
        disBetCode = [disBetCode stringByAppendingFormat:@"|"];
        //后区 胆码
        for (int i = 0; i < nBlueDanCount; i++)
        {
            int nValue = [[blueDanBalls objectAtIndex:i] intValue];
            if (i == (nBlueDanCount - 1))
            {
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            }
            else
            {
                betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
            }

        }
        betCode = [betCode stringByAppendingFormat:@"$"];
        disBetCode = [disBetCode stringByAppendingFormat:@"#"];

        //后区 拖码
        for (int i = 0; i < nBlueTuoCount; i++)
        {
            int nValue = [[blueTuoBalls objectAtIndex:i] intValue];
            if (i == (nBlueTuoCount - 1))
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            else
                betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
            
            if (i == (nBlueTuoCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        
//        disBetCode = [disBetCode stringByAppendingFormat:@"\n"];
 
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isDLTOr11X2 = YES;
    }
    else if (kSegmented12Xuan2 == self.segmentedView.segmentedIndex)
    {
        NSArray *Balls = [m_12X2BallView selectedBallsArray];
        int  n12X2 = [Balls count];
        for(int i = 0; i < n12X2; i++)
        {
            int nValue = [[Balls objectAtIndex:i] intValue];
            if (i == (n12X2 - 1))
            {
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d",nValue];
            }
            else
            {
                betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,",nValue];
            }
        }
        [RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isDLTOr11X2 = NO;
    }
    NSLog(@"betCode: %@",betCode);
    //生成投注基本信息
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoDLT;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    //[RuYiCaiLotDetail sharedObject].sellWay = @"0";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_numZhu];
 
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
        
        [self submitLotNotification:nil];
    }
}

- (void)pressedReselectButton:(id)sender
{
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        [m_redBallViewDirect clearBallState];
        [m_blueBallViewDirect clearBallState];
	}
    else if (kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
        [m_redDanBallViewDrag clearBallState];
        [m_redTuoBallViewDrag clearBallState];
        [m_blueDanBallViewDrag clearBallState];
        [m_blueTuoBallViewDrag clearBallState];
 
	}
    else if (kSegmented12Xuan2 == self.segmentedView.segmentedIndex)
    {
        [m_12X2BallView clearBallState];
    }
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [m_redBallViewDirect clearBallState];
    [m_blueBallViewDirect clearBallState];
    [m_12X2BallView clearBallState];
    
    
    [m_redDanBallViewDrag clearBallState];
    [m_redTuoBallViewDrag clearBallState];
    [m_blueDanBallViewDrag clearBallState];
    [m_blueTuoBallViewDrag clearBallState];
    
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
        
        CGPoint offsetofScrollView = self.scrollDirect.contentOffset;         
        NSInteger page = (offsetofScrollView.x + 160.0) / self.scrollDirect.frame.size.width;
        if(0 == page)//普通页面
        {
            [m_yiLouRedBallViewDirect selectBallForStateArr:m_redBallViewDirect.ballState];
            [m_yiLouBlueBallViewDirect selectBallForStateArr:m_blueBallViewDirect .ballState];
        }
        else
        {
            [m_redBallViewDirect selectBallForStateArr:m_yiLouRedBallViewDirect.ballState];
            [m_blueBallViewDirect selectBallForStateArr:m_yiLouBlueBallViewDirect.ballState];
        }
        
        int nRedBalls = [[m_redBallViewDirect selectedBallsArray] count];
        int nBlueBalls = [[m_blueBallViewDirect selectedBallsArray] count];
        //注数 = zuhe(5,用户选中红球数量) * zuhe(2,用户选中蓝球数量)
        m_numZhu = RYCChoose(5, nRedBalls) * RYCChoose(2, nBlueBalls);
    
        m_numCost = m_numZhu * 2;
        //金额 = 注数 * 倍数 *（2元）
        if (m_numZhu == 0) {
            [alreaderLabel setHidden:NO];
            alreaderLabel.frame = CGRectMake(5,7,35,21);
            m_totalCost.frame = CGRectMake(45,7,132,21);
            m_totalCost.textColor = [UIColor  redColor];
            totalStr = @"摇一摇可以机选一注";
        }
        else
        {
            [alreaderLabel setHidden:YES];
            alreaderLabel.frame = CGRectMake(5,7,35,21);
//            alreaderLabel.frame = CGRectMake(0, 0, 0, 0);
            m_totalCost.textColor = [UIColor  blackColor];
            m_totalCost.frame = CGRectMake(5,7,132,21);
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
            
            else if(ballView == m_blueDanBallViewDrag)
            {
 
                [self blueDanBallClickChange];
            }
            else if(ballView == m_blueTuoBallViewDrag)
            {
 
                [self blueTuoBallClickChange];
            }
        }
 
        int nRedDanBalls = [[m_redDanBallViewDrag selectedBallsArray] count];
        int nRedTuoBalls = [[m_redTuoBallViewDrag selectedBallsArray] count];
        
        int nBlueDanBalls = [[m_blueDanBallViewDrag selectedBallsArray] count];
        int nBuleTuoBalls = [[m_blueTuoBallViewDrag selectedBallsArray] count];
        
        
        //注数 = ((6 - 胆码红球数量), 托码数量) * 蓝球数量
        if (nRedDanBalls >= 1 && nBlueDanBalls >= 1) 
        {
            m_numZhu = RYCChoose((5 - nRedDanBalls), nRedTuoBalls) * RYCChoose(1, nBuleTuoBalls);
        }
        else
            m_numZhu = 0;
 
        if ([[m_redDanBallViewDrag selectedBallsArray] count] + [[m_redTuoBallViewDrag selectedBallsArray] count] < 6 ||
            
            [[m_blueDanBallViewDrag selectedBallsArray] count] +[[m_blueTuoBallViewDrag selectedBallsArray] count] < 3
            ) 
        {
            m_numZhu = 0;
        }
 
        m_numCost = m_numZhu * 2;   
        m_totalCost.textColor = [UIColor  blackColor];
        [alreaderLabel setHidden:YES];
        m_totalCost.frame = CGRectMake(5,7,132,21);
        totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
    }
    else if (kSegmented12Xuan2 == self.segmentedView.segmentedIndex)
    {
        int  n12X5 = [[m_12X2BallView selectedBallsArray] count];
        m_numZhu = RYCChoose(2, n12X5);
        m_numCost = m_numZhu * 2;
        
        if (m_numZhu == 0) {
            [alreaderLabel setHidden:NO];
            m_totalCost.textColor = [UIColor  redColor];
           m_totalCost.frame = CGRectMake(45,7,132,21);
            totalStr = @"  摇一摇可以机选一注";
        }
        else
        {
            [alreaderLabel setHidden:YES];
            m_totalCost.textColor = [UIColor  blackColor];
            m_totalCost.frame = CGRectMake(5,7,132,21);
            totalStr = [NSString stringWithFormat:@"您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
        }
 
    }
 
    m_totalCost.text = totalStr;
    
    CGSize totalStrSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect frame1 = m_totalCost.frame;
    frame1.size.width = totalStrSize.width;
    m_totalCost.frame = frame1;
}
 
#pragma mark getmissDate
- (void)getMissDateOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].netMissDate];
    [jsonParser release];
    
//    if(kSegmentedDirect == self.segmented.selectedSegmentIndex)
//    {
    [m_yiLouRedBallViewDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"qian"] rowNumber:9];
    [m_yiLouBlueBallViewDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"hou"] rowNumber:9];
    
    [m_12X2BallView creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"hou"] rowNumber:9];
//    }
}

#pragma mark 多注投
- (IBAction)addBasketClick:(id)sender
{
    if(m_numZhu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一注进行添加！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    if (self.segmentedView.segmentedIndex == kSegmentedDrag) {
        if ([[m_redDanBallViewDrag selectedBallsArray] count] + [[m_redTuoBallViewDrag selectedBallsArray] count] < 6) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"前区胆码和拖码之和至少为6个！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if ([[m_blueDanBallViewDrag selectedBallsArray] count] + [[m_blueTuoBallViewDrag selectedBallsArray] count] < 3) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"后区胆码和拖码之和至少为3个！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    if(self.segmentedView.segmentedIndex == kSegmentedDirect || self.segmentedView.segmentedIndex == kSegmentedDrag)
    {
        if(![RuYiCaiLotDetail sharedObject].isDLTOr11X2)//大乐透
        {
            self.basketNum.text = @"0";
            m_allZhuShu = 0;
            [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
            [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
        }
        else
            [RuYiCaiLotDetail sharedObject].isDLTOr11X2 = YES;
    }
    else
    {
        if([RuYiCaiLotDetail sharedObject].isDLTOr11X2)//大乐透
        {
            self.basketNum.text = @"0";
            m_allZhuShu = 0;
            [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
            [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
        }
        else
            [RuYiCaiLotDetail sharedObject].isDLTOr11X2 = NO;
    }
    m_allZhuShu = m_allZhuShu + m_numZhu;
    
    if(m_allZhuShu  > 10000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"投注注数不超过10000注！" withTitle:@"提示" buttonTitle:@"确定"];
        m_allZhuShu = m_allZhuShu - m_numZhu;
        
        return;
    }
    
//    if(self.segmentedView.segmentedIndex == kSegmentedDirect || self.segmentedView.segmentedIndex == kSegmented12Xuan2)
//    {
        self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + 1)];
        
        isMoreBet = YES;
        [self submitLotNotification:nil];
    [self clearAllPickBall];
    

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
 
}

- (IBAction)basketButtonClick:(id)sender
{
    if(m_allZhuShu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"号码篮为空，请添加注码" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoDLT;
    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"大乐透";
    [self.navigationController pushViewController:viewController animated:YES];
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
        if(numView == m_randomNumView_red) //判断消息的发送者
        {
            [m_redBallViewDirect randomBall:numValue];
        }
        else if(numView == m_randomNumView_blue)
        {
            [m_blueBallViewDirect randomBall:numValue];
        }
        
        
        
        
        else if(numView == m_randomNumView_redDan)
        {
            [m_redDanBallViewDrag randomBall:numValue];
            [self redDanBallClickChange];
                       
        }
        else if(numView == m_randomNumView_redTuo)
        {
            [m_redTuoBallViewDrag randomBall:numValue];
            [self redTuoBallClickChange];
        }
        else if(numView == m_randomNumView_blueDan)
        {
            [m_blueDanBallViewDrag randomBall:numValue];
            [self blueDanBallClickChange];
        }
        else if(numView == m_randomNumView_blueTuo)
        {
            [m_blueTuoBallViewDrag randomBall:numValue];
            [self blueTuoBallClickChange];
        }
 
        
        else if(numView == m_randomNumView_yiLou_red)
        {
            [m_yiLouRedBallViewDirect randomBall:numValue];
        }
        else if(numView == m_randomNumView_yiLou_blue)
        {
            [m_yiLouBlueBallViewDirect randomBall:numValue];
        }
    }
    [self updateBallState:nil];
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
	viewController.navigationItem.title = @"大乐透投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark scrollView delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset 
{
    if(scrollView == self.scrollDirect)
    {
//        m_recordPickPageImag.hidden = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        if(scrollView == self.scrollDirect)
        {
            CGPoint offsetofScrollView = scrollView.contentOffset; 
            NSLog(@"%f  %f", offsetofScrollView.x, offsetofScrollView.y);
            
            NSInteger page = offsetofScrollView.x / self.scrollDirect.frame.size.width;
            
            CGRect rect = CGRectMake(page * self.scrollDirect.frame.size.width, offsetofScrollView.y,   
                                     self.scrollDirect.frame.size.width, self.scrollDirect.frame.size.height);  
            [UIView setAnimationDuration:0.3f];
            [self.scrollDirect scrollRectToVisible:rect animated:YES]; 
            
////            m_recordPickPageImag.hidden = NO;
//            if(0 == page)
//            {
////                m_recordPickPageImag.frame = CGRectMake(260, self.bottomScrollView.frame.origin.y - 20, 60, 20);
////                m_recordPickPageImag.image = RYCImageNamed(@"ylz_biao.png");
//            }
//            else
//            {
//                m_recordPickPageImag.frame = CGRectMake(0, self.bottomScrollView.frame.origin.y - 20,  60, 20);
//                m_recordPickPageImag.image = RYCImageNamed(@"pttz_biao.png");
//            }
            [self updateBallState:nil];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  //戛然而止
{  
    if(scrollView == self.scrollDirect)
    {
        CGPoint offsetofScrollView = scrollView.contentOffset; 
        NSLog(@"%f  %f", offsetofScrollView.x, offsetofScrollView.y);
        
        NSInteger page = offsetofScrollView.x / self.scrollDirect.frame.size.width;
        
        CGRect rect = CGRectMake(page * self.scrollDirect.frame.size.width, offsetofScrollView.y,   
                                 self.scrollDirect.frame.size.width, self.scrollDirect.frame.size.height);
        
        [UIView setAnimationDuration:0.3f];
        [self.scrollDirect scrollRectToVisible:rect animated:YES]; 
        
//        m_recordPickPageImag.hidden = NO;
//        if(0 == page)
//        {
//            m_recordPickPageImag.frame = CGRectMake(260, self.bottomScrollView.frame.origin.y - 20, 60, 20);
//            m_recordPickPageImag.image = RYCImageNamed(@"ylz_biao.png");
//        }
//        else
//        {
//            m_recordPickPageImag.frame = CGRectMake(0, self.bottomScrollView.frame.origin.y - 20,  60, 20);
//            m_recordPickPageImag.image = RYCImageNamed(@"pttz_biao.png");
//        }
        
        [self updateBallState:nil];
    }
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
    viewController.lotNo = kLotNoDLT;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
//    HistoryLotteryViewController* viewController = [[HistoryLotteryViewController alloc] init];
//    viewController.navigationItem.title =@"大乐透开奖";
//    viewController.lotNo = kLotNoDLT;
//    viewController.lotTitle = kLotTitleDLT;
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleDLT;
    viewController.lotNo = kLotNoDLT;
    viewController.VRednumber = 35;
    viewController.VBluenumber = 12;
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
    viewController.lotTitle = kLotTitleDLT;
    viewController.lotNo = kLotNoDLT;
    viewController.VRednumber = 35;
    viewController.VBluenumber = 12;
    viewController.batchCode = self.lastBatchCode == nil ? @"": self.lastBatchCode;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController trendButtonClick];
    [viewController refreshLotteryAwardInfo];
    viewController.isGoLottery = NO;
    [viewController release];
    
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
    [pickNumberView randomPickerView:m_delegate.randomPickerView selectRowNum:1];
    
    [pickNumberView release];
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
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao && self.segmentedView.segmentedIndex != kSegmentedDrag)
    {
        
        if ((self.segmentedView.segmentedIndex == kSegmentedDirect && [m_redBallViewDirect getSelectNum] > 0) || (self.segmentedView.segmentedIndex == kSegmented12Xuan2 && [m_12X2BallView getSelectNum] > 0)) 
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
            if (kSegmentedDirect == self.segmentedView.segmentedIndex)
            {
                [m_redBallViewDirect randomBall:5];
                [m_blueBallViewDirect randomBall:2]; 
                
            }
            else if(kSegmented12Xuan2 == self.segmentedView.segmentedIndex)
            {
                [m_12X2BallView randomBall:2];
            }

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
                [m_blueBallViewDirect randomBall:2]; 
                
            }
            else if(kSegmented12Xuan2 == self.segmentedView.segmentedIndex)
            {
                [m_12X2BallView randomBall:2];
            }
            
            [self updateBallState:nil];
        }
    }
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

- (void) blueDanBallClickChange
{
    //用胆码做比较  去 拖码的数
    for(int i = 0;i < [m_blueDanBallViewDrag getSelectNum]; i++)
    {
        for(int j =0;j < [m_blueTuoBallViewDrag getSelectNum]; j++)
        {
            NSMutableArray* tuoArray = [m_blueTuoBallViewDrag selectedBallsArray];
            NSMutableArray* danArray = [m_blueDanBallViewDrag selectedBallsArray];
            if([[tuoArray objectAtIndex:j] isEqual:[danArray objectAtIndex:i]])
            {
                [m_blueTuoBallViewDrag resetStateForIndex:[[tuoArray objectAtIndex:j] intValue]-1];
                
                [tuoArray removeObjectAtIndex:j];
            }
        }
    }

}

- (void) blueTuoBallClickChange
{
    //用托马做比较  去胆码的数
    for(int i = 0;i < [m_blueTuoBallViewDrag getSelectNum]; i++)
    {
        for(int j =0;j < [m_blueDanBallViewDrag getSelectNum]; j++)
        {
            NSMutableArray* tuoArray = [m_blueTuoBallViewDrag selectedBallsArray];
            NSMutableArray* danArray = [m_blueDanBallViewDrag selectedBallsArray];
            if([[danArray objectAtIndex:j] isEqual:[tuoArray objectAtIndex:i]])
            {
                [m_blueDanBallViewDrag resetStateForIndex:[[danArray objectAtIndex:j] intValue]-1];
                
                [danArray removeObjectAtIndex:j];
            }
        }
    }
}

#pragma mark - CustomerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self segmentedChangeValue:index];
}
@end