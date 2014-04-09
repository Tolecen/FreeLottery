//
//  LeaveMessageViewController.m
//  RuYiCai
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeaveMessageViewController.h"
#import "NSLog.h"
#import "RuYiCaiNetworkManager.h"
#import "LeaveMessageView.h"
#import "SBJsonParser.h"
#import "RYCImageNamed.h"
#import "LeaveMessageReplyViewController.h"
#import "PullUpRefreshView.h"
#import "Custom_tabbar.h"
#import "FeedBackViewController.h"
#import "AnimationTabView.h"
#import "InLetterContentViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation LeaveMessageViewController

@synthesize dataArray = m_dataArray;
@synthesize inLetterDataArr = m_inLetterDataArr;
@synthesize leaveMessageBtn = m_leaveMessageBtn;
@synthesize stackMessageBtn = m_stackMessageBtn;


- (void)dealloc
{
    [m_leaveMessageBtn release];
    [m_stackMessageBtn release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leaveMessageOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"feedBackOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];

    m_myTable.delegate = nil;
    [m_myTable release], m_myTable = nil;
    [refreshView release], refreshView = nil;
    [m_dataArray release], m_dataArray = nil;
    
    m_inLetterTableView.delegate = nil;
    [m_inLetterTableView release], m_inLetterTableView = nil;
    [m_inLetterDataArr release], m_inLetterDataArr = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveMessageOK:) name:@"leaveMessageOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackOK:) name:@"feedBackOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];

//    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
//    [m_animationTabView.buttonNameArray addObject:@"我的留言"];
//    [m_animationTabView.buttonNameArray addObject:@"站内信"];
//    [m_animationTabView setMainButton];
//    [self.view addSubview:m_animationTabView];
    
    
    UIView *topViewBg = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 31)];
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topall_c_bg.png"]];
    
    topImageView.frame = CGRectMake(2, 2, 296, 27);
    [topViewBg addSubview:topImageView];
    [topImageView release];
    [self.view addSubview:topViewBg];
    [topViewBg release];
    
    
    topButtonIndex = 0;
    m_leaveMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 31)];
    
    [m_leaveMessageBtn setBackgroundImage:RYCImageNamed(@"leaveMessageClick.png") forState:UIControlStateNormal];
    [m_leaveMessageBtn setBackgroundImage:RYCImageNamed(@"leaveMessageNomal.png") forState:UIControlStateHighlighted];
    [m_leaveMessageBtn addTarget:self action:@selector(leaveMessageClick) forControlEvents:UIControlEventTouchUpInside];
    
    m_stackMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, 150, 31)];
    [m_stackMessageBtn setBackgroundImage:RYCImageNamed(@"stackMessage_nomal.png") forState:UIControlStateNormal];
    [m_stackMessageBtn setBackgroundImage:RYCImageNamed(@"stackMessage_click.png") forState:UIControlStateHighlighted];
    [m_stackMessageBtn addTarget:self action:@selector(stackMessageClick) forControlEvents:UIControlEventTouchUpInside];
    
    [topViewBg addSubview:self.leaveMessageBtn];
    [topViewBg addSubview:self.stackMessageBtn];
    
    UIButton* bgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 115, 320, 55)];
    bgButton.backgroundColor = [UIColor clearColor];
    [bgButton setBackgroundImage:RYCImageNamed(@"hm_bottom_bg.png") forState:UIControlStateNormal];
    bgButton.enabled = NO;
    [self.view addSubview:bgButton];
    [bgButton release];
    
    m_dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    m_myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 120 - 40)];
    m_myTable.delegate = self;
    m_myTable.dataSource = self;
    m_myTable.rowHeight = 70;
    [self.view addSubview:m_myTable];
    
    m_inLetterDataArr = [[NSMutableArray alloc] initWithCapacity:5];
    m_inLetterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, [UIScreen mainScreen].bounds.size.height - 120 - 40)];
    m_inLetterTableView.delegate = self;
    m_inLetterTableView.dataSource = self;
    m_inLetterTableView.rowHeight = 40;
    m_inLetterTableView.hidden = YES;
    [self.view addSubview:m_inLetterTableView];
    
    UIButton* feedBackButton = [[UIButton alloc] initWithFrame:CGRectMake(99, [UIScreen mainScreen].bounds.size.height - 104, 123, 34)];
    feedBackButton.backgroundColor = [UIColor clearColor];
    [feedBackButton setTitle:@"我要反馈" forState:UIControlStateNormal];
    
    feedBackButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [feedBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feedBackButton setBackgroundImage:RYCImageNamed(@"commit_c_wznomal.png") forState:UIControlStateNormal];
    [feedBackButton setBackgroundImage:RYCImageNamed(@"commit_c_wzclick.png") forState:UIControlStateHighlighted];
    [feedBackButton addTarget:self action:@selector(feedBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedBackButton];
    [feedBackButton release];
    
    m_inLetterCurPageIndex = 0;
    inLetterRefreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, m_inLetterTableView.frame.size.height, 320, REFRESH_HEADER_HEIGHT)];
    [m_inLetterTableView addSubview:inLetterRefreshView];
    inLetterRefreshView.myScrollView = m_inLetterTableView;
    [inLetterRefreshView stopLoading:NO];
    
    m_curPageIndex = 0;
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, m_myTable.frame.size.height, 320, REFRESH_HEADER_HEIGHT)];
    [m_myTable addSubview:refreshView];
    refreshView.myScrollView = m_myTable;
    [refreshView stopLoading:NO];
    
    [[RuYiCaiNetworkManager sharedManager] queryLeaveMessage:@"0"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
}

- (void)setRefreshViewFrame
{
    if( m_myTable.contentSize.height > m_myTable.frame.size.height)
    {
        refreshView.frame = CGRectMake(0, m_myTable.contentSize.height , 320, REFRESH_HEADER_HEIGHT);
    }
    else
    {
        refreshView.frame = CGRectMake(0, m_myTable.frame.size.height , 320, REFRESH_HEADER_HEIGHT);
    }
}

- (void)leaveMessageOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [self.dataArray addObjectsFromArray:[parserDict objectForKey:@"result"]];
    [jsonParser release];
    
    m_totalPageCount = [[parserDict objectForKey:@"totalPage"] intValue];
   
    m_curPageIndex++;

    [m_myTable reloadData];
    
    if(m_curPageIndex == m_totalPageCount)
    {
       [refreshView stopLoading:YES];
    }
    else
    {
        [refreshView stopLoading:NO];
    }
    [self setRefreshViewFrame];
} 

- (void)feedBackButtonClick
{
    FeedBackViewController* viewController = [[FeedBackViewController alloc] init];
    viewController.title = @"留言反馈";
    viewController.isPushHid = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)feedBackOK:(NSNotification *)notification
{
    m_curPageIndex = 0;
    [self.dataArray removeAllObjects];
    
    [[RuYiCaiNetworkManager sharedManager] queryLeaveMessage:[NSString stringWithFormat:@"%d", m_curPageIndex]];
}

- (void)leaveMessageClick
{
    
    if (topButtonIndex!=0)
    {
        topButtonIndex=0;
        m_myTable.hidden = NO;
        m_inLetterTableView.hidden = YES;
        [m_leaveMessageBtn setBackgroundImage:RYCImageNamed(@"leaveMessageClick.png") forState:UIControlStateNormal];
        [m_leaveMessageBtn setBackgroundImage:RYCImageNamed(@"leaveMessageNomal.png") forState:UIControlStateHighlighted];
        [m_stackMessageBtn setBackgroundImage:RYCImageNamed(@"stackMessage_nomal.png") forState:UIControlStateNormal];
        [m_stackMessageBtn setBackgroundImage:RYCImageNamed(@"stackMessage_click.png") forState:UIControlStateHighlighted];
    }
}
- (void)stackMessageClick
{
    if (topButtonIndex!=1)
    {
        topButtonIndex=1;
        
        [m_leaveMessageBtn setBackgroundImage:RYCImageNamed(@"leaveMessageNomal.png") forState:UIControlStateNormal];
        [m_leaveMessageBtn setBackgroundImage:RYCImageNamed(@"leaveMessageClick.png") forState:UIControlStateHighlighted];
        [m_stackMessageBtn setBackgroundImage:RYCImageNamed(@"stackMessage_click.png") forState:UIControlStateNormal];
        [m_stackMessageBtn setBackgroundImage:RYCImageNamed(@"stackMessage_nomal.png") forState:UIControlStateHighlighted];
        m_myTable.hidden = YES;
        m_inLetterTableView.hidden = NO;
        if([self.inLetterDataArr count] == 0)
        {
            NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
            [tempDic setObject:@"letter" forKey:@"command"];
            [tempDic setObject:@"list" forKey:@"requestType"];
            [tempDic setObject:@"10" forKey:@"maxresult"];
            [tempDic setObject:@"0" forKey:@"pageindex"];
            [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
            
            [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
            [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
        }
    }
}




#pragma mark 切换
- (void)tabButtonChanged:(NSNotification *)notification
{
    m_myTable.hidden = NO;
    m_inLetterTableView.hidden = YES;
    
//    switch (m_animationTabView.selectButtonTag) {
//        case 0:
//        {
//            m_myTable.hidden = NO;
//            m_inLetterTableView.hidden = YES;
//        }break;
//        case 1:
//        {
//            m_myTable.hidden = YES;
//            m_inLetterTableView.hidden = NO;
//            if([self.inLetterDataArr count] == 0)
//            {
//                NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
//                [tempDic setObject:@"letter" forKey:@"command"];
//                [tempDic setObject:@"list" forKey:@"requestType"];
//                [tempDic setObject:@"10" forKey:@"maxresult"];
//                [tempDic setObject:@"0" forKey:@"pageindex"];
//                [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
//                
//                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
//                [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
//            }
//        }break;
//        default:
//            break;
//    }
}

#pragma mark 站内信
- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    
    [self.inLetterDataArr addObjectsFromArray:[parserDict objectForKey:@"result"]];
    m_inLetterTotalPageCount = [[parserDict objectForKey:@"totalPage"] intValue];
    
    m_inLetterCurPageIndex++;
    
    [m_inLetterTableView reloadData];
    
    if(m_inLetterCurPageIndex == m_inLetterTotalPageCount)
    {
        [inLetterRefreshView stopLoading:YES];
    }
    else
    {
        [inLetterRefreshView stopLoading:NO];
    }
    [inLetterRefreshView setRefreshViewFrame];
}

#pragma mark table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if(m_myTable == table)
        return [self.dataArray count];
    else
        return [self.inLetterDataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(tableView == m_myTable)
    {
        static NSString *myIdentifier = @"MyIdentifier";
        LeaveMessageView *cell = (LeaveMessageView*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
        if (cell == nil)
            cell = [[[LeaveMessageView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //cell.textLabel.font = [UIFont boldSystemFontOfSize:16];

        cell.creatTime = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"createTime"];
        cell.content = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];

        [cell refreshView];
        
        return cell;
    }
    else
    {
        static NSString *myIdentifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
        if (cell == nil)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [[self.inLetterDataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setHidesBottomBarWhenPushed:YES];
    
    if(m_myTable == tableView)
    {
        LeaveMessageReplyViewController *viewController = [[LeaveMessageReplyViewController alloc] init];
        viewController.navigationItem.title = @"留言回复";
        viewController.rowIndex = indexPath.row;
        viewController.contentArray = self.dataArray;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else
    {
        [[m_inLetterTableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[UIColor redColor]];

        InLetterContentViewController *viewController = [[InLetterContentViewController alloc] init];
        viewController.inTitle = [[self.inLetterDataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
        viewController.content = [[self.inLetterDataArr objectAtIndex:indexPath.row] objectForKey:@"content"];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView viewWillBeginDragging:scrollView];
    
//    switch (m_animationTabView.selectButtonTag)
//    {
//        case 0:
//            [refreshView viewWillBeginDragging:scrollView];
//            break;
//        case 1:
//            [inLetterRefreshView viewWillBeginDragging:scrollView];
//            break;
//        default:
//            break;
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    
    if(m_curPageIndex == 0)
    {
        refreshView.viewMaxY = 0 ;
    }
    else
    {
        refreshView.viewMaxY = m_myTable.contentSize.height - m_myTable.frame.size.height;
        
    }
    [refreshView viewdidScroll:scrollView];
    
//    switch (m_animationTabView.selectButtonTag)
//    {
//        case 0:
//        {
//            if(m_curPageIndex == 0)
//            {
//                refreshView.viewMaxY = 0 ;
//            }
//            else
//            {
//                refreshView.viewMaxY = m_myTable.contentSize.height - m_myTable.frame.size.height;
//                
//            }
//            [refreshView viewdidScroll:scrollView];
//        }break;
//        case 1:
//        {
//            if(m_inLetterCurPageIndex == 0)
//            {
//                inLetterRefreshView.viewMaxY = 0 ;
//            }
//            else
//            {
//                inLetterRefreshView.viewMaxY = m_inLetterTableView.contentSize.height - m_inLetterTableView.frame.size.height;
//                
//            }
//            [inLetterRefreshView viewdidScroll:scrollView];
//        }break;
//        default:
//            break;
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView didEndDragging:scrollView];
    
//    switch (m_animationTabView.selectButtonTag)
//    {
//        case 0:
//            [refreshView didEndDragging:scrollView];
//            break;
//        case 1:
//            [inLetterRefreshView didEndDragging:scrollView];
//            break;
//        default:
//            break;
//    }
}

- (void)startRefresh:(NSNotification *)notification
{
    
    if(m_curPageIndex <= m_totalPageCount)
    {
        [[RuYiCaiNetworkManager sharedManager] queryLeaveMessage:[NSString stringWithFormat:@"%d", m_curPageIndex]];
    }
//    
//    switch (m_animationTabView.selectButtonTag)
//    {
//        case 0:
//            if(m_curPageIndex <= m_totalPageCount)
//            {
//                [[RuYiCaiNetworkManager sharedManager] queryLeaveMessage:[NSString stringWithFormat:@"%d", m_curPageIndex]];
//            }
//            break;
//        case 1:
//            if(m_inLetterCurPageIndex <= m_inLetterTotalPageCount)
//            {
//                NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
//                [tempDic setObject:@"letter" forKey:@"command"];
//                [tempDic setObject:@"list" forKey:@"requestType"];
//                [tempDic setObject:@"10" forKey:@"maxresult"];
//                [tempDic setObject:[NSString stringWithFormat:@"%d", m_inLetterCurPageIndex] forKey:@"pageindex"];
//                [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
//                
//                [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
//                [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
//            }
//            break;
//        default:
//            break;
//    }
}


- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

@end
