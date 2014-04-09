//
//  QLC_PickNumberViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickBallViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"
#import "CustomSegmentedControl.h"

@class RandomNumViewController;

@interface QLC_PickNumberViewController : UIViewController <UIAlertViewDelegate,CustomSegmentedControlDelegate> {
//    UIButton*                  m_backButton;

	UIScrollView               *m_scrollDirect;
	UIScrollView               *m_scrollDrag;
	UISegmentedControl         *m_segmented;
    CustomSegmentedControl     *m_segmentedView;
    
    UIButton                   *m_topStatus;          //如：七乐彩直选，开奖日期：****

    PickBallViewController     *m_redBallViewDirect;  //直选，红球区
    RandomNumViewController    *m_randomNumView_red;

//    UIButton                   *m_buttonRandomNum;    //机选，随机注数（按钮）
//    NSUInteger                  m_randomNum;          //机选，随机注数（具体值）
//    UITableView                *m_randomTableView;    //机选结果
//    NSMutableArray             *m_randomDataArray;
    
    //胆拖
    PickBallViewController     *m_redDanBallViewDrag;   //胆码区
    RandomNumViewController    *m_randomNumView_redDan;   
    PickBallViewController     *m_redTuoBallViewDrag;   //拖码区
    RandomNumViewController    *m_randomNumView_redTuo;   
    
 
    
    UIButton                   *m_buttonBuy;          //立即投注
    UIButton                   *m_buttonReselect;     //重新选择
    
    UILabel                    *m_totalCost;          //共x注共x元
    UILabel                    *m_selectedRedBalls;   //已选：xx,xx(红球)
    UILabel                    *m_selectedBlueBalls;  //,xx(蓝球)
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
    
    NSString*                   m_lastBatchCode;
    NSTimer*                    m_timer;
    UIScrollView               *m_bottomScrollView;
    UILabel                    *alreaderLabel;
    BOOL                        *m_isHidePush;
    
}
@property (nonatomic, assign) BOOL          *isHidePush;

@property (nonatomic, retain) IBOutlet   UIScrollView *bottomScrollView;
@property (nonatomic, retain) IBOutlet UIButton *topStatus;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollDirect;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDrag;
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
