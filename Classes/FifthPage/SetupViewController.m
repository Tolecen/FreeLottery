//
//  SetupViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SetupViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RYCImageNamed.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "SwitchTableCell.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@interface SetupViewController (internal)

- (void)setupNavigationBarStatus;
 
@end

@implementation SetupViewController

@synthesize myTableView = m_myTableView;

- (void)dealloc 
{
 
    [m_myTableView release], m_myTableView = nil;
 
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    m_myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.backgroundColor = [UIColor clearColor];
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UILabel* warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 60, 300, 50)];
    warnLabel.text = @"提示：只能设置关闭自动登录，如需开启请到登录页面勾选“记住我的登录状态”并登录。";
    warnLabel.font = [UIFont systemFontOfSize:15.0f];
    warnLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:103.0/255.0 blue:106.0/255.0 alpha:1.0];
    warnLabel.backgroundColor = [UIColor clearColor];
    warnLabel.lineBreakMode = UILineBreakModeWordWrap;
    warnLabel.numberOfLines = 2;
    [self.myTableView addSubview:warnLabel];
    [warnLabel release];
}
 
 
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}
 

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
 
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *myIdentifier = @"MyIdentifier";
    SwitchTableCell *cell = (SwitchTableCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[SwitchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lableString = @"自动登录设置";
    [cell refreshData];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

 
@end
