//
//  QueryLotBetViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserLotBetDetailView;
@class PullUpRefreshView;

@interface QueryLotBetViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate> {
    
    
    UIScrollView*   m_scrollView;
    UILabel*        m_pageIndexLabel;
    NSUInteger      m_curPageIndex;
    NSUInteger      m_totalPageCount;
    NSUInteger      m_curPageSize;
    
    //UserLotBetDetailView* m_subViewsArray[10];
    
    NSString*       m_selectLotNo;
    BOOL            isSingleLot;
    BOOL            m_selectScrollViewScroll;
    
    PullUpRefreshView      *refreshView;
    float           startY;
    float           centerY;
    
    BOOL            m_isComeFromBetView;
    BOOL            m_isPushShow;
}
@property (nonatomic, retain) NSString*  selectLotNo;//订单号
@property (nonatomic, assign) BOOL       isPushShow;


- (void) setSelectLotNo:(NSString*) lotNo;
@end
