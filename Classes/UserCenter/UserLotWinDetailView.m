//
//  UserLotWinDetailView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLotWinDetailView.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "BetLotDetailViewController.h"
#import "QueryLotWinViewController.h"
#import "NSLog.h"

@interface UserLotWinDetailView (internal)

- (void)viewAction:(id)sender;

@end

@implementation UserLotWinDetailView

@synthesize lotNo = m_lotNo;
@synthesize lotName = m_lotName;
@synthesize betCode = m_betCode;
@synthesize betCodeMsg = m_betCodeMsg;
@synthesize winAmount = m_winAmount;
@synthesize batchCode = m_batchCode;
@synthesize cashTime = m_cashTime;
@synthesize sellTime = m_sellTime;

@synthesize orderId = m_orderId;
@synthesize betNum = m_betNum;//注数
@synthesize lotMulti = m_lotMulti;
@synthesize cashAmount = m_cashAmount;
@synthesize winCode = m_winCode;

@synthesize supViewController = m_supViewController;

- (void)dealloc 
{
    [m_lotNameLabel release];
    [m_batchCodeLabel release];
    [m_cashTimeLabel release];
    [m_winAmountLabel release];
    [m_viewButton release];
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
        [bgImageView release];
        
        m_lotNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
        m_lotNameLabel.textAlignment = UITextAlignmentLeft;
        m_lotNameLabel.backgroundColor = [UIColor clearColor];
        m_lotNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lotNameLabel];
        
        m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 + 50, 10, 200, 20)];
        m_batchCodeLabel.textAlignment = UITextAlignmentLeft;
        m_batchCodeLabel.backgroundColor = [UIColor clearColor];
        m_batchCodeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_batchCodeLabel];
        
        m_cashTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 20)];
        m_cashTimeLabel.textAlignment = UITextAlignmentLeft;
        m_cashTimeLabel.backgroundColor = [UIColor clearColor];
        m_cashTimeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_cashTimeLabel];
        
        m_winAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        m_winAmountLabel.textAlignment = UITextAlignmentLeft;
        m_winAmountLabel.backgroundColor = [UIColor clearColor];
        m_winAmountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_winAmountLabel];
        
        m_viewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
        m_viewButton.frame = CGRectMake(220, 40, 90, 30);  
        [m_viewButton setTitle:@"查看详情" forState:UIControlStateNormal]; 
        [m_viewButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [m_viewButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
        m_viewButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];  
        [m_viewButton setBackgroundImage:[UIImage imageNamed:@"chasing_c_btn.png"] forState:UIControlStateNormal];  
		[m_viewButton setBackgroundImage:[UIImage imageNamed:@"chasing_c_click.png"] forState:UIControlStateHighlighted];  
        [m_viewButton addTarget:self action: @selector(viewAction:) forControlEvents:UIControlEventTouchUpInside];  
        [self addSubview:m_viewButton];
    }
    return self;
}

//- (void)viewAction:(id)sender
//{
////    NSString* message = @"";
////    if ([self.batchCode length] > 0) 
////    {
////        message = [NSString stringWithFormat:@"彩票种类: %@\n彩票期号: %@\n投注时间: %@\n结束时间: %@\n中奖金额: %@元\n注码: %@", self.lotName, self.batchCode, self.sellTime, self.cashTime, self.winAmount, self.betCodeMsg];
////    }
////    else
////    {
////        message = [NSString stringWithFormat:@"彩票种类: %@\n投注时间: %@\n结束时间: %@\n中奖金额: %@元\n注码: %@", self.lotName, self.sellTime, self.cashTime, self.winAmount, self.betCodeMsg];
////    }
////    [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"订单详情" buttonTitle:@"确定"];
//    NSMutableArray*  contentArr = [[NSMutableArray alloc] initWithCapacity:1];
//    if ([self.batchCode length] > 0) 
//    {
//        [contentArr addObject:[NSString stringWithFormat:@"%@   第%@期",self.lotName, self.batchCode]];
//    }
//    else
//    {
//        [contentArr addObject:[NSString stringWithFormat:@"%@",self.lotName]];
//    }
//    [contentArr addObject:@"订单号:"];
//    [contentArr addObject:self.orderId];
//    [contentArr addObject:@"投注时间:"];
//    [contentArr addObject:self.sellTime];
//    [contentArr addObject:@"兑奖时间:" ];
//    [contentArr addObject:self.cashTime];
//    [contentArr addObject:@"倍数:" ];
//    [contentArr addObject:[NSString stringWithFormat:@"%@倍", self.lotMulti]];
//    [contentArr addObject:@"注数:" ];
//    [contentArr addObject:[NSString stringWithFormat:@"%@注", self.betNum]];
//    [contentArr addObject:@"投注金额:"];
//    [contentArr addObject:[NSString stringWithFormat:@"%@元",self.cashAmount]];
//    if(self.winCode.length != 0)
//    {
//        [contentArr addObject:@"开奖号码:"];
//        [contentArr addObject:[NSString stringWithFormat:@"%@",self.winCode]];
//    }
//    [contentArr addObject:@"中奖金额:"];
//    [contentArr addObject:[NSString stringWithFormat:@"%@元", self.winAmount]];
//    [contentArr addObject:self.betCodeMsg];
//
//    [self.supViewController setHidesBottomBarWhenPushed:YES];
//    BetLotDetailViewController* viewController = [[BetLotDetailViewController alloc] init];
//    viewController.contentArray = contentArr;
//    viewController.navigationItem.title = @"中奖查询详情";
//    [self.supViewController.navigationController pushViewController:viewController animated:YES];
//    [contentArr release];
//    [viewController release];
//}
- (void)viewAction:(id)sender
{
    //    NSString* message = @"";
    //    if ([self.batchCode length] > 0)
    //    {
    //        message = [NSString stringWithFormat:@"彩票种类: %@\n彩票期号: %@\n投注时间: %@\n结束时间: %@\n中奖金额: %@元\n注码: %@", self.lotName, self.batchCode, self.sellTime, self.cashTime, self.winAmount, self.betCodeMsg];
    //    }
    //    else
    //    {
    //        message = [NSString stringWithFormat:@"彩票种类: %@\n投注时间: %@\n结束时间: %@\n中奖金额: %@元\n注码: %@", self.lotName, self.sellTime, self.cashTime, self.winAmount, self.betCodeMsg];
    //    }
    //    [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"订单详情" buttonTitle:@"确定"];
    NSMutableArray*  contentArr = [[NSMutableArray alloc] initWithCapacity:1];
    if ([self.batchCode length] > 0)
    {
        [contentArr addObject:[NSString stringWithFormat:@"%@   第%@期",self.lotName, self.batchCode]];
    }
    else
    {
        [contentArr addObject:[NSString stringWithFormat:@"%@",self.lotName]];
    }
    [contentArr addObject:@"订单号:"];
    [contentArr addObject:self.orderId];
    [contentArr addObject:@"投注时间:"];
    [contentArr addObject:self.sellTime];
    [contentArr addObject:@"兑奖时间:" ];
    [contentArr addObject:self.cashTime];
    [contentArr addObject:@"倍数:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@倍", self.lotMulti]];
    [contentArr addObject:@"注数:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@注", self.betNum]];
    [contentArr addObject:@"投注金额:"];
    [contentArr addObject:[NSString stringWithFormat:@"%@元",self.cashAmount]];
    if(self.winCode.length != 0)
    {
        [contentArr addObject:@"开奖号码:"];
        [contentArr addObject:[NSString stringWithFormat:@"%@",self.winCode]];
    }
    [contentArr addObject:@"中奖金额:"];
    [contentArr addObject:[NSString stringWithFormat:@"%@元", self.winAmount]];
    //    [contentArr addObject:self.betCodeMsg];
    
    [self.supViewController setHidesBottomBarWhenPushed:YES];
    BetLotDetailViewController* viewController = [[BetLotDetailViewController alloc] init];
    viewController.detailType = DETAILTYPEWIN;
    if ([self.lotNo isEqualToString:kLotNoJCLQ_SF] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_RF] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_SFC] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_DXF] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_CONFUSION] ||
        
        [self.lotNo isEqualToString:kLotNoJCZQ_ZJQ] ||
        [self.lotNo isEqualToString:kLotNoJCZQ_SCORE] ||
        [self.lotNo isEqualToString:kLotNoJCZQ_HALF] ||
        [self.lotNo isEqualToString:kLotNoJCZQ_RQ_SPF] ||
        [self.lotNo isEqualToString:kLotNoJCZQ_SPF] ||
        [self.lotNo isEqualToString:kLotNoJCZQ_CONFUSION] ||
        
        [self.lotNo isEqualToString:kLotNoJQC]||
        [self.lotNo isEqualToString:kLotNoSFC]||
        [self.lotNo isEqualToString:kLotNoRX9]||
        [self.lotNo isEqualToString:kLotNoLCB]||
        
        [self.lotNo isEqualToString:kLotNoBJDC_RQSPF]||
        [self.lotNo isEqualToString:kLotNoBJDC_JQS]||
        [self.lotNo isEqualToString:kLotNoBJDC_Score]||
        [self.lotNo isEqualToString:kLotNoBJDC_SXDS]
        )
    {
        viewController.showInTable = YES;
    }
    else
        viewController.showInTable = NO;
    viewController.lotNo = self.lotNo;
    viewController.orderId = self.orderId;
    viewController.contentArray = contentArr;
    viewController.navigationItem.title = @"中奖查询详情";
    viewController.isRepeatBuy = NO;
    [self.supViewController.navigationController pushViewController:viewController animated:YES];
    [contentArr release];
    [viewController release];
}
- (void)refreshView
{
    m_lotNameLabel.text = self.lotName;
    if ([self.batchCode length] > 0) {
        m_batchCodeLabel.text = [NSString stringWithFormat:@"(期号:%@)", self.batchCode];
    }
    else
    {
        m_batchCodeLabel.text = @"";
    }
    m_winAmountLabel.text = [NSString stringWithFormat:@"中奖金额: %@元", self.winAmount];
    m_cashTimeLabel.text =  self.sellTime;
}

@end
