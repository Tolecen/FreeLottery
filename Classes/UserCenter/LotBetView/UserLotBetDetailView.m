//
//  UserLotBetDetailView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLotBetDetailView.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "RuYiCaiLotDetail.h"
#import "BetLotDetailViewController.h"
#import "QueryLotBetViewController.h"

@interface UserLotBetDetailView (internal)

//- (void)againBetClick:(id)sender;
- (void)viewAction:(id)sender;

@end

@implementation UserLotBetDetailView

@synthesize lotNo = m_lotNo;
@synthesize lotName = m_lotName;
@synthesize betCode = m_betCode;
//@synthesize betCodeHtmlMsg = m_betCodeHtmlMsg;
//@synthesize betCodeMsg = m_betCodeMsg;
@synthesize cashAmount = m_cashAmount;
@synthesize winCode = m_winCode;
@synthesize prizeAmount = m_prizeAmount;
@synthesize batchCode = m_batchCode;
@synthesize lotMulti = m_lotMulti;
//@synthesize playType = m_playType;
@synthesize orderTime = m_orderTime;
@synthesize isRepeatBuy = m_isRepeatBuy;
@synthesize prizeState = m_prizeState;

@synthesize orderId = m_orderId;
@synthesize betNum = m_betNum;//注数
@synthesize stateMemo = m_stateMemo;
@synthesize oneAmount = m_oneAmount;
//@synthesize betCodeJson = m_betCodeJson;
@synthesize showInTable = m_showInTable;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [m_lotNameLabel release];
    [m_batchCodeLabel release];
    [m_cashAmountLabel release];
    [m_prizeAmountLabel release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 70)];
        bgImageView.image = RYCImageNamed(@"kj_box_bg.png");
        [self addSubview:bgImageView];
        
        UIImageView *image_sanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(295, 28, 10, 14)];
        image_sanjiao.image = RYCImageNamed(@"sanjiao.png");
        [bgImageView addSubview:image_sanjiao];
        image_sanjiao.alpha = 0.7;
        [image_sanjiao release];
        
        [bgImageView release];
        
        m_lotNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        m_lotNameLabel.textAlignment = UITextAlignmentLeft;
        m_lotNameLabel.backgroundColor = [UIColor clearColor];
        m_lotNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lotNameLabel];
        
        m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 200, 20)];
        m_batchCodeLabel.textAlignment = UITextAlignmentLeft;
        m_batchCodeLabel.backgroundColor = [UIColor clearColor];
        m_batchCodeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_batchCodeLabel];
        
        m_cashAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        m_cashAmountLabel.textAlignment = UITextAlignmentLeft;
        m_cashAmountLabel.backgroundColor = [UIColor clearColor];
        m_cashAmountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_cashAmountLabel];
        
        m_prizeAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 20)];
        m_prizeAmountLabel.textAlignment = UITextAlignmentLeft;
        m_prizeAmountLabel.backgroundColor = [UIColor clearColor];
        m_prizeAmountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_prizeAmountLabel];
        
        //        m_againBet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        m_againBet.frame = CGRectMake(220, 10, 90, 25);
        //        [m_againBet setTitle:@"再投一次" forState:UIControlStateNormal];
        //        [m_againBet setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        //        [m_againBet setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
        //        m_againBet.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        //        [m_againBet setBackgroundImage:[UIImage imageNamed:@"main_btn_normal.png"] forState:UIControlStateNormal];
        //		[m_againBet setBackgroundImage:[UIImage imageNamed:@"main_btn_click.png"] forState:UIControlStateHighlighted];
        //        [m_againBet addTarget:self action: @selector(againBetClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [self addSubview:m_againBet];
        
        
        UIButton* viewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        //        viewButton.frame = CGRectMake(220, 45, 90, 25);
        [viewButton addTarget:self action: @selector(viewAction:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:viewButton];
        [viewButton release];
    }
    return self;
}

- (void)viewAction:(id)sender
{
    //再投一次数据
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = self.betCode;
    [RuYiCaiLotDetail sharedObject].lotMulti = self.lotMulti;
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%d", ([self.cashAmount intValue])/([self.lotMulti intValue])*100];
    [RuYiCaiLotDetail sharedObject].oneAmount = self.oneAmount;
    
    NSMutableArray*  contentArr = [[NSMutableArray alloc] initWithCapacity:1];
    if([self.batchCode isEqualToString:@""])//没有期号
    {
        [contentArr addObject:[NSString stringWithFormat:@"%@",self.lotName]];
    }
    else
    {
        [contentArr addObject:[NSString stringWithFormat:@"%@   第%@期",self.lotName, self.batchCode]];
    }
    
    [contentArr addObject:@"订单号:"];
    [contentArr addObject:self.orderId];
    [contentArr addObject:@"倍数:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@倍", self.lotMulti]];
    [contentArr addObject:@"注数:"];
    [contentArr addObject:[NSString stringWithFormat:@"%@注",self.betNum]];
    [contentArr addObject:@"付款金额:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@元",self.cashAmount]];
    [contentArr addObject:@"中奖金额:"];
    [contentArr addObject:self.prizeAmount];
    [contentArr addObject:@"出票状态:"];
    [contentArr addObject:self.stateMemo];
    [contentArr addObject:@"购买时间:"];
    [contentArr addObject:self.orderTime];
    if(0 != self.winCode.length)//有开奖号码
    {
        [contentArr addObject:@"开奖号码:"];
        [contentArr addObject:self.winCode];
    }
    //    [contentArr addObject:self.betCodeHtmlMsg];
    
    BetLotDetailViewController* viewController = [[BetLotDetailViewController alloc] init];
    viewController.detailType = DETAILTYPEBET;
    viewController.showInTable = self.showInTable;
    viewController.lotNo = self.lotNo;
    viewController.orderId = self.orderId;
    //    viewController.winNum = self.prizeAmount;
    viewController.amountCount = self.cashAmount;
    viewController.isRepeatBuy = [self.isRepeatBuy isEqualToString:@"true"] ? YES : NO;
    viewController.navigationItem.title = @"投注查询详情";
    viewController.contentArray = contentArr;
    QueryLotBetViewController *supViewController = (QueryLotBetViewController *)_delegate;
    [supViewController.navigationController pushViewController:viewController animated:YES];
    [contentArr release];
    [viewController release];
}

- (void)refreshView
{
    m_lotNameLabel.text = self.lotName;
    if(![self.batchCode isEqualToString:@""])//没有期号
    {
        m_batchCodeLabel.text = [NSString stringWithFormat:@"期号: %@", self.batchCode];
    }
    m_cashAmountLabel.text = [NSString stringWithFormat:@"付款金额: %@元", self.cashAmount];
    if([self.prizeState isEqualToString:@"0"])
    {
        self.prizeAmount = @"未开奖";
        m_prizeAmountLabel.textColor = [UIColor brownColor];
        m_prizeAmountLabel.text = [NSString stringWithFormat:@"%@", self.prizeAmount];
    }
    else if([self.prizeState isEqualToString:@"3"])
    {
        self.prizeAmount = @"未中奖";
        m_prizeAmountLabel.textColor = [UIColor grayColor];
        m_prizeAmountLabel.text = [NSString stringWithFormat:@"%@", self.prizeAmount];
    }
    else
    {
        m_prizeAmountLabel.textColor = [UIColor redColor];
        self.prizeAmount = [NSString stringWithFormat:@"%@元", self.prizeAmount];
        m_prizeAmountLabel.text = [NSString stringWithFormat:@"中奖金额: %@", self.prizeAmount];
    }
    //    if(![self.isRepeatBuy isEqualToString:@"true"])
    //    {
    //        [m_againBet setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //        [m_againBet setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //    }
}
/*
 - (void)againBetClick:(id)sender
 {
 if([self.isRepeatBuy isEqualToString:@"true"])
 {
 //        [RuYiCaiLotDetail sharedObject].batchNum = [NSString stringWithString:@"1"];
 //        [RuYiCaiLotDetail sharedObject].betCode = self.betCode;
 //        [RuYiCaiLotDetail sharedObject].lotNo = self.lotNo;
 //        [RuYiCaiLotDetail sharedObject].lotMulti = self.lotMulti;
 //        [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", [self.cashAmount intValue] * 100];
 //        [RuYiCaiLotDetail sharedObject].betType = @"bet";
 //        [RuYiCaiLotDetail sharedObject].batchCode = @"";//期号
 //        [RuYiCaiLotDetail sharedObject].prizeend = @"";
 
 //        NSString* message = [NSString stringWithFormat:@"彩票种类: %@\n投注金额: %@元\n注码:\n%@", self.lotName, self.cashAmount, self.betCodeMsg];
 //
 //
 //        UIAlertView *betView = [[UIAlertView alloc] initWithTitle:@"投注详情"
 //                                                          message:message
 //                                                         delegate:self
 //                                                cancelButtonTitle:@"取消"
 //                                                otherButtonTitles:nil];
 //        [betView addButtonWithTitle:@"确定"];
 //        [betView show];
 //        [betView release];
 
 [MobClick event:@"userPage_again_bet"];
 //初始化值
 [RuYiCaiLotDetail sharedObject].moreZuBetCode = self.betCode;
 [RuYiCaiLotDetail sharedObject].lotNo = self.lotNo;
 //        [RuYiCaiLotDetail sharedObject].lotMulti = self.lotMulti;
 //        [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%d", ([self.cashAmount intValue])/([self.lotMulti intValue])*100];
 [RuYiCaiLotDetail sharedObject].betType = @"bet";
 [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
 
 [RuYiCaiLotDetail sharedObject].batchNum = [NSString stringWithFormat:@"%@", @"1"];
 [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", [self.cashAmount intValue] * 100];
 [RuYiCaiLotDetail sharedObject].batchCode = @"";//期号
 [RuYiCaiLotDetail sharedObject].prizeend = @"";
 [RuYiCaiLotDetail sharedObject].oneAmount = self.oneAmount;
 
 //跳转页面
 [self.supViewController setHidesBottomBarWhenPushed:YES];
 AgainLotBetViewController* viewController = [[AgainLotBetViewController alloc] init];
 viewController.lotNo = self.lotNo;
 viewController.lotName = self.lotName;
 //        viewController.amount = [NSString stringWithFormat:@"%d", ([self.cashAmount intValue])/([self.lotMulti intValue])];
 //        viewController.contentStr = self.betCodeMsg;
 viewController.navigationItem.title = @"再买一次";
 [self.supViewController.navigationController pushViewController:viewController animated:YES];
 [viewController release];
 
 }
 else
 {
 [m_againBet setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
 [m_againBet setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
 }
 }*/


@end