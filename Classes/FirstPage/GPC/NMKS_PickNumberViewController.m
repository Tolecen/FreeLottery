//
//  NMKS_PickNumberViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-2-16.
//
//

#import "NMKS_PickNumberViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "RYCHighBetView.h"
#import "LotteryAwardInfoViewController.h"
#import "MoreBetListViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "LuckViewController.h"
#import "BackBarButtonItemUtils.h"

#define kBackAlterTag (345)
#define kAlterTag3Same (346)
#define kAlterTag2Same (347)
#define kAlterTag2SameDan (348)
#define kAlterTag3NoSame (349)
#define kAlterTag2NoSame (350)
#define kLabelFontSize (12)

#define kSegmentSumIndex (0)
#define kSegment3SameIndex (1)
#define kSegment2SameIndex  (2)
#define kSegmentNoSameIndex (3)
#define kSegment3ConnectedIndex (4)

#define k2SameDanButtonStartTag (2000)

//一级玩法区分
#define kIs3SameNumKey      @"is3SameNum"
#define kIs2SameNumKey      @"is2SameNum"
#define kIsNoSameNumKey     @"isNoSameNum"

//相同玩法二级区分 譬如，不同号分为，2不同和3不同
#define kIs2SameNumFuKey         @"is2SameNumFu"
#define kIs2SameNumDanKey        @"is2SameNumDan"
#define kIs3NoSameNumKey         @"is3NoSameNum"
#define kIs2NoSameNumKey         @"is2NoSameNum"






//#define k2SameDanSameKey      @"2SameDan_same"
//#define k2SameDanNoSameKey    @"2SameDan_noSame"

@interface NMKS_PickNumberViewController ()

- (void)setSelectBallShowView;

- (void)setUpSumView;
- (void)updateBallState:(NSNotification *)notification;

- (void)set3SameView;
- (void)update3SameView;

- (void)set2SameView;
- (void)update2SameView;

- (void)setNoSameView;
- (void)upDateNoSameView;

- (void)set3ConnectedView;

- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)detailViewButtonClick:(id)sender;
- (void)queryBetLotButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;

//- (void)luckButtonClick:(id)sender;

- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;
- (void)setMoreBet;

- (IBAction)addBasketClick:(id)sender;
- (IBAction)basketButtonClick:(id)sender;

- (void)updateInformation:(NSNotification*)notification;
- (void)refreshLeftTime;
- (void)updateLottery:(NSNotification*)notification;//上期

- (void)getMissdateForServersWithPalyType:(NSString *)type;//服务器获取玩儿法遗漏
- (void)getMissDateOK:(NSNotification*)notification;//遗漏返回
@end

@implementation NMKS_PickNumberViewController

@synthesize  scrollSum = m_scrollSum;
@synthesize  scroll3Same = m_scroll3Same;
@synthesize  scroll2Same = m_scroll2Same;
@synthesize  scrollNoSame = m_scrollNoSame;
@synthesize  scroll3Connected = m_scroll3Connected;
@synthesize  ballViewSum = m_ballViewSum;
@synthesize buttonBuy = m_buttonBuy;
@synthesize buttonReselect = m_buttonReselect;
@synthesize totalCost = m_totalCost;
@synthesize batchCode = m_batchCode;
@synthesize batchEndTime = m_batchEndTime;
//@synthesize recoderYiLuoDateArr = m_recoderYiLuoDateArr;
@synthesize segmentedView = m_segmentedView;
@synthesize addBasketButton = m_addBasketButton;
@synthesize basketButton = m_basketButton;
@synthesize basketNum = m_basketNum;
@synthesize bottomScrollView = m_bottomScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [m_bottomScrollView release];
    [alreaderLabel release];
    [m_scrollSum release], m_scrollSum = nil;
    [m_scroll3Same release], m_scroll3Same = nil;
    [m_scroll2Same release], m_scroll2Same = nil;
    [m_scrollNoSame release], m_scrollNoSame = nil;
    [m_scroll3Connected release], m_scroll3Connected = nil;
    [m_segmentedView release], m_segmentedView = nil;

    [m_showSelectBallWarnView release], m_showSelectBallWarnView = nil;
    [m_selectBallWarnLabel release], m_selectBallWarnLabel = nil;
    [m_ballViewSum release], m_ballViewSum = nil;
    [m_tongButton3Same release], m_tongButton3Same = nil;
    [m_danButton3Same release], m_danButton3Same = nil;
    [m_3SameExplain release], m_3SameExplain = nil;
    [m_3SameTongXuan release], m_3SameTongXuan = nil;
    [m_3SameTongXuanYiLou release] ,m_3SameTongXuanYiLou = nil;
    for (int i = 0; i < 6; i++)
    {
        [m_3SameDanXuan[i] release], m_3SameDanXuan[i] = nil;
        [m_3SameDanXuanYiLou[i] release], m_3SameDanXuanYiLou[i] = nil;
    }
    
    [m_fuButton2Same release], m_fuButton2Same = nil;
    [m_danButton2Same release], m_danButton2Same = nil;
    [m_2SameExplain release], m_2SameExplain = nil;
    for (int j = 0; j < 6; j ++)
    {
        [m_2SameFuXuan[j] release], m_2SameFuXuan[j] = nil;
        [m_2SameFuXuanYiLou[j] release], m_2SameFuXuanYiLou[j] = nil;
        
    }
    for (int k = 0; k < 12; k ++)
    {
        [m_2SameDanXuan[k] release], m_2SameDanXuan[k] = nil;
    }
    [m_2sameDanXuanScroll release], m_2sameDanXuanScroll = nil;
    
    [m_select3NoSame release], m_select3NoSame = nil;
    [m_select2NoSame release], m_select2NoSame = nil;
    [m_noSameExplainLabel release], m_noSameExplainLabel = nil;
    for (int i = 0; i < 6; i++)
    {
        [m_noSameButtonArray[i] release], m_noSameButtonArray[i] = nil;
        [m_noSameYiLou[i] release], m_noSameYiLou[i] = nil;
    }
    
    [m_3ConnectedButton release], m_3ConnectedButton = nil;
    [m_3ConnectedYiLou release], m_3ConnectedYiLou = nil;

    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_totalCost release];
	
	[m_leftTimeLabel release];
	[m_batchCodeLabel release];
//    [m_recoderYiLuoDateArr release], m_recoderYiLuoDateArr = nil;
    
    [m_addBasketButton release];
    [m_basketButton release];
    [m_basketNum release];
    
    [m_detailView release], m_detailView = nil;
    [m_lastBatchCodeLabel release];
    [m_winRedNumLabel release];
    [m_ballState release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if([m_timer isValid])
	{
		[m_timer invalidate];
		m_timer = nil;
	}
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMissDateOK" object:nil];

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBallState" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLottery" object:nil];

    [m_refreshButton removeFromSuperview];
    [m_refreshButton release], m_refreshButton = nil;
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBallState:) name:@"updateBallState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLottery:) name:@"updateLottery" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMissDateOK:) name:@"getMissDateOK" object:nil];

    
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoNMK3];//上期开奖
    [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiry:kLotNoNMK3];
    
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

//    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 61, 320, 45)];
//    [m_animationTabView.buttonNameArray addObject:@"和值"];
//    [m_animationTabView.buttonNameArray addObject:@"三同号"];
//    [m_animationTabView.buttonNameArray addObject:@"二同号"];
//    [m_animationTabView.buttonNameArray addObject:@"不同号"];
//    [m_animationTabView.buttonNameArray addObject:@"三连号"];
//    [m_animationTabView setMainButton];
//    m_animationTabView.delegate = self;
//    [self.view addSubview:m_animationTabView];
    
    alreaderLabel = [[UILabel alloc] init];
    alreaderLabel.textColor = [UIColor blackColor];
    alreaderLabel.text=@"已选:";
    alreaderLabel.backgroundColor = [UIColor clearColor];
    alreaderLabel.font = [UIFont systemFontOfSize:14];
    [m_bottomScrollView addSubview:alreaderLabel];
    
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
//初始化随即标示参数，来判定各个彩种选中的状态
    m_randomNumber =100;
    m_2SameRandomNumber=100;
    m_2SameDanRandomNumber =100;
    m_2SameDanRandomNext = 100;
    //三不同
    m_3NoSameRandomNum1 = 100;
    m_3NoSameRandomNum2 = 100;
    m_3NoSameRandomNum3 = 100;
    //俩不同
    m_2NoSameRandomNum1 = 100;
    m_2NoSameRandomNum2 = 100;
    
    
    self.segmentedView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 60, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:
                                                                        @"nmks_hz_segment_normal.png",
                                                                        @"nmks_sth_segment_normal.png",
                                                                        @"nmks_eth_segment_normal.png",
                                                                        @"nmks_bth_segment_normal.png",
                                                                        @"nmks_slh_segment_normal.png", nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:
                                                                        @"nmks_hz_segment_normal.png",
                                                                        @"nmks_sth_segment_normal.png",
                                                                        @"nmks_eth_segment_normal.png",
                                                                        @"nmks_bth_segment_normal.png",
                                                                        @"nmks_slh_segment_normal.png", nil]
                                                        andSelectImage:[NSArray arrayWithObjects:
                                                                        @"nmks_hz_segment_ highlighted.png",
                                                                        @"nmks_sth_segment_ highlighted.png",
                                                                        @"nmks_eth_segment_ highlighted.png",
                                                                        @"nmks_bth_segment_ highlighted.png",
                                                                        @"nmks_slh_segment_ highlighted.png", nil]]autorelease];
    
    self.segmentedView.delegate = self;
    [self.view addSubview:m_segmentedView];
    [self segmentedChangeValue:0];
    
    self.scrollSum.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scroll3Same.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scroll3Same.hidden = YES;
    self.scroll2Same.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scroll2Same.hidden = YES;
    self.scrollNoSame.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scrollNoSame.hidden = YES;
    self.scroll3Connected.frame = CGRectMake(0, 104, 320, [UIScreen mainScreen].bounds.size.height - 256);
    self.scroll3Connected.hidden = YES;
    
    [MobClick event:@"GPC_selectPage"];
    
    [self setupNavigationBar];
    
    isMoreBet = NO;
    m_allZhuShu = 0;

    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];

    [self setUpSumView];//和值
    
    m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 150, 30)];
	m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",self.batchCode];
    m_batchCodeLabel.textAlignment = UITextAlignmentLeft;
    m_batchCodeLabel.backgroundColor = [UIColor clearColor];
    m_batchCodeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:m_batchCodeLabel];
	
	m_leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 150, 30)];
	m_leftTimeLabel.text = @"本期剩余时间：0分0秒";
	m_leftTimeLabel.textAlignment = UITextAlignmentRight;
    m_leftTimeLabel.backgroundColor = [UIColor clearColor];
    m_leftTimeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:m_leftTimeLabel];
    
//    NSDictionary *startDic = [[NSDictionary alloc] init];
//    m_recoderYiLuoDateArr = [[NSMutableArray alloc] initWithObjects:startDic, startDic, startDic, startDic, nil];
//    [startDic release];
    
//    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
//    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:@"T01007" sellWay:@"T01007MV_5X"];
    
    
    [self set3SameView];//三同号
    [self set2SameView];//二同号
    [self setNoSameView];//不同号
    [self set3ConnectedView];//三连号
    [self setSelectBallShowView];
    
    [self setDetailView];
}


- (void)back:(id)sender
{
    if([self.basketNum.text isEqualToString:@"0"])
    {
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
    
    UIButton* detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [detailButton addTarget:self action: @selector(detailViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_normal"] forState:UIControlStateNormal];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_click"] forState:UIControlStateHighlighted];
//    detailButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    detailButton.showsTouchWhenHighlighted = TRUE;
    //    [self.navigationController.navigationBar addSubview:m_detailButton];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:detailButton] autorelease];
    [detailButton release];
    
    m_detailView.hidden = YES;
}

- (void)setSelectBallShowView
{
	m_showSelectBallWarnView = [[UIView alloc]initWithFrame:CGRectMake(85, 160, 150, 25)];
	m_showSelectBallWarnView.alpha = 0.8;
	[m_showSelectBallWarnView setBackgroundColor:[UIColor darkGrayColor]];
	[m_showSelectBallWarnView.layer setCornerRadius:6];
	m_showSelectBallWarnView.clipsToBounds = YES;
	[self.view addSubview:m_showSelectBallWarnView];
    m_showSelectBallWarnView.hidden = YES;
    
	m_selectBallWarnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
	[m_selectBallWarnLabel setBackgroundColor:[UIColor clearColor]];
	[m_selectBallWarnLabel setTextColor:[UIColor whiteColor]];
	m_selectBallWarnLabel.textAlignment = UITextAlignmentCenter;
	m_selectBallWarnLabel.font = [UIFont systemFontOfSize:12];
    [m_showSelectBallWarnView addSubview:m_selectBallWarnLabel];
}

- (void)hideView
{
	m_showSelectBallWarnView.hidden = YES;
}

//- (void)segmentedChangeValue
//{
//    switch (self.animationTabView.selectButtonTag) {
//        case kSegmentSumIndex:
//        {
//            self.scrollSum.hidden = NO;
//            self.scroll3Same.hidden = YES;
//            self.scroll2Same.hidden = YES;
//            self.scrollNoSame.hidden = YES;
//            self.scroll3Connected.hidden = YES;
//        }break;
//        case kSegment3SameIndex:
//        {
//            self.scrollSum.hidden = YES;
//            self.scroll3Same.hidden = NO;
//            self.scroll2Same.hidden = YES;
//            self.scrollNoSame.hidden = YES;
//            self.scroll3Connected.hidden = YES;
//        } break;
//        case kSegment2SameIndex:
//        {
//            self.scrollSum.hidden = YES;
//            self.scroll3Same.hidden = YES;
//            self.scroll2Same.hidden = NO;
//            self.scrollNoSame.hidden = YES;
//            self.scroll3Connected.hidden = YES;
//        } break;
//        case kSegmentNoSameIndex:
//        {
//            self.scrollSum.hidden = YES;
//            self.scroll3Same.hidden = YES;
//            self.scroll2Same.hidden = YES;
//            self.scrollNoSame.hidden = NO;
//            self.scroll3Connected.hidden = YES;
//        } break;
//        case kSegment3ConnectedIndex:
//        {
//            self.scrollSum.hidden = YES;
//            self.scroll3Same.hidden = YES;
//            self.scroll2Same.hidden = YES;
//            self.scrollNoSame.hidden = YES;
//            self.scroll3Connected.hidden = NO;
//        }break;
//        default:
//            break;
//    }
//    [self updateBallState:nil];
//    
//    m_showSelectBallWarnView.hidden = YES;
//}
- (void)segmentedChangeValue:(NSInteger)index
{
    switch (self.segmentedView.segmentedIndex) {
        case kSegmentSumIndex:
        {
            
            NSLog(@"和值");
            
            [self getMissdateForServersWithPalyType:@"F47108MV_10"];
        
            self.scrollSum.hidden = NO;
            self.scroll3Same.hidden = YES;
            self.scroll2Same.hidden = YES;
            self.scrollNoSame.hidden = YES;
            self.scroll3Connected.hidden = YES;
        }break;
        case kSegment3SameIndex:
        {
            NSLog(@"三同号");
            if(m_tongButton3Same.selected){
                NSLog(@"三同号 通选");
                [self getMissdateForServersWithPalyType:@"F47108MV_40"];
            }else{
                NSLog(@"三同号 单选");
                [self getMissdateForServersWithPalyType:@"F47108MV_02"];
            }
            
            self.scrollSum.hidden = YES;
            self.scroll3Same.hidden = NO;
            self.scroll2Same.hidden = YES;
            self.scrollNoSame.hidden = YES;
            self.scroll3Connected.hidden = YES;
        } break;
        case kSegment2SameIndex:
        {
            
            if(m_fuButton2Same.selected){
                NSLog(@"二同号 复选");
                [self getMissdateForServersWithPalyType:@"F47108MV_30"];
            }else{
                NSLog(@"二同号 单选");
                [self getMissdateForServersWithPalyType:@"F47108MV_01"];
            }
            
            
            
            
            
            self.scrollSum.hidden = YES;
            self.scroll3Same.hidden = YES;
            self.scroll2Same.hidden = NO;
            self.scrollNoSame.hidden = YES;
            self.scroll3Connected.hidden = YES;
        } break;
        case kSegmentNoSameIndex:
        {
            NSLog(@"不同号");
            
            if(m_select3NoSame.selected){
                NSLog(@"不同号-三不同号");
                [self getMissdateForServersWithPalyType:@"F47108MV_BASE"];
            }else{
                NSLog(@"不同号-二不同号");
                [self getMissdateForServersWithPalyType:@"F47108MV_BASE"];
            }
            
            self.scrollSum.hidden = YES;
            self.scroll3Same.hidden = YES;
            self.scroll2Same.hidden = YES;
            self.scrollNoSame.hidden = NO;
            self.scroll3Connected.hidden = YES;
        } break;
        case kSegment3ConnectedIndex:
        {
            NSLog(@"三连号");
            [self getMissdateForServersWithPalyType:@"F47108MV_50"];
            self.scrollSum.hidden = YES;
            self.scroll3Same.hidden = YES;
            self.scroll2Same.hidden = YES;
            self.scrollNoSame.hidden = YES;
            self.scroll3Connected.hidden = NO;
        }break;
        default:
            break;
    }
    [self updateBallState:nil];
    
    m_showSelectBallWarnView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)clearAllPickBall
{
    [m_ballViewSum clearBallState];
    m_3SameTongXuan.selected = NO;

    for (int i = 0; i < 6; i++) {
        m_3SameDanXuan[i].selected = NO;
    }

    for (int j = 0; j < 6; j++) {
        m_2SameFuXuan[j].selected = NO;
    }

    for (int k = 0; k < 12; k++) {
        m_2SameDanXuan[k].selected = NO;
    }

    for (int i = 0; i < 6; i++) {
        m_noSameButtonArray[i].selected = NO;
    }

    m_3ConnectedButton.selected = NO;
    [self updateBallState:nil];
}
#pragma mark 刷新上期开奖
- (void)refreshButtonClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager]getLotteryInformation:@"1" lotno:kLotNoNMK3];//上期开奖
}
#pragma mark 上期开奖
- (void)updateLottery:(NSNotification*)notification
{
    if (!m_detailView.hidden) {
        [self detailViewButtonClick:nil];
    }
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].lotteryInformation];
    [jsonParser release];
    if([[parserDict objectForKey:@"result"] count] <= 0)
        return;
    NSString*  winNo = [[[parserDict objectForKey:@"result"] objectAtIndex:0] objectForKey:@"winCode"];
    
    NSString* redStr = @"";
    for(int i = 0; i < 3; i++)
    {
        if(i !=2)
            redStr = [redStr stringByAppendingFormat:@"%@,", [winNo substringWithRange:NSMakeRange(i * 2, 2)]];
        else
            redStr = [redStr stringByAppendingFormat:@"%@", [winNo substringWithRange:NSMakeRange(i * 2, 2)]];
    }
    NSString* bathCodeStr = [NSString stringWithFormat:@"第%@期开奖号码：", KISDictionaryHaveKey([[parserDict objectForKey:@"result"] objectAtIndex:0], @"batchCode")] ;
    CGSize batchCodeSize = [bathCodeStr sizeWithFont:[UIFont systemFontOfSize:kLabelFontSize]];
    CGSize winRedSize = redStr.length == 0 ? CGSizeZero : [redStr sizeWithFont:[UIFont systemFontOfSize:kLabelFontSize]];
    
    m_lastBatchCodeLabel.frame = CGRectMake(10, 0, batchCodeSize.width, 30);
    m_lastBatchCodeLabel.text = bathCodeStr;
    
    m_winRedNumLabel.frame = CGRectMake(10 + batchCodeSize.width, 0, winRedSize.width, 30);
    m_winRedNumLabel.text = redStr;
}

#pragma mark  和值界面
- (void)setUpSumView
{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
	label1.text = @"至少选择1个和值投注，选号与开奖的三个号码相加的数值一致即中奖!";
    label1.numberOfLines = 2;
    label1.textColor = [UIColor redColor];
	label1.textAlignment = UITextAlignmentLeft;
	label1.backgroundColor = [UIColor clearColor];
	label1.font = [UIFont systemFontOfSize:12.0f];
	[self.scrollSum addSubview:label1];
	[label1 release];
    
    CGRect frameRedBall = CGRectMake((320- (8 * kBallVerticalSpacing) - 9 * kBallRectWidth) / 2,
                                     45,
                                     9 * (kBallRectWidth + kBallVerticalSpacing),
                                     (kBallRectHeight + kBallLineSpacing+ kYiLuoHeight) * 2);
    m_ballViewSum = [[PickBallViewController alloc] init];
    self.ballViewSum.isHasYiLuo = YES;
	[self.ballViewSum createBallArray:14 withPerLine:9 startValue:4 selectBallCount:1];
	[self.ballViewSum setBallType:RED_BALL];
    [self.ballViewSum setSelectMaxNum:14];
	self.ballViewSum.view.frame = frameRedBall;
	[self.scrollSum addSubview:self.ballViewSum.view];
    
}

#pragma mark 三同号
- (void)set3SameView
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scroll3Same addSubview:mode_bg];
    [mode_bg release];
    
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 40, 30)];
    numLabel.text = @"模式：";
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:13];
    [self.scroll3Same addSubview:numLabel];
    [numLabel release];
    
    //模式设置
    m_tongButton3Same = [[UIButton alloc] initWithFrame:CGRectMake(70, 10, 23, 23)];
	[m_tongButton3Same setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_tongButton3Same setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateSelected];
	[m_tongButton3Same addTarget:self action:@selector(beforeSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll3Same addSubview:m_tongButton3Same];
    m_tongButton3Same.selected = YES;
	
    UILabel *lable_tong = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 50, 23)];
    lable_tong.text = @"通选";
    lable_tong.textColor = [UIColor blackColor];
    lable_tong.backgroundColor = [UIColor clearColor];
    lable_tong.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll3Same addSubview:lable_tong];
    [lable_tong release];
    
	m_danButton3Same = [[UIButton alloc] initWithFrame:CGRectMake(190, 10, 23, 23)];
	[m_danButton3Same setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_danButton3Same setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateSelected];
    [m_danButton3Same setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[m_danButton3Same addTarget:self action:@selector(afterSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll3Same addSubview:m_danButton3Same];
    
    UILabel *lable_dan = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 50, 23)];
    lable_dan.text = @"单选";
    lable_dan.textColor = [UIColor blackColor];
    lable_dan.backgroundColor = [UIColor clearColor];
    lable_dan.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll3Same addSubview:lable_dan];
    [lable_dan release];

    m_3SameExplain = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    m_3SameExplain.text = @"2元购买6个三同号(111,222,333,444,555,666)投注，选号与开奖号码一致即中奖40元。1/36的中奖机会！";
    m_3SameExplain.numberOfLines = 2;
    m_3SameExplain.textColor = [UIColor redColor];
	m_3SameExplain.textAlignment = UITextAlignmentLeft;
	m_3SameExplain.backgroundColor = [UIColor clearColor];
	m_3SameExplain.font = [UIFont systemFontOfSize:12.0f];
	[self.scroll3Same addSubview:m_3SameExplain];
    
    m_3SameTongXuan = [[UIButton alloc] initWithFrame:CGRectMake(110, 90, 100, 35)];
    [m_3SameTongXuan setBackgroundImage:RYCImageNamed(@"nmk3_bigball_normal.png") forState:UIControlStateNormal];
    [m_3SameTongXuan setBackgroundImage:RYCImageNamed(@"nmk3_bigball_click.png") forState:UIControlStateSelected];
    [m_3SameTongXuan setTitle:@"三同号通选" forState:UIControlStateNormal];
    [m_3SameTongXuan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_3SameTongXuan setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    m_3SameTongXuan.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_3SameTongXuan addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll3Same addSubview:m_3SameTongXuan];
    
    m_3SameTongXuanYiLou = [[UILabel alloc] initWithFrame:CGRectMake(110, 120, 100, 35)];
    [m_3SameTongXuanYiLou setText:@"0"];
    m_3SameTongXuanYiLou.font = [UIFont boldSystemFontOfSize:12.0];
    m_3SameTongXuanYiLou.textAlignment = UITextAlignmentCenter;
    [m_3SameTongXuanYiLou setBackgroundColor:[UIColor clearColor]];
    [m_3SameTongXuanYiLou setTextColor:[UIColor grayColor]];
    [self.scroll3Same addSubview:m_3SameTongXuanYiLou];
    
    //单选界面、、、、
    for (int i = 0; i < 6; i++)
    {
        m_3SameDanXuan[i] = [[UIButton alloc] initWithFrame:CGRectMake(20 + i%3 * 100, 90 + i/3 * 55, 80, 35)];
        [m_3SameDanXuan[i] setBackgroundImage:RYCImageNamed(@"nmk3_medball_normal.png") forState:UIControlStateNormal];
        [m_3SameDanXuan[i] setBackgroundImage:RYCImageNamed(@"nmk3_medball_click.png") forState:UIControlStateSelected];
        [m_3SameDanXuan[i] setTitle:[NSString stringWithFormat:@"%d%d%d",i+1,i+1,i+1] forState:UIControlStateNormal];
        [m_3SameDanXuan[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_3SameDanXuan[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        m_3SameDanXuan[i].titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [m_3SameDanXuan[i] addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_3SameDanXuan[i].tag = k2SameDanButtonStartTag+i;
        [self.scroll3Same addSubview:m_3SameDanXuan[i]];
        m_3SameDanXuan[i].hidden = YES;
        
        
        
        m_3SameDanXuanYiLou[i] = [[UILabel alloc]initWithFrame:CGRectMake(20 + i%3 * 100, 115 + i/3 * 55, 80, 35)];
        [m_3SameDanXuanYiLou[i] setText:@"0"];
        m_3SameDanXuanYiLou[i].textAlignment = UITextAlignmentCenter;
        m_3SameDanXuanYiLou[i].font = [UIFont boldSystemFontOfSize:12.0f];
        [m_3SameDanXuanYiLou[i] setBackgroundColor:[UIColor clearColor]];
        [m_3SameDanXuanYiLou[i] setTextColor:[UIColor grayColor]];
        [self.scroll3Same addSubview:m_3SameDanXuanYiLou[i] ];
        m_3SameDanXuanYiLou[i].hidden = YES;
        
    }
}

- (void)update3SameView
{
    if(m_tongButton3Same.selected)//通选
    {
        m_3SameExplain.text = @"2元购买6个三同号(111,222,333,444,555,666)投注，选号与开奖号码一致即中奖40元。1/36的中奖机会！";
        m_3SameTongXuan.hidden = NO;
        m_3SameTongXuanYiLou.hidden = NO;
        for (int i = 0; i < 6; i++)
        {
            m_3SameDanXuan[i].hidden = YES;
            m_3SameDanXuanYiLou[i].hidden = YES;
        }
    }
    else
    {
        m_3SameExplain.text = @"至少选择1个三同号投注，选号与开奖号码一致即中奖240元。1/216的中奖机会！";
        m_3SameTongXuan.hidden = YES;
        m_3SameTongXuanYiLou.hidden = YES;
        for (int i = 0; i < 6; i++)
        {
            m_3SameDanXuan[i].hidden = NO;
            m_3SameDanXuanYiLou[i].hidden = NO;
        }
    }
    [self updateBallState:nil];
}

#pragma mark 二同号界面
- (void)set2SameView
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scroll2Same addSubview:mode_bg];
    [mode_bg release];
    
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 40, 30)];
    numLabel.text = @"模式：";
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:13];
    [self.scroll2Same addSubview:numLabel];
    [numLabel release];
    
    //模式设置
    m_fuButton2Same = [[UIButton alloc] initWithFrame:CGRectMake(70, 10, 23, 23)];
	[m_fuButton2Same setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_fuButton2Same setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateSelected];
	[m_fuButton2Same addTarget:self action:@selector(beforeSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll2Same addSubview:m_fuButton2Same];
    m_fuButton2Same.selected = YES;
	
    UILabel *lable_fu = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 50, 23)];
    lable_fu.text = @"复选";
    lable_fu.textColor = [UIColor blackColor];
    lable_fu.backgroundColor = [UIColor clearColor];
    lable_fu.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll2Same addSubview:lable_fu];
    [lable_fu release];
    
	m_danButton2Same = [[UIButton alloc] initWithFrame:CGRectMake(190, 10, 23, 23)];
	[m_danButton2Same setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_danButton2Same setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateSelected];
    [m_danButton2Same setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[m_danButton2Same addTarget:self action:@selector(afterSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll2Same addSubview:m_danButton2Same];
    
    UILabel *lable_dan = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 50, 23)];
    lable_dan.text = @"单选";
    lable_dan.textColor = [UIColor blackColor];
    lable_dan.backgroundColor = [UIColor clearColor];
    lable_dan.font = [UIFont boldSystemFontOfSize:14];
    [self.scroll2Same addSubview:lable_dan];
    [lable_dan release];
    
    m_2SameExplain = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    m_2SameExplain.text = @"2元购买1个二同号(11*,22*,33*,44*,55*,66*)投注，选号与开奖号码一致即中奖15元。1/13.5的中奖机会！";
    m_2SameExplain.numberOfLines = 2;
    m_2SameExplain.textColor = [UIColor redColor];
	m_2SameExplain.textAlignment = UITextAlignmentLeft;
	m_2SameExplain.backgroundColor = [UIColor clearColor];
	m_2SameExplain.font = [UIFont systemFontOfSize:12.0f];
	[self.scroll2Same addSubview:m_2SameExplain];
    
    //复选界面、、、、
    for (int i = 0; i < 6; i++)
    {
        m_2SameFuXuan[i] = [[UIButton alloc] initWithFrame:CGRectMake(20 + i%3 * 100, 90 + i/3 * 55, 80, 35)];
        [m_2SameFuXuan[i] setBackgroundImage:RYCImageNamed(@"nmk3_medball_normal.png") forState:UIControlStateNormal];
        [m_2SameFuXuan[i] setBackgroundImage:RYCImageNamed(@"nmk3_medball_click.png") forState:UIControlStateSelected];
        [m_2SameFuXuan[i] setTitle:[NSString stringWithFormat:@"%d%d*",i+1,i+1] forState:UIControlStateNormal];
        [m_2SameFuXuan[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_2SameFuXuan[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        m_2SameFuXuan[i].titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [m_2SameFuXuan[i] addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_2SameFuXuan[i].tag = k2SameDanButtonStartTag+i;
        [self.scroll2Same addSubview:m_2SameFuXuan[i]];
        
        //复选遗漏
        m_2SameFuXuanYiLou[i] = [[UILabel alloc] initWithFrame:CGRectMake(20 + i%3 * 100, 115 + i/3 * 55, 80, 35)];
        m_2SameFuXuanYiLou[i].textAlignment = UITextAlignmentCenter;
        m_2SameFuXuanYiLou[i].font = [UIFont boldSystemFontOfSize:12.0f];
        [m_2SameFuXuanYiLou[i] setBackgroundColor:[UIColor clearColor]];
        [m_2SameFuXuanYiLou[i] setTextColor:[UIColor grayColor]];
        [m_2SameFuXuanYiLou[i] setText:@"0"];
        [self.scroll2Same addSubview:m_2SameFuXuanYiLou[i]];
    }
    
    m_2sameDanXuanScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, 320, [UIScreen mainScreen].bounds.size.height - 256)];
    m_2sameDanXuanScroll.backgroundColor = [UIColor whiteColor];
    [self.scroll2Same addSubview:m_2sameDanXuanScroll];
    m_2sameDanXuanScroll.hidden = YES;
    
    UILabel* label2Same = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 310, 20)];
	label2Same.text = @"相同号：";
	label2Same.textAlignment = UITextAlignmentLeft;
	label2Same.backgroundColor = [UIColor clearColor];
	label2Same.font = [UIFont systemFontOfSize:kLabelFontSize];
	[m_2sameDanXuanScroll addSubview:label2Same];
    [label2Same release];
    
    UILabel* label2NoSame = [[UILabel alloc] initWithFrame:CGRectMake(10, 68, 310, 20)];
	label2NoSame.text = @"不同号：";
	label2NoSame.textAlignment = UITextAlignmentLeft;
	label2NoSame.backgroundColor = [UIColor clearColor];
	label2NoSame.font = [UIFont systemFontOfSize:kLabelFontSize];
	[m_2sameDanXuanScroll addSubview:label2NoSame];
    [label2NoSame release];
    
    for (int j = 0; j < 12; j ++)
    {
        m_2SameDanXuan[j] = [[UIButton alloc] initWithFrame:CGRectMake(12 + j%6 * 51, 25 + j/6 * 65, 40, 35)];
        [m_2SameDanXuan[j] setBackgroundImage:RYCImageNamed(@"nmk3_smallball_normal.png") forState:UIControlStateNormal];
        [m_2SameDanXuan[j] setBackgroundImage:RYCImageNamed(@"nmk3_smallball_click.png") forState:UIControlStateSelected];
        if(j > 5)
        {
          [m_2SameDanXuan[j] setTitle:[NSString stringWithFormat:@"%d",j%6 + 1] forState:UIControlStateNormal];
        }
        else
        {
           [m_2SameDanXuan[j] setTitle:[NSString stringWithFormat:@"%d%d",j+1,j+1] forState:UIControlStateNormal];
        }
            

        [m_2SameDanXuan[j] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_2SameDanXuan[j] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        m_2SameDanXuan[j].titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [m_2SameDanXuan[j] addTarget:self action:@selector(button2SameDanClick:) forControlEvents:UIControlEventTouchUpInside];
        m_2SameDanXuan[j].tag = k2SameDanButtonStartTag + j;
        [m_2sameDanXuanScroll addSubview:m_2SameDanXuan[j]];
        
        
        m_2SameDanXuanYiLou[j] = [[UILabel alloc]initWithFrame:CGRectMake(12 + j%6 * 51, 48 + j/6 * 65, 40, 35)];
        [m_2SameDanXuanYiLou[j] setText:@"0"];
        m_2SameDanXuanYiLou[j].font = [UIFont boldSystemFontOfSize:12.0];
        [m_2SameDanXuanYiLou[j] setTextColor:[UIColor grayColor]];
        [m_2SameDanXuanYiLou[j] setBackgroundColor:[UIColor clearColor]];
        m_2SameDanXuanYiLou[j].textAlignment = UITextAlignmentCenter;
        [m_2sameDanXuanScroll addSubview:m_2SameDanXuanYiLou[j]];
        
    }

}

- (void)update2SameView
{
    if(m_fuButton2Same.selected)
    {
        m_2sameDanXuanScroll.hidden = YES;
        m_2SameExplain.text = @"2元购买1个二同号(11*,22*,33*,44*,55*,66*)投注，选号与开奖号码一致即中奖15元。1/13.5的中奖机会！";
    }
    else
    {
        m_2sameDanXuanScroll.hidden = NO;
        m_2SameExplain.text = @"选择1个相同号码和1个不同号码投注，选号与开奖号码一致即中奖80元。1/72的中奖机会！";
    }
    [self updateBallState:nil];
}

- (void)button2SameDanClick:(id)sender
{
    UIButton* temButton = (UIButton*)sender;
    temButton.selected = !temButton.selected;
    if(temButton.selected)
    {
        if(temButton.tag < k2SameDanButtonStartTag + 6)//选的是相同号
        {
            if(m_2SameDanXuan[temButton.tag - k2SameDanButtonStartTag + 6].selected)
                m_2SameDanXuan[temButton.tag - k2SameDanButtonStartTag + 6].selected = NO;
        }
        else
        {
            if(m_2SameDanXuan[temButton.tag - k2SameDanButtonStartTag - 6].selected)
                m_2SameDanXuan[temButton.tag - k2SameDanButtonStartTag - 6].selected = NO;
        }
    }
    [self updateBallState:nil];
    
    BOOL hasSame = NO;
    BOOL hasNoSame = NO;
    for (int j = 0; j < 6; j ++) {
        if (m_2SameDanXuan[j].selected) 
            hasSame = YES;
        if (m_2SameDanXuan[j+6].selected)
            hasNoSame = YES;
    }
    m_showSelectBallWarnView.hidden = YES;
    if(!hasSame || !hasNoSame)
    {
        m_showSelectBallWarnView.hidden = NO;
        if(!hasSame)
            m_selectBallWarnLabel.text = @"您还差一个“相同号”";
        if(!hasNoSame)
             m_selectBallWarnLabel.text = @"您还差一个“不同号”";
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];
        [self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
    }
}

#pragma mark 不同号界面
- (void)setNoSameView
{
    UIImageView *mode_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"mode_bg.png")];
    mode_bg.frame = CGRectMake(0, 0, 320, 45);
    [self.scrollNoSame addSubview:mode_bg];
    [mode_bg release];
    
	UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 40, 30)];
    numLabel.text = @"模式：";
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:13];
    [self.scrollNoSame addSubview:numLabel];
    [numLabel release];
    
    //模式设置
    m_select3NoSame = [[UIButton alloc] initWithFrame:CGRectMake(70, 10, 23, 23)];
	[m_select3NoSame setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_select3NoSame setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateSelected];
	[m_select3NoSame addTarget:self action:@selector(beforeSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollNoSame addSubview:m_select3NoSame];
    m_select3NoSame.selected = YES;
	
    UILabel *lable_tong = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 80, 23)];
    lable_tong.text = @"三不同号";
    lable_tong.textColor = [UIColor blackColor];
    lable_tong.backgroundColor = [UIColor clearColor];
    lable_tong.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollNoSame addSubview:lable_tong];
    [lable_tong release];
    
	m_select2NoSame = [[UIButton alloc] initWithFrame:CGRectMake(190, 10, 23, 23)];
	[m_select2NoSame setBackgroundImage:RYCImageNamed(@"mode_nomal.png") forState:UIControlStateNormal];
	[m_select2NoSame setBackgroundImage:RYCImageNamed(@"mode_select.png") forState:UIControlStateSelected];
    [m_select2NoSame setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[m_select2NoSame addTarget:self action:@selector(afterSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollNoSame addSubview:m_select2NoSame];
    
    UILabel *lable_dan = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 80, 23)];
    lable_dan.text = @"二不同号";
    lable_dan.textColor = [UIColor blackColor];
    lable_dan.backgroundColor = [UIColor clearColor];
    lable_dan.font = [UIFont boldSystemFontOfSize:14];
    [self.scrollNoSame addSubview:lable_dan];
    [lable_dan release];
    
    m_noSameExplainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    m_noSameExplainLabel.text = @"至少选择3个号码投注，选号与开奖号码一致即中奖40元。1/36的中奖机会！";
    m_noSameExplainLabel.numberOfLines = 2;
    m_noSameExplainLabel.textColor = [UIColor redColor];
	m_noSameExplainLabel.textAlignment = UITextAlignmentLeft;
	m_noSameExplainLabel.backgroundColor = [UIColor clearColor];
	m_noSameExplainLabel.font = [UIFont systemFontOfSize:12.0f];
	[self.scrollNoSame addSubview:m_noSameExplainLabel];

    for (int i = 0; i < 6; i++)
    {
        m_noSameButtonArray[i] = [[UIButton alloc] initWithFrame:CGRectMake(20 + i%3 * 100, 90 + i/3 * 55, 80, 35)];
        [m_noSameButtonArray[i] setBackgroundImage:RYCImageNamed(@"nmk3_medball_normal.png") forState:UIControlStateNormal];
        [m_noSameButtonArray[i] setBackgroundImage:RYCImageNamed(@"nmk3_medball_click.png") forState:UIControlStateSelected];
        m_noSameButtonArray[i].tag = k2SameDanButtonStartTag+i;
        [m_noSameButtonArray[i] setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [m_noSameButtonArray[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_noSameButtonArray[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        m_noSameButtonArray[i].titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [m_noSameButtonArray[i] addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollNoSame addSubview:m_noSameButtonArray[i]];
        
        
        m_noSameYiLou[i] = [[UILabel alloc]initWithFrame:CGRectMake(20 + i%3 * 100, 115 + i/3 * 55, 80, 35)];
        [m_noSameYiLou[i] setBackgroundColor:[UIColor clearColor]];
        [m_noSameYiLou[i] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [m_noSameYiLou[i] setTextColor:[UIColor grayColor]];
        [m_noSameYiLou[i] setTextAlignment:UITextAlignmentCenter];
        [m_noSameYiLou[i] setText:@"0"];
        [self.scrollNoSame addSubview:m_noSameYiLou[i]];
    }
}

- (void)upDateNoSameView
{
    if(m_select3NoSame.selected)
    {
        m_noSameExplainLabel.text = @"至少选择3个号码投注，选号与开奖号码一致即中奖40元。1/36的中奖机会！";
    }
    else
    {
        m_noSameExplainLabel.text = @"至少选择2个号码投注，选号与开奖号码一致即中奖8元。1/7.2的中奖机会！";
    }
    [self pressedReselectButton:nil];
}
#pragma mark 三连号通选
- (void)set3ConnectedView
{
    UILabel* connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    connectLabel.text = @"2元购买4个三连号(123,234,345,456)投注，选号与开奖号码一致即中奖10元。1/9的中奖机会！";
    connectLabel.numberOfLines = 2;
    connectLabel.textColor = [UIColor redColor];
	connectLabel.textAlignment = UITextAlignmentLeft;
	connectLabel.backgroundColor = [UIColor clearColor];
	connectLabel.font = [UIFont systemFontOfSize:12.0f];
	[self.scroll3Connected addSubview:connectLabel];
    [connectLabel release];
    
    m_3ConnectedButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 50, 100, 35)];
    [m_3ConnectedButton setBackgroundImage:RYCImageNamed(@"nmk3_bigball_normal.png") forState:UIControlStateNormal];
    [m_3ConnectedButton setBackgroundImage:RYCImageNamed(@"nmk3_bigball_click.png") forState:UIControlStateSelected];
    [m_3ConnectedButton setTitle:@"三连号通选" forState:UIControlStateNormal];
    [m_3ConnectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_3ConnectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    m_3ConnectedButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_3ConnectedButton addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.scroll3Connected addSubview:m_3ConnectedButton];
    
    
    m_3ConnectedYiLou = [[UILabel alloc]initWithFrame:CGRectMake(110, 75, 100, 35)];
    [m_3ConnectedYiLou setBackgroundColor:[UIColor clearColor]];
    [m_3ConnectedYiLou setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [m_3ConnectedYiLou setTextColor:[UIColor grayColor]];
    [m_3ConnectedYiLou setTextAlignment:UITextAlignmentCenter];
    [m_3ConnectedYiLou setText:@"0"];
    [self.scroll3Connected addSubview:m_3ConnectedYiLou];
    
}
#pragma mark 刷新
- (void)updateBallState:(NSNotification *)notification
{
    m_detailView.hidden = YES;
    
    NSString* totalStr = @"";
	
    m_numZhu = 0;
    m_numCost = 0;
//    switch (self.animationTabView.selectButtonTag) {
    switch (self.segmentedView.segmentedIndex) {
        case kSegmentSumIndex:
        {
            NSArray *balls = [self.ballViewSum selectedBallsArray];
            int nBalls = [balls count];
            
            m_numZhu = RYCChoose(1, nBalls);            
        }break;
        case kSegment3SameIndex:
        {
            if(m_tongButton3Same.selected)
            {
                m_numZhu = m_3SameTongXuan.selected ? 1 : 0;
            }
            else
            {
                for (int i = 0; i < 6; i++)
                {
                    if(m_3SameDanXuan[i].selected)
                        m_numZhu++;
                }
            }
            
        } break;
        case kSegment2SameIndex:
        {
            if(m_fuButton2Same.selected)
            {
                for (int k = 0; k < 6; k++)
                {
                    if(m_2SameFuXuan[k].selected)
                        m_numZhu ++;
                }
            }
            else
            {
                int sameNum = 0;
                int unSameNum = 0;
                for (int j = 0; j < 6; j ++)
                {
                    if(m_2SameDanXuan[j].selected)
                        sameNum++;
                    if(m_2SameDanXuan[j+6].selected)
                        unSameNum++;
                }
                m_numZhu = sameNum * unSameNum;
            }
        } break;
        case kSegmentNoSameIndex:
        {
            int selectBallCount = 0;
            for (int k = 0; k < 6; k++)
            {
               if(m_noSameButtonArray[k].selected)
                   selectBallCount++;
            }
            if(m_select3NoSame.selected)
                m_numZhu = RYCChoose(3, selectBallCount);
            else
                m_numZhu = RYCChoose(2, selectBallCount);
        } break;
        case kSegment3ConnectedIndex:
        {
            m_numZhu = m_3ConnectedButton.selected ? 1 : 0;
        }break;
        default:
            break;
    }
    m_numCost = m_numZhu * 2;
    
    if (m_numZhu == 0&&self.segmentedView.segmentedIndex!=kSegment3ConnectedIndex&&!(self.segmentedView.segmentedIndex==kSegment3SameIndex &&m_tongButton3Same.selected==YES)) {
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
        totalStr = [NSString stringWithFormat:@" 您已选择了 %d 注，共 %d 元", m_numZhu, m_numCost];
    }
    
    self.totalCost.text = totalStr;
    
    CGSize totalStrSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:14]];
    CGRect frame1 = self.totalCost.frame;
    frame1.size.width = totalStrSize.width;
    self.totalCost.frame = frame1;
}

- (NSArray*)selectNumArrayWithType:(int)playType
{
    NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:1];
    switch (playType) {
        case kSegment3SameIndex:
        {
            for (int i = 0; i < 6; i++) {
                if(m_3SameDanXuan[i].selected)
                    [tempArray addObject:[NSString stringWithFormat:@"%d", i+1]];
            }
        }break;
        case kSegment2SameIndex:
        {
            if(m_fuButton2Same.selected)
            {
                for (int j = 0; j < 6; j++) {
                    if (m_2SameFuXuan[j].selected) {
                        [tempArray addObject:[NSString stringWithFormat:@"%d", j+1]];
                    }
                }
            }
            else
            {
                for (int danSame_2 = 0; danSame_2 < 12; danSame_2++) {
                    if(m_2SameDanXuan[danSame_2].selected)
                        [tempArray addObject:[NSString stringWithFormat:@"%d",danSame_2%6+1]];
                    else
                        [tempArray addObject:@"0"];
                }
            }
        }break;
        case kSegmentNoSameIndex:
        {
            for (int noSame = 0; noSame < 6; noSame++) {
                if (m_noSameButtonArray[noSame].selected) {
                    [tempArray addObject:[NSString stringWithFormat:@"%d", noSame+1]];
                }
            }
        }
        default:
            break;
    }
    return tempArray;
}

- (void)submitLotNotification:(NSNotification*)notification
{
	//显示你的订单详情，并生成投注信息
    NSString* disBetCode = @"";
    NSString* betCode = @"";
//    switch (self.animationTabView.selectButtonTag) {
    switch (self.segmentedView.segmentedIndex) {
        case kSegmentSumIndex:
        {
            NSArray*  sumArray = [m_ballViewSum selectedBallsArray];
            int sumCount = [sumArray count];
            betCode = [betCode stringByAppendingFormat:@"100001%02d",sumCount];
            for (int i = 0; i < sumCount; i++) {
                int nValue = [[sumArray objectAtIndex:i] intValue];
                if(i != sumCount - 1)
                {
                    betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", nValue];
                }
                else
                {
                    betCode = [betCode stringByAppendingFormat:@"%02d^", nValue];
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
                }
            }
        }break;
        case kSegment3SameIndex:
        {
            if (m_tongButton3Same.selected) {//三同号通选
                if(m_3SameTongXuan.selected)
                {
                    betCode = [betCode stringByAppendingString:@"400001^"];
                    disBetCode = [disBetCode stringByAppendingString:@"111,222,333,444,555,666"];
                }
            }
            else//三同号单选
            {
                NSArray*  sameArray_3 = [self selectNumArrayWithType:kSegment3SameIndex];
                int sameCount_3 = [sameArray_3 count];
                if (m_numZhu == 1) {//单式1注
                    betCode = [betCode stringByAppendingString:@"020001"];
                    int numValue = [[sameArray_3 objectAtIndex:0] intValue];
                    betCode = [betCode stringByAppendingFormat:@"%02d%02d%02d^", numValue, numValue, numValue];
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d%d%d", numValue, numValue, numValue];
                }
                else
                {
                    betCode = [betCode stringByAppendingFormat:@"810001%02d", sameCount_3];
                    for (int i = 0; i < sameCount_3; i++) {
                        int numValue = [[sameArray_3 objectAtIndex:i] intValue];
                        betCode = [betCode stringByAppendingFormat:@"%02d", numValue];
                        if(i != sameCount_3 - 1)
                            disBetCode = [disBetCode stringByAppendingFormat:@"%d%d%d,", numValue, numValue, numValue];
                        else
                            disBetCode = [disBetCode stringByAppendingFormat:@"%d%d%d", numValue, numValue, numValue];
                    }
                    betCode = [betCode stringByAppendingString:@"^"];
                }
            }
        }break;
        case kSegment2SameIndex:
        {
            if(m_fuButton2Same.selected)//二同号复选
            {
                NSArray* sameArray_2 = [self selectNumArrayWithType:kSegment2SameIndex];
                int sameCount_2 = [sameArray_2 count];
                 betCode = [betCode stringByAppendingFormat:@"300001%02d",sameCount_2];
                for (int j = 0; j < sameCount_2; j++) {
                    int numValue = [[sameArray_2 objectAtIndex:j] intValue];
                    betCode = [betCode stringByAppendingFormat:@"%02d", numValue];
                    if(j != sameCount_2 - 1)
                        disBetCode = [disBetCode stringByAppendingFormat:@"%d%d*,", numValue, numValue];
                    else
                        disBetCode = [disBetCode stringByAppendingFormat:@"%d%d*", numValue, numValue];
                }
                betCode = [betCode stringByAppendingString:@"^"];
            }
            else//二同号单选
            {
                NSArray*  sameDanArray_2 = [self selectNumArrayWithType:kSegment2SameIndex];
                if (m_numZhu == 1 ) {//单式一注
                    betCode = [betCode stringByAppendingString:@"010001"];
                    int sameCount = 0;
                    int noSameCount = 0;
                    for (int k = 0; k < 12; k++) {
                        int numValue = [[sameDanArray_2 objectAtIndex:k] intValue];
                        if(numValue != 0)
                        {
                            if(k < 6)
                            {
                                sameCount = numValue;
                                disBetCode = [disBetCode stringByAppendingFormat:@"%d%d,", numValue, numValue];
                            }
                            else
                            {
                                noSameCount = numValue;
                                disBetCode = [disBetCode stringByAppendingFormat:@"%d,", numValue];
                            }
                        }
                        if(k == 5)
                        {
                            disBetCode = [disBetCode substringWithRange:NSMakeRange(0, disBetCode.length-1)];//去掉末尾的逗号
                            disBetCode = [disBetCode stringByAppendingString:@"#"];
                        }
                    }
                    if (sameCount > noSameCount) {
                        betCode = [betCode stringByAppendingFormat:@"%02d%02d%02d", noSameCount, sameCount, sameCount];
                    }
                    else
                        betCode = [betCode stringByAppendingFormat:@"%02d%02d%02d", sameCount, sameCount, noSameCount];
                }
                else//多注
                {
                    betCode = [betCode stringByAppendingString:@"710001"];
                    for (int k = 0; k < 12; k++) {
                        int numValue = [[sameDanArray_2 objectAtIndex:k] intValue];
                        if(numValue != 0)
                        {
                            betCode = [betCode stringByAppendingFormat:@"%02d", numValue];
                            if(k < 6)
                            {
                                disBetCode = [disBetCode stringByAppendingFormat:@"%d%d,", numValue, numValue];
                            }
                            else
                            {
                                disBetCode = [disBetCode stringByAppendingFormat:@"%d,", numValue];
                            }
                        }
                        if(k == 5)
                        {
                            betCode = [betCode stringByAppendingString:@"*"];
                            disBetCode = [disBetCode substringWithRange:NSMakeRange(0, disBetCode.length-1)];//去掉末尾的逗号
                            disBetCode = [disBetCode stringByAppendingString:@"#"];
                        }
                    }
                }
                disBetCode = [disBetCode substringWithRange:NSMakeRange(0, disBetCode.length-1)];//去掉末尾的逗号
                betCode = [betCode stringByAppendingString:@"^"];
            }
        }break;
        case kSegmentNoSameIndex:
        {
            NSArray* noSameArray = [self selectNumArrayWithType:kSegmentNoSameIndex];
            int   noSameCount = [noSameArray count];
            if(m_select3NoSame.selected){//三不同号
                if (1 == m_numZhu) //单式
                    betCode = [betCode stringByAppendingString:@"000001"];
                else//复式
                    betCode = [betCode stringByAppendingFormat:@"630001%02d", noSameCount];
            }
            else{//二不同号
                if(1 == m_numZhu)
                    betCode = [betCode stringByAppendingString:@"20000101"];
                else
                    betCode = [betCode stringByAppendingFormat:@"210001%02d", noSameCount];
            }
            for (int k = 0; k < noSameCount; k++) {
                int numValue = [[noSameArray objectAtIndex:k] intValue];
                if (m_select2NoSame.selected && 1 == m_numZhu) {
                    betCode = [betCode stringByAppendingFormat:@"%01d", numValue];
                }
                else
                    betCode = [betCode stringByAppendingFormat:@"%02d", numValue];
            }
            betCode = [betCode stringByAppendingString:@"^"];
            for (int k = 0; k < noSameCount; k++) {//显示数据
                int numValue = [[noSameArray objectAtIndex:k] intValue];
                if (noSameCount - 1 != k)
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,", numValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d", numValue];
            }
        }break;
        case kSegment3ConnectedIndex:
        {
            betCode = [betCode stringByAppendingString:@"500001^"];
            disBetCode = [disBetCode stringByAppendingString:@"123,234,345,456"];
        }break;
        default:
            break;
    }
    NSLog(@"betcode:%@",betCode);

    [RuYiCaiLotDetail sharedObject].sellWay = @"0";
    if (m_numZhu > 1) {
        [RuYiCaiLotDetail sharedObject].isShouYiLv = NO;
    }
    else
        [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;

    //生成投注基本信息
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoNMK3;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_numZhu];
        
    if(!isMoreBet)
        [self betNormal:nil];
}

#pragma mark 投注
- (void)betNormal:(NSNotification*)notification
{
    if(m_numCost > kMaxBetCost)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单个方案注数不能超过10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    [self setHidesBottomBarWhenPushed:YES];
	RYCHighBetView* viewController = [[RYCHighBetView alloc] init];
	viewController.navigationItem.title = @"快三投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
#pragma mark 单选按钮和选号按钮
- (void)ballButtonClick:(id)sender
{
    UIButton* temButton = (UIButton*)sender;
    temButton.selected = !temButton.selected;
//    switch (self.animationTabView.selectButtonTag)
    switch (self.segmentedView.segmentedIndex)
    {
        case kSegmentNoSameIndex:
        {
            NSInteger noSameCount = 0;
            for (int i = 0; i < 6; i ++) {
                if(m_noSameButtonArray[i].selected)
                    noSameCount ++;
            }
            m_showSelectBallWarnView.hidden = YES;
            if(m_select3NoSame.selected)
            {
                if(noSameCount < 3)
                {
                    m_showSelectBallWarnView.hidden = NO;
                    m_selectBallWarnLabel.text = [NSString stringWithFormat:@"至少还要选%d个号码", 3 - noSameCount];
                    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];
                    [self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
                }
            }
            else
            {
                if(noSameCount < 2)
                {
                    m_showSelectBallWarnView.hidden = NO;
                    m_selectBallWarnLabel.text = [NSString stringWithFormat:@"至少还要选%d个号码", 2 - noSameCount];
                    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];
                    [self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
                }
            }
        }break;
        default:
            break;
    }
    [self updateBallState:nil];
}

- (void)beforeSelectButtonClick:(id)sender
{
    m_showSelectBallWarnView.hidden = YES;
    switch (self.segmentedView.segmentedIndex)
    {
        case kSegment3SameIndex:
        {
            if(m_tongButton3Same.selected)
                return;
            
            NSLog(@"三同号-通选");
            [self getMissdateForServersWithPalyType:@"F47108MV_40"];
            
            m_tongButton3Same.selected = m_danButton3Same.selected;
            m_danButton3Same.selected = !m_tongButton3Same.selected;
            [self update3SameView];
        }break;
        case kSegment2SameIndex:
        {
            if(m_fuButton2Same.selected)
                return;
            
            NSLog(@"二同号-复选");
            [self getMissdateForServersWithPalyType:@"F47108MV_30"];
            m_fuButton2Same.selected = m_danButton2Same.selected;
            m_danButton2Same.selected = !m_fuButton2Same.selected;
            [self update2SameView];
        }break;
        case kSegmentNoSameIndex:
        {
            if(m_select3NoSame.selected)
                return;
            
            NSLog(@"三不同号");
            [self getMissdateForServersWithPalyType:@"F47108MV_BASE"];
            m_select3NoSame.selected = m_select2NoSame.selected;
            m_select2NoSame.selected = !m_select3NoSame.selected;
            [self upDateNoSameView];
        }break;
        default:
            break;
    }
    
}

- (void)afterSelectButtonClick:(id)sender
{
    m_showSelectBallWarnView.hidden = YES;
    switch (self.segmentedView.segmentedIndex)
    {
        case kSegment3SameIndex:
        {
            NSLog(@"三同号 单选");
            if(m_danButton3Same.selected)
                return;
            
            [self getMissdateForServersWithPalyType:@"F47108MV_02"];
            m_danButton3Same.selected = m_tongButton3Same.selected;
            m_tongButton3Same.selected = !m_danButton3Same.selected;
            [self update3SameView];
        }break;
        case kSegment2SameIndex:
        {
            NSLog(@"二同号 单选");
            if(m_danButton2Same.selected)
                return;
            [self getMissdateForServersWithPalyType:@"F47108MV_01"];
            m_danButton2Same.selected = m_fuButton2Same.selected;
            m_fuButton2Same.selected = !m_danButton2Same.selected;
            [self update2SameView];
        }break;
        case kSegmentNoSameIndex:
        {
            
            if(m_select2NoSame.selected)
                return;
            
            NSLog(@"二不同号");
            [self getMissdateForServersWithPalyType:@"F47108MV_BASE"];
            m_select2NoSame.selected = m_select3NoSame.selected;
            m_select3NoSame.selected = !m_select2NoSame.selected;
            [self upDateNoSameView];
        }break;
        default:
            break;
    }
}

#pragma mark button事件
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
    switch (self.segmentedView.segmentedIndex) {
        case kSegmentSumIndex:
        {
            [m_ballViewSum clearBallState];
        }break;
        case kSegment3SameIndex:
        {
            if(m_tongButton3Same.selected)
                m_3SameTongXuan.selected = NO;
            else
            {
                for (int i = 0; i < 6; i++) {
                    m_3SameDanXuan[i].selected = NO;
                }
            }
        }break;
        case kSegment2SameIndex:
        {
            if(m_fuButton2Same.selected)
            {
                for (int j = 0; j < 6; j++) {
                    m_2SameFuXuan[j].selected = NO;
                }
            }
            else
            {
                for (int k = 0; k < 12; k++) {
                    m_2SameDanXuan[k].selected = NO;
                }
            }
        }break;
        case kSegmentNoSameIndex:
        {
            for (int i = 0; i < 6; i++) {
                m_noSameButtonArray[i].selected = NO;
            }
        }break;
        case kSegment3ConnectedIndex:
        {
            m_3ConnectedButton.selected = NO;
        }break;
        default:
            break;
    }
    [self updateBallState:nil];
}

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
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoNMK3;
    [self setHidesBottomBarWhenPushed:YES];
    
    MoreBetListViewController  *viewController = [[MoreBetListViewController alloc] init];
    viewController.title = @"快三";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];

}

#pragma mark 下拉菜单
- (void)setDetailView
{
    m_lastBatchCodeLabel = [[UILabel alloc] init];
    m_lastBatchCodeLabel.textColor = [UIColor blackColor];
    m_lastBatchCodeLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    m_lastBatchCodeLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_lastBatchCodeLabel];
    
    m_winRedNumLabel = [[UILabel alloc] init];
    m_winRedNumLabel.textColor = [UIColor redColor];
    m_winRedNumLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    m_winRedNumLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_winRedNumLabel];

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
    //
    
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

//- (void)setDetailView
//{
//    m_lastBatchCodeLabel = [[UILabel alloc] init];
//    m_lastBatchCodeLabel.textColor = [UIColor blackColor];
//    m_lastBatchCodeLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
//    m_lastBatchCodeLabel.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:m_lastBatchCodeLabel];
//    
//    m_winRedNumLabel = [[UILabel alloc] init];
//    m_winRedNumLabel.textColor = [UIColor redColor];
//    m_winRedNumLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
//    m_winRedNumLabel.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:m_winRedNumLabel];
//    if(m_detailView != nil)
//    {
//        [m_detailView release], m_detailView = nil;
//    }
//    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 153, 160)];
//    m_detailView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView* imgBg = [[CommonRecordStatus commonRecordStatusManager] creatFourButtonView];
//    [m_detailView addSubview:imgBg];
//    
//    UIButton* PresentSituButton = [[CommonRecordStatus commonRecordStatusManager] creatPresentSituButton:CGRectMake(5, 89, 140, 30)];
//    [PresentSituButton addTarget:self action:@selector(PresentSituButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* introButton = [[CommonRecordStatus commonRecordStatusManager] creatIntroButton:CGRectMake(5, 12, 140, 30)];
//    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* historyButton = [[CommonRecordStatus commonRecordStatusManager] creatHistoryButton:CGRectMake(5, 49, 140, 30)];
//    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton* QuerybetLotButton = [[CommonRecordStatus commonRecordStatusManager] creatQuerybetLotButton:CGRectMake(5, 125, 140, 30)];
//    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
////    UIButton* luckButton = [[CommonRecordStatus commonRecordStatusManager] creatLuckButton:CGRectMake(5, 162, 140, 30)];
////    [luckButton addTarget:self action:@selector(luckButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [m_detailView addSubview:introButton];
//    [m_detailView addSubview:historyButton];
//    [m_detailView addSubview:PresentSituButton];
//    [m_detailView addSubview:QuerybetLotButton];
////    [m_detailView addSubview:luckButton];
//    
//    [self.view addSubview:m_detailView];
//    
//    m_detailView.hidden = YES;
//}

//- (void)detailViewButtonClick:(id)sender
//{
//    CATransition *transition = [CATransition animation];
//    transition.duration = .5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
//    if(m_detailView.hidden)
//    {
//        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [m_detailView.layer addAnimation:transition forKey:nil];
//        m_detailView.hidden = NO;
//    }
//    else
//    {
//        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
//        [m_detailView.layer addAnimation:transition forKey:nil];
//        m_detailView.hidden = YES;
//    }
//}
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
- (void)queryBetLotButtonClick:(id)sender
{
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoNMK3;
    if (![[RuYiCaiNetworkManager sharedManager] hasLogin]) {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    else
    {
        [self setupQueryLotBetViewController];
    }
}

- (void)playIntroButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    PlayIntroduceViewController* viewController = [[PlayIntroduceViewController alloc] init];
    viewController.lotNo = kLotNoNMK3;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
- (void)historyLotteryClick:(id)sender
{
    //历史开奖
    [self setHidesBottomBarWhenPushed:YES];
    
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.lotTitle = kLotTitleNMK3;
    viewController.lotNo = kLotNoNMK3;
    viewController.VRednumber = 6;
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
    viewController.lotTitle = kLotTitleNMK3;
    viewController.lotNo = kLotNoNMK3;
    viewController.VRednumber = 6;
    viewController.VBluenumber = 0;
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController refreshLotteryAwardInfo];
    [viewController release];
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
    [viewController setSelectLotNo:kLotNoNMK3];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}

#pragma mark 多注投
- (void)setMoreBet
{
    
}

#pragma mark NSTimer method
- (void)updateInformation:(NSNotification*)notification
{
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
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
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
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"快三%@期时间已到，进入下一期" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
 	    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoNMK3];
        
//        //重新获取遗漏值
//        NSDictionary *startDic = [[NSDictionary alloc] init];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex5X withObject:startDic];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndexDD withObject:startDic];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex2XZ withObject:startDic];
//        [m_recoderYiLuoDateArr replaceObjectAtIndex:kMissDateIndex2XH withObject:startDic];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kBackAlterTag)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag == kAlterTag3Same)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            for (int i=0; i<6; i++)
            {
                UIButton *btn =(UIButton*) [self.scroll3Same viewWithTag:(k2SameDanButtonStartTag+i)];
                btn.selected=NO;
            }
            m_randomNumber=100;
            [self getYaoYiYaoNum:nil];
            [self updateBallState:nil];
        }
    }
    else if(alertView.tag == kAlterTag2Same)
    {
        
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            for (int i=0; i<6; i++)
            {
                UIButton *btn =(UIButton*) [self.scroll2Same viewWithTag:(k2SameDanButtonStartTag+i)];
                btn.selected=NO;
            }
            m_2SameRandomNumber=100;
            [self getYaoYiYaoNum:0];
            [self updateBallState:nil];
        }
    }
    else if(alertView.tag == kAlterTag2SameDan)
    {
        
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            for (int i=0; i<12; i++)
            {
                UIButton *btn =(UIButton*) [m_2sameDanXuanScroll viewWithTag:(k2SameDanButtonStartTag+i)];
                btn.selected=NO;
            }
            m_2SameDanRandomNumber=100;
            m_2SameDanRandomNext = 100;
            [self getYaoYiYaoNum:1];
            [self updateBallState:nil];
        }
    }
    else if(alertView.tag == kAlterTag3NoSame)
    {
        
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            for (int i=0; i<6; i++)
            {
                UIButton *btn =(UIButton*) [self.scrollNoSame viewWithTag:(k2SameDanButtonStartTag+i)];
                btn.selected=NO;
            }
            m_3NoSameRandomNum1=100;
            m_3NoSameRandomNum2=100;
            m_3NoSameRandomNum3=100;
            [self getYaoYiYaoNum:0];
            [self updateBallState:nil];
        }
    }
    else if(alertView.tag == kAlterTag2NoSame)
    {
        
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            for (int i=0; i<6; i++)
            {
                UIButton *btn =(UIButton*) [self.scrollNoSame viewWithTag:(k2SameDanButtonStartTag+i)];
                btn.selected=NO;
            }
            m_2NoSameRandomNum1=100;
            m_2NoSameRandomNum2=100;
            [self getYaoYiYaoNum:1];
            [self updateBallState:nil];
        }
    }
    else
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            [self getYaoYiYaoNum:nil];
            [self updateBallState:nil];
        }
    }
    
}


//遗漏
- (void)getMissdateForServersWithPalyType:(NSString *)type{
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
    [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoNMK3 sellWay:type];
    
}
- (void)getMissDateOK:(NSNotification*)notification{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].netMissDate];
    [jsonParser release];
    
    switch (self.segmentedView.segmentedIndex) {
        case kSegmentSumIndex:
        {
            NSLog(@"miss date:%@",[[parserDict objectForKey:@"result"] objectForKey:@"miss"]);
            [self.ballViewSum creatYiLuoViewWithData:[[parserDict objectForKey:@"result"] objectForKey:@"miss"] rowNumber:9];   
        }break;
        case kSegment3SameIndex:
        {
            if(m_tongButton3Same.selected){
                NSLog(@"三同号 通选 遗漏获取");
                NSLog(@"miss date:%@",[[[parserDict objectForKey:@"result"] objectForKey:@"miss"]objectAtIndex:0]);
                NSString *num = [[[parserDict objectForKey:@"result"] objectForKey:@"miss"]objectAtIndex:0];
                [m_3SameTongXuanYiLou setTextColor:[UIColor redColor]];
                [m_3SameTongXuanYiLou setText:[NSString stringWithFormat:@"%@",num]];
            }else{
                NSLog(@"三同号 单选 遗漏获取");
                NSLog(@"遗漏:%@",parserDict);
                NSArray *arr = [[parserDict objectForKey:@"result"] objectForKey:@"miss"];
                
                
                NSInteger largIndex;
                NSInteger largIndex_two;
                [self bigTwoNumber:arr maxOne:&largIndex maxTwo:&largIndex_two];
                for (int i = 0; i< [arr count]; i++) {
                    [m_3SameDanXuanYiLou[i] setText:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]];
                    
                    if(largIndex == i || largIndex_two == i)
                    {
                        [m_3SameDanXuanYiLou[i] setTextColor:[UIColor redColor]];
                    }
                    else
                    {
                        [m_3SameDanXuanYiLou[i] setTextColor:[UIColor grayColor]];
                    }
                }
            }
            
        } break;
        case kSegment2SameIndex:
        {
            if(m_fuButton2Same.selected){
                NSLog(@"二同号 复选 遗漏获取");
                NSLog(@"遗漏:%@",parserDict);
                NSArray *arr = [[parserDict objectForKey:@"result"] objectForKey:@"miss"];
                
                
                NSInteger largIndex;
                NSInteger largIndex_two;
                [self bigTwoNumber:arr maxOne:&largIndex maxTwo:&largIndex_two];

                for (int i = 0; i< [arr count]; i++) {
                    [m_2SameFuXuanYiLou[i] setText:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]];
                    if(largIndex == i || largIndex_two == i)
                    {
                        [m_2SameFuXuanYiLou[i] setTextColor:[UIColor redColor]];
                    }
                    else
                    {
                        [m_2SameFuXuanYiLou[i] setTextColor:[UIColor grayColor]];
                    }
                }
            }else{
                NSLog(@"二同号 单选 遗漏获取");
                NSLog(@"遗漏:%@",parserDict);
                NSArray *arrDan = [[parserDict objectForKey:@"result"] objectForKey:@"dan"];
                NSArray *arrShuang = [[parserDict objectForKey:@"result"] objectForKey:@"shuang"];
                
                NSInteger largDanIndex;
                NSInteger largDanIndex_two;
                [self bigTwoNumber:arrDan maxOne:&largDanIndex maxTwo:&largDanIndex_two];
                for (int i = 0; i< [arrDan count]; i++) {
                    [m_2SameDanXuanYiLou[i] setText:[NSString stringWithFormat:@"%@",[arrDan objectAtIndex:i]]];
                    if(largDanIndex == i || largDanIndex_two == i)
                    {
                        [m_2SameDanXuanYiLou[i] setTextColor:[UIColor redColor]];
                    }
                    else
                    {
                        [m_2SameDanXuanYiLou[i] setTextColor:[UIColor grayColor]];
                    }
                }
                
                NSInteger largShuangIndex;
                NSInteger largShuangIndex_two;
                [self bigTwoNumber:arrShuang maxOne:&largShuangIndex maxTwo:&largShuangIndex_two];

                for (int j = 0; j< [arrShuang count]; j++) {
                    [m_2SameDanXuanYiLou[j + [arrDan count]] setText:[NSString stringWithFormat:@"%@",[arrShuang objectAtIndex:j]]];
                    
                    if(largShuangIndex == j || largShuangIndex_two == j)
                    {
                        [m_2SameDanXuanYiLou[j + [arrDan count]] setTextColor:[UIColor redColor]];
                    }
                    else
                    {
                        [m_2SameDanXuanYiLou[j + [arrDan count]] setTextColor:[UIColor grayColor]];
                    }
                }
            }
            
        } break;
        case kSegmentNoSameIndex:
        {
            if(m_select3NoSame.selected){
                NSLog(@"不同号-三不同号 遗漏获取");
            }else{
                NSLog(@"不同号-儿不同号 遗漏获取");
            }
            
            NSLog(@"遗漏:%@",parserDict);
            NSArray *arr = [[parserDict objectForKey:@"result"] objectForKey:@"miss"];
            NSInteger largIndex;
            NSInteger largIndex_two;
            [self bigTwoNumber:arr maxOne:&largIndex maxTwo:&largIndex_two];

            for (int i = 0; i< [arr count]; i++) {
                [m_noSameYiLou[i] setText:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]];
                if(largIndex == i || largIndex_two == i)
                {
                    [m_noSameYiLou[i] setTextColor:[UIColor redColor]];
                }
                else
                {
                    [m_noSameYiLou[i] setTextColor:[UIColor grayColor]];
                }
            }
        } break;
        case kSegment3ConnectedIndex:
        {
            NSLog(@"三连号 遗漏获取");
            NSLog(@"遗漏:%@",parserDict);
            NSString *num = [[[parserDict objectForKey:@"result"] objectForKey:@"miss"]objectAtIndex:0];
            [m_3ConnectedYiLou setTextColor:[UIColor redColor]];
            [m_3ConnectedYiLou setText:[NSString stringWithFormat:@"%@",num]];
            
        }break;
        default:
            break;
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
    if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentSumIndex)
    {
        if ([m_ballViewSum getSelectNum] == 0 )
        {
            [self getYaoYiYaoNum:nil];
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
    }else if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegment3SameIndex && !m_tongButton3Same.selected)
    {
        if (m_randomNumber == 100 )
        {
            [self getYaoYiYaoNum:nil];
            [self updateBallState:nil];
        }
        else
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alterView addButtonWithTitle:@"确定"];
            alterView.delegate = self;
            alterView.tag = kAlterTag3Same;
            [alterView show];
            
            [alterView release];
            return;
        }

    }else if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegment2SameIndex && m_fuButton2Same.selected)
    {
        if (m_2SameRandomNumber == 100 )
        {
            [self getYaoYiYaoNum:0];
            [self updateBallState:nil];
        }
        else
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alterView addButtonWithTitle:@"确定"];
            alterView.delegate = self;
            alterView.tag = kAlterTag2Same;
            [alterView show];
            
            [alterView release];
            return;
        }
        
    }
    else if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegment2SameIndex && m_danButton2Same.selected)
    {
        if (m_2SameDanRandomNumber == 100 && m_2SameDanRandomNext==100)
        {
            [self getYaoYiYaoNum:1];
            [self updateBallState:nil];
        }
        else
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alterView addButtonWithTitle:@"确定"];
            alterView.delegate = self;
            alterView.tag = kAlterTag2SameDan;
            [alterView show];
            
            [alterView release];
            return;
        }
        
    }
    else if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentNoSameIndex && m_select3NoSame.selected)
    {
        if (m_3NoSameRandomNum1 == 100 && m_3NoSameRandomNum2 == 100 && m_3NoSameRandomNum3 == 100)
        {
            [self getYaoYiYaoNum:0];
            [self updateBallState:nil];
        }
        else
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alterView addButtonWithTitle:@"确定"];
            alterView.delegate = self;
            alterView.tag = kAlterTag3NoSame;
            [alterView show];
            
            [alterView release];
            return;
        }
        
    }
    else if (motion == UIEventSubtypeMotionShake && m_delegate.isStartYaoYiYao  && self.segmentedView.segmentedIndex == kSegmentNoSameIndex && m_select2NoSame.selected)
    {
        if (m_2NoSameRandomNum1 == 100 && m_2NoSameRandomNum2 == 100)
        {
            [self getYaoYiYaoNum:1];
            [self updateBallState:nil];
        }
        else
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选球吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alterView addButtonWithTitle:@"确定"];
            alterView.delegate = self;
            alterView.tag = kAlterTag2NoSame;
            [alterView show];
            
            [alterView release];
            return;
        }
        
    }

    
}

//index标示是每个不通玩法的第一个摇一摇还是第二个摇一摇，譬如，而不同，如果index是0标示第一个玩法即复选1是单选
- (void) getYaoYiYaoNum :(int)index
{
    switch (self.segmentedView.segmentedIndex)
    {
        case kSegmentSumIndex:
            [m_ballViewSum randomBall:1];
            break;
        case kSegment3SameIndex:
           [self randomButton:6 isButtonType:kIs3SameNumKey isDanFuType:nil];
            break;
        case kSegment2SameIndex:
            if (index==0) {
                [self randomButton:6 isButtonType:kIs2SameNumKey isDanFuType:kIs2SameNumFuKey];
            }else if (index==1)
            {
                [self randomButton:6 isButtonType:kIs2SameNumKey isDanFuType:kIs2SameNumDanKey];
            }
            break;
        case kSegmentNoSameIndex:
            if (index==0) {
                [self randomButton:6 isButtonType:kIsNoSameNumKey isDanFuType:kIs3NoSameNumKey];
            }else if (index==1)
            {
                [self randomButton:6 isButtonType:kIsNoSameNumKey isDanFuType:kIs2NoSameNumKey];
            }
            break;
        default:
            break;
    }
}
- (void)randomButton:(int)sender isButtonType:(NSString *)type isDanFuType:(NSString *)danFuType
{
    if ([type isEqualToString:kIs3SameNumKey]) {
        if (m_randomNumber==100)
        {
            m_randomNumber = arc4random() % sender;
            UIButton *btn =(UIButton*) [self.scroll3Same viewWithTag:(k2SameDanButtonStartTag+m_randomNumber)];
            
            btn.selected=YES;
        }
    }
    else if([type isEqualToString:kIs2SameNumKey])
    {
        if ([danFuType isEqualToString:kIs2SameNumFuKey]) {
            if (m_2SameRandomNumber==100)
            {
                m_2SameRandomNumber = arc4random() % sender;
                UIButton *btn =(UIButton*) [self.scroll2Same viewWithTag:(k2SameDanButtonStartTag+m_2SameRandomNumber)];
                
                btn.selected=YES;
            }
        }else if([danFuType isEqualToString:kIs2SameNumDanKey])
        {
            if (m_2SameDanRandomNumber==100 && m_2SameDanRandomNext==100)
            {
                m_2SameDanRandomNumber = arc4random() % sender;
                UIButton *btn =(UIButton*) [m_2sameDanXuanScroll viewWithTag:(k2SameDanButtonStartTag+m_2SameDanRandomNumber)];
                btn.selected=YES;
                
                 m_2SameDanRandomNext = [self recursion:sender two:m_2SameDanRandomNumber];
                
                UIButton *btnNext =(UIButton*) [m_2sameDanXuanScroll viewWithTag:(k2SameDanButtonStartTag+m_2SameDanRandomNext+6)];
                
                
                btnNext.selected=YES;
                
            }
        }
    
    }
    else if([type isEqualToString:kIsNoSameNumKey])
    {
        if ([danFuType isEqualToString:kIs3NoSameNumKey]) {
            if (m_3NoSameRandomNum1 == 100 && m_3NoSameRandomNum2 == 100 && m_3NoSameRandomNum3 == 100)
            {
                m_3NoSameRandomNum1 = arc4random() % sender;
                UIButton *btn =(UIButton*) [self.scrollNoSame viewWithTag:(k2SameDanButtonStartTag+m_3NoSameRandomNum1)];
                btn.selected=YES;
                m_3NoSameRandomNum2 = [self recursion:sender two:m_3NoSameRandomNum1];
                UIButton *btnTwo =(UIButton*) [self.scrollNoSame viewWithTag:(k2SameDanButtonStartTag+m_3NoSameRandomNum2)];
                btnTwo.selected = YES;
                
                
                m_3NoSameRandomNum3 = [self recursionTwo:sender];
                UIButton *threeBtn =(UIButton*) [self.scrollNoSame viewWithTag:(k2SameDanButtonStartTag+m_3NoSameRandomNum3)];
                threeBtn.selected = YES;
                NSLog(@"m_3NoSameRandomNum1%d----%d----%d",m_3NoSameRandomNum1,m_3NoSameRandomNum2,m_3NoSameRandomNum3);
                
            }
        }else if([danFuType isEqualToString:kIs2NoSameNumKey])
        {
            if (m_2NoSameRandomNum1 == 100 && m_2NoSameRandomNum2 == 100)
            {
                m_2NoSameRandomNum1 = arc4random() % sender;
                UIButton *btn =(UIButton*) [self.scrollNoSame viewWithTag:(k2SameDanButtonStartTag+m_2NoSameRandomNum1)];
                btn.selected=YES;
                m_2NoSameRandomNum2 = [self recursion:sender two:m_2NoSameRandomNum1];
                UIButton *btnTwo =(UIButton*) [self.scrollNoSame viewWithTag:(k2SameDanButtonStartTag+m_2NoSameRandomNum2)];
                btnTwo.selected = YES;
                NSLog(@"m_2NoSameRandomNum2%d----%d",m_2NoSameRandomNum1,m_2NoSameRandomNum2);
            }
        }
        
    }
    
}

- (int)recursion :(int)sender two:(int)twoNum
{
    int sameDanNext;
    int index = sender;
    
    do {
        sameDanNext = arc4random() % index;
    } while (sameDanNext == twoNum);
    
    return sameDanNext;
}
//递归两个数，第三个数与前两个都不同才返回值
- (int)recursionTwo :(int)sender
{
    int sameDanNext;
    int index = sender;
    
    do {
        sameDanNext = arc4random() % index;
    } while (sameDanNext == m_3NoSameRandomNum2 || sameDanNext == m_3NoSameRandomNum1);
        
    return sameDanNext;
    
}


#pragma mark -CustomSegmentedControlDelegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"customer segmented  %d",index);
    [self segmentedChangeValue:index];
}

- (void)bigTwoNumber:(NSArray*)dataA maxOne:(int*)maxOneIndex maxTwo:(int*)maxTwoIndex
{
    if([dataA count] < 2)
    {
        return;
    }
    if([[dataA objectAtIndex:0] intValue] > [[dataA objectAtIndex:1] intValue])
    {
        *maxOneIndex = 0;
        *maxTwoIndex = 1;
    }
    else
    {
        *maxOneIndex = 1;
        *maxTwoIndex = 0;
    }
    for(int i = 2; i < [dataA count]; i++)
    {
        if([[dataA objectAtIndex:i] intValue] > [[dataA objectAtIndex:*maxOneIndex] intValue])
        {
            *maxTwoIndex = *maxOneIndex;
            *maxOneIndex = i;
        }
        else if([[dataA objectAtIndex:i] intValue] > [[dataA objectAtIndex:*maxTwoIndex] intValue])
        {
            *maxTwoIndex = i;
        }
    }
}
@end
