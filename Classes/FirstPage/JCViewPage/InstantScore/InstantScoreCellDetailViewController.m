//
//  InstantScoreCellDetailViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InstantScoreCellDetailViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface InstantScoreCellDetailViewController (internal)
- (void)setMainView;

- (void)getInstantScoreDetailOK:(NSNotification *)notification;
@end

@implementation InstantScoreCellDetailViewController
@synthesize event = m_event;
@synthesize scollView = m_scollView;
@synthesize lotType = m_lotType;
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
    m_scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, 320, [UIScreen mainScreen].bounds.size.height - 80 - 64 - 60)];
    self.scollView.scrollEnabled = YES;
    self.scollView.delegate = self;
    self.scollView.backgroundColor = [UIColor whiteColor];
    self.scollView.contentSize = CGSizeMake(320, 350);
    [self.view addSubview:self.scollView];
    
    if (m_lotType == 0) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [mDict setObject:@"jingCai" forKey:@"command"];
        [mDict setObject:@"immediateScoreDetail" forKey:@"requestType"];
        [mDict setObject:m_event forKey:@"event"];
        [[RuYiCaiNetworkManager sharedManager] getInstantScoreDetail:mDict];
    }
    else if (m_lotType == 1)
    {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [mDict setObject:@"beiDan" forKey:@"command"];
        [mDict setObject:@"immediateScoreDetail" forKey:@"requestType"];
        [mDict setObject:m_event forKey:@"event"];
        [[RuYiCaiNetworkManager sharedManager] getInstantScoreDetail:mDict];
    }
    
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
    
    //足球 主队在前
    //联赛
    UILabel *sclassName = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, 20)];
    sclassName.textAlignment = UITextAlignmentLeft;
    sclassName.text = KISDictionaryNullValue(parserDict,@"sclassName");
    
    [sclassName setTextColor:[UIColor grayColor]];
    sclassName.backgroundColor = [UIColor clearColor];
    sclassName.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:sclassName];
    [sclassName release];
    //主队
    UILabel *homeTeam = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 120, 20)];
    homeTeam.textAlignment = UITextAlignmentCenter;
    homeTeam.text = KISDictionaryNullValue(parserDict,@"homeTeam");
    [homeTeam setTextColor:[UIColor blackColor]];
    homeTeam.backgroundColor = [UIColor clearColor];
    homeTeam.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:homeTeam];
    [homeTeam release];
    //状态
    UILabel *stateMemo = [[UILabel alloc] initWithFrame:CGRectMake(130, 25, 60, 20)];
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
        stateMemo.textColor = [UIColor redColor];
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
    
    //客队
    UILabel *guestTeam = [[UILabel alloc] initWithFrame:CGRectMake(190, 30, 120, 20)];
    guestTeam.textAlignment = UITextAlignmentCenter;
    guestTeam.text = KISDictionaryNullValue(parserDict,@"guestTeam");
    [guestTeam setTextColor:[UIColor blackColor]];
    guestTeam.backgroundColor = [UIColor clearColor];
    guestTeam.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:guestTeam];
    [guestTeam release];
    
    //uiview
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
    view.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:180.0/255.0 blue:0.0/255.0 alpha:1.0];
    
    // 主队比分
    UILabel *homeScore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
    homeScore.textAlignment = UITextAlignmentCenter;
    homeScore.text = KISDictionaryNullValue(parserDict,@"homeScore");
    [homeScore setTextColor:[UIColor whiteColor]];
    homeScore.backgroundColor = [UIColor clearColor];
    homeScore.font = [UIFont systemFontOfSize:12];
    [view addSubview:homeScore];
    [homeScore release];
    
    //时间
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 60, 20)];
    time.textAlignment = UITextAlignmentCenter;
    time.text = @"时间";
    [time setTextColor:[UIColor whiteColor]];
    time.backgroundColor = [UIColor clearColor];
    time.font = [UIFont systemFontOfSize:12];
    [view addSubview:time];
    [time release];
    // 客队比分
    UILabel *guestScore = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 130, 20)];
    guestScore.textAlignment = UITextAlignmentCenter;
    guestScore.text = KISDictionaryNullValue(parserDict,@"guestScore");
    [guestScore setTextColor:[UIColor whiteColor]];
    guestScore.backgroundColor = [UIColor clearColor];
    guestScore.font = [UIFont systemFontOfSize:12];
    [view addSubview:guestScore];
    [guestScore release];
    
    [self.view addSubview:view];
    [view release];
    
    NSArray* detailResultsArray = (NSArray*)[parserDict objectForKey:@"detailResults"];
    BOOL isWhite = TRUE;
    for (int i = 0; i < [detailResultsArray count]; i++) {
        UIView* scollCellView = [[UIView alloc] initWithFrame:CGRectMake(0,i * 20, 320, 20)];
        UIImageView *backimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        if (isWhite) {
            backimage.image = RYCImageNamed(@"jcinstantscore_detailviewbg_white.png");
        }
        else
            backimage.image = RYCImageNamed(@"jcinstantscore_detailviewbg_gray.png");
        isWhite = isWhite ? FALSE : TRUE;
        [scollCellView addSubview:backimage];
        [backimage release];
        //1、主队 0、客队
        BOOL isHomeTeam = ([KISNullValue(detailResultsArray, i, @"teamID") isEqual:@"1"]  ? TRUE : FALSE);
        
        CGRect rectIco;
        CGRect rectThing;
        if (isHomeTeam) {
            rectIco = CGRectMake(5, 5, 10, 10);
            rectThing = CGRectMake(20, 0, 110, 20);
        }
        else
        {
            rectIco = CGRectMake(305, 5, 10, 10);
            rectThing = CGRectMake(190, 0, 110, 20);
        }
        /*//Kind：事件类型
         1、入球 2、红牌  3、黄牌 4、换进 5换出 7、点球  8、乌龙  9、两黄变红 11、换人
         */
        //图标
        UIImageView *ico = [[UIImageView alloc] initWithFrame:rectIco];
        UIImage* imageIco = RYCImageNamed(@"");
        NSString* kind = KISNullValue(detailResultsArray, i, @"kind");
        
        if ([kind isEqual:@"1"]) {
            imageIco = RYCImageNamed(@"jcinstantscore_ruqiu.png");
        }
        else if([kind isEqual:@"2"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_red.png");
        }
        else if([kind isEqual:@"3"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_yellow.png");
        }
        else if([kind isEqual:@"4"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_huanru.png");
        }
        else if([kind isEqual:@"5"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_huanchu.png");
        }
        else if([kind isEqual:@"6"])//????入球无效
        {
            imageIco = RYCImageNamed(@"");
        }
        else if([kind isEqual:@"7"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_dianqiu.png");
        }
        else if([kind isEqual:@"8"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_wulong.png");
        }
        else if([kind isEqual:@"9"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_2yellowtored.png");
        }
        else if([kind isEqual:@"11"])
        {
            imageIco = RYCImageNamed(@"jcinstantscore_huanren.png");
        }
        ico.image = imageIco;
        [scollCellView addSubview:ico];
        [ico release];
        //事件
        UILabel *playerName = [[UILabel alloc] initWithFrame:rectThing];
        playerName.textAlignment = UITextAlignmentCenter;
        playerName.text = KISNullValue(detailResultsArray, i, @"playerName");
        [playerName setTextColor:[UIColor blackColor]];
        playerName.backgroundColor = [UIColor clearColor];
        playerName.font = [UIFont systemFontOfSize:12];
        [scollCellView addSubview:playerName];
        [playerName release];
        
        //时间
        UILabel *happenTime = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 60, 20)];
        happenTime.textAlignment = UITextAlignmentCenter;
        NSString* time = KISNullValue(detailResultsArray, i,@"happenTime");
        time = [time stringByAppendingString:@"'"];
        happenTime.text = time;
        [happenTime setTextColor:[UIColor whiteColor]];
        happenTime.backgroundColor = [UIColor clearColor];
        happenTime.font = [UIFont systemFontOfSize:12];
        [scollCellView addSubview:happenTime];
        [happenTime release];
        
        [m_scollView addSubview:scollCellView];
        [scollCellView release];
        
    }
    if ([detailResultsArray count] > 15) {
        self.scollView.contentSize = CGSizeMake(320, [detailResultsArray count] * 20 + 50);
    }
    
    UIImageView *InfoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60 - 64, 320, 60)];
    InfoImage.image = RYCImageNamed(@"jcinstantscore_bottom_instruction.png");
    [self.view addSubview:InfoImage];
    [InfoImage release];
}

- (void)getInstantScoreDetailOK:(NSNotification *)notification
{
    [self setMainView];
    
}

@end
