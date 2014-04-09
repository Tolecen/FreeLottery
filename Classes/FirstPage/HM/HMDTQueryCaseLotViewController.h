//
//  HMDTQueryCaseLotViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class HMDTCaseLotCellView;
@class PullUpRefreshView;
@class AnimationTabView;
@interface HMDTQueryCaseLotViewController : UIViewController<UIScrollViewDelegate> {
    
    AnimationTabView*   m_animationTabView;
    
    
    BOOL                 m_isLaunchLotView;
    UIScrollView*        m_launchLotView;
    NSUInteger           m_curPageIndex_launchLotView;
    NSUInteger           m_totalPageCount_launchLotView;
    NSUInteger           m_curPageSize_launchLotView;
    
    
    
    UIScrollView*        m_autoOrderView;
    NSUInteger           m_curPageIndex_autoOrderView;
    NSUInteger           m_totalPageCount_autoOrderView;
    NSUInteger           m_curPageSize_autoOrderView;
    
    //    PullUpRefreshView      *refreshView;
    //    float           startY;
    //    float           centerY;
    
    PullUpRefreshView      *refreshView_launchLotView;
    float           startY_launchLotView;
    float           centerY_launchLotView;
    
    PullUpRefreshView      *refreshView_autoOrderView;
    float           startY_autoOrderView;
    float           centerY_autoOrderView;
    
}
@property(nonatomic,retain) AnimationTabView* animationTabView ;
@end
