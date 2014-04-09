//
//  ZC_pickNumberViewController.h
//  RuYiCai
//
//  Created by haojie on 11-12-1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ZC_TabView.h"
#import "CustomSegmentedControl.h"

typedef enum
{
    IZCLotTag_SFC = 1,//胜负彩
    IZCLotTag_RJC,   //任九场
    IZCLotTag_JQC,    //进球彩
    IZCLotTag_LCB,    //六场半
} ZC_caizhongTag;

@class ZCSixCBView;
@class ZCCellView;
@class ZCJinQiuCaiView;


@interface ZC_pickNumberViewController : UIViewController<UIScrollViewDelegate, RandomPickerDelegate,CustomSegmentedControlDelegate>
{
    RuYiCaiAppDelegate         *m_delegate;
    
	UIScrollView           *m_scrollView;
    
    //	UIBarButtonItem        *m_rightTitleBarItem;
    
    UIButton               *m_buttonBuy;          //立即投注
    UIButton               *m_buttonReselect;     //重新选择
	NSString*               m_batchCode;
    NSString*               m_batchEndTime;
	
	NSInteger               m_numZhu;
	ZCCellView             *m_subViewArray_SFC[14];
	ZCJinQiuCaiView        *m_subViewArray_JQC[4];
   	ZCCellView             *m_subViewArray_RJC[14];
	ZCSixCBView            *m_subViewArray_LCB[6];
    
	UIView                 *m_listTeam;
    UIButton               *m_batchCodeButton;
    UILabel                *m_str2Label;
    
    ZC_TabView             *m_tabview;
    int                     m_ZCTag;
    
    UIView                     *m_detailView;
    //    UIButton                   *m_detailButton;
    
    NSMutableDictionary*       m_batchCodeTimeDic;//存期号（预售期）
    UIView                     *m_bottomView;
    CustomSegmentedControl     *m_customSegmentedControl;
    NSDictionary               *m_typeIdDicArray;
    BOOL                       *m_isHidePush;
    
}
@property (nonatomic, assign) BOOL          *isHidePush;

@property (nonatomic, retain) NSDictionary            *typeIdDicArray;
@property (nonatomic, retain) CustomSegmentedControl   *customSegmentedControl;
@property (nonatomic, retain) IBOutlet UIView        *bottomView;
@property (nonatomic, retain) IBOutlet UIScrollView  *scrollView;
@property (nonatomic, retain) IBOutlet UIButton      *buttonBuy;
@property (nonatomic, retain) IBOutlet UIButton      *buttonReselect;
@property (nonatomic, retain) NSString *batchCode;
@property (nonatomic, retain) NSString *batchEndTime;
@property (nonatomic, retain) UIButton   *batchCodeButton;
@property (nonatomic, retain) UILabel   *str2Label;

@property(nonatomic, assign) int  ZCTag;

@property(nonatomic, retain) NSMutableDictionary*                batchCodeTimeDic;


- (void) refreshBatchCode;

@end
