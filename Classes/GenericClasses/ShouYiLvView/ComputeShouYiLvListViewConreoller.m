//
//  ComputeShouYiLvListViewConreoller.m
//  RuYiCai
//
//  Created by  on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ComputeShouYiLvListViewConreoller.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "SBJsonParser.h"
#import "ShouYiLvTableViewCell.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "Exchange2LotteryWithIntegrationViewController.h"

@implementation ComputeShouYiLvListViewConreoller

@synthesize myTableView = m_myTableView;
@synthesize dataArray = m_dataArray;
@synthesize description = m_description;
@synthesize startBatchCode = m_startBatchCode;
@synthesize batchNum;

- (void)dealloc
{
    [m_myTableView release], m_myTableView =nil;
    [m_dataArray release], m_dataArray = nil;
    [m_zhuiQiSwitch release];
    
    [m_bottomView release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betOutTime:) name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    m_bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 180, 320, 117)];
    [self.view addSubview:m_bottomView];
    
    m_dataArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 179)];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.rowHeight = 80;
    [self.view addSubview:m_myTableView];
    
    UIImageView*  switchbgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 57)];
    switchbgImage.image = RYCImageNamed(@"select_num_bg.png");
    [m_bottomView addSubview:switchbgImage];
    [switchbgImage release];

    UILabel* zhuiQiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 27)];
    zhuiQiLabel.text = @"中奖停止追期:";
    [zhuiQiLabel setTextColor:[UIColor blackColor]];
    zhuiQiLabel.textAlignment = UITextAlignmentLeft;
    zhuiQiLabel.backgroundColor = [UIColor clearColor];
    zhuiQiLabel.font = [UIFont systemFontOfSize:15];
    [m_bottomView addSubview:zhuiQiLabel];
    [zhuiQiLabel release];
    
    m_zhuiQiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(115, 5, 79, 27)];
    m_zhuiQiSwitch.on = YES;
    [m_bottomView addSubview:m_zhuiQiSwitch];
    
    UIImageView*  bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 57, 320, 60)];
    bottomImage.image = RYCImageNamed(@"title_bg.png");
    [m_bottomView addSubview:bottomImage];
    [bottomImage release];
    
    UIButton* buyButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 67, 170, 41)];
    [buyButton setTitle:@"购   买" forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setBackgroundImage:RYCImageNamed(@"button_bg_normal.png") forState:UIControlStateNormal];
    [buyButton setBackgroundImage:RYCImageNamed(@"button_bg_click.png") forState:UIControlStateHighlighted];
    [buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_bottomView addSubview:buyButton];
    [buyButton release];
    
    [self setData];
}

- (void)setData 
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    [self.dataArray removeAllObjects];
    NSArray* resultArr = [parserDict objectForKey:@"result"];
    [self.dataArray addObjectsFromArray:resultArr];
    
    [self.myTableView reloadData];
    
    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 300, 20)];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    detailLabel.text = [NSString stringWithFormat:@"您已选了 %@ 注，共 %d 彩豆", [RuYiCaiLotDetail sharedObject].zhuShuNum, [[[self.dataArray objectAtIndex:([self.dataArray count] - 1)] objectForKey:@"accumulatedInput"] intValue]/100*aas];
    [detailLabel setTextColor:[UIColor blackColor]];
    detailLabel.textAlignment = UITextAlignmentLeft;
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:15];
    [m_bottomView addSubview:detailLabel];
    [detailLabel release];
}

- (void)buyButtonClick:(id)sender
{
    if(m_zhuiQiSwitch.on)
    {
        [RuYiCaiLotDetail sharedObject].prizeend = @"1";
    }
    else
    {
        [RuYiCaiLotDetail sharedObject].prizeend = @"0";
    }
    [RuYiCaiLotDetail sharedObject].batchNum = self.batchNum;
//    [RuYiCaiLotDetail sharedObject].lotMulti = @"0";//不能传0
    
    if(self.startBatchCode)
      [RuYiCaiLotDetail sharedObject].batchCode = self.startBatchCode;
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"1" forKey:@"isBetAfterIssue"];
    [dict setObject:self.description forKey:@"description"];
    [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单倍总金额（多注投）

    [RuYiCaiLotDetail sharedObject].moreZuAmount = [[self.dataArray objectAtIndex:([self.dataArray count] - 1)] objectForKey:@"accumulatedInput"];
    
    [RuYiCaiLotDetail sharedObject].subscribeInfo = [self buildSubscribeInfo];

    [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
}

- (NSString*)buildSubscribeInfo
{
    NSString* tempStr = @"";
    for(int i = 0; i < [self.dataArray count]; i++)
    {
        NSInteger  curInput = [[[self.dataArray objectAtIndex:i] objectForKey:@"currentIssueInput"] intValue]/100;
        NSInteger curYield = [[[self.dataArray objectAtIndex:i] objectForKey:@"currentIssueYield"] intValue]/100;
        
        tempStr = [tempStr stringByAppendingFormat:@"%@,",[[self.dataArray objectAtIndex:i] objectForKey:@"batchCode"]];
        tempStr = [tempStr stringByAppendingFormat:@"%d,",curInput * 100];
        tempStr = [tempStr stringByAppendingFormat:@"%@,",[[self.dataArray objectAtIndex:i] objectForKey:@"lotMulti"]];
        tempStr = [tempStr stringByAppendingFormat:@"%d_", curInput];
        tempStr = [tempStr stringByAppendingFormat:@"%d_", curYield];
        tempStr = [tempStr stringByAppendingFormat:@"%@",[[self.dataArray objectAtIndex:i] objectForKey:@"yieldRate"]];
        if(i != ([self.dataArray count] - 1))
        {
            tempStr = [tempStr stringByAppendingString:@"!"];
        }
    }
    return tempStr;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ShouYiLvTableViewCell *cell = (ShouYiLvTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ShouYiLvTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*{"batchCode":"2012071101","lotMulti":"1","currentIssueInput":"200","currentIssueYield":"400","accumulatedInput":"200","accumulatedYield":"400","yieldRate":"200.00%"}*/
    cell.batchCodeStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"batchCode"];
    cell.lotMultiStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"lotMulti"];
    cell.currentIssueInputStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"currentIssueInput"];
    cell.currentIssueYieldStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"currentIssueYield"];
    cell.accumulatedInputStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"accumulatedInput"];
    cell.accumulatedYieldStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"accumulatedYield"];
    cell.yieldRateStr = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"yieldRate"];
    
    [cell refreshCell];
    return cell;
}

- (void)betCompleteOK:(NSNotification*)notification
{
    NSArray *viewControlelsArray = self.navigationController.viewControllers;
	int index = [viewControlelsArray count] - 3;
	
	UIViewController *viewController = [viewControlelsArray objectAtIndex:index];
	
    
    [self.navigationController popToViewController:viewController animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 投注期号过期处理
- (void)betOutTime:(NSNotification*)notification
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"期号已过期！" withTitle:@"提示" buttonTitle:@"确定"];
}


#pragma mark 投注余额不足处理
- (void)notEnoughMoney:(NSNotification*)notification
{
    UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:CaiJinDuiHuanTiShi
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
    //            [alterView addButtonWithTitle:@"直接支付"];
    [alterView addButtonWithTitle:@"免费兑换"];
    alterView.tag = 112;
    [alterView show];
    [alterView release];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(112 == alertView.tag)
    {
        if(1 == buttonIndex)//去充值
        {
            
//            Exchange2LotteryWithIntegrationViewController* viewController = [[Exchange2LotteryWithIntegrationViewController alloc] init];
//            viewController.isShowBackButton = YES;
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
            [RuYiCaiNetworkManager sharedManager].shouldTurnToAdWall = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
