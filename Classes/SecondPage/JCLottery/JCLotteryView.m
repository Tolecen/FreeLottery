//
//  JCLotteryView.m
//  RuYiCai
//
//  Created by  on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCLotteryView.h"
#import "JCTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "SBJsonParser.h"
#import "NSLog.h"
#import "DataAnalysisViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kTableCellHeight    (60)

@interface JCLotteryView (internal)

- (void)getJCLotteryInforOK:(NSNotification*)notification;

@end

@implementation JCLotteryView

@synthesize myTableView = m_myTableView;
@synthesize dataArray = m_dataArray;
@synthesize isJCLQ = m_isJCLQ;
@synthesize selectDataArray = m_selectDataArray;

- (void)dealloc
{
    //    m_selectDateView.delegate = nil;//防止“魔鬼访问”，一定要在页面销毁前把delegate置空
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getJCLotteryInforOK" object:nil];
    
    [m_myTableView release], m_myTableView = nil;
    [m_dataArray release], m_dataArray = nil;
    [m_selectDataArray release], m_selectDataArray = nil;
    [m_playTypeButton release], m_playTypeButton = nil;
    [m_batchCodeOrDateButton release], m_playTypeButton = nil;
    [m_playTypeArray release], m_playTypeArray = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJCLotteryInforOK:) name:@"getJCLotteryInforOK" object:nil];
    
    isPlayButtonClick = YES;
    m_cellCount = 0;
    m_dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    m_selectDataArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_batchCodeOrDateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 32)];
    [m_batchCodeOrDateButton setBackgroundImage:RYCImageNamed(@"jc_play_normal.png") forState:UIControlStateNormal];
    [m_batchCodeOrDateButton setBackgroundImage:RYCImageNamed(@"jc_play_click.png") forState:UIControlStateHighlighted];
    [m_batchCodeOrDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_batchCodeOrDateButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    //    m_batchCodeOrDateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [m_batchCodeOrDateButton addTarget:self action:@selector(batchCodeOrDateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_batchCodeOrDateButton];
    
    UILabel* batchORdataLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 35, 32)];
    batchORdataLabel.textColor = [UIColor blackColor];
    batchORdataLabel.backgroundColor = [UIColor clearColor];
    batchORdataLabel.font = [UIFont systemFontOfSize:14.0];
    if (m_isJCLQ != 2) {
        batchORdataLabel.text = @"日期:";
    }
    else
        batchORdataLabel.text = @"期号:";
    [m_batchCodeOrDateButton addSubview:batchORdataLabel];
    [batchORdataLabel release];
    
    m_playTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 32)];
    [m_playTypeButton setBackgroundImage:RYCImageNamed(@"jc_play_normal.png") forState:UIControlStateNormal];
    [m_playTypeButton setBackgroundImage:RYCImageNamed(@"jc_play_click.png") forState:UIControlStateHighlighted];
    [m_playTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_playTypeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    m_playTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [m_playTypeButton addTarget:self action:@selector(playTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_playTypeButton];
    
    CGRect tableFrame = CGRectMake(0, 33, 320, [UIScreen mainScreen].bounds.size.height - 55);
    m_myTableView = [[UITableView alloc] initWithFrame:tableFrame];
    m_myTableView.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.myTableView.separatorColor = [UIColor clearColor];//表格分界线颜色
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.rowHeight = kTableCellHeight;
    [self.view addSubview:self.myTableView];
    
    m_playTypeArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (1 == m_isJCLQ) {
        [mDict setObject:@"jingCai" forKey:@"command"];
        [mDict setObject:@"matchResult" forKey:@"requestType"];
        [mDict setObject:kLotNoJCLQ_SF forKey:@"lotno"];
        [mDict setObject:@"" forKey:@"date"];
        
        m_playType = kLotNoJCLQ_SF;
        [m_playTypeButton setTitle:@"胜负" forState:UIControlStateNormal];
        
        [m_playTypeArray addObject:kLotNoJCLQ_SF];
        [m_playTypeArray addObject:kLotNoJCLQ_RF];
        [m_playTypeArray addObject:kLotNoJCLQ_SFC];
        [m_playTypeArray addObject:kLotNoJCLQ_DXF];
    }
    else if(0 == m_isJCLQ)
    {
        [mDict setObject:@"jingCai" forKey:@"command"];
        [mDict setObject:@"matchResult" forKey:@"requestType"];
        [mDict setObject:kLotNoJCZQ_RQ_SPF forKey:@"lotno"];
        [mDict setObject:@"" forKey:@"date"];
        
        m_playType = kLotNoJCZQ_SPF;
        [m_playTypeButton setTitle:@"胜平负" forState:UIControlStateNormal];
        
        [m_playTypeArray addObject:kLotNoJCZQ_SPF];
        [m_playTypeArray addObject:kLotNoJCZQ_RQ_SPF];
        [m_playTypeArray addObject:kLotNoJCZQ_ZJQ];
        [m_playTypeArray addObject:kLotNoJCZQ_SCORE];
        [m_playTypeArray addObject:kLotNoJCZQ_HALF];
    }
    else
    {
        [mDict setObject:@"beiDan" forKey:@"command"];
        [mDict setObject:@"matchResult" forKey:@"requestType"];
        [mDict setObject:kLotNoBJDC_RQSPF forKey:@"lotno"];
        [mDict setObject:@"" forKey:@"batchcode"];
        
        m_playType = kLotNoBJDC_RQSPF;
        [m_playTypeButton setTitle:@"让球胜平负" forState:UIControlStateNormal];
        
        [m_playTypeArray addObject:kLotNoBJDC_RQSPF];
        [m_playTypeArray addObject:kLotNoBJDC_JQS];
        [m_playTypeArray addObject:kLotNoBJDC_Score];
        [m_playTypeArray addObject:kLotNoBJDC_HalfAndAll];
        [m_playTypeArray addObject:kLotNoBJDC_SXDS];
    }
    [[RuYiCaiNetworkManager sharedManager] getJCLotteryInfor:mDict];
}

#pragma mark 选择器
- (void)batchCodeOrDateButtonClick:(id)sender
{
    isPlayButtonClick = NO;
    RuYiCaiAppDelegate* _delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    _delegate.randomPickerView.delegate = self;
    [_delegate.randomPickerView presentModalView:_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
    [_delegate.randomPickerView setPickerDataArray:self.selectDataArray];
    [_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:[self.selectDataArray count]];
}

- (void)playTypeButtonClick:(id)sender
{
    isPlayButtonClick = YES;
    RuYiCaiAppDelegate* _delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    _delegate.randomPickerView.delegate = self;
    [_delegate.randomPickerView presentModalView:_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
    NSMutableArray*  tempArray = [NSMutableArray arrayWithCapacity:1];
    
    if (1 == m_isJCLQ) {
        [tempArray addObject:@"胜负"];
        [tempArray addObject:@"让分胜负"];
        [tempArray addObject:@"胜分差"];
        [tempArray addObject:@"大小分"];
    }
    else if(0 == m_isJCLQ)
    {
        [tempArray addObject:@"胜平负"];
        [tempArray addObject:@"让球胜平负"];
        [tempArray addObject:@"总进球数"];
        [tempArray addObject:@"比分"];
        [tempArray addObject:@"半全场"];
    }
    else
    {
        [tempArray addObject:@"让球胜平负"];
        [tempArray addObject:@"总进球数"];
        [tempArray addObject:@"比分"];
        [tempArray addObject:@"半全场"];
        [tempArray addObject:@"上下单双"];
    }
    [_delegate.randomPickerView setPickerDataArray:tempArray];
    [_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:[self.selectDataArray count]];
}

- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    if ([randomPickerView.pickerNumArray count] == 0) {
        return;
    }
    NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if (isPlayButtonClick) {//玩法切换 日期或期号制为最新期
        m_playType = [m_playTypeArray objectAtIndex:num];
        [m_playTypeButton setTitle:[randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
        if (2 != m_isJCLQ) {
            [mDict setObject:@"" forKey:@"date"];
        }
        else
            [mDict setObject:@"" forKey:@"batchcode"];
    }
    else
    {
        [m_batchCodeOrDateButton setTitle:[randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
        
        if (2 != m_isJCLQ) {
            NSArray* dateArray = [[m_batchCodeOrDateButton currentTitle] componentsSeparatedByString:@"-"];
            NSString* dateStr = @"";
            for (int i = 0; i < [dateArray count]; i++) {
                dateStr = [dateStr stringByAppendingString:[dateArray objectAtIndex:i]];
            }
            [mDict setObject:dateStr forKey:@"date"];
        }
        else
            [mDict setObject:[m_batchCodeOrDateButton currentTitle] forKey:@"batchcode"];
    }
    
    if (2 != m_isJCLQ) {
        [mDict setObject:@"jingCai" forKey:@"command"];
        [mDict setObject:@"matchResult" forKey:@"requestType"];
        [mDict setObject:m_playType forKey:@"lotno"];
    }
    else
    {
        [mDict setObject:@"beiDan" forKey:@"command"];
        [mDict setObject:@"matchResult" forKey:@"requestType"];
        [mDict setObject:m_playType forKey:@"lotno"];
    }
    [[RuYiCaiNetworkManager sharedManager] getJCLotteryInfor:mDict];
}
#pragma mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return m_cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    JCTableViewCell *cell = (JCTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[JCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSUInteger row = indexPath.row;
    NSDictionary* subDict = (NSDictionary*)[self.dataArray objectAtIndex:row];
    cell.leagueStr = KISDictionaryHaveKey(subDict, @"league");
    cell.homeTeamStr = KISDictionaryHaveKey(subDict, @"homeTeam");
    cell.guestTeamStr = KISDictionaryHaveKey(subDict, @"guestTeam");
    if (![KISDictionaryHaveKey(subDict, @"peiLv") isEqualToString:@""]) {
        cell.SPstring = [NSString stringWithFormat:@"SP:%@",KISDictionaryHaveKey(subDict, @"peiLv")];
    }
    else
        cell.SPstring = KISDictionaryHaveKey(subDict, @"peiLv");
    
    cell.resultStr = KISDictionaryHaveKey(subDict, @"matchResult");
    if (kLotNoJCLQ_DXF == m_playType) {
        cell.letPoint = KISDictionaryHaveKey(subDict, @"basePoint");
    }
    else
        cell.letPoint = KISDictionaryHaveKey(subDict, @"letPoint");
    
    cell.teamId = KISDictionaryHaveKey(subDict, @"teamId");
    
    cell.homeScore = KISDictionaryHaveKey(subDict, @"homeScore");
    cell.guestScore = KISDictionaryHaveKey(subDict, @"guestScore");
    cell.homeHalfScore = KISDictionaryHaveKey(subDict, @"homeHalfScore");
    cell.guestHalfScore = KISDictionaryHaveKey(subDict, @"guestHalfScore");
    
    cell.isJCLQoPen = self.isJCLQ;
    
    cell.playType = m_playType;
    
    [cell refresh];
    
    return cell;
}
//选中cell响应事件
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    if (2 == self.isJCLQ) {
//        return;
//    }
//    [[Custom_tabbar showTabBar] hideTabBar:YES];
//    [self setHidesBottomBarWhenPushed:YES];
//    
//    DataAnalysisViewController* viewController = [[DataAnalysisViewController alloc] init];
//    NSString*   event = @"";
//    if (1 == self.isJCLQ) {
//        event = [event stringByAppendingString:@"0_"];//1 足球 0篮球
//    }
//    else if (0 == self.isJCLQ)
//        event = [event stringByAppendingString:@"1_"];//1 足球 0篮球
//    
//    NSDictionary*   subDict = (NSDictionary*)[self.dataArray objectAtIndex:indexPath.row];
//    
//    event = [event stringByAppendingFormat:@"%@_" , KISDictionaryHaveKey(subDict, @"day")];
//    event = [event stringByAppendingFormat:@"%@_" , KISDictionaryHaveKey(subDict, @"weekId")];
//    event = [event stringByAppendingString:[subDict objectForKey:@"teamId"]];
//    
//    [viewController setEvent:event];
//    [viewController setIsJCLQ:self.isJCLQ];
//    
//    viewController.navigationItem.title = @"球队数据分析";
//    [self.navigationController pushViewController:viewController animated:YES];
//	[viewController release];
//    
//    
//    //    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (void)getJCLotteryInforOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:
                                               [RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    [m_dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[parserDict objectForKey:@"result"]];
    
    [m_selectDataArray removeAllObjects];
    NSArray* _array;
    if (2 == m_isJCLQ) {
        _array = [[parserDict objectForKey:@"beforeBatchCode"] componentsSeparatedByString:@";"];
    }
    else
    {
        _array = [[parserDict objectForKey:@"date"] componentsSeparatedByString:@";"];
    }
    for (int i = 0; i < [_array count]; i++) {
        [self.selectDataArray addObject:[_array objectAtIndex:i]];
    }
    if ([self.selectDataArray count] != 0) {
        if (isPlayButtonClick)
            [m_batchCodeOrDateButton setTitle:[self.selectDataArray objectAtIndex:0] forState:UIControlStateNormal];
    }
    m_cellCount = [self.dataArray count];
    
    [self.myTableView reloadData];
    
    if (m_cellCount * kTableCellHeight < self.myTableView.frame.size.height)
    {
        self.myTableView.scrollEnabled = NO;
    }
    else
    {
        self.myTableView.scrollEnabled = YES;
    }
}


- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


/*
 #pragma mark datePickView delegate
 - (void)cancelPickView:(DatePickView*)randomPickerView
 {
 
 }
 
 - (void)randomPickerView:(DatePickView*)randomPickerView selectDate:(NSDate*)selectDate
 {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];//location设置为中国
 [dateFormatter setDateFormat:@"yyyyMMdd"];
 
 NSString* newDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: selectDate]];
 NSLog(@"newDate:%@", newDate);
 
 NSMutableDictionary* mDict = [NSMutableDictionary dictionaryWithCapacity:1];
 
 if (1 == m_isJCLQ) {
 [mDict setObject:@"jingCai" forKey:@"command"];
 [mDict setObject:@"matchResult" forKey:@"requestType"];
 [mDict setObject:kLotNoJCLQ forKey:@"lotno"];
 [mDict setObject:newDate forKey:@"date"];
 [[RuYiCaiNetworkManager sharedManager] getJCLotteryInfor:mDict];//1表示足球
 }
 else if(0 == m_isJCLQ)
 {
 [mDict setObject:@"jingCai" forKey:@"command"];
 [mDict setObject:@"matchResult" forKey:@"requestType"];
 [mDict setObject:kLotNoJCZQ forKey:@"lotno"];
 [mDict setObject:newDate forKey:@"date"];
 [[RuYiCaiNetworkManager sharedManager] getJCLotteryInfor:mDict];//1表示足球
 }
 else
 {
 
 }
 [dateFormatter release];
 }
 
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 [self setNavigationBarDateButton];
 }
 
 - (void)viewWillDisappear:(BOOL)animated
 {
 [[self.navigationController.navigationBar viewWithTag:100] removeFromSuperview];//选择日期按钮
 
 [super viewWillDisappear:animated];
 }*/

@end
