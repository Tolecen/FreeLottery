//
//  GetCashRecordView.m
//  RuYiCai
//
//  Created by  on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GetCashRecordView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"

@implementation GetCashRecordView

@synthesize cashTime = m_cashTime;
@synthesize amount = m_amount;
@synthesize rejectReason = m_rejectReason;
@synthesize stateMemo = m_stateMemo;

@synthesize cashdetailid = m_cashdetailid;
@synthesize state = m_state;

- (void)dealloc
{
    [m_cashTimeLabel release];
    [m_amountLabel release];
    [m_stateMemoLabel release];
    
    [m_reasonButton release];
    [m_cancelCashButton release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 5, 302, 12)];
        image_topbg.image = RYCImageNamed(@"croner_top.png");
        [self addSubview:image_topbg];
        [image_topbg release];

        UIImageView *image_middlebg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 17, 302, 66)];
        image_middlebg.image = RYCImageNamed(@"croner_middle.png");
        [self addSubview:image_middlebg];
        
        UIImageView *image_linebg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 28, 302, 1)];
        image_linebg.image = RYCImageNamed(@"croner_line.png");
        [image_middlebg addSubview:image_linebg];
        
        [image_linebg release];
        [image_middlebg release];

        UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 83, 302, 12)];
        image_bottombg.image = RYCImageNamed(@"croner_bottom.png");
        [self addSubview:image_bottombg];
        [image_bottombg release];
        m_cashTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, 250, 40)];
        m_cashTimeLabel.textAlignment = UITextAlignmentLeft;
        m_cashTimeLabel.backgroundColor = [UIColor clearColor];
        m_cashTimeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_cashTimeLabel];
        
        m_reasonButton = [[UIButton alloc] initWithFrame:CGRectMake(248, 12, 50, 26)];
        [m_reasonButton setTitle:@"原因" forState:UIControlStateNormal];
        [m_reasonButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_reasonButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [m_reasonButton setBackgroundImage:RYCImageNamed(@"yuanyin_normal.png") forState:UIControlStateNormal];
        [m_reasonButton setBackgroundImage:RYCImageNamed(@"yuanyin_click.png") forState:UIControlStateHighlighted];
        [m_reasonButton addTarget:self action:@selector(reasonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_reasonButton];
        m_cancelCashButton.hidden = YES;
        
        m_cancelCashButton = [[UIButton alloc] initWithFrame:CGRectMake(248, 12, 50, 26)];
        [m_cancelCashButton setTitle:@"取消" forState:UIControlStateNormal];
        [m_cancelCashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        m_cancelCashButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [m_cancelCashButton setBackgroundImage:RYCImageNamed(@"quxiao_normal.png") forState:UIControlStateNormal];
        [m_cancelCashButton setBackgroundImage:RYCImageNamed(@"quxiao_click.png") forState:UIControlStateHighlighted];
        [m_cancelCashButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_cancelCashButton];
        m_cancelCashButton.hidden = YES;
        
        UILabel *oneAmount = [[UILabel alloc] initWithFrame:CGRectMake(14, 45, 50, 50)];
        oneAmount.textAlignment = UITextAlignmentLeft;
        oneAmount.backgroundColor = [UIColor clearColor];
        oneAmount.font = [UIFont systemFontOfSize:15];
        oneAmount.text = @"金额：";
        [self addSubview:oneAmount];
        [oneAmount release];
        
        m_amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 45, 200, 50)];
        m_amountLabel.textAlignment = UITextAlignmentLeft;
        [m_amountLabel setTextColor:[UIColor redColor]];
        m_amountLabel.backgroundColor = [UIColor clearColor];
        m_amountLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_amountLabel]; 
        
        m_stateMemoLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 45, 100, 50)];
        m_stateMemoLabel.textAlignment = UITextAlignmentLeft;
        m_stateMemoLabel.backgroundColor = [UIColor clearColor];
        m_stateMemoLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_stateMemoLabel]; 
    }
    return self;
}

- (void)refreshView
{
    m_cashTimeLabel.text = [NSString stringWithFormat:@"提现日期：%@", self.cashTime];
    m_amountLabel.text = [NSString stringWithFormat:@"%@元", self.amount];
    m_stateMemoLabel.text = [NSString stringWithFormat:@"%@", self.stateMemo];
    if([self.state isEqualToString:@"104"])//驳回
    {
        m_reasonButton.hidden = NO;
        [m_stateMemoLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
    }
    else if([self.state isEqualToString:@"1"])//等待审核
    {
        m_cancelCashButton.hidden = NO;
        [m_stateMemoLabel setTextColor:[UIColor colorWithRed:204.0/255.0 green:102.0/255.0 blue:0.0 alpha:1.0]];
    }
    else if([self.state isEqualToString:@"105"])//成功
    {
        m_reasonButton.hidden = YES;
        m_cancelCashButton.hidden = YES;
        [m_stateMemoLabel setTextColor:[UIColor redColor]];
    }
    else if([self.state isEqualToString:@"106"])//取消
    {
        m_reasonButton.hidden = YES;
        m_cancelCashButton.hidden = YES;
        [m_stateMemoLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];   
    }
    else if([self.state isEqualToString:@"103"])//已审核，正在汇款
    {
        m_reasonButton.hidden = YES;
        m_cancelCashButton.hidden = YES;
        [m_stateMemoLabel setTextColor:[UIColor colorWithRed:0.0 green:102.0/255.0 blue:0.0 alpha:1.0]];   
    }
    else
    {
        m_reasonButton.hidden = YES;
        m_cancelCashButton.hidden = YES;
    }
}

- (void)reasonButtonClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:self.rejectReason withTitle:@"提现失败原因" buttonTitle:@"返回"];
}

- (void)cancelButtonClick:(id)sender
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                        message:@"您是否要取消提现？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
    [alterView addButtonWithTitle:@"确定"];
    [alterView show];
    
    [alterView release];
}

#pragma mark alter delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [alertView cancelButtonIndex])
    {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
        [dict setObject:@"getCash" forKey:@"command"];
        [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
        [dict setObject:@"cancelCash" forKey:@"cashtype"];
        [dict setObject:self.cashdetailid forKey:@"cashdetailid"];

        [[RuYiCaiNetworkManager sharedManager] cancelCash:dict];
    }
}

@end
