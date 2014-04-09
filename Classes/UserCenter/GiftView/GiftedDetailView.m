//
//  GiftedDetailView.m
//  RuYiCai
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GiftedDetailView.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "BetLotDetailViewController.h"
#import "QueryGiftViewController.h"
#import "NSLog.h"

@interface GiftedDetailView (internal)

- (void)viewAction:(id)sender;

@end

@implementation GiftedDetailView

@synthesize toMobileId = m_toMobileId;
@synthesize orderTime = m_orderTime;
@synthesize cashAmount = m_cashAmount;
@synthesize batchCode = m_batchCode;
@synthesize lotMulti = m_lotMulti;
@synthesize betCodeMsg = m_betCodeMsg;
@synthesize lotNo = m_lotNo;
@synthesize lotName = m_lotName;
@synthesize playType = m_playType;
//@synthesize reciveState = m_reciveState;
@synthesize presentId = m_presentId;

@synthesize orderId = m_orderId;
@synthesize betNum = m_betNum;//注数
@synthesize stateMemo = m_stateMemo;

@synthesize winCode = m_winCode;

@synthesize supViewController = m_supViewController;

- (void)dealloc 
{
    [m_lotNameLabel release];
    [m_toMobileIdLabel release];
    [m_orderTimeLabel release];
    [m_amountLabel release];
    [m_viewButton release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
    {
        m_toMobileId = @"";
        m_orderTime = @"";
        m_cashAmount = @"";
        m_batchCode = @"";
        m_lotMulti = @"";
        m_betCodeMsg = @"";
        m_lotNo = @"";
        m_lotName = @"";
        m_playType = @"";
        m_presentId = @"";
        
        m_orderId = @"";
        m_betNum = @"";
        m_stateMemo = @"";
        m_winCode = @"";
        
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 70)];
        bgImageView.image = RYCImageNamed(@"kj_box_bg.png");
        [self addSubview:bgImageView];
        [bgImageView release];
        
        
        m_lotNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        m_lotNameLabel.textAlignment = UITextAlignmentLeft;
        m_lotNameLabel.backgroundColor = [UIColor clearColor];
        m_lotNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lotNameLabel];
        
        m_amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 90, 20)];
        m_amountLabel.textAlignment = UITextAlignmentLeft;
        m_amountLabel.backgroundColor = [UIColor clearColor];
        m_amountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_amountLabel];
        
        m_toMobileIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        m_toMobileIdLabel.textAlignment = UITextAlignmentLeft;
        m_toMobileIdLabel.backgroundColor = [UIColor clearColor];
        m_toMobileIdLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_toMobileIdLabel];
        
        m_orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 20)];
        m_orderTimeLabel.textAlignment = UITextAlignmentLeft;
        m_orderTimeLabel.backgroundColor = [UIColor clearColor];
        m_orderTimeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_orderTimeLabel];
        
//        m_reciveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
//        m_reciveButton.frame = CGRectMake(220, 15, 90, 30);  
//        //[m_reciveButton setTitle:@"查看详情" forState:UIControlStateNormal];  
//        [m_reciveButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
//        [m_reciveButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted]; 
//        m_reciveButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];  
//        [m_reciveButton setBackgroundImage:[UIImage imageNamed:@"main_btn_normal.png"] forState:UIControlStateNormal];  
//		[m_reciveButton setBackgroundImage:[UIImage imageNamed:@"main_btn_click.png"] forState:UIControlStateHighlighted];
//        [m_reciveButton addTarget:self action: @selector(reciveButtonClick:) forControlEvents:UIControlEventTouchUpInside];  
//        [self addSubview:m_reciveButton];
//        
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
//
//- (void)reciveButtonClick:(id)sender
//{
//    if([self.reciveState isEqualToString:@"0"])
//    {
//        [[RuYiCaiNetworkManager sharedManager] receiveLotterySecurity:self.presentId];
//    }
//    else
//    {
//        [m_reciveButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [m_reciveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    }
//}

- (void)viewAction:(id)sender
{
//    NSString* message = [NSString stringWithFormat:@"电话号码: %@\n赠彩时间: %@\n彩票金额: %@元\n彩票期号：%@\n倍数：%@\n彩种: %@\n注码:\n%@\n", 
//                         self.toMobileId, self.orderTime, self.cashAmount, self.batchCode, self.lotMulti, self.lotName, self.betCodeMsg];
//    [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"订单详情" buttonTitle:@"确定"];
    NSMutableArray*  contentArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    [contentArr addObject:[NSString stringWithFormat:@"%@   第%@期",self.lotName, self.batchCode]];
    [contentArr addObject:@"订单号:"];
    [contentArr addObject:self.orderId];
    [contentArr addObject:@"赠送人:"];
    [contentArr addObject:self.toMobileId];
    [contentArr addObject:@"赠彩时间:" ];
    [contentArr addObject:self.orderTime];
    [contentArr addObject:@"彩票金额:"];
    [contentArr addObject:[NSString stringWithFormat:@"%@元", self.cashAmount]];
    [contentArr addObject:@"倍数:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@倍",self.lotMulti]];
    [contentArr addObject:@"注数:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@注", self.betNum]];
    [contentArr addObject:@"出票状态:" ];
    [contentArr addObject:self.stateMemo];
    NSString* winNo;
    if([self.winCode isEqualToString:@""])
    {
        winNo = @"未开奖";
    }
    else
    {
        winNo = [NSString stringWithString:self.winCode];
    }
    [contentArr addObject:@"开奖号码:" ];
    [contentArr addObject:winNo];
    [contentArr addObject:self.betCodeMsg];
    [self.supViewController setHidesBottomBarWhenPushed:YES];
    BetLotDetailViewController* viewController = [[BetLotDetailViewController alloc] init];
    viewController.contentArray = contentArr;
    viewController.navigationItem.title = @"赠彩查询详情";
    [self.supViewController.navigationController pushViewController:viewController animated:YES];
    [contentArr release];
    [viewController release];
}

- (void)refreshView
{
    m_lotNameLabel.text = self.lotName;
    m_toMobileIdLabel.text = [NSString stringWithFormat:@"赠送人: %@", self.toMobileId];
    m_orderTimeLabel.text = [NSString stringWithFormat:@"时间: %@", self.orderTime];
    m_amountLabel.text = [NSString stringWithFormat:@"金额: %@元", self.cashAmount];
//    if([self.reciveState isEqualToString:@"0"])
//    {
//        [m_reciveButton setTitle:@"我要领取" forState:UIControlStateNormal];
//        [m_reciveButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
//        [m_reciveButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    }
//    else
//    {
//        [m_reciveButton setTitle:@"已领取" forState:UIControlStateNormal];
//        [m_reciveButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [m_reciveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    }
}

@end
