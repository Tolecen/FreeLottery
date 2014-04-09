//
//  KLSF_PickNumberViewController.h
//  RuYiCai
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//  重庆快乐十分

#import <UIKit/UIKit.h>

#import "PickBallViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"
#import "CustomSegmentedControl.h"

@interface CQSF_PickNumberViewController : UIViewController<RandomPickerDelegate, UIAlertViewDelegate,CustomSegmentedControlDelegate>
{
//    UIButton*                  m_backButton;

    UIScrollView               *m_scrollDirect;
	UIScrollView               *m_scrollRandom;
	UISegmentedControl         *m_segmented;
    CustomSegmentedControl     *m_segmentedView;
	    
    PickBallViewController     *m_ballViewOneDirect;//任选一球
    PickBallViewController     *m_ballViewRedDirect;//选一红球
    
    PickBallViewController     *m_ballViewDirect;  //直选，红球区 万位
	PickBallViewController     *m_ballViewDirect1000;
	PickBallViewController     *m_ballViewDirect100;
	UIButton                   *m_buttonPlayType;
	NSInteger                  m_playType;
	UILabel                    *m_selectedCount;
	UILabel                    *m_wanLable;
	UILabel                    *m_qianLable;
	UILabel                    *m_baiLable;
    
    UIButton                   *m_buttonBuy;          //立即投注
    UIButton                   *m_buttonReselect;     //重新选择
    
    UILabel                    *m_totalCost;          //共x注共x元
    UILabel                    *alreaderLabel;
    
    int                         m_numZhu;             //期数
    int                         m_numCost;            //投注金额
    
    NSString*                   m_batchCode;
    NSString*                   m_batchEndTime;
    RuYiCaiAppDelegate         *m_delegate;
	
	NSTimer*                    m_timer;
	UILabel                    *m_batchCodeLabel;
	UILabel                    *m_leftTimeLabel;  
    
//    NSMutableArray             *m_recoderYiLuoDateArr;//遗漏值存储：下标0任选2~8，1前选直，2组选2，3组选3
    
    //胆拖
    UIScrollView               *m_scrollDrag;
    PickBallViewController     *m_ballViewDan;  //胆码
	PickBallViewController     *m_ballViewTuo;  //拖码
    UIButton                   *m_dragPlayType;
    NSInteger                  drag_PlayType;
    UILabel                    *m_danLabel;
    UILabel                    *m_tuoLabel;
    
    BOOL                       oneRefreshDragYiLuo;//第一次seg进去胆拖，刷新遗漏值；每次进去都刷，若没有遗漏值则会导致机器卡住
    
    BOOL                       isMoreBet;
    UIButton                   *m_addBasketButton;
    UIButton                   *m_basketButton;
    UILabel                    *m_basketNum;
    NSInteger                   m_allZhuShu;
    
    UIView                     *m_detailView;
//    UIButton                   *m_detailButton;
    
    /*
     中奖 描述
     */
    UILabel*                    m_winDescribtionLable;//描述
    UILabel*                    m_winMonneyLable;//奖金
    
    UILabel*                    m_winDescribtionLable_dan;//描述
    UILabel*                    m_winMonneyLable_dan;//奖金
    UIScrollView               *m_bottomScrollView;
    
}
@property (nonatomic, retain) IBOutlet   UIScrollView *bottomScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDirect;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmented;
@property (nonatomic, retain) CustomSegmentedControl *segmentedView;
@property (nonatomic, retain) IBOutlet UIButton *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton *buttonReselect;

@property (nonatomic, retain) PickBallViewController *ballViewOneDirect;
@property (nonatomic, retain) PickBallViewController *ballViewRedDirect;
@property (nonatomic, retain) PickBallViewController *ballViewDirect;
@property (nonatomic, retain) PickBallViewController *ballViewDirect1000;
@property (nonatomic, retain) PickBallViewController *ballViewDirect100;
@property (nonatomic, retain) UIButton *buttonPlayType;

@property (nonatomic, retain) IBOutlet UILabel *totalCost;

@property (nonatomic, retain) NSString* batchCode;
@property (nonatomic, retain) NSString* batchEndTime;

@property (nonatomic, retain) IBOutlet UIScrollView               *scrollDrag;
@property (nonatomic, retain) PickBallViewController     *ballViewDan;  //胆码
@property (nonatomic, retain) PickBallViewController     *ballViewTuo;  //拖码
@property (nonatomic, retain) UIButton*                   dragPlayType;

@property (nonatomic, retain) IBOutlet   UIButton   *addBasketButton;
@property (nonatomic, retain) IBOutlet   UIButton   *basketButton;
@property (nonatomic, retain) IBOutlet   UILabel    *basketNum;

@end
