//
//  JZTableViewCell.h
//  Boyacai
//
//  Created by qiushi on 13-8-15.
//
//

#import "JZHeighTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "ColorUtils.h"
#import "JC_MyButton.h"

@interface JZHeighTableViewCell (internal)
-(void) leftButtonClick;
-(void) rightButtonClick;
-(void) centerButtonClick;

-(void) SFCButtonClick;
-(void) FenXiButtonClick;
-(void) JC_Dan_ButtonClick;

-(void) leftButtonImageChange;
-(void) rightButtonImageChange;
-(void) centerButtonImageChange;

-(void) JC_Dan_ButtonButtonImageChange;

-(BOOL) gameIsSelect;
@end

@implementation JZHeighTableViewCell

@synthesize isJCLQtableview = m_isJCLQtableview;
@synthesize league = m_league;
@synthesize endTime = m_endTime;
@synthesize homeTeam = m_homeTeam;
@synthesize VisitTeam = m_VisitTeam;

@synthesize teamld = m_teamld;
@synthesize weekld = m_weekld;
@synthesize v0 = m_v0;
@synthesize v1 = m_v1;
@synthesize v3 = m_v3;

@synthesize vf = m_vf;
@synthesize vp = m_vp;
@synthesize vs = m_vs;

@synthesize letPoint = m_letPoint;
@synthesize letVs_v0 = m_letVs_v0;
@synthesize letVs_v3 = m_letVs_v3;
@synthesize Big = m_Big;
@synthesize Small = m_Small;
@synthesize basePoint = m_basePoint;


@synthesize sxdsV1 = m_sxdsV1;
@synthesize sxdsV2 = m_sxdsV2;
@synthesize sxdsV3 = m_sxdsV3;
@synthesize sxdsV4 = m_sxdsV4;

@synthesize SFCButton = m_SFCButton;
@synthesize SFCButtonText =m_SFCButtonText;

@synthesize isCenterSelect = m_isCenterSelect;
@synthesize isLeftSelect = m_isLeftSelect;
@synthesize isRightSelect = m_isRightSelect;
@synthesize isHidenFenXi = m_isHidenFenXi;

@synthesize indexPath = m_indexPath;
@synthesize JCZQ_parentViewController = m_JCZQ_parentViewController;

@synthesize playTypeTag = m_playTypeTag;
@synthesize isJC_Button_Dan_Select = m_isJC_Button_Dan_Select;
@synthesize expendButton    = m_expendButton;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
        
        [self setDetileExpend];
        
        UIView  *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 100)];
        leftBgView.backgroundColor = [ColorUtils parseColorFromRGB:@"#eeeae3"];
        [self addSubview:leftBgView];
        [leftBgView release];
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* downBgline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99, 320, 1)];
        downBgline.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:downBgline];
        [downBgline release];
        UIImageView* upBgline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        upBgline.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:upBgline];
        [upBgline release];
        
        UIImageView* verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 1, 100)];
        verticalLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:verticalLine];
        [verticalLine release];
        
        m_downLogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 70, 18/2, 11/2)];
        m_downLogImageView.image = [UIImage imageNamed:@"down_jc_expend.png"];
        [m_downLogImageView setHidden:NO];
        [self addSubview:m_downLogImageView];
        
        m_upLogImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(35, 100-11/2, 18/2, 11/2)];
        m_upLogImageView.image = [UIImage imageNamed:@"up_jc_expend.png"];
        [m_upLogImageView setHidden:YES];
        [self addSubview:m_upLogImageView];
        
        m_expendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_expendButton.frame = CGRectMake(0, 0, 75, 100);
        m_expendButton.backgroundColor = [UIColor clearColor];
        //        [m_expendButton addTarget:self action:@selector(expendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_expendButton];
        
        m_lable_league = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 75, 27)];
        m_lable_league.textAlignment = NSTextAlignmentCenter;
        m_lable_league.backgroundColor = [UIColor clearColor];
        //        m_lable_league.numberOfLines = 2;
        [self addSubview:m_lable_league];
        
        m_lable_endTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 80, 38)];
        m_lable_endTime.textAlignment = UITextAlignmentCenter;
        m_lable_endTime.backgroundColor = [UIColor clearColor];
        m_lable_endTime.font = [UIFont systemFontOfSize:10];
        m_lable_endTime.lineBreakMode = UILineBreakModeWordWrap;
        m_lable_endTime.numberOfLines = 3;
        [self addSubview:m_lable_endTime];
        
        
        /*
         篮球 客队在前
         足球 主队在前
         */
        //默认 竞彩篮球
        
        UIImageView *teamImageView = [[UIImageView alloc] initWithFrame:CGRectMake(76, 0, 320-75, 100)];
        teamImageView.backgroundColor = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
        [self addSubview:teamImageView];
        [teamImageView release];
        
        m_jclq_big_basePoint = [[UILabel alloc] initWithFrame:CGRectMake(156, 35, 39, 30)];
        [m_jclq_big_basePoint setTextColor:[UIColor blackColor]];
        m_jclq_big_basePoint.textAlignment = UITextAlignmentCenter;
        m_jclq_big_basePoint.backgroundColor = [UIColor clearColor];
        m_jclq_big_basePoint.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_jclq_big_basePoint];
        
        m_lable_VS = [[UILabel alloc] initWithFrame:CGRectMake(156, 5, 39, 30)];
        m_lable_VS.text = @"VS";
        [m_lable_VS setTextColor:[UIColor redColor]];
        m_lable_VS.textAlignment = UITextAlignmentCenter;
        m_lable_VS.backgroundColor = [UIColor clearColor];
        m_lable_VS.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lable_VS];
        
        m_lable_visitTeam = [[UILabel alloc] initWithFrame:CGRectMake(85, 2, 100, 35)];
        m_lable_visitTeam.textAlignment = UITextAlignmentCenter;
        m_lable_visitTeam.backgroundColor = [UIColor clearColor];
        m_lable_visitTeam.font = [UIFont boldSystemFontOfSize:13];
        m_lable_visitTeam.lineBreakMode = UILineBreakModeWordWrap;
        m_lable_visitTeam.numberOfLines = 2;
        [self addSubview:m_lable_visitTeam];
        
        m_lable_homeTeam = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 80, 35)];
        m_lable_homeTeam.textAlignment = UITextAlignmentCenter;
        m_lable_homeTeam.backgroundColor = [UIColor clearColor];
        m_lable_homeTeam.font = [UIFont boldSystemFontOfSize:13];
        m_lable_homeTeam.lineBreakMode = UILineBreakModeWordWrap;
        m_lable_homeTeam.numberOfLines = 2;
        [self addSubview:m_lable_homeTeam];
        //非让分图表制作
        m_handicapLable = [[UILabel alloc] initWithFrame:CGRectMake(76, 39, 14, 30)];
        m_handicapLable.backgroundColor = [ColorUtils parseColorFromRGB:@"#e4ffd9"];
        m_handicapLable.textColor = [ColorUtils parseColorFromRGB:@"#145a00"];
        m_handicapLable.text = @"非\n让\n分";
        m_handicapLable.lineBreakMode = NSLineBreakByWordWrapping;
        m_handicapLable.numberOfLines = [m_handicapLable.text length];
        m_handicapLable.font = [UIFont systemFontOfSize:10];
        m_handicapLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:m_handicapLable];
        
        //让分图表制作
        m_handicapLable = [[UILabel alloc] initWithFrame:CGRectMake(76, 70, 14, 30)];
        m_handicapLable.backgroundColor = [ColorUtils parseColorFromRGB:@"#ffd9d9"];
        m_handicapLable.textColor = [ColorUtils parseColorFromRGB:@"#c80000"];
        m_handicapLable.text = @"让\n分";
        m_handicapLable.lineBreakMode = NSLineBreakByWordWrapping;
        m_handicapLable.numberOfLines = [m_handicapLable.text length];
        m_handicapLable.font = [UIFont systemFontOfSize:10];
        m_handicapLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:m_handicapLable];
        
        
    }
    return self;
}
- (void)setDetileExpend
{
    
    m_expendView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 60)];
    m_expendView.backgroundColor = [UIColor redColor];
    [self addSubview:m_expendView];
    
    UIImageView *upBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    upBgImageView.backgroundColor = [ColorUtils parseColorFromRGB:@"#827c70"];
    [m_expendView addSubview:upBgImageView];
    [upBgImageView release];
    
    UILabel *paiLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 50, 20)];
    paiLable.text = @"两队排名";
    paiLable.backgroundColor = [UIColor clearColor];
    paiLable.textColor = [ColorUtils parseColorFromRGB:@"#ffffff"];
    paiLable.font = [UIFont systemFontOfSize:12];
    [m_expendView addSubview:paiLable];
    [paiLable release];
    
    
    
    UIImageView *centerBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    centerBgImageView.backgroundColor = [ColorUtils parseColorFromRGB:@"#797368"];
    [m_expendView addSubview:centerBgImageView];
    [centerBgImageView release];
    
    UILabel *historyLable = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 50, 20)];
    historyLable.text = @"历史交锋";
    historyLable.backgroundColor = [UIColor clearColor];
    historyLable.textColor = [ColorUtils parseColorFromRGB:@"#ffffff"];
    historyLable.font = [UIFont systemFontOfSize:12];
    [m_expendView addSubview:historyLable];
    [historyLable release];
    
    UIImageView *downBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 20)];
    downBgImageView.backgroundColor = [ColorUtils parseColorFromRGB:@"#827c70"];
    [m_expendView addSubview:downBgImageView];
    [downBgImageView release];
    
    UIImageView *basketLogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 40+3/2, 35/2, 35/2)];
    basketLogImageView.image = [UIImage imageNamed:@"basket_log.png"];
    [m_expendView addSubview:basketLogImageView];
    [basketLogImageView release];
    
    UILabel *detilefenxiLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 90, 20)];
    detilefenxiLable.text = @"详情赛事分析";
    detilefenxiLable.backgroundColor = [UIColor clearColor];
    detilefenxiLable.textColor = [ColorUtils parseColorFromRGB:@"#ffffff"];
    detilefenxiLable.font = [UIFont systemFontOfSize:13];
    [m_expendView addSubview:detilefenxiLable];
    [detilefenxiLable release];
    
    UIImageView *rightLogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(305, 40+5, 13/2, 10)];
    rightLogImageView.image = [UIImage imageNamed:@"right_detil_log.png"];
    [m_expendView addSubview:rightLogImageView];
    [rightLogImageView release];
    
    UIButton *fenxiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fenxiButton.backgroundColor = [UIColor clearColor];
    fenxiButton.frame = CGRectMake(0, 40, 320, 20);
    [fenxiButton addTarget:self action:@selector(FenXiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_expendView addSubview:fenxiButton];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)dealloc
{
    [m_LeftButton release];
    [m_RightButton release];
    [m_CenterButton release];
    [m_SFCButton release];
    
    [leftTeamLable release];
    [rightTeamLable release];
    [m_downLogImageView release];
    [m_upLogImageView release];
    
    [m_lable_VS release];
    [m_lable_league release];
    [m_lable_endTime release];
    
    
    [m_expendButton release];
    
    [super dealloc];
}


-(void)setCell:(JZTableViewCell_DataBase *)base
{
    m_expendButton.tag=base.indexpath.row;
    
    if (base.isExpend) {
        m_expendView.hidden=NO;
        [m_upLogImageView setHidden:NO];
        [m_downLogImageView setHidden:YES];
        
    }else{
        m_expendView.hidden=YES;
        [m_upLogImageView setHidden:YES];
        [m_downLogImageView setHidden:NO];
    }
    
}
- (void)creatAllButton
{
    for (UIView   *creatView  in [self subviews])
    {
        if ([creatView isMemberOfClass:[JC_MyButton class]]) {
            [creatView removeFromSuperview];
            [creatView release];
        }
    }
    for (int i = 0;i < 6 ;i++)
    {
        JC_MyButton *baseButton;
        if (i<3) {
            baseButton  = [[JC_MyButton alloc] initWithFrame:CGRectMake(90+i*75, 38, 75, 30)];
        }else
        {
            baseButton = [[JC_MyButton alloc] initWithFrame:CGRectMake(90+(i-3)*75, 69, 75, 30)];
        }
        
        [baseButton setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
        baseButton.downLabel.frame = CGRectMake(0, 10, baseButton.frame.size.width, baseButton.frame.size.height/3);
        baseButton.downLabel.font = [UIFont systemFontOfSize:13];
        baseButton.tag = 110+i;
        baseButton.downLabel.textColor = [UIColor whiteColor];
        
        //        baseButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
        [baseButton addTarget:self action:@selector(myButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:baseButton];
    }
}
- (void)myButtonClick:(id)sender
{
    JC_MyButton *btnClick =(JC_MyButton*) sender;
    int btnClickTag = btnClick.tag-110;
    
    switch (btnClickTag)
    {
        case 0:
        {
            //设置图片
            m_isLeftSelect = !m_isLeftSelect;
            BOOL notOverMax = NO;
                notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isLeftSelect ButtonIndex:1];
            if (notOverMax) {
                [self buttonImageChange];
            }else
            {
                m_isLeftSelect = !m_isLeftSelect;
                [self buttonImageChange];
            }
            
        }
            break;
        case 1:
        {
                m_isCenterSelect = !m_isCenterSelect;
                BOOL notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isCenterSelect ButtonIndex:2];
                
                if (notOverMax) {
                    [self buttonImageChange];
                }else
                {
                    //如果超过 返回 最初的状态
                    m_isCenterSelect = !m_isCenterSelect;
                    [self buttonImageChange];
                }
          
            
        }
            break;
        case 2:
        {
            m_isRightSelect = !m_isRightSelect;
            BOOL notOverMax = NO;
                notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isRightSelect ButtonIndex:3];
            if (notOverMax) {
                [self buttonImageChange];
            }else
            {
                //如果超过 返回 最初的状态
                m_isRightSelect = !m_isRightSelect;
                [self buttonImageChange];
            }
        }
            break;
        case 3:
        {
            m_isRQLeftSelect = !m_isRQLeftSelect;
            BOOL notOverMax = NO;
            notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isRQLeftSelect ButtonIndex:5];
            if (notOverMax) {
                [self buttonImageChange];
            }else
            {
                //如果超过 返回 最初的状态
                m_isRQLeftSelect = !m_isRQLeftSelect;
                [self buttonImageChange];
            }
        }
            break;
        case 4:
        {
            m_isRQCenterSelect = !m_isRQCenterSelect;
            BOOL notOverMax = NO;
            notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isRQCenterSelect ButtonIndex:6];
            if (notOverMax) {
                [self buttonImageChange];
            }else
            {
                //如果超过 返回 最初的状态
                m_isRQCenterSelect = !m_isRQCenterSelect;
                [self buttonImageChange];
            }
        }
            break;
        case 5:
        {
            m_isRQRightSelect = !m_isRQRightSelect;
            BOOL notOverMax = NO;
            notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isRQRightSelect ButtonIndex:7];
            if (notOverMax) {
                [self buttonImageChange];
            }else
            {
                //如果超过 返回 最初的状态
                m_isRQRightSelect = !m_isRQRightSelect;
                [self buttonImageChange];
            }
        }
            break;
            
        default:
            break;
    }
    
}


-(void) setupSFCButton
{
    if (m_SFCButton != nil) {
        [m_SFCButton removeFromSuperview];
        [m_SFCButton release];
    }
    m_SFCButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 38, 185, 22)];
    [m_SFCButton addTarget:self action: @selector(SFCButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_SFCButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_SFCButton.titleLabel.font = [UIFont systemFontOfSize:15];
    m_SFCButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_SFCButton setTitle:[NSString stringWithString:m_SFCButtonText] forState:UIControlStateNormal];
    [m_SFCButton setTitleColor:[ColorUtils parseColorFromRGB:@"#675634"] forState:UIControlStateNormal];
    [m_SFCButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#dcd4c7"]];
    [self addSubview:m_SFCButton];
    
}

-(void) rightButtonClick
{
    m_isRightSelect = !m_isRightSelect;
    BOOL notOverMax = NO;
        notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isRightSelect ButtonIndex:3];
       if (notOverMax) {
        [self rightButtonImageChange];
    }else
    {
        //如果超过 返回 最初的状态
        m_isRightSelect = !m_isRightSelect;
        [self rightButtonImageChange];
    }
}
-(void) JC_Dan_ButtonClick
{
    BOOL gameIsSelect = [self gameIsSelect];
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
-(void) SFCButtonClick
{
        [m_JCZQ_parentViewController gotoSFCView:m_indexPath];
}

-(void) leagueButtonClick
{
        [m_JCZQ_parentViewController gotoLeagueChoose];
}
//竞彩 析
-(void) FenXiButtonClick
{
        [m_JCZQ_parentViewController gotoFenxiView:m_indexPath];
}


-(void) setupJCZQCell
{
    
    if (m_playTypeTag ==  IJCZQPlayType_ZJQ ||
        m_playTypeTag ==  IJCZQPlayType_Score ||
        m_playTypeTag ==  IJCZQPlayType_HalfAndAll||
        m_playTypeTag ==  IJCZQPlayType_ZJQ_DanGuan ||
        m_playTypeTag ==  IJCZQPlayType_Score_DanGuan ||
        m_playTypeTag ==  IJCZQPlayType_HalfAndAll_DanGuan||
        m_playTypeTag ==  IJCZQPlayType_Confusion)
    {
        for (UIView *allView in [self subviews])
        {
            if ([allView isMemberOfClass:[JC_MyButton class]]) {
                
                allView.hidden = YES;
            }
        }
        if (m_handicapLable != nil) {
            m_handicapLable.hidden = YES;
        }
        
        m_lable_VS.text = @"VS";
        m_lable_VS.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
        
        //竞彩足球 主队在前
        m_lable_homeTeam.frame = CGRectMake(85, 2, 80, 35);
        m_lable_visitTeam.frame = CGRectMake(190, 2, 80, 35);
        m_lable_homeTeam.text = self.homeTeam;
        m_lable_visitTeam.text = self.VisitTeam;
        
        [self setupSFCButton];
        
    }
    else if ( m_playTypeTag ==  IJCZQPlayType_RQANDNO_SPF ||
             m_playTypeTag ==  IJCZQPlayType_SPF_DanGuan)
    {
        [self creatAllButton];
        
        [m_handicapLable setHidden:NO];
        
        //        m_lable_VS.hidden = YES;
        //        m_lable_visitTeam.hidden = YES;
        //        m_lable_homeTeam.hidden = YES;
        if (m_SFCButton != nil) {
            m_SFCButton.hidden = YES;
        }
        
        [m_lable_visitTeam setText:self.VisitTeam];;
        
        
        [m_lable_homeTeam setText:self.homeTeam];
        //
        
        for (UIView *setUpView in [self subviews])
        {
            
            if ([setUpView isKindOfClass:[JC_MyButton class]]) {
                
                JC_MyButton *setUpBtn = (JC_MyButton*)setUpView;
                NSLog(@"heiqushitag%d",setUpBtn.tag);
                
                switch (setUpBtn.tag) {
                    case 110:
                        [setUpBtn.downLabel setText:[NSString stringWithFormat:@"胜%@",self.vs]];
                        NSLog(@"heiqushitag%@",setUpBtn.downLabel);
                        break;
                    case 111:
                        [setUpBtn.downLabel setText:[NSString stringWithFormat:@"平%@",self.vp]];
                        break;
                    case 112:
                        [setUpBtn.downLabel setText:[NSString stringWithFormat:@"负%@",self.vf]];
                        break;
                    case 113:
                        [setUpBtn.downLabel setText:[NSString stringWithFormat:@"胜%@",self.v3]];
                        break;
                    case 114:
                        [setUpBtn.downLabel setText:[NSString stringWithFormat:@"平%@",self.v1]];
                        break;
                    case 115:
                        [setUpBtn.downLabel setText:[NSString stringWithFormat:@"负%@",self.v0]];
                        break;
                        
                    default:
                        break;
                }
            }
        }

                [self buttonImageChange];
        
    }
    
}
//刷新 页面跟 数据
-(void) RefreshCellView
{
    [self setupJCZQCell];
    
    if ([m_league length] < 4) {
        
        m_lable_league.font = [UIFont boldSystemFontOfSize:13];
    }
    else
        m_lable_league.font = [UIFont boldSystemFontOfSize:10];
    m_lable_league.text = m_league;
    NSString* weekday = @"";
    int weeknum = [self.weekld intValue];
    switch (weeknum) {
        case 1:
            weekday = @"周一 ";
            break;
        case 2:
            weekday = @"周二 ";
            break;
        case 3:
            weekday = @"周三 ";
            break;
        case 4:
            weekday = @"周四 ";
            break;
        case 5:
            weekday = @"周五 ";
            break;
        case 6:
            weekday = @"周六 ";
            break;
        case 7:
            weekday = @"周日 ";
            break;
        default:
            weekday = @"编号：";
            break;
    }
    [m_lable_endTime setText:[NSString stringWithFormat:@"%@  %@",self.teamld,self.endTime]];
    
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
        m_playTypeTag == IJCZQPlayType_SPF ||
        m_playTypeTag == IJCZQPlayType_ZJQ ||
        m_playTypeTag == IJCZQPlayType_Score ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll)
    {
        
        [self JC_Dan_ButtonButtonImageChange];
    }
    
}


-(void) buttonImageChange
{
    
    for (UIView *buttonView in [self subviews])
    {
        if ([buttonView isMemberOfClass:[JC_MyButton class]]) {
            JC_MyButton *otherBtn = (JC_MyButton*)buttonView;
            if (otherBtn.tag == 110) {
                if (m_isLeftSelect) {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
                    otherBtn.downLabel.textColor = [UIColor whiteColor];
                }
                else
                {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
                    otherBtn.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
                }
            }else if(otherBtn.tag == 111)
            {
                if (m_isCenterSelect) {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
                    otherBtn.downLabel.textColor = [UIColor whiteColor];
                }
                else
                {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
                    otherBtn.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
                }
            }else if(otherBtn.tag == 112)
            {
                if (m_isRightSelect) {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
                    otherBtn.downLabel.textColor = [UIColor whiteColor];
                }
                else
                {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
                    otherBtn.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
                }
            }else if(otherBtn.tag == 113)
            {
                if (m_isRQLeftSelect) {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
                    otherBtn.downLabel.textColor = [UIColor whiteColor];
                }
                else
                {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
                    otherBtn.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
                }
            }else if(otherBtn.tag == 114)
            {
                if (m_isRQCenterSelect) {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
                    otherBtn.downLabel.textColor = [UIColor whiteColor];
                }
                else
                {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
                    otherBtn.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
                }
            }else if(otherBtn.tag == 115)
            {
                if (m_isRQRightSelect) {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
                    otherBtn.downLabel.textColor = [UIColor whiteColor];
                }
                else
                {
                    otherBtn.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
                    otherBtn.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
                }
            }            
            
        }
    }
}

-(void) JC_Dan_ButtonButtonImageChange
{
    if (self.isJC_Button_Dan_Select) {
        [m_JC_Button_Dan setBackgroundImage:[UIImage imageNamed:@"jc_danbutton_click.png"] forState:UIControlStateNormal];
    }
    else
    {
        [m_JC_Button_Dan setBackgroundImage:[UIImage imageNamed:@"jc_danbutton_normal.png"] forState:UIControlStateNormal];
    }
}
-(BOOL) gameIsSelect
{
        NSInteger section;
        NSInteger row;
        if ([m_JCZQ_parentViewController.motionArray count] == 0) {
            
            section = m_indexPath.section;
            row = m_indexPath.row;
        }
        else
        {
            
            if (m_indexPath.section == 0) {
                
                section = [[m_JCZQ_parentViewController.motionArray objectAtIndex:(m_indexPath.row == 0)? 0 : 2] intValue];
                row = [[m_JCZQ_parentViewController.motionArray objectAtIndex:(m_indexPath.row == 0)? 1 : 3] intValue];
            }
            else
            {
                section = m_indexPath.section - 1;
                row = m_indexPath.row;
            }
            
        }
        
        
        JZTableViewCell_DataBase* tableCell = (JZTableViewCell_DataBase*)[[(JZTableViewCell_DataArray*)[m_JCZQ_parentViewController.tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row];
        
        int goalArrayCount = [[tableCell sfc_selectTag] count];
        
        if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] || goalArrayCount > 0)
        {
            return TRUE;
        }
    
    
        return FALSE;
}
@end
