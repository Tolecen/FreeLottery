//
//  HMDTQueryCaseLotViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HMDTQueryCaseLotViewController.h"
#import "HMDTCaseLotCellView.h"
#import "RYCImageNamed.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "PullUpRefreshView.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "AnimationTabView.h"
#import "HMDTQueryCaseLot_AutoOrderView.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kLotWinDetailViewHeight (70)
#define kLotAutoOrderViewHeight (90)
@interface HMDTQueryCaseLotViewController (internal)

- (void)refreshMySubViews;
- (void) setupLaunchLotView;
- (void) setupAutoOrderView;

- (void)queryCaseLotOK:(NSNotification *)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;
//- (void)refreshCurPage:(NSNotification*)notification;
//viewSegment
- (void)tabButtonChanged:(NSNotification*)notification;
- (void)queryCaseLot_aitoOrderCompleteOK:(NSNotification *)notification;
@end

@implementation HMDTQueryCaseLotViewController
@synthesize animationTabView = m_animationTabView;
- (void)dealloc
{
    [m_autoOrderView release];
    [m_launchLotView release];
    [refreshView_launchLotView release];
    [refreshView_autoOrderView release];
    [m_animationTabView release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryCaseLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCurPage" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryCaseLot_aitoOrderCompleteOK" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    m_totalPageCount_launchLotView = 0;
    m_curPageIndex_launchLotView = 0;
    m_curPageSize_launchLotView = 0;
    startY_launchLotView = 0;
    centerY_launchLotView = 0;
    
//    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
//    [m_animationTabView.buttonNameArray addObject:@"合买查询"];
//    [m_animationTabView.buttonNameArray addObject:@"跟单查询"];
//    [m_animationTabView setMainButton];
//    [self.view addSubview:m_animationTabView];
    
    m_isLaunchLotView = YES;
    m_launchLotView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,5, 320, (int)([UIScreen mainScreen].bounds.size.height - 64 - 5))];
    m_launchLotView.delegate = self;
    m_launchLotView.scrollEnabled = YES;
    [self.view addSubview:m_launchLotView];
    
    refreshView_launchLotView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, (int)([UIScreen mainScreen].bounds.size.height - 64- 12), 320, REFRESH_HEADER_HEIGHT)];
    [m_launchLotView addSubview:refreshView_launchLotView];
    refreshView_launchLotView.myScrollView = m_launchLotView;
    [refreshView_launchLotView stopLoading:NO];
    
    [self setNewScrollView_autoOrderView];
    m_autoOrderView.hidden = YES;
    
    [[RuYiCaiNetworkManager sharedManager] queryCaseLotOfPage:0];//连接服务器
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCaseLotOK:) name:@"queryCaseLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurPage:) name:@"refreshCurPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCaseLot_aitoOrderCompleteOK:) name:@"queryCaseLot_aitoOrderCompleteOK" object:nil];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    //    if (m_isLaunchLotView) {
    //        [self setNewScrollView_launchLotView];
    //        m_isLaunchLotView = YES;
    //        m_launchLotView.hidden = NO;
    //        m_autoOrderView.hidden = YES;
    //        m_curPageIndex_launchLotView = 0;
    //        m_curPageIndex_launchLotView = 0;
    //        m_totalPageCount_launchLotView = 0;
    //        [[RuYiCaiNetworkManager sharedManager] queryCaseLotOfPage:0];//查询hemai
    //    }
    //    else
    //    {
    //        [self setNewScrollView_autoOrderView];
    //        m_isLaunchLotView = NO;
    //        m_launchLotView.hidden = YES;
    //        m_autoOrderView.hidden = NO;
    //        m_curPageIndex_autoOrderView = 0;
    //        m_curPageIndex_autoOrderView = 0;
    //        m_totalPageCount_autoOrderView = 0;
    //        [[RuYiCaiNetworkManager sharedManager] queryCaseLot_autoOrderOfPage:0];//查询定制跟单
    //    }
    
}

- (void)refreshMySubViews
{
    if (m_isLaunchLotView) {
        [self setupLaunchLotView];
    }
    else
        [self setupAutoOrderView];
    
}

- (void) setupLaunchLotView
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    
    NSString* totalPage = [parserDict objectForKey:@"totalPage"];
    m_totalPageCount_launchLotView = [totalPage intValue];
    [jsonParser release];
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"result"];
    int nCurCount = [dict count];
    m_curPageSize_launchLotView  = nCurCount;
    
    HMDTCaseLotCellView* m_subViewsArray[m_curPageSize_launchLotView];
    for (int i = 0; i < m_curPageSize_launchLotView ; i++)
    {
        m_subViewsArray[i] = [[HMDTCaseLotCellView alloc] initWithFrame:CGRectZero];
        m_subViewsArray[i].supViewController = self;
        [m_launchLotView addSubview:m_subViewsArray[i]];
        m_subViewsArray[i].hidden = YES;
    }
    
    for (int i = 0; i < nCurCount; i++)
    {
        NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
        m_subViewsArray[i].caseLotId = [subDict objectForKey:@"caseLotId"];
        m_subViewsArray[i].lotNo = [subDict objectForKey:@"lotNo"];
        m_subViewsArray[i].displayState = KISDictionaryHaveKey(subDict, @"displayState");
        m_subViewsArray[i].lotTitle = KISDictionaryHaveKey(subDict, @"lotName");
        //        m_subViewsArray[i].displayStateMemo = [subDict objectForKey:@"displayStateMemo"];
        m_subViewsArray[i].amount = [NSString stringWithFormat:@"%d", [[subDict objectForKey:@"buyAmt"] intValue]/100];
        //        m_subViewsArray[i].totalAmount = [NSString stringWithFormat:@"%d", [[subDict objectForKey:@"totalAmt"] intValue]/100];
        //        m_subViewsArray[i].saftAmount = [NSString stringWithFormat:@"%d", [[subDict objectForKey:@"safeAmt"] intValue]/100];
        //        m_subViewsArray[i].progressInfo = [subDict objectForKey:@"progress"];
        m_subViewsArray[i].buyTime = [subDict objectForKey:@"buyTime"];
        //        m_subViewsArray[i].contentInfo = [subDict objectForKey:@"content"];
        m_subViewsArray[i].prizeState = [subDict objectForKey:@"prizeState"];
        m_subViewsArray[i].prizeAmount = [NSString stringWithFormat:@"%0.2lf", [[subDict objectForKey:@"prizeAmt"] doubleValue]/100];
        m_subViewsArray[i].starter = KISDictionaryHaveKey(subDict, @"starter");
        //        m_subViewsArray[i].winCode = [subDict objectForKey:@"winCode"];
        
        //        if ([subDict objectForKey:@"batchCode"] == (NSString*)[NSNull null] || [(NSString*)[subDict objectForKey:@"batchCode"] isEqualToString:@""])
        //        {
        //            m_subViewsArray[i].batchCode = @"";
        //        }
        //        else
        //            m_subViewsArray[i].batchCode = [subDict objectForKey:@"batchCode"];
        
        m_subViewsArray[i].hidden = NO;
        m_subViewsArray[i].frame = CGRectMake(0,  i * kLotWinDetailViewHeight + startY_launchLotView, 320, kLotWinDetailViewHeight);
        [m_subViewsArray[i] refreshView];
    }
    for (int i = 0; i < m_curPageSize_launchLotView; i++)
        [m_subViewsArray[i] release];
    
    m_launchLotView.contentSize = CGSizeMake(320, kLotWinDetailViewHeight * m_curPageSize_launchLotView + startY_launchLotView);
    
    startY_launchLotView = m_launchLotView.contentSize.height ;
    
    centerY_launchLotView = m_launchLotView.contentSize.height - (int)([UIScreen mainScreen].bounds.size.height - 64 -45);
    
    m_curPageIndex_launchLotView++;
    
    if(m_curPageIndex_launchLotView == m_totalPageCount_launchLotView)
    {
        [refreshView_launchLotView stopLoading:YES];
    }
    else
    {
        [refreshView_launchLotView stopLoading:NO];
    }
    [refreshView_launchLotView setRefreshViewFrame];
}
- (void) setupAutoOrderView
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    
    NSString* totalPage = [parserDict objectForKey:@"totalPage"];
    m_totalPageCount_autoOrderView = [totalPage intValue];
    [jsonParser release];
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"result"];
    int nCurCount = [dict count];
    m_curPageSize_autoOrderView  = nCurCount;
    
    HMDTQueryCaseLot_AutoOrderView* m_subViewsArray[m_curPageSize_autoOrderView];
    for (int i = 0; i < m_curPageSize_autoOrderView ; i++)
    {
        m_subViewsArray[i] = [[HMDTQueryCaseLot_AutoOrderView alloc] initWithFrame:CGRectZero];
        m_subViewsArray[i].supViewController = self;
        [m_autoOrderView addSubview:m_subViewsArray[i]];
        m_subViewsArray[i].hidden = NO;
    }
    
    for (int i = 0; i < nCurCount; i++)
    {
        NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
        m_subViewsArray[i].caseId = KISDictionaryNullValue(subDict, @"id");
        m_subViewsArray[i].starter = KISDictionaryNullValue(subDict, @"starter");
        m_subViewsArray[i].starterUserNo = KISDictionaryNullValue(subDict, @"starterUserNo");
        m_subViewsArray[i].lotName = KISDictionaryNullValue(subDict, @"lotName");
        m_subViewsArray[i].lotNo = KISDictionaryNullValue(subDict, @"lotNo");
        m_subViewsArray[i].times = KISDictionaryNullValue(subDict, @"times");
        m_subViewsArray[i].joinAmt = KISDictionaryNullValue(subDict, @"joinAmt");
        m_subViewsArray[i].safeAmt = KISDictionaryNullValue(subDict, @"safeAmt");
        m_subViewsArray[i].maxAmt = KISDictionaryNullValue(subDict, @"maxAmt");
        m_subViewsArray[i].percent = KISDictionaryNullValue(subDict, @"percent");
        m_subViewsArray[i].joinType = KISDictionaryNullValue(subDict, @"joinType");
        m_subViewsArray[i].forceJoin = KISDictionaryNullValue(subDict, @"forceJoin");
        m_subViewsArray[i].createTime = KISDictionaryNullValue(subDict, @"createTime");
        m_subViewsArray[i].state = KISDictionaryNullValue(subDict, @"state");
        if ([subDict objectForKey:@"displayIcon"] != (NSDictionary*)[NSNull null]) {
            m_subViewsArray[i].zhanjiDic = (NSDictionary*)[subDict objectForKey:@"displayIcon"];
        }
        
        m_subViewsArray[i].hidden = NO;
        m_subViewsArray[i].frame = CGRectMake(0,  i * kLotAutoOrderViewHeight + startY_autoOrderView, 320, kLotAutoOrderViewHeight);
        [m_subViewsArray[i] refreshView];
    }
    for (int i = 0; i < m_curPageSize_autoOrderView; i++)
        [m_subViewsArray[i] release];
    m_autoOrderView.contentSize = CGSizeMake(320, kLotAutoOrderViewHeight * m_curPageSize_autoOrderView + startY_autoOrderView );
    
    startY_autoOrderView = m_autoOrderView.contentSize.height ;
    
    centerY_autoOrderView = m_autoOrderView.contentSize.height - (int)([UIScreen mainScreen].bounds.size.height - 64 -45);
    
    m_curPageIndex_autoOrderView++;
    
    if(m_curPageIndex_autoOrderView == m_totalPageCount_autoOrderView)
    {
        [refreshView_autoOrderView stopLoading:YES];
    }
    else
    {
        [refreshView_autoOrderView stopLoading:NO];
    }
    [refreshView_autoOrderView setRefreshViewFrame];
}
- (void)queryCaseLotOK:(NSNotification *)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *erroeCode = (NSString*)obj;
        if([erroeCode isEqualToString:@"0047"])//无记录
        {
            UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
            cLabel.text = @"无记录";
            cLabel.textAlignment = UITextAlignmentCenter;
            cLabel.textColor = kColorWithRGB(116.0, 116.0, 116.0, 1.0);
            cLabel.font = [UIFont boldSystemFontOfSize:20];
            cLabel.backgroundColor = [UIColor clearColor];
            
            [m_launchLotView addSubview:cLabel];
            
            [cLabel release];
        }
        else
            [self refreshMySubViews];
    }
}
- (void)setNewScrollView_launchLotView
{
    startY_launchLotView = 0;
    centerY_launchLotView = 0;
    
    [refreshView_launchLotView removeFromSuperview];
    [refreshView_launchLotView release];
    
    [m_launchLotView removeFromSuperview];
    [m_launchLotView release];
    
   
    m_launchLotView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,5, 320, (int)([UIScreen mainScreen].bounds.size.height - 64 - 5))];
    m_launchLotView.delegate = self;
    m_launchLotView.scrollEnabled = YES;
    [self.view addSubview:m_launchLotView];
    
    refreshView_launchLotView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, (int)([UIScreen mainScreen].bounds.size.height - 64- 45), 320, REFRESH_HEADER_HEIGHT)];
    [m_launchLotView addSubview:refreshView_launchLotView];
    refreshView_launchLotView.myScrollView = m_launchLotView;
    [refreshView_launchLotView stopLoading:NO];
}
- (void)setNewScrollView_autoOrderView
{
    startY_autoOrderView = 0;
    centerY_autoOrderView = 0;
    
    [refreshView_autoOrderView removeFromSuperview];
    [refreshView_autoOrderView release];
    
    [m_autoOrderView removeFromSuperview];
    [m_autoOrderView release];
    
    m_autoOrderView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, (int)([UIScreen mainScreen].bounds.size.height - 64 -45))];
    m_autoOrderView.delegate = self;
    m_autoOrderView.scrollEnabled = YES;
    [self.view addSubview:m_autoOrderView];
    
    refreshView_autoOrderView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, (int)([UIScreen mainScreen].bounds.size.height - 64-45), 320, REFRESH_HEADER_HEIGHT)];
    [m_autoOrderView addSubview:refreshView_autoOrderView];
    refreshView_autoOrderView.myScrollView = m_autoOrderView;
    [refreshView_autoOrderView stopLoading:NO];
}

- (void)refreshCurPage:(NSNotification*)notification
{
    if (m_isLaunchLotView) {
        m_curPageIndex_launchLotView = 0;
        [self setNewScrollView_launchLotView];
        [[RuYiCaiNetworkManager sharedManager] queryCaseLotOfPage:m_curPageIndex_launchLotView];//连接服务器
    }
    else
    {
        m_curPageIndex_autoOrderView = 0;
        [self setNewScrollView_autoOrderView];
        [[RuYiCaiNetworkManager sharedManager] queryCaseLot_autoOrderOfPage:0];//查询定制跟单
    }
    
}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f", scrollView.contentOffset.y);
    if (m_isLaunchLotView) {
        if(m_curPageIndex_launchLotView == 0)
        {
            refreshView_launchLotView.viewMaxY = 0;
        }
        else
        {
            refreshView_launchLotView.viewMaxY = centerY_launchLotView;
        }
        [refreshView_launchLotView viewdidScroll:scrollView];
    }
    else
    {
        if(m_curPageIndex_autoOrderView == 0)
        {
            refreshView_autoOrderView.viewMaxY = 0;
        }
        else
        {
            refreshView_autoOrderView.viewMaxY = centerY_autoOrderView;
        }
        [refreshView_autoOrderView viewdidScroll:scrollView];
    }
    
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (m_isLaunchLotView) {
        [refreshView_launchLotView viewWillBeginDragging:scrollView];
    }
    else
    {
        [refreshView_autoOrderView viewWillBeginDragging:scrollView];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (m_isLaunchLotView) {
        [refreshView_launchLotView didEndDragging:scrollView];
        
    }
    else
    {
        [refreshView_autoOrderView didEndDragging:scrollView];
    }
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if (m_isLaunchLotView) {
        if(m_curPageIndex_launchLotView < m_totalPageCount_launchLotView)
        {
            [[RuYiCaiNetworkManager sharedManager] queryCaseLotOfPage:m_curPageIndex_launchLotView];
        }
    }
    else
    {
        if(m_curPageIndex_autoOrderView < m_totalPageCount_autoOrderView)
        {
            [[RuYiCaiNetworkManager sharedManager] queryCaseLot_autoOrderOfPage:m_curPageIndex_autoOrderView];
        }
    }
    
}

- (void)netFailed:(NSNotification*)notification
{
    if (m_isLaunchLotView) {
        [refreshView_launchLotView stopLoading:NO];
    }
    else
    {
        [refreshView_autoOrderView stopLoading:NO];
    }
	
}

#pragma mark tabButtonChange
- (void)tabButtonChanged:(NSNotification*)notification
{
    NSLog(@"tabButtonChanged~~~");
    //    [self hideKeyboard];//去掉键盘
    
    if(self.animationTabView.selectButtonTag == 0)
    {
        m_isLaunchLotView = YES;
        if (m_autoOrderView != NULL) {
            m_autoOrderView.hidden = YES;
        }
        if (m_curPageIndex_launchLotView == 0 && m_curPageIndex_launchLotView == 0
            && m_totalPageCount_launchLotView == 0) {
            [self setNewScrollView_launchLotView];
            [[RuYiCaiNetworkManager sharedManager] queryCaseLotOfPage:0];//查询
        }
        else
        {
            if (m_launchLotView != NULL) {
                m_launchLotView.hidden = NO;
            }
        }
    }
    else if(self.animationTabView.selectButtonTag == 1)
    {
        m_isLaunchLotView = NO;
        if (m_launchLotView != NULL) {
            m_launchLotView.hidden = YES;
        }
        m_autoOrderView.hidden = NO;
        if (m_curPageIndex_autoOrderView == 0 && m_curPageIndex_autoOrderView == 0
            && m_totalPageCount_autoOrderView == 0) {
            [[RuYiCaiNetworkManager sharedManager] queryCaseLot_autoOrderOfPage:0];//查询定制跟单
        }
    }
}
- (void)queryCaseLot_aitoOrderCompleteOK:(NSNotification *)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *erroeCode = (NSString*)obj;
        if([erroeCode isEqualToString:@"0047"])//无记录
        {
            UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
            cLabel.text = @"无记录";
            cLabel.textAlignment = UITextAlignmentCenter;
            cLabel.textColor = kColorWithRGB(116.0, 116.0, 116.0, 1.0);
            cLabel.font = [UIFont boldSystemFontOfSize:20];
            cLabel.backgroundColor = [UIColor clearColor];
            [m_autoOrderView addSubview:cLabel];
            [cLabel release];
        }
        else
            [self refreshMySubViews];
    }
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
