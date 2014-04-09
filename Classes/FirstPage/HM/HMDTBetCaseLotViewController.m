//
//  HMDTBetCaseLotViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-10-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HMDTBetCaseLotViewController.h"
#import "HMDTDetialZhanjiCell.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"

#import "SeeDetailTableViewCell.h"
#import "HMDTJoinPeopleTableCell.h"
#import "ShareSendViewController.h"
#import "TengXunSendViewController.h"
#import "OnlyHaveTextViewTableCell.h"
#import "NSLog.h"
#import "JC_SeeDetailTableViewCell.h"
#import "ZC_LCB_SeeDetailTableViewCell.h"
#import "ZC_SeeDetailTableViewCell.h"
#import "BetCompleteViewController.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define ButtonStartTag   (101)

@interface HMDTBetCaseLotViewController (internal)

- (void)setShareButton;
- (void)setTopView;
- (void)queryCaseLotDetailOK:(NSNotification*)notification;
- (void)betCaseLotLoginOK:(NSNotification*)notification;
- (void)betCaseLotOKClick:(NSNotification*)notification;
- (void)querySampleNetOK:(NSNotification*)notification;
- (void)CheDanNotification:(NSNotification*)notification;
- (void)quXiaoOK:(NSNotification*)notification;

- (void)okClick;
- (void)updateBuyAmtLabel;
//- (void)updateSafeAmtLabel;

- (void)shareButtonClick:(id)sender;
- (void)sinaButtonClick:(id)sender;
- (void)tengXunButtonClick:(id)sender;

- (void)queryCaseLotBuys;//参与合买人 查询
@end


@implementation HMDTBetCaseLotViewController

@synthesize topView = m_topView;
@synthesize starterUserNo = m_starterUserNo;
@synthesize buyAmtTextField = m_buyAmtTextField;
@synthesize safeAmtTextField = m_safeAmtTextField;

@synthesize totalAmt = m_totalAmt;
@synthesize caseLotId = m_caseLotId;
@synthesize buyAmt = m_buyAmt;
@synthesize safeAmt = m_safeAmt;
@synthesize minAmt = m_minAmt;
@synthesize cancelCaselot = m_cancelCaselot;
@synthesize lotName = m_lotName;
@synthesize lotNo = m_lotNo;
@synthesize batchCode = m_batchCode;
@synthesize endTime = m_endTime;
@synthesize winAmount = m_winAmount;
@synthesize prizeState = m_prizeState;

@synthesize myTableView = m_myTableView;
@synthesize titleButtonState = m_titleButtonState;
@synthesize dataDic = m_dataDic;
@synthesize joinDataArr = m_joinDataArr;
@synthesize isPushHid   = m_isPushHid;

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"displayStateOk" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryCaseLotDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCaseLotLoginOK" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCaseLotOKClick" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheDanNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"quXiaoOK" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [m_topView release];
    [m_buyAmtTextField release];
    [m_safeAmtTextField release];
    
    [m_myTableView release], m_myTableView = nil;
    [m_titleButtonState release], m_titleButtonState = nil;
    [m_joinDataArr release], m_joinDataArr = nil;
    
    [m_shareButton release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCaseLotDetailOK:) name:@"queryCaseLotDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCaseLotLoginOK:) name:@"betCaseLotLoginOK" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCaseLotOKClick:) name:@"betCaseLotOKClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CheDanNotification:) name:@"CheDanNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quXiaoOK:) name:@"quXiaoOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayStateOk:) name:@"displayStateOk" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"合买";
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"购买"];

    
    m_titleButtonState = [[NSMutableArray alloc] initWithObjects:@"1",@"1",@"0",@"0", nil];
    m_joinDataArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 148, 320, (int)([UIScreen mainScreen].bounds.size.height - 64 - 148)) style:UITableViewStyleGrouped];

    m_myTableView.contentInset = UIEdgeInsetsMake(145 - 148, 0, 0, 0);
    //    m_myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_myTableView];
    
    //    UITapGestureRecognizer *oneFingersOneTaps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingersOneTaps:)];
    //    [oneFingersOneTaps setNumberOfTapsRequired:1];
    //    [oneFingersOneTaps setNumberOfTouchesRequired:1];
    //    [self.myTableView addGestureRecognizer:oneFingersOneTaps];
    //    [oneFingersOneTaps release];//手势，会使表格忽略点击事件
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    //    [dict setObject:@"QueryLot" forKey:@"command"];
    //    [dict setObject:@"querycaselotdetail" forKey:@"type"];
    //    [dict setObject:self.caseLotId forKey:@"caseid"];
    //    [dict setObject:self.lotNo forKey:@"lotno"];
    //    if(self.batchCode)
    //       [dict setObject:self.batchCode forKey:@"batchcode"];
    
    [dict setObject:@"select" forKey:@"command"];
    [dict setObject:@"caseLotDetail" forKey:@"requestType"];
    [dict setObject:self.caseLotId forKey:@"id"];
    if(![CommonRecordStatus commonRecordStatusManager].remmberQuitStatus)
    {
        if(![[RuYiCaiNetworkManager sharedManager].userno isEqualToString:@""])
        {
            [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        }
    }
    [[RuYiCaiNetworkManager sharedManager] queryCaseLotDetail:dict];
    
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:5];
    [tempDic setObject:@"QueryLot" forKey:@"command"];
    [tempDic setObject:@"caseLotBuys" forKey:@"type"];
    [tempDic setObject:self.caseLotId forKey:@"caseid"];
    if(![CommonRecordStatus commonRecordStatusManager].remmberQuitStatus)
    {
        if(![[RuYiCaiNetworkManager sharedManager].userno isEqualToString:@""])
        {
            [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        }
    }
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:NO];//参与人员查询
    [self setTopView];
    
//    [self setShareButton];
    m_currentJoinDataPage = 0;
    
}

- (void)setShareButton
{
    m_shareButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 345, 314, 44)];
    [m_shareButton setBackgroundImage:RYCImageNamed(@"share_slider.png") forState:UIControlStateNormal];
    [m_shareButton setBackgroundImage:RYCImageNamed(@"share_slider.png") forState:UIControlStateHighlighted];
    [m_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    m_shareButton.center = CGPointMake(163 + 270, [UIScreen mainScreen].bounds.size.height - 113);
    [self.view addSubview:m_shareButton];
    
    UIButton*  xinLang = [[UIButton alloc] initWithFrame:CGRectMake(58, 7, 118, 30)];
    [xinLang setBackgroundImage:RYCImageNamed(@"sina.png") forState:UIControlStateNormal];
    [xinLang addTarget:self action:@selector(sinaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_shareButton addSubview:xinLang];
    [xinLang release];
    
    UIButton*  tengXun = [[UIButton alloc] initWithFrame:CGRectMake(186, 7, 118, 30)];
    [tengXun setBackgroundImage:RYCImageNamed(@"tengxun.png") forState:UIControlStateNormal];
    [tengXun addTarget:self action:@selector(tengXunButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_shareButton addSubview:tengXun];
    [tengXun release];
}

- (void)setTopView
{
    m_topView = [[UIView alloc] initWithFrame:CGRectMake(0, /*-143*/0, 320, 148)];
    self.view.backgroundColor = [UIColor clearColor];
    m_topView.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    //    UIImageView* imageC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 148)];
    //    imageC.image = RYCImageNamed(@"topinfo_bg.png");
    //    [m_topView addSubview:imageC];
    //    [imageC release];
    
    [self.view addSubview:m_topView];
    
    UIImageView *bgImg = tableBgImage(CGRectMake(9, 10, 302, 12), CGRectMake(9, 19, 302, 112), CGRectMake(9, 72, 302, 1));
    bgImg.frame = CGRectMake(0, 0, 320, 138);
    [self.topView addSubview:bgImg];
    
    UILabel* buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 21)];
    buyLabel.text = @"我要认购:                           元";
    buyLabel.font = [UIFont systemFontOfSize:14];
    buyLabel.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:buyLabel];
    [buyLabel release];
    
    m_buyAmtTextField = [[UITextField alloc] initWithFrame:CGRectMake(86, 35, 90, 31)];
    m_buyAmtTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_buyAmtTextField.borderStyle = UITextBorderStyleRoundedRect;
    m_buyAmtTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_buyAmtTextField.textColor = [UIColor blackColor];
    m_buyAmtTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.buyAmtTextField.text = @"0";
	self.buyAmtTextField.delegate = self;
	self.buyAmtTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.buyAmtTextField.returnKeyType = UIReturnKeyDone;
    [self.topView addSubview:m_buyAmtTextField];
    
    //    m_buyAmtRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 25, 95, 21)];
    //    m_buyAmtRatioLabel.text = @"占总额0％";
    //    m_buyAmtRatioLabel.font = [UIFont systemFontOfSize:14];
    //    m_buyAmtRatioLabel.backgroundColor = [UIColor clearColor];
    //    [self.topView addSubview:m_buyAmtRatioLabel];
    //
    //    m_leftBuyAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 50, 302, 21)];
    //    m_leftBuyAmtLabel.text = @"剩余0元可认购,至少认购0元";
    //    m_leftBuyAmtLabel.textAlignment = UITextAlignmentCenter;
    //    m_leftBuyAmtLabel.textColor = [UIColor redColor];
    //    m_leftBuyAmtLabel.font = [UIFont systemFontOfSize:14];
    //    m_leftBuyAmtLabel.backgroundColor = [UIColor clearColor];
    //    [self.topView addSubview:m_leftBuyAmtLabel];
    
    UILabel* safeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, 200, 21)];
    safeLabel.text = @"我要保底:                          元";
    safeLabel.font = [UIFont systemFontOfSize:14];
    safeLabel.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:safeLabel];
    [safeLabel release];
    
    m_safeAmtTextField = [[UITextField alloc] initWithFrame:CGRectMake(86 , 90, 90, 31)];
    m_safeAmtTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_safeAmtTextField.borderStyle = UITextBorderStyleRoundedRect;
    m_safeAmtTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_safeAmtTextField.textColor = [UIColor blackColor];
    m_safeAmtTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	self.safeAmtTextField.text = @"0";
	self.safeAmtTextField.delegate = self;
    self.safeAmtTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.safeAmtTextField.returnKeyType = UIReturnKeyDone;
    [self.topView addSubview:m_safeAmtTextField];
    
    //    m_safeAmtRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 90, 95, 21)];
    //    m_safeAmtRatioLabel.text = @"占总额0％";
    //    m_safeAmtRatioLabel.font = [UIFont systemFontOfSize:14];
    //    m_safeAmtRatioLabel.backgroundColor = [UIColor clearColor];
    //    [self.topView addSubview:m_safeAmtRatioLabel];
    //
    //    m_leftSafeAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 120, 206, 21)];
    //    m_leftSafeAmtLabel.text = @"剩余0元可保底";
    //    m_leftSafeAmtLabel.textAlignment = UITextAlignmentLeft;
    //    m_leftSafeAmtLabel.textColor = [UIColor redColor];
    //    m_leftSafeAmtLabel.font = [UIFont systemFontOfSize:14];
    //    m_leftSafeAmtLabel.backgroundColor = [UIColor clearColor];
    //    [self.topView addSubview:m_leftSafeAmtLabel];
}

- (void)queryCaseLotDetailOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    
    //    NSLog(@"合买详情-------%@",[RuYiCaiNetworkManager sharedManager].responseText);
    
    self.dataDic = (NSDictionary*)[parserDict objectForKey:@"result"];
    [jsonParser release];
    
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    
    self.totalAmt = KISDictionaryHaveKey(self.dataDic, @"totalAmt");
    self.caseLotId = KISDictionaryHaveKey(self.dataDic, @"caseLotId");
    self.safeAmt = KISDictionaryHaveKey(self.dataDic, @"safeAmt");
    self.buyAmt = KISDictionaryHaveKey(self.dataDic, @"hasBuyAmt");
    self.minAmt = KISDictionaryHaveKey(self.dataDic, @"minAmt");
    self.cancelCaselot = KISDictionaryHaveKey(self.dataDic, @"cancelCaselot");
    self.batchCode = KISDictionaryHaveKey(self.dataDic, @"batchCode");
    
	[self updateBuyAmtLabel];
    //	[self updateSafeAmtLabel];
    
    [self.myTableView reloadData];
}

- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    m_joinDataPageTotal = [KISDictionaryNullValue(parserDict, @"totalPage") intValue];
    //    [self.joinDataArr removeAllObjects];
    [self.joinDataArr addObjectsFromArray:[parserDict objectForKey:@"result"]];
    
    [self.myTableView reloadData];
}

- (BOOL)HMCheck
{
    for (int i = 0; i < m_buyAmtTextField.text.length; i++)
    {
        UniChar chr = [m_buyAmtTextField.text characterAtIndex:i];
        if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"认购金额须为整数" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    for (int i = 0; i < m_safeAmtTextField.text.length; i++)
    {
        UniChar chr = [m_safeAmtTextField.text characterAtIndex:i];
        //        if ('0' == chr && 0 == i)
        //        {
        //            [[RuYiCaiNetworkManager sharedManager] showMessage:@"保底金额填写不规范" withTitle:@"提示" buttonTitle:@"确定"];
        //            return NO;
        //        }
        if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"保底金额须为整数" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    return YES;
}

- (void)betCaseLotLoginOK:(NSNotification*)notification
{
    if (0 == m_buyAmtTextField.text.length || 0 == m_safeAmtTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"认购或保底金额不允许为空" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
	else if (0 ==[m_buyAmtTextField.text intValue] && 0 ==[m_safeAmtTextField.text intValue])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"认购和保底金额不允许都为零" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if(![self HMCheck])
        return;
    int totalValue = [self.totalAmt intValue] / 100;
    int buyAmtValue = [self.buyAmt intValue] / 100;
    int leftBuy = totalValue - buyAmtValue;
    if([self.buyAmtTextField.text intValue] > leftBuy || [self.safeAmtTextField.text intValue] > leftBuy)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"剩余可认购金额为：%d元", leftBuy] withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if([self.buyAmtTextField.text intValue] != 0 && leftBuy > [self.minAmt intValue]/100)
	{
		if ([self.buyAmtTextField.text intValue] < ([self.minAmt intValue] / 100))
		{
            [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"最低跟单为%d元", [self.minAmt intValue] / 100] withTitle:@"提示" buttonTitle:@"确定"];
			return;
		}
	}
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"betLot" forKey:@"command"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [dict setObject:@"betcase" forKey:@"bettype"];
    [dict setObject:self.caseLotId forKey:@"caseid"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [dict setObject:[NSString stringWithFormat:@"%d", [m_buyAmtTextField.text intValue] * 100] forKey:@"amount"];
	[dict setObject:[NSString stringWithFormat:@"%d", [m_safeAmtTextField.text intValue] * 100] forKey:@"safeAmt"];
    
    [[RuYiCaiNetworkManager sharedManager] betCaseLot:dict];
}

- (void)okClick
{
	[m_buyAmtTextField resignFirstResponder];
	[m_safeAmtTextField resignFirstResponder];
	
	if ([RuYiCaiNetworkManager sharedManager].hasLogin)
	{
		[self betCaseLotLoginOK:nil];
		
	}
	else
	{
		[RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BET_CASE_LOT_LOGIN;
		[[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
	}
}

- (void)updateBuyAmtLabel
{
	int totalValue = [self.totalAmt intValue] / 100;
	int buyAmtValue = [self.buyAmt intValue] / 100;
    //	int safeAmtValue = [self.safeAmt intValue] / 100;
	int leftBuy = totalValue - buyAmtValue;
    
    if(leftBuy <= [self.minAmt intValue]/100)
    {
        self.buyAmtTextField.text = [NSString stringWithFormat:@"%d",leftBuy];
    }
    else
    {
        self.buyAmtTextField.text = [NSString stringWithFormat:@"%d", [self.minAmt intValue]/100];
    }
    
    UILabel* buyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 150, 21)];
    buyLabel.text = [NSString stringWithFormat:@"可认购金额：%d元", leftBuy];
    buyLabel.textAlignment = UITextAlignmentLeft;
    buyLabel.textColor = [UIColor redColor];
    buyLabel.font = [UIFont systemFontOfSize:14];
    buyLabel.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:buyLabel];
    [buyLabel release];
    
    UILabel* minBuyLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 40, 95, 21)];
    minBuyLabel.text = [NSString stringWithFormat:@"(至少认购%d元)", [self.minAmt intValue] / 100 ];
    minBuyLabel.textAlignment = UITextAlignmentCenter;
    minBuyLabel.textColor = [UIColor redColor];
    minBuyLabel.font = [UIFont systemFontOfSize:14];
    minBuyLabel.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:minBuyLabel];
    [minBuyLabel release];
}

#pragma mark 分享

- (void)shareButtonClick:(id)sender
{
    //163 + 270
    [UIView beginAnimations:@"movement" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
    CGPoint buttonCenter = m_shareButton.center;
    if(buttonCenter.x != 163)
    {
        buttonCenter.x -= 270;
    }
    else
    {
        buttonCenter.x += 270;
    }
    m_shareButton.center = buttonCenter;
    [UIView commitAnimations];
}

- (void)sinaButtonClick:(id)sender
{
    ShareSendViewController* viewController = [[ShareSendViewController alloc] init];
    viewController.shareContent = [NSString stringWithFormat:@"#如意彩# 我在@如意彩 发现了“%@”发起的%@合买，花钱不多，中奖几率更大，快来跟单吧！详情：%@", [self.dataDic objectForKey:@"starter"], [self.dataDic objectForKey:@"lotName"], [self.dataDic objectForKey:@"url"]];
    viewController.title = @"新浪微博分享";
    viewController.XinLang_shareType = XL_SHARE_HM_CASE;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}

- (void)tengXunButtonClick:(id)sender
{
    TengXunSendViewController* viewController = [[TengXunSendViewController alloc] init];
    viewController.shareContent = [NSString stringWithFormat:@"#如意彩# 我在@如意彩 发现了“%@”发起的%@合买，花钱不多，中奖几率更大，快来跟单吧！详情：%@", [self.dataDic objectForKey:@"starter"], [self.dataDic objectForKey:@"lotName"], [self.dataDic objectForKey:@"url"]];
    viewController.title = @"腾讯微博分享";
    viewController.TengXun_shareType = TX_SHARE_HM_CASE;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark 撤单
- (void)CheDanNotification:(NSNotification*)notification
{
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:5];
    [tempDic setObject:@"betLot" forKey:@"command"];
    [tempDic setObject:@"cancelCaselot" forKey:@"bettype"];
    [tempDic setObject:self.caseLotId forKey:@"caseid"];
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_QUXIAO;
    [[RuYiCaiNetworkManager sharedManager] quXiaoNetRequest:tempDic];
}

- (void)quXiaoOK:(NSNotification*)notification//撤单成功，撤资成功
{
    //    [self betCaseLotOKClick:nil];
    if (m_isPushHid)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
	[self.navigationController popViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCurPage" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"撤销成功！" withTitle:@"提示" buttonTitle:@"确定"];
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//	if (m_buyAmtTextField == textField)
//	{
//		[self updateBuyAmtLabel];
//	}
//	else if (m_safeAmtTextField == textField)
//	{
//		[self updateSafeAmtLabel];
//	}
//}


- (void)betCaseLotOKClick:(NSNotification*)notification
{
    //	[self.navigationController popViewControllerAnimated:YES];
    //	[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCurPage" object:nil];
    
    [RuYiCaiLotDetail sharedObject].lotNo = self.lotNo;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", [m_buyAmtTextField.text intValue] * 100];
    [self setHidesBottomBarWhenPushed:YES];
    BetCompleteViewController* viewController = [[BetCompleteViewController alloc] init];
    viewController.viewType = TYPE_LAUNCHHM;
    viewController.allAmount = [NSString stringWithFormat:@"认购%@元＋保底%@元", self.buyAmtTextField.text, self.safeAmtTextField.text];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}

- (void)pressTitle:(id)sender
{
	UIButton *temp = (UIButton *)sender;
	int temptag = temp.tag - ButtonStartTag;
    if ([[self.titleButtonState objectAtIndex:temptag] isEqual: @"0"])
    {
        [self.titleButtonState replaceObjectAtIndex:temptag withObject:@"1"];
        
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateHighlighted];
    }
    else if([[self.titleButtonState objectAtIndex:temptag] isEqual: @"1"]){
        [self.titleButtonState replaceObjectAtIndex:temptag withObject:@"0"];
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateHighlighted];
    }
    [self.myTableView reloadData];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(2 == indexPath.section)
    {
        if(0 == indexPath.row)
        {
            NSString* lotno = KISDictionaryNullValue(self.dataDic, @"lotNo");
            if ([lotno isEqualToString:kLotNoJCLQ_SF] ||
                [lotno isEqualToString:kLotNoJCLQ_RF] ||
                [lotno isEqualToString:kLotNoJCLQ_SFC] ||
                [lotno isEqualToString:kLotNoJCLQ_DXF] ||
                [lotno isEqualToString:kLotNoJCLQ_CONFUSION] ||
                
                [lotno isEqualToString:kLotNoJCZQ_RQ_SPF] ||
                [lotno isEqualToString:kLotNoJCZQ_SPF] ||
                [lotno isEqualToString:kLotNoJCZQ_ZJQ] ||
                [lotno isEqualToString:kLotNoJCZQ_SCORE] ||
                [lotno isEqualToString:kLotNoJCZQ_HALF]||
                [lotno isEqualToString:kLotNoJCZQ_CONFUSION] ||
                
                [lotno isEqualToString:kLotNoSFC] ||
                [lotno isEqualToString:kLotNoJQC] ||
                [lotno isEqualToString:kLotNoRX9] ||
                [lotno isEqualToString:kLotNoLCB] ||
                
                [lotno isEqualToString:kLotNoBJDC_RQSPF] ||
                [lotno isEqualToString:kLotNoBJDC_JQS] ||
                [lotno isEqualToString:kLotNoBJDC_Score] ||
                [lotno isEqualToString:kLotNoBJDC_HalfAndAll] ||
                [lotno isEqualToString:kLotNoBJDC_SXDS]
                )
            {
                return 200;
            }
            else
                return 135;
        }
        
        else
            return 42;
    }
    else
        return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = ButtonStartTag + section;
    
    //0 隐藏 1-- 展开
    if([[self.titleButtonState objectAtIndex:section] isEqualToString:@"1"])
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 40)];
        image.image = [UIImage imageNamed:@"jclq_sectionlistexpand.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    else
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 40)];
        image.image = [UIImage imageNamed:@"jclq_sectionlisthide.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 25, 0, 0);
    switch (section)
    {
        case 0:
            [button setTitle:@"发起人信息" forState:UIControlStateNormal];
            break;
        case 1:
            [button setTitle:@"方案信息" forState:UIControlStateNormal];
            break;
        case 2:
            [button setTitle:@"方案内容" forState:UIControlStateNormal];
            break;
        case 3:
            [button setTitle:@"参与人员" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.titleButtonState objectAtIndex:section] isEqualToString:@"1"])
    {
        if(0 == section)
        {
            return 2;
        }
        else if(1 == section)
        {
            if([self.dataDic objectForKey:@"batchCode"] == [NSNull null] || [[self.dataDic objectForKey:@"batchCode"] isEqualToString:@""])
            {
                return 12;
            }
            else
                return 13;
        }
        else if(2 == section)
        {
            if([self.prizeState isEqualToString:@"3"])//开奖未中奖
            {
                if([[self.dataDic objectForKey:@"winCode"] isEqualToString:@""])//竞彩没有开奖号码
                    return 1;
                else
                    return 2;
            }
            else if([self.prizeState isEqualToString:@"4"] || [self.prizeState isEqualToString:@"5"])//中大奖或小奖
            {
                if([[self.dataDic objectForKey:@"winCode"] isEqualToString:@""])//竞彩没有开奖号码
                    return 2;
                else
                    return 3;
            }
            else//未开奖
                return 1;
        }
        else
        {
            if (m_joinDataPageTotal > 1) {
                NSLog(@"%d",[self.joinDataArr count]);
                return [self.joinDataArr count] + 1;
            }
            return [self.joinDataArr count];
        }
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 3)
    {
        static NSString *CellIdentifier = @"Cell";
        if (indexPath.row == [self.joinDataArr count]) {
            static NSString *lastCellIdentifier = @"lastCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];
            if(cell == nil)
            {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lastCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor blackColor];
            
            cell.textLabel.text = [NSString stringWithFormat:@"获取更多(第%d页，共%d页)",m_currentJoinDataPage + 1,m_joinDataPageTotal];
            return cell;
        }
        
        HMDTJoinPeopleTableCell *cell = (HMDTJoinPeopleTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[HMDTJoinPeopleTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.caseLotId = self.caseLotId;
        if(0 == indexPath.row)
        {
            UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
            writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
            [cell addSubview:writeImage];
            [writeImage release];
        }
        if ([self.joinDataArr count] > indexPath.row)
        {
            cell.nickName = KISNullValue(self.joinDataArr, indexPath.row, @"nickName");
            cell.state = KISNullValue(self.joinDataArr, indexPath.row, @"cancelCaselotbuy");
            cell.buyTime = KISNullValue(self.joinDataArr, indexPath.row, @"buyTime");
            cell.buyAmt = KISNullValue(self.joinDataArr, indexPath.row, @"buyAmt");
            cell.beState = KISNullValue(self.joinDataArr, indexPath.row, @"state");
            
            [cell refreshCell];
        }
        return cell;
    }
    else if(1 == indexPath.section || 0 == indexPath.section)
    {
        if(0 == indexPath.section)
        {
            switch (indexPath.row) {
                case 0:
                {
                    static NSString *CellIdentifiers = @"Cell_see1";
                    SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                    if (cell == nil) {
                        cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                    }
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                    writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    [cell addSubview:writeImage];
                    [writeImage release];
                    
                    cell.cellTitle = @"发起人：";
                    NSLog(@"合买 发起人：%@",[self.dataDic objectForKey:@"starter"]);
                    cell.cellDetailTitle = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"starter"]];
                    cell.isRedText = NO;
                    if([self.cancelCaselot isEqualToString:@"true"])
                        cell.hasButton = HMDT_CHEDAN_BUTTON;
                    
                    [cell refreshCell];
                    return cell;
                }
                case 1:
                {
                    //设置不可以进入定制跟单
                    /*
                     通过 CellIdentifiers 来控制 cell的定制跟单按钮
                     */
                    NSString *CellIdentifiers = @"";
                    if (self.isGotoAuto_OrderView || [[self.dataDic objectForKey:@"canAutoJoin"] isEqualToString:@"false"]) {
                        CellIdentifiers = @"Cells_removeOrder";
                    }
                    else
                        CellIdentifiers = @"Cells";
                    
                    HMDTDetialZhanjiCell *cell2 = (HMDTDetialZhanjiCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                    if (cell2 == nil) {
                        cell2 = [[[HMDTDetialZhanjiCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                    }
                    cell2.accessoryType = UITableViewCellAccessoryNone;
                    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell2.cellTitle = @"战  绩：";
                    cell2.superViewController = self;
                    NSDictionary* iconDict = [self.dataDic objectForKey:@"displayIcon"];
                    
                    cell2.graygoldStar = [KISDictionaryNullValue(iconDict, @"graygoldStar") intValue];
                    cell2.goldStar = [KISDictionaryNullValue(iconDict, @"goldStar") intValue];
                    cell2.diamond = [KISDictionaryNullValue(iconDict, @"diamond") intValue];
                    cell2.graydiamond = [KISDictionaryNullValue(iconDict, @"graydiamond") intValue];
                    cell2.graycup = [KISDictionaryNullValue(iconDict, @"graycup") intValue];
                    cell2.cup = [KISDictionaryNullValue(iconDict, @"cup") intValue];
                    cell2.graycrown = [KISDictionaryNullValue(iconDict, @"graycrown") intValue];
                    cell2.crown = [KISDictionaryNullValue(iconDict, @"crown") intValue];
                    
                    [cell2 refreshCell];
                    return cell2;
                }
            }
        }
        else if(1 == indexPath.section)
        {
            static NSString *CellIdentifiers = @"Cell_see2";
            SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
            if (cell == nil) {
                cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if([self.dataDic objectForKey:@"batchCode"] == [NSNull null] || [[self.dataDic objectForKey:@"batchCode"] isEqualToString:@""])//无期号
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                        [cell addSubview:writeImage];
                        [writeImage release];
                        
                        cell.cellTitle = @"彩种：";
                        cell.cellDetailTitle = KISDictionaryHaveKey(self.dataDic, @"lotName");
                        cell.isRedText = NO;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                    }
                    case 1:
                    {
                        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                        [cell addSubview:writeImage];
                        [writeImage release];
                        
                        cell.cellTitle = @"截止时间：";
                        cell.cellDetailTitle = [KISDictionaryHaveKey(self.dataDic, @"endTime") length] == 0 ? @"无" : KISDictionaryHaveKey(self.dataDic, @"endTime");
                        cell.isRedText = NO;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                    }
                    case 2:
                    {
                        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                        [cell addSubview:writeImage];
                        [writeImage release];
                        
                        cell.cellTitle = @"方案金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"totalAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                    }
                    case 3:
                        cell.cellTitle = @"方案编号：";
                        cell.cellDetailTitle = [self.dataDic objectForKey:@"caseLotId"];
                        cell.isRedText = NO;
                        break;
                    case 4:
                        cell.cellTitle = @"认购金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"hasBuyAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        break;
                    case 5:
                        cell.cellTitle = @"保底金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"safeAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        break;
                    case 6:
                        cell.cellTitle = @"方案进度：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%@%@", [self.dataDic objectForKey:@"buyProgress"], @"％"];
                        cell.isRedText = NO;
                        break;
                    case 7:
                        cell.cellTitle = @"方案状态：";
                        NSString* stateStr = @"";
                        switch ([KISDictionaryHaveKey(self.dataDic, @"displayState") length] == 0 ? 0 : [KISDictionaryHaveKey(self.dataDic, @"displayState") intValue])
                    {
                        case 1:
                            stateStr = @"认购中";
                            break;
                        case 2:
                            stateStr = @"满员";
                            break;
                        case 3:
                            if([self.prizeState isEqualToString:@"3"])
                                stateStr = @"未中奖";
                            else
                                stateStr = @"成功";
                            break;
                        case 4:
                            stateStr = @"撤单";
                            break;
                        case 5:
                            stateStr = @"流单";
                            break;
                        case 6:
                            stateStr = @"已中奖";
                            break;
                        default:
                            break;
                    }
                        cell.cellDetailTitle = stateStr;
                        cell.isRedText = NO;
                        break;
                    case 8:
                        cell.cellTitle = @"剩余金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"remainderAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        break;
                    case 9:
                        cell.cellTitle = @"参与人数：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%@人", [self.dataDic objectForKey:@"participantCount"]];
                        cell.isRedText = NO;
                        break;
                    case 10:
                        cell.cellTitle = @"发起人提成：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%@%@", [self.dataDic objectForKey:@"commisionRatio"], @"％"];
                        cell.isRedText = YES;
                        break;
                    case 11:
                        cell.cellTitle = @"方案描述：";
                        if([[self.dataDic objectForKey:@"description"] length] != 0)
                        {
                            cell.cellDetailTitle = [self.dataDic objectForKey:@"description"];
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        }
                        else
                        {
                            cell.cellDetailTitle = @"无";
                        }
                        cell.isRedText = NO;
                        break;
                    default:
                        break;
                }
            }
            else
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                        [cell addSubview:writeImage];
                        [writeImage release];
                        
                        cell.cellTitle = @"彩种：";
                        cell.cellDetailTitle = KISDictionaryHaveKey(self.dataDic, @"lotName");
                        cell.isRedText = NO;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                    }
                    case 1:
                    {
                        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                        [cell addSubview:writeImage];
                        [writeImage release];
                        
                        cell.cellTitle = @"截止时间：";
                        cell.cellDetailTitle = [KISDictionaryHaveKey(self.dataDic, @"endTime") length] == 0 ? @"无" : KISDictionaryHaveKey(self.dataDic, @"endTime");
                        cell.isRedText = NO;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                    }
                    case 2:
                    {
                        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                        [cell addSubview:writeImage];
                        [writeImage release];
                        
                        cell.cellTitle = @"方案金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"totalAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                    }
                    case 3:
                        cell.cellTitle = @"方案期号：";
                        if([self.dataDic objectForKey:@"batchCode"] == [NSNull null] || [[self.dataDic objectForKey:@"batchCode"] isEqualToString:@""])
                        {
                            cell.cellDetailTitle = @"无";
                        }
                        else
                            cell.cellDetailTitle = [NSString stringWithFormat:@"第%@期", [self.dataDic objectForKey:@"batchCode"]];
                        cell.isRedText = NO;
                        break;
                    case 4:
                        cell.cellTitle = @"方案编号：";
                        cell.cellDetailTitle = [self.dataDic objectForKey:@"caseLotId"];
                        cell.isRedText = NO;
                        break;
                    case 5:
                        cell.cellTitle = @"认购金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"hasBuyAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        break;
                    case 6:
                        cell.cellTitle = @"保底金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"safeAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        break;
                    case 7:
                        cell.cellTitle = @"方案进度：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%@%@", [self.dataDic objectForKey:@"buyProgress"], @"％"];
                        cell.isRedText = NO;
                        break;
                    case 8:
                        cell.cellTitle = @"方案状态：";
                        NSString* stateStr = @"";
                        switch ([KISDictionaryHaveKey(self.dataDic, @"displayState") length] == 0 ? 0 : [KISDictionaryHaveKey(self.dataDic, @"displayState") intValue])
                    {
                        case 1:
                            stateStr = @"认购中";
                            break;
                        case 2:
                            stateStr = @"满员";
                            break;
                        case 3:
                            if([self.prizeState isEqualToString:@"3"])
                                stateStr = @"未中奖";
                            else
                                stateStr = @"成功";
                            break;
                        case 4:
                            stateStr = @"撤单";
                            break;
                        case 5:
                            stateStr = @"流单";
                            break;
                        case 6:
                            stateStr = @"已中奖";
                            break;
                        default:
                            break;
                    }
                        cell.cellDetailTitle = stateStr;
                        cell.isRedText = NO;
                        break;
                    case 9:
                        cell.cellTitle = @"剩余金额：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%0.2lf元", [[self.dataDic objectForKey:@"remainderAmt"] doubleValue]/100];
                        cell.isRedText = YES;
                        break;
                    case 10:
                        cell.cellTitle = @"参与人数：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%@人", [self.dataDic objectForKey:@"participantCount"]];
                        cell.isRedText = NO;
                        break;
                    case 11:
                        cell.cellTitle = @"发起人提成：";
                        cell.cellDetailTitle = [NSString stringWithFormat:@"%@%@", [self.dataDic objectForKey:@"commisionRatio"], @"％"];
                        cell.isRedText = YES;
                        break;
                    case 12:
                        cell.cellTitle = @"方案描述：";
                        if([[self.dataDic objectForKey:@"description"] length] != 0)
                        {
                            cell.cellDetailTitle = [self.dataDic objectForKey:@"description"];
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        }
                        else
                        {
                            cell.cellDetailTitle = @"无";
                        }
                        cell.isRedText = NO;
                        break;
                    default:
                        break;
                }
            }
            cell.hasButton = NONE_BUTTON;
            
            [cell refreshCell];
            return cell;
        }
    }
    else
    {
        NSString* lotno = KISDictionaryNullValue(self.dataDic, @"lotNo");
        if(0 == indexPath.row)
        {
            if ([lotno isEqualToString:kLotNoJCLQ_SF] ||
                [lotno isEqualToString:kLotNoJCLQ_RF] ||
                [lotno isEqualToString:kLotNoJCLQ_SFC] ||
                [lotno isEqualToString:kLotNoJCLQ_DXF] ||
                [lotno isEqualToString:kLotNoJCLQ_CONFUSION]||
                
                [lotno isEqualToString:kLotNoJCZQ_RQ_SPF] ||
                [lotno isEqualToString:kLotNoJCZQ_SPF] ||
                [lotno isEqualToString:kLotNoJCZQ_ZJQ] ||
                [lotno isEqualToString:kLotNoJCZQ_SCORE] ||
                [lotno isEqualToString:kLotNoJCZQ_HALF] ||
                [lotno isEqualToString:kLotNoJCZQ_CONFUSION]||
                
                [lotno isEqualToString:kLotNoBJDC_RQSPF]||
                [lotno isEqualToString:kLotNoBJDC_JQS]||
                [lotno isEqualToString:kLotNoBJDC_Score]||
                [lotno isEqualToString:kLotNoBJDC_HalfAndAll]||
                [lotno isEqualToString:kLotNoBJDC_SXDS])//竞彩 北京单场
            {
                static NSString *myIdentifier = @"MyIdentifier_jc";
                NSDictionary* dic = [self.dataDic objectForKey:@"betCodeJson"];
                NSArray* resultArray = [dic objectForKey:@"result"];
                
                /*
                 计算 表格的高度，根据 我的投注内容多少来定
                 */
                int tableHeight = 0;
                if ([resultArray count] == 0) {
                    tableHeight = 180;
                }
                else
                {
                    for (int k = 0; k < [resultArray count]; k++) {
                        
                        NSString *betData= [NSString stringWithFormat:@"<p style=\"line-height:17px\"><font size = \"1.5\">%@</font></p>", KISNullValue(resultArray, k,@"betContentHtml")];
                        NSString* isDanMa = [KISNullValue(resultArray, k, @"isDanMa") isEqualToString:@"true"] ? @"<font color=\"brown\">(胆)</font>" : @"";
                        betData = [betData stringByAppendingString:isDanMa];
                        
                        CGSize betSize = [betData sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(98, 600)];
                        CGSize resultSize = [KISNullValue(resultArray, k,@"matchResult") sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(62, 600)];//赛果高度
                        int currentCellHeight = 0;
                        if (betSize.height > resultSize.height) {
                            currentCellHeight = betSize.height < 65 ? CellHeight : betSize.height;
                        }
                        else
                            currentCellHeight = resultSize.height < 65 ? CellHeight : resultSize.height;
                        
                        tableHeight += currentCellHeight;
                    }
                    tableHeight += 60;
                }
                if ([@"true" isEqualToString:[dic objectForKey:@"display"]])
                {
                    NSArray* wanFa_array = [KISNullValue(resultArray, 0, @"play") componentsSeparatedByString:@","];
                    tableHeight += 30 * ([wanFa_array count]/5);
                }
                JC_SeeDetailTableViewCell* jc = [[[JC_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, tableHeight)] autorelease];
                jc.contentStr = dic;
                jc.jc_lotNo = lotno;
                [jc setBackgroundColor:[UIColor whiteColor]];
                
                UIScrollView* scollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 195)] autorelease];
                [scollview addSubview:jc];
                scollview.contentSize =  CGSizeMake(300, tableHeight);
                [scollview setBackgroundColor:[UIColor whiteColor]];
                
                
                UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
                if (cell == nil)
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
                [cell.contentView addSubview:scollview];
                //            [scollview release];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else if([self.lotNo isEqualToString:kLotNoSFC] || [self.lotNo isEqualToString:kLotNoJQC] || [self.lotNo isEqualToString:kLotNoRX9] || [self.lotNo isEqualToString:kLotNoLCB])//足彩
            {
                static NSString *myIdentifier = @"MyIdentifier_ZC";
                NSDictionary* betCodeJson = [self.dataDic objectForKey:@"betCodeJson"];
                NSArray* resultArray;
                if ([[betCodeJson objectForKey:@"result"] count]>0)
                {
                   resultArray = [[[betCodeJson objectForKey:@"result"] objectAtIndex:0] objectForKey:@"result"];
                }else
                {
                    resultArray = nil;
                }
                //计算 表格的高度，根据 我的投注内容多少来定
                int tableHeight = 0;
                if ([resultArray count] == 0) {
                    tableHeight = 180;
                }
                else
                {
                    for (int k = 0; k < [resultArray count]; k++) {
                        tableHeight += zcCellHeight;
                    }
                    tableHeight += 80;
                }
                
                UIScrollView* scollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300, 195)] autorelease];
                scollview.contentSize =  CGSizeMake(300, tableHeight);
                [scollview setBackgroundColor:[UIColor whiteColor]];
                
                if([self.lotNo isEqualToString:kLotNoLCB] || [self.lotNo isEqualToString:kLotNoJQC])
                {
                    ZC_LCB_SeeDetailTableViewCell* zc_lcb = [[[ZC_LCB_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, tableHeight)] autorelease];
                    zc_lcb.contentStr = betCodeJson;
                    zc_lcb.isZC_JQC = NO;
                    if([self.lotNo isEqualToString:kLotNoJQC])
                    {
                        zc_lcb.isZC_JQC = YES;
                    }
                    [zc_lcb setBackgroundColor:[UIColor whiteColor]];
                    [scollview addSubview:zc_lcb];
                }
                else
                {
                    ZC_SeeDetailTableViewCell* zc = [[[ZC_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, tableHeight)] autorelease];
                    zc.contentStr = betCodeJson;
                    [zc setBackgroundColor:[UIColor whiteColor]];
                    [scollview addSubview:zc];
                }
                UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
                if (cell == nil)
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
                [cell.contentView addSubview:scollview];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else//普通彩种
            {
                static NSString *CellIdentifiers = @"normalCells";
                SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                if (cell == nil) {
                    cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                [cell addSubview:writeImage];
                [writeImage release];
                
                if(0 ==indexPath.row)
                {
                    cell.isWebView = YES;
                    cell.contentStr = KISDictionaryNullValue(self.dataDic, @"betCodeHtml");
                    [cell refreshCell];
                }
                return cell;
            }
        }
        else
        {
            if ([lotno isEqualToString:kLotNoJCLQ_SF] ||
                [lotno isEqualToString:kLotNoJCLQ_RF] ||
                [lotno isEqualToString:kLotNoJCLQ_SFC] ||
                [lotno isEqualToString:kLotNoJCLQ_DXF] ||
                [lotno isEqualToString:kLotNoJCLQ_CONFUSION]||
                
                [lotno isEqualToString:kLotNoJCZQ_RQ_SPF] ||
                [lotno isEqualToString:kLotNoJCZQ_SPF] ||
                [lotno isEqualToString:kLotNoJCZQ_ZJQ] ||
                [lotno isEqualToString:kLotNoJCZQ_SCORE] ||
                [lotno isEqualToString:kLotNoJCZQ_HALF] ||
                [lotno isEqualToString:kLotNoJCZQ_CONFUSION])//竞彩中奖金额
            {
                static NSString *CellIdentifiers_prizeAmt = @"prizeCells";
                SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers_prizeAmt];
                if (cell == nil) {
                    cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers_prizeAmt] autorelease];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                [cell addSubview:writeImage];
                [writeImage release];
                
                cell.cellTitle = @"中奖金额：";
                cell.cellDetailTitle = [NSString stringWithFormat:@"%@元", self.winAmount];
                cell.isRedText = YES;
                
                cell.hasButton = NONE_BUTTON;
                [cell refreshCell];
                return cell;
            }
            else
            {
                static NSString *CellIdentifiers = @"aiCells";
                SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                if (cell == nil) {
                    cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                [cell addSubview:writeImage];
                [writeImage release];
                
                if(1 == indexPath.row && ![[self.dataDic objectForKey:@"winCode"] isEqualToString:@""])
                {
                    cell.cellTitle = @"开奖号码：";
                    cell.cellDetailTitle = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"winCode"]];
                    cell.isRedText = YES;
                }
                else
                {
                    cell.cellTitle = @"中奖金额：";
                    cell.cellDetailTitle = [NSString stringWithFormat:@"%@元", self.winAmount];
                    cell.isRedText = YES;
                }
                cell.hasButton = NONE_BUTTON;
                
                [cell refreshCell];
                return cell;
            }
            
        }
    }
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 1)
    {
        NSInteger desRow;
        if([self.dataDic objectForKey:@"batchCode"] == [NSNull null] || [[self.dataDic objectForKey:@"batchCode"] isEqualToString:@""])
        {
            desRow = 11;
        }
        else
            desRow = 12;
        if(indexPath.row == desRow)
        {
            if([[self.dataDic objectForKey:@"description"] length] != 0)
                [[RuYiCaiNetworkManager sharedManager] showMessage:[self.dataDic objectForKey:@"description"] withTitle:@"" buttonTitle:@"确定"];
        }
    }
    if ([indexPath section] == 3 && indexPath.row == [self.joinDataArr count]) {
        //        发送请求
        if (m_currentJoinDataPage + 1 < m_joinDataPageTotal) {
            m_currentJoinDataPage++;
            [self queryCaseLotBuys];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)queryCaseLotBuys//参与合买人 查询
{
    
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:5];
    [tempDic setObject:@"QueryLot" forKey:@"command"];
    [tempDic setObject:@"caseLotBuys" forKey:@"type"];
    [tempDic setObject:self.caseLotId forKey:@"caseid"];
    [tempDic setObject:[NSNumber numberWithInt:m_currentJoinDataPage] forKey:@"pageindex"];
    [tempDic setObject:@"10" forKey:@"maxresult"];
    if(![CommonRecordStatus commonRecordStatusManager].remmberQuitStatus)
    {
        if(![[RuYiCaiNetworkManager sharedManager].userno isEqualToString:@""])
        {
            [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        }
    }
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
    NSLog(@"%@",tempDic);
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];//参与人员查询
}

- (void)back:(id)sender
{
    if (m_isPushHid)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }else
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayStateOk:(NSNotification*)notification
{
    self.myTableView.frame = CGRectMake(0, 0, 320, (int)([UIScreen mainScreen].bounds.size.height - 64));
    self.navigationItem.rightBarButtonItem = nil;
    
    self.topView.hidden = YES;
}
#pragma mark 手势
//- (void)oneFingersOneTaps:(UITapGestureRecognizer *)gestureRecognizer
//{
//}
@end