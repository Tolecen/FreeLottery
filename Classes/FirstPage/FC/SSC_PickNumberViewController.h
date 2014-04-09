//
//  SSC_PickNumberViewController.h
//  RuYiCai
//
//  Created by haojie on 11-10-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PickBallViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"
#import "CustomSegmentedControl.h"

@interface SSC_PickNumberViewController : UIViewController<CustomSegmentedControlDelegate> {
    //    UIButton*                  m_backButton;
    
	UIScrollView               *m_scroll1xing;
	UIScrollView               *m_scroll2xing;
	UIScrollView               *m_scroll3xing;
	UIScrollView               *m_scroll5xing;
	UIScrollView               *m_scrollDxds;
	CustomSegmentedControl     *m_segmentedView;
	
	//1星
	PickBallViewController     *m_ballView1Direct;    //直选，个位
    
	//2星
	NSInteger                  m_type2x;//模式标记，直选，机选..
	PickBallViewController     *m_ballView2x1;
	PickBallViewController     *m_ballView2x10;
	PickBallViewController     *m_ballView2xSum;
	UILabel                    *m_label2x1;
	UILabel                    *m_label2x10;
	UIButton                   *m_directButton2x;
	UIButton                   *m_zuButton2x;
	UIButton                   *m_sumButton2x;
    
	//3星
	NSInteger                  m_type3x;//模式标记，直选，机选..
	PickBallViewController     *m_ballView3x1;
	PickBallViewController     *m_ballView3x10;
	PickBallViewController     *m_ballView3x100;
    UIScrollView*              m_3XingZuScroll;
    PickBallViewController     *m_ballView3xZu;
    UIButton                   *m_directButton3x;
	UIButton                   *m_zu3Button3x;
	UIButton                   *m_zu6Button3x;
    
	//5星
	NSInteger                  m_type5x;//模式标记，直选，机选..
	PickBallViewController     *m_ballView5x1;
	PickBallViewController     *m_ballView5x10;
	PickBallViewController     *m_ballView5x100;
	PickBallViewController     *m_ballView5x1000;
	PickBallViewController     *m_ballView5x10000;
	UIButton                   *m_directButton5x;
	UIButton                   *m_tongButton5x;
	
	//大小双单
	NSInteger                  m_typeDxds;//模式标记，直选，机选..
	PickBallViewController     *m_ballViewDxds1;
	PickBallViewController     *m_ballViewDxds10;
    
	UIButton                   *m_buttonBuy;          //立即投注
	UIButton                   *m_buttonReselect;     //重新选择
	
	UILabel                    *m_totalCost;          //共x注共x元
    
	int                         m_numZhu;             //期数
	int                         m_numCost;            //投注金额
	
	NSString*                   m_batchCode;
	NSString*                   m_batchEndTime;
	
	RuYiCaiAppDelegate         *m_delegate;
	
	NSTimer*                    m_timer;
	UILabel                    *m_batchCodeLabel;
	UILabel                    *m_leftTimeLabel;
    
    NSMutableArray             *m_recoderYiLuoDateArr;//遗漏值存储：下标0表示1星……;1表示大小单双；
    //2代表2星组选； 3代表2星和值
    BOOL                       isMoreBet;
    UIButton                   *m_addBasketButton;
    UIButton                   *m_basketButton;
    UILabel                    *m_basketNum;
    NSInteger                   m_allZhuShu;
    
    UIView                     *m_detailView;
    
    UIButton*                  m_refreshButton;
    
    /*
     中奖 描述
     */
    UILabel*                    m_winDescribtionLable_X1;//描述
    UILabel*                    m_winMonneyLable_X1;//奖金
    
    UILabel*                    m_winDescribtionLable_X2;//描述
    UILabel*                    m_winMonneyLable_X2;//奖金
    
    UILabel*                    m_winDescribtionLable_X3;//描述
    UILabel*                    m_winMonneyLable_X3;//奖金
    
    UILabel*                    m_winDescribtionLable_X5;//描述
    UILabel*                    m_winMonneyLable_X5;//奖金
    
    UILabel*                    m_winDescribtionLable_Dxds;//描述
    UILabel*                    m_winMonneyLable_Dxds;//奖金
    
    
    UILabel*                    m_lastBatchCodeLabel;//上期开奖
    UILabel*                    m_winRedNumLabel;
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scroll1xing;
@property (nonatomic, retain) IBOutlet UIScrollView *scroll2xing;
@property (nonatomic, retain) IBOutlet UIScrollView *scroll3xing;
@property (nonatomic, retain) IBOutlet UIScrollView *scroll5xing;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDxds;
@property (nonatomic, retain) CustomSegmentedControl *segmentedView;

@property (nonatomic, retain) PickBallViewController     *ballView1Direct;

@property (nonatomic, retain) PickBallViewController     *ballView2x1;
@property (nonatomic, retain) PickBallViewController     *ballView2x10;
@property (nonatomic, retain) PickBallViewController     *ballView2xSum;

@property (nonatomic, retain) PickBallViewController     *ballView3x1;
@property (nonatomic, retain) PickBallViewController     *ballView3x10;
@property (nonatomic, retain) PickBallViewController     *ballView3x100;

@property (nonatomic, retain) PickBallViewController     *ballView5x1;
@property (nonatomic, retain) PickBallViewController     *ballView5x10;
@property (nonatomic, retain) PickBallViewController     *ballView5x100;
@property (nonatomic, retain) PickBallViewController     *ballView5x1000;
@property (nonatomic, retain) PickBallViewController     *ballView5x10000;

@property (nonatomic, retain) PickBallViewController     *ballViewDxds1;
@property (nonatomic, retain) PickBallViewController     *ballViewDxds10;

@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonReselect;

@property (nonatomic, retain) IBOutlet UILabel *totalCost;

@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* batchEndTime;
@property (nonatomic, retain) NSMutableArray  *recoderYiLuoDateArr;

@property (nonatomic, retain) IBOutlet   UIButton   *addBasketButton;
@property (nonatomic, retain) IBOutlet   UIButton   *basketButton;
@property (nonatomic, retain) IBOutlet   UILabel    *basketNum;
@end
