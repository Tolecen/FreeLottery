//
//  InstantScoreTableCell.h
//  RuYiCai
//
//  Created by ruyicai on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InstantScoreViewController.h"
#import "BJDC_instantScoreViewController.h"

typedef enum {
    JingCai = 0,
    BeiDan = 1,
    ZuCai = 2
}ScoreType;

@interface InstantScoreTableCell : UITableViewCell
{
    ScoreType                               m_scoreType;//区分竞彩和北单
    NSString*                               m_event;
    NSString*                               m_sclassName;
    NSString*                               m_homeTeam;
    NSString*                               m_guestTeam;
    NSString*                               m_matchState;
    
    NSString*                               m_matchTime;
    
    UILabel*                                m_eventLable;
    UILabel*                                m_sclassNameLable;
    UILabel*                                m_homeTeamLable;
    UILabel*                                m_guestTeamLable;
    UILabel*                                m_matchTimeLable;
    UILabel*                                m_stateMemoLable;
    
    UIButton*                               m_buttonCang;
    BOOL                                    m_isShouCang;
    BOOL                                    m_shouCangButtonIsHidden;
    
    InstantScoreViewController*             m_superViewController;
    BJDC_instantScoreViewController*        m_bdSuperViewController;
    
    NSString*                               m_homeScore;
    NSString*                               m_guestScore;
    NSString*                               m_homeHalfScore;
    NSString*                               m_guestHalfScore;
    NSString*                               m_red;
    NSString*                               m_yellow;
    
    UILabel*                                m_homeScoreLable;
    UILabel*                                m_guestScoreLable;
    UILabel*                                m_halfScoreLable;
    //    UILabel*                                m_resultLable;
    
    //    UIButton*                                m_redPai;
    //    UIButton*                                m_yellowPai;
}
@property (nonatomic,assign) ScoreType scoreType;

@property (nonatomic,retain) NSString* progressedTime;//竞彩足球比赛进行时间
@property (nonatomic,retain) NSString* matchState;

@property (nonatomic,retain) NSString* event;
@property (nonatomic,retain) NSString* sclassName;
@property (nonatomic,retain) NSString* homeTeam;
@property (nonatomic,retain) NSString* guestTeam;

@property (nonatomic,retain) NSString* matchTime;

@property (nonatomic,retain) UIButton *buttonCang;
@property (nonatomic,assign) BOOL isShouCang;
@property (nonatomic,assign) BOOL shouCangButtonIsHidden;

@property (nonatomic,retain) NSString* homeScore;
@property (nonatomic,retain) NSString* guestScore;
@property (nonatomic,retain) NSString* homeHalfScore;
@property (nonatomic,retain) NSString* guestHalfScore;
//@property (nonatomic,retain) NSString* red;
//@property (nonatomic,retain) NSString* yellow;

@property (nonatomic,retain) InstantScoreViewController* superViewController;
@property (nonatomic,retain) BJDC_instantScoreViewController* bdSuperViewController;
-(void) refreshTableCell;

@end
