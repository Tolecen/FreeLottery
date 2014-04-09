//
//  InstantScoreViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InstantScoreViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "SBJsonParser.h"
#import "NewsViewController.h"
#import "Custom_tabbar.h"
#import "InstantScoreTableCell.h"
#import "InstantScoreCellDetailViewController.h"
#import "InstantScoreCellDetail_JCLQViewController.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "JC_AttentionDataManagement.h"
#import "AdaptationUtils.h"

@interface InstantScoreViewController (internal)
- (void)setupNavigationBar;
- (void)changeUserClick;
- (void)segmentedChange:(id)sender;
- (void)getInstantScoreOK:(NSNotification *)notification;
- (void)historyButtonPress;
 
@end

@implementation InstantScoreViewController

@synthesize segmented = m_segmented;
@synthesize tableView = m_tableView;
@synthesize typeIdArray = m_typeIdArray;
@synthesize Data = m_Data;
@synthesize type = m_type;
@synthesize userDefaultsTag = m_userDefaultsTag;
@synthesize currentTime;
@synthesize noMassageLabel = m_noMessageLabel;
@synthesize segmentView = m_segmentView;
@synthesize tempSelectEvent = m_tempSelectEvent;
@synthesize dateChooseButton = m_dateChooseButton;
@synthesize userChooseGameArray = m_userChooseGameArray;
@synthesize userChooseGameEvent = m_userChooseGameEvent;
@synthesize currentDatePickNum;
@synthesize todayDate;

- (void)dealloc 
{
    m_delegate.randomPickerView.delegate = nil;
    [m_segmentView release];m_segmentView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInstantScoreOK" object:nil];
    KSafe_Free(m_segmented);
    KSafe_Free(m_tableView);
    KSafe_Free(m_typeIdArray);
    KSafe_Free(m_noMessageLabel);
    KSafe_Free(m_noMessageLabel);
    KSafe_Free(m_dateChooseButton);
    [todayDate release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (m_refreshButton != nil) {
        [m_refreshButton release], m_refreshButton = nil;
    }
    m_refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(286, 10, 20, 24)];
    [m_refreshButton addTarget:self action: @selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_refreshButton setImage:[UIImage imageNamed:@"refresh_button.png"] forState:UIControlStateNormal];
    m_refreshButton.showsTouchWhenHighlighted = TRUE;
    [self.navigationController.navigationBar addSubview:m_refreshButton];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [m_refreshButton removeFromSuperview];
    [m_refreshButton release], m_refreshButton = nil;
    
    [super viewWillDisappear:animated];
}
- (void)refreshButtonClick:(id)sender
{
    [self segmentedChangeForIndex:sender];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInstantScoreOK:) name:@"getInstantScoreOK" object:nil];
    
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
 
    self.currentTime = @"";
    self.currentDatePickNum = 0;
    self.todayDate = @"";
    
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 80, 32)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.text = @"选择日期:";
    dateLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:dateLabel];
    
    m_dateChooseButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 35, 135, 32)];
    [m_dateChooseButton setBackgroundImage:RYCImageNamed(@"select3_normal.png") forState:UIControlStateNormal];
    [m_dateChooseButton setBackgroundImage:RYCImageNamed(@"select3_click.png") forState:UIControlStateHighlighted];
    [m_dateChooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_dateChooseButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    m_dateChooseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 23);
    [m_dateChooseButton addTarget:self action:@selector(historyButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_dateChooseButton];
    
    
    
    
    self.segmentView = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 0, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:
                                                                        @"jczq_jsbf_qb_normal.png",
                                                                        @"jczq_jsbf_wks_normal.png",
                                                                        @"jczq_jsbf_jxz_normal.png",
                                                                        @"jczq_jsbf_ywc_normal.png",
                                                                        @"jczq_jsbf_wdgz_normal.png",
                                                                        nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:
                                                                        @"jczq_jsbf_qb_normal.png",
                                                                        @"jczq_jsbf_wks_normal.png",
                                                                        @"jczq_jsbf_jxz_normal.png",
                                                                        @"jczq_jsbf_ywc_normal.png",
                                                                        @"jczq_jsbf_wdgz_normal.png",
                                                                        nil]
                                                        andSelectImage:[NSArray arrayWithObjects:
                                                                        @"jczq_jsbf_qb_click.png",
                                                                        @"jczq_jsbf_wks_click.png",
                                                                        @"jczq_jsbf_jxz_click.png",
                                                                        @"jczq_jsbf_ywc_click.png",
                                                                        @"jczq_jsbf_wdgz_click.png",
                                                                        nil]
                         ]autorelease];
    
    self.segmentView.delegate = self;
    [self.view addSubview:m_segmentView];
    [self segmentedChangeForIndex:0];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 70) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.allowsSelection = YES; 
    [self.view addSubview:self.tableView];
    
    
    m_noMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    [m_tableView addSubview:m_noMessageLabel];
    [m_noMessageLabel setHidden:YES];
 
    m_typeIdArray = [[NSMutableArray alloc] initWithCapacity:1];
    m_typeTag = 0;//默认全部
    //联网 请求
    //state 状态（0：全部 1：未开 2：比赛中 3：完场）
    NSString* requestTYpe = @"";
    if (self.type == JCLQ) {
        requestTYpe = @"immediateScoreJcl";
    }
    else if(self.type == JCZQ)
    {
        requestTYpe = @"immediateScore";
    }
    else if((self.type = BJDC))
    {
        requestTYpe = @"immediateScore";
    }
    else
    {
        requestTYpe = @"immediateScore";
    }
    
    //************//
    //**北京单场***//
    //************//
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
	[mDict setObject:@"jingCai" forKey:@"command"];
    [mDict setObject:requestTYpe forKey:@"requestType"];
    [mDict setObject:@"0" forKey:@"type"];
    [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
    
    NSLog(@"%@",(NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag]);
}




- (void)segmentedChangeForIndex:(id)index
{
    tableRowNum = 0;
    [m_noMessageLabel setHidden:YES];
    int indexsub = (int)index;
    switch (indexsub)
    {
        case 0:
            m_typeTag = 0;
            break;
        case 1:
            m_typeTag = 1;
            break;
        case 2:
            m_typeTag = 2;
            break;
        case 3:
            m_typeTag = 3;
            break;
        case 4:
            m_typeTag = 4;
            break;
        default:
            break;
    }
    
    if (m_typeTag != 2) {
        m_tableView.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 70);
    }
    else
    {
        m_tableView.frame = CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 35);
    }
    [m_tableView reloadData];
    
    
    //给Button设置标题
    if (m_typeTag != 2) {
        [m_dateChooseButton setTitle:[self stringWithDateString:self.currentTime] forState:UIControlStateNormal];
    }
    
    //请求数据
    NSString*   state = @"";
    state = [state stringByAppendingFormat:@"%d",m_typeTag];
    NSString* requestTYpe = @"";
    if (self.type == JCLQ) {
        requestTYpe = @"immediateScoreJcl";
    }
    else if(self.type == JCZQ)
    {
        requestTYpe = @"immediateScore";
    }
    else if(self.type == BJDC)
    {
        requestTYpe = @"immediateScore";
    }
    else
    {
        requestTYpe = @"immediateScore";
    }
    
    //判断是刷新还是切换
    if (index != m_refreshButton) {
        
        if (m_typeTag != 2&&m_typeTag != 4) {
            self.currentTime = @"";
            self.currentDatePickNum = 0;
        }
        else if(m_typeTag == 2)
        {
            self.currentTime = todayDate;
            self.currentDatePickNum = 0;
        }
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (m_typeTag != 2&&m_typeTag != 4)
    {
        
        [mDict setObject:@"jingCai" forKey:@"command"];
        [mDict setObject:requestTYpe forKey:@"requestType"];
        [mDict setObject:state forKey:@"type"];
        [mDict setObject:self.currentTime forKey:@"date"];
        [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
    }
    else if(m_typeTag == 2)
    {
        if (self.type == JCLQ) {
            [mDict setObject:@"jingCai" forKey:@"command"];
            [mDict setObject:@"immediateScoreJcl" forKey:@"requestType"];
            [mDict setObject:state forKey:@"type"];
            [mDict setObject:@"" forKey:@"date"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
        else if(self.type == JCZQ)
        {
            [mDict setObject:@"jingCai" forKey:@"command"];
            [mDict setObject:@"immediateScore" forKey:@"requestType"];
            [mDict setObject:state forKey:@"type"];
            [mDict setObject:@"" forKey:@"date"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
        else
        {
            [mDict setObject:@"jingCai" forKey:@"command"];
            [mDict setObject:@"processingMatches" forKey:@"requestType"];
            [mDict setObject:state forKey:@"type"];
            [mDict setObject:@"" forKey:@"date"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
        
    }
    else
    {
        self.currentDatePickNum = 0;
        NSArray*  userArray = [NSArray arrayWithArray:(NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag]];
        if ([userArray count] == 0||!userArray||userArray == nil) {
            [m_noMessageLabel setHidden:NO];
            m_noMessageLabel.text = @"您还没有关注任何比赛";
            m_noMessageLabel.textAlignment = UITextAlignmentCenter;
            m_noMessageLabel.textColor = kColorWithRGB(116.0, 116.0, 116.0, 1.0);
            m_noMessageLabel.font = [UIFont boldSystemFontOfSize:20];
            m_noMessageLabel.backgroundColor = [UIColor clearColor];
        }
        else
        {
            //如果当前日期没有关注，则找最近的日期
            [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
            //判断是否存在当前期号的关注,若不存在，找最近的期号
            if (![[JC_AttentionDataManagement shareManager] isPresentTheDate:self.currentTime]) {
                NSMutableArray *allQihao = [NSMutableArray arrayWithArray:[[JC_AttentionDataManagement shareManager] getAllDate]];//获得所有的期号
                [[JC_AttentionDataManagement shareManager] selectSortWithDateArray:allQihao];//排序
                self.currentTime = [allQihao objectAtIndex:0];
                [m_dateChooseButton setTitle:[self stringWithDateString:[allQihao objectAtIndex:0]] forState:UIControlStateNormal];
            }
            
            [m_noMessageLabel setHidden:YES];
            [mDict setObject:@"jingCai" forKey:@"command"];
            [mDict setObject:requestTYpe forKey:@"requestType"];
            [mDict setObject:@"0" forKey:@"type"];
            [mDict setObject:self.currentTime forKey:@"date"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
    }
}
- (void) setupTitle
{
    //设置 我的关注标题
    NSString* title = @"我的关注";
    if ([[self getCurrentShouCangArray] count] != 0) {
        title = [title stringByAppendingFormat:@"(%d) ",[[self getCurrentShouCangArray] count]];
    }
    [self.segmented setTitle:title forSegmentAtIndex:4];
}
- (void)getInstantScoreOK:(NSNotification *)notification
{
    [m_noMessageLabel setHidden:YES];
    
    self.Data = [RuYiCaiNetworkManager sharedManager].responseText;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:m_Data];
    [jsonParser release];
    
    if(![KISDictionaryHaveKey(parserDict, @"error_code") isEqualToString:@"0000"])//无记录
    {
        [m_noMessageLabel setHidden:NO];
        m_noMessageLabel.text = KISDictionaryHaveKey(parserDict, @"message");
        m_noMessageLabel.textAlignment = UITextAlignmentCenter;
        m_noMessageLabel.textColor = kColorWithRGB(116.0, 116.0, 116.0, 1.0);
        m_noMessageLabel.font = [UIFont boldSystemFontOfSize:20];
        m_noMessageLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    
    NSString* dateString = @"";
    dateString = KISDictionaryNullValue(parserDict, @"date");
    NSArray* dateArray =  [dateString componentsSeparatedByString:@";"];
    
    //    NSLog(@"data = %@",dateString);
    
    if(0 == [dateArray count] || ([dateArray count] == 1 && [[dateArray objectAtIndex:0] length] == 0))
    {
        
    }
    else
    {
        NSLog(@"time %@", self.currentTime);
        if([self.currentTime isEqualToString:@""])
        {
            NSMutableString* temp_time = [NSMutableString stringWithString:(NSString*)[dateArray objectAtIndex:([KISDictionaryNullValue(parserDict, @"todayIndex") integerValue] - 1)]];
            NSRange rangge = [temp_time rangeOfString:@"-"];
            while (rangge.length > 0) {
                [temp_time deleteCharactersInRange:rangge];
                rangge = [temp_time rangeOfString:@"-"];
            }
            self.todayDate = temp_time;
            self.currentTime = temp_time;
            self.currentDatePickNum = [KISDictionaryNullValue(parserDict, @"todayIndex") integerValue] - 1;
            [m_dateChooseButton setTitle:[self stringWithDateString:self.currentTime] forState:UIControlStateNormal];
            
        }
    }
    
    [self setupTitle];
    
    NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
    if (m_typeTag == 4) {
        //从返回的数据里检索
        tableRowNum = [[self getCurrentShouCangArray] count];
        /*
         if (tableRowNum == 0) {
         //当 当前日期没有 收藏的比赛时，取最近收藏的比赛
         NSArray* UserSavedArray = [NSArray  arrayWithArray:(NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag]];
         
         for (int i = [UserSavedArray count] - 1; i >= 0; i--) {
         NSDictionary* dict = (NSDictionary*)[UserSavedArray objectAtIndex:i];
         NSString* temp_str = [NSString stringWithString:(NSMutableString*)[[dict allKeys] objectAtIndex:0]];
         NSArray* array = (NSArray*)[dict objectForKey:temp_str];
         if ([array count] > 0) {
         tableRowNum = [array count];
         self.currentTime = temp_str;
         self.currentDatePickNum = 0;
         [m_dateChooseButton setTitle:[self stringWithDateString:self.currentTime] forState:UIControlStateNormal];
         break;
         }
         }
         if (tableRowNum > 0) {
         NSString* requestTYpe = @"";
         if (self.type == JCLQ) {
         requestTYpe = @"immediateScoreJcl";
         }
         else if(self.type == JCZQ)
         {
         requestTYpe = @"immediateScore";
         }
         else
         {
         requestTYpe = @"immediateScore";
         }
         
         NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
         [mDict setObject:@"jingCai" forKey:@"command"];
         [mDict setObject:requestTYpe forKey:@"requestType"];
         [mDict setObject:@"0" forKey:@"type"];
         [mDict setObject:self.currentTime forKey:@"date"];
         [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
         return;
         }
         }
         */
    }
    else
    {
        tableRowNum = array.count;
    }
    NSLog(@"time2 %@", self.currentTime);
    
    [m_tableView reloadData];
}

#pragma  mark tableDelegate
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    return tableRowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    NSArray* userarray = [self getCurrentShouCangArray];
    NSLog(@"我的关注 当前日期\n、、、、、、、：%@",userarray);
    
    
    InstantScoreTableCell* cell = (InstantScoreTableCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[InstantScoreTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    //************//
    //**北京单场***//
    //************//
    
    if (m_typeTag != 4) {
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:m_Data];
        [jsonParser release];
        
        NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
        
        cell.scoreType = JingCai;
        cell.event = KISNullValue(array, indexPath.row, @"event");
        cell.sclassName = KISNullValue(array, indexPath.row, @"sclassName");
        
        cell.matchTime = KISNullValue(array, indexPath.row, @"matchTime");
        cell.tag = indexPath.row;
        cell.superViewController = self;
        
        if (self.type == JCZQ) {
            cell.homeTeam = KISNullValue(array, indexPath.row, @"homeTeam");
            cell.guestTeam = KISNullValue(array, indexPath.row, @"guestTeam");
            cell.homeScore = KISNullValue(array, indexPath.row, @"homeScore");
            cell.guestScore = KISNullValue(array, indexPath.row, @"guestScore");
            
            cell.homeHalfScore = KISNullValue(array, indexPath.row, @"homeHalfScore");
            cell.guestHalfScore = KISNullValue(array, indexPath.row, @"guestHalfScore");
            
            NSString *temp_matchState = KISNullValue(array, indexPath.row, @"matchState");
            cell.matchState = temp_matchState;
            if ([temp_matchState isEqualToString:@"1"]||
                [temp_matchState isEqualToString:@"3"]||
                [temp_matchState isEqualToString:@"4"]) {
                cell.progressedTime = [NSString stringWithFormat:@"%@'",KISNullValue(array, indexPath.row, @"progressedTime")];
            }
            else{
                cell.progressedTime = KISNullValue(array, indexPath.row, @"matchStateMemo");
            }
        }
        else//篮球客在前
        {
            cell.homeTeam = [NSString stringWithFormat:@"%@(客)", KISNullValue(array, indexPath.row, @"guestTeam")];
            cell.guestTeam = [NSString stringWithFormat:@"%@(主)",KISNullValue(array, indexPath.row, @"homeTeam")];
            cell.homeScore = KISNullValue(array, indexPath.row, @"guestScore");
            cell.guestScore = KISNullValue(array, indexPath.row, @"homeScore");
            
            NSString *temp_matchState = KISNullValue(array, indexPath.row, @"matchState");
            cell.matchState = temp_matchState;
            if ([temp_matchState isEqualToString:@"1"]||
                [temp_matchState isEqualToString:@"2"]||
                [temp_matchState isEqualToString:@"3"]||
                [temp_matchState isEqualToString:@"4"]||
                [temp_matchState isEqualToString:@"5"]||
                [temp_matchState isEqualToString:@"6"]||
                [temp_matchState isEqualToString:@"7"])
            {
                cell.progressedTime = [NSString stringWithFormat:@"%@ %@",KISNullValue(array, indexPath.row, @"matchStateMemo"),KISNullValue(array, indexPath.row, @"remainTime")];
            }
            else {
                cell.progressedTime = KISNullValue(array, indexPath.row, @"matchStateMemo");
            }
        }
        if (m_typeTag == 0||m_typeTag == 1) {
            cell.shouCangButtonIsHidden = NO;
            BOOL hasShoucang = NO;
            if (userarray != Nil) {
                for (int i = 0; i < [userarray count]; i++) {
                    if ([[userarray objectAtIndex:i] isEqualToString:KISNullValue(array, indexPath.row, @"event")]) {
                        hasShoucang = YES;
                        break;
                    }
                }
            }
            cell.isShouCang = hasShoucang;
        }
        else
        {
            cell.shouCangButtonIsHidden = YES;
        }
        
    }
    else if(userarray != Nil && [userarray count] > 0)
    {
        //        [m_noMessageLabel setHidden:YES];
        cell.shouCangButtonIsHidden = NO;
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:m_Data];
        [jsonParser release];
        NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
        //从返回的数据里检索
        NSString* event = [userarray objectAtIndex:indexPath.row];
        for (int j = 0; j < [array count]; j++) {
            if ([event isEqualToString:KISNullValue(array, j, @"event")]) {
                
                cell.scoreType = JingCai;
                cell.event = KISNullValue(array, j, @"event");
                cell.sclassName = KISNullValue(array, j, @"sclassName");
                
                cell.matchTime = KISNullValue(array, j, @"matchTime");
                cell.tag = j;
                cell.superViewController = self;
                cell.isShouCang = YES;
                
                if (self.type == JCZQ) {
                    cell.homeTeam = KISNullValue(array, j,@"homeTeam");
                    cell.guestTeam = KISNullValue(array, j, @"guestTeam");
                    cell.homeScore = KISNullValue(array, j, @"homeScore");
                    cell.guestScore = KISNullValue(array, j, @"guestScore");
                    cell.homeHalfScore = KISNullValue(array, j, @"homeHalfScore");
                    cell.guestHalfScore = KISNullValue(array, j, @"guestHalfScore");
                    
                    NSString *temp_matchState = KISNullValue(array, j, @"matchState");
                    cell.matchState = temp_matchState;
                    if ([temp_matchState isEqualToString:@"1"]||
                        [temp_matchState isEqualToString:@"3"]||
                        [temp_matchState isEqualToString:@"4"]) {
                        cell.progressedTime = [NSString stringWithFormat:@"%@'",KISNullValue(array, j, @"progressedTime")];
                    }
                    else{
                        cell.progressedTime = KISNullValue(array, j, @"matchStateMemo");
                    }
                }
                else//篮球客在前
                {
                    cell.homeTeam = [NSString stringWithFormat:@"%@(客)", KISNullValue(array, j, @"guestTeam")];
                    cell.guestTeam = [NSString stringWithFormat:@"%@(主)",KISNullValue(array, j, @"homeTeam")];
                    cell.homeScore = KISNullValue(array, j, @"guestScore");
                    cell.guestScore = KISNullValue(array, j, @"homeScore");
                    
                    NSString *temp_matchState = KISNullValue(array, j, @"matchState");
                    cell.matchState = temp_matchState;
                    if ([temp_matchState isEqualToString:@"1"]||
                        [temp_matchState isEqualToString:@"2"]||
                        [temp_matchState isEqualToString:@"3"]||
                        [temp_matchState isEqualToString:@"4"]||
                        [temp_matchState isEqualToString:@"5"]||
                        [temp_matchState isEqualToString:@"6"]||
                        [temp_matchState isEqualToString:@"7"])
                    {
                        cell.progressedTime = [NSString stringWithFormat:@"%@ %@",KISNullValue(array, j, @"matchStateMemo"),KISNullValue(array, j, @"remainTime")];
                    }
                    else {
                        cell.progressedTime = KISNullValue(array, j, @"matchStateMemo");
                    }
                }
                break;
            }
        }
    }
    [cell refreshTableCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //得到 选择的 event
    [m_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:m_Data];
//    [jsonParser release];
//    NSArray* array = (NSArray*)[parserDict objectForKey:@"result"]; 
//    NSString* event = KISNullValue(array, indexPath.row, @"event");
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    if (self.type == JCLQ) {
        InstantScoreCellDetail_JCLQViewController* viewController = [[InstantScoreCellDetail_JCLQViewController alloc] init];
        
        [viewController setEvent:self.tempSelectEvent];
        viewController.navigationItem.title = @"即时比分";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else
    {
        InstantScoreCellDetailViewController* viewController = [[InstantScoreCellDetailViewController alloc] init];
        
        [viewController setEvent:self.tempSelectEvent];
        viewController.navigationItem.title = @"即时比分";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
 
}
#pragma  mark 选择器
- (void)historyButtonPress
{
    m_delegate.randomPickerView.delegate = self;
    
    if (m_typeTag != 4) {
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:m_Data];
        [jsonParser release];
        NSString* dateString = @"";
        dateString = KISDictionaryNullValue(parserDict, @"date");
        NSArray* dateArray =  [dateString componentsSeparatedByString:@";"];
        
        if(0 == [dateArray count] || ([dateArray count] == 1 && [[dateArray objectAtIndex:0] length] == 0))
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"没有历史记录" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
        [m_delegate.randomPickerView setPickerDataArray:dateArray];
        [m_delegate.randomPickerView setPickerNum:self.currentDatePickNum withMinNum:0 andMaxNum:[dateArray count]];
        
    }
    else//我的收藏的日期 是由收藏过的比赛的日期组成的
    {
        
        self.currentDatePickNum = 0;
        NSArray* UserSavedArray = (NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag];
        //        获得我的收藏的日期数组
        NSMutableArray* TimeArray = [NSMutableArray array];
        NSMutableArray* TimeArray_copy = [NSMutableArray array];
        //先排序
        for (int i = 0; i < [UserSavedArray count]; i++) {
            NSDictionary* dict = (NSDictionary*)[UserSavedArray objectAtIndex:i];
            NSMutableString* temp_str = [NSMutableString stringWithString:(NSMutableString*)[[dict allKeys] objectAtIndex:0]];
            [TimeArray addObject:temp_str];
        }
        NSLog(@"%@",TimeArray);
        /*排序*/
        for (int i = 0; i<[TimeArray count]; i++)
        {
            for (int j=i+1; j<[TimeArray count]; j++)
            {
                double a = [[TimeArray objectAtIndex:i] doubleValue];
                double b = [[TimeArray objectAtIndex:j] doubleValue];
                if (a > b)
                {
                    [TimeArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%.0lf",b]];
                    [TimeArray replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%.0lf",a]];
                }
            }
        }
        for (int j = [TimeArray count] - 1; j >= 0; j--) {
            NSMutableString* temp_str = [NSMutableString stringWithString:(NSMutableString*)[TimeArray objectAtIndex:j]];
            if ([temp_str length] == 8) {
                [temp_str insertString:@"-" atIndex:4];
                [temp_str insertString:@"-" atIndex:7];
            }
            [TimeArray_copy addObject:temp_str];
        }
        NSLog(@"%@",TimeArray_copy);
        
        if ([TimeArray_copy count] == 0) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请先收藏比赛" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
        [m_delegate.randomPickerView setPickerDataArray:TimeArray_copy];
        [m_delegate.randomPickerView setPickerNum:self.currentDatePickNum withMinNum:0 andMaxNum:[TimeArray_copy count]];
    }
    
}
#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    tableRowNum = 0;
    [m_tableView reloadData];
    NSString*   state = @"";
    state = [state stringByAppendingFormat:@"%d",m_typeTag];
    
    NSMutableString*  date = [NSMutableString stringWithFormat:@"%@", [m_delegate.randomPickerView.pickerNumArray objectAtIndex:num]];
    while (((NSRange)[date rangeOfString:@"-"]).location != NSNotFound) {
        NSRange range = [date rangeOfString:@"-"];
        [date deleteCharactersInRange:range];
    }
    NSString* requestTYpe = @"";
    if (self.type == JCLQ) {
        requestTYpe = @"immediateScoreJcl";
    }
    else if(self.type == JCZQ)
    {
        requestTYpe = @"immediateScore";
    }
    else
    {
        requestTYpe = @"immediateScore";
    }
    self.currentTime = date;
    self.currentDatePickNum = num;
    [m_dateChooseButton setTitle:[m_delegate.randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
    
    //************//
    //**北京单场***//
    //************//
    
    if (m_typeTag != 4) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [mDict setObject:@"jingCai" forKey:@"command"];
        [mDict setObject:requestTYpe forKey:@"requestType"];
        [mDict setObject:state forKey:@"type"];
        [mDict setObject:date forKey:@"date"];
        [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
    }
    else
    {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [mDict setObject:@"jingCai" forKey:@"command"];
        [mDict setObject:requestTYpe forKey:@"requestType"];
        [mDict setObject:@"0" forKey:@"type"];
        [mDict setObject:date forKey:@"date"];
        [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        
    }
    
}
//收藏 点击事件
- (void)shouCangButtonClick:(BOOL)isSelect INDEX:(NSString*)event
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:m_Data];
    [jsonParser release];
    jsonParser = Nil;
    NSArray* resultArray = (NSArray*)[parserDict objectForKey:@"result"];
    /*
     副本
     对于(NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag]
     的修改 容易崩溃
     
     保存的格式
     "instantScore_JCLQ":[
         (NSMutableDictionary)
         "2013-01-18":（NSArray数组）{
         0_20130117_4_301
         0_20130117_4_301
         0_20130117_4_301
         0_20130117_4_301
         0_20130117_4_301
         }
         "2013-01-19":{
         0_20130117_4_3022
         0_20130117_4_3022
         0_20130117_4_3022
         }
     ]
     */
    
    NSInteger index = 0;
    for (int m = 0; m < [resultArray count]; m++) {
        if ([event isEqualToString:KISNullValue(resultArray, m, @"event")]) {
            index = m;
            break;
        }
    }
    NSArray* UserSavedArray = [NSArray arrayWithArray:(NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag]];
    NSLog(@"UserSavedArray:::::::::%@",UserSavedArray);
    NSMutableArray* UserSavedArray_copy;
    
    BOOL hasSave = NO;
    NSInteger saveIndex = 0;
    //检测是否 存过这个当前时间
    for (int i = 0; i < [UserSavedArray count]; i++) {
        if ([[UserSavedArray objectAtIndex:i] objectForKey:self.currentTime] != nil) {
            hasSave = YES;
            saveIndex = i;
            break;
        }
    }
    
    if (m_typeTag != 4) {
        if (UserSavedArray == Nil && isSelect) {
            UserSavedArray_copy = [NSMutableArray array];
            NSLog(@"event---------------%@\n============m_currentTime：%@",KISNullValue(resultArray, index, @"event"),self.currentTime);
            
            NSMutableDictionary*   timeDict = [NSMutableDictionary dictionary];
            NSMutableArray* eventArray = [NSMutableArray array];
            
            [eventArray addObject:KISNullValue(resultArray, index, @"event")];
            [timeDict setValue:eventArray forKey:self.currentTime];
            [UserSavedArray_copy addObject:timeDict];
            [self showClickOrNoMessage:@"已添加至“我的关注”"];
        }
        else if (UserSavedArray != Nil) {
            if (isSelect)
            {
                NSLog(@"%@",[resultArray objectAtIndex:index]);
                UserSavedArray_copy = [NSMutableArray arrayWithArray:UserSavedArray];
                if (hasSave)
                {       
                    NSMutableDictionary*   timeDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[UserSavedArray objectAtIndex:saveIndex]];
                    NSMutableArray* eventArray = [NSMutableArray arrayWithArray:(NSArray*)[timeDict objectForKey:self.currentTime]];
                    [eventArray addObject:KISNullValue(resultArray, index, @"event")];
                    [timeDict setValue:eventArray forKey:self.currentTime];
                    [UserSavedArray_copy replaceObjectAtIndex:saveIndex withObject:timeDict];
                }
                else
                {
                    NSMutableDictionary*   timeDict = [NSMutableDictionary dictionary];
                    NSMutableArray* eventArray = [NSMutableArray array];
                    
                    [eventArray addObject:KISNullValue(resultArray, index, @"event")];
                    [timeDict setValue:eventArray forKey:self.currentTime];
                    [UserSavedArray_copy addObject:timeDict];
                }
                [self showClickOrNoMessage:@"已添加至“我的关注”"];
            }
            else
            {
                UserSavedArray_copy = [NSMutableArray arrayWithArray:UserSavedArray];
                NSMutableDictionary*   timeDict =  [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[UserSavedArray objectAtIndex:saveIndex]];
 
                NSMutableArray* eventArray = [NSMutableArray arrayWithArray:(NSArray*)[timeDict objectForKey:self.currentTime]];
                NSInteger temp_index = 0;
                for (int i = 0; i < [eventArray count]; i++) {
                    if ([(NSString*)[eventArray objectAtIndex:i] isEqualToString:KISNullValue(resultArray, index, @"event")]) {
                        temp_index = i;
                    }
                }
                [eventArray removeObjectAtIndex:temp_index];
                NSLog(@"eventArray: %@",eventArray);
                NSLog(@"timeDict : %@",timeDict);
                if ([eventArray  count] == 0) {
                    [UserSavedArray_copy removeObjectAtIndex:saveIndex];
                }
                else
                {
                    [timeDict setValue:eventArray forKey:self.currentTime];
                    [UserSavedArray_copy replaceObjectAtIndex:saveIndex withObject:timeDict];
                }
                [self showClickOrNoMessage:@"已取消关注"];
            }
        }
        NSLog(@"UserSavedArray_copy--------------%@",UserSavedArray_copy);
        if ([UserSavedArray_copy count] == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.userDefaultsTag];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:UserSavedArray_copy forKey:self.userDefaultsTag];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];//tongbu
  
    }
    else
    {
        /*&& UserSavedArray_copy != nil*/
        if (!isSelect) {
            UserSavedArray_copy = [NSMutableArray arrayWithArray:UserSavedArray];
            NSMutableDictionary*   timeDict = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[UserSavedArray objectAtIndex:saveIndex]];
 
            NSMutableArray* eventArray = [NSMutableArray arrayWithArray:(NSArray*)[timeDict objectForKey:self.currentTime]];
            //找到那个数组
            NSInteger temp_index = 0;
            for (int i = 0; i < [eventArray count]; i++) {
                if ([(NSString*)[eventArray objectAtIndex:i] isEqualToString:KISNullValue(resultArray, index, @"event")]) {
                    temp_index = i;
                }
            }
            [eventArray removeObjectAtIndex:temp_index];
            //eventArray 为空判断 NSMutableDictionary 不能存 空数据
            if ([eventArray  count] == 0) {
                [UserSavedArray_copy removeObjectAtIndex:saveIndex];
            }
            else
            {
                [timeDict setValue:eventArray forKey:self.currentTime];
                [UserSavedArray_copy replaceObjectAtIndex:saveIndex withObject:timeDict];
            }
            //UserSavedArray_copy 为空判断
            if ([UserSavedArray_copy count] == 0) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.userDefaultsTag];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setValue:UserSavedArray_copy forKey:self.userDefaultsTag];
            }

            [[NSUserDefaults standardUserDefaults] synchronize];//tongbu
            [self showClickOrNoMessage:@"已取消关注"];
        }
        tableRowNum = [[self getCurrentShouCangArray] count];
    }
    
    [self setupTitle];
    [m_tableView reloadData];
    NSLog(@"%@",(NSMutableDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag]);
}
-(NSArray*) getCurrentShouCangArray
{
    NSInteger curretnIndex = 0;
    NSArray* UserSavedArray = (NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:self.userDefaultsTag];
    for (int i= 0; i < [UserSavedArray count]; i++) {
        if ([(NSDictionary*)[UserSavedArray objectAtIndex:i] objectForKey:self.currentTime] != Nil) {
            curretnIndex = i;
        }
 
    }
    return (NSArray*)[(NSDictionary*)[UserSavedArray objectAtIndex:curretnIndex] objectForKey:self.currentTime];
}

-(void) showClickOrNoMessage:(NSString*)Message
{
    [m_messageView removeFromSuperview];
    [m_messageView release];
	m_messageView = [[UIView alloc]initWithFrame:CGRectMake(60, [UIScreen mainScreen].bounds.size.height - 20 - 50 - 60, 200, 30)];
	m_messageView.alpha = 0.8;
	[m_messageView setBackgroundColor:[UIColor darkGrayColor]];
	[m_messageView.layer setCornerRadius:6];
	m_messageView.clipsToBounds = YES;
	[self.view addSubview:m_messageView];
    
	UILabel *mLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 20)] autorelease];
	[mLabel setBackgroundColor:[UIColor clearColor]];
	[mLabel setTextColor:[UIColor whiteColor]];
	mLabel.textAlignment = UITextAlignmentCenter;
	mLabel.font = [UIFont systemFontOfSize:15];
    mLabel.text = Message;
    [m_messageView addSubview:mLabel];

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];
	[self performSelector:@selector(hideView) withObject:nil afterDelay:2.0f];
}

-(void) hideView
{
    m_messageView.hidden = YES;
}

#pragma mark 日期的转化

//把日期格式加上"_"  20130706转化为2013_07_06
- (NSString*) stringWithDateString:(NSString*)dateString
{
    if (dateString.length == 8) {
        NSMutableString *dateStr = [NSMutableString stringWithString:dateString];
        [dateStr insertString:@"-" atIndex:4];
        [dateStr insertString:@"-" atIndex:7];
        return dateStr;
    }
    else
    {
        return @"";
    }
}

//去掉日期的"_"
- (NSString*) stringDateWithString:(NSMutableString*)dateString
{
    while (((NSRange)[dateString rangeOfString:@"-"]).location != NSNotFound) {
        NSRange range = [dateString rangeOfString:@"-"];
        [dateString deleteCharactersInRange:range];
    }
    return dateString;
}

//根据Event获取日期
- (NSString*) getDateWithEvent:(NSString*)event
{
    if (event) {
        NSArray *array = [event componentsSeparatedByString:@"_"];
        
        return [array objectAtIndex:1];
    }
    else
    {
        return @"";
    }
}

#pragma mark -CustomSegmentedControlDelegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"customer segmented  %d",index);
//    [self segmentedChangeValue:index];
    [self segmentedChangeForIndex:index];
    
}

@end
 
