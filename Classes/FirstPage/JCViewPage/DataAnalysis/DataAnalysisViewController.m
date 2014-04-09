







//
//  DataAnalysisViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataAnalysisViewController.h"
#import "RuYiCaiAppDelegate.h"

#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "SBJsonParser.h"
#import "NewsViewController.h"
#import "DataAnalysis_xi_TableCell.h"
#import "DataAnalysis_Europ_TableCell.h"
#import "DataAnalysis_Asia_TableCell.h"
#import "DataAnalysis_top_tableCell.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface DataAnalysisViewController (internal)

- (void)changeUserClick;
- (void)segmentedChange:(id)sender;
- (void)getDataAnalysisOK:(NSNotification *)notification;

- (void)getPaserDataAndPerformt;
@end

@implementation DataAnalysisViewController

@synthesize event = m_event;
@synthesize isZC = m_isZC;
@synthesize isJCLQ = m_isJCLQ;
@synthesize isBJDC = m_isBJDC;
//@synthesize tableView = m_tableView;
@synthesize typeIdArray = m_typeIdArray;
@synthesize segmentedView = m_segmentedView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getDataAnalysisOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
    
    
    for (int i = 0; i < 5; i++) {
        [m_tableView[i] release], m_tableView[i] = nil;
    }
    
    [m_typeIdArray release], m_typeIdArray = nil;
    
    [m_tableHeaderState release], m_tableHeaderState = nil;
    if (m_recordTitleViewState != nil)
    {
        [m_recordTitleViewState release], m_recordTitleViewState = nil;
    }
    if (m_dataDic) {
        KSafe_Free(m_dataDic);
    }
    [m_recommendData release];
    [m_imageTopBg release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataAnalysisOK:) name:@"getDataAnalysisOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];//推荐数据
    [BackBarButtonItemUtils addBackButtonForController:self];
    if (self.isJCLQ) {
        self.segmentedView = [[[CustomSegmentedControl alloc]
                               initWithFrame:CGRectMake(5, 0, 310, 30)
                               andNormalImages:[NSArray arrayWithObjects:
                                                @"analysis_c_btn.png",
                                                @"ouzhi_c_btn.png",
                                                @"yapan_c_nomal.png",
                                                nil]
                               
                               andHighlightedImages:[NSArray arrayWithObjects:
                                                     @"analysis_c_btn.png",
                                                     @"ouzhi_c_btn.png",
                                                     @"yapan_c_nomal.png",
                                                     nil]
                               
                               andSelectImage:[NSArray arrayWithObjects:
                                               @"analysis_c_click.png",
                                               @"ouzhi_c_click.png",
                                               @"yapan_c_click.png",
                                               nil]]autorelease];

        
    }
    else if(self.isZC)
    {
        self.segmentedView = [[[CustomSegmentedControl alloc]
                               initWithFrame:CGRectMake(5, 0, 310, 30)
                               andNormalImages:[NSArray arrayWithObjects:
                                                @"analysis_c_btn.png",
                                                @"ouzhi_c_btn.png",
                                                @"yapan_c_nomal.png",
                                                nil]
                               
                               andHighlightedImages:[NSArray arrayWithObjects:
                                                     @"analysis_c_btn.png",
                                                     @"ouzhi_c_btn.png",
                                                     @"yapan_c_nomal.png",
                                                     nil]
                               
                               andSelectImage:[NSArray arrayWithObjects:
                                               @"analysis_c_click.png",
                                               @"ouzhi_c_click.png",
                                               @"yapan_c_click.png",
                                               nil]]autorelease];
 
        
    }
    else
    {
        self.segmentedView = [[[CustomSegmentedControl alloc]
                               initWithFrame:CGRectMake(5, 0, 310, 30)
                               andNormalImages:[NSArray arrayWithObjects:
                                                @"analysis_c_7btn.png",
                                                @"ouzhi_c_7_btn.png",
                                                @"yapan_c_7_btn.png",@"tuijian_c7_btn.png",
                                                nil]
                               
                               andHighlightedImages:[NSArray arrayWithObjects:
                                                     @"analysis_c_7btn.png",
                                                     @"ouzhi_c_7_btn.png",
                                                     @"yapan_c_7_btn.png",@"tuijian_c7_btn.png",
                                                     nil]
                               
                               andSelectImage:[NSArray arrayWithObjects:
                                               @"analysis_c_7click.png",
                                               @"ouzhi_c_7_click.png",
                                               @"yapan_c_7_click.png",@"tuijian_c7_click.png",
                                               nil]]autorelease];
        
        
        
        
    }
    self.segmentedView.delegate = self;
    [self.view addSubview:self.segmentedView];
    [self segmentedChangeValue:0];
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    
    for (int i = 0; i < self.segmentedView.numberOfSegments; i++) {
        if (i == 0 || (i == self.segmentedView.numberOfSegments - 1 && !self.isZC)) {
            if (i == 0 ) {
                m_tableView[i] = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height - 64 - 60) style:UITableViewStyleGrouped];
                m_tableView[i].contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
                m_tableView[i].delegate = self;
                m_tableView[i].dataSource = self;
                m_tableView[i].allowsSelection=NO;
                m_tableView[i].separatorStyle = UITableViewCellSeparatorStyleNone;
                [self.view addSubview:m_tableView[i]];
            }
            else if(i == self.segmentedView.numberOfSegments - 1 && !self.isZC)
            {
                m_tableView[i] = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, [UIScreen mainScreen].bounds.size.height- 64 - 30) style:UITableViewStyleGrouped];
                m_tableView[i].contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
                m_tableView[i].delegate = self;
                m_tableView[i].dataSource = self;
                m_tableView[i].allowsSelection=NO;
                m_tableView[i].separatorStyle = UITableViewCellSeparatorStyleNone;
                [self.view addSubview:m_tableView[i]];
                m_tableView[i].hidden = YES;
            }
        }
        else
        {
            m_tableView[i] = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, [UIScreen mainScreen].bounds.size.height- 64 - 32) style:UITableViewStylePlain];
            m_tableView[i].delegate = self;
            m_tableView[i].dataSource = self;
            m_tableView[i].allowsSelection=NO;
            [self.view addSubview:m_tableView[i]];
            m_tableView[i].hidden = YES;
        }
    }
    
    //    m_tableView.rowHeight = 35;
    
    m_imageTopBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 320, 30)];
    m_imageTopBg.image = RYCImageNamed(@"analysis_top_bg.png");
    [self.view addSubview:m_imageTopBg];
    
    m_typeIdArray = [[NSMutableArray alloc] initWithCapacity:1];
    m_recommendData = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_typeTag = 0;//默认 分析
    m_headerCount = 0;
    m_rankingsCount = 0;
    
    m_homePreSchedulesCount = 0;
    m_homeAfterSchedulesCount = 0;
    m_guestAfterSchedulesCount = 0;
    m_guestPreSchedulesCount = 0;
    m_preClashSchedulesCount = 0;
    //联网 请求 requestType = dataAnalysisJcl    足球：requestType = dataAnalysis
    if (self.isBJDC) {
        [[RuYiCaiNetworkManager sharedManager] getDataAnalysis:m_event REQUESTTYPE:@"dataAnalysis" ISZC:2];
    }
    else
        [[RuYiCaiNetworkManager sharedManager] getDataAnalysis:m_event REQUESTTYPE:(self.isJCLQ ? @"dataAnalysisJcl" : @"dataAnalysis") ISZC:self.isZC];
}



- (void)getDataAnalysisOK:(NSNotification *)notification
{
    //    [self getPaserDataAndPerformt];
    for (int i = 0; i < self.segmentedView.numberOfSegments; i++) {
        if (!self.isJCLQ && i == self.segmentedView.numberOfSegments - 1 && !self.isZC) {//竞彩足球推荐
            m_typeTag = i + 1;
        }
        else
            m_typeTag = i;
        [self getPaserDataAndPerformt];
        [m_tableView[i] reloadData];
    }
    m_typeTag = 0;
    
    UILabel* homeLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    homeLable.textColor = [UIColor blackColor];
    homeLable.text = [NSString stringWithFormat:@"%@(主队)", KISDictionaryHaveKey(m_dataDic, @"homeTeam")];
    homeLable.font = [UIFont systemFontOfSize:13.0f];
    homeLable.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        homeLable.textAlignment = NSTextAlignmentCenter;
    else
        homeLable.textAlignment = UITextAlignmentCenter;
    homeLable.numberOfLines = 2;
    [m_imageTopBg addSubview:homeLable];
    
    UILabel* guestLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 30)];
    guestLable.textColor = [UIColor blackColor];
    guestLable.text = [NSString stringWithFormat:@"%@(客队)", KISDictionaryHaveKey(m_dataDic, @"guestTeam")];
    guestLable.font = [UIFont systemFontOfSize:13.0f];
    guestLable.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        guestLable.textAlignment = NSTextAlignmentCenter;
    else
        guestLable.textAlignment = UITextAlignmentCenter;
    guestLable.numberOfLines = 2;
    [m_imageTopBg addSubview:guestLable];
    
    if (self.isJCLQ) {
        homeLable.frame = CGRectMake(160, 0, 160, 30);
        guestLable.frame = CGRectMake(0, 0, 160, 30);
    }
    [homeLable release];
    [guestLable release];
    
    if (m_tableHeaderState != nil)
    {
        [m_tableHeaderState removeAllObjects];
        [m_tableHeaderState release];
    }
    m_tableHeaderState = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < m_headerCount; i++)
    {
        if (i == 0) {
            m_SectionN[i] =  m_rankingsCount;
            [m_tableHeaderState addObject:@"1"];
        }
        else
        {
            m_SectionN[i] = 0;
            [m_tableHeaderState addObject:@"0"];
        }
    }
    [m_tableView[m_typeTag] reloadData];
}

#pragma mark 推荐数据
- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    if ([errorCode isEqualToString:@"0000"]) {
        [m_recommendData removeAllObjects];
        [m_recommendData addObjectsFromArray:(NSArray*)[parserDict objectForKey:@"result"]];
        
        if (m_recordTitleViewState != nil)
        {
            [m_recordTitleViewState removeAllObjects];
            [m_recordTitleViewState release], m_recordTitleViewState = nil;
        }
        m_recordTitleViewState = [[NSMutableArray alloc] initWithCapacity:1];
        for (int j = 0; j < [m_recommendData count]; j++) {
            [m_recordTitleViewState addObject:@"0"];
            CGSize contentSize = [[[m_recommendData objectAtIndex:j] objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
            m_reommendHeight[j] = contentSize.height;
        }
        [m_tableView[self.segmentedView.numberOfSegments - 1] reloadData];
    }
    else
    {
        UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
        cLabel.text = [parserDict objectForKey:@"message"];
        cLabel.textAlignment = UITextAlignmentCenter;
        cLabel.textColor = kColorWithRGB(116.0, 116.0, 116.0, 1.0);
        cLabel.font = [UIFont boldSystemFontOfSize:20];
        cLabel.backgroundColor = [UIColor clearColor];
        [m_tableView[self.segmentedView.numberOfSegments - 1] addSubview:cLabel];
        [cLabel release];
    }
}

#pragma  mark tableDelegate
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_tableView[0]) {
        return 40;
    }
    else if(tableView == m_tableView[1])
    {
        return 60;
    }
    else if(tableView == m_tableView[self.segmentedView.numberOfSegments-1] && !self.isZC)
        return m_reommendHeight[indexPath.section];
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    NSDictionary* Dict = (NSDictionary*)[parserDict objectForKey:@"result"];
    NSDictionary* schedule = (NSDictionary*)[Dict objectForKey:@"schedule"];
    if (m_tableView[0] == tableView)//分析
    {
        static NSString *myCellIdentifier = @"Schedules";
        
        DataAnalysis_xi_TableCell* cell = (DataAnalysis_xi_TableCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[DataAnalysis_xi_TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        }
        cell.isJCLQ = self.isJCLQ;
        cell.currentHometeamId = KISDictionaryHaveKey(schedule, @"homeTeamId");
        cell.currentGuestteamId = KISDictionaryHaveKey(schedule, @"guestTeamId");
        
        NSString* arrayKey = @"";
        BOOL isFurtureGame = FALSE;
        BOOL iIsLeagueRanks = FALSE;
        
        NSInteger sectionIndex = indexPath.section;
        if (sectionIndex == 0)
        {
            iIsLeagueRanks = TRUE;
            cell.tag = indexPath.row;
            if (indexPath.row > 0)
            {
                arrayKey = @"rankings";
                NSArray* Array = (NSArray*)[Dict objectForKey:arrayKey];
                cell.ranksData = (NSDictionary*)[Array objectAtIndex:(indexPath.row - 1)];
            }
            cell.iIsLeagueRanks = iIsLeagueRanks;
            cell.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
            [cell refreshTableCell];
            return cell;
        }
        if(sectionIndex == 1)
        {
            arrayKey = @"homePreSchedules";
        }
        if(sectionIndex == 2)
        {
            arrayKey = @"guestPreSchedules";
        }
        if(sectionIndex == 3)
        {
            arrayKey = @"homeAfterSchedules";
            isFurtureGame = TRUE;
        }
        if(sectionIndex == 4)
        {
            arrayKey = @"guestAfterSchedules";
            isFurtureGame = TRUE;
        }
        if(sectionIndex == 5)
        {
            arrayKey = @"preClashSchedules";
        }
        
        NSArray* SchedulesArray = (NSArray*)[Dict objectForKey:arrayKey];
        cell.tag = indexPath.row;
        if (indexPath.row > 0) {
            cell.dayTime = KISNullValue(SchedulesArray, (indexPath.row - 1), @"matchTime");
            cell.homeTeam =  KISNullValue(SchedulesArray, (indexPath.row - 1), @"homeTeam");
            cell.hometeamId = KISNullValue(SchedulesArray, (indexPath.row - 1), @"homeTeamId");
            cell.allGameScore =  KISNullValue(SchedulesArray, (indexPath.row - 1), @"score");
            cell.visitTeam =  KISNullValue(SchedulesArray, (indexPath.row - 1), @"guestTeam");
            cell.guestteamId = KISNullValue(SchedulesArray, (indexPath.row - 1), @"guestTeamId");
        }
        cell.iIsLeagueRanks = iIsLeagueRanks;
        cell.iIsFutrueGame = isFurtureGame;
        cell.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
        [cell refreshTableCell];
        return cell;
    }
    else if(m_tableView[1] == tableView)//欧指
    {
        
        static NSString *myCellIdentifier = @"standards";
        
        NSArray* SchedulesArray = (NSArray*)[Dict objectForKey:@"standards"];
        
        DataAnalysis_Europ_TableCell* cell = (DataAnalysis_Europ_TableCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[DataAnalysis_Europ_TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        }
        cell.isJCLQ = self.isJCLQ;
        
        cell.companyName = KISNullValue(SchedulesArray, indexPath.row, @"companyName");
        cell.homeWin = KISNullValue(SchedulesArray, indexPath.row, @"homeWin");
        cell.standoff = KISNullValue(SchedulesArray, indexPath.row, @"standoff");
        cell.guestWin = KISNullValue(SchedulesArray, indexPath.row, @"guestWin");
        
        NSString* homeWinLu = @"";
        homeWinLu = [homeWinLu stringByAppendingFormat:@"%@" ,KISNullValue(SchedulesArray, indexPath.row, (self.isJCLQ ? @"homeWinLv" : @"homeWinLu"))];
        if ([homeWinLu length] > 0) {
            homeWinLu = [homeWinLu stringByAppendingString:@"%"];
        }
        
        NSString* standoffLu = @"";
        standoffLu = [standoffLu stringByAppendingFormat:@"%@" ,KISNullValue(SchedulesArray, indexPath.row, (self.isJCLQ ? @"standoffLv" : @"standoffLu"))];
        if ([standoffLu length] > 0) {
            standoffLu = [standoffLu stringByAppendingString:@"%"];
        }
        
        NSString* guestWinLu = @"";
        guestWinLu = [guestWinLu stringByAppendingFormat:@"%@" ,KISNullValue(SchedulesArray, indexPath.row, (self.isJCLQ ? @"guestWinLv" : @"guestWinLu"))];
        if ([guestWinLu length] > 0) {
            guestWinLu = [guestWinLu stringByAppendingString:@"%"];
        }
        cell.homeWinLu = homeWinLu;
        cell.standoffLu = standoffLu;
        cell.guestWinLu = guestWinLu;
        
        
        cell.k_h = KISNullValue(SchedulesArray, indexPath.row, @"k_h");
        cell.k_s = KISNullValue(SchedulesArray, indexPath.row, @"k_s");
        cell.k_g = KISNullValue(SchedulesArray, indexPath.row, @"k_g");
        NSString* fanhuanlu = KISNullValue(SchedulesArray, indexPath.row, (self.isJCLQ ? @"fanHuanLv" : @"fanHuanLu"));
        if ([fanhuanlu length] > 0) {
            fanhuanlu = [fanhuanlu stringByAppendingString:@"%"];
        }
        
        cell.fanHuanLu = fanhuanlu;
        
        cell.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
        [cell refreshTableCell];
        return cell;
    }
    else if(m_tableView[2] == tableView)//亚盘 让分
    {
        static NSString *myCellIdentifier = @"letGoals";
        NSArray* SchedulesArray = (NSArray*)[Dict objectForKey:@"letGoals"];
        DataAnalysis_Asia_TableCell* cell = (DataAnalysis_Asia_TableCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[DataAnalysis_Asia_TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        }
        
        cell.firstDownodds = KISNullValue(SchedulesArray, indexPath.row, @"firstDownodds");
        cell.upOdds = KISNullValue(SchedulesArray, indexPath.row, @"upOdds");
        cell.downOdds = KISNullValue(SchedulesArray, indexPath.row, @"downOdds");
        cell.companyName = KISNullValue(SchedulesArray, indexPath.row, @"companyName");
        cell.firstUpodds = KISNullValue(SchedulesArray, indexPath.row, @"firstUpodds");
        
        if (self.isJCLQ) {
            cell.firstGoal = KISNullValue(SchedulesArray, indexPath.row, @"firstGoal");
            cell.goal = KISNullValue(SchedulesArray, indexPath.row, @"goal");
        }
        else{
            cell.firstGoal = KISNullValue(SchedulesArray, indexPath.row, @"firstGoalName");
            cell.goal = KISNullValue(SchedulesArray, indexPath.row, @"goalName");
        }
        
        cell.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
        cell.isJCLQ = self.isJCLQ;
        [cell refreshTableCell];
        return cell;
        
    }
    else if(m_tableView[3] == tableView && self.isJCLQ)
    {
        static NSString* myCellIdentifier = @"totalScores";
        NSArray* SchedulesArray = (NSArray*)[Dict objectForKey:@"totalScores"];
        DataAnalysis_Asia_TableCell* cell = (DataAnalysis_Asia_TableCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[DataAnalysis_Asia_TableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        }
        cell.tag = indexPath.row;
        
        cell.companyName = KISNullValue(SchedulesArray, indexPath.row, @"companyName");
        cell.firstUpodds = KISNullValue(SchedulesArray, indexPath.row , @"firstUpodds");
        cell.firstGoal = KISNullValue(SchedulesArray, indexPath.row, @"firstGoal");
        cell.firstDownodds = KISNullValue(SchedulesArray, indexPath.row, @"firstDownodds");
        
        cell.upOdds = KISNullValue(SchedulesArray, indexPath.row, @"upOdds");
        cell.goal = KISNullValue(SchedulesArray, indexPath.row, @"goal");
        cell.downOdds = KISNullValue(SchedulesArray, indexPath.row, @"downOdds");
        
        cell.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
        [cell refreshTableCell];
        return cell;
    }
    else
    {
        static NSString* myCellIdentifier = @"recommend";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        }
        UIView* writeImage_one = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
        writeImage_one.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:writeImage_one];
        [writeImage_one release];
        
        UIView* writeImage_two = [[UIView alloc] initWithFrame:CGRectMake(293, 0, 7, 7)];
        writeImage_two.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:writeImage_two];
        [writeImage_two release];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.backgroundColor = [UIColor whiteColor];
        if([m_recommendData count] > 0)
            cell.textLabel.text = [[m_recommendData objectAtIndex:indexPath.section] objectForKey:@"content"];
        return cell;
    }
    return Nil;
}
- (void)pressTitle:(id)sender
{
    UIButton *temp = (UIButton *)sender;
	int temptag = temp.tag;
    if (0 == m_typeTag) {
        if ([m_tableHeaderState objectAtIndex:temptag] == @"0")
        {
            [m_tableHeaderState replaceObjectAtIndex:temptag withObject:@"1"];
            NSInteger count = 0;
            if (temptag == 0) {
                count = m_rankingsCount;
            }
            else if(temptag == 1)
            {
                count = m_homePreSchedulesCount;
            }
            else if(temptag == 2)
            {
                count = m_guestPreSchedulesCount;
            }
            else if(temptag == 3)
            {
                count = m_homeAfterSchedulesCount;
            }
            else if(temptag == 4)
            {
                count = m_guestAfterSchedulesCount;
            }
            else if(temptag == 5)
            {
                count = m_preClashSchedulesCount;
            }
            
            m_SectionN[temptag] = count;
            
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateNormal];
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateHighlighted];
        }
        else if([m_tableHeaderState objectAtIndex:temptag] == @"1"){
            [m_tableHeaderState replaceObjectAtIndex:temptag withObject:@"0"];
            m_SectionN[temptag] = 0;
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateNormal];
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateHighlighted];
        }
        [m_tableView[m_typeTag] reloadData];
    }
    else
    {
        if ([m_recordTitleViewState objectAtIndex:temptag] == @"0")
        {
            [m_recordTitleViewState replaceObjectAtIndex:temptag withObject:@"1"];
            
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateNormal];
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateHighlighted];
        }
        else if([m_recordTitleViewState objectAtIndex:temptag] == @"1"){
            [m_recordTitleViewState replaceObjectAtIndex:temptag withObject:@"0"];
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateNormal];
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateHighlighted];
        }
        [m_tableView[self.segmentedView.numberOfSegments-1] reloadData];
    }
}
//指定有多少个分区（section） 默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //默认是1
    if (tableView == m_tableView[0]) {
        return m_headerCount;
    }
    else if(tableView == m_tableView[self.segmentedView.numberOfSegments-1] && !self.isZC){
        return [m_recommendData count];
    }
    return 1;
    
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //根据数组 来定
    if (tableView == m_tableView[0]) {
        return m_SectionN[section];
    }
    else if(tableView == m_tableView[self.segmentedView.numberOfSegments-1] && !self.isZC)
    {
        if ([[m_recordTitleViewState objectAtIndex:section] isEqualToString:@"1"]) {
            return 1;
        }
        return 0;
    }
    NSLog(@"%d", tableRowNum);
    return tableRowNum;
}
//创建 uitableview的 header
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == m_tableView[0]) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = section;
        //0 隐藏 1-- 展开
        if ([m_tableHeaderState objectAtIndex:section] == @"0"){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"jclq_sectionlisthide.png"];
            [button addSubview:image];
            [image release];
        }
        else if([m_tableHeaderState objectAtIndex:section] == @"1"){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"jclq_sectionlistexpand.png"];
            [button addSubview:image];
            [image release];
        }
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
        
        NSString* title = @"";
        
        NSLog(@"m_dataDic %@", m_dataDic);
        if (section == 0) {
            title = [NSString stringWithFormat:@"联赛排名(主队%@ 客队%@)", [m_dataDic objectForKey:@"homeRanking"], [m_dataDic objectForKey:@"guestRanking"]];
        }
        else if(section == 1)
        {
            if (self.isJCLQ) {//竞彩篮球没有平
                title = [NSString stringWithFormat:@"主队近期战绩(近%@场 %@胜%@负)", [m_dataDic objectForKey:@"homePreMatchCount"], [m_dataDic objectForKey:@"homePreWinCount"], [m_dataDic objectForKey:@"homePreLoseCount"]];
            }
            else
                title = [NSString stringWithFormat:@"主队近期战绩(近%@场 %@胜%@平%@负)", [m_dataDic objectForKey:@"homePreMatchCount"], [m_dataDic objectForKey:@"homePreWinCount"], [m_dataDic objectForKey:@"homePreStandoffCount"], [m_dataDic objectForKey:@"homePreLoseCount"]];
        }
        else if(section == 2)
        {
            if (self.isJCLQ) {//竞彩篮球没有平
                title = [NSString stringWithFormat:@"客队近期战绩(近%@场 %@胜%@负)", [m_dataDic objectForKey:@"guestPreMatchCount"], [m_dataDic objectForKey:@"guestPreWinCount"], [m_dataDic objectForKey:@"guestPreLoseCount"]];
            }
            else
                title = [NSString stringWithFormat:@"客队近期战绩(近%@场 %@胜%@平%@负)", [m_dataDic objectForKey:@"guestPreMatchCount"], [m_dataDic objectForKey:@"guestPreWinCount"], [m_dataDic objectForKey:@"guestPreStandoffCount"], [m_dataDic objectForKey:@"guestPreLoseCount"]];
        }
        else if(section == 3)
        {
            title = @"主队未来五场比赛";
        }
        else if(section == 4)
        {
            title = @"客队未来五场比赛";
        }
        else if(section == 5)
        {
            title = @"历史交锋";
        }
        [button setTitle:title forState:UIControlStateNormal];
        return button;
    }
    else if (tableView == m_tableView[self.segmentedView.numberOfSegments-1] && !self.isZC) {//推荐
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = section;
        //0 隐藏 1-- 展开
        if ([m_recordTitleViewState objectAtIndex:section] == @"0"){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"jclq_sectionlisthide.png"];
            [button addSubview:image];
            [image release];
        }
        else if([m_recordTitleViewState objectAtIndex:section] == @"1"){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"jclq_sectionlistexpand.png"];
            [button addSubview:image];
            [image release];
        }
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        button.titleLabel.numberOfLines = 2;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
        if ([m_recommendData count] > 0) {
            [button setTitle:[[m_recommendData objectAtIndex:section] objectForKey:@"title"] forState:UIControlStateNormal];
        }
        
        return button;
    }
    else
    {
        DataAnalysis_top_tableCell*  topView = [[[DataAnalysis_top_tableCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
        topView.isJCLQ = self.isJCLQ;
        //        switch (m_typeTag) {
        //            case 1:
        //                topView.topType = TOPCELL_EUROP;
        //                break;
        //            case 2:
        //                if (self.isJCLQ) {
        //                    topView.topType = TOPTYPE_RANGFEN;
        //                }
        //                else
        //                    topView.topType = TOPCELL_ASIA;
        //                break;
        //            case 3:
        //                topView.topType = TOPTYPE_ALLSCORE;
        //            default:
        //                break;
        //        }
        if (tableView == m_tableView[1]) {
            topView.topType = TOPCELL_EUROP;
        }
        else if(tableView == m_tableView[2])
        {
            if (self.isJCLQ) {
                topView.topType = TOPTYPE_RANGFEN;
            }
            else
                topView.topType = TOPCELL_ASIA;
        }
        else
            topView.topType = TOPTYPE_ALLSCORE;
        
        return topView;
    }
    return Nil;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"title";
//}
//header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((tableView == m_tableView[self.segmentedView.numberOfSegments-1] && !self.isZC) || tableView == m_tableView[0]) {
        return 40;
    }
    return 35;
}
//选中cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getPaserDataAndPerformt
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSDictionary* Dic = (NSDictionary*)[parserDict objectForKey:@"result"];
    if ([errorCode isEqualToString:@"0000"]) {
        if (m_typeTag == 0 && ![@"" isEqual:KISDictionaryNullValue(Dic, @"rankings")])
        {
            if (self.isJCLQ) {
                NSArray* rankingsArray = (NSArray*)[Dic objectForKey:@"rankings"];
                m_rankingsCount = [rankingsArray count] + 1;
                m_headerCount = 6;
            }
            else
            {
                NSArray* rankingsArray = (NSArray*)[Dic objectForKey:@"rankings"];
                m_rankingsCount = [rankingsArray count] + 1;
                m_headerCount = 6;
                
            }
            NSArray* homePreSchedulesArray = (NSArray*)[Dic objectForKey:@"homePreSchedules"];
            NSArray* guestPreSchedulesArray = (NSArray*)[Dic objectForKey:@"guestPreSchedules"];
            NSArray* homeAfterSchedulesArray = (NSArray*)[Dic objectForKey:@"homeAfterSchedules"];
            NSArray* guestAfterSchedulesArray = (NSArray*)[Dic objectForKey:@"guestAfterSchedules"];
            NSArray* preClashSchedulesArray = (NSArray*)[Dic objectForKey:@"preClashSchedules"];
            
            m_homePreSchedulesCount = [homePreSchedulesArray count] + 1;
            m_guestPreSchedulesCount = [guestPreSchedulesArray count] + 1;
            m_homeAfterSchedulesCount = [homeAfterSchedulesArray count] + 1;
            m_guestAfterSchedulesCount = [guestAfterSchedulesArray count] + 1;
            m_preClashSchedulesCount = [preClashSchedulesArray count] + 1;
            
            //主客队排名等信息
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:KISDictionaryHaveKey(Dic, @"schedule")];
            [tempDic setObject:KISDictionaryHaveKey(Dic, @"homeRanking") forKey:@"homeRanking"];
            [tempDic setObject:KISDictionaryHaveKey(Dic, @"guestRanking") forKey:@"guestRanking"];
            [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"homePreMatchCount")] forKey:@"homePreMatchCount"];
            [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"guestPreMatchCount")] forKey:@"guestPreMatchCount"];
            [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"homePreWinCount")] forKey:@"homePreWinCount"];
            if (!self.isJCLQ) {//竞彩篮球没有平
                [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"homePreStandoffCount")] forKey:@"homePreStandoffCount"];
                [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"guestPreStandoffCount")] forKey:@"guestPreStandoffCount"];
            }
            [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"homePreLoseCount")] forKey:@"homePreLoseCount"];
            [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"guestPreWinCount")] forKey:@"guestPreWinCount"];
            [tempDic setObject:[NSString stringWithFormat:@"%@", KISDictionaryHaveKey(Dic, @"guestPreLoseCount")] forKey:@"guestPreLoseCount"];
            m_dataDic = [tempDic retain];
            
        }
        else if(m_typeTag == 1 && ![@"" isEqual:KISDictionaryNullValue(Dic, @"standards")])
        {
            NSArray* SchedulesArray = (NSArray*)[Dic objectForKey:@"standards"];
            tableRowNum = [SchedulesArray count];
            NSLog(@"ff %d", tableRowNum);
        }
        else if(m_typeTag == 2 && ![@"" isEqual:KISDictionaryNullValue(Dic, @"letGoals")])
        {
            NSArray* letGoalsArray = (NSArray*)[Dic objectForKey:@"letGoals"];
            tableRowNum = [letGoalsArray count];
        }
        else if(m_typeTag == 3 && ![@"" isEqual:KISDictionaryNullValue(Dic, @"totalScores")])
        {
            NSArray* totalScoresArray = (NSArray*)[Dic objectForKey:@"totalScores"];
            tableRowNum = [totalScoresArray count] ;
        }
        
    }
    else
    {
        //        [[RuYiCaiNetworkManager sharedManager] showMessage:[parserDict objectForKey:@"message"] withTitle:@"提示" buttonTitle:@"确定"];
        //        return;
        UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
        cLabel.text = [parserDict objectForKey:@"message"];
        cLabel.textAlignment = UITextAlignmentCenter;
        cLabel.textColor = kColorWithRGB(116.0, 116.0, 116.0, 1.0);
        cLabel.font = [UIFont boldSystemFontOfSize:20];
        cLabel.backgroundColor = [UIColor clearColor];
        [m_tableView[m_typeTag] addSubview:cLabel];
        [cLabel release];
    }
}
- (void)segmentedChangeValue:(NSInteger)index
{
    switch (self.segmentedView.segmentedIndex)
    {
        case 0:
        {
            m_typeTag = 0;
            m_imageTopBg.hidden = NO;
            break;
        }
        case 1:
        {
            m_typeTag = 1;
            m_imageTopBg.hidden = YES;
            
            break;
        }
        case 2:
        {
            m_typeTag = 2;
            m_imageTopBg.hidden = YES;
            
            break;
        }
        case 3:
        {
            if (self.isJCLQ) {
                m_typeTag = 3;
                m_imageTopBg.hidden = YES;
                
                break;
            }
        }
        case 4:
        {
            m_typeTag = 4;
            m_imageTopBg.hidden = YES;
            
            if ([m_recommendData count] == 0) {
                NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
                [tempDic setObject:@"jingCai" forKey:@"command"];
                [tempDic setObject:@"news" forKey:@"requestType"];
                [tempDic setObject:m_event forKey:@"event"];
                [tempDic setObject:@"0" forKey:@"pageindex"];
                [tempDic setObject:@"10" forKey:@"maxresult"];
                
                [RuYiCaiNetworkManager sharedManager].netLotType = NET_DONT_SHOWALTER;
                [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
                
            }
        }break;
        default:
            break;
            
    }
    //    if (4 != m_typeTag) {
    //        [self getPaserDataAndPerformt];
    //    }
    //    if(0 < m_typeTag && 4 > m_typeTag)
    //    {
    //        [m_tableView[m_segmented.selectedSegmentIndex] reloadData];
    //    }
    
    for (int i = 0; i < self.segmentedView.numberOfSegments; i++) {
        if (i != self.segmentedView.segmentedIndex) {
            m_tableView[i].hidden = YES;
        }
        else
            m_tableView[i].hidden = NO;
    }
    
}
#pragma mark -CustomSegmentedControlDelegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"customer segmented  %d",index);
    [self segmentedChangeValue:index];
}

@end
