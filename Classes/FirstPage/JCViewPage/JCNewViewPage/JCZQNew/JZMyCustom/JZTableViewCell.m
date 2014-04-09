//
//  JZTableViewCell.h
//  Boyacai
//
//  Created by qiushi on 13-8-15.
//
//

#import "JZTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "ColorUtils.h"
#import "JC_MyButton.h"

@interface JZTableViewCell (internal)
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

@implementation JZTableViewCell

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
@synthesize isSXDSSelect_SD = m_isSXDSSelect_SD;
@synthesize isSXDSSelect_SS = m_isSXDSSelect_SS;
@synthesize isSXDSSelect_XD = m_isSXDSSelect_XD;
@synthesize isSXDSSelect_XS = m_isSXDSSelect_XS;

@synthesize indexPath = m_indexPath;
@synthesize JCLQ_parentViewController = m_JCLQ_parentViewController;
@synthesize JCZQ_parentViewController = m_JCZQ_parentViewController;
@synthesize BJDC_parentViewController = m_BJDC_parentViewController;

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
        
        UIView  *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 67)];
        leftBgView.backgroundColor = [ColorUtils parseColorFromRGB:@"#eeeae3"];
        [self addSubview:leftBgView];
        [leftBgView release];
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* downBgline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 67, 320, 1)];
        downBgline.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:downBgline];
        [downBgline release];
        
        UIImageView* upBgline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        upBgline.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:upBgline];
        [upBgline release];
        
        UIImageView* verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 1, 67)];
        verticalLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:verticalLine];
        [verticalLine release];
        
        m_downLogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, 18/2, 11/2)];
        m_downLogImageView.image = [UIImage imageNamed:@"down_jc_expend.png"];
        [m_downLogImageView setHidden:NO];
        [self addSubview:m_downLogImageView];
        
        m_upLogImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(30, 67-11/2, 18/2, 11/2)];
        m_upLogImageView.image = [UIImage imageNamed:@"up_jc_expend.png"];
        [m_upLogImageView setHidden:YES];
        [self addSubview:m_upLogImageView];
        
        m_expendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_expendButton.frame = CGRectMake(0, 0, 75, 67);
        m_expendButton.backgroundColor = [UIColor clearColor];
//        [m_expendButton addTarget:self action:@selector(expendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_expendButton];
        
        m_lable_league = [[UILabel alloc] initWithFrame:CGRectMake(0,5, 68, 27)];
        m_lable_league.textAlignment = NSTextAlignmentCenter;
        m_lable_league.backgroundColor = [UIColor clearColor];
//        m_lable_league.numberOfLines = 2;
        [self addSubview:m_lable_league];
        
        m_lable_endTime = [[UILabel alloc] initWithFrame:CGRectMake(4, 20, 68, 38)];
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
        
        UIImageView *teamImageView = [[UIImageView alloc] initWithFrame:CGRectMake(76, 0, 320-75, 67)];
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
        
        m_lable_visitTeam = [[UILabel alloc] initWithFrame:CGRectMake(85, 2, 80, 35)];
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
 //让分图表制作
        m_handicapLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 37, 15, 30)];
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
    
    m_expendView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, 320, 60)];
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
    [m_SFCButton release];
    
    [leftTeamLable release];
    [rightTeamLable release];
    [m_downLogImageView release];
    [m_upLogImageView release];
    
    [m_lable_VS release];
    [m_lable_league release];
    [m_lable_endTime release];
    
    [m_LeftButton release];
    [m_CenterButton release];
    [m_RightButton release];
    
    
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
//构建 左边按钮
-(void) setupLeftButton
{
    if (m_LeftButton != nil) {
        [m_LeftButton removeFromSuperview];
        [m_LeftButton release];
    }
    m_LeftButton = [[JC_MyButton alloc] initWithFrame:CGRectMake(90, 37, 75, 30)];
    //    if (2 == m_isJCLQtableview) {//北单
    //        m_LeftButton.frame = CGRectMake(80, 3, 83, 60);
    //    }
    [m_LeftButton setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
    m_LeftButton.downLabel.font = [UIFont systemFontOfSize:13];
    m_LeftButton.downLabel.frame = CGRectMake(0, 10, m_LeftButton.frame.size.width, m_LeftButton.frame.size.height/3);
    m_LeftButton.downLabel.textColor = [UIColor whiteColor];
    
    m_LeftButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
    [m_LeftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_LeftButton];
}

-(void) setupCenterButton
{
    if (m_CenterButton != nil) {
        [m_CenterButton removeFromSuperview];
        [m_CenterButton release];
    }
    m_CenterButton = [[JC_MyButton alloc] initWithFrame:CGRectMake(165, 37, 75, 30)];
    //    if (2 == m_isJCLQtableview) {//北单
    //        m_CenterButton.frame = CGRectMake(176, 3, 39, 60);
    //    }
    [m_CenterButton setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
    m_CenterButton.downLabel.font = [UIFont systemFontOfSize:13];
    m_CenterButton.downLabel.frame = CGRectMake(0, 10, m_CenterButton.frame.size.width, m_CenterButton.frame.size.height/3);
    m_CenterButton.downLabel.textColor = [UIColor whiteColor];

    m_CenterButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
    [m_CenterButton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_CenterButton];
}

-(void) setupRightButton
{
    if (m_RightButton != nil) {
        [m_RightButton removeFromSuperview];
        [m_RightButton release];
    }
    m_RightButton = [[JC_MyButton alloc] initWithFrame:CGRectMake(240, 37, 75, 30)];
    //    if (2 == m_isJCLQtableview) {//北单
    //        m_RightButton.frame = CGRectMake(228, 3, 83, 60);
    //    }
    [m_RightButton setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
    m_RightButton.downLabel.frame = CGRectMake(0, 10, m_RightButton.frame.size.width, m_RightButton.frame.size.height/3);
    m_RightButton.downLabel.font = [UIFont systemFontOfSize:13];
    m_RightButton.downLabel.textColor = [UIColor whiteColor];
    

    m_RightButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
    [m_RightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_RightButton];
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
//    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_click.png"] forState:UIControlStateNormal];
    //    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_normal.png"] forState:UIControlStateHighlighted];
    [self addSubview:m_SFCButton];
    
}



- (void) SXDSbuttonClick:(UIButton*)button
{
    button.selected = !button.selected;
    BOOL notOverMax = [self.BJDC_parentViewController SXDSClickState:m_indexPath clickState:button.selected ButtonIndex:button.tag];
    if (!notOverMax) {
        button.selected = !button.selected;
        return;
    }
    switch (button.tag) {
        case kSXDSbuttonTag:
            m_isSXDSSelect_SD = !m_isSXDSSelect_SD;
            break;
        case kSXDSbuttonTag + 1:
            m_isSXDSSelect_SS = !m_isSXDSSelect_SS;
            break;
        case kSXDSbuttonTag + 2:
            m_isSXDSSelect_XD = !m_isSXDSSelect_XD;
            break;
        case kSXDSbuttonTag + 3:
            m_isSXDSSelect_XS = !m_isSXDSSelect_XS;
            break;
        default:
            break;
    }
}
-(void) leftButtonClick
{
    //设置图片
    m_isLeftSelect = !m_isLeftSelect;
    BOOL notOverMax = NO;
    if (1 == m_isJCLQtableview) {
        notOverMax = [m_JCLQ_parentViewController changeClickState:m_indexPath clickState:m_isLeftSelect ButtonIndex:2];
    }
    else if(0 == m_isJCLQtableview)
    {
        notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isLeftSelect ButtonIndex:1];
    }
    else
    {
        notOverMax =  [self.BJDC_parentViewController changeClickState:m_indexPath clickState:m_isLeftSelect ButtonIndex:1];
    }
    
    if (notOverMax) {
        [self leftButtonImageChange];
    }else
    {
        m_isLeftSelect = !m_isLeftSelect;
        [self leftButtonImageChange];
    }
}
-(void) rightButtonClick
{
    m_isRightSelect = !m_isRightSelect;
    BOOL notOverMax = NO;
    if (1 == m_isJCLQtableview) {
        notOverMax = [m_JCLQ_parentViewController changeClickState:m_indexPath clickState:m_isRightSelect ButtonIndex:1];
    }
    else if (0 == m_isJCLQtableview)
    {
        notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isRightSelect ButtonIndex:3];
    }
    else
    {
        notOverMax =  [self.BJDC_parentViewController changeClickState:m_indexPath clickState:m_isRightSelect ButtonIndex:3];
    }
    if (notOverMax) {
        [self rightButtonImageChange];
    }else
    {
        //如果超过 返回 最初的状态
        m_isRightSelect = !m_isRightSelect;
        [self rightButtonImageChange];
    }
}

-(void) centerButtonClick
{
    if (0 == m_isJCLQtableview) {
        m_isCenterSelect = !m_isCenterSelect;
        BOOL notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isCenterSelect ButtonIndex:2];
        
        if (notOverMax) {
            [self centerButtonImageChange];
        }else
        {
            //如果超过 返回 最初的状态
            m_isCenterSelect = !m_isCenterSelect;
            [self centerButtonImageChange];
        }
    }
    else if(2 == m_isJCLQtableview)
    {
        m_isCenterSelect = !m_isCenterSelect;
        BOOL notOverMax =  [self.BJDC_parentViewController changeClickState:m_indexPath clickState:m_isCenterSelect ButtonIndex:2];
        
        notOverMax ? ([self centerButtonImageChange]) : (m_isCenterSelect = !m_isCenterSelect);
    }
}

-(void) JC_Dan_ButtonClick
{
    BOOL gameIsSelect = [self gameIsSelect];
    if (0 == m_isJCLQtableview && gameIsSelect)
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
    else if(1 == m_isJCLQtableview && gameIsSelect)
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
    else if(2 == m_isJCLQtableview && gameIsSelect)
    {
        m_isJC_Button_Dan_Select = !m_isJC_Button_Dan_Select;
        BOOL notOverMax;
        if(m_playTypeTag == IBJDCPlayType_SXDS)
        {
            notOverMax = [m_BJDC_parentViewController SXDSClickState:m_indexPath clickState:m_isJC_Button_Dan_Select ButtonIndex:kSXDSbuttonTag + 4];
        }
        else{
            notOverMax = [m_BJDC_parentViewController changeClickState:m_indexPath clickState:m_isJC_Button_Dan_Select ButtonIndex:4];
        }
        
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
    if (1 == m_isJCLQtableview) {
        
        [m_JCLQ_parentViewController gotoSFCView:m_indexPath];
    }
    else if(0 == m_isJCLQtableview)
    {
        [m_JCZQ_parentViewController gotoSFCView:m_indexPath];
    }
    else
    {
        [self.BJDC_parentViewController gotoSFCView:m_indexPath];
    }
}

-(void) leagueButtonClick
{
    if (1 == m_isJCLQtableview) {
        
        [m_JCLQ_parentViewController gotoLeagueChoose];
    }
    else if(0 == m_isJCLQtableview)
    {
        [m_JCZQ_parentViewController gotoLeagueChoose];
    }
    else
    {
        [m_BJDC_parentViewController gotoLeagueChoose];
    }
}
//竞彩 析
-(void) FenXiButtonClick
{
    if (1 == m_isJCLQtableview) {
        
        [m_JCLQ_parentViewController gotoFenxiView:m_indexPath];
    }
    else if (0 == m_isJCLQtableview)
    {
        [m_JCZQ_parentViewController gotoFenxiView:m_indexPath];
    }
    else
        [self.BJDC_parentViewController gotoFenxiView:m_indexPath];
}

-(void)setupJCLQCell
{
    
    if (m_playTypeTag ==  IJCLQPlayType_SF ||
        m_playTypeTag ==IJCLQPlayType_LetPoint ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall ||
        m_playTypeTag ==  IJCLQPlayType_SF_DanGuan ||
        m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan )
    {
        
        if (m_SFCButton != nil)
            m_SFCButton.hidden = YES;
        
//        m_lable_VS.hidden = NO;
//        m_lable_visitTeam.hidden = YES;
//        m_lable_homeTeam.hidden = YES;
        m_jclq_big_basePoint.hidden = YES;
        [self setupLeftButton];
        [self setupRightButton];
        [m_handicapLable setHidden:NO];
        
        if (m_playTypeTag ==  IJCLQPlayType_SF ||
            m_playTypeTag ==  IJCLQPlayType_SF_DanGuan)
        {
            m_lable_VS.text = @"VS";
            m_lable_VS.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
            
            [m_lable_homeTeam setText:self.homeTeam];
            [m_RightButton.downLabel setText:[NSString stringWithFormat:@"负%@",self.v3]];
            
            [m_LeftButton.downLabel setText:[NSString stringWithFormat:@"胜%@",self.v0]];
            [m_lable_visitTeam setText:self.VisitTeam];
            
        }
        else if(m_playTypeTag ==  IJCLQPlayType_LetPoint ||
                m_playTypeTag ==  IJCLQPlayType_LetPoint_DanGuan)
        {
            if ([m_letPoint length] > 0)
            {
                UniChar chr = [m_letPoint characterAtIndex:0];
                if (chr == '-')
                {
                    [m_CenterButton.downLabel setText:[NSString stringWithFormat:@"(+%@)平%@",m_letPoint,self.vp]];
                }
                else
                {
                    if ([m_letPoint intValue] > 0) {
                        [m_CenterButton.downLabel setText:[NSString stringWithFormat:@"(+%@)平%@",m_letPoint,self.vp]];
                    }
                    else
                    {
                     [m_CenterButton.downLabel setText:[NSString stringWithFormat:@"(+%@)平%@",@"",self.vp]];
                    }
                }
            }
            else
            {
                [m_CenterButton.downLabel setText:[NSString stringWithFormat:@"(+%@)平%@",@"",self.vp]];
            }
            [self leftButtonImageChange];
            [self centerButtonImageChange];
            [self rightButtonImageChange];
        }
        else if(m_playTypeTag == IBJDCPlayType_SXDS)//上下单双
        {
            if (m_LeftButton != nil) {
                m_LeftButton.hidden = YES;
            }
            if (m_CenterButton != nil) {
                m_CenterButton.hidden = YES;
            }
            if (m_RightButton != nil) {
                m_RightButton.hidden = YES;
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
            
            
        }
    }
}

-(void) setupJCZQCell
{
    if (m_playTypeTag ==  IJCZQPlayType_ZJQ ||
        m_playTypeTag ==  IJCZQPlayType_Score ||
        m_playTypeTag ==  IJCZQPlayType_HalfAndAll||
        m_playTypeTag ==  IJCZQPlayType_ZJQ_DanGuan ||
        m_playTypeTag ==  IJCZQPlayType_Score_DanGuan ||
        m_playTypeTag ==  IJCZQPlayType_HalfAndAll_DanGuan||
        m_playTypeTag ==  IJCZQPlayType_Confusion
        
        || m_playTypeTag == IBJDCPlayType_ZJQ
        || m_playTypeTag == IBJDCPlayType_Score
        || m_playTypeTag == IBJDCPlayType_HalfAndAll)
    {
        if (m_LeftButton != nil) {
            m_LeftButton.hidden = YES;
        }
        if (m_CenterButton != nil) {
            m_CenterButton.hidden = YES;
        }
        if (m_RightButton != nil) {
            m_RightButton.hidden = YES;
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
    else if ( m_playTypeTag ==  IJCZQPlayType_SPF ||
             m_playTypeTag ==  IJCZQPlayType_SPF_DanGuan)
    {
        [self setupLeftButton];
        [self setupCenterButton];
        [self setupRightButton];
        [m_handicapLable setHidden:NO];
        
//        m_lable_VS.hidden = YES;
//        m_lable_visitTeam.hidden = YES;
//        m_lable_homeTeam.hidden = YES;
        if (m_SFCButton != nil) {
            m_SFCButton.hidden = YES;
        }
        
        
        [m_lable_visitTeam setText:self.VisitTeam];
        [m_RightButton.downLabel setText:[NSString stringWithFormat:@"负%@",self.vf]];
        
        
        [m_CenterButton.downLabel setText:[NSString stringWithFormat:@"平%@",self.vp]];
        
        [m_lable_homeTeam setText:self.homeTeam];
        [m_LeftButton.downLabel setText:[NSString stringWithFormat:@"胜%@",self.vs]];
        
       
        
        [self leftButtonImageChange];
        [self centerButtonImageChange];
        [self rightButtonImageChange];
        
    }
    
    else if(m_playTypeTag ==  IJCZQPlayType_RQ_SPF ||
            m_playTypeTag ==  IJCZQPlayType_RQ_SPF_DanGuan ||
            m_playTypeTag == IBJDCPlayType_RQ_SPF)//北单让球胜平负
    {
        [self setupLeftButton];
        [self setupCenterButton];
        [self setupRightButton];
        [m_handicapLable setHidden:NO];
        
//        m_lable_VS.hidden = YES;
//        m_lable_visitTeam.hidden = YES;
//        m_lable_homeTeam.hidden = YES;
        if (m_SFCButton != nil) {
            m_SFCButton.hidden = YES;
        }
        //        if (2 == self.isJCLQtableview) {
        //            m_fenxiButton.hidden = YES;
        //        }
        
        [m_RightButton.downLabel setText:[NSString stringWithFormat:@"负%@",self.v0]];
        
        [m_CenterButton.downLabel setText:[NSString stringWithFormat:@"平%@",self.v1]];
        
        [m_LeftButton.downLabel setText:[NSString stringWithFormat:@"胜%@",self.v3]];
        
        
        [self leftButtonImageChange];
        [self centerButtonImageChange];
        [self rightButtonImageChange];
    }
    else if(m_playTypeTag == IBJDCPlayType_SXDS)//上下单双
    {
        if (m_LeftButton != nil) {
            m_LeftButton.hidden = YES;
        }
        if (m_CenterButton != nil) {
            m_CenterButton.hidden = YES;
        }
        if (m_RightButton != nil) {
            m_RightButton.hidden = YES;
        }
        if (m_handicapLable != nil) {
            m_handicapLable.hidden = YES;
        }
        
        if (m_SFCButton != nil) {
            m_SFCButton.hidden = YES;
        }
        //        m_fenxiButton.hidden = YES;
        
//        m_lable_VS.hidden = NO;
//        m_lable_visitTeam.hidden = NO;
//        m_lable_homeTeam.hidden = NO;
        
        m_lable_VS.text = @"VS";
        m_lable_VS.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
        
        //竞彩足球 主队在前
        m_lable_homeTeam.frame = CGRectMake(85, 2, 80, 35);
        m_lable_visitTeam.frame = CGRectMake(190, 2, 80, 35);
        m_lable_homeTeam.text = self.homeTeam;
        m_lable_visitTeam.text = self.VisitTeam;
        
        
    }
}
//刷新 页面跟 数据
-(void) RefreshCellView
{
       
    
    if (1 == m_isJCLQtableview) {
        [self setupJCLQCell];
    }
    else
    {
        [self setupJCZQCell];
    }
    
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
    
    if (m_playTypeTag == IJCLQPlayType_SF ||
        m_playTypeTag == IJCLQPlayType_LetPoint ||
        m_playTypeTag == IJCLQPlayType_SFC ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall ||
        
        m_playTypeTag == IJCZQPlayType_RQ_SPF ||
        m_playTypeTag == IJCZQPlayType_SPF ||
        m_playTypeTag == IJCZQPlayType_ZJQ ||
        m_playTypeTag == IJCZQPlayType_Score ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll
        
        //北京单场关闭胆
        //        m_playTypeTag == IBJDCPlayType_RQ_SPF||
        //        m_playTypeTag == IBJDCPlayType_Score||
        //        m_playTypeTag == IBJDCPlayType_SXDS||
        //        m_playTypeTag == IBJDCPlayType_ZJQ||
        //        m_playTypeTag == IBJDCPlayType_HalfAndAll
        
        )
    {
        
        [self JC_Dan_ButtonButtonImageChange];
    }

}
-(void) leftButtonImageChange
{
    if (m_isLeftSelect) {

            m_LeftButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
            m_LeftButton.downLabel.textColor = [UIColor whiteColor];
    }
    else
    {
       m_LeftButton.backgroundColor = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
        m_LeftButton.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
    }
    
}
-(void) rightButtonImageChange
{
    if (m_isRightSelect) {
        if(m_playTypeTag == IJCLQPlayType_BigAndSmall ||
           m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan
           )
        {
            m_RightButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
        }
        else
        {
            m_RightButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
        }
        m_RightButton.downLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        m_RightButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
        m_RightButton.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
    }
}

-(void) centerButtonImageChange
{
    if (m_isCenterSelect) {
        m_CenterButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#d52322"];
        m_CenterButton.downLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        m_CenterButton.backgroundColor  = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
        m_CenterButton.downLabel.textColor = [ColorUtils parseColorFromRGB:@"#675634"];
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
    
    if (1 == m_isJCLQtableview) {
        int count = [[(JZTableViewCell_DataBase*)[[(JZTableViewCell_DataArray*)[m_JCLQ_parentViewController.tableCell_DataArray objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] count];
        if (m_isLeftSelect || m_isRightSelect || count > 0) {
            return TRUE;
        }
    }
    else if (0 == m_isJCLQtableview)
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
    }
    
    else if(2 == m_isJCLQtableview)
    {
        JZTableViewCell_DataBase* tableCell = (JZTableViewCell_DataBase*)[[(JZTableViewCell_DataArray*)[m_BJDC_parentViewController.tableCell_DataArray objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]];
        
        int count = [[tableCell sfc_selectTag] count];
        if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] ||count > 0 || [tableCell BD_XS_ButtonIsSelect] || [tableCell BD_XD_ButtonIsSelect] || [tableCell BD_SS_ButtonIsSelect] || [tableCell BD_SD_ButtonIsSelect]) {
            
            return TRUE;
        }
    }
    return FALSE;
}
@end

//-----------------------------------data------------------------------

