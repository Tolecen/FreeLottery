//
//  QueryLotTrackViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryLotTrackViewController.h"
#import "RYCImageNamed.h"
#import "UserLotTrackDetailView.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "PullUpRefreshView.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kLotWinDetailViewHeight (85)

@interface QueryLotTrackViewController (internal)

- (void)refreshMySubViews;
- (void)setNewView;
- (void)queryLotTrackOK:(NSNotification *)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;
//- (void)betCompleteOK:(NSNotification*)notification;//继续追期成功后，刷新页面
@end

@implementation QueryLotTrackViewController

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryLotTrackOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelTrackOK" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backOK" object:nil];

    [super viewWillDisappear:animated];
}

- (void)dealloc 
{
    
    [m_scrollView release];

    
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];

    
    m_totalPageCount = 0;
    m_curPageIndex = 0;
    m_curPageSize = 0;
    startY = 0;
    centerY = 0;
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, (int)([UIScreen mainScreen].bounds.size.height - 64))];
    m_scrollView.scrollEnabled = YES;
    m_scrollView.delegate = self;
    [self.view addSubview:m_scrollView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64, 320, REFRESH_HEADER_HEIGHT)];
    [m_scrollView addSubview:refreshView];
    refreshView.myScrollView = m_scrollView;
    [refreshView stopLoading:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryLotTrackOK:) name:@"queryLotTrackOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTrackOK:) name:@"cancelTrackOK" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backOK:) name:@"backOK" object:nil];
    m_totalPageCount = 0;
    m_curPageIndex = 0;
    m_curPageSize = 0;
    startY = 0;
    centerY = 0;
    [[RuYiCaiNetworkManager sharedManager] queryTrackOfPage:m_curPageIndex];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}

- (void)refreshMySubViews
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
	NSString* totalPage = [parserDict objectForKey:@"totalPage"];
    m_totalPageCount = [totalPage intValue];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"result"];
    NSLog(@"%@",dict);
    int nCurCount = [dict count];
    m_curPageSize = nCurCount;
    
    UserLotTrackDetailView* m_subViewsArray[m_curPageSize];
    for (int i = 0; i < m_curPageSize; i++)
    {
        m_subViewsArray[i] = [[UserLotTrackDetailView alloc] initWithFrame:CGRectZero];
        m_subViewsArray[i].supViewController = self;
        [m_scrollView addSubview:m_subViewsArray[i]];
        m_subViewsArray[i].hidden = YES;
    }
    for (int i = 0; i < m_curPageSize; i++)
        [m_subViewsArray[i] release];
    
    for (int i = 0; i < nCurCount; i++)
    {
        NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
        m_subViewsArray[i].idNo = KISDictionaryHaveKey(subDict, @"id");
        m_subViewsArray[i].lotNo = KISDictionaryHaveKey(subDict, @"lotNo");
        m_subViewsArray[i].lotName = KISDictionaryHaveKey(subDict, @"lotName");
        m_subViewsArray[i].betCode = KISDictionaryHaveKey(subDict, @"bet_code");
        m_subViewsArray[i].betCodeMsg = KISDictionaryHaveKey(subDict, @"betCode");
        m_subViewsArray[i].batchNum = KISDictionaryHaveKey(subDict, @"batchNum");
        m_subViewsArray[i].lastNum = KISDictionaryHaveKey(subDict, @"lastNum");
        m_subViewsArray[i].beginBatch = KISDictionaryHaveKey(subDict, @"beginBatch");
        m_subViewsArray[i].betNum = KISDictionaryHaveKey(subDict, @"betNum");
        m_subViewsArray[i].cashAmount = [NSString stringWithFormat:@"%0.0lf", [[subDict objectForKey:@"amount"] doubleValue]/100];
        m_subViewsArray[i].stateType = KISDictionaryHaveKey(subDict, @"state");
        m_subViewsArray[i].orderTime = KISDictionaryHaveKey(subDict, @"orderTime");
        m_subViewsArray[i].prizeEnd = KISDictionaryHaveKey(subDict, @"prizeEnd");
        m_subViewsArray[i].isRepeatBuy = KISDictionaryHaveKey(subDict, @"isRepeatBuy");
        m_subViewsArray[i].lotMulti = KISDictionaryHaveKey(subDict, @"lotMulti");
        m_subViewsArray[i].oneAmount = KISDictionaryHaveKey(subDict, @"oneAmount");
        
        m_subViewsArray[i].hidden = NO;
        m_subViewsArray[i].frame = CGRectMake(0, i * kLotWinDetailViewHeight + startY, 320, kLotWinDetailViewHeight);
        [m_subViewsArray[i] refreshView];
    }
    m_scrollView.contentSize = CGSizeMake(320, kLotWinDetailViewHeight * m_curPageSize + startY);
    
    startY = m_scrollView.contentSize.height;
    
    centerY = m_scrollView.contentSize.height - (int)([UIScreen mainScreen].bounds.size.height - 64);
    
    m_curPageIndex++;
    
    if(m_curPageIndex == m_totalPageCount)
    {
        [refreshView stopLoading:YES];
    }
    else
    {
        [refreshView stopLoading:NO];
    }
    [refreshView setRefreshViewFrame];
}

- (void)queryLotTrackOK:(NSNotification *)notification
{
    [self refreshMySubViews];
	//[m_scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)cancelTrackOK:(NSNotification *)notification
{
    [self setNewView];
    
    [[RuYiCaiNetworkManager sharedManager] queryTrackOfPage:m_curPageIndex];
}

- (void)backOK:(NSNotification *)notification
{
    [self setNewView];
    
    [[RuYiCaiNetworkManager sharedManager] queryTrackOfPage:m_curPageIndex];
}

- (void)setNewView
{
    m_curPageIndex = 0;
    startY = 0;
    
    [refreshView removeFromSuperview];
    [refreshView release];
    
    [m_scrollView removeFromSuperview];
    [m_scrollView release];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, (int)([UIScreen mainScreen].bounds.size.height - 64))];
    m_scrollView.scrollEnabled = YES;
    m_scrollView.delegate = self;
    [self.view addSubview:m_scrollView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64, 320, REFRESH_HEADER_HEIGHT)];
    [m_scrollView addSubview:refreshView];
    refreshView.myScrollView = m_scrollView;
    [refreshView stopLoading:NO];
}

//- (void)betCompleteOK:(NSNotification*)notification
//{
//    [self setNewView];
//    [[RuYiCaiNetworkManager sharedManager] queryTrackOfPage:m_curPageIndex];
//}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(m_curPageIndex == 0)
    {
        refreshView.viewMaxY = 0;
    }
    else
    {
        refreshView.viewMaxY = centerY;
    }
    [refreshView viewdidScroll:scrollView];
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView viewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView didEndDragging:scrollView];
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(m_curPageIndex < m_totalPageCount)
    {
        [[RuYiCaiNetworkManager sharedManager] queryTrackOfPage:m_curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end