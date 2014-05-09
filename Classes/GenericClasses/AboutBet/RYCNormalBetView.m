//
//  RYCNormalBetView.m
//  RuYiCai
//
//  Created by  on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RYCNormalBetView.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiCommon.h"
#import "GiftViewController.h"
#import "LaunchHMViewController.h"
#import "AnimationTabView.h"
#import "ZhuiHaoBetViewController.h"
#import "GiftWordTableViewController.h"
#import "CommonRecordStatus.h"
#import "ChangeViewController.h"
#import "DirectPaymentViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ExchangeLotteryWithIntegrationViewController.h"

#define kSegIndexNormal (0)
#define kSegZhuiHao     (1)
#define kSegIndexHM     (2)
#define kSegIndexGift   (3)

@implementation RYCNormalBetView

@synthesize lotTitleLabel;
@synthesize normalBetScroll;
@synthesize zhuiHaoBetScroll;
@synthesize HMBetScroll;
@synthesize giftBetScroll;

@synthesize allCountLabel;
@synthesize zhuShuLabel;
@synthesize batchCodeLabel;
@synthesize betCodeList;
@synthesize biAccountLabel;

@synthesize sliderBeishu;
@synthesize fieldBeishu;
@synthesize beiLabelBei;
@synthesize normalLabelBei;
@synthesize zhuiJiaButton;
@synthesize zhuiJiaLabel;

@synthesize animationTabView = m_animationTabView;
@synthesize zhuiHaoViewController = m_zhuiHaoViewController;
@synthesize LaunchHMView = m_LaunchHMView;
@synthesize giftViewController = m_giftViewController;

@synthesize buyButton;
@synthesize segmented;
@synthesize dataDic = m_dataDic;

- (void)dealloc
{
    [_getShareDetileDic release];
    [m_dataDic release];
    [lotTitleLabel release];
    [normalBetScroll release];
    [zhuiHaoBetScroll release];
    [HMBetScroll release];
    [giftBetScroll release];
    
    [allCountLabel release];
    [zhuShuLabel release];
    [batchCodeLabel release];
    [betCodeList release];
    [biAccountLabel release];
    
    [sliderBeishu release];
    [fieldBeishu release];
    [beiLabelBei release];
    if (self.normalLabelBei) {
        [normalLabelBei release];
    }
    
    
    [zhuiJiaButton release];
    [zhuiJiaLabel release];
        
    [m_animationTabView release];
    [m_zhuiHaoViewController release];
    [m_LaunchHMView release];
    [m_giftViewController release];

    [buyButton release];
    [segmented release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"giftWordButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"phoneButtonClick" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"giftSendSms" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fqHeMaiLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getShareDetileLotOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryCaseLotDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhuShuOut" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCaseLotDetailOK:) name:@"queryCaseLotDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftWordButtonClick:) name:@"giftWordButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneButtonClick:) name:@"phoneButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftSendSms:) name:@"giftSendSms" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betOutTime:) name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fqHeMaiLotOK:) name:@"fqHeMaiLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShareDetileLotOK:) name:@"getShareDetileLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZhuShuOut:) name:@"ZhuShuOut" object:nil];

    if([RuYiCaiLotDetail sharedObject].giftContentStr && ![[RuYiCaiLotDetail sharedObject].giftContentStr isEqualToString:@""])//赠言
    {
        self.giftViewController.adviceTextView.text = [self.giftViewController.adviceTextView.text stringByAppendingString:[RuYiCaiLotDetail sharedObject].giftContentStr];
        [RuYiCaiLotDetail sharedObject].giftContentStr = @"";
    }
}
-(void)ZhuShuOut:(NSNotification *)noti
{
    UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:noti.object
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
    //            [alterView addButtonWithTitle:@"直接支付"];
    [alterView addButtonWithTitle:@"免费兑换"];
    alterView.tag = 112;
    [alterView show];
    [alterView release];
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //双色球投注 返回 按钮
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    self.zhuiHaoBetScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 162);
    self.HMBetScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 162);
    self.giftBetScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 162);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
   
    isNormalBet = YES;

//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
//                                             initWithTitle:@"返回"
//                                             style:UIBarButtonItemStylePlain
//                                             target:self
//                                             action:@selector(back:)] autorelease];
//    
//    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
//    [m_animationTabView.buttonNameArray addObject:@"投注"];
//    [m_animationTabView.buttonNameArray addObject:@"追号"];
//    [m_animationTabView.buttonNameArray addObject:@"合买"];
//    [m_animationTabView.buttonNameArray addObject:@"赠送"];
//    [m_animationTabView setMainButton];
//    [self.view addSubview:m_animationTabView];

    self.segmented = [[[CustomSegmentedControl alloc]
                       initWithFrame:CGRectMake(25, 5, 270, 30)
                       andNormalImages:[NSArray arrayWithObjects:
                                        @"segment_tz_nomarl.png",
                                        @"segment_zh_nomarl.png",
                                        @"segment_hm_nomarl.png",
                                        @"segment_zs_nomarl.png",
                                        nil]
                       andHighlightedImages:[NSArray arrayWithObjects:
                                             @"segment_tz_nomarl.png",
                                             @"segment_zh_nomarl.png",
                                             @"segment_hm_nomarl.png",
                                             @"segment_zs_nomarl.png",
                                             nil]
                       andSelectImage:[NSArray arrayWithObjects:
                                       @"segment_tz_click.png",
                                       @"segment_zh_click.png",
                                       @"segment_hm_click.png",
                                       @"segment_zs_click.png",
                                       nil]]autorelease];
    
    segmented.delegate = self;
    [self.view addSubview:segmented];
    [self.segmented setHidden:YES];

    self.fieldBeishu.delegate = self;
    
    self.sliderBeishu.maximumValue = 200;
    self.sliderBeishu.minimumValue = 1.0;
    self.sliderBeishu.value = 1.0;
    self.fieldBeishu.text = @"1";
    

      
    allCount = [[RuYiCaiLotDetail sharedObject].amount intValue];
    
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆",[[RuYiCaiLotDetail sharedObject].amount intValue]/100*aas];
    self.zhuShuLabel.text = [NSString stringWithFormat:@"共%@注",[RuYiCaiLotDetail sharedObject].zhuShuNum];

    self.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    
    if([RuYiCaiLotDetail sharedObject].batchCode && [RuYiCaiLotDetail sharedObject].batchCode.length != 0)
    {
       self.batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//       self.batchEndTimeLabel.text = [NSString stringWithFormat:@"（截止日期：%@）", [RuYiCaiLotDetail sharedObject].batchEndTime];
    }
    else
       [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:[RuYiCaiLotDetail sharedObject].lotNo];//获取期号 
    
    [RuYiCaiLotDetail sharedObject].prizeend = @"1";//是否中奖就停止追期
    [RuYiCaiLotDetail sharedObject].lotMulti = @"1";//倍数
        
    [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", [RuYiCaiLotDetail sharedObject].disBetCode] forState:UIControlStateNormal];
    
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//机选
    {
        self.biAccountLabel.text = [NSString stringWithFormat:@"您共有%@笔投注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
    }
    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"])//多注投
    {
        self.biAccountLabel.text = [NSString stringWithFormat:@"您共有%d笔投注", [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]];
    }
    m_zhuiHaoViewController = [[ZhuiHaoBetViewController alloc] init];
    m_zhuiHaoViewController.view.frame = CGRectMake(0, 0, 320, 696);
    [self.zhuiHaoBetScroll addSubview:m_zhuiHaoViewController.view];
    self.zhuiHaoBetScroll.contentSize = CGSizeMake(320, 696);
    
    m_LaunchHMView = [[LaunchHMViewController alloc] init];
    m_LaunchHMView.view.frame = CGRectMake(0, 0, 320, 720);
    [self.HMBetScroll addSubview:m_LaunchHMView.view];
    self.HMBetScroll.contentSize = CGSizeMake(320, 715);
    
    m_giftViewController = [[GiftViewController alloc] init];
    m_giftViewController.view.frame = CGRectMake(0, 0, 320, 490);
    [self.giftBetScroll addSubview:m_giftViewController.view];
    self.giftBetScroll.contentSize = CGSizeMake(320, 475);
    
    if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoDLT] && [RuYiCaiLotDetail sharedObject].isDLTOr11X2)
	{
        self.zhuiJiaButton.hidden = NO;
        self.zhuiJiaLabel.hidden = NO;
    }
    else
    {
        self.zhuiJiaButton.hidden = YES;
        self.zhuiJiaLabel.hidden = YES;
    }
    self.normalBetScroll.hidden = NO;
    self.zhuiHaoBetScroll.hidden = YES;
    self.HMBetScroll.hidden = YES;
    self.giftBetScroll.hidden = YES;
    
    if ([CanChooseBeiShu isEqualToString:@"NO"]) {
//        [self.fieldBeishu setFrame:CGRectMake(zhuShuLabel.frame.origin.x, self.fieldBeishu.frame.origin.y, self.fieldBeishu.frame.size.width, self.fieldBeishu.frame.size.height)];
//        [self.beiLabelBei setFrame:CGRectMake(self.fieldBeishu.frame.origin.x+self.fieldBeishu.frame.size.width+5, self.beiLabelBei.frame.origin.y, self.beiLabelBei.frame.size.width, self.beiLabelBei.frame.size.height)];
        
        
        self.normalLabelBei = [[UILabel alloc] initWithFrame:CGRectMake(zhuShuLabel.frame.origin.x, 235, 100, 20)];
        [self.normalLabelBei setBackgroundColor:[UIColor clearColor]];
        [self.normalLabelBei setText:@"1倍"];
        [self.view addSubview:self.normalLabelBei];
        
        
        self.sliderBeishu.hidden = YES;
        self.fieldBeishu.hidden = YES;
        self.beiLabelBei.hidden = YES;
        self.zhuiJiaButton.hidden = YES;
        self.zhuiJiaLabel.hidden = YES;
    }

}

#pragma mark---微信分享
- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (void)doAuth
{
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"post_timeline";
    req.state = @"xxx";
    
    [WXApi sendReq:req];
}

-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
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

- (void)back:(id)sender
{
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"4"])//多注投 幸运选号 模拟选号
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"退出该页面将清空您所选的号码，是否将已选的号码保存到号码篮内？"
                                                           delegate:self
                                                  cancelButtonTitle:@"否"
                                                  otherButtonTitles:nil];
        [alterView addButtonWithTitle:@"是"];
        alterView.tag = 113;
        [alterView show];
        [alterView release];
    }
}

- (void)tabButtonChanged:(NSNotification*)notification
{
    [self hideKeybord];
    [self.zhuiHaoViewController hideKeybord];
    [self.LaunchHMView hideKeybord];
    [self.giftViewController hideKeybord];
    
    if(self.segmented.segmentedIndex == 0)
    {
        self.normalBetScroll.hidden = NO;
        self.zhuiHaoBetScroll.hidden = YES;
        self.HMBetScroll.hidden = YES;
        self.giftBetScroll.hidden = YES;
        
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(self.segmented.segmentedIndex == 1)
    {
        self.normalBetScroll.hidden = YES;
        self.zhuiHaoBetScroll.hidden = NO;
        self.HMBetScroll.hidden = YES;
        self.giftBetScroll.hidden = YES;
        
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(self.segmented.segmentedIndex == 2)
    {
        self.normalBetScroll.hidden = YES;
        self.zhuiHaoBetScroll.hidden = YES;
        self.HMBetScroll.hidden = NO;
        self.giftBetScroll.hidden = YES;
        
        [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
    }
    else
    {
        self.normalBetScroll.hidden = YES;
        self.zhuiHaoBetScroll.hidden = YES;
        self.HMBetScroll.hidden = YES;
        self.giftBetScroll.hidden = NO;
                
        [buyButton setTitle:@"立即赠送" forState:UIControlStateNormal];
    }
}

- (IBAction)sliderBeishuChange:(id)sender
{ 
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
    
    int aCount; // = allCount/100 * numBeishu;
    if(!isNormalBet)
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    else
        aCount = allCount/100 * numBeishu;
    
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", aCount*aas];
}


- (IBAction)betCodeClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
}

- (IBAction)zhuiJiaButtonClick:(id)sender
{
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    int aCount;
    if(isNormalBet)
    {
        isNormalBet = !isNormalBet;
        [zhuiJiaButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateNormal];
        [zhuiJiaButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateHighlighted];  
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    }
    else
    {
        isNormalBet = !isNormalBet;
        [zhuiJiaButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateNormal];
        [zhuiJiaButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateHighlighted];  
        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    }
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", aCount*aas];
}

- (BOOL)normalBetCheck
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
    if([self.fieldBeishu.text intValue] <= 0 || [self.fieldBeishu.text intValue] > 200)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}

- (IBAction)buyClick:(id)sender
{
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
    if (![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    if(([appStoreORnormal isEqualToString:@"appStore"] &&
        [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat))
    {
        if([self normalBetCheck])
        {
            [self buildBetCode];
            [self wapPageBuild];
        }
    }
    else
    {
        switch (self.segmented.segmentedIndex)
        {
            case kSegIndexNormal:
            {
                if([self normalBetCheck])
                {
                    [self buildBetCode];
                }
                else
                {
                    return;
                }
//                [MobClick event:@"FCTC_bet"];
                
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
                [dict setObject:@"1" forKey:@"isSellWays"];               
                [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
            }break;
            case kSegZhuiHao:
            {
                if(![self.zhuiHaoViewController zhuiHaoBetCheck])
                {
                    return;
                }
                [self.zhuiHaoViewController buildBetCode];
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
                [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单笔总金额（多注投)
                [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
            }break;
            case kSegIndexHM:
            {
                               [self.LaunchHMView LotComplete:nil];
            }break;
            case kSegIndexGift:
            {
                [self.giftViewController sureButonClick];
            }break;
            default:
                break;
        }
    }
}

- (void)updateInformation:(NSNotification*)notification
{
    [RuYiCaiLotDetail sharedObject].batchCode = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    [RuYiCaiLotDetail sharedObject].batchEndTime = [[RuYiCaiNetworkManager sharedManager] highFrequencyEndTime];
    self.batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//    self.batchEndTimeLabel.text = [NSString stringWithFormat:@"（截止日期：%@）", [RuYiCaiLotDetail sharedObject].batchEndTime];
    
    self.zhuiHaoViewController.zhuiHao_batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//    self.zhuiHaoViewController.zhuiHao_batchEndTimeLabel.text = [RuYiCaiLotDetail sharedObject].batchEndTime;
    
    self.LaunchHMView.batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//    self.LaunchHMView.batchEndTimeLabel.text = [RuYiCaiLotDetail sharedObject].batchEndTime;
    
    self.giftViewController.batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//    self.giftViewController.batchEndTimeLabel.text = [RuYiCaiLotDetail sharedObject].batchEndTime;
}


#pragma mark gift notification
- (void)giftWordButtonClick:(NSNotification*)notification
{
    GiftWordTableViewController*  viewController = [[GiftWordTableViewController alloc] init];
    viewController.title = @"赠言";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)phoneButtonClick:(NSNotification*)notification
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
							   [NSNumber numberWithInt:kABPersonEmailProperty],
							   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	picker.displayedProperties = displayedItems;
	// Show the picker 
	[self presentModalViewController:picker animated:YES];
//    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
        NSString *aLabel = [(NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i) autorelease];
        NSLog(@"PhoneLabel:%@ Phone#:%@",aLabel,aPhone);
        if([aLabel isEqualToString:@"_$!<Mobile>!$_"])
        {
            [phones addObject:aPhone];
        }
        else if([aLabel isEqualToString:@"iPhone"])
        {
            [phones addObject:aPhone];
        }
    }
    if([phones count]>0)
    {
        NSString *mobileNo = [phones objectAtIndex:0];
        NSArray *phoneNum = [mobileNo componentsSeparatedByString:@"-"];
        if(self.giftViewController.numTextView.text.length != 0)
        {
            self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingString:@","];
            for(int i = 0; i < [phoneNum count]; i++)
            {
                self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
            }
        }
        else
        {
            for(int i = 0; i < [phoneNum count]; i++)
            {
                self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
            }
        }
        NSLog(mobileNo);
    }
    [phones release];
//    CFRelease(phoneMulti);
    [self dismissModalViewControllerAnimated:YES];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
	return YES;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
//	ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
//	NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, identifier);
//	NSArray *phoneNum = [personPhone componentsSeparatedByString:@"-"];
//	//NSLog(@"phonenum--- %@",phoneNum);
//	
//	[personPhone release];
//	if(self.giftViewController.numTextView.text.length != 0)
//	{
//		self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingString:@","];
//		for(int i = 0; i < [phoneNum count]; i++)
//	    {
//			self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
//		}
//	}
//	else
//	{
//		for(int i = 0; i < [phoneNum count]; i++)
//	    {
//			self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
//		}
//	}
//	[self dismissModalViewControllerAnimated:YES];
//    [[Custom_tabbar showTabBar] hideTabBar:YES];
//    
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}

#pragma mark MFMessageComposeViewController
- (void)giftSendSms:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
    [[RuYiCaiNetworkManager sharedManager] showMessage:[CommonRecordStatus commonRecordStatusManager].resultWarn withTitle:@"提示" buttonTitle:@"确定"];
}

//- (void)displaySMS:(NSString*)message
//{
//	MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
//	picker.messageComposeDelegate=self;
//	picker.navigationBar.tintColor= [UIColor redColor];
//	picker.body= message;// 默认信息内容
//	
//	// 默认收件人(可多个)
//	NSArray *numArray = [self.giftViewController.numTextView.text componentsSeparatedByString:@","]; 
//	picker.recipients = numArray;
//	
//	//picker.recipients = [NSArray arrayWithObjects:@"13161962673", nil];
//	[self presentModalViewController:picker animated:YES];
//	[picker release];
//}
//
//- (void)sendsms:(NSString*)message
//{
//	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//	NSLog(@"can send SMS [%d]", [messageClass canSendText]);
//	NSLog(@"infor:%@",message);
//	if(messageClass !=nil)
//	{
//		if([messageClass canSendText])
//		{
//            [self displaySMS:message];
//		}
//		else
//		{
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"设备没有短信功能" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            [self.navigationController popViewControllerAnimated:YES];
//		}
//	}
//	else
//	{
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"iOS版本过低，iOS4.0以上才支持程序内发送短信" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//	}
//}
//
//- (void)messageComposeViewController:(MFMessageComposeViewController*)controller
//                 didFinishWithResult:(MessageComposeResult)result 
//{
//	switch(result) {
//        case MessageComposeResultCancelled:
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"发送短信取消" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            break;
//        case MessageComposeResultSent:
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"短信已发送" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            break;
//        case MessageComposeResultFailed:
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"短信发送失败" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            break;
//        default:
//            break;
//    }
//    [self dismissModalViewControllerAnimated:YES];
//    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
//    
//    [[Custom_tabbar showTabBar] hideTabBar:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark textField and touch delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.fieldBeishu resignFirstResponder];
    if(self.normalBetScroll.center.y != 201)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.normalBetScroll.center;
        center.y += 100;
        self.normalBetScroll.center = center;
        [UIView commitAnimations];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%f", self.normalBetScroll.center.y);
    if(self.normalBetScroll.center.y != 99)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.normalBetScroll.center;
        center.y -= 100;
        self.normalBetScroll.center = center;
        [UIView commitAnimations];
    }
}

- (void)hideKeybord
{
    [self.fieldBeishu resignFirstResponder];
    if(self.normalBetScroll.center.y != 201)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.normalBetScroll.center;
        center.y += 100;
        self.normalBetScroll.center = center;
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i = 0; i < textField.text.length; i++)
    {
        UniChar chr = [textField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            self.fieldBeishu.text = @"1";
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            self.fieldBeishu.text = @"1";
        }
    }
    if([textField.text intValue] <= 0 || [textField.text intValue] > 200)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
        self.fieldBeishu.text = @"1";;
    }
    self.sliderBeishu.value = [self.fieldBeishu.text floatValue];
    
    int numBeishu = [self.fieldBeishu.text intValue];
    int aCount;
    if(!isNormalBet)
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    else
        aCount =  [fieldBeishu.text intValue] * (allCount/100);
    
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", aCount*aas];
            
 }

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSLog(@"tex %@", self.fieldBeishu.text);
//    if(self.fieldBeishu == textField)
//    {
//        self.fieldBeishu.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:self.fieldBeishu.text andLength:3];
//    }
////    [self textFieldDidEndEditing:self.fieldBeishu];
//
//    return YES;
//}



#pragma mark betCode method
- (void)buildBetCode
{
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);

    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    
    int aCount;
    int oneAmount;
    int oneBiAmount;//单笔金额
    if(!isNormalBet)
    {
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
        [RuYiCaiLotDetail sharedObject].oneAmount = @"300";
        oneAmount = 300;
        oneBiAmount = [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * 300;//普通投注
    }
    else
    {
        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
        [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
        oneAmount = 200;
        oneBiAmount = allCount;
    }
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", aCount * 100];  
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [RuYiCaiLotDetail sharedObject].amount;
    
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"0"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"4"])//普通投 模拟选号
    {
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].betCode stringByAppendingFormat:@"_%d_%d_%d", numBeishu, oneAmount, oneBiAmount];
    }
    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//机选 幸运选号
    {
        NSArray*  eachBetCode = [[RuYiCaiLotDetail sharedObject].betCode componentsSeparatedByString:@";"];
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
        for(int i = 0; i < [eachBetCode count]; i++)
        {
            NSString*  aStr;
            if(i != [eachBetCode count] -1)
            {
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%d_%d!", numBeishu, oneAmount, oneAmount];
            }
            else
            {
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%d_%d", numBeishu, oneAmount, oneAmount];
            }
            [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@", aStr];
        }
    }
    else //多注投
    {
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
        NSLog(@"%@", [RuYiCaiLotDetail sharedObject].moreBetCodeInfor);
        for(int i = 0; i < [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count]; i++)
        {   
            oneBiAmount = [[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_ZHUSHU] intValue] * [[RuYiCaiLotDetail sharedObject].oneAmount intValue];
            
            if(i != [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count] - 1)
                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d!",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti, [RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
            else
                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti,[RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
            NSLog(@"aaaa %@", [RuYiCaiLotDetail sharedObject].moreZuBetCode);
        }
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
        NSLog(@"safari:%@ ", allStr);
        
        NSString *strUrl = [allStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"检测不到网络" withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)betCompleteOK:(NSNotification*)notification
{
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 投注期号过期处理
- (void)betOutTime:(NSNotification*)notification
{
//    该期已过期
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"该期已过期" withTitle:@"错误" buttonTitle:@"确定"];

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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
            ExchangeLotteryWithIntegrationViewController* viewController = [[ExchangeLotteryWithIntegrationViewController alloc] init];
            viewController.isShowBackButton = YES;

            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
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

#pragma mark - customer Segmented delegate

-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self hideKeybord];
    [self.zhuiHaoViewController hideKeybord];
    [self.LaunchHMView hideKeybord];
    [self.giftViewController hideKeybord];
    
    switch (index) {
        case 0:
        {self.normalBetScroll.hidden = NO;
            self.zhuiHaoBetScroll.hidden = YES;
            self.HMBetScroll.hidden = YES;
            self.giftBetScroll.hidden = YES;
            [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            self.normalBetScroll.hidden = YES;
            self.zhuiHaoBetScroll.hidden = NO;
            self.HMBetScroll.hidden = YES;
            self.giftBetScroll.hidden = YES;
            [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        }
            
            break;
        case 2:
        {
            self.normalBetScroll.hidden = YES;
            self.zhuiHaoBetScroll.hidden = YES;
            self.HMBetScroll.hidden = NO;
            self.giftBetScroll.hidden = YES;
            [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            self.normalBetScroll.hidden = YES;
            self.zhuiHaoBetScroll.hidden = YES;
            self.HMBetScroll.hidden = YES;
            self.giftBetScroll.hidden = NO;
            [buyButton setTitle:@"立即赠送" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    if(self.segmented.segmentedIndex == 0)
    {
        
    }
    else if(self.segmented.segmentedIndex == 1)
    {
        
    }
    else if(self.segmented.segmentedIndex == 2)
    {
        
    }
    else
    {
        
    }
}

- (void)fqHeMaiLotOK:(NSNotification*)notification//合买成功弹出view
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSLog(@"合买成功之后的返回信息-------%@",[RuYiCaiNetworkManager sharedManager].responseText);
    
    self.dataDic = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    
    
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


- (void)queryCaseLotDetailOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    //    NSLog(@"合买详情-------%@",[RuYiCaiNetworkManager sharedManager].responseText);
    
    self.dataDic = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
}
@end
