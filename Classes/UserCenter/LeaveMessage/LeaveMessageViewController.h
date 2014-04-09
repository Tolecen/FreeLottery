//
//  LeaveMessageViewController.h
//  RuYiCai
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullUpRefreshView;
@class AnimationTabView;

@interface LeaveMessageViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView          *m_myTable;
    NSMutableArray              *m_dataArray;
    
    PullUpRefreshView      *refreshView;
    NSUInteger              m_curPageIndex;
    NSUInteger              m_totalPageCount;
    
    AnimationTabView*    m_animationTabView;

    UITableView*         m_inLetterTableView;
    NSMutableArray      *m_inLetterDataArr;
    PullUpRefreshView      *inLetterRefreshView;
    NSUInteger              m_inLetterCurPageIndex;
    NSUInteger              m_inLetterTotalPageCount;
    NSInteger            topButtonIndex;
    UIButton             *m_leaveMessageBtn;
    UIButton             *m_stackMessageBtn;
}
@property (nonatomic, retain)UIButton             *leaveMessageBtn;
@property (nonatomic, retain)UIButton             *stackMessageBtn;
@property (nonatomic, retain)NSMutableArray     *dataArray;
@property (nonatomic, retain)NSMutableArray      *inLetterDataArr;

- (void)setRefreshViewFrame;
- (void)leaveMessageOK:(NSNotification *)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)feedBackOK:(NSNotification *)notification;
- (void)feedBackButtonClick;
- (void)netFailed:(NSNotification*)notification;

@end
