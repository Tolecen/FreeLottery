//
//  HistoryTrackDetailtableViewCell.m
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryTrackDetailtableViewCell.h"

@implementation HistoryTrackDetailtableViewCell

@synthesize batchCodeStr;
@synthesize lotMultiStr;
@synthesize amountStr;
@synthesize stateStr;
@synthesize winCodeStr;
@synthesize winAccountStr;
@synthesize planStr;

- (void)dealloc
{
    [batchCodeLabel release];
    [lotMultiLabel release];
    [amountLabel release];
    [stateLabel release];
    [winCodeLabel release];
    [winAccountLabel release];
    [planInputLabel release];
    [planYieldLabel release];
    [yieldRateLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 150, 20)];
        [batchCodeLabel setTextColor:[UIColor blackColor]];
        batchCodeLabel.textAlignment = UITextAlignmentLeft;
        batchCodeLabel.backgroundColor = [UIColor clearColor];
        batchCodeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:batchCodeLabel];
        
        lotMultiLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 100, 20)];
        [lotMultiLabel setTextColor:[UIColor blackColor]];
        lotMultiLabel.textAlignment = UITextAlignmentLeft;
        lotMultiLabel.backgroundColor = [UIColor clearColor];
        lotMultiLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:lotMultiLabel];
        
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 150, 20)];
        [amountLabel setTextColor:[UIColor blackColor]];
        amountLabel.textAlignment = UITextAlignmentLeft;
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:amountLabel];
        
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 20, 100, 20)];
        [stateLabel setTextColor:[UIColor blackColor]];
        stateLabel.textAlignment = UITextAlignmentLeft;
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:stateLabel];
        
        winCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 280, 20)];
        [winCodeLabel setTextColor:[UIColor blackColor]];
        winCodeLabel.textAlignment = UITextAlignmentLeft;
        winCodeLabel.backgroundColor = [UIColor clearColor];
        winCodeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:winCodeLabel];
        
        winAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 280, 20)];
        [winAccountLabel setTextColor:[UIColor blackColor]];
        winAccountLabel.textAlignment = UITextAlignmentLeft;
        winAccountLabel.backgroundColor = [UIColor clearColor];
        winAccountLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:winAccountLabel];
        
        planInputLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 150, 20)];
        [planInputLabel setTextColor:[UIColor blackColor]];
        planInputLabel.textAlignment = UITextAlignmentLeft;
        planInputLabel.backgroundColor = [UIColor clearColor];
        planInputLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:planInputLabel];
        
        planYieldLabel  = [[UILabel alloc] initWithFrame:CGRectMake(190, 80, 120, 20)];
        [planYieldLabel setTextColor:[UIColor blackColor]];
        planYieldLabel.textAlignment = UITextAlignmentLeft;
        planYieldLabel.lineBreakMode = UILineBreakModeWordWrap;
        planYieldLabel.numberOfLines = 2;
        planYieldLabel.backgroundColor = [UIColor clearColor];
        planYieldLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:planYieldLabel];   
        
        yieldRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 150, 20)];
        [yieldRateLabel setTextColor:[UIColor blackColor]];
        yieldRateLabel.textAlignment = UITextAlignmentLeft;
        yieldRateLabel.backgroundColor = [UIColor clearColor];
        yieldRateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:yieldRateLabel];;
	}
    return self;
}

- (void)refreshCell
{
    batchCodeLabel.text = [NSString stringWithFormat:@"期号：%@", self.batchCodeStr];
    lotMultiLabel.text = [NSString stringWithFormat:@"倍数：%@倍", self.lotMultiStr];
    amountLabel.text = [NSString stringWithFormat:@"金额：%d元", [self.amountStr intValue]/100];
    stateLabel.text = [NSString stringWithFormat:@"状态：%@", self.stateStr];
    if([self.winCodeStr isEqualToString:@""])
        self.winCodeStr = @"未开奖";
    winCodeLabel.text = [NSString stringWithFormat:@"开奖号码：%@", self.winCodeStr];
    winAccountLabel.text = [NSString stringWithFormat:@"中奖金额：%d元", [self.winAccountStr intValue]/100];
    if([self.planStr isEqualToString:@""])
    {
        return;
    }
    NSArray*  planArr = [self.planStr componentsSeparatedByString:@"_"];
    if(3 == [planArr count])
    {
        planInputLabel.text = [NSString stringWithFormat:@"计划投入：%@元", [planArr objectAtIndex:0]];
        planYieldLabel.text = [NSString stringWithFormat:@"计划收益：%@元", [planArr objectAtIndex:1]];
        yieldRateLabel.text = [NSString stringWithFormat:@"收益率：%@", [planArr objectAtIndex:2]];
    }
}

@end
