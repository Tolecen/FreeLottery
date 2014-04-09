//
//  JZ_NoteNumEditeViewController.h
//  Boyacai
//
//  Created by qiushi on 13-8-21.
//
//

#import <UIKit/UIKit.h>
#import "JZ_CombineListModel.h"
#import "RuYiCaiAppDelegate.h"

@class JZ_CombineList;
@class JZ_CombineBase;

typedef enum jzconfusionType
{
    Jz_confusion_BASE = 0,
    JzLQ_SFC = 1,  //竞彩篮球胜分差
    JzZQ_SCORE = 2,//竞彩足球比分
    JzZQ_HALF = 3, //竞彩足球半全场
    JzZQ_ZJQ = 4,  //竞彩足球半全场
}type1;

@interface JZ_NoteNumEditeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    UIButton        *m_editeButton;
    UITableView     *m_tableView;
    NSMutableArray  *m_dataBaseArray;
    int             m_playTypeTag;
    NSMutableArray  *m_tableCell_DataArray;
    NSMutableArray  *m_deleteBaseArray;
    
    int                         m_numCost;            //投注金额
    int                         m_numGameCount;
    int                         m_twoCount;
    int                         m_threeCount;
    
    double                      m_allCount;
    int                         m_betNumber;
    int                         m_DanCount;
    BOOL                        m_isDanGuan;
    
    BOOL                        m_isFreePassButton;

    UILabel*                      m_guoguanFangshLabel;
    //择count ,例如 只有主胜 或 负 则为1  依次递增
    int                         duochuanScrollViewOffset_Y;
    int                         duoChuanPassRadioIndex;
    NSMutableArray              *m_duoChuanPassRadioArray;
    
    UIButton                    *_clearanceButton;
    UIView                      *_bottomView;
    UIScrollView                *_allUpScrollView;
    UIButton                    *_shadowButton;
    BOOL                        isBottomDown;
    UIImageView                 *_downImageView;
    JZ_CombineList                 *m_duoChuanChooseArray;//存放 每场比赛的选择count ,例如 只有主胜 或 负 则为1  依次递增
    int                          m_jzconfusionType;
    
    NSMutableArray               *_freePassRadioIndexArray;
    NSMutableArray               *duoChuanRadioIndexArray;
    //倍数框
    UITextField                  *_fieldBeishu;
    NSString                    *m_chooseBetCode;
    JZ_CombineList                 *m_Com_SParray;//所有的 赔率
    JZ_CombineList                 *m_Com_arrangeSP_Min;//排列之后的 赔率（最小的）
    JZ_CombineList                 *m_Com_arrangeSP_Max;//排列之后的 赔率（最da的）
    
    double                         m_minWinAmount;//最小奖金
    double                         m_maxWinAmount;
    
    double                        m_minAmount_Confusion;//混合过关的最小奖金
    double                        m_maxAmount_Confusion;//混合过关的最大奖金
    
    NSMutableArray               *m_tempConfusionArray;
    //过关方式全局，为了改变他的位置
    UILabel                      *_freeGuanLable;
    UILabel                      *_toGetherGuanLable;
    int                         freePassRadioIndex;
    int                          m_confusion_type;
    //标注滑动状态是在左边还是右边
    BOOL                         _isScrollerLeft;
    RuYiCaiAppDelegate          *m_delegate;
}
@property (nonatomic, retain)  NSMutableArray    *freePassRadioIndexArray;
@property (nonatomic, retain)  NSString          *chooseBetCode;
@property (nonatomic, retain)  UILabel           *freeGuanLable;
@property (nonatomic, retain)  UILabel           *toGetherGuanLable;
@property (nonatomic, retain)  UIView           *bottomView;
@property (nonatomic, retain)  JZ_CombineList   *duoChuanChooseArray;
@property (nonatomic, assign)  int             DanCount;
@property (nonatomic, assign)  int             betNumber;

@property (nonatomic, assign)  BOOL            isScrollerLeft;
@property (nonatomic, retain)  UIScrollView    *allUpScrollView;
@property (nonatomic, retain)  UITextField     *fieldBeishu;
@property (nonatomic, assign)  int             jzconfusionType;
@property (nonatomic, assign)  int             confusion_type;
@property (nonatomic, assign)  int             playTypeTag;
@property (nonatomic, assign)  int             numGameCount;
@property (nonatomic, assign)  int             twoCount;

@property (nonatomic, retain)  UITableView     *tableView;
@property (nonatomic, retain)  NSMutableArray  *deleteBaseArray;
@property (nonatomic, retain)  NSMutableArray  *dataBaseArray;
@property (nonatomic, retain) IBOutlet UIView    *jzNoteBgView;

@property (nonatomic, retain) IBOutlet UIScrollView    *bottomScrollView;
@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonHeMai;
@property (nonatomic, retain) IBOutlet UILabel  *totalCost;
@property (nonatomic, retain) IBOutlet UILabel  *zhuBeiLable;
@property (nonatomic, retain) IBOutlet UILabel  *bonusLable;

@property(nonatomic,retain)UIButton        *editeButton;

-(BOOL) changeClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState  ButtonIndex:(NSInteger)buttonIndex;

- (void)setDuoChuanPassScollView;
- (void)setFreePassScollView;
- (void)layoutBottomView;
- (void)changeBetNumber;
-(void) initAppendArrangePS;
-(void) appendArrangePS:(JZ_CombineBase*) PS;
-(void) sortSPArray;
//刷新注数，金额和预计奖金
- (void) refreshData;
//获得最小的奖金
-(float) getMinWinAmountByX:(NSInteger)X;
//计算复式过关的注数
- (NSInteger)getDuoChuanBetNum:(NSInteger)X  ChangShu:(NSInteger)Y;
- (void) calculationAmountBy_X_Y:(NSInteger)x Y:(NSInteger)y;
- (void) appendDuoChuanChoose:(NSString*)chooseCount IS_DAN:(BOOL)is_Dan CONFUSION:(NSArray*)confusion_array;

@end
