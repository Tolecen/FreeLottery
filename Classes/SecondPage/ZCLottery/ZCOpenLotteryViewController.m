//
//  ZCOpenLotteryViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-3.
//
//

#import "ZCOpenLotteryViewController.h"
#import "AnimationTabView.h"
#import "PullUpRefreshView.h"
#import "RuYiCaiNetworkManager.h"
#import "LotteryAwardInfoTableViewCell.h"
#import "HistoryLotDetailViewController.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kSFCtabKey  0
#define kRXJtabKey  1
#define kJQCtabKey  2
#define kLCBtabKey  3

@interface ZCOpenLotteryViewController ()

- (void)updateLotteryList:(NSNotification*)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;

@end

@implementation ZCOpenLotteryViewController
@synthesize animationTabView = m_animationTabView;
@synthesize myTableView = m_myTableView;
@synthesize lotteryDataArray = m_lotteryDataArray;
@synthesize segmentedView = _segmentedView;
@synthesize isPushShow = m_isPushShow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (id)init{
    if(self = [super init]){
//        _scene = WXSceneSession;
    }
    return self;
}

- (void)dealloc
{
    [m_animationTabView release], m_animationTabView = nil;
    [m_myTableView release], m_myTableView = nil;
    [m_lotteryDataArray release], m_lotteryDataArray = nil;
    [refreshView release], refreshView = nil;
    [_segmentedView release];
    [super dealloc];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateLotteryList" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLotteryList:) name:@"updateLotteryList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(goToBack) andAutoPopView:NO];
    
    self.title = @"足彩开奖中心";
    
//    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
//    [m_animationTabView.buttonNameArray addObject:@"胜负彩"];
//    [m_animationTabView.buttonNameArray addObject:@"任选九"];
//    [m_animationTabView.buttonNameArray addObject:@"进球彩"];
//    [m_animationTabView.buttonNameArray addObject:@"六场半"];
//    [m_animationTabView setMainButton];
//    [self.view addSubview:m_animationTabView];
    
    self.segmentedView = [[[CustomSegmentedControl alloc]
                          initWithFrame:CGRectMake(10, 5, 300, 30)
                        andNormalImages:[NSArray arrayWithObjects:
                                         @"zc_c_sfc_nomal.png",
                                         @"zc_c_rxj_nomal.png",
                                         @"zc_c_jqs_nomal.png",
                                         @"zc_c_lcb_nomal.png",
                                         nil]
                   andHighlightedImages:[NSArray arrayWithObjects:
                                         @"zc_c_sfc_nomal.png",
                                         @"zc_c_rxj_nomal.png",
                                         @"zc_c_jqs_nomal.png",
                                         @"zc_c_lcb_nomal.png",
                                         nil]
                         andSelectImage:[NSArray arrayWithObjects:
                                         @"zc_c_sfc_click.png",
                                         @"zc_c_rxj_click.png",
                                         @"zc_c_jqs_click.png",
                                         @"zc_c_lcb_click.png",
                                         nil]]autorelease];
    self.segmentedView.delegate = self;
    self.segmentedView.segmentedIndex = 0;
    [self.view addSubview:_segmentedView];
    
    m_lotteryDataArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_curPageIndex = 0;

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, (int)[UIScreen mainScreen].bounds.size.height - 110)];
	[self.myTableView setRowHeight:90];
	[self.myTableView setBackgroundColor:[UIColor clearColor]];
    self.myTableView.delegate = self;
    self.myTableView.dataSource=self;
    [self.view addSubview:m_myTableView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 95, 320, REFRESH_HEADER_HEIGHT)];
    [self.myTableView addSubview:refreshView];
    refreshView.myScrollView = self.myTableView;
    [refreshView stopLoading:NO];
    
//    [[RuYiCaiNetworkManager sharedManager] getLotteryInfoList:@"0" lotNo:kLotNoSFC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tabButtonChanged:(NSNotification*)notification
{
    NSString*  curLotNo = @"";
    switch (self.segmentedView.segmentedIndex)
    {
        case kSFCtabKey:
            curLotNo = kLotNoSFC;
            break;
        case kRXJtabKey:
            curLotNo = kLotNoRX9;
            break;
        case kJQCtabKey:
            curLotNo = kLotNoJQC;
            break;
        case kLCBtabKey:
            curLotNo = kLotNoLCB;
            break;
        default:
            break;
    }
    m_curPageIndex = 0;
    [self.lotteryDataArray removeAllObjects];

    [[RuYiCaiNetworkManager sharedManager] getLotteryInfoList:@"0" lotNo:curLotNo];
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
    [self.myTableView reloadData];
    
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

#pragma mark -
#pragma mark tableView delegate

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
    switch (self.segmentedView.segmentedIndex)
    {
        case kSFCtabKey:
            cell.lotTitle = kLotTitleSFC;
            break;
        case kRXJtabKey:
            cell.lotTitle = kLotTitleRX9;
            break;
        case kJQCtabKey:
            cell.lotTitle = kLotTitleJQC;
            break;
        case kLCBtabKey:
            cell.lotTitle = kLotTitle6CB;
            break;
        default:
            break;
    }
    cell.batchCode = KISDictionaryHaveKey(subDict, @"batchCode");
    cell.winNo = KISDictionaryHaveKey(subDict ,@"winCode");
    cell.dateStr = KISDictionaryHaveKey(subDict ,@"openTime");
    [cell refresh];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //网络数据获取完整才能点击
    if (self.lotteryDataArray && [self.lotteryDataArray count]>0) {
        
        [self setHidesBottomBarWhenPushed:YES];
        NSDictionary* subDict = (NSDictionary*)[self.lotteryDataArray objectAtIndex:indexPath.row];
        
        HistoryLotDetailViewController*   viewController = [[HistoryLotDetailViewController alloc] init];
        viewController.delegate = self;
        viewController.batchCode = [subDict objectForKey:@"batchCode"];
        switch (self.segmentedView.segmentedIndex)
        {
            case kSFCtabKey:
                viewController.lotTitle = kLotTitleSFC;
                viewController.lotNo = kLotNoSFC;
                break;
            case kRXJtabKey:
                viewController.lotTitle = kLotTitleRX9;
                viewController.lotNo = kLotNoRX9;
                break;
            case kJQCtabKey:
                viewController.lotTitle = kLotTitleJQC;
                viewController.lotNo = kLotNoJQC;
                break;
            case kLCBtabKey:
                viewController.lotTitle = kLotTitle6CB;
                viewController.lotNo = kLotNoLCB;
                break;
            default:
                break;
        }
        //    viewController.title = [NSString stringWithFormat:@"%@开奖详情",[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:viewController.lotNo]];
        
        viewController.title = @"足彩开奖中心";
        
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    
    
    
}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.myTableView)
    {
//        NSLog(@"%f", scrollView.contentOffset.y);
        if(m_curPageIndex == 0)
        {
            refreshView.viewMaxY = 0;
        }
        else
        {
            refreshView.viewMaxY = m_myTableView.contentSize.height - m_myTableView.frame.size.height;
        }
        [refreshView viewdidScroll:scrollView];
    }
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self.myTableView)
    {
        [refreshView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == self.myTableView)
    {
        [refreshView didEndDragging:scrollView];
    }
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(m_curPageIndex <= m_totalPageCount)//从1开始记录页码
    {
        NSString*  curLotNo = @"";
        switch (self.segmentedView.segmentedIndex)
        {
            case kSFCtabKey:
                curLotNo = kLotNoSFC;
                break;
            case kRXJtabKey:
                curLotNo = kLotNoRX9;
                break;
            case kJQCtabKey:
                curLotNo = kLotNoJQC;
                break;
            case kLCBtabKey:
                curLotNo = kLotNoLCB;
                break;
            default:
                break;
        }

        [[RuYiCaiNetworkManager sharedManager] getLotteryInfoList:[NSString stringWithFormat:@"%d", (m_curPageIndex + 1)] lotNo:curLotNo];
    }
}

- (void)netFailed:(NSNotification*)notification
{
    [self.lotteryDataArray removeAllObjects];
    [self.myTableView reloadData];
	[refreshView stopLoading:NO];
}

#pragma mark customerSegmentedView delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabButtonChanged" object:nil];

    
//    NSString*  curLotNo = @"";
//    switch (index)
//    {
//        case kSFCtabKey:
//            curLotNo = kLotNoSFC;
//            break;
//        case kRXJtabKey:
//            curLotNo = kLotNoRX9;
//            break;
//        case kJQCtabKey:
//            curLotNo = kLotNoJQC;
//            break;
//        case kLCBtabKey:
//            curLotNo = kLotNoLCB;
//            break;
//        default:
//            break;
//    }
//
//    [[RuYiCaiNetworkManager sharedManager] getLotteryInfoList:@"0" lotNo:curLotNo];
    
}
- (void)goToBack
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
