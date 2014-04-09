//
//  HMDTGroupByViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"
#import "ShareViewController.h"
#import "WXApi.h"
#import "RespForWeChatViewController.h"

#define kPerPageMaxSize  (10)

//@class HMDTGroupByCellView;
@class PullUpRefreshView;

typedef enum{
    jinduOrder = 0,
    zongeOrder,
    renqiOrder
}TypeOrder;

@interface HMDTGroupByViewController : UIViewController<UIScrollViewDelegate,CustomSegmentedControlDelegate, sendMsgToWeChatViewDelegate,RespForWeChatViewDelegate,WXApiDelegate> {
    enum WXScene _scene;
    NSUInteger           m_curPageIndex;
    NSUInteger           m_totalPageCount;
    NSUInteger           m_curPageSize;
    
    UIButton*            m_danjiaButton;
    UIButton*            m_jinduButton;
    UIButton*            m_zongeButton;
    UIButton*            m_groupOrderButton;
    NSUInteger           m_groupType;
    BOOL                 m_upOrder;
 
    UIScrollView*        m_scrollView;
 
    NSMutableArray*      m_resultDict;
    
    PullUpRefreshView      *refreshView;
    float           startY;
    float           centerY;
    
    NSString*            m_selectLotNo;
 
//    NSMutableArray*      m_subViewsArray;
    NSString                    *m_isFilter;
 
}
@property (nonatomic, retain) NSString   *isFilter;
@property (nonatomic, retain) NSString* selectLotNo;
@property (nonatomic, retain) CustomSegmentedControl *segmented;
@property (nonatomic, assign) TypeOrder typeOrder;

@end
