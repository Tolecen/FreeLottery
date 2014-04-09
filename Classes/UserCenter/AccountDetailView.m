//
//  AccountDetailView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AccountDetailView.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "NSLog.h"

@implementation AccountDetailView

@synthesize amt = m_amt;
@synthesize drawAmt = m_drawAmt;
@synthesize blsign = m_blsign;
@synthesize ttransactionType = m_ttransactionType;
@synthesize memo = m_memo;
@synthesize balance = m_balance;
@synthesize drawamtBalance = m_drawamtBalance;
@synthesize platTime = m_platTime;

- (void)dealloc 
{
    [m_memoLabel release];
    [m_platTimeLabel release];
    [m_amountLabel release];
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
        
        m_memoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 210, 20)];
        m_memoLabel.textAlignment = UITextAlignmentLeft;
        m_memoLabel.backgroundColor = [UIColor clearColor];
        m_memoLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_memoLabel];
        
        m_platTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        m_platTimeLabel.textAlignment = UITextAlignmentLeft;
        m_platTimeLabel.backgroundColor = [UIColor clearColor];
        m_platTimeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_platTimeLabel];
        
        m_amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 130, 20)];
        m_amountLabel.textAlignment = UITextAlignmentRight;
        m_amountLabel.backgroundColor = [UIColor clearColor];
        m_amountLabel.font = [UIFont systemFontOfSize:15];
        m_amountLabel.textColor = [UIColor blackColor];
        [self addSubview:m_amountLabel];
    }
    return self;
}

- (void)refreshView
{
    m_memoLabel.text = self.memo;
    m_platTimeLabel.text = [NSString stringWithFormat:@"%@", self.platTime];
    if([self.blsign isEqualToString:@"-1"])
    {
        m_amountLabel.text = [NSString stringWithFormat:@"-%.02lf元", [self.amt doubleValue]/100];
        m_amountLabel.textColor = [UIColor colorWithRed:32.0/255.0 green:124.0/255.0 blue:35.0/255.0 alpha:1.0];
    }
    else
    {
        m_amountLabel.text = [NSString stringWithFormat:@"+%.02lf元", [self.amt doubleValue]/100];
        m_amountLabel.textColor = [UIColor colorWithRed:196.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
    }
}

@end
