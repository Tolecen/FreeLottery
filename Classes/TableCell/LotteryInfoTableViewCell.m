//
//  LotteryInfoTableViewCell.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LotteryInfoTableViewCell.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "SSQRandomTableViewCell.h"
#import "WinNoView.h"
#import "NSLog.h"
@interface LotteryInfoTableViewCell (inter)
-(void) instantScoreButtonClick;
-(void) checkButtonClick;
@end

@implementation LotteryInfoTableViewCell

@synthesize lotTitle = m_lotTitle;
@synthesize batchCode = m_batchCode;
@synthesize winNo = m_winNo;
@synthesize dateStr = m_date;
@synthesize tryCode = m_tryCode;
@synthesize tryCodeBatchCode = _tryCodeBatchCode;
@synthesize superViewController = m_superViewController;
- (void)dealloc 
{
    [_tryCodeBatchCode release];
    [m_boxBgImageView release];
    [m_titleBgImageView release];
    [m_icoImageView release];
    [m_titleLabel release];
    [m_batchCodeLabel release];
    [m_dateLabel release];
    [m_winCellView release];
 
    [m_instantScoreButton release];
    [m_checkButton release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        m_boxBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 3, 300, 84)];
        m_boxBgImageView.image = RYCImageNamed(@"kj_box_bg.png");
        [self addSubview:m_boxBgImageView];
        
//        m_titleBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 59, 74, 25)];
//        m_titleBgImageView.image = RYCImageNamed(@"ico_title_bg.png");
//        [self addSubview:m_titleBgImageView];
        
        m_icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 8, 48, 48)];
        [self addSubview:m_icoImageView];
        
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 58, 100, 25)];
        m_titleLabel.textAlignment = UITextAlignmentCenter;
        m_titleLabel.backgroundColor = [UIColor clearColor];
        m_titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_titleLabel];

        m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 10, 120, 30)];
        m_batchCodeLabel.textAlignment = UITextAlignmentCenter;
        m_batchCodeLabel.backgroundColor = [UIColor clearColor];
        m_batchCodeLabel.font = [UIFont systemFontOfSize:13];
        m_batchCodeLabel.textColor = [UIColor grayColor];
        [self addSubview:m_batchCodeLabel];
        
        m_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 130, 30)];
        m_dateLabel.textAlignment = UITextAlignmentCenter;
        m_dateLabel.backgroundColor = [UIColor clearColor];
        m_dateLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_dateLabel];
        
        m_winCellView = [[WinNoView alloc] initWithFrame:CGRectZero];
        [self addSubview:m_winCellView];
 
//        m_instantScoreButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 30, 89, 37)];
//        [m_instantScoreButton setImage:[UIImage imageNamed:@"jc_instantscore_normal.png"] forState:UIControlStateNormal];
//        [m_instantScoreButton setImage:[UIImage imageNamed:@"jc_instantscore_click.png"] forState:UIControlStateHighlighted];
//        [m_instantScoreButton addTarget:self action:@selector(instantScoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:m_instantScoreButton];
//        m_instantScoreButton.hidden = YES;
        
        m_checkButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 31, 238/2, 28)];
//        [m_checkButton setImage:[UIImage imageNamed:@"jc_openawards_normal.png"] forState:UIControlStateNormal];
        [m_checkButton setBackgroundImage:[UIImage imageNamed:@"ckxsjg_btn.png"] forState:UIControlStateNormal];
        [m_checkButton setTitle:@"查看比赛结果" forState:UIControlStateNormal];
        m_checkButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [m_checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [m_checkButton setImage:[UIImage imageNamed:@"jc_openawards_click.png"] forState:UIControlStateHighlighted];
        [m_checkButton setBackgroundImage:[UIImage imageNamed:@"ckxsjg_hover_btn.png"] forState:UIControlStateHighlighted];
        [m_checkButton setTitle:@"查看比赛结果" forState:UIControlStateHighlighted];
        [m_checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        
        [m_checkButton addTarget:self action:@selector(checkButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_checkButton];
        m_checkButton.hidden = YES;
        
        
        
        UIButton *accessoryBtn = [[UIButton alloc]initWithFrame:CGRectMake(300, 37, 8, 16)];
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
    m_titleLabel.font = [UIFont systemFontOfSize:13];

    if ([self.lotTitle isEqualToString:kLotTitleSSQ])
    {
        m_icoImageView.image = RYCImageNamed(@"scc_c_main.png");
        m_titleLabel.text = @"双色球";
    }
    else if ([self.lotTitle isEqualToString:kLotTitleQLC])
    {
        m_icoImageView.image = RYCImageNamed(@"ql_c_main.png");
        m_titleLabel.text = @"七乐彩";
    }
    else if ([self.lotTitle isEqualToString:kLotTitleFC3D])
    {
        m_icoImageView.image = RYCImageNamed(@"fc3d_c_main.png");
        m_titleLabel.text = @"福彩3D";
    }
    else if ([self.lotTitle isEqualToString:kLotTitleDLT])
    {
        m_icoImageView.image = RYCImageNamed(@"dlt_c_main.png");
        m_titleLabel.text = @"大乐透";
    }
    else if ([self.lotTitle isEqualToString:kLotTitlePLS])
    {
        m_icoImageView.image = RYCImageNamed(@"pds_c_main.png");
        m_titleLabel.text = @"排列三";
	}
	else if ([self.lotTitle isEqualToString:kLotTitle11X5])
    {
        m_icoImageView.image = RYCImageNamed(@"jx11x5_c_main.png");
        m_titleLabel.text = @"江西11选5";
    }	
    else if ([self.lotTitle isEqualToString:kLotTitleGD115])
    {
        m_icoImageView.image = RYCImageNamed(@"gd11x5_c_main.png");
        m_titleLabel.text = @"广东11选5";
    }	
    else if ([self.lotTitle isEqualToString:kLotTitleSSC])
	{
		m_icoImageView.image = RYCImageNamed(@"ssc_c_main.png");
		m_titleLabel.text = @"时时彩";
	}
    else if ([self.lotTitle isEqualToString:kLotTitleJXSSC])
	{
		m_icoImageView.image = RYCImageNamed(@"jxssc_c_main.png");
		m_titleLabel.text = @"江西时时彩";
	}
    else if ([self.lotTitle isEqualToString:kLotTitlePK10])
	{
		m_icoImageView.image = RYCImageNamed(@"pk10_c_main.png");
		m_titleLabel.text = @"PK拾";
	}
	else if([self.lotTitle isEqualToString:kLotTitleSFC])
	{
		m_icoImageView.image = RYCImageNamed(@"zq_c_main.png");
		m_titleLabel.text = @"足彩";
	}
	else if([self.lotTitle isEqualToString:kLotTitleRX9])
	{
		m_icoImageView.image = RYCImageNamed(@"rx9.png");
		m_titleLabel.text = @"任选九";
	}
	else if([self.lotTitle isEqualToString:kLotTitleJQC])
	{
		m_icoImageView.image = RYCImageNamed(@"jqc.png");
		m_titleLabel.text = @"进球彩";
	}
	else if([self.lotTitle isEqualToString:kLotTitle6CB])
	{
		m_icoImageView.image = RYCImageNamed(@"6cb.png");
		m_titleLabel.text = @"六场半";
	}
	else if([self.lotTitle isEqualToString:kLotTitlePL5])
	{
		m_icoImageView.image = RYCImageNamed(@"pdw_c_main.png");
		m_titleLabel.text = @"排列五";
	}
	else if([self.lotTitle isEqualToString:kLotTitleQXC])
	{
		m_icoImageView.image = RYCImageNamed(@"qx_c_main.png");
		m_titleLabel.text = @"七星彩";
	}
    else if([self.lotTitle isEqualToString:kLotTitle11YDJ])
	{
		m_icoImageView.image = RYCImageNamed(@"11ydj_c_.png");
		m_titleLabel.text = @"十一运夺金";
	}
//    else if([self.lotTitle isEqualToString:kLotTitle22_5])
//    {
//         m_icoImageView.image = RYCImageNamed(@"22x5_c_main.png");
//         m_titleLabel.text = @"22选5";
//    }
    else if([self.lotTitle isEqualToString:kLotTitleKLSF])
    {
        m_icoImageView.image = RYCImageNamed(@"klsf_c_main.png");
        m_titleLabel.text = @"广东快乐十分";
        m_titleLabel.font = [UIFont systemFontOfSize:11];
    }
    else if([self.lotTitle isEqualToString:kLotTitleCQSF])
    {
        m_icoImageView.image = RYCImageNamed(@"cqsf_log.png");
        m_titleLabel.text = @"重庆快乐十分";
        m_titleLabel.font = [UIFont systemFontOfSize:11];
    }
    else if([self.lotTitle isEqualToString:kLotTitleNMK3])
    {
        m_icoImageView.image = RYCImageNamed(@"nmks_c_main.png");
        m_titleLabel.text = @"快三";
        m_titleLabel.font = [UIFont systemFontOfSize:11];
    }else if([self.lotTitle isEqualToString:kLotTitleCQ11X5])
    {
        m_icoImageView.image = RYCImageNamed(@"cq11_5_c_main.png");
        m_titleLabel.text = @"重庆11选5";
        m_titleLabel.font = [UIFont systemFontOfSize:11];
    }

    else if([self.lotTitle isEqualToString:kLotTitleJCLQ])
    {
        [self JCrefreshView];
        
        return;
    }    
    else if([self.lotTitle isEqualToString:kLotTitleJCZQ])
    {
        [self JCrefreshView];
        
        return;
    }
    else if([self.lotTitle isEqualToString:kLotTitleBJDC])
    {
        [self JCrefreshView];
        
        return;
    }

    if(![self.tryCode isEqualToString:@""])
    {
        if([self.lotTitle isEqualToString:kLotTitleFC3D])
        {
           [m_winCellView showFC3DWinNo:m_winNo ofType:self.lotTitle withTryCode:self.tryCode withTryCodeBatchCode:self.tryCodeBatchCode];
        }else
        {
          [m_winCellView showWinNo:m_winNo ofType:self.lotTitle withTryCode:self.tryCode];
        }
    }
    else
    {
        [m_winCellView showWinNo:m_winNo ofType:self.lotTitle withTryCode:@""];
    }
    CGRect oldFrame = m_winCellView.frame;
    m_winCellView.frame = CGRectMake(290 - oldFrame.size.width, 50, oldFrame.size.width, oldFrame.size.height);
    if([self.lotTitle isEqualToString:kLotTitleFC3D])
    {
        m_winCellView.frame = CGRectMake(240 - oldFrame.size.width, 50, oldFrame.size.width+30, oldFrame.size.height);
    }
    
	m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期", self.batchCode];
    m_dateLabel.text = [NSString stringWithFormat:@"开奖日期:%@", self.dateStr];
    
    m_instantScoreButton.hidden = YES;
    m_checkButton.hidden = YES;
}

- (void)JCrefreshView
{
    if([self.lotTitle isEqualToString:kLotTitleJCLQ])
    {
        m_icoImageView.image = RYCImageNamed(@"jclq_c_main.png");
        m_titleLabel.text = @"竞彩篮球";
//        m_titleLabel.frame = CGRectMake(17, 59, 75, 25);
//        m_titleBgImageView.frame = CGRectMake(15, 59, 79, 25);
    }    
    if([self.lotTitle isEqualToString:kLotTitleJCZQ])
    {
        m_icoImageView.image = RYCImageNamed(@"jczq_c_main.png");
        m_titleLabel.text = @"竞彩足球";
        //        m_titleLabel.frame = CGRectMake(17, 59, 75, 25);
        //        m_titleBgImageView.frame = CGRectMake(15, 59, 79, 25);
    }
    if([self.lotTitle isEqualToString:kLotTitleBJDC])
    {
        m_icoImageView.image = RYCImageNamed(@"bjdc_c_main.png");
        m_titleLabel.text = @"北京单场";
        //        m_titleLabel.frame = CGRectMake(17, 59, 75, 25);
        //        m_titleBgImageView.frame = CGRectMake(15, 59, 79, 25);
    }
    [m_winCellView showWinNo:m_winNo ofType:self.lotTitle withTryCode:@""];
    m_batchCodeLabel.text = self.batchCode;
    m_dateLabel.text = self.dateStr;

    m_instantScoreButton.hidden = NO;
    m_checkButton.hidden = NO;
}
-(void) instantScoreButtonClick
{
    if([self.lotTitle isEqualToString:kLotTitleJCLQ])
    {
        [self.superViewController JCInstantScoreButtonSelected:YES];
    }
    else if([self.lotTitle isEqualToString:kLotTitleJCZQ])
    {
        [self.superViewController JCInstantScoreButtonSelected:NO];
    }
}
//-(void) checkButtonClick
//{
//    if([self.lotTitle isEqualToString:kLotTitleJCLQ])
//    {
//        [self.superViewController JCCheckButtonSelected:YES];
//    }
//    else if([self.lotTitle isEqualToString:kLotTitleJCZQ])
//    {
//        [self.superViewController JCCheckButtonSelected:NO];
//    }
//    else if([self.lotTitle isEqualToString:kLotTitleBJDC])
//    {
//        [self.superViewController JCCheckButtonSelected:NO];
//    }
//}

-(void) checkButtonClick
{
    if([self.lotTitle isEqualToString:kLotTitleJCLQ])
    {
        [self.superViewController JCCheckButtonSelectedForType:JC_LQ_TYPE];
    }
    else if([self.lotTitle isEqualToString:kLotTitleJCZQ])
    {
        [self.superViewController JCCheckButtonSelectedForType:JC_ZQ_TYPE];
    }
    else if([self.lotTitle isEqualToString:kLotTitleBJDC])
    {
        [self.superViewController JCCheckButtonSelectedForType:JC_BD_TYPE];
    }
}
@end
