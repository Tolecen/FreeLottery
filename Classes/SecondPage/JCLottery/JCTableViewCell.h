//
//  JCTableViewCell.h
//  RuYiCai
//
//  Created by  on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCTableViewCell : UITableViewCell
{
    int           m_isJCLQoPen;//竞彩篮球主客队位置需调换
    
    UILabel       *m_teamIdLabel;
    UILabel       *m_leagueLabel;
    UILabel       *m_teamOneLabel;
    UILabel       *m_teamTwoLabel;
    
    UILabel       *m_sampleRecordLabel;
    UILabel       *m_resultLabel;
    UILabel       *m_SPLabel;//赔率（北单）
    UILabel       *m_scoreLabel;//北单 比分
    
    NSString      *m_leagueStr;
    NSString      *m_letPoint;
    NSString      *m_homeTeamStr;
    NSString      *m_guestTeamStr;
    NSString      *m_resultStr;
//    UIImageView*   m_imageIco;
    
    UIImageView   *image_result;
}
@property(nonatomic, retain)NSString*    playType;

@property(nonatomic, assign)int          isJCLQoPen;
@property(nonatomic, retain)NSString      *teamId;
@property(nonatomic ,retain)NSString      *leagueStr;
@property(nonatomic ,retain)NSString      *letPoint;
@property(nonatomic ,retain)NSString      *homeTeamStr;
@property(nonatomic ,retain)NSString      *guestTeamStr;
@property(nonatomic ,retain)NSString      *resultStr;

@property(nonatomic, retain)NSString      *homeScore;
@property(nonatomic, retain)NSString      *guestScore;
@property(nonatomic, retain)NSString      *homeHalfScore;
@property(nonatomic, retain)NSString      *guestHalfScore;

@property(nonatomic, retain)NSString      *SPstring;

- (void)refresh;

@end
