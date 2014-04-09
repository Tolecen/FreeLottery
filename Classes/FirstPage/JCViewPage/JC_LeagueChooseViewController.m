//
//  JC_LeagueChooseViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JC_LeagueChooseViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "JC_LeagueTableCell.h"
#import "AdaptationUtils.h"

@interface JC_LeagueChooseViewController (internal)
- (void)setupNavigationBar;
- (void)selectButtonClick;

@end

@implementation JC_LeagueChooseViewController

@synthesize  isJCLQView = m_isJCLQView;
@synthesize tableView = m_tableView;
@synthesize JCLQ_parentController = m_JCLQ_parentController;
@synthesize JCZQ_parentController = m_JCZQ_parentController;
@synthesize BJDC_parentController;
@synthesize selectedLeagueArrayTag = m_selectedLeagueArrayTag;
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)dealloc
{
    NSTrace(); 
    [m_tableView release], m_tableView = nil;
    
    [m_rightTitleBarItem release], m_rightTitleBarItem = nil;
    [m_selectedLeagueArrayTag release], m_selectedLeagueArrayTag = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [self setupNavigationBar];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    m_tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    //如果不希望响应select，那么就可以用下面的代码设置属性：
    m_tableView.allowsSelection=NO; 
    
    m_SectionN[0] = 1;
    m_leagueHeaderButtonSelect = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_tableView];
    self.tableView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height);
    
}
- (void)setupNavigationBar
{
//	m_rightTitleBarItem = [[UIBarButtonItem alloc]
//                           initWithTitle:@"确定"
//                           style:UIBarButtonItemStylePlain
//                           target:self
//                           action:@selector(selectButtonClick)];
//    self.navigationItem.rightBarButtonItem = m_rightTitleBarItem;
    
    
    [BackBarButtonItemUtils addBackButtonForController:self];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(selectButtonClick) andTitle:@"确定"];
    self.navigationItem.title = @"赛事筛选";
}

- (void)selectButtonClick
{
    if (1 == m_isJCLQView)
    {
        [m_JCLQ_parentController clearAllChoose];
        int count = [m_selectedLeagueArrayTag count];
        if (count == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请选择至少一种联赛" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        /*
         注：
         单关 首次点击 要连网 获取数据
         */
        if (([m_JCLQ_parentController isDanGuan] && [m_JCLQ_parentController. parserDictData_DanGuan length] > 0)
            || ![m_JCLQ_parentController isDanGuan])
        {
            [m_JCLQ_parentController.league_selected_tableCell_DataArrayTag removeAllObjects];
            for (int i = 0; i < count; i++)
            {
                [m_JCLQ_parentController.league_selected_tableCell_DataArrayTag addObject:[m_selectedLeagueArrayTag objectAtIndex:i]];
            }     
        }
        [m_JCLQ_parentController comeBackFromChooseView];
    }
    else if(0 == m_isJCLQView)
    {
        [m_JCZQ_parentController clearAllChoose];
        int count = [m_selectedLeagueArrayTag count];
        if (count == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请选择至少一种联赛" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if (([m_JCZQ_parentController isDanGuan] && [m_JCZQ_parentController. parserDictData_DanGuan length] > 0) || ![m_JCZQ_parentController isDanGuan])
        {
            [m_JCZQ_parentController.league_selected_tableCell_DataArrayTag removeAllObjects];
            for (int i = 0; i < count; i++)
            {
                [m_JCZQ_parentController.league_selected_tableCell_DataArrayTag addObject:[m_selectedLeagueArrayTag objectAtIndex:i]];
            }  
        }
        
        [m_JCZQ_parentController comeBackFromChooseView];
    }
    else
    {
        [self.BJDC_parentController clearAllChoose];
        int count = [m_selectedLeagueArrayTag count];
        if (count == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请选择至少一种联赛" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        
        if (!self.BJDC_parentController.league_selected_tableCell_DataArrayTag) {
            return;
        }
        [self.BJDC_parentController.league_selected_tableCell_DataArrayTag removeAllObjects];
        for (int i = 0; i < count; i++)
        {
            [self.BJDC_parentController.league_selected_tableCell_DataArrayTag addObject:[m_selectedLeagueArrayTag objectAtIndex:i]];
        }
        [self.BJDC_parentController parserData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//指定有多少个分区（section） 默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//指定每个分区中有多少行，默认为1 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_SectionN[section];
    
}

//创建 uitableview的 header
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundColor:[UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")]];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    //0 隐藏 1-- 展开
 
    if(section == 0)
    {
        if (m_leagueHeaderButtonSelect)
        {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"jclq_sectionlistexpand.png"];
            [button addSubview:image];
            [image release];
        }
        else
        {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"jclq_sectionlisthide.png"];
            [button addSubview:image];
            [image release];
        }
        [button setTitle:@"联赛选择" forState:UIControlStateNormal];  
    }
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    
    return button;
}
- (void)pressTitle:(id)sender
{
	UIButton *temp = (UIButton *)sender;
	int temptag = temp.tag;
 
    if(temptag == 0)
    {
        m_leagueHeaderButtonSelect = !m_leagueHeaderButtonSelect;
        if (m_leagueHeaderButtonSelect)
        {
            m_SectionN[0] = 1;
            
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateNormal];
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateHighlighted]; 
        }
        else 
        {
            m_SectionN[0] = 0;
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlisthide.png"] forState:UIControlStateNormal]; 
            [temp setBackgroundImage:[UIImage imageNamed:@"jclq_sectionlistexpand.png"] forState:UIControlStateHighlighted]; 
        }
        
    }
    
    [m_tableView reloadData];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"title";
}
//绘制cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    static NSString *groupCell = @"groupCell00";
    JC_LeagueTableCell *cell = (JC_LeagueTableCell*)[tableView dequeueReusableCellWithIdentifier:groupCell];
    if(cell == nil)
    {
        cell = [[[JC_LeagueTableCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupCell]autorelease];
        cell.tag = indexPath.section + indexPath.row;
    }
    cell.parentDelete = self;
    if (1 == m_isJCLQView)
    {
        [cell.leagueArray removeAllObjects];
        for (int i = 0; i < [m_JCLQ_parentController.league_tableCell_DataArray count]; i++) 
        {
            [cell.leagueArray addObject:[m_JCLQ_parentController.league_tableCell_DataArray objectAtIndex:i]];
        }
        [cell.selectedLeagueArrayTag removeAllObjects];
        for (int i = 0; i < [m_JCLQ_parentController.league_selected_tableCell_DataArrayTag count]; i++) 
        {
            [cell.selectedLeagueArrayTag addObject:[m_JCLQ_parentController.league_selected_tableCell_DataArrayTag objectAtIndex:i]];
        }
        
    }
    else if (0 == m_isJCLQView)
    {
        [cell.leagueArray removeAllObjects];
        for (int i = 0; i < [m_JCZQ_parentController.league_tableCell_DataArray count]; i++) 
        {
            [cell.leagueArray addObject:[m_JCZQ_parentController.league_tableCell_DataArray objectAtIndex:i]];
        }
        [cell.selectedLeagueArrayTag removeAllObjects];
        for (int i = 0; i < [m_JCZQ_parentController.league_selected_tableCell_DataArrayTag count]; i++) 
        {
            [cell.selectedLeagueArrayTag addObject:[m_JCZQ_parentController.league_selected_tableCell_DataArrayTag objectAtIndex:i]];
        }
    }
    else
    {
        [cell.leagueArray removeAllObjects];
        for (int i = 0; i < [self.BJDC_parentController.league_tableCell_DataArray count]; i++)
        {
            [cell.leagueArray addObject:[self.BJDC_parentController.league_tableCell_DataArray objectAtIndex:i]];
        }
        [cell.selectedLeagueArrayTag removeAllObjects];
        for (int i = 0; i < [self.BJDC_parentController.league_selected_tableCell_DataArrayTag count]; i++)
        {
            [cell.selectedLeagueArrayTag addObject:[self.BJDC_parentController.league_selected_tableCell_DataArrayTag objectAtIndex:i]];
        }
    }
    [cell refreshTableCell];
    return cell;
 
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellHeight = 0;
    if (1 == m_isJCLQView)
    {
        int count = [m_JCLQ_parentController.league_tableCell_DataArray count];
        count = count % 2 == 0 ? count / 2 : count / 2 + 1;
        cellHeight = 50 * count;
    }
    else if (0 == m_isJCLQView)
    {
        int count = [m_JCZQ_parentController.league_tableCell_DataArray count];
        count = count % 2 == 0 ? count / 2 : count / 2 + 1;
        cellHeight = 50 * count;
    }
    else
    {
        int count = [self.BJDC_parentController.league_tableCell_DataArray count];
        count = count % 2 == 0 ? count / 2 : count / 2 + 1;
        cellHeight = 50 * count;
    }
    //重设 tableview 的高度
    self.tableView.contentSize = CGSizeMake(320, 450 + cellHeight);
 
    return cellHeight;
}
//header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//选中cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[m_tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void) appendSelectedLeagueTag:(NSString*)tag
{
    if (m_selectedLeagueArrayTag == nil)
    {
        m_selectedLeagueArrayTag = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [m_selectedLeagueArrayTag addObject:tag];
}

@end
