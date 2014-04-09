//
//  InstantScoreCellDetail_JCLQViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-12-13.
//
//

#import "InstantScoreCellDetail_JCLQViewController.h"
 
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface InstantScoreCellDetail_JCLQViewController (internal)
- (void)setMainView;

- (void)getInstantScoreDetailOK:(NSNotification *)notification;
@end

@implementation InstantScoreCellDetail_JCLQViewController
@synthesize event = m_event;
@synthesize scollView = m_scollView;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInstantScoreDetailOK" object:nil];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInstantScoreDetailOK:) name:@"getInstantScoreDetailOK" object:nil];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    m_scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 110, 320, [UIScreen mainScreen].bounds.size.height - 101 - 64 - 10)];
    self.scollView.scrollEnabled = YES;
    self.scollView.delegate = self;
    self.scollView.backgroundColor = [UIColor whiteColor];
    self.scollView.contentSize = CGSizeMake(320, 350);
    [self.view addSubview:self.scollView];
    
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [mDict setObject:@"jingCai" forKey:@"command"];
    [mDict setObject:@"immediateScoreDetailJcl" forKey:@"requestType"];
    [mDict setObject:m_event forKey:@"event"];
    [[RuYiCaiNetworkManager sharedManager] getInstantScoreDetail:mDict];
    
//    [[RuYiCaiNetworkManager sharedManager] getInstantScoreDetail:m_event REQUESTTYPE:@"immediateScoreDetailJcl"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setMainView
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
 
    UIImageView* topViewImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 101)] autorelease];
    [topViewImage setImage:[UIImage imageNamed:@"instantscore_jclq_topview.png"]];
    [self.view addSubview:topViewImage];
 
    //联赛
    UILabel *sclassName = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, 20)];
    sclassName.textAlignment = UITextAlignmentLeft;
    sclassName.text = KISDictionaryNullValue(parserDict,@"sclassName");
    
    [sclassName setTextColor:[UIColor grayColor]];
    sclassName.backgroundColor = [UIColor clearColor];
    sclassName.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:sclassName];
    [sclassName release];
    //篮球 主队在后
    //客队
    UILabel *guestTeam = [[UILabel alloc] initWithFrame:CGRectMake(190, 30, 120, 35)];
    guestTeam.textAlignment = UITextAlignmentCenter;
    guestTeam.lineBreakMode = UILineBreakModeWordWrap;
    guestTeam.numberOfLines = 2;
    guestTeam.text = KISDictionaryNullValue(parserDict,@"guestTeam");
    [guestTeam setTextColor:[UIColor blackColor]];
    guestTeam.backgroundColor = [UIColor clearColor];
    guestTeam.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:guestTeam];
    [guestTeam release];
    
    UILabel *guestTeamScore = [[UILabel alloc] initWithFrame:CGRectMake(205, 60, 100, 35)];
    guestTeamScore.textAlignment = UITextAlignmentCenter;
    guestTeamScore.text = KISDictionaryNullValue(parserDict,@"guestScore");
//    guestTeamScore.text = @"110";
    [guestTeamScore setTextColor:[UIColor colorWithRed:204/255.0 green:0 blue:0 alpha:1.0]];
    guestTeamScore.backgroundColor = [UIColor clearColor];
    guestTeamScore.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:guestTeamScore];
    [guestTeamScore release];
    
    //状态
    UILabel *stateMemo = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, 60, 20)];
    stateMemo.textAlignment = UITextAlignmentCenter;
    stateMemo.text = KISDictionaryNullValue(parserDict,@"stateMemo");
    if ([KISDictionaryNullValue(parserDict,@"stateMemo") isEqualToString:@"未开赛"]) {
        stateMemo.textColor = [UIColor grayColor];
    }
    else if([KISDictionaryNullValue(parserDict,@"stateMemo") isEqualToString:@"已完场"])
    {
        stateMemo.textColor = [UIColor redColor];
    }
    else if([KISDictionaryNullValue(parserDict,@"stateMemo") isEqualToString:@"进行中"])
    {
        stateMemo.textColor = [UIColor greenColor];
    }
    stateMemo.backgroundColor = [UIColor clearColor];
    stateMemo.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:stateMemo];
    [stateMemo release];
    
    //时间
    UILabel *matchTime = [[UILabel alloc] initWithFrame:CGRectMake(200, 5, 120, 20)];
    matchTime.textAlignment = UITextAlignmentLeft;
    NSString* kaisai = @"";
    kaisai = [kaisai stringByAppendingFormat:@"开赛：%@",KISDictionaryNullValue(parserDict,@"matchTime")];
    matchTime.text = kaisai;
    [matchTime setTextColor:[UIColor grayColor]];
    matchTime.backgroundColor = [UIColor clearColor];
    matchTime.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:matchTime];
    [matchTime release];
 
    //主队
    UILabel *homeTeam = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 120, 35)];
    homeTeam.textAlignment = UITextAlignmentCenter;
    homeTeam.lineBreakMode = UILineBreakModeWordWrap;
    homeTeam.numberOfLines = 2;
    homeTeam.text = KISDictionaryNullValue(parserDict,@"homeTeam");
    [homeTeam setTextColor:[UIColor blackColor]];
    homeTeam.backgroundColor = [UIColor clearColor];
    homeTeam.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:homeTeam];
    [homeTeam release];
    
    UILabel *homeTeamScore = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 120, 35)];
    homeTeamScore.textAlignment = UITextAlignmentCenter;
    homeTeamScore.text = KISDictionaryNullValue(parserDict,@"homeScore");
//    homeTeamScore.text = @"0";
    [homeTeamScore setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
    homeTeamScore.backgroundColor = [UIColor clearColor];
    homeTeamScore.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:homeTeamScore];
    [homeTeamScore release];
    
    //未开赛 隐藏表格
    if (![KISDictionaryNullValue(parserDict,@"stateMemo") isEqualToString:@"未开赛"]) {
    
        //2:上下半场;4:四节
        UIImageView* imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 303,111)];
        if ([@"2" isEqualToString:KISDictionaryHaveKey(parserDict, @"sclassType")]) {
            [imageBg setImage:[UIImage imageNamed:@"instantscore_jclq_half.png"]];
        }
        else
        {
            [imageBg setImage:[UIImage imageNamed:@"instantscore_jclq_four.png"]];
        }
        [self.scollView addSubview:imageBg];
        [imageBg release];
        //主队
        UILabel *homeTeam_table = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 140, 40)];
        homeTeam_table.textAlignment = UITextAlignmentCenter;
        homeTeam_table.lineBreakMode = UILineBreakModeWordWrap;
        homeTeam_table.numberOfLines = 2;
        homeTeam_table.text = KISDictionaryNullValue(parserDict,@"homeTeam");
        [homeTeam_table setTextColor:[UIColor blackColor]];
        homeTeam_table.backgroundColor = [UIColor clearColor];
        homeTeam_table.font = [UIFont systemFontOfSize:15];
        [self.scollView addSubview:homeTeam_table];
        [homeTeam_table release];
        
        //客队
        UILabel *guestTeam_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 + 40, 140, 40)];
        guestTeam_lable.lineBreakMode = UILineBreakModeWordWrap;
        guestTeam_lable.numberOfLines = 2;
        guestTeam_lable.textAlignment = UITextAlignmentCenter;
        guestTeam_lable.text = KISDictionaryNullValue(parserDict,@"guestTeam");
        [guestTeam_lable setTextColor:[UIColor blackColor]];
        guestTeam_lable.backgroundColor = [UIColor clearColor];
        guestTeam_lable.font = [UIFont systemFontOfSize:15];
        [self.scollView addSubview:guestTeam_lable];
        [guestTeam_lable release];
        
        if ([@"2" isEqualToString:KISDictionaryHaveKey(parserDict, @"sclassType")]) {
            UILabel *half_hometable = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 70, 40)];
            half_hometable.textAlignment = UITextAlignmentCenter;
            half_hometable.text = KISDictionaryNullValue(parserDict,@"homeOne");
            [half_hometable setTextColor:[UIColor blackColor]];
            half_hometable.backgroundColor = [UIColor clearColor];
            half_hometable.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:half_hometable];
            [half_hometable release];
            
            UILabel *down_hometable = [[UILabel alloc] initWithFrame:CGRectMake(160 + 75, 30, 70, 40)];
            down_hometable.textAlignment = UITextAlignmentCenter;
            down_hometable.text = KISDictionaryNullValue(parserDict,@"homeThree");
            [down_hometable setTextColor:[UIColor blackColor]];
            down_hometable.backgroundColor = [UIColor clearColor];
            down_hometable.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:down_hometable];
            [down_hometable release];
            
            
            UILabel *half_guesttable = [[UILabel alloc] initWithFrame:CGRectMake(160 + 75, 30 + 40, 70, 40)];
            half_guesttable.textAlignment = UITextAlignmentCenter;
            half_guesttable.text = KISDictionaryNullValue(parserDict,@"guestOne");
            [half_guesttable setTextColor:[UIColor blackColor]];
            half_guesttable.backgroundColor = [UIColor clearColor];
            half_guesttable.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:half_guesttable];
            [half_guesttable release];
            
            UILabel *down_guesttable = [[UILabel alloc] initWithFrame:CGRectMake(160 + 75, 30 + 40, 70, 40)];
            down_guesttable.textAlignment = UITextAlignmentCenter;
            down_guesttable.text = KISDictionaryNullValue(parserDict,@"guestThree");
            [down_guesttable setTextColor:[UIColor blackColor]];
            down_guesttable.backgroundColor = [UIColor clearColor];
            down_guesttable.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:down_guesttable];
            [down_guesttable release];
        }
        else
        {
            UILabel *hometable_1 = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 35, 40)];
            hometable_1.text = KISDictionaryNullValue(parserDict,@"homeOne");
            hometable_1.textAlignment = UITextAlignmentCenter;
            [hometable_1 setTextColor:[UIColor blackColor]];
            hometable_1.backgroundColor = [UIColor clearColor];
            hometable_1.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:hometable_1];
            [hometable_1 release];
            
            UILabel *hometable_2 = [[UILabel alloc] initWithFrame:CGRectMake(165 + 37 , 30, 35, 40)];
            hometable_2.text = KISDictionaryNullValue(parserDict,@"homeTwo");
            hometable_2.textAlignment = UITextAlignmentCenter;
            [hometable_2 setTextColor:[UIColor blackColor]];
            hometable_2.backgroundColor = [UIColor clearColor];
            hometable_2.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:hometable_2];
            [hometable_2 release];
            
            UILabel *hometable_3 = [[UILabel alloc] initWithFrame:CGRectMake(165 + 37 * 2, 30, 35, 40)];
            hometable_3.text = KISDictionaryNullValue(parserDict,@"homeThree");
            hometable_3.textAlignment = UITextAlignmentCenter;
            [hometable_3 setTextColor:[UIColor blackColor]];
            hometable_3.backgroundColor = [UIColor clearColor];
            hometable_3.font = [UIFont systemFontOfSize:20];
            
            [self.scollView addSubview:hometable_3];
            [hometable_3 release];
            
            UILabel *hometable_4 = [[UILabel alloc] initWithFrame:CGRectMake(165 + 37 * 3, 30, 35, 40)];
            hometable_4.text = KISDictionaryNullValue(parserDict,@"homeFour");
            hometable_4.textAlignment = UITextAlignmentCenter;
            [hometable_4 setTextColor:[UIColor blackColor]];
            hometable_4.backgroundColor = [UIColor clearColor];
            hometable_4.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:hometable_4];
            [hometable_4 release];
            
            UILabel *guesttable_1 = [[UILabel alloc] initWithFrame:CGRectMake(160, 30 + 40, 35, 40)];
            guesttable_1.text = KISDictionaryNullValue(parserDict,@"guestOne");
            guesttable_1.textAlignment = UITextAlignmentCenter;
            [guesttable_1 setTextColor:[UIColor blackColor]];
            guesttable_1.backgroundColor = [UIColor clearColor];
            guesttable_1.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:guesttable_1];
            [guesttable_1 release];
            
            UILabel *guesttable_2 = [[UILabel alloc] initWithFrame:CGRectMake(165 + 37, 70, 32, 40)];
            guesttable_2.text = KISDictionaryNullValue(parserDict,@"guestTwo");
            guesttable_2.textAlignment = UITextAlignmentCenter;
            [guesttable_2 setTextColor:[UIColor blackColor]];
            guesttable_2.backgroundColor = [UIColor clearColor];
            guesttable_2.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:guesttable_2];
            [guesttable_2 release];
            
            UILabel *guesttable_3 = [[UILabel alloc] initWithFrame:CGRectMake(165 + 37* 2, 70, 32, 40)];
            guesttable_3.text = KISDictionaryNullValue(parserDict,@"guestThree");
            guesttable_3.textAlignment = UITextAlignmentCenter;
            [guesttable_3 setTextColor:[UIColor blackColor]];
            guesttable_3.backgroundColor = [UIColor clearColor];
            guesttable_3.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:guesttable_3];
            [guesttable_3 release];
            
            UILabel *guesttable_4 = [[UILabel alloc] initWithFrame:CGRectMake(165 + 37 * 3, 70, 35, 40)];
            guesttable_4.text = KISDictionaryNullValue(parserDict,@"guestFour");
            guesttable_4.textAlignment = UITextAlignmentCenter;
            [guesttable_4 setTextColor:[UIColor blackColor]];
            guesttable_4.backgroundColor = [UIColor clearColor];
            guesttable_4.font = [UIFont systemFontOfSize:20];
            [self.scollView addSubview:guesttable_4];
            [guesttable_4 release];
        }
    }
}

- (void)getInstantScoreDetailOK:(NSNotification *)notification
{
    [self setMainView];
}

@end

