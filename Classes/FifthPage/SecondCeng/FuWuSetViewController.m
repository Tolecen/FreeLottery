//
//  FuWuSetViewController.m
//  RuYiCai
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FuWuSetViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "SBJsonParser.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define  SWITCH_WININFO       (0)
#define  SWITCH_WIN           (1)
#define  SWITCH_SUBS          (2)

#define  SWITCH_WININFO_PUSH  (3)
#define  SWITCH_WININFO_SMS   (4)

#define  SWITCH_WIN_PUSH      (5)
#define  SWITCH_WIN_SMS       (6)
    
#define  SWITCH_SUBS_PUSH     (7)
#define  SWITCH_SUBS_SMS      (8)
    
#define ButtonStartTag  (101)

@implementation FuWuSetViewController

@synthesize myTableView = m_myTableView;
@synthesize stateSwitchArr = m_stateSwitchArr;
@synthesize idSwitchArr = m_idSwitchArr;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryMessageSettingOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"messageSettingOK" object:nil];
    
    [m_myTableView release], m_myTableView = nil;
    [m_stateSwitchArr release], m_stateSwitchArr = nil;
    [m_idSwitchArr release],m_idSwitchArr = nil;
    [m_startStateArr release],m_startStateArr = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryMessageSettingOK:) name:@"queryMessageSettingOK" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageSettingOK:) name:@"messageSettingOK" object:nil];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    
//    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
//                                              initWithTitle:@"保存设置"
//                                              style:UIBarButtonItemStyleBordered
//                                              target:self
//                                              action:@selector(okClick)] autorelease];

    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"保存"];
    
    m_stateSwitchArr = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    m_idSwitchArr = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    
    [RuYiCaiNetworkManager sharedManager].netHelpCenterCenter = NET_QUERY_MESSAGE_SET ;
    [[RuYiCaiNetworkManager sharedManager] queryMessageSetting];
}

- (void)queryMessageSettingOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    NSDictionary* winInfoDic = [parserDict objectForKey:@"winInfo"];//开奖提醒
    NSArray* winInfoArr = [winInfoDic objectForKey:@"sendChannels"];
    NSDictionary* winDic = [parserDict objectForKey:@"win"];//中奖提醒
    NSArray* winArr = [winDic objectForKey:@"sendChannels"];
    NSDictionary* subscribeDic = [parserDict objectForKey:@"subscribe"];//追号提醒
    NSArray* subscribeArr = [subscribeDic objectForKey:@"sendChannels"];
    if([[winInfoDic allKeys] count] == 0 || [[winDic allKeys] count] == 0 ||[[subscribeDic allKeys] count] == 0 )//防止没有数据的时候崩溃
    {
        return;
    }
    [self.idSwitchArr replaceObjectAtIndex:SWITCH_WININFO withObject:[winInfoDic objectForKey:@"id"]];
    [self.idSwitchArr replaceObjectAtIndex:SWITCH_WIN withObject:[winDic objectForKey:@"id"]];
    [self.idSwitchArr replaceObjectAtIndex:SWITCH_SUBS withObject:[subscribeDic objectForKey:@"id"]];
    
    [self.stateSwitchArr replaceObjectAtIndex:SWITCH_WININFO withObject:[winInfoDic objectForKey:@"needToSend"]];
    [self.stateSwitchArr replaceObjectAtIndex:SWITCH_WIN withObject:[winDic objectForKey:@"needToSend"]];
    [self.stateSwitchArr replaceObjectAtIndex:SWITCH_SUBS withObject:[subscribeDic objectForKey:@"needToSend"]];
    
    for (int i = 0; i < 3; i++)
    {
        NSArray*  allKeysArr_winInfor = [[winInfoArr objectAtIndex:i] allKeys];
        for(int j = 0; j < [allKeysArr_winInfor count]; j++)
        {
            if([[allKeysArr_winInfor objectAtIndex:j] isEqualToString:@"push"])
            {
                 [self.stateSwitchArr replaceObjectAtIndex:SWITCH_WININFO_PUSH withObject:[[winInfoArr objectAtIndex:i] objectForKey:@"push"]];
                [self.idSwitchArr replaceObjectAtIndex:SWITCH_WININFO_PUSH withObject:[[winInfoArr objectAtIndex:i] objectForKey:@"id"]];
            }
            else if([[allKeysArr_winInfor objectAtIndex:j] isEqualToString:@"sms"])
            {
                [self.stateSwitchArr replaceObjectAtIndex:SWITCH_WININFO_SMS withObject:[[winInfoArr objectAtIndex:i] objectForKey:@"sms"]];
                [self.idSwitchArr replaceObjectAtIndex:SWITCH_WININFO_SMS withObject:[[winInfoArr objectAtIndex:i] objectForKey:@"id"]];
            }
        }
        NSArray*  allKeysArr_win = [[winArr objectAtIndex:i] allKeys];
        for(int j = 0; j < [allKeysArr_win count]; j++)
        {
            if([[allKeysArr_win objectAtIndex:j] isEqualToString:@"push"])
            {
                [self.stateSwitchArr replaceObjectAtIndex:SWITCH_WIN_PUSH withObject:[[winArr objectAtIndex:i] objectForKey:@"push"]];
                [self.idSwitchArr replaceObjectAtIndex:SWITCH_WIN_PUSH withObject:[[winArr objectAtIndex:i] objectForKey:@"id"]];
            }
            else if([[allKeysArr_win objectAtIndex:j] isEqualToString:@"sms"])
            {
                [self.stateSwitchArr replaceObjectAtIndex:SWITCH_WIN_SMS withObject:[[winArr objectAtIndex:i] objectForKey:@"sms"]];
                [self.idSwitchArr replaceObjectAtIndex:SWITCH_WIN_SMS withObject:[[winArr objectAtIndex:i] objectForKey:@"id"]];
            }
        }
        NSArray*  allKeysArr_subs = [[subscribeArr objectAtIndex:i] allKeys];
        for(int j = 0; j < [allKeysArr_subs count]; j++)
        {
            if([[allKeysArr_subs objectAtIndex:j] isEqualToString:@"push"])
            {
                [self.stateSwitchArr replaceObjectAtIndex:SWITCH_SUBS_PUSH withObject:[[subscribeArr objectAtIndex:i] objectForKey:@"push"]];
                [self.idSwitchArr replaceObjectAtIndex:SWITCH_SUBS_PUSH withObject:[[subscribeArr objectAtIndex:i] objectForKey:@"id"]];
            }
            else if([[allKeysArr_subs objectAtIndex:j] isEqualToString:@"sms"])
            {
                [self.stateSwitchArr replaceObjectAtIndex:SWITCH_SUBS_SMS withObject:[[subscribeArr objectAtIndex:i] objectForKey:@"sms"]];
                [self.idSwitchArr replaceObjectAtIndex:SWITCH_SUBS_SMS withObject:[[subscribeArr objectAtIndex:i] objectForKey:@"id"]];
            }
        }
    }
    m_startStateArr = [self.stateSwitchArr copy];
    NSLog(@"m_startStateArr:%@", m_startStateArr);
    NSLog(@"stateSwitchArr:%@", self.stateSwitchArr);
    NSLog(@"idSwitchArr:%@", self.idSwitchArr);

    [self.myTableView reloadData];
}

- (void)okClick
{
    NSString* infoStr = [NSString stringWithFormat:@"winInfo:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_WININFO], [self.idSwitchArr objectAtIndex:SWITCH_WININFO]];

    if([[self.stateSwitchArr objectAtIndex:SWITCH_WININFO] isEqualToString:@"1"])
    {
        if(![[self.stateSwitchArr objectAtIndex:SWITCH_WININFO_SMS] isEqualToString:[m_startStateArr objectAtIndex:SWITCH_WININFO_SMS]])
            infoStr = [infoStr stringByAppendingFormat:@"_sms:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_WININFO_SMS], [self.idSwitchArr objectAtIndex:SWITCH_WININFO_SMS]];
         if(![[self.stateSwitchArr objectAtIndex:SWITCH_WININFO_PUSH] isEqualToString:[m_startStateArr objectAtIndex:SWITCH_WININFO_PUSH]])
            infoStr = [infoStr stringByAppendingFormat:@"_push:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_WININFO_PUSH], [self.idSwitchArr objectAtIndex:SWITCH_WININFO_PUSH]];
    }
    infoStr = [infoStr stringByAppendingFormat:@"!win:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_WIN], [self.idSwitchArr objectAtIndex:SWITCH_WIN]];
    if([[self.stateSwitchArr objectAtIndex:SWITCH_WIN] isEqualToString:@"1"])
    {
         if(![[self.stateSwitchArr objectAtIndex:SWITCH_WIN_SMS] isEqualToString:[m_startStateArr objectAtIndex:SWITCH_WIN_SMS]])
             infoStr = [infoStr stringByAppendingFormat:@"_sms:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_WIN_SMS], [self.idSwitchArr objectAtIndex:SWITCH_WIN_SMS]];
         if(![[self.stateSwitchArr objectAtIndex:SWITCH_WIN_PUSH] isEqualToString:[m_startStateArr objectAtIndex:SWITCH_WIN_PUSH]])
             infoStr = [infoStr stringByAppendingFormat:@"_push:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_WIN_PUSH], [self.idSwitchArr objectAtIndex:SWITCH_WIN_PUSH]];
    }
    infoStr = [infoStr stringByAppendingFormat:@"!subscribe:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_SUBS], [self.idSwitchArr objectAtIndex:SWITCH_SUBS]];
    if([[self.stateSwitchArr objectAtIndex:SWITCH_SUBS] isEqualToString:@"1"])
    {
        if(![[self.stateSwitchArr objectAtIndex:SWITCH_SUBS_SMS] isEqualToString:[m_startStateArr objectAtIndex:SWITCH_SUBS_SMS]])
           infoStr = [infoStr stringByAppendingFormat:@"_sms:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_SUBS_SMS], [self.idSwitchArr objectAtIndex:SWITCH_SUBS_SMS]];
        if(![[self.stateSwitchArr objectAtIndex:SWITCH_SUBS_PUSH] isEqualToString:[m_startStateArr objectAtIndex:SWITCH_SUBS_PUSH]])
           infoStr = [infoStr stringByAppendingFormat:@"_push:%@:%@", [self.stateSwitchArr objectAtIndex:SWITCH_SUBS_PUSH], [self.idSwitchArr objectAtIndex:SWITCH_SUBS_PUSH]];
    }
    NSLog(@"infoStr~~ %@", infoStr);
    [RuYiCaiNetworkManager sharedManager].netHelpCenterCenter = NET_MESSAGE_SET ;
    [[RuYiCaiNetworkManager sharedManager] messageSetting:infoStr];
}

- (void)messageSettingOK:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressSwitch:(id)sender
{
	UISwitch *temp = (UISwitch *)sender;
	int temptag = temp.tag;
    UIButton*  tempButton = (UIButton*)[self.view viewWithTag:ButtonStartTag + temptag];
    if ([[self.stateSwitchArr objectAtIndex:temptag] isEqualToString:@"0"])
    {
        [self.stateSwitchArr replaceObjectAtIndex:temptag withObject:@"1"]; 
        [tempButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlistexpand.png") forState:UIControlStateNormal];
        [tempButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlisthide.png") forState:UIControlStateHighlighted];
    }
    else if([[self.stateSwitchArr objectAtIndex:temptag] isEqualToString:@"1"])
    {
        [self.stateSwitchArr replaceObjectAtIndex:temptag withObject:@"0"];
        [tempButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlisthide.png") forState:UIControlStateNormal];
        [tempButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlistexpand.png") forState:UIControlStateHighlighted];
    }
    [self.myTableView reloadData];
}


#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 47;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    [button setBackgroundColor:[UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")]];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = ButtonStartTag + section;
       
    //0 隐藏 1-- 展开
    UISwitch*  swith = [[UISwitch alloc] initWithFrame:CGRectMake(220, 17, 79, 27)];
    if([[self.stateSwitchArr objectAtIndex:section] isEqualToString:@"1"])
    {
        swith.on = YES;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 40)];
        image.image = [UIImage imageNamed:@"jclq_sectionlistexpand.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    else
    {
        swith.on = NO;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 40)];
        image.image = [UIImage imageNamed:@"jclq_sectionlisthide.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    swith.tag = section;
    [swith addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    [button addSubview:swith];
    [swith release];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.contentEdgeInsets = UIEdgeInsetsMake(10, 18, 0, 0);
    if(0 == section)
    {
        [button setTitle:@"开奖提醒" forState:UIControlStateNormal];
    }
    if(1 == section)
    {
        [button setTitle:@"中奖提醒" forState:UIControlStateNormal];
    }
    if(2 == section)
    {
        [button setTitle:@"追号提醒（追号剩3期时提醒）" forState:UIControlStateNormal];
    }
    return button;  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if([[self.stateSwitchArr objectAtIndex:section] isEqualToString:@"1"])
        return 2;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(0 == indexPath.row)
    {
        cell.textLabel.text = @"推送通知";
        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
        writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        [cell addSubview:writeImage];
        [writeImage release];
    }
    else if(1 == indexPath.row)
    {
        cell.textLabel.text = @"短信提醒";
    }
    
    UISwitch*  swith = [[UISwitch alloc] initWithFrame:CGRectMake(220, 12, 79, 27)];
    if([[self.stateSwitchArr objectAtIndex:(indexPath.row + 3) + indexPath.section * 2] isEqualToString:@"1"])
    {
        swith.on = YES;
    }
    else
    {
        swith.on = NO;
    }
    swith.tag = (indexPath.row + 3) + indexPath.section * 2;
    [swith addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:swith];
    [swith release];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
