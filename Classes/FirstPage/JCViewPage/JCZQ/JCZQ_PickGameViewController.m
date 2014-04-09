//
//  JCZQ_PickGameViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "JCZQ_PickGameViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "JC_TableView_ContentCell.h"
#import "JC_BetView.h"
#import "BackBarButtonItemUtils.h"
#import "RYCNormalBetView.h"
#import "SFCViewController.h"
#import "DataAnalysisViewController.h"
#import "InstantScoreViewController.h"
#import "JC_LeagueChooseViewController.h"
#import "PlayIntroduceViewController.h"
#import "QueryLotBetViewController.h"

#import "ConfusionViewController.h"
#import "AdaptationUtils.h"

@interface JCZQ_PickGameViewController (internal)
- (void)setupNavigationBar;
- (void)pressedBuyButton:(id)sender;
- (void)pressedReselectButton:(id)sender;
//筛选
- (void)setDetailView;
- (void)scoreButtonClick:(id)sender;
- (void)InstructionButtonClick:(id)sender;
- (void)queryBetlot_loginOK:(NSNotification*)notification;
- (void)setupQueryLotBetViewController;

- (void)getJCLQDuiZhenOK:(NSNotification*)notification;
- (void)submitLotNotification:(NSNotification*)notification;
- (void)betNormal:(NSNotification*)notification;

-(BOOL) gameIsSelect:(NSIndexPath*) indexPath;

//- (NSString*)getSfcScore:(NSInteger)section Row:(NSInteger)row Tag:(NSInteger)tag;
- (NSString*)getSfcScore:(NSInteger)section Row:(NSInteger)row Tag:(NSInteger)tag isGetBetCode:(BOOL)isGetbetCode;
-(NSString*) commonBetCode:(NSString*)betCode I:(NSInteger)i J:(NSInteger)j;
-(NSString*) commonDisBetCode:(NSString*)disBetCode I:(NSInteger)i J:(NSInteger)j;

@end

@implementation JCZQ_PickGameViewController

@synthesize motionArray = m_motionArray;

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

@synthesize eventChooseGameArray = m_eventChooseGameArray;
@synthesize userChooseGameEvent = m_userChooseGameEvent;

#define KHeightForFooterInSection 1 //section 底部间距
#define KHeightForRowAtIndexPath 67
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QueryJCLQDuiZhen" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryBetlot_loginOK" object:nil];
    m_detailView.hidden = YES;
    m_playChooseView.hidden = YES;
    //    if (iamge != nil) {
    //        [iamge removeFromSuperview];
    //        [iamge release], iamge = nil;
    //    }
    if(centerButton != nil)
    {
        [centerButton removeFromSuperview];
        [centerButton release], centerButton = nil;
    }
    [self resignFirstResponder];//摇一摇
    [super viewWillDisappear:animated];
}
- (void)dealloc
{
    NSTrace();
    
    [m_motionArray release],m_motionArray = nil;
    
    [m_tableCell_DataArray release], m_tableCell_DataArray = nil;
    [m_tableHeaderState release], m_tableHeaderState = nil;
    
    [m_tableView release], m_tableView = nil;
	[m_selectedCount release];
    [m_rightTitleBarItem release];
    
    [m_buttonBuy release];
    [m_buttonReselect release];
    [m_totalCost release];
    [m_selectLotAlterView release];
    [m_selectScrollView release];
    [m_SFCSelectScore release];
    
    [m_league_tableCell_DataArray release];
    [m_league_selected_tableCell_DataArrayTag release];
    [m_arrangeSP release];
    [m_detailView release];
    [m_playChooseView release];
    
    [m_randomData_SPF release], m_randomData_SPF = nil;
    
    [m_eventChooseGameArray release], m_eventChooseGameArray = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getJCLQDuiZhenOK:) name:@"QueryJCLQDuiZhen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBetlot_loginOK:) name:@"queryBetlot_loginOK" object:nil];
    
    //玩法切换 按钮
    //    if (iamge != nil) {
    //        [iamge removeFromSuperview];
    //        [iamge release], iamge = nil;
    //    }
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
    
    UIImageView* iamge = [[UIImageView alloc] initWithFrame:CGRectMake(55, 32, 14, 10)];
    iamge.image = [UIImage imageNamed:@"jc_headerlist_ico.png"];
    [centerButton addSubview:iamge];
    [iamge release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [MobClick event:@"JC_selectPage"];
    
    m_playTypeTag = IJCZQPlayType_SPF;//默认胜平负
    [self setupNavigationBar];
    
    m_totalCost.text = @" 已选比赛：0场\n";
    
    m_userChooseGameEvent = @"instantScore_JCZQ";
    
    m_headerCount = 0;
	m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //购买he取消购买按钮
    [self.buttonBuy addTarget:self action:@selector(pressedBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonReselect addTarget:self action:@selector(pressedReselectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    m_randomData_SPF = [[NSMutableArray alloc] initWithCapacity:1];
    m_motionArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 147  + 25) style:/*UITableViewStyleGrouped*/UITableViewStylePlain];
    //    m_tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉 groupcell的圆角
    //如果不希望响应select，那么就可以用下面的代码设置属性：
    m_tableView.allowsSelection=NO;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_tableView];
    
    [self setDetailView];
    [self setPlayChooseView];
    m_numGameCount = 0;
    
    self.parserDictData = @"";
    self.parserDictData_DanGuan = @"";
    [[RuYiCaiNetworkManager sharedManager]QueryJCLQDuiZhen:@"1" JingCaiValueType:@"1"];
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
    
    //    [m_tableView delete:(id)];
    
    [m_tableView reloadData];
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return KHeightForFooterInSection;
}
//指定有多少个分区（section） 默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //默认是1
    if ([m_motionArray count] == 0) {
        
        return m_headerCount;
    }
    else
    {
        return m_headerCount + 1;
    }
    
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KHeightForRowAtIndexPath;
}
//header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([m_motionArray count] > 0 && 0 == section) {
        return 0;
    }
    else
    {
        return 30;
    }
    
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([m_motionArray count] == 0) {
        //根据数组 来定
        return m_SectionN[section];
    }
    else
    {
        if (0 == section) {
            return 2;//[m_motionArray count];
        }
        else
        {
            NSLog(@"%d",m_SectionN[section -1]);
            
            return m_SectionN[section -1];
        }
    }
    
}
//创建 uitableview的 header
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger tempSection;
    if ([m_motionArray count] == 0) {
        tempSection = section;
    }
    else
    {
        tempSection = section - 1;
    }
    
    if ([m_motionArray count] > 0 && section == 0) {
        
        return nil;
    }
    else
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        
        [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = tempSection;
        //0 隐藏 1-- 展开
        if ([m_tableHeaderState objectAtIndex:tempSection] == @"0"){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            image.image = [UIImage imageNamed:@"jc_sectionlisthide.png"];
            [button addSubview:image];
            [image release];
        }
        else if([m_tableHeaderState objectAtIndex:tempSection] == @"1"){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
            image.image = [UIImage imageNamed:@"jc_sectionlistexpand.png"];
            [button addSubview:image];
            [image release];
        }
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        //    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        NSMutableArray* tempArray = [[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:tempSection] tableHeaderArray] objectAtIndex:0];//获取数组中的 第一个base数据
        
        NSString* dayForamt = [NSString stringWithFormat:@"%@  ", [(JCLQ_tableViewCell_DataBase*) tempArray dayforamt]];
        NSString* week = [NSString stringWithFormat:@"%@  ",[(JCLQ_tableViewCell_DataBase*) tempArray week]];
        NSString* title = [NSString stringWithFormat:@"%@%@%d场比赛可投注",dayForamt,week,[((JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:tempSection]) baseCount]];
        [button setTitle:title forState:UIControlStateNormal];
        return button;
    }
    
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
        cell.isCenterSelect = NO;
        cell.isRightSelect = NO;
	}
    cell.indexPath = indexPath;
    
    cell.JCZQ_parentViewController = self;
    cell.isJCLQtableview = NO;
    
    NSInteger section;
    
    if ([m_motionArray count] == 0) {
        
        section = indexPath.section;
        
    }
    else
    {
        section = indexPath.section - 1;
    }
    
    
    JCLQ_tableViewCell_DataBase* base;
    
    if ([m_motionArray count] > 0 && indexPath.section == 0) {
        
        base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:[[m_motionArray objectAtIndex:(indexPath.row == 0)? 0 : 2] intValue]] tableHeaderArray] objectAtIndex:[[m_motionArray objectAtIndex:(indexPath.row == 0)? 1 : 3] intValue]];
        
        //手动控制 用户的选择
        cell.isLeftSelect = [base ZQ_S_ButtonIsSelect];
        
        cell.isCenterSelect = [base ZQ_P_ButtonIsSelect];
        
        cell.isRightSelect = [base ZQ_F_ButtonIsSelect];
        
    }
    else
    {
        /*
         根据 玩法 （m_playTypeTag）来控制 cell呈现的界面
         
         IJCZQPlayType_RQ_SPF,//让球胜平负
         IJCZQPlayType_ZJQ,  //总进球数
         IJCZQPlayType_Score,//比分
         IJCZQPlayType_HalfAndAll,//半全场
         */
        base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:indexPath.row];
        
        cell.playTypeTag = m_playTypeTag;
        if (m_playTypeTag == IJCZQPlayType_RQ_SPF || m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan
            || m_playTypeTag == IJCZQPlayType_SPF || m_playTypeTag == IJCZQPlayType_SPF_DanGuan)
        {
            //手动控制 用户的选择
            cell.isLeftSelect = [base ZQ_S_ButtonIsSelect];
            
            cell.isCenterSelect = [base ZQ_P_ButtonIsSelect];
            
            cell.isRightSelect = [base ZQ_F_ButtonIsSelect];
        }
        else if(m_playTypeTag == IJCZQPlayType_ZJQ ||
                m_playTypeTag == IJCZQPlayType_Score ||
                m_playTypeTag == IJCZQPlayType_HalfAndAll||
                
                m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan ||
                m_playTypeTag == IJCZQPlayType_Score_DanGuan ||
                m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan ||
                m_playTypeTag == IJCZQPlayType_Confusion)
        {
            if (m_playTypeTag == IJCZQPlayType_Confusion) {
                if ([[base confusionButtonText] length] == 0) {
                    cell.SFCButtonText = @"请选择投注选项";
                }
                else
                    cell.SFCButtonText = [NSString stringWithFormat:@"%@   ",base.confusionButtonText];
            }
            else
            {
                NSString *buttonText = @"";
                NSMutableArray *array = [base sfc_selectTag];
                int count  = [array count];
                
                if (m_playTypeTag == IJCZQPlayType_ZJQ || m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan)
                {
                    buttonText = [buttonText stringByAppendingString:@"  进球数："];
                    for (int i = 0; i < count; i++)
                    {
                        int selectTag = [[[base sfc_selectTag] objectAtIndex:i] intValue];
                        if (selectTag == 7) {
                            buttonText = [buttonText stringByAppendingFormat:@"%d+ ,",selectTag];
                        }
                        else
                            buttonText = [buttonText stringByAppendingFormat:@"%d ,",selectTag];
                        
                        if (i <= count - 1)
                        {
                            buttonText = [buttonText stringByAppendingString:@"     "];
                        }
                    }
                }
                else if(m_playTypeTag == IJCZQPlayType_Score || m_playTypeTag == IJCZQPlayType_Score_DanGuan)
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
                else if(m_playTypeTag == IJCZQPlayType_HalfAndAll || m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan)
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
        }
    }
    
    
    cell.weekld = [base weekld];
    cell.teamld = [base teamld];
    cell.league = [base league];
    cell.endTime = [base endTime];
    cell.homeTeam = [base homeTeam];
    cell.VisitTeam = [base VisitTeam];
    cell.v0 = [base v0];
    cell.v1 = [base v1];
    cell.v3 = [base v3];
    cell.vf = [base vf];
    cell.vp = [base vp];
    cell.vs = [base vs];
    cell.letPoint = [base letPoint];
    
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

//选中cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
	[m_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//点击投注调用次函数
- (void)pressedBuyButton:(id)sender
{
    //    if ([m_motionArray count] > 0) {
    //
    //        [m_motionArray removeAllObjects];
    //    }
    //
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan ||
        m_playTypeTag == IJCZQPlayType_Score_DanGuan ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan)
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

//点击取消投注按钮调用此函数
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
    
    if (m_eventChooseGameArray != nil)
    {
        [m_eventChooseGameArray removeAllObjects];
        [m_eventChooseGameArray release];
    }
    
    m_arrangeSP = [[NSMutableArray alloc] initWithCapacity:10];
    m_eventChooseGameArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i = 0; i < m_headerCount; i++)
    {
        int everyHeaderBaseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < everyHeaderBaseCount; j++) {
            NSString*  WinSelect = @"";
            BOOL ishave = FALSE;
            /////////////////////////betCode////////////////////////////
            /*
             注码格式
             日期 |周数 |场次 |注码 ^日期 |周数 |场次 |注码 ^……
             |表示字段之间的分隔符号 表示字段之间的分隔符号
             ^表示注的结束符号
             例如
             胜负玩法 20101004| 20101004|1|301|3^ 1|301|3^ 1|301|3^ 1|301|3^ 1|301|3^ 1|301|3^ 表示投注 20101004 20101004 的周 1, 场次 301, 赛事胜
             胜负玩法 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 20101004|1|301|30^ 表示投注 20101004 20101004 的周 1, 场次 301, 赛事胜 +负
             */
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            if (self.playTypeTag == IJCZQPlayType_Confusion)
            {
                
                NSMutableArray *array = [base confusion_selectTag];
                if ([array count] > 0) {
                    int confsion_select_index = 0 ,confsion_select_count = 0;
                    while (confsion_select_index < [array count]) {
                        confsion_select_count += [[array objectAtIndex:confsion_select_index] count];
                        confsion_select_index++;
                    }
                    if (confsion_select_count > 0) {
                        ishave = TRUE;
                        disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                    }
                }
                //每一个对阵赔率
                CombineBase *gameSparray = [[[CombineBase alloc] init] autorelease];
                for (int m = 0; m < [array count]; m++)
                {
                    NSArray* array_inner = [array objectAtIndex:m];
                    NSLog(@"array_inner:%@",array_inner);
                    if ([array_inner count] > 0)
                    {
                        if (m == 0)//竞彩zu球胜平负
                        {
                            betCode = [NSString stringWithFormat:@"%@%@|",[self commonBetCode:betCode I:i J:j],kLotNoJCZQ_SPF];
                            WinSelect = [WinSelect stringByAppendingString:@"胜平负~"];
                            
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                            {
                                if ([[array_inner objectAtIndex:inner_index] intValue] == 2) {
                                    betCode = [betCode stringByAppendingString:@"0"];
                                    [[gameSparray combineBase_SP] addObject:[base vf]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 负 "]];
                                }
                                else if([[array_inner objectAtIndex:inner_index] intValue] == 1)
                                {
                                    betCode = [betCode stringByAppendingString:@"1"];
                                    [[gameSparray combineBase_SP] addObject:[base vp]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 平 "]];
                                }
                                else if([[array_inner objectAtIndex:inner_index] intValue] == 0)
                                {
                                    betCode = [betCode stringByAppendingString:@"3"];
                                    [[gameSparray combineBase_SP] addObject:[base vs]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 胜 "]];
                                }
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                        }
                        
                        else if (m == 1)//竞彩足球让球胜平负
                        {
                            
                            betCode = [NSString stringWithFormat:@"%@%@|",[self commonBetCode:betCode I:i J:j],kLotNoJCZQ_RQ_SPF];
                            WinSelect = [WinSelect stringByAppendingString:@"让球胜平负~"];
                            
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                            {
                                if ([[array_inner objectAtIndex:inner_index] intValue] == 2) {
                                    betCode = [betCode stringByAppendingString:@"0"];
                                    [[gameSparray combineBase_SP] addObject:[base v0]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 负 "]];
                                }
                                else if([[array_inner objectAtIndex:inner_index] intValue] == 1)
                                {
                                    betCode = [betCode stringByAppendingString:@"1"];
                                    [[gameSparray combineBase_SP] addObject:[base v1]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 平 "]];
                                }
                                else if([[array_inner objectAtIndex:inner_index] intValue] == 0)
                                {
                                    betCode = [betCode stringByAppendingString:@"3"];
                                    [[gameSparray combineBase_SP] addObject:[base v3]];
                                    WinSelect = [WinSelect stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" 胜 "]];
                                }
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                        }
                        
                        
                        else if (m == 2)//竞彩足球半全场
                        {
                            //betCode****** 20130308|5|001|333130131110030100^
                            betCode = [NSString stringWithFormat:@"%@%@|",[self commonBetCode:betCode I:i J:j],kLotNoJCZQ_HALF];
                            WinSelect = [WinSelect stringByAppendingString:@"半全场~"];
                            m_playTypeTag = IJCZQPlayType_HalfAndAll;
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                
                                NSString* bifen_temp = [self getSfcScore:i Row:j Tag:[[array_inner objectAtIndex:inner_index] intValue] isGetBetCode:NO];
                                NSArray* bifen_array = [bifen_temp componentsSeparatedByString:@"|"];
                                WinSelect = [WinSelect stringByAppendingString:([bifen_array count] == 2 ? [NSString stringWithFormat:@"%@  ",[bifen_array objectAtIndex:0]] : @"")];
                                
                                betCode = [betCode stringByAppendingString:[self getSfcScore:i Row:j Tag:[[array_inner objectAtIndex:inner_index] intValue] isGetBetCode:YES]];
                                [[gameSparray combineBase_SP] addObject:m_tempStr];
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                            m_playTypeTag = IJCZQPlayType_Confusion;
                        }
                        else if (m == 3)//竞彩足球总进球
                        {
                            //betCode****** 20130308|5|001|01234567
                            betCode = [NSString stringWithFormat:@"%@%@|",[self commonBetCode:betCode I:i J:j],kLotNoJCZQ_ZJQ];
                            WinSelect = [WinSelect stringByAppendingString:@"总进球~"];
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                int inner_index_tag =  [[array_inner objectAtIndex:inner_index] intValue];
                                
                                betCode = [betCode stringByAppendingFormat:@"%d",inner_index_tag];
                                [[gameSparray combineBase_SP] addObject:[[base goalArray] objectAtIndex:inner_index_tag]];
                                WinSelect = [WinSelect stringByAppendingFormat:@"%@",(inner_index_tag == 7 ? [NSString stringWithFormat:@" %d+ ",inner_index_tag] : [NSString stringWithFormat:@" %d ",inner_index_tag])];
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                        }
                        else if (m == 4)//竞彩足球比分
                        {
                            //betCode****** 20130308|5|001|90102021303132404142505152990011332209010212031323041424051525^
                            betCode = [NSString stringWithFormat:@"%@%@|",[self commonBetCode:betCode I:i J:j],kLotNoJCZQ_SCORE];
                            WinSelect = [WinSelect stringByAppendingString:@"比分~"];
                            m_playTypeTag = IJCZQPlayType_Score;
                            for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                
                                NSString* bifen_temp = [self getSfcScore:i Row:j Tag:[[array_inner objectAtIndex:inner_index] intValue] isGetBetCode:NO];
                                NSArray* bifen_array = [bifen_temp componentsSeparatedByString:@"|"];
                                WinSelect = [WinSelect stringByAppendingString:([bifen_array count] == 2 ? [NSString stringWithFormat:@"%@  ",[bifen_array objectAtIndex:0]] : @"")];
                                
                                betCode = [betCode stringByAppendingString:[self getSfcScore:i Row:j Tag:[[array_inner objectAtIndex:inner_index] intValue] isGetBetCode:YES]];
                                [[gameSparray combineBase_SP] addObject:m_tempStr];
                            }
                            WinSelect = [WinSelect stringByAppendingString:@","];
                            m_playTypeTag = IJCZQPlayType_Confusion;
                        }
                        
                        betCode = [betCode stringByAppendingString:@"^"];
                    }
                }
                
                if (ishave) {
                    [gameSparray setIsDan:[base JC_DanIsSelect]];
                    [m_arrangeSP addObject:gameSparray];
                    //添加 场次分隔符
                    WinSelect = [WinSelect stringByAppendingString:@";"];
                    disBetCode = [disBetCode stringByAppendingString:WinSelect];
                    
                    //保存Event
                    [m_eventChooseGameArray addObject:[self getEventWithBase:base]];
                    
                }
                [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCZQ_CONFUSION;
                
            }
            else
            {
                if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
                    m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan ||
                    m_playTypeTag == IJCZQPlayType_SPF ||
                    m_playTypeTag == IJCZQPlayType_SPF_DanGuan)
                {
                    CombineBase *gameSparray = [[CombineBase alloc] init];
                    BOOL ZQ_S_ButtonIsSelect = [base ZQ_S_ButtonIsSelect];
                    BOOL ZQ_P_ButtonIsSelect = [base ZQ_P_ButtonIsSelect];
                    BOOL ZQ_F_ButtonIsSelect = [base ZQ_F_ButtonIsSelect];
                    if (ZQ_F_ButtonIsSelect || ZQ_P_ButtonIsSelect ||ZQ_S_ButtonIsSelect)
                    {
                        ishave = TRUE;
                        if ([base JC_DanIsSelect]) {
                            betCode_Dan = [self commonBetCode:betCode_Dan I:i J:j];
                        }
                        else
                            betCode = [self commonBetCode:betCode I:i J:j];
                        disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                        if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
                            m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan)
                            disBetCode = [disBetCode stringByAppendingString:@"让球胜平负~"];
                        else
                            disBetCode = [disBetCode stringByAppendingString:@"胜平负~"];
                        
                        if (ZQ_S_ButtonIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"3"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"3"];
                            
                            disBetCode = [disBetCode stringByAppendingString:@" 胜"];
                            if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
                                m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan)
                                [[gameSparray combineBase_SP] addObject:[base v3]];
                            else
                                [[gameSparray combineBase_SP] addObject:[base vs]];
                        }
                        if (ZQ_P_ButtonIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"1"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"1"];
                            disBetCode = [disBetCode stringByAppendingString:@" 平"];
                            if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
                                m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan)
                                [[gameSparray combineBase_SP] addObject:[base v1]];
                            else
                                [[gameSparray combineBase_SP] addObject:[base vp]];
                        }
                        if (ZQ_F_ButtonIsSelect)
                        {
                            if ([base JC_DanIsSelect]) {
                                betCode_Dan = [betCode_Dan stringByAppendingString:@"0"];
                            }
                            else
                                betCode = [betCode stringByAppendingString:@"0"];
                            disBetCode = [disBetCode stringByAppendingString:@" 负"];
                            if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
                                m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan)
                                [[gameSparray combineBase_SP] addObject:[base v0]];
                            else
                                [[gameSparray combineBase_SP] addObject:[base vf]];
                        }
                        disBetCode = [disBetCode stringByAppendingString:@","];
                        [gameSparray setIsDan:[base JC_DanIsSelect]];
                        [m_arrangeSP addObject:gameSparray];
                    }
                    
                    [gameSparray release];
                    if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
                        m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan)
                        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCZQ_RQ_SPF;
                    else
                        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCZQ_SPF;
                }
                if (m_playTypeTag == IJCZQPlayType_ZJQ ||
                    m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan)
                {
                    NSMutableArray *array = [base sfc_selectTag];
                    if ([array count] > 0) {
                        ishave = TRUE;
                        disBetCode = [self commonDisBetCode:disBetCode I:i J:j];
                        disBetCode = [disBetCode stringByAppendingString:@"总进球~"];
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
                            betCode_Dan = [betCode_Dan stringByAppendingFormat:@"%d",tag];
                        }
                        else
                            betCode = [betCode stringByAppendingFormat:@"%d",tag];
                        
                        WinSelect = [WinSelect stringByAppendingFormat:@"  %d  ",tag];
                        [[gameSparray combineBase_SP] addObject:[[base goalArray] objectAtIndex:tag]];//tag 即为 下标值
                    }
                    if (ishave) {
                        [gameSparray setIsDan:[base JC_DanIsSelect]];
                        [m_arrangeSP addObject:gameSparray];
                    }
                    [gameSparray release];
                    
                    WinSelect = [WinSelect stringByAppendingString:@","];
                    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCZQ_ZJQ;
                    
                }
                
                if (m_playTypeTag == IJCZQPlayType_Score ||
                    m_playTypeTag == IJCZQPlayType_Score_DanGuan)
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
                    WinSelect = [WinSelect stringByAppendingString:@","];
                    [gameSparray release];
                    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCZQ_SCORE;
                    
                }
                else if(m_playTypeTag == IJCZQPlayType_HalfAndAll ||
                        m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan)
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
                    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoJCZQ_HALF;
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
                    
                    //保存Event
                    [m_eventChooseGameArray addObject:[self getEventWithBase:base]];
                }
            }
        }
    }
    
	NSLog(@"betCode****** %@",betCode);
    NSLog(@"betCode****** %@",disBetCode);
    NSLog(@"betCode****** %@",betCode_Dan);
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    NSString* betCode_dan_tuo = @"";
    if ([betCode_Dan length] > 0) {
        betCode_dan_tuo = [betCode_dan_tuo stringByAppendingString:betCode_Dan];
        
        betCode_dan_tuo = [betCode_dan_tuo stringByAppendingString:@"$"];
    }
    betCode_dan_tuo = [betCode_dan_tuo stringByAppendingString:betCode];
    
    NSLog(@"betCode****** %@",betCode_dan_tuo);
    
    [RuYiCaiLotDetail sharedObject].betCode = betCode_dan_tuo;
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    [RuYiCaiLotDetail sharedObject].sellWay = @"";
	[RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].toMobileCode = @"";
    //    [[RuYiCaiNetworkManager sharedManager] showLotSubmitMessage:@"" withTitle:@"您的订单详情"];
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
        NSLog(@"array %@", array.combineBase_SP);
    }
    //排序
    [viewController sortSPArray];
    
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan ||
        m_playTypeTag == IJCZQPlayType_Score_DanGuan ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan
        )
    {
        m_twoCount = 0;
        for (int i = 0; i < m_headerCount; i++)
        {
            int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
            
            for (int j = 0; j < baseCount; j++)
            {
                JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
                
                int selectCount = [[base sfc_selectTag] count];
                if (m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan || m_playTypeTag == IJCZQPlayType_SPF_DanGuan)
                {
                    BOOL ZQ_S_ButtonIsSelect = [base ZQ_S_ButtonIsSelect];
                    BOOL ZQ_P_ButtonIsSelect = [base ZQ_P_ButtonIsSelect];
                    BOOL ZQ_F_ButtonIsSelect = [base ZQ_F_ButtonIsSelect];
                    
                    if((ZQ_S_ButtonIsSelect && ZQ_P_ButtonIsSelect)||
                       (ZQ_S_ButtonIsSelect && ZQ_F_ButtonIsSelect)||
                       (ZQ_P_ButtonIsSelect && ZQ_F_ButtonIsSelect) )
                    {
                        if (ZQ_S_ButtonIsSelect && ZQ_P_ButtonIsSelect && ZQ_F_ButtonIsSelect)
                        {
                            m_twoCount += 2;
                        }
                        else
                            m_twoCount += 1;
                    }
                    else
                    {
                        //                        [viewController appendDuoChuanChoose:@"1"];
                    }
                }
                else
                {
                    if (selectCount > 0) {
                        m_twoCount += selectCount - 1;
                    }
                }
            }
        }
    }
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||
        m_playTypeTag == IJCZQPlayType_SPF ||
        m_playTypeTag == IJCZQPlayType_ZJQ ||
        m_playTypeTag == IJCZQPlayType_Score ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll||
        m_playTypeTag == IJCZQPlayType_Confusion)
    {
        for (int i = 0; i < m_headerCount; i++)
        {
            int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
            for (int j = 0; j < baseCount; j++)
            {
                JCLQ_tableViewCell_DataBase* base = [[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
                if (m_playTypeTag == IJCZQPlayType_Confusion)
                {
                    //计算 选择的
                    int confusion_selectCount = 0;
                    for (int i = 0; i < [[base confusion_selectTag] count]; i++)
                    {
                        confusion_selectCount += [[[base confusion_selectTag] objectAtIndex:i] count];
                    }
                    NSMutableArray* confusion_array = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil];
                    NSMutableArray *array = [base confusion_selectTag];
                    //每一个对阵赔率
                    for (int m = 0; m < [array count]; m++)
                    {
                        NSArray* array_inner = [array objectAtIndex:m];
                        NSLog(@"array_inner:%d,%@",m,array_inner);
                        if ([array_inner count] > 0)
                        {
                            if (m == 0)//竞彩zu球胜平负
                            {
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                                {
                                    
                                    if ([[array_inner objectAtIndex:inner_index] intValue] == 2) {
                                        [[confusion_array objectAtIndex:0] addObject:[base vf]];
                                    }
                                    else if([[array_inner objectAtIndex:inner_index] intValue] == 1)
                                    {
                                        //用于计算 混合过关的最大奖金
                                        [[confusion_array objectAtIndex:0] addObject:[base vp]];
                                    }
                                    else if([[array_inner objectAtIndex:inner_index] intValue] == 0)
                                    {
                                        [[confusion_array objectAtIndex:0] addObject:[base vs]];
                                    }
                                }
                            }
                            
                            else if(m == 1)//竞彩足球让球胜平负
                            {
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++)
                                {
                                    
                                    if ([[array_inner objectAtIndex:inner_index] intValue] == 2) {
                                        [[confusion_array objectAtIndex:1] addObject:[base v0]];
                                    }
                                    else if([[array_inner objectAtIndex:inner_index] intValue] == 1)
                                    {
                                        //用于计算 混合过关的最大奖金
                                        [[confusion_array objectAtIndex:1] addObject:[base v1]];
                                    }
                                    else if([[array_inner objectAtIndex:inner_index] intValue] == 0)
                                    {
                                        [[confusion_array objectAtIndex:1] addObject:[base v3]];
                                    }
                                }
                            }
                            
                            else if (m == 2)//竞彩足球半全场
                            {
                                m_playTypeTag = IJCZQPlayType_HalfAndAll;
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                    
                                    [self getSfcScore:i Row:j Tag:[[array_inner objectAtIndex:inner_index] intValue] isGetBetCode:NO];
                                    
                                    [[confusion_array objectAtIndex:2] addObject:m_tempStr];
                                    viewController.confusion_type = JCZQ_HALF;
                                }
                                m_playTypeTag = IJCZQPlayType_Confusion;
                            }
                            else if (m == 3)//竞彩足球总进球
                            {
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                    int inner_index_tag =  [[array_inner objectAtIndex:inner_index] intValue];
                                    [[confusion_array objectAtIndex:3] addObject:[[base goalArray] objectAtIndex:inner_index_tag]];
                                    if (viewController.confusion_type != JCZQ_HALF && viewController.confusion_type != JCZQ_SCORE) {
                                        viewController.confusion_type = JCZQ_ZJQ;
                                    }
                                }
                            }
                            else if (m == 4)//竞彩足球比分
                            {
                                m_playTypeTag = IJCZQPlayType_Score;
                                for (int inner_index = 0; inner_index < [array_inner count]; inner_index++) {
                                    [self getSfcScore:i Row:j Tag:[[array_inner objectAtIndex:inner_index] intValue] isGetBetCode:NO];
                                    [[confusion_array objectAtIndex:4] addObject:m_tempStr];
                                    viewController.confusion_type = JCZQ_SCORE;
                                }
                                m_playTypeTag = IJCZQPlayType_Confusion;
                            }
                        }
                    }
                    if (confusion_selectCount > 0) {
                        [viewController appendDuoChuanChoose:[NSString stringWithFormat:@"%d",confusion_selectCount] IS_DAN:[base JC_DanIsSelect] CONFUSION:confusion_array];
                    }
                    //////////////// //////// //////// ////////
                    
                }
                else
                {
                    int selectCount = [[base sfc_selectTag] count];
                    if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||m_playTypeTag == IJCZQPlayType_SPF)
                    {
                        BOOL ZQ_S_ButtonIsSelect = [base ZQ_S_ButtonIsSelect];
                        BOOL ZQ_P_ButtonIsSelect = [base ZQ_P_ButtonIsSelect];
                        BOOL ZQ_F_ButtonIsSelect = [base ZQ_F_ButtonIsSelect];
                        if (ZQ_S_ButtonIsSelect || ZQ_P_ButtonIsSelect || ZQ_F_ButtonIsSelect)
                        {
                            if((ZQ_S_ButtonIsSelect && ZQ_P_ButtonIsSelect) ||
                               (ZQ_S_ButtonIsSelect && ZQ_F_ButtonIsSelect) ||
                               (ZQ_P_ButtonIsSelect && ZQ_F_ButtonIsSelect)
                               )//选2个或3个结果时
                            {
                                if (ZQ_S_ButtonIsSelect && ZQ_P_ButtonIsSelect && ZQ_F_ButtonIsSelect)
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
    
    viewController.eventChooseGameArray = m_eventChooseGameArray;
    viewController.userChooseGameEvent = m_userChooseGameEvent;
    
    viewController.playTypeTag = m_playTypeTag;
    viewController.jc_type = 0;
    viewController.chooseBetCode = [RuYiCaiLotDetail sharedObject].betCode;
	viewController.navigationItem.title = @"竞彩足球投注";
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
-(BOOL) changeClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState  ButtonIndex:(NSInteger)buttonIndex
{
    m_playChooseView.hidden = YES;
    m_detailView.hidden = YES;
    
    
    
    
    NSInteger section;
    NSInteger row;
    if ([m_motionArray count] == 0) {
        section = indexPath.section;
        row = indexPath.row;
    }
    else
    {
        if (0 == indexPath.section) {
            
            section = [[m_motionArray objectAtIndex:indexPath.row == 0?0:2]intValue];
            row = [[m_motionArray objectAtIndex:indexPath.row == 0?1:3]intValue];
        }
        else
        {
            section = indexPath.section - 1;
            row = indexPath.row;
        }
    }
    
    /*
     最多十场比赛 限制
     */
    if (m_numGameCount == 10)
    {
        if (clickState && buttonIndex != 4)
        {
            BOOL isHave = FALSE;
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row];
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
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多选择10场比赛" withTitle:@"投注提示" buttonTitle:@"确定"];
                return FALSE;
            }
        }
    }
    JCLQ_tableViewCell_DataBase* base = [[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row];
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
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF || m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan || m_playTypeTag == IJCZQPlayType_SPF || m_playTypeTag == IJCZQPlayType_SPF_DanGuan) {
        //刷新 所选比赛场次，金额
        NSInteger gameCount = 0;
        m_twoCount = 0;
        m_threeCount = 0;
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
                    if (ZQ_S_ButtonIsSelect && ZQ_P_ButtonIsSelect && !ZQ_F_ButtonIsSelect)
                    {
                        m_twoCount++;
                    }
                    if (ZQ_S_ButtonIsSelect && ZQ_F_ButtonIsSelect && !ZQ_P_ButtonIsSelect)
                    {
                        m_twoCount++;
                    }
                    if (ZQ_F_ButtonIsSelect&& ZQ_P_ButtonIsSelect && !ZQ_S_ButtonIsSelect)
                    {
                        m_twoCount++;
                    }
                    
                    if (ZQ_F_ButtonIsSelect&& ZQ_P_ButtonIsSelect && ZQ_S_ButtonIsSelect)
                    {
                        m_threeCount++;
                    }
                }
            }
        }
        m_numGameCount = gameCount;
        // 已选比赛：%d 场
        if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||m_playTypeTag == IJCZQPlayType_SPF) {
            m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场\n", gameCount];
            
        }
        else
            m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", gameCount];
    }
    
    [m_tableView reloadData];//用于胜平负都取消选项时 胆 按钮自动未选中
    
    return TRUE;
}

-(void) gotoSFCView:(NSIndexPath*)indexPath
{
    m_playChooseView.hidden = YES;
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
    
    if (m_playTypeTag == IJCZQPlayType_Confusion) {
        
        ConfusionViewController* viewController = [[ConfusionViewController alloc] init];
        viewController.navigationItem.title = @"返回";
        viewController.JCZQ_parentController = self;
        viewController.indexPath = indexPath;
        viewController.isJCLQView = FALSE;
        viewController.playTypeTag = m_playTypeTag;
        viewController.team = temp;
        
        //竞彩zu球 胜平负
        BOOL isSupport = TRUE;
        if(base.isUnSupportArry > 0)
        {
            for (int  i = 0; i < [base.isUnSupportArry count]; i++) {
                
                if([[base.isUnSupportArry objectAtIndex:i] intValue] == IJCZQPlayType_SPF)
                {
                    isSupport = FALSE;
                }
            }
        }
        if (isSupport) {
            NSArray* jczq_spf = [NSArray arrayWithObjects:[NSString stringWithFormat:@"胜 %@",[base vs]],[NSString stringWithFormat:@"平 %@",[base vp]],[NSString stringWithFormat:@"负 %@",[base vf]], nil];
            [viewController appendButtonText:jczq_spf];
        }
        else
        {
            [viewController appendButtonText:[NSArray array]];
        }
        
        
        //竞彩足球 让分胜平负
        isSupport = TRUE;
        if(base.isUnSupportArry > 0)
        {
            for (int  i = 0; i < [base.isUnSupportArry count]; i++) {
                
                if([[base.isUnSupportArry objectAtIndex:i] intValue] == IJCZQPlayType_RQ_SPF)
                {
                    isSupport = FALSE;
                }
            }
        }
        if (isSupport) {
            
            NSArray* jclq_rf = [NSArray arrayWithObjects:[NSString stringWithFormat:@"胜 %@",[base v3]],[NSString stringWithFormat:@"平 %@",[base v1]],[NSString stringWithFormat:@"负 %@",[base v0]],[NSString stringWithFormat:@"让 %@",[base letPoint]], nil];
            [viewController appendButtonText:jclq_rf];
        }
        else
        {
            [viewController appendButtonText:[NSArray array]];
        }
        
        //竞彩zu球 半全场
        isSupport = TRUE;
        NSString *half_buttonText = @"";
        if(base.isUnSupportArry > 0)
        {
            for (int  i = 0; i < [base.isUnSupportArry count]; i++) {
                
                if([[base.isUnSupportArry objectAtIndex:i] intValue] == IJCZQPlayType_HalfAndAll)
                {
                    isSupport = FALSE;
                }
            }
        }
        if (isSupport) {
            int half_Count = [[base half_Array] count];
            //通过修改 m_playTypeTag 来调用函数getSfcScore
            m_playTypeTag = IJCZQPlayType_HalfAndAll;
            for (int i = 0; i < half_Count; i++) {
                half_buttonText = [half_buttonText stringByAppendingString:[self getSfcScore:indexPath.section Row:indexPath.row  Tag:(i) isGetBetCode:NO]];
                if (i < half_Count - 1) {
                    half_buttonText = [half_buttonText stringByAppendingString:@";"];
                }
            }
        }
        else
        {
            [viewController appendButtonText:[NSArray array]];
        }
        
        
        //竞彩zu球 总进球
        isSupport = TRUE;
        if(base.isUnSupportArry > 0)
        {
            for (int  i = 0; i < [base.isUnSupportArry count]; i++) {
                
                if([[base.isUnSupportArry objectAtIndex:i] intValue] == IJCZQPlayType_ZJQ)
                {
                    isSupport = FALSE;
                }
            }
        }
        if (isSupport) {
            NSArray* jczq_bqc = [half_buttonText componentsSeparatedByString:@";"];
            [viewController appendButtonText:jczq_bqc];
            
            int ZJQ_count = [[base goalArray] count];
            //通过修改 m_playTypeTag 来调用函数getSfcScore
            m_playTypeTag = IJCZQPlayType_ZJQ;
            NSString *ZJQ_buttonText = @"";
            for (int i = 0; i < ZJQ_count; i++) {
                ZJQ_buttonText = [ZJQ_buttonText stringByAppendingFormat:@"%@|%@",(i == 7 ? [NSString stringWithFormat:@"%d+",i] : [NSString stringWithFormat:@"%d",i]),
                                  [[base goalArray] objectAtIndex:i]];
                if (i < ZJQ_count - 1) {
                    ZJQ_buttonText = [ZJQ_buttonText stringByAppendingString:@";"];
                }
            }
            NSArray* jczq_zjq = [ZJQ_buttonText componentsSeparatedByString:@";"];
            [viewController appendButtonText:jczq_zjq];
        }
        else
        {
            [viewController appendButtonText:[NSArray array]];
        }
        
        //竞彩zu球 比分
        isSupport = TRUE;
        if(base.isUnSupportArry > 0)
        {
            for (int  i = 0; i < [base.isUnSupportArry count]; i++) {
                
                if([[base.isUnSupportArry objectAtIndex:i] intValue] == IJCZQPlayType_RQ_SPF)
                {
                    isSupport = FALSE;
                }
            }
        }
        if (isSupport) {
            
            NSString *bf_buttonText = @"";
            m_playTypeTag = IJCZQPlayType_Score;
            
            for (int i = 0; i < 31; i++) {
                bf_buttonText = [bf_buttonText stringByAppendingFormat:@"%@",[self getSfcScore:indexPath.section Row:indexPath.row  Tag:(i) isGetBetCode:NO]];
                if (i < 31 - 1) {
                    bf_buttonText = [bf_buttonText stringByAppendingString:@";"];
                }
            }
            
            NSArray* jczq_bf = [bf_buttonText componentsSeparatedByString:@";"];
            [viewController appendButtonText:jczq_bf];
        }
        else
        {
            [viewController appendButtonText:[NSArray array]];
        }
        
        
        m_playTypeTag = IJCZQPlayType_Confusion;//还原回来
        
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
    else{
        SFCViewController* viewController = [[SFCViewController alloc] init];
        viewController.navigationItem.title = @"返回";
        viewController.JCZQ_parentController = self;
        viewController.indexPath = indexPath;
        viewController.isJCLQView = NO;
        viewController.playTypeTag = m_playTypeTag;
        viewController.team = temp;
        
        //    //总进球数
        if (m_playTypeTag == IJCZQPlayType_ZJQ || m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan) {
            int ZJQ_count = [[base goalArray] count];
            
            for (int i = 0; i < ZJQ_count; i++) {
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
        //    //比分
        if (m_playTypeTag == IJCZQPlayType_Score || m_playTypeTag == IJCZQPlayType_Score_DanGuan)
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
        if (m_playTypeTag == IJCZQPlayType_HalfAndAll || m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan) {
            
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
    
}
-(void) clearAllChoose
{
    m_numGameCount = 0;
    // 已选比赛：%d 场
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF||m_playTypeTag == IJCZQPlayType_SPF) {
        m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场\n", m_numGameCount];
        
    }
    else
        m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", m_numGameCount];
    for (int i = 0; i < m_headerCount; i++)
    {
        int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < baseCount; j++) {
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            [base setZQ_S_ButtonIsSelect:NO];
            
            [base setZQ_P_ButtonIsSelect:NO];
            
            [base setZQ_F_ButtonIsSelect:NO];
            
            [[base sfc_selectTag] removeAllObjects];
            [base.confusion_selectTag removeAllObjects];
            for (int k = 0; k < 4; k++) {
                [base.confusion_selectTag addObject:[NSArray array]];
            }
            base.confusionButtonText = @"";
        }
    }
    [m_SFCSelectScore removeAllObjects];
    
    if ([m_motionArray count] != 0) {
        
        [m_motionArray removeAllObjects];
    }
    [m_tableView reloadData];
}

-(void) reloadData
{
    //刷新 所选比赛场次，金额-----胜分差完发
    NSInteger gameCount = 0;
    for (int i = 0; i < m_headerCount; i++)
    {
        int baseCount = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] baseCount];
        for (int j = 0; j < baseCount; j++) {
            JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
            if (self.playTypeTag == IJCZQPlayType_Confusion) {
                for (int p = 0; p < [base.confusion_selectTag count]; p++) {
                    if ([[base.confusion_selectTag objectAtIndex:p] count] > 0) {
                        gameCount++;
                        break;
                    }
                }
            }
            else
            {
                int count = [[base sfc_selectTag] count];
                if (count > 0) {
                    gameCount++;
                }
                else
                    [base setJC_DanIsSelect:NO];
            }
            
        }
    }
    m_numGameCount = gameCount;
    // 已选比赛：%d 场
    m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场", gameCount];
    
    [m_tableView reloadData];
}

//获得 比分 和 半全场的 按钮 text
- (NSString*)getSfcScore:(NSInteger)section Row:(NSInteger)row Tag:(NSInteger)tag isGetBetCode:(BOOL)isGetbetCode
{
    NSString *temp = @"";
    //加 | 用来分离文字和数据
    if (m_playTypeTag == IJCZQPlayType_Score ||
        m_playTypeTag == IJCZQPlayType_Score_DanGuan)
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
        else if(tag == 10)
        {
            temp = [temp stringByAppendingString:@"5 : 0|"];
            
            if (isGetbetCode) {
                return @"50";
            }
        }
        else if(tag == 11)
        {
            temp = [temp stringByAppendingString:@"5 : 1|"];
            
            if (isGetbetCode) {
                return @"51";
            }
        }
        else if(tag == 12)
        {
            temp = [temp stringByAppendingString:@"5 : 2|"];
            
            if (isGetbetCode) {
                return @"52";
            }
        }
        
        else if(tag == 13)
        {
            temp = [temp stringByAppendingString:@"平其它|"];
            
            if (isGetbetCode) {
                return @"99";
            }
        }
        else if(tag == 14)
        {
            temp = [temp stringByAppendingString:@"0 : 0|"];
            
            if (isGetbetCode) {
                return @"00";
            }
        }
        else if(tag == 15)
        {
            temp = [temp stringByAppendingString:@"1 : 1|"];
            
            if (isGetbetCode) {
                return @"11";
            }
        }
        else if(tag == 16)
        {
            temp = [temp stringByAppendingString:@"2 : 2|"];
            
            if (isGetbetCode) {
                return @"22";
            }
        }
        else if(tag == 17)
        {
            temp = [temp stringByAppendingString:@"3 : 3|"];
            if (isGetbetCode) {
                return @"33";
            }
        }
        
        else if(tag == 18)
        {
            temp = [temp stringByAppendingString:@"负其它|"];
            if (isGetbetCode) {
                return @"09";
            }
        }
        else if(tag == 19)
        {
            temp = [temp stringByAppendingString:@"0 : 1|"];
            
            if (isGetbetCode) {
                return @"01";
            }
        }
        else if(tag == 20)
        {
            temp = [temp stringByAppendingString:@"0 : 2|"];
            
            if (isGetbetCode) {
                return @"02";
            }
        }
        
        else if(tag == 21)
        {
            temp = [temp stringByAppendingString:@"1 : 2|"];
            
            if (isGetbetCode) {
                return @"12";
            }
        }
        else if(tag == 22)
        {
            temp = [temp stringByAppendingString:@"0 : 3|"];
            
            if (isGetbetCode) {
                return @"03";
            }
        }
        
        else if(tag == 23)
        {
            temp = [temp stringByAppendingString:@"1 : 3|"];
            
            if (isGetbetCode) {
                return @"13";
            }
        }
        else if(tag == 24)
        {
            temp = [temp stringByAppendingString:@"2 : 3|"];
            
            if (isGetbetCode) {
                return @"23";
            }
        }
        else if(tag == 25)
        {
            temp = [temp stringByAppendingString:@"0 : 4|"];
            
            if (isGetbetCode) {
                return @"04";
            }
        }
        else if(tag == 26)
        {
            temp = [temp stringByAppendingString:@"1 : 4|"];
            
            if (isGetbetCode) {
                return @"14";
            }
        }
        else if(tag == 27)
        {
            temp = [temp stringByAppendingString:@"2 : 4|"];
            
            if (isGetbetCode) {
                return @"24";
            }
        }
        else if(tag == 28)
        {
            temp = [temp stringByAppendingString:@"0 : 5|"];
            
            if (isGetbetCode) {
                return @"05";
            }
        }
        else if(tag == 29)
        {
            temp = [temp stringByAppendingString:@"1 : 5|"];
            
            if (isGetbetCode) {
                return @"15";
            }
        }
        else if(tag == 30)
        {
            temp = [temp stringByAppendingString:@"2 : 5|"];
            if (isGetbetCode) {
                return @"25";
            }
        }
        
        if (tag <= 12) {
            m_tempStr = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] score_S_Array] objectAtIndex:tag];
            
            temp = [temp stringByAppendingString:m_tempStr];
        }
        if( 12 < tag && tag < 18)
        {
            m_tempStr = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] score_P_Array] objectAtIndex:tag - 13];
            
            temp = [temp stringByAppendingString:m_tempStr];
        }
        if(tag >= 18)
        {
            m_tempStr = [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] score_F_Array] objectAtIndex:tag - 18];
            
            temp = [temp stringByAppendingString:m_tempStr];
        }
        
    }
    
    if (m_playTypeTag == IJCZQPlayType_HalfAndAll ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan)
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
-(NSString*) commonDisBetCode:(NSString*)disBetCode I:(NSInteger)i J:(NSInteger)j
{
    //主队 VS 客队
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
    if ([base JC_DanIsSelect]) {
        if (m_playTypeTag == IJCZQPlayType_RQ_SPF || m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan) {
            disBetCode = [disBetCode stringByAppendingFormat:@"%@ %@(胆) %@ %@ %@@",[base week],[base teamld], [base homeTeam],[base letPoint],[base VisitTeam]];
        }
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%@ %@(胆) %@ VS %@@",[base week],[base teamld],[base homeTeam],[base VisitTeam]];
    }
    else
    {
        if (m_playTypeTag == IJCZQPlayType_RQ_SPF || m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan) {
            disBetCode = [disBetCode stringByAppendingFormat:@"%@ %@ %@ %@ %@@",[base week],[base teamld], [base homeTeam],[base letPoint],[base VisitTeam]];
        }
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%@ %@ %@ VS %@@",[base week],[base teamld],[base homeTeam],[base VisitTeam]];
    }
    return disBetCode;
}
-(NSString*) commonBetCode:(NSString*)betCode I:(NSInteger)i J:(NSInteger)j
{
    JCLQ_tableViewCell_DataBase* base = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:i] tableHeaderArray] objectAtIndex:j];
    betCode = [betCode stringByAppendingFormat:@"%@|",[base dayTime]];
    betCode = [betCode stringByAppendingFormat:@"%@|",[base weekld]];
    betCode = [betCode stringByAppendingFormat:@"%@|",[base teamld]];
    return betCode;
}
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
        [m_tableCell_DataArray release], m_tableCell_DataArray = nil;
    }
    m_tableCell_DataArray = [[NSMutableArray alloc] initWithCapacity:10];
    [m_randomData_SPF removeAllObjects];//机选的赛事
    for (int i = 0; i < nHeaderCount; i++)
    {
        NSArray*  subArray = (NSArray*)[array objectAtIndex:i];
        //        NSInteger newSection = 0;//确保联赛选择后 保存的section是正确的
        
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
            if ([teamArray count] == 2) {
                base.homeTeam = [teamArray objectAtIndex:0];//主队在前
                base.VisitTeam = [teamArray objectAtIndex:1];
            }
            base.teamld = KISDictionaryNullValue(sub_subDict, @"teamId");
            base.weekld = [sub_subDict objectForKey:@"weekId"];
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
            
            //            base.letPoint = [sub_subDict objectForKey:@"letPoint"];
            base.letPoint = [sub_subDict objectForKey:@"letVs_letPoint"];
            base.endTime = [sub_subDict objectForKey:@"endTime"];
            base.vf = [sub_subDict objectForKey:@"v0"];
            base.vp = [sub_subDict objectForKey:@"v1"];
            base.vs = [sub_subDict objectForKey:@"v3"];
            
            base.v0 = [sub_subDict objectForKey:@"letVs_v0"];
            base.v1 = [sub_subDict objectForKey:@"letVs_v1"];
            base.v3 = [sub_subDict objectForKey:@"letVs_v3"];
            
            //            [m_randomData_SPF removeAllObjects];
            //            if (([[base v0] floatValue] <= 1.75 && [[base v0] floatValue] > 0.0)||( [[base v1] floatValue] <= 1.75  && [[base v1] floatValue] > 0) || ([[base v3] floatValue] <= 1.75 && [[base v3] floatValue] > 0)) {//机选的赔率必须小于1.75
            //                NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
            //                [tempDic setObject:base forKey:@"data"];
            //                [tempDic setObject:[NSString stringWithFormat:@"%d", i] forKey:@"section"];
            //                [tempDic setObject:[NSString stringWithFormat:@"%d", j] forKey:@"row"];
            //
            //                if (isLeagueSelect) {
            //                    [m_randomData_SPF addObject:tempDic];
            //                }
            //            }
            
            //总进球数
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
            
            //比分 胜
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
            [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v50"] length] == 0
                                           ? @"" : [sub_subDict objectForKey:@"score_v50"])];
            [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v51"] length] == 0
                                           ? @"" : [sub_subDict objectForKey:@"score_v51"])];
            [base.score_S_Array addObject:([[sub_subDict objectForKey:@"score_v52"] length] == 0
                                           ? @"" : [sub_subDict objectForKey:@"score_v52"])];
            
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
            [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v05"] length] == 0
                                           ? @"" : [sub_subDict objectForKey:@"score_v05"])];
            [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v15"] length] == 0
                                           ? @"" : [sub_subDict objectForKey:@"score_v15"])];
            [base.score_F_Array addObject:([[sub_subDict objectForKey:@"score_v25"] length] == 0
                                           ? @"" : [sub_subDict objectForKey:@"score_v25"])];
            
            //胜分差
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
            
            if ([base.isUnSupportArry count] > 0)
            {
                BOOL have = FALSE;
                for (int i = 0; i < [base.isUnSupportArry count]; i++)
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
                    
                    if (m_playTypeTag == IJCZQPlayType_SPF)
                    {
                        
                        if (([[base vf] floatValue] <= 1.75 && [[base vf] floatValue] > 0.0)||( [[base vp] floatValue] <= 1.75  && [[base vp] floatValue] > 0) || ([[base vs] floatValue] <= 1.75 && [[base vs] floatValue] > 0))
                        {//机选的赔率必须小于1.75
                            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
                            [tempDic setObject:base forKey:@"data"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [m_tableCell_DataArray count]] forKey:@"section"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [currentBaseArray.tableHeaderArray count] - 1] forKey:@"row"];
                            
                            [m_randomData_SPF addObject:tempDic];
                        }
                    }
                    
                    if (m_playTypeTag == IJCZQPlayType_RQ_SPF)
                    {
                        
                        if (([[base v0] floatValue] <= 1.75 && [[base v0] floatValue] > 0.0)||( [[base v1] floatValue] <= 1.75  && [[base v1] floatValue] > 0) || ([[base v3] floatValue] <= 1.75 && [[base v3] floatValue] > 0))
                        {//机选的赔率必须小于1.75
                            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
                            [tempDic setObject:base forKey:@"data"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [m_tableCell_DataArray count]] forKey:@"section"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [currentBaseArray.tableHeaderArray count] - 1] forKey:@"row"];
                            
                            [m_randomData_SPF addObject:tempDic];
                        }
                        
                    }
                }
                
            }
            else
            {
                if (isLeagueSelect)
                {
                    [currentBaseArray.tableHeaderArray addObject:base];
                    if (m_playTypeTag == IJCZQPlayType_SPF)
                    {
                        
                        if (([[base vf] floatValue] <= 1.75 && [[base vf] floatValue] > 0.0)||( [[base vp] floatValue] <= 1.75  && [[base vp] floatValue] > 0) || ([[base vs] floatValue] <= 1.75 && [[base vs] floatValue] > 0))
                        {//机选的赔率必须小于1.75
                            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
                            [tempDic setObject:base forKey:@"data"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [m_tableCell_DataArray count]] forKey:@"section"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [currentBaseArray.tableHeaderArray count] - 1] forKey:@"row"];
                            
                            [m_randomData_SPF addObject:tempDic];
                        }
                    }
                    
                    if (m_playTypeTag == IJCZQPlayType_RQ_SPF)
                    {
                        
                        if (([[base v0] floatValue] <= 1.75 && [[base v0] floatValue] > 0.0)||( [[base v1] floatValue] <= 1.75  && [[base v1] floatValue] > 0) || ([[base v3] floatValue] <= 1.75 && [[base v3] floatValue] > 0))
                        {//机选的赔率必须小于1.75
                            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
                            [tempDic setObject:base forKey:@"data"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [m_tableCell_DataArray count]] forKey:@"section"];
                            [tempDic setObject:[NSString stringWithFormat:@"%d", [currentBaseArray.tableHeaderArray count] - 1] forKey:@"row"];
                            
                            [m_randomData_SPF addObject:tempDic];
                        }
                    }
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
    NSLog(@"m_randomData_SPF %@", m_randomData_SPF);
    //设置 tableviewcellheader 是否展开
    m_headerCount = [m_tableCell_DataArray count];
    if (m_tableHeaderState != nil)
    {
        [m_tableHeaderState removeAllObjects];
        [m_tableHeaderState release], m_tableHeaderState = nil;
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
    //    if ([m_motionArray count] > 0) {
    //
    //        [m_motionArray removeAllObjects];
    //    }
    
    //过关
    if ( ![self isDanGuan])
    {
        [centerButton setTitle:[self getTitleBy_playType] forState:UIControlStateNormal];
        [self parserData];
    }
    //单关
    if ([self isDanGuan])
    {
        [centerButton setTitle:[self getTitleBy_playType] forState:UIControlStateNormal];
        
        if ([self.parserDictData_DanGuan length] > 0)
        {
            [self parserData];
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager]QueryJCLQDuiZhen:@"1" JingCaiValueType:@"0"];//1 多关 0 单关
        }
    }
}

-(NSString*) getTitleBy_playType
{
    NSString* title = @"";
    if ([self isDanGuan]) {
        if(m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan)
        {
            title = @"让球胜平负(单关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_SPF_DanGuan)
        {
            title = @"胜平负(单关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan)
        {
            title = @"总进球(单关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_Score_DanGuan)
        {
            title = @"比分(单关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan)
        {
            title = @"半全场(单关)";
        }
    }
    else
    {
        if (m_playTypeTag == IJCZQPlayType_RQ_SPF) {
            title = @"让球胜平负(过关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_SPF)
        {
            title = @"胜平负(过关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_ZJQ)
        {
            title = @"总进球(过关)";
        }
        else if(m_playTypeTag ==IJCZQPlayType_Score)
        {
            title = @"比分(过关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_HalfAndAll)
        {
            title = @"半全场(过关)";
        }
        else if(m_playTypeTag == IJCZQPlayType_Confusion)
        {
            title = @"混合过关";
        }
    }
    return title;
    
}
- (BOOL) isDanGuan
{
    //单关
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan ||
        m_playTypeTag == IJCZQPlayType_Score_DanGuan ||
        m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan
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
        m_playChooseView = [[JCZQ_PlayChooseViewCell alloc] initWithFrame:CGRectMake(33, 0, 255, 250)];
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
    //    if ([m_motionArray count] > 0) {
    //
    //        [m_motionArray removeAllObjects];
    //    }
    
    m_playChooseView.hidden = NO;
    [self playChooseViewButtonClick];
    
    self.playTypeTag = m_playChooseView.PlayTypeTag;
    [self clearAllChoose];
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
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoJCZQ;
    if (![[RuYiCaiNetworkManager sharedManager] hasLogin]) {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    else
    {
        [self setupQueryLotBetViewController];
    }
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

- (void)queryBetlot_loginOK:(NSNotification*)notification
{
    [self setupQueryLotBetViewController];
}

- (void)setupQueryLotBetViewController
{
    [self setHidesBottomBarWhenPushed:YES];
    QueryLotBetViewController* viewController = [[QueryLotBetViewController alloc] init];
    viewController.navigationItem.title = @"投注查询";
    [viewController setSelectLotNo:kLotNoJCZQ];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}

- (void)leagueButtonClick:(id)sender;
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    JC_LeagueChooseViewController* viewController = [[JC_LeagueChooseViewController alloc] init];
    viewController.isJCLQView = NO;
	viewController.navigationItem.title = @"返回";
    viewController.JCZQ_parentController = self;
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
    InstantScoreViewController* viewController = [[InstantScoreViewController alloc] init];
    viewController.navigationItem.title = @"即时比分";
    viewController.type = JCZQ;
    viewController.userDefaultsTag = @"instantScore_JCZQ";
    viewController.userChooseGameEvent = m_userChooseGameEvent;
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
- (void)InstructionButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];
    
    PlayIntroduceViewController* viewController = [[PlayIntroduceViewController alloc] init];
    viewController.lotNo = kLotNoJCZQ;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
-(void) gotoLeagueChoose
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    JC_LeagueChooseViewController* viewController = [[JC_LeagueChooseViewController alloc] init];
    viewController.isJCLQView = NO;
	viewController.navigationItem.title = @"返回";
    viewController.JCZQ_parentController = self;
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
    
    NSInteger section;
    NSInteger row;
    if ([m_motionArray count] == 0) {
        section = indexPath.section;
        row = indexPath.row;
    }
    else
    {
        if (0 == indexPath.section) {
            
            section = [[m_motionArray objectAtIndex:indexPath.row == 0?0:2]intValue];
            row = [[m_motionArray objectAtIndex:indexPath.row == 0?1:3]intValue];
        }
        else
        {
            section = indexPath.section - 1;
            row = indexPath.row;
        }
    }
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    DataAnalysisViewController* viewController = [[DataAnalysisViewController alloc] init];
    NSString*   event = @"";
    event = [event stringByAppendingString:@"1_"];//1 足球 0篮球
    
    event = [event stringByAppendingFormat:@"%@_" ,[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] dayTime]];
    event = [event stringByAppendingFormat:@"%@_" ,[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] weekld]];
    
    event = [event stringByAppendingString:[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row] teamld]];
    
    [viewController setEvent:event];
    [viewController setIsJCLQ:NO];
    [viewController setIsZC:NO];
    
    viewController.navigationItem.title = @"球队数据分析";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
-(BOOL) gameIsSelect:(NSIndexPath*) indexPath
{
    NSInteger section;
    NSInteger row;
    if ([m_motionArray count] == 0) {
        
        section = indexPath.section;
        row = indexPath.row;
    }
    else
    {
        
        if (indexPath.section == 0) {
            
            section = [[m_motionArray objectAtIndex:(indexPath.row == 0)? 0 : 2] intValue];
            row = [[m_motionArray objectAtIndex:(indexPath.row == 0)? 1 : 3] intValue];
        }
        else
        {
            section = indexPath.section - 1;
            row = indexPath.row;
        }
        
    }
    
    
    JCLQ_tableViewCell_DataBase* tableCell = (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section] tableHeaderArray] objectAtIndex:row];
    
    int goalArrayCount = [[tableCell sfc_selectTag] count];
    if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] || goalArrayCount > 0  )
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
    if (danCount > 7) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多可以选择七场比赛进行设胆" withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    return TRUE;
}

//用于设胆之前的判断
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
        if (danCount <= 0 || m_numGameCount - 2 <= 0) {
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

#pragma mark 摇一摇（机选一注）
//然后在你的View控制器中添加/重载canBecomeFirstResponder, viewDidAppear:以及viewWillDisappear:
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self resignFirstResponder];
//    [super viewWillDisappear:animated];
//}

//最后在你的view控制器中添加motionEnded：
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    RuYiCaiAppDelegate* delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (motion == UIEventSubtypeMotionShake  && delegate.isStartYaoYiYao)
    {
        if (m_playTypeTag == IJCZQPlayType_RQ_SPF ||m_playTypeTag == IJCZQPlayType_SPF) {
            
            if ([m_randomData_SPF count] < 2) {
                m_totalCost.text = [NSString stringWithFormat:@" 已选比赛：%d 场\n(没有符合机选的场次)", m_numGameCount];
                return;
            }
            if (m_numGameCount == 0)//未选其他比赛
            {
                [self randomSPF];
            }
            else
            {
                UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"摇一摇提示" message:@"您确定要放弃所选比赛吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                
                [alterView addButtonWithTitle:@"确定"];
                alterView.delegate = self;
                [alterView show];
                
                [alterView release];
                return;
            }
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self randomSPF];
    }
}

- (void)randomSPF
{
    NSLog(@"%d", [m_randomData_SPF count]);
    
    [self clearAllChoose];
    
    
    int randomValue_one = arc4random() % [m_randomData_SPF count];
    int randomValue_two;
    do {
        randomValue_two = arc4random() % [m_randomData_SPF count];
    } while (randomValue_two == randomValue_one);//选两场 下标
    NSLog(@"m_motionArray %@ %d %d", m_motionArray, randomValue_one, randomValue_two);
    
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF) {
        
        base_one = [[m_randomData_SPF objectAtIndex:randomValue_one] objectForKey:@"data"];
        if ([[base_one v3] floatValue] <= 1.75) {//胜
            base_one.ZQ_S_ButtonIsSelect = YES;
        }
        else if ([[base_one v1] floatValue] <= 1.75) {//平
            base_one.ZQ_P_ButtonIsSelect = YES;
        }
        else if ([[base_one v0] floatValue] <= 1.75) {//负
            base_one.ZQ_F_ButtonIsSelect = YES;
        }
        
        base_two = [[m_randomData_SPF objectAtIndex:randomValue_two] objectForKey:@"data"];
        if ([[base_two v3] floatValue] <= 1.75) {//胜
            base_two.ZQ_S_ButtonIsSelect = YES;
        }
        else if ([[base_two v1] floatValue] <= 1.75) {//平
            base_two.ZQ_P_ButtonIsSelect = YES;
        }
        else if ([[base_two v0] floatValue] <= 1.75) {//负
            base_two.ZQ_F_ButtonIsSelect = YES;
        }
    }
    
    if (m_playTypeTag == IJCZQPlayType_SPF) {
        
        base_one = [[m_randomData_SPF objectAtIndex:randomValue_one] objectForKey:@"data"];
        if ([[base_one vs] floatValue] <= 1.75) {//胜
            base_one.ZQ_S_ButtonIsSelect = YES;
        }
        else if ([[base_one vp] floatValue] <= 1.75) {//平
            base_one.ZQ_P_ButtonIsSelect = YES;
        }
        else if ([[base_one vf] floatValue] <= 1.75) {//负
            base_one.ZQ_F_ButtonIsSelect = YES;
        }
        
        base_two = [[m_randomData_SPF objectAtIndex:randomValue_two] objectForKey:@"data"];
        if ([[base_two vs] floatValue] <= 1.75) {//胜
            base_two.ZQ_S_ButtonIsSelect = YES;
        }
        else if ([[base_two vp] floatValue] <= 1.75) {//平
            base_two.ZQ_P_ButtonIsSelect = YES;
        }
        else if ([[base_two vf] floatValue] <= 1.75) {//负
            base_two.ZQ_F_ButtonIsSelect = YES;
        }
    }
    
    for (int i = 0; i < m_headerCount; i++)
    {
        [m_tableHeaderState replaceObjectAtIndex:i withObject:@"0"];
        m_SectionN[i]=0;
        
    }
    //    m_SectionN[section_one] = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section_one] baseCount];
    //    m_SectionN[section_two] = [(JCLQ_tableViewCell_DataArray*)[m_tableCell_DataArray objectAtIndex:section_two] baseCount];
    
    if ([m_motionArray count] == 0) {
        
        [m_motionArray addObject:[[m_randomData_SPF objectAtIndex:randomValue_one] objectForKey:@"section"]];
        [m_motionArray addObject:[[m_randomData_SPF objectAtIndex:randomValue_one] objectForKey:@"row"]];
        [m_motionArray addObject:[[m_randomData_SPF objectAtIndex:randomValue_two] objectForKey:@"section"]];
        [m_motionArray addObject:[[m_randomData_SPF objectAtIndex:randomValue_two] objectForKey:@"row"]];
    }
    NSLog(@"m_motionArray %@", m_motionArray);
    
    [m_tableView reloadData];
    
    m_numGameCount = 2;
    m_totalCost.text = @" 已选比赛：2 场\n";
    
    
}

#pragma mark 获得一场比赛的Event

- (NSString*) getEventWithBase:(JCLQ_tableViewCell_DataBase*)base
{
    NSString*   event = @"";
    event = [event stringByAppendingString:@"1_"];//1 足球 0篮球
    
    event = [event stringByAppendingFormat:@"%@_" ,base.dayTime];
    event = [event stringByAppendingFormat:@"%@_" ,base.weekld];
    event = [event stringByAppendingString:base.teamld];
    
    return event;
}

- (void)back:(id)sender
{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
}
    
@end