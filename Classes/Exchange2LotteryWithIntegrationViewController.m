//
//  ExchangeLotteryViewController.m
//  Boyacai
//
//  Created by fengyuting on 14-1-14.
//
//

#import "Exchange2LotteryWithIntegrationViewController.h"
#import "AdaptationUtils.h"
#import "UINavigationBarCustomBg.h"
#import "BackBarButtonItemUtils.h"
#import "ADWallViewController.h"
#import "RecommendViewController.h"
#import <objc/runtime.h>
@interface Exchange2LotteryWithIntegrationViewController ()

@end

@implementation Exchange2LotteryWithIntegrationViewController
@synthesize listTableV;
@synthesize adView_adWall;
@synthesize theUserID;
@synthesize shouldShowTabbar;
//@synthesize rtbAdWall;

-(void)didReceiveGetScoreResult:(int)point
{
    
}
-(void)offerWallDidFinishLoad
{
    
}
-(void)offerWallDidStartLoad
{
    
}
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess
{
    
}
-(void)offerWallDidFailLoadWithError:(NSError *)error
{
    
}
-(void)didReceiveOffers
{
    
}
-(void)didFailToReceiveOffers:(NSError *)error
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isShowBackButton = NO;
        self.shouldShowTabbar = NO;
        AdWallHaveInit = NO;
        previousUserno=@"";
        realAdwall = YES;
        adAdded = NO;
        ifhaveImportantInfo = NO;
//        titleArray = [[NSArray alloc] initWithObjects:@"美美换彩豆",@"米米换彩豆",@"点点换彩豆",@"易易换彩豆",@"多多换彩豆", nil];
        titleArray = [[NSArray alloc] init];
        realArray = [[NSArray alloc] initWithObjects:[self rr:@"免费获取彩豆入口1" De:@"免费获取彩豆入口1" ID:@"limei"],[self rr:@"免费获取彩豆入口2" De:@"免费获取彩豆入口2" ID:@"youmi"],[self rr:@"免费获取彩豆入口3" De:@"免费获取彩豆入口3" ID:@"dianru"],[self rr:@"免费获取彩豆入口4" De:@"免费获取彩豆入口4" ID:@"duomeng"],[self rr:@"免费获取彩豆入口5" De:@"免费获取彩豆入口5" ID:@"midi"], nil];
        
        notRealArray = [[NSArray alloc] initWithObjects:[self rr:@"幸运大转盘" De:@"免费获取彩豆入口1" ID:@"limei"],[self rr:@"每日送彩豆" De:@"免费获取彩豆入口1" ID:@"limei"],[self rr:@"更多精彩活动敬请期待" De:@"免费获取彩豆入口1" ID:@"limei"], nil];
        
        self.theUserID = [NSString stringWithFormat:@"%@_%@",[RuYiCaiNetworkManager sharedManager].userno,kRuYiCaiCoopid];
//        self.theUserID = @"00000866";
    }
    return self;
}
-(NSDictionary *)rr:(NSString *)theName De:(NSString *)theD ID:(NSString *)theID
{
    NSMutableDictionary * kk = [NSMutableDictionary dictionary];
    [kk setObject:theName forKey:@"name"];
    [kk setObject:theD forKey:@"description"];
    [kk setObject:theID forKey:@"code"];
    return kk;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryUserBalanceOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryADWallListOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryRemainingIDFAOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getAdwallImportantInfoOK" object:nil];
 
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        [bgv removeFromSuperview];
    }
    [super viewWillDisappear:animated];
    
}
-(void)regAnwoNoti
{
//    // 注册登录事件消息
//    AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_PRESENT, self, @selector(loginSelector));
    // 注册积分墙被关闭事件消息
    AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_DISMISS, self, @selector(dismissSelector));
    // 注册积分消费响应事件消息
//    AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_CONSUMEPOINTS_POINT, self, @selector(adwoOWConsumepoint));
//    // 注册积分墙刷新最新积分响应事件消息，使用分数的时候，开发者应该先刷新积分接口获得服务器的最新积分，再利用此分数进行相关操作
//    AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_REFRESH_POINT, self, @selector(adwoOWRefreshPoint));
//    // 注册积分墙刷新最新服务器响应事件消息
//    AdwoOWRegisterResponseEvent(ADWO_OFFER_WALL_SUMMARY_MESSAGE, self, @selector(adwoOWSummary));
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryADWallListOK:) name:@"queryADWallListOK" object:nil];
    [self.navigationController.navigationBar setBackground];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK:) name:@"loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUserBalanceOK:) name:@"queryUserBalanceOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRemainingIDFAOK:) name:@"queryRemainingIDFAOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toGetAdwallImportantInfoOK:) name:@"getAdwallImportantInfoOK" object:nil];
    
    //    self.theUserID = [RuYiCaiNetworkManager sharedManager].userno;
//    if([RuYiCaiNetworkManager sharedManager].hasLogin)
//    {
        if([RuYiCaiNetworkManager sharedManager].hasLogin)
        {
        self.theUserID = [NSString stringWithFormat:@"%@_%@",[RuYiCaiNetworkManager sharedManager].userno,kRuYiCaiCoopid];
        }
    else
        self.theUserID = @"notlog";
        if (![self.theUserID isEqualToString:previousUserno]) {
//            NSString * loginN = [RuYiCaiNetworkManager sharedManager].loginName;
            if (([appStoreORnormal isEqualToString:@"appStore"] &&
                 [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
                realAdwall = NO;
                titleArray = notRealArray;
                [self loadDisk];
            }
            else{
                realAdwall = YES;
                titleArray = realArray;
                

                [self YouMiInit];
                [self DianRuInit];
                [self DuoMengInit];
    //            [self EScoreWallInit];
                [self LiMeiAdWallInit];
                [self midiInit];
                [self AdviewAdWallInit];
            }
//            AdWallHaveInit = YES;
            previousUserno = [self.theUserID mutableCopy];
            [RuYiCaiNetworkManager sharedManager].requestedAdwallSuccess = NO;
            [[RuYiCaiNetworkManager sharedManager] queryADWallList];
        }
    else
    {
        
    }
    if (![RuYiCaiNetworkManager sharedManager].requestedAdwallSuccess) {
        [[RuYiCaiNetworkManager sharedManager] queryADWallList];
    }
    if (([appStoreORnormal isEqualToString:@"appStore"] &&
         [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
        recommendB.hidden = YES;
    }
    else
        recommendB.hidden = NO;
    
//        [[RuYiCaiNetworkManager sharedManager] UpdateUserInfo];
//        self.loginTopView.hidden = NO;
//        self.notLoginView.hidden = YES;
//        
//        [self setupNavigationBarStatus];
//    }
//    else
//    {
////        selectTableRow = nil;
////        AdWallHaveInit = NO;
//
//        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录呢，要想免费获取彩豆先去登录吧" delegate:self cancelButtonTitle:@"好的，去登录" otherButtonTitles: nil];
//        alert.tag = 101;
//        [alert show];
//        
////        self.loginTopView.hidden = YES;
////        self.notLoginView.hidden = NO;
//        //        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
//    }
    NSString * theV = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADWallExchangeScale"];
    exchangeScale = [[NSString stringWithFormat:@"(1注=%d彩豆)",2*[theV intValue]] mutableCopy];
    
    [self.listTableV reloadData];
/*
    NSDictionary * dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"101",@"id",@"zzzz中大奖了",@"title",@"prizeNoti",@"type", nil];
    NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"102",@"id",@"系统维护大约5个小时",@"title",@"sysNoti",@"type", nil];
    NSDictionary * dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"103",@"id",@"asdasddasd中大奖了",@"title",@"prizeNoti",@"type", nil];
    NSArray * ff = [NSArray arrayWithObjects:dict1,dict2,dict3, nil];
    NSDictionary * gg = [NSDictionary dictionaryWithObjectsAndKeys:ff,@"value",@"0000",@"error_code", nil];
    SBJsonWriter *jsonw = [SBJsonWriter new];
    NSString * hh = [jsonw stringWithObject:gg];
    NSLog(@"LISTBACK:%@",hh);
    
    
    NSDictionary * cont = [NSDictionary dictionaryWithObjectsAndKeys:@"有个人中过奖了和回复三等奖风口浪尖SD卡浪费就开始束带结发快乐健康了加贷款是附近快乐到死解放军的说法",@"content",@"sssss中奖了",@"title",@"101",@"id", nil];
    NSDictionary * gg2 = [NSDictionary dictionaryWithObjectsAndKeys:cont,@"value",@"0000",@"error_code", nil];
    SBJsonWriter *jsonw2 = [SBJsonWriter new];
    NSString * hh2 = [jsonw2 stringWithObject:gg2];
    NSLog(@"CONTENTBACK:%@",hh2);
    
    NSDictionary * cont2 = [NSDictionary dictionaryWithObjectsAndKeys:@"有个人中过奖了和回复三等奖风口浪尖SD卡浪费就开始束带结发快乐健康了加贷款是附近快乐到死解放军的说法",@"content",@"sssss中奖了",@"title",@"101",@"id",@"1",@"ifhave", nil];
    NSDictionary * gg3 = [NSDictionary dictionaryWithObjectsAndKeys:cont2,@"value",@"0000",@"error_code", nil];
//    NSLog(@"KAIJINOTIBACK:%@",gg3);
    SBJsonWriter *jsonw3 = [SBJsonWriter new];
    NSString * hh3 = [jsonw3 stringWithObject:gg3];
    NSLog(@"KAIJINOTIBACK:%@",hh3);
    
    
    NSDictionary * cont4 = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"ifhave", nil];
    NSDictionary * gg4 = [NSDictionary dictionaryWithObjectsAndKeys:cont4,@"value",@"0000",@"error_code", nil];
    SBJsonWriter *jsonw4 = [SBJsonWriter new];
    NSString * hh4 = [jsonw4 stringWithObject:gg4];
    NSLog(@"KAIJINOTIBACK:%@",hh4);
    
    */
//    if (self.shouldShowTabbar) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
//    }

}
-(void)toGetAdwallImportantInfoOK:(NSNotification *)noti
{
//    importInfoDict = [(NSDictionary *)noti.object retain];
    adwallInfoTitle = [[(NSDictionary *)noti.object objectForKey:@"title"] retain];
    [[NSUserDefaults standardUserDefaults] setObject:[(NSDictionary *)noti.object objectForKey:@"content"] forKey:@"adwallimportantinfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (([appStoreORnormal isEqualToString:@"appStore"] &&
        [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)){
        ifhaveImportantInfo = NO;
    }
    else
        ifhaveImportantInfo = YES;
    
    [self.listTableV reloadData];
}
-(void)queryRemainingIDFAOK:(NSNotification *)noti
{
    NSDictionary * parserDict = noti.object;
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    if ([errorCode isEqualToString:@"0000"])
	{
        NSString * v = [parserDict objectForKey:@"value"];
        int rv = [v intValue];
        if (rv==1) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"系统判定您设备识别符修改次数过多，有作弊刷积分嫌疑，现给予您警告，如果再有此行为，将进行封号处理，如果您确实有这么多设备，可以添加客服QQ为您处理" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else if (rv==0){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"检测到本账号有严重作弊行为（刷豆设备已达10个），已进行封号处理，如果有什么问题和特殊情况，您可以致电400-856-1000或者联系官方QQ2492831607咨询. 期待您对全面免费彩票更多的支持。" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        if (rv>=1) {
            if ([theAdwallID isEqualToString:@"limei"]) {
                [self enterLiMeiAdWall];
            }
            else if ([theAdwallID isEqualToString:@"youmi"]){
                [self showYouMiWall];
            }
            else if ([theAdwallID isEqualToString:@"dianru"]){
                [self showDianRuWall];
            }
            else if ([theAdwallID isEqualToString:@"duomeng"]){
                [self showDuoMengAdWall];
            }
            else if ([theAdwallID isEqualToString:@"midi"]){
                [self showMiidiAdWall];
            }
            else if ([theAdwallID isEqualToString:@"adview"]){
                [self showAdviewWall];
            }
            else if ([theAdwallID isEqualToString:@"anwo"]){
                [self showAnWoAdwall];
            }

        }
    }
    else if ([errorCode isEqualToString:@"1114"]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起，您还没有绑定手机号，不能进行积分兑换操作，请先绑定手机号操作，谢谢" delegate:self cancelButtonTitle:@"好的，去绑定" otherButtonTitles: nil];
        alert.tag = 22;
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络有点问题" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    [m_delegate.activityView disActivityView];
    
}
- (void)setUpBindPhone
{
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BIND_PHONE;
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}
-(void)queryADWallListOK:(NSNotification *)noti
{
    if (([appStoreORnormal isEqualToString:@"appStore"] &&
         [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
        realAdwall = NO;
        titleArray = notRealArray;
        [self loadDisk];
    }
    else
    {
        realAdwall = YES;
        titleArray = [(NSArray *)noti.object retain];

    }
    [RuYiCaiNetworkManager sharedManager].requestedAdwallSuccess = YES;
    [self.listTableV reloadData];

}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self getMyBalance];
}
-(void)loadDisk
{
    if (!adAdded) {
        adAdded = YES;
        [self creatiADView];
    }
    [self.listTableV reloadData];
}
-(void)getMyBalance
{
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_BALANCE;
    [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.shouldShowTabbar) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }
}
-(void)queryUserBalanceOK:(NSNotification *)notification
{
    [self.listTableV reloadData];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101) {
        if (buttonIndex==0) {
            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
            [[RuYiCaiNetworkManager sharedManager] showLoginAlertViewAndAddAnimation:NO];
        }
    }
    if (alertView.tag==22) {
        [self setUpBindPhone];
    }
}
-(void)loginOK:(NSNotification *)notification
{
    self.theUserID = [NSString stringWithFormat:@"%@_%@",[RuYiCaiNetworkManager sharedManager].userno,kRuYiCaiCoopid];
//    NSString * loginN = [RuYiCaiNetworkManager sharedManager].loginName;
    if (([appStoreORnormal isEqualToString:@"appStore"] &&
         [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
        realAdwall = NO;
        titleArray = notRealArray;
        [self loadDisk];
    }
    else{
        realAdwall = YES;
        titleArray = realArray;
        [self YouMiInit];
        [self DianRuInit];
        [self DuoMengInit];
        //            [self EScoreWallInit];
        [self LiMeiAdWallInit];
        [self midiInit];
        [self AdviewAdWallInit];
    }
    [[RuYiCaiNetworkManager sharedManager] queryADWallList];
    previousUserno = [self.theUserID mutableCopy];
    [self.listTableV reloadData];
}
-(void)dealloc
{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        [bgv2 removeFromSuperview];
//        [bgv2 release];
//    }
   AdwoOWUnregisterResponseEvents(ADWO_OFFER_WALL_RESPONSE_EVENTS_WALL_DISMISS);
    [self.rtbAdWall release];
    _offerWallController.delegate = nil;
    [_offerWallController release];
    _offerWallController = nil;
    self.adView_adWall.delegate = nil;
    [self.adView_adWall release];
    self.adView_adWall = nil;
//    [titleArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self regAnwoNoti];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    //    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    
    if (self.isShowBackButton) {
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(backAction:) andAutoPopView:NO];
        
    }
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [RuYiCaiNetworkManager sharedManager].thirdViewController = self;
    
    self.navigationItem.title = @"免费彩豆";
    //    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(backAction:) andAutoPopView:NO];
    //    self.navigationItem.title = @"积分换彩";

    float h = [UIScreen mainScreen].bounds.size.height;
    float tabbarH = 0;
    if (self.shouldShowTabbar) {
        tabbarH = 50;
    }
    else
        tabbarH = 0;
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, h-44-tabbarH-20) style:UITableViewStylePlain];
    if (self.shouldShowTabbar) {
    }
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.rowHeight = 68;
    [self.listTableV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.listTableV];
    
    recommendB = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendB.frame = CGRectMake(240,  h-126-tabbarH, 62, 62);
    [recommendB setBackgroundImage:[UIImage imageNamed:@"recommend"] forState:UIControlStateNormal];
    [self.view addSubview:recommendB];
    [recommendB addTarget:self action:@selector(goodRecommend) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, 40, 40)];
    [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonLogin setImage:RYCImageNamed(@"whatthat2.png") forState:UIControlStateNormal];
    [buttonLogin addTarget:self action:@selector(toIntroV) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * m_button_Login = [[UIBarButtonItem alloc] initWithCustomView:buttonLogin];
    [buttonLogin release];

    self.navigationController.navigationBar.topItem.rightBarButtonItem = m_button_Login;
    self.navigationItem.rightBarButtonItem = m_button_Login;
    [m_button_Login release];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:bgv2]) {
//            bgv2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//            [bgv2 setImage:[UIImage imageNamed:@"title_bg"]];
//            [[UIApplication sharedApplication].keyWindow addSubview:bgv2];
//        }
        bgv2 = (UIImageView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1111];

    }
    
    if (![RuYiCaiNetworkManager sharedManager].requestedAdwallSuccess) {
        [[RuYiCaiNetworkManager sharedManager] queryADWallList];
    }
    [[RuYiCaiNetworkManager sharedManager] getAdWallImportantInfo];

}
- (void)goodRecommend
{
    RecommendViewController * recommendVC = [[RecommendViewController alloc]init];
    [self.navigationController pushViewController:recommendVC animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    [recommendVC release];
}
-(void)toIntroV
{
    ADIntroduceViewController * inv = [[ADIntroduceViewController alloc] init];
    inv.theTextType = TextTypeAdIntro;
    inv.shouldShowTabbar = self.shouldShowTabbar;
    [self.navigationController pushViewController:inv animated:YES];
    [inv release];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(ifhaveImportantInfo)
    {
        return 2;
    }
    else
        return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return titleArray.count+1;
    }
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            static NSString *cellIdentifier = @"cellIdentifieradwall";
            AdWallTopCell* cell = (AdWallTopCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (nil == cell)
                cell = [[[AdWallTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            if (([appStoreORnormal isEqualToString:@"appStore"] &&
                 [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
                NSString * yy = [[RuYiCaiNetworkManager sharedManager] userLotPea];
                NSString * jiaMoney = [[NSUserDefaults standardUserDefaults] objectForKey:@"jiaMoney"];
                if (!jiaMoney) {
                    jiaMoney = @"0";
                }
                if([RuYiCaiNetworkManager sharedManager].hasLogin)
                {
                    cell.remainMoneyLabel.text = [NSString stringWithFormat:@"%.0f",[yy floatValue]+ [jiaMoney floatValue]];
                }
                else
                {
                    cell.remainMoneyLabel.text = @"点击登录查看";
                }
            }
            else
            {
                if([RuYiCaiNetworkManager sharedManager].hasLogin)
                {
                    cell.remainMoneyLabel.text = [[RuYiCaiNetworkManager sharedManager] userLotPea];
                }
                else
                {
                    cell.remainMoneyLabel.text = @"点击登录查看";
                }
            }
            cell.disLabel.text = @" ";
            return cell;
        }
        else{
            
            static NSString *cellIdentifier = @"cellIdentifier";
            ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (nil == cell)
                cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            cell.titleName = [titleArray[indexPath.row-1] objectForKey:@"name"];
            cell.littleTitleName = [titleArray[indexPath.row-1] objectForKey:@"description"];
            cell.iconImageName = [NSString stringWithFormat:@"rukou%d",indexPath.row];
            
            if (!realAdwall) {
                if (indexPath.row==1) {
                    cell.littleTitleName = @"大转盘抽奖获取相应彩豆";
                }
                else if (indexPath.row==2){
                    cell.littleTitleName = @"每日签到获取彩豆";
                }
            }
            
            [cell refresh];
            
            return cell;
        }

    }
    else
    {
        static NSString *cellIdentifier = @"cellIdentifierinfo";
        ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell)
            cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        cell.titleName = @"积分墙重要通知";
        cell.littleTitleName = adwallInfoTitle;
        cell.iconImageName = @"importantinfo";
        
        [cell refresh];
        
        return cell;

    }
}

-(void)enterADWALLWithID:(int)theIndex
{
    NSString * theID = [titleArray[theIndex] objectForKey:@"code"];
    theAdwallID = theID;
    [[RuYiCaiNetworkManager sharedManager] queryRemainingIDFA];
    [m_delegate.activityView activityViewShow];
    
//    NSString * theID = [titleArray[theIndex] objectForKey:@"code"];
//    theAdwallID = theID;
//    if ([theAdwallID isEqualToString:@"limei"]) {
//        [self enterLiMeiAdWall];
//    }
//    else if ([theAdwallID isEqualToString:@"youmi"]){
//        [self showYouMiWall];
//    }
//    else if ([theAdwallID isEqualToString:@"dianru"]){
//        [self showDianRuWall];
//    }
//    else if ([theAdwallID isEqualToString:@"duomeng"]){
//        [self showDuoMengAdWall];
//    }
//    else if ([theAdwallID isEqualToString:@"midi"]){
//        [self showMiidiAdWall];
//    }
//    else if ([theAdwallID isEqualToString:@"adview"]){
//        [self showAdviewWall];
//    }


    
/*********
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    [SFHFKeychainUtils storeUsername:CurrentIDFA andPassword:idfa forServiceName:CheckCheatStatus updateExisting:YES error:nil];
    NSString * lastIDFA = [SFHFKeychainUtils getPasswordForUsername:CurrentIDFA andServiceName:CheckCheatStatus error:nil];
    NSString * idfacount = [SFHFKeychainUtils getPasswordForUsername:IDFACount andServiceName:CheckCheatStatus error:nil];
    if (!lastIDFA) {
        lastIDFA = @"no";
    }
    int theCount = 0;
    if (idfacount) {
        theCount = [idfacount intValue];
    }
    if (![lastIDFA isEqualToString:idfa]) {
        theCount++;
    }
    [SFHFKeychainUtils storeUsername:IDFACount andPassword:[NSString stringWithFormat:@"%d",theCount] forServiceName:CheckCheatStatus updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:CurrentIDFA andPassword:idfa forServiceName:CheckCheatStatus updateExisting:YES error:nil];
    
    if (theCount>MaxAllowIDFACount) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到你有点作弊，先缓一缓吧，明天再说" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
 
 ********/
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
        [RuYiCaiNetworkManager sharedManager].goBackType = GO_GDSZ_TYPE;
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertViewAndAddAnimation:YES];
        return;
        
        
        
    }
    if (indexPath.section==0) {
        switch (indexPath.row) {
        case 0:
            {
                
                //            adWallV = [[ADWallViewController alloc] init];
                
                //            [self presentModalViewController:adWallV animated:YES];
                //            [adWallV release];
                ADIntroduceViewController * inv = [[ADIntroduceViewController alloc] init];
                inv.shouldShowTabbar = self.shouldShowTabbar;
                [self.navigationController pushViewController:inv animated:YES];
                [inv release];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
                
            }
            break;
        case 1:
            {
                
                //            adWallV = [[ADWallViewController alloc] init];
                
                //            [self presentModalViewController:adWallV animated:YES];
                //            [adWallV release];
                if (realAdwall) {
                    //                [self enterLiMeiAdWall];
                    [self enterADWALLWithID:indexPath.row-1];
                }
                else
                {
                    DiskViewController * diskV = [[DiskViewController alloc] init];
                    [self.navigationController pushViewController:diskV animated:YES];
                    [diskV release];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
                }
                
                
            }
            break;
        case 2:
            {
                
                //            adWallV = [[ADWallViewController alloc] init];
                
                //            [self presentModalViewController:adWallV animated:YES];
                //            [adWallV release];
                if (realAdwall) {
                    //                [self showYouMiWall];
                    [self enterADWALLWithID:indexPath.row-1];
                }
                else
                {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                    [self performSelector:@selector(QianDaoSuccess) withObject:nil afterDelay:1];
                    //                if([[RuYiCaiNetworkManager sharedManager] testConnection])
                    //                {
                    //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kRuYiCaiCharge]];
                    //                }
                }
                
                
            }
            break;
        case 3:
            {
                
                //            adWallV = [[ADWallViewController alloc] init];
                
                //            [self presentModalViewController:adWallV animated:YES];
                //            [adWallV release];
                
                if (realAdwall) {
                    //                [self showDianRuWall];
                    [self enterADWALLWithID:indexPath.row-1];
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更多获取彩豆的方法正在开发敬请期待" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
                
            }
            break;

//        case 4:
//            {
// 
//                [self enterADWALLWithID:indexPath.row-1];
//                
//            }
//            break;
//        case 5:
//            {
//  
//                [self enterADWALLWithID:indexPath.row-1];
// 
//                
//            }
//            break;
            
        default:
            {
                [self enterADWALLWithID:indexPath.row-1];
            }
            break;
        }
    }
    else
    {
        ADIntroduceViewController * inv = [[ADIntroduceViewController alloc] init];
        inv.shouldShowTabbar = self.shouldShowTabbar;
        inv.theTextType = TextTypeAdwallImportantInfo;
        [self.navigationController pushViewController:inv animated:YES];
        [inv release];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)QianDaoSuccess
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    NSString * qiand = [[NSUserDefaults standardUserDefaults] objectForKey:@"qiandaoday"];
    if (qiand) {
        if ([messageDateStr isEqualToString:qiand]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您今日已签到，明天才能再次签到" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
            [alert release];
            [[NSUserDefaults standardUserDefaults] setObject:messageDateStr forKey:@"qiandaoday"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:messageDateStr forKey:@"qiandaoday"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已完成今日签到，获得250彩豆，已冲入您的账户" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
    [alert release];
    NSString * dd = [[NSUserDefaults standardUserDefaults] objectForKey:@"jiaMoney"];
    NSString * gg = [NSString stringWithFormat:@"%.0f",[dd floatValue]+250];
    [[NSUserDefaults standardUserDefaults] setObject:gg forKey:@"jiaMoney"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.listTableV reloadData];
}
-(void)creatiADView
{
    float h = [UIScreen mainScreen].bounds.size.height;
    imgV = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgV setFrame:CGRectMake(0.0, h-44-20-50-50, self.view.frame.size.width, 50.0)];
    [imgV setImage:[UIImage imageNamed:@"adbanner"] forState:UIControlStateNormal];
    [self.view addSubview:imgV];
    [imgV addTarget:self action:@selector(adclicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * deleteB  = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteB.tag = 2013;
    deleteB.frame = CGRectMake(290, h-44-20-50-50+10, 30, 30);
    [deleteB setBackgroundImage:[UIImage imageNamed:@"deletenewop"] forState:UIControlStateNormal];
    [deleteB addTarget:self action:@selector(removeadvertisement:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteB];
//    //以画面直立的方式设定Banner于画面底部
//    bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//    bannerView.backgroundColor = [UIColor redColor];
//    [bannerView setFrame:CGRectMake(0.0, self.view.frame.size.height-44-[self originY]-50-50, self.view.frame.size.width, 50.0)];
    NSLog(@"THEFRAMEHEIGHT:%f",h);
//    //此Banner所能支援的类型
////    bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
//    
//    //目前的Banner 类型
//    bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//    
//    //设定代理
//    bannerView.delegate = self;
//    
//    //无法按下触发广告
//    bannerView.userInteractionEnabled = YES;
//    
//    [self.view addSubview:bannerView];
}
-(void)adclicked
{
    NSString * appLink = @"https://itunes.apple.com/us/app/chong-wu-quan-ai-chong-wu/id686838840?ls=1&mt=8";
    NSURL *url = [NSURL URLWithString:appLink];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
-(void)removeadvertisement:(UIButton *)sender
{
    [sender removeFromSuperview];
    [imgV removeFromSuperview];
}
-(float)originY
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        return 0;
    }
    else
    {
        return 20;
    }
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"should begin");
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"did finish");
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"%d",banner.bannerLoaded);
    NSLog(@"did load");
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
-(void)showOtherActivity
{
    OtherActivityViewController * otherV = [[OtherActivityViewController alloc] init];
    [self.navigationController pushViewController:otherV animated:YES];
    [otherV release];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
}

-(void)DuoMengInit
{
    if (_offerWallController) {
        _offerWallController.delegate = nil;
        [_offerWallController release];
        _offerWallController = nil;
    }
    _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DuoMengPublisherID andUserID:self.theUserID];
    _offerWallController.delegate = self;
    _offerWallController.disableStoreKit = YES;
    
}
-(void)showDuoMengAdWall
{
    [_offerWallController presentOfferWall];
}

-(void)offerWallDidClosed
{
    [self getMyBalance];
}

static NSString* const errCodeList[] = {
    @"successful",
    @"offer wall is disabled",
    @"login connection failed",
    @"offer wall has not been loginned",
    @"offer wall is not initialized",
    @"offer wall has been loginned",
    @"unknown error",
    @"invalid event flag",
    @"app list request failed",
    @"app list response failed",
    @"app list parameter malformatted",
    @"app list is being requested",
    @"offer wall is not ready for show",
    @"keywords malformatted",
    @"current device has not enough space to save resource",
    @"resource malformatted",
    @"resource load failed",
    @"you are have already loginned",
    @"exceed max show count",
    @"exceed max login count",
    @"you have not enough points",
    @"points consumption is not available",
    @"point is negative number",
    @"receive point is error",
    @"network request error"
};
-(void)showAnWoAdwall
{
    bgv2.hidden = YES;
    //开发者如需要后台对接，才需要设置这个字段。
    NSArray *arr = [NSArray arrayWithObjects:self.theUserID, nil];
    AdwoOWSetKeywords(arr);
    
    // 初始化并登录积分墙
    BOOL result = AdwoOWPresentOfferWall(ADWO_OFFERWALL_BASIC_PID, self);
    if(!result)
    {
        enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
        NSLog(@"Initialization error, because %@", errCodeList[errCode]);
    }
    else
        NSLog(@"Initialization successfully!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
}
//点击更新积分
- (void)checkPointsTouched:(id)sender
{
    AdwoOWRefreshPoint();
}

//点击消费积分
- (void)consumePointsTouched:(id)sender
{
    UITextField *text = (UITextField*)[self.view viewWithTag:111];
    NSInteger value = (text.text == nil || [text.text length] == 0)? 0 : [text.text intValue];
    // 消费value个虚拟货币
    if(!AdwoOWConsumePoints(value))
    {
        NSLog(@"Consume points failed, because %@", errCodeList[AdwoOWFetchLatestErrorCode()]);
    }
    text.text = @"";
}

//点击获取积分墙最新信息
-(void)getSummaryMessageTouched:(id)sender{
    AdwoOWRefreshSummeryMessage();
}



#pragma mark - adwo offerwall delegates
//登陆积分墙的代理方法
- (void)loginSelector
{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
        NSLog(@"Login successfully!");
    else
        NSLog(@"Login failed, because %@", errCodeList[errCode]);
}
//退出积分墙的代理方法
- (void)dismissSelector
{
    if (self.shouldShowTabbar) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    bgv2.hidden = NO;
    NSLog(@"I know, the wall is dismissed!");
}

//消费积分响应的代理方法，开发者每次消费积分之后，需要在收到此响应之后才表示完成一次消费
-(void)adwoOWConsumepoint{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
    {
        UITextView *text = (UITextView*)[self.view viewWithTag:121];
        NSInteger pRemainPoints;
        AdwoOWGetCurrentPoints(&pRemainPoints);//当收到消费积分回调后，利用此函数获得当前积分。
        text.text = [NSString stringWithFormat:@"%d",pRemainPoints];
    }
    else
        NSLog(@"Login failed, because %@", errCodeList[errCode]);
}

//刷新积分响应的代理方法
-(void)adwoOWRefreshPoint{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
    {
        NSLog(@"adwoOWRefreshPoint successfully!");
        UITextView *text = (UITextView*)[self.view viewWithTag:121];
        int pRemainPoints;
        //当刷新到最新积分之后，利用此函数获得当前积分。
        AdwoOWGetCurrentPoints(&pRemainPoints);
        text.text = [NSString stringWithFormat:@"%d",pRemainPoints];
    }
    else
        NSLog(@"Login failed, because %@", errCodeList[errCode]);
}

//获得积分墙最新信息的代理方法
-(void)adwoOWSummary{
    enum ADWO_OFFER_WALL_ERRORCODE errCode = AdwoOWFetchLatestErrorCode();
    if(errCode == ADWO_OFFER_WALL_ERRORCODE_SUCCESS)
    {
        UITextView *text = (UITextView*)[self.view viewWithTag:121];
        NSDictionary *dic =  AdwoOWGetSummaryMessage();
        if (dic !=nil) {
            text.text = [NSString stringWithFormat:@"%@",dic];
        }
        
    }else
        NSLog(@"Login failed, because %@", errCodeList[errCode]);
}


//-(void)EScoreWallInit
//{
//    [YJFUserMessage shareInstance].yjfUserAppId =EScoreUserAppId;//应用ID
//    [YJFUserMessage shareInstance].yjfUserDevId =EScoreUserDevId;//开发者ID
//    [YJFUserMessage shareInstance].yjfAppKey =EScoreAppkey;//appKey
//    [YJFUserMessage shareInstance].yjfChannel =EScoreChannel;//市场渠道号
//    [YJFUserMessage shareInstance].yjfCoop_info = self.theUserID;
//    
//    YJFInitServer *InitData = [[YJFInitServer alloc]init];
//    [InitData getInitEscoreData];
//    [InitData release];
//}

//-(void)showEscoreWall
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
//    YJFIntegralWall *integralWall = [[YJFIntegralWall
//                                      alloc]init];
//    integralWall.delegate = self;
//    [self presentViewController:integralWall animated:YES
//                     completion:nil];
//    [integralWall release];
//}
//-(void)OpenIntegralWall:(int)_value
//{
//    
//}
//-(void)CloseIntegralWall
//{
//    if (!self.isShowBackButton) {
//        if (self.shouldShowTabbar) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
//        }
//        
//    }
//    [self getMyBalance];
//    
//}

-(void)DianRuInit
{
    [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
}
-(NSString *)applicationKey
{
    return DianRuAppKey;
}
-(NSString *)dianruAdWallAppUserId
{
    return self.theUserID;
}
-(void)showDianRuWall
{
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    [DianRuAdWall showAdWall:self];
}
-(void)dianruAdWallClose
{
    if (!self.isShowBackButton) {
        if (self.shouldShowTabbar) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        }
        
    }
    [self getMyBalance];

}
-(void)YouMiInit
{
    [YouMiConfig setUserID:self.theUserID]; // [可选] 例如开发者的应用是有登录功能的，则可以使用登录后的用户账号来替代有米为每台机器提供的标识（有米会为每台设备生成的唯一标识符）。
    [YouMiConfig setUseInAppStore:NO];  // [可选]开启内置appStore，详细请看YouMiSDK常见问题解答
    [YouMiConfig launchWithAppID:YouMiAdWallPublishID appSecret:YouMiAdWallSecret];
    [YouMiWall enable];
}
-(void)showYouMiWall
{
    [YouMiWall showOffers:YES didShowBlock:^{
        NSLog(@"有米积分墙已显示");
    } didDismissBlock:^{
        NSLog(@"有米积分墙已退出");
        [self getMyBalance];
    }];
}
-(void)LiMeiAdWallInit
{
    if (self.adView_adWall) {
        self.adView_adWall.delegate = nil;
        [self.adView_adWall release];
        self.adView_adWall = nil;
    }
    self.adView_adWall=[[immobView alloc] initWithAdUnitID:LiMeiAdID];
    //添加 immobView 的 Delegate;
    self.adView_adWall.delegate=self;
    //添加 userAccount 属性,此属性针对多账户应用所使用,用于区分不同账户下的积分(可选)。
    [self.adView_adWall.UserAttribute setObject:self.theUserID forKey:@"accountname"];
    [self.adView_adWall.UserAttribute setObject:@"YES" forKey:@"disableStoreKit"];
}
-(void)enterLiMeiAdWall{
    // 实例化 immobView 对象,在此处替换在力美广告平台申请到的广告位 ID;

    //开始加载广告。
    [self.adView_adWall.UserAttribute setObject:self.theUserID forKey:@"accountname"];
    [m_delegate.activityView activityViewShow];
    [self.adView_adWall immobViewRequest];
}
-(void)onDismissScreen:(immobView *)immobView
{
    if (!self.isShowBackButton) {
        if (self.shouldShowTabbar) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        }
        
    }

    bgBTopBar.hidden = YES;
    [m_delegate.activityView disActivityView];
    self.navigationController.navigationBarHidden = NO;
    [self getMyBalance];
}
// 设置必需的 UIViewController, 此方法的返回值如果为空,会导致广告展示不正常。
- (UIViewController *)immobViewController{ return self;
}
- (void) immobViewDidReceiveAd:(immobView*)immobView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    bgBTopBar.hidden = NO;
    //将 immobView 添加到界面上。
    self.navigationController.navigationBarHidden = YES;
    [self.view addSubview:adView_adWall];
    [m_delegate.activityView disActivityView];
    //将 immobView 添加到界面后,调用 immobViewDisplay。
    [self.adView_adWall immobViewDisplay];
    //    [self presentModalViewController:adWallV animated:YES];
}

-(void)QueryScore{
    [self.adView_adWall immobViewQueryScoreWithAdUnitID:LiMeiAdID WithAccountID:self.theUserID];
}
// 查询积分回调
-(void)immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message{ UIAlertView *uA=[[UIAlertView alloc] initWithTitle:@"积分查询" message: ![message
                                                                                                                                                    isEqualToString:@""]?[NSString stringWithFormat:@"%@",message]:[NSString stringWithFormat:@"当前积分 为:%i",score] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    [uA show];
    [uA release];
}
-(void)ReduceScore{
    [self.adView_adWall immobViewReduceScore:99 WithAdUnitID:LiMeiAdID WithAccountID:self.theUserID];
}
// 减少积分回调
-(void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message{
    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:status?@"积分减少成功":@"积分减少失败"
                                               message: status?@"":[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"YES"
                                     otherButtonTitles:nil, nil]; [uA show];
    [uA release];
}
- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode{
    
}

-(void)midiInit
{
    [MiidiManager setAppPublisher:MiidiPublisher withAppSecret:MiidiAppSecret];
}
-(void)showMiidiAdWall
{
    [MiidiAdWall setUserParam:self.theUserID];
    [MiidiAdWall showAppOffers:self withDelegate:self];
}
-(void)didShowWallView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
}
-(void)didDismissWallView
{
    if (self.shouldShowTabbar) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    
}
// email 账号未设置。
- (void) emailNotSetupForAd:(immobView *)immobView{
    
}

-(void)AdviewAdWallInit
{
    self.rtbAdWall = [[RTBWall alloc]initWithAppID:AdViewKey andDelegate:self];
}

-(void)showAdviewWall
{
//    int num = arc4random()%6;
    [self.rtbAdWall setDeveloperUserID:self.theUserID];
    [self.rtbAdWall setRTBWallColor:RTBWallThemeColor_Red];
    [self.rtbAdWall setRTBWallModel:YES];
    [self.rtbAdWall showRTBWallWithController:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
}

-(void)rtbWallDidDismissScreen:(UIViewController *)adWall
{
    if (self.shouldShowTabbar) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
}


-(void)backAction:(UIButton * )button{
//    if (self.isShowTabBar)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
//    }
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
