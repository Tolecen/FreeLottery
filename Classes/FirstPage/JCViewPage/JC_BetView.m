//
//  JC_BetView.m
//  RuYiCai
//
//  Created by ruyicai on 12-5-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//


#import "JC_BetView.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiCommon.h"
#import "GiftViewController.h"
#import "LaunchHMViewController.h"
#import "LaunchHMViewController.h"
#import "AnimationTabView.h"
#import "RYCNormalBetView.h"
#import "JC_LaunchHMViewController_copy.h"
#import "ChangeViewController.h"
#import "DirectPaymentViewController.h"
#import "NotEnoughMoneyViewController.h"
#import "BetCompleteViewController.h"

#import "JC_AttentionDataManagement.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ExchangeLotteryWithIntegrationViewController.h"

@interface JC_BetView (internal)

- (void)FreePassButtonClick;
- (void)DuoChuanPassButtonClick;

- (void)setFreePassScollView;
- (void)setDuoChuanPassScollView;

- (void)freePassRadioButtonClick:(id)sender;
- (void)duoChuanPassRadioButtonClick:(id)sender;

- (void)CreatFreePassRadio:(CGRect)rect Title:(NSString*)title isSelect:(BOOL)select Tag:(NSInteger)radioTag ISCLICK:(BOOL) isClick;
- (void)CreatDuoChuanPassRadio:(CGRect)rect Title:(NSString*)title isSelect:(BOOL)select Tag:(NSInteger)radioTag ISCLICK:(BOOL) isClick;

-(NSInteger) getNoteNumberByDuoChuanRadioTag:(NSString*)DuoChuanRadioTag;

-(float) getMinWinAmountByX:(NSInteger)X;

- (void)tabButtonChanged:(NSNotification*)notification;
- (void)hideKeybord;

- (BOOL) BetJudement;
@end

@implementation JC_BetView

@synthesize srollView_normalBet;
@synthesize srollView_HMBet;
@synthesize LaunchHMView = m_LaunchHMView;
@synthesize buyButton;

@synthesize lotTitleLabel;
@synthesize allCountLabel;
@synthesize gameCountLabel;
@synthesize betNumberLable;
@synthesize betCodeList;
@synthesize jiaBeishuButton;
@synthesize jianBeishuButton;
@synthesize fieldBeishu;
@synthesize winAmount;
@synthesize view_down;

@synthesize image_sanjiao;

@synthesize duoChuanChooseArray = m_duoChuanChooseArray;
@synthesize isDanGuan = m_isDanGuan;
@synthesize allCount = m_allCount;
@synthesize gameCount = m_gameCount;
@synthesize freePassScollView = m_freePassScollView;
@synthesize DuoChuanPassScollView = m_DuoChuanPassScollView;
@synthesize twoCount = m_twoCount;
@synthesize chooseBetCode = m_chooseBetCode;
@synthesize betNumber = m_betNumber;
@synthesize arrangeSP_Min = m_Com_arrangeSP_Min;
@synthesize arrangeSP_Max = m_Com_arrangeSP_Max;

@synthesize playTypeTag = m_playTypeTag;
@synthesize confusion_type = m_confusion_type;

@synthesize eventChooseGameArray = m_eventChooseGameArray;
@synthesize userChooseGameEvent = m_userChooseGameEvent;
@synthesize jc_type = m_jc_type;
@synthesize cusSegmented = m_cusSegmented;

#define kSegIndexNormal (0)
#define kSegIndexHM     (1)
#define kMoveDownHeight 120
#define kFangAnXiangQingViewTag 111
#define kLaunchHMMaxScrollContentHeight 870

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"launchViewContentSizeCahnge" object:nil];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [_getShareDetileDic release];
    [m_cusSegmented release];
    [srollView_normalBet release];
    [srollView_HMBet release];
    [m_LaunchHMView release];
    [buyButton release];
    
    [m_chooseBetCode release];
    //    [m_freePassRadioArray release];
    [m_duoChuanPassRadioArray release], m_duoChuanPassRadioArray = nil;
    [m_FreePassButton release];
    [m_DuoChuanPassButton release];
    [m_freePassScollView release];
    if (m_DuoChuanPassScollView != nil) {
        [m_DuoChuanPassScollView release], m_DuoChuanPassScollView = nil;
    }
    
    [m_image_bottom release];
    [m_image_top release];
    
    [lotTitleLabel release];
    [allCountLabel release];
    [gameCountLabel release];
    [betNumberLable release];
    
    [betCodeList release];
    [jiaBeishuButton release];
    [jianBeishuButton release];
    [fieldBeishu release];
    [m_duoChuanChooseArray release], m_duoChuanChooseArray = nil;
    [m_Com_arrangeSP_Min release];
    [m_Com_arrangeSP_Max release];
    [m_Com_SParray release];
    [freePassRadioIndexArray release], freePassRadioIndexArray = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchViewContentSizeCahnge:) name:@"launchViewContentSizeCahnge" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    //选择开关按钮
    self.cusSegmented = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(25, 5, 264, 30)
                                                      andNormalImages:[NSArray arrayWithObjects:
                                                                       @"segment_high_bet_tz_nomarl.png",
                                                                       @"segment_high_bet_hm_nomarl.png",
                                                                       nil]
                                                 andHighlightedImages:[NSArray arrayWithObjects:
                                                                       @"segment_high_bet_tz_nomarl.png",
                                                                       @"segment_high_bet_hm_nomarl.png",
                                                                       nil]
                                                       andSelectImage:[NSArray arrayWithObjects:
                                                                       @"segment_high_bet_tz_click.png",
                                                                       @"segment_high_bet_hm_click.png",
                                                                       nil]]autorelease];
    
    self.cusSegmented.delegate = self;
    //    [self segmentedChangeValue:0];
    [self.view addSubview:m_cusSegmented];

    
    m_betCodeListHeight = [self getBetCodeListHeight];
    
    freePassRadioIndexArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    
    m_LaunchHMView = [[JC_LaunchHMViewController_copy alloc] init];
    m_LaunchHMView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, /*[UIScreen mainScreen].bounds.size.height - 64 - 60 - 42*/1000);
    m_LaunchHMView.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    
    //大的scrollView
    self.srollView_HMBet.frame = CGRectMake(0, 43, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 162);
    [self.srollView_HMBet addSubview:m_LaunchHMView.view];
    self.srollView_HMBet.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, kLaunchHMMaxScrollContentHeight - 120);
    
    self.srollView_normalBet.hidden = NO;
    self.srollView_normalBet.frame = CGRectMake(0,43, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 60 - 42);
    
    self.srollView_HMBet.hidden = YES;
    
    self.fieldBeishu.delegate = self;
    
    self.fieldBeishu.text = @"1";
    m_DanCount = 0;
    m_allCount = [[RuYiCaiLotDetail sharedObject].amount intValue];
    
    //    m_betNumber = [self getFreeChuanBetNum:2];//2串1
    
    //    self.allCountLabel.text = [NSString stringWithFormat:@"共%d元",[[RuYiCaiLotDetail sharedObject].amount intValue]/100];
    self.gameCountLabel.text = [NSString stringWithFormat:@"共%d场",m_gameCount];
    [RuYiCaiLotDetail sharedObject].lotMulti = @"1";//倍数
    
    NSString* betCodeListStr = [RuYiCaiLotDetail sharedObject].disBetCode;
    betCodeListStr = [betCodeListStr stringByReplacingOccurrencesOfString:@"," withString:@" "];//去掉 button中的，
    [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", betCodeListStr] forState:UIControlStateNormal];
    
    //胆
    for (int i = 0; i < [[m_duoChuanChooseArray combineList] count]; i++) {
        if ([(CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] isDan]) {
            m_DanCount++;
        }
    }
    
    if (m_playTypeTag == IJCLQPlayType_SF_DanGuan ||
        m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan ||
        m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan ||
        
        m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan ||
        m_playTypeTag == IJCZQPlayType_Score_DanGuan||
        m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan ||
        m_playTypeTag == IJCZQPlayType_SPF_DanGuan
        )
    {
        m_isDanGuan = TRUE;
        //        m_betNumber = [self getFreeChuanBetNum:1];//没有过关方式
        m_betNumber = m_gameCount + m_twoCount;
    }
    else
    {
        
        //默认显示 自由过关
        m_isFreePassButton = TRUE;
        if (m_DanCount > 1) {
            freePassRadioIndex = 500 + m_DanCount + 1;
            [freePassRadioIndexArray addObject:[NSNumber numberWithInt:freePassRadioIndex]];
            
        }
        else
        {
            freePassRadioIndex = 502;
            [freePassRadioIndexArray addObject:[NSNumber numberWithInt:freePassRadioIndex]];
        }
        m_betNumber = [self getFreeChuanBetNum:freePassRadioIndex - 500];//默认
        
        duoChuanPassRadioIndex = -1;
        duochuanScrollViewOffset_Y = 0;
        m_duoChuanPassRadioArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        //多串过关
        NSDictionary *dictionary01 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"3串3", @"526", nil];
        NSDictionary *dictionary02 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"3串4", @"527", nil];
        NSDictionary *dictionary03 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串4", @"539", nil];
        NSDictionary *dictionary04 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串5", @"540", nil];
        NSDictionary *dictionary05 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串6", @"528", nil];
        NSDictionary *dictionary06 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串11", @"529", nil];
        [m_duoChuanPassRadioArray addObject:dictionary01];
        [m_duoChuanPassRadioArray addObject:dictionary02];
        [m_duoChuanPassRadioArray addObject:dictionary03];
        [m_duoChuanPassRadioArray addObject:dictionary04];
        [m_duoChuanPassRadioArray addObject:dictionary05];
        [m_duoChuanPassRadioArray addObject:dictionary06];
        
        if (m_playTypeTag != IJCLQPlayType_SFC && m_playTypeTag != IJCLQPlayType_SFC_DanGuan) {
            NSDictionary *dictionary07 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串5", @"544", nil];
            NSDictionary *dictionary08 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串6", @"545", nil];
            NSDictionary *dictionary09 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串10", @"530", nil];
            NSDictionary *dictionary10 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串16", @"541", nil];
            NSDictionary *dictionary11 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串20", @"531", nil];
            NSDictionary *dictionary12 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串26", @"532", nil];
            
            NSDictionary *dictionary13 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串6", @"549", nil];
            NSDictionary *dictionary14 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串7", @"550", nil];
            NSDictionary *dictionary15 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串15", @"533", nil];
            NSDictionary *dictionary16 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串20", @"542", nil];
            NSDictionary *dictionary17 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串22", @"546", nil];
            NSDictionary *dictionary18 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串35", @"534", nil];
            NSDictionary *dictionary19 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串42", @"543", nil];
            NSDictionary *dictionary20 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串50", @"535", nil];
            NSDictionary *dictionary21 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串57", @"536", nil];
            
            [m_duoChuanPassRadioArray addObject:dictionary07];
            [m_duoChuanPassRadioArray addObject:dictionary08];
            [m_duoChuanPassRadioArray addObject:dictionary09];
            [m_duoChuanPassRadioArray addObject:dictionary10];
            [m_duoChuanPassRadioArray addObject:dictionary11];
            [m_duoChuanPassRadioArray addObject:dictionary12];
            [m_duoChuanPassRadioArray addObject:dictionary13];
            [m_duoChuanPassRadioArray addObject:dictionary14];
            [m_duoChuanPassRadioArray addObject:dictionary15];
            [m_duoChuanPassRadioArray addObject:dictionary16];
            [m_duoChuanPassRadioArray addObject:dictionary17];
            [m_duoChuanPassRadioArray addObject:dictionary18];
            [m_duoChuanPassRadioArray addObject:dictionary19];
            [m_duoChuanPassRadioArray addObject:dictionary20];
            [m_duoChuanPassRadioArray addObject:dictionary21];
            
            
            if (m_playTypeTag != IJCZQPlayType_ZJQ &&
                m_playTypeTag != IJCZQPlayType_ZJQ_DanGuan)
            {
                NSDictionary *dictionary22 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串7", @"553", nil];
                NSDictionary *dictionary23 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串8", @"554", nil];
                NSDictionary *dictionary24 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串21", @"551", nil];
                NSDictionary *dictionary25 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串35", @"547", nil];
                NSDictionary *dictionary26 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串120", @"537", nil];
                
                NSDictionary *dictionary27 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串8", @"556", nil];
                NSDictionary *dictionary28 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串9", @"557", nil];
                NSDictionary *dictionary29 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串28", @"555", nil];
                NSDictionary *dictionary30 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串56", @"552", nil];
                NSDictionary *dictionary31 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串70", @"548", nil];
                NSDictionary *dictionary32 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串247", @"538", nil];
                [m_duoChuanPassRadioArray addObject:dictionary22];
                [m_duoChuanPassRadioArray addObject:dictionary23];
                [m_duoChuanPassRadioArray addObject:dictionary24];
                
                [m_duoChuanPassRadioArray addObject:dictionary25];
                [m_duoChuanPassRadioArray addObject:dictionary26];
                [m_duoChuanPassRadioArray addObject:dictionary27];
                [m_duoChuanPassRadioArray addObject:dictionary28];
                [m_duoChuanPassRadioArray addObject:dictionary29];
                [m_duoChuanPassRadioArray addObject:dictionary30];
                
                [m_duoChuanPassRadioArray addObject:dictionary31];
                [m_duoChuanPassRadioArray addObject:dictionary32];
            }
        }
        
        if (m_playTypeTag == IJCLQPlayType_Confusion ||
            m_playTypeTag == IJCZQPlayType_Confusion) {
            m_guoguanFangshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 217 + 8 + 36, 300, 30)] autorelease];
            m_guoguanFangshLabel.text = @"过关方式";
            m_guoguanFangshLabel.backgroundColor = [UIColor clearColor];
            m_guoguanFangshLabel.textAlignment = UITextAlignmentLeft;
            m_guoguanFangshLabel.textColor = [UIColor blackColor];
            m_guoguanFangshLabel.font = [UIFont boldSystemFontOfSize:15];
            [self.srollView_normalBet addSubview:m_guoguanFangshLabel];
            
            m_image_top = [[UIImageView alloc] initWithFrame:CGRectMake(9, 217 + 8 + 36 + 30, 302, 10)];
            m_image_top.image = RYCImageNamed(@"croner_top.png");
            [self.srollView_normalBet addSubview:m_image_top];
        }
        else
        {
            m_FreePassButton = [[UIButton alloc] initWithFrame:CGRectMake(9, 217 + 8 + 36, 151, 40)];
            [m_FreePassButton setTitle:@"自由过关" forState:UIControlStateNormal];
            [m_FreePassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_FreePassButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [m_FreePassButton setBackgroundImage:RYCImageNamed(@"jifen_btna2.png") forState:UIControlStateNormal];
            [m_FreePassButton setBackgroundImage:RYCImageNamed(@"jifen_btna1.png") forState:UIControlStateSelected];
            [m_FreePassButton addTarget:self action:@selector(guoGuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.srollView_normalBet addSubview:m_FreePassButton];
            m_FreePassButton.selected = YES;
            
            m_DuoChuanPassButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 217 + 8 + 36, 151, 40)];
            [m_DuoChuanPassButton setTitle:@"多串过关" forState:UIControlStateNormal];
            [m_DuoChuanPassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_DuoChuanPassButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [m_DuoChuanPassButton setBackgroundImage:RYCImageNamed(@"jifen_btnb1.png") forState:UIControlStateSelected];
            [m_DuoChuanPassButton setBackgroundImage:RYCImageNamed(@"jifen_btnb2.png") forState:UIControlStateNormal];
            [m_DuoChuanPassButton addTarget:self action:@selector(guoGuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.srollView_normalBet addSubview:m_DuoChuanPassButton];
            
            if(self.gameCount > 8)
            {
                m_DuoChuanPassButton.hidden = YES;
                m_FreePassButton.hidden = YES;
                
                m_guoguanFangshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 217 + 8 + 36, 300, 30)] autorelease];
                m_guoguanFangshLabel.text = @"过关方式";
                m_guoguanFangshLabel.backgroundColor = [UIColor clearColor];
                m_guoguanFangshLabel.textAlignment = UITextAlignmentLeft;
                m_guoguanFangshLabel.textColor = [UIColor blackColor];
                m_guoguanFangshLabel.font = [UIFont boldSystemFontOfSize:15];
                [self.srollView_normalBet addSubview:m_guoguanFangshLabel];
                
                m_image_top = [[UIImageView alloc] initWithFrame:CGRectMake(9, 217 + 8 + 36 + 30, 302, 10)];
                m_image_top.image = RYCImageNamed(@"croner_top.png");
                [self.srollView_normalBet addSubview:m_image_top];
            }
            else
            {
                [self setupPassScollView_view];
                m_DuoChuanPassScollView.hidden = YES;
            }
        }
        [self setupFreeScollView_view];
        
        m_image_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(9, 217 + 8 + 36 + 125, 302, 10)];
        m_image_bottom.image = RYCImageNamed(@"croner_bottom.png");
        [self.srollView_normalBet addSubview:m_image_bottom];
        
        srollView_normalBet.contentSize = CGSizeMake(320, 360 + 40);
    }
    
    [self beishuButtonAddGesture];
    
    [self refreshData];
    
}

- (void)tabButtonChanged:(NSNotification*)notification
{
    [self hideKeybord];
    [self.LaunchHMView hideKeybord];
    
    if(self.cusSegmented.segmentedIndex == 0)
    {
        self.srollView_normalBet.hidden = NO;
        self.srollView_HMBet.hidden = YES;
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(self.cusSegmented.segmentedIndex == 1)
    {
        
        self.srollView_normalBet.hidden = YES;
        self.srollView_HMBet.hidden = NO;
        [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
        [RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d" ,m_betNumber];
        self.LaunchHMView.zhuShuLabel.text = [NSString stringWithFormat:@"共%d注" ,m_betNumber];
        
        [self.LaunchHMView refreshTopView];
    }
}

/*
 注：竞彩  玩法 过关方式 限制（暂时）
 
 竞彩篮球：
 [
 胜分差 只有 4串 以内的
 
 ]
 竞彩足球：
 [
 胜平负  全部
 
 总进球  只有 6串 以内的
 比分    只有 4串 以内的
 半全场  只有 4串 以内的
 ]
 */
- (BOOL)isHaveSelected:(NSInteger)index
{
    BOOL ishave = FALSE;
    for (int a = 0; a < [freePassRadioIndexArray count]; a++) {
        if ([[freePassRadioIndexArray objectAtIndex:a] intValue] == index) {
            ishave = TRUE;
            break;
        }
    }
    return ishave;
}

- (void)setupFreeScollView_view
{
    if (m_freePassScollView != nil) {
        [m_freePassScollView removeFromSuperview];
    }
    m_freePassScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(9, 257 + 36 + 3 + (m_expandBetCode ? kMoveDownHeight : 0), 302, 90)];
    UIImageView* image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 302, 90)] autorelease];
    image.image = [UIImage imageNamed:@"croner_middle.png"];
    [m_freePassScollView addSubview:image];
    
    self.freePassScollView.scrollEnabled = YES;
    self.freePassScollView.delegate = self;
    self.freePassScollView.backgroundColor = [UIColor whiteColor];
    self.freePassScollView.contentSize = CGSizeMake(302, 90);
    [self.srollView_normalBet addSubview:m_freePassScollView];
    self.freePassScollView.hidden = NO;
    
    [self setFreePassScollView];
}

- (void)setupPassScollView_view
{
    if (m_DuoChuanPassScollView != nil) {
        [m_DuoChuanPassScollView removeFromSuperview];
    }
    m_DuoChuanPassScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(9, 257 + 36 + 3 + (m_expandBetCode ? kMoveDownHeight : 0), 302, 90)];
    
    UIImageView* image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 302, 90)] autorelease];
    image.image = [UIImage imageNamed:@"croner_middle.png"];
    [self.DuoChuanPassScollView addSubview:image];
    self.DuoChuanPassScollView.scrollEnabled = YES;
    self.DuoChuanPassScollView.delegate = self;
    self.DuoChuanPassScollView.backgroundColor = [UIColor whiteColor];
    self.DuoChuanPassScollView.contentSize = CGSizeMake(302, 90);
    [self.srollView_normalBet addSubview:m_DuoChuanPassScollView];
    self.DuoChuanPassScollView.hidden = NO;
    //重新创建
    [self setDuoChuanPassScollView];
}

- (void)setFreePassScollView
{
    if (m_gameCount >= 2) {
        BOOL isSelect = [self isHaveSelected:502];
        [self CreatFreePassRadio:CGRectMake(10, 10, 70, 20) Title:@"2串1" isSelect:isSelect Tag:502 ISCLICK:((m_DanCount >= 2) ? FALSE : TRUE)];
    }
    if(m_gameCount >= 3)
    {
        BOOL isSelect = [self isHaveSelected:503];
        [self CreatFreePassRadio:CGRectMake(10 + 75, 10, 70, 20) Title:@"3串1" isSelect:isSelect Tag:503 ISCLICK:((m_DanCount >= 3 || (m_DanCount > 0 && m_gameCount == 3)) ? FALSE : TRUE)];
    }
    if(m_gameCount >= 4)
    {
        BOOL isSelect = [self isHaveSelected:504];
        [self CreatFreePassRadio:CGRectMake(10 + 75 * 2, 10, 70, 20) Title:@"4串1" isSelect:isSelect Tag:504 ISCLICK:((m_DanCount >= 4 || (m_DanCount > 0 && m_gameCount == 4)) ? FALSE : TRUE)];
    }
    //竞彩篮球  胜分差 只有 4串 以内的
    //竞彩足球    比分    只有 4串 以内的
    //竞彩足球    半全场  只有 4串 以内的
    if (m_playTypeTag != IJCLQPlayType_SFC   &&
        m_playTypeTag != IJCZQPlayType_Score   &&
        m_playTypeTag != IJCZQPlayType_HalfAndAll
        )
    {
        if (self.confusion_type == JCZQ_SCORE ||
            self.confusion_type == JCZQ_HALF||
            self.confusion_type == JCLQ_SFC)
        {
            
        }
        else
        {
            if(m_gameCount >= 5)
            {
                BOOL isSelect = [self isHaveSelected:505];
                [self CreatFreePassRadio:CGRectMake(10 + 75 * 3, 10, 70, 20) Title:@"5串1" isSelect:isSelect Tag:505 ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_gameCount == 5)) ? FALSE : TRUE)];
            }
            if(m_gameCount >= 6)
            {
                BOOL isSelect = [self isHaveSelected:506];
                [self CreatFreePassRadio:CGRectMake(10, 10 + 30, 70, 20) Title:@"6串1" isSelect:isSelect Tag:506 ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
            }
            //竞彩足球  总进球 只有 6串 以内的
            if (m_playTypeTag != IJCZQPlayType_ZJQ  )
            {
                if (self.confusion_type == JCZQ_ZJQ)
                {
                    
                }
                else
                {
                    if(m_gameCount >= 7)
                    {
                        BOOL isSelect = [self isHaveSelected:507];
                        [self CreatFreePassRadio:CGRectMake(10 + 75 * 1, 10 + 30, 70, 20) Title:@"7串1" isSelect:isSelect Tag:507 ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_gameCount == 7)) ? FALSE : TRUE)];
                    }
                    if(m_gameCount >= 8)
                    {
                        BOOL isSelect = [self isHaveSelected:508];
                        [self CreatFreePassRadio:CGRectMake(10 + 75 * 2, 10 + 30, 70, 20) Title:@"8串1" isSelect:isSelect Tag:508 ISCLICK:((m_DanCount >= 8 || (m_DanCount > 0 && m_gameCount == 8)) ? FALSE : TRUE)];
                    }
                }
            }
        }
        
    }
}

- (void)setDuoChuanPassScollView
{
    if (m_gameCount >= 3)
    {
        [self CreatDuoChuanPassRadio:CGRectMake(10, 10, 70, 20) Title:@"3串3" isSelect:NO Tag:0 ISCLICK:((m_DanCount >= 3 || (m_DanCount > 0 && m_gameCount == 3)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10, 70, 20) Title:@"3串4" isSelect:NO Tag:1 ISCLICK:((m_DanCount >= 3 || (m_DanCount > 0 && m_gameCount == 3)) ? FALSE : TRUE)];
        self.DuoChuanPassScollView.contentSize = CGSizeMake(300, 90);
    }
    if(m_gameCount >= 4 )
    {
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10, 70, 20) Title:@"4串4" isSelect:NO Tag:2
                             ISCLICK:((m_DanCount >= 4 || (m_DanCount > 0 && m_gameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(5 + 75 * 3, 10, 70, 20) Title:@"4串5" isSelect:NO Tag:3
                             ISCLICK:((m_DanCount >= 4  || (m_DanCount > 0 && m_gameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(10 , 10 + 30, 70, 20) Title:@"4串6" isSelect:NO Tag:4
                             ISCLICK:((m_DanCount >= 4  || (m_DanCount > 0 && m_gameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30, 70, 20) Title:@"4串11" isSelect:NO Tag:5
                             ISCLICK:((m_DanCount >= 4  || (m_DanCount > 0 && m_gameCount == 4)) ? FALSE : TRUE)];
        self.DuoChuanPassScollView.contentSize = CGSizeMake(300, 90);
    }
    //竞彩篮球  胜分差 只有 4串 以内的
    //竞彩足球    比分    只有 4串 以内的
    //竞彩足球    半全场  只有 4串 以内的
    
    if (m_playTypeTag != IJCLQPlayType_SFC &&
        
        m_playTypeTag != IJCZQPlayType_Score &&
        
        m_playTypeTag != IJCZQPlayType_HalfAndAll
        )
    {
        if (self.confusion_type == JCZQ_SCORE ||
            self.confusion_type == JCZQ_HALF||
            self.confusion_type == JCLQ_SFC)
        {
            
        }
        else
        {
            if(m_gameCount >= 5)
            {
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2 , 10 + 30, 70, 20) Title:@"5串5" isSelect:NO Tag:6
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_gameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(5 + 75* 3, 10 + 30, 70, 20) Title:@"5串6" isSelect:NO Tag:7
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_gameCount == 5)) ? FALSE : TRUE)];
                
                
                [self CreatDuoChuanPassRadio:CGRectMake(10, 10 + 30 * 2, 70, 20) Title:@"5串10" isSelect:NO Tag:8
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_gameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 2, 70, 20) Title:@"5串16" isSelect:NO Tag:9
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_gameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 2, 70, 20) Title:@"5串20" isSelect:NO Tag:10
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_gameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(5 + 75 * 3 , 10 + 30 * 2, 70, 20) Title:@"5串26" isSelect:NO Tag:11
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_gameCount == 5)) ? FALSE : TRUE)];
                self.DuoChuanPassScollView.contentSize = CGSizeMake(300, 90);
                
            }
            if(m_gameCount >= 6)
            {
                [self CreatDuoChuanPassRadio:CGRectMake(10, 10 + 30 * 3, 70, 20) Title:@"6串6" isSelect:NO Tag:12
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 3, 70, 20) Title:@"6串7" isSelect:NO Tag:13
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 3, 70, 20) Title:@"6串15" isSelect:NO Tag:14
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(5 + 75 * 3, 10 + 30 * 3, 70, 20) Title:@"6串20" isSelect:NO Tag:15
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                
                [self CreatDuoChuanPassRadio:CGRectMake(10, 10 + 30 * 4, 70, 20) Title:@"6串22" isSelect:NO Tag:16
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 4, 70, 20) Title:@"6串35" isSelect:NO Tag:17
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 4, 70, 20) Title:@"6串42" isSelect:NO Tag:18
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(5 + 75 * 3 , 10 + 30 * 4, 70, 20) Title:@"6串50" isSelect:NO Tag:19
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                
                
                [self CreatDuoChuanPassRadio:CGRectMake(10 , 10 + 30 * 5, 70, 20) Title:@"6串57" isSelect:NO Tag:20
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_gameCount == 6)) ? FALSE : TRUE)];
                self.DuoChuanPassScollView.contentSize = CGSizeMake(300, 90 * 2 + 10);
                
            }
            //竞彩足球  总进球 只有 6串 以内的
            if (m_playTypeTag != IJCZQPlayType_ZJQ )
            {
                if (self.confusion_type == JCZQ_ZJQ) {
                    
                }
                else
                {
                    if(m_gameCount >= 7 )
                    {
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 5, 70, 20) Title:@"7串7" isSelect:NO Tag:21
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_gameCount == 7)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10  + 75 * 2, 10 + 30 * 5, 70, 20) Title:@"7串8" isSelect:NO Tag:22
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_gameCount == 7)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(5 + 75 * 3 , 10 + 30 * 5, 70, 20) Title:@"7串21" isSelect:NO Tag:23
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_gameCount == 7)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(10 , 10 + 30 * 6, 70, 20) Title:@"7串35" isSelect:NO Tag:24
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_gameCount == 7)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 6, 70, 20) Title:@"7串120" isSelect:NO Tag:25
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_gameCount == 7)) ? FALSE : TRUE)];
                        self.DuoChuanPassScollView.contentSize = CGSizeMake(300, 90 * 3 + 10);
                        
                    }
                    if(m_gameCount >= 8 && m_DanCount <= 8)
                    {
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 6, 70, 20) Title:@"8串8" isSelect:NO Tag:26
                                             ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_gameCount == 8)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(5  + 75 * 3, 10 + 30 * 6, 70, 20) Title:@"8串9" isSelect:NO Tag:27
                                             ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_gameCount == 8)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(10, 10 + 30 * 7, 70, 20) Title:@"8串28" isSelect:NO Tag:28
                                             ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_gameCount == 8)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 7, 70, 20) Title:@"8串56" isSelect:NO Tag:29 ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_gameCount == 8)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 7, 70, 20) Title:@"8串70" isSelect:NO Tag:30 ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_gameCount == 8)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(5 + 75 * 3, 10 + 30 * 7, 70, 20) Title:@"8串247" isSelect:NO Tag:31 ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_gameCount == 8)) ? FALSE : TRUE)];
                        self.DuoChuanPassScollView.contentSize = CGSizeMake(300, 90 * 3 + 10);
                    }
                }
            }
        }
    }
}

- (void)CreatFreePassRadio:(CGRect)rect Title:(NSString*)title isSelect:(BOOL)select Tag:(NSInteger) radioTag ISCLICK:(BOOL) isClick
{
    //X串1
    //X串1
    UIButton* string2_1 = [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, 20, 20)];
    [string2_1 setBackgroundImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateSelected];
    [string2_1 setBackgroundImage:RYCImageNamed(@"select_2.png") forState:UIControlStateNormal];
    
    if (select) {
        string2_1.selected = YES;
        int count = [freePassRadioIndexArray count];
        BOOL isHave = FALSE;
        for (int a = 0; a < count; a++) {
            if ([[freePassRadioIndexArray objectAtIndex:a] intValue] == radioTag) {
                isHave = TRUE;
            }
        }
        if (!isHave) {
            [freePassRadioIndexArray addObject:[NSNumber numberWithInt:radioTag]];
        }
    }
    UILabel* string2_1Lable = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 20, rect.origin.y, 50, 20)];
    string2_1Lable.backgroundColor = [UIColor clearColor];
    
    /*
     添加 过关限制
     */
    if (!isClick) {
        [string2_1 setBackgroundImage:RYCImageNamed(@"select2_noselect.png") forState:UIControlStateNormal];
        [string2_1 setBackgroundImage:RYCImageNamed(@"select2_noselect.png") forState:UIControlStateHighlighted];
        
        [string2_1Lable setTextColor:[UIColor grayColor]];
    }
    else
    {
        [string2_1 addTarget:self action:@selector(freePassRadioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [string2_1Lable setTextColor:[UIColor blackColor]];
    }
    
    [string2_1 setTag:radioTag];
    [m_freePassScollView addSubview:string2_1];
    [string2_1 release];
    
    
    string2_1Lable.text = title;
    string2_1Lable.textAlignment = UITextAlignmentLeft;
    
    string2_1Lable.font = [UIFont systemFontOfSize:15];
    [m_freePassScollView addSubview:string2_1Lable];
    [string2_1Lable release];
    
}
- (void)CreatDuoChuanPassRadio:(CGRect)rect Title:(NSString*)title isSelect:(BOOL)select Tag:(NSInteger)radioTag ISCLICK:(BOOL) isClick
{
    //X串X
    UIButton* string2_1 = [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, 20, 20)];
    [string2_1 setBackgroundImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateSelected];
    [string2_1 setBackgroundImage:RYCImageNamed(@"select_2.png") forState:UIControlStateNormal];
    
    string2_1.selected = select;
    
    UILabel* string2_1Lable = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x + 20, rect.origin.y, 50, 20)];
    /*
     添加 过关限制
     */
    if (!isClick) {
        [string2_1 setBackgroundImage:RYCImageNamed(@"select2_noselect.png") forState:UIControlStateNormal];
        [string2_1 setBackgroundImage:RYCImageNamed(@"select2_noselect.png") forState:UIControlStateHighlighted];
        
        [string2_1Lable setTextColor:[UIColor grayColor]];
    }
    else
    {
        [string2_1 addTarget:self action:@selector(duoChuanPassRadioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [string2_1 setTag:radioTag];
    [m_DuoChuanPassScollView addSubview:string2_1];
    [string2_1 release];
    
    
    string2_1Lable.text = title;
    string2_1Lable.tag = 1000 + radioTag;
    string2_1Lable.textAlignment = UITextAlignmentLeft;
    string2_1Lable.backgroundColor = [UIColor clearColor];
    string2_1Lable.font = [UIFont systemFontOfSize:15];
    [m_DuoChuanPassScollView addSubview:string2_1Lable];
    [string2_1Lable release];
    
}

- (void)freePassRadioButtonClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    int beforBetNum = m_betNumber;
    NSLog(@"%d", btn.tag);
    if (btn.selected) {
        m_betNumber += [self getFreeChuanBetNum:btn.tag - 500];
        if (m_betNumber > 10000) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高注数不能超过10000注！" withTitle:@"提示" buttonTitle:@"确定"];
            m_betNumber = beforBetNum;
            btn.selected = !btn.selected;
        }
        else
            [freePassRadioIndexArray addObject:[NSNumber numberWithInt:btn.tag]];
    }
    else
    {
        if ([freePassRadioIndexArray count] == 1) {
            btn.selected = YES;
        }
        else
        {
            m_betNumber -= [self getFreeChuanBetNum:btn.tag - 500];
            
            [freePassRadioIndexArray removeObject:[NSNumber numberWithInt:btn.tag]];//未勾选的就移除
        }
    }
    NSLog(@"%d", m_betNumber);
    [self refreshData];
}

- (void)duoChuanPassRadioButtonClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    if (btn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    duoChuanPassRadioIndex = btn.tag;
    for (UIView*  viewbtn in m_DuoChuanPassScollView.subviews)
    {
        if ([viewbtn isKindOfClass:[UIButton class]] && viewbtn != btn) {
            UIButton* tempBtn = (UIButton*)viewbtn;
            tempBtn.selected = NO;
        }
    }
    NSArray* keyArray = [(NSDictionary*)[m_duoChuanPassRadioArray objectAtIndex:duoChuanPassRadioIndex] allKeys];
    
    NSString *key = [keyArray objectAtIndex:0];
    NSString *value = [(NSDictionary*)[m_duoChuanPassRadioArray objectAtIndex:duoChuanPassRadioIndex] objectForKey:key];
    
    m_betNumber = [self getNoteNumberByDuoChuanRadioTag:value];
    if (m_betNumber > 10000) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高注数不能超过10000注！" withTitle:@"提示" buttonTitle:@"确定"];
        m_betNumber = 0;
        btn.selected = NO;
    }
    
    
    [self refreshData];
}


-(void)refrshPlayTypeButton//清空所有自由过关和多串过关的勾选
{
    m_betNumber = 0;
    m_minWinAmount = 0.00;
    m_maxWinAmount = 0.00;
    
    [freePassRadioIndexArray removeAllObjects];
    for (UIView*  viewbtn in m_freePassScollView.subviews)
    {
        if ([viewbtn isKindOfClass:[UIButton class]]) {
            UIButton* tempBtn = (UIButton*)viewbtn;
            tempBtn.selected = NO;
        }
    }
    
    duoChuanPassRadioIndex = -1;//默认未选中任何多关
    for (UIView*  viewbtn in m_DuoChuanPassScollView.subviews)
    {
        if ([viewbtn isKindOfClass:[UIButton class]]) {
            UIButton* tempBtn = (UIButton*)viewbtn;
            tempBtn.selected = NO;
        }
    }
}
- (void)guoGuanButtonClick:(UIButton*)tempButton
{
    [self refrshPlayTypeButton];
    if (tempButton == m_FreePassButton) {
        if (m_FreePassButton.selected) {
            return;
        }
        m_isFreePassButton = TRUE;
        m_FreePassButton.selected = !m_FreePassButton.selected;
        m_DuoChuanPassButton.selected = !m_FreePassButton.selected;
        m_freePassScollView.hidden = NO;
        m_DuoChuanPassScollView.hidden = YES;
    }
    else
    {
        if (m_DuoChuanPassButton.selected) {
            return;
        }
        m_isFreePassButton = NO;
        m_DuoChuanPassButton.selected = !m_DuoChuanPassButton.selected;
        m_FreePassButton.selected = !m_DuoChuanPassButton.selected;
        m_freePassScollView.hidden = YES;
        m_DuoChuanPassScollView.hidden = NO;
        
    }
    
    [self refreshData];
}

- (void)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fqHeMaiLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getShareDetileLotOK" object:nil];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShareDetileLotOK:) name:@"getShareDetileLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fqHeMaiLotOK:) name:@"fqHeMaiLotOK" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark 倍数按钮添加手势

- (void) beishuButtonAddGesture
{
    
    //加  单击
    [self.jiaBeishuButton addTarget:self action:@selector(jiaHandleTapGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    //减  单击
    [self.jianBeishuButton addTarget:self action:@selector(jianHandleTapGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    //加  长按
    self.jiaBeishuButton.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *jialongpressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jiaButtonPressed:)];
    jialongpressGR.minimumPressDuration = 0.5; //设定长按时间
    [self.jiaBeishuButton addGestureRecognizer:jialongpressGR];
    [jialongpressGR release];
    
    //减  长按
    self.jianBeishuButton.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *jianlongpressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jianButtonPressed:)];
    jianlongpressGR.minimumPressDuration = 0.5; //设定长按时间
    [self.jianBeishuButton addGestureRecognizer:jianlongpressGR];
    [jianlongpressGR release];
}


- (void) jiaHandleTapGesture:(id)sender
{
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu++;
    if (tempBeishu > 100000) {
        tempBeishu = 100000;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}


- (void) jianHandleTapGesture:(id)sender
{
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu--;
    if (tempBeishu <= 1) {
        tempBeishu = 1;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}

- (void) jiaButtonPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.jiaBeishuButton setBackgroundImage:[UIImage imageNamed:@"jia_click.png"] forState:UIControlStateNormal];
        m_timer = [NSTimer scheduledTimerWithTimeInterval:(0.1)
                                                   target:self selector:@selector(jiaBeishu)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    
    
    //    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    //    {
    //
    //        [self.jiaBeishuButton setBackgroundImage:[UIImage imageNamed:@"jia_normal.png"] forState:UIControlStateNormal];
    //        [m_timer invalidate];
    //        m_timer = nil;
    //    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.jiaBeishuButton setBackgroundImage:[UIImage imageNamed:@"jia_normal.png"] forState:UIControlStateNormal];
        [m_timer invalidate];
        m_timer = nil;
    }
}


- (void) jianButtonPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.jianBeishuButton setBackgroundImage:[UIImage imageNamed:@"jian_click.png"] forState:UIControlStateNormal];
        m_timer = [NSTimer scheduledTimerWithTimeInterval:(0.1)
                                                   target:self selector:@selector(jianBeishu)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    
    //    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    //    {
    //        [self.jianBeishuButton setBackgroundImage:[UIImage imageNamed:@"jian_normal.png"] forState:UIControlStateNormal];
    //        [m_timer invalidate];
    //        m_timer = nil;
    //    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.jianBeishuButton setBackgroundImage:[UIImage imageNamed:@"jian_normal.png"] forState:UIControlStateNormal];
        [m_timer invalidate];
        m_timer = nil;
    }
}


- (void) jiaBeishu{
    
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu++;
    if (tempBeishu > 100000) {
        tempBeishu = 100000;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}


- (void) jianBeishu{
    
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu--;
    if (tempBeishu <= 1) {
        tempBeishu = 1;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}

//刷新注数，金额和预计奖金
- (void) refreshData
{
    int fieldText = [self.fieldBeishu.text intValue];
    
    if (m_isDanGuan)
    {
        //         2011年10月11日，足球比分游戏和篮球胜分差游戏的单关销售由原来的“浮动奖金”升级为“固定奖金”。也就是说，您购彩竞彩足球比分和篮球胜分差的单关时，会按照投注出票时的奖金进行计奖返奖。
        //
        //         例如：用户购买1场比赛，出票时的奖金是5.5，倍投为10
        //
        //         那么用户这个单关固定奖金投注所获得的奖金是=2元×5.5×10，奖金是110元
        m_minWinAmount = 0.00;
        m_maxWinAmount = 0.00;
        if (m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
            m_playTypeTag == IJCZQPlayType_Score_DanGuan)
        {
            m_minWinAmount = [[[(CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:0] combineBase_SP] objectAtIndex:0] floatValue] * 2.0;
            
            float maxAmount = 0.0;
            for (int a = 0; a < [[m_Com_arrangeSP_Max combineList] count]; a++)
            {
                maxAmount += [[[(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:a] combineBase_SP] objectAtIndex:0]floatValue] * 2.0;
            }
            m_maxWinAmount = maxAmount ;
        }
        
        else
        {
            m_minWinAmount = [[[(CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:0] combineBase_SP] objectAtIndex:0] floatValue];
            //            m_minWinAmount = [[m_arrangeSP_Min objectAtIndex:0] floatValue];
            
            float maxAmount = 0.0;
            for (int a = 0; a < [[m_Com_arrangeSP_Max combineList] count]; a++)
            {
                maxAmount += [[[(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:a] combineBase_SP] objectAtIndex:0] floatValue];
            }
            m_maxWinAmount = maxAmount ;
        }
    }
    else
    {
        if (m_isFreePassButton && m_gameCount >= 2)
        {
            m_minWinAmount = 0.00;
            m_maxWinAmount = 0.00;
            
            m_maxAmount_Confusion = 0.0;
            m_minAmount_Confusion = 0.0;
            
            float minMonney = 0;
            float maxMonney = 0;
            
            for (int a = 0; a < [freePassRadioIndexArray count]; a++) {
                
                if (self.playTypeTag == IJCLQPlayType_Confusion ||
                    self.playTypeTag == IJCZQPlayType_Confusion) {
                    
                    [self calculationWinAmountForConfusion:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
                    
                    if (a == 0) {
                        minMonney = m_minAmount_Confusion;
                    }
                    minMonney > m_minAmount_Confusion ? (minMonney = m_minAmount_Confusion) : (minMonney);
                    
                    maxMonney += m_maxAmount_Confusion;
                }
                else
                {
                    //计算最小的奖金
                    [self getMinWinAmountByX:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
                    if (a == 0) {
                        minMonney = m_minWinAmount;
                    }
                    minMonney > m_minWinAmount ? (minMonney = m_minWinAmount) : (minMonney);
                    
                    //计算最大的奖金
                    [self calculationAmountBy_X_Y:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500 Y:1];
                    maxMonney += m_maxWinAmount;
                }
                
            }
            m_maxWinAmount = maxMonney;
            m_minWinAmount = minMonney;
        }
    }
    //    m_betNumber = count;
    self.betNumberLable.text = [NSString stringWithFormat:@"共%d注", m_betNumber];
    
    m_allCount = m_betNumber * 2.0 * fieldText * 100;
    self.allCountLabel.text = [NSString stringWithFormat:@"共%.0lf元", m_allCount /100.0];
    
    self.winAmount.text = [NSString stringWithFormat:@"%0.2lf元 -- %0.2lf元", m_minWinAmount * fieldText,m_maxWinAmount * fieldText];
    
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", fieldText];
}


/*
 - (IBAction)sliderBeishuChange:(id)sender
 {
 int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
 self.fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
 
 //注数 = zuhe(6,用户选中红球数量) * zuhe(1,用户选中蓝球数量)
 
 //    int count = 0;
 if (m_isDanGuan)
 {
 
 
 //         2011年10月11日，足球比分游戏和篮球胜分差游戏的单关销售由原来的“浮动奖金”升级为“固定奖金”。也就是说，您购彩竞彩足球比分和篮球胜分差的单关时，会按照投注出票时的奖金进行计奖返奖。
 //
 //         例如：用户购买1场比赛，出票时的奖金是5.5，倍投为10
 //
 //         那么用户这个单关固定奖金投注所获得的奖金是=2元×5.5×10，奖金是110元
 
 //        count = m_gameCount + m_twoCount;
 m_minWinAmount = 0.00;
 m_maxWinAmount = 0.00;
 if (m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
 m_playTypeTag == IJCZQPlayType_Score_DanGuan)
 {
 m_minWinAmount = [[[(CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:0] combineBase_SP] objectAtIndex:0] floatValue] * 2.0;
 
 float maxAmount = 0.0;
 for (int a = 0; a < [[m_Com_arrangeSP_Max combineList] count]; a++)
 {
 maxAmount += [[[(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:a] combineBase_SP] objectAtIndex:0]floatValue] * 2.0;
 }
 m_maxWinAmount = maxAmount ;
 }
 else
 {
 m_minWinAmount = [[[(CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:0] combineBase_SP] objectAtIndex:0] floatValue];
 //            m_minWinAmount = [[m_arrangeSP_Min objectAtIndex:0] floatValue];
 
 float maxAmount = 0.0;
 for (int a = 0; a < [[m_Com_arrangeSP_Max combineList] count]; a++)
 {
 maxAmount += [[[(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:a] combineBase_SP] objectAtIndex:0] floatValue];
 }
 m_maxWinAmount = maxAmount ;
 }
 
 }
 else
 {
 if (m_isFreePassButton && m_gameCount >= 2)
 {
 m_minWinAmount = 0.00;
 m_maxWinAmount = 0.00;
 
 m_maxAmount_Confusion = 0.0;
 m_minAmount_Confusion = 0.0;
 
 float minMonney = 0;
 float maxMonney = 0;
 
 for (int a = 0; a < [freePassRadioIndexArray count]; a++) {
 
 if (self.playTypeTag == IJCLQPlayType_Confusion ||
 self.playTypeTag == IJCZQPlayType_Confusion) {
 
 [self calculationWinAmountForConfusion:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
 
 minMonney += m_minAmount_Confusion;
 maxMonney += m_maxAmount_Confusion;
 }
 else
 {
 //计算最小的奖金
 [self getMinWinAmountByX:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
 if (a == 0) {
 minMonney = m_minWinAmount;
 }
 minMonney > m_minWinAmount ? (minMonney = m_minWinAmount) : (minMonney);
 
 //计算最大的奖金
 [self calculationAmountBy_X_Y:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500 Y:1];
 maxMonney += m_maxWinAmount;
 }
 
 }
 m_maxWinAmount = maxMonney;
 m_minWinAmount = minMonney;
 }
 }
 //    m_betNumber = count;
 self.betNumberLable.text = [NSString stringWithFormat:@"共%d注", m_betNumber];
 
 m_allCount = m_betNumber * 2 * numBeishu * 100;
 self.allCountLabel.text = [NSString stringWithFormat:@"共%d元", m_allCount /100];
 
 self.winAmount.text = [NSString stringWithFormat:@"%0.2f元 -- %0.2f元", m_minWinAmount * numBeishu,m_maxWinAmount * numBeishu];
 
 [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
 }
 */

-(void) betCode_ExpandButtonEvent_move:(BOOL)down
{
    int moveHeight = 0;
    if (down) {
        moveHeight = kMoveDownHeight;
        srollView_normalBet.frame = CGRectMake(srollView_normalBet.frame.origin.x,43, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 60 - 42 + 200);
        srollView_normalBet.contentSize = CGSizeMake(320, 750);
    }
    else
    {
        moveHeight = -kMoveDownHeight;
        srollView_normalBet.frame = CGRectMake(srollView_normalBet.frame.origin.x,43, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 60 - 42);
        srollView_normalBet.contentSize = CGSizeMake(320, 360 + 40);
    }
    m_FreePassButton.frame = CGRectMake(m_FreePassButton.frame.origin.x, m_FreePassButton.frame.origin.y + moveHeight, m_FreePassButton.frame.size.width, m_FreePassButton.frame.size.height);
    
    m_DuoChuanPassButton.frame = CGRectMake(m_DuoChuanPassButton.frame.origin.x, m_DuoChuanPassButton.frame.origin.y + moveHeight, m_DuoChuanPassButton.frame.size.width, m_DuoChuanPassButton.frame.size.height);
    
    m_freePassScollView.frame = CGRectMake(m_freePassScollView.frame.origin.x, m_freePassScollView.frame.origin.y + moveHeight, m_freePassScollView.frame.size.width, m_freePassScollView.frame.size.height);
    
    m_DuoChuanPassScollView.frame = CGRectMake(m_DuoChuanPassScollView.frame.origin.x, m_DuoChuanPassScollView.frame.origin.y + moveHeight, m_DuoChuanPassScollView.frame.size.width, m_DuoChuanPassScollView.frame.size.height);
    
    m_image_top.frame = CGRectMake(m_image_top.frame.origin.x, m_image_top.frame.origin.y + moveHeight, m_image_top.frame.size.width, m_image_top.frame.size.height);
    
    m_image_bottom.frame = CGRectMake(m_image_bottom.frame.origin.x, m_image_bottom.frame.origin.y + moveHeight, m_image_bottom.frame.size.width, m_image_bottom.frame.size.height);
    
    m_guoguanFangshLabel.frame = CGRectMake(m_guoguanFangshLabel.frame.origin.x, m_guoguanFangshLabel.frame.origin.y + moveHeight, m_guoguanFangshLabel.frame.size.width, m_guoguanFangshLabel.frame.size.height);
    view_down.frame = CGRectMake(view_down.frame.origin.x, view_down.frame.origin.y + moveHeight, view_down.frame.size.width, view_down.frame.size.height);
}
- (IBAction)betCodeClick:(id)sender
{
    
    BOOL ishave = NO;
    for (UIScrollView *view in [self.srollView_normalBet subviews]) {
        if ([view isKindOfClass:[UIScrollView class]] && view.tag == kFangAnXiangQingViewTag) {
            ishave = YES;
            if (!m_expandBetCode) {
                view.hidden = NO;
            }
            else
                view.hidden = YES;
        }
    }
    if (!ishave) {
        UIScrollView* view = [self creatExpandCellView];
        [self.srollView_normalBet addSubview:view];
    }
    if (!m_expandBetCode) {
        [betCodeList setTitle:@"" forState:UIControlStateNormal];
        [self betCode_ExpandButtonEvent_move:YES];
    }
    else
    {
        NSString* betCodeListStr = [RuYiCaiLotDetail sharedObject].disBetCode;
        betCodeListStr = [betCodeListStr stringByReplacingOccurrencesOfString:@"," withString:@" "];//去掉 button中的，
        [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", betCodeListStr] forState:UIControlStateNormal];
        [self betCode_ExpandButtonEvent_move:NO];
    }
    
    m_expandBetCode = !m_expandBetCode;
    if (m_expandBetCode) {
        image_sanjiao.image = [UIImage imageNamed:@"sanjiao_expand.png"];
    }
    else
        image_sanjiao.image = [UIImage imageNamed:@"sanjiao_hide.png"];
}

-(UIScrollView*) creatExpandCellView
{
    NSMutableString* betcodeList = [NSMutableString stringWithString:[[RuYiCaiLotDetail sharedObject] disBetCode]];
    if ([betcodeList length] == 0) {
        return nil;
    }
    UIScrollView* view = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 92, 300, kMoveDownHeight)] autorelease];
    view.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
    view.contentSize = CGSizeMake(300, m_betCodeListHeight);
    view.tag = kFangAnXiangQingViewTag;
    // ; @ , :
    NSArray* gameArray = [betcodeList componentsSeparatedByString:@";"];
    if (gameArray > 0) {
        int heightindex = 0;
        for ( int i = 0;i < [gameArray count];i++) {
            NSString* str = [gameArray objectAtIndex:i];
            
            NSArray* array_2 = [str componentsSeparatedByString:@"@"];
            //周一 001 皇家马德里 vs 巴萨
            UILabel* lable = [[[UILabel alloc] initWithFrame:CGRectMake(10, heightindex * 19 , 300, 19)] autorelease];
            lable.backgroundColor = [UIColor clearColor];
            lable.textColor = [UIColor blackColor];
            lable.font = [UIFont systemFontOfSize:13];
            lable.textAlignment = UITextAlignmentLeft;
            lable.text = ([array_2 count] > 0 ? [array_2 objectAtIndex:0] :@"");
            [view addSubview:lable];
            
            heightindex += 1;
            if ([array_2 count] == 2)
            {
                NSString* play_str = [array_2 objectAtIndex:1];
                NSArray* array_3 = [play_str componentsSeparatedByString:@","];
                
                for (int j = 0 ; j < [array_3 count];j++) {
                    NSString* str_3 = [array_3 objectAtIndex:j];
                    
                    if ([str_3 length] > 0) {
                        NSArray* array_4 = [str_3 componentsSeparatedByString:@"~"];
                        NSString* playChoose = ([array_4 count] > 0 ? [array_4 objectAtIndex:0] : @"");
                        //胜平负：
                        if ([playChoose length] > 0) {
                            
                            UILabel* lable = [[[UILabel alloc] initWithFrame:CGRectMake(10, heightindex * 19 , 70, 19)] autorelease];
                            lable.textColor = [UIColor blackColor];
                            lable.backgroundColor = [UIColor clearColor];
                            lable.font = [UIFont systemFontOfSize:13];
                            lable.textAlignment = UITextAlignmentLeft;
                            lable.text = playChoose;
                            [view addSubview:lable];
                        }
                        
                        NSString* play_content = ([array_4 count] > 1 ? [array_4 objectAtIndex:1] : @"");
                        
                        if ([play_content length] > 0)
                        {
                            CGSize labelsize = [play_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300 - 80,2000) lineBreakMode:UILineBreakModeWordWrap];
                            int hangnum = labelsize.height/19 + 1;
                            /*0:2 0:3 1:0 2: 0 3:0 5:2
                             胜其他 平其他 负其他
                             */
                            UILabel* lable_content = [[[UILabel alloc] initWithFrame:CGRectMake(75, 19 * heightindex, 300 - 80, hangnum * 19)] autorelease];
                            lable_content.backgroundColor = [UIColor clearColor];
                            lable_content.textColor = [UIColor redColor];
                            lable_content.font = [UIFont systemFontOfSize:13];
                            lable_content.textAlignment = UITextAlignmentLeft;
                            lable_content.lineBreakMode = UILineBreakModeWordWrap;
                            lable_content.numberOfLines = hangnum;
                            lable_content.text = play_content;
                            [view addSubview:lable_content];
                            heightindex += hangnum;
                        }
                    }
                }
            }
        }
    }
    return view;
}

-(NSInteger) getBetCodeListHeight
{
    NSMutableString* betcodeList = [NSMutableString stringWithString:[[RuYiCaiLotDetail sharedObject] disBetCode]];
    if ([betcodeList length] == 0) {
        return 0;
    }
    // ; @ , ~
    /*
     betCode******
     星期二 001 广岛三箭  VS  浦项制铁@胜平负~ 胜 ,半全场~胜胜  胜平  平负  负胜  ,总进球~ 0 ,比分~胜其它  ,;
     星期二 002 首尔FC  VS  仙台维加泰@胜平负~ 胜 ,;
     */
    NSArray* gameArray = [betcodeList componentsSeparatedByString:@";"];
    int heightindex = 0;
    if (gameArray > 0) {
        for ( int i = 0;i < [gameArray count];i++) {
            NSString* str = [gameArray objectAtIndex:i];
            NSArray* array_2 = [str componentsSeparatedByString:@"@"];
            //周一 001 皇家马德里 vs 巴萨
            heightindex += 1;
            if ([array_2 count] == 2)
            {
                NSString* play_str = [array_2 objectAtIndex:1];
                NSArray* array_3 = [play_str componentsSeparatedByString:@","];
                
                for (int j = 0 ; j < [array_3 count];j++) {
                    NSString* str_3 = [array_3 objectAtIndex:j];
                    
                    if ([str_3 length] > 0) {
                        NSArray* array_4 = [str_3 componentsSeparatedByString:@"~"];
                        NSString* play_content = ([array_4 count] > 1 ? [array_4 objectAtIndex:1] : @"");
                        if ([play_content length] > 0)
                        {
                            CGSize labelsize = [play_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300 - 60,2000) lineBreakMode:UILineBreakModeWordWrap];
                            int hangnum = labelsize.height/19 + 1;
                            /*0:2 0:3 1:0 2: 0 3:0 5:2
                             胜其他 平其他 负其他
                             */
                            heightindex += hangnum;
                        }
                    }
                }
            }
        }
    }
    return  heightindex * 19;
}
//发起和买 投注注码 点击展开的 回调
- (void)launchViewContentSizeCahnge:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[NSString class]]) {
        NSString* state = notification.object;
        if ([state isEqualToString:@"yes"]) {
            self.srollView_HMBet.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,kLaunchHMMaxScrollContentHeight);
        }
        else
        {
            self.srollView_HMBet.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,kLaunchHMMaxScrollContentHeight - 120);
        }
    }
    
}

- (IBAction)buyClick:(id)sender
{
    //    //保存选择的比赛到关注里面
    //    if ([m_eventChooseGameArray count] > 0) {
    //
    //        [[NSUserDefaults standardUserDefaults] setValue:m_eventChooseGameArray forKey:self.userChooseGameEvent];
    //    }
    //    else
    //    {
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.userChooseGameEvent];
    //    }
        
    
    if (m_betNumber > 10000) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单笔投注不能超过10000注，请您重新选择玩法" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
    if (![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    
    if (m_betNumber <= 0) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请选择玩法" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    
    if([appStoreORnormal isEqualToString:@"appStore"]&&
       [appTestPhone isEqualToString:[RuYiCaiNetworkManager sharedManager].phonenum])
    {
        if([self BetJudement])
        {
            [self buildBetCode];
            [self wapPageBuild];
        }
    }
    else
    {
        switch (self.cusSegmented.segmentedIndex)
        {
            case kSegIndexNormal:
            {
                if([self BetJudement])
                {
                    [MobClick event:@"JC_bet"];
                    
                    [self buildBetCode];
                    
                    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
                    [dict setObject:@"1" forKey:@"isSellWays"];
                    if (m_minWinAmount != 0.0 || m_maxWinAmount != 0.0) {//预计奖金
                        [dict setObject:[NSString stringWithFormat:@"%0.2lf元-%.2lf元", m_minWinAmount, m_maxWinAmount] forKey:@"expectPrizeAmt"];
                    }
                    [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
                }
            }break;
            case kSegIndexHM:
            {
                [self buildBetCode];
                [RuYiCaiLotDetail sharedObject].sellWay = @"0";
                //                [self.LaunchHMView buildBetCode];
                [self.LaunchHMView LotComplete:nil];
            }break;
                
            default:
                break;
        }
    }
}


#pragma mark 保存选择的比赛

- (void) saveUserChooseGameTwo
{
    //    JC_AttentionDataManagement *dataManager = [JC_AttentionDataManagement shareManager];
    [JC_AttentionDataManagement shareManager].mark = self.userChooseGameEvent;
    for (int i = 0; i < [m_eventChooseGameArray count]; i++)
    {
        [[JC_AttentionDataManagement shareManager] addDataWithEvent:[m_eventChooseGameArray objectAtIndex:i]];
    }
}


- (void) saveUserChooseGame
{
    //读取已经关注的比赛
    NSMutableArray* UserSavedArray = [NSArray arrayWithArray:(NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userChooseGameEvent]];
    NSLog(@"UserSavedArray:::::::::%@",UserSavedArray);
    
    NSMutableArray* UserSavedArray_copy;
    
    
    NSLog(@"chooseGameArray::::::::%@",m_eventChooseGameArray);
    
    //如果此时没有关注
    if ([UserSavedArray count] == 0)
    {
        
        UserSavedArray_copy = [NSMutableArray array];
        
        NSString *tempdate = @"";
        NSMutableDictionary*  timeDict = [NSMutableDictionary dictionary];
        for (int i = 0; i < [m_eventChooseGameArray count]; i++)
        {
            //第一次直接加进去
            if (i == 0) {
                tempdate = [self getDateWithEvent:[m_eventChooseGameArray objectAtIndex:0]];
                NSMutableArray* eventArray = [NSMutableArray array];
                [eventArray addObject:[m_eventChooseGameArray objectAtIndex:i]];
                [timeDict setObject:eventArray forKey:tempdate];
            }
            else//之后需要判断是否存在这个日期
            {
                NSArray *keyArray = [timeDict allKeys];
                tempdate = [self getDateWithEvent:[m_eventChooseGameArray objectAtIndex:i]];
                BOOL hasAdd = false;
                for (NSString *key in keyArray) {
                    
                    if ([key isEqualToString:tempdate]) {
                        hasAdd = true;
                    }
                }
                
                if (hasAdd) {
                    [[timeDict objectForKey:tempdate] addObject:[m_eventChooseGameArray objectAtIndex:i]];
                }
                else
                {
                    NSMutableArray* eventArray = [NSMutableArray array];
                    [eventArray addObject:[m_eventChooseGameArray objectAtIndex:i]];
                    [timeDict setObject:eventArray forKey:tempdate];
                }
            }
            
        }
        [UserSavedArray_copy addObject:timeDict];
        //写入本地文件
        [[NSUserDefaults standardUserDefaults] setValue:UserSavedArray_copy forKey:self.userChooseGameEvent];
        [[NSUserDefaults standardUserDefaults] synchronize];//tongbu
    }
    else//如果有关注
    {
        UserSavedArray_copy = [NSMutableArray arrayWithArray:UserSavedArray];
        NSLog(@"UserSavedArray_copy:%@",UserSavedArray_copy);
        
        for (int i = 0; i < [m_eventChooseGameArray count]; i++)
        {
            NSString *dateEvent = [self getDateWithEvent:[m_eventChooseGameArray objectAtIndex:i]];
            //判断这场比赛是否已经关注，如果有则纪录这场比赛对应的日期的下标
            BOOL hasSave = NO;
            NSInteger saveIndex = 0;
            for (int j = 0; j < [UserSavedArray count]; j++)
            {
                if ([[UserSavedArray objectAtIndex:j] objectForKey:dateEvent] != nil)
                {
                    hasSave = YES;
                    saveIndex = j;
                    break;
                }
            }
            
            if (hasSave)//如果存在这个日期了
            {
                NSMutableDictionary*  timeDict  = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[UserSavedArray objectAtIndex:saveIndex]];
                NSLog(@"timeDict:%@",timeDict);
                NSMutableArray *event = [NSMutableArray arrayWithArray:(NSArray*)[timeDict objectForKey:dateEvent]];
                BOOL hasAdd = false;//判断是否保存了这场比赛
                for (NSString *temp in event)
                {
                    if ([(NSString*)[m_eventChooseGameArray objectAtIndex:i] isEqualToString:temp])
                    {
                        hasAdd = true;
                        break;
                    }
                }
                
                if (!hasAdd)//如果没有则保存
                {
                    [event addObject:[m_eventChooseGameArray objectAtIndex:i]];
                    [timeDict setValue:event forKey:dateEvent];
                    [UserSavedArray_copy replaceObjectAtIndex:saveIndex withObject:timeDict];
                    
                }
            }
            else//如果没有存在这个日期，需重新创建一个字典
            {
                NSMutableDictionary *timeDict = [NSMutableDictionary dictionary];
                NSMutableArray* eventArray = [NSMutableArray array];
                [eventArray addObject:[m_eventChooseGameArray objectAtIndex:i]];
                [timeDict setObject:eventArray forKey:dateEvent];
                
                [UserSavedArray_copy addObject:timeDict];
            }
            //写入文件
            [[NSUserDefaults standardUserDefaults] setValue:UserSavedArray_copy forKey:self.userChooseGameEvent];
            [[NSUserDefaults standardUserDefaults] synchronize];//tongbu
        }
    }
}


//通过Event截取日期
- (NSString*) getDateWithEvent:(NSString*)event
{
    if (event) {
        NSArray *array = [event componentsSeparatedByString:@"_"];
        
        return [array objectAtIndex:1];
    }
    else
    {
        return @"";
    }
    
}


- (void)wapPageBuild
{
    if([[RuYiCaiNetworkManager sharedManager] testConnection])
    {
        NSMutableDictionary* mDict = [[RuYiCaiNetworkManager sharedManager] getCommonCookieDictionary];
        [mDict setObject:@"betLot" forKey:@"command"];
        [mDict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
        [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        if([RuYiCaiLotDetail sharedObject].batchCode)
            [mDict setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].batchNum forKey:@"batchnum"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].lotMulti forKey:@"lotmulti"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].betType forKey:@"bettype"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].sellWay forKey:@"sellway"];
        [mDict setObject:@"1" forKey:@"isSellWays"];
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSString* cookieStr = [jsonWriter stringWithObject:mDict];
        [jsonWriter release];
        
        NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
        NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
        NSString *AESstring = [[[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding] autorelease];
        
        NSMutableString *sendStr = [NSMutableString stringWithFormat:
                                    @"%@",kRuYiCaiBetSafari];
        NSString *allStr = [sendStr stringByAppendingString:AESstring];
        //        NSLog(@"safari:%@ ", allStr);
        
        NSString *strUrl = [allStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"检测不到网络" withTitle:@"提示" buttonTitle:@"确定"];
    }
}

#pragma mark -购买 合买 成功
- (void)betCompleteOK:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)fqHeMaiLotOK:(NSNotification*)notification
{
    UIAlertView *succesAlertView = [[UIAlertView alloc] initWithTitle:@"全民免费彩" message:@"恭喜您已成功发起合买，赶紧告诉更多好友一起中大奖！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    succesAlertView.tag =110;
    [succesAlertView show];
    [succesAlertView release];
}

- (void)getShareDetileLotOK:(NSNotification*)notification//合买成功弹出view
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSLog(@"合买成功之后的再次请求返回的分享信息-------%@",[RuYiCaiNetworkManager sharedManager].responseText);
    
    self.getShareDetileDic = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
}

#pragma mark textField and touch delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.fieldBeishu resignFirstResponder];
    
    NSLog(@"%f", self.srollView_normalBet.center.y);
    if(self.srollView_normalBet.center.y != ([self.srollView_normalBet frame].size.height/2 + [self.srollView_normalBet frame].origin.y))
    {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.srollView_normalBet.center;
        center.y += 80;
        self.srollView_normalBet.center = center;
        [UIView commitAnimations];
    }
    return YES;
}

- (void)hideKeybord
{
    [self.fieldBeishu resignFirstResponder];
    
    NSLog(@"%f", self.srollView_normalBet.center.y);
    if(self.srollView_normalBet.center.y != ([self.srollView_normalBet frame].size.height/2 + [self.srollView_normalBet frame].origin.y))
    {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.srollView_normalBet.center;
        center.y += 80;
        self.srollView_normalBet.center = center;
        [UIView commitAnimations];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%f",self.srollView_normalBet.center.y);
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.fieldBeishu.text.length >= 6 && range.length == 0)
    {
        return  NO;
    }
    else//只允许输入数字
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i = 0; i < textField.text.length; i++)
    {
        UniChar chr = [textField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"数字不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"填写的必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    if([textField.text intValue] <= 0 || [textField.text intValue] > 100000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"投注倍数的范围为 1~100000倍" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    
    [self refreshData];
    
}

#pragma mark 投注余额不足处理
- (void)notEnoughMoney:(NSNotification*)notification
{
    
    UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:CaiJinDuiHuanTiShi
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
    //            [alterView addButtonWithTitle:@"直接支付"];
    [alterView addButtonWithTitle:@"免费兑换"];
    alterView.tag = 112;
    [alterView show];
    [alterView release];
    
//    switch (self.cusSegmented.segmentedIndex)
//    {
//        case kSegIndexNormal:
//        {
//            //            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
//            //                                                                message:@"尊敬的用户，您的账户余额不足以支付本次购买，请选择去充值或直接支付！"
//            //                                                               delegate:self
//            //                                                      cancelButtonTitle:@"取消"
//            //                                                      otherButtonTitles:nil];
//            //            [alterView addButtonWithTitle:@"直接支付"];
//            //            [alterView addButtonWithTitle:@"去充值"];
//            //            alterView.tag = 112;
//            //            [alterView show];
//            //            [alterView release];
//            [self setHidesBottomBarWhenPushed:YES];
//            
//            NotEnoughMoneyViewController* viewController = [[NotEnoughMoneyViewController alloc] init];
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
//            
//        }break;
//        default:
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"余额不足" withTitle:@"错误" buttonTitle:@"确定"];
//            break;
//    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if(112 == alertView.tag)
    //    {
    //        if(1 == buttonIndex)//直接支付
    //        {
    //            [self setHidesBottomBarWhenPushed:YES];
    //
    //            DirectPaymentViewController* viewController = [[DirectPaymentViewController alloc] init];
    //            [self.navigationController pushViewController:viewController animated:YES];
    //            [viewController release];
    //        }
    //        else if(2 == buttonIndex)//去充值
    //        {
    //            [self setHidesBottomBarWhenPushed:YES];
    //
    //            ChangeViewController* viewController = [[ChangeViewController alloc] init];
    //            [self.navigationController pushViewController:viewController animated:YES];
    //            [viewController release];
    //        }
    //    }
    
    
    if (110 == alertView.tag)
    {
        if (buttonIndex==1)
        {
            ShareViewController *shareViewController = [[ShareViewController alloc] init];
            shareViewController.delegate = self;
            shareViewController.navigationItem.title=@"合买分享";
            shareViewController.sinShareContent = [NSString stringWithFormat:@"@全民免费彩，我刚发起了一个%@的合买,合买中奖率更大!%@", [[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"lotName"],[[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"url"]];
            
            shareViewController.txShareContent = [NSString stringWithFormat:@"@全民免费彩，我刚发起了一个%@的合买,合买中奖率更大!%@", [[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"lotName"],[[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"url"]];
            
            shareViewController.shareContent =[NSString stringWithFormat:@"@全民免费彩，我刚发起了一个%@的合买,合买中奖率更大!%@", [[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"lotName"],[[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"url"]];
            shareViewController.pushType = @"PUSHHIDE";
            [self.navigationController pushViewController:shareViewController animated:YES];
            [shareViewController release];
        }else if(buttonIndex==0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
    
    if(112 == alertView.tag)
    {
        if(1 == buttonIndex)//去充值
        {
            [self setHidesBottomBarWhenPushed:YES];
            
            ExchangeLotteryWithIntegrationViewController * viewController = [[ExchangeLotteryWithIntegrationViewController alloc] init];
            viewController.isShowBackButton = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }

    }

}

#pragma mark betCode method
- (void)buildBetCode
{
    //by huangxin
    int numBeishu = [self.fieldBeishu.text intValue];
    if (self.cusSegmented.segmentedIndex == kSegIndexHM) {
        numBeishu = [self.LaunchHMView.fieldBeishu.text intValue];
    }
    NSString* betCode = @"";
    if (m_isDanGuan)
    {
        
        betCode = [betCode stringByAppendingFormat:@"%d@",500];
        
        betCode = [betCode stringByAppendingFormat:@"%@",m_chooseBetCode];
        
        betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu,m_betNumber * 200];
    }
    else
    {
        if (m_isFreePassButton)
        {
            int RadioIndexArrayCount = [freePassRadioIndexArray count];
            for (int a = 0; a < RadioIndexArrayCount; a++) {
                if (m_DanCount > 0)
                {
                    betCode = [betCode stringByAppendingFormat:@"%d@",[[freePassRadioIndexArray objectAtIndex:a] intValue] + 100];
                }
                else
                    betCode = [betCode stringByAppendingFormat:@"%d@",[[freePassRadioIndexArray objectAtIndex:a] intValue]];
                
                betCode = [betCode stringByAppendingFormat:@"%@",m_chooseBetCode];
                
                int betNum = [self getFreeChuanBetNum:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
                betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu,betNum * 200];
                if (a < RadioIndexArrayCount - 1) {
                    betCode = [betCode stringByAppendingString:@"!"];
                }
            }
        }
        else
        {
            NSArray* keyArray = [(NSDictionary*)[m_duoChuanPassRadioArray objectAtIndex:duoChuanPassRadioIndex] allKeys];
            NSString *key = [keyArray objectAtIndex:0];
            
            int keyNumber = [key intValue];
            
            if (m_DanCount > 0) {
                keyNumber += 100;
            }
            
            betCode = [betCode stringByAppendingFormat:@"%@@",[NSString stringWithFormat:@"%d",keyNumber]];
            betCode = [betCode stringByAppendingFormat:@"%@",m_chooseBetCode];
            betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu,m_betNumber * 200];
        }
    }
    
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = [RuYiCaiLotDetail sharedObject].betCode;
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%.0lf",m_allCount];
    [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    [RuYiCaiLotDetail sharedObject].batchNum = @"1";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    [RuYiCaiLotDetail sharedObject].batchCode = @"";
    
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%.0lf",m_allCount];
}



#pragma mark 组合数算法
/*
 以在n个数中选取m(0<m<=n)个数为例，问题可分解为：
 1. 首先从n个数中选取编号最大的数，然后在剩下的n-1个数里面选取m-1个数，直到从n-(m-1)个数中选取1个数为止
 2. 从n个数中选取编号次小的一个数，继续执行1步，直到当前可选编号最大的数为m。
 很明显，上述方法是一个递归的过程，也就是说用递归的方法可以很干净利索地求得所有组合。
 下面是递归方法的实现：
 /// 求从数组a[1..n]中任选m个元素的所有组合。
 /// a[1..n]表示候选集，m表示一个组合的元素个数。
 /// b[1..M]用来存储当前组合中的元素, 常量M表示一个组合中元素的个数。
 */
void combine( int a[], int n, int m, int b[], const int M ,CombineListArray *ListArraybase, CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            combine(a,i-1,m-1,b,M,ListArraybase,data);
        else      // m == 1, 输出一个组合
        {
            CombineList *array = [[CombineList alloc] init];
            for(int j=M-1; j>=0; j--)
            {
                CombineBase* base = (CombineBase*)[[data combineList] objectAtIndex:b[j]];
                CombineBase* baseBase = [[CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                baseBase.gameCount = [base gameCount];
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    //                    [base.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                
                [array appendList:baseBase];
                [baseBase release];
            }
            [ListArraybase appendListArray:array];
            [array release];
        }
    }
}

void combine_List( int a[], int n, int m,  int b[], const int M,CombineList *listbase,CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            combine_List(a,i-1,m-1,b,M,listbase,data);
        else      // m == 1, 输出一个组合
        {
            for(int j=M-1; j>=0; j--)
            {
                CombineBase* base = (CombineBase*)[[data combineList] objectAtIndex:b[j]];
                CombineBase* baseBase = [[CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                baseBase.gameCount = [base gameCount];
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    
                    //                    [baseBase.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                [listbase appendList:baseBase];
                [baseBase release];
            }
        }
    }
}

void combine_SP(float a[], int n, int m, int b[], const int M ,CombineListArray *ListArraybase,CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            combine_SP(a,i-1,m-1,b,M,ListArraybase,data);
        else      // m == 1, 输出一个组合
        {
            CombineList *array = [[CombineList alloc] init];
            for(int j=M-1; j>=0; j--)
            {
                CombineBase* base = (CombineBase*)[[data combineList] objectAtIndex:b[j]];
                CombineBase* baseBase = [[CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                for (int sp = 0; sp < [[base combineBase_SP] count]; sp++) {
                    [[baseBase combineBase_SP] addObject:[[base combineBase_SP] objectAtIndex:sp]];
                }
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    
                    //                    [baseBase.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                [array appendList:baseBase];
                [baseBase release];
            }
            [ListArraybase appendListArray:array];
            [array release];
        }
    }
}
void combine_SP_List(float a[], int n, int m, int b[], const int M ,CombineList *listbase,CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            combine_SP_List(a,i-1,m-1,b,M,listbase,data);
        else      // m == 1, 输出一个组合
        {
            for(int j=M-1; j>=0; j--)
            {
                CombineBase* base = (CombineBase*)[[data combineList] objectAtIndex:b[j]];
                CombineBase* baseBase = [[CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                for (int sp = 0; sp < [[base combineBase_SP] count]; sp++) {
                    [[baseBase combineBase_SP] addObject:[[base combineBase_SP] objectAtIndex:sp]];
                }
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    
                    //                    [baseBase.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                [listbase appendList:baseBase];
                [baseBase release];
            }
        }
    }
}



void combine_SP_confusion(NSMutableArray* result,NSArray* data,int curr,int count,NSMutableArray* temp_baseArray)
{
    if (curr == count)
    {
        NSLog(@" @@@@@@@@@@@@@@@ \n%@ ",temp_baseArray);
        [result addObject:temp_baseArray];
        [temp_baseArray removeAllObjects];
    }
    else
    {
        int i;
        NSArray* array = [data objectAtIndex:curr];
        for (i = 0; i < [array count]; ++i)
        {
            [temp_baseArray addObject:[array objectAtIndex:i]];
            combine_SP_confusion(result,data, curr+1,count,temp_baseArray);
        }
    }
}


#pragma mark 计算注数

/*
 思路：
 X串N
 从比赛场数中 选择X场，根据选择的是几串几 ，列出所选比赛的组合
 然后 再在这些组合中 算出组合的可能
 
 
 例：（4场比赛  A只有一种可能 B 2种、、、）
 A - 1
 B - 2
 C - 2
 D - 1
 如果选择玩法3串3
 既 先从四场比赛中选取三场：
 （
 ABC
 ABD
 BCD
 ACD
 ）
 根据3串3的玩法规则 既 3个 2串1
 因此：
 ABC(1 2 2) -------[AB(12) AC(12) BC(22)]  1*2 + 1*2 + 2*2 = 8种
 ABD（1 2 1）-------[AB(12) AD(11) BD(21)]  1*2 + 1*1 + 2*1 = 5
 BCD（2 2 1）-------[BC(22) BD(21) CD(21)]  2*2 + 2*1 + 2*1 = 8
 ACD(1 2 1) -------[AC(12) AD(11) CD(21)]  1*2 + 1*1 + 2*1 = 5
 
 因此 总共为 26种组合方式
 */



//计算单式过关的注数
- (NSInteger)getFreeChuanBetNum:(NSInteger)X
{
    int count = 0;
    int duoChuanChooseArraycount = [[m_duoChuanChooseArray combineList] count];
    int a[duoChuanChooseArraycount];
    int Dan_count = 0;
    
    CombineList* noDanArray = [[CombineList alloc] init];
    CombineList* danArray = [[CombineList alloc] init];
    for (int i = 0; i < duoChuanChooseArraycount; i++)
    {
        a[i] = [(CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] gameCount];
        if ([(CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] isDan])
        {
            Dan_count++;
            [danArray appendList:[[m_duoChuanChooseArray combineList] objectAtIndex:i]];
        }
        else
            [noDanArray appendList:[[m_duoChuanChooseArray combineList] objectAtIndex:i]];
    }
    
    int danBetNum = 1;//胆组合的总数
    for (int d = 0; d < [danArray.combineList count]; d++) {
        CombineBase* base = [danArray.combineList objectAtIndex:d];
        danBetNum *= [base gameCount];
    }
    
    //选X－Dan_count场
    int b[X-Dan_count];
    CombineListArray *listArrayTemp = [[CombineListArray alloc] init];
    combine(a, duoChuanChooseArraycount - Dan_count, X-Dan_count, b, X-Dan_count,listArrayTemp,noDanArray);//在没有胆的比赛中选（X－胆）场
    
    int ListArrayCount = [[listArrayTemp combineListArray] count];
    for (int j = 0; j < ListArrayCount; j++)
    {
        CombineList* List = (CombineList*)[[listArrayTemp combineListArray] objectAtIndex:j];
        int tempCount = danBetNum;
        for (int i = 0; i < [List.combineList count]; i ++) {
            CombineBase* base = [List.combineList objectAtIndex:i];
            tempCount *= [base gameCount];
        }
        count += tempCount;
    }
    return count;
}


//计算复式过关的注数
- (NSInteger)getDuoChuanBetNum:(NSInteger)X  ChangShu:(NSInteger)Y
{
    int count = 0;
    int duoChuanChooseArraycount = [[m_duoChuanChooseArray combineList] count];
    int a[duoChuanChooseArraycount];
    int Dan_count = 0;
    
    for (int i = 0; i < duoChuanChooseArraycount; i++)
    {
        a[i] = [(CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] gameCount];
        if ([(CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] isDan])
        {
            Dan_count++;
        }
    }
    
    //选X场
    int b[X];
    CombineListArray *listArrayTemp = [[CombineListArray alloc] init];
    combine(a, duoChuanChooseArraycount, X, b, X,listArrayTemp,m_duoChuanChooseArray);//在n个数中选取m
    
    int ListArrayCount = [[listArrayTemp combineListArray] count];
    for (int j = 0; j < ListArrayCount; j++)
    {
        CombineList* List = (CombineList*)[[listArrayTemp combineListArray] objectAtIndex:j];
        int tempCount = 1;
        BOOL isHaveDan = NO;//是否剔除不含胆的场数
        NSInteger danCount = 0;
        for (int i = 0; i < [List.combineList count]; i ++) {
            CombineBase* base = [List.combineList objectAtIndex:i];
            
            isHaveDan += Dan_count <= Y - X ? YES : base.isDan;
            danCount += base.isDan;//胆个数
            tempCount *= base.gameCount;//每种组合选择个数之积
            if (i == [List.combineList count] - 1) {//考虑胆数量
                if (X == Y) {
                    tempCount = danCount == m_DanCount ? tempCount : 0;
                }
                else
                    tempCount = isHaveDan >= (X - (Y - Dan_count)) ? tempCount : 0;//6场 3个胆 4串4
            }
        }
        if (Dan_count == 0 || Dan_count == danCount) {//重复数 跟胆相关
            tempCount *= RYCChoose(Y - X, self.gameCount-X);
        }
        else if (Dan_count != 0 && danCount < Dan_count)
        {
            if (RYCChoose(Y - X - (Dan_count - danCount), self.gameCount - Dan_count - (X - danCount)) != 0) {
                tempCount *= RYCChoose(Y - X - (Dan_count - danCount), self.gameCount - Dan_count - (X - danCount));
            }
        }
        else if(!isHaveDan)//不考虑要包含胆的组合 的重复数
            tempCount *= RYCChoose(Y - X - Dan_count, self.gameCount - X - Dan_count);
        count += tempCount;
    }
    NSLog(@"count1 %d" ,count);
    
    return count;
}

//传进来一个X串Y的字符串，返回这种串法的个数
-(NSInteger) getNoteNumberByDuoChuanRadioTag:(NSString*)DuoChuanRadioTag
{
    int count = 0;
    
    if (DuoChuanRadioTag == @"3串3") {
        count = [self getDuoChuanBetNum:2 ChangShu:3];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(3 - 2, (m_gameCount - 2));
        
        float amount = 0.0;
        [self calculationAmountBy_X_Y:3 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"3串4")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:3] +
        [self getDuoChuanBetNum:3 ChangShu:3];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(3 - 2, (m_gameCount - 2));
        
        float amount = 0.0;
        [self calculationAmountBy_X_Y:3 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:3 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"4串4")
    {
        count = [self getDuoChuanBetNum:3 ChangShu:4];
        
        m_minWinAmount = [self getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(4 - 3, (m_gameCount - 3));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:4 Y:3];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"4串5")
    {
        count = [self getDuoChuanBetNum:3 ChangShu:4] +
        [self getDuoChuanBetNum:4 ChangShu:4];
        ;
        
        m_minWinAmount = [self getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(4 - 3, (m_gameCount - 3));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:4 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:4 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"4串6")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:4];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(4 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:4 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if(DuoChuanRadioTag == @"4串11")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:4] +
        [self getDuoChuanBetNum:3 ChangShu:4] +
        [self getDuoChuanBetNum:4 ChangShu:4];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(4 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:4 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:4 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:4 Y:4];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    
    else if(DuoChuanRadioTag == @"5串5")
    {
        count = [self getDuoChuanBetNum:4 ChangShu:5];
        
        m_minWinAmount = [self getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(5 - 4, (m_gameCount - 4));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
        
    }
    else if(DuoChuanRadioTag == @"5串6")
    {
        count = [self getDuoChuanBetNum:4 ChangShu:5] +
        [self getDuoChuanBetNum:5 ChangShu:5];
        
        m_minWinAmount = [self getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(5 - 4, (m_gameCount - 4));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:5 Y:5];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"5串10")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:5];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(5 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:5 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if(DuoChuanRadioTag == @"5串16")
    {
        count = [self getDuoChuanBetNum:3 ChangShu:5] +
        [self getDuoChuanBetNum:4 ChangShu:5] +
        [self getDuoChuanBetNum:5 ChangShu:5];
        
        m_minWinAmount = [self getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(5 - 3, (m_gameCount - 3));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:5 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:5 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"5串20")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:5] +
        [self getDuoChuanBetNum:3 ChangShu:5];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(5 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:5 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:5 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"5串26")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:5] +
        [self getDuoChuanBetNum:3 ChangShu:5] +
        [self getDuoChuanBetNum:4 ChangShu:5] +
        [self getDuoChuanBetNum:5 ChangShu:5];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(5 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:5 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:5 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:5 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    
    else if(DuoChuanRadioTag == @"6串6")
    {
        count = [self getDuoChuanBetNum:5 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(6 - 5, (m_gameCount - 5));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"6串7")
    {
        count = [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(6 - 5, (m_gameCount - 5));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"6串15")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"6串20")
    {
        count = [self getDuoChuanBetNum:3 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(6 - 3, (m_gameCount - 3));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"6串22")
    {
        count = [self getDuoChuanBetNum:4 ChangShu:6] +
        [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(6 - 4, (m_gameCount - 4));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"6串35")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:6] +
        [self getDuoChuanBetNum:3 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"6串42")
    {
        count = [self getDuoChuanBetNum:3 ChangShu:6] +
        [self getDuoChuanBetNum:4 ChangShu:6] +
        [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(6 - 3, (m_gameCount - 3));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"6串50")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:6] +
        [self getDuoChuanBetNum:3 ChangShu:6] +
        [self getDuoChuanBetNum:4 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if(DuoChuanRadioTag == @"6串57")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:6] +
        [self getDuoChuanBetNum:3 ChangShu:6] +
        [self getDuoChuanBetNum:4 ChangShu:6] +
        [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"7串7")
    {
        count = [self getDuoChuanBetNum:6 ChangShu:7];
        
        m_minWinAmount = [self getMinWinAmountByX:6];
        m_minWinAmount *= RYCChoose(7 - 6, (m_gameCount - 6));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:7 Y:6];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"7串8")
    {
        count = [self getDuoChuanBetNum:6 ChangShu:7] +
        [self getDuoChuanBetNum:7 ChangShu:7];
        
        m_minWinAmount = [self getMinWinAmountByX:6];
        m_minWinAmount *= RYCChoose(7 - 6, (m_gameCount - 6));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:7 Y:6];
        amount += m_maxWinAmount;
        [self calculationAmountBy_X_Y:7 Y:7];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"7串21")
    {
        count = [self getDuoChuanBetNum:5 ChangShu:7];
        
        m_minWinAmount = [self getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(7 - 5, (m_gameCount - 5));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:7 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"7串35")
    {
        count = [self getDuoChuanBetNum:4 ChangShu:7];
        
        m_minWinAmount = [self getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(7 - 4, (m_gameCount - 4));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:7 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"7串120")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:7] +
        [self getDuoChuanBetNum:3 ChangShu:7] +
        [self getDuoChuanBetNum:4 ChangShu:7] +
        [self getDuoChuanBetNum:5 ChangShu:7] +
        [self getDuoChuanBetNum:6 ChangShu:7] +
        [self getDuoChuanBetNum:7 ChangShu:7];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(7 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:7 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:7 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:7 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:7 Y:5];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:7 Y:6];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:7 Y:7];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    
    else if(DuoChuanRadioTag == @"8串8")
    {
        count = [self getDuoChuanBetNum:7 ChangShu:8];
        
        m_minWinAmount = [self getMinWinAmountByX:7];
        m_minWinAmount *= RYCChoose(8 - 7, (m_gameCount - 7));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:8 Y:7];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if(DuoChuanRadioTag == @"8串9")
    {
        count = [self getDuoChuanBetNum:7 ChangShu:8] +
        [self getDuoChuanBetNum:8 ChangShu:8];
        
        m_minWinAmount = [self getMinWinAmountByX:7];
        m_minWinAmount *= RYCChoose(8 - 7, (m_gameCount - 7));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:8 Y:7];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:8 Y:8];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
        
    }
    else if(DuoChuanRadioTag == @"8串28")
    {
        count = [self getDuoChuanBetNum:6 ChangShu:8];
        
        m_minWinAmount = [self getMinWinAmountByX:6];
        m_minWinAmount *= RYCChoose(8 - 6, (m_gameCount - 6));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:8 Y:6];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"8串56")
    {
        count = [self getDuoChuanBetNum:5 ChangShu:8];
        
        m_minWinAmount = [self getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(8 - 5, (m_gameCount - 5));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:8 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"8串70")
    {
        count = [self getDuoChuanBetNum:4 ChangShu:8];
        
        m_minWinAmount = [self getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(8 - 4, (m_gameCount - 4));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:8 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if(DuoChuanRadioTag == @"8串247")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:8] +
        [self getDuoChuanBetNum:3 ChangShu:8] +
        [self getDuoChuanBetNum:4 ChangShu:8] +
        [self getDuoChuanBetNum:5 ChangShu:8] +
        [self getDuoChuanBetNum:6 ChangShu:8] +
        [self getDuoChuanBetNum:7 ChangShu:8] +
        [self getDuoChuanBetNum:8 ChangShu:8];
        
        m_minWinAmount = [self getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(8 - 2, (m_gameCount - 2));
        
        //最大
        float amount = 0.0;
        [self calculationAmountBy_X_Y:8 Y:2];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:8 Y:3];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:8 Y:4];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:8 Y:5];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:8 Y:6];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:8 Y:7];
        amount += m_maxWinAmount;
        
        [self calculationAmountBy_X_Y:8 Y:8];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    return count;
}


#pragma mark 计算除混合过关的预计奖金

- (void) appendDuoChuanChoose:(NSString*)chooseCount IS_DAN:(BOOL)is_Dan CONFUSION:(NSArray*)confusion_array
{
    if (m_duoChuanChooseArray == nil) {
        m_duoChuanChooseArray = [[CombineList alloc] init];
    }
    CombineBase* base = [[[CombineBase alloc]init] autorelease];
    [base setGameCount:[chooseCount intValue]];
    [base setIsDan:is_Dan];
    if (confusion_array != nil) {
        for(int i = 0; i < [confusion_array count]; i++) {
            
            [[base combineBase_SP_confusion] replaceObjectAtIndex:i withObject:[confusion_array objectAtIndex:i]];
            //            [base.combineBase_SP_confusion addObject:[confusion_array objectAtIndex:i]];
        }
    }
    
    [m_duoChuanChooseArray appendList:base];
}
-(void) appendArrangePS:(CombineBase*) PS
{
    if (m_Com_SParray == nil)
    {
        m_Com_SParray = [[CombineList alloc] init];
    }
    CombineBase* base = [[CombineBase alloc] init];
    for (int i = 0; i < [[PS combineBase_SP] count]; i++)
    {
        [[base combineBase_SP] addObject:(NSString*)[[PS combineBase_SP] objectAtIndex:i]];
    }
    base.isDan = [PS isDan];
    [m_Com_SParray appendList:base];
    [base release];
}
-(void) sortSPArray
{
    //排序     //对几场比赛排序 从小到大
    if (m_Com_arrangeSP_Min == nil)
    {
        m_Com_arrangeSP_Min = [[CombineList alloc] init];
    }
    int spCount = [[m_Com_SParray combineList] count];
    for (int spindex = 0; spindex < spCount; spindex++)
    {
        CombineBase *baseTemp = (CombineBase*)[[m_Com_SParray combineList] objectAtIndex:spindex];
        CombineBase* base = [[CombineBase alloc] init];
        int SPCount = [[baseTemp combineBase_SP] count];
        float minValue = 0;
        for (int i = 0; i < SPCount; i++)
        {
            float value = [[[baseTemp combineBase_SP] objectAtIndex:i] floatValue];
            if (i == 0)
            {
                minValue = value;
            }
            else
            {
                if (minValue > value)
                {
                    minValue = value;
                }
            }
        }
        base.isDan = [baseTemp isDan];
        [[base combineBase_SP] addObject:[NSString stringWithFormat:@"%f",minValue]];
        
        [m_Com_arrangeSP_Min appendList:base];
        [base release];
    }
    
    int arraySPcount = [[m_Com_arrangeSP_Min combineList] count];
    float a[arraySPcount];
    //存放临时 的m_Com_arrangeSP_Min
    CombineList* Com_arrangeSP_Min_Temp = [[CombineList alloc] init];
    for (int arrange_i = 0; arrange_i < arraySPcount; arrange_i++)
    {
        CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:arrange_i];
        float value = [[[base combineBase_SP] objectAtIndex:0] floatValue];
        a[arrange_i] = value;
        
        CombineBase* baseBase = [[CombineBase alloc] init];
        baseBase.isDan = [base isDan];
        [[baseBase combineBase_SP] addObject:[NSString stringWithFormat:@"%f",value]];
        [Com_arrangeSP_Min_Temp appendList:baseBase];
        [baseBase release];
    }
    
    [[m_Com_arrangeSP_Min combineList] removeAllObjects];
    
    int sort_IndexArray[arraySPcount];//排序之后的 索引
    int index = 0;
    while(index < arraySPcount)
    {
        sort_IndexArray[index]=index;
        index++;
    }
    
    int m_i,m_j;
    float m_temp;
    
    for(m_j = 0;m_j < arraySPcount;m_j++)
    {
        for (m_i = m_j + 1; m_i < arraySPcount; ++m_i)
        {
            if (a[m_j] > a[m_i])
            {
                m_temp = a[m_j];
                a[m_j] = a[m_i];
                a[m_i] = m_temp;
                
                m_temp = sort_IndexArray[m_j];
                sort_IndexArray[m_j] = sort_IndexArray[m_i];
                sort_IndexArray[m_i] = m_temp;
            }
        }
        
    }
    
    for (int arrange_i = 0  ; arrange_i <arraySPcount; arrange_i++)
    {
        CombineBase* base = (CombineBase*)[[Com_arrangeSP_Min_Temp combineList] objectAtIndex:sort_IndexArray[arrange_i]];
        CombineBase* baseBase = [[CombineBase alloc] init];
        baseBase.isDan = [base  isDan];
        
        //        NSLog(@"%@",[base combineBase_SP]);
        
        [[baseBase combineBase_SP] addObject:[[base combineBase_SP] objectAtIndex:0]];
        [m_Com_arrangeSP_Min  appendList:base];
        [baseBase release];
        
    }
    [Com_arrangeSP_Min_Temp release];
    
    //////////////////////////////////////////排序     //对几场比赛排序 从大到小
    if (m_Com_arrangeSP_Max == nil)
    {
        m_Com_arrangeSP_Max = [[CombineList alloc] init ];
    }
    int sp_max_Count = [[m_Com_SParray combineList] count];
    for (int spindex = 0; spindex < sp_max_Count; spindex++)
    {
        CombineBase *baseTemp = (CombineBase*)[[m_Com_SParray combineList] objectAtIndex:spindex];
        CombineBase* base = [[CombineBase alloc] init];
        int SPCount = [[baseTemp combineBase_SP] count];
        float maxValue = 0.0;
        for (int i = 0; i < SPCount; i++)
        {
            float value = [[[baseTemp combineBase_SP] objectAtIndex:i] floatValue];
            if (i == 0)
            {
                maxValue = value;
            }
            else
            {
                if (maxValue < value)
                {
                    maxValue = value;
                }
            }
        }
        base.isDan = [baseTemp isDan];
        [[base combineBase_SP] addObject:[NSString stringWithFormat:@"%f",maxValue]];
        [m_Com_arrangeSP_Max appendList:base];
        [base release];
    }
    
    int arraySP_maxcount = [[m_Com_arrangeSP_Max combineList] count];
    float max_a[arraySP_maxcount];
    
    //存放临时 的m_Com_arrangeSP_Max
    CombineList* Com_arrangeSP_Max_Temp = [[CombineList alloc] init];
    for (int arrange_i = 0; arrange_i < arraySP_maxcount; arrange_i++)
    {
        CombineBase* base =(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:arrange_i];
        float value = [[[base combineBase_SP] objectAtIndex:0] floatValue];
        max_a[arrange_i] = value;
        
        CombineBase* baseBase = [[CombineBase alloc] init];
        baseBase.isDan = [base isDan];
        [[baseBase combineBase_SP] addObject:[NSString stringWithFormat:@"%f",value]];
        [Com_arrangeSP_Max_Temp appendList:baseBase];
        [baseBase release];
    }
    [[m_Com_arrangeSP_Max combineList] removeAllObjects];
    
    int sort_Max_IndexArray[arraySP_maxcount];//排序之后的 索引
    index = 0;
    while(index < arraySP_maxcount)
    {
        sort_Max_IndexArray[index]=index;
        index++;
    }
    
    //排序
    {
        int m_i,m_j;
        float m_temp;
        for(m_j = 0;m_j < arraySP_maxcount;m_j++)
        {
            for (m_i = m_j + 1; m_i < arraySP_maxcount; ++m_i)
            {
                if (max_a[m_j] < max_a[m_i])
                {
                    m_temp = max_a[m_j];
                    max_a[m_j] = max_a[m_i];
                    max_a[m_i] = m_temp;
                    
                    m_temp = sort_Max_IndexArray[m_j];
                    sort_Max_IndexArray[m_j] = sort_Max_IndexArray[m_i];
                    sort_Max_IndexArray[m_i] = m_temp;
                }
            }
            
        }
    }
    
    for (int arrange_i = 0; arrange_i < arraySPcount; arrange_i++)
    {
        CombineBase* base = (CombineBase*)[[Com_arrangeSP_Max_Temp combineList] objectAtIndex:(sort_Max_IndexArray[arrange_i])];
        CombineBase* baseBase = [[CombineBase alloc] init];
        baseBase.isDan = [base  isDan];
        [[baseBase combineBase_SP] addObject:(NSString*)[[base combineBase_SP] objectAtIndex:0]];
        [m_Com_arrangeSP_Max  appendList:base];
        [baseBase release];
    }
    [Com_arrangeSP_Max_Temp release];
    
}

//获得最小的奖金
-(float) getMinWinAmountByX:(NSInteger)X
{
    m_minWinAmount = 0.0;
    int Xindex = 0;
    /*
     先取出 含胆的 比赛
     */
    for (int j = 0;j < [[m_Com_arrangeSP_Min combineList] count]; j++)
    {
        if (j == 0) {
            m_minWinAmount = 1.0;
        }
        CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:j];
        if ([base isDan]) {
            m_minWinAmount *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
            Xindex++;
        }
    }
    /*
     补全 X 串 y
     */
    for (int i = 0;i < [[m_Com_arrangeSP_Min combineList] count]; i++)
    {
        if (Xindex >= X) {
            break;
        }
        CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:i];
        if (![base isDan]) {
            m_minWinAmount *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
            Xindex++;
        }
    }
    m_minWinAmount *= 2.0;
    return m_minWinAmount;
}



//***************************************************
//by huangxin add
//计算除了混合玩法之外的各种玩法的预计最大奖金
//含胆和不含胆，Y为1的情况都能够计算
//***************************************************
- (void) calculationAmountBy_X_Y:(NSInteger)x Y:(NSInteger)y
{
    m_maxWinAmount = 0.0;
    int MaxSP_Count = [[m_Com_arrangeSP_Max combineList] count];
    float SP_a[MaxSP_Count];
    
    int Dan_count = 0;
    for (int i = 0; i < MaxSP_Count; i++)
    {
        float value = [[[(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:i] combineBase_SP] objectAtIndex:0]floatValue];
        SP_a[i] = value;
        if ([(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:i] isDan])
        {
            Dan_count++;
        }
    }
    
    //如果不含胆
    if (Dan_count == 0) {
        
        CombineListArray *SP_listArrayTemp = [[CombineListArray alloc] init];
        float peilv = 0.0;
        
        if (y == 1) {
            
            int SP_c[x];
            combine_SP(SP_a, MaxSP_Count, x, SP_c, x,SP_listArrayTemp,m_Com_arrangeSP_Max);//在n场比赛中选取m场
            for (int i = 0; i < [[SP_listArrayTemp combineListArray] count]; i++) {
                
                CombineList* list = (CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:i];
                
                int listCount  = [[list combineList] count];
                
                for (int m = 0; m < listCount; m++) {
                    
                    CombineBase* base = (CombineBase*)[[(CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:i] combineList] objectAtIndex:m];
                    
                    if (m == 0) {
                        peilv = 1.0;
                    }
                    peilv *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
                }
                
                m_maxWinAmount += peilv;
            }
        }
        else
        {
            
            int SP_b[y];
            combine_SP(SP_a, MaxSP_Count, y, SP_b, y,SP_listArrayTemp,m_Com_arrangeSP_Max);//在n场比赛中选取m场
            
            int num = RYCChoose(x - y, MaxSP_Count - y);
            for (int j = 0;j < [[SP_listArrayTemp combineListArray] count]; j++)
            {
                CombineList* list = (CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:j];
                
                int listCount  = [[list combineList] count];
                
                for (int m = 0; m < listCount; m++) {
                    
                    CombineBase* base = (CombineBase*)[[(CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:j] combineList] objectAtIndex:m];
                    if (m == 0) {
                        peilv = 1.0;
                    }
                    peilv *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
                }
                
                m_maxWinAmount += peilv * (double)num;
            }
        }
        m_maxWinAmount *= 2.0;
        [SP_listArrayTemp release];
    }
    else //含胆
    {
        //第一步：把选择的比赛分成含胆和不含胆的两部分
        CombineList *dan_ListArray = [[CombineList alloc] init];//含胆的比赛
        CombineList *no_dan_ListArray = [[CombineList alloc] init];//不含胆的比赛
        
        for (int i = 0; i < MaxSP_Count; i++)
        {
            CombineBase *base = (CombineBase *)[[m_Com_arrangeSP_Max combineList] objectAtIndex:i];
            if ([base isDan]) {
                
                [dan_ListArray appendList:base];
            }
            else
            {
                [no_dan_ListArray appendList:base];
            }
        }
        //第二步：根据胆的个数分情况,计算不含胆部分的最大赔率
        if (x <= Dan_count) {
            
            NSLog(@"胆大!");
        }
        else
        {
            CombineListArray *SP_listArrayTemp = [[CombineListArray alloc] init];
            
            int no_dan_array_count = [[no_dan_ListArray combineList] count];
            float SP_no_a[no_dan_array_count];
            
            
            
            for (int i = 0; i < no_dan_array_count; i++)
            {
                float value = [[[(CombineBase*)[[no_dan_ListArray combineList] objectAtIndex:i] combineBase_SP] objectAtIndex:0] floatValue];
                SP_no_a[i] = value;
            }
            
            float dan_peilv = 0.0;
            for (int dan_i = 0; dan_i < [[dan_ListArray combineList] count]; dan_i++) {
                
                float value = [[[(CombineBase*)[[dan_ListArray combineList] objectAtIndex:dan_i] combineBase_SP] objectAtIndex:0] floatValue];
                if (dan_i == 0) {
                    dan_peilv = 1.0;
                }
                dan_peilv *= value;
            }
            int SP_c[x - Dan_count];
            combine_SP(SP_no_a, no_dan_array_count, x - Dan_count, SP_c, x - Dan_count,SP_listArrayTemp,no_dan_ListArray);//在n场比赛中选取m场
            
            for (int i = 0; i < [[SP_listArrayTemp combineListArray] count]; i++)
            {
                CombineList* list = (CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:i];
                
                CombineList *addDan_List = [[CombineList alloc] init];
                
                
                for (int list_i = 0; list_i < [[list combineList] count]; list_i++) {
                    
                    CombineBase* base = (CombineBase *)[[list combineList] objectAtIndex:list_i];
                    [addDan_List appendList:base];
                }
                //用得到的不含胆的比赛补全
                for (int k = 0; k < [[dan_ListArray combineList] count]; k++) {
                    
                    CombineBase* base = (CombineBase *)[[dan_ListArray combineList] objectAtIndex:k];
                    [addDan_List appendList:base];
                }
                //
                int listCount  = [[addDan_List combineList] count];
                float SP_bu_a[listCount];
                for (int h = 0; h < listCount; h++)
                {
                    float value = [[[(CombineBase*)[[addDan_List combineList] objectAtIndex:h] combineBase_SP] objectAtIndex:0]floatValue];
                    SP_bu_a[h] = value;
                }
                
                CombineListArray *SP_bu_listArrayTemp = [[CombineListArray alloc] init];
                float peilv = 0.0;
                
                if (y == 1)
                {
                    int numCount = [[list combineList] count];
                    for (int j = 0; j < numCount; j++) {
                        
                        CombineBase *listBase = (CombineBase*)[[list combineList] objectAtIndex:j];
                        
                        if (j == 0) {
                            peilv = 1.0;
                        }
                        peilv *= [[[listBase combineBase_SP] objectAtIndex:0] floatValue];
                    }
                    peilv = peilv * dan_peilv;
                    m_maxWinAmount += peilv;
                }
                else
                {
                    int SP_b[y];
                    combine_SP(SP_bu_a, listCount, y, SP_b, y,SP_bu_listArrayTemp,addDan_List);//在n场比赛中选取m场
                    
                    int num = RYCChoose(x - y, listCount - y);
                    for (int j = 0;j < [[SP_bu_listArrayTemp combineListArray] count]; j++)
                    {
                        CombineList* bu_list = (CombineList*)[[SP_bu_listArrayTemp combineListArray] objectAtIndex:j];
                        
                        for (int m = 0; m < [[bu_list combineList] count]; m++) {
                            
                            CombineBase* listBase = (CombineBase*)[[(CombineList*)[[SP_bu_listArrayTemp combineListArray] objectAtIndex:j] combineList] objectAtIndex:m];
                            if (m == 0) {
                                peilv = 1.0;
                            }
                            peilv *= [[[listBase combineBase_SP] objectAtIndex:0] floatValue];
                        }
                        
                        m_maxWinAmount += peilv * (double)num;
                    }
                }
                [SP_bu_listArrayTemp release];
                [addDan_List release];
            }
        }
        
        [dan_ListArray release];
        [no_dan_ListArray release];
        m_maxWinAmount *= 2.0;
    }
}



- (BOOL) BetJudement
{
    for (int i = 0; i < self.fieldBeishu.text.length; i++)
    {
        UniChar chr = [self.fieldBeishu.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    
    if([self.fieldBeishu.text intValue] <= 0 || [self.fieldBeishu.text intValue] > 100000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～100000" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    if(m_betNumber == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请选择至少一注投注" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}


#pragma mark 计算混合过关的预计奖金

//给一个数组排序  ,选择排序
- (void) sortForArray:(NSMutableArray *) array
{
    int count = [array count];
    if (count <= 1) {
        return;
    }
    
    for (int i = 0; i< count-1; i++) {
        int m =i;
        for (int j =i+1; j<[array count]; j++) {
            if ([[array objectAtIndex:j] floatValue] < [[array objectAtIndex:m] floatValue]) {
                m = j;
            }
        }
        if (m != i) {
            [self swapWithData:array index1:m index2:i];
        }
    }
}


//交换数组里的两个元素的位置

- (void) swapWithData:(NSMutableArray *)adata index1:(NSInteger) index1 index2:(NSInteger) index2{
    
    NSNumber *tmp = [adata objectAtIndex:index1];
    [adata replaceObjectAtIndex:index1 withObject:[adata objectAtIndex:index2]];
    [adata replaceObjectAtIndex:index2 withObject:tmp];
    
}

//从一个数组里面找到x个最小的数，相乘

- (float) calculationMinItemsArray_X:(NSMutableArray*)array X:(int)x
{
    float allCount = 0.0;
    int count = [array count];
    if (count < x) {
        
    }
    else
    {
        for (int i = 0; i < x; i++) {
            if (i == 0) {
                allCount = 1.0;
            }
            allCount *= [[array objectAtIndex:i] floatValue];
        }
    }
    return allCount;
}


//计算混合过关的预计奖金
- (void) calculationWinAmountForConfusion:(int) y
{
    m_minAmount_Confusion = 0.0;
    //    m_maxAmount_Confusion = 0.0;
    
    int count = [[m_duoChuanChooseArray combineList] count];
    NSMutableArray *minSp_Array = [[NSMutableArray alloc] initWithCapacity:1];
    
    //计算最小奖金
    for (int i = 0; i < count; i++)
    {
        CombineBase *base = (CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i];
        
        NSMutableArray *confusionSPArray = [base combineBase_SP_confusion];
        
        NSMutableArray *oneGame_SPArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        //选出每种玩法中赔率最小的保存下来
        for (int j = 0; j < [confusionSPArray count]; j++) {
            
            NSMutableArray *array = [confusionSPArray objectAtIndex:j];
            if ([array count] > 0) {
                if ([array count] > 1) {
                    [self sortForArray:array];
                    
                }
                [oneGame_SPArray addObject:[array objectAtIndex:0]];
            }
            
        }
        
        if ([oneGame_SPArray count] > 1) {
            
            [self sortForArray:oneGame_SPArray];
        }
        [minSp_Array addObject:[oneGame_SPArray objectAtIndex:0]];
        [oneGame_SPArray release];
    }
    
    if ([minSp_Array count] > 1) {
        [self sortForArray:minSp_Array];
    }
    
    m_minAmount_Confusion = [self calculationMinItemsArray_X:minSp_Array X:y];
    
    [minSp_Array release];
    m_minAmount_Confusion *= 2.0;
    
    //计算最大预计奖金
    [self confusionMaxAmountBy_X:m_gameCount By_Y:y];
    
    m_maxAmount_Confusion *= 2.0;
}



- (void) confusionMaxAmountBy_X:(int)X By_Y:(int)y
{
    
    m_maxAmount_Confusion = 0.0;//最大的奖金
    int duoChuanChooseArraycount = [[m_duoChuanChooseArray combineList] count];
    int a[duoChuanChooseArraycount];
    for (int i = 0; i < duoChuanChooseArraycount; i++)
    {
        a[i] = [(CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] gameCount];
    }
    
    /*
     第一步 ：
     从 gamecount 里 选出 三场 (X)
     */
    int b[X];
    CombineListArray *listArrayTemp = [[CombineListArray alloc] init];
    combine(a, duoChuanChooseArraycount, X, b, X,listArrayTemp,m_duoChuanChooseArray);//在n个数中选取m
    
    
    /*
     第二步 ：
     从 listBase里 选出 2场(Y) ，计算组合数
     */
    int ListArrayCount = [[listArrayTemp combineListArray] count];
    for (int j = 0; j < ListArrayCount; j++)
    {
        CombineList* List = (CombineList*)[[listArrayTemp combineListArray] objectAtIndex:j];
        int a_1[[[List combineList] count]];
        int b_1[y];
        for (int m = 0; m < [[List combineList] count]; m++) {
            a_1[m] = [[[List combineList] objectAtIndex:m] gameCount];
        }
        //此处 也是个CombineListArray  例如 3串3 此处 是从选出的三场比赛里 选出2场存储
        CombineListArray* listArray2Temp = [[CombineListArray alloc] init];
        combine(a_1, [[List combineList] count], y, b_1, y,listArray2Temp,List);//在n个数中选取m
        
        int listArray2Count = [[listArray2Temp combineListArray] count];
        for (int p = 0; p < listArray2Count; p++)
        {
            CombineList* List = (CombineList*)[[listArray2Temp combineListArray] objectAtIndex:p];
            
            [self calculationConfusionAmountOfCombineList:List];
            
        }
    }
    
}


- (void) calculationConfusionAmountOfCombineList:(CombineList*) listBase
{
    /*
     获得 最后的 最小组合数组 既X串1 得出可能性
     */
    int baseCount = [[listBase combineList] count];
    
    NSMutableArray* array_base_confusion = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    for (int k = 0; k < baseCount; k++)
    {
        CombineBase* base_base = (CombineBase*)[[listBase combineList] objectAtIndex:k];
        NSMutableArray* array = [NSMutableArray array];
        BOOL ishave = NO;
        for (int base_confusion_index = 0; base_confusion_index < [[base_base combineBase_SP_confusion] count];base_confusion_index++)
        {
            NSArray* confusion_array = [[base_base combineBase_SP_confusion] objectAtIndex:base_confusion_index];
            if ([confusion_array count] > 0) {
                float confusion_sp = 0;
                ishave = YES;
                for (int i = 0; i < [confusion_array count]; i++) {
                    float currValue = [[confusion_array objectAtIndex:i] floatValue];
                    if (i == 0) {
                        confusion_sp = currValue;
                    }
                    else
                    {
                        confusion_sp < currValue ? confusion_sp = currValue : confusion_sp;
                    }
                }
                [array addObject:[NSNumber numberWithFloat:confusion_sp]];
            }
        }
        if(ishave)
            [array_base_confusion addObject:array];
    }
    /*
     不明白为什么要这么做
     如果 不把array_base_confusion 存放到成员变量，执行完show（）后
     数据会丢失
     */
    m_tempConfusionArray = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    for (int i = 0; i < [array_base_confusion count]; i++) {
        NSMutableArray* array = [NSMutableArray arrayWithArray:[array_base_confusion objectAtIndex:i]];
        [m_tempConfusionArray addObject:array];
    }
    if ([array_base_confusion count] > 0)
    {
        const char* data[10];
        char result[10];
        m_tempBase_stringArray = [NSMutableArray array];
        for (int i = 0; i < [array_base_confusion count]; i++) {
            NSArray* array = [NSArray arrayWithArray:[array_base_confusion objectAtIndex:i]];
            NSString* index_array = @"";
            for (int j = 0; j < [array count]; j++) {
                index_array = [index_array stringByAppendingFormat:@"%d",j];
            }
            data[i] = [index_array UTF8String];
        }
        int count = [array_base_confusion count];
        show(result, data, 0, count);
        /*
         例如 取出来的是 A{a(赔率),b,c} B{e,f}
         下标值的 组合为 00，01，10，11，20，21
         */
        //根据下标值 计算奖金
        for (int m = 0; m < [m_tempBase_stringArray count]; m++) {
            float tempnum = 0.0;
            NSString* index_string = [m_tempBase_stringArray objectAtIndex:m];
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < [index_string length]; i++) {
                NSRange range;
                range.length = 1;
                range.location = i;
                [array addObject:[index_string substringWithRange:range]];
            }
            for (int k = 0; k < [array count]; k++)
            {
                if (k == 0) {
                    tempnum = 1;
                }
                int x = [[array objectAtIndex:k] intValue];
                float sp = [[[array_base_confusion objectAtIndex:k] objectAtIndex:x] floatValue];
                tempnum *= sp;
            }
            m_maxAmount_Confusion += tempnum;
        }
    }
    
    
}

/*
 从N个数组中各取1个元素的全部组合
 http://bbs.csdn.net/topics/320269074
 */
void show(char* result,const char** data, int curr,int count)
{
    if (curr == count)
    {
        result[curr] = '\0';
        NSLog(@"%s",result);
        [m_tempBase_stringArray addObject:[NSString stringWithUTF8String:result]];
    }
    else
    {
        int i;
        for (i = 0; data[curr][i]; ++i)
        {
            result[curr] = data[curr][i];
            show(result,data, curr+1,count);
        }
    }
}



//**********************************************
//获得一场比赛的混合玩法的赔率数组
//传进来一场比赛，有四种玩法，获得选择的各种玩法中的最大赔率，返回这四个最大赔率
//**********************************************
- (NSMutableArray *) getOneGameSPArray:(CombineBase *)base
{
    NSMutableArray *oneGameSp_Array = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    
    int count = [[base combineBase_SP_confusion] count];
    for (int i = 0; i < count; i++) {
        NSMutableArray *tempSP_Array = [[NSMutableArray alloc] initWithCapacity:1];
        tempSP_Array = [[base combineBase_SP_confusion] objectAtIndex:i];
        
        int countSP = [tempSP_Array count];
        
        if(countSP == 1)
        {
            [oneGameSp_Array addObject:[tempSP_Array objectAtIndex:0]];
        }
        else
        {
            [self sortForArray:tempSP_Array];
            [oneGameSp_Array addObject:[tempSP_Array lastObject]];
            
        }
        [tempSP_Array release];
    }
    return oneGameSp_Array;
}



#pragma mark - customerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    
    [self hideKeybord];
    [self.LaunchHMView hideKeybord];
    
    if(self.cusSegmented.segmentedIndex == 0)
    {
        self.srollView_normalBet.hidden = NO;
        self.srollView_HMBet.hidden = YES;
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(self.cusSegmented.segmentedIndex == 1)
    {
        
        self.srollView_normalBet.hidden = YES;
        self.srollView_HMBet.hidden = NO;
        [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
        [RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d" ,m_betNumber];
        self.LaunchHMView.zhuShuLabel.text = [NSString stringWithFormat:@"共%d注" ,m_betNumber];
        
        [self.LaunchHMView refreshTopView];
    }
    
    
}

@end

/////////////////////////////////////////////////


@implementation CombineListArray
@synthesize combineListArray = m_combineListArray;

- (id)init {
    self = [super init];
    if (self)
    {
        //初始化 数组
        m_combineListArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) appendListArray:(CombineList*) listArray
{
    [m_combineListArray addObject:listArray];
}
- (void)dealloc {
    [m_combineListArray removeAllObjects];
    [m_combineListArray release];
    [super dealloc];
}
@end


@implementation CombineList
@synthesize combineList = m_combineList;

- (id)init {
    self = [super init];
    if (self)
    {
        //初始化 数组
        m_combineList = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void) appendList:(CombineBase*) listbase
{
    [m_combineList addObject:listbase];
}
- (void)dealloc {
    [m_combineList removeAllObjects];
    [m_combineList release];
    [super dealloc];
}
@end

@implementation CombineBase
@synthesize combineBase_SP = m_combineBase_SP;
@synthesize combineBase_SP_confusion = m_combineBase_SP_confusion;
@synthesize isDan = m_isDan;
@synthesize gameCount = m_gameCount;

- (id)init{
    self = [super init];
    if (self)
    {
        //初始化 数组
        m_combineBase_SP = [[NSMutableArray alloc] init];
        
        self.combineBase_SP_confusion = [[NSMutableArray alloc] initWithCapacity:4];
        
        NSMutableArray* array1 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array2 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array3 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array4 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array5 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        
        [self.combineBase_SP_confusion addObject:array1];
        [self.combineBase_SP_confusion addObject:array2];
        [self.combineBase_SP_confusion addObject:array3];
        [self.combineBase_SP_confusion addObject:array4];
        [self.combineBase_SP_confusion addObject:array5];
        
    }
    return self;
}


- (void)dealloc {
    [m_combineBase_SP_confusion removeAllObjects];
    [m_combineBase_SP_confusion release];
    
    [m_combineBase_SP removeAllObjects];
    [m_combineBase_SP release];
    [super dealloc];
}
@end