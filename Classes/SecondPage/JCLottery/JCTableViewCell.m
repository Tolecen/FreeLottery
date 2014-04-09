//
//  JCTableViewCell.m
//  RuYiCai
//
//  Created by  on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCTableViewCell.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"

#define kLabelFont 13

@implementation JCTableViewCell

@synthesize playType;

@synthesize leagueStr = m_leagueStr;
@synthesize letPoint = m_letPoint;
@synthesize homeTeamStr = m_homeTeamStr;
@synthesize guestTeamStr = m_guestTeamStr;
@synthesize resultStr = m_resultStr;
@synthesize teamId;

@synthesize homeScore;
@synthesize guestScore;
@synthesize homeHalfScore;
@synthesize guestHalfScore;

@synthesize SPstring;

- (void)dealloc
{
    [m_teamIdLabel release];
    [m_leagueLabel release];
    [m_teamOneLabel release];
    [m_teamTwoLabel release];
//    [m_imageIco release];
    [m_sampleRecordLabel release];
    [m_resultLabel release];
    [m_SPLabel release];
    [m_scoreLabel release];
    [image_result release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
		
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 60)];
        image.image = [UIImage imageNamed:@"jclottery_bg.png"];
        [self addSubview:image];
        [image release];
        
        image_result = [[UIImageView alloc] initWithFrame:CGRectMake(180, 5, 55, 39)];
        image_result.image = [UIImage imageNamed:@"same_bg.png"];
        [self addSubview:image_result];
        
        m_teamIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 70, 20)];
        [m_teamIdLabel setTextColor:[UIColor blackColor]];
		m_teamIdLabel.font = [UIFont systemFontOfSize:12.0];
		m_teamIdLabel.backgroundColor = [UIColor clearColor];
		m_teamIdLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_teamIdLabel];
        
		m_leagueLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 20, 70, 40)];
        m_leagueLabel.lineBreakMode = UILineBreakModeWordWrap;
        m_leagueLabel.numberOfLines = 2;
        [m_leagueLabel setTextColor:[UIColor blackColor]];
		m_leagueLabel.font = [UIFont systemFontOfSize:kLabelFont];
		m_leagueLabel.backgroundColor = [UIColor clearColor];
		m_leagueLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_leagueLabel];
        
        m_teamOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 60, 60)];
        m_teamOneLabel.lineBreakMode = UILineBreakModeWordWrap;
        m_teamOneLabel.numberOfLines = 3;
        [m_teamOneLabel setTextColor:[UIColor blackColor]];
		m_teamOneLabel.font = [UIFont systemFontOfSize:kLabelFont];
		m_teamOneLabel.backgroundColor = [UIColor clearColor];
		m_teamOneLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_teamOneLabel];
		
        m_sampleRecordLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 0, 35, 60)];
		m_sampleRecordLabel.font = [UIFont systemFontOfSize:12.0];
		m_sampleRecordLabel.backgroundColor = [UIColor clearColor];
		m_sampleRecordLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_sampleRecordLabel];
        
        m_resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 55, 50)];
        m_resultLabel.textColor = [UIColor blackColor];
		m_resultLabel.font = [UIFont systemFontOfSize:kLabelFont];
        m_resultLabel.numberOfLines = 3;
		m_resultLabel.backgroundColor = [UIColor clearColor];
		m_resultLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_resultLabel];
        
        m_scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 30, 55, 20)];
        [m_scoreLabel setTextColor:[UIColor blackColor]];
		m_scoreLabel.font = [UIFont systemFontOfSize:kLabelFont];
		m_scoreLabel.backgroundColor = [UIColor clearColor];
		m_scoreLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_scoreLabel];
        
        m_SPLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 41, 90, 20)];
        [m_SPLabel setTextColor:[UIColor blackColor]];
		m_SPLabel.font = [UIFont systemFontOfSize:12];
		m_SPLabel.backgroundColor = [UIColor clearColor];
		m_SPLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_SPLabel];
        
        m_teamTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(237, 0, 60, 60)];
        m_teamTwoLabel.lineBreakMode = UILineBreakModeWordWrap;
        m_teamTwoLabel.numberOfLines = 3;
        [m_teamTwoLabel setTextColor:[UIColor blackColor]];
		m_teamTwoLabel.font = [UIFont systemFontOfSize:kLabelFont];
		m_teamTwoLabel.backgroundColor = [UIColor clearColor];
		m_teamTwoLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:m_teamTwoLabel];
        
        self.isJCLQoPen = NO;
//        m_imageIco = [[UIImageView alloc] initWithFrame:CGRectMake(295, 23, 10, 14)];
//        m_imageIco.image = [UIImage imageNamed:@"sanjiao.png"];
//        [self addSubview:m_imageIco];
        
	}
	return self;
}

- (void)refresh
{
    m_leagueLabel.text = self.leagueStr;
    m_teamIdLabel.text = [NSString stringWithFormat:@"编号：%@", self.teamId];
    if (2 == self.isJCLQoPen) {//北单
//        m_imageIco.hidden = YES;
        m_SPLabel.frame = CGRectMake(150, 41, 90, 20);
        image_result.frame = CGRectMake(180, 5, 55, 27);
        m_resultLabel.frame = CGRectMake(180, 0, 55, 37);
    }
    else
    {
        image_result.frame = CGRectMake(180, 5, 55, 39);
        m_SPLabel.frame = CGRectMake(170, 41, 75, 20);
        m_resultLabel.frame = CGRectMake(180, 0, 55, 50);
//        m_imageIco.hidden = NO;
    }
    if(1 == self.isJCLQoPen)//竞彩篮球
    {
        m_teamOneLabel.text = [NSString stringWithFormat:@"%@(客)", self.guestTeamStr];
        m_teamTwoLabel.text = [NSString stringWithFormat:@"%@(主)", self.homeTeamStr];
        if(![self.homeScore isEqualToString:@""]){
            self.SPstring = [self.SPstring stringByAppendingFormat:@"%@:%@", self.guestScore, self.homeScore];
        }
    }
    else if(0 == self.isJCLQoPen)//竞彩足球
    {
        m_teamOneLabel.text = [NSString stringWithFormat:@"%@(主)", self.homeTeamStr];
        m_teamTwoLabel.text = [NSString stringWithFormat:@"%@(客)", self.guestTeamStr];
        if (![self.homeHalfScore isEqualToString:@""]) {
            self.SPstring = [self.SPstring stringByAppendingFormat:@"%@:%@(%@:%@)", self.homeScore, self.guestScore, self.homeHalfScore, self.guestHalfScore];
        }
        else if(![self.homeScore isEqualToString:@""])
            self.SPstring = [self.SPstring stringByAppendingFormat:@"%@:%@", self.homeScore, self.guestScore];
    }
    else//北单
    {
        NSString* score = @"";
        m_teamOneLabel.text = [NSString stringWithFormat:@"%@(主)", self.homeTeamStr];
        m_teamTwoLabel.text = [NSString stringWithFormat:@"%@(客)", self.guestTeamStr];
        //        if (![self.homeHalfScore isEqualToString:@""]) {
        //            score = [score stringByAppendingFormat:@"%@:%@(%@:%@)", self.homeScore, self.guestScore, self.homeHalfScore, self.guestHalfScore];
        //        }
        //        else
        if(![self.homeScore isEqualToString:@""])
            score = [score stringByAppendingFormat:@"%@:%@", self.homeScore, self.guestScore];
        m_scoreLabel.text = score;
    }
    m_resultLabel.text = self.resultStr;
    m_SPLabel.text = self.SPstring;
    
    if([self.letPoint intValue] > 0)//让分
    {
        [m_sampleRecordLabel setTextColor:[UIColor redColor]];
    }
    else
    {
        [m_sampleRecordLabel setTextColor:[UIColor colorWithRed:0 green:102.0/255.0 blue:51.0/255.0 alpha:1.0]];
    }
    if ([kLotNoJCLQ_RF isEqual: self.playType] || [kLotNoJCZQ_RQ_SPF isEqual: self.playType] || [kLotNoJCLQ_DXF isEqual: self.playType] || [kLotNoBJDC_RQSPF isEqual: self.playType]) {//让分 竞彩篮球大小分
        m_sampleRecordLabel.text = self.letPoint;
    }
    else
        m_sampleRecordLabel.text = @"";
}

@end
