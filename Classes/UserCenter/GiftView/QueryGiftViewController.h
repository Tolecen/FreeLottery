//
//  QueryGiftViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class GiftDetailView;
//@class GiftedDetailView;
@class PullUpRefreshView;

@interface QueryGiftViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView*   m_scrollView;
	UIScrollView*   m_giftedScrollView;
    
    NSUInteger      m_giftCurPageIndex;
    NSUInteger      m_giftTotalPageCount;
    NSUInteger      m_giftCurPageSize;
    
    NSUInteger      m_giftedCurPageIndex;
    NSUInteger      m_giftedTotalPageCount;
    NSUInteger      m_giftedCurPageSize;
    
	UIButton        *giftButton;
    UIButton        *giftedButton;	
//    GiftDetailView* m_subViewsArray[10];
//	GiftedDetailView* m_giftedSubViewsArray[10];
    
    PullUpRefreshView      *refreshGiftView;
    float           giftStartY;
    float           giftCenterY;
    
    PullUpRefreshView      *refreshGiftedView;
    float           giftedStartY;
    float           giftedCenterY;   
	
	BOOL           isGift;
	BOOL           isFirst;
}

@end
