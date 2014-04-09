//
//  JZNoteNumEditCell.m
//  Boyacai
//
//  Created by qiushi on 13-8-22.
//
//

#import "JZNoteNumEditCell.h"
#import "RuYiCaiCommon.h"
#import "ColorUtils.h"
@interface JZNoteNumEditCell()
{
    UIButton *_testButton;
}
@property (nonatomic, retain) UIButton *testButton;
@end

@implementation JZNoteNumEditCell

@synthesize danButton = m_danButton;
@synthesize playTypeTag = m_playTypeTag;
@synthesize homeTeam    = m_homeTeam;
@synthesize VisitTeam   = m_VisitTeam;
@synthesize vf          = m_vf;
@synthesize vp          = m_vp;
@synthesize vs          = m_vs;
@synthesize SFCButton   = m_SFCButton;
@synthesize jZ_NoteNumEditeViewController = m_jZ_NoteNumEditeViewController;

@synthesize indexpath = m_indexpath;


@synthesize isJC_Button_Dan_Select = m_isJC_Button_Dan_Select;

@synthesize LeftButton = m_LeftButton;
@synthesize CenterButton = m_CenterButton;
@synthesize RightButton = m_RightButton;
@synthesize isLeftSelect = m_isLeftSelect;
@synthesize isCenterSelect = m_isCenterSelect;
@synthesize isRightSelect = m_isRightSelect;
@synthesize deleteNoteBtn = m_deleteNoteBtn;

- (void)dealloc
{
    [m_deleteNoteBtn release];
    [m_indexpath release];
    [m_jZ_NoteNumEditeViewController release];
    [m_SFCButton release];
    [m_vf release];
    [m_vp release];
    [m_vs release];
    [m_VisitTeam release];
    [m_homeTeam release];
    [m_handicapLable release];
    [m_lable_VS release];
    [m_lable_homeTeam release];
    [m_lable_visitTeam release];
    [m_danButton release];
    [super dealloc];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
        
        UIImageView* downBgline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        downBgline.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:downBgline];
        [downBgline release];
        
        UIImageView* upBgline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 320, 1)];
        upBgline.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d6d1"];
        [self addSubview:upBgline];
        [upBgline release];
        
        m_danButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_danButton.frame = CGRectMake(250, 38, 33, 30);
        m_danButton.backgroundColor = [UIColor redColor];
        [m_danButton setBackgroundImage:[UIImage imageNamed:@"dan_jz_c_nomal.png"] forState:UIControlStateNormal];
        [m_danButton setBackgroundImage:[UIImage imageNamed:@"dan_jz_c_click.png"] forState:UIControlStateSelected];
        [m_danButton setBackgroundImage:[UIImage imageNamed:@"dan_jz_c_click.png"] forState:UIControlStateHighlighted];
        [m_danButton addTarget:self action:@selector(JC_Dan_ButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_danButton];
        
        //删除赛事
        m_deleteNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        m_deleteNoteBtn.frame = CGRectMake(290, 42, 21, 21);
        [m_deleteNoteBtn setBackgroundImage:[UIImage imageNamed:@"delete_c_note.png"] forState:UIControlStateNormal];

        [self addSubview:m_deleteNoteBtn];
        
// 主队在前
        
        m_lable_VS = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, 39, 30)];
        m_lable_VS.text = @"VS";
        [m_lable_VS setTextColor:[UIColor redColor]];
        m_lable_VS.textAlignment = UITextAlignmentCenter;
        m_lable_VS.backgroundColor = [UIColor clearColor];
        m_lable_VS.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lable_VS];
        
        m_lable_visitTeam = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 80, 35)];
        m_lable_visitTeam.textAlignment = UITextAlignmentCenter;
        m_lable_visitTeam.backgroundColor = [UIColor clearColor];
        m_lable_visitTeam.font = [UIFont boldSystemFontOfSize:13];
        m_lable_visitTeam.lineBreakMode = UILineBreakModeWordWrap;
        m_lable_visitTeam.numberOfLines = 2;
        [self addSubview:m_lable_visitTeam];
        
        m_lable_homeTeam = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 80, 35)];
        m_lable_homeTeam.textAlignment = UITextAlignmentCenter;
        m_lable_homeTeam.backgroundColor = [UIColor clearColor];
        m_lable_homeTeam.font = [UIFont boldSystemFontOfSize:13];
        m_lable_homeTeam.lineBreakMode = UILineBreakModeWordWrap;
        m_lable_homeTeam.numberOfLines = 2;
        [self addSubview:m_lable_homeTeam];
        //让分图表制作
        m_handicapLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, 15, 30)];
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


//刷新 页面跟 数据
-(void) RefreshCellView
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
        
        [m_lable_visitTeam setText:self.VisitTeam];
        [m_RightButton.downLabel setText:[NSString stringWithFormat:@"负%@",self.vf]];
        
        
        [m_CenterButton.downLabel setText:[NSString stringWithFormat:@"平%@",self.vp]];
        
        [m_lable_homeTeam setText:self.homeTeam];
        [m_LeftButton.downLabel setText:[NSString stringWithFormat:@"胜%@",self.vs]];
        
        
        
        [self leftButtonImageChange];
        [self centerButtonImageChange];
        [self rightButtonImageChange];
        
    }
    
}


//构建 左边按钮
-(void) setupLeftButton
{
    if (m_LeftButton != nil) {
        [m_LeftButton removeFromSuperview];
        [m_LeftButton release];
    }
    m_LeftButton = [[JC_MyButton alloc] initWithFrame:CGRectMake(15, 37, 75, 30)];
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
    m_CenterButton = [[JC_MyButton alloc] initWithFrame:CGRectMake(90, 37, 75, 30)];
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
    m_RightButton = [[JC_MyButton alloc] initWithFrame:CGRectMake(165, 37, 75, 30)];
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
//    [m_SFCButton setTitle:[NSString stringWithString:m_SFCButtonText] forState:UIControlStateNormal];
    [m_SFCButton setTitleColor:[ColorUtils parseColorFromRGB:@"#675634"] forState:UIControlStateNormal];
    [m_SFCButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#dcd4c7"]];
    //    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_click.png"] forState:UIControlStateNormal];
    //    [m_SFCButton setBackgroundImage:[UIImage imageNamed:@"sfcbutton_normal.png"] forState:UIControlStateHighlighted];
    [self addSubview:m_SFCButton];
    
}


//-(void) SFCButtonClick
//{
//        [m_JCZQ_parentViewController gotoSFCView:m_indexPath];
//
//}
//三个按钮的点击效果
-(void) leftButtonClick
{
    //设置图片
    m_isLeftSelect = !m_isLeftSelect;
    BOOL notOverMax = NO;

    notOverMax =  [m_jZ_NoteNumEditeViewController changeClickState:m_indexpath clickState:m_isLeftSelect ButtonIndex:1];

    notOverMax ? ([self leftButtonImageChange]) : (m_isLeftSelect = !m_isLeftSelect);//如果超过 返回 最初的状态
}
-(void) rightButtonClick
{
    m_isRightSelect = !m_isRightSelect;
    BOOL notOverMax = NO;
        notOverMax =  [m_jZ_NoteNumEditeViewController changeClickState:m_indexpath clickState:m_isRightSelect ButtonIndex:3];
    notOverMax ? ([self rightButtonImageChange]) : (m_isRightSelect = !m_isRightSelect);//如果超过 返回 最初的状态
}

-(void) centerButtonClick
{
        m_isCenterSelect = !m_isCenterSelect;
        BOOL notOverMax =  [m_jZ_NoteNumEditeViewController changeClickState:m_indexpath clickState:m_isCenterSelect ButtonIndex:2];
        
        notOverMax ? ([self centerButtonImageChange]) : (m_isCenterSelect = !m_isCenterSelect);//如果超过 返回 最初的状态
}


//选中的颜色按钮变化
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//胆按钮点击执行方法
-(void) JC_Dan_ButtonClick
{
    BOOL gameIsSelect = [self gameIsSelect];
    if ( gameIsSelect)
    {
        m_isJC_Button_Dan_Select = !m_isJC_Button_Dan_Select;
        /*
         函数返回值 代表是否超过最大比赛数
         */
        BOOL notOverMax =  [m_jZ_NoteNumEditeViewController changeClickState:m_indexpath clickState:m_isJC_Button_Dan_Select ButtonIndex:4];
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

-(void) JC_Dan_ButtonButtonImageChange
{
    if (self.isJC_Button_Dan_Select) {
        [m_danButton setBackgroundImage:[UIImage imageNamed:@"dan_jz_c_click.png"] forState:UIControlStateNormal];
    }
    else
    {
        [m_danButton setBackgroundImage:[UIImage imageNamed:@"dan_jz_c_nomal.png"] forState:UIControlStateNormal];
    }
}

-(BOOL) gameIsSelect
{
        
        NSInteger section;
        NSInteger row;
            
            section = m_indexpath.section;
            row = m_indexpath.row;
  
        
    
    JZNoteNumEditCell_DataBase*  base =(JZNoteNumEditCell_DataBase*) [m_jZ_NoteNumEditeViewController.dataBaseArray objectAtIndex:row];
    
        int goalArrayCount = [[base sfc_selectTag] count];
        
        if ([base ZQ_S_ButtonIsSelect] || [base ZQ_P_ButtonIsSelect] || [base ZQ_F_ButtonIsSelect] || goalArrayCount > 0)
        {
            return TRUE;
        }
    return FALSE;
}



@end

//-----------------------------------data------------------------------

@implementation JZNoteNumEditCell_DataBase
@synthesize indexpath = m_indexpath;
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
@synthesize isExpend = m_isExpend;


- (id)init {
    self = [super init];
    if (self)
    {
        m_isExpend = NO;
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
    [m_indexpath release];
    
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

@implementation JZNoteNumEdit_DataArray
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


