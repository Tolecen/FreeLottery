//
//  QueryLotTrackViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class UserLotTrackDetailView;
@class PullUpRefreshView;

@interface QueryLotTrackViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView*   m_scrollView;

    NSUInteger      m_curPageIndex;
    NSUInteger      m_totalPageCount;
    NSUInteger      m_curPageSize;
    
    //UserLotTrackDetailView* m_subViewsArray[10];
    
    PullUpRefreshView      *refreshView;
    float           startY;
    float           centerY;
}

- (void)backOK:(NSNotification *)notification;

@end
