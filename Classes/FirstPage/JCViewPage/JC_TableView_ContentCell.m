//
//  JC_TableView_ContentCell.m
//  RuYiCai
//
//  Created by ruyicai on 13-3-21.
//
//

#import "JC_TableView_ContentCell.h"
#import "RuYiCaiCommon.h"
@interface JC_TableView_ContentCell (internal)
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

@implementation JC_TableView_ContentCell

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
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView* imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 67)];
        imageBg.image = [UIImage imageNamed:@"jc_listbackground.png"];
        [self addSubview:imageBg];
        [imageBg release];
        
        UIImageView *image_endtime = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27, 68, 38 + 2)];
        image_endtime.image = [UIImage imageNamed:@"jc_endtimebg.png"];
        [self addSubview:image_endtime];
        [image_endtime release];
        
        m_button_league = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 68, 27)];
        m_button_league.titleLabel.numberOfLines = 2;
        [m_button_league addTarget:self action: @selector(leagueButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [m_button_league setBackgroundImage:[UIImage imageNamed:@"jc_leagueBackground.png"] forState:UIControlStateNormal];
        [self addSubview:m_button_league];
        
        m_lable_endTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 68, 38)];
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
        
        m_fenxiButton = [[UIButton alloc] initWithFrame:CGRectMake(285,0, 35, 25)];
        [m_fenxiButton addTarget:self action: @selector(FenXiButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [m_fenxiButton setBackgroundImage:[UIImage imageNamed:@"jc_fenxibutton_normal.png"] forState:UIControlStateNormal];
        [self addSubview:m_fenxiButton];
        
        m_lable_VS = [[UILabel alloc] initWithFrame:CGRectMake(156, 5, 39, 30)];
        m_lable_VS.text = @"VS";
        [m_lable_VS setTextColor:[UIColor redColor]];
        m_lable_VS.textAlignment = UITextAlignmentCenter;
        m_lable_VS.backgroundColor = [UIColor clearColor];
        m_lable_VS.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lable_VS];
        
        
        m_jclq_big_basePoint = [[UILabel alloc] initWithFrame:CGRectMake(156, 35, 39, 30)];
        [m_jclq_big_basePoint setTextColor:[UIColor blackColor]];
        m_jclq_big_basePoint.textAlignment = UITextAlignmentCenter;
        m_jclq_big_basePoint.backgroundColor = [UIColor clearColor];
        m_jclq_big_basePoint.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_jclq_big_basePoint];
        
        
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
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)dealloc
{
    [m_SFCButton release];
    [m_fenxiButton release];
    [m_JC_Button_Dan release];
    
    [leftTeamLable release];
    [rightTeamLable release];
    
    [m_lable_VS release];
    [m_button_league release];
    [m_lable_endTime release];
    
    [m_LeftButton release];
    [m_CenterButton release];
    [m_RightButton release];
    
    [SD_Button release];
    [SS_Button release];
    [XD_Button release];
    [XS_Button release];
    
    [super dealloc];
}
//构建 左边按钮
-(void) setupLeftButton
{
    if (m_LeftButton != nil) {
        [m_LeftButton removeFromSuperview];
        [m_LeftButton release];
    }
    m_LeftButton = [[MyButton alloc] initWithFrame:CGRectMake(68 + 2, 3, 83, 60)];
    //    if (2 == m_isJCLQtableview) {//北单
    //        m_LeftButton.frame = CGRectMake(80, 3, 83, 60);
    //    }
    [m_LeftButton setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
    m_LeftButton.upLabel.font = [UIFont boldSystemFontOfSize:13];
    m_LeftButton.downLabel.font = [UIFont systemFontOfSize:13];
    m_LeftButton.upLabel.frame = CGRectMake(0, 0, m_LeftButton.frame.size.width, m_LeftButton.frame.size.height*2/3);
    m_LeftButton.downLabel.frame = CGRectMake(0, m_LeftButton.frame.size.height*2/3, m_LeftButton.frame.size.width, m_LeftButton.frame.size.height/3);
    m_LeftButton.downLabel.textColor = [UIColor grayColor];
    m_LeftButton.upLabel.textColor = [UIColor blackColor];
    
    m_LeftButton.upLabel.lineBreakMode = UILineBreakModeWordWrap;
    m_LeftButton.upLabel.numberOfLines = 2;
    [m_LeftButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_normal.png"] forState:UIControlStateNormal];
    //    [m_LeftButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_click.png"] forState:UIControlStateHighlighted];
    [m_LeftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_LeftButton];
}

-(void) setupCenterButton
{
    if (m_CenterButton != nil) {
        [m_CenterButton removeFromSuperview];
        [m_CenterButton release];
    }
    m_CenterButton = [[MyButton alloc] initWithFrame:CGRectMake(156, 3, 39, 60)];
    //    if (2 == m_isJCLQtableview) {//北单
    //        m_CenterButton.frame = CGRectMake(176, 3, 39, 60);
    //    }
    [m_CenterButton setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
    m_CenterButton.upLabel.font = [UIFont boldSystemFontOfSize:13];
    m_CenterButton.downLabel.font = [UIFont systemFontOfSize:13];
    m_CenterButton.upLabel.frame = CGRectMake(0, 0, m_CenterButton.frame.size.width, m_CenterButton.frame.size.height*2/3);
    m_CenterButton.downLabel.frame = CGRectMake(0, m_CenterButton.frame.size.height*2/3, m_CenterButton.frame.size.width, m_CenterButton.frame.size.height/3);
    m_CenterButton.downLabel.textColor = [UIColor grayColor];
    m_CenterButton.upLabel.textColor = [UIColor blackColor];
    
    m_CenterButton.upLabel.lineBreakMode = UILineBreakModeWordWrap;
    m_CenterButton.upLabel.numberOfLines = 2;
    [m_CenterButton setBackgroundImage:[UIImage imageNamed:@"jc_teambuttoncenter_normal.png"] forState:UIControlStateNormal];
    //    [m_CenterButton setBackgroundImage:[UIImage imageNamed:@"jc_teambuttoncenter_click.png"] forState:UIControlStateHighlighted];
    [m_CenterButton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_CenterButton];
}

-(void) setupRightButton
{
    if (m_RightButton != nil) {
        [m_RightButton removeFromSuperview];
        [m_RightButton release];
    }
    m_RightButton = [[MyButton alloc] initWithFrame:CGRectMake(195 + 3, 3, 83, 60)];
    //    if (2 == m_isJCLQtableview) {//北单
    //        m_RightButton.frame = CGRectMake(228, 3, 83, 60);
    //    }
    [m_RightButton setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
    m_RightButton.upLabel.font = [UIFont boldSystemFontOfSize:13];
    m_RightButton.upLabel.frame = CGRectMake(0, 0, m_RightButton.frame.size.width, m_RightButton.frame.size.height*2/3);
    m_RightButton.downLabel.frame = CGRectMake(0, m_RightButton.frame.size.height*2/3, m_RightButton.frame.size.width, m_RightButton.frame.size.height/3);
    m_RightButton.downLabel.font = [UIFont systemFontOfSize:13];
    m_RightButton.downLabel.textColor = [UIColor grayColor];
    m_RightButton.upLabel.textColor = [UIColor blackColor];
    
    m_RightButton.upLabel.lineBreakMode = UILineBreakModeWordWrap;
    m_RightButton.upLabel.numberOfLines = 2;
    [m_RightButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_normal.png"] forState:UIControlStateNormal];
    //    [m_RightButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_click.png"] forState:UIControlStateHighlighted];
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
    m_SFCButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    m_SFCButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [m_SFCButton setTitle:[NSString stringWithString:m_SFCButtonText] forState:UIControlStateNormal];
    
    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_click.png"] forState:UIControlStateNormal];
    //    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_normal.png"] forState:UIControlStateHighlighted];
    [self addSubview:m_SFCButton];
    
}

- (void)setBJDC_SXDSbutton
{
    if (SD_Button != nil) {
        [SD_Button removeFromSuperview];
        [SD_Button release];
    }
    if (SS_Button != nil) {
        [SS_Button removeFromSuperview];
        [SS_Button release];
    }
    if (XD_Button != nil) {
        [XD_Button removeFromSuperview];
        [XD_Button release];
    }
    if (XS_Button != nil) {
        [XS_Button removeFromSuperview];
        [XS_Button release];
    }
    SD_Button = [[MyButton alloc] initWithFrame:CGRectMake(70, 35, 50, 30)];
    SD_Button.tag = kSXDSbuttonTag;
    [SD_Button setMyButton:[UIImage imageNamed:@"sfc_f_select_normal.png"] UPLABEL:@"上单" DOWNLABEL:self.sxdsV1];
    [SD_Button setImage:[UIImage imageNamed:@"sfc_s_select_normal.png"] forState:UIControlStateSelected];
    [SD_Button addTarget:self action:@selector(SXDSbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    SD_Button.downLabel.font = [UIFont systemFontOfSize:12];
    SD_Button.downLabel.textColor = [UIColor grayColor];
    SD_Button.upLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:SD_Button];
    SD_Button.selected = m_isSXDSSelect_SD;
    
    SS_Button = [[MyButton alloc] initWithFrame:CGRectMake(125, 35, 50, 30)];
    SS_Button.tag = kSXDSbuttonTag + 1;
    [SS_Button setMyButton:[UIImage imageNamed:@"sfc_f_select_normal.png"] UPLABEL:@"上双" DOWNLABEL:self.sxdsV2];
    [SS_Button setImage:[UIImage imageNamed:@"sfc_s_select_normal.png"] forState:UIControlStateSelected];
    [SS_Button addTarget:self action:@selector(SXDSbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    SS_Button.downLabel.font = [UIFont systemFontOfSize:12];
    SS_Button.downLabel.textColor = [UIColor grayColor];
    SS_Button.upLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:SS_Button];
    SS_Button.selected = m_isSXDSSelect_SS;
    
    XD_Button = [[MyButton alloc] initWithFrame:CGRectMake(179, 35, 50, 30)];
    XD_Button.tag = kSXDSbuttonTag + 2;
    [XD_Button setMyButton:[UIImage imageNamed:@"sfc_f_select_normal.png"] UPLABEL:@"下单" DOWNLABEL:self.sxdsV3];
    [XD_Button setImage:[UIImage imageNamed:@"sfc_s_select_normal.png"] forState:UIControlStateSelected];
    [XD_Button addTarget:self action:@selector(SXDSbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    XD_Button.downLabel.font = [UIFont systemFontOfSize:12];
    XD_Button.downLabel.textColor = [UIColor grayColor];
    XD_Button.upLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:XD_Button];
    XD_Button.selected = m_isSXDSSelect_XD;
    
    XS_Button = [[MyButton alloc] initWithFrame:CGRectMake(234, 35, 50, 30)];
    XS_Button.tag = kSXDSbuttonTag + 3;
    [XS_Button setMyButton:[UIImage imageNamed:@"sfc_f_select_normal.png"] UPLABEL:@"下双" DOWNLABEL:self.sxdsV4];
    [XS_Button setImage:[UIImage imageNamed:@"sfc_s_select_normal.png"] forState:UIControlStateSelected];
    [XS_Button addTarget:self action:@selector(SXDSbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    XS_Button.downLabel.font = [UIFont systemFontOfSize:12];
    XS_Button.downLabel.textColor = [UIColor grayColor];
    XS_Button.upLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:XS_Button];
    XS_Button.selected = m_isSXDSSelect_XS;
    
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

-(void) setupDanButton
{
    //胆
    if (m_JC_Button_Dan != nil) {
        [m_JC_Button_Dan removeFromSuperview];
        [m_JC_Button_Dan release];
    }
    m_JC_Button_Dan = [[UIButton alloc] initWithFrame:CGRectMake(290, 35, 26, 25)];
    [m_JC_Button_Dan addTarget:self action: @selector(JC_Dan_ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_JC_Button_Dan setBackgroundImage:[UIImage imageNamed:@"jc_danbutton_normal.png"] forState:UIControlStateNormal];
    [self addSubview:m_JC_Button_Dan];
    
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
    notOverMax ? ([self leftButtonImageChange]) : (m_isLeftSelect = !m_isLeftSelect);//如果超过 返回 最初的状态
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
    notOverMax ? ([self rightButtonImageChange]) : (m_isRightSelect = !m_isRightSelect);//如果超过 返回 最初的状态
}

-(void) centerButtonClick
{
    if (0 == m_isJCLQtableview) {
        m_isCenterSelect = !m_isCenterSelect;
        BOOL notOverMax =  [m_JCZQ_parentViewController changeClickState:m_indexPath clickState:m_isCenterSelect ButtonIndex:2];
        
        notOverMax ? ([self centerButtonImageChange]) : (m_isCenterSelect = !m_isCenterSelect);//如果超过 返回 最初的状态
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
        
        m_lable_VS.hidden = NO;
        m_lable_visitTeam.hidden = YES;
        m_lable_homeTeam.hidden = YES;
        m_jclq_big_basePoint.hidden = YES;
        [self setupLeftButton];
        [self setupRightButton];
        
        if (m_playTypeTag ==  IJCLQPlayType_SF ||
            m_playTypeTag ==  IJCLQPlayType_SF_DanGuan)
        {
            m_lable_VS.text = @"VS";
            m_lable_VS.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
            
            [m_RightButton.upLabel setText:self.homeTeam];
            [m_RightButton.downLabel setText:self.v3];
            
            [m_LeftButton.downLabel setText:self.v0];
            [m_LeftButton.upLabel setText:self.VisitTeam];
            
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
            [m_RightButton.upLabel setText:self.homeTeam];
            [m_RightButton.downLabel setText:self.letVs_v3];
            
            [m_LeftButton.downLabel setText:self.letVs_v0];
            [m_LeftButton.upLabel setText:self.VisitTeam];
            
        }
        else if(m_playTypeTag == IJCLQPlayType_BigAndSmall ||
                m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan
                )
        {
            m_jclq_big_basePoint.hidden = NO;
            m_jclq_big_basePoint.text = m_basePoint;
            
            m_lable_VS.text = @"VS";
            m_lable_VS.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
            [m_RightButton.upLabel setText:self.homeTeam];
            [m_RightButton.downLabel setText:[NSString stringWithFormat:@"小 %@",self.Small]];
            
            [m_LeftButton.downLabel setText:[NSString stringWithFormat:@"大 %@",self.Big]];
            [m_LeftButton.upLabel setText: self.VisitTeam];
        }
        
        [self leftButtonImageChange];
        [self rightButtonImageChange];
    }
    else if(m_playTypeTag == IJCLQPlayType_SFC ||
            m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
            m_playTypeTag == IJCLQPlayType_Confusion)
    {
        if (m_LeftButton != nil) {
            m_LeftButton.hidden = YES;
        }
        if (m_RightButton != nil) {
            m_RightButton.hidden = YES;
        }
        m_lable_VS.hidden = NO;
        m_lable_visitTeam.hidden = NO;
        m_lable_homeTeam.hidden = NO;
        
        [m_lable_visitTeam setText:self.VisitTeam];
        [m_lable_homeTeam setText:self.homeTeam];
        
        m_lable_VS.text = @"VS";
        m_lable_VS.textColor = [UIColor redColor];
        
        [self setupSFCButton];
        
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
        //        if (2 == self.isJCLQtableview) {
        //            m_fenxiButton.hidden = YES;
        //        }
        
        SD_Button.hidden = YES;
        SS_Button.hidden = YES;
        XD_Button.hidden = YES;
        XS_Button.hidden = YES;
        
        m_lable_VS.hidden = NO;
        m_lable_visitTeam.hidden = NO;
        m_lable_homeTeam.hidden = NO;
        
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
        
        m_lable_VS.hidden = YES;
        m_lable_visitTeam.hidden = YES;
        m_lable_homeTeam.hidden = YES;
        if (m_SFCButton != nil) {
            m_SFCButton.hidden = YES;
        }
        
        SD_Button.hidden = YES;
        SS_Button.hidden = YES;
        XD_Button.hidden = YES;
        XS_Button.hidden = YES;
        
        [m_RightButton.upLabel setText:self.VisitTeam];
        [m_RightButton.downLabel setText:self.vf];
        
        
        [m_CenterButton.downLabel setText:self.vp];
        
        [m_LeftButton.upLabel setText:self.homeTeam];
        [m_LeftButton.downLabel setText:self.vs];
        
        [m_CenterButton.upLabel setText:@"0"];
        m_CenterButton.upLabel.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
        
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
        
        m_lable_VS.hidden = YES;
        m_lable_visitTeam.hidden = YES;
        m_lable_homeTeam.hidden = YES;
        if (m_SFCButton != nil) {
            m_SFCButton.hidden = YES;
        }
        //        if (2 == self.isJCLQtableview) {
        //            m_fenxiButton.hidden = YES;
        //        }
        SD_Button.hidden = YES;
        SS_Button.hidden = YES;
        XD_Button.hidden = YES;
        XS_Button.hidden = YES;
        
        [m_RightButton.upLabel setText:self.VisitTeam];
        [m_RightButton.downLabel setText:self.v0];
        
        [m_CenterButton.downLabel setText:self.v1];
        
        [m_LeftButton.upLabel setText:self.homeTeam];
        [m_LeftButton.downLabel setText:self.v3];
        
        if ([m_letPoint length] > 0)
        {
            UniChar chr = [m_letPoint characterAtIndex:0];
            if (chr == '-')
            {
                [m_CenterButton.upLabel setText:m_letPoint];
                [m_CenterButton.upLabel setTextColor:[UIColor blueColor]];
            }
            else
            {
                if ([m_letPoint intValue] > 0) {
                    [m_CenterButton.upLabel setText:m_letPoint];
                    [m_CenterButton.upLabel setTextColor:[UIColor redColor]];
                }
                else
                {
                    if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
                        [m_CenterButton.upLabel setText:@"VS"];
                    }
                    else
                    {
                        [m_CenterButton.upLabel setText:@"0"];
                    }
                    
                    m_CenterButton.upLabel.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
                }
            }
        }
        else
        {
            if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
                [m_CenterButton.upLabel setText:@"VS"];
            }
            else
            {
                [m_CenterButton.upLabel setText:@"0"];
            }
            
            m_CenterButton.upLabel.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
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
        if (m_SFCButton != nil) {
            m_SFCButton.hidden = YES;
        }
        SD_Button.hidden = NO;
        SS_Button.hidden = NO;
        XD_Button.hidden = NO;
        XS_Button.hidden = NO;
        
        //        m_fenxiButton.hidden = YES;
        
        m_lable_VS.hidden = NO;
        m_lable_visitTeam.hidden = NO;
        m_lable_homeTeam.hidden = NO;
        
        m_lable_VS.text = @"VS";
        m_lable_VS.textColor = [UIColor colorWithRed:49.0/255.0 green:129.0/255 blue:68.0/255 alpha:1.0];
        
        //竞彩足球 主队在前
        m_lable_homeTeam.frame = CGRectMake(85, 2, 80, 35);
        m_lable_visitTeam.frame = CGRectMake(190, 2, 80, 35);
        m_lable_homeTeam.text = self.homeTeam;
        m_lable_visitTeam.text = self.VisitTeam;
        
        [self setBJDC_SXDSbutton];
        
    }
}
//刷新 页面跟 数据
-(void) RefreshCellView
{
    //设置 分析隐藏
    if (m_isHidenFenXi) {
        [m_fenxiButton setHidden:YES];
        
    }else{
        [m_fenxiButton setHidden:NO];
    }
    
    
    if (1 == m_isJCLQtableview) {
        [self setupJCLQCell];
    }
    else
    {
        [self setupJCZQCell];
    }
    
    if ([m_league length] < 4) {
        
        m_button_league.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    else
        m_button_league.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    [m_button_league setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_button_league setTitle:m_league forState:UIControlStateNormal];
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
    [m_lable_endTime setText:[NSString stringWithFormat:@"%@%@\n%@(截)",weekday,self.teamld,self.endTime]];
    
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
        
        [self setupDanButton];
        [self JC_Dan_ButtonButtonImageChange];
    }
    else
    {
        if (m_JC_Button_Dan != nil) {
            [m_JC_Button_Dan removeFromSuperview];
            [m_JC_Button_Dan release], m_JC_Button_Dan = nil;
        }
    }
}
-(void) leftButtonImageChange
{
    if (m_isLeftSelect) {
        if(m_playTypeTag == IJCLQPlayType_BigAndSmall ||
           m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan
           )
        {
            [m_LeftButton setBackgroundImage:[UIImage imageNamed:@"jc_bigorsmall_teambutton_click.png"] forState:UIControlStateNormal];
            [m_LeftButton.upLabel setTextColor:[UIColor blackColor]];
        }
        else
        {
            [m_LeftButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_click.png"] forState:UIControlStateNormal];
            [m_LeftButton.upLabel setTextColor:[UIColor whiteColor]];
        }
    }
    else
    {
        [m_LeftButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_normal.png"] forState:UIControlStateNormal];
        [m_LeftButton.upLabel setTextColor:[UIColor blackColor]];
    }
    
}
-(void) rightButtonImageChange
{
    if (m_isRightSelect) {
        if(m_playTypeTag == IJCLQPlayType_BigAndSmall ||
           m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan
           )
        {
            [m_RightButton setBackgroundImage:[UIImage imageNamed:@"jc_bigorsmall_teambutton_click.png"] forState:UIControlStateNormal];
            [m_RightButton.upLabel setTextColor:[UIColor blackColor]];
        }
        else
        {
            [m_RightButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_click.png"] forState:UIControlStateNormal];
            [m_RightButton.upLabel setTextColor:[UIColor whiteColor]];
        }
    }
    else
    {
        [m_RightButton setBackgroundImage:[UIImage imageNamed:@"jc_teambutton_normal.png"] forState:UIControlStateNormal];
        [m_RightButton.upLabel setTextColor:[UIColor blackColor]];
    }
}

-(void) centerButtonImageChange
{
    if (m_isCenterSelect) {
        [m_CenterButton setBackgroundImage:[UIImage imageNamed:@"jc_teambuttoncenter_click.png"] forState:UIControlStateNormal];
    }
    else
    {
        [m_CenterButton setBackgroundImage:[UIImage imageNamed:@"jc_teambuttoncenter_normal.png"] forState:UIControlStateNormal];
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
        int count = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_JCLQ_parentViewController.tableCell_DataArray objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] count];
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
        
        
        JCLQ_tableViewCell_DataBase* tableCell = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_JCZQ_parentViewController.tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row];
        
        int goalArrayCount = [[tableCell sfc_selectTag] count];
        
        if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] || goalArrayCount > 0)
        {
            return TRUE;
        }
    }
    
    else if(2 == m_isJCLQtableview)
    {
        JCLQ_tableViewCell_DataBase* tableCell = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_BJDC_parentViewController.tableCell_DataArray objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]];
        
        int count = [[tableCell sfc_selectTag] count];
        if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] ||count > 0 || [tableCell BD_XS_ButtonIsSelect] || [tableCell BD_XD_ButtonIsSelect] || [tableCell BD_SS_ButtonIsSelect] || [tableCell BD_SD_ButtonIsSelect]) {
            
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

@synthesize vf = m_vf;
@synthesize vp = m_vp;
@synthesize vs = m_vs;

@synthesize letPoint = m_letPoint;
@synthesize letVs_v0 = m_letVs_v0;
@synthesize letVs_v3 = m_letVs_v3;
@synthesize Big = m_Big;
@synthesize Small = m_Small;
@synthesize basePoint = m_basePoint;
@synthesize sfc_selectTag = m_sfc_selectTag;
@synthesize confusion_selectTag = m_confusion_selectTag;
@synthesize confusionButtonText = m_confusionButtonText;
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

@synthesize sxdsV1 = m_sxdsV1;
@synthesize sxdsV2 = m_sxdsV2;
@synthesize sxdsV3 = m_sxdsV3;
@synthesize sxdsV4 = m_sxdsV4;

@synthesize goalArray = m_goalArray;
@synthesize score_S_Array = m_score_S_Array;
@synthesize score_P_Array = m_score_P_Array;
@synthesize score_F_Array = m_score_F_Array;
@synthesize half_Array = m_half_Array;

@synthesize ZQ_S_ButtonIsSelect = m_ZQ_S_ButtonIsSelect;
@synthesize ZQ_P_ButtonIsSelect = m_ZQ_P_ButtonIsSelect;
@synthesize ZQ_F_ButtonIsSelect = m_ZQ_F_ButtonIsSelect;

@synthesize BD_SD_ButtonIsSelect, BD_SS_ButtonIsSelect, BD_XD_ButtonIsSelect, BD_XS_ButtonIsSelect;

@synthesize isUnSupportArry = m_isUnSupportArray;
- (id)init {
    self = [super init];
    if (self)
    {
        m_sfc_selectTag = [[NSMutableArray alloc] initWithCapacity:10];
        
        m_confusion_selectTag = [[NSMutableArray alloc] initWithCapacity:5];
        NSMutableArray* array1 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array2 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array3 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array4 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        NSMutableArray* array5 = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        [self.confusion_selectTag addObject:array1];
        [self.confusion_selectTag addObject:array2];
        [self.confusion_selectTag addObject:array3];
        [self.confusion_selectTag addObject:array4];
        [self.confusion_selectTag addObject:array5];
        
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
    
    [m_sfc_selectTag release];
    [m_confusion_selectTag release];
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

- (BOOL)isSelectThisMatch:(int)playType
{
    switch (playType) {
        case IBJDCPlayType_SXDS:
            if (BD_SD_ButtonIsSelect || BD_SS_ButtonIsSelect || BD_XD_ButtonIsSelect || BD_XS_ButtonIsSelect)
                return YES;
            break;
        default:
            break;
    }
    return NO;
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
            
            else if([kLotNoJCZQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_SPF_DanGuan]];
            }
            else if([kLotNoJCZQ_RQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_RQ_SPF_DanGuan]];
            }
            else if([kLotNoJCZQ_ZJQ isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_ZJQ_DanGuan]];
            }
            else if([kLotNoJCZQ_SCORE isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_Score_DanGuan]];
            }
            else if([kLotNoJCZQ_HALF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_HalfAndAll_DanGuan]];
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
            
            else if([kLotNoJCZQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_SPF]];
            }
            else if([kLotNoJCZQ_RQ_SPF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_RQ_SPF]];
            }
            else if([kLotNoJCZQ_ZJQ isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_ZJQ]];
            }
            else if([kLotNoJCZQ_SCORE isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_Score]];
            }
            else if([kLotNoJCZQ_HALF isEqual:lotNo])
            {
                [m_isUnSupportArray addObject:[NSString stringWithFormat:@"%d" ,IJCZQPlayType_HalfAndAll]];
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

