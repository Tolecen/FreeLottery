//
//  JC_BetView.h
//  RuYiCai
//
//  Created by ruyicai on 12-5-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
/*
 ----------------竞彩 投注页面-------------------
 */


#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"

@class CombineList;
@class CombineBase;
@class AnimationTabView;
@class LaunchHMViewController;
@class JC_LaunchHMViewController_copy;

//竞彩篮球  胜分差 只有 4串 以内的
//竞彩足球    比分    只有 4串 以内的
//竞彩足球    半全场  只有 4串 以内的
//竞彩足球    总进球  只有 6串 以内的

typedef enum confusionType
{
    JC_confusion_BASE = 0,
    JCLQ_SFC = 1,  //竞彩篮球胜分差
    JCZQ_SCORE = 2,//竞彩足球比分
    JCZQ_HALF = 3, //竞彩足球半全场
    JCZQ_ZJQ = 4,  //竞彩足球半全场
}type;

@interface JC_BetView : UIViewController<UIScrollViewDelegate, UITextFieldDelegate,CustomSegmentedControlDelegate> {
    double                      m_allCount;
    int                         m_gameCount;
    int                         m_twoCount;//胜负都选的比赛个数
    int                         m_betNumber;
    
    NSString                    *m_chooseBetCode;
    
    BOOL                        m_isFreePassButton;
    UIButton                    *m_FreePassButton; //自由过关
    UIButton                    *m_DuoChuanPassButton;//多穿过关
    
    UIScrollView                *m_freePassScollView;
    int                         freePassRadioIndex;
    NSMutableArray*             freePassRadioIndexArray;
    
    UIScrollView                *m_DuoChuanPassScollView;
    int                         duoChuanPassRadioIndex;
    NSMutableArray              *m_duoChuanPassRadioArray;
    int                         m_DanCount;
    
    int                         m_playTypeTag;//玩法
    
    BOOL                        m_isDanGuan;
    CombineList                 *m_duoChuanChooseArray;//存放 每场比赛的选择count ,例如 只有主胜 或 负 则为1  依次递增
    int                         duochuanScrollViewOffset_Y;
    
    CombineList                 *m_Com_SParray;//所有的 赔率
    CombineList                 *m_Com_arrangeSP_Min;//排列之后的 赔率（最小的）
    CombineList                 *m_Com_arrangeSP_Max;//排列之后的 赔率（最da的）
    
    double                         m_minWinAmount;//最小奖金
    double                         m_maxWinAmount;
    
    double                        m_minAmount_Confusion;//混合过关的最小奖金
    double                        m_maxAmount_Confusion;//混合过关的最大奖金
    
    /*
     奖金计算：
     最小奖金：
     一注赔率最小的组合
     
     最大奖金：（一场球 只能有一个赔率 有效)
     只需要 找出每场球的最大的赔率
     然后 根据这些赔率组成，算出可能的注数 相加
     */
    JC_LaunchHMViewController_copy*       m_LaunchHMView;
    
    NSMutableArray*              m_tempConfusionArray;//存放临时数据
    int                          m_confusion_type;
    
    
    int                          m_betCodeListHeight;
    BOOL                         m_expandBetCode;
    UIImageView*                  m_image_top;
    UIImageView*                  m_image_bottom;
    UILabel*                      m_guoguanFangshLabel;
    
    NSTimer                       *m_timer;
    
    NSMutableArray                *m_eventChooseGameArray;//保持每场比赛的Event
    NSString                      *m_userChooseGameEvent;//存储Event的关键字
    
    int                            m_jc_type;//竞彩的类型  0  竞彩足球；1  竞彩篮球
    CustomSegmentedControl      *m_cusSegmented;
    
}
@property (nonatomic, retain) NSDictionary     *getShareDetileDic;
@property (nonatomic, retain) CustomSegmentedControl *cusSegmented;
@property (nonatomic,assign) int confusion_type;
@property (nonatomic, retain) IBOutlet UIScrollView* srollView_normalBet;
@property (nonatomic, retain) IBOutlet UIScrollView* srollView_HMBet;
@property (nonatomic, retain) AnimationTabView*   animationTabView;
@property (nonatomic, retain) JC_LaunchHMViewController_copy*       LaunchHMView;
@property (nonatomic, retain) IBOutlet UIButton*  buyButton;
@property (nonatomic, retain) IBOutlet UIView* view_down;
@property (nonatomic, retain) IBOutlet UIImageView *image_sanjiao;

@property (nonatomic,assign) BOOL isDanGuan;
@property (nonatomic,retain) CombineList *duoChuanChooseArray;

@property (nonatomic,retain) CombineList *arrangeSP_Min;
@property (nonatomic,retain) CombineList *arrangeSP_Max;
@property (nonatomic,assign) double allCount;
@property (nonatomic,assign) int gameCount;
@property (nonatomic,assign) int twoCount;
@property (nonatomic,assign) int betNumber;

@property (nonatomic, assign) int playTypeTag;

@property (nonatomic, retain) NSString *chooseBetCode;

@property (nonatomic, retain) UIScrollView *freePassScollView;
@property (nonatomic, retain) UIScrollView *DuoChuanPassScollView;

@property (nonatomic, retain) IBOutlet UILabel *lotTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *allCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *gameCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *betNumberLable;

@property (nonatomic, retain) IBOutlet UIButton *betCodeList;

@property (nonatomic, retain) IBOutlet UIButton *jianBeishuButton;
@property (nonatomic, retain) IBOutlet UIButton *jiaBeishuButton;

@property (nonatomic, retain) IBOutlet UITextField *fieldBeishu;
@property (nonatomic, retain) IBOutlet UILabel *winAmount;
@property (nonatomic, retain) NSMutableArray *eventChooseGameArray;

@property (nonatomic, retain) NSString *userChooseGameEvent;

@property (nonatomic, assign) int jc_type;

-(void) appendArrangePS:(CombineBase*) PS;
-(void) sortSPArray;


- (IBAction)betCodeClick:(id)sender;
- (IBAction)buyClick:(id)sender;

- (void)betCompleteOK:(NSNotification*)notification;

- (void)back:(id)sender;
- (void)buildBetCode;
- (void)wapPageBuild;
- (void)appendDuoChuanChoose:(NSString*)chooseCount IS_DAN:(BOOL)is_Dan CONFUSION:(NSArray*)confusion_array;

- (NSMutableArray *) getOneGameSPArray:(CombineBase *)base;
- (void) calculationWinAmountForConfusion:(int) y;

@end

/*
 X串Y
 */
@class CombineList;
@interface CombineListArray : NSObject {
    NSMutableArray                          *m_combineListArray;//存放的从N场比赛选出来X场的 比赛组合
}
@property (nonatomic,retain) NSMutableArray* combineListArray;
-(void) appendListArray:(CombineList*) listArray;
@end
@class CombineBase;
@interface CombineList : NSObject {
    NSMutableArray                          *m_combineList; //存放的每个X
}
@property (nonatomic,retain) NSMutableArray* combineList;
-(void) appendList:(CombineBase*) list;
@end
@interface CombineBase : NSObject {
    NSMutableArray                          *m_combineBase_SP;//每场比赛
    NSMutableArray                          *m_combineBase_SP_confusion;//内存四个数组，分别代表混合过关的四种玩法
    BOOL                                    m_isDan;
    int                                     m_gameCount;//每场比赛的选择count
}
@property (nonatomic,retain) NSMutableArray* combineBase_SP;
@property (nonatomic,retain) NSMutableArray* combineBase_SP_confusion;

@property (nonatomic,assign) BOOL isDan;
@property (nonatomic,assign) NSInteger gameCount;


@end

void combine( int a[], int n, int m,  int b[], const int M,CombineListArray *ListArraybase,CombineList* data);//函数 范围--二次修改

void combine_List( int a[], int n, int m,  int b[], const int M,CombineList *listbase,CombineList* data);//在n个数中选取m ---三次修改

void combine_SP(float a[], int n, int m, int b[], const int M ,CombineListArray *ListArraybase,CombineList* data);
void combine_SP_List(float a[], int n, int m, int b[], const int M ,CombineList *listbase,CombineList* data);

//void combine_SP_confusion(float (*result)[100],float  (*data)[100] ,int curr,int count);

void combine_SP_confusion(NSMutableArray* result,NSArray* data,int curr,int count,NSMutableArray* temp_baseArray);

NSMutableArray*                     m_tempBase_stringArray;//存放临时的下标值

//void show(char* result,const char** data, int curr,int count);
