//
//  BJDC_pickNumViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-19.
//
//

#import <UIKit/UIKit.h>

@interface BJDC_pickNumViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    UITableView                *m_tableView;
    NSInteger                   m_headerCount;
    NSString                    *m_currentLotNo;
    int                         m_SectionN[500];//每section行数
    NSMutableArray              *m_tableHeaderState;
    NSMutableArray              *m_tableCell_DataArray;//数据
    
    NSString*                   m_parserDictData;//保存对阵数据
    
    int                         m_playTypeTag;
    
    UIView*                     m_playChooseView;
    UIButton*                   centerButton;
    
    int                         m_numGameCount;//比赛场数
    NSString*                   m_tempStr;//用来记录 临时值的临时变量（按钮的text）
    //联赛筛选
    NSMutableArray              *m_league_tableCell_DataArray;
    NSMutableArray              *m_league_selected_tableCell_DataArrayTag;
    
    UIView                     *m_detailView;
    UILabel                    *m_batchCodeLabel;
    NSMutableArray             *m_arrangeSP;
    UILabel                    *m_leftTimeLabel;
    NSTimer*                    m_timer;
    NSString*                   m_batchEndTime;
    
    
}
@property (nonatomic, retain) NSString* batchEndTime;
@property (nonatomic, retain) NSString *parserDictData;

@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonReselect;
@property (nonatomic, retain) IBOutlet UILabel *totalCost;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, assign) int      playTypeTag;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray    *tableCell_DataArray;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString          *currentLotNo;

@property (nonatomic, retain) NSMutableArray *league_tableCell_DataArray;
@property (nonatomic, retain) NSMutableArray *league_selected_tableCell_DataArrayTag;

- (void) parserData;
- (void) clearAllChoose;
- (void) playChooseButtonEvent;
- (BOOL) changeClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState ButtonIndex:(NSInteger)buttonIndex;
- (void) gotoSFCView:(NSIndexPath*)indexPath;
- (void) reloadData;
- (BOOL) SXDSClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState ButtonIndex:(NSInteger)buttonIndex;
- (void) gotoLeagueChoose;
- (void) gotoFenxiView:(NSIndexPath*)indexPath;
- (BOOL) judgeSetupIsOk;//判断可不可以设胆

@end
