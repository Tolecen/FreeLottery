//
//  JC_TableView_ContentCell.h
//  RuYiCai
//
//  Created by ruyicai on 13-3-21.
//
//

#import <UIKit/UIKit.h>
#import "JCLQ_PickGameViewController.h"
#import "JCZQ_PickGameViewController.h"
#import "BJDC_pickNumViewController.h"

@class JCLQ_tableViewCell_DataBase;
@class BJDC_pickNumViewController;
#import "MyButton.h"

#define kSXDSbuttonTag (11)//北京单场 上下单双button

@interface JC_TableView_ContentCell : UITableViewCell {
    int                                    m_isJCLQtableview;//1为篮球  2为北京单场  0为竞彩足球
    
    NSString                                *m_league;
    NSString                                *m_endTime;
    NSString                                *m_homeTeam;
    NSString                                *m_VisitTeam;
    
    NSString                                *m_teamld;
    NSString                                *m_weekld;
    NSString                                *m_v0;
    NSString                                *m_v1;
    NSString                                *m_v3;
    
    NSString                                *m_vf;//胜平负    负
    NSString                                *m_vp;//胜平负    平
    NSString                                *m_vs;//胜平负    胜
    
    NSString                                *m_letPoint;
    NSString                                *m_letVs_v0;
    NSString                                *m_letVs_v3;
    NSString                                *m_Big;
    NSString                                *m_Small;
    NSString                                *m_basePoint;
    
    
    UILabel                                 *m_lable_visitTeam;
    UILabel                                 *m_lable_homeTeam;
    UILabel                                 *leftTeamLable;
    UILabel                                 *rightTeamLable;
    UILabel                                 *m_lable_VS;
    
    NSIndexPath                             *m_indexPath;
    JCLQ_PickGameViewController             *m_JCLQ_parentViewController;
    JCZQ_PickGameViewController             *m_JCZQ_parentViewController;
    BJDC_pickNumViewController              *m_BJDC_parentViewController;
    int                                     m_playTypeTag;
    
    UIButton*                               m_button_league;
    //    UILabel                                 *m_lable_league;
    UILabel                                 *m_lable_endTime;
    MyButton                                *m_LeftButton;
    MyButton                                *m_CenterButton;
    MyButton                                *m_RightButton;
    
    UIButton                                *m_fenxiButton;
    UIButton                                *m_JC_Button_Dan;
    BOOL                                    m_isJC_Button_Dan_Select;
    
    BOOL                                    m_isLeftSelect;
    BOOL                                    m_isCenterSelect;
    BOOL                                    m_isRightSelect;
    BOOL                                    m_isHidenFenXi;
    
    MyButton*                               SD_Button;
    MyButton*                               SS_Button;
    MyButton*                               XD_Button;
    MyButton*                               XS_Button;
    
    BOOL                                    m_isSXDSSelect_SD;
    BOOL                                    m_isSXDSSelect_SS;
    BOOL                                    m_isSXDSSelect_XD;
    BOOL                                    m_isSXDSSelect_XS;
    
    UIButton                                *m_SFCButton;
    NSString                                *m_SFCButtonText;
    
    /*
     大小分
     */
    UILabel*                                m_jclq_big_basePoint;
    
    
    //北京单场  上下单双
    NSString                                *m_sxdsV1;//上单
    NSString                                *m_sxdsV2;//上双
    NSString                                *m_sxdsV3;//下单
    NSString                                *m_sxdsV4;//下双
}
@property (nonatomic,assign) int isJCLQtableview;
@property (nonatomic , retain) NSString* league;
@property (nonatomic,retain) NSString* endTime;
@property (nonatomic,retain) NSString* homeTeam;
@property (nonatomic,retain) NSString* VisitTeam;

@property (nonatomic,retain) NSString* teamld;
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

@property (nonatomic,retain) UIButton* JC_Button_Dan;
@property (nonatomic,assign) BOOL isJC_Button_Dan_Select;

@property (nonatomic,retain) UIButton* SFCButton;
@property (nonatomic,retain) NSString* SFCButtonText;

@property (nonatomic,retain) NSIndexPath* indexPath;
@property (nonatomic,assign) int playTypeTag;
@property (nonatomic,retain) JCLQ_PickGameViewController* JCLQ_parentViewController;
@property (nonatomic,retain) JCZQ_PickGameViewController* JCZQ_parentViewController;
@property (nonatomic, retain)BJDC_pickNumViewController*  BJDC_parentViewController;

@property (nonatomic,assign) BOOL isCenterSelect;
@property (nonatomic,assign) BOOL isLeftSelect;
@property (nonatomic,assign) BOOL isRightSelect;
@property (nonatomic,assign) BOOL isHidenFenXi;

@property (nonatomic, assign)BOOL isSXDSSelect_SD;
@property (nonatomic, assign)BOOL isSXDSSelect_SS;
@property (nonatomic, assign)BOOL isSXDSSelect_XD;
@property (nonatomic, assign)BOOL isSXDSSelect_XS;

@property (nonatomic,retain) NSString* sxdsV1;
@property (nonatomic,retain) NSString* sxdsV2;
@property (nonatomic,retain) NSString* sxdsV3;
@property (nonatomic,retain) NSString* sxdsV4;

////////////////////
//@property (nonatomic,retain) UIButton* homeTeamButton;
//@property (nonatomic,retain) UIButton* visitTeamButton;
//@property (nonatomic,assign) BOOL isHomeTeamSelect;
//@property (nonatomic,assign) BOOL isVisitTeamSelect;
//
//@property (nonatomic,retain) UIButton* ZQ_S_Button;
//@property (nonatomic,retain) UIButton* ZQ_P_Button;
//@property (nonatomic,retain) UIButton* ZQ_F_Button;
//
//@property (nonatomic,assign) BOOL isZQ_S_Button_Select;
//@property (nonatomic,assign) BOOL isZQ_P_Button_Select;
//@property (nonatomic,assign) BOOL isZQ_F_Button_Select;



-(void) RefreshCellView;

@end

/////////////////////////////////data//////////////////////////////////
@interface JCLQ_tableViewCell_DataBase : NSObject {
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
}
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

@interface JCLQ_tableViewCell_DataArray : NSObject {
    NSMutableArray                          *m_tableHeaderArray;
}
@property (nonatomic,retain) NSMutableArray* tableHeaderArray;
- (NSInteger) baseCount;
@end
