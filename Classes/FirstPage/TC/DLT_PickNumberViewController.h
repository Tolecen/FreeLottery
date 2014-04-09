//
//  DLT_PickNumberViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-8-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickBallViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"
#import "CustomSegmentedControl.h"

@class RandomNumViewController;

@interface DLT_PickNumberViewController : UIViewController < UIAlertViewDelegate, UIScrollViewDelegate, CustomSegmentedControlDelegate> {
//    UIButton*                  m_backButton;
    
	UIScrollView               *m_scrollDirect;
	UIScrollView               *m_scrollDrag;
    UIScrollView               *m_scroll12X2;
	UISegmentedControl         *m_segmented;
    CustomSegmentedControl     *m_segmentedView;
    
    UIButton                   *m_topStatus;          //如：大乐透直选，开奖日期：****
    
    PickBallViewController     *m_redBallViewDirect;  //直选，红球区
    PickBallViewController     *m_blueBallViewDirect; //直选，蓝球区
   
    RandomNumViewController    *m_randomNumView_red;
    RandomNumViewController    *m_randomNumView_blue;
    //胆拖
    PickBallViewController     *m_redDanBallViewDrag;  //  红球区 胆码
    PickBallViewController     *m_redTuoBallViewDrag; //   红球区 拖码
    PickBallViewController     *m_blueDanBallViewDrag;  //  蓝球区 胆码
    PickBallViewController     *m_blueTuoBallViewDrag; //   蓝球区 拖码
 
    RandomNumViewController    *m_randomNumView_redDan;
    RandomNumViewController    *m_randomNumView_redTuo;
    RandomNumViewController    *m_randomNumView_blueDan;
    RandomNumViewController    *m_randomNumView_blueTuo;
    
    PickBallViewController     *m_yiLouRedBallViewDirect;  //直选，遗漏红球区
    RandomNumViewController    *m_randomNumView_yiLou_red;
    PickBallViewController     *m_yiLouBlueBallViewDirect; //直选，遗漏蓝球区
    RandomNumViewController    *m_randomNumView_yiLou_blue;
 
    PickBallViewController     *m_12X2BallView;

    UIButton                   *m_buttonBuy;          //立即投注
    UIButton                   *m_buttonReselect;     //重新选择
    
    UILabel                    *m_totalCost;          //共x注共x元
    UILabel                    *m_selectedRedBalls;   //已选：xx,xx(红球)
    UILabel                    *m_selectedBlueBalls;  //,xx(蓝球)
    
    UILabel                    *alreaderLabel;
    int                         m_numZhu;             //期数
    int                         m_numCost;            //投注金额
    
    NSString*                   m_batchCode;
    NSString*                   m_batchEndTime;
    UILabel                    *m_str1Label;
    UILabel                    *m_str2Label;
    
    RuYiCaiAppDelegate         *m_delegate;
    
    BOOL                       isMoreBet;
    UIButton                   *m_addBasketButton;
    UIButton                   *m_basketButton;
    UILabel                    *m_basketNum;
    NSInteger                   m_allZhuShu;

    UIView                     *m_detailView;
//    UIButton                   *m_detailButton;
    
    UIImageView*                m_recordPickPageImag;

    NSString*                   m_lastBatchCode;
    NSTimer*                    m_timer;
    UIScrollView               *m_bottomScrollView;
    BOOL                        *m_isHidePush;
    
    
}
@property (nonatomic, assign) BOOL          *isHidePush;

@property (nonatomic, retain) IBOutlet UIButton *topStatus;
@property (nonatomic, retain) IBOutlet   UIScrollView *bottomScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDirect;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDrag;
@property (nonatomic, retain) IBOutlet UIScrollView *scroll12X2;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmented;
@property (nonatomic, retain) CustomSegmentedControl *segmentedView;
@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonReselect;
@property (nonatomic, retain) IBOutlet UILabel *totalCost;

@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* batchEndTime;
@property (nonatomic, retain) UILabel   *str1Label;
@property (nonatomic, retain) UILabel   *str2Label;
@property (nonatomic, retain) NSString*  lastBatchCode;

@property (nonatomic, retain) IBOutlet   UIButton   *addBasketButton;
@property (nonatomic, retain) IBOutlet   UIButton   *basketButton;
@property (nonatomic, retain) IBOutlet   UILabel    *basketNum;
@end
