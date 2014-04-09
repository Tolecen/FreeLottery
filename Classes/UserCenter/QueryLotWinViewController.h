//
//  QueryLotWinViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UserLotWinDetailView;
@class PullUpRefreshView;

@interface QueryLotWinViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView*   m_scrollView;
    //UILabel*        m_pageIndexLabel;
    NSUInteger      m_curPageIndex;
    NSUInteger      m_totalPageCount;
    NSUInteger      m_curPageSize;
    
    //UserLotWinDetailView* m_subViewsArray[10];
    
    PullUpRefreshView      *refreshView;
    float           startY;
    float           centerY;
}

@end
