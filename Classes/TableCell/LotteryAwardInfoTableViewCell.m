//
//  LotteryAwardInfoTableViewCell.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LotteryAwardInfoTableViewCell.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "SSQRandomTableViewCell.h"
#import "WinNoView.h"
#import "NSLog.h"
#import "CommonRecordStatus.h"

@implementation LotteryAwardInfoTableViewCell

@synthesize lotTitle = m_lotTitle;
@synthesize batchCode = m_batchCode;
@synthesize winNo = m_winNo;
@synthesize dateStr = m_date;
@synthesize tryCode = m_tryCode;
@synthesize accessoryBtn;

- (void)dealloc 
{
    [accessoryBtn release];
    [m_boxBgImageView release];
    [m_batchCodeLabel release];
    [m_dateLabel release];
    [m_winCellView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
//        m_boxBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 480, 64)];
//        m_boxBgImageView.image = RYCImageNamed(@"kj_box_bg.png");
//        [self addSubview:m_boxBgImageView];
        m_boxBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 300, 84)];
        m_boxBgImageView.image = RYCImageNamed(@"kj_box_bg.png");
        [self addSubview:m_boxBgImageView];
        
        
//        m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 34, 170, 30)];
//        m_batchCodeLabel.textAlignment = UITextAlignmentLeft;
//        m_batchCodeLabel.backgroundColor = [UIColor clearColor];
//        m_batchCodeLabel.font = [UIFont systemFontOfSize:12];
//        m_batchCodeLabel.textColor = [UIColor grayColor];
//        [self addSubview:m_batchCodeLabel];
//        
//        m_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 34, 140, 30)];
//        m_dateLabel.textAlignment = UITextAlignmentRight;
//        m_dateLabel.backgroundColor = [UIColor clearColor];
//        m_dateLabel.font = [UIFont systemFontOfSize:12];
//        [self addSubview:m_dateLabel];
        
        
        m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 50, 120, 30)];
        m_batchCodeLabel.textAlignment = UITextAlignmentCenter;
        m_batchCodeLabel.backgroundColor = [UIColor clearColor];
        m_batchCodeLabel.font = [UIFont systemFontOfSize:13];
        m_batchCodeLabel.textColor = [UIColor grayColor];
        [self addSubview:m_batchCodeLabel];
        
        
        m_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 , 50, 130, 30)];
        m_dateLabel.textAlignment = UITextAlignmentCenter;
        m_dateLabel.backgroundColor = [UIColor clearColor];
        m_dateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_dateLabel];
        

        

        
        m_winCellView = [[WinNoView alloc] initWithFrame:CGRectZero];
        m_winCellView.frame = CGRectMake(30, 5, m_winCellView.bounds.size.height,  m_winCellView.bounds.size.height);
        [self addSubview:m_winCellView];
       
        
        accessoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(300, 37, 8, 16)];
        [accessoryBtn setBackgroundImage:[UIImage imageNamed:@"accessory_c_normal.png"] forState:UIControlStateNormal];
        [accessoryBtn setBackgroundImage:[UIImage imageNamed:@"accessory_c_normal.png"] forState:UIControlStateHighlighted];
        accessoryBtn.tag = 0;
        [self addSubview:accessoryBtn];
        [accessoryBtn release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{    
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    if(![self.tryCode isEqualToString:@""])
    {
        [m_winCellView showWinNo:m_winNo ofType:self.lotTitle withTryCode:self.tryCode];
    }
    else
    {
        [m_winCellView showWinNo:m_winNo ofType:self.lotTitle withTryCode:@""];
    }
//    [m_winCellView showWinNo:self.winNo ofType:self.lotTitle withTryCode:@""];
    CGRect oldFrame = m_winCellView.frame;
    m_winCellView.frame = CGRectMake((310 - oldFrame.size.width)/2, 10, oldFrame.size.width, oldFrame.size.height);
    
    m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期", self.batchCode];
    
    
    if(![[CommonRecordStatus commonRecordStatusManager] isHeighLotTitle:self.lotTitle])
    {
        
        m_dateLabel.text = [NSString stringWithFormat:@"开奖日期:%@", self.dateStr];
        
    }else
    {
        
        m_dateLabel.text = [NSString stringWithFormat:@"开奖时间:%@", [self.dateStr substringWithRange:NSMakeRange(11, 5)]];
        
    }
}

@end
