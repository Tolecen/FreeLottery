//
//  RechargeViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RechargeViewController.h"
#import "BankCardPaymentViewController.h"
#import "PhoneCardPaymentViewController.h"
#import "AlipayPaymentViewController.h"
#import "ThirdPageTabelCellView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "UnionPayViewController.h"
#import "BaseHelpViewController.h"
#import "bankChargeViewController.h"
#import "LaKaLaChargeViewController.h"
#import "BankPaymentViewController.h"
#import "BackBarButtonItemUtils.h"
//#import "UmpayCreditCardVC.h"
#import "WealthTenpayVC.h"
#import "AdaptationUtils.h"


@interface RechargeViewController()
    

@property (nonatomic,retain) NSMutableArray *appShowArray;//app store需要显示的
@property (nonatomic,retain) NSMutableArray *allShowArray;//其他渠道 需要显示的


@end
@interface RechargeViewController (internal)

- (void)setTopView;
- (void)changeURLClick:(id)sender;
- (void)loginClick;
- (void)changeUserClick;
- (void)queryDNAOK:(NSNotification*)notification;
- (void)getUserCenterInfoOK:(NSNotification *)notification;

@end

@implementation RechargeViewController

@synthesize myTabelView = m_myTabelView;
@synthesize appShowArray;
@synthesize allShowArray;
@synthesize isHidePush    = m_isHidePush;
@synthesize isExpend      = _isExpend;
- (void)dealloc
{
    [m_myTabelView release], m_myTabelView = nil;
    
    [m_loginStatus release];
    [allShowArray release];
    self.lotNo = nil;
    
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    self.navigationItem.title = @"充值中心";
    
    
    

    _isExpend  = NO;
    m_didSelectRow = 0;
    cell_count = 7;
        
    m_myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64 )];
//    m_myTabelView.contentSize = CGSizeMake(320, 340);
    m_myTabelView.delegate = self;
    m_myTabelView.dataSource = self;
    m_myTabelView.rowHeight = 68;
    [m_myTabelView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:m_myTabelView];
	
//    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [RuYiCaiNetworkManager sharedManager].thirdViewController = self;
    
//    [self setTopView];
//    [self updateLoginStatus];
    [self getShowPayType];
}
//获取需要显示的充值方式
- (void)getShowPayType{
    NSMutableArray*  showPayArray = [NSMutableArray array];
    
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kPayStationShowKey];
    self.appShowArray = [NSMutableArray array];
    self.allShowArray = [NSMutableArray array];
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kPayStationShowKey];
        showPayArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        showPayArray = [[NSMutableArray alloc] initWithArray:mutableArr];
    }
    
    for (int i = 0; i<[showPayArray count]; i++) {
        NSMutableDictionary *showDic = [showPayArray objectAtIndex:i];
        [showDic objectForKey:@"keyStr"];
//        if (![[showDic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfSJCZK])
//        {
//            [self.appShowArray addObject:showDic];
//        }
        [self.allShowArray addObject:showDic];
        
    }

}
- (void)setTopView
{
    UIImageView* image_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    image_bg.image = RYCImageNamed(@"green_bg.png");
    [self.view addSubview:image_bg];
    
    [image_bg release];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    if([RuYiCaiOR91 isEqualToString:@"91"])
    {
        titleLabel.frame = CGRectMake(10, 0, 300, 50);
        titleLabel.text = @"登录“91全民免费彩”(                                  )用网银网上充值免手续费，支持更多银行。";
    }
    else if([RuYiCaiOR91 isEqualToString:@"RuYiCai"])
    {
        titleLabel.frame = CGRectMake(10, 0, 300, 50);
        titleLabel.text = @"登录“全民免费彩票”(                                       )用网银网上充值免手续费，支持更多银行。";
    }
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UIButton* URL_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if([RuYiCaiOR91 isEqualToString:@"91"])
    {
        URL_button.frame = CGRectMake(97 + 13, 5, 130, 25);
        [URL_button setTitle:@"http://91.ruyicai.com" forState:UIControlStateNormal];
    }
    else if([RuYiCaiOR91 isEqualToString:@"RuYiCai"])
    {
        URL_button.frame = CGRectMake(97 + 11, 5, 130 + 20, 25);
        [URL_button setTitle:@"http://www.ruyicai.com" forState:UIControlStateNormal];
    }
    URL_button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [URL_button setTitleColor:[UIColor colorWithRed:0 green:96.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [URL_button setBackgroundColor:[UIColor clearColor]];
    [URL_button addTarget:self action:@selector(changeURLClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:URL_button];
    
    UILabel   *lineLabel = [[UILabel alloc] init];
    if([RuYiCaiOR91 isEqualToString:@"91"])
    {
       lineLabel.frame = CGRectMake(0, 18, 130, 1);
    }
    else if([RuYiCaiOR91 isEqualToString:@"RuYiCai"])
    {
        lineLabel.frame = CGRectMake(0, 18, 130 + 20, 1);
    }
    [lineLabel setBackgroundColor:[UIColor colorWithRed:0 green:96.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [URL_button addSubview:lineLabel];
    [lineLabel release];
}

- (void)changeURLClick:(id)sender
{
    NSString* URL_Str = [(UIButton*)sender currentTitle];
    NSURL *URL = [NSURL URLWithString:URL_Str];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)updateLoginStatus
{
    if ([[RuYiCaiNetworkManager sharedManager] hasLogin])
    {

//        if([appStoreORnormal isEqualToString:@"appStore"] )
//        {
//            cell_count = [self.appShowArray count];
//            [self.myTabelView reloadData];   
//        }
//        else
//        {
            cell_count = [self.allShowArray count];
            [self.myTabelView reloadData];            
//        }
    }
    else
    {
//        m_loginStatus.text = @"尚未登录";
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryDNAOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUserCenterInfoOK" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Custom_tabbar showTabBar]hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDNAOK:) name:@"queryDNAOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserCenterInfoOK:) name:@"getUserCenterInfoOK" object:nil];
    
    [self updateLoginStatus];
    
    [CommonRecordStatus commonRecordStatusManager].changeWay = 0;//普通充值
    
    if([appStoreORnormal isEqualToString:@"appStore"])//appstore充值前必需先登陆
    {
//        cell_count = [self.appShowArray count];
        if(![RuYiCaiNetworkManager sharedManager].hasLogin)
        {
            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        }
    }
    else if([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
       [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_BALANCE;
       [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
    }

    if([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] UpdateUserInfo];
    }
}

- (void)loginClick
{
    [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
}

- (void)changeUserClick
{
    [[RuYiCaiNetworkManager sharedManager] showChangeUserAlertView];
}


- (void)queryDNAOK:(NSNotification*)notification
{
        
        NSDictionary *dic = [self.allShowArray objectAtIndex:m_didSelectRow];
    
    if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfZFBAQ]){
        [self pushZFBAQ];
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfLDYS]){
        [self pushLDYS];
    }
    else if ([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfYL]) {
        [self pushYLCZ];
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfYLYY]){
        [self pushYLYY];
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfCFT]){
        [self pushCFT];
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfSJCZK]){
        [self pushSJCZK];
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfYHZZ]){
        [self pushYHZZ];
    }
    
}






#pragma mark -
#pragma mark TableView Delegate

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//	return UITableViewCellAccessoryDisclosureIndicator;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (_isExpend)
    {
        return cell_count;
    }else
    {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *cellIdentifier = @"cellIdentifier";	
	ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell)
		cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
        NSDictionary *dic = [self.allShowArray objectAtIndex:[indexPath row]];
        cell.titleName = [dic objectForKey:@"title"];
        cell.littleTitleName = [dic objectForKey:@"description"];
    
    if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfZFBAQ]){
        cell.iconImageName = @"zhifubao_safe_icon.png";
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfLDYS]){
        cell.iconImageName = @"recharge_ufpay.png";
    }
    else if ([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfYL]) {
        cell.iconImageName = @"union_pay_icon.png";
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfYLYY]){
        cell.iconImageName = @"pay_ecoc_icon.png";
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfCFT]){
        cell.iconImageName = @"cft_c_log.png";
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfSJCZK]){
        cell.iconImageName = @"ico_c_phone.png";
    }
    else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfYHZZ]){
        cell.iconImageName = @"ico_c_bank.png";
    }
//        else if([[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfZFBWAP]){
//            cell.iconImageName = @"zhifubao_wap_icon.png";
//        }
    
    [cell refresh];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_didSelectRow = [indexPath row];

        if ([RuYiCaiNetworkManager sharedManager].hasLogin)
        {
           
                
                NSDictionary *dic = [self.allShowArray objectAtIndex:m_didSelectRow];
                if ( [[dic objectForKey:@"keyStr"] isEqual:kPayStationKeyOfYLYY]) {
                    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_DNA;
                    [[RuYiCaiNetworkManager sharedManager] queryDNA];
                }else{
                    [self queryDNAOK:nil];
                }
            
        }
        else
        {
            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_DNA;
            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView  *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(113, 10, 94, 15);
    [footerButton setBackgroundImage:[UIImage imageNamed:@"recharge_gengduo.png"] forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(expendTableClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:footerButton];
    return footerView;
}

- (void)expendTableClick
{
    _isExpend = YES;
    [m_myTabelView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isExpend)
    {
        return 0;
    }else
    {
        return 40;
    }
}
- (void)getUserCenterInfoOK:(NSNotification *)notification{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].userCenterInfo];
    [jsonParser release];

}

-(void)pushSJCZK{
    PhoneCardPaymentViewController* viewController = [[PhoneCardPaymentViewController alloc] init];
    viewController.title = @"手机充值卡充值";
    [self.navigationController pushViewController:viewController animated:YES];
    
    [viewController release];
}

-(void)pushYHZZ{
    BankPaymentViewController *bankPaymentVC = [[BankPaymentViewController alloc]init];
    if (self.lotNo != nil) {
        bankPaymentVC.lotNo = kLotNoNMK3;
    }
    bankPaymentVC.title = @"银行转账";
    [self.navigationController pushViewController:bankPaymentVC animated:YES];
    [bankPaymentVC release];
}

-(void)pushYLCZ{
    UnionPayViewController *unionPayVC = [[UnionPayViewController alloc]init];
    if (self.lotNo != nil) {
        unionPayVC.lotNo = kLotNoNMK3;
    }
    unionPayVC.title = @"银联充值";
    [self.navigationController pushViewController:unionPayVC animated:YES];
    [unionPayVC release];
    
}

-(void)pushZFBWAP{
    AlipayPaymentViewController* viewController = [[AlipayPaymentViewController alloc] init];
    viewController.title = @"支付宝wap充值";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

-(void)pushCFT{
    WealthTenpayVC *wealthTenpayVC = [[WealthTenpayVC alloc]init];
    if (self.lotNo != nil) {
        wealthTenpayVC.lotNo = kLotNoNMK3;
    }
    wealthTenpayVC.title = @"财付通充值";
    [self.navigationController pushViewController:wealthTenpayVC animated:YES];
    [wealthTenpayVC release];
}
-(void)pushYLYY{
    BankCardPaymentViewController* viewController = [[BankCardPaymentViewController alloc] init];
    if (self.lotNo != nil) {
        viewController.lotNo = kLotNoNMK3;
    }
    viewController.navigationItem.title = @"易联语音支付";
    [self.navigationController pushViewController:viewController animated:YES];


}

@end
