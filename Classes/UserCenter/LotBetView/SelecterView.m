//
//  SelecterView.m
//  RuYiCai
//
//  Created by ruyicai on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelecterView.h"
 
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"
 
@interface SelecterView (internal)
- (void)setupNavigationBar;
- (void)selectButtonClick;
@end

@implementation SelecterView
 
@synthesize tableView = m_tableView;
 
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)dealloc
{
    NSTrace(); 
    [m_tableView release], m_tableView = nil;
    
    [m_rightTitleBarItem release], m_rightTitleBarItem = nil;
    [m_selectArrayTag release], m_selectArrayTag = nil;
    [m_selectArrayTitle release], m_selectArrayTitle = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [self setupNavigationBar];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-100) style:UITableViewStyleGrouped];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;

    m_selectedTag = 0;
 
    [self.view addSubview:m_tableView];
//    self.tableView.contentSize = CGSizeMake(320, 600);
    
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
    self.navigationItem.title = @"彩种筛选";
}

 
//指定有多少个分区（section） 默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//指定每个分区中有多少行，默认为1 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_selectCount;
    
}
 
//绘制cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupCell = @"groupCell00";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:groupCell];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupCell]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    if (indexPath.row == m_selectedTag) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.backgroundColor = [UIColor blueColor];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
//        cell.backgroundColor = [UIColor whiteColor];
    }
        

    cell.textLabel.textColor = [UIColor blackColor];
 
    cell.textLabel.text = [m_selectArrayTitle objectAtIndex:indexPath.row];
 
    return cell;
    
}
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 44;
}
 
//选中cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    UITableViewCell *oneCell = [tableView cellForRowAtIndexPath: indexPath];    
//    oneCell.accessoryType = UITableViewCellAccessoryCheckmark; 
//    oneCell.selected = YES;
    m_selectedTag = indexPath.row;
    
     
 // 
////	[m_tableView deselectRowAtIndexPath:indexPath animated:NO];/
    [m_tableView reloadData];
}

-(void) appendSelectArray:(NSString*)tag TITLE:(NSString*)title
{
    if (m_selectArrayTag == nil) {
        m_selectArrayTag = [[NSMutableArray alloc] initWithCapacity:2];
    }
    if (m_selectArrayTitle == nil) {
        m_selectArrayTitle = [[NSMutableArray alloc] initWithCapacity:2];
    }
    [m_selectArrayTag addObject:tag];
    [m_selectArrayTitle addObject:title];
    m_selectCount++;
}
 
- (void)selectButtonClick
{
    NSMutableDictionary* myDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [myDictionary setObject:self forKey:@"selectView"];
    [myDictionary setObject:[NSString stringWithString:[m_selectArrayTag objectAtIndex:m_selectedTag]] forKey:@"selectValue"];

    //消息在 willappear 中 创建
    if (_isUserEvent)
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPressEventUser" object:myDictionary];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectPressEvent" object:myDictionary];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
   

}

@end
