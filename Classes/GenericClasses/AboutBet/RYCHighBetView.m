//
//  RYCHighBetView.m
//  RuYiCai
//
//  Created by  on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RYCHighBetView.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiCommon.h"
#import "ShouYiLvSetViewController.h"
#import "AnimationTabView.h"
#import "ComputeShouYiLvListViewConreoller.h"
#import "NormalBetViewController.h"
#import "ZhuiHaoBetViewController.h"
#import "ChangeViewController.h"
#import "DirectPaymentViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "Exchange2LotteryWithIntegrationViewController.h"

#define kSegmentNormal    (0)
#define kSegmentZhuiHao   (1)
#define kSegmentShouYiLv  (2)

@implementation RYCHighBetView

@synthesize normalBetScroll;
@synthesize zhuiHaoBetScroll;
@synthesize shouYilvBetScroll;
@synthesize cusSegmented = _cusSegmented;
@synthesize animationTabView = m_animationTabView;
@synthesize shouYiLvViewController = m_shouYiLvViewController;
@synthesize normalBetViewController = m_normalBetViewController;
@synthesize zhuiHaoViewController = m_zhuiHaoViewController;

@synthesize buyButton;

- (void)dealloc
{
    [normalBetScroll release];
    [zhuiHaoBetScroll release];
    [shouYilvBetScroll release];
    [_cusSegmented release];
    [m_animationTabView release];
    [m_normalBetViewController release];
    [m_shouYiLvViewController release];
    [m_zhuiHaoViewController release];
    
    [buyButton release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"computeShouYiLvOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ZhuShuOut" object:nil];
    [super viewWillDisappear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(computeShouYiLvOK:) name:@"computeShouYiLvOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betOutTime:) name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZhuShuOut:) name:@"ZhuShuOut" object:nil];
    
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    self.zhuiHaoBetScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 162);
    self.shouYilvBetScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 162);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    
    //    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
    //                                             initWithTitle:@"返回"
    //                                             style:UIBarButtonItemStylePlain
    //                                             target:self
    //                                             action:@selector(back:)] autorelease];
    
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    //    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    //    [m_animationTabView.buttonNameArray addObject:@"投注"];
    //    [m_animationTabView.buttonNameArray addObject:@"追号"];
    //    if([RuYiCaiLotDetail sharedObject].isShouYiLv)
    //      [m_animationTabView.buttonNameArray addObject:@"收益率追号"];
    //    [m_animationTabView setMainButton];
    //    [self.view addSubview:m_animationTabView];
    
    
    
    //单投注
    NSLog(@"-----高频彩----单投注-------");

        self.cusSegmented = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(25, 5, 264, 30)
                                                          andNormalImages:[NSArray arrayWithObjects:
                                                                           @"segment_3_tz_nomarl.png",
                                                                           @"segment_3_zh_nomarl.png",
                                                                           @"segment_3_sylzh_normal.png",
                                                                           nil]
                                                     andHighlightedImages:[NSArray arrayWithObjects:
                                                                           @"segment_3_tz_nomarl.png",
                                                                           @"segment_3_zh_nomarl.png",
                                                                           @"segment_3_sylzh_normal.png",
                                                                           nil]
                                                           andSelectImage:[NSArray arrayWithObjects:
                                                                           @"segment_3_tz_click.png",
                                                                           @"segment_3_zh_click.png",
                                                                           @"segment_3_sylzh_click.png",
                                                                           nil]]autorelease];

    
    

    //多投注 判断是否有收益率投注
    if (![RuYiCaiLotDetail sharedObject].isShouYiLv) {

        NSLog(@"---高频彩----多投注---------");
        self.cusSegmented = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(25, 5, 264, 30)
                                                          andNormalImages:[NSArray arrayWithObjects:
                                                                           @"segment_high_bet_tz_nomarl.png",
                                                                           @"segment_high_bet_zh_nomarl.png",
                                                                           nil]
                                                     andHighlightedImages:[NSArray arrayWithObjects:
                                                                           @"segment_high_bet_tz_nomarl.png",
                                                                           @"segment_high_bet_zh_nomarl.png",
                                                                           nil]
                                                           andSelectImage:[NSArray arrayWithObjects:
                                                                           @"segment_high_bet_tz_click.png",
                                                                           @"segment_high_bet_zh_click.png",
                                                                           nil]]autorelease];
    }
    
    [self.cusSegmented setHidden:YES];
    self.cusSegmented.delegate = self;
    [self.view addSubview:_cusSegmented];
    
    [RuYiCaiLotDetail sharedObject].prizeend = @"1";
    
    m_normalBetViewController = [[NormalBetViewController alloc] init];
    m_normalBetViewController.view.frame = CGRectMake(0, 0, 320, 300);
    [self.normalBetScroll addSubview:m_normalBetViewController.view];
    self.normalBetScroll.contentSize = CGSizeMake(320, 318);
    
    m_zhuiHaoViewController = [[ZhuiHaoBetViewController alloc] init];
    m_zhuiHaoViewController.view.frame = CGRectMake(0, 0, 320, 696);
    [self.zhuiHaoBetScroll addSubview:m_zhuiHaoViewController.view];
    self.zhuiHaoBetScroll.contentSize = CGSizeMake(320, 696);
    
    m_shouYiLvViewController = [[ShouYiLvSetViewController alloc] init];
    m_shouYiLvViewController.view.frame = CGRectMake(0, 0, 320, 500);
    [self.shouYilvBetScroll addSubview:m_shouYiLvViewController.view];
    self.shouYilvBetScroll.contentSize = CGSizeMake(320, 400);
    
    self.zhuiHaoBetScroll.hidden = YES;
    self.shouYilvBetScroll.hidden = YES;
}

- (void)tabButtonChanged:(NSNotification*)notification
{
    [self.normalBetViewController hideKeybord];
    [self.zhuiHaoViewController hideKeybord];
    [self.shouYiLvViewController hideKeybord];
    
    if(self.cusSegmented.segmentedIndex == 0)
    {
        self.normalBetScroll.hidden = NO;
        self.zhuiHaoBetScroll.hidden = YES;
        self.shouYilvBetScroll.hidden = YES;
        
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(self.cusSegmented.segmentedIndex == 1)
    {
        self.normalBetScroll.hidden = YES;
        self.zhuiHaoBetScroll.hidden = NO;
        self.shouYilvBetScroll.hidden = YES;
        
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else
    {
        self.normalBetScroll.hidden = YES;
        self.zhuiHaoBetScroll.hidden = YES;
        self.shouYilvBetScroll.hidden = NO;
        
        [buyButton setTitle:@"计  算" forState:UIControlStateNormal];
    }
}

- (void)back:(id)sender
{
	if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//多注投 幸运选号
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

- (IBAction)buyClick:(id)sender
{
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].betCode);
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
    if (![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    
    [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    
    
    if(self.cusSegmented.segmentedIndex == kSegmentShouYiLv)
    {
        [self.normalBetViewController buildBetCode];
        [m_shouYiLvViewController okClick:nil];
        return;
    }
    else if (self.cusSegmented.segmentedIndex == kSegmentNormal)
    {
        if(![self.normalBetViewController normalBetCheck])
        {
            return;
        }
        //        [MobClick event:@"GPC_bet"];
        
        [self.normalBetViewController buildBetCode];
        [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    }
    else if(self.cusSegmented.segmentedIndex == kSegmentZhuiHao)
    {
        if(![self.zhuiHaoViewController zhuiHaoBetCheck])
        {
            return;
        }
        [self.zhuiHaoViewController buildBetCode];
    }
    
    if(([appStoreORnormal isEqualToString:@"appStore"] &&
        [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat))
        
    {
        if([self.normalBetViewController normalBetCheck])
        {
            [self.normalBetViewController buildBetCode];
            [self wapPageBuild];
        }
    }
    else
    {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
        [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单倍总金额（多注投)
        NSLog(@"%@",[NSString stringWithString: [RuYiCaiLotDetail sharedObject].amount]);
        [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithString: [RuYiCaiLotDetail sharedObject].amount];
        
        
        
        [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
    }
}

- (void)computeShouYiLvOK:(NSNotification*)notification
{
    [self setHidesBottomBarWhenPushed:YES];
    ComputeShouYiLvListViewConreoller* viewController =  [[ComputeShouYiLvListViewConreoller alloc] init];
    viewController.navigationItem.title = @"计算结果";
    NSString*  des = @"";
    if(self.shouYiLvViewController.isAllOrSome)
    {
        des = [NSString stringWithFormat:@"全程收益率%@%@", self.shouYiLvViewController.allShouField.text, @"%"];
    }
    else
    {
        des = [NSString stringWithFormat:@"前%@期收益率%@%@之后收益率%@%@", self.shouYiLvViewController.qianBatchField.text, self.shouYiLvViewController.qianBatchShouField.text, @"%", self.shouYiLvViewController.houBatchShouField.text, @"%"];
    }
    viewController.description = des;
    viewController.startBatchCode = [self.shouYiLvViewController.batchCodeButton currentTitle];
    viewController.batchNum = self.shouYiLvViewController.touRuBatchField.text;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


#pragma mark betCode method
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
}
#pragma mark 投注期号过期处理
- (void)betOutTime:(NSNotification*)notification
{
    
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSString class]])
    {
        [RuYiCaiLotDetail sharedObject].batchCode = (NSString*)obj;
        
        self.normalBetViewController.normalBet_batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
        self.zhuiHaoViewController.zhuiHao_batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
        [self.shouYiLvViewController.batchCodeButton setTitle:[RuYiCaiLotDetail sharedObject].batchCode forState:UIControlStateNormal];
        
        self.zhuiHaoViewController.isBatchCodeAdjust = YES;
        [self.zhuiHaoViewController batchCodeAdjust:nil];
        
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_SHOUYILV_BATCH;
        [[RuYiCaiNetworkManager sharedManager] getShouYiLvBatchList:[RuYiCaiLotDetail sharedObject].lotNo];
    }
    if (self.cusSegmented.segmentedIndex == kSegmentNormal)
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"尊敬的用户"
                                                             message:[NSString stringWithFormat:@"当前投注已转入下一期%@期，是否投注该新期？" ,(NSString*)obj]
                                                            delegate:self
                                                   cancelButtonTitle:@"返回"
                                                   otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"继续投注"];
        [alertView show];
        [alertView setTag:123];
        [alertView release];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"当前投注已转入下一期%@期" ,(NSString*)obj] withTitle:@"尊敬的用户" buttonTitle:@"确定"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if (self.cusSegmented.segmentedIndex == kSegmentNormal)
            {
                [self buyClick:nil];
            }
        }
        
    }
    else if(112 == alertView.tag)
    {
        if(1 == buttonIndex)//去充值
        {
            [RuYiCaiNetworkManager sharedManager].shouldTurnToAdWall = YES;
            [self.navigationController popToRootViewControllerAnimated:NO];
//            Exchange2LotteryWithIntegrationViewController* viewController = [[Exchange2LotteryWithIntegrationViewController alloc] init];
//            viewController.isShowBackButton = YES;
//
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
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

#pragma mark 投注余额不足处理
- (void)notEnoughMoney:(NSNotification*)notification
{
    //    switch (self.cusSegmented.segmentedIndex)
    //    {
    //        case kSegmentNormal:
    //        {
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
    
    //        }break;
    //        default:
    //            [[RuYiCaiNetworkManager sharedManager] showMessage:@"余额不足！" withTitle:@"提示" buttonTitle:@"确定"];
    //            break;
    //    }
}

#pragma mark - customerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    [self.normalBetViewController hideKeybord];
    [self.zhuiHaoViewController hideKeybord];
    [self.shouYiLvViewController hideKeybord];
    
    if(index == 0)
    {
        self.normalBetScroll.hidden = NO;
        self.zhuiHaoBetScroll.hidden = YES;
        self.shouYilvBetScroll.hidden = YES;
        
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(index == 1)
    {
        self.normalBetScroll.hidden = YES;
        self.zhuiHaoBetScroll.hidden = NO;
        self.shouYilvBetScroll.hidden = YES;
        
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else
    {
        self.normalBetScroll.hidden = YES;
        self.zhuiHaoBetScroll.hidden = YES;
        self.shouYilvBetScroll.hidden = NO;
        
        [buyButton setTitle:@"计  算" forState:UIControlStateNormal];
    }
}

@end
