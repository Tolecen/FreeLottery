//
//  NMKS_PickNumberViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-2-16.
//
//

#import <UIKit/UIKit.h>
#import "PickBallViewController.h"
#import "CustomSegmentedControl.h"
#import "RuYiCaiAppDelegate.h"

//@class AnimationTabView;
@interface NMKS_PickNumberViewController : UIViewController<CustomSegmentedControlDelegate>
{

    UIScrollView               *m_scrollSum;
	UIScrollView               *m_scroll3Same;
	UIScrollView               *m_scroll2Same;
	UIScrollView               *m_scrollNoSame;
	UIScrollView               *m_scroll3Connected;
    CustomSegmentedControl     *m_segmentedView;
    UIView*                    m_showSelectBallWarnView;
    UILabel*                   m_selectBallWarnLabel;
    
    PickBallViewController*    m_ballViewSum;//和值
    NSMutableArray             *m_ballState;
    
    RuYiCaiAppDelegate         *m_delegate;
    
    UIButton*                  m_tongButton3Same;
    UIButton*                  m_danButton3Same;
    UILabel                    *m_3SameExplain;
    UIButton*                  m_3SameTongXuan;//三同号同选
    UILabel*                   m_3SameTongXuanYiLou;//三同号遗漏
    UIButton*                  m_3SameDanXuan[6];//三同号单选
    UILabel*                   m_3SameDanXuanYiLou[6];//三同号单选遗漏
    
    UIButton*                  m_fuButton2Same;
    UIButton*                  m_danButton2Same;
    UILabel                    *m_2SameExplain;
    UIButton*                  m_2SameFuXuan[6];//二同号复选
    UILabel*                   m_2SameFuXuanYiLou[6];//二同号复选遗漏
    UIButton*                  m_2SameDanXuan[12];//二同号单选
    UILabel*                  m_2SameDanXuanYiLou[12];//二同号单选遗漏
    UIScrollView*              m_2sameDanXuanScroll;
    
    UIButton*                  m_select3NoSame;
    UIButton*                  m_select2NoSame;
    UILabel                    *m_noSameExplainLabel;
    UIButton*                  m_noSameButtonArray[6];//不同号
    UILabel*                  m_noSameYiLou[6];//不同号 遗漏
    
    UIButton*                  m_3ConnectedButton;
    UILabel*                  m_3ConnectedYiLou;//三连号遗漏
    
    UIButton                   *m_buttonBuy;          //立即投注
	UIButton                   *m_buttonReselect;     //重新选择
	
	UILabel                    *m_totalCost;          //共x注共x元
    
	int                         m_numZhu;             //注数
	int                         m_numCost;            //投注金额
    int                         m_randomNumber; //3同号随即选择注数
	int                         m_2SameRandomNumber; //2同号复选随即选择注数
    int                         m_2SameDanRandomNumber; //2同号单选选随即选择注数
    int                         m_2SameDanRandomNext; //2同号单选选随即选择注数
    //不同号选择三不通的三个号码变化
    int                         m_3NoSameRandomNum1; //3不同号单选选随即选择注数
    int                         m_3NoSameRandomNum2; //3不同号单选选随即选择注数
    int                         m_3NoSameRandomNum3; //3不同号单选选随即选择注数
     //不同号选择三不通的两个号码变化
    
    int                         m_2NoSameRandomNum1; //2不同号单选选随即选择注数
    int                         m_2NoSameRandomNum2; //2不同号单选选随即选择注数
    
	NSString*                   m_batchCode;
	NSString*                   m_batchEndTime;
		
	NSTimer*                    m_timer;
	UILabel                    *m_batchCodeLabel;
	UILabel                    *m_leftTimeLabel;
    
    BOOL                       isMoreBet;
    UIButton                   *m_addBasketButton;
    UIButton                   *m_basketButton;
    UILabel                    *m_basketNum;
    NSInteger                   m_allZhuShu;//多注投总注数
    
    UIView                     *m_detailView;
    UIButton*                  m_refreshButton;
    
    UILabel*                    m_lastBatchCodeLabel;//上期开奖
    UILabel*                    m_winRedNumLabel;
    UILabel                    *alreaderLabel;
    UIScrollView               *m_bottomScrollView;
}

@property (nonatomic, retain) IBOutlet UIScrollView*          scrollSum;
@property (nonatomic, retain) IBOutlet UIScrollView*          scroll3Same;
@property (nonatomic, retain) IBOutlet UIScrollView*          scroll2Same;
@property (nonatomic, retain) IBOutlet UIScrollView*          scrollNoSame;
@property (nonatomic, retain) IBOutlet UIScrollView*          scroll3Connected;
@property (nonatomic, retain) PickBallViewController*         ballViewSum;
@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonReselect;

@property (nonatomic, retain) IBOutlet UILabel *totalCost;
@property (nonatomic, retain) CustomSegmentedControl     *segmentedView;
@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* batchEndTime;
//@property (nonatomic, retain) NSMutableArray  *recoderYiLuoDateArr;

@property (nonatomic, retain) IBOutlet   UIButton   *addBasketButton;
@property (nonatomic, retain) IBOutlet   UIButton   *basketButton;
@property (nonatomic, retain) IBOutlet   UILabel    *basketNum;
@property (nonatomic, retain) IBOutlet   UIScrollView *bottomScrollView;

@end
