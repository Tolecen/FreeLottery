    //
//  QueryGiftViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryGiftViewController.h"
#import "RYCImageNamed.h"
#import "GiftDetailView.h"
#import "GiftedDetailView.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "PullUpRefreshView.h"
#import "Custom_tabbar.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kLotWinDetailViewHeight (80)
#define kGiftedDetailViewHeight (80)

@interface QueryGiftViewController (internal)

- (void)refreshMySubViews;
//- (void)pageUpClick:(id)sender;
//- (void)pageDownClick:(id)sender;
- (void)giftButtonClick;
- (void)giftedButtonClick;
//- (void)goBack:(id)sender;
- (void)queryGiftOK:(NSNotification *)notification;
//- (void)receiveLotteryOK:(NSNotification *)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;

@end

@implementation QueryGiftViewController

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryGiftOK" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"receiveLotteryOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [super viewWillDisappear:animated];
}

- (void)dealloc 
{
    [m_scrollView release];
	[m_giftedScrollView release];
	[giftButton release];
	[giftedButton release];

    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];

    m_giftCurPageIndex = 0;
    m_giftTotalPageCount = 0;
    m_giftCurPageSize = 0;
    giftStartY = 0;
    giftCenterY = 0;
    
    m_giftedCurPageIndex = 0;
    m_giftedTotalPageCount = 0;
    m_giftedCurPageSize = 0;
    giftedStartY = 0;
    giftedCenterY = 0;
    
	isGift = YES;
	isFirst = YES;
	
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 38, 320, (int)([UIScreen mainScreen].bounds.size.height - 64 - 38))];
    m_scrollView.scrollEnabled = YES;
    m_scrollView.delegate = self;
    [self.view addSubview:m_scrollView];
	m_scrollView.hidden = NO;

	m_giftedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 38, 320, (int)([UIScreen mainScreen].bounds.size.height - 64 - 38))];
    m_giftedScrollView.scrollEnabled = YES;
    m_giftedScrollView.delegate = self;
    [self.view addSubview:m_giftedScrollView];
	m_giftedScrollView.hidden = YES;
    
    

    
    
	giftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 1, 155, 32)];
//    [giftButton setTitle:@"赠出的彩票" forState:UIControlStateNormal];
//    [giftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[giftButton setBackgroundImage:[UIImage imageNamed:@"presentation_c_click.png"] forState:UIControlStateNormal];
	[giftButton setBackgroundImage:[UIImage imageNamed:@"presentation_c_nomal.png"] forState:UIControlStateHighlighted];  
    [giftButton addTarget:self action: @selector(giftButtonClick) forControlEvents:UIControlEventTouchUpInside];  
    [self.view addSubview:giftButton];	
	
	giftedButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 1, 155, 32)];
//    [giftedButton setTitle:@"收到的彩票" forState:UIControlStateNormal];
//    [giftedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[giftedButton setBackgroundImage:[UIImage imageNamed:@"receiver_c_nomal.png"] forState:UIControlStateNormal];
	[giftedButton setBackgroundImage:[UIImage imageNamed:@"receiver_c_click.png"] forState:UIControlStateHighlighted];  
    [giftedButton addTarget:self action: @selector(giftedButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:giftedButton];	
	
    refreshGiftView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, (int)([UIScreen mainScreen].bounds.size.height - 64), 320, REFRESH_HEADER_HEIGHT)];
    [m_scrollView addSubview:refreshGiftView];
    refreshGiftView.myScrollView = m_scrollView;
    [refreshGiftView stopLoading:NO];
    
    refreshGiftedView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, (int)([UIScreen mainScreen].bounds.size.height - 64), 320, REFRESH_HEADER_HEIGHT)];
    [m_giftedScrollView addSubview:refreshGiftedView];
    refreshGiftedView.myScrollView = m_giftedScrollView;
    [refreshGiftedView stopLoading:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryGiftOK:) name:@"queryGiftOK" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLotteryOK:) name:@"receiveLotteryOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];

    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
}


- (void)refreshMySubViews
{
	SBJsonParser *jsonParser = [SBJsonParser new];
	NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
	NSString* totalPage = [parserDict objectForKey:@"totalPage"];
	
	[jsonParser release];
	
	NSArray* dict = (NSArray*)[parserDict objectForKey:@"result"];
	int nCurCount = [dict count];
	
	if(isGift)
	{
        m_giftTotalPageCount = [totalPage intValue];
        m_giftCurPageSize = nCurCount;
        
        GiftDetailView* m_subViewsArray[m_giftCurPageSize];
        for (int i = 0; i < m_giftCurPageSize; i++)
        {
            m_subViewsArray[i] = [[GiftDetailView alloc] initWithFrame:CGRectZero];
            m_subViewsArray[i].supViewController = self;
            [m_scrollView addSubview:m_subViewsArray[i]];
            m_subViewsArray[i].hidden = YES;
        }
        for (int i = 0; i < m_giftCurPageSize; i++)
            [m_subViewsArray[i] release];
        
		for (int i = 0; i < nCurCount; i++)
		{
			NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
			m_subViewsArray[i].toMobileId = KISDictionaryHaveKey(subDict, @"toMobileId");
			m_subViewsArray[i].orderTime = KISDictionaryHaveKey(subDict, @"orderTime");
			double amount = [[subDict objectForKey:@"amount"] doubleValue]/100;
			m_subViewsArray[i].cashAmount = [NSString stringWithFormat:@"%0.0lf", amount];
			m_subViewsArray[i].batchCode = KISDictionaryHaveKey(subDict, @"batchCode");
			m_subViewsArray[i].lotMulti = KISDictionaryHaveKey(subDict, @"lotMulti");
			m_subViewsArray[i].betCodeMsg = KISDictionaryHaveKey(subDict, @"betCodeHtml");
			m_subViewsArray[i].lotNo = KISDictionaryHaveKey(subDict, @"lotNo");
			m_subViewsArray[i].lotName = KISDictionaryHaveKey(subDict, @"lotName");
			m_subViewsArray[i].playType = KISDictionaryHaveKey(subDict, @"play");
//			m_subViewsArray[i].reciveState = [subDict objectForKey:@"reciveState"];
            
            m_subViewsArray[i].orderId = KISDictionaryHaveKey(subDict, @"orderId");
            m_subViewsArray[i].betNum = KISDictionaryHaveKey(subDict, @"betNum");
            m_subViewsArray[i].stateMemo = KISDictionaryHaveKey(subDict, @"stateMemo");
            m_subViewsArray[i].winCode = KISDictionaryHaveKey(subDict, @"winCode");

			m_subViewsArray[i].hidden = NO;
			m_subViewsArray[i].frame = CGRectMake(0, i * kLotWinDetailViewHeight + giftStartY, 320, kLotWinDetailViewHeight);
			[m_subViewsArray[i] refreshView];
		}
		m_scrollView.contentSize = CGSizeMake(320, kLotWinDetailViewHeight * m_giftCurPageSize + giftStartY);
        giftStartY = m_scrollView.contentSize.height;
        
//        giftCenterY = m_scrollView.contentSize.height - (int)([UIScreen mainScreen].bounds.size.height - 64);
        giftCenterY = m_scrollView.contentSize.height - m_scrollView.frame.size.height;
        
        m_giftCurPageIndex++;
        
        if(m_giftCurPageIndex == m_giftTotalPageCount)
        {
            [refreshGiftView stopLoading:YES];
        }
        else
        {
            [refreshGiftView stopLoading:NO];
        }
        [refreshGiftView setRefreshViewFrame];
	}
	else
	{
        m_giftedTotalPageCount = [totalPage intValue];
        m_giftedCurPageSize = nCurCount;

        GiftedDetailView* m_giftedSubViewsArray[m_giftedCurPageSize];
        for (int i = 0; i < m_giftedCurPageSize; i++)
        {
            m_giftedSubViewsArray[i] = [[GiftedDetailView alloc] initWithFrame:CGRectZero];
            m_giftedSubViewsArray[i].supViewController = self;
            [m_giftedScrollView addSubview:m_giftedSubViewsArray[i]];
            m_giftedSubViewsArray[i].hidden = YES;
        }
        for (int i = 0; i < m_giftedCurPageSize; i++)
            [m_giftedSubViewsArray[i] release];
        
		for (int i = 0; i < nCurCount; i++)
		{
			NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
			m_giftedSubViewsArray[i].toMobileId = KISDictionaryHaveKey(subDict, @"giftMobileId");
			m_giftedSubViewsArray[i].orderTime = KISDictionaryHaveKey(subDict, @"orderTime");
			double amount = [[subDict objectForKey:@"amount"] doubleValue]/100;
			m_giftedSubViewsArray[i].cashAmount = [NSString stringWithFormat:@"%0.0lf", amount];
			m_giftedSubViewsArray[i].batchCode = KISDictionaryHaveKey(subDict, @"batchCode");
			m_giftedSubViewsArray[i].lotMulti = KISDictionaryHaveKey(subDict, @"lotMulti");
			m_giftedSubViewsArray[i].betCodeMsg = KISDictionaryHaveKey(subDict, @"betCodeHtml");
			m_giftedSubViewsArray[i].lotNo = KISDictionaryHaveKey(subDict, @"lotNo");
			m_giftedSubViewsArray[i].lotName = KISDictionaryHaveKey(subDict, @"lotName");
			m_giftedSubViewsArray[i].playType = KISDictionaryHaveKey(subDict, @"play");
//            m_giftedSubViewsArray[i].reciveState = [subDict objectForKey:@"reciveState"];
            m_giftedSubViewsArray[i].presentId = KISDictionaryHaveKey(subDict, @"presentId");
            m_giftedSubViewsArray[i].orderId = KISDictionaryHaveKey(subDict, @"orderId");
            m_giftedSubViewsArray[i].betNum = KISDictionaryHaveKey(subDict, @"betNum");
            m_giftedSubViewsArray[i].stateMemo = KISDictionaryHaveKey(subDict, @"stateMemo");
            
            m_giftedSubViewsArray[i].winCode = KISDictionaryHaveKey(subDict, @"winCode");

			m_giftedSubViewsArray[i].hidden = NO;
			m_giftedSubViewsArray[i].frame = CGRectMake(0, i * kGiftedDetailViewHeight + giftedStartY, 320, kGiftedDetailViewHeight);
			[m_giftedSubViewsArray[i] refreshView];
		}
		m_giftedScrollView.contentSize = CGSizeMake(320, kGiftedDetailViewHeight * m_giftedCurPageSize + giftedStartY);

		giftedStartY = m_giftedScrollView.contentSize.height;
        
        giftedCenterY = m_giftedScrollView.contentSize.height - m_giftedScrollView.frame.size.height;
        
        m_giftedCurPageIndex++;
        
        if(m_giftedCurPageIndex == m_giftedTotalPageCount)
        {
            [refreshGiftedView stopLoading:YES];
        }
        else
        {
            [refreshGiftedView stopLoading:NO];
        }
        [refreshGiftedView setRefreshViewFrame];
	}
}

- (void)giftButtonClick
{
	if(!isGift)
	{
		isGift = !isGift;
        
        
        [giftButton setBackgroundImage:[UIImage imageNamed:@"presentation_c_click.png"] forState:UIControlStateNormal];
        [giftButton setBackgroundImage:[UIImage imageNamed:@"presentation_c_nomal.png"] forState:UIControlStateHighlighted];
        [giftedButton setBackgroundImage:[UIImage imageNamed:@"receiver_c_nomal.png"] forState:UIControlStateNormal];
        [giftedButton setBackgroundImage:[UIImage imageNamed:@"receiver_c_click.png"] forState:UIControlStateHighlighted];

		
		//[[RuYiCaiNetworkManager sharedManager] queryGiftOfPage:0  hasGift:YES];

		m_scrollView.hidden = NO;
		m_giftedScrollView.hidden = YES;
	}
}

- (void)giftedButtonClick
{
	if(isGift)
	{
		isGift = !isGift;
        [giftButton setBackgroundImage:[UIImage imageNamed:@"presentation_c_nomal.png"] forState:UIControlStateNormal];
        [giftButton setBackgroundImage:[UIImage imageNamed:@"presentation_c_click.png"] forState:UIControlStateHighlighted];
        [giftedButton setBackgroundImage:[UIImage imageNamed:@"receiver_c_click.png"] forState:UIControlStateNormal];
        [giftedButton setBackgroundImage:[UIImage imageNamed:@"receiver_c_nomal.png"] forState:UIControlStateHighlighted];
		if(isFirst)
		{
            [[RuYiCaiNetworkManager sharedManager] queryGiftOfPage:0 hasGift:NO];
            isFirst = NO;
        }
		
		m_scrollView.hidden = YES;
		m_giftedScrollView.hidden = NO;
	}
}

//- (void)goBack:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)queryGiftOK:(NSNotification *)notification
{
    [self refreshMySubViews];
//	[m_scrollView setContentOffset:CGPointMake(0, 0)];
//	[m_giftedScrollView setContentOffset:CGPointMake(0, 0)];
}

//- (void)receiveLotteryOK:(NSNotification *)notification
//{
//    m_giftedCurPageIndex = 0;
//    giftedStartY = 0;
//    
//    [refreshGiftedView removeFromSuperview];
//    [refreshGiftedView release];
//    
//    [m_giftedScrollView removeFromSuperview];
//    [m_giftedScrollView release];
//    
//    m_giftedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 38, 320, 379)];
//    m_giftedScrollView.scrollEnabled = YES;
//    m_giftedScrollView.delegate = self;
//    [self.view addSubview:m_giftedScrollView];
//    
//    refreshGiftedView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 416, 320, REFRESH_HEADER_HEIGHT)];
//    [m_giftedScrollView addSubview:refreshGiftedView];
//    refreshGiftedView.myScrollView = m_giftedScrollView;
//    [refreshGiftedView stopLoading:NO];
//
//    [[RuYiCaiNetworkManager sharedManager] queryGiftOfPage:0 hasGift:NO];
//}

#pragma make  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(m_scrollView == scrollView)
    {
        if(m_giftCurPageIndex == 0)
        {
            refreshGiftView.viewMaxY = 0;
        }
        else
        {
            refreshGiftView.viewMaxY = giftCenterY;
        }
        [refreshGiftView viewdidScroll:scrollView];
    }
    else
    {
        if(m_giftedCurPageIndex == 0)
        {
            refreshGiftedView.viewMaxY = 0;
        }
        else
        {
            refreshGiftedView.viewMaxY = giftedCenterY;
        }
        [refreshGiftedView viewdidScroll:scrollView];
    }
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(m_scrollView == scrollView)
    {
       [refreshGiftView viewWillBeginDragging:scrollView];
    }
    else
    {
        [refreshGiftedView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(m_scrollView == scrollView)
    {
       [refreshGiftView didEndDragging:scrollView];
    }
    else
    {
        [refreshGiftedView didEndDragging:scrollView];
    }
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(isGift)
    {
        if(m_giftCurPageIndex < m_giftTotalPageCount)
        {
            [[RuYiCaiNetworkManager sharedManager] queryGiftOfPage:m_giftCurPageIndex hasGift:YES];
        }
    }
    else
    {
        if(m_giftedCurPageIndex < m_giftedTotalPageCount)
        {
            [[RuYiCaiNetworkManager sharedManager] queryGiftOfPage:m_giftedCurPageIndex hasGift:NO];
        }
        //[refreshGiftedView stopLoading:NO];
    }
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)netFailed:(NSNotification*)notification
{
	[refreshGiftView stopLoading:NO];
    [refreshGiftedView stopLoading:NO];
}

@end