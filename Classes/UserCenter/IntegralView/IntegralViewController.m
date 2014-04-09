//
//  IntegralViewController.m
//  RuYiCai
//
//  Created by  on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "IntegralViewController.h"
#import "RYCImageNamed.h"
#import "IntegralCellView.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "PullUpRefreshView.h"
#import "Custom_tabbar.h"
#import "IntegralRuleViewController.h"
#import "AdaptationUtils.h"

#define REFRESH_HEADER_HEIGHT 52.0f
#define ScrollViewMaxY        (208)

@interface IntegralViewController (internal)

- (void)seeIntegralExplain;
- (void)mingXiButtonClick;
- (void)duiHuanButtonClick;
- (void)IntegralInfoOK:(NSNotification *)notification;
- (void)duiHuanClick;
- (void)getUserCenterInfoOK:(NSNotification *)notification;
- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;
- (void)setRefreshViewFrame;

- (void)transMoneyNeedsScoresOk:(NSNotification *)notification;
@end

@implementation IntegralViewController

@synthesize dataArray = m_dataArray;

- (void)dealloc
{
    [m_integralLabel release];
    [m_tableView release], m_tableView = nil;
    [m_dataArray release], m_dataArray = nil;
    [m_imageBottom release];
    [m_mingXiButton release];
    [m_duiHuanButton release];

    [m_duiHuanbg release];
    [m_duiHuanBottombg release];
    [duiHuanButton release];
    [m_transMoneyLabelDescription release];
    [refreshView release];
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"IntegralInfoOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUserCenterInfoOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"transMoneyNeedsScoresOk" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
        
    isMingXi = YES;
    
    m_dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 102, 300, [UIScreen mainScreen].bounds.size.height - 188)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.rowHeight = 50;
    [self.view addSubview:m_tableView];

    m_curPageIndex = 0;
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 188, 320, REFRESH_HEADER_HEIGHT)];
    [m_tableView addSubview:refreshView];
    refreshView.myScrollView = m_tableView;
    [refreshView stopLoading:NO];
    m_transMoneyNeedsScores = 1000;
    m_transMoneyNeedsScoresDescription = @"";
    [self setMainView];
    [self setUpDuihuanView];
    
    [[RuYiCaiNetworkManager sharedManager] getIntegralInfo:@"0"];
    
    [[RuYiCaiNetworkManager sharedManager] integralTransMoneyNeedsScores];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
            
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IntegralInfoOK:) name:@"IntegralInfoOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserCenterInfoOK:) name:@"getUserCenterInfoOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transMoneyNeedsScoresOk:) name:@"transMoneyNeedsScoresOk" object:nil];
}

- (void)setRefreshViewFrame
{
    if( m_tableView.contentSize.height > m_tableView.frame.size.height)
    {
        refreshView.frame = CGRectMake(0, m_tableView.contentSize.height , 320, REFRESH_HEADER_HEIGHT);
    }
    else
    {
        refreshView.frame = CGRectMake(0, m_tableView.frame.size.height , 320, REFRESH_HEADER_HEIGHT);
    }
}

- (void)setMainView
{
    UIImageView *imageOne = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 12)];
    imageOne.image = RYCImageNamed(@"croner_top.png");
    [self.view addSubview:imageOne];
    [imageOne release];
    
    UIImageView *imageTwo = [[UIImageView alloc] initWithFrame:CGRectMake(9, 22, 302, 18)];
    imageTwo.image = RYCImageNamed(@"croner_middle.png");
    [self.view addSubview:imageTwo];
    [imageTwo release];
    
    UIImageView *imageThere = [[UIImageView alloc] initWithFrame:CGRectMake(9, 40, 302, 12)];
    imageThere.image = RYCImageNamed(@"croner_bottom.png");
    [self.view addSubview:imageThere];
    [imageThere release];
    
    UILabel *anLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 100, 18)];
    anLabel.textAlignment = UITextAlignmentLeft;
    anLabel.text = @"当前积分：";
    [anLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    anLabel.backgroundColor = [UIColor clearColor];
    anLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:anLabel];
    [anLabel release];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].userCenterInfo];
    [jsonParser release];
    
    m_integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 90, 42)];
    m_integralLabel.textAlignment = UITextAlignmentLeft;
    m_integralLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    m_integralLabel.numberOfLines = 2;
    if([[parserDict objectForKey:@"score"] isEqualToString:@""])
    {
        m_integralLabel.text = @"0";
    }
    else
    {
        m_integralLabel.text = [NSString stringWithFormat:@"%@", [parserDict objectForKey:@"score"]];
    }
    [m_integralLabel setTextColor:[UIColor redColor]];
    m_integralLabel.backgroundColor = [UIColor clearColor];
    m_integralLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:m_integralLabel];
        
    UIButton *getButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 22, 200, 18)];
    [getButton setTitle:@"如何获取更多积分 >>" forState:UIControlStateNormal];
    [getButton setTitleColor:[UIColor colorWithRed:0 green:87.0/255.0 blue:174.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    getButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [getButton addTarget:self action:@selector(seeIntegralExplain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getButton];
    [getButton release];
    
    m_mingXiButton = [[UIButton alloc] initWithFrame:CGRectMake(9, 62, 151, 40)];
    [m_mingXiButton setTitle:@"积分明细" forState:UIControlStateNormal];
    [m_mingXiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_mingXiButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m_mingXiButton setBackgroundImage:RYCImageNamed(@"jifen_btna1.png") forState:UIControlStateNormal];
    [m_mingXiButton setBackgroundImage:RYCImageNamed(@"jifen_btna2.png") forState:UIControlStateHighlighted];
    [m_mingXiButton addTarget:self action:@selector(mingXiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_mingXiButton];
    
    m_duiHuanButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 62, 151, 40)];
    [m_duiHuanButton setTitle:@"积分兑换" forState:UIControlStateNormal];
    [m_duiHuanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_duiHuanButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [m_duiHuanButton setBackgroundImage:RYCImageNamed(@"jifen_btnb2.png") forState:UIControlStateNormal];
    [m_duiHuanButton setBackgroundImage:RYCImageNamed(@"jifen_btnb1.png") forState:UIControlStateHighlighted];
    [m_duiHuanButton addTarget:self action:@selector(duiHuanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_duiHuanButton];
    
    m_imageBottom = [[UIImageView alloc] initWithFrame:CGRectMake(9, [UIScreen mainScreen].bounds.size.height - 86, 302, 12)];
    m_imageBottom.image = RYCImageNamed(@"croner_bottom.png");
    [self.view addSubview:m_imageBottom];
}

- (void)setUpDuihuanView
{
    m_duiHuanbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 102, 302, 150)];
    m_duiHuanbg.image = RYCImageNamed(@"croner_middle.png");
    [self.view addSubview:m_duiHuanbg];
    
    UILabel *anLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 250, 30)];
    anLabel.textAlignment = UITextAlignmentLeft;
    anLabel.text = @"使用                      积分";
    [anLabel setTextColor:[UIColor blackColor]];
    anLabel.backgroundColor = [UIColor clearColor];
    anLabel.font = [UIFont systemFontOfSize:15];
    [m_duiHuanbg addSubview:anLabel];
    [anLabel release];
    
    m_integralNum = [[UITextField alloc] initWithFrame:CGRectMake(55, 122, 80, 30)];
    m_integralNum.borderStyle = UITextBorderStyleRoundedRect;
    m_integralNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_integralNum.placeholder = @"积分数";
    m_integralNum.delegate = self;
    m_integralNum.keyboardType = UIKeyboardTypeNumberPad;
    m_integralNum.font = [UIFont systemFontOfSize:15];
    [m_integralNum setTextColor:[UIColor redColor]];
    [self.view addSubview:m_integralNum];

    duiHuanButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 122, 80, 30)];
    [duiHuanButton setTitle:@"兑换" forState:UIControlStateNormal];
    [duiHuanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    duiHuanButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [duiHuanButton setBackgroundImage:RYCImageNamed(@"red_btn1.png") forState:UIControlStateNormal];
    [duiHuanButton setBackgroundImage:RYCImageNamed(@"red_btn2.png") forState:UIControlStateHighlighted];
    [duiHuanButton addTarget:self action:@selector(duiHuanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:duiHuanButton];
    
    UILabel *anLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 30)];
    anLabel2.textAlignment = UITextAlignmentLeft;
    anLabel2.text = @"兑换                         购彩金";
    [anLabel2 setTextColor:[UIColor blackColor]];
    anLabel2.backgroundColor = [UIColor clearColor];
    anLabel2.font = [UIFont systemFontOfSize:15];
    [m_duiHuanbg addSubview:anLabel2];
    [anLabel2 release];
    
    m_getMoney = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 105, 30)];
    m_getMoney.text = @"0元";
    m_getMoney.textAlignment = UITextAlignmentCenter;
    [m_getMoney setTextColor:[UIColor redColor]];
    m_getMoney.backgroundColor = [UIColor clearColor];
    m_getMoney.font = [UIFont systemFontOfSize:15];
    [m_duiHuanbg addSubview:m_getMoney];

    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 302, 2)];
    lineView.image = RYCImageNamed(@"croner_line.png");
    [m_duiHuanbg addSubview:lineView];
    [lineView release];
    
    m_transMoneyLabelDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 282, 70)];
    m_transMoneyLabelDescription.textAlignment = UITextAlignmentLeft;
    m_transMoneyLabelDescription.text = m_transMoneyNeedsScoresDescription;
    /*[NSString stringWithFormat:@"注：%d个积分可兑换1元购彩金（请输入%d的倍数），购彩金将存入您的账户。" ,m_transMoneyNeedsScores,m_transMoneyNeedsScores];
     */
    m_transMoneyLabelDescription.lineBreakMode = UILineBreakModeWordWrap;
    m_transMoneyLabelDescription.numberOfLines = 3;
    [m_transMoneyLabelDescription setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    m_transMoneyLabelDescription.backgroundColor = [UIColor clearColor];
    m_transMoneyLabelDescription.font = [UIFont systemFontOfSize:12];
    [m_duiHuanbg addSubview:m_transMoneyLabelDescription];
    
    m_duiHuanBottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 252, 302, 12)];
    m_duiHuanBottombg.image = RYCImageNamed(@"croner_bottom.png");
    [self.view addSubview:m_duiHuanBottombg];
    
    duiHuanButton.hidden = YES;
    m_duiHuanBottombg.hidden = YES;
    m_integralNum.hidden = YES;
    m_duiHuanbg.hidden = YES;
}

- (void)duiHuanClick
{
    [m_integralNum resignFirstResponder];
    for (int i = 0; i < m_integralNum.text.length; i++)
    {
        UniChar chr = [m_integralNum.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"积分数格式不规范" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"积分数须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    if([m_integralNum.text intValue] == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入积分值！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if([m_integralNum.text doubleValue] > [m_integralLabel.text doubleValue])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"积分不足！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    else if([m_integralNum.text intValue] % m_transMoneyNeedsScores != 0 || [m_integralNum.text floatValue] - [m_integralNum.text intValue] != 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"请输入积分值为%d的倍数！" , m_transMoneyNeedsScores] withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
//    [MobClick event:@"userPage_integral_exchange"];
    [[RuYiCaiNetworkManager sharedManager] transIntegral:[NSString stringWithFormat:@"%d", [m_integralNum.text intValue]]];
}

- (void)IntegralInfoOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    m_totalPageCount = [[parserDict objectForKey:@"totalPage"] intValue];
    
    [self.dataArray addObjectsFromArray:[parserDict objectForKey:@"result"]];
    
    m_curPageIndex++;
    [m_tableView reloadData];
    
    if(m_curPageIndex == m_totalPageCount)
    {
        [refreshView stopLoading:YES];
    }
    else
    {
        [refreshView stopLoading:NO];
    }
    [self setRefreshViewFrame];
    
}

- (void)getUserCenterInfoOK:(NSNotification *)notification//积分兑换成功
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].userCenterInfo];
    [jsonParser release];

    m_integralLabel.text = [NSString stringWithFormat:@"%@", [parserDict objectForKey:@"score"]];
    
    [self.dataArray removeAllObjects];//兑换成功，刷新积分细节页面
    m_curPageIndex = 0;
    refreshView.hidden = NO;
    
    [[RuYiCaiNetworkManager sharedManager] getIntegralInfo:@"0"];
}

- (void)mingXiButtonClick
{
    if(!isMingXi)
    {
        isMingXi = !isMingXi;
        [m_mingXiButton setBackgroundImage:RYCImageNamed(@"jifen_btna1.png") forState:UIControlStateNormal];
        [m_mingXiButton setBackgroundImage:RYCImageNamed(@"jifen_btna2.png") forState:UIControlStateHighlighted];
        [m_duiHuanButton setBackgroundImage:RYCImageNamed(@"jifen_btnb2.png") forState:UIControlStateNormal];
        [m_duiHuanButton setBackgroundImage:RYCImageNamed(@"jifen_btnb1.png") forState:UIControlStateHighlighted];
        
        [m_integralNum resignFirstResponder];
        m_imageBottom.hidden = NO;
        m_tableView.hidden = NO;
        m_duiHuanbg.hidden = YES;
        m_integralNum.hidden = YES;
        m_duiHuanBottombg.hidden = YES;
        duiHuanButton.hidden = YES;
    }
}

- (void)duiHuanButtonClick
{
    if(isMingXi)
    {
        isMingXi = !isMingXi;
        [m_mingXiButton setBackgroundImage:RYCImageNamed(@"jifen_btna2.png") forState:UIControlStateNormal];
        [m_mingXiButton setBackgroundImage:RYCImageNamed(@"jifen_btna1.png") forState:UIControlStateHighlighted];
        [m_duiHuanButton setBackgroundImage:RYCImageNamed(@"jifen_btnb1.png") forState:UIControlStateNormal];
        [m_duiHuanButton setBackgroundImage:RYCImageNamed(@"jifen_btnb2.png") forState:UIControlStateHighlighted];
        
        m_integralNum.text = nil;
        m_getMoney.text = @"0元";
        
        m_imageBottom.hidden = YES;
        m_tableView.hidden = YES;
        m_duiHuanbg.hidden = NO;
        m_integralNum.hidden = NO;
        m_duiHuanBottombg.hidden = NO;
        duiHuanButton.hidden = NO;
    }
}

- (void)seeIntegralExplain
{  
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"integral" ofType:@"txt"];
//    NSData* proData = [NSData dataWithContentsOfFile:path];
//    NSString* proContent = [[NSString alloc] initWithData:proData encoding:NSUTF8StringEncoding];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    
    IntegralRuleViewController* viewController = [[IntegralRuleViewController alloc] init];
    viewController.title = @"积分规则";
    [self.navigationController pushViewController:viewController animated:YES];
    
    NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:@"information" forKey:@"command"];
    [tempDic setObject:@"scoreRule" forKey:@"newsType"];
    viewController.requestDic = tempDic;
    [viewController requestDate];
    [viewController release];

}


#pragma mark table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myIdentifier = @"MyIdentifier";
    IntegralCellView *cell = (IntegralCellView*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[IntegralCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.title = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"scoreSource"];
    cell.time = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"createTime"];
    cell.score = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"score"];
    cell.blsign = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"blsign"];
    //NSLog(@"%@ %@ %@", cell.title, cell.time, cell.score);
    [cell refreshView];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark textField and touch delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i = 0; i < m_integralNum.text.length; i++)
    {
        UniChar chr = [m_integralNum.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            m_getMoney.text = @"0元";
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            m_getMoney.text = @"0元";
            return;
        }
    }
    if(m_integralNum == textField && ([m_integralNum.text floatValue] - [m_integralNum.text intValue] == 0) && [m_integralNum.text intValue] % m_transMoneyNeedsScores == 0)
    {
        m_getMoney.text = [NSString stringWithFormat:@"%d元", [m_integralNum.text intValue]/m_transMoneyNeedsScores];
    }
    else
    {
         m_getMoney.text = @"0元";
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_integralNum resignFirstResponder];
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView viewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    NSLog(@"%f", scrollView.contentOffset.y);
    if(m_curPageIndex == 0)
    {
        refreshView.viewMaxY = 0;
    }
    else
    {
        refreshView.viewMaxY = m_tableView.contentSize.height - m_tableView.frame.size.height;
    }
    [refreshView viewdidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView didEndDragging:scrollView];
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(m_curPageIndex <= m_totalPageCount)
    {
        [[RuYiCaiNetworkManager sharedManager] getIntegralInfo:[NSString stringWithFormat:@"%d", m_curPageIndex]];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

- (void)transMoneyNeedsScoresOk:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    m_transMoneyNeedsScores = [KISDictionaryNullValue(parserDict, @"needScores") intValue];
    m_transMoneyNeedsScoresDescription = KISDictionaryNullValue(parserDict, @"description");

    if (m_transMoneyNeedsScoresDescription != NULL)
    {
        m_transMoneyLabelDescription.text = m_transMoneyNeedsScoresDescription;
    }
}
@end
