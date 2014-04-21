//
//  MoreBetListViewController.m
//  RuYiCai
//
//  Created by  on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreBetListViewController.h"
#import "RuYiCaiLotDetail.h"
#import "RYCImageNamed.h"
#import "MoreBetListTableViewCell.h"
#import "SSQRandomTableViewCell.h"
#import "FC3DRandomTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCNormalBetView.h"
#import "RYCHighBetView.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface MoreBetListViewController (internal) 

- (void)setTopViewAndBottomView;
- (void)refreshLabelText;

- (void)clearAllButtonClick:(id)sender;
- (void)addOneZhuClick:(id)sender;
- (void)againSelectClick:(id)sender;
- (void)buyClick:(id)sender;

- (void)userLoginOK:(NSNotification*)notification;//登陆之后
- (void)betTypeSelect;

- (void)addSSQRandom;
- (void)addDLTRandom;
- (void)addFC3DRandom;
- (void)addSSCRandom;
- (void)add115Random;
- (void)addPLSRandom;
- (void)addPL5Random;
- (void)add11YDJRandom;
- (void)addCQ115Random;
- (void)addQXCRandom;
- (void)add22_5Random;
- (void)addQLCRandom;
- (void)addGD115Random;
- (void)addKLSFRandom;
- (void)addCQSFRandom;
- (void)addNMKSRandom;

@end


@implementation MoreBetListViewController

@synthesize myTableView = m_myTableView;
@synthesize zhuShu = m_zhuShu;
@synthesize allAmount = m_allAmount;

- (void)dealloc
{
    [m_myTableView release], m_myTableView = nil;
    [m_inforBetLabel release];
    [bottomView release];
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.zhuShu = 0;
    self.allAmount = 0;

    for(int i = 0; i < [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]; i++)
    {
        NSString*  zhuShuStr = [[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor objectAtIndex:i] objectForKey:MORE_ZHUSHU];
        NSString*  allAmountStr = [[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor objectAtIndex:i] objectForKey:MORE_AMOUNT];
        self.zhuShu += [zhuShuStr intValue];
        self.allAmount += [allAmountStr intValue]/100;
    }
    [self refreshLabelText];
    
    if(self.zhuShu == 0)
    {
//        UILabel* oneLabel = [[UILabel alloc] init];
//        self.navigationItem.rightBarButtonItem.customView = oneLabel;
//        [oneLabel release];
//        [self.navigationController popViewControllerAnimated:YES];
        [self.myTableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(editTableView:) andTitle:@"编辑"];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, [UIScreen mainScreen].bounds.size.height - 200)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor clearColor];
    //self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.myTableView.rowHeight = 50;
    [self.view addSubview:self.myTableView];
    
    [self setTopViewAndBottomView];
}
- (void)setTopViewAndBottomView
{
//    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    topBg.image = RYCImageNamed(@"more_list_top_bg.png");
//    [self.view addSubview:topBg];
//    [topBg release];
//    
    UIButton* clearAllButton = [[UIButton alloc] initWithFrame:CGRectMake(27, 8, 133, 30)];
    [clearAllButton setBackgroundImage:RYCImageNamed(@"clean_list_normal.png") forState:UIControlStateNormal];
    [clearAllButton setBackgroundImage:RYCImageNamed(@"clean_list_click.png") forState:UIControlStateHighlighted];
    [clearAllButton addTarget:self action:@selector(clearAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearAllButton];
    [clearAllButton release];
    
    UIButton* addOneZhuButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 8, 133, 30)];
    [addOneZhuButton setBackgroundImage:RYCImageNamed(@"add_to_list_normal.png") forState:UIControlStateNormal];
    [addOneZhuButton setBackgroundImage:RYCImageNamed(@"add_to_list_click.png") forState:UIControlStateHighlighted];
    [addOneZhuButton addTarget:self action:@selector(addOneZhuClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addOneZhuButton];
    [addOneZhuButton release];
    
    bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, 320, 100)];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:bottomView];
    
    UIImageView* listInforBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    listInforBg.image = RYCImageNamed(@"select_num_bg.png");
    [bottomView addSubview:listInforBg];
    [listInforBg release];
    
    
    m_inforBetLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 30)];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    m_inforBetLabel.text = [NSString stringWithFormat:@"已选：共%d注 ，共%d彩豆", self.zhuShu, self.allAmount*aas];
    m_inforBetLabel.backgroundColor = [UIColor clearColor];
    m_inforBetLabel.font = [UIFont systemFontOfSize:14];
    m_inforBetLabel.textColor = [UIColor blackColor];
    [bottomView addSubview:m_inforBetLabel];
    
    UIImageView* bottomBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 320, 84)];
    bottomBg.image = RYCImageNamed(@"title_bg.png");
    [bottomView addSubview:bottomBg];
    [bottomBg release];

    UIButton* againButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 37, 134, 41)];
    [againButton setBackgroundImage:RYCImageNamed(@"button_bg_normal.png") forState:UIControlStateNormal];
    [againButton setBackgroundImage:RYCImageNamed(@"button_bg_click.png") forState:UIControlStateHighlighted];
    [againButton setTitle:@"继续选号" forState:UIControlStateNormal];
    [againButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    againButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [againButton addTarget:self action:@selector(againSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:againButton];
    [againButton release];
    
    UIButton* buyButton = [[UIButton alloc] initWithFrame:CGRectMake(176, 37, 134, 41)];
    [buyButton setBackgroundImage:RYCImageNamed(@"button_bg_normal.png") forState:UIControlStateNormal];
    [buyButton setBackgroundImage:RYCImageNamed(@"button_bg_click.png") forState:UIControlStateHighlighted];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [buyButton addTarget:self action:@selector(buyClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyButton];
    [buyButton release];
}

- (void)clearAllButtonClick:(id)sender
{
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeAllObjects];
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeAllObjects];
    
    [self.myTableView reloadData];
    
    self.zhuShu = 0;
    self.allAmount = 0;
    [self refreshLabelText];
}

- (void)addOneZhuClick:(id)sender
{
    if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoSSQ])
    {
        [self addSSQRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoDLT])
    {
        [self addDLTRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoFC3D])
    {
        [self addFC3DRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoSSC])
    {
        [self addSSCRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNo115])
    {
        [self add115Random];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoPLS])
    {
        [self addPLSRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoPL5])
    {
        [self addPL5Random];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNo11YDJ])
    {
        [self add11YDJRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoQXC])
    {
        [self addQXCRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNo22_5])
    {
        [self add22_5Random];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoQLC])
    {
        [self addQLCRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoGD115])
    {
        [self addGD115Random];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoKLSF])
    {
        [self addKLSFRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoCQSF])
    {
        [self addCQSFRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoNMK3])
    {
        [self addNMKSRandom];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString: kLotNoCQ115])
    {
        [self addCQ115Random];
    }
        
    self.zhuShu += 1;
    self.allAmount += 2;
    [self refreshLabelText];
    
    [self.myTableView reloadData];
}

- (void)againSelectClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buyClick:(id)sender
{
    if (0 == [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一注进行投注" withTitle:@"错误" buttonTitle:@"确定"];
        return;
    }
    [self userLoginOK:nil];
}

- (void)userLoginOK:(NSNotification*)notification
{
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", m_allAmount * 100];
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",m_zhuShu];
    
    [RuYiCaiLotDetail sharedObject].disBetCode = @"";
    for(int i = 0; i < [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]; i++)
    {
        [RuYiCaiLotDetail sharedObject].disBetCode = [[RuYiCaiLotDetail sharedObject].disBetCode stringByAppendingFormat:@"%@\n", [[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE]];
    } 
    if(m_allAmount > kMaxBetCost)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单个方案注数不能超过10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    [self betTypeSelect];
}

- (void)betTypeSelect
{
    [self setHidesBottomBarWhenPushed:YES];
    
    [RuYiCaiLotDetail sharedObject].sellWay = @"2";//表示多注投
    [RuYiCaiLotDetail sharedObject].isShouYiLv = NO;//没有收益率
    
    if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoSSQ] 
       || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoFC3D]
       || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoDLT]
       || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoQLC]
       || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoPLS]
       || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoPL5]
       || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoQXC]
       || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNo22_5]) 
    {
        RYCNormalBetView* viewController = [[RYCNormalBetView alloc] init];
        if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoSSQ])
            viewController.navigationItem.title = @"双色球投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoFC3D])
            viewController.navigationItem.title = @"福彩3D投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoDLT])
            viewController.navigationItem.title = @"大乐透投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoQLC])
            viewController.navigationItem.title = @"七乐彩投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoPLS])
            viewController.navigationItem.title = @"排列三投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoPL5])
            viewController.navigationItem.title = @"排列五投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoQXC])
            viewController.navigationItem.title = @"七星彩投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNo22_5])
            viewController.navigationItem.title = @"22选5投注";
     
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNo115]
            || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNo11YDJ]
            || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoSSC]
            || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoGD115]
            || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoCQ115]
            || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoKLSF]
            || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoNMK3] || [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoCQSF])
    {
        RYCHighBetView* viewController = [[RYCHighBetView alloc] init];
        if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNo115])
            viewController.navigationItem.title = @"江西11选5投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNo11YDJ])
            viewController.navigationItem.title = @"十一运夺金投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoCQ115])
            viewController.navigationItem.title = @"重庆11选5投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoGD115])
            viewController.navigationItem.title = @"广东11选5投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoSSC])
            viewController.navigationItem.title = @"时时彩投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoNMK3])
            viewController.navigationItem.title = @"快三投注";
        else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoCQSF])
            viewController.navigationItem.title = @"重庆快乐十分投注";
        else
            viewController.navigationItem.title = @"广东快乐十分投注";
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (void)refreshLabelText
{
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
     m_inforBetLabel.text = [NSString stringWithFormat:@"已选：共%d注 ，共%d彩豆", self.zhuShu, self.allAmount*aas];
}

- (void)editTableView:(id)sender
{
    if(self.myTableView.editing)
    {
        [self.myTableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    else
    {
        [self.myTableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleDelete; 
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        self.zhuShu = self.zhuShu - 
                               [[[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor 
                                     objectAtIndex:indexPath.row] objectForKey:MORE_ZHUSHU] intValue];
        self.allAmount = self.allAmount - [[[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor 
                                             objectAtIndex:indexPath.row] objectForKey:MORE_AMOUNT] intValue]/100;
        
	    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor removeObjectAtIndex:indexPath.row];
        [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor removeObjectAtIndex:indexPath.row];
	    [self.myTableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshLabelText];
	}   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    MoreBetListTableViewCell *cell = (MoreBetListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[MoreBetListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.betCodeStr = [[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor objectAtIndex:indexPath.row] objectForKey:MORE_BETCODE];
    NSString*  zhuShuStr = [[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor objectAtIndex:indexPath.row] objectForKey:MORE_ZHUSHU];
    NSString*  allAmountStr = [[[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor objectAtIndex:indexPath.row] objectForKey:MORE_AMOUNT];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    cell.inforStr = [zhuShuStr stringByAppendingFormat:@"注       %d彩豆", [allAmountStr intValue]/100*aas];
    [cell refreshCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 增加一注机选
- (void)addSSQRandom
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController setRedNum:6 inRedMax:33 andBlueNum:1 inBlueMax:16];
    
    NSString* startStr = [NSString stringWithFormat:@"%@", @"0001"];
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    betCode = [betCode stringByAppendingString:startStr];
    int nCount = [tempController.randomData count];
    for (int j = (nCount - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:(nCount - j - 1)] intValue] + 1;
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
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];  
    
    [tempController release];
}

- (void)addDLTRandom
{
    if(![RuYiCaiLotDetail sharedObject].isDLTOr11X2)
    {
        [RuYiCaiLotDetail sharedObject].isDLTOr11X2 = NO;
    }

    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController setRedNum:5 inRedMax:35 andBlueNum:2 inBlueMax:12];
    
    NSString* disBetCode = @"";
    NSString* betCode = @"";
  
    int nCount = [tempController.randomData count];
    for (int j = (nCount - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:(nCount - 1 - j)] intValue] + 1;
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
            disBetCode = [disBetCode stringByAppendingFormat:@"|%02d", nValue];
        else if (2 == j)
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
    }
    
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic]; 
    
    [tempController release];
}

- (void)addFC3DRandom
{
    FC3DRandomTableViewCell *tempController = [[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    [tempController setRedNum:3 inRedMax:10 dxds:NO];
    [tempController createDataWithStartNum:0 inRedMax:10 num:3 isSort:NO];
   
    NSString* disBetCode = @"";
    NSString* betCode = @"";
   
    int nCount = [tempController.randomData count];
    betCode = [betCode stringByAppendingString:@"0001"];
    for (int j = (nCount - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue];
        betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
        if (0 == j)
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%d|", nValue];
    }	
    
    betCode = [betCode stringByAppendingFormat:@"^"];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic]; 
    
    [tempController release];
}

- (void)addSSCRandom
{
    FC3DRandomTableViewCell *tempController = [[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    [tempController setRedNum:5 inRedMax:10 dxds:NO];
    [tempController createDataWithStartNum:0 inRedMax:10 num:5 isSort:NO];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    
    betCode  = [betCode stringByAppendingFormat:@"5D|"];
    int nRandom = [tempController.randomData count];
    for(int j = (nRandom - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue];
        if(0 == j)
        {						
            disBetCode = [disBetCode stringByAppendingFormat:@"%d",nValue];
            betCode = [betCode stringByAppendingFormat:@"%d",nValue];					
        }
        else
        {
            betCode = [betCode stringByAppendingFormat:@"%d,",nValue];					
            disBetCode = [disBetCode stringByAppendingFormat:@"%d,",nValue];
        }
    }

    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];

    [tempController release];
}

- (void)add115Random
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    tempController.isSort = YES;
    [tempController setRedNum:5 inRedMax:11 andBlueNum:0 inBlueMax:0];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";

    betCode = [betCode stringByAppendingFormat:@"R5|"];
    int nCount = [tempController.randomData count];
    for (int j = 0; j < nCount; j++)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue]+1;
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
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    
    [tempController release];
}

- (void)addPLSRandom
{
    FC3DRandomTableViewCell *tempController = [[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    [tempController setRedNum:3 inRedMax:10 dxds:NO];
    [tempController createDataWithStartNum:0 inRedMax:10 num:3 isSort:NO];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    
    int nCount = [tempController.randomData count];

    betCode = [betCode stringByAppendingFormat:@"1|"];
    for (int j = (nCount - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue];
        if (0 == j)
        {
            betCode = [betCode stringByAppendingFormat:@"%d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d", nValue];
        }
        else
        {
            betCode = [betCode stringByAppendingFormat:@"%d,", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%d|", nValue];
        }
    }
    [tempController release];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];  

}

- (void)addPL5Random
{
    FC3DRandomTableViewCell *tempController = [[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //[tempController setRedNum:5 inRedMax:10 dxds:NO];
    [tempController createDataWithStartNum:0 inRedMax:10 num:5 isSort:NO];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    
    int nRandom = [tempController.randomData count];
    for(int j = (nRandom - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue];
        if(0 == j)
        {						
            disBetCode = [disBetCode stringByAppendingFormat:@"%d",nValue];
            betCode = [betCode stringByAppendingFormat:@"%d",nValue];					
        }
        else
        {
            betCode = [betCode stringByAppendingFormat:@"%d,",nValue];					
            disBetCode = [disBetCode stringByAppendingFormat:@"%d,",nValue];
        }
    }
    [tempController release];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
}

- (void)add11YDJRandom
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    tempController.isSort = YES;
    [tempController setRedNum:5 inRedMax:11 andBlueNum:0 inBlueMax:0];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    
    betCode = [betCode stringByAppendingFormat:@"114@"];
    int nCount = [tempController.randomData count];
    for (int j = 0; j < nCount; j++)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue]+1;
        if ((nCount - 1) == j)
        {
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        }
        else
        {
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
    }
    betCode = [betCode stringByAppendingFormat:@"^"];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
   
    [tempController release];
}
- (void)addCQ115Random
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    tempController.isSort = YES;
    [tempController setRedNum:5 inRedMax:11 andBlueNum:0 inBlueMax:0];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    
    betCode = [betCode stringByAppendingFormat:@"114@"];
    int nCount = [tempController.randomData count];
    for (int j = 0; j < nCount; j++)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue]+1;
        if ((nCount - 1) == j)
        {
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        }
        else
        {
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
        }
    }
    betCode = [betCode stringByAppendingFormat:@"^"];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    
    [tempController release];
}

- (void)addQXCRandom
{
    FC3DRandomTableViewCell *tempController = [[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    [tempController setRedNum:7 inRedMax:10 dxds:NO];
    [tempController createDataWithStartNum:0 inRedMax:10 num:7 isSort:NO];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    
    int nRandom = [tempController.randomData count];
    for(int j = (nRandom - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue];
        if(0 == j)
        {						
            disBetCode = [disBetCode stringByAppendingFormat:@"%d",nValue];
            betCode = [betCode stringByAppendingFormat:@"%d",nValue];					
        }
        else
        {
            betCode = [betCode stringByAppendingFormat:@"%d,",nValue];					
            disBetCode = [disBetCode stringByAppendingFormat:@"%d,",nValue];
        }
    }
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    
    [tempController release];
}

- (void)add22_5Random
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController setRedNum:5 inRedMax:22 andBlueNum:0 inBlueMax:0];
    
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    betCode = [betCode stringByAppendingString:@"0@"];

    int nCount = [tempController.randomData count];
    for (int j = (nCount - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:(nCount - 1 - j)] intValue] + 1;
        if (0 == j)
            betCode = [betCode stringByAppendingFormat:@"%02d^", nValue];
        else
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
        
        if (0 == j)
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
    }
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic]; 
    
    [tempController release];
}

- (void)addQLCRandom
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController setRedNum:7 inRedMax:30 andBlueNum:0 inBlueMax:0];

    NSString* betCode = @"";
    NSString* disBetCode = @"";
    betCode = [betCode stringByAppendingString:@"0001"];
    int nCount = [tempController.randomData count];
    for (int j = (nCount - 1); j >= 0; j--)
    {
        int nValue = [[tempController.randomData objectAtIndex:(nCount - 1 - j)] intValue] + 1;
        if (0 == j)
            betCode = [betCode stringByAppendingFormat:@"%02d^", nValue];
        else
            betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
        
        if (0 == j)
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
    }
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic]; 
    
    [tempController release];
}

- (void)addGD115Random
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController setRedNum:5 inRedMax:11 andBlueNum:0 inBlueMax:0];

    NSString* betCode = @"S|R5|";
    NSString* disBetCode = @"";

    int nCount = [tempController.randomData count];
    for (int j = 0; j < nCount; j++)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue]+1;
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
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    
    [tempController release];
}

- (void)addCQSFRandom
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController setRedNum:5 inRedMax:20 andBlueNum:0 inBlueMax:0];
    
    NSString* betCode = @"S|R5|";
    NSString* disBetCode = @"";
    
    int nCount = [tempController.randomData count];
    for (int j = 0; j < nCount; j++)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue]+1;
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
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    
    [tempController release];
}


- (void)addKLSFRandom
{
    SSQRandomTableViewCell* tempController = [[SSQRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController setRedNum:5 inRedMax:20 andBlueNum:0 inBlueMax:0];
    
    NSString* betCode = @"S|R5|";
    NSString* disBetCode = @"";
    
    int nCount = [tempController.randomData count];
    for (int j = 0; j < nCount; j++)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue]+1;
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
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    
    [tempController release];
}

- (void)addNMKSRandom
{
    FC3DRandomTableViewCell *tempController = [[FC3DRandomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tempController createDataWithStartNum:1 inRedMax:7 num:3 isSort:YES];
    
    NSLog(@"%@", tempController.randomData);
    
    NSString* disBetCode = @"";
    NSString* betCode = @"";
    
    int nCount = [tempController.randomData count];
    //    int playType = 0;//3表示三同号单选 2表示二同号单选 1表示三不同号
    if (nCount == 3) {
        int oneNum = [[tempController.randomData objectAtIndex:0] intValue];
        int twoNum = [[tempController.randomData objectAtIndex:1] intValue];
        int thereNum = [[tempController.randomData objectAtIndex:2] intValue];
        if (oneNum == twoNum && twoNum == thereNum) {
            //            playType = 3;
            betCode = [betCode stringByAppendingString:@"020001"];
        }
        else if(oneNum == twoNum || twoNum == thereNum){
            //            playType = 2;
            betCode = [betCode stringByAppendingString:@"010001"];
        }
        else{
            //            playType = 1;
            betCode = [betCode stringByAppendingString:@"000001"];
        }
    }
    for (int j = 0; j < nCount; j++)
    {
        int nValue = [[tempController.randomData objectAtIndex:j] intValue];
        betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
        if ((nCount -1) == j)
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
    }
    betCode = [betCode stringByAppendingFormat:@"^"];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:betCode forKey:MORE_BETCODE];
    [tempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [tempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor addObject:tempDic];
    
    NSMutableDictionary* disTempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [disTempDic setObject:disBetCode forKey:MORE_BETCODE];
    [disTempDic setObject:@"1" forKey:MORE_ZHUSHU];
    [disTempDic setObject:@"200" forKey:MORE_AMOUNT];//以分为单位
    [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor addObject:disTempDic];
    
    [tempController release];
}
@end
