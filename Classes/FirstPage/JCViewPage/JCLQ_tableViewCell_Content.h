//
//  JCLQ_tableViewCell_Content.h
//  RuYiCai
//
//  Created by ruyicai on 12-4-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQ_PickGameViewController.h"
#import "JCZQ_PickGameViewController.h"
@class JCLQ_tableViewCell_DataBase;

@interface JCLQ_tableViewCell_Content : UITableViewCell {
    BOOL                                    m_isJCLQtableview;
    
    NSString                                *m_league;
    NSString                                *m_endTime;
    NSString                                *m_homeTeam;
    NSString                                *m_VisitTeam;

    NSString                                *m_teamld;
    NSString                                *m_weekld;
    NSString                                *m_v0;
    NSString                                *m_v1;
    NSString                                *m_v3;
    NSString                                *m_letPoint;
    NSString                                *m_letVs_v0;
    NSString                                *m_letVs_v3;
    NSString                                *m_Big;
    NSString                                *m_Small;
    NSString                                *m_basePoint;
    
    UIButton                                *m_homeTeamButton;
    UIButton                                *m_visitTeamButton;
    BOOL                                    m_isHomeTeamSelect;
    BOOL                                    m_isVisitTeamSelect;
    
    UIButton                                *m_ZQ_S_Button;
    UIButton                                *m_ZQ_P_Button;
    UIButton                                *m_ZQ_F_Button;
    
    UIButton                                *m_fenxiButton;
    
    BOOL                                    m_isZQ_S_Button_Select;
    BOOL                                    m_isZQ_P_Button_Select;
    BOOL                                    m_isZQ_F_Button_Select;
    
    UIButton                                *m_JC_Button_Dan;
    BOOL                                    m_isJC_Button_Dan_Select;
    
    UILabel                                 *m_lable_league;
    UILabel                                 *m_lable_endTime;
    UILabel                                 *m_lable_visitTeam;
    UILabel                                 *m_lable_homeTeam;
    UILabel                                 *m_lable_v0;
    UILabel                                 *m_lable_v3;

    UILabel                                 *HomeTeamlable;
    UILabel                                 *visitTeamlable;
    

    NSIndexPath                             *m_indexPath;
    JCLQ_PickGameViewController             *m_JCLQ_parentViewController;
    
    JCZQ_PickGameViewController             *m_JCZQ_parentViewController;
    UILabel                                 *m_lable_VS;
    int                                     m_playTypeTag;
    
    UIButton                                *m_SFCButton;
    NSString                                *m_SFCButtonText;
    
    UILabel                                 *m_teamldlable;
    
    UILabel                                 *m_lable_endDate;
    UILabel                                 *m_lable_endWeek;
}
@property (nonatomic,retain) UILabel   *lable_VS;
@property (nonatomic,retain) UIButton  *fenxiButton;
@property (nonatomic,retain) UILabel   *lable_endDate;
@property (nonatomic,retain) UILabel   *lable_endWeek;
@property (nonatomic,assign) BOOL isJCLQtableview;
@property (nonatomic , retain) NSString* league;
@property (nonatomic,retain) NSString* endTime;
@property (nonatomic,retain) NSString* homeTeam;
@property (nonatomic,retain) NSString* VisitTeam;

@property (nonatomic,retain) NSString* teamld;
@property (nonatomic,retain) NSString* weekld;
@property (nonatomic,retain) NSString* v0;
@property (nonatomic,retain) NSString* v1;
@property (nonatomic,retain) NSString* v3;
@property (nonatomic,retain) NSString* letPoint;
@property (nonatomic,retain) NSString* letVs_v0;
@property (nonatomic,retain) NSString* letVs_v3;
@property (nonatomic,retain) NSString* Big;
@property (nonatomic,retain) NSString* Small;
@property (nonatomic,retain) NSString* basePoint;

@property (nonatomic,retain) UIButton* JC_Button_Dan;
@property (nonatomic,assign) BOOL isJC_Button_Dan_Select;

@property (nonatomic,retain) UIButton* homeTeamButton;
@property (nonatomic,retain) UIButton* visitTeamButton;
@property (nonatomic,retain) UIButton* SFCButton;
@property (nonatomic,retain) NSString* SFCButtonText;

@property (nonatomic,retain) UIButton* ZQ_S_Button;
@property (nonatomic,retain) UIButton* ZQ_P_Button;
@property (nonatomic,retain) UIButton* ZQ_F_Button;

@property (nonatomic,assign) BOOL isZQ_S_Button_Select;
@property (nonatomic,assign) BOOL isZQ_P_Button_Select;
@property (nonatomic,assign) BOOL isZQ_F_Button_Select;
 
@property (nonatomic,assign) BOOL isHomeTeamSelect;
@property (nonatomic,assign) BOOL isVisitTeamSelect;
@property (nonatomic,retain) NSIndexPath* indexPath;

@property (nonatomic,assign) int playTypeTag;
@property (nonatomic,retain) JCLQ_PickGameViewController* JCLQ_parentViewController;
@property (nonatomic,retain) JCZQ_PickGameViewController* JCZQ_parentViewController;

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
    NSString                                *m_v0;
    NSString                                *m_v1;
    NSString                                *m_v3;
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
    
    //精彩足球
    
    //1.0 总进球数
    NSMutableArray                          *m_goalArray;
    //2.0 比分
    NSMutableArray                          *m_score_S_Array;
    NSMutableArray                          *m_score_P_Array;
    NSMutableArray                          *m_score_F_Array;

    //半全场
    NSMutableArray                          *m_half_Array;
 
    BOOL                                    m_ZQ_S_ButtonIsSelect;
    BOOL                                    m_ZQ_P_ButtonIsSelect;
    BOOL                                    m_ZQ_F_ButtonIsSelect;
 
    NSMutableArray                          *m_sfc_selectTag;
    
    NSMutableArray                          *m_isUnSupportArray;//不支持的玩法 存放的是玩法的枚举值

    BOOL                                    m_JC_DanIsSelect;
}
@property (nonatomic , retain) NSMutableArray* isUnSupportArry;
@property (nonatomic , retain) NSMutableArray* sfc_selectTag;

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

-(BOOL) visitTeamIsSelect;
-(BOOL) homeTeamIsSelect;
-(BOOL) JC_DanIsSelect;

-(void) setVisitTeamIsSelect:(BOOL)visitTeamIsSelect;
-(void) setHomeTeamIsSelect:(BOOL)homeTeamIsSelect;
-(void) setJC_DanIsSelect:(BOOL)JC_DanIsSelect;

-(void) appendToBaseUnSupportDuiZhen:(NSString*)lotNo;
 
@end

@interface JCLQ_tableViewCell_DataArray : NSObject {
    NSMutableArray                          *m_tableHeaderArray;
}
@property (nonatomic,retain) NSMutableArray* tableHeaderArray;
- (NSInteger) baseCount;
@end


