//
//  HMDTJoinPeopleTableCell.m
//  RuYiCai
//
//  Created by  on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMDTJoinPeopleTableCell.h"
#import "RYCImageNamed.h"
#import "CommonRecordStatus.h"
#import "RuYiCaiNetworkManager.h"

@implementation HMDTJoinPeopleTableCell

@synthesize nickName;
@synthesize state;
@synthesize buyTime;
@synthesize buyAmt;
@synthesize caseLotId;
@synthesize beState;

- (void)dealloc
{
    [nickNameLabel release];
    [cancelCaseButton release];
    [buyTimeLabel release];
    [buyAmtLabel release];
    [canceledCaseLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 60, 25)];
        nickNameLabel.textAlignment = UITextAlignmentLeft;
        nickNameLabel.backgroundColor = [UIColor clearColor];
        nickNameLabel.font = [UIFont systemFontOfSize:14];
        nickNameLabel.textColor = [UIColor blackColor];
        [self addSubview:nickNameLabel];

        buyAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 10, 100, 25)];
        buyAmtLabel.textAlignment = UITextAlignmentLeft;
        buyAmtLabel.backgroundColor = [UIColor clearColor];
        buyAmtLabel.font = [UIFont systemFontOfSize:14];
        buyAmtLabel.textColor = [UIColor blackColor];
        [self addSubview:buyAmtLabel];
        
        buyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 25)];
        buyTimeLabel.textAlignment = UITextAlignmentLeft;
        buyTimeLabel.backgroundColor = [UIColor clearColor];
        buyTimeLabel.font = [UIFont systemFontOfSize:14];
        buyTimeLabel.textColor = [UIColor blackColor];
        [self addSubview:buyTimeLabel];
        
        canceledCaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 55, 25)];
        canceledCaseLabel.textAlignment = UITextAlignmentLeft;
        canceledCaseLabel.backgroundColor = [UIColor clearColor];
        canceledCaseLabel.font = [UIFont systemFontOfSize:15];
        canceledCaseLabel.textColor = [UIColor redColor];
        canceledCaseLabel.text = @"已撤资";
        [self addSubview:canceledCaseLabel];
        canceledCaseLabel.hidden = YES;
        
        cancelCaseButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 10, 50, 25)];
        [cancelCaseButton setBackgroundImage:RYCImageNamed(@"quxiao_normal.png") forState:UIControlStateNormal];
        [cancelCaseButton setBackgroundImage:RYCImageNamed(@"quxiao_click.png") forState:UIControlStateHighlighted];
        [cancelCaseButton setTitle:@"撤资" forState:UIControlStateNormal];
        cancelCaseButton.backgroundColor = [UIColor clearColor];
        cancelCaseButton.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelCaseButton.titleLabel.textColor = [UIColor whiteColor];
        [cancelCaseButton addTarget:self action:@selector(cancelCaselotbuyClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelCaseButton];
        cancelCaseButton.hidden = YES;
    }
    return self;
}

- (void)refreshCell
{
    nickNameLabel.text = self.nickName;
    if([self.state isEqualToString:@"true"])
        cancelCaseButton.hidden = NO;
    else
        cancelCaseButton.hidden = YES;
    buyTimeLabel.text = self.buyTime;
    buyAmtLabel.text = [NSString stringWithFormat:@"¥%d", [self.buyAmt intValue]/100];
    if([self.beState isEqualToString:@"0"])//1:正常；0:撤资
        canceledCaseLabel.hidden = NO;
    else
        canceledCaseLabel.hidden = YES;
}

- (void)cancelCaselotbuyClick
{
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:5];
    [tempDic setObject:@"betLot" forKey:@"command"];
    [tempDic setObject:@"cancelCaselotbuy" forKey:@"bettype"];
    [tempDic setObject:self.caseLotId forKey:@"caseid"];
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_QUXIAO;
    [[RuYiCaiNetworkManager sharedManager] quXiaoNetRequest:tempDic];
}

@end
