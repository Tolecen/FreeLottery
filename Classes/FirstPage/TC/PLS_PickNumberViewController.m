//
//  PLS_PickNumberViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PLS_PickNumberViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "FC3DRandomTableViewCell.h"
#import "FC3DRandomGroup3TableViewCell.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "RYCNormalBetView.h"
#import "LotteryAwardInfoViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSegmentedDirect  (0)
//#define kSegmentedRandom  (3)
#define kSegmentedGroup3  (1)
#define kSegmentedGroup6  (2)

#define kLabelHeight      (20)
#define kLabelFontSize    (12)
#define kBackAlterTag     (55)

@interface PLS_PickNumberViewController (internal)

- (void)newThreadRun;
- (void)setupNavigationBar;

- (void)setupSubViewsOfDirect;
- (void)updateSubViewsOfDirect;
- (void)setDirectType;
- (void)setDirectSumType;

//- (void)setupSubViewsOfRandom;
//- (void)randomNumSet;
//- (void)deleteRandomBallCell:(NSNotification *)notification;
//- (void)refreshRandomTableView;
//- (void)directRandomClick;
//- (void)group3RandomClick;

- (void)setupSubViewsOfGroup3;
- (void)updateSubViewsOfGroup3;
- (void)singleGroupClick;
- (void)doubleGroupClick;

- (void)setupSubViewsOfGroup6;
- (void)updateSubViewsOfGroup6;

- (void)setGroup3SumType;
- (void)setGroup6SumType;

- (void)segmentedChangeValue;
- (void)segmentedChangeValue:(int)index;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)updateBallState:(NSNotification *)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;
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

@implementation PLS_PickNumberViewController

@synthesize topStatus = m_topStatus;
@synthesize scrollDirect = m_scrollDirect;
//@synthesize scrollRandom = m_scrollRandom;
@synthesize scrollGroup3 = m_scrollGroup3;
@synthesize scrollGroup6 = m_scrollGroup6;
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

    [m_scrollDirect release];
//    [m_scrollRandom release];
    [m_scrollGroup3 release];
    [m_scrollGroup6 release];
    [m_segmented release];
    [m_segmentedView release];
    [m_topStatus release];
    [m_ballView1Direct release];
    [m_ballView10Direct release];
    [m_ballView100Direct release];
    
    [m_buttonDirectDirect release];
    [m_directLabelBai release];
    [m_directLabelShi release];
    [m_directLabelGe release];
    
    [m_buttonSingleGroup release];
    [m_buttonDoubleGroup release];
    [m_label1Single release];
    [m_label2Single release];
    [m_labelDoubleGroup3 release];
    [m_ballView1Single release];
    [m_ballView2Single release];
    [m_ballViewDoubleGroup3 release];
    [m_ballViewGroup6 release];
    [m_typeDirectSum release];
    [m_typeGroup3Sum release];
    [m_typeGroup6Sum release];
    [m_ballViewDirectSum release];
    [m_ballViewGroup3Sum release];
    [m_ballViewGroup6Sum release];
    
    [m_typeDirectGroup6 release];
    [m_labelGroup6 release];
    
    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_totalCost release];
    //[m_selectedBalls release];
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
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"betNormal" object:nil];

//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"batchCodeInformation" object:nil];	
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
    [self setupNavigationBar];
    
    alreaderLabel = [[UILabel alloc] init];
    alreaderLabel.textColor = [UIColor blackColor];
    alreaderLabel.text=@"已选:";
    alreaderLabel.backgroundColor = [UIColor clearColor];
    alreaderLabel.font = [UIFont systemFontOfSize:14];
    [m_bottomScrollView addSubview:alreaderLabel];
    
    alreaderLabel.frame = CGRectMake(5,7,35,21);
    m_totalCost.frame = CGRectMake(45,7,132,21);

//    [MobClick event:@"FCTC_selectPage"];

    isMoreBet = NO;
    m_allZhuShu = 0;
    
    self.scrollDirect.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);
    self.scrollGroup3.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);
    self.scrollGroup6.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);

    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
     
    [self newThreadRun];
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoPLS];

    [self.segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
    self.segmented.selectedSegmentIndex = 0;
    [self segmentedChangeValue];
    
    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:@"fc3d_zx_btn.png",
                                                                        @"fc3d_z3_btn.png",
                                                                        @"fc3d_z6_btn.png", nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:@"fc3d_zx_btn.png",
                                                                        @"fc3d_z3_btn.png",
                                                                        @"fc3d_z6_btn.png", nil]
                                                        andSelectImage:[NSArray arrayWithObjects:@"fc3d_zx_hov_btn.png",
                                                                        @"fc3d_z3_hov_btn.png",
                                                                        @"fc3d_z6_hov_btn.png", nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self segmentedChangeValue:0];
    [self.view addSubview:m_segmentedView];
    
    
    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];    
    
  
}

- (void)newThreadRun
{   
    //初始化直选、机选、组选、和值
    [self setupSubViewsOfDirect];
    [self setupSubViewsOfGroup3];
    [self setupSubViewsOfGroup6];
    
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
    
    self.str1Label.text = [NSString stringWithFormat:@"%@", @"期号获取中..."];
    self.str2Label.text = @"00:00:00";
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoPLS];//获取期号
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
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"排列三 %@期时间已截止，投注时请确认您选择的期号！" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
//        [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoPLS];//获取期号
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
//    
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

- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoPLS;
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
    [viewController setSelectLotNo:kLotNoPLS];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}

- (void)setupSubViewsOfDirect
{    
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scrollDirect addSubview:mode_bg];
    [mode_bg release];
    
    m_directType = 0;
    
    m_buttonDirectDirect = [[UIButton alloc] initWithFrame:CGRectMake(58, 12, 23, 23)];
    [m_buttonDirectDirect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_buttonDirectDirect addTarget:self action:@selector(setDirectType) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollDirect addSubview:m_buttonDirectDirect];
    
    UILabel *lable_direct = [[UILabel alloc] initWithFrame:CGRectMake(86, 12, 50, 23)];
    lable_direct.text = @"普通";
    lable_direct.textColor = [UIColor blackColor];
    lable_direct.backgroundColor = [UIColor clearColor];
    lable_direct.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollDirect addSubview:lable_direct];
    [lable_direct release];
    
    //和值，直选
    m_typeDirectSum = [[UIButton alloc] initWithFrame:CGRectMake(194, 12, 23, 23)];
    [m_typeDirectSum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[m_typeDirectSum setTitle:@"直选" forState:UIControlStateNormal];
    [m_typeDirectSum addTarget:self action:@selector(setDirectSumType) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollDirect addSubview:m_typeDirectSum];
    
    UILabel *lable_sum = [[UILabel alloc] initWithFrame:CGRectMake(222, 12, 50, 23)];
    lable_sum.text = @"和值";
    lable_sum.textColor = [UIColor blackColor];
    lable_sum.backgroundColor = [UIColor clearColor];
    lable_sum.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollDirect addSubview:lable_sum];
    [lable_sum release];
    
    //直选：百位区
    m_directLabelBai = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 310, kLabelHeight)];
    m_directLabelBai.text = @"百位区（至少选择1个）：";
    m_directLabelBai.textAlignment = UITextAlignmentLeft;
    m_directLabelBai.backgroundColor = [UIColor clearColor];
    m_directLabelBai.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_directLabelBai];
    
    CGRect frame100Ball = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight + 50, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing) * 2);
    m_ballView100Direct = [[PickBallViewController alloc] init];
    [m_ballView100Direct createBallArray:10 withPerLine:9 startValue:0 selectBallCount:1];
	[m_ballView100Direct setBallType:RED_BALL];
	[m_ballView100Direct setSelectMaxNum:10];
	m_ballView100Direct.view.frame = frame100Ball;
	[self.scrollDirect addSubview:m_ballView100Direct.view];
    
    //直选：十位区
    m_directLabelShi = [[UILabel alloc] initWithFrame:CGRectMake(10, 
                                                                 frame100Ball.origin.y + frame100Ball.size.height, 
                                                                 310, 
                                                                 kLabelHeight)];
    m_directLabelShi.text = @"十位区（至少选择1个）：";
    m_directLabelShi.textAlignment = UITextAlignmentLeft;
    m_directLabelShi.backgroundColor = [UIColor clearColor];
    m_directLabelShi.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_directLabelShi];
    
    CGRect frame10Ball = CGRectMake(frame100Ball.origin.x, 
                                    frame100Ball.origin.y + frame100Ball.size.height + kLabelHeight, 
                                    frame100Ball.size.width, 
                                    (kBallRectHeight + kBallLineSpacing) * 2);
    m_ballView10Direct = [[PickBallViewController alloc] init];
    [m_ballView10Direct createBallArray:10 withPerLine:9 startValue:0 selectBallCount:1];
	[m_ballView10Direct setBallType:RED_BALL];
	[m_ballView10Direct setSelectMaxNum:10];
	m_ballView10Direct.view.frame = frame10Ball;
	[self.scrollDirect addSubview:m_ballView10Direct.view];
    
    //直选：个位区
    m_directLabelGe = [[UILabel alloc] initWithFrame:CGRectMake(10, 
                                                                frame10Ball.origin.y + frame10Ball.size.height, 
                                                                310, 
                                                                kLabelHeight)];
    m_directLabelGe.text = @"个位区（至少选择1个）：";
    m_directLabelGe.textAlignment = UITextAlignmentLeft;
    m_directLabelGe.backgroundColor = [UIColor clearColor];
    m_directLabelGe.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_directLabelGe];
    
    CGRect frame1Ball = CGRectMake(frame10Ball.origin.x, 
                                   frame10Ball.origin.y + frame10Ball.size.height + kLabelHeight, 
                                   frame10Ball.size.width, 
                                   (kBallRectHeight + kBallLineSpacing) * 2);
    m_ballView1Direct = [[PickBallViewController alloc] init];
    [m_ballView1Direct createBallArray:10 withPerLine:9 startValue:0 selectBallCount:1];
	[m_ballView1Direct setBallType:RED_BALL];
	[m_ballView1Direct setSelectMaxNum:10];
	m_ballView1Direct.view.frame = frame1Ball;
	[self.scrollDirect addSubview:m_ballView1Direct.view];
    
    //和值
    CGRect ballFrame = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                  50 + kLabelHeight, 
                                  9 * (kBallRectWidth + kBallVerticalSpacing), 
                                  (kBallRectHeight + kBallLineSpacing) * 4);
    m_ballViewDirectSum = [[PickBallViewController alloc] init];
    [m_ballViewDirectSum createBallArray:28 withPerLine:9 startValue:0 selectBallCount:1];
	[m_ballViewDirectSum setBallType:RED_BALL];
	[m_ballViewDirectSum setSelectMaxNum:1];
	m_ballViewDirectSum.view.frame = ballFrame;
	[self.scrollDirect addSubview:m_ballViewDirectSum.view];
    
    
    self.scrollDirect.contentSize = CGSizeMake(320, frame1Ball.origin.y + frame1Ball.size.height);
    self.scrollDirect.scrollEnabled = YES;
    
    [self updateSubViewsOfDirect];
}

- (void)updateSubViewsOfDirect
{
    if(0 == m_directType)
    {
        m_directLabelBai.text = @"百位区（至少选择1个）：";
        m_directLabelShi.hidden = NO;
        m_directLabelGe.hidden = NO;
        
        [m_buttonDirectDirect setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
        [m_buttonDirectDirect setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
        [m_typeDirectSum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
        [m_typeDirectSum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
        
        m_ballView1Direct.view.hidden = NO;    //直选，个位
        m_ballView10Direct.view.hidden = NO;   //直选，十位
        m_ballView100Direct.view.hidden = NO;
        m_ballViewDirectSum.view.hidden = YES;
    }
    else
    {
        m_directLabelBai.text = @"选择和值：";
        m_directLabelShi.hidden = YES;
        m_directLabelGe.hidden = YES;
        
        [m_buttonDirectDirect setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
        [m_buttonDirectDirect setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
        [m_typeDirectSum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
        [m_typeDirectSum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
        
        m_ballView1Direct.view.hidden = YES;    //直选，个位
        m_ballView10Direct.view.hidden = YES;   //直选，十位
        m_ballView100Direct.view.hidden = YES;
        m_ballViewDirectSum.view.hidden = NO;
    }
    [self updateBallState:nil];
}

//- (void)setupSubViewsOfRandom
//{
//    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
//    mode_bg.frame = CGRectMake(0, 0, 320, 45);
//    [self.scrollRandom addSubview:mode_bg];
//    [mode_bg release];
//    
//    //机选：注数
//    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 40, 30)];
//    numLabel.text = @"注数：";
//    numLabel.font = [UIFont systemFontOfSize:13];
//    numLabel.backgroundColor = [UIColor clearColor];
//    [self.scrollRandom addSubview:numLabel];
//    [numLabel release];
//    
//	m_randomDataArray = [[NSMutableArray alloc] initWithCapacity:5];
//    
//    //注数设置
//    m_randomNum = 5;
//    m_randomType = 0;
//    m_buttonRandomNum = [[UIButton alloc] initWithFrame:CGRectMake(60, 8, 70, 30)];
//    [m_buttonRandomNum setBackgroundImage:RYCImageNamed(@"list_normal.png") forState:UIControlStateNormal];
//    [m_buttonRandomNum setBackgroundImage:RYCImageNamed(@"list_click.png") forState:UIControlStateHighlighted];
//    [m_buttonRandomNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [m_buttonRandomNum setTitle:[NSString stringWithFormat:@"%d", m_randomNum] forState:UIControlStateNormal];
//    [m_buttonRandomNum setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
//    [m_buttonRandomNum addTarget:self action:@selector(randomNumSet) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollRandom addSubview:m_buttonRandomNum];
//    
//    //机选，直选
//    m_buttonRandomDirect = [[UIButton alloc] initWithFrame:CGRectMake(150, 10, 23, 23)];
//    if (0 == m_randomType)
//    {
//        [m_buttonRandomDirect setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
//        [m_buttonRandomDirect setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
//    }
//    else
//    {
//        [m_buttonRandomDirect setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
//        [m_buttonRandomDirect setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
//    }
//    [m_buttonRandomDirect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[m_buttonRandomDirect setTitle:@"直选" forState:UIControlStateNormal];
//    [m_buttonRandomDirect addTarget:self action:@selector(directRandomClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollRandom addSubview:m_buttonRandomDirect];
//    
//    UILabel *lable_direct = [[UILabel alloc] initWithFrame:CGRectMake(180, 12, 50, 23)];
//    lable_direct.text = @"直选";
//    lable_direct.textColor = [UIColor blackColor];
//    lable_direct.backgroundColor = [UIColor clearColor];
//    lable_direct.font = [UIFont boldSystemFontOfSize:14];
//    [self.scrollRandom addSubview:lable_direct];
//    [lable_direct release];
//    
//    //机选，组3
//    m_buttonRandomGroup3 = [[UIButton alloc] initWithFrame:CGRectMake(220, 10, 23, 23)];
//    if (0 == m_randomType)
//    {
//        [m_buttonRandomGroup3 setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
//        [m_buttonRandomGroup3 setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
//    }
//    else
//    {
//        [m_buttonRandomGroup3 setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
//        [m_buttonRandomGroup3 setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
//    }
//    [m_buttonRandomGroup3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[m_buttonRandomGroup3 setTitle:@"组三" forState:UIControlStateNormal];
//    [m_buttonRandomGroup3 addTarget:self action:@selector(group3RandomClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.scrollRandom addSubview:m_buttonRandomGroup3];    
//    
//    UILabel *lable_group3 = [[UILabel alloc] initWithFrame:CGRectMake(250, 12, 50, 23)];
//    lable_group3.text = @"组三";
//    lable_group3.textColor = [UIColor blackColor];
//    lable_group3.backgroundColor = [UIColor clearColor];
//    lable_group3.font = [UIFont boldSystemFontOfSize:14];
//    [self.scrollRandom addSubview:lable_group3];
//    [lable_group3 release];
//    
//    //机选结果
//    [self refreshRandomTableView];
//}

- (void)setupSubViewsOfGroup3
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scrollGroup3 addSubview:mode_bg];
    [mode_bg release];
    
    //组选：模式
    //    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 40, 30)];
    //    numLabel.text = @"模式：";
    //    numLabel.font = [UIFont systemFontOfSize:13];
    //    numLabel.backgroundColor = [UIColor clearColor];
    //    [self.scrollGroup3 addSubview:numLabel];
    //    [numLabel release];
    
    //m_delegate.randomPickerView.delegate = self;
    
    //模式设置
    m_group3Type = 0;
    
    //组3，单式
    m_buttonSingleGroup = [[UIButton alloc] initWithFrame:CGRectMake(22, 12, 23, 23)];
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
    [m_buttonSingleGroup setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_buttonSingleGroup addTarget:self action:@selector(singleGroupClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollGroup3 addSubview:m_buttonSingleGroup];
    
    UILabel* lable_single = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 50, 23)];
    lable_single.text = @"单式";
    lable_single.textColor = [UIColor blackColor];
    lable_single.backgroundColor = [UIColor clearColor];
    lable_single.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollGroup3 addSubview:lable_single];
    [lable_single release];
    
    //组3，复式
    m_buttonDoubleGroup = [[UIButton alloc] initWithFrame:CGRectMake(115, 12, 23, 23)];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_buttonDoubleGroup setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_buttonDoubleGroup addTarget:self action:@selector(doubleGroupClick) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollGroup3 addSubview:m_buttonDoubleGroup];
    
    UILabel* lable_double = [[UILabel alloc] initWithFrame:CGRectMake(143, 12, 50, 23)];
    lable_double.text = @"复式";
    lable_double.textColor = [UIColor blackColor];
    lable_double.backgroundColor = [UIColor clearColor];
    lable_double.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollGroup3 addSubview:lable_double];
    [lable_double release];
    
    //和值，组3
    m_typeGroup3Sum = [[UIButton alloc] initWithFrame:CGRectMake(208, 12, 23, 23)];
    [m_typeGroup3Sum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_typeGroup3Sum addTarget:self action:@selector(setGroup3SumType) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollGroup3 addSubview:m_typeGroup3Sum];
    
    UILabel *lable_3sum = [[UILabel alloc] initWithFrame:CGRectMake(236, 12, 50, 23)];
    lable_3sum.text = @"和值";
    lable_3sum.textColor = [UIColor blackColor];
    lable_3sum.backgroundColor = [UIColor clearColor];
    lable_3sum.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollGroup3 addSubview:lable_3sum];
    [lable_3sum release];
    
    //组3，单式设置项，重复号码（百位区、十位区）
    m_label1Single = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 310, kLabelHeight)];
    m_label1Single.text = @"出现两次号码：";
    m_label1Single.textAlignment = UITextAlignmentLeft;
    m_label1Single.backgroundColor = [UIColor clearColor];
    m_label1Single.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollGroup3 addSubview:m_label1Single];
    
    CGRect frameBall1 = CGRectMake((320- (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                   50 + kLabelHeight, 
                                   9 * (kBallRectWidth + kBallVerticalSpacing), 
                                   (kBallRectHeight + kBallLineSpacing) * 2);
    m_ballView1Single = [[PickBallViewController alloc] init];
    [m_ballView1Single createBallArray:10 withPerLine:9 startValue:0 selectBallCount:1];
	[m_ballView1Single setBallType:RED_BALL];
	[m_ballView1Single setSelectMaxNum:1];
	m_ballView1Single.view.frame = frameBall1;
	[self.scrollGroup3 addSubview:m_ballView1Single.view];
    
    //组3，单式设置项，非重复号码（个位区）
    m_label2Single = [[UILabel alloc] initWithFrame:CGRectMake(10, 
                                                               frameBall1.origin.y + frameBall1.size.height, 
                                                               310, 
                                                               kLabelHeight)];
    m_label2Single.text = @"出现一次号码：";
    m_label2Single.textAlignment = UITextAlignmentLeft;
    m_label2Single.backgroundColor = [UIColor clearColor];
    m_label2Single.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollGroup3 addSubview:m_label2Single];
    
    CGRect frameBall2 = CGRectMake(frameBall1.origin.x, 
                                   frameBall1.origin.y + frameBall1.size.height + kLabelHeight, 
                                   frameBall1.size.width, 
                                   (kBallRectHeight + kBallLineSpacing) * 2);
    m_ballView2Single = [[PickBallViewController alloc] init];
    [m_ballView2Single createBallArray:10 withPerLine:9 startValue:0 selectBallCount:1];
	[m_ballView2Single setBallType:RED_BALL];
	[m_ballView2Single setSelectMaxNum:1];
	m_ballView2Single.view.frame = frameBall2;
	[self.scrollGroup3 addSubview:m_ballView2Single.view];
    
    //组3，复式设置项
    m_labelDoubleGroup3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 310, kLabelHeight)];
    m_labelDoubleGroup3.text = @"选择号码（至少选择2个）：";
    m_labelDoubleGroup3.textAlignment = UITextAlignmentLeft;
    m_labelDoubleGroup3.backgroundColor = [UIColor clearColor];
    m_labelDoubleGroup3.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollGroup3 addSubview:m_labelDoubleGroup3];
    
    CGRect frameBall3 = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                   50 + kLabelHeight, 
                                   9 * (kBallRectWidth + kBallVerticalSpacing), 
                                   (kBallRectHeight + kBallLineSpacing) * 2);
    m_ballViewDoubleGroup3 = [[PickBallViewController alloc] init];
    [m_ballViewDoubleGroup3 createBallArray:10 withPerLine:9 startValue:0 selectBallCount:2];
	[m_ballViewDoubleGroup3 setBallType:RED_BALL];
	[m_ballViewDoubleGroup3 setSelectMaxNum:10];
	m_ballViewDoubleGroup3.view.frame = frameBall3;
	[self.scrollGroup3 addSubview:m_ballViewDoubleGroup3.view];
    
    CGRect ballFrame = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                  50 + kLabelHeight, 
                                  9 * (kBallRectWidth + kBallVerticalSpacing), 
                                  (kBallRectHeight + kBallLineSpacing) * 4);
    m_ballViewGroup3Sum = [[PickBallViewController alloc] init];
    [m_ballViewGroup3Sum createBallArray:26 withPerLine:9 startValue:1 selectBallCount:1];
	[m_ballViewGroup3Sum setBallType:RED_BALL];
	[m_ballViewGroup3Sum setSelectMaxNum:1];
	m_ballViewGroup3Sum.view.frame = ballFrame;
	[self.scrollGroup3 addSubview:m_ballViewGroup3Sum.view];
    
    self.scrollGroup3.contentSize = CGSizeMake(320, frameBall2.origin.y + frameBall2.size.height);
    self.scrollGroup3.scrollEnabled = YES;
    [self updateSubViewsOfGroup3];
}

- (void)updateSubViewsOfGroup3
{
    if (0 == m_group3Type)
    {
        m_label1Single.hidden = NO;
        m_label2Single.hidden = NO;
        m_ballView1Single.view.hidden = NO;
        m_ballView2Single.view.hidden = NO;
        m_labelDoubleGroup3.hidden = YES;
        m_ballViewDoubleGroup3.view.hidden = YES;
        m_ballViewGroup3Sum.view.hidden = YES;
    }
    else if(1 == m_group3Type)
    {
        m_labelDoubleGroup3.hidden = NO;
        m_labelDoubleGroup3.text = @"选择号码（至少选择2个）：";
        
        m_label1Single.hidden = YES;
        m_label2Single.hidden = YES;
        m_ballView1Single.view.hidden = YES;
        m_ballView2Single.view.hidden = YES;
        m_ballViewDoubleGroup3.view.hidden = NO;
        m_ballViewGroup3Sum.view.hidden = YES;
        
    }
    else
    {
        m_labelDoubleGroup3.hidden = NO;
        m_labelDoubleGroup3.text = @"选择和值：";
        
        m_label1Single.hidden = YES;
        m_label2Single.hidden = YES;
        m_ballView1Single.view.hidden = YES;
        m_ballView2Single.view.hidden = YES;
        m_ballViewDoubleGroup3.view.hidden = YES;
        m_ballViewGroup3Sum.view.hidden = NO;
        
        //        m_label1Single.hidden = YES;
        //        m_label2Single.hidden = YES;
        //        m_ballView1Single.view.hidden = YES;
        //        m_ballView2Single.view.hidden = YES;
        //        m_labelDoubleGroup3.hidden = YES;
        //        m_ballViewDoubleGroup3.view.hidden = YES;
        //        m_labelGroup6.hidden = NO;
        //        m_ballViewGroup6.view.hidden = NO;
    }
    [self updateBallState:nil];
}

- (void)setupSubViewsOfGroup6
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scrollGroup6 addSubview:mode_bg];
    [mode_bg release];
    
    m_group6Type = 0;
    
    //组六 直选
    m_typeDirectGroup6 = [[UIButton alloc] initWithFrame:CGRectMake(58, 12, 23, 23)];
    [m_typeDirectGroup6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_typeDirectGroup6 addTarget:self action:@selector(setGroup6DirectType) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollGroup6 addSubview:m_typeDirectGroup6];
    
    UILabel *lable_6direct = [[UILabel alloc] initWithFrame:CGRectMake(86, 12, 50, 23)];
    lable_6direct.text = @"普通";
    lable_6direct.textColor = [UIColor blackColor];
    lable_6direct.backgroundColor = [UIColor clearColor];
    lable_6direct.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollGroup6 addSubview:lable_6direct];
    [lable_6direct release];
    
    //和值，组6
    m_typeGroup6Sum = [[UIButton alloc] initWithFrame:CGRectMake(194, 12, 23, 23)];
    [m_typeGroup6Sum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[m_typeGroup6Sum setTitle:@"组6" forState:UIControlStateNormal];
    [m_typeGroup6Sum addTarget:self action:@selector(setGroup6SumType) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollGroup6 addSubview:m_typeGroup6Sum];
    
    UILabel *lable_6sum = [[UILabel alloc] initWithFrame:CGRectMake(222, 12, 50, 23)];
    lable_6sum.text = @"和值";
    lable_6sum.textColor = [UIColor blackColor];
    lable_6sum.backgroundColor = [UIColor clearColor];
    lable_6sum.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollGroup6 addSubview:lable_6sum];
    [lable_6sum release];
    
    
    //组6
    m_labelGroup6 = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 310, kLabelHeight)];
    m_labelGroup6.text = @"选择号码（至少选择3个）：";
    m_labelGroup6.textAlignment = UITextAlignmentLeft;
    m_labelGroup6.backgroundColor = [UIColor clearColor];
    m_labelGroup6.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollGroup6 addSubview:m_labelGroup6];
    
    CGRect frameBall4 = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                   50 + kLabelHeight, 
                                   9 * (kBallRectWidth + kBallVerticalSpacing), 
                                   (kBallRectHeight + kBallLineSpacing) * 2);
    m_ballViewGroup6 = [[PickBallViewController alloc] init];
    [m_ballViewGroup6 createBallArray:10 withPerLine:9 startValue:0 selectBallCount:3];
	[m_ballViewGroup6 setBallType:RED_BALL];
	[m_ballViewGroup6 setSelectMaxNum:10];
	m_ballViewGroup6.view.frame = frameBall4;
	[self.scrollGroup6 addSubview:m_ballViewGroup6.view];
    
    
    //    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 310, kLabelHeight)];
    //    label.text = @"选择和值：";
    //    label.textAlignment = UITextAlignmentLeft;
    //    label.backgroundColor = [UIColor clearColor];
    //    label.font = [UIFont systemFontOfSize:kLabelFontSize];
    //    [self.scrollGroup6 addSubview:label];
    //    [label release];
	
    //直选，和值选择区
    CGRect ballFrame = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                  50 + kLabelHeight, 
                                  9 * (kBallRectWidth + kBallVerticalSpacing), 
                                  (kBallRectHeight + kBallLineSpacing) * 4);
    
    //组6，和值选择区
    m_ballViewGroup6Sum = [[PickBallViewController alloc] init];
    [m_ballViewGroup6Sum createBallArray:22 withPerLine:9 startValue:3 selectBallCount:1];
	[m_ballViewGroup6Sum setBallType:RED_BALL];
	[m_ballViewGroup6Sum setSelectMaxNum:1];
	m_ballViewGroup6Sum.view.frame = ballFrame;
	[self.scrollGroup6 addSubview:m_ballViewGroup6Sum.view];
    
    self.scrollGroup6.contentSize = CGSizeMake(320, ballFrame.origin.y + ballFrame.size.height);
    self.scrollGroup6.scrollEnabled = YES;
    [self updateSubViewsOfGroup6];
}

- (void)updateSubViewsOfGroup6
{
    if(0 == m_group6Type)
    {
        [m_typeDirectGroup6 setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
        [m_typeDirectGroup6 setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
        [m_typeGroup6Sum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
        [m_typeGroup6Sum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
        
        m_labelGroup6.text = @"选择号码（至少选择3个）：";
        m_ballViewGroup6.view.hidden = NO;
        m_ballViewGroup6Sum.view.hidden = YES;
        
    }
    else
    {
        [m_typeDirectGroup6 setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
        [m_typeDirectGroup6 setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
        [m_typeGroup6Sum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
        [m_typeGroup6Sum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
        
        m_labelGroup6.text = @"选择和值：";
        m_ballViewGroup6.view.hidden = YES;
        m_ballViewGroup6Sum.view.hidden = NO;
        
    }
    [self updateBallState:nil];
}

- (void)setGroup6DirectType
{
    m_group6Type = 0;
    [self updateSubViewsOfGroup6];
}

- (void)setDirectType
{
    m_directType = 0;
    [self updateSubViewsOfDirect];
}

- (void)setDirectSumType
{
    m_directType = 1;
    [self updateSubViewsOfDirect];
}

- (void)setGroup3SumType
{
    if(2 == m_group3Type)
    {
        return;
    }
    m_group3Type = 2;
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
    [self updateSubViewsOfGroup3];
}

- (void)setGroup6SumType
{
    m_group6Type = 1;
    [self updateSubViewsOfGroup6];
}

- (void)segmentedChangeValue
{
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = NO;
        self.scrollGroup3.hidden = YES;
        self.scrollGroup6.hidden = YES;
	}
    else if (kSegmentedGroup3 == self.segmentedView.segmentedIndex)
    {
		self.scrollDirect.hidden = YES;
        self.scrollGroup3.hidden = NO;
        self.scrollGroup6.hidden = YES;
    }
    else
    {
		self.scrollDirect.hidden = YES;
        self.scrollGroup3.hidden = YES;
        self.scrollGroup6.hidden = NO;
    }
    [self updateBallState:nil];
}

- (void)segmentedChangeValue:(int)index{
    
    if (kSegmentedDirect == index)
    {
		self.scrollDirect.hidden = NO;
        self.scrollGroup3.hidden = YES;
        self.scrollGroup6.hidden = YES;
	}
    else if (kSegmentedGroup3 == index)
    {
		self.scrollDirect.hidden = YES;
        self.scrollGroup3.hidden = NO;
        self.scrollGroup6.hidden = YES;
    }
    else
    {
		self.scrollDirect.hidden = YES;
        self.scrollGroup3.hidden = YES;
        self.scrollGroup6.hidden = NO;
    }
    [self updateBallState:nil];
}

- (void)submitLotNotification:(NSNotification*)notification
{
	NSTrace();    
    //显示你的订单详情，并生成投注信息
	NSString* disBetCode = @"";

    NSString* betCode = @"";
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        if(0 == m_directType)
        {
            NSArray *direct1Balls = [m_ballView1Direct selectedBallsArray];
            NSArray *direct10Balls = [m_ballView10Direct selectedBallsArray];
            NSArray *direct100Balls = [m_ballView100Direct selectedBallsArray];
            int n1Count = [direct1Balls count];
            int n10Count = [direct10Balls count];
            int n100Count = [direct100Balls count];
            
            betCode = [betCode stringByAppendingFormat:@"1|"];
            for (int i = 0; i < n100Count; i++)
            {
                int nValue = [[direct100Balls objectAtIndex:i] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d", nValue];

                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
            }
            betCode = [betCode stringByAppendingFormat:@","];
            disBetCode = [disBetCode stringByAppendingFormat:@"|"];
            
            for (int i = 0; i < n10Count; i++)
            {
                int nValue = [[direct10Balls objectAtIndex:i] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
            }
            betCode = [betCode stringByAppendingFormat:@","];
            disBetCode = [disBetCode stringByAppendingFormat:@"|"];
            
            for (int i = 0; i < n1Count; i++)
            {
                int nValue = [[direct1Balls objectAtIndex:i] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
            }
        }
        else
        {
            NSArray* selectedBallsArray;
            int nCount = 0;
            betCode = [betCode stringByAppendingFormat:@"S1|"];
            selectedBallsArray = [m_ballViewDirectSum selectedBallsArray];
            
            nCount = [selectedBallsArray count];
            for (int i = 0; i < nCount; i++)
            {
                int nValue = [[selectedBallsArray objectAtIndex:i] intValue];
                if (i != (nCount - 1))
                    betCode = [betCode stringByAppendingFormat:@"%d,", nValue];
                else
                    betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                
                if (i == (nCount - 1))
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
            }

        }
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
    }
    else if (kSegmentedGroup3 == self.segmentedView.segmentedIndex)
    {
        if (0 == m_group3Type)  //组3
        {
            int nValue1 = [[[m_ballView1Single selectedBallsArray] objectAtIndex:0] intValue];
            int nValue2 = [[[m_ballView2Single selectedBallsArray] objectAtIndex:0] intValue];
            betCode = [betCode stringByAppendingFormat:@"6|%d,%d,%d", nValue1, nValue1, nValue2];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d,%d,%d", nValue1, nValue1, nValue2];
        }
        else if(1 == m_group3Type)
        {
            NSArray* doubleBalls = [m_ballViewDoubleGroup3 selectedBallsArray];
            int nCount = [doubleBalls count];
            betCode = [betCode stringByAppendingFormat:@"F3|"];
            for (int i = 0; i < nCount; i++)
            {
                int nValue = [[doubleBalls objectAtIndex:i] intValue];
                betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                if (i == (nCount - 1))
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
            }
        }
        else
        {
            NSArray* selectedBallsArray;
            int nCount = 0;
            betCode = [betCode stringByAppendingFormat:@"S3|"];
            selectedBallsArray = [m_ballViewGroup3Sum selectedBallsArray];
            nCount = [selectedBallsArray count];
            for (int i = 0; i < nCount; i++)
            {
                int nValue = [[selectedBallsArray objectAtIndex:i] intValue];
                if (i != (nCount - 1))
                    betCode = [betCode stringByAppendingFormat:@"%d,", nValue];
                else
                    betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                
                if (i == (nCount - 1))
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
            }
        }
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
    }
    else if (kSegmentedGroup6 == self.segmentedView.segmentedIndex)
    {
        if(0 == m_group6Type)
        { 
            NSArray* group6Balls = [m_ballViewGroup6 selectedBallsArray];
            int nCount = [group6Balls count];
            if (nCount > 3)  //复式
                betCode = [betCode stringByAppendingFormat:@"F6|"];
            else
                betCode = [betCode stringByAppendingFormat:@"6|"];
                
            for (int i = 0; i < nCount; i++)
            {
                int nValue = [[group6Balls objectAtIndex:i] intValue];
                if (nCount > 3)
                {
                    betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                }
                else
                {
                    if (i != (nCount - 1))
                        betCode = [betCode stringByAppendingFormat:@"%d,", nValue];
                    else
                        betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                }
                
                if (i == (nCount - 1))
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
            }
        }
        else
        {
            NSArray* selectedBallsArray;
            int nCount = 0;
            
            betCode = [betCode stringByAppendingFormat:@"S6|"];
            selectedBallsArray = [m_ballViewGroup6Sum selectedBallsArray];
            
            
            nCount = [selectedBallsArray count];
            for (int i = 0; i < nCount; i++)
            {
                int nValue = [[selectedBallsArray objectAtIndex:i] intValue];
                if (i != (nCount - 1))
                    betCode = [betCode stringByAppendingFormat:@"%d,", nValue];
                else
                    betCode = [betCode stringByAppendingFormat:@"%d", nValue];
                
                if (i == (nCount - 1))
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
            }
        }
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
    }
	NSLog(@"%@",betCode);

    //生成投注基本信息
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoPLS;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    //[RuYiCaiLotDetail sharedObject].sellWay = @"0";
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
        [m_ballView1Direct clearBallState];
        [m_ballView10Direct clearBallState];
        [m_ballView100Direct clearBallState];
        
        [m_ballViewDirectSum clearBallState];
	}
    else if (kSegmentedGroup3 == self.segmentedView.segmentedIndex)
    {
        [m_ballView1Single clearBallState];
        [m_ballView2Single clearBallState];
        [m_ballViewDoubleGroup3 clearBallState];
        [m_ballViewGroup3Sum clearBallState];
    }
    else
    {
        [m_ballViewGroup6 clearBallState];
        [m_ballViewGroup6Sum clearBallState];
    }
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [m_ballView1Direct clearBallState];
    [m_ballView10Direct clearBallState];
    [m_ballView100Direct clearBallState];
    
    [m_ballViewDirectSum clearBallState];
    [m_ballView1Single clearBallState];
    [m_ballView2Single clearBallState];
    [m_ballViewDoubleGroup3 clearBallState];
    [m_ballViewGroup3Sum clearBallState];
    [m_ballViewGroup6 clearBallState];
    [m_ballViewGroup6Sum clearBallState];

    [self updateBallState:nil];
}

- (void)singleGroupClick
{
    if(0 == m_group3Type)
    {
        return;
    }
    m_group3Type = 0;
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    
    [self updateSubViewsOfGroup3];
}

- (void)doubleGroupClick
{
    if(1 == m_group3Type)
    {
        return;
    }
    m_group3Type = 1;
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_buttonSingleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateNormal];
    [m_buttonDoubleGroup setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateHighlighted];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
    [m_typeGroup3Sum setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateHighlighted];
    [self updateSubViewsOfGroup3];
    
}

- (void)updateBallState:(NSNotification *)notification
{
    m_detailView.hidden = YES;
    
	NSString* totalStr = @"";
    //NSString* redStr = @"";
    m_numZhu = 0;
    m_numCost = 0;
    
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        if(0 == m_directType)
        {
            NSArray *balls1 = [m_ballView1Direct selectedBallsArray];
            NSArray *balls2 = [m_ballView10Direct selectedBallsArray];
            NSArray *balls3 = [m_ballView100Direct selectedBallsArray];
            int count1 = [balls1 count];
            int count2 = [balls2 count];
            int count3 = [balls3 count];
            
            //注数 = 个位红球数 * 十位红球数 * 百位红球数
            //金额 = 注数 * 倍数 *（2元）* 期数
            m_numZhu = count1 * count2 * count3;
            m_numCost = m_numZhu * 2;
            if (m_numZhu == 0) {
                [alreaderLabel setHidden:NO];
                self.totalCost.textColor = [UIColor redColor];
                [alreaderLabel setHidden:NO];
                m_totalCost.frame = CGRectMake(45,7,132,21);
                totalStr = @"  摇一摇可以机选一注";
            }
            else
            {
                [alreaderLabel setHidden:YES];
                m_totalCost.frame = CGRectMake(5,7,132,21);
                self.totalCost.textColor = [UIColor blackColor];
                [alreaderLabel setHidden:YES];
                totalStr = [NSString stringWithFormat:@"  您已选择了 %d 注,共 %d 元", m_numZhu, m_numCost];
            }
        }
        else
        {
            NSArray* indexs_direct = nil;
            m_numZhu = 0;
            indexs_direct = [m_ballViewDirectSum selectedIndexArray];
            m_numZhu = NumberOfDirectSum(indexs_direct);
            m_numCost = m_numZhu * 2;
            [alreaderLabel setHidden:YES];
            m_totalCost.frame = CGRectMake(5,7,132,21);
            self.totalCost.textColor = [UIColor blackColor];
            totalStr = [NSString stringWithFormat:@"您已选择了 %d 注,共 %d 元", m_numZhu, m_numCost];
        }
    }
    else if (kSegmentedGroup3 == self.segmentedView.segmentedIndex)
    {
        if (0 == m_group3Type)  //组3
        {
            
            NSMutableArray* balls1 = [m_ballView1Single selectedBallsArray];
            NSMutableArray* balls2 = [m_ballView2Single selectedBallsArray];
            int count1 = [balls1 count];
            int count2 = [balls2 count];
            
            NSObject *obj = [notification object];
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary*)obj;
                PickBallViewController *ballView = [dict objectForKey:@"ballView"];
                if(ballView == m_ballView1Single) //判断消息的发送者
                {
                    for(int i = 0;i < count1; i++)
                    {
                        for(int j =0;j < count2; j++)
                        {
                            if([[balls2 objectAtIndex:j] isEqual:[balls1 objectAtIndex:i]])
                            {
                                [m_ballView2Single resetStateForIndex:[[balls2 objectAtIndex:j]intValue]];
                                [balls2 removeObjectAtIndex:j];
                                count2 -= 1;
                            }
                        }
                    }
                }
				
                else if(ballView == m_ballView2Single)
                {
                    for(int i = 0;i < count2; i++)
                    {
                        for(int j =0;j < count1; j++)
                        {
                            if([[balls1 objectAtIndex:j] isEqual:[balls2 objectAtIndex:i]])
                            {
                                [m_ballView1Single resetStateForIndex:[[balls1 objectAtIndex:j]intValue]];
                                [balls1 removeObjectAtIndex:j];
                                count1 -= 1;
                            }
                        }
                    }
                }
            }
            
            if (count1 > 0 && count2 > 0)
                m_numZhu = 1;
            else
                m_numZhu = 0;
            m_numCost = m_numZhu * 2;
            if (m_numZhu == 0) {
                alreaderLabel.frame = CGRectMake(5,7,35,21);
                m_totalCost.frame = CGRectMake(45,7,132,21);
                m_totalCost.textColor = [UIColor  redColor];
                [alreaderLabel setHidden:NO];
                totalStr = @"摇一摇可以机选一注";
            }
            else
            {
                [alreaderLabel setHidden:YES];
                m_totalCost.frame = CGRectMake(5,7,132,21);
                m_totalCost.textColor = [UIColor  blackColor];
                [alreaderLabel setHidden:YES];
                totalStr = [NSString stringWithFormat:@"您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
            }
        }
        else if(1 == m_group3Type)//复式
        {
            NSArray* balls = [m_ballViewDoubleGroup3 selectedBallsArray];
            int count = [balls count];
            //注数 = zuhe(2,用户选中红球数量) * 2
            m_numZhu = RYCChoose(2, count) * 2;
            m_numCost = m_numZhu * 2;
            self.totalCost.textColor = [UIColor blackColor];
            [alreaderLabel setHidden:YES];
            m_totalCost.frame = CGRectMake(5,7,132,21);
            totalStr = [NSString stringWithFormat:@"您已选择了 %d 注,共 %d 元", m_numZhu, m_numCost];
        }
        else//组三
        {
            NSArray* group3_indexs = nil;
            m_numZhu = 0;
            
            group3_indexs = [m_ballViewGroup3Sum selectedIndexArray];
            m_numZhu = NumberOfGroup3Sum(group3_indexs);
            m_numCost = m_numZhu * 2;
            self.totalCost.textColor = [UIColor blackColor];
            [alreaderLabel setHidden:YES];
            m_totalCost.frame = CGRectMake(5,7,132,21);
            totalStr = [NSString stringWithFormat:@"您已选择了 %d 注,共 %d 元", m_numZhu, m_numCost];
            
        }
    }
    else
    {
        //NSArray* balls = nil;
        NSArray* indexs = nil;
        m_numZhu = 0;
        if(0 == m_group6Type)  //组6
        {
            NSArray* balls = [m_ballViewGroup6 selectedBallsArray];
            int count = [balls count];
            //注数 = zuhe(3,用户选中红球数量)
            m_numZhu = RYCChoose(3, count);
        }
        else
        {
            indexs = [m_ballViewGroup6Sum selectedIndexArray];
            m_numZhu = NumberOfGroup6Sum(indexs);
        }
        
        m_numCost = m_numZhu * 2;
        self.totalCost.textColor = [UIColor blackColor];
        [alreaderLabel setHidden:YES];
        m_totalCost.frame = CGRectMake(5,7,132,21);
        totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注,共 %d 元", m_numZhu, m_numCost];
    }
    
    self.totalCost.text = totalStr;
    CGSize totalStrSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect frame1 = self.totalCost.frame;
    frame1.size.width = totalStrSize.width;
    self.totalCost.frame = frame1;
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
    for(int i = 0; i < 3; i++)
    {
        if(i != 2)
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
    
    if(self.segmentedView.segmentedIndex == kSegmentedDirect || self.segmentedView.segmentedIndex == kSegmentedGroup3 || self.segmentedView.segmentedIndex == kSegmentedGroup6)
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
    [self clearAllPickBall];
}

- (IBAction)basketButtonClick:(id)sender
{
    if(m_allZhuShu == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"号码篮为空，请添加注码" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoPLS;
    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"排列三";
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
	viewController.navigationItem.title = @"排列三投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark RandomPickerDelegate
//
//- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
//{
//    m_randomNum = num + 1;
//    [m_buttonRandomNum setTitle:[NSString stringWithFormat:@"%d", m_randomNum] forState:UIControlStateNormal];
//    [self refreshRandomTableView];
//}

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
    viewController.lotNo = kLotNoPLS;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitlePLS;
    viewController.lotNo = kLotNoPLS;
    viewController.VRednumber = 30;
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
    viewController.lotTitle = kLotTitlePLS;
    viewController.lotNo = kLotNoPLS;
    viewController.VRednumber = 30;
    viewController.VBluenumber = 0;
    viewController.batchCode = self.lastBatchCode == nil ? @"": self.lastBatchCode;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController trendButtonClick];
    [viewController refreshLotteryAwardInfo];
    viewController.isGoLottery = NO;

    [viewController release];
    
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
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentedDirect && m_directType == 0)//普通投注
    {
        if ([m_ballView1Direct getSelectNum] == 0 && [m_ballView10Direct getSelectNum] == 0 &&
            [m_ballView100Direct getSelectNum] == 0) 
        {
            [m_ballView1Direct randomBall:1];
            [m_ballView10Direct randomBall:1];
            [m_ballView100Direct randomBall:1];
            
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
    //组三 单式
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentedGroup3 && m_group3Type == 0)//单式
    {
        if ([m_ballView1Single getSelectNum] == 0 && [m_ballView2Single getSelectNum] == 0) 
        {
            [m_ballView1Single randomBall:1];
            [m_ballView2Single randomBall:1];
            int Single1 = [[[m_ballView1Single selectedBallsArray] objectAtIndex:0] intValue];
            int Single2 = [[[m_ballView2Single selectedBallsArray] objectAtIndex:0] intValue];
            while (Single1 == Single2) {
                
                [m_ballView1Single randomBall:1];
                [m_ballView2Single randomBall:1];
                
                Single1 = [[[m_ballView1Single selectedBallsArray] objectAtIndex:0] intValue];
                Single2 = [[[m_ballView2Single selectedBallsArray] objectAtIndex:0] intValue];
            }
            
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
            if (kSegmentedDirect == self.segmentedView.segmentedIndex)
            {
                [m_ballView1Direct randomBall:1];
                [m_ballView10Direct randomBall:1];
                [m_ballView100Direct randomBall:1];
                
            }
            else if(kSegmentedGroup3 == self.segmentedView.segmentedIndex)
            {
                [m_ballView1Single randomBall:1];
                [m_ballView2Single randomBall:1];
                int Single1 = [[[m_ballView1Single selectedBallsArray] objectAtIndex:0] intValue];
                int Single2 = [[[m_ballView2Single selectedBallsArray] objectAtIndex:0] intValue];
                while (Single1 == Single2) {
                    
                    [m_ballView1Single randomBall:1];
                    [m_ballView2Single randomBall:1];
                    
                    Single1 = [[[m_ballView1Single selectedBallsArray] objectAtIndex:0] intValue];
                    Single2 = [[[m_ballView2Single selectedBallsArray] objectAtIndex:0] intValue];
                }
            }
            [self updateBallState:nil];
        }
    }
}

#pragma mark - customSegment delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self segmentedChangeValue:index];
}

@end