//
//  DataAnalysis_xi_TableCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataAnalysis_xi_TableCell.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
@interface DataAnalysis_xi_TableCell(internal)  
- (void)creatRanksLable:(UILabel*)lable RECT:(CGRect)rect STRINGtAG:(NSString*) stringTag  FIRSTNAME:(NSString*)firstName ;
-(void) resertLables;
@end
 
@implementation DataAnalysis_xi_TableCell
@synthesize isJCLQ = m_isJCLQ;
@synthesize dayTime = m_dayTime;
@synthesize homeTeam = m_homeTeam;
@synthesize visitTeam = m_visitTeam;
@synthesize allGameScore = m_allGameScore;
 
@synthesize iIsFutrueGame = m_iIsFutrueGame;
@synthesize iIsLeagueRanks = m_iIsLeagueRanks;
@synthesize ranksData = m_ranksData;

@synthesize hometeamId = m_hometeamId;
@synthesize guestteamId = m_guestteamId;

@synthesize currentGuestteamId = m_currentGuestteamId;
@synthesize currentHometeamId = m_currentHometeamId;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) refreshTableCell
{
    [self resertLables];
    if (m_iIsLeagueRanks) {

        m_rankingLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        m_rankingLable.textAlignment = UITextAlignmentCenter;
        m_rankingLable.backgroundColor = [UIColor clearColor];
        m_rankingLable.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_rankingLable];
        
        m_teamNameLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 80, 30)];
        m_teamNameLable.textAlignment = UITextAlignmentCenter;
        m_teamNameLable.backgroundColor = [UIColor clearColor];
        m_teamNameLable.font = [UIFont systemFontOfSize:13];
        m_teamNameLable.lineBreakMode = UILineBreakModeCharacterWrap;
        m_teamNameLable.numberOfLines = 2;
        [self addSubview:m_teamNameLable];
        
        m_matchCountLable = [[UILabel alloc] initWithFrame:CGRectMake(45 + 80, 5, 30, 30)];
        m_matchCountLable.textAlignment = UITextAlignmentCenter;
        m_matchCountLable.backgroundColor = [UIColor clearColor];
        m_matchCountLable.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_matchCountLable];
        
        m_winLable = [[UILabel alloc] initWithFrame:CGRectMake(45 + 80 + 30, 5, 30, 30)];
        m_winLable.textAlignment = UITextAlignmentCenter;
        m_winLable.backgroundColor = [UIColor clearColor];
        m_winLable.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_winLable];
        
        if (!self.isJCLQ) {
            m_standoffLable = [[UILabel alloc] initWithFrame:CGRectMake(45 + 80 + 30* 2, 5, 30, 30)];
            m_standoffLable.textAlignment = UITextAlignmentCenter;
            m_standoffLable.backgroundColor = [UIColor clearColor];
            m_standoffLable.font = [UIFont systemFontOfSize:13];
            [self addSubview:m_standoffLable];
 
            m_loseLable = [[UILabel alloc] initWithFrame:CGRectMake(45 + 80 + 30 * 3 - (self.isJCLQ ? 20 : 0), 5, 30, 30)];
            m_loseLable.textAlignment = UITextAlignmentCenter;
            m_loseLable.backgroundColor = [UIColor clearColor];
            m_loseLable.font = [UIFont systemFontOfSize:13];
            [self addSubview:m_loseLable];
 
            m_goalDifferenceLable = [[UILabel alloc] initWithFrame:CGRectMake(45 + 80 + 30 * 4  - 10, 5, 40, 30)];
            m_goalDifferenceLable.textAlignment = UITextAlignmentCenter;
            m_goalDifferenceLable.backgroundColor = [UIColor clearColor];
            m_goalDifferenceLable.font = [UIFont systemFontOfSize:13];
            [self addSubview:m_goalDifferenceLable];
            
            m_integral = [[UILabel alloc] initWithFrame:CGRectMake(45 + 80 + 30 * 5, 5, 30, 30)];
            m_integral.textAlignment = UITextAlignmentCenter;
            m_integral.backgroundColor = [UIColor clearColor];
            m_integral.font = [UIFont systemFontOfSize:13];
            [self addSubview:m_integral];
        }
        else
        {
            m_loseLable = [[UILabel alloc] initWithFrame:CGRectMake(125 + 30 * 2, 5, 30, 30)];
            m_loseLable.textAlignment = UITextAlignmentCenter;
            m_loseLable.backgroundColor = [UIColor clearColor];
            m_loseLable.font = [UIFont systemFontOfSize:13];
            [self addSubview:m_loseLable];
            
            //得
            m_getScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(122 + 30 * 3, 5, 32, 30)];
            m_getScoreLable.textAlignment = UITextAlignmentCenter;
            m_getScoreLable.backgroundColor = [UIColor clearColor];
            m_getScoreLable.font = [UIFont systemFontOfSize:12];
            [self addSubview:m_getScoreLable];
            //失分
            m_loseScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(122 + 30 * 4, 5, 33, 30)];
            m_loseScoreLable.textAlignment = UITextAlignmentCenter;
            m_loseScoreLable.backgroundColor = [UIColor clearColor];
            m_loseScoreLable.font = [UIFont systemFontOfSize:12];
            [self addSubview:m_loseScoreLable];
 
            m_goalDifferenceLable = [[UILabel alloc] initWithFrame:CGRectMake(125 + 30 * 5, 5, 30, 30)];
            m_goalDifferenceLable.textAlignment = UITextAlignmentCenter;
            m_goalDifferenceLable.backgroundColor = [UIColor clearColor];
            m_goalDifferenceLable.font = [UIFont systemFontOfSize:13];
            [self addSubview:m_goalDifferenceLable];
 
        }
 
        if (self.tag == 0) {
            m_rankingLable.text = @"排名";
            m_teamNameLable.text = @"球队";
            m_matchCountLable.text = @"赛";
            m_winLable.text = @"胜";
            if (!self.isJCLQ) {
                m_standoffLable.text = @"平";
                m_loseLable.text = @"负";
                m_goalDifferenceLable.text = @"净";
                m_integral.text = @"积分";
            }
            else
            {
                m_loseLable.text = @"负";
                m_getScoreLable.text = @"得";
                m_loseScoreLable.text = @"失";
                m_goalDifferenceLable.text = @"净";
            }
            
            UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
            writeImage.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
            [self addSubview:writeImage];
            [writeImage release];
        }
        else
        {
            if (self.isJCLQ) {
                m_rankingLable.text = KISDictionaryNullValue(m_ranksData, @"ranking");
                m_teamNameLable.text = KISDictionaryNullValue(m_ranksData, @"teamName");
 
                m_matchCountLable.text = KISDictionaryNullValue(m_ranksData, @"matchCount");
                m_winLable.text = KISDictionaryNullValue(m_ranksData, @"winCount");
                m_loseLable.text = KISDictionaryNullValue(m_ranksData, @"loseCount");
                
                m_getScoreLable.text = KISDictionaryNullValue(m_ranksData, @"gainScore");
                m_loseScoreLable.text = KISDictionaryNullValue(m_ranksData, @"loseScore");
                m_goalDifferenceLable.text = KISDictionaryNullValue(m_ranksData, @"scoreDifference");//净
            }
            else
            {
                m_rankingLable.text = KISDictionaryNullValue(m_ranksData, @"ranking");
                m_teamNameLable.text = KISDictionaryNullValue(m_ranksData, @"teamName");
 
                m_matchCountLable.text = KISDictionaryNullValue(m_ranksData, @"matchCount");
                m_winLable.text = KISDictionaryNullValue(m_ranksData, @"win");
                m_standoffLable.text = KISDictionaryNullValue(m_ranksData, @"standoff");
                m_loseLable.text = KISDictionaryNullValue(m_ranksData, @"lose");
                m_goalDifferenceLable.text = KISDictionaryNullValue(m_ranksData, @"goalDifference");
                m_integral.text = KISDictionaryNullValue(m_ranksData, @"integral"); 
            }
            
            //@"印第安纳步行者" 特殊比赛
 
            //主客队 做颜色标示
            if ([KISDictionaryNullValue(m_ranksData, @"teamId") isEqualToString:self.currentHometeamId]) {
                m_teamNameLable.textColor = [UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1];
            }
            else if([KISDictionaryNullValue(m_ranksData, @"teamId") isEqualToString:self.currentGuestteamId])
            {
                m_teamNameLable.textColor = [UIColor colorWithRed:0 green:102.0/255.0 blue:0 alpha:1];
            }
            else
            {
                m_teamNameLable.textColor = [UIColor blackColor];
            }
        }
    }
    else
    {
        //赛事日期
        m_dayTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
        m_dayTimeLable.textAlignment = UITextAlignmentCenter;
        m_dayTimeLable.backgroundColor = [UIColor clearColor];
        m_dayTimeLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_dayTimeLable];
        //主队
        CGRect rect;
        if (m_iIsFutrueGame)
        {
            rect = CGRectMake(110, 0, 80, 40);
        }
        else
            rect = CGRectMake(10 + 80, 0, 80, 40);
        
        m_homeTeamLable = [[UILabel alloc] initWithFrame:rect];
        m_homeTeamLable.textAlignment = UITextAlignmentCenter;
        m_homeTeamLable.backgroundColor = [UIColor clearColor];
        m_homeTeamLable.font = [UIFont systemFontOfSize:15];
        m_homeTeamLable.lineBreakMode = UILineBreakModeCharacterWrap;
        m_homeTeamLable.numberOfLines = 2;
        [self addSubview:m_homeTeamLable];
        //全场比分
        if (!m_iIsFutrueGame) {
            m_allGameScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(10 + 80*2, 5, 60, 30)];
            m_allGameScoreLable.textAlignment = UITextAlignmentCenter;
            m_allGameScoreLable.backgroundColor = [UIColor clearColor];
            m_allGameScoreLable.font = [UIFont systemFontOfSize:15];
            [self addSubview:m_allGameScoreLable];
        }
        if (m_iIsFutrueGame)
        {
            rect = CGRectMake(210, 0, 80, 40);
        }
        else
            rect = CGRectMake(80*3 - 10,0, 80, 40);
        m_visitTeamLable = [[UILabel alloc] initWithFrame:rect];
        m_visitTeamLable.textAlignment = UITextAlignmentCenter;
        m_visitTeamLable.backgroundColor = [UIColor clearColor];
        m_visitTeamLable.font = [UIFont systemFontOfSize:15];
        m_visitTeamLable.lineBreakMode = UILineBreakModeCharacterWrap;
        m_visitTeamLable.numberOfLines = 2;
        [self addSubview:m_visitTeamLable];
        
        if (self.tag == 0)
        {
            m_dayTimeLable.text = @"赛事日期";
            m_homeTeamLable.text = @"主队";
            if (!m_iIsFutrueGame) {
                m_allGameScoreLable.text = @"全场比分";
            }
            
            m_visitTeamLable.text = @"客队";
            UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
            writeImage.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
            [self addSubview:writeImage];
            [writeImage release];
        }
        else
        {
            m_dayTimeLable.text = m_dayTime;
            m_homeTeamLable.text = m_homeTeam;
            if (!m_iIsFutrueGame) {
                m_allGameScoreLable.text = m_allGameScore;
            }
            m_visitTeamLable.text = m_visitTeam;
            
            //主客队 做颜色标示 主队红色 可对 绿色
            if ([self.hometeamId isEqualToString:self.currentHometeamId]) {
                m_homeTeamLable.textColor = [UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1];
            }
            else if([self.hometeamId isEqualToString:self.currentGuestteamId])
            {
                m_homeTeamLable.textColor = [UIColor colorWithRed:0 green:102.0/255.0 blue:0 alpha:1];
            }
            else
                m_homeTeamLable.textColor = [UIColor blackColor];
            
            if([self.guestteamId isEqualToString:self.currentGuestteamId])
            {
                m_visitTeamLable.textColor = [UIColor colorWithRed:0 green:102.0/255.0 blue:0 alpha:1];
            }
            else if ([self.guestteamId isEqualToString:self.currentHometeamId])
            {
                m_visitTeamLable.textColor = [UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1];
            }
            else
            {
                m_visitTeamLable.textColor = [UIColor blackColor];
            }
        }
    }
    
}

-(void) resertLables
{
    if (m_rankingLable) {
        [m_rankingLable removeFromSuperview];
        [m_rankingLable release];
        m_rankingLable = NULL;
    }
    if (m_teamNameLable) {
        [m_teamNameLable removeFromSuperview];
        [m_teamNameLable release];
        m_teamNameLable = NULL;
    }
    if (m_matchCountLable) {
        [m_matchCountLable removeFromSuperview];
        [m_matchCountLable release];
        m_matchCountLable = NULL;
    }
    if (m_winLable) {
        [m_winLable removeFromSuperview];
        [m_winLable release];
        m_winLable = NULL;
    }
    if (m_standoffLable) {
        [m_standoffLable removeFromSuperview];
        [m_standoffLable release];
        m_standoffLable = NULL;
    }
    if (m_loseLable) {
        [m_loseLable removeFromSuperview];
        [m_loseLable release];
        m_loseLable = NULL;
    }
    if (m_goalDifferenceLable) {
        [m_goalDifferenceLable removeFromSuperview];
        [m_goalDifferenceLable release];
        m_goalDifferenceLable = NULL;
    }
    if (m_integral) {
        [m_integral removeFromSuperview];
        [m_integral release];
        m_integral = NULL;
    }
 
    if (m_dayTimeLable)
    {
        [m_dayTimeLable removeFromSuperview];
        [m_dayTimeLable release];
        m_dayTimeLable = NULL;
    }
    if (m_homeTeamLable)
    {
        [m_homeTeamLable removeFromSuperview];
        [m_homeTeamLable release];
        m_homeTeamLable = NULL;
    }
    if (m_allGameScoreLable)
    {
        [m_allGameScoreLable removeFromSuperview];
        [m_allGameScoreLable release];
        m_allGameScoreLable = NULL;
    }
    if (m_visitTeamLable)
    {
        [m_visitTeamLable removeFromSuperview];
        [m_visitTeamLable release];
        m_visitTeamLable = NULL;
    }
    if (m_getScoreLable) {
        [m_getScoreLable removeFromSuperview];
        [m_getScoreLable release];
        m_getScoreLable = NULL;
    }
    if (m_loseScoreLable) {
        [m_loseScoreLable removeFromSuperview];
        [m_loseScoreLable release];
        m_loseScoreLable = NULL;
    }
 
}

- (void)dealloc
{
    [m_dayTimeLable release];
    [m_homeTeamLable release];
    [m_visitTeamLable release];
    [m_allGameScoreLable release];
    
    [m_rankingLable release];
    [m_teamNameLable release];
    [m_matchCountLable release];
    [m_winLable release];
    [m_standoffLable release];
    [m_loseLable release];
    [m_goalDifferenceLable release];
    [m_integral release];
 
    [super dealloc];
}

@end
