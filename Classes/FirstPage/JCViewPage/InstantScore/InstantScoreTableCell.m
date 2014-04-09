//
//  InstantScoreTableCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InstantScoreTableCell.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
@interface InstantScoreTableCell (inter)
- (void) buttonPress:(id)sender;
@end
@implementation InstantScoreTableCell

@synthesize scoreType = m_scoreType;
@synthesize progressedTime;
@synthesize matchState = m_matchState;
@synthesize event = m_event;
@synthesize homeTeam = m_homeTeam;
@synthesize guestTeam = m_guestTeam;
@synthesize matchTime = m_matchTime;

@synthesize sclassName = m_sclassName;
@synthesize buttonCang = m_buttonCang;
@synthesize isShouCang = m_isShouCang;

@synthesize homeScore = m_homeScore;
@synthesize guestScore = m_guestScore;

@synthesize homeHalfScore = m_homeHalfScore;
@synthesize guestHalfScore = m_guestHalfScore;
//@synthesize red = m_red;
//@synthesize yellow = m_yellow;

@synthesize superViewController = m_superViewController;
@synthesize bdSuperViewController = m_bdSuperViewController;
@synthesize shouCangButtonIsHidden = m_shouCangButtonIsHidden;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //联赛
        UIImageView *backimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        backimage.image = RYCImageNamed(@"jcinstantscore_cellbackimage.png");
        [self addSubview:backimage];
        [backimage release];
        
        m_buttonCang = [[UIButton alloc] initWithFrame:CGRectMake(5, 15, 30, 30)];
        [m_buttonCang setImage:[UIImage imageNamed:@"instantscore_shoucangnormal.png"] forState:UIControlStateNormal];
        [m_buttonCang setImage:[UIImage imageNamed:@"instantscore_shoucangnormal.png"] forState:UIControlStateHighlighted];
        [m_buttonCang addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_buttonCang];
        
        m_sclassNameLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 3, 70, 15)];
        m_sclassNameLable.textAlignment = UITextAlignmentLeft;
        m_sclassNameLable.backgroundColor = [UIColor clearColor];
        m_sclassNameLable.font = [UIFont boldSystemFontOfSize:12];
        m_sclassNameLable.textColor = [UIColor grayColor];
        [self addSubview:m_sclassNameLable];
        
        //时间
        m_matchTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 3, 140, 15)];
        m_matchTimeLable.textAlignment = UITextAlignmentLeft;
        m_matchTimeLable.backgroundColor = [UIColor clearColor];
        m_matchTimeLable.font = [UIFont boldSystemFontOfSize:12];
        m_matchTimeLable.textColor = [UIColor grayColor];
        [self addSubview:m_matchTimeLable];
        
        m_halfScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(240, 3, 60, 15)];
        m_halfScoreLable.textAlignment = UITextAlignmentCenter;
        m_halfScoreLable.backgroundColor = [UIColor clearColor];
        m_halfScoreLable.font = [UIFont boldSystemFontOfSize:12];
        m_halfScoreLable.textColor = [UIColor grayColor];
        [self addSubview:m_halfScoreLable];
        /*
         足球 主队在前，篮球 客队在前
         */
        //主队
        m_homeTeamLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 90, 45)];
        m_homeTeamLable.textAlignment = UITextAlignmentCenter;
        m_homeTeamLable.lineBreakMode = UILineBreakModeWordWrap;
        m_homeTeamLable.numberOfLines = 2;
        m_homeTeamLable.backgroundColor = [UIColor clearColor];
        m_homeTeamLable.font = [UIFont boldSystemFontOfSize:13];
        m_homeTeamLable.textColor = [UIColor blackColor];
        [self addSubview:m_homeTeamLable];
        
        UIImageView *Scoreimage = [[UIImageView alloc] initWithFrame:CGRectMake(120, 18, 80, 23)];
        Scoreimage.image = RYCImageNamed(@"jc_score_bg.png");
        [self addSubview:Scoreimage];
        [Scoreimage release];
        
        //竞彩足球 返回全场比分
        //全场比分
        m_homeScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 18, 35, 23)];
        m_homeScoreLable.textAlignment = UITextAlignmentCenter;
        m_homeScoreLable.backgroundColor = [UIColor clearColor];
        m_homeScoreLable.font = [UIFont boldSystemFontOfSize:12];
        m_homeScoreLable.textColor = kColorWithRGB(255.0, 204.0, 0.0, 1.0);
        [self addSubview:m_homeScoreLable];
        
        m_guestScoreLable = [[UILabel alloc] initWithFrame:CGRectMake(165, 18, 35, 23)];
        m_guestScoreLable.textAlignment = UITextAlignmentCenter;
        m_guestScoreLable.backgroundColor = [UIColor clearColor];
        m_guestScoreLable.font = [UIFont boldSystemFontOfSize:12];
        m_guestScoreLable.textColor = kColorWithRGB(255.0, 204.0, 0.0, 1.0);
        [self addSubview:m_guestScoreLable];
        
        //        m_resultLable = [[UILabel alloc] initWithFrame:CGRectMake(115, 30, 40, 20)];
        //        m_resultLable.textAlignment = UITextAlignmentCenter;
        //        m_resultLable.backgroundColor = [UIColor clearColor];
        //        m_resultLable.font = [UIFont boldSystemFontOfSize:12];
        //        m_resultLable.textColor = [UIColor grayColor];
        //        [self addSubview:m_resultLable];
        
        //        m_redPai = [[UIButton alloc] initWithFrame:CGRectMake(160, 32, 14, 15)];
        //        [m_redPai.titleLabel setFont:[UIFont systemFontOfSize:10]];
        //        [m_redPai setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [m_redPai setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //        [m_redPai setBackgroundImage:[UIImage imageNamed:@"instantscore_hongpai.png"] forState:UIControlStateNormal];
        //        [m_redPai setBackgroundImage:[UIImage imageNamed:@"instantscore_hongpai.png"] forState:UIControlStateHighlighted];
        //        [m_redPai setBackgroundColor:[UIColor clearColor]];
        //        [self addSubview:m_redPai];
        //
        //        m_yellowPai = [[UIButton alloc] initWithFrame:CGRectMake(180, 32, 14, 15)];
        //        [m_yellowPai.titleLabel setFont:[UIFont systemFontOfSize:10]];
        //        [m_yellowPai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [m_yellowPai setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        //        [m_yellowPai setBackgroundImage:[UIImage imageNamed:@"instantscore_huangpai.png"] forState:UIControlStateNormal];
        //        [m_yellowPai setBackgroundImage:[UIImage imageNamed:@"instantscore_huangpai.png"] forState:UIControlStateHighlighted];
        //        [m_yellowPai setBackgroundColor:[UIColor clearColor]];
        //
        //        [self addSubview:m_yellowPai];
        
        //状态
        m_stateMemoLable = [[UILabel alloc] initWithFrame:CGRectMake(120, 42, 80, 15)];
        m_stateMemoLable.textAlignment = UITextAlignmentCenter;
        m_stateMemoLable.backgroundColor = [UIColor clearColor];
        m_stateMemoLable.font = [UIFont boldSystemFontOfSize:12];
        m_stateMemoLable.textColor = [UIColor grayColor];
        [self addSubview:m_stateMemoLable];
        
        //客队
        m_guestTeamLable = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 110, 45)];
        m_guestTeamLable.textAlignment = UITextAlignmentCenter;
        m_guestTeamLable.lineBreakMode = UILineBreakModeWordWrap;
        m_guestTeamLable.numberOfLines = 2;
        m_guestTeamLable.backgroundColor = [UIColor clearColor];
        m_guestTeamLable.font = [UIFont boldSystemFontOfSize:13];
        m_guestTeamLable.textColor = [UIColor blackColor];
        [self addSubview:m_guestTeamLable];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.scoreType == BeiDan) {
        m_bdSuperViewController.selectDetailBatchCode = m_event;
    }
    else
    {
        m_superViewController.tempSelectEvent = m_event;
    }
    // Configure the view for the selected state
}

-(void) refreshTableCell
{
    m_eventLable.text = m_event;
    NSString* time = @"";
    time = [time stringByAppendingFormat:@"开赛：%@",m_matchTime];
    m_matchTimeLable.text = time;
    
    m_homeTeamLable.text = m_homeTeam;
    
    m_guestTeamLable.text = m_guestTeam;
    m_sclassNameLable.text = m_sclassName;
    
    
    if ([m_matchState isEqualToString:@"0"]) {
        m_stateMemoLable.textColor = [UIColor grayColor];
    }
    else{
        m_stateMemoLable.textColor = [UIColor redColor];
    }
    m_stateMemoLable.text = [NSString stringWithFormat:@"%@", self.progressedTime];
    
    
    //收藏按钮是否隐藏
    if (m_shouCangButtonIsHidden) {
        [m_buttonCang setHidden:YES];
    }
    else{
        [m_buttonCang setHidden:NO];
    }
    
    
    //我的关注
    if (self.isShouCang) {
        [m_buttonCang setImage:[UIImage imageNamed:@"instantscore_shoucangselect.png"] forState:UIControlStateNormal];
        [m_buttonCang setImage:[UIImage imageNamed:@"instantscore_shoucangselect.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [m_buttonCang setImage:[UIImage imageNamed:@"instantscore_shoucangnormal.png"] forState:UIControlStateNormal];
        [m_buttonCang setImage:[UIImage imageNamed:@"instantscore_shoucangnormal.png"] forState:UIControlStateHighlighted];
    }
    
    if (m_scoreType == JingCai) {
        
        if (self.superViewController.type == JCZQ) {
            m_halfScoreLable.hidden = NO;
            
            m_halfScoreLable.text = [NSString stringWithFormat:@"半场 %@:%@",m_homeHalfScore,m_guestHalfScore];
            m_homeScoreLable.text = m_homeScore;
            m_guestScoreLable.text = m_guestScore;
        }
        else
        {
            m_halfScoreLable.hidden = YES;
            
            if ([m_matchState isEqualToString:@"0"]) {
                m_homeScoreLable.text = @"0";
                m_guestScoreLable.text = @"0";
            }
            else
            {
                m_homeScoreLable.text = m_homeScore;
                m_guestScoreLable.text = m_guestScore;
            }
        }
    }
    else if (m_scoreType == BeiDan)
    {
        m_halfScoreLable.hidden = NO;
        
        m_halfScoreLable.text = [NSString stringWithFormat:@"半场 %@:%@",m_homeHalfScore,m_guestHalfScore];
        m_homeScoreLable.text = m_homeScore;
        m_guestScoreLable.text = m_guestScore;
    }
    
    
    
}

- (void) buttonPress:(id)sender
{
    
    if (self.isShouCang) {
        self.isShouCang = NO;
        [(UIButton*)sender setImage:[UIImage imageNamed:@"instantscore_shoucangnormal.png"] forState:UIControlStateNormal];
        [(UIButton*)sender setImage:[UIImage imageNamed:@"instantscore_shoucangnormal.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.isShouCang = YES;
        [(UIButton*)sender setImage:[UIImage imageNamed:@"instantscore_shoucangselect.png"] forState:UIControlStateNormal];
        [(UIButton*)sender setImage:[UIImage imageNamed:@"instantscore_shoucangselect.png"] forState:UIControlStateHighlighted];
    }
    
    if (![self.event isEqualToString:@""])
    {
        if (self.scoreType == JingCai) {
            [self.superViewController shouCangButtonClick:self.isShouCang INDEX:self.event];
        }
        else if (self.scoreType == BeiDan){
            [self.bdSuperViewController shouCangButtonClick:self.isShouCang INDEX:self.event];
        }
        
    }
}

- (void)dealloc
{
    [m_buttonCang release];
    [m_eventLable release];
    [m_sclassNameLable release];
    [m_homeTeamLable release];
    [m_guestTeamLable release];
    [m_matchTimeLable release];
    [m_stateMemoLable release];
    //    [m_resultLable release];
    //    [m_scoreLable release];
    [m_homeScoreLable release];
    [m_guestScoreLable release];
    [m_halfScoreLable release];
    //    [m_redPai release];
    //    [m_yellowPai release];
    [super dealloc];
}


@end
