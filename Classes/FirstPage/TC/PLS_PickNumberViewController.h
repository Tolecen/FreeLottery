//
//  PLS_PickNumberViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickBallViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"
#import "CustomSegmentedControl.h"

@interface PLS_PickNumberViewController : UIViewController <UIAlertViewDelegate,CustomSegmentedControlDelegate> {
//    UIButton*                  m_backButton;

	UIScrollView               *m_scrollDirect;
//	UIScrollView               *m_scrollRandom;
    UIScrollView               *m_scrollGroup3;
    UIScrollView               *m_scrollGroup6;
	UISegmentedControl         *m_segmented;
    CustomSegmentedControl     *m_segmentedView;
    
    UIButton                   *m_topStatus;          //如：福彩3D，开奖日期：****
    
    PickBallViewController     *m_ballView1Direct;    //直选，个位
    PickBallViewController     *m_ballView10Direct;   //直选，十位
    PickBallViewController     *m_ballView100Direct;  //直选，百位
    NSInteger                  m_directType;
    UIButton                   *m_buttonDirectDirect;
    PickBallViewController     *m_ballViewDirectSum;
    UIButton                   *m_typeDirectSum;
    UILabel*                   m_directLabelBai;
    UILabel*                   m_directLabelShi;
    UILabel*                   m_directLabelGe;
    
//    UIButton                   *m_buttonRandomNum;    //机选，随机注数（按钮）
//    NSUInteger                  m_randomNum;          //机选，随机注数（具体值）
//    NSUInteger                  m_randomType;         //机选类型，0表示直选，1表示组3
//    UIButton                   *m_buttonRandomDirect; //机选，直选
//    UIButton                   *m_buttonRandomGroup3; //机选，组3
//    UITableView                *m_tableViewRandom;    //机选结果
//    NSMutableArray             *m_randomDataArray;
    
    UIButton                   *m_typeGroup3Sum;
    UILabel                    *m_label1Single;
    UILabel                    *m_label2Single;
    UILabel                    *m_labelDoubleGroup3;
    UIButton                   *m_buttonSingleGroup;  //组3，单式
    UIButton                   *m_buttonDoubleGroup;  //组3，复式
    PickBallViewController     *m_ballView1Single;
    PickBallViewController     *m_ballView2Single;
    PickBallViewController     *m_ballViewDoubleGroup3;
    PickBallViewController     *m_ballViewGroup3Sum;
    
    NSUInteger                  m_group3Type;
    
    PickBallViewController     *m_ballViewGroup6;
    
    UIButton                   *m_typeGroup6Sum;
    UIButton                   *m_typeDirectGroup6;
    PickBallViewController     *m_ballViewGroup6Sum;
    NSInteger                  m_group6Type;
    UILabel                    *m_labelGroup6;
    
    UIButton                   *m_buttonBuy;          //立即投注
    UIButton                   *m_buttonReselect;     //重新选择
    
    UILabel                    *m_totalCost;          //共x注共x元
    
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
    
    NSString*                   m_lastBatchCode;
    NSTimer*                    m_timer;
    UIScrollView               *m_bottomScrollView;
    BOOL                        *m_isHidePush;
    

}
@property (nonatomic, assign) BOOL          *isHidePush;

@property (nonatomic, retain) IBOutlet UIButton *topStatus;
@property (nonatomic, retain) IBOutlet   UIScrollView *bottomScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollDirect;
//@property (nonatomic, retain) IBOutlet UIScrollView *scrollRandom;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollGroup3;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollGroup6;
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