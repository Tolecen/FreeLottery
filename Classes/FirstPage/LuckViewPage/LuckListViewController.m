//
//  LuckListViewController.m
//  RuYiCai
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LuckListViewController.h"
#import "SSQRandomTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "FC3DRandomTableViewCell.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiLotDetail.h"
#import "RYCNormalBetView.h"
#import "RYCHighBetView.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation LuckListViewController

@synthesize m_randomNum;
@synthesize randomTableView = m_randomTableView;
@synthesize lotTitle = m_lotTitle;
@synthesize randomDataArray = m_randomDataArray;
@synthesize batchCode = m_batchCode;
@synthesize batchEndTime = m_batchEndTime;
@synthesize lotNo;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteRandomBallCell" object:nil];	

    [m_randomTableView release], m_randomTableView = nil;
    [m_randomDataArray release], m_randomDataArray = nil;
    [m_mainScrollView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:
     @"updateInformation" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRandomBallCell:) name:@"deleteRandomBallCell" object:nil];
    [BackBarButtonItemUtils addBackButtonForController:self];
        
    UIImageView* big_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"tz_c_list.png")];
    big_bg.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    [self.view addSubview:big_bg];
    [big_bg release];

    if (KISiPhone5)
    {
        m_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 480)/3-15, 320, 380)];
    }else
    {
        m_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 480)/3-25, 320, 380)];
    }
    m_mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_mainScrollView];

//    UIImageView* kit_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"luck_list.png")]; 
//    kit_bg.frame = CGRectMake(2, 3, 316, 410);
//    [m_mainScrollView addSubview:kit_bg];
//    [kit_bg release];
    
    m_randomDataArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    //CGRect tableFrame = CGRectMake(12, 27, 270, 400);

    if (KISiPhone5)
    {
        m_randomTableView = [[UITableView alloc] initWithFrame:CGRectMake(40, 60, 300, 330)];
    }else
    {
        m_randomTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 40, 300, 280)];
    }
    m_randomTableView.center = CGPointMake(140, 0);
    m_randomTableView.delegate = self;
    m_randomTableView.dataSource = self;
    m_randomTableView.backgroundColor = [UIColor clearColor];
    m_randomTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.randomTableView.rowHeight = kLuckBallHeight + 3;
    [m_mainScrollView addSubview:self.randomTableView];

    UIButton* oKButton = [[UIButton alloc] init];
    oKButton.frame = CGRectMake(23, [UIScreen mainScreen].bounds.size.height - 125, 553/2, 36);
    
    oKButton.backgroundColor =[UIColor clearColor];
    [oKButton setBackgroundImage:RYCImageNamed(@"tz_list_nomal.png") forState:UIControlStateNormal];
    [oKButton setBackgroundImage:RYCImageNamed(@"tz_list_click.png") forState:UIControlStateHighlighted];
    [oKButton addTarget:self action:@selector(OKButttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oKButton];
    [oKButton release];
    
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:self.lotNo];//获取期号
    
    [self listTableView];
}

//- (void)zhuiJiaButtonClick:(id)sender
//{
//    UIButton* tempButton = (UIButton*)sender;
//    if(!isZhuiJia)
//    {
//        [tempButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateNormal];
//        [tempButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateHighlighted]; 
//        isZhuiJia = YES;
//    }
//    else
//    {
//        [tempButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateNormal];
//        [tempButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateHighlighted]; 
//        isZhuiJia = NO;
//    }
//}

- (void)listTableView
{
    [UIView beginAnimations:@"movement" context:nil]; 
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    CGPoint center = self.randomTableView.center;
    center.y += 205;
    self.randomTableView.center = center;
    
    [UIView commitAnimations];
}

- (void)OKButttonClick
{
    [self submitLotNotification:nil];
}

- (void)updateInformation:(NSNotification*)notification
{
    self.batchCode = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    self.batchEndTime = [[RuYiCaiNetworkManager sharedManager] highFrequencyEndTime];
    [RuYiCaiLotDetail sharedObject].batchCode = self.batchCode;
    [RuYiCaiLotDetail sharedObject].batchEndTime = self.batchEndTime;
}

- (void)submitLotNotification:(NSNotification*)notification
{
    //显示你的订单详情，并生成投注信息
    NSString* disBetCode = @"";
    NSString* betCode = @"";
    if([self.lotTitle isEqualToString:kLotTitleSSQ])
    {
        NSString* startStr = [NSString stringWithFormat:@"%@", @"0001"];
        NSLog(@"m_randomNumm_randomNum%d",m_randomNum);
        for (int i = 0; i < m_randomNum; i++)
        {
            betCode = [betCode stringByAppendingString:startStr];
            NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
            NSLog(@"m_randomDataArraym_randomDataArray%@",m_randomDataArray);
            int nCount = [randomData count];
            for (int j = (nCount - 1); j >= 0; j--)
            {
                int nValue = [[randomData objectAtIndex:(nCount - j - 1)] intValue] + 1;
                if (0 == j)
                    betCode = [betCode stringByAppendingFormat:@"~%02d^", nValue];
                else
                    betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                
                if (0 == j)
                    disBetCode = [disBetCode stringByAppendingFormat:@"|%02d", nValue];
                else if (1 == j)
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
            }
            disBetCode = [disBetCode stringByAppendingFormat:@"\n"];
            if(i != m_randomNum - 1)
                betCode = [betCode stringByAppendingFormat:@";"];
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSQ;
    }
    else if([self.lotTitle isEqualToString:kLotTitleDLT])
    {
        for (int i = 0; i < m_randomNum; i++)
        {
            if (i > 0)
                betCode = [betCode stringByAppendingFormat:@";"];
            
            NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
            int nCount = [randomData count];
            for (int j = (nCount - 1); j >= 0; j--)
            {
                int nValue = [[randomData objectAtIndex:(nCount - 1 - j)] intValue] + 1;
                if (0 == j)
                    betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                else if (1 == j)
                    betCode = [betCode stringByAppendingFormat:@"-%02d ", nValue];
                else if (2 == j)
                    betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                else
                    betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
                
                if (0 == j)
                    disBetCode = [disBetCode stringByAppendingFormat:@",%02d", nValue];
                else if (1 == j)
                    disBetCode = [disBetCode stringByAppendingFormat:@" | %02d", nValue];
                else if (2 == j)
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
            }
            disBetCode = [disBetCode stringByAppendingFormat:@"\n"];
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoDLT;
    }
    else if([self.lotTitle isEqualToString:kLotTitleFC3D])
    {
        for (int i = 0; i < m_randomNum; i++)
        {
            NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
            int nCount = [randomData count];

            betCode = [betCode stringByAppendingString:@"0001"];
            for (int j = (nCount - 1); j >= 0; j--)
            {
                int nValue = [[randomData objectAtIndex:j] intValue];
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                if (0 == j)
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d\n", nValue];
                else
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d|", nValue];
            }	
            betCode = [betCode stringByAppendingFormat:@"^"];
            if(i != m_randomNum - 1)
                betCode = [betCode stringByAppendingFormat:@";"];
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoFC3D;
    }
    else if([self.lotTitle isEqualToString:kLotTitleSSC])
    {
        for(int i = 0; i < m_randomNum; i++)
        {
            NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
            betCode  = [betCode stringByAppendingString:@"3D|-,-,"];
            disBetCode = [disBetCode stringByAppendingString:@"-,-,"];
            int nRandom = [randomData count];
            for(int j = (nRandom - 1); j >= 0; j--)
            {
                int nValue = [[randomData objectAtIndex:j] intValue];
                if(0 == j)
                {						
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d \n",nValue];
                    betCode = [betCode stringByAppendingFormat:@"%d",nValue];					
                }
                else
                {
                    betCode = [betCode stringByAppendingFormat:@"%d,",nValue];					
                    disBetCode = [disBetCode stringByAppendingFormat:@"%d,",nValue];
                }
            }
            if(i != (m_randomNum-1))
            {
                betCode = [betCode stringByAppendingFormat:@";"];
            }
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSC;
    }
    else if([self.lotTitle isEqualToString:kLotTitle11X5])
    {
        for (int i = 0; i < m_randomNum; i++)
        {
            betCode = [betCode stringByAppendingFormat:@"R5|"];
            NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
            int nCount = [randomData count];
            for (int j = 0; j < nCount; j++)
            {
                int nValue = [[randomData objectAtIndex:j] intValue]+1;
                if ((nCount - 1) == j)
                {
					betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
					disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
				}
                else
				{
                    betCode = [betCode stringByAppendingFormat:@"%02d ", nValue];
				    disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
				}
			}
            if (i != (m_randomNum - 1))
            {
                betCode = [betCode stringByAppendingFormat:@";"];     
                disBetCode = [disBetCode stringByAppendingFormat:@" \n"];
            }
        }
        [RuYiCaiLotDetail sharedObject].lotNo = kLotNo115;
    }
    else if([self.lotTitle isEqualToString:kLotTitleGD115] || [self.lotTitle isEqualToString:kLotTitle11YDJ] || [self.lotTitle isEqualToString:kLotTitleKLSF]||[self.lotTitle isEqualToString:kLotTitleCQ11X5] )
    {
        for (int i = 0; i < m_randomNum; i++)
        {
            NSMutableArray* randomData = [m_randomDataArray objectAtIndex:i];
            int nCount = [randomData count];
            if([self.lotTitle isEqualToString:kLotTitleGD115])
                betCode = [betCode stringByAppendingFormat:@"S|R5|"];
            else if([self.lotTitle isEqualToString:kLotTitle11YDJ])
                betCode = [betCode stringByAppendingFormat:@"114@"];
            else if([self.lotTitle isEqualToString:kLotTitleGD115])
                betCode = [betCode stringByAppendingFormat:@"114@"];
            else 
                betCode = [betCode stringByAppendingString:@"S|R5|"];

            for (int j = 0; j < nCount; j++)
            {
                int nValue = [[randomData objectAtIndex:j] intValue]+1;
                betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
                if ((nCount - 1) == j)
                {
					disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
				}
                else
				{
				    disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
				}
			}
            if([self.lotTitle isEqualToString:kLotTitle11YDJ])
                 betCode = [betCode stringByAppendingFormat:@"^"];     
            if (i != (m_randomNum - 1))
            {
                betCode = [betCode stringByAppendingFormat:@";"];     
                disBetCode = [disBetCode stringByAppendingFormat:@"\n"];
            }
        }
        if([self.lotTitle isEqualToString:kLotTitleGD115])
            [RuYiCaiLotDetail sharedObject].lotNo = kLotNoGD115;
        else if([self.lotTitle isEqualToString:kLotTitle11YDJ])
            [RuYiCaiLotDetail sharedObject].lotNo = kLotNo11YDJ;
        else 
            [RuYiCaiLotDetail sharedObject].lotNo = kLotNoKLSF;
    }
  
    [RuYiCaiLotDetail sharedObject].sellWay = @"3";
	[RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_randomNum * 200];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_randomNum];
    //[[RuYiCaiNetworkManager sharedManager] showLotSubmitMessage:@"" withTitle:@"您的订单详情"];
    [self betNormal:nil];
}

#pragma mark betNormal
- (void)betNormal:(NSNotification*)notification
{
//    if(m_randomNum * 200 > kMaxBetCost)
//    {
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单个方案注数不能超过10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
//        return;
//    }
    [self setHidesBottomBarWhenPushed:YES];
    if([self.lotTitle isEqualToString:kLotTitleSSQ] || [self.lotTitle isEqualToString:kLotTitleDLT] || [self.lotTitle isEqualToString:kLotTitleFC3D])
    {
	  	RYCNormalBetView* viewController = [[RYCNormalBetView alloc] init];
        viewController.navigationItem.title = [NSString stringWithFormat:@"%@投注", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:self.lotTitle]];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else
    {
        if(m_randomNum == 1)
        {
            [RuYiCaiLotDetail sharedObject].isShouYiLv = YES;
        }
        else
        {
            [RuYiCaiLotDetail sharedObject].isShouYiLv = NO;
        }
        RYCHighBetView* viewController = [[RYCHighBetView alloc] init];
        viewController.navigationItem.title = [NSString stringWithFormat:@"%@投注", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:self.lotTitle]];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (void)deleteRandomBallCell:(NSNotification *)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        if (1 == m_randomNum)
            return;
        
        NSDictionary *dict = (NSDictionary*)obj;
        NSIndexPath *indexPath = [dict objectForKey:@"indexPath"];
        m_randomNum--;
        [self.randomTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [m_randomDataArray removeObjectAtIndex:indexPath.row];
        [self.randomTableView reloadData];
    }
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return m_randomNum;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
     if([self.lotTitle isEqualToString:kLotTitleSSQ] || [self.lotTitle isEqualToString:kLotTitleDLT] || [self.lotTitle isEqualToString:kLotTitle11X5] || [self.lotTitle isEqualToString:kLotTitleGD115] || [self.lotTitle isEqualToString:kLotTitle11YDJ] || [self.lotTitle isEqualToString:kLotTitleKLSF])
     {
         SSQRandomTableViewCell *cell = (SSQRandomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
            cell.isLuckView = YES;
            if([self.lotTitle isEqualToString:kLotTitleSSQ])
            {
                [cell setRedNum:6 inRedMax:33 andBlueNum:1 inBlueMax:16];
            }
            else if([self.lotTitle isEqualToString:kLotTitleDLT]) 
            {
                [cell setRedNum:5 inRedMax:35 andBlueNum:2 inBlueMax:12];
            }
            else if([self.lotTitle isEqualToString:kLotTitle11X5] || [self.lotTitle isEqualToString:kLotTitleGD115] || [self.lotTitle isEqualToString:kLotTitle11YDJ])
            {
                cell.isSort = YES;
                [cell setRedNum:5 inRedMax:11 andBlueNum:0 inBlueMax:0];
            }
            else
            {
                cell.isSort = YES;
                [cell setRedNum:5 inRedMax:20 andBlueNum:0 inBlueMax:0];
            }
            [m_randomDataArray addObject:cell.randomData];
        }
         cell.backgroundColor = [UIColor clearColor];
         cell.accessoryType = UITableViewCellAccessoryNone;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.backgroundColor = [UIColor clearColor];
         cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.indexPath = indexPath;
         self.randomTableView.separatorColor = [UIColor clearColor];
         self.randomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         return cell;
     }
    else
    {
        FC3DRandomTableViewCell *cell = (FC3DRandomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil)
        {
            cell = [[[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
            cell.isLuckView = YES;
            if([self.lotTitle isEqualToString:kLotTitleSSC])
                [cell setRedNum:3 inRedMax:10 dxds:NO];
            else
                [cell setRedNum:3 inRedMax:10 dxds:NO];
            [m_randomDataArray addObject:cell.randomData];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexPath = indexPath;
        self.randomTableView.separatorColor = [UIColor clearColor];
        self.randomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
