//
//  QXC_PickNumberViewController.m
//  RuYiCai
//
//  Created by haojie on 11-12-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QXC_PickNumberViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "FC3DRandomTableViewCell.h"
#import "RYCNormalBetView.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h" 
#import "LotteryAwardInfoViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSegmentedDirect  (0)
#define kSegmentedRandom  (1)

#define kLabelHeight      (20)
#define kLabelFontSize    (12)

#define kBackAlterTag     (55)

@interface QXC_PickNumberViewController (internal)

- (void)newThreadRun;
- (void)setupNavigationBar;
- (void)setupSubViewsOfDirect;

- (void)setupSubViewsOfRandom;
- (void)refreshRandomTableView;
- (void)randomNumSet;

- (void)updateBallState:(NSNotification *)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)deleteRandomBallCell:(NSNotification *)notification;
- (void)betNormal:(NSNotification*)notification;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)segmentedChangeValue;
- (void)segmentedChangeValue:(int)index;
//- (void)batchCodeInformation:(NSNotification*)notification;
- (void)updateInformation:(NSNotification*)notification;

- (void)netFailed:(NSNotification*)notification;
- (void)setDetailView;
- (void)detailViewButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;
- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;

- (IBAction)addBasketClick:(id)sender;
- (IBAction)basketButtonClick:(id)sender;
@end

@implementation QXC_PickNumberViewController
@synthesize bottomScrollView = m_bottomScrollView;
@synthesize scrollDirect = m_scrollDirect;
@synthesize scrollRandom = m_scrollRandom;
@synthesize segmented = m_segmented;
@synthesize segmentedView = m_segmentedView;
@synthesize ballView1 = m_ballView1;
@synthesize ballView10 = m_ballView10;
@synthesize ballView100 = m_ballView100;
@synthesize ballView1000 = m_ballView1000;
@synthesize ballView10000 = m_ballView10000;
@synthesize ballView100000 = m_ballView100000;
@synthesize ballView1000000 = m_ballView1000000;
@synthesize tableViewRandom = m_tableViewRandom;
@synthesize buttonRandomNum = m_buttonRandomNum;
@synthesize randomDataArray = m_randomDataArray;        
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
@synthesize isHidePush    = m_isHidePush;

- (void)dealloc
{
    if([m_timer isValid])
	{
		[m_timer invalidate];
		m_timer = nil;
	}
    m_delegate.randomPickerView.delegate = nil;

//    [m_backButton release];
    [m_bottomScrollView release];
    [m_scrollDirect release];
	[m_scrollRandom release];
	[m_segmented release];
    [m_segmentedView release];
	[m_ballView1 release];
	[m_ballView10 release];
	[m_ballView100 release];
	[m_ballView1000 release];
	[m_ballView10000 release];
	[m_ballView100000 release];
	[m_ballView1000000 release];
	[m_tableViewRandom release], m_tableViewRandom = nil;
	[m_buttonRandomNum release];
	[m_randomDataArray release], m_randomDataArray = nil;
	[m_buttonBuy release];          
	[m_buttonReselect release];     
	[m_totalCost release];          
	[m_batchCode release];
	[m_batchEndTime release];
    [m_str1Label release];
    [m_str2Label release];

    [m_addBasketButton release];
    [m_basketButton release];
    [m_basketNum release];
    
    [m_detailView release];
    [alreaderLabel release];
    [super dealloc];	
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBallState" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteRandomBallCell" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];	

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];	
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRandomBallCell:) name:@"deleteRandomBallCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
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
    
    [self clearAllPickBall];//清空所选数据
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
//    [MobClick event:@"FCTC_selectPage"];
    
    alreaderLabel = [[UILabel alloc] init];
    alreaderLabel.textColor = [UIColor blackColor];
    alreaderLabel.text=@"已选:";
    alreaderLabel.backgroundColor = [UIColor clearColor];
    alreaderLabel.font = [UIFont systemFontOfSize:14];
    [m_bottomScrollView addSubview:alreaderLabel];
    
    [self setupNavigationBar];
    
    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:
                           [NSArray arrayWithObjects:@"zixuan_normal.png",@"jixuan_normal.png", nil]
                                                  andHighlightedImages:
                           [NSArray arrayWithObjects:@"zixuan_normal.png",@"jixuan_normal.png", nil]
                                                        andSelectImage:
                           [NSArray arrayWithObjects:@"zixuan_click.png",@"jixuan_click.png", nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self.view addSubview:m_segmentedView];
    [self segmentedChangeValue:0];
    
    isMoreBet = NO;
    m_allZhuShu = 0;
    
    self.scrollDirect.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);
    self.scrollRandom.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);
    
	m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
	 
    [self newThreadRun];
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoQXC];
	
    [self.segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
    self.segmented.selectedSegmentIndex = 0;
    [self segmentedChangeValue];
    
    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];    

}

- (void)newThreadRun
{    
	[self setupSubViewsOfDirect];
	[self setupSubViewsOfRandom];

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
//    self.str2Label.text = [NSString stringWithFormat:@"%@", @"剩余时间获取中..."];
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoQXC];//获取期号
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
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"七星彩 %@期时间已截止，投注时请确认您选择的期号！" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
//        [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoQXC];//获取期号

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
    for(int i = 0; i < 7; i++)
    {
        if(i != 6)
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

#pragma mark   右上角 下拉按钮
- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoQXC;
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
    [viewController setSelectLotNo:kLotNoQXC];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
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

- (void)setupSubViewsOfDirect
{
    //直选
	UILabel *label1000000  = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, kLabelHeight)];
	label1000000.text = @"第一位（至少选择1个）：";
	label1000000.textAlignment = UITextAlignmentLeft;
	label1000000.backgroundColor = [UIColor clearColor];
	label1000000.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDirect addSubview:label1000000];
	[label1000000 release];
	
	CGRect frameBall1000000 = CGRectMake((320 - (9 * kBallVerticalSpacing) - 10 * kSmallBallRectWidth) / 2, 
									   kLabelHeight, 
									   10 * (kSmallBallRectWidth + kBallVerticalSpacing), 
									   (kSmallBallRectHeight + kBallLineSpacing));
	m_ballView1000000 = [[PickBallViewController alloc] init];
    [m_ballView1000000 setBallSize:1];
	[m_ballView1000000 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView1000000 setBallType:RED_BALL];
	[m_ballView1000000 setSelectMaxNum:5];
	m_ballView1000000.view.frame = frameBall1000000;
	[self.scrollDirect addSubview:m_ballView1000000.view];
	
	UILabel *label100000  = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall1000000.origin.y+frameBall1000000.size.height, 310, kLabelHeight)];
	label100000.text = @"第二位（至少选择1个）：";
	label100000.textAlignment = UITextAlignmentLeft;
	label100000.backgroundColor = [UIColor clearColor];
	label100000.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDirect addSubview:label100000];
	[label100000 release];
    
	CGRect frameBall100000 = CGRectMake(frameBall1000000.origin.x, 
									  frameBall1000000.origin.y+frameBall1000000.size.height + kLabelHeight, 
                                        frameBall1000000.size.width, 
                                        frameBall1000000.size.height);
	m_ballView100000 = [[PickBallViewController alloc] init];
    [m_ballView100000 setBallSize:1];
	[m_ballView100000 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView100000 setBallType:RED_BALL];
	[m_ballView100000 setSelectMaxNum:5];
	m_ballView100000.view.frame = frameBall100000;
	[self.scrollDirect addSubview:m_ballView100000.view];
	
	UILabel *label10000  = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall100000.origin.y+frameBall100000.size.height, 310, kLabelHeight)];
	label10000.text = @"第三位（至少选择1个）：";
	label10000.textAlignment = UITextAlignmentLeft;
	label10000.backgroundColor = [UIColor clearColor];
	label10000.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDirect addSubview:label10000];
	[label10000 release];
    
	CGRect frameBall10000 = CGRectMake(frameBall1000000.origin.x, 
									 frameBall100000.origin.y+frameBall100000.size.height + kLabelHeight, 
                                       frameBall1000000.size.width, 
                                       frameBall1000000.size.height);
	m_ballView10000 = [[PickBallViewController alloc] init];
    [m_ballView10000 setBallSize:1];
	[m_ballView10000 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView10000 setBallType:RED_BALL];
	[m_ballView10000 setSelectMaxNum:5];
	m_ballView10000.view.frame = frameBall10000;
	[self.scrollDirect addSubview:m_ballView10000.view];
	
	
    UILabel *label1000  = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall10000.origin.y+frameBall10000.size.height, 310, kLabelHeight)];
	label1000.text = @"第四位（至少选择1个）：";
	label1000.textAlignment = UITextAlignmentLeft;
	label1000.backgroundColor = [UIColor clearColor];
	label1000.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDirect addSubview:label1000];
	[label1000 release];
    
	CGRect frameBall1000 = CGRectMake(frameBall1000000.origin.x, 
									frameBall10000.origin.y+frameBall10000.size.height + kLabelHeight, 
                                      frameBall1000000.size.width, 
                                      frameBall1000000.size.height);
	m_ballView1000 = [[PickBallViewController alloc] init];
    [m_ballView1000 setBallSize:1];
	[m_ballView1000 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView1000 setBallType:RED_BALL];
	[m_ballView1000 setSelectMaxNum:5];
	m_ballView1000.view.frame = frameBall1000;
	[self.scrollDirect addSubview:m_ballView1000.view];
	
	UILabel *label100 = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall1000.origin.y+frameBall1000.size.height, 310, kLabelHeight)];
	label100.text = @"第五位（至少选择1个）：";
	label100.textAlignment = UITextAlignmentLeft;
	label100.backgroundColor = [UIColor clearColor];
	label100.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDirect addSubview:label100];
	[label100 release];
    
	CGRect frameBall100 = CGRectMake(frameBall1000000.origin.x, 
								  frameBall1000.origin.y+frameBall1000.size.height + kLabelHeight, 
                                     frameBall1000000.size.width, 
                                     frameBall1000000.size.height);
	m_ballView100 = [[PickBallViewController alloc] init];
    [m_ballView100 setBallSize:1];
	[m_ballView100 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView100 setBallType:RED_BALL];
	[m_ballView100 setSelectMaxNum:5];
	m_ballView100.view.frame = frameBall100;
	[self.scrollDirect addSubview:m_ballView100.view];
	
	UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall100.origin.y+frameBall100.size.height, 310, kLabelHeight)];
	label10.text = @"第六位（至少选择1个）：";
	label10.textAlignment = UITextAlignmentLeft;
	label10.backgroundColor = [UIColor clearColor];
	label10.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDirect addSubview:label10];
	[label10 release];
    
	CGRect frameBall10 = CGRectMake(frameBall1000000.origin.x, 
									 frameBall100.origin.y+frameBall100.size.height + kLabelHeight, 
                                    frameBall1000000.size.width, 
                                    frameBall1000000.size.height);
	m_ballView10 = [[PickBallViewController alloc] init];
    [m_ballView10 setBallSize:1];
	[m_ballView10 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView10 setBallType:RED_BALL];
	[m_ballView10 setSelectMaxNum:5];
	m_ballView10.view.frame = frameBall10;
	[self.scrollDirect addSubview:m_ballView10.view];
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, frameBall10.origin.y+frameBall10.size.height, 310, kLabelHeight)];
	label1.text = @"第七位（至少选择1个）：";
	label1.textAlignment = UITextAlignmentLeft;
	label1.backgroundColor = [UIColor clearColor];
	label1.font = [UIFont systemFontOfSize:kLabelFontSize];
	[self.scrollDirect addSubview:label1];
	[label1 release];
    
	CGRect frameBall = CGRectMake(frameBall1000000.origin.x, 
									frameBall10.origin.y+frameBall10.size.height + kLabelHeight, 
                                  frameBall1000000.size.width, 
                                  frameBall1000000.size.height);
	m_ballView1 = [[PickBallViewController alloc] init];
    [m_ballView1 setBallSize:1];
	[m_ballView1 createBallArray:10 withPerLine:10 startValue:0 selectBallCount:1];
	[m_ballView1 setBallType:RED_BALL];
	[m_ballView1 setSelectMaxNum:5];
	m_ballView1.view.frame = frameBall;
	[self.scrollDirect addSubview:m_ballView1.view];
	
	self.scrollDirect.contentSize = CGSizeMake(320, frameBall.origin.y + frameBall.size.height);
	self.scrollRandom.scrollEnabled = YES;
}

- (void)setupSubViewsOfRandom
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scrollRandom addSubview:mode_bg];
    [mode_bg release];
    
	//机选
	UILabel *m_zhuShu = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 30)];
	m_zhuShu.text = @"注数：";
	m_zhuShu.font = [UIFont systemFontOfSize:12];
    m_zhuShu.backgroundColor = [UIColor clearColor];
	[self.scrollRandom addSubview: m_zhuShu];
	[m_zhuShu release];
    
	m_randomDataArray = [[NSMutableArray alloc] initWithCapacity:4];
	m_randomNum = 5;
	m_buttonRandomNum = [[UIButton alloc] initWithFrame:CGRectMake(60, 10, 70, 30)];
	[m_buttonRandomNum setBackgroundImage:RYCImageNamed(@"list_normal.png") forState:UIControlStateNormal];
    [m_buttonRandomNum setBackgroundImage:RYCImageNamed(@"list_click.png") forState:UIControlStateHighlighted];
	[m_buttonRandomNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[m_buttonRandomNum setTitle:[NSString stringWithFormat:@"%d", m_randomNum] forState:UIControlStateNormal];
    [m_buttonRandomNum setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
	[m_buttonRandomNum addTarget:self action:@selector(randomNumSet) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollRandom addSubview:m_buttonRandomNum];	
	[self refreshRandomTableView];	
}

- (void)segmentedChangeValue
{
	if(kSegmentedDirect == self.segmented.selectedSegmentIndex)
	{
		self.scrollDirect.hidden = NO;
		self.scrollRandom.hidden = YES;
	}
	else if(kSegmentedRandom == self.segmented.selectedSegmentIndex)
	{
		self.scrollDirect.hidden = YES;
		self.scrollRandom.hidden = NO;
	}
	
	[self updateBallState:nil];
}
- (void)segmentedChangeValue:(int)index{
	if(kSegmentedDirect == index)
	{
		self.scrollDirect.hidden = NO;
		self.scrollRandom.hidden = YES;
	}
	else if(kSegmentedRandom == index)
	{
		self.scrollDirect.hidden = YES;
		self.scrollRandom.hidden = NO;
	}
	
	[self updateBallState:nil];
    
}

- (void)refreshRandomTableView
{
	[self.tableViewRandom removeFromSuperview];
    [m_tableViewRandom release];
    [m_randomDataArray removeAllObjects];
    
    CGRect tableFrame = CGRectMake(10, 45, 300, self.scrollRandom.frame.size.height - 40);
    m_tableViewRandom = [[UITableView alloc] initWithFrame:tableFrame];
    self.tableViewRandom.delegate = self;
    self.tableViewRandom.dataSource = self;
    self.tableViewRandom.backgroundColor = [UIColor clearColor];
    self.tableViewRandom.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableViewRandom.rowHeight = kRandomBallHeight + kRandomTopOffset;
    [self.scrollRandom addSubview:self.tableViewRandom];
    [self updateBallState:nil];
}

- (void)deleteRandomBallCell:(NSNotification *)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        if (1 == m_randomNum)
            return;
        
        NSDictionary *dict = (NSDictionary*)obj;
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        m_randomNum--;
        [self.tableViewRandom deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [m_randomDataArray removeObjectAtIndex:indexPath.row];
        [self.tableViewRandom reloadData];
        [self.buttonRandomNum setTitle:[NSString stringWithFormat:@"%d", m_randomNum] forState:UIControlStateNormal];
        [self updateBallState:nil];
    }
}

- (void)updateBallState:(NSNotification *)notification
{
    m_detailView.hidden = YES;
    
	NSTrace();
    NSString* totalStr = @"";
    NSString* redStr = @"";
	
    m_numZhu = 0;
    m_numCost = 0;
    if(kSegmentedDirect == self.segmentedView.segmentedIndex)
	{
		NSArray *bWangBalls = [self.ballView1000000 selectedBallsArray];
		int nBWangBalls = [bWangBalls count];
		for (int i = 0; i < nBWangBalls; i++)
		{
			if (i == (nBWangBalls - 1))
				redStr = [redStr stringByAppendingFormat:@"%d", [[bWangBalls objectAtIndex:i] intValue]];
			else
				redStr = [redStr stringByAppendingFormat:@"%d,", [[bWangBalls objectAtIndex:i] intValue]];
		}
		if (nBWangBalls > 0)
			redStr = [redStr stringByAppendingFormat:@"+"];
		else
			redStr = [redStr stringByAppendingFormat:@" +"];
		
		
		NSArray *sWangBalls = [self.ballView100000 selectedBallsArray];
		int nSWangBalls = [sWangBalls count];
		for (int i = 0; i < nSWangBalls; i++)
		{
			if (i == (nSWangBalls - 1))
				redStr = [redStr stringByAppendingFormat:@"%d", [[sWangBalls objectAtIndex:i] intValue]];
			else
				redStr = [redStr stringByAppendingFormat:@"%d,", [[sWangBalls objectAtIndex:i] intValue]];
		}
		if (nSWangBalls > 0)
			redStr = [redStr stringByAppendingFormat:@"+"];
		else
			redStr = [redStr stringByAppendingFormat:@" +"];
		
		
		NSArray *wangBalls = [self.ballView10000 selectedBallsArray];
		int nWangBalls = [wangBalls count];
		for (int i = 0; i < nWangBalls; i++)
		{
			if (i == (nWangBalls - 1))
				redStr = [redStr stringByAppendingFormat:@"%d", [[wangBalls objectAtIndex:i] intValue]];
			else
				redStr = [redStr stringByAppendingFormat:@"%d,", [[wangBalls objectAtIndex:i] intValue]];
		}
		if (nWangBalls > 0)
			redStr = [redStr stringByAppendingFormat:@"+"];
		else
			redStr = [redStr stringByAppendingFormat:@" +"];
		
		NSArray *qianBalls = [self.ballView1000 selectedBallsArray];
		int nQianBalls = [qianBalls count];
		for (int i = 0; i < nQianBalls; i++)
		{
			if (i == (nQianBalls - 1))
				redStr = [redStr stringByAppendingFormat:@"%d", [[qianBalls objectAtIndex:i] intValue]];
			else
				redStr = [redStr stringByAppendingFormat:@"%d,", [[qianBalls objectAtIndex:i] intValue]];
		}
		if (nQianBalls > 0)
			redStr = [redStr stringByAppendingFormat:@"+"];
		else
			redStr = [redStr stringByAppendingFormat:@" +"];
		
		NSArray *baiBalls = [self.ballView100 selectedBallsArray];
		int nBaiBalls = [baiBalls count];
		for (int i = 0; i < nBaiBalls; i++)
		{					
			if (i == (nBaiBalls - 1))
				redStr = [redStr stringByAppendingFormat:@"%d", [[baiBalls objectAtIndex:i] intValue]];
			else
				redStr = [redStr stringByAppendingFormat:@"%d,", [[baiBalls objectAtIndex:i] intValue]];
		}
		if (nBaiBalls > 0)
			redStr = [redStr stringByAppendingFormat:@"+"];
		else
			redStr = [redStr stringByAppendingFormat:@" +"];
		
		NSArray *shiBalls = [self.ballView10 selectedBallsArray];
		int nShiBalls = [shiBalls count];
		for (int i = 0; i < nShiBalls; i++)
		{
			if (i == (nShiBalls - 1))
				redStr = [redStr stringByAppendingFormat:@"%d", [[shiBalls objectAtIndex:i] intValue]];
			else
				redStr = [redStr stringByAppendingFormat:@"%d,", [[shiBalls objectAtIndex:i] intValue]];
		}
		if (nShiBalls > 0)
			redStr = [redStr stringByAppendingFormat:@"+"];
		else
			redStr = [redStr stringByAppendingFormat:@" +"];
		
		NSArray *geBalls = [self.ballView1 selectedBallsArray];
		int nGeBalls = [geBalls count];
		for (int i = 0; i < nGeBalls; i++)
		{
			if (i == (nGeBalls - 1))
				redStr = [redStr stringByAppendingFormat:@"%d", [[geBalls objectAtIndex:i] intValue]];
			else
				redStr = [redStr stringByAppendingFormat:@"%d,", [[geBalls objectAtIndex:i] intValue]];
		}
		
		if(0 == nGeBalls && 0 == nShiBalls && 0 == nBaiBalls && 0 == nQianBalls && 0 == nWangBalls 
		   && 0 == nSWangBalls && 0 == nBWangBalls)
			redStr = nil;
		
		m_numZhu = RYCChoose(1, nGeBalls) * RYCChoose(1, nShiBalls) * RYCChoose(1, nBaiBalls)
		* RYCChoose(1, nQianBalls) * RYCChoose(1, nWangBalls) * RYCChoose(1, nSWangBalls) * RYCChoose(1, nBWangBalls);
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
	else 
	{
		m_numZhu = m_randomNum;
		m_numCost = m_numZhu * 2;
        self.totalCost.textColor = [UIColor blackColor];
		totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注,共 %d 元", m_numZhu, m_numCost];
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
	if (kSegmentedDirect == self.segmentedView.segmentedIndex)
	{
		NSArray *bWBalls = [self.ballView1000000 selectedBallsArray];
		int nBWCount = [bWBalls count];
		NSArray *sWBalls = [self.ballView100000 selectedBallsArray];
		int nSWCount = [sWBalls count];
		NSArray *wBalls = [self.ballView10000 selectedBallsArray];
		int nWCount = [wBalls count];
		NSArray *qBalls = [self.ballView1000 selectedBallsArray];
		int nQCount = [qBalls count];
		NSArray *bBalls = [self.ballView100 selectedBallsArray];
		int nBCount = [bBalls count];
		NSArray *sBalls = [self.ballView10 selectedBallsArray];
		int nSCount = [sBalls count];
		NSArray *gBalls = [self.ballView1 selectedBallsArray];
		int nGCount = [gBalls count];
		
		for (int i = 0; i < nBWCount; i++)
		{
			int nValue = [[bWBalls objectAtIndex:i] intValue];
			betCode = [betCode stringByAppendingFormat:@"%d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
		}
		betCode = [betCode stringByAppendingFormat:@","];
		disBetCode = [disBetCode stringByAppendingFormat:@","];
		
		for (int i = 0; i < nSWCount; i++)
		{
			int nValue = [[sWBalls objectAtIndex:i] intValue];
			betCode = [betCode stringByAppendingFormat:@"%d", nValue];
			disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
		}
		betCode = [betCode stringByAppendingFormat:@","];
		disBetCode = [disBetCode stringByAppendingFormat:@","];
		
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
	}
	else 
	{
		for(int i = 0; i < m_randomNum; i++)
		{
			NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
			int nRandom = [randomData count];
			for(int j = (nRandom - 1); j >= 0; j--)
			{
				int nValue = [[randomData objectAtIndex:j] intValue];
				if(0 == j)
				{						
					disBetCode = [disBetCode stringByAppendingFormat:@"%d\n",nValue];
					betCode = [betCode stringByAppendingFormat:@"%d",nValue];					
				}
				else
				{
					betCode = [betCode stringByAppendingFormat:@"%d,",nValue];					
					disBetCode = [disBetCode stringByAppendingFormat:@"%d,",nValue];
				}
			}
			if(i != (m_randomNum-1))
			{
				betCode = [betCode stringByAppendingFormat:@";"];
			}
		}
		[RuYiCaiLotDetail sharedObject].sellWay = @"1";
	}
	
	NSLog(@"betno&&&&&& %@",betCode);
    //生成投注基本信息
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoQXC;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
	//[RuYiCaiLotDetail sharedObject].sellWay = @"0";
    //[RuYiCaiLotDetail sharedObject].toMobileCode = @"";
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
        [self submitLotNotification:nil];
    }
}

- (void)pressedReselectButton:(id)sender
{
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        [self.ballView1 clearBallState];
        [self.ballView10 clearBallState];
		[self.ballView100 clearBallState];
		[self.ballView1000 clearBallState];
		[self.ballView10000 clearBallState];
		[self.ballView100000 clearBallState];
		[self.ballView1000000 clearBallState];
	}
    else if (kSegmentedRandom == self.segmentedView.segmentedIndex)
    {
        [self refreshRandomTableView];
	}
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [self.ballView1 clearBallState];
    [self.ballView10 clearBallState];
    [self.ballView100 clearBallState];
    [self.ballView1000 clearBallState];
    [self.ballView10000 clearBallState];
    [self.ballView100000 clearBallState];
    [self.ballView1000000 clearBallState];
    [self updateBallState:nil];
}

- (void)randomNumSet
{
	m_delegate.randomPickerView.delegate = self;
	
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:SSQ_RANDOM_NUM];
    [m_delegate.randomPickerView setPickerNum:m_randomNum withMinNum:1 andMaxNum:5];
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
    
    if(self.segmentedView.segmentedIndex == kSegmentedDirect)
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
    else if(self.segmentedView.segmentedIndex == kSegmentedRandom)
    {
        self.basketNum.text = [NSString stringWithFormat:@"%d", ([self.basketNum.text intValue] + m_randomNum)];
        for (int i = 0; i < m_randomNum; i++)
        {
            NSString* betCode = @"";
            NSString* disBetCode = @"";
			NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
			int nRandom = [randomData count];
			for(int j = (nRandom - 1); j >= 0; j--)
			{
				int nValue = [[randomData objectAtIndex:j] intValue];
				if(0 == j)
				{						
					disBetCode = [disBetCode stringByAppendingFormat:@"%d",nValue];
					betCode = [betCode stringByAppendingFormat:@"%d",nValue];					
				}
				else
				{
					betCode = [betCode stringByAppendingFormat:@"%d,",nValue];					
					disBetCode = [disBetCode stringByAppendingFormat:@"%d,",nValue];
				}
			}
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tempDic setObject:betCode forKey:MORE_BETCODE];
            [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
            [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
            [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
            
            NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
            [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
            [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
            [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoQXC;
    }
    // NSLog(@"多倍投数据：%@", [RuYiCaiLotDetail sharedObject].moreBetCodeInfor);
    [self clearAllPickBall];
}

- (IBAction)basketButtonClick:(id)sender
{
    if(m_allZhuShu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"号码篮为空，请添加注码" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoQXC;

    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"七星彩";
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
	viewController.navigationItem.title = @"七星彩投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark RandomPickerDelegate

- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    m_randomNum = num + 1;
    [self.buttonRandomNum setTitle:[NSString stringWithFormat:@"%d", m_randomNum] forState:UIControlStateNormal];
    [self refreshRandomTableView];
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
    viewController.lotNo = kLotNoQXC;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleQXC;
    viewController.lotNo = kLotNoQXC;
    viewController.VRednumber = 70;
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
    viewController.lotTitle = kLotTitleQXC;
    viewController.lotNo = kLotNoQXC;
    viewController.VRednumber = 70;
    viewController.VBluenumber = 0;
    viewController.batchCode = self.lastBatchCode == nil ? @"": self.lastBatchCode;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController trendButtonClick];
    [viewController refreshLotteryAwardInfo];
    viewController.isGoLottery = NO;

    [viewController release];
    
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
	return m_randomNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    FC3DRandomTableViewCell *cell = (FC3DRandomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
		
		[cell setRedNum:7 inRedMax:10 dxds:NO];
		[m_randomDataArray addObject:cell.randomData];
	}
	
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    m_tableViewRandom.separatorColor = [UIColor clearColor];//表格分界线颜色
    m_tableViewRandom.separatorStyle = UITableViewCellSeparatorStyleNone;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	[self.tableViewRandom deselectRowAtIndexPath:indexPath animated:YES];//取消选中行
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
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentedDirect)//普通投注
    {
        if ([m_ballView1 getSelectNum] == 0 && [m_ballView10 getSelectNum] == 0 &&
            [m_ballView100 getSelectNum] == 0 && [m_ballView1000 getSelectNum] == 0
            && [m_ballView10000 getSelectNum] == 0) 
        {
            [m_ballView1 randomBall:1];
            [m_ballView10 randomBall:1];
            [m_ballView100 randomBall:1];
            [m_ballView1000 randomBall:1];
            [m_ballView10000 randomBall:1];
            
            [m_ballView100000 randomBall:1];
            [m_ballView1000000 randomBall:1];
            
            [self updateBallState:nil];
        }
        else
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alterView addButtonWithTitle:@"确定"];
            alterView.delegate = self;
            [alterView show];
            
            [alterView release];
            return;
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
            [m_ballView1 randomBall:1];
            [m_ballView10 randomBall:1];
            [m_ballView100 randomBall:1];
            [m_ballView1000 randomBall:1];
            [m_ballView10000 randomBall:1];
            
            [m_ballView100000 randomBall:1];
            [m_ballView1000000 randomBall:1];
            [self updateBallState:nil];
        }
    }
}

#pragma mark -customSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self segmentedChangeValue:index];
}



@end


