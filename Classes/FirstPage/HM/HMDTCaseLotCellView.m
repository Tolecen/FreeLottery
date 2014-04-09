//
//  HMDTCaseLotCellView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HMDTCaseLotCellView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
//#import "SeeDetailViewController.h"
#import "HMDTQueryCaseLotViewController.h"
#import "HMDTBetCaseLotViewController.h"
#import "NSLog.h"

#define kMaxOffsetXOK (10)
#define kMaxOffsetYOK (10)

@implementation HMDTCaseLotCellView

@synthesize caseLotId = m_caseLotId;
@synthesize lotNo = m_lotNo;
@synthesize displayState = m_displayState;
//@synthesize displayStateMemo = m_displayStateMemo;
@synthesize amount = m_amount;
//@synthesize totalAmount = m_totalAmount;
//@synthesize saftAmount = m_saftAmount;
//@synthesize progressInfo = m_progressInfo;
@synthesize buyTime = m_buyTime;
//@synthesize contentInfo = m_contentInfo;
@synthesize prizeState = m_prizeState;
//@synthesize prizeAmount = m_prizeAmount;
//@synthesize winCode = m_winCode;
//@synthesize batchCode = m_batchCode;
@synthesize starter = m_starter;
@synthesize lotTitle = m_lotTitle;
@synthesize supViewController = m_supViewController;

- (void)dealloc
{
    [m_lotNoLabel release];
    [m_buyTimeLabel release];
    [m_stateLabel release];
    [m_starterLabel release];
    [m_amountLabel release];
    
    //    [m_lotTitle release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 60)];
        bgImageView.image = RYCImageNamed(@"kj_box_bg.png");
        [self addSubview:bgImageView];
        
        UIImageView *image_sanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(295, 23, 10, 14)];
        image_sanjiao.image = RYCImageNamed(@"sanjiao.png");
        [bgImageView addSubview:image_sanjiao];
        image_sanjiao.alpha = 0.7;
        [image_sanjiao release];
        [bgImageView release];
        
        m_lotNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        m_lotNoLabel.textAlignment = UITextAlignmentLeft;
        m_lotNoLabel.backgroundColor = [UIColor clearColor];
        m_lotNoLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lotNoLabel];
        
        m_stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 50, 20)];
        m_stateLabel.textAlignment = UITextAlignmentLeft;
        m_stateLabel.textColor = [UIColor redColor];
        m_stateLabel.backgroundColor = [UIColor clearColor];
        m_stateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_stateLabel];
        
        m_buyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 130, 20)];
        m_buyTimeLabel.textAlignment = UITextAlignmentLeft;
        m_buyTimeLabel.textColor = [UIColor brownColor];
        m_buyTimeLabel.backgroundColor = [UIColor clearColor];
        m_buyTimeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_buyTimeLabel];
        
        //        UILabel* noLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 30, 20)];
        //        noLabel.textAlignment = UITextAlignmentLeft;
        //        noLabel.text = @"编号:";
        //        noLabel.backgroundColor = [UIColor clearColor];
        //        noLabel.font = [UIFont systemFontOfSize:12];
        //        [self addSubview:noLabel];
        //        [noLabel release];
        
        m_starterLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 150, 20)];
        m_starterLabel.textAlignment = UITextAlignmentLeft;
        m_starterLabel.backgroundColor = [UIColor clearColor];
        m_starterLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_starterLabel];
        
        UILabel* buyAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 35, 75, 20)];
        buyAmtLabel.textAlignment = UITextAlignmentLeft;
        buyAmtLabel.text = @"认购金额：";
        buyAmtLabel.backgroundColor = [UIColor clearColor];
        buyAmtLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:buyAmtLabel];
        [buyAmtLabel release];
        
        m_amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 35, 80, 20)];
        m_amountLabel.textAlignment = UITextAlignmentLeft;
        //        m_amountLabel.contentMode =UIViewContentModeTop;
        //        m_amountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        m_amountLabel.numberOfLines = 2;
        m_amountLabel.textColor = [UIColor redColor];
        m_amountLabel.backgroundColor = [UIColor clearColor];
        m_amountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_amountLabel];
        
        //        m_lotTitle = [[NSString alloc] init];
    }
    return self;
}

- (void)refreshView
{
    if ([self.lotNo isEqualToString:kLotNoJCLQ_CONFUSION] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_SF] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_RF] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_SFC] ||
        [self.lotNo isEqualToString:kLotNoJCLQ_DXF]) {
        m_lotNoLabel.text = @"竞彩篮球";
    }
    else if([self.lotNo isEqualToString:kLotNoJCZQ_CONFUSION] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_RQ_SPF] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_SPF] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_ZJQ] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_SCORE] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_HALF])
    {
        m_lotNoLabel.text = @"竞彩足球";
    }
    else if( [self.lotNo isEqualToString:kLotNoBJDC_RQSPF]||
            [self.lotNo isEqualToString:kLotNoBJDC_JQS]||
            [self.lotNo isEqualToString:kLotNoBJDC_Score]||
            [self.lotNo isEqualToString:kLotNoBJDC_HalfAndAll]||
            [self.lotNo isEqualToString:kLotNoBJDC_SXDS])
    {
        m_lotNoLabel.text = @"北京单场";
    }
    else
        m_lotNoLabel.text = self.lotTitle;
    NSString* stateStr = @"";
    
    switch (self.displayState.length == 0 ? 0 : [self.displayState intValue])
    {
        case 1:
            stateStr = @"认购中";
            break;
        case 2:
            stateStr = @"满员";
            break;
        case 3:
        {
            if([self.prizeState isEqualToString:@"3"])
            {
                m_stateLabel.textColor = [UIColor grayColor];
                stateStr = @"未中奖";
            }
            else
                stateStr = @"成功";
        }break;
        case 4:
            stateStr = @"撤单";
            m_stateLabel.textColor = [UIColor grayColor];
            break;
        case 5:
            stateStr = @"流单";
            m_stateLabel.textColor = [UIColor grayColor];
            break;
        case 6:
            stateStr = @"已中奖";
            break;
        default:
            break;
    }
    m_stateLabel.text = [NSString stringWithFormat:@"(%@)", stateStr];
    m_buyTimeLabel.text = self.buyTime;
    m_starterLabel.text = [NSString stringWithFormat:@"发起人：%@", self.starter];
    m_amountLabel.text = [NSString stringWithFormat:@"%@元", self.amount];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    m_beganTouchPt = [[touches anyObject] locationInView:self];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGFloat xOffset = (pt.x > m_beganTouchPt.x) ? (pt.x - m_beganTouchPt.x) : (m_beganTouchPt.x - pt.x);
    CGFloat yOffset = (pt.y > m_beganTouchPt.y) ? (pt.y - m_beganTouchPt.y) : (m_beganTouchPt.y - pt.y);
    if (xOffset <= kMaxOffsetXOK && yOffset <= kMaxOffsetYOK)//移动距离不超过10
    {
        //        NSString* message = @"";
        //        message = [message stringByAppendingFormat:@"彩种: %@\n", self.lotTitle];
        //        message = [message stringByAppendingFormat:@"参与时间: %@\n", self.buyTime];
        //        message = [message stringByAppendingFormat:@"方案编号: %@\n", self.caseLotId];
        //        if(self.batchCode == (NSString*)[NSNull null] || [self.batchCode isEqualToString:@""])
        //        {
        //        }
        //        else
        //        {
        //            message = [message stringByAppendingFormat:@"期号: %@\n", self.batchCode];
        //        }
        //        message = [message stringByAppendingFormat:@"总额: %@元\n", self.totalAmount];
        //        if([self.displayStateMemo isEqualToString:@"已中奖"])
        //        {
        //            message = [message stringByAppendingFormat:@"中奖金额: %@元\n", self.prizeAmount];
        //        }
        //        message = [message stringByAppendingFormat:@"认购金额: %@元\n", self.amount];
        //        message = [message stringByAppendingFormat:@"保底金额: %@元\n", self.saftAmount];
        //        message = [message stringByAppendingFormat:@"进度: %@%@\n", self.progressInfo, @"%"];
        //        message = [message stringByAppendingFormat:@"结果: %@\n", self.displayStateMemo];
        //        if(![self.winCode isEqualToString:@""])
        //            message = [message stringByAppendingFormat:@"开奖号码: %@\n", self.winCode];
        //        message = [message stringByAppendingFormat:@"方案内容:\n%@", self.contentInfo];
        //        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"合买详情" buttonTitle:@"确定"];
        //        NSMutableArray*  contentArr = [[NSMutableArray alloc] initWithCapacity:1];
        //        if(self.batchCode == (NSString*)[NSNull null] || [self.batchCode isEqualToString:@""])
        //        {
        //             [contentArr addObject:[NSString stringWithFormat:@"%@",self.lotTitle]];
        //        }
        //        else
        //        {
        //            [contentArr addObject:[NSString stringWithFormat:@"%@   第%@期",self.lotTitle, self.batchCode]];
        //        }
        //        [contentArr addObject:@"参与时间:"];
        //        [contentArr addObject:self.buyTime];
        //        [contentArr addObject:@"方案编号:" ];
        //        [contentArr addObject:self.caseLotId];
        //        [contentArr addObject:@"总额:"];
        //        [contentArr addObject:[NSString stringWithFormat:@"%@元", self.totalAmount]];
        //        if([self.displayStateMemo isEqualToString:@"已中奖"])
        //        {
        //           [contentArr addObject:@"中奖金额:"];
        //           [contentArr addObject:[NSString stringWithFormat:@"%@元", self.prizeAmount]];
        //        }
        //        [contentArr addObject:@"认购金额:" ];
        //        [contentArr addObject:[NSString stringWithFormat:@"%@元", self.amount]];
        //        [contentArr addObject:@"保底金额:" ];
        //        [contentArr addObject:[NSString stringWithFormat:@"%@元", self.saftAmount]];
        //        [contentArr addObject:@"进度:" ];
        //        [contentArr addObject:[NSString stringWithFormat:@"%@％", self.progressInfo]];
        //        [contentArr addObject:@"结果:" ];
        //        [contentArr addObject:self.displayStateMemo];
        //        if(![self.winCode isEqualToString:@""])
        //        {
        //            [contentArr addObject:@"开奖号码:"];
        //            [contentArr addObject:[NSString stringWithFormat:@"%@", self.winCode]];
        //        }
        //        [contentArr addObject:self.contentInfo];
        //
        //        [self.supViewController setHidesBottomBarWhenPushed:YES];
        //        SeeDetailViewController* viewController = [[SeeDetailViewController alloc] init];
        //        viewController.contentArray = contentArr;
        //        viewController.navigationItem.title = @"合买详情";
        //        [self.supViewController.navigationController pushViewController:viewController animated:YES];
        //        [contentArr release];
        //        [viewController release];
        
        [self.supViewController setHidesBottomBarWhenPushed:YES];
        HMDTBetCaseLotViewController* viewController = [[HMDTBetCaseLotViewController alloc] init];
        viewController.isGotoAuto_OrderView = YES;
        viewController.caseLotId = self.caseLotId;
        viewController.lotNo = self.lotNo;
        //        viewController.batchCode = self.batchCode;
        viewController.prizeState = self.prizeState;//开奖表示
        viewController.winAmount = self.prizeAmount;//中奖金额
        viewController.isPushHid = YES;
        [self.supViewController.navigationController pushViewController:viewController animated:YES];
        if(![self.displayState isEqualToString:@"1"])//不是认购中
        {
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.1f];
        }
        [viewController release];
    }
}

- (void)delayMethod
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"displayStateOk" object:nil];
}

@end
