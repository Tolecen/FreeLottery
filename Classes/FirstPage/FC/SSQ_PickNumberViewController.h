//
//  SSQ_PickNumberViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickBallViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "CustomSegmentedControl.h"

@class RandomNumViewController;
@interface SSQ_PickNumberViewController : UIViewController <UIScrollViewDelegate ,UIAlertViewDelegate,CustomSegmentedControlDelegate> {
//    UIButton*                  m_backButton;

	UIScrollView               *m_scrollDirect;
//	UIScrollView               *m_scrollRandom;
    UIScrollView               *m_scrollDrag;
	UISegmentedControl         *m_segmented;
    CustomSegmentedControl     *m_segmentedView;
    
    UIButton                   *m_topStatus;          //如：双色球直选，开奖日期：****
    
    PickBallViewController     *m_redBallViewDirect;  //直选，红球区
    RandomNumViewController    *m_randomNumView_red;
    PickBallViewController     *m_blueBallViewDirect; //直选，蓝球区
    RandomNumViewController    *m_randomNumView_blue;
    
    PickBallViewController     *m_yiLouRedBallViewDirect;  //直选，遗漏红球区
    RandomNumViewController    *m_randomNumView_yiLou_red;
    PickBallViewController     *m_yiLouBlueBallViewDirect; //直选，遗漏蓝球区
    RandomNumViewController    *m_randomNumView_yiLou_blue;       
    
    PickBallViewController     *m_danmaBallViewDrag;  //胆拖，胆码区
    RandomNumViewController    *m_randomNumDanTuoView_dan;
    
    PickBallViewController     *m_tuomaBallViewDrag;  //胆拖，拖码区
    RandomNumViewController    *m_randomNumDanTuoView_tuo;
    
    PickBallViewController     *m_blueBallViewDrag;   //胆拖，蓝球区
    RandomNumViewController    *m_randomNumDanTuoView_blue;
    
    UIButton                   *m_buttonBuy;          //立即投注
    UIButton                   *m_buttonReselect;     //重新选择
    
    UILabel                    *m_totalCost;          //共x注共x元
    UILabel                    *alreaderLabel;
    int                         m_numZhu;             //期数
    int                         m_numCost;            //投注金额
    
    NSString*                   m_batchCode;
    NSString*                   m_batchEndTime;
    RuYiCaiAppDelegate         *m_delegate;
    
    UILabel                    *m_str1Label;
    UILabel                    *m_str2Label;
    
    BOOL                       isMoreBet;
    UIScrollView               *m_bottomScrollView;
    UIButton                   *m_addBasketButton;
    UIButton                   *m_basketButton;
    UILabel                    *m_basketNum;
    NSInteger                   m_allZhuShu;

    UIView                     *m_detailView;
//    UIButton                   *m_detailButton;
    UIImageView*                m_recordPickPageImag;
    NSString*                   m_lastBatchCode;
    NSTimer*                    m_timer;
    UIButton                    *m_cleanButton;
    BOOL                        *m_isHidePush;
}

@property (nonatomic, retain) IBOutlet UIButton *topStatus;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollDirect;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDrag;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmented;
@property (nonatomic, retain) CustomSegmentedControl     *segmentedView;
@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonReselect;
@property (nonatomic, retain) IBOutlet UIButton *cleanButton;

@property (nonatomic, retain) PickBallViewController *redBallViewDirect;
@property (nonatomic, retain) PickBallViewController *blueBallViewDirect;
@property (nonatomic, retain) PickBallViewController *yiLouRedBallViewDirect;
@property (nonatomic, retain) PickBallViewController *yiLouBlueBallViewDirect;


@property (nonatomic, retain) PickBallViewController *danmaBallViewDrag;
@property (nonatomic, retain) PickBallViewController *tuomaBallViewDrag;
@property (nonatomic, retain) PickBallViewController *blueBallViewDrag;

@property (nonatomic, retain) IBOutlet UILabel *totalCost;

@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* batchEndTime;
@property (nonatomic, retain) UILabel   *str1Label;
@property (nonatomic, retain) UILabel   *str2Label;
@property (nonatomic, retain) NSString*  lastBatchCode;

@property (nonatomic, retain) IBOutlet   UIScrollView *bottomScrollView;
@property (nonatomic, retain) IBOutlet   UIButton   *addBasketButton;
@property (nonatomic, retain) IBOutlet   UIButton   *basketButton;
@property (nonatomic, retain) IBOutlet   UILabel    *basketNum;
@property (nonatomic, assign) BOOL          *isHidePush;

@end
