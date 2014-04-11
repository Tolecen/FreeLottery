//
//  GZ11X5_PickNumberViewController.m
//  RuYiCai
//
//  Created by  on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GZ11X5_PickNumberViewController.h"
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

#define kMissDateIndexRX   (0)
#define kMissDateIndexQ3   (1)
#define kMissDateIndexQ2Z  (2)
#define kMissDateIndexQ3Z  (3)

#define kPerMinuteTimeInterval (60.0)

@interface GZ11X5_PickNumberViewController (internal)

- (void)newThreadRun;
- (void)setupNavigationBar;
- (void)setupSubViewsOfDirectGroup;
- (void)updateSubViewsOfDirect;

//- (void)setupSubViewsOfRandomGroup;

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
//- (void)refreshRandomTableView;
//- (void)randomNumSet;
- (void)playTypeSet;


- (void)refreshLeftTime;

- (void)getMissDateOK:(NSNotification*)notification;
- (void)refreshMissView;
- (void)getMissDateNet;
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
@end

@implementation GZ11X5_PickNumberViewController

@synthesize scrollDirect = m_scrollDirect;
@synthesize bottomScrollView = m_bottomScrollView;
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
@synthesize recoderYiLuoDateArr = m_recoderYiLuoDateArr;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMissDateOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];

//    [m_detailButton removeFromSuperview];
//    [m_backButton removeFromSuperview];

    [self resignFirstResponder];
	[super viewWillDisappear:animated];
}


- (void)dealloc
{
    m_delegate.randomPickerView.delegate = nil;

//    [m_backButton release];

	[m_playTypeArray release], m_playTypeArray = nil;
	[m_scrollDirect release];
	[m_buttonPlayType release];
	[m_selectedCount release];
	[m_scrollRandom release];
	[m_segmented release];
    [m_segmentedView release];
    
    [m_buttonBuy release];
    [m_buttonReselect release];
 
    [m_ballViewDirect release];
	[m_ballViewDirect1000 release];
    [m_ballViewDirect100 release];
	
	[m_wanLable release];
	[m_qianLable release];
	[m_baiLable release];
	
 
    [m_totalCost release];
	
	[m_leftTimeLabel release];
	[m_batchCodeLabel release];
    
    [m_recoderYiLuoDateArr release], m_recoderYiLuoDateArr = nil;
    //[oneNetArr release];
	
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMissDateOK:) name:@"getMissDateOK" object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLottery:) name:@"updateLottery" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoGD115];//上期开奖

    [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiry:kLotNoGD115];
    
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
//    [MobClick event:@"GPC_selectPage"];
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
    [self.view addSubview:m_segmentedView];
    isMoreBet = NO;
    m_allZhuShu = 0;
    
    oneRefreshDragYiLuo = YES;
    
    self.scrollDirect.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);
    self.scrollDrag.frame = CGRectMake(0, 90, 320, [UIScreen mainScreen].bounds.size.height - 240);

    
	m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
        
	m_playTypeArray = [[NSArray alloc]initWithObjects:@"任选二",@"任选三",@"任选四",@"任选五",@"任选六",
					   @"任选七",@"任选八",@"前一直选",@"前二组选",@"前二直选",@"前三组选",@"前三直选",nil];
    [self newThreadRun];
	
//    self.scrollDirect.contentSize = CGSizeMake(320, 600);

    [self.segmented addTarget:self action:@selector(segmentedChangeValue) forControlEvents:UIControlEventValueChanged];
    self.segmentedView.segmentedIndex = 0;
    [self segmentedChangeValue];
    
    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];    
}

- (void)newThreadRun
{
    //初始化直选、机选
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
    
    NSDictionary *startDic = [[NSDictionary alloc] init];
    m_recoderYiLuoDateArr = [[NSMutableArray alloc] initWithObjects:startDic, startDic, startDic, startDic, nil];
    [startDic release];
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_RX"];
    //oneNetArr = [[NSMutableArray alloc] initWithObjects:@"1",@"0",@"0",@"0", nil];
    
//    [self setDetailView];
    
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
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoGD115;
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
    [pickNumberView randomPickerView:m_delegate.randomPickerView selectRowNum:5];
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
    [viewController setSelectLotNo:kLotNoGD115];
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
    m_playType = kPlayType5;
    m_buttonPlayType = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 85, 20)];
    [self.buttonPlayType setBackgroundImage:RYCImageNamed(@"list_c_normal.png") forState:UIControlStateNormal];
    [self.buttonPlayType setBackgroundImage:RYCImageNamed(@"list_c_click.png") forState:UIControlStateHighlighted];
	[self.buttonPlayType setTitle:[m_playTypeArray objectAtIndex:m_playType] forState:UIControlStateNormal];
    [self.buttonPlayType setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
	self.buttonPlayType.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.buttonPlayType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buttonPlayType addTarget:self action:@selector(playTypeSet) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollDirect addSubview:self.buttonPlayType];
	
    //奖金描述
    m_winDescribtionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    m_winDescribtionLable.text = @"至少选择2个号码投注，命中任意2 位即中奖！";
    m_winDescribtionLable.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable.numberOfLines = 2;
    m_winDescribtionLable.textColor = [UIColor redColor];
    [self.scrollDirect addSubview:m_winDescribtionLable];
    
    //奖金：6元
    m_winMonneyLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 15)];
    m_winMonneyLable.text = @"奖金：6元";
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
	m_wanLable.text = @"万位 ：（请至少选择1个球）";
	m_wanLable.textAlignment = UITextAlignmentLeft;
    m_wanLable.backgroundColor = [UIColor clearColor];
    m_wanLable.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_wanLable];
	
	CGRect frameRedBall = CGRectMake((320- (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                     kLabelHeight + 50 + 45, 
                                     9 * (kBallRectWidth + kBallVerticalSpacing), 
                                     (kBallRectHeight + kBallLineSpacing+ kYiLuoHeight) * 2);
    m_ballViewDirect = [[PickBallViewController alloc] init];
    self.ballViewDirect.isHasYiLuo = YES;
	[self.ballViewDirect createBallArray:11 withPerLine:9 startValue:1 selectBallCount:1];
	[self.ballViewDirect setBallType:RED_BALL];
	self.ballViewDirect.view.frame = frameRedBall;
	[self.scrollDirect addSubview:self.ballViewDirect.view];
    
	m_qianLable = [[UILabel alloc] initWithFrame:CGRectMake(10, frameRedBall.origin.y + (kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2, 310, kLabelHeight)];
	m_qianLable.text = @"千位：（请至少选择1个球）";
	m_qianLable.textAlignment = UITextAlignmentLeft;
    m_qianLable.backgroundColor = [UIColor clearColor];
    m_qianLable.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_qianLable];
	
	CGRect frameRedBall1000 = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                         kLabelHeight + frameRedBall.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2, 
                                         9 * (kBallRectWidth + kBallVerticalSpacing), 
                                         (kBallRectHeight + kBallLineSpacing+ kYiLuoHeight) * 2);
    m_ballViewDirect1000 = [[PickBallViewController alloc] init];
    self.ballViewDirect1000.isHasYiLuo = YES;
    [self.ballViewDirect1000 createBallArray:11 withPerLine:9 startValue:1 selectBallCount:1];
	//[self.ballViewDirect1000 setSelectMaxNum:11];
	[self.ballViewDirect1000 setBallType:RED_BALL];
	self.ballViewDirect1000.view.frame = frameRedBall1000;
	[self.scrollDirect addSubview:self.ballViewDirect1000.view];
	
	m_baiLable = [[UILabel alloc] initWithFrame:CGRectMake(10, frameRedBall1000.origin.y + (kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2, 310, kLabelHeight)];
	m_baiLable.text = @"百位 ：（请至少选择1个球）";
	m_baiLable.textAlignment = UITextAlignmentLeft;
    m_baiLable.backgroundColor = [UIColor clearColor];
    m_baiLable.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDirect addSubview:m_baiLable];
	
	CGRect frameRedBall100 = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                        kLabelHeight + frameRedBall1000.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2, 
                                        9 * (kBallRectWidth + kBallVerticalSpacing), 
                                        (kBallRectHeight + kBallLineSpacing + kYiLuoHeight) * 2);
    m_ballViewDirect100 = [[PickBallViewController alloc] init];
    self.ballViewDirect100.isHasYiLuo = YES;
	[self.ballViewDirect100 createBallArray:11 withPerLine:9 startValue:1 selectBallCount:1];
	[self.ballViewDirect100 setSelectMaxNum:11];
	[self.ballViewDirect100 setBallType:RED_BALL];
	self.ballViewDirect100.view.frame = frameRedBall100;
	[self.scrollDirect addSubview:self.ballViewDirect100.view];
	
 
	self.scrollDirect.contentSize = CGSizeMake(320,  frameRedBall100.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2);
    self.scrollDirect.scrollEnabled = YES;
	[self updateSubViewsOfDirect];
}

- (void)updateSubViewsOfDirect
{	
	switch (m_playType)
	{
		case kPlayType1:
		{	
			self.ballViewDirect.m_selectBallCount = 1;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择1个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayType2:
		{
			self.ballViewDirect.m_selectBallCount = 2;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择2个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayType3:
		{
			self.ballViewDirect.m_selectBallCount = 3;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择3个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayType4:
		{
			self.ballViewDirect.m_selectBallCount = 4;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择4个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayType5:
		{
			self.ballViewDirect.m_selectBallCount = 5;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择5个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;	       
			[self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayType6:
		{
			self.ballViewDirect.m_selectBallCount = 6;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择6个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayType7:
		{
			self.ballViewDirect.m_selectBallCount = 7;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择7个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayType8:
		{
			self.ballViewDirect.m_selectBallCount = 8;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择8个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayTypezu2:
		{
			self.ballViewDirect.m_selectBallCount = 2;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择2个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayTypezhi2:
		{
			self.ballViewDirect.m_selectBallCount = 1;
			m_selectedCount.hidden = YES;
			m_wanLable.hidden = NO;
			m_qianLable.hidden = NO;
			self.ballViewDirect1000.view.hidden = NO;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
			[self.ballViewDirect1000 setSelectMaxNum:11];
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayTypezu3:
		{
			self.ballViewDirect.m_selectBallCount = 3;
			m_selectedCount.hidden = NO;
			m_selectedCount.text = @"球区：（请至少选择3个球）";
			m_wanLable.hidden = YES;
			m_qianLable.hidden = YES;
			self.ballViewDirect1000.view.hidden = YES;
			m_baiLable.hidden = YES;
			self.ballViewDirect100.view.hidden = YES;
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}
		case kPlayTypezhi3:
		{
			self.ballViewDirect.m_selectBallCount = 1;
			m_selectedCount.hidden = YES;
			m_wanLable.hidden = NO;
			m_qianLable.hidden = NO;
			self.ballViewDirect1000.view.hidden = NO;
			m_baiLable.hidden = NO;
			self.ballViewDirect100.view.hidden = NO;
			[self.ballViewDirect1000 setSelectMaxNum:11];
	        [self.ballViewDirect setSelectMaxNum:11];
			break;
		}	
		default:
			break;
	}
    NSArray* arrayDes = kwinDescribtionArray_direct;
    NSArray* arrayWMonney = kwinMonneyArray_direct;
    
    m_winDescribtionLable.text = [arrayDes objectAtIndex:m_playType];
    m_winMonneyLable.text = [arrayWMonney objectAtIndex:m_playType];
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
    drag_PlayType = kPlayType5;
    m_dragPlayType = [[UIButton alloc] initWithFrame:CGRectMake(60, 15, 85, 20)];
    [self.dragPlayType setBackgroundImage:RYCImageNamed(@"list_c_normal.png") forState:UIControlStateNormal];
    [self.dragPlayType setBackgroundImage:RYCImageNamed(@"list_c_click.png") forState:UIControlStateHighlighted];
	[self.dragPlayType setTitle:[m_playTypeArray objectAtIndex:drag_PlayType] forState:UIControlStateNormal];
    [self.dragPlayType setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 35)];
	self.dragPlayType.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.dragPlayType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.dragPlayType addTarget:self action:@selector(playTypeSet) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollDrag addSubview:self.dragPlayType];
    
    //奖金描述
    m_winDescribtionLable_dan = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 300, 30)];
    m_winDescribtionLable_dan.text = @"至少选择2个号码投注，命中任意2 位即中奖！";
    m_winDescribtionLable_dan.font = [UIFont systemFontOfSize:12];
    m_winDescribtionLable_dan.textAlignment = UITextAlignmentLeft;
    m_winDescribtionLable_dan.backgroundColor = [UIColor clearColor];
    m_winDescribtionLable_dan.lineBreakMode = UILineBreakModeWordWrap;
    m_winDescribtionLable_dan.numberOfLines = 2;
    m_winDescribtionLable_dan.textColor = [UIColor redColor];
    [self.scrollDrag addSubview:m_winDescribtionLable_dan];
    
    //奖金：6元
    m_winMonneyLable_dan = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 15)];
    m_winMonneyLable_dan.text = @"奖金：6元";
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
                                     (kBallRectHeight + kBallLineSpacing + kYiLuoHeight) * 2);
    m_ballViewDan = [[PickBallViewController alloc] init];
    self.ballViewDan.isHasYiLuo = YES;
	[self.ballViewDan createBallArray:11 withPerLine:9 startValue:1 selectBallCount:1];
	[self.ballViewDan setBallType:RED_BALL];
	self.ballViewDan.view.frame = frameRedBall;
	[self.scrollDrag addSubview:self.ballViewDan.view];
    
	m_tuoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frameRedBall.origin.y + (kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2, 310, kLabelHeight)];
	m_tuoLabel.text = @"拖码：";
	m_tuoLabel.textAlignment = UITextAlignmentLeft;
    m_tuoLabel.backgroundColor = [UIColor clearColor];
    m_tuoLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.scrollDrag addSubview:m_tuoLabel];
	
	CGRect frameRedBall1000 = CGRectMake((320 - (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2, 
                                         kLabelHeight + frameRedBall.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2, 
                                         9 * (kBallRectWidth + kBallVerticalSpacing), 
                                         (kBallRectHeight + kBallLineSpacing + kYiLuoHeight) * 2);
    m_ballViewTuo = [[PickBallViewController alloc] init];
    self.ballViewTuo.isHasYiLuo = YES;
    [self.ballViewTuo createBallArray:11 withPerLine:9 startValue:1 selectBallCount:2];
	//[self.ballViewTuo setSelectMaxNum:10];
	[self.ballViewTuo setBallType:RED_BALL];
	self.ballViewTuo.view.frame = frameRedBall1000;
	[self.scrollDrag addSubview:self.ballViewTuo.view];
    
    self.scrollDrag.contentSize = CGSizeMake(320, frameRedBall1000.origin.y+(kBallRectHeight + kBallLineSpacing + kYiLuoHeight)*2);
    self.scrollDrag.scrollEnabled = YES;
	[self updateSubViewsOfDrag];
    
}

- (void)updateSubViewsOfDrag
{
    switch (drag_PlayType) {
        case kPlayType2:
            m_danLabel.text = @"胆码（只能选1个球）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:1];
            [self.ballViewTuo setSelectMaxNum:10];
            break;
        case kPlayType3:
            m_danLabel.text = @"胆码（选1-2个球,胆码加拖码个数大于3）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:2];
            [self.ballViewTuo setSelectMaxNum:10];
            break;    
        case kPlayType4:
            m_danLabel.text = @"胆码（选1-3个球,胆码加拖码个数大于4）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:3];
            [self.ballViewTuo setSelectMaxNum:10];
            break;
        case kPlayType5:
            m_danLabel.text = @"胆码（选1-4个球,胆码加拖码个数大于5）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:4];
            [self.ballViewTuo setSelectMaxNum:10];
            break;
        case kPlayType6:
            m_danLabel.text = @"胆码（选1-5个球,胆码加拖码个数大于6）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:5];
            [self.ballViewTuo setSelectMaxNum:10];
            break;
        case kPlayType7:
            m_danLabel.text = @"胆码（选1-6个球,胆码加拖码个数大于7）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:6];
            [self.ballViewTuo setSelectMaxNum:10];
            break;
        case 6:
            m_danLabel.text = @"胆码（只能选1个球）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:1];
            [self.ballViewTuo setSelectMaxNum:10];
            break;
        case 7:
            m_danLabel.text = @"胆码（选1-2个球,胆码加拖码个数大于3）：";
            m_tuoLabel.text = @"拖码（选2-10个球）：";
            [self.ballViewDan setSelectMaxNum:2];
            [self.ballViewTuo setSelectMaxNum:10];
            break;
        default:
            break;
    }
    NSArray* arrayDes = kwinDescribtionArray_dantuo;
    NSArray* arrayWMonney = kwinMonneyArray_dantuo;
    
    m_winDescribtionLable_dan.text = [arrayDes objectAtIndex:drag_PlayType];
    m_winMonneyLable_dan.text = [arrayWMonney objectAtIndex:drag_PlayType];
}

- (void)segmentedChangeValue
{
	if (kSegmentedDirect == self.segmentedView.segmentedIndex)
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
            [self refreshMissView];
            oneRefreshDragYiLuo = NO;
        }   
    }
    [self updateBallState:nil];
}
- (void)segmentedChangeValue:(int)index{
    if (kSegmentedDirect == index)
    {
        m_playType = kPlayType5;
        [self.buttonPlayType setTitle:@"任选五" forState:UIControlStateNormal];
        [self updateSubViewsOfDirect];
		self.scrollDirect.hidden = NO;
        self.scrollDrag.hidden = YES;
	}
    else
    {
        drag_PlayType = kPlayType5;
        [self.dragPlayType setTitle:@"任选五" forState:UIControlStateNormal];
        [self.ballViewDan creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexRX] objectForKey:@"miss"] rowNumber:9];
        [self.ballViewTuo creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexRX] objectForKey:@"miss"] rowNumber:9];
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
    [self.ballViewDirect clearBallState];
    [self.ballViewDirect1000 clearBallState];
    [self.ballViewDirect100 clearBallState];
    [self.ballViewDan clearBallState];
    [self.ballViewTuo clearBallState];
    [self updateBallState:nil];
}

- (void)updateBallState:(NSNotification*)notification
{
//    NSTrace();

    m_detailView.hidden = YES;
    
    NSString* totalStr = @"";
    
	NSInteger baseBallCount = 0;
	//static int markLastCount;
    m_numZhu = 0;
    m_numCost = 0;
    
    if (kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
	    if(kPlayTypezhi2 != m_playType && kPlayTypezhi3 != m_playType)
		{
			NSArray *balls = [self.ballViewDirect selectedBallsArray];
			int nBalls = [balls count];
			
			switch (m_playType) 
			{
				case kPlayType1:
					baseBallCount = 1;
					break;
				case kPlayType2:
					baseBallCount = 2;
					break;
				case kPlayType3:
					baseBallCount = 3;
					break;
				case kPlayType4:
					baseBallCount = 4;
					break;
				case kPlayType5:
					baseBallCount = 5;
					break;
				case kPlayType6:
					baseBallCount = 6;
					break;
				case kPlayType7:
					baseBallCount = 7;
					break;
				case kPlayType8:
					baseBallCount = 8;
					break;
				case kPlayTypezu2:
					baseBallCount = 2;
					break;
				case kPlayTypezu3:
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
                [alreaderLabel setHidden:NO];
                totalStr = @"摇一摇可以机选一注";
            }
            else
            {
                m_totalCost.textColor = [UIColor  blackColor];
                m_totalCost.frame = CGRectMake(5,7,132,21);
                [alreaderLabel setHidden:YES];
                int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
                totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
            }
		}
		else//直2 直3
		{
			NSMutableArray *wBalls = [self.ballViewDirect selectedBallsArray];
//			int nWBalls = [wBalls count];
			NSMutableArray *qBalls = [self.ballViewDirect1000 selectedBallsArray];
//			int nQBalls = [qBalls count];
			NSMutableArray *bBalls = [self.ballViewDirect100 selectedBallsArray];
//			int nBBalls = [bBalls count];
            
			//各区没有相同球
//			NSObject *obj = [notification object];
//			if ([obj isKindOfClass:[NSDictionary class]])
//			{
//				NSDictionary *dict = (NSDictionary*)obj;
//				PickBallViewController *ballView = [dict objectForKey:@"ballView"];
//				if(ballView == self.ballViewDirect) //判断消息的发送者
//				{
//					for(int i = 0;i < nWBalls; i++)
//					{
//						for(int j =0;j <nQBalls; j++)
//						{
//							if([[qBalls objectAtIndex:j] isEqual:[wBalls objectAtIndex:i]])
//							{
//								[self.ballViewDirect1000 resetStateForIndex:[[qBalls objectAtIndex:j]intValue]-1];
//								[qBalls removeObjectAtIndex:j];
//								nQBalls -= 1;
//							}
//						}
//						for(int k = 0;k <nBBalls; k++)
//						{
//							if([[bBalls objectAtIndex:k] isEqual:[wBalls objectAtIndex:i]])
//							{
//								[self.ballViewDirect100 resetStateForIndex:[[bBalls objectAtIndex:k]intValue]-1];
//								[bBalls removeObjectAtIndex:k];
//								nBBalls -= 1; 
//							}
//						}
//					}
//				}
//				else if(ballView == self.ballViewDirect1000)
//				{
//					for(int i = 0;i < nQBalls; i++)
//					{
//						for(int j =0;j < nWBalls; j++)
//						{
//							if([[wBalls objectAtIndex:j] isEqual:[qBalls objectAtIndex:i]])
//		                    {
//								[self.ballViewDirect resetStateForIndex:[[wBalls objectAtIndex:j]intValue]-1];
//								[wBalls removeObjectAtIndex:j];
//								nWBalls -= 1;
//							}
//						}
//						for(int k = 0;k <nBBalls; k++)
//						{
//							if([[bBalls objectAtIndex:k] isEqual:[qBalls objectAtIndex:i]])
//							{
//								[self.ballViewDirect100 resetStateForIndex:[[bBalls objectAtIndex:k]intValue]-1];
//								[bBalls removeObjectAtIndex:k];
//								nBBalls -= 1;
//							}
//						}
//					}
//				}
//				else if(ballView == self.ballViewDirect100)
//				{
//					for(int i = 0;i < nBBalls; i++)
//					{
//						for(int j =0 ;j < nWBalls; j++)
//						{
//							if([[wBalls objectAtIndex:j] isEqual:[bBalls objectAtIndex:i]])
//		                    {
//								[self.ballViewDirect resetStateForIndex:[[wBalls objectAtIndex:j]intValue]-1];
//								[wBalls removeObjectAtIndex:j];
//								nWBalls -= 1;
//							}
//						}
//						for(int k = 0;k <nQBalls; k++)
//						{
//							if([[qBalls objectAtIndex:k] isEqual:[bBalls objectAtIndex:i]])
//							{
//								[self.ballViewDirect1000 resetStateForIndex:[[qBalls objectAtIndex:k]intValue]-1];
//								[qBalls removeObjectAtIndex:k];
//								nQBalls -= 1;
//							}
//						}
//					}
//				}
//			}
 
            //选前2直
			if(kPlayTypezhi2 == m_playType)
			{
//			    m_numZhu = RYCChoose(1, nWBalls) * RYCChoose(1, nQBalls);
//                m_numZhu = numZhuZhiWithDic([NSDictionary dictionaryWithObjects:@[wBalls, qBalls] forKeys:@[kWangWeiKey, kQianWeiKey]]);
                
                m_numZhu = numZhuZhiWithDic(@{kWangWeiKey:wBalls, kQianWeiKey:qBalls});
			}
            else//选前3直
			{
//				m_numZhu = RYCChoose(1, nWBalls) * RYCChoose(1, nQBalls) * RYCChoose(1, nBBalls);
                m_numZhu = numZhuZhiWithDic(@{kWangWeiKey:wBalls, kQianWeiKey:qBalls, kBaiWeiKey:bBalls});
			}
            m_numCost = m_numZhu * 2;
            if (m_numZhu == 0) {
                self.totalCost.textColor = [UIColor redColor];
                m_totalCost.frame = CGRectMake(45,7,132,21);
                [alreaderLabel setHidden:NO];
                totalStr = @"摇一摇可以机选一注";
            }
            else
            {
                self.totalCost.textColor = [UIColor blackColor];
                m_totalCost.frame = CGRectMake(5,7,132,21);
                [alreaderLabel setHidden:YES];
                int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
                totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
            }
        }		
	}
    else if(kSegmentedDrag == self.segmentedView.segmentedIndex)
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
            case kPlayType2:
            case kPlayType3:
            case kPlayType4:
            case kPlayType5:
            case kPlayType6:
            case kPlayType7:
                baseBallCount = drag_PlayType + 2;
                break;
            case 6:
                baseBallCount = 2;
                break;
            case 7:
                baseBallCount = 3;
                break;
            default:
                break;
        }
        if(nTuoBalls >= 2 && nDanBalls >=1 && (nTuoBalls + nDanBalls) > baseBallCount)
        {
            m_numZhu = RYCChoose(baseBallCount - nDanBalls, nTuoBalls);
            m_numCost = m_numZhu * 2;
            self.totalCost.textColor = [UIColor blackColor];
            m_totalCost.frame = CGRectMake(5,7,132,21);
            [alreaderLabel setHidden:YES];
            int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
            totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
        }
        else
        {
            m_numZhu = 0;
            m_numCost = m_numZhu * 2;
            m_totalCost.frame = CGRectMake(5,7,132,21);
            [alreaderLabel setHidden:YES];
            self.totalCost.textColor = [UIColor blackColor];
            int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
            totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 彩豆", m_numZhu, m_numCost*aas];
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
        NSArray *redBalls = [self.ballViewDirect selectedBallsArray];//高位
		int nRedCount = [redBalls count];
		NSArray *qianBalls = [self.ballViewDirect1000 selectedBallsArray];//中位
		int nQianCount = [qianBalls count];
		NSArray *baiBalls = [self.ballViewDirect100 selectedBallsArray];//低位
		int nBaiCount = [baiBalls count];
        if(m_numZhu > 1 || (m_numZhu == 1 && (nRedCount > 1 || nQianCount > 1 || nBaiCount > 1)))//复式投
       {
            if(m_playType == kPlayTypezhi2 || m_playType == kPlayTypezhi3)
                betCode = [betCode stringByAppendingString:@"P|"];
            else
                if (nRedCount>2)
                {
//                    betCode = [betCode stringByAppendingString:@"M|"];
                    betCode = [betCode stringByAppendingString:@"S|"];
                }
           else
           {
               betCode = [betCode stringByAppendingString:@"S|"];

           }
           
        }
        else//单式
        {
            if(m_playType == kPlayType1)
                betCode = [betCode stringByAppendingString:@"M|"];
            else
                betCode = [betCode stringByAppendingString:@"S|"];
        }
        switch (m_playType)
        {
            case kPlayType1:
                betCode = [betCode stringByAppendingString:@"R1|"];
                break;
            case kPlayType2:
                betCode = [betCode stringByAppendingString:@"R2|"];
                break;
            case kPlayType3:
                betCode = [betCode stringByAppendingString:@"R3|"];
                break;
            case kPlayType4:
                betCode = [betCode stringByAppendingString:@"R4|"];
                break;
            case kPlayType5:
                betCode = [betCode stringByAppendingString:@"R5|"];
                break;
            case kPlayType6:
                betCode = [betCode stringByAppendingString:@"R6|"];
                break;
            case kPlayType7:
                betCode = [betCode stringByAppendingString:@"R7|"];
                break;
            case kPlayType8:
                betCode = [betCode stringByAppendingString:@"R8|"];
                break;
            case kPlayTypezu2:
                betCode = [betCode stringByAppendingString:@"Z2|"];
                break;
            case kPlayTypezhi2:
                betCode = [betCode stringByAppendingString:@"Q2|"];
                break;
            case kPlayTypezu3:
                betCode = [betCode stringByAppendingString:@"Z3|"];
                break;
            case kPlayTypezhi3:
                betCode = [betCode stringByAppendingString:@"Q3|"];
                break;
            default:
                break;
        } 
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
        
        if (kPlayTypezhi2 == m_playType)
        {
            if(m_numZhu > 1 || (m_numZhu == 1 && (nRedCount > 1 || nQianCount > 1 || nBaiCount)))
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
        }
        
		if(kPlayTypezhi3 == m_playType)
		{
            if((m_numZhu == 1 && (nRedCount > 1 || nQianCount > 1 || nBaiCount)))
            {
                
            }else
            {
               betCode = [betCode stringByAppendingFormat:@"-"]; 
            }
			    
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
			if(kPlayTypezhi3 == m_playType)
			{
                if((m_numZhu == 1 && (nRedCount > 1 || nQianCount > 1 || nBaiCount)))
                {
                    
                }else
                {
                    betCode = [betCode stringByAppendingFormat:@"-"];
                }
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
            case kPlayType2:
                betCode = [betCode stringByAppendingString:@"D|R2|"];
                break;
            case kPlayType3:
                betCode = [betCode stringByAppendingString:@"D|R3|"];
                break;
            case kPlayType4:
                betCode = [betCode stringByAppendingString:@"D|R4|"];
                break;
            case kPlayType5:
                betCode = [betCode stringByAppendingString:@"D|R5|"];
                break;
            case kPlayType6:
                betCode = [betCode stringByAppendingString:@"D|R6|"];
                break;
            case kPlayType7:
                betCode = [betCode stringByAppendingString:@"D|R7|"];
                break;
            case 6:
                betCode = [betCode stringByAppendingString:@"D|Z2|"];
                break;
            case 7:
                betCode = [betCode stringByAppendingString:@"D|Z3|"];
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
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoGD115;
    
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
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:P11X5_TYPE];
        switch (m_playType) 
        {
            case kPlayType1:
                [m_delegate.randomPickerView setPickerNum:kPlayType1 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType2:
                [m_delegate.randomPickerView setPickerNum:kPlayType2 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType3:
                [m_delegate.randomPickerView setPickerNum:kPlayType3 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType4:
                [m_delegate.randomPickerView setPickerNum:kPlayType4 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType5:
                [m_delegate.randomPickerView setPickerNum:kPlayType5 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType6:
                [m_delegate.randomPickerView setPickerNum:kPlayType6 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType7:
                [m_delegate.randomPickerView setPickerNum:kPlayType7 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType8:
                [m_delegate.randomPickerView setPickerNum:kPlayType8 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypezu2:
                [m_delegate.randomPickerView setPickerNum:kPlayTypezu2 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypezhi2:
                [m_delegate.randomPickerView setPickerNum:kPlayTypezhi2 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypezu3:
                [m_delegate.randomPickerView setPickerNum:kPlayTypezu3 withMinNum:0 andMaxNum:0];
                break;
            case kPlayTypezhi3:
                [m_delegate.randomPickerView setPickerNum:kPlayTypezhi3 withMinNum:0 andMaxNum:0];
                break;
            default:
                break;
        }
    }
    else
    {
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:DRAG11YDJ_TYPE];
        switch (drag_PlayType) 
        {
            case kPlayType2:
                [m_delegate.randomPickerView setPickerNum:kPlayType2 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType3:
                [m_delegate.randomPickerView setPickerNum:kPlayType3 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType4:
                [m_delegate.randomPickerView setPickerNum:kPlayType4 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType5:
                [m_delegate.randomPickerView setPickerNum:kPlayType5 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType6:
                [m_delegate.randomPickerView setPickerNum:kPlayType6 withMinNum:0 andMaxNum:0];
                break;
            case kPlayType7:
                [m_delegate.randomPickerView setPickerNum:kPlayType7 withMinNum:0 andMaxNum:0];
                break;
            case 6:
                [m_delegate.randomPickerView setPickerNum:6 withMinNum:0 andMaxNum:0];
                break;
            case 7:
                [m_delegate.randomPickerView setPickerNum:7 withMinNum:0 andMaxNum:0];
                break;
            default:
                break;
        }
    }
}

#pragma mark getmissDate
- (void)getMissDateOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].netMissDate];
    [jsonParser release];
    
    if(kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        if (m_playType == kPlayTypezhi2 || m_playType == kPlayTypezhi3 || m_playType == kPlayType1)
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ3 withObject:[parserDict objectForKey:@"result"]];
        }
        else if (m_playType == kPlayTypezu2)
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ2Z withObject:[parserDict objectForKey:@"result"]];
        }
        else if(m_playType == kPlayTypezu3)
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ3Z withObject:[parserDict objectForKey:@"result"]];
        }
        else
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexRX withObject:[parserDict objectForKey:@"result"]];
        }
    }
    else//胆拖
    {
        if (drag_PlayType == 6)
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ2Z withObject:[parserDict objectForKey:@"result"]];
        }
        else if(drag_PlayType == 7)
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ3Z withObject:[parserDict objectForKey:@"result"]];
        }
        else
        {
            [self.recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexRX withObject:[parserDict objectForKey:@"result"]];
        }
    }
    
    [self refreshMissView];
}

- (void)refreshMissView
{
    if(kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        switch (m_playType)
        {
            case kPlayType2:
            case kPlayType3:
            case kPlayType4:
            case kPlayType5:
            case kPlayType6:
            case kPlayType7:
            case kPlayType8:
            {
                [self.ballViewDirect creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexRX] objectForKey:@"miss"] rowNumber:9];
            }break; 
            case kPlayType1://选前一
            case kPlayTypezhi2:
            case kPlayTypezhi3:
            {
                [self.ballViewDirect creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3] objectForKey:@"bai"] rowNumber:9];
                [self.ballViewDirect1000 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3] objectForKey:@"shi"] rowNumber:9];
                [self.ballViewDirect100 creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3] objectForKey:@"ge"] rowNumber:9];
            }break;
            case kPlayTypezu2:
            {
                [self.ballViewDirect creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ2Z] objectForKey:@"miss"] rowNumber:9];
            }break;
            case kPlayTypezu3:
            {
                [self.ballViewDirect creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3Z] objectForKey:@"miss"] rowNumber:9];
            }break;
            default:
                break;
        }
    }
    else
    {
        switch (drag_PlayType)
        {
            case kPlayType2:
            case kPlayType3:
            case kPlayType4:
            case kPlayType5:
            case kPlayType6:
            case kPlayType7:
            {
                [self.ballViewDan creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexRX] objectForKey:@"miss"] rowNumber:9];
                [self.ballViewTuo creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexRX] objectForKey:@"miss"] rowNumber:9];
            }break; 
            case 6:
            {
                [self.ballViewDan creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ2Z] objectForKey:@"miss"] rowNumber:9];
                [self.ballViewTuo creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ2Z] objectForKey:@"miss"] rowNumber:9];
            }break;
            case 7:
            {
                [self.ballViewDan creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3Z] objectForKey:@"miss"] rowNumber:9];
                [self.ballViewTuo creatYiLuoViewWithData:[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3Z] objectForKey:@"miss"] rowNumber:9];
            }break;
            default:
                break;
        }
    }
}

- (void)getMissDateNet
{
    if(kSegmentedDirect == self.segmentedView.segmentedIndex)
    {
        if (m_playType == kPlayTypezhi2 || m_playType == kPlayTypezhi3 || m_playType == kPlayType1)
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_Q3"];
            }
            else
            {
                [self refreshMissView];
            }
        }
        else if (m_playType == kPlayTypezu2)
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ2Z] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_Q2Z"];
            }
            else
            {
                [self refreshMissView];
            }
        }
        else if(m_playType == kPlayTypezu3)
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3Z] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_Q3Z"];
            }
            else
            {
                [self refreshMissView];
            }
        }
        else
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexRX] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_RX"];
            }
            else
            {
                [self refreshMissView];
            }
        }
    }
    else//胆拖
    {
        if (drag_PlayType == 6)//胆拖组2
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ2Z] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_Q2Z"];
            }
            else
            {
                [self refreshMissView];
            }
        }
        else if(drag_PlayType == 7)//胆拖组3
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexQ3Z] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_Q3Z"];
            }
            else
            {
                [self refreshMissView];
            }
        }
        else
        {
            if([[[self.recoderYiLuoDateArr objectAtIndex:kMissDateIndexRX] allKeys] count] == 0)
            {
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
                [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoGD115 sellWay:@"T01014MV_RX"];
            }
            else
            {
                [self refreshMissView];
            }
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
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoGD115;

    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"广东11选5";
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
	viewController.navigationItem.title = @"广东11选5投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
	if(kSegmentedDirect == self.segmentedView.segmentedIndex)
	{
		m_playType = num;
		[self.buttonPlayType setTitle:[NSString stringWithFormat:@"%@",[m_playTypeArray objectAtIndex:m_playType]] 
							 forState:UIControlStateNormal];
		[self pressedReselectButton:nil];
		[self updateSubViewsOfDirect];
        
        [self getMissDateNet];
    }
    else
    {
        drag_PlayType = num;
		[self.dragPlayType setTitle:[NSString stringWithFormat:@"%@",[m_delegate.randomPickerView.pickerNumArray objectAtIndex:drag_PlayType]] 
                           forState:UIControlStateNormal];
		[self pressedReselectButton:nil];
		[self updateSubViewsOfDrag];
        
        [self getMissDateNet];
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
    viewController.lotNo = kLotNoGD115;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleGD115;
    viewController.lotNo = kLotNoGD115;
    viewController.VRednumber = 11;
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
    viewController.lotTitle = kLotTitleGD115;
    viewController.lotNo = kLotNoGD115;
    viewController.VRednumber = 11;
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
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"广东11选5 %@期时间已到，进入下一期" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
        
        [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoGD115];//上期开奖

	    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoGD115];
        
        //重新获取遗漏值
        NSDictionary *startDic = [[NSDictionary alloc] init];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexRX withObject:startDic];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ3 withObject:startDic];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ2Z withObject:startDic];
        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexQ3Z withObject:startDic];
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

//- (void)viewWillDisappear:(BOOL)animated {
//    [self resignFirstResponder];
//    [super viewWillDisappear:animated];
//}

//最后在你的view控制器中添加motionEnded：
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //直选普通
    if (motion == UIEventSubtypeMotionShake  && m_delegate.isStartYaoYiYao && self.segmentedView.segmentedIndex == kSegmentedDirect)
    {
        if ([m_ballViewDirect getSelectNum] == 0 && [m_ballViewDirect1000 getSelectNum] == 0 && [m_ballViewDirect100 getSelectNum] == 0) 
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
        case kPlayType1:
            [m_ballViewDirect randomBall:1];
            break;
        case kPlayType2:
            [m_ballViewDirect randomBall:2];
            break;
        case kPlayType3:
            [m_ballViewDirect randomBall:3];
            break;
        case kPlayType4:
            [m_ballViewDirect randomBall:4];
            break;
        case kPlayType5:
            [m_ballViewDirect randomBall:5];
            break;
        case kPlayType6:
            [m_ballViewDirect randomBall:6];
            break;
        case kPlayType7:
            [m_ballViewDirect randomBall:7];
            break;
        case kPlayType8:
            [m_ballViewDirect randomBall:8];
            break;
        case kPlayTypezu2:
            [m_ballViewDirect randomBall:2];
            break;
        case kPlayTypezhi2:
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
        case kPlayTypezu3:
            [m_ballViewDirect randomBall:3];
            break;
        case kPlayTypezhi3:
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

#pragma mark -CustomerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    
    [self segmentedChangeValue:index];
    
}

@end
