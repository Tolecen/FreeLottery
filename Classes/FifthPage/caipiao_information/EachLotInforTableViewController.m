//
//  EachLotInforTableViewController.m
//  RuYiCai
//
//  Created by  on 12-9-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EachLotInforTableViewController.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "NewsViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation EachLotInforTableViewController

@synthesize lotNo;
@synthesize typeIdArray = m_typeIdArray;

#pragma mark - View lifecycle

- (void)dealloc
{
    [m_typeIdArray release], m_typeIdArray = nil;
    
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
//        _scene = WXSceneSession;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    m_typeIdArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSLog(@"%@",self.lotNo);
//    [[RuYiCaiNetworkManager sharedManager] getInformation:2 withLotNo:self.lotNo];
    [[RuYiCaiNetworkManager sharedManager] getInformation:2 withLotNo:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInformationOK:) name:@"getInformationOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInformationContentOK:) name:@"getInformationContentOK" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInformationOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInformationContentOK" object:nil];
    
    [super viewWillDisappear:animated];    
}

- (void)getInformationOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].newsTitle];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"news"];

    if(0 == [dict count])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:[parserDict objectForKey:@"message"] withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    [self.typeIdArray removeAllObjects];
    for(int i = 0; i < [dict count]; i++)
    {
        [self.typeIdArray insertObject:[[dict objectAtIndex:i] objectForKey:@"newsId"] atIndex:i];
    }
    [self.tableView reloadData];
}

- (void)getInformationContentOK:(NSNotification *)notification
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    
    NewsViewController *newsContent = [[NewsViewController alloc] init];
    newsContent.delegate = self;
    [self.navigationController pushViewController:newsContent animated:YES];
    //[newsContent refreshView];
    [newsContent release];
}
-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    if ([strMsg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}
#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.typeIdArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].newsTitle];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"news"];
    
    cell.textLabel.text = [[dict objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setTextColor:[UIColor blackColor]];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger typeID = [[self.typeIdArray objectAtIndex:indexPath.row] intValue];
    
    [[RuYiCaiNetworkManager sharedManager] getInformationContent:typeID];
    [[self.tableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[UIColor redColor]];
}

@end
