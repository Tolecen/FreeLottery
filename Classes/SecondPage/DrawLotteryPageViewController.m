//
//  DrawLotteryPageViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawLotteryPageViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "LotteryInfoTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "LotteryAwardInfoViewController.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "JCLotteryView.h"
#import "ZCOpenLotteryViewController.h"
#import "InstantScoreViewController.h"
#import "AnimationTabView.h"
#import "UINavigationBarCustomBg.h"
#import "AdaptationUtils.h"

#define kButtonTag   1000

@interface DrawLotteryPageViewController ()
{
    @private
    NSMutableArray *_showArray;
}
@property (nonatomic, retain) NSMutableArray *showArray;
@end

@interface DrawLotteryPageViewController (internal)

- (void)loginClick;

- (void)querySampleNetOK:(NSNotification*)notification;
- (void)netFailed:(NSNotification*)notification;
 
@end

@implementation DrawLotteryPageViewController

@synthesize buttonStatuArr = m_buttonStatuArr;
@synthesize cellTitleArray = m_cellTitleArray;
@synthesize showArray = _showArray;
@synthesize jcType = m_jcType;

- (void)dealloc 
{
    
    [m_cellTitleArray release], m_cellTitleArray = nil;
    [m_buttonStatuArr release], m_buttonStatuArr = nil;
    [_showArray release],_showArray = nil;
    
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"开奖中心";
    [self.navigationController.navigationBar setBackground];
    m_cellTitleArray = [[NSMutableArray alloc] initWithCapacity:1];
  
	[self.tableView setRowHeight:90];	
	[self.tableView setBackgroundColor:[UIColor clearColor]];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [RuYiCaiNetworkManager sharedManager].secondViewController = self;
    
    m_cellCount = 0;
    
    //[[RuYiCaiNetworkManager sharedManager] getLotteryInformation];//走势图开奖号码
        
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"QueryLot" forKey:@"command"];
    [dict setObject:@"winInfo" forKey:@"type"];    
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOTTERY_INFOR;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:dict isShowProgress:YES];
}


- (void)setNewTableTitle
{
    [self.cellTitleArray removeAllObjects];
    
    m_cellCount = 0;
    
    NSMutableArray*  showLotArray = [NSMutableArray array];
    
     NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
    self.showArray = [NSMutableArray array];
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
        showLotArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        showLotArray = [[NSMutableArray alloc] initWithArray:mutableArr];
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].lotteryInfor];
        [jsonParser release];
       
    }

    for(int i = 0; i < [showLotArray count]; i ++)
    {
        if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
        {
            [self.showArray addObject:[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0]]];
            
        }
    }
    
    NSLog(@"开奖中心-showLotArray:%@",showLotArray);
    for(int i = 0; i < [showLotArray count]; i ++)
    {
        
        if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleSSQ])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleSSQ];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleFC3D])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleFC3D];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleDLT])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleDLT];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleSSC])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleSSC];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitle11X5])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitle11X5];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitleJCZQ])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitleJCZQ];
                m_cellCount ++;
            }
        }
        else if([[[[showLotArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:kLotTitle11YDJ])
        {
            if([[[[showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
            {
                [self.cellTitleArray addObject:kLotTitle11YDJ];
                m_cellCount ++;
            }
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setHidesBottomBarWhenPushed:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNewTableTitle];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    
    [[Custom_tabbar showTabBar] hideTabBar:NO];
    
    [[CommonRecordStatus commonRecordStatusManager] clearBetData];
}


#pragma mark -
#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return m_cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    LotteryInfoTableViewCell *cell = (LotteryInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[LotteryInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    }
    
    cell.backgroundColor = [UIColor clearColor];
//	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSUInteger row = indexPath.row;
    cell.superViewController = self;
    cell.lotTitle = [self.cellTitleArray objectAtIndex:row];
    if([cell.lotTitle isEqual: kLotTitleJCLQ] || [cell.lotTitle isEqual: kLotTitleJCZQ] || [cell.lotTitle isEqual: kLotTitleBJDC])
    {
        cell.batchCode = @"";
        cell.winNo = @"";
        cell.dateStr = @"";
        [cell refresh];
     
        return cell;
    }
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].lotteryInfor];
    [jsonParser release];

    NSDictionary* subDict = (NSDictionary*)[parserDict objectForKey:cell.lotTitle];
    
    if([[subDict allKeys] count] == 0)
    {
        NSArray *array01 = [[NSArray alloc] initWithObjects:@"",@"",@"", @"",nil];
        NSArray *array02 = [[NSArray alloc] initWithObjects:@"batchCode",@"winCode",@"openTime", @"tryCode", nil];
        subDict = [NSDictionary dictionaryWithObjects:array01 forKeys:array02 ];
        [array01 release];
        [array02 release];
    }
    
    cell.batchCode = [subDict objectForKey:@"batchCode"];
    cell.winNo = [subDict objectForKey:@"winCode"];
    cell.dateStr = [subDict objectForKey:@"openTime"];
    cell.tryCodeBatchCode = [subDict objectForKey:@"tryCodeBatchCode"];
    if([cell.lotTitle isEqual: kLotTitleFC3D])
    {
        cell.tryCode = [subDict objectForKey:@"tryCode"];
        
    }
    if([cell.lotTitle isEqual: kLotTitleNMK3])
    {
        cell.tryCode = [subDict objectForKey:@"sumValue"];
    }
    NSLog(@"--------lotTitle:%@,  batchCode:%@   winNO:%@", cell.lotTitle, cell.batchCode, cell.winNo);
    [cell refresh];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSString* lotTitle = [(LotteryInfoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] lotTitle];
    if([lotTitle isEqualToString:kLotTitleJCLQ])
    {
        return;
    }
    else if([lotTitle isEqualToString:kLotTitleJCZQ])
    {
        return;
    }
    else if([lotTitle isEqualToString:kLotTitleBJDC])
    {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    if([lotTitle isEqualToString:kLotTitleSFC])//足彩开奖
    {
        ZCOpenLotteryViewController* viewController = [[ZCOpenLotteryViewController alloc] init];
        viewController.isPushShow = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.animationTabView.selectButtonTag = 0;
        [viewController tabButtonChanged:nil];
        [viewController release];
        return;
    }
    
    NSString *batchCodeStr = [(LotteryInfoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] batchCode];
    NSLog(@"batchCodeStr %@", batchCodeStr);
        
    LotteryAwardInfoViewController* viewController = [[LotteryAwardInfoViewController alloc] init];
    viewController.delegate = self;
    viewController.isPushShow = YES;
    if([lotTitle isEqualToString:kLotTitleSSQ])
    {
//        [MobClick event:@"openPage_SSQ"];
        
        viewController.lotTitle = kLotTitleSSQ;
        viewController.lotNo = kLotNoSSQ;
        viewController.VRednumber = 33;//红球个数
        viewController.VBluenumber = 16;//篮球个数
    }
    else if([lotTitle isEqualToString:kLotTitleFC3D])
    {
        viewController.lotTitle = kLotTitleFC3D;
        viewController.lotNo = kLotNoFC3D;
        viewController.VRednumber = 30;
        viewController.VBluenumber = 0;
    }
    else if([lotTitle isEqualToString:kLotTitleDLT])
    {
        viewController.lotTitle = kLotTitleDLT;
        viewController.lotNo = kLotNoDLT;
        viewController.VRednumber = 35;
        viewController.VBluenumber = 12;
    }
    else if([lotTitle isEqualToString:kLotTitleSSC])
    {
        viewController.lotTitle = kLotTitleSSC;
        viewController.lotNo = kLotNoSSC;
        viewController.VRednumber = 50;
        viewController.VBluenumber = 0;
    }
   
    else if([lotTitle isEqualToString:kLotTitle11YDJ])
    {
        viewController.lotTitle = kLotTitle11YDJ;
        viewController.lotNo = kLotNo11YDJ;
        viewController.VRednumber = 11;
        viewController.VBluenumber = 0;
    }
    if(batchCodeStr)
        viewController.batchCode = batchCodeStr;
    else
        viewController.batchCode = @"";

    [self.navigationController pushViewController:viewController animated:YES];
    [viewController refreshLotteryAwardInfo];
        
    [viewController release];
}
- (void)JCCheckButtonSelected:(BOOL) isJclq
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    NSLog(@"JCCheckButtonSelected>>>>>>>>>>>>");
    JCLotteryView* viewController = [[JCLotteryView alloc] init];
    if (isJclq) {
        viewController.isJCLQ = TRUE;
        viewController.navigationItem.title = @"竞彩篮球开奖中心";
    }
    else
    {
        viewController.isJCLQ = FALSE;
        viewController.navigationItem.title = @"竞彩足球开奖中心";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)JCCheckButtonSelectedForType:(JCType) jcType
{
    
    JCLotteryView* viewController = [[JCLotteryView alloc] init];
    if (jcType == JC_LQ_TYPE) {
        viewController.isJCLQ = 1;
        viewController.navigationItem.title = @"竞彩篮球开奖中心";
    }
    else if(jcType == JC_ZQ_TYPE)
    {
        viewController.isJCLQ = 0;
        viewController.navigationItem.title = @"竞彩足球开奖中心";
    }
    else
    {
        viewController.isJCLQ = 2;
        viewController.navigationItem.title = @"北京单场开奖中心";
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)JCInstantScoreButtonSelected:(BOOL) isJclq
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    InstantScoreViewController* viewController = [[InstantScoreViewController alloc] init];
    viewController.navigationItem.title = @"即时比分";
    if (isJclq) {
        viewController.type = JCLQ;
        #ifndef KInstantScore_myGame
        viewController.userDefaultsTag = @"instantScore_JCLQ";
        #endif
        
    }
    else
    {
        viewController.type = JCZQ;
        #ifndef KInstantScore_myGame
        viewController.userDefaultsTag = @"instantScore_JCZQ";
        #endif
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
 
- (void)refresh 
{    
    //[[RuYiCaiNetworkManager sharedManager] getLotteryInformation];//走势图开奖号码

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"QueryLot" forKey:@"command"];
    [dict setObject:@"winInfo" forKey:@"type"];    
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOTTERY_INFOR;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:dict isShowProgress:YES];
}

- (void)querySampleNetOK:(NSNotification*)notification
{
	[self.tableView reloadData];
	[self setNewTableTitle];
	[self stopLoading];
}

- (void)netFailed:(NSNotification*)notification
{
	[self stopLoading];
}

#pragma mark - 
#pragma mark 显示微博界面的代理方法
- (void)doAuth
{
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"post_timeline";
    req.state = @"xxx";
    
    [WXApi sendReq:req];
}

-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}


- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

#pragma mark dingYue method
//- (void)dingYueButtonClick
//{
//    [[Custom_tabbar showTabBar] hideTabBar:YES];
//    [self setHidesBottomBarWhenPushed:YES];
//    
//    KaiJiangDingYueViewController* viewController = [[KaiJiangDingYueViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
//    viewController.navigationItem.title = @"开奖提醒设置";
//    [viewController release];
//}

@end
