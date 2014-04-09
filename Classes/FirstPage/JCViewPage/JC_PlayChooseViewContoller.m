//
//  JCLQ_PlayChooseViewContoller.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "JC_PlayChooseViewContoller.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"

#import "JCZQ_PlayChooseViewCell.h"
#import "JCLQ_PlayChooseViewCell.h"
#import "ColorUtils.h"
 
@interface JC_PlayChooseViewContoller (internal)
- (void)setupNavigationBar;
- (void)selectButtonClick;

@end

@implementation JC_PlayChooseViewContoller

@synthesize  isJCLQView = m_isJCLQView;
@synthesize tableView = m_tableView;
@synthesize playChooseType = m_playChooseType;
@synthesize JCLQ_parentController = m_JCLQ_parentController;
@synthesize JCZQ_parentController = m_JCZQ_parentController;

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)dealloc
{
    NSTrace(); 
    [m_tableView release], m_tableView = nil;
 
    [m_rightTitleBarItem release], m_rightTitleBarItem = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
 

    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];

    m_tableView.delegate = self;
    m_tableView.dataSource = self;
//    m_tableView.backgroundColor = [UIColor redColor];
    //如果不希望响应select，那么就可以用下面的代码设置属性：
    m_tableView.allowsSelection=NO;
    
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#f5f5f5"];
    m_tableView.backgroundView = [[[UIView alloc]init] autorelease];
    m_tableView.backgroundColor  = [UIColor clearColor];
 
    m_SectionN[0] = 1;
    m_playTypeHeaderButtonSelect = YES;
 
//    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    [self.view addSubview:m_tableView];
    self.tableView.contentSize = CGSizeMake(320, 600);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectButtonClick) name:@"selectButtonClickPlay" object:nil];
 
}
- (void)setupNavigationBar
{
	m_rightTitleBarItem = [[UIBarButtonItem alloc]
                           initWithTitle:@"确定"
                           style:UIBarButtonItemStylePlain
                           target:self
                           action:@selector(selectButtonClick)];
    self.navigationItem.rightBarButtonItem = m_rightTitleBarItem;
    self.navigationItem.title = @"玩法筛选";
}

- (void)selectButtonClick
{
    if (m_isJCLQView)
    {
        [m_JCLQ_parentController clearAllChoose];
        m_JCLQ_parentController.playTypeTag = m_playChooseType;
        /*
         注：
         单关 首次点击 要连网 获取数据
         */
        [m_JCLQ_parentController comeBackFromChooseView];
    }
    else
    {
        [m_JCZQ_parentController clearAllChoose];
        m_JCLQ_parentController.playTypeTag = m_playChooseType;
        [m_JCZQ_parentController comeBackFromChooseView];
    }

//    [self.navigationController popViewControllerAnimated:YES];
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
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section;
    //0 隐藏 1-- 展开
    if (section == 0)
    {
        if (m_playTypeHeaderButtonSelect)
        {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"shrink_back_ground_image.png"];
            [button addSubview:image];
            [image release];
            
            
            UIImageView *upImagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up_detile.png"]];
            upImagView.frame = CGRectMake(300-20,12, 46/2,47/2);
            [button addSubview:upImagView];
            [upImagView release];
        }
        else
        {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 0, 302, 40)];
            image.image = [UIImage imageNamed:@"shrink_back_ground_image.png"];
            [button addSubview:image];
            [image release];
            
            UIImageView *downImagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_detile.png"]];
            downImagView.frame = CGRectMake(300-20,12, 46/2,47/2);
            [button addSubview:downImagView];
            [downImagView release];
        }
        [button setTitle:@"玩法选择" forState:UIControlStateNormal];  
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
    
    if (temptag == 0)
    {
        m_playTypeHeaderButtonSelect = !m_playTypeHeaderButtonSelect;
        if (m_playTypeHeaderButtonSelect)
        {
            m_SectionN[0] = 1;
            
            [temp setBackgroundImage:[UIImage imageNamed:@"shrink_back_ground_image.png"] forState:UIControlStateNormal];
            [temp setBackgroundImage:[UIImage imageNamed:@"shrink_back_ground_image.png"] forState:UIControlStateHighlighted];
        }
        else
        {
            m_SectionN[0] = 0;
            [temp setBackgroundImage:[UIImage imageNamed:@"shrink_back_ground_image.png"] forState:UIControlStateNormal]; 
            [temp setBackgroundImage:[UIImage imageNamed:@"shrink_back_ground_image.png"] forState:UIControlStateHighlighted];
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
    if (indexPath.section == 0)
    {
        if (m_isJCLQView)
        {
            static NSString *groupCell = @"groupCell";
            JCLQ_PlayChooseViewCell *cell = (JCLQ_PlayChooseViewCell*)[tableView dequeueReusableCellWithIdentifier:groupCell];
            if(cell == nil)
            {
                cell = [[[JCLQ_PlayChooseViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupCell]autorelease];
                
                cell.tag = indexPath.section + indexPath.row;
            }         
            cell.parentController = self;
            cell.SFTitle = @"过关投注";
            cell.LetPointTitle = @"过关投注";
            cell.SFCTitle = @"过关投注";
            cell.BigAndSmallTitle = @"过关投注";
            
            cell.SFTitle_DanGuan = @"单关投注";
            cell.LetPointTitle_DanGuan = @"单关投注";
            cell.SFCTitle_DanGuan = @"单关投注";
            cell.BigAndSmallTitle_DanGuan = @"单关投注";
            cell.PlayTypeTag = m_playChooseType;
            [cell RefreshCellView];
            return cell;
        }
        else
        {
            static NSString *groupCell = @"groupCell";
            JCZQ_PlayChooseViewCell *cell = (JCZQ_PlayChooseViewCell*)[tableView dequeueReusableCellWithIdentifier:groupCell];
            if(cell == nil)
            {
                cell = [[[JCZQ_PlayChooseViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupCell]autorelease];
                
                cell.tag = indexPath.section + indexPath.row;
            }
  
            cell.parentController = self;
//            cell.SFTitle = @"过关投注";
//            cell.LetPointTitle = @"过关投注";
//            cell.SFCTitle = @"过关投注";
//            cell.BigAndSmallTitle = @"过关投注";
            
//            cell.SFTitle_DanGuan = @"单关投注";
//            cell.LetPointTitle_DanGuan = @"单关投注";
//            cell.SFCTitle_DanGuan = @"单关投注";
//            cell.BigAndSmallTitle_DanGuan = @"单关投注";
            cell.PlayTypeTag = m_playChooseType;
            [cell RefreshCellView];
            cell.backgroundColor = [ColorUtils parseColorFromRGB:@"#f5f5f5"];
            return cell;
        }  
    }
    return nil;
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int cellHeight = 0;
    if (indexPath.section == 0)
    {
        cellHeight =  65 * 4 - 40;
    }
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
 
@end
