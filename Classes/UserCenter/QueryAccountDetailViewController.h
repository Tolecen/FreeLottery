//
//  QueryAccountDetailViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"

@class AccountDetailView;

@interface QueryAccountDetailViewController : UIViewController <CustomSegmentedControlDelegate>
{
//    UIButton        *m_backButton;
    
    UILabel*        m_pageIndexLabel;
    NSUInteger      m_curPageIndex;
    NSUInteger      m_totalPageCount;
    NSUInteger      m_curPageSize;
    
    AccountDetailView*  m_subViewsArray[50];
    UIScrollView*       m_scrollViewArray[5];
    UISegmentedControl* m_segmented;
    CustomSegmentedControl *_segmentView;
    
    UILabel         *m_allAmountLabel;
    UIImageView*     allCountBg;
}
@property (nonatomic, retain) CustomSegmentedControl *segmentView;

@end
