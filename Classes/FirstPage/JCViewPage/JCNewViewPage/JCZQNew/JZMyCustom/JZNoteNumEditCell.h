//
//  JZNoteNumEditCell.h
//  Boyacai
//
//  Created by qiushi on 13-8-22.
//
//

#import <UIKit/UIKit.h>
#import "JC_MyButton.h"
#import "JZ_NoteNumEditeViewController.h"

@interface JZNoteNumEditCell : UITableViewCell

{
    UIButton                    *m_danButton;
    UIButton                    *m_deleteNoteBtn;
    UILabel                     *m_lable_VS;
    UILabel                     *m_lable_visitTeam;
    UILabel                     *m_lable_homeTeam;
    UILabel                     *m_handicapLable;
    int                         m_playTypeTag;
    JC_MyButton                 *m_LeftButton;
    JC_MyButton                 *m_CenterButton;
    JC_MyButton                 *m_RightButton;
    NSString                    *m_homeTeam;
    NSString                    *m_VisitTeam;
    BOOL                        m_isLeftSelect;
    BOOL                        m_isCenterSelect;
    BOOL                        m_isRightSelect;
    BOOL                        m_isHidenFenXi;
    
    //设胆是否选中
    BOOL                        m_isJC_Button_Dan_Select;
    
    NSString*                   m_vf;
    NSString*                   m_vp;
    NSString*                   m_vs;
    UIButton                    *m_SFCButton;
    JZ_NoteNumEditeViewController   *m_jZ_NoteNumEditeViewController;
    
    NSIndexPath                             *m_indexpath;
    
    
}

@property (nonatomic,retain)UIButton                *deleteNoteBtn;

@property (nonatomic,assign)BOOL                    isLeftSelect;
@property (nonatomic,assign)BOOL                    isCenterSelect;
@property (nonatomic,assign)BOOL                    isRightSelect;

@property (nonatomic,assign) BOOL           isJC_Button_Dan_Select;

@property (nonatomic,retain)JC_MyButton             *LeftButton;
@property (nonatomic,retain)JC_MyButton             *CenterButton;
@property (nonatomic,retain)JC_MyButton             *RightButton;

@property (nonatomic,retain)NSIndexPath             *indexpath;
@property (nonatomic,retain) JZ_NoteNumEditeViewController   *jZ_NoteNumEditeViewController;
@property (nonatomic,retain) UIButton  *SFCButton;
@property (nonatomic,retain) NSString* vf;
@property (nonatomic,retain) NSString* vp;
@property (nonatomic,retain) NSString* vs;
@property (nonatomic,retain) NSString   *homeTeam;
@property (nonatomic,retain) NSString   *VisitTeam;

@property (nonatomic,assign) int        playTypeTag;
@property(nonatomic,retain) UIButton    *danButton;

- (void)RefreshCellView;
@end

/////////////////////////////////data//////////////////////////////////
@interface JZNoteNumEditCell_DataBase : NSObject {
    NSString                                *m_dayTime;
    NSString                                *m_dayForamt;
    
    NSString                                *m_league;
    NSString                                *m_endTime;
    NSString                                *m_homeTeam;
    NSString                                *m_VisitTeam;
    
    NSString                                *m_week;
    
    NSString                                *m_teamld;
    NSString                                *m_weekld;
    NSString                                *m_v0;//让负
    NSString                                *m_v1;
    NSString                                *m_v3;//让胜
    
    //    //让球胜平负
    NSString                                *m_vf;//负
    NSString                                *m_vp;
    NSString                                *m_vs;//胜
    
    NSString                                *m_letPoint;
    NSString                                *m_letVs_v0;
    NSString                                *m_letVs_v3;
    NSString                                *m_Big;
    NSString                                *m_Small;
    NSString                                *m_basePoint;
    
    //胜分差
    NSString                                *m_sfcV01;
    NSString                                *m_sfcV02;
    NSString                                *m_sfcV03;
    NSString                                *m_sfcV04;
    NSString                                *m_sfcV05;
    NSString                                *m_sfcV06;
    NSString                                *m_sfcV11;
    NSString                                *m_sfcV12;
    NSString                                *m_sfcV13;
    NSString                                *m_sfcV14;
    NSString                                *m_sfcV15;
    NSString                                *m_sfcV16;
    
    BOOL                                    m_visitTeamIsSelect;
    BOOL                                    m_homeTeamIsSelect;
    
    //北京单场  上下单双
    NSString                                *m_sxdsV1;//上单
    NSString                                *m_sxdsV2;//上双
    NSString                                *m_sxdsV3;//下单
    NSString                                *m_sxdsV4;//下双
    
    /*
     精彩足球
     */
    //胜平负
    BOOL                                    m_ZQ_S_ButtonIsSelect;
    BOOL                                    m_ZQ_P_ButtonIsSelect;
    BOOL                                    m_ZQ_F_ButtonIsSelect;
    //总进球数
    NSMutableArray                          *m_goalArray;
    //比分
    NSMutableArray                          *m_score_S_Array;
    NSMutableArray                          *m_score_P_Array;
    NSMutableArray                          *m_score_F_Array;
    //半全场
    NSMutableArray                          *m_half_Array;
    
    NSMutableArray                          *m_sfc_selectTag;
    NSMutableArray                          *m_isUnSupportArray;//不支持的玩法 存放的是玩法的枚举值
    BOOL                                    m_JC_DanIsSelect;
    
    //混合过关
    NSMutableArray*                         m_confusion_selectTag;//竞彩 篮球跟 足球 一样，里面存的都是 四个数组（表示 四种混合玩法）
    NSString                                *m_confusionButtonText;
    BOOL                                    m_isExpend;
    NSIndexPath                             *m_indexpath;
}
@property (nonatomic,assign) BOOL    isExpend;
@property (nonatomic , retain) NSIndexPath        *indexpath;
@property (nonatomic , retain) NSMutableArray* isUnSupportArry;
@property (nonatomic , retain) NSMutableArray* sfc_selectTag;
@property (nonatomic,retain) NSMutableArray* confusion_selectTag;

@property (nonatomic,retain) NSString* confusionButtonText;
@property (nonatomic , retain) NSString* dayTime;
@property (nonatomic,retain) NSString* dayforamt;

@property (nonatomic , retain) NSString* league;
@property (nonatomic,retain) NSString* endTime;
@property (nonatomic,retain) NSString* homeTeam;
@property (nonatomic,retain) NSString* VisitTeam;

@property (nonatomic,retain) NSString* teamld;
@property (nonatomic,retain) NSString* week;

@property (nonatomic,retain) NSString* weekld;
@property (nonatomic,retain) NSString* v0;
@property (nonatomic,retain) NSString* v1;
@property (nonatomic,retain) NSString* v3;

@property (nonatomic,retain) NSString* vf;
@property (nonatomic,retain) NSString* vp;
@property (nonatomic,retain) NSString* vs;

@property (nonatomic,retain) NSString* letPoint;
@property (nonatomic,retain) NSString* letVs_v0;
@property (nonatomic,retain) NSString* letVs_v3;
@property (nonatomic,retain) NSString* Big;
@property (nonatomic,retain) NSString* Small;
@property (nonatomic,retain) NSString* basePoint;

@property (nonatomic,retain) NSString* sfcV01;
@property (nonatomic,retain) NSString* sfcV02;
@property (nonatomic,retain) NSString* sfcV03;
@property (nonatomic,retain) NSString* sfcV04;
@property (nonatomic,retain) NSString* sfcV05;
@property (nonatomic,retain) NSString* sfcV06;
@property (nonatomic,retain) NSString* sfcV11;
@property (nonatomic,retain) NSString* sfcV12;
@property (nonatomic,retain) NSString* sfcV13;
@property (nonatomic,retain) NSString* sfcV14;
@property (nonatomic,retain) NSString* sfcV15;
@property (nonatomic,retain) NSString* sfcV16;

@property (nonatomic,retain) NSString* sxdsV1;
@property (nonatomic,retain) NSString* sxdsV2;
@property (nonatomic,retain) NSString* sxdsV3;
@property (nonatomic,retain) NSString* sxdsV4;

/*
 总进球数 0 - 7+
 */
@property (nonatomic,retain) NSMutableArray* goalArray;

@property (nonatomic,retain) NSMutableArray* score_S_Array;
@property (nonatomic,retain) NSMutableArray* score_P_Array;
@property (nonatomic,retain) NSMutableArray* score_F_Array;
/*
 比分 score_vxx
 胜
 平
 负
 */
//平
//负
@property (nonatomic,retain) NSMutableArray* half_Array;

@property (nonatomic,assign) BOOL ZQ_S_ButtonIsSelect;
@property (nonatomic,assign) BOOL ZQ_P_ButtonIsSelect;
@property (nonatomic,assign) BOOL ZQ_F_ButtonIsSelect;

@property (nonatomic,assign) BOOL BD_SD_ButtonIsSelect;
@property (nonatomic,assign) BOOL BD_SS_ButtonIsSelect;
@property (nonatomic,assign) BOOL BD_XD_ButtonIsSelect;
@property (nonatomic,assign) BOOL BD_XS_ButtonIsSelect;

-(BOOL) visitTeamIsSelect;
-(BOOL) homeTeamIsSelect;
-(BOOL) JC_DanIsSelect;

-(void) setVisitTeamIsSelect:(BOOL)visitTeamIsSelect;
-(void) setHomeTeamIsSelect:(BOOL)homeTeamIsSelect;
-(void) setJC_DanIsSelect:(BOOL)JC_DanIsSelect;

-(void) appendToBaseUnSupportDuiZhen:(NSString*)lotNo;

//-(int) selectCountEveryMatch:(int)playType;
- (BOOL)isSelectThisMatch:(int)playType;

@end

@interface JZNoteNumEdit_DataArray : NSObject {
    NSMutableArray                          *m_tableHeaderArray;
}
@property (nonatomic,retain) NSMutableArray* tableHeaderArray;
- (NSInteger) baseCount;
@end

