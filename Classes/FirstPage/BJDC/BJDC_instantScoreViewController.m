//
//  BJDC_instantScoreViewController.m
//  RuYiCai
//
//  Created by huangxin on 13-7-3.
//
//

#import "BJDC_instantScoreViewController.h"
#import "RuYiCaiCommon.h"
#import "InstantScoreTableCell.h"
#import "JC_AttentionDataManagement.h"
#import "InstantScoreCellDetailViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
@interface BJDC_instantScoreViewController (internal)
- (void)changeUserClick;
- (void)segmentedChange:(id)sender;
- (void)getInstantScoreOK:(NSNotification *)notification;
- (void)historyButtonPress;

@end

@implementation BJDC_instantScoreViewController

@synthesize todayBatchCode = m_todayBatchCode;
@synthesize selectDetailBatchCode = m_selectDetailBatchCode;
@synthesize currentLotNo = m_currentLotNo;
@synthesize userDefaultsTag = m_userDefaultsTag;
@synthesize segmented = m_segmented;
@synthesize dataScore = m_dataScore;
@synthesize noMessageLabel = m_noMessageLabel;
//@synthesize myTableView = m_myTableView;
@synthesize dateChooseButton = m_dateChooseButton;
@synthesize currentBatchCode = m_currentBatchCode;
@synthesize segmentView = m_segmentView;

- (void) dealloc
{
    [m_segmentView release];
    m_delegate.randomPickerView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInstantScoreOK" object:nil];
    KSafe_Free(m_segmented);
    KSafe_Free(m_noMessageLabel);
    KSafe_Free(m_dateChooseButton);
    KSafe_Free(m_myTableView);
    
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
    [self segmentedChange:sender];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInstantScoreOK:) name:@"getInstantScoreOK" object:nil];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    
    m_tableViewNum = 0;
    pickViewCurrentNum = 0;
    
    self.currentBatchCode = @"";
    
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
    
    
    UIImageView *pickImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"golottery_bg.png"]];
    pickImageView.frame = CGRectMake(0, 30, [[UIScreen mainScreen] bounds].size.width, 44);
    [self.view addSubview:pickImageView];
    [pickImageView release];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 80, 32)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.text = @"选择期号:";
    dateLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:dateLabel];
    
    m_dateChooseButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 35, 135, 32)];
    [m_dateChooseButton setBackgroundImage:RYCImageNamed(@"select3_normal.png") forState:UIControlStateNormal];
    [m_dateChooseButton setBackgroundImage:RYCImageNamed(@"select3_click.png") forState:UIControlStateHighlighted];
    [m_dateChooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_dateChooseButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    m_dateChooseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 23);
    [m_dateChooseButton addTarget:self action:@selector(historyButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [m_dateChooseButton setTitle:self.currentBatchCode forState:UIControlStateNormal];
    [self.view addSubview:m_dateChooseButton];
    
    
    //tableView create
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 70) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.allowsSelection = YES;
    [self.view addSubview:m_myTableView];
    
    m_noMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    [m_myTableView addSubview:m_noMessageLabel];
    [m_noMessageLabel setHidden:YES];
    
    
    //请求数据
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"beiDan" forKey:@"command"];
    [mDict setObject:@"immediateScore" forKey:@"requestType"];
    [mDict setObject:@"0" forKey:@"type"];
    [mDict setObject:m_currentLotNo forKey:@"lotno"];
    [mDict setObject:@"" forKey:@"batchcode"];
    [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedChange:(id)sender
{
    m_tableViewNum = 0;
    [m_noMessageLabel setHidden:YES];
    switch (self.segmented.selectedSegmentIndex)
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
        m_myTableView.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 70);
    }
    else
    {
        m_myTableView.frame = CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 35);
    }
    
    //判断是刷新还是切换
    if (sender != m_refreshButton) {
        pickViewCurrentNum = 0;
        self.currentBatchCode = self.todayBatchCode;
    }
    
    if (m_typeTag != 2) {
        [m_dateChooseButton setTitle:self.currentBatchCode forState:UIControlStateNormal];
    }
    //请求数据
    NSString*   state = @"";
    if (m_typeTag == 4)
        state = @"0";
    else
        state = [state stringByAppendingFormat:@"%d",m_typeTag];
    
    if (m_typeTag != 4 && m_typeTag != 2) {
        if (self.currentBatchCode && ![self.currentBatchCode isEqualToString:@""]) {
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [mDict setObject:@"beiDan" forKey:@"command"];
            [mDict setObject:@"immediateScore" forKey:@"requestType"];
            [mDict setObject:state forKey:@"type"];
            [mDict setObject:m_currentLotNo forKey:@"lotno"];
            [mDict setObject:self.currentBatchCode forKey:@"batchcode"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
        else
        {
            NSLog(@"获取当前期号失败");
        }
    }
    else if (m_typeTag == 2) {
        if (self.currentBatchCode && ![self.currentBatchCode isEqualToString:@""]) {
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [mDict setObject:@"beiDan" forKey:@"command"];
            [mDict setObject:@"processingMatches" forKey:@"requestType"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
        else
        {
            NSLog(@"获取当前期号失败");
        }
    }
    else {
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
            [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
            //判断是否存在当前期号的关注,若不存在，找最近的期号
            if (![[JC_AttentionDataManagement shareManager] isPresentTheDate:self.currentBatchCode]) {
                NSMutableArray *allQihao = [NSMutableArray arrayWithArray:[[JC_AttentionDataManagement shareManager] getAllDate]];//获得所有的期号
                [[JC_AttentionDataManagement shareManager] selectSortWithDateArray:allQihao];//排序
                self.currentBatchCode = [allQihao objectAtIndex:0];
                [m_dateChooseButton setTitle:self.currentBatchCode forState:UIControlStateNormal];
            }
            //请求数据
            if (![self.currentBatchCode isEqualToString:@""]) {
                
                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
                [mDict setObject:@"beiDan" forKey:@"command"];
                [mDict setObject:@"immediateScore" forKey:@"requestType"];
                [mDict setObject:state forKey:@"type"];
                [mDict setObject:m_currentLotNo forKey:@"lotno"];
                [mDict setObject:self.currentBatchCode forKey:@"batchcode"];
                [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
            }
            else
            {
                NSLog(@"获取当前期号失败");
            }
        }
    }
    [m_myTableView reloadData];
}

#pragma mark 请求数据完成后
- (void)getInstantScoreOK:(NSNotification *)notification
{
    [m_noMessageLabel setHidden:YES];
    
    self.dataScore = [RuYiCaiNetworkManager sharedManager].responseText;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.dataScore];
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
    
    //设置选择器的初始值
    NSString* dateString = @"";
    dateString = KISDictionaryNullValue(parserDict, @"batchCodeSelect");
    NSArray* dateArray =  [dateString componentsSeparatedByString:@";"];
    if ([m_dateChooseButton.currentTitle isEqualToString:@""]||
        !m_dateChooseButton.currentTitle) {
        pickViewCurrentNum = 0;
        self.todayBatchCode = [dateArray objectAtIndex:0];
        self.currentBatchCode = self.todayBatchCode;
        [m_dateChooseButton setTitle:self.currentBatchCode forState:UIControlStateNormal];
    }
    
    //设置tableView的行数，若是我的关注，特殊处理
    NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
    if (m_typeTag == 4) {
        m_tableViewNum = [[self getCurrentShouCangArray] count];
    }
    else {
        m_tableViewNum = [array count];
    }
    
    [self setupTitle];
    [m_myTableView reloadData];
}


#pragma mark tableViewDelegate
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
    
    return m_tableViewNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
    
    NSArray *allData = [[JC_AttentionDataManagement shareManager] getSaveData];
    NSArray *userarray;
    if ([[JC_AttentionDataManagement shareManager] isPresentTheDate:self.currentBatchCode]) {
        int index = [[JC_AttentionDataManagement shareManager] getIndexWithDate:self.currentBatchCode];
        userarray = [(NSDictionary*)[allData objectAtIndex:index] objectForKey:self.currentBatchCode];
    }
    else
    {
        userarray = nil;
    }
    
    InstantScoreTableCell* cell = (InstantScoreTableCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[InstantScoreTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (m_typeTag != 4) {
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.dataScore];
        [jsonParser release];
        
        NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
        
        cell.scoreType = BeiDan;
        cell.event = KISNullValue(array, indexPath.row, @"bdEvent");
        cell.sclassName = KISNullValue(array, indexPath.row, @"sclassName");
        
        cell.matchTime = KISNullValue(array, indexPath.row, @"matchTime");
        
        cell.tag = indexPath.row;
        cell.bdSuperViewController = self;
        
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
        
        if (m_typeTag == 0 || m_typeTag == 1) {
            
            cell.shouCangButtonIsHidden = NO;
            BOOL hasShoucang = NO;
            if (userarray != Nil) {
                for (int i = 0; i < [userarray count]; i++) {
                    if ([[userarray objectAtIndex:i] isEqualToString:KISNullValue(array, indexPath.row, @"bdEvent")]) {
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
    
    //我的关注
    else {
        
        cell.shouCangButtonIsHidden = NO;
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.dataScore];
        [jsonParser release];
        NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
        //从返回的数据里检索
        NSString* event = [userarray objectAtIndex:indexPath.row];
        
        for (int j = 0; j < [array count]; j++) {
            if ([event isEqualToString:KISNullValue(array, j, @"bdEvent")])
            {
                cell.scoreType = BeiDan;
                cell.event = KISNullValue(array, j, @"bdEvent");
                cell.sclassName = KISNullValue(array, j, @"sclassName");
                cell.matchTime = KISNullValue(array, j, @"matchTime");
                cell.tag = indexPath.row;
                cell.bdSuperViewController = self;
                
                cell.homeTeam = KISNullValue(array, j, @"homeTeam");
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
                
                cell.isShouCang = YES;
            }
        }
    }
    
    
    [cell refreshTableCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    
    InstantScoreCellDetailViewController* viewController = [[InstantScoreCellDetailViewController alloc] init];
    [viewController setEvent:self.selectDetailBatchCode];
    viewController.lotType = 1;
    viewController.navigationItem.title = @"即时比分";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark 选择器回调函数
- (void) historyButtonPress
{
    if (m_typeTag != 4) {
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.dataScore];
        [jsonParser release];
        NSString* dateString = @"";
        dateString = KISDictionaryNullValue(parserDict, @"batchCodeSelect");
        NSArray* dateArray =  [dateString componentsSeparatedByString:@";"];
        
        if(0 == [dateArray count] || ([dateArray count] == 1 && [[dateArray objectAtIndex:0] length] == 0))
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"没有历史记录" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
        [m_delegate.randomPickerView setPickerDataArray:dateArray];
        [m_delegate.randomPickerView setPickerNum:pickViewCurrentNum withMinNum:0 andMaxNum:[dateArray count]];
    }
    else
    {
        [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
        NSMutableArray *qihaoArray = [NSMutableArray arrayWithArray:[[JC_AttentionDataManagement shareManager] getAllDate]];
        if ([qihaoArray count] > 0) {
            [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
            [[JC_AttentionDataManagement shareManager] selectSortWithDateArray:qihaoArray];
            [m_delegate.randomPickerView setPickerDataArray:qihaoArray];
            [m_delegate.randomPickerView setPickerNum:0 withMinNum:0 andMaxNum:[qihaoArray count]];
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请先收藏比赛" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    pickViewCurrentNum = num;
    m_tableViewNum = 0;
    [m_myTableView reloadData];
    NSString*   state = @"";
    state = [state stringByAppendingFormat:@"%d",m_typeTag];
    
    NSMutableString* qihao = [NSMutableString stringWithFormat:@"%@", [m_delegate.randomPickerView.pickerNumArray objectAtIndex:num]];
    self.currentBatchCode = qihao;
    
    [m_dateChooseButton setTitle:[m_delegate.randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"beiDan" forKey:@"command"];
    [mDict setObject:@"immediateScore" forKey:@"requestType"];
    [mDict setObject:state forKey:@"type"];
    [mDict setObject:m_currentLotNo forKey:@"lotno"];
    [mDict setObject:self.currentBatchCode forKey:@"batchcode"];
    [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
}

#pragma mark 显示messageView
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

#pragma mark 收藏
//收藏 点击事件
- (void)shouCangButtonClick:(BOOL)isSelect INDEX:(NSString*)event
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.dataScore];
    [jsonParser release];
    jsonParser = Nil;
    NSArray* resultArray = (NSArray*)[parserDict objectForKey:@"result"];
    
    //通过Event找到全部里面对应的那场比赛，并记录下标
    NSInteger index = 0;
    for (int m = 0; m < [resultArray count]; m++) {
        if ([event isEqualToString:KISNullValue(resultArray, m, @"bdEvent")]) {
            index = m;
            break;
        }
    }
    if (m_typeTag != 4) {
        
        NSString *event_temp = KISNullValue(resultArray, index, @"bdEvent");
        if (isSelect) {
            
            [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
            [[JC_AttentionDataManagement shareManager] addDataWithEvent:event_temp];
            NSLog(@"%@",[[JC_AttentionDataManagement shareManager] getSaveData]);
            [self showClickOrNoMessage:@"已添加至“我的关注”"];
        }
        else
        {
            [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
            [[JC_AttentionDataManagement shareManager] removeEventWithEvent:event_temp];
            
            [self showClickOrNoMessage:@"已取消关注"];
        }
    }
    
    //点击的是我的关注的数据
    else
    {
        NSString *event_temp = KISNullValue(resultArray, index, @"bdEvent");
        [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
        NSLog(@"%@",[[JC_AttentionDataManagement shareManager] getSaveData]);
        //这种情况是发生错误了
        if (isSelect) {
            
            NSLog(@"我的关注出错了！！！！");
        }
        else {
            [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
            [[JC_AttentionDataManagement shareManager] removeEventWithEvent:event_temp];
            
            [self showClickOrNoMessage:@"已取消关注"];
        }
        [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
        if ([[[JC_AttentionDataManagement shareManager] getSaveData] count] > 0) {
            m_tableViewNum = [[self getCurrentShouCangArray] count];
        }
        else
        {
            m_tableViewNum = 0;
        }
        
        [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
        NSLog(@"%@",[[JC_AttentionDataManagement shareManager] getSaveData]);
    }
    [m_myTableView reloadData];
    [self setupTitle];
    
}

//获得当前期号的收藏
-(NSArray*) getCurrentShouCangArray
{
    [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
    if ([[JC_AttentionDataManagement shareManager] isPresentTheDate:self.currentBatchCode]) {
        NSInteger curretnIndex = 0;
        NSArray* UserSavedArray = [[JC_AttentionDataManagement shareManager] getSaveData];
        curretnIndex = [[JC_AttentionDataManagement shareManager] getIndexWithDate:self.currentBatchCode];
        NSArray *currentBatchCodeShouCangArray = [(NSDictionary*)[UserSavedArray objectAtIndex:curretnIndex] objectForKey:self.currentBatchCode];
        return currentBatchCodeShouCangArray;
    }
    else
    {
        return nil;
    }
}

//设置我的关注的标题
- (void) setupTitle
{
    //设置 我的关注标题
    NSString* title = @"我的关注";
    if ([[self getCurrentShouCangArray] count] > 0 && [self getCurrentShouCangArray] != nil) {
        title = [title stringByAppendingFormat:@"(%d) ",[[self getCurrentShouCangArray] count]];
    }
    [m_segmented setTitle:title forSegmentAtIndex:4];
}

- (void)segmentedChangeForIndex:(id)index
{
    m_tableViewNum = 0;
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
        m_myTableView.frame = CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 75);
    }
    else
    {
        m_myTableView.frame = CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 35);
    }
    
    //判断是刷新还是切换
    if (index != m_refreshButton) {
        pickViewCurrentNum = 0;
        self.currentBatchCode = self.todayBatchCode;
    }
    
    if (m_typeTag != 2) {
        [m_dateChooseButton setTitle:self.currentBatchCode forState:UIControlStateNormal];
    }
    //请求数据
    NSString*   state = @"";
    if (m_typeTag == 4)
        state = @"0";
    else
        state = [state stringByAppendingFormat:@"%d",m_typeTag];
    
    if (m_typeTag != 4 && m_typeTag != 2) {
        if (self.currentBatchCode && ![self.currentBatchCode isEqualToString:@""]) {
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [mDict setObject:@"beiDan" forKey:@"command"];
            [mDict setObject:@"immediateScore" forKey:@"requestType"];
            [mDict setObject:state forKey:@"type"];
            [mDict setObject:m_currentLotNo forKey:@"lotno"];
            [mDict setObject:self.currentBatchCode forKey:@"batchcode"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
        else
        {
            NSLog(@"获取当前期号失败");
        }
    }
    else if (m_typeTag == 2) {
        if (self.currentBatchCode && ![self.currentBatchCode isEqualToString:@""]) {
            
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
            [mDict setObject:@"beiDan" forKey:@"command"];
            [mDict setObject:@"immediateScore" forKey:@"requestType"];
            [mDict setObject:state forKey:@"type"];
            [mDict setObject:m_currentLotNo forKey:@"lotno"];
            [mDict setObject:self.currentBatchCode forKey:@"batchcode"];
            [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
        }
        else
        {
            NSLog(@"获取当前期号失败");
        }
    }
    else {
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
            [JC_AttentionDataManagement shareManager].mark = self.userDefaultsTag;
            //判断是否存在当前期号的关注,若不存在，找最近的期号
            if (![[JC_AttentionDataManagement shareManager] isPresentTheDate:self.currentBatchCode]) {
                NSMutableArray *allQihao = [NSMutableArray arrayWithArray:[[JC_AttentionDataManagement shareManager] getAllDate]];//获得所有的期号
                [[JC_AttentionDataManagement shareManager] selectSortWithDateArray:allQihao];//排序
                self.currentBatchCode = [allQihao objectAtIndex:0];
                [m_dateChooseButton setTitle:self.currentBatchCode forState:UIControlStateNormal];
            }
            //请求数据
            if (![self.currentBatchCode isEqualToString:@""]) {
                
                NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
                [mDict setObject:@"beiDan" forKey:@"command"];
                [mDict setObject:@"immediateScore" forKey:@"requestType"];
                [mDict setObject:state forKey:@"type"];
                [mDict setObject:m_currentLotNo forKey:@"lotno"];
                [mDict setObject:self.currentBatchCode forKey:@"batchcode"];
                [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
            }
            else
            {
                NSLog(@"获取当前期号失败");
            }
        }
    }
    [m_myTableView reloadData];}


#pragma mark -CustomSegmentedControlDelegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"customer segmented  %d",index);
    //    [self segmentedChangeValue:index];
    [self segmentedChangeForIndex:index];
    
}

@end
