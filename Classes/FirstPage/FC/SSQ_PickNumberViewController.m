//
//  SSQ_PickNumberViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SSQ_PickNumberViewController.h"
#import "RandomPickerViewController.h"
#import "RYCImageNamed.h"
#import "SSQRandomTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "RYCNormalBetView.h"
#import "LotteryAwardInfoViewController.h"
#import "RandomNumViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "LuckViewController.h"
#import "AnalogSeleNumViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSegmentedDirect  (0)
#define kSegmentedDrag    (1)

#define kLabelHeight      (35)
#define kLabelFontSize    (12)

#define kBackAlterTag     (55)

@interface SSQ_PickNumberViewController (internal)

- (void)newThreadRun;
- (void)setupNavigationBar;
- (void)setupBottomView;
- (void)setDetailView;
- (void)setupSubViewsOfDirectGroup;
- (void)setupSubViewsOfYiLouDirectGroup;
- (void)setupSubViewsOfDragGroup;
- (void)segmentedChangeValue;
- (void)segmentedChangeValue:(NSUInteger)index;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)updateBallState:(NSNotification*)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;
- (void)updateInformation:(NSNotification*)notification;
- (void)updateLottery:(NSNotification*)notification;//最新开奖号码

- (void)netFailed:(NSNotification*)notification;

- (void)detailViewButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;
- (void)queryBetLotButtonClick:(id)sender;
- (void)luckButtonClick:(id)sender;

- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;

- (void)getMissDateOK:(NSNotification*)notification;
- (void)refreshMissView;
 

- (IBAction)addBasketClick:(id)sender;
- (IBAction)basketButtonClick:(id)sender;
@end

@implementation SSQ_PickNumberViewController

@synthesize topStatus = m_topStatus;
@synthesize scrollDirect = m_scrollDirect;
@synthesize scrollDrag = m_scrollDrag;
@synthesize segmented = m_segmented;
@synthesize segmentedView = m_segmentedView;
@synthesize buttonBuy = m_buttonBuy;
@synthesize buttonReselect = m_buttonReselect;
@synthesize cleanButton = m_cleanButton;

@synthesize redBallViewDirect = m_redBallViewDirect;
@synthesize blueBallViewDirect = m_blueBallViewDirect;
@synthesize yiLouRedBallViewDirect = m_yiLouRedBallViewDirect;
@synthesize yiLouBlueBallViewDirect = m_yiLouBlueBallViewDirect;

@synthesize danmaBallViewDrag = m_danmaBallViewDrag;
@synthesize tuomaBallViewDrag = m_tuomaBallViewDrag;
@synthesize blueBallViewDrag = m_blueBallViewDrag;
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
    [m_detailView release];
//    [m_backButton release];

    [m_topStatus release];
	[m_scrollDirect release];
	[m_scrollDrag release];
	[m_segmented release];
    [m_segmentedView release];
    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_cleanButton release];
    [m_redBallViewDirect release];
    [m_blueBallViewDirect release];
    [m_yiLouRedBallViewDirect release];
    [m_yiLouBlueBallViewDirect release];
    [m_danmaBallViewDrag release];
    [m_tuomaBallViewDrag release];
    [m_blueBallViewDrag release];
    [m_totalCost release];
    [m_str1Label release];
    [m_str2Label release];
    
    [m_randomNumView_red release];
    [m_randomNumView_blue release];
    [m_randomNumView_yiLou_red release];
    [m_randomNumView_yiLou_blue release];

    
    [m_randomNumDanTuoView_dan release];
    [m_randomNumDanTuoView_tuo release];
    [m_randomNumDanTuoView_blue release];
    [m_addBasketButton release];
    [m_basketButton release];
    [m_basketNum release];
        
    [m_recordPickPageImag release];
    [m_bottomScrollView release];
    [alreaderLabel release];
	[super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBallState" object:nil];
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];	

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMissDateOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"randomUpdateBallState" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];

//    [m_detailButton removeFromSuperview];
//    [m_backButton removeFromSuperview];
    
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSTrace();
	[super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBallState:) name:@"updateBallState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMissDateOK:) name:@"getMissDateOK" object:nil]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(randomUpdateBallState:) name:@"randomUpdateBallState" object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
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
    
//    m_recordPickPageImag.frame = CGRectMake(260, self.bottomScrollView.frame.origin.y - 20, 60, 20);
//    m_recordPickPageImag.image = RYCImageNamed(@"ylz_biao.png");
//    [m_recordPickPageImag setHidden:YES];
    [self clearAllPickBall];//清空所选数据
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [self setupNavigationBar];
    [self setupBottomView];
    

//    [MobClick event:@"FCTC_selectPage"];
    alreaderLabel = [[UILabel alloc] init];
    alreaderLabel.textColor = [UIColor blackColor];
    alreaderLabel.text=@"已选:";
    alreaderLabel.backgroundColor = [UIColor clearColor];
    alreaderLabel.font = [UIFont systemFontOfSize:14];
    [m_bottomScrollView addSubview:alreaderLabel];

    isMoreBet = NO;
    m_allZhuShu = 0;
	
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];

    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoSSQ];

    [self newThreadRun];
    
//    [NSThread detachNewThreadSelector:@selector(newThreadRun) toTarget:self withObject:nil];
//    dispatch_queue_t newThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); 
//    dispatch_async(newThread, ^{ 
//        [self newThreadRun]; 
//    });     //没执行完就退出该页面，进入其他页面调该方法会崩溃
    
    /** old segmented 样式 现在更改为下面的自定义样式
    [self.segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
    self.segmented.selectedSegmentIndex = 0;
    [self segmentedChangeValue];
    */
    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                        andSelectImage:[NSArray arrayWithObjects:@"zixuan_click.png",@"dantuo_click.png", nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self.view addSubview:m_segmentedView];
    [self segmentedChangeValue:0];
    [self.segmentedView setHidden:YES];
    
    self.scrollDirect.frame = CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height - 200);
    self.scrollDirect.showsHorizontalScrollIndicator = NO;
    self.scrollDirect.showsVerticalScrollIndicator = NO;
    self.scrollDirect.delegate = self;
    self.scrollDirect.directionalLockEnabled = YES;
    self.scrollDirect.bounces = NO;//不超过边界
//    self.scrollDirect.scrollEnabled = NO;

    self.scrollDrag.frame = CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height - 200);
//    self.scrollDrag.bounces = NO;//不超过边界
//    self.scrollDrag.showsVerticalScrollIndicator = NO;

    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];        
}

- (void)newThreadRun
{
    //初始化直选、机选、胆拖
    [self setupSubViewsOfDirectGroup];
    [self setupSubViewsOfDragGroup];
    [self setupSubViewsOfYiLouDirectGroup];
    
    m_str1Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 120, 30)];
    m_str1Label.textAlignment = UITextAlignmentLeft;
    m_str1Label.backgroundColor = [UIColor clearColor];
    m_str1Label.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_str1Label];
    
    m_str2Label = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 100, 30)];
    m_str2Label.textAlignment = UITextAlignmentRight;
    m_str2Label.backgroundColor = [UIColor clearColor];
    m_str2Label.textColor = [UIColor redColor];
    m_str2Label.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_str2Label];  
    
    self.str1Label.text = [NSString stringWithFormat:@"%@", @"期号获取中..."];
    self.str2Label.text = @"00:00:00";
    
//    [self setDetailView];
    
//    m_recordPickPageImag = [[UIImageView alloc] initWithFrame:CGRectMake(260,self.bottomScrollView.frame.origin.y - 20,60,20)];
//    m_recordPickPageImag.image = RYCImageNamed(@"ylz_biao.png");
//    [self.view addSubview:m_recordPickPageImag];
    
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoSSQ];//获取期号 
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoSSQ sellWay:@"F47104MV_X"];
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
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"双色球 %@期已截止，投注时请确认您选择的期号！" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
//        [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoSSQ];//获取期号
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
    if([[RuYiCaiNetworkManager sharedManager] getBatchCodeOfLot:kLotNoSSQ].length == 0)
    {
        self.str1Label.text = @"期号获取失败";
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
}
- (void)setupBottomView
{
    
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
 
- (void)setupSubViewsOfDirectGroup
{
    NSTrace();
    //直选：红球区
    UILabel* labelRedBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    labelRedBall.text = @"   红球区（至少选择6个）";
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
    [m_redBallViewDirect createBallArray:33 withPerLine:9 startValue:1 selectBallCount:6];
	[m_redBallViewDirect setBallType:RED_BALL];
	[m_redBallViewDirect setSelectMaxNum:16];
    [m_redBallViewDirect setLViewFrame:LEFT_FRAME];
	m_redBallViewDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:self.redBallViewDirect.view];
    
    m_randomNumView_red = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    [m_randomNumView_red createNumBallList:11 withPerLine:8 startValue:6 withFrame:CGRectMake(0, 0, 320, kLabelHeight + frameRedBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDirect addSubview:m_randomNumView_red];
    
    //直选：篮球区
    UILabel* labelBlueBall = [[UILabel alloc] initWithFrame:CGRectMake(0,   frameRedBall.origin.y + frameRedBall.size.height,    320,  kLabelHeight)];
    labelBlueBall.text = @"   蓝球区（至少选择1个）";
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
    [m_blueBallViewDirect createBallArray:16 withPerLine:9 startValue:1 selectBallCount:1];
	[m_blueBallViewDirect setBallType:BLUE_BALL];
	[m_blueBallViewDirect setSelectMaxNum:16];
    [m_blueBallViewDirect setLViewFrame:LEFT_FRAME];

	self.blueBallViewDirect.view.frame = frameBlueBall;
	[self.scrollDirect addSubview:self.blueBallViewDirect.view];
    
    m_randomNumView_blue = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_blue createNumBallList:16 withPerLine:8 startValue:1 withFrame:CGRectMake(0, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight + frameBlueBall.size.height) andBallType:RANDOM_BLUE_BALL];
    [self.scrollDirect addSubview:m_randomNumView_blue];
    
    self.scrollDirect.contentSize = CGSizeMake(0, frameBlueBall.origin.y + frameBlueBall.size.height);
    self.scrollDirect.scrollEnabled = YES;
}

- (void)setupSubViewsOfYiLouDirectGroup//遗漏
{
    //直选：红球区
    UILabel* labelRedBall = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 320, kLabelHeight)];
    labelRedBall.text = @"   红球区（至少选择6个）";
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
    self.yiLouRedBallViewDirect.isHasYiLuo = YES;
    [m_yiLouRedBallViewDirect createBallArray:33 withPerLine:9 startValue:1 selectBallCount:6];
	[m_yiLouRedBallViewDirect setBallType:RED_BALL];
	//[m_yiLouRedBallViewDirect setSelectMaxNum:20];
    [m_yiLouRedBallViewDirect setSelectMaxNum:16];
    [m_yiLouRedBallViewDirect setLViewFrame:LEFT_FRAME];
	m_yiLouRedBallViewDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:self.yiLouRedBallViewDirect.view];
    
    m_randomNumView_yiLou_red = [[RandomNumViewController alloc] initWithFrame:CGRectMake(320, 0, 320, kLabelHeight)];
    [m_randomNumView_yiLou_red createNumBallList:11 withPerLine:8 startValue:6 withFrame:CGRectMake(320, 0, 320, kLabelHeight+frameRedBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDirect addSubview:m_randomNumView_yiLou_red];

    //直选：篮球区
    UILabel* labelBlueBall = [[UILabel alloc] initWithFrame:CGRectMake(320, 
                                                                       frameRedBall.origin.y + (kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*4, 
                                                                       320, 
                                                                       kLabelHeight)];
    labelBlueBall.text = @"   蓝球区（至少选择1个）";
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
    self.yiLouBlueBallViewDirect.isHasYiLuo = YES;
    [m_yiLouBlueBallViewDirect createBallArray:16 withPerLine:9 startValue:1 selectBallCount:1];
	[m_yiLouBlueBallViewDirect setBallType:BLUE_BALL];
	[m_yiLouBlueBallViewDirect setSelectMaxNum:16];
    [m_yiLouBlueBallViewDirect setLViewFrame:LEFT_FRAME];
	self.yiLouBlueBallViewDirect.view.frame = frameBlueBall;
	[self.scrollDirect addSubview:self.yiLouBlueBallViewDirect.view];
    
    m_randomNumView_yiLou_blue= [[RandomNumViewController alloc] initWithFrame:CGRectMake(320, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight)];
    [m_randomNumView_yiLou_blue createNumBallList:16 withPerLine:8 startValue:1 withFrame:CGRectMake(320, frameRedBall.origin.y + frameRedBall.size.height, 320, kLabelHeight + frameBlueBall.size.height) andBallType:RANDOM_BLUE_BALL];
    [self.scrollDirect addSubview:m_randomNumView_yiLou_blue];
    
    self.scrollDirect.contentSize = CGSizeMake(0, frameBlueBall.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2);
    self.scrollDirect.scrollEnabled = YES;
}

- (void)setupSubViewsOfDragGroup;
{    
    //胆拖：胆码区
    UILabel* labelDanmaBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    labelDanmaBall.text = @"   胆码区（至少选择1个）：";
    labelDanmaBall.textAlignment = UITextAlignmentLeft;
    labelDanmaBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelDanmaBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelDanmaBall];
    [labelDanmaBall release];
    
    CGRect frameDanmaBall = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight + kBallLineSpacing, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing) * 4);
    m_danmaBallViewDrag = [[PickBallViewController alloc] init];
    [m_danmaBallViewDrag createBallArray:33 withPerLine:9 startValue:1 selectBallCount:1];
	[self.danmaBallViewDrag setBallType:RED_BALL];
	[self.danmaBallViewDrag setSelectMaxNum:5];
    [m_danmaBallViewDrag setLViewFrame:LEFT_FRAME];
	self.danmaBallViewDrag.view.frame = frameDanmaBall;
	[self.scrollDrag addSubview:self.danmaBallViewDrag.view];
  
    m_randomNumDanTuoView_dan = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, 0, 320, kLabelHeight)];
    [m_randomNumDanTuoView_dan createNumBallList:5 withPerLine:8 startValue:1 withFrame:CGRectMake(0, 0, 320, kLabelHeight+frameDanmaBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDrag addSubview:m_randomNumDanTuoView_dan];

    //胆拖：拖码区
    UILabel* labelTuomaBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                                        frameDanmaBall.origin.y + frameDanmaBall.size.height, 
                                                                        320, 
                                                                        kLabelHeight)];
    labelTuomaBall.text = @"   拖码区（至少选择2个）：";
    labelTuomaBall.textAlignment = UITextAlignmentLeft;
    labelTuomaBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelTuomaBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelTuomaBall];
    [labelTuomaBall release];
    
    CGRect frameTuomaBall = CGRectMake(frameDanmaBall.origin.x, 
                                      frameDanmaBall.origin.y + frameDanmaBall.size.height + kLabelHeight + kBallLineSpacing, 
                                      frameDanmaBall.size.width, 
                                      (kBallRectHeight + kBallLineSpacing) * 4);
    m_tuomaBallViewDrag = [[PickBallViewController alloc] init];
    [m_tuomaBallViewDrag createBallArray:33 withPerLine:9 startValue:1 selectBallCount:1];
	[self.tuomaBallViewDrag setBallType:RED_BALL];
	[self.tuomaBallViewDrag setSelectMaxNum:16];
	self.tuomaBallViewDrag.view.frame = frameTuomaBall;
    [m_tuomaBallViewDrag setLViewFrame:LEFT_FRAME];
	[self.scrollDrag addSubview:self.tuomaBallViewDrag.view];
    
    m_randomNumDanTuoView_tuo = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameDanmaBall.origin.y + frameDanmaBall.size.height, 320, kLabelHeight)];
    [m_randomNumDanTuoView_tuo createNumBallList:15 withPerLine:8 startValue:2 withFrame:CGRectMake(0, frameDanmaBall.origin.y + frameDanmaBall.size.height, 320, kLabelHeight + frameTuomaBall.size.height) andBallType:RANDOM_RED_BALL];
    [self.scrollDrag addSubview:m_randomNumDanTuoView_tuo];
    
    //胆拖：蓝球区
    UILabel* labelBlueBall = [[UILabel alloc] initWithFrame:CGRectMake(0, 
                                                                       frameTuomaBall.origin.y + frameTuomaBall.size.height, 
                                                                       320, 
                                                                       kLabelHeight)];
    labelBlueBall.text = @"蓝球区（至少选择1个）：";
    labelBlueBall.textAlignment = UITextAlignmentLeft;
    labelBlueBall.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:235.0/255.0];
    labelBlueBall.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:labelBlueBall];
    [labelBlueBall release];
    
    CGRect frameBlueBall = CGRectMake(frameDanmaBall.origin.x, 
                                      labelBlueBall.frame.origin.y + kLabelHeight + kBallLineSpacing, 
                                      frameDanmaBall.size.width, 
                                      (kBallRectHeight + kBallLineSpacing) * 2);
    m_blueBallViewDrag = [[PickBallViewController alloc] init];
    [m_blueBallViewDrag createBallArray:16 withPerLine:9 startValue:1 selectBallCount:1];
	[self.blueBallViewDrag setBallType:BLUE_BALL];
	[self.blueBallViewDrag setSelectMaxNum:16];
	self.blueBallViewDrag.view.frame = frameBlueBall;
    [m_blueBallViewDrag setLViewFrame:LEFT_FRAME];
	[self.scrollDrag addSubview:self.blueBallViewDrag.view];
    
    m_randomNumDanTuoView_blue = [[RandomNumViewController alloc] initWithFrame:CGRectMake(0, frameTuomaBall.origin.y + frameTuomaBall.size.height, 320, kLabelHeight)];
    [m_randomNumDanTuoView_blue createNumBallList:16 withPerLine:8 startValue:1 withFrame:CGRectMake(0, frameTuomaBall.origin.y + frameTuomaBall.size.height, 320, kLabelHeight + frameBlueBall.size.height) andBallType:RANDOM_BLUE_BALL];
    [self.scrollDrag addSubview:m_randomNumDanTuoView_blue];
    
    
    self.scrollDrag.contentSize = CGSizeMake(320, frameBlueBall.origin.y + frameBlueBall.size.height);
    self.scrollDrag.scrollEnabled = YES; 
}

- (void)updateBallState:(NSNotification *)notification
{
    m_detailView.hidden = YES;
    
    NSTrace();
    NSString* totalStr = @"";
    m_numZhu = 0;
    m_numCost = 0;
    
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        CGPoint offsetofScrollView = self.scrollDirect.contentOffset;         
        NSInteger page = (offsetofScrollView.x + 160.0) / self.scrollDirect.frame.size.width;
        if(0 == page)//普通页面
        {
            [self.yiLouRedBallViewDirect selectBallForStateArr:self.redBallViewDirect.ballState];
            [self.yiLouBlueBallViewDirect selectBallForStateArr:self.blueBallViewDirect .ballState];
        }
        else
        {
            [self.redBallViewDirect selectBallForStateArr:self.yiLouRedBallViewDirect.ballState];
            [self.blueBallViewDirect selectBallForStateArr:self.yiLouBlueBallViewDirect.ballState];
        }

        NSArray *redBalls = [self.redBallViewDirect selectedBallsArray];
        int nRedBalls = [redBalls count];
        NSArray *blueBalls = [self.blueBallViewDirect selectedBallsArray];
        int nBlueBalls = [blueBalls count];
        
        //注数 = zuhe(6,用户选中红球数量) * zuhe(1,用户选中蓝球数量)
        m_numZhu = RYCChoose(6, nRedBalls) * RYCChoose(1, nBlueBalls);
        //金额 = 注数 * 倍数 *（2元）* 期数
        m_numCost = m_numZhu * 2;
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
            m_totalCost.frame = CGRectMake(5,7,132,21);
//            alreaderLabel.frame = CGRectMake(0, 0, 0, 0);
            m_totalCost.textColor = [UIColor  blackColor];
            int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
            totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
        }

    }
    else
    {
        NSObject *obj = [notification object];
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary*)obj;
            PickBallViewController *ballView = [dict objectForKey:@"ballView"];
            int index = [[dict objectForKey:@"ballIndex"] intValue];
            
            if (ballView == self.danmaBallViewDrag)
            {
                if (YES == [self.tuomaBallViewDrag stateForIndex:index])
                    [self.tuomaBallViewDrag resetStateForIndex:index];
            }
            else if (ballView == self.tuomaBallViewDrag)
            {
                if (YES == [self.danmaBallViewDrag stateForIndex:index])
                    [self.danmaBallViewDrag resetStateForIndex:index];
            }
        }
        
        NSArray *danmaBalls = [self.danmaBallViewDrag selectedBallsArray];
        int nDanmaBalls = [danmaBalls count];
        
        NSArray *tuomaBalls = [self.tuomaBallViewDrag selectedBallsArray];
        int nTuomaBalls = [tuomaBalls count];
        NSArray *blueBalls = [self.blueBallViewDrag selectedBallsArray];
        int nBlueBalls = [blueBalls count];
        
        //注数 = ((6 - 胆码红球数量), 托码数量) * 蓝球数量
        if (nDanmaBalls >= 1 && nTuomaBalls >= 2) 
        {
            m_numZhu = RYCChoose((6 - nDanmaBalls), nTuomaBalls) * nBlueBalls;
        }
        else
            m_numZhu = 0;
 
        if ([[m_danmaBallViewDrag selectedBallsArray] count] + [[m_tuomaBallViewDrag selectedBallsArray] count] < 7) {
            m_numZhu = 0;
        }
 
        m_numCost = m_numZhu * 2;

        [alreaderLabel setHidden:YES];
        m_totalCost.frame = CGRectMake(5,7,132,21);
        self.totalCost.textColor = [UIColor blackColor];int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
        totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注,共 %d 彩豆", m_numZhu, m_numCost*aas];
    }

    self.totalCost.text = totalStr;
    CGSize totalStrSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:14]];
    
    CGRect frame1 = self.totalCost.frame;
    frame1.size.width = totalStrSize.width;
    self.totalCost.frame = frame1;
}
 

- (void)submitLotNotification:(NSNotification*)notification
{
   //显示你的订单详情，并生成投注信息
    NSString* disBetCode = @"";
    NSString* betCode = @"";
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        NSArray *redBalls;
        NSArray *blueBalls;
        int nRedCount = 0;
        int nBlueCount = 0;
        CGPoint offsetofScrollView = self.scrollDirect.contentOffset; 
        NSInteger page = offsetofScrollView.x / self.scrollDirect.frame.size.width;
        if(0 == page)
        {
            redBalls = [self.redBallViewDirect selectedBallsArray];
            blueBalls = [self.blueBallViewDirect selectedBallsArray];
            nRedCount = [redBalls count];
            nBlueCount = [blueBalls count];
        }
        else
        {
            redBalls = [self.yiLouRedBallViewDirect selectedBallsArray];
            blueBalls = [self.yiLouBlueBallViewDirect selectedBallsArray];
            nRedCount = [redBalls count];
            nBlueCount = [blueBalls count];
        }
        if (nRedCount > 6 && nBlueCount > 1)  //复式
            betCode = [betCode stringByAppendingString:@"3001*"];
        else if (nRedCount > 6)  //红复式，篮球等于1
            betCode = [betCode stringByAppendingString:@"1001*"];
        else if (nBlueCount > 1)  //蓝复式
            betCode = [betCode stringByAppendingString:@"2001*"];
        else  //单式
            betCode = [betCode stringByAppendingString:@"0001"];
        
        for (int i = 0; i < nRedCount; i++)
        {
            int nValue = [[redBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            
            if (i == (nRedCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"~"];
        disBetCode = [disBetCode stringByAppendingFormat:@"|"];
        
        for (int i = 0; i < nBlueCount; i++)
        {
            int nValue = [[blueBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            if (i == (nBlueCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"^"];
		
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
	}
    //添加胆拖投注注码///////// 
    else
    {
        NSArray *danBalls;
        NSArray *tuoBalls;
        NSArray *blueBalls;
        int nBlueCount = 0;
        int nDanCount = 0;
        int nTuoCount = 0;
        danBalls = [self.danmaBallViewDrag selectedBallsArray];
        tuoBalls = [self.tuomaBallViewDrag selectedBallsArray];
        blueBalls = [self.blueBallViewDrag selectedBallsArray];
        nDanCount = [danBalls count];
        nTuoCount = [tuoBalls count];
        nBlueCount = [blueBalls count];
        //红色球区胆拖且蓝色球区单式
        if (nBlueCount == 1)  //复式
            betCode = [betCode stringByAppendingString:@"4001"];
        else
            betCode = [betCode stringByAppendingString:@"5001"];
        for (int i = 0; i < nDanCount; i++)
        {
            int nValue = [[danBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            if (i == (nDanCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"*"];
        disBetCode = [disBetCode stringByAppendingFormat:@"#"];
        //托
        for (int i = 0; i < nTuoCount; i++)
        {
            int nValue = [[tuoBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            if (i == (nTuoCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"~"];
        disBetCode = [disBetCode stringByAppendingFormat:@"|"];
        
        //蓝
        for (int i = 0; i < nBlueCount; i++)
        {
            int nValue = [[blueBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            if (i == (nBlueCount - 1))
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            else
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
        betCode = [betCode stringByAppendingFormat:@"^"];
    
        [RuYiCaiLotDetail sharedObject].sellWay = @"0";
    
    }
 
    
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;

    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSQ;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
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

        [self.redBallViewDirect clearBallState];
        [self.blueBallViewDirect clearBallState];

        [self.yiLouRedBallViewDirect clearBallState];
        [self.yiLouBlueBallViewDirect clearBallState];
	}
    else
    {
        [self.danmaBallViewDrag clearBallState];
        [self.tuomaBallViewDrag clearBallState];
        [self.blueBallViewDrag clearBallState];
    }
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [self.redBallViewDirect clearBallState];
    [self.blueBallViewDirect clearBallState];
    [self.yiLouRedBallViewDirect clearBallState];
    [self.yiLouBlueBallViewDirect clearBallState];
    [self.danmaBallViewDrag clearBallState];
    [self.tuomaBallViewDrag clearBallState];
    [self.blueBallViewDrag  clearBallState];
    
    [self updateBallState:nil];
}

- (void)segmentedChangeValue
{
	if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = NO;
        self.scrollDrag.hidden = YES;
//        m_recordPickPageImag.hidden = NO;
	}
    
    else
    {
		self.scrollDirect.hidden = YES;
        self.scrollDrag.hidden = NO;
//        m_recordPickPageImag.hidden = YES;
    }
    [self updateBallState:nil];
}

- (void)segmentedChangeValue:(NSUInteger)index
{
	if (kSegmentedDirect == index)
    {
		self.scrollDirect.hidden = NO;
        self.scrollDrag.hidden = YES;
//        m_recordPickPageImag.hidden = NO;
	}
    
    else
    {
		self.scrollDirect.hidden = YES;
        self.scrollDrag.hidden = NO;
//        m_recordPickPageImag.hidden = YES;
    }
    [self updateBallState:nil];
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
    NSString* blueStr = [winNo substringWithRange:NSMakeRange(winNo.length - 2, 2)];
    
    for(int i = 0; i < 6; i++)
    {
        redStr = [redStr stringByAppendingFormat:@"%@,", [winNo substringWithRange:NSMakeRange(i * 2, 2)]];
    }
    CGSize winRedSize = [redStr sizeWithFont:[UIFont systemFontOfSize:kLabelFontSize]];
    
    UILabel* winRedNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, winRedSize.width, 30)];
    winRedNumLabel.text = redStr;
    winRedNumLabel.textColor = [UIColor redColor];
    winRedNumLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    winRedNumLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:winRedNumLabel];
    [winRedNumLabel release];

    UILabel* winBlueNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 + winRedSize.width, 0, 20, 30)];
    winBlueNumLabel.text = blueStr;
    winBlueNumLabel.textColor = [UIColor blueColor];
    winBlueNumLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    winBlueNumLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:winBlueNumLabel];
    [winBlueNumLabel release];
    
    [self setDetailView];
//    [m_detailView.superview bringSubviewToFront:m_detailView];
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
        if ([[m_danmaBallViewDrag selectedBallsArray] count] + [[m_tuomaBallViewDrag selectedBallsArray] count] < 7) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"胆码和拖码之和至少为7个！" withTitle:@"提示" buttonTitle:@"确定"];
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
 
    self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + 1)];
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
}

- (IBAction)basketButtonClick:(id)sender
{
    if (m_allZhuShu == 0) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"号码篮为空，请添加注码" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSQ;
    [self setHidesBottomBarWhenPushed:YES];
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"双色球";
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
            [self.redBallViewDirect randomBall:numValue];
        }
        else if(numView == m_randomNumView_blue)
        {
            [self.blueBallViewDirect randomBall:numValue];
        }
        else if(numView == m_randomNumView_yiLou_red)
        {
            [self.yiLouRedBallViewDirect randomBall:numValue];
        }
        else if(numView == m_randomNumView_yiLou_blue)
        {
            [self.yiLouBlueBallViewDirect randomBall:numValue];
        }
        
        
        else if(numView == m_randomNumDanTuoView_dan)
        {
            [self.danmaBallViewDrag randomBall:numValue];
            
            //用胆码做比较  去 拖码的数
            for(int i = 0;i < [m_danmaBallViewDrag getSelectNum]; i++)
            {
                for(int j =0;j < [m_tuomaBallViewDrag getSelectNum]; j++)
                {
                    NSMutableArray* tuoArray = [m_tuomaBallViewDrag selectedBallsArray];
                    NSMutableArray* danArray = [m_danmaBallViewDrag selectedBallsArray];
                    if([[tuoArray objectAtIndex:j] isEqual:[danArray objectAtIndex:i]])
                    {
                        [self.tuomaBallViewDrag resetStateForIndex:[[tuoArray objectAtIndex:j] intValue]-1];
 
                        [tuoArray removeObjectAtIndex:j];
                    }
                }
            }
        }
 
        else if(numView == m_randomNumDanTuoView_tuo)
        {
            [self.tuomaBallViewDrag randomBall:numValue];
            
            //用托马做比较  去胆码的数
            for(int i = 0;i < [m_tuomaBallViewDrag getSelectNum]; i++)
            {
                for(int j =0;j < [m_danmaBallViewDrag getSelectNum]; j++)
                {
                    NSMutableArray* tuoArray = [m_tuomaBallViewDrag selectedBallsArray];
                    NSMutableArray* danArray = [m_danmaBallViewDrag selectedBallsArray];
                    if([[danArray objectAtIndex:j] isEqual:[tuoArray objectAtIndex:i]])
                    {
                        [self.danmaBallViewDrag resetStateForIndex:[[danArray objectAtIndex:j] intValue]-1];
                        
                        [danArray removeObjectAtIndex:j];
                    }
                }
            }
        }
        else if(numView == m_randomNumDanTuoView_blue)
        {
            [self.blueBallViewDrag randomBall:numValue];
        }
    }
    [self updateBallState:nil];
}

#pragma  mark 遗漏值
- (void)getMissDateOK:(NSNotification*)notification
{
    [self refreshMissView];
}

- (void)refreshMissView
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].netMissDate];
    [jsonParser release];
    
    if(kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        [self.yiLouRedBallViewDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"red"] rowNumber:9];
        [self.yiLouBlueBallViewDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"blue"] rowNumber:9];
    }
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
	viewController.navigationItem.title = @"双色球投注";
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
    viewController.lotNo = kLotNoSSQ;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
        
//    HistoryLotteryViewController* viewController = [[HistoryLotteryViewController alloc] init];
//    viewController.navigationItem.title =@"双色球开奖";
//    viewController.lotNo = kLotNoSSQ;
//    viewController.lotTitle = kLotTitleSSQ;
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
     LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleSSQ;
    viewController.lotNo = kLotNoSSQ;
    viewController.VRednumber = 33;//红球个数
    viewController.VBluenumber = 16;//篮球个数
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
    viewController.lotTitle = kLotTitleSSQ;
    viewController.lotNo = kLotNoSSQ;
    viewController.VRednumber = 33;//红球个数
    viewController.VBluenumber = 16;//篮球个数
    viewController.batchCode = self.lastBatchCode == nil ? @"": self.lastBatchCode;

    [self.navigationController pushViewController:viewController animated:YES];
    [viewController trendButtonClick];
    [viewController refreshLotteryAwardInfo];
    viewController.isGoLottery = NO;
    [viewController release];
}

- (void)AnalogNumButtonClick:(id)sender
{
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
    
    [self setHidesBottomBarWhenPushed:YES];
    
    AnalogSeleNumViewController* viewController = [[AnalogSeleNumViewController alloc] init];
    viewController.navigationItem.title =@"双色球模拟选号";
    viewController.lotNo = kLotNoSSQ;
    viewController.sellWay = @"F47104MV_X";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark   右上角 下拉按钮
- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoSSQ;
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
    [pickNumberView randomPickerView:m_delegate.randomPickerView selectRowNum:0];
    
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
    [viewController setSelectLotNo:kLotNoSSQ];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}
 
#pragma mark scrollView
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
            
            NSInteger page = (offsetofScrollView.x) / self.scrollDirect.frame.size.width;
            
            CGRect rect = CGRectMake(page * self.scrollDirect.frame.size.width, offsetofScrollView.y,   
                                     self.scrollDirect.frame.size.width, self.scrollDirect.frame.size.height);  
            [UIView setAnimationDuration:0.3f];
            [self.scrollDirect scrollRectToVisible:rect animated:YES]; 
            
//            m_recordPickPageImag.hidden = NO;
            

            
//            if(0 == page)
//            {
//                m_recordPickPageImag.frame = CGRectMake(260, self.bottomScrollView.frame.origin.y - 20, 60, 20);
//                m_recordPickPageImag.image = RYCImageNamed(@"ylz_biao.png");
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
        
        NSInteger page = (offsetofScrollView.x) / self.scrollDirect.frame.size.width;
        
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
//            m_recordPickPageImag.frame = CGRectMake(0, self.bottomScrollView.frame.origin.y - 20, 60, 20);
//            m_recordPickPageImag.image = RYCImageNamed(@"pttz_biao.png");
//        }

        [self updateBallState:nil];
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
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao && self.segmentedView.segmentedIndex != kSegmentedDrag)
    {
        CGPoint offsetofScrollView = self.scrollDirect.contentOffset;         
        NSInteger page = (offsetofScrollView.x + 160.0) / self.scrollDirect.frame.size.width;
        
        if ([self.redBallViewDirect getSelectNum] > 0 || 
            [self.blueBallViewDirect getSelectNum] > 0 || 
            
            [self.yiLouRedBallViewDirect getSelectNum] || 
            [self.yiLouBlueBallViewDirect getSelectNum]) 
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
            if(0 == page)//普通页面
            {
                [self.redBallViewDirect randomBall:6];
                [self.blueBallViewDirect randomBall:1];
            }
            else
            {
                [self.yiLouRedBallViewDirect randomBall:6];
                [self.yiLouBlueBallViewDirect randomBall:1];
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
            CGPoint offsetofScrollView = self.scrollDirect.contentOffset;         
            NSInteger page = (offsetofScrollView.x + 160.0) / self.scrollDirect.frame.size.width;
            if(0 == page)//普通页面
            {
                [self.redBallViewDirect randomBall:6];
                [self.blueBallViewDirect randomBall:1];
            }
            else
            {
                [self.yiLouRedBallViewDirect randomBall:6];
                [self.yiLouBlueBallViewDirect randomBall:1];
            }
            
            [self updateBallState:nil];
            
        }
    }
}
#pragma mark -CustomSegmentedControlDelegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"customer segmented  %d",index);
    [self segmentedChangeValue:index];
}

@end
