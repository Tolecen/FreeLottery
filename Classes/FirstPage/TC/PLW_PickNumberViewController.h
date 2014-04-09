//
//  PLW_PickNumberViewController.h
//  RuYiCai
//
//  Created by haojie on 11-12-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickBallViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RandomPickerViewController.h"
#import "CustomSegmentedControl.h"

@interface PLW_PickNumberViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, RandomPickerDelegate,UIAlertViewDelegate,CustomSegmentedControlDelegate>
{
//    UIButton*                  m_backButton;

	UIScrollView               *m_scrollDirect;
	UIScrollView               *m_scrollRandom;
	UISegmentedControl         *m_segmented;
    CustomSegmentedControl     *m_segmentedView;
	
	PickBallViewController     *m_ballView1;
	PickBallViewController     *m_ballView10;
	PickBallViewController     *m_ballView100;
	PickBallViewController     *m_ballView1000;
	PickBallViewController     *m_ballView10000;
	
	UITableView                *m_tableViewRandom;
	UIButton                   *m_buttonRandomNum;
    NSUInteger                  m_randomNum;  
	NSMutableArray             *m_randomDataArray;
	
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
   UIScrollView                *m_bottomScrollView;
    BOOL                       *m_isHidePush;
    
}
@property (nonatomic, assign) BOOL          *isHidePush;

@property (nonatomic, retain) IBOutlet   UIScrollView *bottomScrollView;
@property (nonatomic, retain)IBOutlet UIScrollView *scrollDirect;
@property (nonatomic, retain)IBOutlet UIScrollView *scrollRandom;
@property(nonatomic, retain)IBOutlet UISegmentedControl   *segmented;
@property(nonatomic, retain)CustomSegmentedControl        *segmentedView;
@property(nonatomic, retain)PickBallViewController        *ballView1;
@property(nonatomic, retain)PickBallViewController        *ballView10;
@property(nonatomic, retain)PickBallViewController        *ballView100;
@property(nonatomic, retain)PickBallViewController        *ballView1000;
@property(nonatomic, retain)PickBallViewController        *ballView10000;
@property(nonatomic, retain)UITableView                   *tableViewRandom;
@property(nonatomic, retain)UIButton                      *buttonRandomNum;
@property(nonatomic, retain)NSMutableArray                *randomDataArray;    
@property(nonatomic, retain)IBOutlet UIButton             *buttonBuy;        
@property(nonatomic, retain)IBOutlet UIButton             *buttonReselect;   
@property(nonatomic, retain)IBOutlet UILabel              *totalCost;          
@property(nonatomic, retain)NSString*                     batchCode;
@property(nonatomic, retain)NSString*                     batchEndTime;
@property (nonatomic, retain) UILabel   *str1Label;
@property (nonatomic, retain) UILabel   *str2Label;
@property (nonatomic, retain) NSString*  lastBatchCode;

@property (nonatomic, retain) IBOutlet   UIButton   *addBasketButton;
@property (nonatomic, retain) IBOutlet   UIButton   *basketButton;
@property (nonatomic, retain) IBOutlet   UILabel    *basketNum;
@end
