//
//  DataAnalysis_xi_TableCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataAnalysis_xi_TableCell : UITableViewCell
{
    BOOL                                    m_isJCLQ;
    NSString*                               m_dayTime;
    NSString*                               m_homeTeam;
    NSString*                               m_visitTeam;
    NSString*                               m_allGameScore;
//    NSString*                               m_hometeamId;
//    NSString*                               m_guestteamId;
    
    
    UILabel*                                m_dayTimeLable;
    UILabel*                                m_homeTeamLable;
    UILabel*                                m_visitTeamLable;
    UILabel*                                m_allGameScoreLable;
    
    BOOL                                    m_iIsFutrueGame;//未来的比赛，去掉比分
    
    BOOL                                    m_iIsLeagueRanks;//联赛排名
    
    NSDictionary*                           m_ranksData;
    UILabel*                                m_rankingLable;
    UILabel*                                m_teamNameLable;
    UILabel*                                m_matchCountLable;
    UILabel*                                m_winLable;
    UILabel*                                m_standoffLable;
    UILabel*                                m_loseLable;
    //竞彩篮球
    UILabel*                                m_getScoreLable;
    UILabel*                                m_loseScoreLable;

    UILabel*                                m_goalDifferenceLable;
    UILabel*                                m_integral;
    
    //主客队 标示
    NSString*                               m_currentHometeamId;
    NSString*                               m_currentGuestteamId;
}
@property (nonatomic,assign) BOOL isJCLQ;
@property (nonatomic,retain) NSString* dayTime;
@property (nonatomic,retain) NSString* homeTeam;
@property (nonatomic,retain) NSString* visitTeam;
@property (nonatomic,retain) NSString* allGameScore;

@property (nonatomic,assign) BOOL iIsFutrueGame;

@property (nonatomic,assign) BOOL iIsLeagueRanks;
@property (nonatomic,retain) NSDictionary* ranksData;
 
@property (nonatomic,retain) NSString* hometeamId;
@property (nonatomic,retain) NSString* guestteamId;
@property (nonatomic,retain) NSString* currentHometeamId;
@property (nonatomic,retain) NSString* currentGuestteamId;

-(void) refreshTableCell;
@end
