//
//  ZC_pickNumberViewController.m
//  RuYiCai
//
//  Created by haojie on 11-12-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZC_pickNumberViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RYCImageNamed.h"
#import "ZCCellView.h"
#import "NSLog.h"
#import "RuYiCaiLotDetail.h"
#import "SBJsonParser.h"
#import "RYCZCBetView.h"
#import "RandomPickerViewController.h"
#import "AnimationTabView.h"

#import "ZCJinQiuCaiView.h"
#import "ZCSixCBView.h"
#import "QueryLotBetViewController.h"
#import "ZCOpenLotteryViewController.h"
#import "PlayIntroduceViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"


#define kSegmentedsfc  (0)
#define kSegmentedrxj  (1)
#define kSegmentedjqc (2)
#define kSegmentedlcb (3)

#define kLabelFontSize    (12)

#define kBatchCodeKey  @"batchCode"
#define kEndTimeKey    @"endTime"


@interface ZC_pickNumberViewController (internal)

- (void) refreshData;
- (void)batchCodeRejust;

- (void)refrenshMyview;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
- (void)clearAllPickBall;

- (void)updateBallState:(NSNotification*)notification;
- (void)hideView;
- (void)submitLotNotification:(NSNotification*)notification;

- (void)ZCTeamOK:(NSNotification*)notification;
//- (void)batchCodeInformation:(NSNotification*)notification;
- (void)queryZCIssueBatchCodeOK:(NSNotification*)notification;

- (void)netFailed:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;

- (void)setupNavigationBar;
- (void)setDetailView;
- (void)detailViewButtonClick:(id)sender;
- (void)playIntroButtonClick:(id)sender;
- (void)historyLotteryClick:(id)sender;
- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;
- (NSString*) getLotNo;
@end

@implementation ZC_pickNumberViewController

@synthesize scrollView = m_scrollView;

@synthesize buttonBuy = m_buttonBuy;
@synthesize buttonReselect = m_buttonReselect;
@synthesize batchCode = m_batchCode;
@synthesize batchEndTime = m_batchEndTime;
@synthesize batchCodeButton = m_batchCodeButton;
@synthesize str2Label = m_str2Label;
@synthesize ZCTag = m_ZCTag;
@synthesize bottomView = m_bottomView;
@synthesize customSegmentedControl = m_customSegmentedControl;

@synthesize batchCodeTimeDic = m_batchCodeTimeDic;
@synthesize typeIdDicArray = m_typeIdDicArray;
@synthesize isHidePush    = m_isHidePush;


- (void)dealloc
{
    for(int i = 0; i < 14; i++)
	{
		[m_subViewArray_SFC[i] release];
	}
    for(int i = 0; i < 4; i++)
	{
		[m_subViewArray_JQC[i] release];
	}
    for(int i = 0; i < 14; i++)
	{
		[m_subViewArray_RJC[i] release];
	}
    for(int i = 0; i < 6; i++)
	{
		[m_subViewArray_LCB[i] release];
	}
    [m_customSegmentedControl release];
    [m_bottomView release];
    [m_buttonBuy release];
    [m_buttonReselect release];
	[m_batchCode release];
    [m_batchEndTime release];
    [m_typeIdDicArray release];
	
	[m_scrollView release];
    [m_batchCodeButton release];
    [m_str2Label release];
    
    [m_tabview release];
    
    [m_batchCodeTimeDic release] , m_batchCodeTimeDic = nil;
    m_delegate = nil;
    
	[super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZCTeamOK" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateBallState" object:nil];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryZCIssueBatchCodeOK" object:nil];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];
    
    //    [m_detailButton removeFromSuperview];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
     自定义 返回按钮
     */
    //    [MobClick event:@"ZC_selectPage"];
    [AdaptationUtils adaptation:self];
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 42, 310, 40)];
    topImageView.image = [UIImage imageNamed:@"cellbg_c_top.png"];
    [self.view addSubview:topImageView];
    [topImageView release];
    
    [self setupNavigationBar];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //	[self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    m_batchCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(13, 50, 128, 24)];
    //    self.batchCodeButton.textAlignment = UITextAlignmentLeft;
    self.batchCodeButton.backgroundColor = [UIColor clearColor];
    self.batchCodeButton.titleLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.batchCodeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
    [self.batchCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.batchCodeButton setBackgroundImage:RYCImageNamed(@"qihaoqishu_c_nomal.png") forState:UIControlStateNormal];
    [self.batchCodeButton setBackgroundImage:RYCImageNamed(@"qihaoqishu_c_click.png") forState:UIControlStateHighlighted];
    [self.batchCodeButton addTarget:self action:@selector(batchCodeRejust) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.batchCodeButton];
    
    m_str2Label = [[UILabel alloc] initWithFrame:CGRectMake(135, 50, 170, 30)];
    self.str2Label.textAlignment = UITextAlignmentRight;
    self.str2Label.backgroundColor = [UIColor clearColor];
    self.str2Label.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:self.str2Label];
    
    [self.batchCodeButton setTitle:@"期号获取中..." forState:UIControlStateNormal];
    self.str2Label.text = [NSString stringWithFormat:@"%@", @"截止日期获取中..."];
    
    NSArray* arr = [[NSArray alloc] init];
    m_batchCodeTimeDic = [[NSMutableDictionary alloc] init];
    [m_batchCodeTimeDic setObject:arr forKey:kLotTitleSFC];
    [m_batchCodeTimeDic setObject:arr forKey:kLotTitleJQC];
    [m_batchCodeTimeDic setObject:arr forKey:kLotTitleRX9];
    [m_batchCodeTimeDic setObject:arr forKey:kLotTitle6CB];
    [arr release];
    
    m_ZCTag = IZCLotTag_SFC;
    //    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoSFC];//获取期号
    [[RuYiCaiNetworkManager sharedManager] queryZCIssueBatchCode:kLotNoSFC];
    
    //    UIImageView *image_linebg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    //    image_linebg.image = RYCImageNamed(@"croner_line.png");
    //    [self.view addSubview:image_linebg];
    //    [image_linebg release];
    //
    //    m_tabview = [[ZC_TabView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //    m_tabview.presentViewController = self;
    //    [m_tabview refreshView];
    //    [self.view addSubview:m_tabview];
    
    self.customSegmentedControl = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 5, 310, 32)
                                                                andNormalImages:[NSArray arrayWithObjects:
                                                                                 @"zc_c_sfc_nomal.png",
                                                                                 @"zc_c_rxj_nomal.png",
                                                                                 @"zc_c_jqs_nomal.png",
                                                                                 @"zc_c_lcb_nomal.png",nil]
                                                           andHighlightedImages:[NSArray arrayWithObjects:
                                                                                 @"zc_c_sfc_nomal.png",
                                                                                 @"zc_c_rxj_nomal.png",
                                                                                 @"zc_c_jqs_nomal.png",
                                                                                 @"zc_c_lcb_nomal.png",
                                                                                 nil]
                                                                 andSelectImage:[NSArray arrayWithObjects:
                                                                                 @"zc_c_sfc_click.png",
                                                                                 @"zc_c_rxj_click.png",
                                                                                 @"zc_c_jqs_click.png",
                                                                                 @"zc_c_lcb_click.png",nil]]autorelease];
    
    self.customSegmentedControl.delegate = self;
    [self.view addSubview:m_customSegmentedControl];
    
    
    
    [self updateBallState:nil];
    [self setDetailView];
    m_detailView.hidden = YES;
    
    
    //底部bar
    
    m_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40-64, 320, 40)];
    [self.view addSubview:m_bottomView];
    
    UIImageView  *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    bottomImageView.image = [UIImage imageNamed:@"jctz_botton_bg.png"];
    [m_bottomView insertSubview:bottomImageView atIndex:100];
    [bottomImageView release];
    
    self.buttonBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_buttonBuy setBackgroundImage:[UIImage imageNamed:@"jctx_touzhu_c_btn.png"] forState:UIControlStateNormal];
    [m_buttonBuy setBackgroundImage:[UIImage imageNamed:@"jctx_touzhu_c_btnclick.png"] forState:UIControlStateHighlighted];
    m_buttonBuy.frame = CGRectMake(110,4, 100, 32);
    [m_buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [m_bottomView insertSubview:m_buttonBuy atIndex:100];
}


#pragma mark - customer segmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self segmentedChangeValue:index];
}
- (void)segmentedChangeValue:(NSUInteger)type
{
    int zcTag = IZCLotTag_SFC;
    if (kSegmentedsfc == type)
    {
        zcTag = IZCLotTag_SFC;
    }
    else if (kSegmentedrxj == type)
    {
        zcTag = IZCLotTag_RJC;
    }
    else if(kSegmentedjqc == type)
    {
        zcTag = IZCLotTag_JQC;
    }
    else if(kSegmentedlcb == type)
    {
        zcTag = IZCLotTag_LCB;
    }
    self.ZCTag = zcTag;
    [self refreshBatchCode];
    //    [self updateBallState:nil];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZCTeamOK:) name:@"ZCTeamOK" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBallState:) name:@"updateBallState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryZCIssueBatchCodeOK:) name:@"queryZCIssueBatchCodeOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
    
    //    [self refreshBatchCode];
    
    //初始化导航栏
    //    [self setupNavigationBar];
    
    [self clearAllPickBall];
}

- (void)queryZCIssueBatchCodeOK:(NSNotification*)notification
{
    NSDictionary* tempDic = notification.userInfo;
    NSArray*  batchCodeArr = [tempDic objectForKey:@"batchCodeArray"];
    if(tempDic)
    {
        switch (m_ZCTag)
        {
            case IZCLotTag_SFC:
                [self.batchCodeTimeDic setObject:batchCodeArr forKey:kLotTitleSFC];
                break;
            case IZCLotTag_JQC:
                [self.batchCodeTimeDic setObject:batchCodeArr forKey:kLotTitleJQC];
                break;
            case IZCLotTag_RJC:
                [self.batchCodeTimeDic setObject:batchCodeArr forKey:kLotTitleRX9];
                break;
            case IZCLotTag_LCB:
                [self.batchCodeTimeDic setObject:batchCodeArr forKey:kLotTitle6CB];
                break;
            default:
                break;
        }
        
    }
    self.batchCode = [[batchCodeArr objectAtIndex:0] objectForKey:@"batchCode"];
    self.batchEndTime = [[batchCodeArr objectAtIndex:0] objectForKey:@"endTime"];
    [self.batchCodeButton setTitle:[NSString stringWithFormat:@"第%@期", self.batchCode] forState:UIControlStateNormal];
    self.str2Label.text = [NSString stringWithFormat:@"截止时间:%@", self.batchEndTime];
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
    
    [self refreshData];
}

- (void)netFailed:(NSNotification*)notification
{
    if([[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode].length == 0)
    {
        [self.batchCodeButton setTitle:@"期号获取失败" forState:UIControlStateNormal];
    }
    if([[RuYiCaiNetworkManager sharedManager] highFrequencyEndTime].length == 0)
    {
        self.str2Label.text = @"日期获取失败";
    }
}

- (void)refrenshMyview
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"result"];
    int nCurCount = [dict count];
    if (m_ZCTag == IZCLotTag_SFC)
    {
        for (int i = 0; i < nCurCount; i++)
        {
            NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
            m_subViewArray_SFC[i].index = [NSString stringWithFormat:@"%d",i + 1];
            m_subViewArray_SFC[i].hTeam = [subDict objectForKey:@"homeTeam"];
            m_subViewArray_SFC[i].vTeam = [subDict objectForKey:@"guestTeam"];
            m_subViewArray_SFC[i].avgOdds = [NSString stringWithFormat:@"胜%@|平%@|负%@",[subDict objectForKey:@"homeWinAverageOuPei"],[subDict objectForKey:@"standoffAverageOuPei"],[subDict objectForKey:@"guestWinAverageOuPei"]];
            //            m_subViewArray_SFC[i].avgOdds = [subDict objectForKey:@"avgOdds"];
            m_subViewArray_SFC[i].cDate = [subDict objectForKey:@"matchTime"];
            m_subViewArray_SFC[i].m_sort = [subDict objectForKey:@"leagueRank"];
            m_subViewArray_SFC[i].hidden = NO;
            m_subViewArray_SFC[i].frame = CGRectMake(0, i * 90, 320, 90);
            [m_subViewArray_SFC[i] refreshView];
        }
        m_scrollView.contentSize = CGSizeMake(310, 90 * nCurCount);
    }
    else if(m_ZCTag == IZCLotTag_JQC)
    {
        for (int i = 0; i < nCurCount; i++)
        {
            NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
            m_subViewArray_JQC[i].index = [NSString stringWithFormat:@"%d",i + 1];
            m_subViewArray_JQC[i].hTeam = [subDict objectForKey:@"homeTeam"];
            m_subViewArray_JQC[i].vTeam = [subDict objectForKey:@"guestTeam"];
            m_subViewArray_JQC[i].avgOdds = [NSString stringWithFormat:@"胜%@|平%@|负%@",[subDict objectForKey:@"homeWinAverageOuPei"],[subDict objectForKey:@"standoffAverageOuPei"],[subDict objectForKey:@"guestWinAverageOuPei"]];
            //            m_subViewArray_SFC[i].avgOdds = [subDict objectForKey:@"avgOdds"];
            m_subViewArray_JQC[i].cDate = [subDict objectForKey:@"matchTime"];
            m_subViewArray_JQC[i].hidden = NO;
            m_subViewArray_JQC[i].frame = CGRectMake(0, i * 90, 320, 90);
            [m_subViewArray_JQC[i] refreshView];
        }
        m_scrollView.contentSize = CGSizeMake(310, 90 * nCurCount);
    }
    else if(m_ZCTag == IZCLotTag_RJC)
    {
       	for (int i = 0; i < nCurCount; i++)
        {
            NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
            m_subViewArray_RJC[i].index = [NSString stringWithFormat:@"%d",i + 1];
            m_subViewArray_RJC[i].hTeam = [subDict objectForKey:@"homeTeam"];
            m_subViewArray_RJC[i].vTeam = [subDict objectForKey:@"guestTeam"];
            m_subViewArray_RJC[i].avgOdds = [NSString stringWithFormat:@"胜%@|平%@|负%@",[subDict objectForKey:@"homeWinAverageOuPei"],[subDict objectForKey:@"standoffAverageOuPei"],[subDict objectForKey:@"guestWinAverageOuPei"]];
            //            m_subViewArray_SFC[i].avgOdds = [subDict objectForKey:@"avgOdds"];
            m_subViewArray_RJC[i].cDate = [subDict objectForKey:@"matchTime"];
            m_subViewArray_RJC[i].m_sort = [subDict objectForKey:@"leagueRank"];
            m_subViewArray_RJC[i].hidden = NO;
            m_subViewArray_RJC[i].frame = CGRectMake(0, i * 90, 320, 90);
            [m_subViewArray_RJC[i] refreshView];
        }
        m_scrollView.contentSize = CGSizeMake(310, 90 * nCurCount);
    }
    else if(m_ZCTag == IZCLotTag_LCB)
    {
        for (int i = 0; i < nCurCount; i++)
        {
            NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
            m_subViewArray_LCB[i].index = [NSString stringWithFormat:@"%d",i + 1];
            m_subViewArray_LCB[i].hTeam = [subDict objectForKey:@"homeTeam"];
            m_subViewArray_LCB[i].vTeam = [subDict objectForKey:@"guestTeam"];
            m_subViewArray_LCB[i].avgOdds = [NSString stringWithFormat:@"胜%@|平%@|负%@",[subDict objectForKey:@"homeWinAverageOuPei"],[subDict objectForKey:@"standoffAverageOuPei"],[subDict objectForKey:@"guestWinAverageOuPei"]];
            //            m_subViewArray_SFC[i].avgOdds = [subDict objectForKey:@"avgOdds"];
            m_subViewArray_LCB[i].m_sort = [subDict objectForKey:@"leagueRank"];
            m_subViewArray_LCB[i].hidden = NO;
            m_subViewArray_LCB[i].frame = CGRectMake(0, i * 100, 320, 100);
            [m_subViewArray_LCB[i] refreshView];
        }
        m_scrollView.contentSize = CGSizeMake(310, 100 * nCurCount);
    }
    [self setDetailView];
    m_detailView.hidden = YES;
}

- (void)updateBallState:(NSNotification*)notification
{
    if (m_detailView.hidden == NO) {
        m_detailView.hidden = YES;
    }
    int  m_changShu = 0;
    int  m_maxChangShu = 0;
    if (m_ZCTag == IZCLotTag_SFC)
    {
        m_numZhu = 1;
        m_changShu = 0;
        m_maxChangShu = 14;
        for(int i = 0; i < 14; i++)
        {
            NSMutableArray *arrayWin = [m_subViewArray_SFC[i] selectedBallsArray];
            int zCout = [arrayWin count];
            if(0 == zCout)
            {
                m_numZhu = 0;
            }
            else
            {
                m_numZhu *= zCout;
                m_changShu ++;
            }
        }
    }
    else if(m_ZCTag == IZCLotTag_JQC)
    {
        m_numZhu = 1;
        m_changShu = 0;
        m_maxChangShu = 4;
        
        for(int i = 0; i < 4; i++)
        {
            NSArray *arrayFirstBall = [m_subViewArray_JQC[i] selectedFirstLineArray];
            int zCoutOne = [arrayFirstBall count];
            NSArray *arraySecondBall = [m_subViewArray_JQC[i] selectedSecondLineArray];
            int zCoutTwo = [arraySecondBall count];
            
            if(0 == zCoutOne || 0 == zCoutTwo)
            {
                m_numZhu = 0;
            }
            else
            {
                m_numZhu *= zCoutOne * zCoutTwo;
                m_changShu ++;
            }
        }
    }
    else if(m_ZCTag == IZCLotTag_RJC)
    {
        m_numZhu = 1;
        m_changShu = 0;
        m_maxChangShu = 9;
        for(int i = 0; i < 14; i++)
        {
            if([m_subViewArray_RJC[i] haveBallPress])
            {
                NSMutableArray *arrayNine = [m_subViewArray_RJC[i] selectedBallsArray];
                int zCout = [arrayNine count];
                m_numZhu *= zCout;
                
                m_changShu ++;
            }
        }
        //        m_numZhu = m_numZhu * RYCChoose(m_changShu, 9);
        if(9 == m_changShu)
        {
            for (int i = 0; i < 14; i++)
            {
                if(![m_subViewArray_RJC[i] haveBallPress])
                    m_subViewArray_RJC[i].m_isPress = NO;
            }
        }
        else
        {
            for(int j = 0; j < 14; j++)
            {
                m_subViewArray_RJC[j].m_isPress = YES;
            }
            m_numZhu = 0;
        }
    }
    else if(m_ZCTag == IZCLotTag_LCB)
    {
        m_numZhu = 1;
        m_changShu = 0;
        m_maxChangShu = 6;
        for(int i = 0; i < 6; i++)
        {
            NSArray *firstBall = [m_subViewArray_LCB[i] selectedFirstLineArray];
            int zCoutOne = [firstBall count];
            NSArray *secondBall = [m_subViewArray_LCB[i] selectedSecondLineArray];
            int zCoutTwo = [secondBall count];
            
            if(0 == zCoutOne || 0 == zCoutTwo)
            {
                m_numZhu = 0;
            }
            else
            {
                m_numZhu *= zCoutOne * zCoutTwo;
                m_changShu ++;
            }
        }
    }
    [m_listTeam removeFromSuperview];
	[m_listTeam release];
	m_listTeam = [[UIView alloc]initWithFrame:CGRectMake(100, 55, 130, 20)];
	m_listTeam.alpha = 0.8;
	[m_listTeam setBackgroundColor:[UIColor darkGrayColor]];
	[m_listTeam.layer setCornerRadius:6];
	m_listTeam.clipsToBounds = YES;
	[self.view addSubview:m_listTeam];
	UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 125, 15)];
	[mLabel setBackgroundColor:[UIColor clearColor]];
	[mLabel setTextColor:[UIColor whiteColor]];
	mLabel.textAlignment = UITextAlignmentCenter;
	mLabel.font = [UIFont systemFontOfSize:12];
	
	if(m_maxChangShu - m_changShu == 0)
	{
		mLabel.text = [NSString stringWithFormat:@"已选%d注,共%d元",m_numZhu,m_numZhu * 2];
	}
	else if(m_maxChangShu - m_changShu == m_maxChangShu)
	{
		mLabel.text = [NSString stringWithFormat:@"请选择 %d 场",m_maxChangShu];
	}
	else if(m_maxChangShu - m_changShu >= 0)
	{
		mLabel.text = [NSString stringWithFormat:@"至少还要选 %d 场",m_maxChangShu - m_changShu];
	}
    
	[m_listTeam addSubview:mLabel];
	[mLabel release];
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];
	[self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
}

- (void)hideView
{
	m_listTeam.hidden = YES;
}

- (void)pressedReselectButton:(id)sender
{
    for (int i = 0; i < 14; i++)
    {
        [m_subViewArray_SFC[i] clearBallState];
    }
    for(int i = 0; i < 4; i++)
	{
		[m_subViewArray_JQC[i] clearBallState];
	}
    for(int i = 0; i < 14; i++)
	{
		[m_subViewArray_RJC[i] clearBallState];
	}
    for(int i = 0; i < 6; i++)
	{
		[m_subViewArray_LCB[i] clearBallState];
	}
    [self updateBallState:nil];
}

- (void)clearAllPickBall
{
    [self pressedReselectButton:nil];
}

- (void)pressedBuyButton:(id)sender
{
    if (m_detailView.hidden == NO) {
        m_detailView.hidden = YES;
    }
	if (0 == m_numZhu)
	{
		[[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一注" withTitle:@"错误" buttonTitle:@"确定"];
		return;
	}
    
    [self submitLotNotification:nil];
}


- (void)submitLotNotification:(NSNotification*)notification
{
	NSString* disBetCode = @"";
    
	NSString* betCode = @"";
    
    
    if (m_ZCTag == IZCLotTag_SFC)
    {
        for (int i = 0; i < 14; i++)
        {
            NSMutableArray *winArray = [m_subViewArray_SFC[i] selectedBallsArray];
            int winCount = [winArray count];
            for(int j = 0; j < winCount; j++)
            {
                betCode = [betCode stringByAppendingFormat:@"%@",[winArray objectAtIndex:j]];
                disBetCode = [disBetCode stringByAppendingFormat:@"%@",[winArray objectAtIndex:j]];
            }
            if(13 != i)
            {
                betCode = [betCode stringByAppendingFormat:@","];
                disBetCode = [disBetCode stringByAppendingFormat:@","];
            }
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSFC;
    }
    else if(m_ZCTag == IZCLotTag_JQC)
    {
        for (int i = 0; i < 4; i++)
        {
            NSArray *ballArrayOne = [m_subViewArray_JQC[i] selectedFirstLineArray];
            int ballCountOne = [ballArrayOne count];
            NSArray *ballArrayTwo = [m_subViewArray_JQC[i] selectedSecondLineArray];
            int ballCountTwo = [ballArrayTwo count];
            
            for(int j = 0; j < ballCountOne; j++)
            {
                if((ballCountOne - 1)== j)
                {
                    betCode = [betCode stringByAppendingFormat:@"%@,",[ballArrayOne objectAtIndex:j]];
                    if([[ballArrayOne objectAtIndex:j] isEqualToString:@"3"])
                        disBetCode = [disBetCode stringByAppendingFormat:@"%@,",@"3+"];
                    else
                        disBetCode = [disBetCode stringByAppendingFormat:@"%@,",[ballArrayOne objectAtIndex:j]];
                }
                else
                {
                    betCode = [betCode stringByAppendingFormat:@"%@",[ballArrayOne objectAtIndex:j]];
                    if([[ballArrayOne objectAtIndex:j] isEqualToString:@"3"])
                        disBetCode = [disBetCode stringByAppendingFormat:@"%@",@"3+"];
                    else
                        disBetCode = [disBetCode stringByAppendingFormat:@"%@",[ballArrayOne objectAtIndex:j]];
                }
            }
            for(int k = 0; k < ballCountTwo; k++)
            {
                betCode = [betCode stringByAppendingFormat:@"%@",[ballArrayTwo objectAtIndex:k]];
                if([[ballArrayTwo objectAtIndex:k] isEqualToString:@"3"])
                    disBetCode = [disBetCode stringByAppendingFormat:@"%@",@"3+"];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%@",[ballArrayTwo objectAtIndex:k]];
            }
            if(3 != i)
            {
                betCode = [betCode stringByAppendingFormat:@","];
                disBetCode = [disBetCode stringByAppendingFormat:@","];
            }
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJQC;
        
    }
    else if(m_ZCTag == IZCLotTag_RJC)
    {
        for (int i = 0; i < 14; i++)
        {
            NSMutableArray *nineArray = [m_subViewArray_RJC[i] selectedBallsArray];
            int nineCount = [nineArray count];
            if(0 == nineCount)
            {
                betCode = [betCode stringByAppendingFormat:@"#"];
                disBetCode = [disBetCode stringByAppendingString:@"*"];
            }
            for(int j = 0; j < nineCount; j++)
            {
                betCode = [betCode stringByAppendingFormat:@"%@",[nineArray objectAtIndex:j]];
                disBetCode = [disBetCode stringByAppendingFormat:@"%@",[nineArray objectAtIndex:j]];
            }
            if(13 != i)
            {
                betCode = [betCode stringByAppendingFormat:@","];
                disBetCode = [disBetCode stringByAppendingFormat:@","];
            }
        }
    	
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoRX9;
    }
    else if(m_ZCTag == IZCLotTag_LCB)
    {
        for (int i = 0; i < 6; i++)
        {
            NSArray *sixArrayOne = [m_subViewArray_LCB[i] selectedFirstLineArray];
            int sixCountOne = [sixArrayOne count];
            NSArray *sixArrayTwo = [m_subViewArray_LCB[i] selectedSecondLineArray];
            int sixCountTwo = [sixArrayTwo count];
            
            for(int j = 0; j < sixCountOne; j++)
            {
                if((sixCountOne - 1)== j)
                {
                    betCode = [betCode stringByAppendingFormat:@"%@,",[sixArrayOne objectAtIndex:j]];
                    disBetCode = [disBetCode stringByAppendingFormat:@"%@,",[sixArrayOne objectAtIndex:j]];
                }
                else
                {
                    betCode = [betCode stringByAppendingFormat:@"%@",[sixArrayOne objectAtIndex:j]];
                    disBetCode = [disBetCode stringByAppendingFormat:@"%@",[sixArrayOne objectAtIndex:j]];
                }
            }
            for(int k = 0; k < sixCountTwo; k++)
            {
                betCode = [betCode stringByAppendingFormat:@"%@",[sixArrayTwo objectAtIndex:k]];
                disBetCode = [disBetCode stringByAppendingFormat:@"%@",[sixArrayTwo objectAtIndex:k]];
            }
            if(5 != i)
            {
                betCode = [betCode stringByAppendingFormat:@","];
                disBetCode = [disBetCode stringByAppendingFormat:@","];
            }
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoLCB;
    }
    
	NSLog(@"betCode****** %@",betCode);
	[RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
	[RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_numZhu * 200];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    [RuYiCaiLotDetail sharedObject].sellWay = @"0";
	[RuYiCaiLotDetail sharedObject].batchNum = @"1";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_numZhu];
	
    //[[RuYiCaiNetworkManager sharedManager] showLotSubmitMessage:@"" withTitle:@"您的订单详情"];
    [self betNormal:nil];
}

- (void)ZCTeamOK:(NSNotification*)notification
{
	NSLog(@"ZCTeamOK^^^notification");
	[self refrenshMyview];
}

#pragma mark 期号调整
- (void)batchCodeRejust
{

    NSArray* allArr;
    NSMutableArray* batchCodeArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSLog(@"%@batchCodeArrbatchCodeArr",batchCodeArr);

    if (batchCodeArr ) {
        m_delegate.randomPickerView.delegate = self;
        
        
        
       
        if(m_ZCTag == IZCLotTag_SFC)
        {
            allArr = [self.batchCodeTimeDic objectForKey:kLotTitleSFC];
        }
        else if(m_ZCTag == IZCLotTag_JQC)
        {
            allArr = [self.batchCodeTimeDic objectForKey:kLotTitleJQC];
        }
        else if(m_ZCTag == IZCLotTag_RJC)
        {
            allArr = [self.batchCodeTimeDic objectForKey:kLotTitleRX9];
        }
        else if(m_ZCTag == IZCLotTag_LCB)
        {
            allArr = [self.batchCodeTimeDic objectForKey:kLotTitle6CB];
        }
        for (int i = 0; i < [allArr count]; i++)
        {
            [batchCodeArr addObject:[[allArr objectAtIndex:i] objectForKey:@"batchCode"]];
        }
        
//        NSLog(@"%d",    [batchCodeArr count]);
        if ([batchCodeArr count] != 0) {
            [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
            [m_delegate.randomPickerView setPickerDataArray:[NSArray arrayWithArray:batchCodeArr]];
            [m_delegate.randomPickerView setPickerNum:0 withMinNum:0 andMaxNum:0];
            [batchCodeArr release], batchCodeArr = nil;
        }
        else
        {
            UIAlertView *nilBatchCodeAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"期号为空不能进行期号调整" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [nilBatchCodeAlertView show];
            [nilBatchCodeAlertView release];
            return;
        }
        
        
    }

    
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    if(m_ZCTag == IZCLotTag_SFC)
    {
        //        [self.batchCodeButton setTitle:[NSString stringWithFormat:@"第%@期", [m_delegate.randomPickerView.pickerNumArray objectAtIndex:num]] forState:UIControlStateNormal];
        self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitleSFC] objectAtIndex:num] objectForKey:@"batchCode"];
        self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitleSFC] objectAtIndex:num] objectForKey:@"endTime"];
    }
    else if(m_ZCTag == IZCLotTag_JQC)
    {
        self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitleJQC] objectAtIndex:num] objectForKey:@"batchCode"];
        self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitleJQC] objectAtIndex:num] objectForKey:@"endTime"];
    }
    else if(m_ZCTag == IZCLotTag_RJC)
    {
        self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitleRX9] objectAtIndex:num] objectForKey:@"batchCode"];
        self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitleRX9] objectAtIndex:num] objectForKey:@"endTime"];
    }
    else if(m_ZCTag == IZCLotTag_LCB)
    {
        self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitle6CB] objectAtIndex:num] objectForKey:@"batchCode"];
        self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitle6CB] objectAtIndex:num] objectForKey:@"endTime"];
    }
    [self.batchCodeButton setTitle:[NSString stringWithFormat:@"第%@期", self.batchCode] forState:UIControlStateNormal];
    self.str2Label.text = [NSString stringWithFormat:@"截止时间:%@", self.batchEndTime];
    [self refreshData];
}
#pragma mark bet
- (void)betNormal:(NSNotification*)notification
{
    NSString *kLotNoTitle = @"";
    if (m_ZCTag == IZCLotTag_SFC)
    {
        kLotNoTitle = @"胜负彩投注";
    }
    else if(m_ZCTag == IZCLotTag_JQC)
    {
        kLotNoTitle = @"进球彩投注";
    }
    else if(m_ZCTag == IZCLotTag_RJC)
    {
        kLotNoTitle = @"任九场投注";
    }
    else if(m_ZCTag == IZCLotTag_LCB)
    {
        kLotNoTitle = @"六场半投注";
    }
    
    [self setHidesBottomBarWhenPushed:YES];
    //足彩投注viewController-胜负彩投注-进球彩投注-任九场投注-六场半投注
	RYCZCBetView* viewController = [[RYCZCBetView alloc] init];
	viewController.navigationItem.title = kLotNoTitle;
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void) refreshData
{
    NSTrace();
    if (m_scrollView != nil) {
        [m_scrollView removeFromSuperview];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 82, 310, [UIScreen mainScreen].bounds.size.height - 217+30)];
    imageView.backgroundColor =  [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"cellbg_c_bottom.png"];
    [self.view addSubview:imageView];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 82, 310, [UIScreen mainScreen].bounds.size.height - 217+30)];
    m_scrollView.delegate = self;
    m_scrollView.scrollEnabled = YES;
    
    
    m_scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_scrollView];
    
    [imageView release];
    
    if (m_ZCTag == IZCLotTag_SFC)
    {
        m_tabview.selectButtonTag = 0;
        
        for(int i = 0; i < 14; i++)
        {
            m_subViewArray_SFC[i] = [[ZCCellView alloc] initWithFrame:CGRectZero];
            [m_scrollView addSubview:m_subViewArray_SFC[i]];
            m_subViewArray_SFC[i].hidden = YES;
        }
        
        [[RuYiCaiNetworkManager sharedManager] zcInquiry:self.batchCode withLotNo:kLotNoSFC];
    }
    else if (m_ZCTag == IZCLotTag_JQC)
    {
        m_tabview.selectButtonTag = 1;
        
        for(int i = 0; i < 4; i++)
        {
            m_subViewArray_JQC[i] = [[ZCJinQiuCaiView alloc] initWithFrame:CGRectZero];
            [m_scrollView addSubview:m_subViewArray_JQC[i]];
            m_subViewArray_JQC[i].hidden = YES;
        }
        [[RuYiCaiNetworkManager sharedManager] zcInquiry:self.batchCode withLotNo:kLotNoJQC];
    }
    else if (m_ZCTag == IZCLotTag_RJC)
    {
        m_tabview.selectButtonTag = 2;
        
        for(int i = 0; i < 14; i++)
        {
            m_subViewArray_RJC[i] = [[ZCCellView alloc] initWithFrame:CGRectZero];
            [m_scrollView addSubview:m_subViewArray_RJC[i]];
            m_subViewArray_RJC[i].hidden = YES;
        }
        [[RuYiCaiNetworkManager sharedManager] zcInquiry:self.batchCode withLotNo:kLotNoRX9];
    }
    else if (m_ZCTag == IZCLotTag_LCB)
    {
        m_tabview.selectButtonTag = 3;
        
        for(int i = 0; i < 6; i++)
        {
            m_subViewArray_LCB[i] = [[ZCSixCBView alloc] initWithFrame:CGRectZero];
            [m_scrollView addSubview:m_subViewArray_LCB[i]];
            m_subViewArray_LCB[i].hidden = YES;
        }
        [[RuYiCaiNetworkManager sharedManager] zcInquiry:self.batchCode withLotNo:kLotNoLCB];
    }
    
    [self setDetailView];
    m_detailView.hidden = YES;
}

- (void) refreshBatchCode
{
    NSString *kLotNoTag = @"";
    kLotNoTag = [self getLotNo];
    if(kLotNoTag == kLotNoSFC)
    {
        if ([[self.batchCodeTimeDic objectForKey:kLotTitleSFC] count] == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] queryZCIssueBatchCode:kLotNoSFC];
        }
        else
        {
            self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitleSFC] objectAtIndex:0] objectForKey:@"batchCode"];
            self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitleSFC] objectAtIndex:0] objectForKey:@"endTime"];
            [self.batchCodeButton setTitle:[NSString stringWithFormat:@"第%@期", self.batchCode] forState:UIControlStateNormal];
            self.str2Label.text = [NSString stringWithFormat:@"截止时间:%@", self.batchEndTime];
            [self refreshData];
        }
    }
    else if(kLotNoTag == kLotNoJQC)
    {
        if ([[self.batchCodeTimeDic objectForKey:kLotTitleJQC] count] == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] queryZCIssueBatchCode:kLotNoJQC];
        }
        else
        {
            self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitleJQC] objectAtIndex:0] objectForKey:@"batchCode"];
            self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitleJQC] objectAtIndex:0] objectForKey:@"endTime"];
            [self.batchCodeButton setTitle:[NSString stringWithFormat:@"第%@期", self.batchCode] forState:UIControlStateNormal];
            self.str2Label.text = [NSString stringWithFormat:@"截止时间:%@", self.batchEndTime];
            [self refreshData];
        }
    }
    else if(kLotNoTag == kLotNoRX9)
    {
        if ([[self.batchCodeTimeDic objectForKey:kLotTitleRX9] count] == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] queryZCIssueBatchCode:kLotNoRX9];
        }
        else
        {
            self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitleRX9] objectAtIndex:0] objectForKey:@"batchCode"];
            self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitleRX9] objectAtIndex:0] objectForKey:@"endTime"];
            [self.batchCodeButton setTitle:[NSString stringWithFormat:@"第%@期", self.batchCode] forState:UIControlStateNormal];
            self.str2Label.text = [NSString stringWithFormat:@"截止时间:%@", self.batchEndTime];
            [self refreshData];
        }
    }
    else if(kLotNoTag == kLotNoLCB)
    {
        if ([[self.batchCodeTimeDic objectForKey:kLotTitle6CB] count] == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] queryZCIssueBatchCode:kLotNoLCB];
        }
        else
        {
            self.batchCode = [[[self.batchCodeTimeDic objectForKey:kLotTitle6CB] objectAtIndex:0] objectForKey:@"batchCode"];
            self.batchEndTime = [[[self.batchCodeTimeDic objectForKey:kLotTitle6CB] objectAtIndex:0] objectForKey:@"endTime"];
            [self.batchCodeButton setTitle:[NSString stringWithFormat:@"第%@期", self.batchCode] forState:UIControlStateNormal];
            self.str2Label.text = [NSString stringWithFormat:@"截止时间:%@", self.batchEndTime];
            [self refreshData];
        }
    }
    //    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoTag];//获取期号
}

- (void)setupNavigationBar
{
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

#pragma mark   右上角 下拉按钮
- (void)setDetailView
{
    if (m_detailView != NULL) {
        [m_detailView removeFromSuperview];
        [m_detailView release];
    }
    
    
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
    NSString* lotNo = [self getLotNo];
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = lotNo;
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
    NSString* lotNo = [self getLotNo];
    [viewController setSelectLotNo:lotNo];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
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
    NSString* lotno = [self getLotNo];
    viewController.lotNo = lotno;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)historyLotteryClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    //    NSString* lotno = [self getLotNo];
    //    NSString* title = @"";
    //
    //    NSString *kLotNoTitle = @"";
    //    if (m_ZCTag == IZCLotTag_SFC)
    //    {
    //        kLotNoTitle = kLotTitleSFC;
    //    }
    //    else if(m_ZCTag == IZCLotTag_JQC)
    //    {
    //        kLotNoTitle = kLotTitleJQC;
    //    }
    //    else if(m_ZCTag == IZCLotTag_RJC)
    //    {
    //        kLotNoTitle = kLotTitleRX9;
    //    }
    //    else if(m_ZCTag == IZCLotTag_LCB)
    //    {
    //        kLotNoTitle = kLotTitle6CB;
    //    }
    //    HistoryLotteryViewController* viewController = [[HistoryLotteryViewController alloc] init];
    ZCOpenLotteryViewController* viewController = [[ZCOpenLotteryViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.animationTabView.selectButtonTag = m_ZCTag - 1;
    [viewController.animationTabView changeImage];
    [viewController tabButtonChanged:nil];
    [viewController release];
}

- (NSString*) getLotNo
{
    NSString *kLotNoTag = @"";
    if (m_ZCTag == IZCLotTag_SFC)
    {
        kLotNoTag = kLotNoSFC;
    }
    else if(m_ZCTag == IZCLotTag_JQC)
    {
        kLotNoTag = kLotNoJQC;
    }
    else if(m_ZCTag == IZCLotTag_RJC)
    {
        kLotNoTag = kLotNoRX9;
    }
    else if(m_ZCTag == IZCLotTag_LCB)
    {
        kLotNoTag = kLotNoLCB;
    }
    return kLotNoTag;
    
}

- (void)back:(id)sender
{
    if (m_isHidePush) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
        [self.navigationController popViewControllerAnimated:YES];
}

@end
