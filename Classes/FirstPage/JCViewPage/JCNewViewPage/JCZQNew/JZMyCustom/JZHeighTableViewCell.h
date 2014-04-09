//
//  JZTableViewCell.h
//  Boyacai
//
//  Created by qiushi on 13-8-15.
//
//

#import <UIKit/UIKit.h>
#import "JZ_MainGameViewController.h"
#import "JZCell_DataBaseModel.h"

@class JCLQ_tableViewCell_DataBase;
@class BJDC_pickNumViewController;
@class JC_MyButton;



@interface JZHeighTableViewCell : UITableViewCell {
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

    JZ_MainGameViewController           *m_JCZQ_parentViewController;
    int                                     m_playTypeTag;
    
    UILabel*                               m_lable_league;
    //    UILabel                                 *m_lable_league;
    UILabel                                 *m_lable_endTime;
    JC_MyButton                                *m_LeftButton;
    JC_MyButton                                *m_CenterButton;
    JC_MyButton                                *m_RightButton;
    
    JC_MyButton                                *m_RQLeftButton;
    JC_MyButton                                *m_RQCenterButton;
    JC_MyButton                                *m_RQRightButton;
    
    UILabel                                    *m_handicapLable;
    
    UIButton                                *m_JC_Button_Dan;
    BOOL                                    m_isJC_Button_Dan_Select;
    
    BOOL                                    m_isLeftSelect;
    BOOL                                    m_isCenterSelect;
    BOOL                                    m_isRightSelect;
    //非让球的三个变量值
    BOOL                                    m_isRQLeftSelect;
    BOOL                                    m_isRQCenterSelect;
    BOOL                                    m_isRQRightSelect;
    
    BOOL                                    m_isHidenFenXi;
    

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
    

    //是否展开变量
    BOOL                                    m_isExpend;
    UIButton                                *m_expendButton;
    UIView                                  *m_expendView;
    UIImageView                             *m_downLogImageView;
    UIImageView                             *m_upLogImageView;
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

@property (nonatomic,assign) BOOL isJC_Button_Dan_Select;

@property (nonatomic,retain) UIButton* SFCButton;
@property (nonatomic,retain) NSString* SFCButtonText;

@property (nonatomic,retain) NSIndexPath* indexPath;
@property (nonatomic,assign) int playTypeTag;

@property (nonatomic,retain)JZ_MainGameViewController* JCZQ_parentViewController;
@property (nonatomic, retain)BJDC_pickNumViewController*  BJDC_parentViewController;
@property (nonatomic , retain) UIButton     *expendButton;

@property (nonatomic,assign) BOOL isCenterSelect;
@property (nonatomic,assign) BOOL isLeftSelect;
@property (nonatomic,assign) BOOL isRightSelect;
@property (nonatomic,assign) BOOL isRQCenterSelect;
@property (nonatomic,assign) BOOL isRQLeftSelect;
@property (nonatomic,assign) BOOL isRQRightSelect;
@property (nonatomic,assign) BOOL isHidenFenXi;
@property (nonatomic,retain) NSString* sxdsV1;
@property (nonatomic,retain) NSString* sxdsV2;
@property (nonatomic,retain) NSString* sxdsV3;
@property (nonatomic,retain) NSString* sxdsV4;



-(void) setCell :(JZTableViewCell_DataBase *)base;
-(void) RefreshCellView;

@end