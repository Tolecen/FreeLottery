//
//  BJDC_pickNumViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-19.
//
//

#import "BJDC_pickNumViewController.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiCommon.h"
#import "JC_TableView_ContentCell.h"
#import "BJDC_PlayChoseView.h"
#import "SFCViewController.h"
#import "JC_LeagueChooseViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"
#import "RuYiCaiLotDetail.h"
#import "BJDC_Bet_viewController.h"
#import "DataAnalysisViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "BJDC_instantScoreViewController.h"
#import "AdaptationUtils.h"

#define kLabelFontSize    (12)
#define kPerMinuteTimeInterval (60.0)

@interface BJDC_pickNumViewController ()

- (void)setDetailView;

@end

@implementation BJDC_pickNumViewController

@synthesize parserDictData = m_parserDictData;

@synthesize buttonBuy;
@synthesize buttonReselect;
@synthesize totalCost;
@synthesize batchCode = m_batchCode;
@synthesize tableView = m_tableView;
@synthesize playTypeTag = m_playTypeTag;
@synthesize tableCell_DataArray = m_tableCell_DataArray;
@synthesize timeLabel;

@synthesize league_tableCell_DataArray = m_league_tableCell_DataArray;
@synthesize league_selected_tableCell_DataArrayTag = m_league_selected_tableCell_DataArrayTag;
@synthesize currentLotNo = m_currentLotNo;
@synthesize batchEndTime = m_batchEndTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [m_batchEndTime release];
    [m_batchCodeLabel release];
    [m_leftTimeLabel release];
    [m_currentLotNo release];
    [buttonBuy release];
    [buttonReselect release];
    [totalCost release];
    
    [m_tableView release], m_tableView = nil;
    [m_tableCell_DataArray release], m_tableCell_DataArray = nil;
    [m_tableHeaderState release], m_tableHeaderState = nil;
    
    [m_playChooseView release], m_playChooseView = nil;
    
    [m_league_tableCell_DataArray release], m_league_tableCell_DataArray = nil;
    [m_league_selected_tableCell_DataArrayTag release], m_league_selected_tableCell_DataArrayTag = nil;
    
    [m_detailView release];
    
	[super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getBJDCDuiZhenOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];

    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;

    if(centerButton != nil)
    {
        [centerButton removeFromSuperview];
        [centerButton release], centerButton = nil;
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBJDCDuiZhenOK:) name:@"getBJDCDuiZhenOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];

    if(centerButton != nil)
    {
        [centerButton removeFromSuperview];
        [centerButton release], centerButton = nil;
    }
    centerButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 120, 44)];
    [centerButton addTarget:self action: @selector(playChooseViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    centerButton.showsTouchWhenHighlighted = TRUE;
    centerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
    centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerButton setTitle:[self getTitleBy_playType] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:centerButton];
    
    UIImageView* iamge = [[UIImageView alloc] initWithFrame:CGRectMake(54, 32, 14, 10)];
    iamge.image = [UIImage imageNamed:@"jc_headerlist_ico.png"];
    [centerButton addSubview:iamge];
    [iamge release];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    m_batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    NSLog(@"%@",self.batchCode);
    
	m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",self.batchCode];
    m_batchCodeLabel.textAlignment = UITextAlignmentLeft;
    m_batchCodeLabel.backgroundColor = [UIColor clearColor];
    m_batchCodeLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_batchCodeLabel];
    
    
    
    m_leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 100, 30)];
	m_leftTimeLabel.text = @"00:00:00";
	m_leftTimeLabel.textAlignment = UITextAlignmentLeft;
    m_leftTimeLabel.backgroundColor = [UIColor clearColor];
    m_leftTimeLabel.textColor = [UIColor redColor];
    m_leftTimeLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [self.view addSubview:m_leftTimeLabel];
    
    
    if (self.batchCode == nil || [self.batchCode isEqualToString:@"-1"]) {
        NSLog(@"11111batch 无数据时候 隐藏");
        [m_batchCodeLabel setHidden:YES];
        [m_leftTimeLabel setHidden:YES];
        [self.timeLabel setHidden:YES];
    }else{
        [m_batchCodeLabel setHidden:NO];
        [m_leftTimeLabel setHidden:NO];
        [self.timeLabel setHidden:NO];
    }
    
    self.parserDictData = @"";

    
    
    m_currentLotNo = kLotNoBJDC_RQSPF;
    
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    m_playTypeTag = IBJDCPlayType_RQ_SPF;
    m_headerCount = 0;
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 25, 320, [UIScreen mainScreen].bounds.size.height - 64  - 50-25) style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
//    m_tableView.backgroundColor = [UIColor redColor];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉 groupcell的圆角
    //如果不希望响应select，那么就可以用下面的代码设置属性：
    m_tableView.allowsSelection=NO;
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_tableView];
    
    [self setPlayChooseView];
    
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    UIButton* detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [detailButton addTarget:self action: @selector(detailViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_normal"] forState:UIControlStateNormal];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_click"] forState:UIControlStateHighlighted];
    detailButton.showsTouchWhenHighlighted = TRUE;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:detailButton] autorelease];
    [detailButton release];
    [self setDetailView];
    
    //请求数据
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"beiDan" forKey:@"command"];
    [mDict setObject:@"immediateScore" forKey:@"requestType"];
    [mDict setObject:@"0" forKey:@"type"];
    [mDict setObject:m_currentLotNo forKey:@"lotno"];
    [mDict setObject:@"" forKey:@"batchcode"];
    [[RuYiCaiNetworkManager sharedManager] getInstantScore:mDict];
    
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoBJDC_RQSPF];//获取期号

}

- (void)refreshLeftTime
{
    if (0 == self.batchEndTime.length)
    {
        return;
    }
	m_leftTimeLabel.text = @"00:00:00";
	int leftTime = [self.batchEndTime intValue];
	if (leftTime > 0)
	{
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
	    m_leftTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",
                                numHour, numMinute, numSecond];
        self.batchEndTime = [NSString stringWithFormat:@"%d",[self.batchEndTime intValue]-1];
    }
	else if(leftTime == 0)//防止过期彩种
	{
		if([m_timer isValid])
		{
			[m_timer invalidate];
			m_timer = nil;
		}
		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"北单 %@期已截止，投注时请确认您选择的期号！" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
        [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoBJDC_RQSPF];//获取期号
	}
	else //时间为负时，停止调用
	{
		if([m_timer isValid])
		{
			[m_timer invalidate];
			m_timer = nil;
		}
	}
}


- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark button
- (void)pressedBuyButton:(id)sender
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;

    if (m_numGameCount < 1)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一场比赛" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    int danCount = 0;
    for (int index = 0; index < m_headerCount; index++) {
        JCLQ_tableViewCell_DataArray* header =   (JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:index];
        for (int spindex = 0; spindex < [header baseCount]; spindex++)
        {
            JCLQ_tableViewCell_DataBase* base = [[header tableHeaderArray] objectAtIndex:spindex];
            if ([base JC_DanIsSelect]) {
                danCount++;
            }
        }
    }
    
    //判断是否满足设胆条件
    if (danCount > 0 && ![self judegmentDan]) {
        return;
    }

    [self submitLotNotification:nil];
}

- (void)pressedReselectButton:(id)sender
{
    m_detailView.hidden = YES;
    [self clearAllChoose];
}
#pragma mark 截止时间

- (void)updateInformation:(NSNotification*)notification
{
    

    self.batchCode = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    self.batchEndTime = [[RuYiCaiNetworkManager sharedManager] highFrequencyLeftTime];
	m_batchCodeLabel.text = [NSString stringWithFormat:@"第%@期",self.batchCode];
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    
    
    NSLog(@"%@",self.batchCode);
    if (self.batchCode == nil || [self.batchCode isEqualToString:@"-1"]) {
        NSLog(@"11111batch 无数据时候 隐藏");
        [m_batchCodeLabel setHidden:YES];
        [m_leftTimeLabel setHidden:YES];
        [self.timeLabel setHidden:YES];
        [m_tableView setFrame:CGRectMake(0, 25, 320, [UIScreen mainScreen].bounds.size.height - 64  - 50-25)];
    }else{
        [m_batchCodeLabel setHidden:NO];
        [m_leftTimeLabel setHidden:NO];
        [self.timeLabel setHidden:NO];
        [m_tableView setFrame:CGRectMake(0, 25, 320, [UIScreen mainScreen].bounds.size.height - 64  - 50-25)];
    }

    
    if(m_timer != nil)
	{
		[m_timer invalidate];
		m_timer = nil;
	}
	else
	{
		m_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshLeftTime)
												 userInfo:nil repeats:YES];
	}
    

    
    
    if ([self.batchCode isEqualToString:@"-1"]) {//获取失败时
        return;
    }
    switch (self.playTypeTag) {
        case IBJDCPlayType_RQ_SPF:
            [[RuYiCaiNetworkManager sharedManager] getBJDCDuiZhen:self.batchCode withLotNo:kLotNoBJDC_RQSPF];
            break;
        case IBJDCPlayType_ZJQ:
            [[RuYiCaiNetworkManager sharedManager] getBJDCDuiZhen:self.batchCode withLotNo:kLotNoBJDC_JQS];
            break;
        case IBJDCPlayType_Score:
            [[RuYiCaiNetworkManager sharedManager] getBJDCDuiZhen:self.batchCode withLotNo:kLotNoBJDC_Score];
            break;
        case IBJDCPlayType_HalfAndAll:
            [[RuYiCaiNetworkManager sharedManager] getBJDCDuiZhen:self.batchCode withLotNo:kLotNoBJDC_HalfAndAll];
            break;
        case IBJDCPlayType_SXDS:
            [[RuYiCaiNetworkManager sharedManager] getBJDCDuiZhen:self.batchCode withLotNo:kLotNoBJDC_SXDS];
            break;
        default:
            break;
    }
    
}

#pragma mark 对阵
- (void)getBJDCDuiZhenOK:(NSNotification*)notification
{
    self.parserDictData = [RuYiCaiNetworkManager sharedManager].responseText;
    [self changeLeague];//联赛信息

    [self parserData];
}
- (void)parserData
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.parserDictData];
    [jsonParser release];
    
    NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
    int nHeaderCount = [array count];
    if (nHeaderCount == 0) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"暂时没有赛事!" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (m_tableCell_DataArray != nil)
    {
        [m_tableCell_DataArray removeAllObjects];
        [m_tableCell_DataArray release];
    }
    m_tableCell_DataArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < nHeaderCount; i++)
    {
        NSArray*  subArray = (NSArray*)[array objectAtIndex:i];
        
        JCLQ_tableViewCell_DataArray* currentBaseArray = [[JCLQ_tableViewCell_DataArray alloc] init];
        int subArrayCount = [subArray count];
        for (int j = 0; j < subArrayCount; j++)
        {
            NSDictionary* sub_subDict = (NSDictionary*) [subArray objectAtIndex:j];

            JCLQ_tableViewCell_DataBase*  base = [[JCLQ_tableViewCell_DataBase alloc] init];

            base.dayforamt = [sub_subDict objectForKey:@"dayForamt"];
            //是否 已选的联赛
            BOOL isLeagueSelect = NO;
            base.league = [sub_subDict objectForKey:@"league"];
            for (int k = 0; k < [m_league_selected_tableCell_DataArrayTag count]; k++)
            {
                int tag = [[m_league_selected_tableCell_DataArrayTag objectAtIndex:k] intValue];
                NSString* league = [m_league_tableCell_DataArray objectAtIndex:tag];
                if ([base.league isEqual:league])
                {
                    isLeagueSelect = YES;
                    break;
                }
            }
            
            base.homeTeam = [sub_subDict objectForKey:@"homeTeam"];//主队在前
            base.VisitTeam = [sub_subDict objectForKey:@"guestTeam"];
            
            base.teamld = KISDictionaryNullValue(sub_subDict, @"teamId");
            //            base.weekld = [sub_subDict objectForKey:@"weekId"];
            //            base.week = [sub_subDict objectForKey:@"week"];
            
            //            NSString* unSupportArray = [sub_subDict objectForKey:@"unsupport"];
            //            NSArray*  supportArray;
            //            BOOL isHave = FALSE;
            //            for (int k = 0; k < [unSupportArray length]; k++)
            //            {
            //                if ([unSupportArray characterAtIndex:k] == ',')
            //                {
            //                    isHave = TRUE;
            //                    break;
            //                }
            //            }
            //            if (isHave)
            //            {
            //                supportArray = [unSupportArray componentsSeparatedByString:@","];
            //                for (int m = 0; m < [supportArray count]; m++)
            //                {
            //                    NSString *str = [supportArray objectAtIndex:m];
            //                    [base appendToBaseUnSupportDuiZhen:str];
            //                }
            //            }
            //            else
            //            {
            //                if([unSupportArray length] > 0)
            //                {
            //                    [base appendToBaseUnSupportDuiZhen:unSupportArray];
            //                }
            //            }
            
            base.letPoint = [sub_subDict objectForKey:@"letPoint"];
            base.endTime = [sub_subDict objectForKey:@"endTime"];
                
            if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
                base.v0 = [sub_subDict objectForKey:@"v0"];
                base.v1 = [sub_subDict objectForKey:@"v1"];
                base.v3 = [sub_subDict objectForKey:@"v3"];
            }
            else if(m_playTypeTag == IBJDCPlayType_ZJQ)
            {
                 //总进球数------------------
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v0"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v0"])];
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v1"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v1"])];
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v2"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v2"])];
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v3"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v3"])];
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v4"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v4"])];
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v5"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v5"])];
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v6"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v6"])];
                 [base.goalArray addObject:([[sub_subDict objectForKey:@"goal_v7"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"goal_v7"])];
            }
            else if(m_playTypeTag == IBJDCPlayType_Score)
            {
                //比分 胜-----------------
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v90"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v90"])];//胜其他
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v10"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v10"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v20"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v20"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v21"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v21"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v30"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v30"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v31"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v31"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v32"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v32"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v40"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v40"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v41"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v41"])];
                 [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v42"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v42"])];

                 
                 //平
                 [base.score_P_Array addObject:([[sub_subDict objectForKey:@"score_v99"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v99"])];
                 [base.score_P_Array addObject:([[sub_subDict objectForKey:@"score_v00"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v00"])];
                 [base.score_P_Array addObject:([[sub_subDict objectForKey:@"score_v11"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v11"])];
                 [base.score_P_Array addObject:([[sub_subDict objectForKey:@"score_v22"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v22"])];
                 [base.score_P_Array addObject:([[sub_subDict objectForKey:@"score_v33"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v33"])];
                 //负
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v09"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v09"])];//胜其他
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v01"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v01"])];
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v02"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v02"])];
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v12"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v12"])];
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v03"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v03"])];
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v13"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v13"])];
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v23"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v23"])];
                 
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v04"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v04"])];
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v14"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v14"])];
                 [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v24"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"score_v24"])];
        //         [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v05"] length] == 0
        //         ? @"" : [sub_subDict objectForKey:@"score_v05"])];
        //         [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v15"] length] == 0
        //         ? @"" : [sub_subDict objectForKey:@"score_v15"])];
        //         [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v25"] length] == 0
        //         ? @"" : [sub_subDict objectForKey:@"score_v25"])];
            }
            else if(m_playTypeTag == IBJDCPlayType_HalfAndAll)
                {
                 //胜分差  半全场
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v33"] length] == 0 //胜胜
                 ? @"" : [sub_subDict objectForKey:@"half_v33"])];
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v31"] length] == 0 //胜平
                 ? @"" : [sub_subDict objectForKey:@"half_v31"])];
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v30"] length] == 0 //胜负
                 ? @"" : [sub_subDict objectForKey:@"half_v30"])];
                 
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v13"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"half_v13"])];//平胜
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v11"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"half_v11"])];//平平
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v10"] length] == 0
                 ? @"" : [sub_subDict objectForKey:@"half_v10"])];//平复
                 
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v03"] length] == 0 //负胜
                 ? @"" : [sub_subDict objectForKey:@"half_v03"])];
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v01"] length] == 0 //抚平
                 ? @"" : [sub_subDict objectForKey:@"half_v01"])];
                 [base.half_Array addObject:([[sub_subDict objectForKey:@"half_v00"] length] == 0 //负负
                 ? @"" : [sub_subDict objectForKey:@"half_v00"])];
            }
            else if(m_playTypeTag == IBJDCPlayType_SXDS)
            {
                base.sxdsV1 = [sub_subDict objectForKey:@"sxds_v1"];
                base.sxdsV2 = [sub_subDict objectForKey:@"sxds_v2"];
                base.sxdsV3 = [sub_subDict objectForKey:@"sxds_v3"];
                base.sxdsV4 = [sub_subDict objectForKey:@"sxds_v4"];
            }
            
            //            if ([base.isUnSupportArry count] > 0)
            //            {
            //                BOOL have = FALSE;
            //                for (int i = 0; i < [base.isUnSupportArry count]; i++)
            //                {
            //                    if ([[base.isUnSupportArry objectAtIndex:i] intValue] == m_playTypeTag)
            //                    {
            //                        have = TRUE;
            //                        break;
            //                    }
            //                }
            //                if (isLeagueSelect && !have)
            //                {
            //                    [currentBaseArray.tableHeaderArray addObject:base];
            //                }
            //            }
            //            else
            //            {
            if (isLeagueSelect)
            {
                [currentBaseArray.tableHeaderArray addObject:base];
            }
            //            }
            
            [base release];
            }
            if ([currentBaseArray baseCount] > 0)
            {
                [m_tableCell_DataArray addObject:currentBaseArray];
            }
            [currentBaseArray release];
    }
    //设置 tableviewcellheader 是否展开
    m_headerCount = [m_tableCell_DataArray count];
    if (m_tableHeaderState != nil)
    {
        [m_tableHeaderState removeAllObjects];
        [m_tableHeaderState release];
    }
    m_tableHeaderState = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < m_headerCount; i++)
    {
        if (i == 0) {
            [m_tableHeaderState addObject:@"1"];
            m_SectionN[i] = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        }
        else
        {
            m_SectionN[i] = 0;
            [m_tableHeaderState addObject:@"0"];
        }
    }
    [m_tableView reloadData];
}

-(void) clearAllChoose
{
    m_numGameCount = 0;

    self.totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", m_numGameCount];
    for (int i = 0; i < m_headerCount; i++)
    {
        int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < baseCount; j++) {
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            [base setZQ_S_ButtonIsSelect:NO];
            
            [base setZQ_P_ButtonIsSelect:NO];
            
            [base setZQ_F_ButtonIsSelect:NO];
            
            [base setJC_DanIsSelect:NO];
            
            [[base sfc_selectTag] removeAllObjects];
            
            [base setBD_SD_ButtonIsSelect:NO];
            [base setBD_SS_ButtonIsSelect:NO];
            [base setBD_XD_ButtonIsSelect:NO];
            [base setBD_XS_ButtonIsSelect:NO];

        }
    }
//    [m_SFCSelectScore removeAllObjects];
    
    [m_tableView reloadData];
}

-(void) reloadData//选择选项后
{
    //刷新 所选比赛场次，金额-----胜分差完发
    NSInteger gameCount = 0;
    for (int i = 0; i < m_headerCount; i++)
    {
        int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < baseCount; j++) {
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
      
            int count = [[base sfc_selectTag] count];
            if (count > 0) {
                gameCount++;
            }
            else
                [base setJC_DanIsSelect:NO];
        
        }
    }
    m_numGameCount = gameCount;
    // 已选比赛：%d 场
    self.totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", gameCount];
    
    [m_tableView reloadData];
}

#pragma mark 点击胜平负按钮
-(BOOL) changeClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState ButtonIndex:(NSInteger)buttonIndex
{
    
     //1 主队 2 客队
     
    m_detailView.hidden = YES;
    
    // 最多十场比赛 限制
     
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[indexPath section]] tableHeaderArray] objectAtIndex:indexPath.row];
    if (m_numGameCount == 15)
    {
        if (clickState && buttonIndex != 4)
        {
            BOOL isHave = FALSE;
            
            if (buttonIndex == 1 && ([base ZQ_P_ButtonIsSelect] || [base ZQ_F_ButtonIsSelect]))
            {
                isHave = TRUE;
            }
            else if(buttonIndex == 2 && ([base ZQ_S_ButtonIsSelect] || [base ZQ_F_ButtonIsSelect]))
            {
                isHave = TRUE;
            }
            else if(buttonIndex == 3 && ([base ZQ_S_ButtonIsSelect] || [base ZQ_P_ButtonIsSelect]))
            {
                isHave = TRUE;
            }
            if (!isHave)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多选择15场比赛" withTitle:@"投注提示" buttonTitle:@"确定"];
                return FALSE;
            }
        }
    }
    
    if (buttonIndex == 1)
    {
        if (clickState)
        {
            [base setZQ_S_ButtonIsSelect:YES];
        }
        else
        {
            [base setZQ_S_ButtonIsSelect:NO];
        }
    }
    else if(buttonIndex == 2)
    {
        if (clickState)
        {
            [base setZQ_P_ButtonIsSelect:YES];
        }
        else
        {
            [base setZQ_P_ButtonIsSelect:NO];
        }
    }
    else if(buttonIndex == 3)
    {
        if (clickState)
        {
            [base setZQ_F_ButtonIsSelect:YES];
        }
        else
        {
            [base setZQ_F_ButtonIsSelect:NO];
        }
    }
    else if(buttonIndex == 4)
    {
        if (clickState)
        {
            if ([self judegmentDan_clickEvent]) {
                [base setJC_DanIsSelect:YES];
            }
            else
            {
                [base setJC_DanIsSelect:NO];
                return FALSE;
            }
            
        }
        else
        {
            [base setJC_DanIsSelect:NO];
        }
    }
    
    /*
     去除所选 胆
     */
    if (![base ZQ_S_ButtonIsSelect] && ![base ZQ_P_ButtonIsSelect] && ![base ZQ_F_ButtonIsSelect] && [[base sfc_selectTag] count] <= 0) {
        [base setJC_DanIsSelect:NO];
    }
    
    
    if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
        //刷新 所选比赛场次，金额
        NSInteger gameCount = 0;
//        m_twoCount = 0;
//        m_threeCount = 0;
        for (int i = 0; i < m_headerCount; i++)
        {
            int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
            for (int j = 0; j < baseCount; j++) {
                BOOL ZQ_S_ButtonIsSelect = [(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j] ZQ_S_ButtonIsSelect];
                
                BOOL ZQ_P_ButtonIsSelect = [(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j] ZQ_P_ButtonIsSelect];
                
                BOOL ZQ_F_ButtonIsSelect = [(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j] ZQ_F_ButtonIsSelect];
                
                if (ZQ_S_ButtonIsSelect || ZQ_P_ButtonIsSelect || ZQ_F_ButtonIsSelect)
                {
                    gameCount++;
//                    if (ZQ_S_ButtonIsSelect && ZQ_P_ButtonIsSelect && !ZQ_F_ButtonIsSelect)
//                    {
//                        m_twoCount++;
//                    }
//                    if (ZQ_S_ButtonIsSelect && ZQ_F_ButtonIsSelect && !ZQ_P_ButtonIsSelect)
//                    {
//                        m_twoCount++;
//                    }
//                    if (ZQ_F_ButtonIsSelect&& ZQ_P_ButtonIsSelect && !ZQ_S_ButtonIsSelect)
//                    {
//                        m_twoCount++;
//                    }
//                    
//                    if (ZQ_F_ButtonIsSelect&& ZQ_P_ButtonIsSelect && ZQ_S_ButtonIsSelect)
//                    {
//                        m_threeCount++;
//                    }
                }
            }
        }
        m_numGameCount = gameCount;
        // 已选比赛：%d 场
        self.totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", gameCount];
    }
    [m_tableView reloadData];
    return TRUE;
}

- (BOOL) SXDSClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState ButtonIndex:(NSInteger)buttonIndex
{
    m_detailView.hidden = YES;

    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[indexPath section]] tableHeaderArray] objectAtIndex:indexPath.row];
    if (m_numGameCount == 10 && buttonIndex != kSXDSbuttonTag + 4)
    {
        if (clickState)
        {
            BOOL isHave = FALSE;
            
            if (buttonIndex == kSXDSbuttonTag &&  ([base BD_SS_ButtonIsSelect] || [base BD_XD_ButtonIsSelect] || [base BD_XS_ButtonIsSelect]))
            {
                isHave = TRUE;
            }
            else if (buttonIndex == (kSXDSbuttonTag + 1) &&  ([base BD_SD_ButtonIsSelect] || [base BD_XD_ButtonIsSelect] || [base BD_XS_ButtonIsSelect]))
            {
                isHave = TRUE;
            }
            else if (buttonIndex == (kSXDSbuttonTag + 2) &&  ([base BD_SD_ButtonIsSelect] || [base BD_SS_ButtonIsSelect] || [base BD_XS_ButtonIsSelect]))
            {
                isHave = TRUE;
            }
            else if (buttonIndex == (kSXDSbuttonTag + 3) &&  ([base BD_SD_ButtonIsSelect] || [base BD_SS_ButtonIsSelect] || [base BD_XD_ButtonIsSelect]))
            {
                isHave = TRUE;
            }
            if (!isHave)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多选择10场比赛" withTitle:@"投注提示" buttonTitle:@"确定"];
                return FALSE;
            }
        }
    }
    switch (buttonIndex) {
        case kSXDSbuttonTag:
            [base setBD_SD_ButtonIsSelect:clickState];
            break;
        case kSXDSbuttonTag + 1:
            [base setBD_SS_ButtonIsSelect:clickState];
            break;
        case kSXDSbuttonTag + 2:
            [base setBD_XD_ButtonIsSelect:clickState];
            break;
        case kSXDSbuttonTag + 3:
            [base setBD_XS_ButtonIsSelect:clickState];
            break;
        case kSXDSbuttonTag + 4:
            {
                if (clickState)
                {
                    if ([self judegmentDan_clickEvent]) {
                        [base setJC_DanIsSelect:YES];
                    }
                    else
                    {
                        [base setJC_DanIsSelect:NO];
                        return FALSE;
                    }
                    
                }
                else
                {
                    [base setJC_DanIsSelect:NO];
                }
            }
        default:
            break;
    }
    
    //消除胆
    int playGame_Count = [base BD_SD_ButtonIsSelect] + [base BD_SS_ButtonIsSelect] +
                         [base BD_XD_ButtonIsSelect] + [base BD_XS_ButtonIsSelect];
    if (playGame_Count == 0) {
        [base setJC_DanIsSelect:NO];
    }
    
    
    if (m_playTypeTag == IBJDCPlayType_SXDS) {
        //刷新 所选比赛场次，金额
        NSInteger gameCount = 0;

        for (int i = 0; i < m_headerCount; i++)
        {
            int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
            for (int j = 0; j < baseCount; j++) {
                JCLQ_tableViewCell_DataBase *tempBase = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
                if ([tempBase isSelectThisMatch:m_playTypeTag])
                {
                    gameCount++;
                }
            }
        }
        m_numGameCount = gameCount;
        self.totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", gameCount];
    }
    [m_tableView reloadData];
    
    return TRUE;
}

#pragma mark 联赛筛选
- (void) changeLeague
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    if (m_league_tableCell_DataArray != nil)
    {
        [m_league_tableCell_DataArray removeAllObjects];
        [m_league_tableCell_DataArray release];
    }
    m_league_tableCell_DataArray = [[NSMutableArray alloc] initWithCapacity:10];
    if (m_league_selected_tableCell_DataArrayTag != nil)
    {
        [m_league_selected_tableCell_DataArrayTag removeAllObjects];
        [m_league_selected_tableCell_DataArrayTag release];
    }
    m_league_selected_tableCell_DataArrayTag = [[NSMutableArray alloc] initWithCapacity:10];
    NSString* arrayStr = (NSString*)[parserDict objectForKey:@"leagues"];//以；分隔联赛
    BOOL isHave = FALSE;
    if ([arrayStr length] > 0)
    {
        for (int k = 0; k < [arrayStr length]; k++)
        {
            if ([arrayStr characterAtIndex:k] == ';')
            {
                isHave = TRUE;
                break;
            }
        }
        if (isHave)
        {
            NSArray* leaguesarray = [arrayStr componentsSeparatedByString:@";"];
            for (int i = 0; i < [leaguesarray count]; i++) //默认 联赛 全选
            {
                NSString* temp = [leaguesarray objectAtIndex:i];
                [m_league_tableCell_DataArray addObject:temp];
                [m_league_selected_tableCell_DataArrayTag addObject:[NSNumber numberWithInt:i]];
            }
        }
        else
        {
            [m_league_tableCell_DataArray addObject:arrayStr];
            [m_league_selected_tableCell_DataArrayTag addObject:[NSNumber numberWithInt:0]];
        }
    }
}
#pragma mark 表格
- (void)pressTitle:(id)sender
{
//    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
	UIButton *temp = (UIButton *)sender;
	int temptag = temp.tag;
    if ([[m_tableHeaderState objectAtIndex:temptag] isEqual: @"0"])
    {
        [m_tableHeaderState replaceObjectAtIndex:temptag withObject:@"1"];
        m_SectionN[temptag] = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:temptag] baseCount];
        
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlistexpand.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlisthide.png"] forState:UIControlStateHighlighted];
    }
    else if([[m_tableHeaderState objectAtIndex:temptag] isEqual: @"1"]){
        [m_tableHeaderState replaceObjectAtIndex:temptag withObject:@"0"];
        m_SectionN[temptag] = 0;
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlisthide.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlistexpand.png"] forState:UIControlStateHighlighted];
    }
        
    [m_tableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//指定有多少个分区（section） 默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //默认是1
    return m_headerCount;
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 65;
    return 67;
}
//header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //根据数组 来定
    return m_SectionN[section];
}
//创建 uitableview的 header
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    
    [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    //0 隐藏 1-- 展开
    if ([m_tableHeaderState objectAtIndex:section] == @"0"){
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        image.image = [UIImage imageNamed:@"jc_sectionlisthide.png"];
        [button addSubview:image];
        [image release];
    }
    else if([m_tableHeaderState objectAtIndex:section] == @"1"){
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        image.image = [UIImage imageNamed:@"jc_sectionlistexpand.png"];
        [button addSubview:image];
        [image release];
    }
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    NSMutableArray* tempArray = [[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:0];//获取数组中的 第一个base数据
    
    NSString* dayForamt = [NSString stringWithFormat:@"%@  ", [(JCLQ_tableViewCell_DataBase*) tempArray dayforamt]];
    NSString* title = [NSString stringWithFormat:@"%@%d场比赛可投注",dayForamt,[((JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section]) baseCount]];    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupCell = @"groupCell";
	JC_TableView_ContentCell *cell = (JC_TableView_ContentCell*)[tableView dequeueReusableCellWithIdentifier:groupCell];
	if(cell == nil)
	{
		cell = [[[JC_TableView_ContentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupCell]autorelease];
        cell.isLeftSelect = NO;
        cell.isCenterSelect = NO;
        cell.isRightSelect = NO;
    }
    cell.indexPath = indexPath;
    
    cell.BJDC_parentViewController = self;
    cell.isJCLQtableview = 2;
    NSInteger section = indexPath.section;

    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:indexPath.row];
    
    cell.playTypeTag = m_playTypeTag;
    if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
        cell.isLeftSelect = [base ZQ_S_ButtonIsSelect];
        
        cell.isCenterSelect = [base ZQ_P_ButtonIsSelect];
        
        cell.isRightSelect = [base ZQ_F_ButtonIsSelect];
    }
    else
    {
        NSString *buttonText = @"";
        NSMutableArray *array = [base sfc_selectTag];
        int count  = [array count];
        
        if (m_playTypeTag == IBJDCPlayType_ZJQ)
        {
            buttonText = @"";
            for (int i = 0; i < count; i++)
            {
                int selectTag = [[[base sfc_selectTag] objectAtIndex:i] intValue];
                if (selectTag == 7) {
                    if (i != count -1) {
                        buttonText = [buttonText stringByAppendingFormat:@"%d+ ,",selectTag];
                    }
                    else
                        buttonText = [buttonText stringByAppendingFormat:@"%d+",selectTag];
                }
                else
                {
                    if (i != count -1) {
                        buttonText = [buttonText stringByAppendingFormat:@"%d ,",selectTag];
                    }
                    else
                        buttonText = [buttonText stringByAppendingFormat:@"%d",selectTag];
                }
                
                if (i <= count - 1)
                {
                    buttonText = [buttonText stringByAppendingString:@"     "];
                }
            }
        }
        else if(m_playTypeTag == IBJDCPlayType_Score)
        {
            for (int i = 0; i < count; i++)
            {
                int tag = [[array objectAtIndex:i] intValue];
                buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath.section Row:indexPath.row  Tag:tag isGetBetCode:NO]];
                if (i <= count - 1)
                {
                    buttonText = [buttonText stringByAppendingString:@"     "];
                }
            }
        }
        else if(m_playTypeTag == IBJDCPlayType_HalfAndAll)
        {
            for (int i = 0; i < count; i++)
            {
                int tag = [[array objectAtIndex:i] intValue];
                buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath.section Row:indexPath.row  Tag:tag isGetBetCode:NO]];
                
                if (i <= count - 1)
                {
                    buttonText = [buttonText stringByAppendingString:@"     "];
                }
            }
        }
        if (count == 0) {
            cell.SFCButtonText = @"请选择投注选项";
        }
        else
            cell.SFCButtonText = buttonText;
    }
//    cell.weekld = [base weekld];
    cell.weekld = @"";
    cell.teamld = [base teamld];
    cell.league = [base league];
    cell.endTime = [base endTime];
    cell.homeTeam = [base homeTeam];
    cell.VisitTeam = [base VisitTeam];
    cell.letPoint = [base letPoint];

    if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
        cell.v0 = [base v0];
        cell.v1 = [base v1];
        cell.v3 = [base v3];
    }
    if (m_playTypeTag == IBJDCPlayType_SXDS) {
        cell.sxdsV1 = [base sxdsV1];
        cell.sxdsV2 = [base sxdsV2];
        cell.sxdsV3 = [base sxdsV3];
        cell.sxdsV4 = [base sxdsV4];
        
        cell.isSXDSSelect_SD = [base BD_SD_ButtonIsSelect];
        cell.isSXDSSelect_SS = [base BD_SS_ButtonIsSelect];
        cell.isSXDSSelect_XD = [base BD_XD_ButtonIsSelect];
        cell.isSXDSSelect_XS = [base BD_XS_ButtonIsSelect];
    }
    
    if ([self gameIsSelect:indexPath]) {
        if ([base JC_DanIsSelect]) {
            NSLog(@"\n[tableCell JC_DanIsSelect]:%d",indexPath.row);
        }
        [cell setIsJC_Button_Dan_Select:[base JC_DanIsSelect]];
    }
    else
    {
        [cell setIsJC_Button_Dan_Select:FALSE];
    }
    
    [cell RefreshCellView];
    return cell;
}

#pragma mark --
-(NSString*) getTitleBy_playType
{
    NSString* title = @"";

    if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
        title = @"单场让球胜平负";
    }
    else if(m_playTypeTag == IBJDCPlayType_ZJQ)
    {
        title = @"单场总进球数";
    }
    else if(m_playTypeTag == IBJDCPlayType_Score)
    {
        title = @"单场比分";
    }
    else if(m_playTypeTag == IBJDCPlayType_HalfAndAll)
    {
        title = @"单场半全场";
    }
    else if(m_playTypeTag == IBJDCPlayType_SXDS)
    {
        title = @"单场上下单双";
    }
    return title;
}

//获得 比分 和 半全场的 按钮 text
- (NSString*)getSfcScore:(NSInteger)section Row:(NSInteger)row Tag:(NSInteger)tag isGetBetCode:(BOOL)isGetbetCode
{
    NSString *temp = @"";
    //加 | 用来分离文字和数据
    if (m_playTypeTag == IBJDCPlayType_Score)
    {
        if (tag == 0) {
            temp = [temp stringByAppendingString:@"胜其它|"];
            
            if (isGetbetCode) {
                return @"90";
            }
        }
        else if(tag == 1)
        {
            temp = [temp stringByAppendingString:@"1 : 0|"];
            
            if (isGetbetCode) {
                return @"10";
            }
        }
        else if(tag == 2)
        {
            temp = [temp stringByAppendingString:@"2 : 0|"];
            
            if (isGetbetCode) {
                return @"20";
            }
        }
        else if(tag == 3)
        {
            temp = [temp stringByAppendingString:@"2 : 1|"];
            
            if (isGetbetCode) {
                return @"21";
            }
        }
        else if(tag == 4)
        {
            temp = [temp stringByAppendingString:@"3 : 0|"];
            
            if (isGetbetCode) {
                return @"30";
            }
        }
        else if(tag == 5)
        {
            temp = [temp stringByAppendingString:@"3 : 1|"];
            
            if (isGetbetCode) {
                return @"31";
            }
        }
        else if(tag == 6)
        {
            temp = [temp stringByAppendingString:@"3 : 2|"];
            
            if (isGetbetCode) {
                return @"32";
            }
        }
        else if(tag == 7)
        {
            temp = [temp stringByAppendingString:@"4 : 0|"];
            
            if (isGetbetCode) {
                return @"40";
            }
        }
        
        else if(tag == 8)
        {
            temp = [temp stringByAppendingString:@"4 : 1|"];
            
            if (isGetbetCode) {
                return @"41";
            }
        }
        else if(tag == 9)
        {
            temp = [temp stringByAppendingString:@"4 : 2|"];
            
            if (isGetbetCode) {
                return @"42";
            }
        }
//        else if(tag == 10)
//        {
//            temp = [temp stringByAppendingString:@"5 : 0|"];
//            
//            if (isGetbetCode) {
//                return @"50";
//            }
//        }
//        else if(tag == 11)
//        {
//            temp = [temp stringByAppendingString:@"5 : 1|"];
//            
//            if (isGetbetCode) {
//                return @"51";
//            }
//        }
//        else if(tag == 12)
//        {
//            temp = [temp stringByAppendingString:@"5 : 2|"];
//            
//            if (isGetbetCode) {
//                return @"52";
//            }
//        }
        
        else if(tag == 10)
        {
            temp = [temp stringByAppendingString:@"平其它|"];
            
            if (isGetbetCode) {
                return @"99";
            }
        }
        else if(tag == 11)
        {
            temp = [temp stringByAppendingString:@"0 : 0|"];
            
            if (isGetbetCode) {
                return @"00";
            }
        }
        else if(tag == 12)
        {
            temp = [temp stringByAppendingString:@"1 : 1|"];
            
            if (isGetbetCode) {
                return @"11";
            }
        }
        else if(tag == 13)
        {
            temp = [temp stringByAppendingString:@"2 : 2|"];
            
            if (isGetbetCode) {
                return @"22";
            }
        }
        else if(tag == 14)
        {
            temp = [temp stringByAppendingString:@"3 : 3|"];
            if (isGetbetCode) {
                return @"33";
            }
        }
        
        else if(tag == 15)
        {
            temp = [temp stringByAppendingString:@"负其它|"];
            if (isGetbetCode) {
                return @"09";
            }
        }
        else if(tag == 16)
        {
            temp = [temp stringByAppendingString:@"0 : 1|"];
            
            if (isGetbetCode) {
                return @"01";
            }
        }
        else if(tag == 17)
        {
            temp = [temp stringByAppendingString:@"0 : 2|"];
            
            if (isGetbetCode) {
                return @"02";
            }
        }
        
        else if(tag == 18)
        {
            temp = [temp stringByAppendingString:@"1 : 2|"];
            
            if (isGetbetCode) {
                return @"12";
            }
        }
        else if(tag == 19)
        {
            temp = [temp stringByAppendingString:@"0 : 3|"];
            
            if (isGetbetCode) {
                return @"03";
            }
        }
        
        else if(tag == 20)
        {
            temp = [temp stringByAppendingString:@"1 : 3|"];
            
            if (isGetbetCode) {
                return @"13";
            }
        }
        else if(tag == 21)
        {
            temp = [temp stringByAppendingString:@"2 : 3|"];
            
            if (isGetbetCode) {
                return @"23";
            }
        }
        else if(tag == 22)
        {
            temp = [temp stringByAppendingString:@"0 : 4|"];
            
            if (isGetbetCode) {
                return @"04";
            }
        }
        else if(tag == 23)
        {
            temp = [temp stringByAppendingString:@"1 : 4|"];
            
            if (isGetbetCode) {
                return @"14";
            }
        }
        else if(tag == 24)
        {
            temp = [temp stringByAppendingString:@"2 : 4|"];
            
            if (isGetbetCode) {
                return @"24";
            }
        }
//        else if(tag == 28)
//        {
//            temp = [temp stringByAppendingString:@"0 : 5|"];
//            
//            if (isGetbetCode) {
//                return @"05";
//            }
//        }
//        else if(tag == 29)
//        {
//            temp = [temp stringByAppendingString:@"1 : 5|"];
//            
//            if (isGetbetCode) {
//                return @"15";
//            }
//        }
//        else if(tag == 30)
//        {
//            temp = [temp stringByAppendingString:@"2 : 5|"];
//            if (isGetbetCode) {
//                return @"25";
//            }
//        }
        
        if (tag <= 9) {
            m_tempStr = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] score_S_Array] objectAtIndex:tag];
            
            temp = [temp stringByAppendingString:m_tempStr];
        }
        if( 9 < tag && tag < 15)
        {
            m_tempStr = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] score_P_Array] objectAtIndex:tag - 10];
            
            temp = [temp stringByAppendingString:m_tempStr];
        }
        if(tag >= 15)
        {
            m_tempStr = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] score_F_Array] objectAtIndex:tag - 15];
            
            temp = [temp stringByAppendingString:m_tempStr];
        }
        
    }
    else if (m_playTypeTag == IBJDCPlayType_HalfAndAll)
    {
        if (tag == 0) {
            if (isGetbetCode) {
                return @"33";
            }
            temp = [temp stringByAppendingString:@"胜胜|"];
        }
        else if(tag == 1)
        {
            if (isGetbetCode) {
                return @"31";
            }
            temp = [temp stringByAppendingString:@"胜平|"];
        }
        else if(tag == 2)
        {
            if (isGetbetCode) {
                return @"30";
            }
            temp = [temp stringByAppendingString:@"胜负|"];
        }
        else if(tag == 3)
        {
            if (isGetbetCode) {
                return @"13";
            }
            temp = [temp stringByAppendingString:@"平胜|"];
        }
        
        else if(tag == 4)
        {
            if (isGetbetCode) {
                return @"11";
            }
            temp = [temp stringByAppendingString:@"平平|"];
        }
        else if(tag == 5)
        {
            if (isGetbetCode) {
                return @"10";
            }
            temp = [temp stringByAppendingString:@"平负|"];
        }
        else if(tag == 6)
        {
            if (isGetbetCode) {
                return @"03";
            }
            temp = [temp stringByAppendingString:@"负胜|"];
        }
        else if(tag == 7)
        {
            if (isGetbetCode) {
                return @"01";
            }
            temp = [temp stringByAppendingString:@"负平|"];
        }
        else if(tag == 8)
        {
            if (isGetbetCode) {
                return @"00";
            }
            temp = [temp stringByAppendingString:@"负负|"];
        }        
        
        m_tempStr = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] half_Array] objectAtIndex:tag];
        temp = [temp stringByAppendingString:m_tempStr];
        
    }
    return temp;
}

#pragma mark 跳转
-(void) gotoSFCView:(NSIndexPath*)indexPath
{
//    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
    if (m_numGameCount >= 10)
    {
        JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[indexPath section]] tableHeaderArray] objectAtIndex:[indexPath row]];
        
        if (m_playTypeTag == IJCZQPlayType_Confusion) {
            int confusion_selectCount = 0;
            for (int i = 0; i < [[base confusion_selectTag] count]; i++)
            {
                confusion_selectCount += [[[base confusion_selectTag] objectAtIndex:i] count];
            }
            if (confusion_selectCount == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多选择10场比赛" withTitle:@"投注提示" buttonTitle:@"确定"];
                return;
            }
        }
        else
        {
            int count = [[base sfc_selectTag] count];
            if (count == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多选择10场比赛" withTitle:@"投注提示" buttonTitle:@"确定"];
                return;
            }
        }
    }
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:indexPath.section] tableHeaderArray] objectAtIndex:indexPath.row];
    NSString *temp = @"";
    temp = [temp stringByAppendingString:[base homeTeam]];
    temp = [temp stringByAppendingString:@" VS "];
    temp = [temp stringByAppendingString:[base VisitTeam]];   

    SFCViewController* viewController = [[SFCViewController alloc] init];
    viewController.navigationItem.title = @"返回";
    viewController.BJDC_parentController = self;
    viewController.indexPath = indexPath;
    viewController.isJCLQView = 2;
    viewController.playTypeTag = m_playTypeTag;
    viewController.team = temp;
    
    //总进球数
    if (m_playTypeTag == IBJDCPlayType_ZJQ) {
        int ZJQ_count = [[base goalArray] count];//8
        
        for (int i = 0; i < ZJQ_count; i++) {//把button的title串起来（以｜分隔）
            NSString *buttonText = @"";
            buttonText = [buttonText stringByAppendingFormat:@"%d|%@",i,
                          [[base goalArray] objectAtIndex:i]];
            [viewController appendButtonText:buttonText];
        }
        int scoreCount = [[base sfc_selectTag] count];
        for (int i = 0; i < scoreCount; i++) {
            [viewController appendSelectScoreText:[[base sfc_selectTag] objectAtIndex:i]];
        }
        
    }
    //比分
    if (m_playTypeTag == IBJDCPlayType_Score)
    {
        int winCount = [[base score_S_Array] count];
        int PingCount = [[base score_P_Array] count];
        int FuCount = [[base score_F_Array] count];
        for (int i = 0; i < winCount + PingCount + FuCount; i++) {
            NSString *buttonText = @"";
            
            buttonText = [buttonText stringByAppendingFormat:@"%@",[self getSfcScore:indexPath.section Row:indexPath.row  Tag:(i) isGetBetCode:NO]];
            
            [viewController appendButtonText:buttonText];
        }
        
        int scoreCount = [[base sfc_selectTag] count];
        for (int i = 0; i < scoreCount; i++) {
            [viewController appendSelectScoreText:[[base sfc_selectTag] objectAtIndex:i]];
        }
    }
    //半全场
    if (m_playTypeTag == IBJDCPlayType_HalfAndAll) {
        
        int half_Count = [[base half_Array] count];
        for (int i = 0; i < half_Count; i++) {
            NSString *buttonText = @"";
            buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath.section Row:indexPath.row  Tag:(i) isGetBetCode:NO]];
            [viewController appendButtonText:buttonText];
        }
        
        int scoreCount = [[base sfc_selectTag] count];
        for (int i = 0; i < scoreCount; i++) {
            [viewController appendSelectScoreText:[[base sfc_selectTag] objectAtIndex:i]];
        }
    }
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void) gotoLeagueChoose
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    JC_LeagueChooseViewController* viewController = [[JC_LeagueChooseViewController alloc] init];
    viewController.isJCLQView = 2;
	viewController.navigationItem.title = @"返回";
    viewController.BJDC_parentController = self;
    int  count = [m_league_selected_tableCell_DataArrayTag count];
    for (int i = 0; i < count; i++)
    {
        [viewController appendSelectedLeagueTag:[m_league_selected_tableCell_DataArrayTag objectAtIndex:i]];
    }
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

-(void) gotoFenxiView:(NSIndexPath*)indexPath
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    DataAnalysisViewController* viewController = [[DataAnalysisViewController alloc] init];

    NSString*   event = [NSString stringWithFormat:@"%@_", self.batchCode];
    event = [event stringByAppendingString:[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:indexPath.section] tableHeaderArray] objectAtIndex:indexPath.row] teamld]];
    
    [viewController setEvent:event];
    [viewController setIsJCLQ:FALSE];
    [viewController setIsZC:YES];
    [viewController setIsBJDC:YES];

    viewController.navigationItem.title = @"球队数据分析";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

#pragma mark 投注
-(NSString*) commonDisBetCode:(NSString*)disBetCode I:(NSInteger)i J:(NSInteger)j
{
    //主队 VS 客队
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
    
    NSString *letPointString = @"VS";
    
    if ([base letPoint].length > 0) {
        
        if ([base letPoint].intValue == 0) {
            
            letPointString = @"VS";
        }
        else
        {
            letPointString = [base letPoint];
        }
    }
    else
    {
        letPointString = @"VS";
    }
    
    
    if ([base JC_DanIsSelect]) {
        if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
            disBetCode = [disBetCode stringByAppendingFormat:@"%@(胆)  %@ %@ %@@",[base teamld], [base homeTeam],letPointString,[base VisitTeam]];
        }
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%@(胆)  %@ VS %@@",[base teamld],[base homeTeam],[base VisitTeam]];
    }
    else
    {
        if (m_playTypeTag == IBJDCPlayType_RQ_SPF) {
            disBetCode = [disBetCode stringByAppendingFormat:@"%@  %@ %@ %@@",[base teamld], [base homeTeam],letPointString,[base VisitTeam]];
        }
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%@  %@ VS %@@",[base teamld],[base homeTeam],[base VisitTeam]];
    }
    return disBetCode;
    
}
-(NSString*) commonBetCode:(NSString*)betCode I:(NSInteger)i J:(NSInteger)j
{
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];

    betCode = [betCode stringByAppendingFormat:@"%@|",[base teamld]];
    return betCode;
}
- (void)submitLotNotification:(id)sender
{
    NSTrace();
    
    //添加  赔率
    if (m_arrangeSP != nil)
    {
        [m_arrangeSP removeAllObjects];
        [m_arrangeSP release];
    }
    m_arrangeSP = [[NSMutableArray alloc] initWithCapacity:10];
    
    //显示你的订单详情，并生成投注信息
    NSString* disBetCode = @"";
	NSString* betCode = @"";
    NSString* betCode_Dan = @"";
  
    for (int i = 0; i < m_headerCount; i++)
    {
        int everyHeaderBaseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < everyHeaderBaseCount; j++) {
            NSString*  WinSelect = @"";
            BOOL ishave = FALSE;
            /////////////////////////betCode////////////////////////////
             /*529@013|310^014|3^015|3^016|310^017|013^
             529表示玩法
             013,014表示赛事编号
             310表示投注的内容
             ^分割不同场次*/
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            if (m_playTypeTag == IBJDCPlayType_RQ_SPF)
            {
                
                //每一个对阵赔率
                CombineBase *gameSparray = [[CombineBase alloc] init];
                
                BOOL ZQ_S_ButtonIsSelect = [base ZQ_S_ButtonIsSelect];
                BOOL ZQ_P_ButtonIsSelect = [base ZQ_P_ButtonIsSelect];
                BOOL ZQ_F_ButtonIsSelect = [base ZQ_F_ButtonIsSelect];
                if (ZQ_F_ButtonIsSelect || ZQ_P_ButtonIsSelect ||ZQ_S_ButtonIsSelect)
                {
                    ishave = TRUE;
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan  = [self commonBetCode:betCode_Dan I:i J:j];
                    }
                    else{
                        betCode = [self commonBetCode:betCode I:i J:j];
                    }
                    disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                    disBetCode = [disBetCode stringByAppendingString:@"让球胜平负~"];
                    if (ZQ_S_ButtonIsSelect)
                    {
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan  = [betCode_Dan stringByAppendingString:@"3"];
                        }
                        else{
                            betCode = [betCode stringByAppendingString:@"3"];
                        }
                        [[gameSparray combineBase_SP] addObject:[base v3]];
                      disBetCode = [disBetCode stringByAppendingString:@" 胜"];  
                    }
                    if (ZQ_P_ButtonIsSelect)
                    {
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan  = [betCode_Dan stringByAppendingString:@"1"];
                        }
                        else{
                            betCode = [betCode stringByAppendingString:@"1"];
                        }
                        disBetCode = [disBetCode stringByAppendingString:@" 平"];
                        [[gameSparray combineBase_SP] addObject:[base v1]];
                    }
                    if (ZQ_F_ButtonIsSelect)
                    {
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan  = [betCode_Dan stringByAppendingString:@"0"];
                        }
                        else{
                            betCode = [betCode stringByAppendingString:@"0"];
                        }
                        disBetCode = [disBetCode stringByAppendingString:@" 负"];
                        [[gameSparray combineBase_SP] addObject:[base v0]];
                    }
                    disBetCode = [disBetCode stringByAppendingString:@","];
                }
                if (ishave) {
                    [gameSparray setIsDan:[base JC_DanIsSelect]];
                    [m_arrangeSP addObject:gameSparray];
                }
                [gameSparray release];
                [RuYiCaiLotDetail sharedObject].lotNo = kLotNoBJDC_RQSPF;
            }
            else if (m_playTypeTag == IBJDCPlayType_ZJQ)
            {
                CombineBase* gameSparray = [[CombineBase alloc] init];
                NSMutableArray *array = [base sfc_selectTag];
                if ([array count] > 0) {
                    ishave = TRUE;
                    disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [self commonBetCode:betCode_Dan I:i J:j];
                    }
                    else
                        betCode = [self commonBetCode:betCode I:i J:j];
                }
                //每一个对阵赔率
                WinSelect = [WinSelect stringByAppendingString:@"总进球~"];
                for (int m = 0; m < [array count]; m++)
                {
                    int tag = [[array objectAtIndex:m] intValue];
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [betCode_Dan stringByAppendingFormat:@"%d",tag];
                    }
                    else
                        betCode = [betCode stringByAppendingFormat:@"%d",tag];
                    
                    WinSelect = [WinSelect stringByAppendingFormat:@"  %d  ",tag];
                    NSLog(@"%@",[base goalArray]);
                    [[gameSparray combineBase_SP] addObject:[[base goalArray] objectAtIndex:tag]];
//                    [[gameSparray combineBase_SP] addObject:m_tempStr];
                }
                if (ishave) {
                    [gameSparray setIsDan:[base JC_DanIsSelect]];
                    [m_arrangeSP addObject:gameSparray];
                }
                [gameSparray release];
                
//                WinSelect = [WinSelect stringByAppendingString:@","];
                [RuYiCaiLotDetail sharedObject].lotNo = kLotNoBJDC_JQS;
                
            }
            else if (m_playTypeTag == IBJDCPlayType_Score)
            {
                NSMutableArray *array = [base sfc_selectTag];
                if ([array count] > 0) {
                    ishave = TRUE;
                    disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                    disBetCode = [disBetCode stringByAppendingString:@"比分~"];
                    
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [self commonBetCode:betCode_Dan I:i J:j];
                    }
                    else
                        betCode = [self commonBetCode:betCode I:i J:j];
                }
                
                //每一个对阵赔率
                CombineBase *gameSparray = [[CombineBase alloc] init];
                
                for (int m = 0; m < [array count]; m++)
                {
                    int tag = [[array objectAtIndex:m] intValue];
                    
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [betCode_Dan stringByAppendingString:[self getSfcScore:i Row:j Tag:tag isGetBetCode:YES]];
                    }
                    else
                        betCode = [betCode stringByAppendingString:[self getSfcScore:i Row:j Tag:tag isGetBetCode:YES]];
                    
                    WinSelect = [WinSelect stringByAppendingFormat:@"  %@  ",[self getSfcScore:i Row:j Tag:tag isGetBetCode:NO]];
                    [[gameSparray combineBase_SP] addObject:m_tempStr];
                }
                if (ishave) {
                    [gameSparray setIsDan:[base JC_DanIsSelect]];
                    [m_arrangeSP addObject:gameSparray];
                }
                [gameSparray release];
                WinSelect = [WinSelect stringByAppendingString:@","];
                [RuYiCaiLotDetail sharedObject].lotNo = kLotNoBJDC_Score;
            }
                
            else if(m_playTypeTag == IBJDCPlayType_HalfAndAll)
            {
                NSMutableArray *array = [base sfc_selectTag];
                if ([array count] > 0) {
                    ishave = TRUE;
                    disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                    disBetCode = [disBetCode stringByAppendingString:@"半全场~"];
                    
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [self commonBetCode:betCode_Dan I:i J:j];
                    }
                    else
                        betCode = [self commonBetCode:betCode I:i J:j];
                }
                
                //每一个对阵赔率
                CombineBase *gameSparray = [[CombineBase alloc] init];
                
                for (int m = 0; m < [array count]; m++)
                {
                    int tag = [[array objectAtIndex:m] intValue];
                    
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [betCode_Dan stringByAppendingString:[self getSfcScore:i Row:j Tag:tag isGetBetCode:YES]];
                    }
                    else
                        betCode = [betCode stringByAppendingString:[self getSfcScore:i Row:j Tag:tag isGetBetCode:YES]];
                                        
                    WinSelect = [WinSelect stringByAppendingFormat:@"  %@  ",[self getSfcScore:i Row:j Tag:tag isGetBetCode:NO]];
                    [[gameSparray combineBase_SP] addObject:m_tempStr];
                }
                if (ishave) {
                    [gameSparray setIsDan:[base JC_DanIsSelect]];
                    [m_arrangeSP addObject:gameSparray];
                }
                [gameSparray release];

                WinSelect = [WinSelect stringByAppendingString:@","];
                [RuYiCaiLotDetail sharedObject].lotNo = kLotNoBJDC_HalfAndAll;
            }
            else if(m_playTypeTag == IBJDCPlayType_SXDS)//上下单双
            {
                CombineBase *gameSparray = [[CombineBase alloc] init];
                if ([base BD_SD_ButtonIsSelect] || [base BD_SS_ButtonIsSelect] || [base BD_XD_ButtonIsSelect] || [base BD_XS_ButtonIsSelect]) {
                    ishave = TRUE;
                    
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [self commonBetCode:betCode_Dan I:i J:j];
                    }
                    else
                        betCode = [self commonBetCode:betCode I:i J:j];
                    
                    disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                    disBetCode = [disBetCode stringByAppendingString:@"上下单双~"];

                    if ([base BD_SD_ButtonIsSelect]) {
                        
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan = [betCode_Dan stringByAppendingString:@"1"];
                        }
                        else
                            betCode = [betCode stringByAppendingString:@"1"];
                        [[gameSparray combineBase_SP] addObject:[base sxdsV1]];
                        disBetCode = [disBetCode stringByAppendingString:@" 上单"];
                    }
                    if ([base BD_SS_ButtonIsSelect]) {
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan = [betCode_Dan stringByAppendingString:@"2"];
                        }
                        else
                            betCode = [betCode stringByAppendingString:@"2"];
                        disBetCode = [disBetCode stringByAppendingString:@" 上双"];
                        [[gameSparray combineBase_SP] addObject:[base sxdsV2]];
                    }
                    if ([base BD_XD_ButtonIsSelect]) {
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan = [betCode_Dan stringByAppendingString:@"3"];
                        }
                        else
                            betCode = [betCode stringByAppendingString:@"3"];
                        disBetCode = [disBetCode stringByAppendingString:@" 下单"];
                        [[gameSparray combineBase_SP] addObject:[base sxdsV3]];
                    }
                    if ([base BD_XS_ButtonIsSelect]) {
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan = [betCode_Dan stringByAppendingString:@"4"];
                        }
                        else
                            betCode = [betCode stringByAppendingString:@"4"];
                        disBetCode = [disBetCode stringByAppendingString:@" 下双"];
                        [[gameSparray combineBase_SP] addObject:[base sxdsV4]];
                    }
//                    disBetCode = [disBetCode stringByAppendingString:@","];
                }
                if (ishave) {
                    [gameSparray setIsDan:[base JC_DanIsSelect]];
                    [m_arrangeSP addObject:gameSparray];
                }
                [gameSparray release];
                
                [RuYiCaiLotDetail sharedObject].lotNo = kLotNoBJDC_SXDS;
            }
            if (ishave)
            {
                if ([base JC_DanIsSelect]) {
                    betCode_Dan = [betCode_Dan stringByAppendingString:@"^"];
                }
                else
                    betCode = [betCode stringByAppendingString:@"^"];
                //添加 场次分隔符
                WinSelect = [WinSelect stringByAppendingString:@";"];
                disBetCode = [disBetCode stringByAppendingString:WinSelect];
            }
            
        }
    }    
	NSLog(@"betCode****** %@",betCode);
    NSLog(@"disBetCode****** %@",disBetCode);
    NSLog(@"betCode_Dan****** %@",betCode_Dan);
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    
    NSString *dantuo_betCode = @"";
    
    if ([betCode_Dan length] > 0) {
        dantuo_betCode = [dantuo_betCode stringByAppendingString:betCode_Dan];
        dantuo_betCode = [dantuo_betCode stringByAppendingString:@"$"];
    }
    
    dantuo_betCode =  [dantuo_betCode stringByAppendingString:betCode];
    
    NSLog(@"dantuo_betCode****** %@",dantuo_betCode);
    
    [RuYiCaiLotDetail sharedObject].betCode = dantuo_betCode;
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    [RuYiCaiLotDetail sharedObject].sellWay = @"";
	[RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
    [self betNormal:nil];
}
- (void)betNormal:(NSNotification*)notification
{
    [self setHidesBottomBarWhenPushed:YES];
	BJDC_Bet_viewController* viewController = [[BJDC_Bet_viewController alloc]init];
    
    //把赔率传过去
    for (int spindex = 0; spindex < [m_arrangeSP count]; spindex++)
    {
        CombineBase* array = (CombineBase*)[m_arrangeSP objectAtIndex:spindex];
        
        [viewController appendArrangePS:array];
        NSLog(@"array %@", array.combineBase_SP);
    }
    
    //排序
    [viewController sortSPArray];
    
    viewController.gameCount = m_numGameCount;
//        m_twoCount = 0;
    for (int i = 0; i < m_headerCount; i++)
    {
        int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        
        for (int j = 0; j < baseCount; j++)
        {
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            
            int selectCount = [[base sfc_selectTag] count];
            if (m_playTypeTag == IBJDCPlayType_RQ_SPF)
            {
                BOOL BD_S_ButtonIsSelect = [base ZQ_S_ButtonIsSelect];
                BOOL BD_P_ButtonIsSelect = [base ZQ_P_ButtonIsSelect];
                BOOL BD_F_ButtonIsSelect = [base ZQ_F_ButtonIsSelect];
                if (BD_S_ButtonIsSelect || BD_P_ButtonIsSelect || BD_F_ButtonIsSelect)
                {
                    if((BD_S_ButtonIsSelect && BD_P_ButtonIsSelect) ||
                       (BD_S_ButtonIsSelect && BD_F_ButtonIsSelect) ||
                       (BD_P_ButtonIsSelect && BD_F_ButtonIsSelect)
                       )//选2个或3个结果时
                    {
                        if (BD_S_ButtonIsSelect && BD_P_ButtonIsSelect && BD_F_ButtonIsSelect)
                        {
                            [viewController appendDuoChuanChoose:@"3" IS_DAN:[base JC_DanIsSelect] CONFUSION:nil];
                        }
                        else
                            [viewController appendDuoChuanChoose:@"2" IS_DAN:[base JC_DanIsSelect] CONFUSION:nil];
                    }
                    else//选1个结果时
                    {
                        [viewController appendDuoChuanChoose:@"1" IS_DAN:[base JC_DanIsSelect] CONFUSION:nil];
                    }
                }
            }
            else if(m_playTypeTag == IBJDCPlayType_SXDS)
            {
                BOOL BD_SD_ButtonIsSelect = [base BD_SD_ButtonIsSelect];
                BOOL BD_SS_ButtonIsSelect = [base BD_SS_ButtonIsSelect];
                BOOL BD_XD_ButtonIsSelect = [base BD_XD_ButtonIsSelect];
                BOOL BD_XS_ButtonIsSelect = [base BD_XS_ButtonIsSelect];
                
                int count_yes = BD_SD_ButtonIsSelect + BD_SS_ButtonIsSelect + BD_XD_ButtonIsSelect + BD_XS_ButtonIsSelect;
                if (count_yes != 0) {
                    [viewController appendDuoChuanChoose:[NSString stringWithFormat:@"%d", count_yes] IS_DAN:[base JC_DanIsSelect] CONFUSION:nil];
                }
            }
            else
            {
                if (selectCount > 0)
                {
                    NSString *temp = @"";
                    temp = [temp stringByAppendingFormat:@"%d",selectCount];
                    [viewController appendDuoChuanChoose:temp IS_DAN:[base JC_DanIsSelect] CONFUSION:nil];
                }
            }
        }
    }
 
//    viewController.twoCount = m_twoCount;*/
    
    viewController.playTypeTag = m_playTypeTag;
	viewController.navigationItem.title = @"北京单场投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


#pragma mark 中间 玩法切换 按钮
- (void)playChooseViewButtonClick
{
    m_detailView.hidden = YES;
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    if(m_playChooseView.hidden)
    {
        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_playChooseView.layer addAnimation:transition forKey:nil];
        m_playChooseView.hidden = NO;
    }
    else
    {
        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_playChooseView.layer addAnimation:transition forKey:nil];
        m_playChooseView.hidden = YES;
    }
}
- (void)setPlayChooseView
{
    if (m_playChooseView == nil)
    {
        m_playChooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        m_playChooseView.backgroundColor = kColorWithRGB(0.0, 0.0, 0.0, 0.7);
        
        BJDC_PlayChoseView* playTypeView = [[BJDC_PlayChoseView alloc] initWithFrame:CGRectMake(32, 0, 256, 160)];
        playTypeView.parentController = self;
        [m_playChooseView addSubview:playTypeView];
        [playTypeView release];
        
        [self.view addSubview:m_playChooseView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(playChooseViewTouch:)];
        tapGestureRecognizer.delegate = self;
        [m_playChooseView addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    m_playChooseView.hidden = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)playChooseViewTouch:(id)sender
{
    [self playChooseViewButtonClick];
}

- (void) playChooseButtonEvent
{
    [self playChooseViewButtonClick];
    [centerButton setTitle:[self getTitleBy_playType] forState:UIControlStateNormal];
   
    if (m_tableCell_DataArray != nil)
    {
        [m_tableCell_DataArray removeAllObjects];
        m_headerCount = 0;
//        [m_tableView reloadData];
    }
    
    [self clearAllChoose];
 
    switch (self.playTypeTag) {
        case IBJDCPlayType_RQ_SPF:
        {
            [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoBJDC_RQSPF];//获取期号
            m_currentLotNo = kLotNoBJDC_RQSPF;
            break;
        }
        case IBJDCPlayType_ZJQ:
        {
            [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoBJDC_JQS];
            m_currentLotNo = kLotNoBJDC_JQS;
            break;
        }
        case IBJDCPlayType_Score:
        {
            [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoBJDC_Score];
            m_currentLotNo = kLotNoBJDC_Score;
            break;
        }
        case IBJDCPlayType_HalfAndAll:
        {
            [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoBJDC_HalfAndAll];
            m_currentLotNo = kLotNoBJDC_HalfAndAll;
            break;
        }
        case IBJDCPlayType_SXDS:
        {
           [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoBJDC_SXDS];
            m_currentLotNo = kLotNoBJDC_SXDS;
            break;
        }
        default:
            break;
    }
}

#pragma mark   右上角 下拉按钮

#pragma mark 详情页
- (void)detailViewButtonClick:(id)sender
{
    m_playChooseView.hidden = YES;
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    if(m_detailView.hidden)
    {
        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_detailView.layer addAnimation:transition forKey:nil];
        m_detailView.hidden = NO;
    }
    else
    {
        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_detailView.layer addAnimation:transition forKey:nil];
        m_detailView.hidden = YES;
    }
}

- (void)setDetailView
{
    if (m_detailView != NULL) {
        [m_detailView removeFromSuperview];
        [m_detailView release];
    }
    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 145, 165)];
    m_detailView.backgroundColor = [UIColor clearColor];
    
    UIImageView* imgBg = [[CommonRecordStatus commonRecordStatusManager] creatFourButtonView];
    [m_detailView addSubview:imgBg];
  
    UIButton* teamButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 12, 135, 30)];
    UIImageView *team_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    team_icon.image = RYCImageNamed(@"jcgamechoose_ico.png");
    [teamButton addSubview:team_icon];
    [team_icon release];
    teamButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [teamButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [teamButton setTitle:@"赛事筛选" forState:UIControlStateNormal];
    [teamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    teamButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [teamButton addTarget:self action:@selector(leagueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_detailView addSubview:teamButton];
    [teamButton release];
    
    //及时比分
    UIButton* instantScoreButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 50, 135, 30)];
    UIImageView *instantScore_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    instantScore_icon.image = RYCImageNamed(@"jcnowscore_ico.png");
    [instantScoreButton addSubview:instantScore_icon];
    [instantScore_icon release];
    instantScoreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [instantScoreButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [instantScoreButton setTitle:@"即时比分" forState:UIControlStateNormal];
    [instantScoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    instantScoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [instantScoreButton addTarget:self action:@selector(scoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_detailView addSubview:instantScoreButton];
    [instantScoreButton release];
    
    
    UIButton* intructionButton  = [[UIButton alloc] initWithFrame:CGRectMake(5, 89, 135, 30)];
    UIImageView *intruction_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    intruction_icon.image = RYCImageNamed(@"jcplayinstruction_ico.png");
    [intructionButton addSubview:intruction_icon];
    [intruction_icon release];
    intructionButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [intructionButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [intructionButton setTitle:@"玩法介绍" forState:UIControlStateNormal];
    [intructionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    intructionButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [intructionButton addTarget:self action:@selector(InstructionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_detailView addSubview:intructionButton];
    [intructionButton release];
    
    UIButton* queryBetLotButton  = [[UIButton alloc] initWithFrame:CGRectMake(5, 127, 135, 30)];
    UIImageView *queryBetLot_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    queryBetLot_icon.image = RYCImageNamed(@"querybetlot_ico.png");
    [queryBetLotButton addSubview:queryBetLot_icon];
    [queryBetLot_icon release];
    queryBetLotButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [queryBetLotButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [queryBetLotButton setTitle:@"投注查询" forState:UIControlStateNormal];
    [queryBetLotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    queryBetLotButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [queryBetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_detailView addSubview:queryBetLotButton];
    [queryBetLotButton release];
    [self.view addSubview:m_detailView];
    
    m_detailView.hidden = YES;
}
- (void)queryBetlot_loginOK:(NSNotification*)notification
{
    [self queryBetLotButtonClick:nil];
}
- (void)queryBetLotButtonClick:(id)sender
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoBJDC;
    if (![[RuYiCaiNetworkManager sharedManager] hasLogin]) {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    else
    {
        [self setHidesBottomBarWhenPushed:YES];
        QueryLotBetViewController* viewController = [[QueryLotBetViewController alloc] init];
        viewController.navigationItem.title = @"投注查询";
        [viewController setSelectLotNo:kLotNoBJDC];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];

        [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
    }
}

- (void)leagueButtonClick:(id)sender;
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    JC_LeagueChooseViewController* viewController = [[JC_LeagueChooseViewController alloc] init];
    viewController.isJCLQView = 2;
	viewController.navigationItem.title = @"返回";
    viewController.BJDC_parentController = self;
    int  count = [m_league_selected_tableCell_DataArrayTag count];
    for (int i = 0; i < count; i++)
    {
        [viewController appendSelectedLeagueTag:[m_league_selected_tableCell_DataArrayTag objectAtIndex:i]];
    }
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


- (void)scoreButtonClick:(id)sender
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    BJDC_instantScoreViewController* viewController = [[BJDC_instantScoreViewController alloc] init];
    viewController.navigationItem.title = @"即时比分";
    viewController.userDefaultsTag = @"instantScore_BJDC";
    viewController.currentLotNo = m_currentLotNo;
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)InstructionButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    PlayIntroduceViewController* viewController = [[PlayIntroduceViewController alloc] init];
    viewController.lotNo = kLotNoBJDC;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


//判断可不可以设胆
- (BOOL) judgeSetupIsOk
{
    int danCount = 0;
    for (int index = 0; index < m_headerCount; index++) {
        JCLQ_tableViewCell_DataArray* header =   (JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:index];
        for (int spindex = 0; spindex < [header baseCount]; spindex++)
        {
            JCLQ_tableViewCell_DataBase* base = [[header tableHeaderArray] objectAtIndex:spindex];
            if ([base JC_DanIsSelect]) {
                danCount++;
            }
        }
    }
    
    if (danCount + 2 > m_numGameCount) {
        
        NSString* message = @"";
        if (danCount <= 0 || m_numGameCount - 2 <= 0) {
            message = [message stringByAppendingString:@"不符合设胆条件"];
        }
        else
            message = [message stringByAppendingFormat:@"胆码不能超过%d个",m_numGameCount - 2];
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    if (danCount > 7) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多可以选择七场比赛进行设胆" withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    return TRUE;
    
}

-(BOOL) gameIsSelect:(NSIndexPath*) indexPath
{
    
    JCLQ_tableViewCell_DataBase* tableCell = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[indexPath section]] tableHeaderArray] objectAtIndex:[indexPath row]];
    
    int goalArrayCount = [[tableCell sfc_selectTag] count];
    if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] || goalArrayCount > 0 ||[tableCell BD_SD_ButtonIsSelect] || [tableCell BD_SS_ButtonIsSelect] || [tableCell BD_XD_ButtonIsSelect] || [tableCell BD_XS_ButtonIsSelect])
    {
        return TRUE;
    }
    
    
    return FALSE;
}


//判断设胆 是否符合条件
-(BOOL) judegmentDan
{
    /*
     所选比赛 至少有一场不sedan
     */
    int danCount = 0;
    for (int index = 0; index < m_headerCount; index++) {
        JCLQ_tableViewCell_DataArray* header =   (JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:index];
        for (int spindex = 0; spindex < [header baseCount]; spindex++)
        {
            JCLQ_tableViewCell_DataBase* base = [[header tableHeaderArray] objectAtIndex:spindex];
            if ([base JC_DanIsSelect]) {
                danCount++;
            }
        }
    }
    if (danCount + 2 > m_numGameCount) {
        
        NSString* message = @"";
        if (danCount <= 0 || m_numGameCount - 2 <= 0) {
            message = [message stringByAppendingString:@"不符合设胆条件"];
        }
        else
            message = [message stringByAppendingFormat:@"胆码不能超过%d个",m_numGameCount - 2];
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    return TRUE;
}


//用于设置胆码时的判断
-(BOOL) judegmentDan_clickEvent
{
    /*
     所选比赛 至少有一场不sedan
     */
    int danCount = 0;
    for (int index = 0; index < m_headerCount; index++) {
        JCLQ_tableViewCell_DataArray* header =   (JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:index];
        for (int spindex = 0; spindex < [header baseCount]; spindex++)
        {
            JCLQ_tableViewCell_DataBase* base = [[header tableHeaderArray] objectAtIndex:spindex];
            if ([base JC_DanIsSelect]) {
                danCount++;
            }
        }
    }
    
    if (m_playTypeTag != IBJDCPlayType_RQ_SPF &&m_playTypeTag != IBJDCPlayType_Score && danCount >= 5) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多只可以选择5场比赛进行设胆" withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    
    if (m_playTypeTag == IBJDCPlayType_Score && danCount >= 2) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多只可以选择2场比赛进行设胆" withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    
    if (danCount + 2 >= m_numGameCount) {
        
        NSString* message = @"";
        if (danCount <= 0 || m_numGameCount - 2 <= 0)  {
            message = [message stringByAppendingString:@"不符合设胆条件"];
        }
        else
            message = [message stringByAppendingFormat:@"胆码不能超过%d个",m_numGameCount - 2];
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    return TRUE;
}

@end
