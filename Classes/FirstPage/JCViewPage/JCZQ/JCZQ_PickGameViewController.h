//
//  JCLQ_PickGameViewController.h
//  RuYiCai
//
//  Created by ruyicai on 12-4-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RuYiCaiAppDelegate.h"
#import "JCZQ_PlayChooseViewCell.h"
@class CombineBase;
@class JCLQ_tableViewCell_DataBase;

@interface JCZQ_PickGameViewController :
UIViewController <UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>
{
	UITableView                *m_tableView;
    UIBarButtonItem            *m_rightTitleBarItem;
	
	UILabel                    *m_selectedCount;
    UIButton                   *m_buttonBuy;          //立即投注
    UIButton                   *m_buttonReselect;     //重新选择
    
    UILabel                    *m_totalCost;          //已选比赛：X场
    int                         m_numCost;            //投注金额
    int                         m_numGameCount;
    int                         m_twoCount;
    int                         m_threeCount;
    
    UIAlertView                 *m_selectLotAlterView;
    UIScrollView                *m_selectScrollView;
    NSUInteger                  m_selectLotIndex;
    
    //    NSIndexPath                 *m_currentIndexPath;
    
    RuYiCaiAppDelegate          *m_delegate;
    
    //存放每一组的个数
    NSInteger                   m_headerCount;
	int                         m_SectionN[500];
    NSMutableArray              *m_tableHeaderState;
    NSMutableArray              *m_tableCell_DataArray;
    
    
    //存放摇一摇de数组
    NSMutableArray              *m_motionArray;
    
    JCLQ_tableViewCell_DataBase *base_one;
    JCLQ_tableViewCell_DataBase *base_two;
    
    int                         m_playTypeTag;
    NSMutableArray              *m_SFCSelectScore;
    NSString*                   m_parserDictData;
    
    /*
     2012 -  6 - 18 修改
     m_league_tableCell_DataArray  -- 存放所有的联赛
     m_league_selected_tableCell_DataArray  -- 存放 用户选择的联赛的 tag
     */
    NSMutableArray              *m_league_tableCell_DataArray;
    NSMutableArray              *m_league_selected_tableCell_DataArrayTag;
    
    /*
     2012 - 6 -20 修改
     添加 投注页面赔率 计算 预计奖金金额
     */
    NSMutableArray              *m_arrangeSP;//  （存放 每个对阵的赔率数组  存放类型 CombineBase）
    NSString*                   m_tempStr;//用来记录 临时值的临时变量
    
    /*
     2012 - 6 - 29
     竞彩 单关 与 多关赔率 不一样
     数据 分开存
     */
    NSString*                   m_parserDictData_DanGuan;
    
    /*
     2012 - 8 -6
     增加 竞彩数据分析  即时比分
     */
    UIView                     *m_detailView;
    
    /*
     2013- 3- 25
     玩法切换独立出来
     */
    JCZQ_PlayChooseViewCell                     *m_playChooseView;
    //    UIImageView*                                iamge;
    UIButton*                                   centerButton;
    
    //让分胜负摇一摇筛选数据
    NSMutableArray*            m_randomData_SPF;
    
    //保存选择的比赛的event
    NSMutableArray             *m_eventChooseGameArray;
    //存储Event的关键字
    NSString                   *m_userChooseGameEvent;
}

@property (nonatomic, retain) NSMutableArray *motionArray;

@property (nonatomic, retain) NSMutableArray *league_tableCell_DataArray;
@property (nonatomic, retain) NSMutableArray *league_selected_tableCell_DataArrayTag;

@property (nonatomic, retain) NSString *parserDictData;
@property (nonatomic, retain) NSString *parserDictData_DanGuan;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonReselect;
@property (nonatomic, retain) IBOutlet UILabel *totalCost;

@property (nonatomic, retain) NSMutableArray *tableCell_DataArray;
@property (nonatomic, retain) NSMutableArray *SFCSelectScore;
//@property (nonatomic, retain) NSMutableArray *confusion_selectData;

@property (nonatomic, assign) int playTypeTag;

@property (nonatomic, retain) NSMutableArray *eventChooseGameArray;
@property (nonatomic, retain) NSString       *userChooseGameEvent;

-(BOOL) changeClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState  ButtonIndex:(NSInteger)buttonIndex;

-(void) gotoSFCView:(NSIndexPath*)indexPath;
-(void) gotoFenxiView:(NSIndexPath*)indexPath;
-(void) gotoLeagueChoose;
-(void) clearAllChoose;
-(void) reloadData;

- (void)parserData;

- (BOOL) isDanGuan;
/*
 获得竞彩 对阵后 解析过程
 
 首先 将原始数据 保存在 parserDictData 或 parserDictData_DanGuan中
 其次 获取 联赛
 最后 解析 data 到 m_league_tableCell_DataArray（当前页面 显示数据）
 */
- (void) playChooseButtonEvent;
- (void) changeLeague;
- (void) comeBackFromChooseView;
@end