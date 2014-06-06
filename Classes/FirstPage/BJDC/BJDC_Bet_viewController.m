//
//  BJDC_Bet_viewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-25.
//
//

#import "BJDC_Bet_viewController.h"
#import "DirectPaymentViewController.h"
#import "RuYiCaiCommon.h"
#import "ChangeViewController.h"
#import "BJDC_LaunchHMViewController.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ExchangeLotteryWithIntegrationViewController.h"

#define kLaunchHMMaxScrollContentHeight 900
#define kSegIndexNormal (0)
#define kSegIndexHM     (1)
#define kMoveDownHeight 120
#define kFangAnXiangQingViewTag 111

@interface BJDC_Bet_viewController ()

@end

@implementation BJDC_Bet_viewController

@synthesize DanCount = m_DanCount;
@synthesize playTypeTag;
@synthesize customSegmentView = m_customSegmentView;
@synthesize LaunchHMView = m_LaunchHMView;
@synthesize srollView_normalBet, srollView_HMBet;
@synthesize buyButton, view_down, image_sanjiao;
@synthesize lotTitleLabel,allCountLabel,gameCountLabel,betNumberLable,betCodeList,fieldBeishu;//winAmount;
@synthesize gameCount;
@synthesize batchCodeLabel;
@synthesize duoChuanChooseArray = m_duoChuanChooseArray;
@synthesize jianBeishuButton;
@synthesize jiaBeishuButton;
@synthesize m_Com_SParray;
@synthesize amountLabel;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"launchViewContentSizeCahnge" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fqHeMaiLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getShareDetileLotOK" object:nil];
    [_getShareDetileDic release];
    [m_chooseBetCode release];
    [jiaBeishuButton release];
    [jianBeishuButton release];
    [m_Com_SParray release];
    
    
    [m_customSegmentView release], m_customSegmentView = nil;
    
    [m_LaunchHMView release];
    [srollView_normalBet release];
    [srollView_HMBet release];
    
    [buyButton release];
    [view_down release];
    [image_sanjiao release];
    
    [lotTitleLabel release];
    [allCountLabel release];
    [gameCountLabel release];
    [betNumberLable release];
    [betCodeList release];
    [fieldBeishu release];
    //    [winAmount release];
    [batchCodeLabel release];
    [amountLabel release];
    
    [freePassRadioIndexArray release];
    [m_duoChuanPassRadioArray release], m_duoChuanPassRadioArray = nil;
    [m_FreePassButton release];
    [m_DuoChuanPassButton release];
    [m_freePassScollView release];
    if (m_DuoChuanPassScollView != nil) {
        [m_DuoChuanPassScollView release], m_DuoChuanPassScollView = nil;
    }
    
    if (m_duoChuanChooseArray != nil) {
        [m_duoChuanChooseArray release], m_duoChuanChooseArray = nil;
    }
    [super dealloc];
}

#pragma mark---微信分享
- (id)init{
    if(self = [super init]){
//        _scene = WXSceneSession;
    }
    return self;
}

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    if ([strMsg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [BackBarButtonItemUtils addBackButtonForController:self];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betOutTime:) name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchViewContentSizeCahnge:) name:@"launchViewContentSizeCahnge" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fqHeMaiLotOK:) name:@"fqHeMaiLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShareDetileLotOK:) name:@"getShareDetileLotOK" object:nil];
    
    //选择开关按钮
    self.customSegmentView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(25, 5, 264, 30)
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
    
    self.customSegmentView.delegate = self;
    //    [self segmentedChangeValue:0];
    [self.view addSubview:m_customSegmentView];
    
    m_chooseBetCode = [[RuYiCaiLotDetail sharedObject].betCode retain];
    
    duoChuanPassRadioIndex = -1;//默认未选中任何多关
    
    m_allCount = 0;
    m_DanCount = 0;
    
    m_isFreePassButton = YES;//默认自由过关
    
    //胆
    for (int i = 0; i < [[m_duoChuanChooseArray combineList] count]; i++) {
        if ([(CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] isDan]) {
            m_DanCount++;
        }
    }
    
    
    self.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    self.batchCodeLabel.text = [NSString stringWithFormat:@"第%@期", [RuYiCaiLotDetail sharedObject].batchCode];
    self.gameCountLabel.text = [NSString stringWithFormat:@"共%d场",self.gameCount];
    
    //    m_betNumber = [self getDuoChuanChooseCountBy_X_Y:self.gameCount Y_1:0];//单关
    m_betNumber = [self getFreeChuanBetNum:m_DanCount + 1];
    self.betNumberLable.text = [NSString stringWithFormat:@"共%d注", m_betNumber];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", m_betNumber * 2*aas];
    
    min_amount = [self calculationMinAmount:1];
    max_amount = 0.0;
    amountLabel.text = [NSString stringWithFormat:@"%.2lf ~ %.2lf元",min_amount,max_amount];
    
    [RuYiCaiLotDetail sharedObject].lotMulti = @"1";//倍数
    
    NSString* betCodeListStr = [RuYiCaiLotDetail sharedObject].disBetCode;
    betCodeListStr = [betCodeListStr stringByReplacingOccurrencesOfString:@"," withString:@" "];//去掉 button中的，
    [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", betCodeListStr] forState:UIControlStateNormal];
    
    m_LaunchHMView = [[BJDC_LaunchHMViewController alloc] init];
    m_LaunchHMView.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1000);
    m_LaunchHMView.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    self.srollView_HMBet.frame = CGRectMake(0, 43, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 162);
    [self.srollView_HMBet addSubview:m_LaunchHMView.view];
    self.srollView_HMBet.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, kLaunchHMMaxScrollContentHeight - 120);
    
    self.srollView_normalBet.hidden = NO;
    self.srollView_normalBet.frame = CGRectMake(0,43, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 60 - 42);
    
    self.srollView_HMBet.hidden = YES;
    
    self.fieldBeishu.delegate = self;
    self.fieldBeishu.text = @"1";
    
    freePassRadioIndexArray = [[NSMutableArray alloc] initWithCapacity:1];
    if (m_DanCount > 7) {
        [freePassRadioIndexArray addObject:[NSNumber numberWithInt:100 + m_DanCount + 1]];
    }
    else if(m_DanCount == 0)
        [freePassRadioIndexArray addObject:[NSNumber numberWithInt:500]];
    else
        [freePassRadioIndexArray addObject:[NSNumber numberWithInt:500 + m_DanCount + 1]];//默认单关
    m_duoChuanPassRadioArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    //多串过关
    NSDictionary *dictionary01 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"2串3", @"509", nil];
    NSDictionary *dictionary02 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"3串4", @"527", nil];
    NSDictionary *dictionary03 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"3串7", @"511", nil];
    NSDictionary *dictionary04 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"4串5", @"540", nil];
    NSDictionary *dictionary05 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"4串11", @"529", nil];
    NSDictionary *dictionary06 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"4串15", @"514", nil];
    NSDictionary *dictionary07 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"5串6", @"545", nil];
    NSDictionary *dictionary08 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"5串16", @"541", nil];
    NSDictionary *dictionary09 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"5串26", @"532", nil];
    NSDictionary *dictionary10 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"5串31", @"518", nil];
    NSDictionary *dictionary11 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"6串7", @"550", nil];
    NSDictionary *dictionary12 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"6串22", @"546", nil];
    NSDictionary *dictionary13 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"6串42", @"543", nil];
    NSDictionary *dictionary14 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"6串57", @"536", nil];
    NSDictionary *dictionary15 = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"6串63", @"523", nil];
    [m_duoChuanPassRadioArray addObject:dictionary01];
    [m_duoChuanPassRadioArray addObject:dictionary02];
    [m_duoChuanPassRadioArray addObject:dictionary03];
    [m_duoChuanPassRadioArray addObject:dictionary04];
    [m_duoChuanPassRadioArray addObject:dictionary05];
    [m_duoChuanPassRadioArray addObject:dictionary06];
    
    [m_duoChuanPassRadioArray addObject:dictionary07];
    [m_duoChuanPassRadioArray addObject:dictionary08];
    [m_duoChuanPassRadioArray addObject:dictionary09];
    [m_duoChuanPassRadioArray addObject:dictionary10];
    [m_duoChuanPassRadioArray addObject:dictionary11];
    [m_duoChuanPassRadioArray addObject:dictionary12];
    [m_duoChuanPassRadioArray addObject:dictionary13];
    [m_duoChuanPassRadioArray addObject:dictionary14];
    [m_duoChuanPassRadioArray addObject:dictionary15];
    
    [self setupFreeScollView_view];
    
    m_FreePassButton = [[UIButton alloc] initWithFrame:CGRectMake(9, 180, 151, 40)];
    [m_FreePassButton setTitle:@"自由过关" forState:UIControlStateNormal];
    [m_FreePassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_FreePassButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m_FreePassButton setBackgroundImage:RYCImageNamed(@"jifen_btna2.png") forState:UIControlStateNormal];
    [m_FreePassButton setBackgroundImage:RYCImageNamed(@"jifen_btna1.png") forState:UIControlStateSelected];
    [m_FreePassButton addTarget:self action:@selector(guoGuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view_down addSubview:m_FreePassButton];
    m_FreePassButton.selected = YES;
    
    m_DuoChuanPassButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 180, 151, 40)];
    [m_DuoChuanPassButton setTitle:@"多串过关" forState:UIControlStateNormal];
    [m_DuoChuanPassButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_DuoChuanPassButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m_DuoChuanPassButton setBackgroundImage:RYCImageNamed(@"jifen_btnb2.png") forState:UIControlStateNormal];
    [m_DuoChuanPassButton setBackgroundImage:RYCImageNamed(@"jifen_btnb1.png") forState:UIControlStateSelected];
    [m_DuoChuanPassButton addTarget:self action:@selector(guoGuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view_down addSubview:m_DuoChuanPassButton];
    
    if(self.gameCount > 8 ||m_DanCount > 0)
    {
        m_DuoChuanPassButton.hidden = YES;
        m_FreePassButton.hidden = YES;
        
        UILabel* guoguanFangshLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 178, 300, 30)];
        guoguanFangshLabel.text = @"过关方式";
        guoguanFangshLabel.backgroundColor = [UIColor clearColor];
        guoguanFangshLabel.textAlignment = UITextAlignmentLeft;
        guoguanFangshLabel.textColor = [UIColor blackColor];
        guoguanFangshLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.view_down addSubview:guoguanFangshLabel];
        [guoguanFangshLabel release];
        
        UIImageView* m_image_top = [[UIImageView alloc] initWithFrame:CGRectMake(9, 208, 302, 12)];
        m_image_top.image = RYCImageNamed(@"croner_top.png");
        [self.view_down addSubview:m_image_top];
        [m_image_top release];
    }
    else
    {
        [self setupPassScollView_view];
        m_DuoChuanPassScollView.hidden = YES;
    }
    UIImageView* m_image_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(9, 306, 302, 10)];
    m_image_bottom.image = RYCImageNamed(@"croner_bottom.png");
    [self.view_down addSubview:m_image_bottom];
    [m_image_bottom release];
    
    srollView_normalBet.contentSize = CGSizeMake(320, 450);
    
    [self refreshData];
    
    
    [self beishuButtonAddGesture];
}

#pragma mark 创建过关方式
- (void)refrshPlayTypeButton//清空所有自由过关和多串过关的勾选
{
    m_betNumber = 0;
    
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
- (void)setupFreeScollView_view
{
    if (m_freePassScollView != nil) {
        [m_freePassScollView removeFromSuperview];
    }
    m_freePassScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(9, 216 + (m_expandBetCode ? kMoveDownHeight : 0), 302, 90)];
    UIImageView* image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 302, 90 + 50)] autorelease];
    image.image = [UIImage imageNamed:@"croner_middle.png"];
    [m_freePassScollView addSubview:image];
    
    m_freePassScollView.scrollEnabled = YES;
    //    m_freePassScollView.delegate = self;
    m_freePassScollView.backgroundColor = [UIColor whiteColor];
    m_freePassScollView.contentSize = CGSizeMake(302, 90);
    [self.view_down addSubview:m_freePassScollView];
    m_freePassScollView.hidden = NO;
    
    [self setFreePassScollView];
}

- (void)setupPassScollView_view
{
    if (m_DuoChuanPassScollView != nil) {
        [m_DuoChuanPassScollView removeFromSuperview];
    }
    m_DuoChuanPassScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(9, 216 + (m_expandBetCode ? kMoveDownHeight : 0), 302, 90)];
    
    UIImageView* image = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 302, 90 + 50)] autorelease];
    image.image = [UIImage imageNamed:@"croner_middle.png"];
    [m_DuoChuanPassScollView addSubview:image];
    m_DuoChuanPassScollView.scrollEnabled = YES;
    //    m_DuoChuanPassScollView.delegate = self;
    m_DuoChuanPassScollView.backgroundColor = [UIColor whiteColor];
    m_DuoChuanPassScollView.contentSize = CGSizeMake(302, 90);
    [self.view_down addSubview:m_DuoChuanPassScollView];
    m_DuoChuanPassScollView.hidden = NO;
    //重新创建
    [self setDuoChuanPassScollView];
}

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
- (void)setFreePassScollView
{
    [m_FreePassButton setBackgroundImage:RYCImageNamed(@"jifen_btna1.png") forState:UIControlStateNormal];
    [m_FreePassButton setBackgroundImage:RYCImageNamed(@"jifen_btna2.png") forState:UIControlStateHighlighted];
    
    [m_DuoChuanPassButton setBackgroundImage:RYCImageNamed(@"jifen_btnb2.png") forState:UIControlStateNormal];
    [m_DuoChuanPassButton setBackgroundImage:RYCImageNamed(@"jifen_btnb1.png") forState:UIControlStateHighlighted];
    
    if (self.gameCount >= 1) {
        BOOL isSelect = [self isHaveSelected:500];
        [self CreatFreePassRadio:CGRectMake(10, 10, 70, 20) Title:@"单关" isSelect:isSelect Tag:500 ISCLICK:((m_DanCount >= 1) ? FALSE : TRUE)];
        
    }
    if (self.gameCount >= 2) {
        BOOL isSelect = [self isHaveSelected:502];
        [self CreatFreePassRadio:CGRectMake(10 + 75, 10, 70, 20) Title:@"2串1" isSelect:isSelect Tag:502 ISCLICK:((m_DanCount >= 2) ? FALSE : TRUE)];
    }
    if(self.gameCount >= 3)
    {
        BOOL isSelect = [self isHaveSelected:503];
        [self CreatFreePassRadio:CGRectMake(10 + 75 * 2, 10, 70, 20) Title:@"3串1" isSelect:isSelect Tag:503 ISCLICK:TRUE];//((m_DanCount >= 3 || (m_DanCount > 0 && self.gameCount == 3)) ? FALSE : TRUE)];
        if (self.playTypeTag == IBJDCPlayType_Score) {
            return;
        }
    }
    if(self.gameCount >= 4)
    {
        BOOL isSelect = [self isHaveSelected:504];
        [self CreatFreePassRadio:CGRectMake(10 + 75 * 3, 10, 70, 20) Title:@"4串1" isSelect:isSelect Tag:504 ISCLICK:((m_DanCount >= 4 || (m_DanCount > 0 && self.gameCount == 4)) ? FALSE : TRUE)];
    }
    if(self.gameCount >= 5)
    {
        BOOL isSelect = [self isHaveSelected:505];
        [self CreatFreePassRadio:CGRectMake(10  , 10 + 30, 70, 20) Title:@"5串1" isSelect:isSelect Tag:505 ISCLICK:((m_DanCount >= 5 || (m_DanCount > 0 && self.gameCount == 5)) ? FALSE : TRUE)];
    }
    if(self.gameCount >= 6)
    {
        BOOL isSelect = [self isHaveSelected:506];
        [self CreatFreePassRadio:CGRectMake(10 + 75 , 10 + 30, 70, 20) Title:@"6串1" isSelect:isSelect Tag:506 ISCLICK:((m_DanCount >= 6 || (m_DanCount > 0 && self.gameCount == 6)) ? FALSE : TRUE)];
    }
    //北京单场 让球胜平负最高15串1  比分3串1 其他6串1
    if (self.playTypeTag == IBJDCPlayType_RQ_SPF )
    {
        if(self.gameCount >= 7)
        {
            BOOL isSelect = [self isHaveSelected:507];
            [self CreatFreePassRadio:CGRectMake(10 + 75 * 2, 10 + 30, 70, 20) Title:@"7串1" isSelect:isSelect Tag:507 ISCLICK:((m_DanCount >= 7 || (m_DanCount > 0 && self.gameCount == 7)) ? FALSE : TRUE)];
        }
        if(self.gameCount >= 8)
        {
            BOOL isSelect = [self isHaveSelected:508];
            [self CreatFreePassRadio:CGRectMake(10 + 75 * 3, 10 + 30, 70, 20) Title:@"8串1" isSelect:isSelect Tag:508 ISCLICK:((m_DanCount >= 8 || (m_DanCount > 0 && self.gameCount == 8)) ? FALSE : TRUE)];
        }
        if(self.gameCount >= 9)
        {
            BOOL isSelect = [self isHaveSelected:109];
            [self CreatFreePassRadio:CGRectMake(10, 10 + 30 * 2, 70, 20) Title:@"9串1" isSelect:isSelect Tag:109 ISCLICK:((m_DanCount >= 9 || (m_DanCount > 0 && self.gameCount == 9)) ? FALSE : TRUE)];
        }
        if(self.gameCount >= 10)
        {
            BOOL isSelect = [self isHaveSelected:110];
            [self CreatFreePassRadio:CGRectMake(10 + 75, 10 + 30 * 2, 70, 20) Title:@"10串1" isSelect:isSelect Tag:110 ISCLICK:((m_DanCount >= 10 || (m_DanCount > 0 && self.gameCount == 10)) ? FALSE : TRUE)];
        }
        if(self.gameCount >= 11)
        {
            BOOL isSelect = [self isHaveSelected:111];
            [self CreatFreePassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 2, 70, 20) Title:@"11串1" isSelect:isSelect Tag:111 ISCLICK:((m_DanCount >= 11 || (m_DanCount > 0 && self.gameCount == 11)) ? FALSE : TRUE)];
        }
        if(self.gameCount >= 12)
        {
            BOOL isSelect = [self isHaveSelected:112];
            [self CreatFreePassRadio:CGRectMake(10 + 75 * 3, 10 + 30 * 2, 70, 20) Title:@"12串1" isSelect:isSelect Tag:112 ISCLICK:((m_DanCount >= 12 || (m_DanCount > 0 && self.gameCount == 12)) ? FALSE : TRUE)];
        }
        if(self.gameCount >= 13)
        {
            BOOL isSelect = [self isHaveSelected:113];
            [self CreatFreePassRadio:CGRectMake(10, 10 + 30 * 3, 70, 20) Title:@"13串1" isSelect:isSelect Tag:113 ISCLICK:((m_DanCount >= 13 || (m_DanCount > 0 && self.gameCount == 13)) ? FALSE : TRUE)];
            m_freePassScollView.contentSize = CGSizeMake(302, 90 + 40);
        }
        if(self.gameCount >= 14)
        {
            BOOL isSelect = [self isHaveSelected:114];
            [self CreatFreePassRadio:CGRectMake(10 + 75, 10 + 30 * 3, 70, 20) Title:@"14串1" isSelect:isSelect Tag:114 ISCLICK:((m_DanCount >= 14 || (m_DanCount > 0 && self.gameCount == 14)) ? FALSE : TRUE)];
        }
        if(self.gameCount >= 15)
        {
            BOOL isSelect = [self isHaveSelected:115];
            [self CreatFreePassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 3, 70, 20) Title:@"15串1" isSelect:isSelect Tag:115 ISCLICK:((m_DanCount >= 15 || (m_DanCount > 0 && self.gameCount == 15)) ? FALSE : TRUE)];
        }
    }
}

- (void)CreatFreePassRadio:(CGRect)rect Title:(NSString*)title isSelect:(BOOL)select Tag:(NSInteger) radioTag ISCLICK:(BOOL) isClick
{
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

- (void)setDuoChuanPassScollView
{
    if (self.gameCount >= 2) {
        [self CreatDuoChuanPassRadio:CGRectMake(10, 10, 70, 20) Title:@"2串3" isSelect:NO Tag:0 ISCLICK: TRUE];
        m_DuoChuanPassScollView.contentSize = CGSizeMake(300, 90);
    }
    if (self.gameCount >= 3)
    {
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10, 70, 20) Title:@"3串4" isSelect:NO Tag:1 ISCLICK: ((m_DanCount >= 3 || (m_DanCount > 0 && self.gameCount == 3)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10, 70, 20) Title:@"3串7" isSelect:NO Tag:2 ISCLICK:((m_DanCount >= 3 || (m_DanCount > 0 && self.gameCount == 3)) ? FALSE : TRUE)];
        m_DuoChuanPassScollView.contentSize = CGSizeMake(300, 90);
        if (self.playTypeTag == IBJDCPlayType_Score) {//比分最高支持3串7
            return;
        }
    }
    if(self.gameCount >= 4 )
    {
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 3, 10, 70, 20) Title:@"4串5" isSelect:NO Tag:3
                             ISCLICK: ((m_DanCount >= 4 || (m_DanCount > 0 && self.gameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(10 , 10 + 30, 70, 20) Title:@"4串11" isSelect:NO Tag:4
                             ISCLICK: ((m_DanCount >= 4 || (m_DanCount > 0 && self.gameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30, 70, 20) Title:@"4串15" isSelect:NO Tag:5
                             ISCLICK: ((m_DanCount >= 4 || (m_DanCount > 0 && self.gameCount == 4)) ? FALSE : TRUE)];
        
        m_DuoChuanPassScollView.contentSize = CGSizeMake(300, 90);
    }
    if (self.gameCount >= 5) {
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30, 70, 20) Title:@"5串6" isSelect:NO Tag:6
                             ISCLICK: ((m_DanCount >= 5 || (m_DanCount > 0 && self.gameCount == 5)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 3, 10 + 30, 70, 20) Title:@"5串16" isSelect:NO Tag:7
                             ISCLICK: ((m_DanCount >= 5 || (m_DanCount > 0 && self.gameCount == 5)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 , 10 + 30 * 2, 70, 20) Title:@"5串26" isSelect:NO Tag:8
                             ISCLICK: ((m_DanCount >= 5 || (m_DanCount > 0 && self.gameCount == 5)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 2, 70, 20) Title:@"5串31" isSelect:NO Tag:9
                             ISCLICK: ((m_DanCount >= 5 || (m_DanCount > 0 && self.gameCount == 5)) ? FALSE : TRUE)];
    }
    if (self.gameCount >= 6) {
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 2, 70, 20) Title:@"6串7" isSelect:NO Tag:10
                             ISCLICK: ((m_DanCount >= 6 || (m_DanCount > 0 && self.gameCount == 6)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 3, 10 + 30 * 2, 70, 20) Title:@"6串22" isSelect:NO Tag:11
                             ISCLICK: ((m_DanCount >= 6 || (m_DanCount > 0 && self.gameCount == 6)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 , 10 + 30 * 3, 70, 20) Title:@"6串42" isSelect:NO Tag:12
                             ISCLICK: ((m_DanCount >= 6 || (m_DanCount > 0 && self.gameCount == 6)) ? FALSE : TRUE)];
        m_DuoChuanPassScollView.contentSize = CGSizeMake(300, 90 + 40);
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75, 10 + 30 * 3, 70, 20) Title:@"6串57" isSelect:NO Tag:13
                             ISCLICK: ((m_DanCount >= 6 || (m_DanCount > 0 && self.gameCount == 6)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 75 * 2, 10 + 30 * 3, 70, 20) Title:@"6串63" isSelect:NO Tag:14
                             ISCLICK: ((m_DanCount >= 6 || (m_DanCount > 0 && self.gameCount == 6)) ? FALSE : TRUE)];
    }
}
- (void)freePassRadioButtonClick:(id)sender
{
    
    
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    int beforBetNum = m_betNumber;
    if (btn.selected) {
        if (btn.tag < 500) {
            m_betNumber += [self getFreeChuanBetNum:btn.tag - 100];//注数
        }
        else if(btn.tag == 500)
        {
            m_betNumber += [self getFreeChuanBetNum:1];
        }
        else
        {
            m_betNumber += [self getFreeChuanBetNum:btn.tag - 500];
        }
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
            if (btn.tag < 500)
                m_betNumber -= [self getFreeChuanBetNum:btn.tag - 100];
            else if(btn.tag == 500)
                m_betNumber -= [self getFreeChuanBetNum:1];
            else
                m_betNumber -= [self getFreeChuanBetNum:btn.tag - 500];
            [freePassRadioIndexArray removeObject:[NSNumber numberWithInt:btn.tag]];//未勾选的就移除
        }
    }
    NSLog(@"%@", freePassRadioIndexArray);
    
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


#pragma mark button事件
- (void)segmentedChangeValue
{
    //    [self hideKeybord];
    //    [self.LaunchHMView hideKeybord];
    //
    //    if(self.customSegmentView.segmentedIndex == 0)
    //    {
    //        self.srollView_normalBet.hidden = NO;
    //        self.srollView_HMBet.hidden = YES;
    //        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    //    }
    //    else if(self.customSegmentView.segmentedIndex == 1)
    //    {
    //
    //        self.srollView_normalBet.hidden = YES;
    //        self.srollView_HMBet.hidden = NO;
    //        [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
    //        [RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d" ,m_betNumber];
    //        self.LaunchHMView.zhuShuLabel.text = [NSString stringWithFormat:@"共%d注" ,m_betNumber];
    //
    //        [self.LaunchHMView refreshTopView];
    //    }
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

- (void) refreshData
{
    int numBeishu = [self.fieldBeishu.text intValue];
    self.betNumberLable.text = [NSString stringWithFormat:@"共%d注", m_betNumber];
    
    m_allCount = m_betNumber * 2.0 * numBeishu * 100.0;
    self.allCountLabel.text = [NSString stringWithFormat:@"共%.0lf元", m_allCount /100];
    
    if (m_isFreePassButton) {
        
        [self freePassMinAndMaxAmount];
    }
    self.amountLabel.text = [NSString stringWithFormat:@"%.2lf元 ~ %.2lf元",min_amount * numBeishu,max_amount * numBeishu];
}

- (void) freePassMinAndMaxAmount
{
    max_amount = 0.0;
    if ([freePassRadioIndexArray count] == 0) {
        min_amount = 0.0;
        
    }
    else
    {
        double temp_min_amount = 0.0;
        double temp_max_amount = 0.0;
        for (int i = 0; i < [freePassRadioIndexArray count]; i++)
        {
            int tag = [[freePassRadioIndexArray objectAtIndex:i] integerValue];
            if (tag == 500) {
                //最小奖金
                double temp1_min_amount = [self calculationMinAmount:1];
                if (temp_min_amount == 0.0) {
                    temp_min_amount = temp1_min_amount;
                }
                else
                    temp_min_amount = (temp1_min_amount < temp_min_amount)?temp1_min_amount:temp_min_amount;
                
                //最大奖金
                temp_max_amount += [self calculationFreePassMaxAmount:1];
                
            }
            else if (tag < 500)
            {
                double temp1_min_amount = [self calculationMinAmount:tag - 100];//最小奖金
                if (temp_min_amount == 0.0) {
                    temp_min_amount = temp1_min_amount;
                }
                else
                    temp_min_amount = (temp1_min_amount < temp_min_amount)?temp1_min_amount:temp_min_amount;
                
                //最大奖金
                temp_max_amount += [self calculationFreePassMaxAmount:tag - 100];
            }
            else
            {
                double temp1_min_amount = [self calculationMinAmount:tag - 500];//最小奖金
                if (temp_min_amount == 0.0) {
                    temp_min_amount = temp1_min_amount;
                }
                else
                    temp_min_amount = (temp1_min_amount < temp_min_amount)?temp1_min_amount:temp_min_amount;
                
                //最大奖金
                temp_max_amount += [self calculationFreePassMaxAmount:tag - 500];
            }
        }
        min_amount = temp_min_amount;
        max_amount = temp_max_amount;
    }
}


- (void)guoGuanButtonClick:(UIButton*)tempButton
{
    [self refrshPlayTypeButton];
    if (tempButton == m_FreePassButton) {
        if (m_FreePassButton.selected) {
            return;
        }
        m_isFreePassButton = YES;
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
        
        //清空下数据
        min_amount = 0.0;
        max_amount = 0.0;
        
    }
    [self refreshData];
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

-(UIScrollView*) creatExpandCellView
{
    NSMutableString* betcodeList = [NSMutableString stringWithString:[[RuYiCaiLotDetail sharedObject] disBetCode]];
    if ([betcodeList length] == 0) {
        return nil;
    }
    UIScrollView* view = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 132, 300, kMoveDownHeight - 1)] autorelease];
    view.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
    view.contentSize = CGSizeMake(300, [self getBetCodeListHeight]);
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
        
        self.view_down.frame = CGRectMake(view_down.frame.origin.x, view_down.frame.origin.y + kMoveDownHeight, view_down.frame.size.width, view_down.frame.size.height);
        srollView_normalBet.contentSize = CGSizeMake(320, 570);
    }
    else
    {
        NSString* betCodeListStr = [RuYiCaiLotDetail sharedObject].disBetCode;
        betCodeListStr = [betCodeListStr stringByReplacingOccurrencesOfString:@"," withString:@" "];//去掉 button中的，
        [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", betCodeListStr] forState:UIControlStateNormal];
        self.view_down.frame = CGRectMake(view_down.frame.origin.x, view_down.frame.origin.y - kMoveDownHeight, view_down.frame.size.width, view_down.frame.size.height);
        
        srollView_normalBet.contentSize = CGSizeMake(320, 450);
    }
    
    m_expandBetCode = !m_expandBetCode;
    if (m_expandBetCode) {
        image_sanjiao.image = [UIImage imageNamed:@"sanjiao_expand.png"];
    }
    else
        image_sanjiao.image = [UIImage imageNamed:@"sanjiao_hide.png"];
    
}
- (IBAction)buyClick:(id)sender
{
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
    if (m_betNumber > 10000) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高注数为10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    if([appStoreORnormal isEqualToString:@"appStore"] && [RuYiCaiNetworkManager sharedManager].isSafari)
    {
        [self buildBetCode];
        [self wapPageBuild];
    }
    else
    {
        switch (self.customSegmentView.segmentedIndex)
        {
            case kSegIndexNormal:
            {
                [self buildBetCode];
                
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
                [dict setObject:@"1" forKey:@"isSellWays"];
                NSLog(@"投注 :%@  %@", [RuYiCaiLotDetail sharedObject].betCode, [RuYiCaiLotDetail sharedObject].amount);
                if (min_amount != 0.0 || max_amount != 0.0) {//预计奖金
                    [dict setObject:[NSString stringWithFormat:@"%0.2lf元-%.2lf元", min_amount, max_amount] forKey:@"expectPrizeAmt"];
                }
                [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
                
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

#pragma mark 发起和买 投注注码 点击展开的 回调
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
#pragma mark betCode method
- (void)buildBetCode
{
    int numBeishu = [self.fieldBeishu.text intValue];
    if (self.customSegmentView.segmentedIndex == kSegIndexHM) {
        numBeishu = [self.LaunchHMView.fieldBeishu.text intValue];
    }
    NSString* betCode = @"";
    
    if (m_FreePassButton.selected)
    {
        int RadioIndexArrayCount = [freePassRadioIndexArray count];
        for (int a = 0; a < RadioIndexArrayCount; a++) {
            
            betCode = [betCode stringByAppendingFormat:@"%d@",[[freePassRadioIndexArray objectAtIndex:a] intValue]];
            
            betCode = [betCode stringByAppendingFormat:@"%@",m_chooseBetCode];
            int betNum;
            if ([[freePassRadioIndexArray objectAtIndex:a] intValue] < 500) {
                
                betNum = [self getFreeChuanBetNum:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 100];
            }
            else if([[freePassRadioIndexArray objectAtIndex:a] intValue] == 500)
            {
                betNum = [self getFreeChuanBetNum:1];
            }
            else
                betNum = [self getFreeChuanBetNum:[[freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
            betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu, 200 * betNum];
            
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
        
        
        betCode = [betCode stringByAppendingFormat:@"%@@",[NSString stringWithFormat:@"%d",keyNumber]];
        betCode = [betCode stringByAppendingFormat:@"%@", m_chooseBetCode];
        betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu,m_betNumber * 200];
    }
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = [RuYiCaiLotDetail sharedObject].betCode;
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%.0lf",m_allCount];
    [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    [RuYiCaiLotDetail sharedObject].batchNum = @"1";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%.0lf",m_allCount];
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
    BOOL  isOk = YES;
    for (int i = 0; i < textField.text.length; i++)
    {
        UniChar chr = [textField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"数字不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            isOk = NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"填写的必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            isOk = NO;
        }
    }
    if (isOk) {
        if([textField.text intValue] <= 0 || [textField.text intValue] > 100000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"投注倍数的范围为 1~100000倍" withTitle:@"提示" buttonTitle:@"确定"];
            isOk = NO;
        }
    }
    
    if (!isOk) {
        self.fieldBeishu.text = @"1";
    }
    [self refreshData];
}

#pragma mark 投注余额不足处理
- (void)betCompleteOK:(NSNotification*)notification
{
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
    //    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    //    switch (self.segmented.segmentedIndex)
    //    {
    //        case kSegIndexNormal:
    //        {
    //
    //
    //        }break;
    //        case kSegZhuiHao:
    //        case kSegIndexHM:
    //        case kSegIndexGift:
    ////            [[RuYiCaiNetworkManager sharedManager] showMessage:@"余额不足" withTitle:@"错误" buttonTitle:@"确定"];
    //            break;
    //        default:
    //            break;
    //    }
}
- (void)fqHeMaiLotOK:(NSNotification*)notification//合买成功弹出view
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


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (110 == alertView.tag)
    {
        if (buttonIndex==1)
        {
            
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
            
            ExchangeLotteryWithIntegrationViewController * viewController = [[ExchangeLotteryWithIntegrationViewController alloc] init];
            viewController.isShowBackButton = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
    }
    else if(113 == alertView.tag)//返回是否加入号码篮
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"0"])//普通投
            {
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
            else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"])//机选
            {
                NSArray*  eachBetCode = [[RuYiCaiLotDetail sharedObject].betCode componentsSeparatedByString:@";"];
                NSArray* eachDisBetCode = [[RuYiCaiLotDetail sharedObject].disBetCode componentsSeparatedByString:@"\n"];
                for (int i = 0; i < [eachBetCode count]; i++)
                {
                    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
                    [tempDic setObject:[eachBetCode objectAtIndex:i] forKey:MORE_BETCODE];
                    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
                    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
                    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
                    
                    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
                    [disTempDic setObject:[eachDisBetCode objectAtIndex:i] forKey:MORE_BETCODE];
                    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
                    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
                    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
                }
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 投注期号过期处理
- (void)betOutTime:(NSNotification*)notification
{
    //    该期已过期
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"该期已过期" withTitle:@"错误" buttonTitle:@"确定"];
    
}
#pragma mark 数据处理
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
        }
    }
    
    [m_duoChuanChooseArray appendList:base];
}

//- (NSInteger)getFreeChooseCountBy_X:(NSInteger)_x//自由过关X串1  只针对胜平负玩法
//{
//    if(_x <= 0)
//        return 0;
//    int count = 0;
//
//    int count_2 = 0;
//    int count_3 = 0;
//    for (int i = 0; i < self.gameCount; i++) {
//         CombineBase* base = [m_duoChuanChooseArray.combineList objectAtIndex:i];
//        if ([base gameCount] == 2) {
//            count_2++;
//        }
//        else if([base gameCount] == 3)
//        {
//            count_3++;
//        }
//    }
//    int count_1 = self.gameCount - count_2 - count_3;
//    if (_x == 1) {//单关
//        count = 2 * count_2 + 3 * count_3 + count_1;
//        return count;
//    }
//    count = RYCChoose(_x, count_1);//没有选复式场数
//    for (int N_2 = 1; N_2 <= count_2; N_2++) {//选了含2个的场数
//        if (N_2 > _x) {
//            break;
//        }
//        count += RYCChoose(N_2, count_2)*RYCChoose(_x - N_2, count_1)*pow(2 , N_2);
////        NSLog(@"count1 %d", count);
//    }
//    for (int N_3 = 1; N_3 <= count_3; N_3++) {//选了含3个的场数
//        if (N_3 > _x) {
//            break;
//        }
//        count += RYCChoose(N_3, count_3)*RYCChoose(_x - N_3, count_1)*pow(3 , N_3);
////        NSLog(@"count3 %d", count);
//
//    }
//    for (int N_X_2 = 1; N_X_2 <= count_2; N_X_2++) {
//        for (int N_X_3 = 1; N_X_3 <= count_3; N_X_3++) {
//            if (_x - N_X_2 - N_X_3 < 0) {
//                break;
//            }
//            count += RYCChoose(N_X_2, count_2)*RYCChoose(N_X_3, count_3)*RYCChoose(_x-N_X_2-N_X_3, count_1)*pow(3, N_X_3)*pow(2, N_X_2);
////            NSLog(@"count4 %d", count);
//        }
//    }
//    return count;
//}
//

-(NSInteger) getNoteNumberByDuoChuanRadioTag:(NSString*)DuoChuanRadioTag
{
    int count = 0;
    if (DuoChuanRadioTag == @"2串3") {
        
        count = [self getDuoChuanBetNum:1 ChangShu:2] +
        [self getDuoChuanBetNum:2 ChangShu:2];
        
        min_amount = [self calculationMinAmount:1];
        //        min_amount *= RYCChoose(2 - 1, (gameCount - 1));
        
        float amount = 0.0;
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:2 Y:2];
        
        //单关
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:2 Y:1];
        
        max_amount = amount;
    }
    else if(DuoChuanRadioTag == @"3串4")
    {
        
        count = [self getDuoChuanBetNum:2 ChangShu:3] +
        [self getDuoChuanBetNum:3 ChangShu:3];
        
        min_amount = [self calculationMinAmount:2];
        min_amount *= RYCChoose(3 - 2, (gameCount - 2));
        
        float amount = 0.0;
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:3 Y:2];;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:3 Y:3];;
        
        max_amount = amount;
    }
    else if (DuoChuanRadioTag == @"3串7") {
        
        count = [self getDuoChuanBetNum:1 ChangShu:3] +
        [self getDuoChuanBetNum:2 ChangShu:3] +
        [self getDuoChuanBetNum:3 ChangShu:3];
        
        min_amount = [self calculationMinAmount:1];
        //        min_amount *= RYCChoose(3 - 1, (gameCount - 1));
        
        float amount = 0.0;
        
        //单关
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:3 Y:1];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:3 Y:2];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:3 Y:3];
        
        max_amount = amount;
        
    }
    else if(DuoChuanRadioTag == @"4串5")
    {
        
        count = [self getDuoChuanBetNum:3 ChangShu:4] +
        [self getDuoChuanBetNum:4 ChangShu:4];
        
        min_amount = [self calculationMinAmount:3];
        min_amount *= RYCChoose(4 - 3, (gameCount - 3));
        
        float amount = 0.0;
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:4];
        
        max_amount = amount;
        
    }
    else if(DuoChuanRadioTag == @"4串11")
    {
        
        count = [self getDuoChuanBetNum:2 ChangShu:4] +
        [self getDuoChuanBetNum:3 ChangShu:4] +
        [self getDuoChuanBetNum:4 ChangShu:4];
        
        min_amount = [self calculationMinAmount:2];
        min_amount *= RYCChoose(4 - 2, (gameCount - 2));
        
        float amount = 0.0;
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:2];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:4];
        
        max_amount = amount;
    }
    else if(DuoChuanRadioTag == @"4串15")
    {
        
        count = [self getDuoChuanBetNum:1 ChangShu:4] +
        [self getDuoChuanBetNum:2 ChangShu:4] +
        [self getDuoChuanBetNum:3 ChangShu:4] +
        [self getDuoChuanBetNum:4 ChangShu:4];
        
        min_amount = [self calculationMinAmount:1];
        //        min_amount *= RYCChoose(4 - 1, (gameCount - 1));
        
        float amount = 0.0;
        
        //单关
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:1];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:2];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:4 Y:4];
        
        max_amount = amount;
        
    }
    else if(DuoChuanRadioTag == @"5串6")
    {
        
        count = [self getDuoChuanBetNum:4 ChangShu:5] +
        [self getDuoChuanBetNum:5 ChangShu:5];
        
        min_amount = [self calculationMinAmount:4];
        min_amount *= RYCChoose(5 - 4, (gameCount - 4));
        
        float amount = 0.0;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:5];
        
        max_amount = amount;
    }
    else if(DuoChuanRadioTag == @"5串16")
    {
        count = [self getDuoChuanBetNum:3 ChangShu:5] +
        [self getDuoChuanBetNum:4 ChangShu:5] +
        [self getDuoChuanBetNum:5 ChangShu:5];
        
        min_amount = [self calculationMinAmount:3];
        min_amount *= RYCChoose(5 - 3, (gameCount - 3));
        
        float amount = 0.0;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:5];
        
        max_amount = amount;
    }
    else if(DuoChuanRadioTag == @"5串26")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:5] +
        [self getDuoChuanBetNum:3 ChangShu:5] +
        [self getDuoChuanBetNum:4 ChangShu:5] +
        [self getDuoChuanBetNum:5 ChangShu:5];
        
        min_amount = [self calculationMinAmount:2];
        min_amount *= RYCChoose(5 - 2, (gameCount - 2));
        
        float amount = 0.0;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:2];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:5];
        
        max_amount = amount;
    }
    else if(DuoChuanRadioTag == @"5串31")
    {
        count = [self getDuoChuanBetNum:1 ChangShu:5] +
        [self getDuoChuanBetNum:2 ChangShu:5] +
        [self getDuoChuanBetNum:3 ChangShu:5] +
        [self getDuoChuanBetNum:4 ChangShu:5] +
        [self getDuoChuanBetNum:5 ChangShu:5];
        
        min_amount = [self calculationMinAmount:1];
        //        min_amount *= RYCChoose(5 - 1, (gameCount - 1));
        
        float amount = 0.0;
        
        //单关
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:1];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:2];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:5 Y:5];
        
        max_amount = amount;
    }
    else if(DuoChuanRadioTag == @"6串7")
    {
        count = [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        min_amount = [self calculationMinAmount:5];
        min_amount *= RYCChoose(6 - 5, (gameCount -5));
        
        float amount = 0.0;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:5];
        
        max_amount = amount;
        
    }
    else if(DuoChuanRadioTag == @"6串22")
    {
        count = [self getDuoChuanBetNum:4 ChangShu:6] +
        [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        min_amount = [self calculationMinAmount:4];
        min_amount *= RYCChoose(6 - 4, (gameCount -4));
        
        float amount = 0.0;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:5];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:6];
        
        max_amount = amount;
        
    }
    else if(DuoChuanRadioTag == @"6串42")
    {
        count = [self getDuoChuanBetNum:3 ChangShu:6] +
        [self getDuoChuanBetNum:4 ChangShu:6] +
        [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        min_amount = [self calculationMinAmount:3];
        min_amount *= RYCChoose(6 - 3, (gameCount -3));
        
        float amount = 0.0;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:5];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:6];
        
        max_amount = amount;
    }
    else if(DuoChuanRadioTag == @"6串57")
    {
        count = [self getDuoChuanBetNum:2 ChangShu:6] +
        [self getDuoChuanBetNum:3 ChangShu:6] +
        [self getDuoChuanBetNum:4 ChangShu:6] +
        [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        min_amount = [self calculationMinAmount:2];
        min_amount *= RYCChoose(6 - 2, (gameCount -2));
        
        float amount = 0.0;
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:2];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:5];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:6];
        
        max_amount = amount;
        
    }
    else if(DuoChuanRadioTag == @"6串63")
    {
        
        count = [self getDuoChuanBetNum:1 ChangShu:6] +
        [self getDuoChuanBetNum:2 ChangShu:6] +
        [self getDuoChuanBetNum:3 ChangShu:6] +
        [self getDuoChuanBetNum:4 ChangShu:6] +
        [self getDuoChuanBetNum:5 ChangShu:6] +
        [self getDuoChuanBetNum:6 ChangShu:6];
        
        min_amount = [self calculationMinAmount:1];
        //        min_amount *= RYCChoose(6 - 1, (gameCount -1));
        
        float amount = 0.0;
        
        //单关
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:1];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:2];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:3];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:4];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:5];
        
        
        amount += [self calculationDuochuanPassMaxAmountBy_X_Y:6 Y:6];
        
        max_amount = amount;
    }
    return count;
}


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

#pragma mark 计算赔率
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

//计算最小奖金
- (double) calculationMinAmount:(int)x
{
    min_amount = 0.0;
    
    //单关
    if (x == 1)
    {
        if (m_DanCount) {
            
            for (int j = 0;j < [[m_Com_arrangeSP_Min combineList] count]; j++)
            {
                CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:j];
                if ([base isDan]) {
                    min_amount = [[[base combineBase_SP] objectAtIndex:0] floatValue];
                }
            }
        }
        else
        {
            for (int j = 0;j < [[m_Com_arrangeSP_Min combineList] count]; j++)
            {
                CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:j];
                float peilv = [[[base combineBase_SP] objectAtIndex:0] floatValue];
                if (j == 0) {
                    min_amount = peilv;
                }
                if (peilv < min_amount) {
                    min_amount = peilv;
                }
            }
            
        }
        return min_amount * 2.0 * 0.65;
    }
    
    
    //非单关
    int Xindex = 0;
    /*
     先取出 含胆的 比赛
     */
    for (int j = 0;j < [[m_Com_arrangeSP_Min combineList] count]; j++)
    {
        if (j == 0) {
            min_amount = 1.0;
        }
        CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:j];
        if ([base isDan]) {
            min_amount *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
            Xindex++;
        }
    }
    /*
     补全 X 串 y
     */
    for (int i = 0;i < [[m_Com_arrangeSP_Min combineList] count]; i++)
    {
        if (Xindex >= x) {
            break;
        }
        CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:i];
        if (![base isDan]) {
            min_amount *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
            Xindex++;
        }
    }
    min_amount *= 2.0;
    return min_amount * 0.65;
}


//计算自由过关的最大奖金
- (double) calculationFreePassMaxAmount:(int)x
{
    max_amount = 0.0;
    
    //单关
    if (x == 1) {
        
        for (int j = 0;j < [[m_Com_arrangeSP_Max combineList] count]; j++)
        {
            CombineBase* base = (CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:j];
            float peilv = [[[base combineBase_SP] objectAtIndex:0] floatValue];
            max_amount += peilv;
        }
        
        return max_amount *2.0 * 0.65;
    }
    
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
    if (Dan_count == 0)
    {
        CombineListArray *SP_listArrayTemp = [[CombineListArray alloc] init];
        float peilv = 0.0;
        
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
            
            max_amount += peilv;
        }
        
    }
    
    //含胆
    else
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
        
        CombineListArray *SP_listArrayTemp = [[CombineListArray alloc] init];
        
        int no_dan_array_count = [[no_dan_ListArray combineList] count];
        float SP_no_a[no_dan_array_count];
        for (int i = 0; i < no_dan_array_count; i++)
        {
            float value = [[[(CombineBase*)[[no_dan_ListArray combineList] objectAtIndex:i] combineBase_SP] objectAtIndex:0] floatValue];
            SP_no_a[i] = value;
        }
        
        //第二步:计算胆的赔率
        float dan_peilv = 0.0;
        for (int dan_i = 0; dan_i < [[dan_ListArray combineList] count]; dan_i++)
        {
            
            float value = [[[(CombineBase*)[[dan_ListArray combineList] objectAtIndex:dan_i] combineBase_SP] objectAtIndex:0] floatValue];
            if (dan_i == 0) {
                dan_peilv = 1.0;
            }
            dan_peilv *= value;
        }
        
        //第三步：再从不含胆的数组中选去还差的场数
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
            //第四步：用得到的不含胆的比赛补全
            for (int k = 0; k < [[dan_ListArray combineList] count]; k++) {
                
                CombineBase* base = (CombineBase *)[[dan_ListArray combineList] objectAtIndex:k];
                [addDan_List appendList:base];
            }
            
            float peilv = 0.0;
            
            int numCount = [[addDan_List combineList] count];
            for (int j = 0; j < numCount; j++) {
                
                CombineBase *listBase = (CombineBase*)[[addDan_List combineList] objectAtIndex:j];
                
                if (j == 0) {
                    peilv = 1.0;
                }
                peilv *= [[[listBase combineBase_SP] objectAtIndex:0] floatValue];
            }
            max_amount += peilv;
        }
        
    }
    
    
    return max_amount * 2.0 * 0.65;
}


//计算多串过关的最大奖金
- (double) calculationDuochuanPassMaxAmountBy_X_Y:(NSInteger)x Y:(NSInteger)y
{
    max_amount = 0.0;
    
    
    int MaxSP_Count = [[m_Com_arrangeSP_Max combineList] count];
    
    
    //计算胆的个数
    int Dan_count = 0;
    for (int i = 0; i < MaxSP_Count; i++)
    {
        if ([(CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:i] isDan])
        {
            Dan_count++;
        }
    }
    
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
    
    
    //第二步：计算含胆的赔率
    float dan_peilv = 0.0;
    for (int dan_i = 0; dan_i < [[dan_ListArray combineList] count]; dan_i++) {
        
        float value = [[[(CombineBase*)[[dan_ListArray combineList] objectAtIndex:dan_i] combineBase_SP] objectAtIndex:0] floatValue];
        if (dan_i == 0) {
            dan_peilv = 1.0;
        }
        dan_peilv *= value;
    }
    
    //第三步：从不含胆的数组里面，选出还差的场数
    CombineListArray *SP_listArrayTemp = [[CombineListArray alloc] init];
    int no_dan_array_count = [[no_dan_ListArray combineList] count];
    float SP_no_a[no_dan_array_count];
    for (int i = 0; i < no_dan_array_count; i++)
    {
        float value = [[[(CombineBase*)[[no_dan_ListArray combineList] objectAtIndex:i] combineBase_SP] objectAtIndex:0] floatValue];
        SP_no_a[i] = value;
    }
    
    
    int SP_c[x - Dan_count];
    combine_SP(SP_no_a, no_dan_array_count, x - Dan_count, SP_c, x - Dan_count,SP_listArrayTemp,no_dan_ListArray);//在n场比赛中选取m场
    
    //第四步：遍历选出来的不含胆的组合，给每个组合都拼上胆的比赛
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
        
        //第四步：计算赔率
        float peilv = 0.0;
        
        //x!=1的准备工作
        
        int listCount  = [[addDan_List combineList] count];
        float SP_bu_a[listCount];
        for (int h = 0; h < listCount; h++)
        {
            float value = [[[(CombineBase*)[[addDan_List combineList] objectAtIndex:h] combineBase_SP] objectAtIndex:0]floatValue];
            SP_bu_a[h] = value;
        }
        CombineListArray *SP_bu_listArrayTemp = [[CombineListArray alloc] init];
        
        
        if (y == 1) {
            //如果x==1，即为单关
            //
            int numCount = [[addDan_List combineList] count];
            for (int j = 0; j < numCount; j++) {
                
                CombineBase *listBase = (CombineBase*)[[addDan_List combineList] objectAtIndex:j];
                
                peilv += [[[listBase combineBase_SP] objectAtIndex:0] floatValue];
            }
            max_amount += peilv;
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
                
                max_amount += peilv * (double)num;
            }
        }
        
        [SP_bu_listArrayTemp release];
        [addDan_List release];
    }
    
    
    [dan_ListArray release];
    [no_dan_ListArray release];
    
    return max_amount * 2.0 *0.65;
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



#pragma mark - customerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    
    //    [self hideKeybord];
    //    [self.LaunchHMView hideKeybord];
    //
    //    if(self.cusSegmented.segmentedIndex == 0)
    //    {
    //        self.srollView_normalBet.hidden = NO;
    //        self.srollView_HMBet.hidden = YES;
    //        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    //    }
    //    else if(self.cusSegmented.segmentedIndex == 1)
    //    {
    //
    //        self.srollView_normalBet.hidden = YES;
    //        self.srollView_HMBet.hidden = NO;
    //        [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
    //        [RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d" ,m_betNumber];
    //        self.LaunchHMView.zhuShuLabel.text = [NSString stringWithFormat:@"共%d注" ,m_betNumber];
    //
    //        [self.LaunchHMView refreshTopView];
    //    }
    
    
    [self hideKeybord];
    [self.LaunchHMView hideKeybord];
    
    if(self.customSegmentView.segmentedIndex == 0)
    {
        self.srollView_normalBet.hidden = NO;
        self.srollView_HMBet.hidden = YES;
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(self.customSegmentView.segmentedIndex == 1)
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
