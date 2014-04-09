//
//  QueryLotWinViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryLotWinViewController.h"
#import "RYCImageNamed.h"
#import "UserLotWinDetailView.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "PullUpRefreshView.h"
#import "Custom_tabbar.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kLotWinDetailViewHeight (80)

#define REFRESH_HEADER_HEIGHT 52.0f

@interface QueryLotWinViewController (internal)

- (void)refreshMySubViews;
//- (void)pageUpClick:(id)sender;
//- (void)pageDownClick:(id)sender;
- (void)goBack:(id)sender;
- (void)queryBetWinOK:(NSNotification *)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;

@end

@implementation QueryLotWinViewController

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetWinOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    
    [m_scrollView release];
    //for (int i = 0; i < 10; i++)
    //   [m_subViewsArray[i] release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    /*self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
     initWithTitle:@"返回"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(goBack:)];*/
    
    m_totalPageCount = 0;
    m_curPageIndex = 0;
    m_curPageSize = 0;
    startY = 0;
    centerY = 0;
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetWinOK:) name:@"queryBetWinOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    
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
    int nCurCount = [dict count];
    m_curPageSize = nCurCount;
    
    UserLotWinDetailView* m_subViewsArray[m_curPageSize];
    for (int i = 0; i < m_curPageSize; i++)
    {
        m_subViewsArray[i] = [[UserLotWinDetailView alloc] initWithFrame:CGRectZero];
        m_subViewsArray[i].supViewController = self;
        [m_scrollView addSubview:m_subViewsArray[i]];
        m_subViewsArray[i].hidden = YES;
    }
    for (int i = 0; i < m_curPageSize; i++)
        [m_subViewsArray[i] release];
    
    NSLog(@"m_curPageIndex %d",m_curPageIndex);
    for (int i = 0; i < nCurCount; i++)
    {
        NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
        m_subViewsArray[i].lotNo = KISDictionaryHaveKey(subDict, @"lotNo");
        m_subViewsArray[i].lotName = KISDictionaryHaveKey(subDict, @"lotName");
        //        m_subViewsArray[i].betCode = KISDictionaryHaveKey(subDict, @"bet_code");
        //        m_subViewsArray[i].betCodeMsg = KISDictionaryHaveKey(subDict, @"betCodeHtml");
		double win = [[subDict objectForKey:@"prizeAmt"] doubleValue] / 100;
        m_subViewsArray[i].winAmount = [NSString stringWithFormat:@"%0.2lf", win];
        m_subViewsArray[i].batchCode = KISDictionaryHaveKey(subDict, @"batchCode");
        m_subViewsArray[i].cashTime = KISDictionaryHaveKey(subDict, @"cashTime");
        m_subViewsArray[i].sellTime = KISDictionaryHaveKey(subDict, @"orderTime");
        
        m_subViewsArray[i].orderId = KISDictionaryHaveKey(subDict, @"orderId");//订单号
        m_subViewsArray[i].betNum = KISDictionaryHaveKey(subDict, @"betNum");//注数
        m_subViewsArray[i].lotMulti = KISDictionaryHaveKey(subDict, @"lotMulti");
        m_subViewsArray[i].winCode = KISDictionaryHaveKey(subDict, @"winCode");
        
        m_subViewsArray[i].cashAmount = [NSString stringWithFormat:@"%0.2lf", [[subDict objectForKey:@"amount"] doubleValue] / 100];
        
        m_subViewsArray[i].hidden = NO;
        m_subViewsArray[i].frame = CGRectMake(0, i * kLotWinDetailViewHeight + startY, 320, kLotWinDetailViewHeight);
        [m_subViewsArray[i] refreshView];
    }
    m_scrollView.contentSize = CGSizeMake(320, kLotWinDetailViewHeight * m_curPageSize + startY);
    NSLog(@"contentSize.height %f", m_scrollView.contentSize.height);
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

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)queryBetWinOK:(NSNotification *)notification
{
	//[m_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
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
            [m_scrollView addSubview:cLabel];
            [cLabel release];
        }
        else
            [self refreshMySubViews];
    }
}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f", scrollView.contentOffset.y);
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
        [[RuYiCaiNetworkManager sharedManager] queryLotWinOfPage:m_curPageIndex];
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
