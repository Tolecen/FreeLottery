//
//  ZCOpenLotteryViewController.h
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-3.
//
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"
#import "ShareViewController.h"
#import "WXApi.h"
#import "RespForWeChatViewController.h"

@class AnimationTabView;
@class PullUpRefreshView;

@interface ZCOpenLotteryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CustomSegmentedControlDelegate,sendMsgToWeChatViewDelegate,RespForWeChatViewDelegate,WXApiDelegate>
{
    enum WXScene _scene;
    AnimationTabView*   m_animationTabView;
    UITableView      *m_myTableView;
    CustomSegmentedControl *_segmentedView;
    
    PullUpRefreshView      *refreshView;
    BOOL                   isRefreshList;
    
    NSMutableArray   *m_lotteryDataArray;
    NSUInteger       m_curPageIndex;
    NSUInteger       m_totalPageCount;
    BOOL            *m_isPushShow;
}
@property (nonatomic, assign) BOOL            *isPushShow;
@property (nonatomic, retain) AnimationTabView*      animationTabView;
@property (nonatomic, retain) UITableView            *myTableView;
@property (nonatomic, retain) NSMutableArray         *lotteryDataArray;
@property (nonatomic, retain) CustomSegmentedControl *segmentedView;

- (void)tabButtonChanged:(NSNotification*)notification;

@end
