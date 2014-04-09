//
//  JCLQ_PickGameViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCLQ_PickGameViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "JC_TableView_ContentCell.h"
#import "JC_BetView.h"

#import "RYCNormalBetView.h"
#import "SFCViewController.h"

#import "DataAnalysisViewController.h"
#import "InstantScoreViewController.h"
#import "JC_LeagueChooseViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"

#import "JCLQ_PlayChooseViewCell.h"
#import "ConfusionViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface JCLQ_PickGameViewController (internal)
- (void)setupNavigationBar;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
//筛选
- (void)setDetailView;

- (void)InstructionButtonClick:(id)sender;
- (void)scoreButtonClick:(id)sender;
- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;


- (void)getJCLQDuiZhenOK:(NSNotification*)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;
- (NSString*)getSfcScore:(NSInteger)section Row:(NSInteger)row Tag:(NSInteger)tag;
-(BOOL) gameIsSelect:(NSIndexPath*) indexPath;
@end

@implementation JCLQ_PickGameViewController
@synthesize parserDictData = m_parserDictData;
@synthesize parserDictData_DanGuan = m_parserDictData_DanGuan;

@synthesize tableView = m_tableView;
@synthesize buttonBuy = m_buttonBuy;
@synthesize buttonReselect = m_buttonReselect;
@synthesize totalCost = m_totalCost;

@synthesize tableCell_DataArray = m_tableCell_DataArray;
@synthesize playTypeTag = m_playTypeTag;
@synthesize SFCSelectScore = m_SFCSelectScore;

@synthesize league_tableCell_DataArray = m_league_tableCell_DataArray;
@synthesize league_selected_tableCell_DataArrayTag = m_league_selected_tableCell_DataArrayTag;
#define KHeightForFooterInSection 1 //section 底部间距
#define KHeightForRowAtIndexPath 67
#define KHeightForHeaderInSection 30

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QueryJCLQDuiZhen" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];
    m_detailView.hidden = YES;
    m_playChooseView.hidden = YES;
    
    //    iamge.hidden = YES;
    //    centerButton.hidden = YES;
    if(centerButton != nil)
    {
        [centerButton removeFromSuperview];
        [centerButton release], centerButton = nil;
    }
    
    [super viewWillDisappear:animated];
}
- (void)dealloc
{
    NSTrace();
    
    [m_tableCell_DataArray release];
    [m_tableHeaderState release], m_tableHeaderState = nil;
    
    [m_tableView release], m_tableView = nil;
	[m_selectedCount release];
    [m_rightTitleBarItem release];
    
    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_totalCost release];
    [m_selectLotAlterView release];
    [m_selectScrollView release];
    [m_SFCSelectScore release], m_SFCSelectScore = nil;
    
    [m_league_tableCell_DataArray release];
    [m_league_selected_tableCell_DataArrayTag release];
    [m_arrangeSP release];
    [m_playChooseView release];
    //    [iamge release];
    [m_detailView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJCLQDuiZhenOK:) name:@"QueryJCLQDuiZhen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
    
    //玩法切换 按钮
    if(centerButton != nil)
    {
        [centerButton removeFromSuperview];
        [centerButton release], centerButton = nil;
    }
    centerButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
    [centerButton addTarget:self action: @selector(playChooseViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
    centerButton.showsTouchWhenHighlighted = TRUE;
    centerButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
    centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerButton setTitle:[self getTitleBy_playType] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:centerButton];
    
    UIImageView* iamge = [[UIImageView alloc] initWithFrame:CGRectMake(44, 32, 14, 10)];
    iamge.image = [UIImage imageNamed:@"jc_headerlist_ico.png"];
    [centerButton addSubview:iamge];
    [iamge release];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [MobClick event:@"JC_selectPage"];
    m_numGameCount = 0;
    m_headerCount = 0;
    m_playTypeTag = IJCLQPlayType_SF;//默认 胜负玩法
    [self setupNavigationBar];
    
	m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    //立即投注，重新选择
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 147 + 25) style:UITableViewStylePlain];
    //    m_tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //如果不希望响应select，那么就可以用下面的代码设置属性：
    m_tableView.allowsSelection=NO;
    [self.view addSubview:m_tableView];
    
    self.parserDictData = @"";
    self.parserDictData_DanGuan = @"";
    [self setDetailView];
    [self setPlayChooseView];
    [[RuYiCaiNetworkManager sharedManager]QueryJCLQDuiZhen:@"0" JingCaiValueType:@"1"];
}
- (void)pressTitle:(id)sender
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
	UIButton *temp = (UIButton *)sender;
	int temptag = temp.tag;
    if ([m_tableHeaderState objectAtIndex:temptag] == @"0")
    {
        [m_tableHeaderState replaceObjectAtIndex:temptag withObject:@"1"];
        m_SectionN[temptag] = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:temptag] baseCount];
        
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlistexpand.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlisthide.png"] forState:UIControlStateHighlighted];
    }
    else if([m_tableHeaderState objectAtIndex:temptag] == @"1"){
        [m_tableHeaderState replaceObjectAtIndex:temptag withObject:@"0"];
        m_SectionN[temptag] = 0;
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlisthide.png"] forState:UIControlStateNormal];
        [temp setBackgroundImage:[UIImage imageNamed:@"jc_sectionlistexpand.png"] forState:UIControlStateHighlighted];
    }
    [m_tableView reloadData];
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
    return KHeightForRowAtIndexPath;
}
//header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KHeightForHeaderInSection;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return KHeightForFooterInSection;
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
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, KHeightForHeaderInSection)];
        image.image = [UIImage imageNamed:@"jc_sectionlisthide.png"];
        [button addSubview:image];
        [image release];
    }
    else if([m_tableHeaderState objectAtIndex:section] == @"1"){
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, KHeightForHeaderInSection)];
        image.image = [UIImage imageNamed:@"jc_sectionlistexpand.png"];
        [button addSubview:image];
        [image release];
    }
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:0];//获取数组中的 第一个base数据
    
    NSString* dayForamt = [NSString stringWithFormat:@"%@  ", [base dayforamt]];
    NSString* week = [NSString stringWithFormat:@"%@  ",[base week]];
    NSString* title = [NSString stringWithFormat:@"%@%@%d场比赛可投注 (客在前)",dayForamt,week,[((JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section]) baseCount]];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"title";
}
//绘制cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupCell = @"groupCell";
	JC_TableView_ContentCell *cell = (JC_TableView_ContentCell*)[tableView dequeueReusableCellWithIdentifier:groupCell];
	if(cell == nil)
	{
		cell = [[[JC_TableView_ContentCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupCell]autorelease];
        cell.isLeftSelect = NO;
        cell.isRightSelect = NO;
        cell.isJC_Button_Dan_Select = NO;
        cell.isHidenFenXi = YES;
	}
    cell.indexPath = indexPath;
    cell.JCLQ_parentViewController = self;
    NSInteger section = indexPath.section;
    
    /*
     根据 玩法 （m_playTypeTag）来控制 cell呈现的界面
     */
    cell.playTypeTag = m_playTypeTag;
    if (m_playTypeTag == IJCLQPlayType_SFC ||
        m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
        m_playTypeTag == IJCLQPlayType_Confusion)
    {
        if (m_playTypeTag == IJCLQPlayType_Confusion) {
            
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:indexPath.row];
            if ([[base confusionButtonText] length] == 0) {
                cell.SFCButtonText = @"请选择投注选项";
            }
            else
                cell.SFCButtonText = [NSString stringWithFormat:@"%@   ",base.confusionButtonText];
            //                cell.SFCButtonText = [NSString stringWithFormat:@"%@",base.confusionButtonText];
        }
        else
        {
            NSString *buttonText = @"";
            NSMutableArray *array =
            [(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:indexPath.row] sfc_selectTag];
            int count  = [array count];
            for (int i = 0; i < count; i++)
            {
                int tag = [[array objectAtIndex:i] intValue];
                buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath.section Row:indexPath.row  Tag:tag]];
                if (i <= count - 1)
                {
                    buttonText = [buttonText stringByAppendingString:@"     "];
                }
            }
            if (count == 0) {
                cell.SFCButtonText = @"请选择投注选项";
            }
            else
                cell.SFCButtonText = buttonText;
        }
        
    }
    cell.isJCLQtableview = YES;
    JCLQ_tableViewCell_DataBase* tableCell = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:indexPath.row];
    cell.weekld = [tableCell weekld];
    cell.teamld = [tableCell teamld];
    cell.league = [tableCell league];
    cell.endTime = [tableCell endTime];
    cell.homeTeam = [tableCell homeTeam];
    cell.VisitTeam = [tableCell VisitTeam];
    cell.v0 = [tableCell v0];
    cell.v3 = [tableCell v3];
    cell.letPoint = [tableCell letPoint];
    
    cell.letVs_v0 = [tableCell letVs_v0];
    cell.letVs_v3 = [tableCell letVs_v3];
    
    cell.Big = [tableCell Big];
    cell.Small = [tableCell Small];
    cell.basePoint = [tableCell basePoint];
    
    //手动控制 用户的选择
    cell.isLeftSelect = [tableCell visitTeamIsSelect];
    
    cell.isRightSelect = [tableCell homeTeamIsSelect];
    
    if ([self gameIsSelect:indexPath]) {
        if ([tableCell JC_DanIsSelect]) {
            NSLog(@"\n[tableCell JC_DanIsSelect]:%d",indexPath.row);
        }
        [cell setIsJC_Button_Dan_Select:[tableCell JC_DanIsSelect]];
    }
    else
    {
        [cell setIsJC_Button_Dan_Select:FALSE];
    }
    [cell RefreshCellView];
    
    return cell;
}


//选中cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[m_tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        m_playChooseView = [[JCLQ_PlayChooseViewCell alloc] initWithFrame:CGRectMake(33, 0, 255, 222)];
        m_playChooseView.backgroundColor = [UIColor clearColor];
        
        m_playChooseView.parentController = self;
        m_playChooseView.SFTitle = @"过关投注";
        m_playChooseView.LetPointTitle = @"过关投注";
        m_playChooseView.SFCTitle = @"过关投注";
        m_playChooseView.BigAndSmallTitle = @"过关投注";
        
        m_playChooseView.SFTitle_DanGuan = @"单关投注";
        m_playChooseView.LetPointTitle_DanGuan = @"单关投注";
        m_playChooseView.SFCTitle_DanGuan = @"单关投注";
        m_playChooseView.BigAndSmallTitle_DanGuan = @"单关投注";
        m_playChooseView.PlayTypeTag = self.playTypeTag;
        m_playChooseView.hunheTitle = @"混合过关投注";
        [m_playChooseView RefreshCellView];
        [self.view addSubview:m_playChooseView];
    }
    m_playChooseView.hidden = YES;
}
- (void) playChooseButtonEvent
{
    m_playChooseView.hidden = NO;
    [self playChooseViewButtonClick];
    [self clearAllChoose];
    self.playTypeTag = m_playChooseView.PlayTypeTag;
    [self comeBackFromChooseView];
}

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
#pragma mark   右上角 下拉按钮
- (void)queryBetLotButtonClick:(id)sender
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoJCLQ;
    if (![[RuYiCaiNetworkManager sharedManager] hasLogin]) {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    else
    {
        [self setupQueryLotBetViewController];
    }
}

- (void)queryBetlot_loginOK:(NSNotification*)notification
{
    [self setupQueryLotBetViewController];
}

- (void)setupQueryLotBetViewController
{
    [self setHidesBottomBarWhenPushed:YES];
    QueryLotBetViewController* viewController = [[QueryLotBetViewController alloc] init];
    viewController.navigationItem.title = @"投注查询";
    [viewController setSelectLotNo:kLotNoJCLQ];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}
- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNavigationBar
{
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    UIButton* detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [detailButton addTarget:self action: @selector(detailViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_normal"] forState:UIControlStateNormal];
    [detailButton setImage:[UIImage imageNamed:@"right_top_list_button_click"] forState:UIControlStateHighlighted];
    //    detailButton.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
    detailButton.showsTouchWhenHighlighted = TRUE;
    //    [self.navigationController.navigationBar addSubview:m_detailButton];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:detailButton] autorelease];
    [detailButton release];
    
    //    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    customLab.backgroundColor = [UIColor clearColor];
    //    customLab.font = [UIFont boldSystemFontOfSize:15];
    //    [customLab setTextColor:[UIColor whiteColor]];
    //    customLab.textAlignment = UITextAlignmentRight;
    //    [customLab setText:[self getTitleBy_playType]];
    //    self.navigationItem.titleView = customLab;
    //    [customLab release];
}

- (void)setDetailView
{
    
    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(165, 0, 153, 165)];
    m_detailView.backgroundColor = [UIColor clearColor];
    
    /*
     背景
     */
    UIImageView* teamButton_imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
    teamButton_imgBg.image = RYCImageNamed(@"righttop_menu_bottom_top.png");
    [teamButton_imgBg setBackgroundColor:[UIColor clearColor]];
    [m_detailView addSubview:teamButton_imgBg];
    [teamButton_imgBg release];
    
    UIImageView* leagueButton_imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 140, 35)];
    leagueButton_imgBg.image = RYCImageNamed(@"righttop_menu_bottom.png");
    [leagueButton_imgBg setBackgroundColor:[UIColor clearColor]];
    [m_detailView addSubview:leagueButton_imgBg];
    [leagueButton_imgBg release];
    
    UIImageView* scoreButton_imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 75, 140, 35)];
    scoreButton_imgBg.image = RYCImageNamed(@"righttop_menu_bottom.png");
    [scoreButton_imgBg setBackgroundColor:[UIColor clearColor]];
    [m_detailView addSubview:scoreButton_imgBg];
    [scoreButton_imgBg release];
    
    UIImageView* intructionButton_imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 110, 140, 35)];
    intructionButton_imgBg.image = RYCImageNamed(@"righttop_menu_bottom.png");
    [intructionButton_imgBg setBackgroundColor:[UIColor clearColor]];
    [m_detailView addSubview:intructionButton_imgBg];
    [intructionButton_imgBg release];
    
    //    /*
    //     图标
    //     */
    UIButton* teamButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 130, 30)];
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
    
    UIButton* scoreButton  = [[UIButton alloc] initWithFrame:CGRectMake(5, 43, 130, 30)];
    UIImageView *score_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    score_icon.image = RYCImageNamed(@"jcnowscore_ico.png");// history_lottery
    [scoreButton addSubview:score_icon];
    [score_icon release];
    scoreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
    [scoreButton setBackgroundImage:RYCImageNamed(@"caidanbutton_bg_click.png") forState:UIControlStateHighlighted];
    [scoreButton setTitle:@"即时比分" forState:UIControlStateNormal];
    [scoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [scoreButton addTarget:self action:@selector(scoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_detailView addSubview:scoreButton];
    [scoreButton release];
    
    UIButton* intructionButton  = [[UIButton alloc] initWithFrame:CGRectMake(5, 78, 130, 30)];
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
    
    UIButton* queryBetLotButton  = [[UIButton alloc] initWithFrame:CGRectMake(5, 113, 130, 30)];
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

- (void)InstructionButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    PlayIntroduceViewController* viewController = [[PlayIntroduceViewController alloc] init];
    viewController.lotNo = kLotNoJCLQ;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)scoreButtonClick:(id)sender
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    InstantScoreViewController* viewController = [[InstantScoreViewController alloc] init];
    viewController.navigationItem.title = @"即时比分";
    viewController.type = JCLQ;
    viewController.userDefaultsTag = @"instantScore_JCLQ";
    
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)leagueButtonClick:(id)sender;
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    JC_LeagueChooseViewController* viewController = [[JC_LeagueChooseViewController alloc] init];
    viewController.isJCLQView = YES;
	viewController.navigationItem.title = @"返回";
    viewController.JCLQ_parentController = self;
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
    NSString*   event = @"";
    event = [event stringByAppendingString:@"0_"];//1 足球 0篮球
    
    event = [event stringByAppendingFormat:@"%@_" ,[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:indexPath.section] tableHeaderArray] objectAtIndex:indexPath.row] dayTime]];
    event = [event stringByAppendingFormat:@"%@_" ,[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:indexPath.section] tableHeaderArray] objectAtIndex:indexPath.row] weekld]];
    
    event = [event stringByAppendingString:[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:indexPath.section] tableHeaderArray] objectAtIndex:indexPath.row] teamld]];
    
    [viewController setEvent:event];
    [viewController setIsJCLQ:YES];
    [viewController setIsZC:NO];
    
    viewController.navigationItem.title = @"球队数据分析";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
-(void) gotoLeagueChoose
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    JC_LeagueChooseViewController* viewController = [[JC_LeagueChooseViewController alloc] init];
    viewController.isJCLQView = YES;
	viewController.navigationItem.title = @"返回";
    viewController.JCLQ_parentController = self;
    int  count = [m_league_selected_tableCell_DataArrayTag count];
    for (int i = 0; i < count; i++)
    {
        [viewController appendSelectedLeagueTag:[m_league_selected_tableCell_DataArrayTag objectAtIndex:i]];
    }
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
- (void)pressedBuyButton:(id)sender
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
    if (m_playTypeTag == IJCLQPlayType_SF_DanGuan ||
        m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan ||
        m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan)
    {
        if (m_numGameCount < 1)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一场比赛" withTitle:@"错误" buttonTitle:@"确定"];
            return;
        }
    }
    else
    {
    	if (m_numGameCount <= 1 )
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择两场比赛" withTitle:@"错误" buttonTitle:@"确定"];
            return;
        }
    }
    if (![self isDanGuan] && ![self judegmentDan]) {
        return;
    }
    [self submitLotNotification:nil];
}

- (void)pressedReselectButton:(id)sender
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
    [self clearAllChoose];
    [m_tableView reloadData];
}

- (void)submitLotNotification:(NSNotification*)notification
{
    NSTrace();
    //显示你的订单详情，并生成投注信息
    NSString* disBetCode = @"";
    
	NSString* betCode = @"";
    NSString* betCode_Dan = @"";
    //添加  赔率
    if (m_arrangeSP != nil)
    {
        [m_arrangeSP removeAllObjects];
        [m_arrangeSP release];
    }
    m_arrangeSP = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < m_headerCount; i++)
    {
        int everyHeaderBaseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < everyHeaderBaseCount; j++)
        {
            NSString*  WinSelect = @"";
            /////////////////////////betCode//////////////////////////////////
            /*
             注码格式
             日期 |周数 |场次 |注码 ^日期 |周数 |场次 |注码 ^……
             |表示字段之间的分隔符号 表示字段之间的分隔符号
             ^表示注的结束符号
             例如
             胜负玩法 20101004| 20101004|1|301|3^ 1|301|3^ 1|301|3^ 1|301|3^ 1|301|3^ 1|301|3^ 表示投注 20101004 20101004 的周 1, 场次 301, 赛事胜
             胜负玩法 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 表示投注 20101004 20101004 的周 1, 场次 301, 赛事胜 +负
             
             混合过关的注码格式:
             502@20130130|3|015|J00001|0^20130130|3|015|J00002|0923^20130130|3|018|J00002|0923243290^20130130|3|017|J00001|0^
             竞彩混合足球    J00011
             竞彩混合篮球    J00012
             */
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            if (m_playTypeTag == IJCLQPlayType_Confusion)
            {
                
                NSMutableArray *array = [base confusion_selectTag];
                int count  = [array count];
                BOOL ishave = FALSE;
                if (count > 0) {
                    int confsion_select_index = 0 ,confsion_select_count = 0;
                    while (confsion_select_index < 4) {
                        confsion_select_count += [[array objectAtIndex:confsion_select_index] count];
                        confsion_select_index++;
                    }
                    if (confsion_select_count > 0) {
                        ishave = TRUE;
                        disBetCode = [disBetCode stringByAppendingFormat:@"%@ %@ %@(客) VS %@(主) @",[base week],[base teamld],[base VisitTeam],[base homeTeam]];
                    }
                    //暂时不设置胆 2013.3.7
                    //betCode = [betCode stringByAppendingFormat:@"%@|%@|%@|",[base dayTime],[base weekld],[base teamld]];
                }
                CombineBase *gameSparray = [[[CombineBase alloc] init] autorelease];
                for (int m = 0; m < count; m++)
                {
                    NSArray* array_inner = [array objectAtIndex:m];
                    NSLog(@"array_inner:%@",array_inner);
                    if ([array_inner count] > 0)
                    {
                        if (m == 0 || m == 1) {
                            if (m == 0) {//竞彩篮球胜负
                                betCode = [betCode stringByAppendingFormat:@"%@|%@|%@|%@|",[base dayTime],[base weekld],[base teamld],kLotNoJCLQ_SF];
                                WinSelect = [WinSelect stringByAppendingString:@"胜负~"];
                            }
                            else//竞彩篮球让分胜负
                            {
                                WinSelect = [WinSelect stringByAppendingString:@"让分胜负~"];
                                betCode = [betCode stringByAppendingFormat:@"%@|%@|%@|%@|",[base dayTime],[base weekld],[base teamld],kLotNoJCLQ_RF];
                            }
                            
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                            {
                                if ([[array_inner objectAtIndex:inner_index] isEqualToString:@"0"]) {
                                    betCode = [betCode stringByAppendingString:@"3"];
                                    [[gameSparray combineBase_SP] addObject:(m == 0 ? [base v3] : [base letVs_v3])];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"主胜SP%@ ",(m == 0 ? [base v3] : [base letVs_v3])]];
                                }
                                else if([[array_inner objectAtIndex:inner_index] isEqualToString:@"1"])
                                {
                                    betCode = [betCode stringByAppendingString:@"0"];
                                    [[gameSparray combineBase_SP] addObject:(m == 0 ? [base v0] : [base letVs_v0])];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"客胜SP%@ ",(m == 0 ? [base v0] : [base letVs_v0])]];
                                }
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                        }
                        else if (m == 2)//竞彩篮球大小分
                        {
                            betCode = [betCode stringByAppendingFormat:@"%@|%@|%@|%@|",[base dayTime],[base weekld],[base teamld],kLotNoJCLQ_DXF];
                            WinSelect = [WinSelect stringByAppendingString:@"大小分~"];
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                            {
                                
                                if ([[array_inner objectAtIndex:inner_index] isEqualToString:@"0"]) {
                                    betCode = [betCode stringByAppendingString:@"1"];
                                    [[gameSparray combineBase_SP] addObject:[base Big]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 大SP%@ ",[base Big]]];
                                    
                                }
                                else if([[array_inner objectAtIndex:inner_index] isEqualToString:@"1"])
                                {
                                    betCode = [betCode stringByAppendingString:@"2"];
                                    [[gameSparray combineBase_SP] addObject:[base Small]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 小SP%@ ",[base Small]]];
                                }
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                        }
                        else if (m == 3) //竞彩篮球胜分差
                        {
                            betCode = [betCode stringByAppendingFormat:@"%@|%@|%@|%@|",[base dayTime],[base weekld],[base teamld],kLotNoJCLQ_SFC];
                            //010203040506111213151416
                            WinSelect = [WinSelect stringByAppendingString:@"胜分差~"];
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                            {
                                int inner_select_tag = [[array_inner objectAtIndex:inner_index] intValue];
                                if (inner_select_tag < 6)
                                {
                                    betCode = [betCode stringByAppendingFormat:@"0%d",inner_select_tag + 1];
                                }
                                else
                                {
                                    betCode = [betCode stringByAppendingFormat:@"%d",inner_select_tag + 5];
                                }
                                
                                m_tempStr = @"";
                                WinSelect = [WinSelect stringByAppendingFormat:@"  %@",[self getSfcScore:i Row:j  Tag:(inner_select_tag < 6 ? inner_select_tag + 1 : inner_select_tag + 5)]];
                                [[gameSparray combineBase_SP] addObject:m_tempStr];
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                        }
                        betCode = [betCode stringByAppendingString:@"^"];
                    }
                }
                
                if (ishave) {
                    [m_arrangeSP addObject:gameSparray];
                    //添加 场次分隔符
                    WinSelect = [WinSelect stringByAppendingString:@";"];
                    disBetCode = [disBetCode stringByAppendingString:WinSelect];
                }
                [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCLQ_CONFUSION;
            }
            if(m_playTypeTag == IJCLQPlayType_SFC || m_playTypeTag == IJCLQPlayType_SFC_DanGuan)
            {
                /*篮彩 胜分差定义
                 注码
                 分差
                 01 主胜 1-5
                 02 主胜 6-10
                 03 主胜 11 -15
                 04 主胜 16 -20
                 05 主胜 21 -25
                 06 主胜 26+
                 11客胜 1-5
                 12客胜 6-10
                 13客胜 11 -15
                 14客胜 16 -20
                 15客胜 21 -25
                 16客胜 26+
                 */
                NSMutableArray *array = [base sfc_selectTag];
                int count  = [array count];
                BOOL ishave = FALSE;
                if (count > 0) {
                    ishave = TRUE;
                    disBetCode = [disBetCode stringByAppendingFormat:@"%@ %@ %@(客) VS %@(主) @",[base week],[base teamld],[base VisitTeam],[base homeTeam]];
                    if ([base JC_DanIsSelect])
                        betCode_Dan = [betCode_Dan stringByAppendingFormat:@"%@|%@|%@|",[base dayTime],[base weekld],[base teamld]];
                    else
                        betCode = [betCode stringByAppendingFormat:@"%@|%@|%@|",[base dayTime],[base weekld],[base teamld]];
                }
                CombineBase *gameSparray = [[CombineBase alloc] init];
                for (int m = 0; m < count; m++)
                {
                    int tag = [[array objectAtIndex:m] intValue];
                    if ([base JC_DanIsSelect]) {
                        if (tag <= 6)
                            betCode_Dan = [betCode_Dan stringByAppendingString:@"0"];
                        betCode_Dan = [betCode_Dan stringByAppendingString:[array objectAtIndex:m]];
                    }
                    else
                    {
                        if (tag <= 6)
                            betCode = [betCode stringByAppendingString:@"0"];
                        betCode = [betCode stringByAppendingString:[array objectAtIndex:m]];
                    }
                    m_tempStr = @"";
                    if (m == 0) {
                        WinSelect = [WinSelect stringByAppendingString:@"胜分差~"];
                    }
                    WinSelect = [WinSelect stringByAppendingFormat:@"  %@",[self getSfcScore:i Row:j  Tag:tag]];
                    
                    [[gameSparray combineBase_SP] addObject:m_tempStr];
                }
                
                if (ishave) {
                    [gameSparray setIsDan:[base JC_DanIsSelect]];
                    [m_arrangeSP addObject:gameSparray];
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [betCode_Dan stringByAppendingString:@"^"];
                    }
                    else
                        betCode = [betCode stringByAppendingString:@"^"];
                    //添加 场次分隔符
                    WinSelect = [WinSelect stringByAppendingString:@";"];
                    disBetCode = [disBetCode stringByAppendingString:WinSelect];
                    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCLQ_SFC;
                }
                [gameSparray release];
            }
            else
            {
                BOOL visitTeamIsSelect = [base visitTeamIsSelect];
                BOOL homeTeamIsSelect = [base homeTeamIsSelect];
                BOOL ishave = FALSE;
                if (visitTeamIsSelect || homeTeamIsSelect)
                {
                    ishave = TRUE;
                    disBetCode = [disBetCode stringByAppendingFormat:@"%@ %@ %@(客) VS %@(主) @",[base week],[base teamld],[base VisitTeam],[base homeTeam]];
                    if ([base JC_DanIsSelect]) {
                        betCode_Dan = [betCode_Dan stringByAppendingFormat:@"%@|%@|%@|",[base dayTime],[base weekld],[base teamld]];
                    }
                    else
                    {
                        betCode = [betCode stringByAppendingFormat:@"%@|%@|%@|",[base dayTime],[base weekld],[base teamld]];
                    }
                    if (m_playTypeTag == IJCLQPlayType_SF || m_playTypeTag == IJCLQPlayType_SF_DanGuan)
                    {
                        CombineBase *gameSparray = [[CombineBase alloc] init];
                        WinSelect = [WinSelect stringByAppendingString:@"胜负~"];
                        if (visitTeamIsSelect) {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"0"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"0"];
                            
                            WinSelect = [WinSelect stringByAppendingFormat:@"    主负SP%@",[base v0]];
                            [[gameSparray combineBase_SP] addObject:[base v0]];
                        }
                        if (homeTeamIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"3"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"3"];
                            
                            WinSelect = [WinSelect stringByAppendingFormat:@"    主胜SP%@",[base v3]];
                            [[gameSparray combineBase_SP] addObject:[base v3]];
                        }
                        [gameSparray setIsDan:[base JC_DanIsSelect]];
                        [m_arrangeSP addObject:gameSparray];
                        [gameSparray release];
                        
                        //默认是 胜负过关
                        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCLQ_SF;
                    }
                    else if(m_playTypeTag == IJCLQPlayType_LetPoint || m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan)
                    {
                        CombineBase *gameSparray = [[CombineBase alloc] init ];
                        WinSelect = [WinSelect stringByAppendingString:@"让分胜负~"];
                        if (visitTeamIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"0"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"0"];
                            
                            WinSelect = [WinSelect stringByAppendingFormat:@"    主负SP%@",[base letVs_v0]];
                            [[gameSparray combineBase_SP] addObject:[base letVs_v0]];
                        }
                        if (homeTeamIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"3"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"3"];
                            WinSelect = [WinSelect stringByAppendingFormat:@"    主胜SP%@",[base letVs_v3]];
                            [[gameSparray combineBase_SP] addObject:[base letVs_v3]];
                        }
                        [gameSparray setIsDan:[base JC_DanIsSelect]];
                        [m_arrangeSP addObject:gameSparray];
                        [gameSparray release];
                        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCLQ_RF;
                    }
                    else if(m_playTypeTag == IJCLQPlayType_BigAndSmall ||
                            m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan)
                    {
                        CombineBase *gameSparray = [[CombineBase alloc] init ];
                        WinSelect = [WinSelect stringByAppendingString:@"大小分~"];
                        if (visitTeamIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"1"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"1"];
                            
                            WinSelect = [WinSelect stringByAppendingFormat:@"    大%@",[base Big]];
                            [[gameSparray combineBase_SP] addObject:[base Big]];
                        }
                        if (homeTeamIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"2"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"2"];
                            WinSelect = [WinSelect stringByAppendingFormat:@"    小%@",[base Small]];
                            [[gameSparray combineBase_SP] addObject:[base Small]];
                            
                        }
                        
                        [gameSparray setIsDan:[base JC_DanIsSelect]];
                        [m_arrangeSP addObject:gameSparray];
                        [gameSparray release];
                        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCLQ_DXF;
                    }
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
    }
    
	NSLog(@"betCode****** %@",betCode);
    NSLog(@"betCode****** %@",disBetCode);
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    NSString* betCode_dan_tuo = @"";
    if ([betCode_Dan length] > 0) {
        betCode_dan_tuo = [betCode_dan_tuo stringByAppendingString:betCode_Dan];
        
        betCode_dan_tuo = [betCode_dan_tuo stringByAppendingString:@"$"];
    }
    betCode_dan_tuo = [betCode_dan_tuo stringByAppendingString:betCode];
    
    [RuYiCaiLotDetail sharedObject].betCode = betCode_dan_tuo;
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    [RuYiCaiLotDetail sharedObject].sellWay = @"";
	[RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
    
    [self betNormal:nil];
}
- (void)betNormal:(NSNotification*)notification
{
    /*
     此方法 适用于 当xib文件跟 要关联的文件 名字不一样时
     */
    [self setHidesBottomBarWhenPushed:YES];
	JC_BetView* viewController = [[JC_BetView alloc] initWithNibName:@"JC_BetView" bundle:nil];
    viewController.gameCount = m_numGameCount;
    
    for (int spindex = 0; spindex < [m_arrangeSP count]; spindex++)
    {
        CombineBase* array = (CombineBase*)[m_arrangeSP objectAtIndex:spindex];
        [viewController appendArrangePS:array];
    }
    //排序
    [viewController sortSPArray];
    
    if (m_playTypeTag == IJCLQPlayType_SFC_DanGuan)
    {
        m_twoCount = 0;
        for (int i = 0; i < m_headerCount; i++)
        {
            int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
            for (int j = 0; j < baseCount; j++)
            {
                int selectCount = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j] sfc_selectTag] count];
                if (selectCount > 0) {
                    m_twoCount += selectCount - 1;
                }
                
            }
        }
    }
    if (m_playTypeTag == IJCLQPlayType_SFC ||
        m_playTypeTag == IJCLQPlayType_SF ||
        m_playTypeTag == IJCLQPlayType_LetPoint ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall ||
        m_playTypeTag == IJCLQPlayType_Confusion)
    {
        for (int i = 0; i < m_headerCount; i++)
        {
            int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
            
            for (int j = 0; j < baseCount; j++)
            {
                JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
                if (m_playTypeTag == IJCLQPlayType_Confusion) {
                    //计算 选择的
                    int confusion_selectCount = 0;
                    for (int i = 0; i < [[base confusion_selectTag] count]; i++) {
                        confusion_selectCount += [[[base confusion_selectTag] objectAtIndex:i] count];
                    }
                    NSMutableArray* confusion_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil];
                    NSMutableArray *array = [base confusion_selectTag];
                    for (int m = 0; m < [array count]; m++)
                    {
                        NSArray* array_inner = [array objectAtIndex:m];
                        NSLog(@"array_inner:%@",array_inner);
                        if ([array_inner count] > 0)
                        {
                            if (m == 0 || m == 1) {//竞彩篮球胜负//竞彩篮球让分胜负
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                    if ([[array_inner objectAtIndex:inner_index] isEqualToString:@"0"]) {
                                        [[confusion_array objectAtIndex:(m == 0 ? 0 : 1)] addObject:(m == 0 ? [base v3] : [base letVs_v3])];
                                    }
                                    else if([[array_inner objectAtIndex:inner_index] isEqualToString:@"1"])
                                    {
                                        [[confusion_array objectAtIndex:(m == 0 ? 0 : 1)] addObject:(m == 0 ? [base v0] : [base letVs_v0])];
                                    }
                                }
                            }
                            else if (m == 2)//竞彩篮球大小分
                            {
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                    
                                    if ([[array_inner objectAtIndex:inner_index] isEqualToString:@"0"]) {
                                        [[confusion_array objectAtIndex:2] addObject:[base Big]];
                                        
                                    }
                                    else if([[array_inner objectAtIndex:inner_index] isEqualToString:@"1"])
                                    {
                                        [[confusion_array objectAtIndex:2] addObject:[base Small]];
                                    }
                                }
                            }
                            else if (m == 3) //竞彩篮球胜分差
                            {
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                                {
                                    int inner_select_tag = [[array_inner objectAtIndex:inner_index] intValue];
                                    
                                    m_tempStr = @"";
                                    [self getSfcScore:i Row:j  Tag:(inner_select_tag < 6 ? inner_select_tag + 1 : inner_select_tag + 5)];
                                    [[confusion_array objectAtIndex:3] addObject:m_tempStr];
                                    viewController.confusion_type = JCLQ_SFC;
                                }
                            }
                        }
                    }
                    if (confusion_selectCount > 0) {
                        [viewController appendDuoChuanChoose:[NSString stringWithFormat:@"%d",confusion_selectCount] IS_DAN:[base JC_DanIsSelect] CONFUSION:confusion_array];
                    }
                    
                }
                else
                {
                    int selectCount = [[base sfc_selectTag] count];
                    if (m_playTypeTag == IJCLQPlayType_SF ||
                        m_playTypeTag == IJCLQPlayType_LetPoint ||
                        m_playTypeTag == IJCLQPlayType_BigAndSmall)
                    {
                        BOOL visitTeamIsSelect = [base visitTeamIsSelect];
                        BOOL homeTeamIsSelect = [base homeTeamIsSelect];
                        if (visitTeamIsSelect || homeTeamIsSelect)
                        {
                            if(visitTeamIsSelect && homeTeamIsSelect)
                                [viewController appendDuoChuanChoose:@"2" IS_DAN:[base JC_DanIsSelect] CONFUSION:nil];
                            else
                                [viewController appendDuoChuanChoose:@"1" IS_DAN:[base JC_DanIsSelect] CONFUSION:nil];
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
        }
    }
    viewController.twoCount = m_twoCount;
    viewController.playTypeTag = m_playTypeTag;
    viewController.chooseBetCode = [RuYiCaiLotDetail sharedObject].betCode;
	viewController.navigationItem.title = @"竞彩篮球投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
    
}

- (void)getJCLQDuiZhenOK:(NSNotification*)notification
{
    if ([self isDanGuan])
    {
        self.parserDictData_DanGuan = [RuYiCaiNetworkManager sharedManager].responseText;
    }
    else
    {
        self.parserDictData = [RuYiCaiNetworkManager sharedManager].responseText;
    }
    [self changeLeague];
    
    [self parserData];
}

-(BOOL) changeClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState ButtonIndex:(NSInteger)buttonIndex
{
    /*
     1 主队 2 客队
     */
    m_detailView.hidden = YES;
    m_playChooseView.hidden = YES;
    /*
     最多十场比赛 限制
     */
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[indexPath section]] tableHeaderArray] objectAtIndex:indexPath.row];
    if (m_numGameCount == 10)
    {
        if (clickState && buttonIndex != 4)
        {
            BOOL isHave = FALSE;
            
            if (buttonIndex == 1 && base.homeTeamIsSelect)
            {
                isHave = TRUE;
            }
            else if(buttonIndex == 2 && base.visitTeamIsSelect)
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
    
    if (buttonIndex == 2)
    {
        if (clickState)
        {
            [base setVisitTeamIsSelect:YES];
        }
        else
        {
            [base setVisitTeamIsSelect:NO];
        }
    }
    else if(buttonIndex == 1)
    {
        if (clickState)
        {
            [base  setHomeTeamIsSelect:YES];
        }
        else
        {
            [base setHomeTeamIsSelect:NO];
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
    if (![base homeTeamIsSelect] && ![base visitTeamIsSelect] && [[base sfc_selectTag] count] <= 0) {
        [base setJC_DanIsSelect:NO];
    }
    
    if (!(m_playTypeTag == IJCLQPlayType_SFC || m_playTypeTag == IJCLQPlayType_SFC_DanGuan))
    {
        //刷新 所选比赛场次，金额
        NSInteger gameCount = 0;
        m_twoCount = 0;
        for (int i = 0; i < m_headerCount; i++)
        {
            int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
            for (int j = 0; j < baseCount; j++) {
                BOOL visitTeamIsSelect = [(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j] visitTeamIsSelect];
                
                BOOL homeTeamIsSelect = [(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j] homeTeamIsSelect];
                if (visitTeamIsSelect || homeTeamIsSelect)
                {
                    gameCount++;
                    if (visitTeamIsSelect && homeTeamIsSelect)
                    {
                        m_twoCount++;
                    }
                }
            }
        }
        m_numGameCount = gameCount;
        // 已选比赛：%d 场
        m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", gameCount];
    }
    [m_tableView reloadData];//用于胜负都取消选项时 胆 按钮自动未选中
    return TRUE;
}
-(void) gotoSFCView:(NSIndexPath*)indexPath
{
    if (m_numGameCount >= 10)
    {
        
        JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[indexPath section]] tableHeaderArray] objectAtIndex:[indexPath row]];
        
        if (m_playTypeTag == IJCLQPlayType_Confusion) {
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
    NSString *temp = [NSString stringWithFormat:@"%@(客) VS %@(主)", [base VisitTeam], [base homeTeam]];
    
    if (m_playTypeTag == IJCLQPlayType_Confusion) {
        
        ConfusionViewController* viewController = [[ConfusionViewController alloc] init];
        viewController.navigationItem.title = @"返回";
        viewController.JCLQ_parentController = self;
        viewController.indexPath = indexPath;
        viewController.isJCLQView = TRUE;
        viewController.playTypeTag = m_playTypeTag;
        viewController.team = temp;
        //竞彩篮球 胜负
        NSArray* jclq_sf = [NSArray arrayWithObjects:[NSString stringWithFormat:@"主胜 %@",[base v3]],[NSString stringWithFormat:@"客胜 %@",[base v0]], nil];
        [viewController appendButtonText:jclq_sf];
        
        //竞彩篮球 让分胜负
        NSArray* jclq_rf = [NSArray arrayWithObjects:[NSString stringWithFormat:@"主胜 %@",[base letVs_v3]], [base letPoint],[NSString stringWithFormat:@"客胜 %@",[base letVs_v0]], nil];
        [viewController appendButtonText:jclq_rf];
        //竞彩篮球 大小分
        NSArray* jclq_dxf = [NSArray arrayWithObjects:[NSString stringWithFormat:@"大 %@",[base Big]], [base basePoint],[NSString stringWithFormat:@"小 %@",[base Small]], nil];
        [viewController appendButtonText:jclq_dxf];
        //竞彩篮球 胜分差
        
        NSString *buttonText = @"";
        for (int i = 1; i < 7; i++) {
            buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath.section Row:indexPath.row  Tag:(i)]];
            buttonText = [buttonText stringByAppendingFormat:@";"];
        }
        for (int i = 11; i < 17; i++) {
            buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath .section Row:indexPath.row Tag:(i)]];
            if (i < 16) {
                buttonText = [buttonText stringByAppendingFormat:@";"];
            }
        }
        NSArray* jclq_sfc = [buttonText componentsSeparatedByString:@";"];
        [viewController appendButtonText:jclq_sfc];
        /*
         设置已选择的玩法
         */
        for (int i = 0; i < [[base confusion_selectTag] count]; i++) {
            NSMutableArray* array = [NSMutableArray arrayWithArray:[[base confusion_selectTag] objectAtIndex:i]];
            [viewController appendSelectScoreText:array];
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
    }
    else
    {
        SFCViewController* viewController = [[SFCViewController alloc] init];
        viewController.navigationItem.title = @"返回";
        viewController.JCLQ_parentController = self;
        viewController.indexPath = indexPath;
        viewController.isJCLQView = TRUE;
        viewController.playTypeTag = m_playTypeTag;
        viewController.team = temp;
        
        for (int i = 1; i < 7; i++) {
            NSString *buttonText = @"";
            buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath.section Row:indexPath.row  Tag:(i)]];
            [viewController appendButtonText:buttonText];
        }
        for (int i = 11; i < 17; i++) {
            NSString *buttonText = @"";
            buttonText = [buttonText stringByAppendingString:[self getSfcScore:indexPath .section Row:indexPath.row Tag:(i)]];
            [viewController appendButtonText:buttonText];
        }
        
        int scoreCount = [[base sfc_selectTag] count];
        for (int i = 0; i < scoreCount; i++) {
            [viewController appendSelectScoreText:[[base sfc_selectTag] objectAtIndex:i]];
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}
-(void) clearAllChoose
{
    m_numGameCount = 0;
    // 已选比赛：%d 场
    m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", m_numGameCount];
    for (int i = 0; i < m_headerCount; i++)
    {
        int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < baseCount; j++) {
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            [base setVisitTeamIsSelect:NO];
            [base setHomeTeamIsSelect:NO];
            [base.sfc_selectTag removeAllObjects];
            [base.confusion_selectTag removeAllObjects];
            for (int k = 0; k < 4; k++) {
                [base.confusion_selectTag addObject:[NSArray array]];
            }
            base.confusionButtonText = @"";
        }
    }
    
    //    [m_tableHeaderState removeAllObjects];
    //    for (int i = 0; i < m_headerCount; i++) {
    //        [m_tableHeaderState addObject:@"0"];
    //        m_SectionN[i] = 0;
    //    }
    
}

-(void) reloadDataTwo
{
    //刷新 所选比赛场次，金额-----胜分差完发
    NSInteger gameCount = 0;
    for (int i = 0; i < m_headerCount; i++)
    {
        int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < baseCount; j++) {
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            if (self.playTypeTag != IJCLQPlayType_Confusion) {
                int count = [[base sfc_selectTag] count];
                if (count > 0) {
                    gameCount++;
                }
                else
                {
                    [base setJC_DanIsSelect:NO];
                }
            }
            else
            {
                for (int p = 0; p < [base.confusion_selectTag count]; p++) {
                    if ([[base.confusion_selectTag objectAtIndex:p] count] > 0) {
                        gameCount++;
                        break;
                    }
                }
            }
        }
    }
    m_numGameCount = gameCount;
    // 已选比赛：%d 场
    m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", gameCount];
    [m_tableView reloadData];
}

- (NSString*)getSfcScore:(NSInteger)section Row:(NSInteger)row Tag:(NSInteger)tag
{
    //    tag 1-6 + 11-16
    NSString *temp = @"";
    NSArray* textArray = [NSArray arrayWithObjects:@"主胜1-5分|",@"主胜6-10分|", @"主胜11-15分|",@"主胜16-20分|",@"主胜21-25分|",@"主胜26分以上|",@"主负1-5分|",@"主负6-10分|",@"主负11-15分|",@"主负16-20分|",@"主负21-25分|",@"主负26分以上|", nil];
    
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row];
    //加 | 用来分离文字和数据
    if (tag == 1) {
        m_tempStr = [base sfcV01];
    }
    else if(tag == 2)
    {
        m_tempStr = [base sfcV02];
    }
    else if(tag == 3)
    {
        m_tempStr = [base sfcV03];
    }
    else if(tag == 4)
    {
        m_tempStr = [base sfcV04];
    }
    else if(tag == 5)
    {
        m_tempStr = [base sfcV05];
    }
    else if(tag == 6)
    {
        m_tempStr = [base sfcV06];
    }
    else if(tag == 11)
    {
        m_tempStr = [base sfcV11];
    }
    else if(tag == 12)
    {
        m_tempStr = [base sfcV12];
    }
    else if(tag == 13)
    {
        m_tempStr = [base sfcV13];
    }
    else if(tag == 14)
    {
        m_tempStr = [base sfcV14];
    }
    else if(tag == 15)
    {
        m_tempStr = [base sfcV15];
    }
    else if(tag == 16)
    {
        m_tempStr = [base sfcV16];
    }
    
    temp = [textArray objectAtIndex:(tag > 6 ? tag - 5 : tag - 1)];
    temp = [temp stringByAppendingString:m_tempStr];
    return temp;
}

/*
 解析对阵数据
 */
- (void)parserData
{
    NSString* parserData = @"";
    if ([self isDanGuan])
    {
        if ([self.parserDictData_DanGuan length] == 0)
        {
            return;
        }
        parserData = self.parserDictData_DanGuan;
    }
    if (![self isDanGuan])
    {
        if ([self.parserDictData length] == 0)
        {
            return;
        }
        parserData = self.parserDictData;
    }
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:parserData];
    [jsonParser release];
    
    NSArray* array = (NSArray*)[parserDict objectForKey:@"result"];
    int nHeaderCount = [array count];
    if (nHeaderCount == 0) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"暂时没有赛事" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (m_tableCell_DataArray != nil)
    {
        [m_tableCell_DataArray removeAllObjects];
        [m_tableCell_DataArray release];
    }
    m_tableCell_DataArray = [[NSMutableArray alloc] initWithCapacity:10];
    /*
     存储 获得的所有对阵 ，并且 筛选 当前要显示的对阵
     */
    for (int i = 0; i < nHeaderCount; i++)
    {
        NSArray*  subArray = (NSArray*)[array objectAtIndex:i];
        
        JCLQ_tableViewCell_DataArray* currentBaseArray = [[JCLQ_tableViewCell_DataArray alloc] init];
        
        int subArrayCount = [subArray count];
        for (int j = 0; j < subArrayCount; j++)
        {
            NSDictionary* sub_subDict = (NSDictionary*) [subArray objectAtIndex:j];
            
            JCLQ_tableViewCell_DataBase*  base = [[JCLQ_tableViewCell_DataBase alloc] init];
            base.dayTime = [sub_subDict objectForKey:@"day"];
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
            NSString* team = [sub_subDict objectForKey:@"team"];
            NSArray* teamArray =  [team componentsSeparatedByString:@":"];
            if ([teamArray count] == 2)
            {
                base.homeTeam = [teamArray objectAtIndex:0];
                base.VisitTeam = [teamArray objectAtIndex:1];
            }
            base.teamld = [sub_subDict objectForKey:@"teamId"];
            
            base.weekld = [sub_subDict objectForKey:@"weekId"];
            base.weekld = KISDictionaryNullValue(sub_subDict, @"weekId");
            
            base.week = [sub_subDict objectForKey:@"week"];
            
            NSString* unSupportArray = [sub_subDict objectForKey:@"unsupport"];
            NSArray*  supportArray;
            BOOL isHave = FALSE;
            for (int k = 0; k < [unSupportArray length]; k++)
            {
                if ([unSupportArray characterAtIndex:k] == ',')
                {
                    isHave = TRUE;
                    break;
                }
            }
            if (isHave)
            {
                supportArray = [unSupportArray componentsSeparatedByString:@","];
                for (int m = 0; m < [supportArray count]; m++)
                {
                    NSString *str = [supportArray objectAtIndex:m];
                    [base appendToBaseUnSupportDuiZhen:str];
                }
            }
            else
            {
                if([unSupportArray length] > 0)
                {
                    [base appendToBaseUnSupportDuiZhen:unSupportArray];
                }
            }
            base.endTime = [sub_subDict objectForKey:@"endTime"];
            base.v0 = [sub_subDict objectForKey:@"v0"];
            base.v3 = [sub_subDict objectForKey:@"v3"];
            base.letPoint = [sub_subDict objectForKey:@"letPoint"];
            base.basePoint = [sub_subDict objectForKey:@"basePoint"];
            
            base.letVs_v0 = [sub_subDict objectForKey:@"letVs_v0"];
            base.letVs_v3 = [sub_subDict objectForKey:@"letVs_v3"];
            base.Big = [sub_subDict objectForKey:@"g"];
            base.Small = [sub_subDict objectForKey:@"l"];
            //胜分差
            base.sfcV01 = [sub_subDict objectForKey:@"v01"];
            base.sfcV02 = [sub_subDict objectForKey:@"v02"];
            base.sfcV03 = [sub_subDict objectForKey:@"v03"];
            base.sfcV04 = [sub_subDict objectForKey:@"v04"];
            base.sfcV05 = [sub_subDict objectForKey:@"v05"];
            base.sfcV06 = [sub_subDict objectForKey:@"v06"];
            
            base.sfcV11 = [sub_subDict objectForKey:@"v11"];
            base.sfcV12 = [sub_subDict objectForKey:@"v12"];
            base.sfcV13 = [sub_subDict objectForKey:@"v13"];
            base.sfcV14 = [sub_subDict objectForKey:@"v14"];
            base.sfcV15 = [sub_subDict objectForKey:@"v15"];
            base.sfcV16 = [sub_subDict objectForKey:@"v16"];
            
            int unsupportArrayCount =  [base.isUnSupportArry count];
            if (unsupportArrayCount > 0)
            {
                BOOL have = FALSE;
                for (int i = 0; i < unsupportArrayCount; i++)
                {
                    if ([[base.isUnSupportArry objectAtIndex:i] intValue] == m_playTypeTag)
                    {
                        have = TRUE;
                        break;
                    }
                }
                if (isLeagueSelect && !have)
                {
                    [currentBaseArray.tableHeaderArray addObject:base];
                }
            }
            else
            {
                if (isLeagueSelect)
                {
                    [currentBaseArray.tableHeaderArray addObject:base];
                }
            }
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
/*
 单关与过关 数据分开
 */
- (void) comeBackFromChooseView
{
    [centerButton setTitle:[self getTitleBy_playType] forState:UIControlStateNormal];
    
    //过关
    if ( ![self isDanGuan])
    {
        
        [self parserData];
    }
    //单关
    if ([self isDanGuan])
    {
        if ([self.parserDictData_DanGuan length] > 0)
        {
            [self parserData];
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager]QueryJCLQDuiZhen:@"0" JingCaiValueType:@"0"];//1 多关 0 单关
        }
    }
}
-(NSString*) getTitleBy_playType
{
    NSString* title = @"";
    if ([self isDanGuan]) {
        if(m_playTypeTag == IJCLQPlayType_SF_DanGuan)
        {
            title = @"胜负(单关)";
        }
        else if(m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan)
        {
            title = @"让分胜负(单关)";
        }
        else if(m_playTypeTag == IJCLQPlayType_SFC_DanGuan)
        {
            title = @"胜分差(单关)";
        }
        else if(m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan)
        {
            title = @"大小分(单关)";
        }
    }
    else
    {
        if(m_playTypeTag == IJCLQPlayType_SF)
        {
            title = @"胜负(过关)";
        }
        else if(m_playTypeTag == IJCLQPlayType_LetPoint)
        {
            title = @"让分胜负(过关)";
        }
        else if(m_playTypeTag == IJCLQPlayType_SFC)
        {
            title = @"胜分差(过关)";
        }
        else if(m_playTypeTag == IJCLQPlayType_BigAndSmall)
        {
            title = @"大小分(过关)";
        }
        else if(m_playTypeTag == IJCLQPlayType_Confusion)
        {
            title = @"混合过关";
        }
    }
    return title;
    
}

- (BOOL) isDanGuan
{
    //单关
    if (m_playTypeTag == IJCLQPlayType_SF_DanGuan ||
        m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan ||
        m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan
        )
    {
        return TRUE;
    }
    return FALSE;
}
/*
 //获取联赛
 */
- (void) changeLeague
{
    NSString* parserData = @"";
    if ([self isDanGuan])
    {
        if ([self.parserDictData_DanGuan length] == 0)
        {
            return;
        }
        parserData = self.parserDictData_DanGuan;
    }
    if (![self isDanGuan])
    {
        if ([self.parserDictData length] == 0)
        {
            return;
        }
        parserData = self.parserDictData;
    }
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:parserData];
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
    NSString* arrayStr = (NSString*)[parserDict objectForKey:@"leagues"];
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

-(BOOL) gameIsSelect:(NSIndexPath*) indexPath
{
    
    JCLQ_tableViewCell_DataBase* tableCell = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[indexPath section]] tableHeaderArray] objectAtIndex:[indexPath row]];
    if ([tableCell homeTeamIsSelect] || [tableCell visitTeamIsSelect] || [[tableCell sfc_selectTag] count] > 0) {
        return TRUE;
    }
    return FALSE;
}
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
        if (danCount <= 0 || m_numGameCount - 2 <= 0)  {
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
    if (danCount >= 7) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多可以选择七场比赛进行设胆" withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    return TRUE;
}
@end