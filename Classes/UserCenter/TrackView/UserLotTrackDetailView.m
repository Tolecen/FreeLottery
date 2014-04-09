    //
//  UserLotTrackDetailView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLotTrackDetailView.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "TrackDetailViewController.h"
#import "QueryLotTrackViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "AgainTrackViewController.h"
#import "NSLog.h"

@interface UserLotTrackDetailView (internal)

- (void)stopTrack:(id)sender;
- (void)viewAction:(id)sender;
- (void)againTrack:(id)sender;

- (void)cancelAgainTrackClick:(id)sender;
- (void)submitAgainTrackClick:(id)sender;


@end

@implementation UserLotTrackDetailView

@synthesize idNo = m_idNo;
@synthesize lotNo = m_lotNo;
@synthesize lotName = m_lotName;
@synthesize betCode = m_betCode;
@synthesize betCodeMsg = m_betCodeMsg;
@synthesize batchNum = m_batchNum;
@synthesize lastNum = m_lastNum;
@synthesize beginBatch = m_beginBatch;
@synthesize betNum = m_betNum;
@synthesize cashAmount = m_cashAmount;
@synthesize stateType = m_state;
@synthesize orderTime = m_orderTime;
@synthesize prizeEnd = m_prizeEnd;
@synthesize lotMulti = m_lotMulti;
@synthesize isRepeatBuy = m_isRepeatBuy;
@synthesize oneAmount = m_oneAmount;

@synthesize supViewController = m_supViewController;

- (void)dealloc 
{
    [m_lotNameLabel release];
    [m_stateLabel release];
    [m_batchNumLabel release];
    [m_cashAmountLabel release];
    [m_lastNumLabel release];
	[m_stopButton release];
    [m_viewButton release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
    {
        m_idNo = @""; 
        m_lotNo = @"";
        m_lotName = @"";
        m_betCode = @"";
        m_betCodeMsg = @"";
        m_batchNum = @"";
        m_lastNum = @"";
        m_beginBatch = @"";
        m_betNum = @"";
        m_cashAmount = @"";
        m_state = @"";
        m_orderTime = @"";
        m_lotMulti = @"";
        m_prizeEnd = @"";
        m_oneAmount = @"";
        
        m_isRepeatBuy = @"";
        
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 80)];
        bgImageView.image = RYCImageNamed(@"kj_box_bg.png");
        [self addSubview:bgImageView];
        [bgImageView release];
        
        m_lotNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        m_lotNameLabel.textAlignment = UITextAlignmentLeft;
        m_lotNameLabel.backgroundColor = [UIColor clearColor];
        m_lotNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lotNameLabel];
        
        m_stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 100, 20)];
        m_stateLabel.textAlignment = UITextAlignmentLeft;
        m_stateLabel.backgroundColor = [UIColor clearColor];
        m_stateLabel.textColor = [UIColor redColor];
        m_stateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_stateLabel];
        
        m_batchNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 200, 20)];
        m_batchNumLabel.textAlignment = UITextAlignmentLeft;
        m_batchNumLabel.backgroundColor = [UIColor clearColor];
        m_batchNumLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_batchNumLabel];
        
        m_cashAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        m_cashAmountLabel.textAlignment = UITextAlignmentLeft;
        m_cashAmountLabel.backgroundColor = [UIColor clearColor];
        m_cashAmountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_cashAmountLabel];
        
        m_lastNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 110, 20)];
        m_lastNumLabel.textAlignment = UITextAlignmentLeft;
        m_lastNumLabel.backgroundColor = [UIColor clearColor];
        m_lastNumLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lastNumLabel];
        
		m_stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
        m_stopButton.frame = CGRectMake(210, 30, 90, 25);  
		m_stopButton.enabled = YES;
		[m_stopButton setTitle:@"取消追期" forState:UIControlStateNormal];
        [m_stopButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [m_stopButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];              
        m_stopButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];  
        [m_stopButton setBackgroundImage:[UIImage imageNamed:@"chasing_c_btn.png"] forState:UIControlStateNormal];  
		[m_stopButton setBackgroundImage:[UIImage imageNamed:@"chasing_c_click.png"] forState:UIControlStateHighlighted]; 
        [m_stopButton addTarget:self action: @selector(stopTrack:) forControlEvents:UIControlEventTouchUpInside];  
        [self addSubview:m_stopButton];
        m_stopButton.hidden = YES;
		
        m_againButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
        m_againButton.frame = CGRectMake(210, 30, 90, 25);  
		m_againButton.enabled = YES;
		[m_againButton setTitle:@"继续追期" forState:UIControlStateNormal];
        [m_againButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [m_againButton setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];              
        m_againButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];  
        [m_againButton setBackgroundImage:[UIImage imageNamed:@"chasing_c_btn.png"] forState:UIControlStateNormal];  
		[m_againButton setBackgroundImage:[UIImage imageNamed:@"chasing_c_click.png"] forState:UIControlStateHighlighted]; 
        [m_againButton addTarget:self action: @selector(againTrack:) forControlEvents:UIControlEventTouchUpInside];  
        [self addSubview:m_againButton];
        m_againButton.hidden = YES;
        
        m_viewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
        m_viewButton.frame = CGRectMake(210, 57, 90, 25);  
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

- (void)stopTrack:(id)sender
{
    if([self.stateType isEqualToString:@"0"] && [self.batchNum intValue] != [self.lastNum intValue])
    {
//        [MobClick event:@"userPage_cancel_track"];
        [[RuYiCaiNetworkManager sharedManager] cancelTrack:self.idNo];
    }
    else
    {
        [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
}

- (void)viewAction:(id)sender
{
    NSString* stateStr = @"";
    if ([self.stateType isEqualToString:@"0"])
        stateStr = @"进行中";
    else if([self.stateType isEqualToString:@"2"])
		stateStr = @"已取消";
	else 
        stateStr = @"已完成";
    NSString* isPrizeEnd = @"";
    if([self.prizeEnd isEqualToString:@"0"])
        isPrizeEnd = @"否";
    else
        isPrizeEnd = @"是";
    
    NSMutableArray*  contentArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    [contentArr addObject:@"彩种:"];
    [contentArr addObject:[NSString stringWithFormat:@"%@",self.lotName]];
    [contentArr addObject:@"编号:"];
    [contentArr addObject:[NSString stringWithFormat:@"%@", self.idNo]];
    [contentArr addObject:@"追号期数:"];
    [contentArr addObject:[NSString stringWithFormat:@"%@期", self.batchNum]];
    [contentArr addObject:@"已追期数:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@期", self.lastNum]];
    
    [contentArr addObject:@"已撤销期数:" ];
    if([self.stateType isEqualToString:@"2"])
    {
        [contentArr addObject:[NSString stringWithFormat:@"%d期", [self.batchNum intValue] - [self.lastNum intValue]]];
    }
    else
    {
        [contentArr addObject:@"0期"];
    }

    [contentArr addObject:@"起始追期:"];
    [contentArr addObject:[NSString stringWithFormat:@"第%@期", self.beginBatch]];
    [contentArr addObject:@"追号总额:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@元", self.cashAmount]];
    
//    [contentArr addObject:@"已追金额:" ];
//    [contentArr addObject:[NSString stringWithFormat:@"%d元", [self.cashAmount intValue]/[self.batchNum intValue]*[self.lastNum intValue]]];
//    
    [contentArr addObject:@"投注时间:" ];
    [contentArr addObject:[NSString stringWithFormat:@"%@",self.orderTime]];
    [contentArr addObject:@"中奖停止追号:"];
    [contentArr addObject:isPrizeEnd];
    [contentArr addObject:@"当前状态:" ];
    [contentArr addObject:stateStr];

    [contentArr addObject:self.betCodeMsg];
    
    [self.supViewController setHidesBottomBarWhenPushed:YES];
    TrackDetailViewController* viewController = [[TrackDetailViewController alloc] init];
    viewController.trackId = self.idNo;
    viewController.contentArray = contentArr;
    if([self.stateType isEqualToString:@"0"] && [self.batchNum intValue] != [self.lastNum intValue])
        viewController.isCanStopTrack = YES;
    else
        viewController.isCanStopTrack = NO;
    viewController.stopIdNo = self.idNo;
    viewController.navigationItem.title = @"追号查询详情";
    [self.supViewController.navigationController pushViewController:viewController animated:YES];
    [contentArr release];
    [viewController release];
}

- (void)refreshView
{
    m_lotNameLabel.text = self.lotName;
    if ([self.stateType isEqualToString:@"0"])
	{
        if([self.batchNum intValue] == [self.lastNum intValue])//停止追期
        {
            if([self.isRepeatBuy isEqualToString:@"true"])
            {
                m_stopButton.hidden = YES;
                m_againButton.hidden = NO;
            }
            else
            {
                m_stopButton.hidden = NO;
                m_againButton.hidden = YES;
                [m_stopButton setTitle:@"停止追期" forState:UIControlStateNormal];
                [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            }
            m_stateLabel.text = @"已追完";
        }
        else
        {
            m_stopButton.hidden = NO;
            m_againButton.hidden = YES;
            
            m_stateLabel.text = @"进行中";
        }
	}
    else if([self.stateType isEqualToString:@"2"])
	{
		m_stateLabel.text = @"已取消";
        if([self.isRepeatBuy isEqualToString:@"true"])
        {
            m_stopButton.hidden = YES;
            m_againButton.hidden = NO;
        }
        else
        {
            m_stopButton.hidden = NO;
            m_againButton.hidden = YES;
            [m_stopButton setTitle:@"停止追期" forState:UIControlStateNormal];
            [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];        }
	}
	else//3
	{
        m_stateLabel.text = @"已追完";
        if([self.isRepeatBuy isEqualToString:@"true"])
        {
            m_stopButton.hidden = YES;
            m_againButton.hidden = NO;
        }
        else
        {
            m_stopButton.hidden = NO;
            m_againButton.hidden = YES;
            [m_stopButton setTitle:@"停止追期" forState:UIControlStateNormal];
            [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [m_stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];        }
	}
    m_batchNumLabel.text = [NSString stringWithFormat:@"追号期数: %@", self.batchNum];
    m_cashAmountLabel.text = [NSString stringWithFormat:@"追号总额: %@元", self.cashAmount];
    m_lastNumLabel.text = [NSString stringWithFormat:@"已追期数: %@", self.lastNum];
}

- (void)againTrack:(id)sender
{
//    [MobClick event:@"userPage_again_track"];
    //初始化值
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = self.betCode;
    [RuYiCaiLotDetail sharedObject].lotNo = self.lotNo;
//    [RuYiCaiLotDetail sharedObject].lotMulti = self.lotMulti;
//    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%d", ([self.cashAmount intValue]*100)/([self.batchNum intValue])];
    [RuYiCaiLotDetail sharedObject].prizeend = self.prizeEnd;
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    [RuYiCaiLotDetail sharedObject].oneAmount = self.oneAmount;
    //跳转页面
    [self.supViewController setHidesBottomBarWhenPushed:YES];
    AgainTrackViewController* viewController = [[AgainTrackViewController alloc] init];
    viewController.lotNo = self.lotNo;
    viewController.lotName = self.lotName;
    viewController.oneAmount = self.oneAmount;
    viewController.zhuShu = self.betNum;
    viewController.navigationItem.title = @"继续追号";
    [self.supViewController.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
@end