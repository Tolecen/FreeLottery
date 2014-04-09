//
//  HistoryLotteryViewController.m
//  RuYiCai
//
//  Created by  on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryLotteryViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "PullUpRefreshView.h"
#import "LotteryAwardInfoTableViewCell.h"
#import "NSLog.h"
#import "AdaptationUtils.h"
#define ScrollViewMaxY        (284)

@implementation HistoryLotteryViewController

@synthesize lotNo = m_lotNo;
@synthesize lotTitle = m_lotTitle;
@synthesize lotteryDataArray = m_lotteryDataArray;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLotteryList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    
    [m_lotteryDataArray release], m_lotteryDataArray = nil;
    [refreshView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLotteryList:) name:@"updateLotteryList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];

    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
                                        initWithTitle:@"投注"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(goBack:)];
    self.navigationItem.rightBarButtonItem = okBarButtonItem;
    [okBarButtonItem release];
    
    [self.tableView setRowHeight:70];	
    
     m_curPageIndex = 0;
     m_totalPageCount = 0;
    
     m_lotteryDataArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, 416, 320, REFRESH_HEADER_HEIGHT)];
    [self.tableView addSubview:refreshView];
    refreshView.myScrollView = self.tableView;
    [refreshView stopLoading:NO];
    
    [[RuYiCaiNetworkManager sharedManager] getLotteryInfoList:@"0" lotNo:self.lotNo];
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateLotteryList:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].lotteryInfoList];
    [jsonParser release];
    
    m_totalPageCount = [[parserDict objectForKey:@"totalPage"] intValue];
    
    [self.lotteryDataArray addObjectsFromArray:[parserDict objectForKey:@"result"]];
    
    m_curPageIndex++;
    [self.tableView reloadData];
    
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

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.lotteryDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    LotteryAwardInfoTableViewCell *cell = (LotteryAwardInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
        cell = [[[LotteryAwardInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    
    NSDictionary* subDict = (NSDictionary*)[self.lotteryDataArray objectAtIndex:indexPath.row];
    cell.lotTitle = self.lotTitle;
    cell.batchCode = [subDict objectForKey:@"batchCode"];
    cell.winNo = [subDict objectForKey:@"winCode"];
    cell.dateStr = [subDict objectForKey:@"openTime"];
    [cell refresh];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        refreshView.viewMaxY = self.tableView.contentSize.height - self.tableView.frame.size.height;
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
    if(m_curPageIndex <= m_totalPageCount)//从1开始记录页码
    {
        [[RuYiCaiNetworkManager sharedManager] getLotteryInfoList:[NSString stringWithFormat:@"%d", (m_curPageIndex + 1)] lotNo:self.lotNo];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

@end
