    //
//  QueryUserBalanceViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QueryUserBalanceViewController.h"
#import "RYCImageNamed.h"
#import "UserLotTrackDetailView.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface QueryUserBalanceViewController (internal)

- (void)refreshMySubViews;
- (void)queryUserBalanceOK:(NSNotification *)notification;

@end

@implementation QueryUserBalanceViewController

@synthesize balance = m_balance;
@synthesize drawBalance = m_drawBalance;
@synthesize betBalance = m_betBalance;
@synthesize freezeBalance = m_freezeBalance;

@synthesize myTableView = m_myTableView;

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];  
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryUserBalanceOK" object:nil];
}

- (void)dealloc 
{
    [m_myTableView release], m_myTableView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUserBalanceOK:) name:@"queryUserBalanceOK" object:nil];
    
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}
- (void)refreshMySubViews
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    self.balance = [parserDict objectForKey:@"balance"];
    self.drawBalance = [parserDict objectForKey:@"drawbalance"];
    self.betBalance = [parserDict objectForKey:@"bet_balance"];
    self.freezeBalance = [parserDict objectForKey:@"freezebalance"];
    [jsonParser release];
    
    [self.myTableView reloadData];
//    m_balanceLabel.text = [NSString stringWithFormat:@"总金额: %@", self.balance];
//    m_drawBalanceLabel.text = [NSString stringWithFormat:@"冻结金额: %@", self.freezeBalance];
//    m_betBalanceLabel.text = [NSString stringWithFormat:@"可投注金额: %@", self.betBalance];
//    m_freezeBalanceLabel.text = [NSString stringWithFormat:@"可提现金额: %@", self.drawBalance];
}

- (void)queryUserBalanceOK:(NSNotification *)notification
{
    [self refreshMySubViews];
}


#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return 4;
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
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(0 == indexPath.row)
    {
        cell.textLabel.text = @"总金额";
        cell.detailTextLabel.text = self.balance;
    }
    else if(1 == indexPath.row)
    {
        cell.textLabel.text = @"冻结金额";
        cell.detailTextLabel.text = self.freezeBalance;
    }
    else if(2 == indexPath.row)
    {
        cell.textLabel.text = @"可投注金额";
        cell.detailTextLabel.text = self.betBalance;
    }
    else
    {
        cell.textLabel.text = @"可提现金额";
        cell.detailTextLabel.text = self.drawBalance;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end