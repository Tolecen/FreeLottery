//
//  SetLotShowViewController.m
//  RuYiCai
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SetLotShowViewController.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

#define SwitchStartTag   (212)

@implementation SetLotShowViewController

@synthesize lotArray= m_lotArray;
@synthesize stateSwitchArr = m_stateSwitchArr;
@synthesize showLotArray = m_showLotArray;

- (void)dealloc
{
    [m_myTableView release],m_myTableView = nil;
    
    [m_lotArray release],m_lotArray = nil;
    [m_stateSwitchArr release],m_stateSwitchArr = nil;
    
    if(m_showLotArray != nil)
        [m_showLotArray release],m_showLotArray = nil;
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:self.showLotArray forKey:kLotShowDicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];//同步

    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [AdaptationUtils adaptation:self];
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotShowDicKey];
//    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:kLotShowDicKey]);
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotShowDicKey];
         m_showLotArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        m_showLotArray = [[NSMutableArray alloc] initWithArray:mutableArr];
    }

    NSLog(@"retainCount %d", [m_showLotArray retainCount]);//? 2
   
    m_stateSwitchArr = [[NSMutableArray alloc] initWithCapacity:1];
    m_lotArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_openLotNum = 0;
    for(int i = 0; i < [self.showLotArray count]; i ++)
    {
        if([[[[self.showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            m_openLotNum++;
    }
    
    [self setRecordArray];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 350, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.editing = YES;
    m_myTableView.contentInset = UIEdgeInsetsMake(0, -30, 0, 0);
    [self.view addSubview:m_myTableView];
}

- (void)setRecordArray
{
    NSLog(@"setRecordArray$$$$ %@", self.showLotArray);
    for(int i = 0; i < [self.showLotArray count]; i ++)
    {
        if([[[[self.showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
        {
            [self.stateSwitchArr addObject:@"1"];
        }
        else
        {
            [self.stateSwitchArr addObject:@"0"];
        }
        [self.lotArray addObject:[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:[[[self.showLotArray objectAtIndex:i] allKeys] objectAtIndex:0]]];
    }
//    NSArray* lotArray = [NSArray arrayWithObjects:@"双色球", @"大乐透", @"福彩3D" ,@"时时彩", @"江西11选5", @"竞彩足球", @"广东11选5", @"十一运夺金", @"排列三", @"七乐彩",   @"22选5", @"排列五", @"七星彩", @"足彩", @"竞彩篮球", nil];
//    NSMutableSet *OneSet = [[NSMutableSet alloc] initWithCapacity:1];
//    [OneSet addObjectsFromArray:lotArray];
//    
//    NSMutableSet *TwoSet = [[NSMutableSet alloc] initWithCapacity:1];
//    [TwoSet addObjectsFromArray:self.lotArray];
//    
//    [OneSet minusSet:TwoSet];
//    [self.lotArray addObjectsFromArray:[OneSet allObjects]];
//    NSLog(@"%@", [OneSet allObjects]);
//    for(int k = 0; k < [[OneSet allObjects] count]; k++)
//    {
//        [self.stateSwitchArr addObject:@"0"];
//    }
}

- (void)pressSwitch:(id)sender
{
	UISwitch *temp = (UISwitch *)sender;
	int temptag = temp.tag - SwitchStartTag;
    NSLog(@"index %d", temptag);
    
    NSString* thisKey = [[[self.showLotArray objectAtIndex:temptag] allKeys] objectAtIndex:0];
    NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([[self.stateSwitchArr objectAtIndex:temptag] isEqualToString:@"0"])
    {
        [self.stateSwitchArr replaceObjectAtIndex:temptag withObject:@"1"]; 
        m_openLotNum += 1;
        
        [tempDict setObject:@"1" forKey:thisKey];
        [self.showLotArray replaceObjectAtIndex:temptag withObject:tempDict];
    }
    else
    {
        if(m_openLotNum == 1)
        {
            temp.on = YES;
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"至少要选择一种进行显示！" withTitle:@"提示" buttonTitle:@"确定"];
        }
        else
        {
            [self.stateSwitchArr replaceObjectAtIndex:temptag withObject:@"0"];
            m_openLotNum -= 1;
            
            [tempDict setObject:@"0" forKey:thisKey];
            [self.showLotArray replaceObjectAtIndex:temptag withObject:tempDict];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return LotCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.text = [self.lotArray objectAtIndex:indexPath.row];
    
    UISwitch*  swith = [[UISwitch alloc] initWithFrame:CGRectMake(215, 8, 79, 27)];
    if([[self.stateSwitchArr objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        swith.on = YES;
    }
    else
    {
        swith.on = NO;
    }
    swith.tag = SwitchStartTag + indexPath.row;
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleNone; 
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath != destinationIndexPath) 
    {
        id object = [self.lotArray objectAtIndex:sourceIndexPath.row];
        [object retain];
        [self.lotArray removeObjectAtIndex:sourceIndexPath.row];
        
        id stateObj = [self.stateSwitchArr objectAtIndex:sourceIndexPath.row];
        [stateObj retain];
        [self.stateSwitchArr removeObjectAtIndex:sourceIndexPath.row];
        
        id showLot = [self.showLotArray objectAtIndex:sourceIndexPath.row];
        [showLot retain];
        [self.showLotArray removeObjectAtIndex:sourceIndexPath.row];
        
        if (destinationIndexPath.row > [self.lotArray count]) 
        {
            [self.lotArray addObject:object];
            [self.stateSwitchArr addObject:stateObj];
            [self.showLotArray addObject:showLot];
        }
        else 
        {
            [self.lotArray insertObject:object atIndex:destinationIndexPath.row];
            [self.stateSwitchArr insertObject:stateObj atIndex:destinationIndexPath.row];
            [self.showLotArray insertObject:showLot atIndex:destinationIndexPath.row];
        }
        [showLot release];
        [object release];
        [stateObj release];
    }
}

//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    
//}

@end
