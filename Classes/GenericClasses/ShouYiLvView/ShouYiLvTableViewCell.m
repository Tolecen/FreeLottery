//
//  ShouYiLvTableViewCell.m
//  RuYiCai
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShouYiLvTableViewCell.h"

@implementation ShouYiLvTableViewCell

@synthesize batchCodeStr;
@synthesize lotMultiStr;
@synthesize currentIssueInputStr;
@synthesize currentIssueYieldStr;
@synthesize accumulatedInputStr;
@synthesize accumulatedYieldStr;
@synthesize yieldRateStr; 

- (void)dealloc
{
    [batchCodeLabel release];
    [lotMultiLabel release];
    [currentIssueInputLabel release];
    [currentIssueYieldLabel release];
    [accumulatedInputLabel release];
    [accumulatedYieldLabel release];
    [yieldRateLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 20)];
        [batchCodeLabel setTextColor:[UIColor blackColor]];
        batchCodeLabel.textAlignment = UITextAlignmentLeft;
        batchCodeLabel.backgroundColor = [UIColor clearColor];
        batchCodeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:batchCodeLabel];
        
        lotMultiLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 150, 20)];
        [lotMultiLabel setTextColor:[UIColor blackColor]];
        lotMultiLabel.textAlignment = UITextAlignmentLeft;
        lotMultiLabel.backgroundColor = [UIColor clearColor];
        lotMultiLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:lotMultiLabel];
        
        currentIssueInputLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 20)];
        [currentIssueInputLabel setTextColor:[UIColor blackColor]];
        currentIssueInputLabel.textAlignment = UITextAlignmentLeft;
        currentIssueInputLabel.backgroundColor = [UIColor clearColor];
        currentIssueInputLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:currentIssueInputLabel];
        
        currentIssueYieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 150, 20)];
        [currentIssueYieldLabel setTextColor:[UIColor blackColor]];
        currentIssueYieldLabel.textAlignment = UITextAlignmentLeft;
        currentIssueYieldLabel.backgroundColor = [UIColor clearColor];
        currentIssueYieldLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:currentIssueYieldLabel];
        
        accumulatedInputLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 150, 20)];
        [accumulatedInputLabel setTextColor:[UIColor blackColor]];
        accumulatedInputLabel.textAlignment = UITextAlignmentLeft;
        accumulatedInputLabel.backgroundColor = [UIColor clearColor];
        accumulatedInputLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:accumulatedInputLabel];
        
        accumulatedYieldLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 150, 20)];
        [accumulatedYieldLabel setTextColor:[UIColor blackColor]];
        accumulatedYieldLabel.textAlignment = UITextAlignmentLeft;
        accumulatedYieldLabel.backgroundColor = [UIColor clearColor];
        accumulatedYieldLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:accumulatedYieldLabel];
        
        yieldRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 150, 20)];
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
    currentIssueInputLabel.text = [NSString stringWithFormat:@"当期投入：￥%d", [self.currentIssueInputStr intValue]/100];
    currentIssueYieldLabel.text = [NSString stringWithFormat:@"当期收入：￥%d", [self.currentIssueYieldStr intValue]/100];
    accumulatedInputLabel.text = [NSString stringWithFormat:@"累计投入：￥%d", [self.accumulatedInputStr intValue]/100];
    accumulatedYieldLabel.text = [NSString stringWithFormat:@"累计收入：￥%d", [self.accumulatedYieldStr intValue]/100];
    yieldRateLabel.text = [NSString stringWithFormat:@"收益率：%@", self.yieldRateStr];
}

@end
