//
//  QueryLotBetViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryLotBetViewController.h"
#import "RYCImageNamed.h"
#import "UserLotBetDetailView.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "PullUpRefreshView.h"
#import "Custom_tabbar.h"
#import "BackBarButtonItemUtils.h"
#import "SelecterView.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kLotWinDetailViewHeight (80)

//#define REFRESH_HEADER_HEIGHT 52.0f

@interface QueryLotBetViewController (internal)

- (void)refreshMySubViews;
- (void)setMainViewAgian;

- (void)queryLotBetOK:(NSNotification *)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;
- (void)betCompleteOK:(NSNotification*)notification;

- (void)selectLotButtonClick;

- (void)viewBackNotification:(NSNotification*)notification;

//彩种选择
- (void)selectPressEventUser:(NSNotification*)notification;

@end

@implementation QueryLotBetViewController
@synthesize selectLotNo = m_selectLotNo;
@synthesize isPushShow  = m_isPushShow;

- (void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryLotBetOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectPressEventUser" object:nil];
	[m_pageIndexLabel release];
    [m_scrollView release];
    [refreshView release];
    [m_selectLotNo release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    
    if ([m_selectLotNo isEqualToString:kLotNoNMK3]) {
        //快三返回按钮
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
    }else{
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPressEventUser:) name:@"selectPressEventUser" object:nil];
    //相当于UITableViewCell,当发通知时进行cell的定制
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryLotBetOK:) name:@"queryLotBetOK" object:nil];
    //相当于UITableViewCell
    
    m_totalPageCount = 0;
    m_curPageIndex = 0;
    m_curPageSize = 0;
    startY = 0;
    centerY = 0;
    
    m_selectScrollViewScroll = FALSE;
    
    if (!m_isComeFromBetView) {
        
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(selectLotButtonClick) andTitle:@"筛选"];
    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    
    
}


- (void)setMainViewAgian
{
    m_curPageIndex = 0;
    startY = 0;
    centerY = 0;
    m_totalPageCount = 1;//为了无记录时选择彩种后可以有请求
    
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
    
    for (int i = 0; i < nCurCount; i++)
    {
        //投注 查询详情，cell定制（view即自定义cell）
        UserLotBetDetailView* subview  = [[[UserLotBetDetailView alloc] initWithFrame:CGRectZero] autorelease];
        subview.delegate = self;
        subview.hidden = YES;
        
        NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
        subview.lotNo = KISDictionaryHaveKey(subDict, @"lotNo");
        subview.lotName = KISDictionaryHaveKey(subDict, @"lotName");
        subview.betCode = KISDictionaryHaveKey(subDict, @"orderInfo");
        //        subview.betCode = KISDictionaryHaveKey(subDict, @"bet_code");
        //        subview.betCodeMsg = [subDict objectForKey:@"betCode"];//老字段
        //        subview.betCodeHtmlMsg = KISDictionaryHaveKey(subDict, @"betCodeHtml");//webView
        subview.cashAmount = [NSString stringWithFormat:@"%0.0lf", [[subDict objectForKey:@"amount"] doubleValue]/100];
        subview.prizeAmount = [NSString stringWithFormat:@"%0.2lf", [[subDict objectForKey: @"prizeAmt"] doubleValue]/100.0];
        subview.lotMulti = KISDictionaryHaveKey(subDict, @"lotMulti");
        //        subview.playType = KISDictionaryHaveKey(subDict, @"play");
        subview.batchCode = KISDictionaryHaveKey(subDict, @"batchCode");
        subview.orderTime = KISDictionaryHaveKey(subDict, @"orderTime");
        subview.winCode = KISDictionaryHaveKey(subDict, @"winCode");
        subview.isRepeatBuy = KISDictionaryHaveKey(subDict, @"isRepeatBuy");
        subview.prizeState = KISDictionaryHaveKey(subDict, @"prizeState");
        subview.orderId = KISDictionaryHaveKey(subDict, @"orderId");
        subview.betNum = KISDictionaryHaveKey(subDict, @"betNum");
        subview.stateMemo = KISDictionaryHaveKey(subDict, @"stateMemo");
        subview.oneAmount = KISDictionaryHaveKey(subDict, @"oneAmount");
        //暂时添加 竞彩
        if ([subview.lotNo isEqualToString:kLotNoJCLQ_SF] ||
            [subview.lotNo isEqualToString:kLotNoJCLQ_RF] ||
            [subview.lotNo isEqualToString:kLotNoJCLQ_SFC] ||
            [subview.lotNo isEqualToString:kLotNoJCLQ_DXF] ||
            [subview.lotNo isEqualToString:kLotNoJCLQ_CONFUSION] ||
            
            [subview.lotNo isEqualToString:kLotNoJCZQ_SPF] ||
            [subview.lotNo isEqualToString:kLotNoJCZQ_RQ_SPF] ||
            [subview.lotNo isEqualToString:kLotNoJCZQ_ZJQ] ||
            [subview.lotNo isEqualToString:kLotNoJCZQ_SCORE] ||
            [subview.lotNo isEqualToString:kLotNoJCZQ_HALF] ||
            [subview.lotNo isEqualToString:kLotNoJCZQ_CONFUSION] ||
            
            [subview.lotNo isEqualToString:kLotNoJQC]||
            [subview.lotNo isEqualToString:kLotNoSFC]||
            [subview.lotNo isEqualToString:kLotNoRX9]||
            [subview.lotNo isEqualToString:kLotNoLCB]||
            
            [subview.lotNo isEqualToString:kLotNoBJDC_RQSPF]||
            [subview.lotNo isEqualToString:kLotNoBJDC_JQS]||
            [subview.lotNo isEqualToString:kLotNoBJDC_Score]||
            [subview.lotNo isEqualToString:kLotNoBJDC_HalfAndAll]||
            [subview.lotNo isEqualToString:kLotNoBJDC_SXDS]
            )
        {
            subview.showInTable = YES;
            //            NSLog(@"%@",[subDict objectForKey:@"betCodeJson"]);
            if ([subDict objectForKey:@"betCodeJson"] != [NSNull null]) {
                subview.betCodeJson = [subDict objectForKey:@"betCodeJson"];
            }
        }
        else
            subview.showInTable = NO;
        
        subview.hidden = NO;
        subview.frame = CGRectMake(0, i * kLotWinDetailViewHeight + startY, 320, kLotWinDetailViewHeight);
        [subview refreshView];
        [m_scrollView addSubview:subview];
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

- (void)queryLotBetOK:(NSNotification *)notification
{
    NSObject *obj = [notification object];
    NSLog(@"obj,%@",obj);
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
            //cell定制函数
            [self refreshMySubViews];
    }
}

- (void)selectPressEventUser:(NSNotification*)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary*)obj;
        m_selectLotNo = [dict objectForKey:@"selectValue"];
        if ([m_selectLotNo length] > 0) {
            isSingleLot = TRUE;
        }
        else
            isSingleLot = FALSE;
        
        [self setMainViewAgian];
        
        [self startRefresh:nil];
    }
}
- (void)selectLotButtonClick
{
    
    SelecterView* view = [[SelecterView alloc] init];
    view.isUserEvent = YES;
    //    NSArray *LotNamesArray = [NSArray arrayWithObjects:@"全部彩种",@"双色球", @"七乐彩", @"福彩3D"
    //                         , @"快三", @"江西11选5", @"广东11选5",@"广东快乐十分", @"时时彩",@"大乐透",@"排列三",@"七星彩"
    //                         ,@"排列五"/*,@"进球彩",@"足彩六场半",@"足彩胜负彩"
    //                         ,@"足彩任选九"*/,@"足彩",@"十一运夺金",@"22选5"
    //                         ,@"竞彩篮球"
    //                         ,@"竞彩足球", @"北京单场", nil];
    //
    //    NSArray *LotNoArray = [NSArray arrayWithObjects:@"",@"F47104", @"F47102", @"F47103", kLotNoNMK3,@"T01010", @"T01014"   ,@"T01015"
    //                           , @"T01007",@"T01001",@"T01002",@"T01009"
    //                           ,@"T01011"/*,@"T01005",@"T01006",@"T01003"
    //                           ,@"T01004"*/,kLotNoZC,@"T01012" ,@"T01013"
    //                           ,@"JC_L"
    //                           ,@"JC_Z", kLotNoBJDC,nil];
    //
    //    for (int a = 0; a < [LotNamesArray count]; a++) {
    //        [view appendSelectArray:[LotNoArray objectAtIndex:a] TITLE:[LotNamesArray objectAtIndex:a]];
    //    }
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotShowDicKey];
    NSMutableArray* showLotArray;
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotShowDicKey];
        showLotArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        showLotArray = [[NSMutableArray alloc] initWithArray:mutableArr];
    }
    [view appendSelectArray:@"" TITLE:@"全部彩种"];
    for(int i = 0; i < [showLotArray count]; i ++)
    {
        NSString*  lotTitle = [[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0];
        NSString*  lotNo = [[CommonRecordStatus commonRecordStatusManager] lotNoWithLotTitle:lotTitle];
        
        if (![lotNo isEqualToString:@""] && ![[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"3"])
            [view appendSelectArray:lotNo TITLE:[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:lotNo]];
    }
    [self.navigationController pushViewController:view animated:YES];
    [view release];
}

- (void)betCompleteOK:(NSNotification*)notification
{
    [self setMainViewAgian];
    
    [self startRefresh:nil];
}

#pragma mark --



#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // NSLog(@"%f", scrollView.contentOffset.y);
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
    [refreshView stopLoading:NO];
    
    if (m_selectScrollViewScroll) {
        return;
    }
    if(m_curPageIndex < m_totalPageCount)
    {
        if (m_isComeFromBetView) {
            [[RuYiCaiNetworkManager sharedManager] queryLotBetOfPage:m_curPageIndex lotNo:m_selectLotNo];
            return;
        }
        
        if (isSingleLot) {
            [[RuYiCaiNetworkManager sharedManager] queryLotBetOfPage:m_curPageIndex lotNo:m_selectLotNo];
        }
        else
            [[RuYiCaiNetworkManager sharedManager] queryLotBetOfPage:m_curPageIndex lotNo:@""];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

- (void) setSelectLotNo:(NSString*) lotNo
{
    m_isComeFromBetView = TRUE;
    m_selectLotNo = lotNo;
}

- (void)back:(id)sender
{
    if (m_isPushShow)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end