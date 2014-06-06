//
//  LotteryAwardInfoViewController.h
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class TrendView;
@class PullUpRefreshView;

@interface LotteryAwardInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
//    UIButton         *m_backButton;
    
      UIView           *m_detailView;
//    UIScrollView     *m_detailScroll;
    
    //UIScrollView     *m_jiangXianScroll;
    
    UITableView      *m_myTableView;
    NSUInteger       m_cellCount;
    NSString*        m_lotTitle;
    NSString*        m_lotNo;
    NSString*        m_batchCode;
    
    UIButton         *m_trendButton;
    UIButton         *m_lotteryButton;
    UIButton         *m_detailButton;
    NSInteger        btnIndex;
    
    UIScrollView     *m_scrollView;
    TrendView        *m_trendView;
    NSInteger        VRednumber;
    NSMutableArray*  m_trendDataArray;//请求50期开奖号码数据
    
    TrendView        *m_blueTrendView;
    NSInteger        VBluenumber;
    BOOL             isBlue;
    
    PullUpRefreshView      *refreshView;
    BOOL                   isRefreshList;
    
    NSMutableArray   *m_lotteryDataArray;
    NSUInteger       m_curPageIndex;
    NSUInteger       m_totalPageCount;
    
    BOOL             isHasDetailView;
    BOOL             isFirstTrendView;
    
    UIButton*        m_shareButton;

    UIButton*        m_goLotteryButton;
    BOOL             m_isGoLottery;//从选号页进入时，返回功能
    NSString        *m_nsLastText;
//    enum WXScene _scene;
    BOOL            *m_isPushShow;

}
@property (nonatomic, assign) BOOL            *isPushShow;
@property (nonatomic, assign) id                delegate;
@property (nonatomic, retain) UIView           *detailView;
@property (nonatomic, retain) UIScrollView     *detailScroll;
@property (nonatomic, retain) NSString*        lotTitle;
@property (nonatomic, retain) NSString*        lotNo;
@property (nonatomic, retain) NSString*        batchCode;
@property (nonatomic, retain) UITableView      *myTableView;

@property (nonatomic, retain) NSMutableArray*  trendDataArray;
@property (nonatomic, retain) UIButton         *trendButton;
@property (nonatomic, retain) UIButton         *lotteryButton;
@property (nonatomic, retain) UIButton         *detailButton;
@property (nonatomic, retain) UIScrollView     *scrollView;
@property (nonatomic, retain) TrendView        *trendView;
@property (nonatomic, assign) NSInteger         VRednumber;
@property (nonatomic, retain) TrendView        *blueTrendView;
@property (nonatomic, assign) NSInteger         VBluenumber;
@property (nonatomic, retain) NSMutableArray    *lotteryDataArray;
@property (nonatomic, assign) BOOL             isGoLottery;
- (void)refreshLotteryAwardInfo;
- (void)trendButtonClick;
- (void)lotteryButtonClick;
- (void)displaySMS:(NSString*)message;
- (void)sendsms:(NSString*)message;
@end
