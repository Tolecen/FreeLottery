//
//  ActionCenterViewController.h
//  RuYiCai
//
//  Created by  on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullUpRefreshView;

@interface ActionCenterViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView       *m_scrollView;
    
    NSMutableArray     *m_titleDataArray;
    NSInteger           m_curIndex;
    NSInteger           m_totalPage;
    float               m_startY;
    
    PullUpRefreshView    *refreshView;
    NSUInteger           m_curPageIndex;
    float                m_centerY;
    
    NSMutableArray     *m_activityTimesArr;
    NSMutableArray     *m_activityIdArr;
    NSInteger           m_index;
    UIImageView         *activeConductImageView;
    UILabel             *m_titleLabel;
    NSString            *m_detileStr;
}
@property (nonatomic, retain) NSString            *detileStr;
@property (nonatomic, retain) NSMutableArray      *titleDataArray;
@property (nonatomic, retain) NSMutableArray      *activityTimesArr;
@property (nonatomic, retain) NSMutableArray      *activityIdArr;

@end
