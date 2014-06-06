    //
//  HMDTGroupByViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-10-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HMDTGroupByViewController.h"
#import "RuYiCaiCommon.h"
#import "HMDTGroupByCellView.h"
#import "RYCImageNamed.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "PullUpRefreshView.h"
#import "NSLog.h"
#import "SelecterView.h"
#import "Custom_tabbar.h"
#import "UINavigationBarCustomBg.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface HMDTGroupByViewController (internal)


 
- (void)selectLotButtonClick;
- (void)selectPressEvent:(NSNotification*)notification;
 

- (void)danjiaClick:(id)sender;
- (void)jinduClick:(id)sender;
- (void)zongeClick:(id)sender;
- (void)sortClick:(id)sender;
- (void)setupQueryAllCaseLot:(NSInteger)pageIndex;
- (void)queryAllCaseLotOK:(NSNotification*)notification;
- (void)refreshCurPage:(NSNotification*)notification;
- (void)betCaseLotOKClick:(NSNotification*)notification;

- (void)refreshMySubViews;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;

- (void)setNewScrollView;

@end

@implementation HMDTGroupByViewController
 
@synthesize selectLotNo = m_selectLotNo;
@synthesize segmented;
@synthesize typeOrder;
@synthesize isFilter = m_isFilter;

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"he------");
    [self setHidesBottomBarWhenPushed:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshCurPage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryAllCaseLotOK" object:nil];

    
 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCaseLotOKClick" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
     NSLog(@"qiu------");
    [self setHidesBottomBarWhenPushed:YES];
    [super viewDidDisappear:animated];
}
- (void)viewWillUnload
{
    NSLog(@"shi------");
    [self setHidesBottomBarWhenPushed:YES];
    [super viewWillUnload];
}
- (void)dealloc
{
 //这个通知不能放到其他方法里面，不然回导致不执行selectPressEvent方法
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectPressEvent" object:nil];
    [m_isFilter release];
	[m_scrollView release];
    
    [m_resultDict release], m_resultDict = nil;
    [m_danjiaButton release];
    [m_jinduButton release];
    [m_zongeButton release];
    [m_groupOrderButton release];
    [segmented release];
 
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
//        _scene = WXSceneSession;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"1111------");
    [self.navigationController.navigationBar setBackground];
    [self.navigationItem setTitle:@"合买大厅"];
    self.navigationItem.title = @"合买大厅";
    [AdaptationUtils adaptation:self];
    
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(selectLotButtonClick) andTitle:@"筛选"];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPressEvent:) name:@"selectPressEvent" object:nil];
    self.segmented = [[[CustomSegmentedControl alloc]
                                         initWithFrame:CGRectMake(10, 7, 264, 30)
                                         andNormalImages:[NSArray arrayWithObjects:@"hm_jindu_order_normal.png",@"hm_zonge_order_normal.png",@"hm_renqi_order_normal.png", nil]
                                         andHighlightedImages:[NSArray arrayWithObjects:@"hm_jindu_order_normal.png",@"hm_zonge_order_normal.png",@"hm_renqi_order_normal.png", nil]
                                         andSelectImage:[NSArray arrayWithObjects:@"hm_jindu_order_click.png",@"hm_zonge_order_click.png",@"hm_renqi_order_click.png", nil]]autorelease];
    
    segmented.delegate = self;
    [self.view addSubview:segmented];
    
    m_upOrder = NO;
    m_groupOrderButton = [[UIButton alloc] initWithFrame:CGRectMake(283, 7, 30, 30)];
    [m_groupOrderButton setBackgroundImage:[UIImage imageNamed:@"group_c_down.png"] forState:UIControlStateNormal];
    [m_groupOrderButton setBackgroundImage:[UIImage imageNamed:@"group_c_up.png"] forState:UIControlStateHighlighted];
    [m_groupOrderButton addTarget:self action: @selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];  
    [self.view addSubview:m_groupOrderButton];
    
    m_totalPageCount = 0;
    m_curPageIndex = 0;
    m_curPageSize = 0;
    m_groupType = 1;
    startY = 0;
    centerY = 0;

    m_resultDict = [[NSMutableArray alloc] initWithCapacity:10];
    m_selectLotNo = @"";
	
 
}

- (void)selectPressEvent:(NSNotification*)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary*)obj;
        m_selectLotNo = [dict objectForKey:@"selectValue"];
        
        if ([self.selectLotNo isEqualToString:kLotNoSSQ])
            self.navigationItem.title = @"合买大厅-双色球";
        else if ([self.selectLotNo isEqualToString:kLotNoFC3D])
            self.navigationItem.title = @"合买大厅-福彩3D";
        else if ([self.selectLotNo isEqualToString:kLotNoDLT])
            self.navigationItem.title = @"合买大厅-大乐透";
        else if ([self.selectLotNo isEqualToString:kLotNoQLC])
            self.navigationItem.title = @"合买大厅-七乐彩";
        else if ([self.selectLotNo isEqualToString:kLotNoPLS])
            self.navigationItem.title = @"合买大厅-排列三";
        else if ([self.selectLotNo isEqualToString:kLotNoSFC])
            self.navigationItem.title = @"合买大厅-胜负彩";
        else if ([self.selectLotNo isEqualToString:kLotNoRX9])
            self.navigationItem.title = @"合买大厅-任选九";
        else if ([self.selectLotNo isEqualToString:kLotNoJQC])
            self.navigationItem.title = @"合买大厅-进球彩";
        else if ([self.selectLotNo isEqualToString:kLotNoLCB])
            self.navigationItem.title = @"合买大厅-六场半";
        else if ([self.selectLotNo isEqualToString:kLotNoZC])
            self.navigationItem.title = @"合买大厅-足彩";
        else if ([self.selectLotNo isEqualToString:kLotNoPL5])
            self.navigationItem.title = @"合买大厅-排列五";
        else if ([self.selectLotNo isEqualToString:kLotNoQXC])
            self.navigationItem.title = @"合买大厅-七星彩";
//        else if ([self.selectLotNo isEqualToString:kLotNo22_5])
//            self.navigationItem.title = @"合买大厅-22选5";
        else if ([self.selectLotNo isEqualToString:kLotNoJCLQ])
            self.navigationItem.title = @"合买大厅-竞彩篮球";
        else if ([self.selectLotNo isEqualToString:kLotNoJCZQ])
            self.navigationItem.title = @"合买大厅-竞彩足球";
        else if ([self.selectLotNo isEqualToString:kLotNoBJDC])
            self.navigationItem.title = @"合买大厅-北京单场";
        else
            self.navigationItem.title = @"合买大厅";
 
        [self setNewScrollView];
        [self setupQueryAllCaseLot:0];  
    }
}


- (void)selectLotButtonClick
{
    [self setHidesBottomBarWhenPushed:YES];
    self.isFilter = @"1";
 
    SelecterView* view = [[[SelecterView alloc] init] autorelease];
    view.isUserEvent = NO;
    NSArray *LotNamesArray = [NSArray arrayWithObjects:@"全部彩种",@"双色球", @"福彩3D",@"大乐透",@"竞彩足球",@"七乐彩", @"排列三",@"排列五",@"七星彩",@"足彩",@"竞彩篮球",@"北京单场",nil];
    
    /*, @"七乐彩",@"排列三",@"胜负彩",@"任选九",@"进球彩"
        ,@"六场半",@"足彩",@"排列五",@"七星彩",@"22选5",@"竞彩篮球",@"竞彩足球",nil];*/
    
    NSArray *LotNoArray = [NSArray arrayWithObjects:@"",kLotNoSSQ,kLotNoFC3D,kLotNoDLT,kLotNoJCZQ,kLotNoQLC,kLotNoPLS,kLotNoPL5,kLotNoQXC,kLotNoZC,kLotNoJCLQ,kLotNoBJDC, nil];
    
    /*@"",@"F47104", @"F47103", @"T01001" , @"F47102", @"T01002"  ,@"T01003", @"T01004" ,@"T01005"  ,@"T01006" ,kLotNoZC,@"T01011" ,@"T01009",@"T01013",@"JC_L",@"JC_Z", nil];*/
    
    for (int a = 0; a < [LotNamesArray count]; a++) {
        [view appendSelectArray:[LotNoArray objectAtIndex:a] TITLE:[LotNamesArray objectAtIndex:a]];
    }
    [self.navigationController pushViewController:view animated:YES];
}

- (void)setNewScrollView
{
    startY = 0;
    centerY = 0;
    if (refreshView) {
        [refreshView removeFromSuperview];
    }
    [refreshView release];
    if (m_scrollView) {
        [m_scrollView removeFromSuperview];
    }
    
    [m_scrollView release];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 320, (int)([UIScreen mainScreen].bounds.size.height - 150))];
    m_scrollView.scrollEnabled = YES;
    m_scrollView.delegate = self;
    [self.view addSubview:m_scrollView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 150, 320, REFRESH_HEADER_HEIGHT)];
    [m_scrollView addSubview:refreshView];
    refreshView.myScrollView = m_scrollView;
    [refreshView stopLoading:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurPage:) name:@"refreshCurPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryAllCaseLotOK:) name:@"queryAllCaseLotOK" object:nil];
    
   
 
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCaseLotOKClick:) name:@"betCaseLotOKClick" object:nil];
    
    
    //存储是否是筛选之后进入的合买大厅
    if (!m_isFilter)
    {
        self.isFilter =@"0";
    }
  //存储是否是筛选之后进入的合买大厅   
    NSLog(@"------filter%@",m_isFilter);
    if ([self.isFilter isEqualToString:@"0"])
    {
        [self setNewScrollView];
        [self setupQueryAllCaseLot:0];
        
    }
    
     [[Custom_tabbar showTabBar] hideTabBar:NO];
    
    self.isFilter = @"0";
}

- (void)danjiaClick:(id)sender
{
    if (0 == m_groupType)
        return;
    
    m_groupType = 0;
    
//    [m_danjiaButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateNormal];
//    [m_danjiaButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateHighlighted];
//    [m_jinduButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateNormal];
//    [m_jinduButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateHighlighted];
//    [m_zongeButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateNormal];
//    [m_zongeButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateHighlighted];
    
    [self setNewScrollView];
    [self setupQueryAllCaseLot:0];
}

- (void)jinduClick:(id)sender
{
    if (1 == m_groupType)
        return;
    
    m_groupType = 1;
    
//    [m_danjiaButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateNormal];
//    [m_danjiaButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateHighlighted];
//    [m_jinduButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateNormal];
//    [m_jinduButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateHighlighted];
//    [m_zongeButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateNormal];
//    [m_zongeButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateHighlighted];
    
    [self setNewScrollView];
    [self setupQueryAllCaseLot:0];
}

- (void)zongeClick:(id)sender
{
    if (2 == m_groupType)
        return;
    
    m_groupType = 2;
    
//    [m_danjiaButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateNormal];
//    [m_danjiaButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateHighlighted];
//    [m_jinduButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateNormal];
//    [m_jinduButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateHighlighted];
//    [m_zongeButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_click.png"] forState:UIControlStateNormal];
//    [m_zongeButton setBackgroundImage:[UIImage imageNamed:@"hm_sort_normal.png"] forState:UIControlStateHighlighted];
	
    [self setNewScrollView];
    [self setupQueryAllCaseLot:0];
}

- (void)sortClick:(id)sender
{
    m_upOrder = !m_upOrder;
    if (m_upOrder)
    {
        [m_groupOrderButton setBackgroundImage:[UIImage imageNamed:@"group_c_up.png"] forState:UIControlStateNormal];
        [m_groupOrderButton setBackgroundImage:[UIImage imageNamed:@"group_c_down.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [m_groupOrderButton setBackgroundImage:[UIImage imageNamed:@"group_c_down.png"] forState:UIControlStateNormal];
        [m_groupOrderButton setBackgroundImage:[UIImage imageNamed:@"group_c_up.png"] forState:UIControlStateHighlighted];
    }
    [self setNewScrollView];
    [self setupQueryAllCaseLot:0];
	[m_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)setupQueryAllCaseLot:(NSInteger)pageIndex
{
	m_curPageIndex = pageIndex;
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"QueryLot" forKey:@"command"];
    [dict setObject:@"querycaselot" forKey:@"type"];
	[dict setObject:@"10" forKey:@"maxresult"];
	[dict setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageindex"];
 
    if ([m_selectLotNo length] > 0) {
        [dict setObject:m_selectLotNo forKey:@"lotno"];
    }
//    if ([m_batchCode length] > 0) {
//        [dict setObject:m_batchCode forKey:@"batchCode"];
//    }
	if(m_upOrder)
	{
		[dict setObject:@"asc" forKey:@"orderDir"];
	}
	else
	{
		[dict setObject:@"desc" forKey:@"orderDir"];
	}
	if(0 == m_groupType)
		[dict setObject:@"participantCount" forKey:@"orderBy"];
	else if(1 == m_groupType)
		[dict setObject:@"progress" forKey:@"orderBy"];
	else
		[dict setObject:@"totalAmt" forKey:@"orderBy"];

 
    [[RuYiCaiNetworkManager sharedManager] queryAllCaseLot:dict];
}

- (void)queryAllCaseLotOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    
    [m_resultDict removeAllObjects];
    NSMutableArray* dict = (NSMutableArray*)[parserDict objectForKey:@"result"];
	m_totalPageCount = [[parserDict objectForKey:@"totalPage"]intValue];
    [m_resultDict addObjectsFromArray:dict];
    
    int totalCount = [dict count];
	m_curPageSize = totalCount;
    [self refreshMySubViews];
 
}


- (void)refreshMySubViews
{    
 
    for (int i = 0; i < m_curPageSize; i++)
    {
        HMDTGroupByCellView *cell = [[HMDTGroupByCellView alloc] initWithFrame:CGRectZero];
        cell.hidden = YES;
		cell.superViewController = self;
 
        NSDictionary* subDict = (NSDictionary*)[m_resultDict objectAtIndex:i];
        cell.lotName = 
        KISDictionaryNullValue(subDict, @"lotName");
        
        cell.lotNo = 
        KISDictionaryNullValue(subDict, @"lotNo");
        
        cell.batchCode = 
        KISDictionaryNullValue(subDict, @"batchCode");
        
        
        cell.caseLotId = 
        KISDictionaryNullValue(subDict, @"caseLotId");
 
        cell.starter = 
        KISDictionaryNullValue(subDict, @"starter");
 
        cell.starterUserNo =
        KISDictionaryNullValue(subDict, @"starterUserNo");
        
        cell.totalAmt = 
        KISDictionaryNullValue(subDict, @"totalAmt");
 
        cell.safeAmt = 
        KISDictionaryNullValue(subDict, @"safeAmt");
 
        cell.safeRate = 
        KISDictionaryNullValue(subDict, @"safeRate");
 
        cell.buyAmt = 
        KISDictionaryNullValue(subDict, @"buyAmt");
 
        cell.progressInfo = 
        KISDictionaryNullValue(subDict, @"progress");
 
        cell.isTop = 
        KISDictionaryNullValue(subDict, @"isTop");
 
        NSDictionary* iconDict = [(NSDictionary*)subDict objectForKey:@"displayIcon"];
        
        cell.graygoldStar = [[iconDict objectForKey:@"graygoldStar"] intValue];
        cell.goldStar = [[iconDict objectForKey:@"goldStar"] intValue];
        cell.diamond = [[iconDict objectForKey:@"diamond"] intValue];
        cell.graydiamond = [[iconDict objectForKey:@"graydiamond"] intValue];
        cell.graycup = [[iconDict objectForKey:@"graycup"] intValue];
        cell.cup = [[iconDict objectForKey:@"cup"] intValue];
        cell.graycrown = [[iconDict objectForKey:@"graycrown"] intValue];
        cell.crown = [[iconDict objectForKey:@"crown"] intValue];
 
        cell.hidden = NO;
        cell.frame = CGRectMake(0, i * 90 + startY, 320, 90);
        [cell refreshView];
        [m_scrollView addSubview:cell];
        [cell release];
    }
    m_scrollView.contentSize = CGSizeMake(320, 90 * m_curPageSize + startY);

    startY = m_scrollView.contentSize.height;
    
    centerY = m_scrollView.contentSize.height - (int)([UIScreen mainScreen].bounds.size.height - 109);
    
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

- (void)refreshCurPage:(NSNotification*)notification
{
    m_curPageIndex = 0;
    
    [self setNewScrollView];
	[self setupQueryAllCaseLot:m_curPageIndex];
}
- (void)betCaseLotOKClick:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCurPage" object:nil];
}

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
        [self setupQueryAllCaseLot:m_curPageIndex];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}
 

- (void)querySampleLotNetRequest:(NSDictionary*)dict isShowProgress:(BOOL)showPro
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [[RuYiCaiNetworkManager sharedManager] getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:dict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"简单联网查询:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
    
    if(showPro)
    {
        [[RuYiCaiNetworkManager sharedManager] showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
    }
}

#pragma mark -
#pragma mark 显示微博界面的代理方法

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    if ([strMsg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

#pragma mark - CustomerSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    if (index == jinduOrder) {
        [self jinduClick:nil];
    }else if (index == zongeOrder){
        [self zongeClick:nil];
    }else if (index == renqiOrder){
        [self danjiaClick:nil];
    }
}
@end
