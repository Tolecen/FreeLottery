//
//  KLSF_PickNumberViewController.m
//  RuYiCai
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  广东快乐十分

#import "KLSF_PickNumberViewController.h"
#import "RandomPickerViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "RYCHighBetView.h"
#import "SBJsonBase.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"
#import "LotteryAwardInfoViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "LuckViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSegmentedDirect  (0)
#define kSegmentedDrag    (1)

#define kLabelHeight      (20)
#define kLabelFontSize    (12)
#define kBackAlterTag     (55)

#define kPlayTypeOne    (0)
#define kPlayTypeRed    (1)
#define kPlayTypeRX2    (2)
#define kPlayTypeRX3    (3)
#define kPlayTypeRX4    (4)
#define kPlayTypeRX5    (5)
#define kPlayTypeX2Zhi  (6)
#define kPlayTypeX2Zu   (7)
#define kPlayTypeX3Zhi  (8)
#define kPlayTypeX3Zu   (9)

#define kPlayTypeRX2_Dan    (0)
#define kPlayTypeRX3_Dan    (1)
#define kPlayTypeRX4_Dan    (2)
#define kPlayTypeRX5_Dan    (3)

#define kPerMinuteTimeInterval (60.0)

@interface KLSF_PickNumberViewController (internal)

- (void)setupNavigationBar;
- (void)setupSubViewsOfDirectGroup;
- (void)updateSubViewsOfDirect;

- (void)setupSubviewsOfDrag;
- (void)updateSubViewsOfDrag;

- (void)segmentedChangeValue;
- (void)segmentedChangeValue:(int)index;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)updateBallState:(NSNotification*)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)updateInformation:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;
- (void)playTypeSet;


- (void)refreshLeftTime;

- (void)setDetailView;
- (void)detailViewButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;
- (void)luckButtonClick:(id)sender;

- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;

- (IBAction)addBasketClick:(id)sender;
- (IBAction)basketButtonClick:(id)sender;

- (void) getYaoYiYaoNum;

//遗漏获取和返回数据
- (void)getMissdateForServersWithPalyType:(NSString *)type;
- (void)getMissDateOK:(NSNotification*)notification;


@end

@implementation KLSF_PickNumberViewController

@synthesize ballViewOneDirect = m_ballViewOneDirect;
@synthesize ballViewRedDirect = m_ballViewRedDirect;

@synthesize bottomScrollView = m_bottomScrollView;
@synthesize scrollDirect = m_scrollDirect;
@synthesize segmented = m_segmented;
@synthesize segmentedView = m_segmentedView;
@synthesize buttonBuy = m_buttonBuy;
@synthesize buttonReselect = m_buttonReselect;
@synthesize ballViewDirect = m_ballViewDirect;
@synthesize ballViewDirect1000 = m_ballViewDirect1000;
@synthesize ballViewDirect100 = m_ballViewDirect100;
@synthesize buttonPlayType = m_buttonPlayType;

@synthesize totalCost = m_totalCost;
@synthesize batchCode = m_batchCode;
@synthesize batchEndTime = m_batchEndTime;

@synthesize scrollDrag = m_scrollDrag;
@synthesize ballViewDan = m_ballViewDan;
@synthesize ballViewTuo = m_ballViewTuo;
@synthesize dragPlayType = m_dragPlayType;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMissDateOK" object:nil];
//    [m_detailButton removeFromSuperview];
//    [m_backButton removeFromSuperview];

    [self resignFirstResponder];
	[super viewWillDisappear:animated];
}

- (void)dealloc
{
    m_delegate.randomPickerView.delegate = nil;
//    [m_backButton release];
    [m_bottomScrollView release];
	[m_scrollDirect release];
	[m_buttonPlayType release];
	[m_selectedCount release];
	[m_scrollRandom release];
	[m_segmented release];
    [m_segmentedView release];
    
    [m_buttonBuy release];
    [m_buttonReselect release];
    
    [m_ballViewOneDirect release];
    [m_ballViewRedDirect release];
    [m_ballViewDirect release];
	[m_ballViewDirect1000 release];
    [m_ballViewDirect100 release];
	
	[m_wanLable release];
	[m_qianLable release];
	[m_baiLable release];
	
    
    [m_totalCost release];
	
	[m_leftTimeLabel release];
	[m_batchCodeLabel release];
    
//    [m_recoderYiLuoDateArr release];
	
    [m_scrollDrag release];
    [m_ballViewDan release];  //胆码
	[m_ballViewTuo release]; 
    [m_dragPlayType release];
    [m_danLabel release];
    [m_tuoLabel release];
    
    [m_addBasketButton release];
    [m_basketButton release];
    [m_basketNum release];
    
    [m_detailView release], m_detailView = nil;
    [alreaderLabel release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBallState:) name:@"updateBallState" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLottery:) name:@"updateLottery" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMissDateOK:) name:@"getMissDateOK" object:nil];

    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoKLSF];//上期开奖
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoKLSF];
    
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
    
//    [MobClick event:@"GPC_selectPage"];
    [AdaptationUtils adaptation:self];
    alreaderLabel = [[UILabel alloc] init];
    alreaderLabel.textColor = [UIColor blackColor];
    alreaderLabel.text=@"已选:";
    alreaderLabel.backgroundColor = [UIColor clearColor];
    alreaderLabel.font = [UIFont systemFontOfSize:14];
   [m_bottomScrollView addSubview:alreaderLabel];
    
    
     [self setupNavigationBar];
    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:@"zixuan_normal.png",@"dantuo_normal.png", nil]
                                                        andSelectImage:[NSArray arrayWithObjects:@"zixuan_click.png",@"dantuo_click.png", nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self segmentedChangeValue:0];
    [self.view addSubview:m_segmentedView];
    
    self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    
    self.scrollDirect.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);
    self.scrollDrag.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);
    
    isMoreBet = NO;
    m_allZhuShu = 0;
    
    oneRefreshDragYiLuo = YES;
    
	m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];

    [self setupSubViewsOfDirectGroup];
    [self setupSubviewsOfDrag];
    
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
    
//    NSDictionary *startDic = [[NSDictionary alloc] init];
//    m_recoderYiLuoDateArr = [[NSMutableArray alloc] initWithObjects:startDic, startDic, startDic, startDic, nil];
//    [startDic release];
    
//    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
//    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_RX"];
    
//    [self setDetailView];

//    [self.segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
//    self.segmented.selectedSegmentIndex = 0;
//    [self segmentedChangeValue];
    
    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];    
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
    NSString*   blueWinNoString_one = @"";
    
    NSString*   redWinNoString_one = @"";
    NSInteger   redWinNo_one = 0;
    
    NSString*   redWinNoString_two = @"";
    NSInteger   redWinNo_two = 0;
    
    NSString*  winNo = [[[parserDict objectForKey:@"result"] objectAtIndex:0] objectForKey:@"winCode"];

    for (int i = 0; i < 8; i++)
    {
        NSString* winStr = [winNo substringWithRange:NSMakeRange(i * 2, 2)];
        if(i != 7)
        {
            if([winStr isEqualToString:@"19"] || [winStr isEqualToString:@"20"])
            {
                if([redWinNoString_one isEqualToString:@""])
                {
                    redWinNoString_one = [redWinNoString_one stringByAppendingFormat:@"%@,", winStr];
                    redWinNo_one = i + 1;
                }
                else
                {
                    redWinNoString_two = [redWinNoString_two stringByAppendingFormat:@"%@,", winStr];
                    redWinNo_two = i + 1;
                }
                blueWinNoString_one = [blueWinNoString_one stringByAppendingString:@"      "];
            }
            else
            {
                blueWinNoString_one = [blueWinNoString_one stringByAppendingFormat:@"%@,", winStr];
            }
        }
        else
        {
            if([winStr isEqualToString:@"19"] || [winStr isEqualToString:@"20"])
            {
                if([redWinNoString_one isEqualToString:@""])
                {
                    redWinNoString_one = [redWinNoString_one stringByAppendingFormat:@"%@", winStr];
                    redWinNo_one = i + 1;
                }
                else
                {
                    redWinNoString_two = [redWinNoString_two stringByAppendingFormat:@"%@", winStr];
                    redWinNo_two = i + 1;
                }
            }
            else
                blueWinNoString_one = [blueWinNoString_one stringByAppendingFormat:@"%@", winStr];
        }
    }
    UILabel *blueWinLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 30)];
    blueWinLabel.backgroundColor = [UIColor whiteColor];
    blueWinLabel.textColor = [UIColor blueColor];
    blueWinLabel.textAlignment = UITextAlignmentLeft;
    blueWinLabel.font = [UIFont systemFontOfSize:12];
    blueWinLabel.text = blueWinNoString_one;
    [self.view addSubview:blueWinLabel];
    
    CGSize redStrSize = [redWinNoString_one sizeWithFont:[UIFont systemFontOfSize:12]];
    
    if(redWinNo_one != 0)
    {
        float withX ;
        if(redWinNo_one == 8)
            withX = (redWinNo_one - 1) * redStrSize.width + 20;
        else
            withX = (redWinNo_one - 1) * redStrSize.width;
        
        UILabel *redWinLabel_one = [[UILabel alloc] initWithFrame:CGRectMake(100 + withX, 0, redStrSize.width, 30)];
        redWinLabel_one.backgroundColor = [UIColor whiteColor];
        redWinLabel_one.textColor = [UIColor redColor];
        redWinLabel_one.textAlignment = UITextAlignmentRight;
        redWinLabel_one.font = [UIFont systemFontOfSize:12];
        redWinLabel_one.text = redWinNoString_one;
        [self.view addSubview:redWinLabel_one];
        [redWinLabel_one release];
    }
    if(redWinNo_two != 0)
    {
        UILabel *redWinLabel_two = [[UILabel alloc] initWithFrame:CGRectMake(100 + (redWinNo_two - 1) * redStrSize.width, 0, redStrSize.width, 30)];
        redWinLabel_two.backgroundColor = [UIColor whiteColor];
        redWinLabel_two.textColor = [UIColor redColor];
        redWinLabel_two.textAlignment = UITextAlignmentLeft;
        redWinLabel_two.font = [UIFont systemFontOfSize:12];
        redWinLabel_two.text = redWinNoString_two;
        [self.view addSubview:redWinLabel_two];
        [redWinLabel_two release];
    }
    [blueWinLabel release];
    
    [self setDetailView];
}

#pragma mark   右上角 下拉按钮
- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoKLSF;
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
    [pickNumberView randomPickerView:m_delegate.randomPickerView selectRowNum:7];
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
    [viewController setSelectLotNo:kLotNoKLSF];
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
    if(m_detailView != nil)
    {
        [m_detailView release], m_detailView = nil;
    }
//    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 153, 195)];
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

#pragma mark 选球
- (void)setupSubViewsOfDirectGroup
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scrollDirect addSubview:mode_bg];
    [mode_bg release];
    
    
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 30)];
    numLabel.text = @"玩法：";
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.backgroundColor = [UIColor clearColor];
    [self.scrollDirect addSubview:numLabel];
    [numLabel release];
    
    //模式设置
    m_playType = kPlayTypeRX5;
    m_buttonPlayType = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 85, 20)];
    [self.buttonPlayType setBackgroundImage:RYCImageNamed(@"list_c_normal.png") forState:UIControlStateNormal];
    [self.buttonPlayType setBackgroundImage:RYCImageNamed(@"list_c_click.png") forState:UIControlStateHighlighted];
	[self.buttonPlayType setTitle:@"任选五" forState:UIControlStateNormal];
    [self.buttonPlayType setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
    self.buttonPlayType.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.buttonPlayType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonPlayType addTarget:self action:@selector(playTypeSet) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollDirect addSubview:self.buttonPlayType];
	
    //奖金描述
    m_winDescribtionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    m_winDescribtionLable.text = @"至少选择1个号码投注，命中开奖在号码第1位即中奖！";
    m_winDescribtionLable.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable.numberOfLines = 2;
    m_winDescribtionLable.textColor = [UIColor redColor];
    [self.scrollDirect addSubview:m_winDescribtionLable];
    
    //奖金：6元
    m_winMonneyLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 15)];
    m_winMonneyLable.text = @"奖金：25元";
    m_winMonneyLable.font = [UIFont systemFontOfSize:12];
    m_winMonneyLable.textAlignment = UITextAlignmentLeft;
    m_winMonneyLable.backgroundColor = [UIColor clearColor];
    m_winMonneyLable.textColor = [UIColor redColor];
    [self.scrollDirect addSubview:m_winMonneyLable];
    
	//直选：红球区
	m_selectedCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 50  + 45, 310, kLabelHeight)];
	m_selectedCount.textAlignment = UITextAlignmentLeft;
    m_selectedCount.backgroundColor = [UIColor clearColor];
    m_selectedCount.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_selectedCount];
	
   	m_wanLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + 45, 310, kLabelHeight)];
	m_wanLable.text = @"第一位：（请至少选择1个球）";
	m_wanLable.textAlignment = UITextAlignmentLeft;
    m_wanLable.backgroundColor = [UIColor clearColor];
    m_wanLable.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_wanLable];
	
	CGRect frameRedBall = CGRectMake((320- (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight + 50 + 45, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing) * 3+50);
    
    m_ballViewOneDirect = [[PickBallViewController alloc] init];
    self.ballViewOneDirect.isHasYiLuo = YES;
	[self.ballViewOneDirect createBallArray:18 withPerLine:9 startValue:1 selectBallCount:1];
    [self.ballViewOneDirect setSelectMaxNum:18];
	[self.ballViewOneDirect setBallType:RED_BALL];
	self.ballViewOneDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:self.ballViewOneDirect.view];
    
    m_ballViewRedDirect = [[PickBallViewController alloc] init];
    self.ballViewRedDirect.isHasYiLuo = YES;
	[self.ballViewRedDirect createBallArray:2 withPerLine:9 startValue:19 selectBallCount:1];
    [self.ballViewRedDirect setSelectMaxNum:2];
	[self.ballViewRedDirect setBallType:RED_BALL];
	self.ballViewRedDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:self.ballViewRedDirect.view];
    
    m_ballViewDirect = [[PickBallViewController alloc] init];
    self.ballViewDirect.isHasYiLuo = YES;
	[self.ballViewDirect createBallArray:20 withPerLine:9 startValue:1 selectBallCount:1];
    [self.ballViewDirect setSelectMaxNum:20];
	[self.ballViewDirect setBallType:RED_BALL];
	self.ballViewDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:self.ballViewDirect.view];
    
	m_qianLable = [[UILabel alloc] initWithFrame:CGRectMake(10, frameRedBall.origin.y + frameRedBall.size.height+50, 310, kLabelHeight)];
	m_qianLable.text = @"第二位：（请至少选择1个球）";
	m_qianLable.textAlignment = UITextAlignmentLeft;
    m_qianLable.backgroundColor = [UIColor clearColor];
    m_qianLable.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_qianLable];
	
	CGRect frameRedBall1000 = CGRectMake(frameRedBall.origin.x, 
                                         frameRedBall.origin.y + frameRedBall.size.height + kLabelHeight + kBallLineSpacing+50,
                                         frameRedBall.size.width, 
                                         frameRedBall.size.height);
    m_ballViewDirect1000 = [[PickBallViewController alloc] init];
    self.ballViewDirect1000.isHasYiLuo = YES;
    [self.ballViewDirect1000 createBallArray:20 withPerLine:9 startValue:1 selectBallCount:1];
	[self.ballViewDirect1000 setSelectMaxNum:20];
	[self.ballViewDirect1000 setBallType:RED_BALL];
	self.ballViewDirect1000.view.frame = frameRedBall1000;
	[self.scrollDirect addSubview:self.ballViewDirect1000.view];
	
	m_baiLable = [[UILabel alloc] initWithFrame:CGRectMake(10, frameRedBall1000.origin.y + frameRedBall1000.size.height + 50, 310, kLabelHeight)];
	m_baiLable.text = @"第三位 ：（请至少选择1个球）";
	m_baiLable.textAlignment = UITextAlignmentLeft;
    m_baiLable.backgroundColor = [UIColor clearColor];
    m_baiLable.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_baiLable];
	
	CGRect frameRedBall100 = CGRectMake(frameRedBall.origin.x, 
                                        frameRedBall1000.origin.y + frameRedBall1000.size.height + kLabelHeight + kBallLineSpacing + 50,
                                        frameRedBall.size.width, 
                                        frameRedBall.size.height);
    m_ballViewDirect100 = [[PickBallViewController alloc] init];
    self.ballViewDirect100.isHasYiLuo = YES;
	[self.ballViewDirect100 createBallArray:20 withPerLine:9 startValue:1 selectBallCount:1];
	[self.ballViewDirect100 setSelectMaxNum:20];
	[self.ballViewDirect100 setBallType:RED_BALL];
	self.ballViewDirect100.view.frame = frameRedBall100;
	[self.scrollDirect addSubview:self.ballViewDirect100.view];
	
	self.scrollDirect.contentSize = CGSizeMake(320, frameRedBall100.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2 + 5 + 50);
    self.scrollDirect.scrollEnabled = YES;
	[self updateSubViewsOfDirect];
}

- (void)updateSubViewsOfDirect
{	
	switch (m_playType)
	{
		case kPlayTypeOne:
		{	
			self.ballViewDirect.m_selectBallCount = 1;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择1个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = NO;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = YES;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            
            m_winDescribtionLable.text = @"至少选择1个号码投注，命中开奖在号码第1位即中奖！";
            m_winMonneyLable.text = @"奖金：25元";
            [self getMissdateForServersWithPalyType:@"T01015MV_S1"];

			break;
		}
		case kPlayTypeRed:
		{
			self.ballViewDirect.m_selectBallCount = 2;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择1个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = NO;
            self.ballViewDirect.view.hidden = YES;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"19，20为红号，从这两个号码任选一个投注，开奖号码第一位是红号即中奖！";
            m_winMonneyLable.text = @"奖金：5元";
            [self getMissdateForServersWithPalyType:@"T01015MV_H1"];
			break;
		}
		case kPlayTypeRX2:
		{
			self.ballViewDirect.m_selectBallCount = 2;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择2个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"至少选择2个号码投注，命中开奖号码的任意两位即中奖！";
            m_winMonneyLable.text = @"奖金：8元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
			break;
		}
		case kPlayTypeRX3:
		{
			self.ballViewDirect.m_selectBallCount = 3;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择3个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"至少选择3个号码投注，命中开奖号码的任意三位即中奖！";
            m_winMonneyLable.text = @"奖金：24元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
			break;
		}
		case kPlayTypeRX4:
		{
			self.ballViewDirect.m_selectBallCount = 4;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择4个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"至少选择4个号码投注，命中开奖号码的任意四位即中奖！";
            m_winMonneyLable.text = @"奖金：80元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];            
			break;
		}
		case kPlayTypeRX5:
		{
			self.ballViewDirect.m_selectBallCount = 5;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择5个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"至少选择5个号码投注，命中开奖号码的任意五位即中奖！";
            m_winMonneyLable.text = @"奖金：320元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
			break;
		}
        case kPlayTypeX2Zu:
		{
			self.ballViewDirect.m_selectBallCount = 2;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择2个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"每位各选1个或多个号码投注，命中开奖号码的连续两位数字（顺序不限）即中奖！";
            m_winMonneyLable.text = @"奖金：31元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
			break;
		}
		case kPlayTypeX2Zhi:
		{
			self.ballViewDirect.m_selectBallCount = 1;
			m_selectedCount.hidden = YES;
			m_wanLable.hidden = NO;
			m_qianLable.hidden = NO;
            m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = NO;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"每位各选1个或多个号码投注，命中开奖号码的连续两位数字、顺序相同即中奖！";
            m_winMonneyLable.text = @"奖金：62元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
			break;
		}
		case kPlayTypeX3Zu:
		{
			self.ballViewDirect.m_selectBallCount = 3;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择3个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			m_baiLable.hidden = YES;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
            m_winDescribtionLable.text = @"每位各选1个或多个号码投注，命中开奖号码的前三位数字（顺序不限）即中奖！";
            m_winMonneyLable.text = @"奖金：1300元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
			break;
		}
		case kPlayTypeX3Zhi:
		{
			self.ballViewDirect.m_selectBallCount = 1;
			m_selectedCount.hidden = YES;
			m_wanLable.hidden = NO;
			m_qianLable.hidden = NO;
			m_baiLable.hidden = NO;
            self.ballViewOneDirect.view.hidden = YES;
            self.ballViewRedDirect.view.hidden = YES;
            self.ballViewDirect.view.hidden = NO;
            self.ballViewDirect1000.view.hidden = NO;
			self.ballViewDirect100.view.hidden = NO;
            m_winDescribtionLable.text = @"每位各选1个或多个号码投注，命中开奖号码的前三位数字、顺序相同即中奖！";
            m_winMonneyLable.text = @"奖金：8000元";
            [self getMissdateForServersWithPalyType:@"T01015MV_Q3"];
			break;
		}	
		default:
			break;
	}
 	[self updateBallState:nil];
}

- (void)setupSubviewsOfDrag
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scrollDrag addSubview:mode_bg];
    [mode_bg release];
    
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 30)];
    numLabel.text = @"玩法：";
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.backgroundColor = [UIColor clearColor];
    [self.scrollDrag addSubview:numLabel];
    [numLabel release];
    
    //模式设置
    drag_PlayType = kPlayTypeRX5_Dan;
    m_dragPlayType = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 85, 20)];
    [self.dragPlayType setBackgroundImage:RYCImageNamed(@"list_c_normal.png") forState:UIControlStateNormal];
    [self.dragPlayType setBackgroundImage:RYCImageNamed(@"list_c_click.png") forState:UIControlStateHighlighted];
	[self.dragPlayType setTitle:@"任选五" forState:UIControlStateNormal];
    [self.dragPlayType setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
	self.dragPlayType.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.dragPlayType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.dragPlayType addTarget:self action:@selector(playTypeSet) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollDrag addSubview:self.dragPlayType];
    
    //奖金描述
    m_winDescribtionLable_dan = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    m_winDescribtionLable_dan.text = @"至少选择1个胆码和2个拖码投注，胆码加拖码≥3个，命中开奖号码的任意两位即中奖！";
    m_winDescribtionLable_dan.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable_dan.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable_dan.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable_dan.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable_dan.numberOfLines = 2;
    m_winDescribtionLable_dan.textColor = [UIColor redColor];
    [self.scrollDrag addSubview:m_winDescribtionLable_dan];
    
    //奖金：6元
    m_winMonneyLable_dan = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 15)];
    m_winMonneyLable_dan.text = @"奖金：8元";
    m_winMonneyLable_dan.font = [UIFont systemFontOfSize:12];
    m_winMonneyLable_dan.textAlignment = UITextAlignmentLeft;
    m_winMonneyLable_dan.backgroundColor = [UIColor clearColor];
    m_winMonneyLable_dan.textColor = [UIColor redColor];
    [self.scrollDrag addSubview:m_winMonneyLable_dan];
    
    //直选：红球区
    m_danLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + 45, 310, kLabelHeight)];
	m_danLabel.text = @"胆码 ：";
	m_danLabel.textAlignment = UITextAlignmentLeft;
    m_danLabel.backgroundColor = [UIColor clearColor];
    m_danLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:m_danLabel];
	
	CGRect frameRedBall = CGRectMake((320- (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight + 50 + 45, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing) * 3 + 50);
    m_ballViewDan = [[PickBallViewController alloc] init];
    self.ballViewDan.isHasYiLuo = YES;
	[self.ballViewDan createBallArray:20 withPerLine:9 startValue:1 selectBallCount:1];
	[self.ballViewDan setBallType:RED_BALL];
	self.ballViewDan.view.frame = frameRedBall;
	[self.scrollDrag addSubview:self.ballViewDan.view];
    
	m_tuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frameRedBall.origin.y + frameRedBall.size.height + 50, 310, kLabelHeight)];
	m_tuoLabel.text = @"拖码：";
	m_tuoLabel.textAlignment = UITextAlignmentLeft;
    m_tuoLabel.backgroundColor = [UIColor clearColor];
    m_tuoLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:m_tuoLabel];
	
	CGRect frameRedBall1000 = CGRectMake(frameRedBall.origin.x, 
                                         kLabelHeight + frameRedBall.origin.y+frameRedBall.size.height + 50,
                                         frameRedBall.size.width, 
                                         frameRedBall.size.height);
    m_ballViewTuo = [[PickBallViewController alloc] init];
    self.ballViewTuo.isHasYiLuo = YES;
    [self.ballViewTuo createBallArray:20 withPerLine:9 startValue:1 selectBallCount:2];
	//[self.ballViewTuo setSelectMaxNum:10];
	[self.ballViewTuo setBallType:RED_BALL];
	self.ballViewTuo.view.frame = frameRedBall1000;
	[self.scrollDrag addSubview:self.ballViewTuo.view];
    
    self.scrollDrag.contentSize = CGSizeMake(320, frameRedBall1000.origin.y+frameRedBall1000.size.height + 50);
    self.scrollDrag.scrollEnabled = YES;
	[self updateSubViewsOfDrag];
    
}

- (void)updateSubViewsOfDrag
{
    switch (drag_PlayType) {
        case kPlayTypeRX2_Dan:
            m_danLabel.text = @"胆码（只能选1个球）：";
            m_tuoLabel.text = @"拖码（选2-19个球）：";
            [self.ballViewDan setSelectMaxNum:1];
            [self.ballViewTuo setSelectMaxNum:19];
            m_winDescribtionLable_dan.text = @"至少选择1个胆码和2个拖码投注，胆码加拖码≥3个，命中开奖号码的任意两位即中奖！";
            m_winMonneyLable_dan.text = @"奖金：8元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
            break;
        case kPlayTypeRX3_Dan:
            m_danLabel.text = @"胆码（选1-2个球,胆码加拖码个数大于3）：";
            m_tuoLabel.text = @"拖码（选2-19个球）：";
            [self.ballViewDan setSelectMaxNum:2];
            [self.ballViewTuo setSelectMaxNum:19];
            m_winDescribtionLable_dan.text = @"胆码可选1-2个，拖码至少选择2个，胆码加拖码≥4个，命中开奖号码的任意三位即中奖！";
            m_winMonneyLable_dan.text = @"奖金：24元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
            break;    
        case kPlayTypeRX4_Dan:
            m_danLabel.text = @"胆码（选1-3个球,胆码加拖码个数大于4）：";
            m_tuoLabel.text = @"拖码（选2-19个球）：";
            [self.ballViewDan setSelectMaxNum:3];
            [self.ballViewTuo setSelectMaxNum:19];
            m_winDescribtionLable_dan.text = @"胆码可选1-3个，拖码至少选择2个，胆码加拖码≥5个，命中开奖号码的任意四位即中奖！";
            m_winMonneyLable_dan.text = @"奖金：80元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
            break;
        case kPlayTypeRX5_Dan:
            m_danLabel.text = @"胆码（选1-4个球,胆码加拖码个数大于5）：";
            m_tuoLabel.text = @"拖码（选2-19个球）：";
            [self.ballViewDan setSelectMaxNum:4];
            [self.ballViewTuo setSelectMaxNum:19];
            m_winDescribtionLable_dan.text = @"胆码可选1-4个，拖码至少选择2个，胆码加拖码≥6个，命中开奖号码的任意五位即中奖！";
            m_winMonneyLable_dan.text = @"奖金：320元";
            [self getMissdateForServersWithPalyType:@"T01015MV_RX"];
            break;
        default:
            break;
    }
}

- (void)segmentedChangeValue
{
	if (kSegmentedDirect == self.segmented.selectedSegmentIndex)
    {
		self.scrollDirect.hidden = NO;
        self.scrollDrag.hidden = YES;
	}
    else 
    {
        self.scrollDirect.hidden = YES;
        self.scrollDrag.hidden = NO;
        if(oneRefreshDragYiLuo)//每次都刷新，机器就会卡死
        {
//           [self refreshMissView];
            oneRefreshDragYiLuo = NO;
        }   
    }
    [self updateBallState:nil];
}

- (void)segmentedChangeValue:(int)index{
    if (kSegmentedDirect == index)
    {
        m_playType = kPlayTypeRX5;
        [self.buttonPlayType setTitle:@"任选五" forState:UIControlStateNormal];
        [self updateSubViewsOfDirect];
		self.scrollDirect.hidden = NO;
        self.scrollDrag.hidden = YES;
	}
    else
    {
        drag_PlayType = kPlayTypeRX5_Dan;
        [self.dragPlayType setTitle:@"任选五" forState:UIControlStateNormal];
        [self updateSubViewsOfDrag];
        
        self.scrollDirect.hidden = YES;
        self.scrollDrag.hidden = NO;
        if(oneRefreshDragYiLuo)//每次都刷新，机器就会卡死
        {
//            [self refreshMissView];
            oneRefreshDragYiLuo = NO;
        }
    }
    [self updateBallState:nil];
    [self updateSubViewsOfDrag];
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
        [self.ballViewOneDirect clearBallState];
        [self.ballViewRedDirect clearBallState];
        [self.ballViewDirect clearBallState];
		[self.ballViewDirect1000 clearBallState];
		[self.ballViewDirect100 clearBallState];
        
	}
    else if(kSegmentedDrag == self.segmentedView.segmentedIndex)
    {
        [self.ballViewDan clearBallState];
		[self.ballViewTuo clearBallState];
    }
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [self.ballViewOneDirect clearBallState];
    [self.ballViewRedDirect clearBallState];
    [self.ballViewDirect clearBallState];
    [self.ballViewDirect1000 clearBallState];
    [self.ballViewDirect100 clearBallState];
    [self.ballViewDan clearBallState];
    [self.ballViewTuo clearBallState];
    [self updateBallState:nil];
}

- (void)updateBallState:(NSNotification*)notification
{    
    m_detailView.hidden = YES;
    
    NSString* totalStr = @"";
	NSInteger baseBallCount = 0;
    m_numZhu = 0;
    m_numCost = 0;
    
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
	    if(kPlayTypeX2Zhi != m_playType && kPlayTypeX3Zhi != m_playType)
		{
            NSArray *balls;
            if(kPlayTypeOne == m_playType)
            {
                balls = [self.ballViewOneDirect selectedBallsArray];
            }
            else if(kPlayTypeRed == m_playType)
            {
                balls = [self.ballViewRedDirect selectedBallsArray];
            }
            else
            {
                balls = [self.ballViewDirect selectedBallsArray];
            }
            int nBalls = [balls count];

            switch (m_playType) 
			{
				case kPlayTypeOne:
                case kPlayTypeRed:
					baseBallCount = 1;
					break;
				case kPlayTypeRX2:
					baseBallCount = 2;
					break;
				case kPlayTypeRX3:
					baseBallCount = 3;
					break;
				case kPlayTypeRX4:
					baseBallCount = 4;
					break;
				case kPlayTypeRX5:
					baseBallCount = 5;
					break;
				case kPlayTypeX2Zu:
					baseBallCount = 2;
					break;
				case kPlayTypeX3Zu:
					baseBallCount = 3;
					break;
				default:
					break;
			}
			//注数 = zuhe(1,用户选中红球数量) 
			m_numZhu = RYCChoose(baseBallCount, nBalls);
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
        else//直选2、3
        {
            NSMutableArray *wBalls = [self.ballViewDirect selectedBallsArray];
			int nWBalls = [wBalls count];
			NSMutableArray *qBalls = [self.ballViewDirect1000 selectedBallsArray];
			int nQBalls = [qBalls count];
			NSMutableArray *bBalls = [self.ballViewDirect100 selectedBallsArray];
			int nBBalls = [bBalls count];
            
			//各区没有相同球
			NSObject *obj = [notification object];
			if ([obj isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *dict = (NSDictionary*)obj;
				PickBallViewController *ballView = [dict objectForKey:@"ballView"];
				if(ballView == self.ballViewDirect) //判断消息的发送者
				{
					for(int i = 0;i < nWBalls; i++)
					{
						for(int j =0;j <nQBalls; j++)
						{
							if([[qBalls objectAtIndex:j] isEqual:[wBalls objectAtIndex:i]])
							{
								[self.ballViewDirect1000 resetStateForIndex:[[qBalls objectAtIndex:j]intValue]-1];
								[qBalls removeObjectAtIndex:j];
								nQBalls -= 1;
							}
						}
						for(int k = 0;k <nBBalls; k++)
						{
							if([[bBalls objectAtIndex:k] isEqual:[wBalls objectAtIndex:i]])
							{
								[self.ballViewDirect100 resetStateForIndex:[[bBalls objectAtIndex:k]intValue]-1];
								[bBalls removeObjectAtIndex:k];
								nBBalls -= 1; 
							}
						}
					}
				}
				else if(ballView == self.ballViewDirect1000)
				{
					for(int i = 0;i < nQBalls; i++)
					{
						for(int j =0;j < nWBalls; j++)
						{
							if([[wBalls objectAtIndex:j] isEqual:[qBalls objectAtIndex:i]])
		                    {
								[self.ballViewDirect resetStateForIndex:[[wBalls objectAtIndex:j]intValue]-1];
								[wBalls removeObjectAtIndex:j];
								nWBalls -= 1;
							}
						}
						for(int k = 0;k <nBBalls; k++)
						{
							if([[bBalls objectAtIndex:k] isEqual:[qBalls objectAtIndex:i]])
							{
								[self.ballViewDirect100 resetStateForIndex:[[bBalls objectAtIndex:k]intValue]-1];
								[bBalls removeObjectAtIndex:k];
								nBBalls -= 1;
							}
						}
					}
				}
				else if(ballView == self.ballViewDirect100)
				{
					for(int i = 0;i < nBBalls; i++)
					{
						for(int j =0 ;j < nWBalls; j++)
						{
							if([[wBalls objectAtIndex:j] isEqual:[bBalls objectAtIndex:i]])
		                    {
								[self.ballViewDirect resetStateForIndex:[[wBalls objectAtIndex:j]intValue]-1];
								[wBalls removeObjectAtIndex:j];
								nWBalls -= 1;
							}
						}
						for(int k = 0;k <nQBalls; k++)
						{
							if([[qBalls objectAtIndex:k] isEqual:[bBalls objectAtIndex:i]])
							{
								[self.ballViewDirect1000 resetStateForIndex:[[qBalls objectAtIndex:k]intValue]-1];
								[qBalls removeObjectAtIndex:k];
								nQBalls -= 1;
							}
						}
					}
				}
			}
            //选前2直
			if(kPlayTypeX2Zhi == m_playType)
			{
			    m_numZhu = RYCChoose(1, nWBalls) * RYCChoose(1, nQBalls);
			}
            else//选前3直
			{
				m_numZhu = RYCChoose(1, nWBalls) * RYCChoose(1, nQBalls) * RYCChoose(1, nBBalls);               
			}			
            m_numCost = m_numZhu * 2;
            if (m_numZhu == 0) {
                self.totalCost.textColor = [UIColor redColor];
                totalStr = @"  摇一摇可以机选一注";	
            }
           else
            {
                self.totalCost.textColor = [UIColor blackColor];
                totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];	
            }
        }		
    }
    else//胆拖
    {
        NSMutableArray *danBalls = [self.ballViewDan selectedBallsArray];
        int nDanBalls = [danBalls count];
        NSMutableArray *tuoBalls = [self.ballViewTuo selectedBallsArray];
        int nTuoBalls = [tuoBalls count];
        
        NSObject *obj = [notification object];
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary*)obj;
            PickBallViewController *ballView = [dict objectForKey:@"ballView"];
            if(ballView == self.ballViewDan) //判断消息的发送者
            {
                for(int i = 0;i < nDanBalls; i++)
                {
                    for(int j =0;j <nTuoBalls; j++)
                    {
                        if([[tuoBalls objectAtIndex:j] isEqual:[danBalls objectAtIndex:i]])
                        {
                            [self.ballViewTuo resetStateForIndex:[[tuoBalls objectAtIndex:j]intValue]-1];
                            [tuoBalls removeObjectAtIndex:j];
                            nTuoBalls -= 1;
                        }
                    }
                }
            }
            else
            {
                for(int i = 0;i < nTuoBalls; i++)
                {
                    for(int j =0;j <nDanBalls; j++)
                    {
                        if([[danBalls objectAtIndex:j] isEqual:[tuoBalls objectAtIndex:i]])
                        {
                            [self.ballViewDan resetStateForIndex:[[danBalls objectAtIndex:j]intValue]-1];
                            [danBalls removeObjectAtIndex:j];
                            nDanBalls -= 1;
                        }
                    }
                }
            }
        }
        switch (drag_PlayType) 
        {
            case kPlayTypeRX2_Dan:
            case kPlayTypeRX3_Dan:
            case kPlayTypeRX4_Dan:
            case kPlayTypeRX5_Dan:
                baseBallCount = drag_PlayType + 2;
                break;
            default:
                break;
        }
        if(nTuoBalls >= 2 && nDanBalls >=1 && (nTuoBalls + nDanBalls) > baseBallCount)
        {
            m_numZhu = RYCChoose(baseBallCount - nDanBalls, nTuoBalls);
            m_numCost = m_numZhu * 2;
            self.totalCost.textColor = [UIColor blackColor];
            totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
        }
        else
        {
            m_numZhu = 0;
            m_numCost = m_numZhu * 2;
            self.totalCost.textColor = [UIColor blackColor];
            totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
        }
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
	//显示你的订单详情，并生成投注信息
    NSString* disBetCode = @"";
    NSString* betCode = @"";
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        NSArray *oneBalls = [self.ballViewOneDirect selectedBallsArray];
        int nOneCount = [oneBalls count];
        NSArray *oneRedBalls = [self.ballViewRedDirect selectedBallsArray];
        int nOneRedCount = [oneRedBalls count];
        
        NSArray *redBalls = [self.ballViewDirect selectedBallsArray];//高位
		int nRedCount = [redBalls count];
		NSArray *qianBalls = [self.ballViewDirect1000 selectedBallsArray];//中位
		int nQianCount = [qianBalls count];
		NSArray *baiBalls = [self.ballViewDirect100 selectedBallsArray];//低位
		int nBaiCount = [baiBalls count];
        if(m_numZhu > 1)//复式投
        {
            switch (m_playType)
            {
                case kPlayTypeOne:
                    betCode = [betCode stringByAppendingString:@"M|S1|"];
                    break;
                case kPlayTypeRed:
                    betCode = [betCode stringByAppendingString:@"S|H1|"];
                    break;
                case kPlayTypeRX2:
                    betCode = [betCode stringByAppendingString:@"M|R2|"];
                    break;
                case kPlayTypeRX3:
                    betCode = [betCode stringByAppendingString:@"M|R3|"];
                    break;
                case kPlayTypeRX4:
                    betCode = [betCode stringByAppendingString:@"M|R4|"];
                    break;
                case kPlayTypeRX5:
                    betCode = [betCode stringByAppendingString:@"M|R5|"];
                    break;
                case kPlayTypeX2Zhi:
                    betCode = [betCode stringByAppendingString:@"P|Q2|"];
                    break;
                case kPlayTypeX2Zu:
                    betCode = [betCode stringByAppendingString:@"M|Z2|"];
                    break;
                case kPlayTypeX3Zhi:
                    betCode = [betCode stringByAppendingString:@"P|Q3|"];
                    break;
                case kPlayTypeX3Zu:
                    betCode = [betCode stringByAppendingString:@"M|Z3|"];
                    break;
                default:
                    break;
            } 
        }
        else//单式
        {
            switch (m_playType)
            {
                case kPlayTypeOne:
                    betCode = [betCode stringByAppendingString:@"S|S1|"];
                    break;
                case kPlayTypeRed:
                    betCode = [betCode stringByAppendingString:@"S|H1|"];
                    break;
                case kPlayTypeRX2:
                    betCode = [betCode stringByAppendingString:@"S|R2|"];
                    break;
                case kPlayTypeRX3:
                    betCode = [betCode stringByAppendingString:@"S|R3|"];
                    break;
                case kPlayTypeRX4:
                    betCode = [betCode stringByAppendingString:@"S|R4|"];
                    break;
                case kPlayTypeRX5:
                    betCode = [betCode stringByAppendingString:@"S|R5|"];
                    break;
                case kPlayTypeX2Zhi:
                    betCode = [betCode stringByAppendingString:@"S|Q2|"];
                    break;
                case kPlayTypeX2Zu:
                    betCode = [betCode stringByAppendingString:@"S|Z2|"];
                    break;
                case kPlayTypeX3Zhi:
                    betCode = [betCode stringByAppendingString:@"S|Q3|"];
                    break;
                case kPlayTypeX3Zu:
                    betCode = [betCode stringByAppendingString:@"S|Z3|"];
                    break;
                default:
                    break;
            } 
        }
        if(kPlayTypeOne == m_playType)
        {
            for(int i = 0; i < nOneCount; i++)
            {
                int nValue = [[oneBalls objectAtIndex:i] intValue];
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                if (i == (nOneCount - 1))
                {
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
                }
                else
                {
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
                }
            }
        }
        else if(kPlayTypeRed == m_playType)
        {
            for(int i = 0; i < nOneRedCount; i++)
            {
                int nValue = [[oneRedBalls objectAtIndex:i] intValue];

                if (i == (nOneRedCount - 1))
                {
                    betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
                }
                else
                {
                    betCode = [betCode stringByAppendingFormat:@"%02d^", nValue];
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
                }
            }
        }
        else
        {
            for (int i = 0; i < nRedCount; i++)
            {
                int nValue = [[redBalls objectAtIndex:i] intValue];
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                if (i == (nRedCount - 1))
                {
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
                }
                else
                {
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
                }
            }
            if(kPlayTypeX2Zhi == m_playType || kPlayTypeX3Zhi == m_playType)
            {
                if(m_numZhu > 1)
                    betCode = [betCode stringByAppendingFormat:@"-"];
                disBetCode = [disBetCode stringByAppendingFormat:@"|"];
                for(int i = 0; i < nQianCount; i++)
                {
                    int nValue = [[qianBalls objectAtIndex:i] intValue];
                    betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                    if (i == (nQianCount - 1))
                    {
                        disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
                    }
                    else
                    {
                        disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
                    }
                }
                if(kPlayTypeX3Zhi == m_playType)
                {
                    if(m_numZhu > 1)
                        betCode = [betCode stringByAppendingFormat:@"-"];
                    disBetCode = [disBetCode stringByAppendingFormat:@"|"];
                    for(int i = 0; i < nBaiCount; i++)
                    {
                        int nValue = [[baiBalls objectAtIndex:i] intValue];
                        betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                        if (i == (nBaiCount - 1))
                        {
                            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
                        }
                        else
                        {
                            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
                        }
                    }
                }
            }
        }
        [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
		[RuYiCaiLotDetail sharedObject].sellWay = @"0";
	}
    else 
    {
        NSArray *danBalls = [self.ballViewDan selectedBallsArray];//胆码
		int nDanCount = [danBalls count];
		NSArray *tuoBalls = [self.ballViewTuo selectedBallsArray];//拖码
        int nTuoCount = [tuoBalls count];
        switch (drag_PlayType)
        {
            case kPlayTypeRX2_Dan:
                betCode = [betCode stringByAppendingString:@"D|R2|"];
                break;
            case kPlayTypeRX3_Dan:
                betCode = [betCode stringByAppendingString:@"D|R3|"];
                break;
            case kPlayTypeRX4_Dan:
                betCode = [betCode stringByAppendingString:@"D|R4|"];
                break;
            case kPlayTypeRX5_Dan:
                betCode = [betCode stringByAppendingString:@"D|R5|"];
                break;
            default:
                break;
        }
        for (int i = 0; i < nDanCount; i++)
		{
			int nValue = [[danBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
			if (i == (nDanCount - 1))
			{
				disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
			}
			else
			{
				disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
			}
		}
        betCode = [betCode stringByAppendingString:@"-"];
        disBetCode = [disBetCode stringByAppendingString:@"#"];
        for(int i = 0; i < nTuoCount; i++)
        {
            int nValue = [[tuoBalls objectAtIndex:i] intValue];
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            if (i == (nTuoCount - 1))
            {
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
            }
            else
            {
                disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
            }
        }
        [RuYiCaiLotDetail sharedObject].sellWay = @"0";
        [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
    }
    NSLog(@"betcode:%@",betCode);
    //生成投注基本信息
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoKLSF;
    
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_numZhu];
    
    //[[RuYiCaiNetworkManager sharedManager] showLotSubmitMessage:@"" withTitle:@"您的订单详情"];
    if(!isMoreBet)
        [self betNormal:nil];	
}

- (void)playTypeSet
{
    m_delegate.randomPickerView.delegate = self;
    if(kSegmentedDirect == self.segmentedView.segmentedIndex)
	{
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
        [m_delegate.randomPickerView setPickerDataArray:[NSArray arrayWithObjects:@"选一数投", @"选一红投", @"任选二", @"任选三", @"任选四", @"任选五", @"选二连直", @"选二连组", @"选三前直", @"选三前组",nil]];
        switch (m_playType) 
        {
            case kPlayTypeOne:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeOne withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRed:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRed withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRX2:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX2 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRX3:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX3 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRX4:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX4 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRX5:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX5 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeX2Zhi:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeX2Zhi withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeX2Zu:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeX2Zu withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeX3Zhi:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeX3Zhi withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeX3Zu:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeX3Zu withMinNum:0 andMaxNum:0];
                break;
            default:
                break;
        }
    }
    else
    {
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
        [m_delegate.randomPickerView setPickerDataArray:[NSArray arrayWithObjects:@"任选二", @"任选三", @"任选四", @"任选五", nil]];
        switch (drag_PlayType) 
        {
            case kPlayTypeRX2_Dan:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX2_Dan withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRX3_Dan:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX3_Dan withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRX4_Dan:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX4_Dan withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypeRX5_Dan:
                [m_delegate.randomPickerView setPickerNum:kPlayTypeRX5_Dan withMinNum:0 andMaxNum:0];
                break;
            default:
                break;
        }
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
    
    if(self.segmentedView.segmentedIndex == kSegmentedDirect || self.segmentedView.segmentedIndex == kSegmentedDrag)
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
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoKLSF;
    
    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"广东快乐十分";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
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
	viewController.navigationItem.title = @"广东快乐十分投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
	if(kSegmentedDirect == self.segmentedView.segmentedIndex)
	{
		m_playType = num;
        [self.buttonPlayType setTitle:[NSString stringWithFormat:@"%@", [m_delegate.randomPickerView.pickerNumArray objectAtIndex:num]] forState:UIControlStateNormal];
		[self pressedReselectButton:nil];
		[self updateSubViewsOfDirect];
        
//        [self getMissDateNet];
    }
    else
    {
        drag_PlayType = num;
        
		[self.dragPlayType setTitle:[NSString stringWithFormat:@"%@",[m_delegate.randomPickerView.pickerNumArray objectAtIndex:drag_PlayType]]
                           forState:UIControlStateNormal];
		[self pressedReselectButton:nil];
		[self updateSubViewsOfDrag];
        
//        [self getMissDateNet];
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
    viewController.lotNo = kLotNoKLSF;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleKLSF;
    viewController.lotNo = kLotNoKLSF;
    viewController.VRednumber = 20;
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
    viewController.lotTitle = kLotTitleKLSF;
    viewController.lotNo = kLotNoKLSF;
    viewController.VRednumber = 20;
    viewController.VBluenumber = 0;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController refreshLotteryAwardInfo];
    [viewController release];
    
}

#pragma mark NSTimer methods
- (void)updateInformation:(NSNotification*)notification
{
	NSTrace();    
	self.batchCode = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    self.batchEndTime = [[RuYiCaiNetworkManager sharedManager] highFrequencyLeftTime];
	m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",self.batchCode];
	//NSLog(@"%@,%@",self.batchCode,self.batchEndTime);
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
	//NSLog(@"11X5NSTimer^^^^^");
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
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"广东快乐十分 %@期时间已到，进入下一期" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
	    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoKLSF];
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoKLSF];//上期开奖

//        //重新获取遗漏值
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

//- (void)viewWillDisappear:(BOOL)animated {
//    [self resignFirstResponder];
//    [super viewWillDisappear:animated];
//}

//最后在你的view控制器中添加motionEnded：
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //直选普通
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentedDirect)
    {
        if ([m_ballViewOneDirect getSelectNum] == 0 && [m_ballViewRedDirect getSelectNum] == 0 && [m_ballViewDirect getSelectNum] == 0 && [m_ballViewDirect1000 getSelectNum] == 0 && [m_ballViewDirect100 getSelectNum] == 0) 
        {
            [self getYaoYiYaoNum];
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
            [self getYaoYiYaoNum];
            [self updateBallState:nil];
        }
    }
}

- (void) getYaoYiYaoNum
{
    switch (m_playType)
    {
        case kPlayTypeOne:
            [m_ballViewOneDirect randomBall:1];
            break;
        case kPlayTypeRed:
            [m_ballViewRedDirect randomBall:1];
            break;
        case kPlayTypeRX2:
            [m_ballViewDirect randomBall:2];
            break;
        case kPlayTypeRX3:
            [m_ballViewDirect randomBall:3];
            break;
        case kPlayTypeRX4:
            [m_ballViewDirect randomBall:4];
            break;
        case kPlayTypeRX5:
            [m_ballViewDirect randomBall:5];
            break;
        case kPlayTypeX2Zu:
            [m_ballViewDirect randomBall:2];
            break;
        case kPlayTypeX2Zhi:
        {
            [m_ballViewDirect randomBall:1];
            [m_ballViewDirect1000 randomBall:1];
            
            /*
             去掉 前后区 选球一样的情况
             */
            int DirectRandomNum = [[[self.ballViewDirect selectedBallsArray] objectAtIndex:0] intValue];
            int Direct1000RandomNum = [[[self.ballViewDirect1000 selectedBallsArray] objectAtIndex:0] intValue];
            while (DirectRandomNum == Direct1000RandomNum) {
                
                [m_ballViewDirect randomBall:1];
                [m_ballViewDirect1000 randomBall:1];
                
                DirectRandomNum = [[[self.ballViewDirect selectedBallsArray] objectAtIndex:0] intValue];
                Direct1000RandomNum = [[[self.ballViewDirect1000 selectedBallsArray] objectAtIndex:0] intValue];
            }
            break;
        }
        case kPlayTypeX3Zu:
            [m_ballViewDirect randomBall:3];
            break;
        case kPlayTypeX3Zhi:
        {
            [m_ballViewDirect randomBall:1];
            [m_ballViewDirect1000 randomBall:1];
            [m_ballViewDirect100 randomBall:1];
            
            int DirectRandomNum = [[[self.ballViewDirect selectedBallsArray] objectAtIndex:0] intValue];
            int Direct1000RandomNum = [[[self.ballViewDirect1000 selectedBallsArray] objectAtIndex:0] intValue];
            int Direct100RandomNum = [[[self.ballViewDirect100 selectedBallsArray] objectAtIndex:0] intValue];
            
            while (DirectRandomNum == Direct1000RandomNum || 
                   Direct1000RandomNum == Direct100RandomNum || 
                   DirectRandomNum == Direct100RandomNum  
                   )
            {
                [m_ballViewDirect randomBall:1];
                [m_ballViewDirect1000 randomBall:1];
                [m_ballViewDirect100 randomBall:1];
                DirectRandomNum = [[[self.ballViewDirect selectedBallsArray] objectAtIndex:0] intValue];
                Direct1000RandomNum = [[[self.ballViewDirect1000 selectedBallsArray] objectAtIndex:0] intValue];
                Direct100RandomNum = [[[self.ballViewDirect100 selectedBallsArray] objectAtIndex:0] intValue];
            }
            
            break;
        }
        default:
            break;
    }
}

//遗漏返回
- (void)getMissdateForServersWithPalyType:(NSString *)type{
//    NSArray *array = [NSArray arrayWithObjects:@"0", @"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
//    [self.ballViewOneDirect creatYiLuoViewWithData:array rowNumber:9];
//    [self.ballViewRedDirect creatYiLuoViewWithData:array rowNumber:2];
//    [self.ballViewDirect creatYiLuoViewWithData:array rowNumber:9];
//    [self.ballViewDirect1000 creatYiLuoViewWithData:array rowNumber:9];
//    [self.ballViewDirect100 creatYiLuoViewWithData:array rowNumber:9];
//    [self.ballViewDan creatYiLuoViewWithData:array rowNumber:9];
//    [self.ballViewTuo creatYiLuoViewWithData:array rowNumber:9];
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoKLSF sellWay:type];
}
- (void)getMissDateOK:(NSNotification*)notification{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].netMissDate];
    [jsonParser release];
    
    NSLog(@"%@",parserDict);
    
    if (kSegmentedDirect == self.segmentedView.segmentedIndex){
        switch (m_playType)
        {
            case kPlayTypeOne:
            {
                [self.ballViewOneDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:9];
                break;
            }
            case kPlayTypeRed:
            {
                [self.ballViewRedDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:2];
                
                break;
            }
            case kPlayTypeRX2:
            case kPlayTypeRX3:
            case kPlayTypeRX4:
            case kPlayTypeRX5:
            case kPlayTypeX2Zu:
            case kPlayTypeX3Zu:
            {
                [self.ballViewDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:9];
                
                break;
            }
            case kPlayTypeX2Zhi:
            {
                [self.ballViewDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:9];
                [self.ballViewDirect1000 creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:9];
                break;
            }
            case kPlayTypeX3Zhi:
            {
                [self.ballViewDirect creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"ge"] rowNumber:9];
                [self.self.ballViewDirect100 creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"shi"] rowNumber:9];
                [self.self.ballViewDirect1000 creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"bai"] rowNumber:9];
                break;
            }
            default:
                break;
        }
    }else{
        switch (drag_PlayType) {
            case kPlayTypeRX2_Dan:
            case kPlayTypeRX3_Dan:
            case kPlayTypeRX4_Dan:
            case kPlayTypeRX5_Dan:
                
                [self.ballViewDan creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:9];
                [self.ballViewTuo creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:9];
                
                
                break;
            default:
                break;
        }
        
    }
    

   
}

#pragma mark -CustomerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    
    [self segmentedChangeValue:index];
    
}

@end
