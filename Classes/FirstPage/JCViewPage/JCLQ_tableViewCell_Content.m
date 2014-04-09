//
//  JCLQ_tableViewCell_Content.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCLQ_tableViewCell_Content.h"
#import "RuYiCaiCommon.h"
@interface JCLQ_tableViewCell_Content (internal)
-(void) visitTeamButtonClick;
-(void) homeTeamButtonClick;

-(void) ZQ_S_ButtonClick;
-(void) ZQ_P_ButtonClick;
-(void) ZQ_F_ButtonClick;

-(void) SFCButtonClick;

-(void) FenXiButtonClick;

-(void) JC_Dan_ButtonClick;

-(void) visitTeamButtonImageChange; 
-(void) homeTeamButtonImageChange;

-(void) ZQ_S_ButtonButtonImageChange; 
-(void) ZQ_P_ButtonButtonImageChange;
-(void) ZQ_F_ButtonButtonImageChange; 
 
-(void) JC_Dan_ButtonButtonImageChange; 

-(BOOL) gameIsSelect;
@end

@implementation JCLQ_tableViewCell_Content

@synthesize lable_VS = m_lable_VS;
@synthesize isJCLQtableview = m_isJCLQtableview;
@synthesize league = m_league;
@synthesize endTime = m_endTime;
@synthesize homeTeam = m_homeTeam;
@synthesize VisitTeam = m_VisitTeam;
@synthesize fenxiButton = m_fenxiButton;

@synthesize teamld = m_teamld;
@synthesize weekld = m_weekld;
@synthesize v0 = m_v0;
@synthesize v1 = m_v1;
@synthesize v3 = m_v3;
@synthesize letPoint = m_letPoint;
@synthesize letVs_v0 = m_letVs_v0;
@synthesize letVs_v3 = m_letVs_v3;
@synthesize Big = m_Big;
@synthesize Small = m_Small;
@synthesize basePoint = m_basePoint;

@synthesize homeTeamButton = m_homeTeamButton;
@synthesize visitTeamButton = m_visitTeamButton;
@synthesize SFCButton = m_SFCButton;
@synthesize SFCButtonText =m_SFCButtonText;

@synthesize isHomeTeamSelect = m_isHomeTeamSelect;
@synthesize isVisitTeamSelect = m_isVisitTeamSelect;

@synthesize ZQ_S_Button = m_ZQ_S_Button;
@synthesize ZQ_P_Button = m_ZQ_P_Button;
@synthesize ZQ_F_Button = m_ZQ_F_Button;

@synthesize isZQ_S_Button_Select = m_isZQ_S_Button_Select;
@synthesize isZQ_P_Button_Select = m_isZQ_P_Button_Select;
@synthesize isZQ_F_Button_Select = m_isZQ_F_Button_Select;

@synthesize JC_Button_Dan = m_JC_Button_Dan;
@synthesize isJC_Button_Dan_Select = m_isJC_Button_Dan_Select;

@synthesize indexPath = m_indexPath;

@synthesize JCLQ_parentViewController = m_JCLQ_parentViewController;
@synthesize JCZQ_parentViewController = m_JCZQ_parentViewController;
@synthesize lable_endDate       = m_lable_endDate;
@synthesize lable_endWeek       = m_lable_endWeek;

@synthesize playTypeTag = m_playTypeTag;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 65 + 2 + 20)];
//        image.image = [UIImage imageNamed:@"jclq_listbackground.png"];
//        [self addSubview:image];
//        [image release];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 120)];
        image.image = [UIImage imageNamed:@"cellbg_c_bottom.png"];
        [self addSubview:image];
        [image release];
        
        
        UIImageView *analysisbgimage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 3, 300-6, 114)];
        analysisbgimage.image = [UIImage imageNamed:@"layout_c_Bg.png"];
        [self addSubview:analysisbgimage];
        [analysisbgimage release];
        
//        m_lable_league = [[UILabel alloc] initWithFrame:CGRectMake(2 + 9, 5, 60 +5, 30)];
//        m_lable_league.textAlignment = UITextAlignmentCenter;
//        m_lable_league.backgroundColor = [UIColor clearColor];
//        m_lable_league.font = [UIFont systemFontOfSize:12];
//        m_lable_league.lineBreakMode = UILineBreakModeWordWrap;
//        m_lable_league.numberOfLines = 2;
//        [self addSubview:m_lable_league];
        
        
        m_lable_endDate = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60 +5, 30)];
        m_lable_endDate.textAlignment = UITextAlignmentCenter;
        m_lable_endDate.backgroundColor = [UIColor clearColor];
        m_lable_endDate.font = [UIFont systemFontOfSize:12];
        m_lable_endDate.lineBreakMode = UILineBreakModeWordWrap;
        m_lable_endDate.numberOfLines = 2;
        [self addSubview:m_lable_endDate];
        
        m_lable_endWeek = [[UILabel alloc] initWithFrame:CGRectMake(12+70, 5, 60 +5, 30)];
        m_lable_endWeek.textAlignment = UITextAlignmentCenter;
        m_lable_endWeek.backgroundColor = [UIColor clearColor];
        m_lable_endWeek.font = [UIFont systemFontOfSize:12];
        m_lable_endWeek.lineBreakMode = UILineBreakModeWordWrap;
        m_lable_endWeek.numberOfLines = 2;
        [self addSubview:m_lable_endWeek];
        
        
        UILabel *haoLable = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 60 +5, 20)];
        haoLable.textAlignment = UITextAlignmentCenter;
        haoLable.backgroundColor = [UIColor clearColor];
        haoLable.text = @"编号：";
        haoLable.font = [UIFont systemFontOfSize:13];
        [self addSubview:haoLable];
        [haoLable release];
        
        m_teamldlable = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 65, 30)];
        m_teamldlable.textAlignment = UITextAlignmentLeft;
        m_teamldlable.backgroundColor = [UIColor clearColor];
        m_teamldlable.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:m_teamldlable];
 
        
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 50, 49, 28)];
        timeImageView.image  = [UIImage imageNamed:@"uptimeBg.png"];
        [self addSubview:timeImageView];
        [timeImageView release];
        
        m_lable_endTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 49, 49, 20)];
        m_lable_endTime.textAlignment = UITextAlignmentCenter;
        m_lable_endTime.backgroundColor = [UIColor clearColor];
        m_lable_endTime.font = [UIFont systemFontOfSize:12];
        m_lable_endTime.lineBreakMode = UILineBreakModeWordWrap;
//        m_lable_endTime.numberOfLines = 2;
        [self addSubview:m_lable_endTime];
        
        
        m_lable_league = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 60 +5, 30)];
        m_lable_league.textAlignment = UITextAlignmentCenter;
        m_lable_league.backgroundColor = [UIColor clearColor];
        m_lable_league.font = [UIFont systemFontOfSize:10];
        m_lable_league.lineBreakMode = UILineBreakModeWordWrap;
//        m_lable_league.numberOfLines = 2;
        [self addSubview:m_lable_league];

 
//        UIImageView *imageId = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 25, 15)];
//        imageId.image = [UIImage imageNamed:@"jcteamId.png"];
//        [self addSubview:imageId];
//        [imageId release];
        

        /*
         篮球 客队在前 
         足球 主队在前
         */
            //默认 竞彩篮球
            m_lable_visitTeam = [[UILabel alloc] initWithFrame:CGRectMake(/*85*/80, 30, 100, 35)];
            m_lable_visitTeam.textAlignment = UITextAlignmentCenter;
            m_lable_visitTeam.backgroundColor = [UIColor clearColor];
            m_lable_visitTeam.font = [UIFont systemFontOfSize:13];
            m_lable_visitTeam.lineBreakMode = UILineBreakModeWordWrap;
            m_lable_visitTeam.numberOfLines = 1;
            [self addSubview:m_lable_visitTeam];     
            
            visitTeamlable = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, 100, 20)];
            visitTeamlable.textAlignment = UITextAlignmentCenter;
            visitTeamlable.backgroundColor = [UIColor clearColor];
            visitTeamlable.text = @"(客)";
            visitTeamlable.font = [UIFont systemFontOfSize:13];
            [self addSubview:visitTeamlable];  
            
            HomeTeamlable = [[UILabel alloc] initWithFrame:CGRectMake(180, 55, 100, 20)];
            HomeTeamlable.textAlignment = UITextAlignmentCenter;
            HomeTeamlable.backgroundColor = [UIColor clearColor];
            HomeTeamlable.text = @"(主)";
            HomeTeamlable.font = [UIFont systemFontOfSize:13];
            [self addSubview:HomeTeamlable];  
            
            m_lable_homeTeam = [[UILabel alloc] initWithFrame:CGRectMake(190, 30, 80, 35)];
            m_lable_homeTeam.textAlignment = UITextAlignmentCenter;
            m_lable_homeTeam.backgroundColor = [UIColor clearColor];
            m_lable_homeTeam.font = [UIFont systemFontOfSize:13];
            m_lable_homeTeam.lineBreakMode = UILineBreakModeWordWrap;
            m_lable_homeTeam.numberOfLines = 1;
            [self addSubview:m_lable_homeTeam];
        
            m_fenxiButton = [[UIButton alloc] initWithFrame:CGRectMake(273,10, 22, 22)];
            [m_fenxiButton addTarget:self action: @selector(FenXiButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [m_fenxiButton setBackgroundImage:[UIImage imageNamed:@"analysisbg.png"] forState:UIControlStateNormal]; 
            [self addSubview:m_fenxiButton];
 
        m_lable_VS = [[UILabel alloc] initWithFrame:CGRectMake(155, 50, 40, 30)];
//        m_lable_VS.text = @"VS";
        [m_lable_VS setTextColor:[UIColor redColor]];
        m_lable_VS.textAlignment = UITextAlignmentCenter;
        m_lable_VS.backgroundColor = [UIColor clearColor];
        m_lable_VS.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lable_VS];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{

    [m_lable_VS release];
    [m_lable_endWeek release];
    [m_lable_endDate release];
    [m_league release];
    [m_endTime release];
    [m_homeTeam release];
    [m_VisitTeam release];
    
    [m_teamld release];
    [m_weekld release];
    [m_v0 release];
    [m_v1 release];
    [m_v3 release];
    [m_letPoint release];
    [m_letVs_v0 release];
    [m_letVs_v3 release];
    [m_basePoint release];
    [m_Big release];
    [m_Small release];
    
    [m_visitTeamButton release];
    [m_homeTeamButton release];
    [m_SFCButton release];
    [m_SFCButtonText release];
    
    [m_ZQ_F_Button release];
    [m_ZQ_P_Button release];
    [m_ZQ_S_Button release];
    
    [m_lable_league release];
    [m_lable_endTime release];
    [m_lable_visitTeam release];
    [m_lable_homeTeam release];
    [m_lable_v0 release];
    [m_lable_v3 release];
 
    [m_lable_VS release];
    [m_indexPath release];
    [m_Big release];
    [m_Small release];
    
    [m_fenxiButton release];
    
    [HomeTeamlable release];
    [visitTeamlable release];
    
    [m_teamldlable release];
    [super dealloc];
}
-(void) visitTeamButtonClick 
{
    //设置图片 
    if (m_isJCLQtableview) {
        m_isVisitTeamSelect = !m_isVisitTeamSelect;
        BOOL notOverMax = [m_JCLQ_parentViewController changeClickState:m_indexPath clickState:m_isVisitTeamSelect ButtonIndex:2];
        if (notOverMax)
        {
            [self visitTeamButtonImageChange];
        }
        else 
        {
            /*
             返回 最初的状态
             */
            m_isVisitTeamSelect = !m_isVisitTeamSelect;
        }
    }
}
-(void) homeTeamButtonClick
{
    if (m_isJCLQtableview) {
        m_isHomeTeamSelect = !m_isHomeTeamSelect;
        BOOL notOverMax = [m_JCLQ_parentViewController changeClickState:m_indexPath clickState:m_isHomeTeamSelect ButtonIndex:1];
        if (notOverMax)
        {
            [self homeTeamButtonImageChange];
        }
        else
        {
            m_isHomeTeamSelect = !m_isHomeTeamSelect;
        }
    }
}

-(void) ZQ_S_ButtonClick
{
    m_isZQ_S_Button_Select = !m_isZQ_S_Button_Select;
 
    if (!m_isJCLQtableview) {
        /*
         函数返回值 代表是否超过最大比赛数
         */
        BOOL notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isZQ_S_Button_Select ButtonIndex:1];
        if (notOverMax) 
        {
            [self ZQ_S_ButtonButtonImageChange];
        }
        else
        {
            m_isZQ_S_Button_Select = !m_isZQ_S_Button_Select;
        }
        
    }
}
-(void) ZQ_P_ButtonClick
{
    m_isZQ_P_Button_Select = !m_isZQ_P_Button_Select;
 
    if (!m_isJCLQtableview) {
        
        /*
         函数返回值 代表是否超过最大比赛数
         */
        BOOL notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isZQ_P_Button_Select ButtonIndex:2];
        if (notOverMax) 
        {
            [self ZQ_P_ButtonButtonImageChange];
        }
        else
        {
            m_isZQ_P_Button_Select = !m_isZQ_P_Button_Select;
        }
    }
}
-(void) ZQ_F_ButtonClick
{
    m_isZQ_F_Button_Select = !m_isZQ_F_Button_Select;
    if (!m_isJCLQtableview)
    {
        
        /*
         函数返回值 代表是否超过最大比赛数
         */
        BOOL notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isZQ_F_Button_Select ButtonIndex:3];
        if (notOverMax) 
        {
            [self ZQ_F_ButtonButtonImageChange];
        }
        else
        {
            m_isZQ_F_Button_Select = !m_isZQ_F_Button_Select;
        }
    }
}
-(void) JC_Dan_ButtonClick
{
    BOOL gameIsSelect = [self gameIsSelect];
    if (!m_isJCLQtableview && gameIsSelect)
    {
         m_isJC_Button_Dan_Select = !m_isJC_Button_Dan_Select;
        /*
         函数返回值 代表是否超过最大比赛数
         */
        BOOL notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isJC_Button_Dan_Select ButtonIndex:4];
        if (notOverMax) 
        {
            [self JC_Dan_ButtonButtonImageChange];
        }
        else
        {
            m_isJC_Button_Dan_Select = !m_isJC_Button_Dan_Select;
        }
    }
    else if(m_isJCLQtableview && gameIsSelect)
    {
        m_isJC_Button_Dan_Select = !m_isJC_Button_Dan_Select;
        /*
         函数返回值 代表是否超过最大比赛数z
         */
        BOOL notOverMax =  [m_JCLQ_parentViewController changeClickState:m_indexPath clickState:m_isJC_Button_Dan_Select ButtonIndex:4];
        if (notOverMax) 
        {
            [self JC_Dan_ButtonButtonImageChange];
        }
        else
        {
            m_isJC_Button_Dan_Select = !m_isJC_Button_Dan_Select;
        }
    
    }
}
-(void) SFCButtonClick
{
    if (m_isJCLQtableview) {
        
        [m_JCLQ_parentViewController gotoSFCView:m_indexPath];
    }
    else
    {
        [m_JCZQ_parentViewController gotoSFCView:m_indexPath];
    }    
}

-(void) FenXiButtonClick
{
    if (m_isJCLQtableview) {
        
        [m_JCLQ_parentViewController gotoFenxiView:m_indexPath];
    }
    else
    {
        [m_JCZQ_parentViewController gotoFenxiView:m_indexPath];
    }
}
-(void) RefreshCellView
{
    if (m_isJCLQtableview) {
        if (m_playTypeTag ==  IJCLQPlayType_SF || m_playTypeTag ==IJCLQPlayType_LetPoint ||m_playTypeTag == IJCLQPlayType_BigAndSmall || m_playTypeTag ==  IJCLQPlayType_SF_DanGuan || m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan ||m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan ) {
            if (m_homeTeamButton != nil) {
                [m_homeTeamButton removeFromSuperview];
                [m_homeTeamButton release];
            }
            if (m_visitTeamButton != nil) {
                [m_visitTeamButton removeFromSuperview];
                [m_visitTeamButton release];
            }
            if (m_SFCButton != nil) {
                m_SFCButton.hidden = YES;
            }
            
            m_visitTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 30 + 20+30, 80, 30)];
            [m_visitTeamButton addTarget:self action: @selector(visitTeamButtonClick) forControlEvents:UIControlEventTouchUpInside];  
            [m_visitTeamButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_visitTeamButton.titleLabel.font = [UIFont systemFontOfSize:13];
            m_visitTeamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self addSubview:m_visitTeamButton];
            
            m_homeTeamButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 30+ 20+30, 80, 30)];
            [m_homeTeamButton addTarget:self action: @selector(homeTeamButtonClick) forControlEvents:UIControlEventTouchUpInside];  
            [m_homeTeamButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_homeTeamButton.titleLabel.font = [UIFont systemFontOfSize:13];
            m_homeTeamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self addSubview:m_homeTeamButton];
            
            if (m_playTypeTag ==  IJCLQPlayType_SF ||
                m_playTypeTag ==  IJCLQPlayType_SF_DanGuan) 
            {
                m_lable_VS.text = @"VS";
                m_lable_VS.textColor = [UIColor redColor];
                [m_visitTeamButton setTitle:[NSString stringWithFormat:@"主负 %@",m_v0] forState:UIControlStateNormal];
                [m_homeTeamButton setTitle:[NSString stringWithFormat:@"主胜 %@",m_v3] forState:UIControlStateNormal];
            }
            else if(m_playTypeTag ==  IJCLQPlayType_LetPoint ||
                    m_playTypeTag ==  IJCLQPlayType_LetPoint_DanGuan)
            {
                if ([m_letPoint length] > 0) {
                    UniChar chr = [m_letPoint characterAtIndex:0];
                    
                    if (chr == '-') {
                        m_lable_VS.text = m_letPoint;
                        m_lable_VS.textColor = [UIColor blueColor];
                    }
                    else
                    {
                        m_lable_VS.text = m_letPoint;
                        m_lable_VS.textColor = [UIColor redColor];
                    }
                }

                [m_visitTeamButton setTitle:[NSString stringWithFormat:@"主负 %@",m_letVs_v0] forState:UIControlStateNormal];
                [m_homeTeamButton setTitle:[NSString stringWithFormat:@"主胜 %@",m_letVs_v3] forState:UIControlStateNormal];
            }
            else if(m_playTypeTag == IJCLQPlayType_BigAndSmall ||
                    m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan
                    )
            {
                m_lable_VS.text = m_basePoint;
                m_lable_VS.textColor = [UIColor redColor];
                [m_visitTeamButton setTitle:[NSString stringWithFormat:@"大 %@",m_Big] forState:UIControlStateNormal];
                [m_homeTeamButton setTitle:[NSString stringWithFormat:@"小 %@",m_Small] forState:UIControlStateNormal];
            }
            
            [self visitTeamButtonImageChange];
            [self homeTeamButtonImageChange];
        }
        
        else if(m_playTypeTag == IJCLQPlayType_SFC ||
                m_playTypeTag == IJCLQPlayType_SFC_DanGuan)
        {
            if (m_homeTeamButton != nil) {
                m_homeTeamButton.hidden = YES;
            }
            if (m_visitTeamButton != nil) {
                m_visitTeamButton.hidden = YES;
            }
            if (m_SFCButton != nil) {
                [m_SFCButton removeFromSuperview];
                [m_SFCButton release];
            }
            m_lable_VS.text = @"VS";
            m_lable_VS.textColor = [UIColor redColor];
            m_SFCButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 30+ 20+30, 185, 30)];
            [m_SFCButton addTarget:self action: @selector(SFCButtonClick) forControlEvents:UIControlEventTouchUpInside];  
            [m_SFCButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_SFCButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            m_SFCButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [m_SFCButton setTitle:[NSString stringWithString:m_SFCButtonText] forState:UIControlStateNormal];
            
            [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_click.png"] forState:UIControlStateNormal]; 
            [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_normal.png"] forState:UIControlStateHighlighted]; 
            
            [self addSubview:m_SFCButton];
        }

    }
    else
    {
        if (m_playTypeTag ==  IJCZQPlayType_ZJQ ||
            m_playTypeTag ==IJCZQPlayType_Score ||
            m_playTypeTag == IJCZQPlayType_HalfAndAll||
            m_playTypeTag ==  IJCZQPlayType_ZJQ_DanGuan ||
            m_playTypeTag ==IJCZQPlayType_Score_DanGuan ||
            m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan)
        {
            if (m_ZQ_S_Button != nil) {
                m_ZQ_S_Button.hidden = YES;
            }
            if (m_ZQ_P_Button != nil) {
                m_ZQ_P_Button.hidden = YES;
            }
            if (m_ZQ_F_Button != nil) {
                m_ZQ_F_Button.hidden = YES;
            }
            
            if (m_SFCButton != nil) {
                [m_SFCButton removeFromSuperview];
                [m_SFCButton release];
            }
            m_lable_VS.text = @"VS";
            m_lable_VS.textColor = [UIColor redColor];
            m_SFCButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 30+ 20+30, 185, 30)];
            [m_SFCButton addTarget:self action: @selector(SFCButtonClick) forControlEvents:UIControlEventTouchUpInside];  
            [m_SFCButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_SFCButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            m_SFCButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [m_SFCButton setTitle:[NSString stringWithString:m_SFCButtonText] forState:UIControlStateNormal];
            
            [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_click.png"] forState:UIControlStateNormal]; 
            [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_normal.png"] forState:UIControlStateHighlighted]; 
            
            [self addSubview:m_SFCButton];
        }
        else if(m_playTypeTag ==  IJCZQPlayType_RQ_SPF ||
                m_playTypeTag ==  IJCZQPlayType_RQ_SPF_DanGuan)
        {
            if (m_ZQ_S_Button != nil) {
                [m_ZQ_S_Button removeFromSuperview];
                [m_ZQ_S_Button release];
            }
            if (m_ZQ_P_Button != nil) {
                [m_ZQ_P_Button removeFromSuperview];
                [m_ZQ_P_Button release];
            }
            if (m_ZQ_F_Button != nil) {
                [m_ZQ_F_Button removeFromSuperview];
                [m_ZQ_F_Button release];
            }
            if (m_SFCButton != nil) {
                m_SFCButton.hidden = YES;
            }
            
            m_ZQ_S_Button = [[UIButton alloc] initWithFrame:CGRectMake(85, 80, 60, 30)];
            [m_ZQ_S_Button addTarget:self action: @selector(ZQ_S_ButtonClick) forControlEvents:UIControlEventTouchUpInside];  
            [m_ZQ_S_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_ZQ_S_Button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            m_ZQ_S_Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self addSubview:m_ZQ_S_Button];
            
            m_ZQ_P_Button = [[UIButton alloc] initWithFrame:CGRectMake(85 + 65, 80, 60, 30)];
            [m_ZQ_P_Button addTarget:self action: @selector(ZQ_P_ButtonClick) forControlEvents:UIControlEventTouchUpInside];  
            [m_ZQ_P_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_ZQ_P_Button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            m_ZQ_P_Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self addSubview:m_ZQ_P_Button];
            
            m_ZQ_F_Button = [[UIButton alloc] initWithFrame:CGRectMake(85 + 65 * 2, 80, 55, 30)];
            [m_ZQ_F_Button addTarget:self action: @selector(ZQ_F_ButtonClick) forControlEvents:UIControlEventTouchUpInside];  
            [m_ZQ_F_Button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            m_ZQ_F_Button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            m_ZQ_F_Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self addSubview:m_ZQ_F_Button];
            
            if ([m_letPoint length] > 0)
            {
                UniChar chr = [m_letPoint characterAtIndex:0]; 
                if (chr == '-') 
                {
                    m_lable_VS.text = m_letPoint;
                    m_lable_VS.textColor = [UIColor blueColor];
                }
                else
                {
                    m_lable_VS.text = m_letPoint;
                    m_lable_VS.textColor = [UIColor redColor];
                }
            }
 
            [m_ZQ_S_Button setTitle:[NSString stringWithFormat:@"胜 %@",m_v0] forState:UIControlStateNormal];
            [m_ZQ_P_Button setTitle:[NSString stringWithFormat:@"平 %@",m_v1] forState:UIControlStateNormal];
            [m_ZQ_F_Button setTitle:[NSString stringWithFormat:@"负 %@",m_v3] forState:UIControlStateNormal];
 
            [self ZQ_S_ButtonButtonImageChange];
            [self ZQ_P_ButtonButtonImageChange];
            [self ZQ_F_ButtonButtonImageChange];
            
        }
    }
 
    [m_lable_league setText:m_league];
 
    [m_lable_endTime setText:m_endTime];
 
    [m_lable_homeTeam setText:m_homeTeam];
 
    [m_lable_visitTeam setText:m_VisitTeam];
    
    m_lable_homeTeam.font = [UIFont systemFontOfSize:13];
    m_lable_visitTeam.font = [UIFont systemFontOfSize:13];
    
    if (!m_isJCLQtableview) //竞彩足球 主队在前
    {
        m_lable_homeTeam.frame = CGRectMake(70, 30, 100, 35);
        m_lable_visitTeam.frame = CGRectMake(185, 30, 100, 35);
        
        HomeTeamlable.frame = CGRectMake(70, 50, 100, 20);
        HomeTeamlable.text = @"(主)";
        
        visitTeamlable.frame = CGRectMake(195, 50, 90, 20);
        visitTeamlable.text = @"(客)";
    }
    
    if (m_playTypeTag == IJCLQPlayType_SF ||
        m_playTypeTag == IJCLQPlayType_LetPoint ||
        m_playTypeTag == IJCLQPlayType_SFC ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall ||
  
        m_playTypeTag == IJCZQPlayType_RQ_SPF ||
        m_playTypeTag == IJCZQPlayType_ZJQ ||
        m_playTypeTag == IJCZQPlayType_Score ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll 
        )
    {
        //胆
        if (m_JC_Button_Dan) {
            [m_JC_Button_Dan removeFromSuperview];
            [m_JC_Button_Dan release];
            m_JC_Button_Dan = NULL;
        }
        m_JC_Button_Dan = [[UIButton alloc] initWithFrame:CGRectMake(275,80, 30, 30)];
        [m_JC_Button_Dan addTarget:self action: @selector(JC_Dan_ButtonClick) forControlEvents:UIControlEventTouchUpInside];  
        [m_JC_Button_Dan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_JC_Button_Dan.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        m_JC_Button_Dan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [m_JC_Button_Dan setTitle:@"胆" forState:UIControlStateNormal];
        [self addSubview:m_JC_Button_Dan];
    }
    else
    {
        if (m_JC_Button_Dan) {
            [m_JC_Button_Dan removeFromSuperview];
            [m_JC_Button_Dan release];
            m_JC_Button_Dan = NULL;
        }
        if (m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan) {
            m_ZQ_F_Button.frame = CGRectMake(85 + 65 * 2,80, 60, 30);
        }
    }
    
    m_teamldlable.text = m_teamld;
    [self JC_Dan_ButtonButtonImageChange];

//    if (m_isJCLQtableview) 
//    {
//        if (m_fenxiButton) {
//            [m_fenxiButton removeFromSuperview];
//            [m_fenxiButton release];
//            m_fenxiButton = NULL;
//        }
//    }
}


-(void) visitTeamButtonImageChange
{
    if (m_isVisitTeamSelect) {
        [m_visitTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonselect.png"] forState:UIControlStateNormal];
        [m_visitTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonnoselect.png"] forState:UIControlStateHighlighted]; 
    }
    else
    {
        [m_visitTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonnoselect.png"] forState:UIControlStateNormal];
        [m_visitTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonselect.png"] forState:UIControlStateHighlighted]; 
    }
}
-(void) homeTeamButtonImageChange
{
    if (m_isHomeTeamSelect) {
        [m_homeTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonselect.png"] forState:UIControlStateNormal]; 
        [m_homeTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonnoselect.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [m_homeTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonnoselect.png"] forState:UIControlStateNormal]; 
        [m_homeTeamButton setBackgroundImage:[UIImage imageNamed:@"jclq_buttonselect.png"] forState:UIControlStateHighlighted]; 
    }
}

-(void) ZQ_S_ButtonButtonImageChange
{
    if (m_isZQ_S_Button_Select) {
        [m_ZQ_S_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_click.png"] forState:UIControlStateNormal];
        [m_ZQ_S_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_nomal.png"] forState:UIControlStateHighlighted]; 
    }
    else
    {
        [m_ZQ_S_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_nomal.png"] forState:UIControlStateNormal]; 
        [m_ZQ_S_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_click.png"] forState:UIControlStateHighlighted]; 
    }
}

-(void) ZQ_P_ButtonButtonImageChange
{
    if (m_isZQ_P_Button_Select) {
        [m_ZQ_P_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_click.png"] forState:UIControlStateNormal]; 
        [m_ZQ_P_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_nomal.png"] forState:UIControlStateHighlighted]; 
    }
    else
    {
        [m_ZQ_P_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_nomal.png"] forState:UIControlStateNormal]; 
        [m_ZQ_P_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_click.png"] forState:UIControlStateHighlighted]; 
    }
}

-(void) ZQ_F_ButtonButtonImageChange
{
    if (m_isZQ_F_Button_Select) {
        [m_ZQ_F_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_click.png"] forState:UIControlStateNormal]; 
        [m_ZQ_F_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_nomal.png"] forState:UIControlStateHighlighted]; 
    }
    else
    {
        [m_ZQ_F_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_nomal.png"] forState:UIControlStateNormal]; 
        [m_ZQ_F_Button setBackgroundImage:[UIImage imageNamed:@"jczq_c_click.png"] forState:UIControlStateHighlighted]; 
    }
}
-(void) JC_Dan_ButtonButtonImageChange
{
    if (m_isJC_Button_Dan_Select) {
        [m_JC_Button_Dan setBackgroundImage:[UIImage imageNamed:@"danbtn_c_click.png"] forState:UIControlStateNormal];
        [m_JC_Button_Dan setBackgroundImage:[UIImage imageNamed:@"danbtn_c_nomal.png"] forState:UIControlStateHighlighted]; 
    }
    else
    {
        [m_JC_Button_Dan setBackgroundImage:[UIImage imageNamed:@"danbtn_c_nomal.png"] forState:UIControlStateNormal]; 
        [m_JC_Button_Dan setBackgroundImage:[UIImage imageNamed:@"danbtn_c_click.png"] forState:UIControlStateHighlighted]; 
    }
}
-(BOOL) gameIsSelect
{
    if (m_isJCLQtableview) {
        int count = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_JCLQ_parentViewController.tableCell_DataArray objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] count];
        if (m_isVisitTeamSelect || m_isHomeTeamSelect || count > 0) {
            return TRUE;
        }
    }
    else
    {
    JCLQ_tableViewCell_DataBase* tableCell = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_JCZQ_parentViewController.tableCell_DataArray objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]];
 
    int goalArrayCount = [[tableCell sfc_selectTag] count];
   
    if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] || goalArrayCount > 0)
        {
            return TRUE;
        }
    }
    return FALSE;
}
@end

//-----------------------------------data------------------------------

@implementation JCLQ_tableViewCell_DataBase
@synthesize dayTime = m_dayTime;
@synthesize dayforamt = m_dayForamt;
@synthesize league = m_league;
@synthesize endTime = m_endTime;
@synthesize homeTeam = m_homeTeam;
@synthesize VisitTeam = m_VisitTeam;
@synthesize week = m_week;

@synthesize teamld = m_teamld;
@synthesize weekld = m_weekld;
@synthesize v0 = m_v0;
@synthesize v1 = m_v1;
@synthesize v3 = m_v3;
@synthesize letPoint = m_letPoint;
@synthesize letVs_v0 = m_letVs_v0;
@synthesize letVs_v3 = m_letVs_v3;
@synthesize Big = m_Big;
@synthesize Small = m_Small;
@synthesize basePoint = m_basePoint;
@synthesize sfc_selectTag = m_sfc_selectTag;

@synthesize sfcV01 = m_sfcV01;
@synthesize sfcV02 = m_sfcV02;
@synthesize sfcV03 = m_sfcV03;
@synthesize sfcV04 = m_sfcV04;
@synthesize sfcV05 = m_sfcV05;
@synthesize sfcV06 = m_sfcV06;
@synthesize sfcV11 = m_sfcV11;
@synthesize sfcV12 = m_sfcV12;
@synthesize sfcV13 = m_sfcV13;
@synthesize sfcV14 = m_sfcV14;
@synthesize sfcV15 = m_sfcV15;
@synthesize sfcV16 = m_sfcV16;

@synthesize goalArray = m_goalArray;
@synthesize score_S_Array = m_score_S_Array;
@synthesize score_P_Array = m_score_P_Array;
@synthesize score_F_Array = m_score_F_Array;
@synthesize half_Array = m_half_Array;

@synthesize ZQ_S_ButtonIsSelect = m_ZQ_S_ButtonIsSelect;
@synthesize ZQ_P_ButtonIsSelect = m_ZQ_P_ButtonIsSelect;
@synthesize ZQ_F_ButtonIsSelect = m_ZQ_F_ButtonIsSelect;

@synthesize isUnSupportArry = m_isUnSupportArray;
- (id)init {
    self = [super init];
    if (self)
    {
        m_sfc_selectTag = [[NSMutableArray alloc] initWithCapacity:10];
        
        m_goalArray = [[NSMutableArray alloc] initWithCapacity:10];
        m_score_S_Array = [[NSMutableArray alloc] initWithCapacity:10];
        m_score_P_Array = [[NSMutableArray alloc] initWithCapacity:10];
        m_score_F_Array = [[NSMutableArray alloc] initWithCapacity:10];
        m_half_Array = [[NSMutableArray alloc] initWithCapacity:10];
        
        m_isUnSupportArray = [[NSMutableArray alloc] initWithCapacity:10];
        m_JC_DanIsSelect = NO;
    }
    return self;
}

- (void)dealloc {
    [m_dayTime release];
    [m_dayForamt release];
    [m_league release];
    [m_endTime release];
    [m_homeTeam release];
    [m_VisitTeam release];
    
    [m_week release];
    [m_teamld release];
    [m_weekld release];
    [m_v0 release];
    [m_v1 release];
    [m_v3 release];
    [m_letPoint release];
    [m_letVs_v0 release];
    [m_letVs_v3 release];
    [m_Big release];
    [m_Small release];
    [m_basePoint release];
    
    [m_sfcV01 release];
    [m_sfcV02 release];
    [m_sfcV03 release];
    [m_sfcV04 release];
    [m_sfcV05 release];
    [m_sfcV06 release];
    [m_sfcV11 release];
    [m_sfcV12 release];
    [m_sfcV13 release];
    [m_sfcV14 release];
    [m_sfcV15 release];
    [m_sfcV16 release];
    
    [m_sfc_selectTag release];
    
    [m_goalArray release];
    [m_score_S_Array release];
    [m_score_P_Array release];
    [m_score_F_Array release];
    [m_half_Array release];
    
    [m_isUnSupportArray release];
    [super dealloc];
}

-(BOOL) visitTeamIsSelect
{
    return m_visitTeamIsSelect;
}
-(BOOL) homeTeamIsSelect
{
    return m_homeTeamIsSelect;
}
-(BOOL) JC_DanIsSelect
{
    return m_JC_DanIsSelect;
}
-(void) setJC_DanIsSelect:(BOOL)JC_DanIsSelect
{
    m_JC_DanIsSelect = JC_DanIsSelect;
}

-(void) setVisitTeamIsSelect:(BOOL)visitTeamIsSelect
{
    m_visitTeamIsSelect = visitTeamIsSelect;
}
-(void) setHomeTeamIsSelect:(BOOL)homeTeamIsSelect
{
    m_homeTeamIsSelect = homeTeamIsSelect;
}

-(void) appendToBaseUnSupportDuiZhen:(NSString*)lotNo
{
    NSArray* Array =  [lotNo componentsSeparatedByString:@"_"];
    if ([Array count] == 2)
    {
        NSString *lotNo = [Array objectAtIndex:0];
        NSString *typeValue = [Array objectAtIndex:1];
        //0 单关 1多关
        if ([@"0" isEqual:typeValue]) 
        {
            if ([kLotNoJCLQ_SF isEqual:lotNo]) 
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SF_DanGuan]];
            }
            else if([kLotNoJCLQ_RF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_LetPoint_DanGuan]];
            }
            else if([kLotNoJCLQ_SFC isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SFC_DanGuan]];
            }
            else if([kLotNoJCLQ_DXF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_BigAndSmall_DanGuan]];
            }
        }
        else if([@"1" isEqual:typeValue])
        {
            if ([kLotNoJCLQ_SF isEqual:lotNo]) 
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SF]];
            }
            else if([kLotNoJCLQ_RF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_LetPoint]];
            }
            else if([kLotNoJCLQ_SFC isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_SFC]];
            }
            else if([kLotNoJCLQ_DXF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCLQPlayType_BigAndSmall]];
            }
        }
    }
}
@end

/////////////////////////////////////////////////

@implementation JCLQ_tableViewCell_DataArray
@synthesize tableHeaderArray = m_tableHeaderArray;
- (id)init {
    self = [super init];
    if (self)
    {
        //初始化 数组 
        m_tableHeaderArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSInteger) baseCount
{
    return [m_tableHeaderArray count];
}
- (void)dealloc {
    [m_tableHeaderArray removeAllObjects];
    [m_tableHeaderArray release];
    [super dealloc];
}
@end



