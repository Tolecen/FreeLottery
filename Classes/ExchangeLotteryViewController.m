//
//  ExchangeLotteryViewController.m
//  Boyacai
//
//  Created by fengyuting on 14-1-14.
//
//

#import "ExchangeLotteryViewController.h"
#import "AdaptationUtils.h"
#import "UINavigationBarCustomBg.h"
#import "BackBarButtonItemUtils.h"
#import "ADWallViewController.h"

@interface ExchangeLotteryViewController ()

@end

@implementation ExchangeLotteryViewController
@synthesize listTableV;
@synthesize adView_adWall;
@synthesize theUserID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArray = [[NSArray alloc] initWithObjects:@"力美积分墙",@"有米积分墙",@"点入积分墙",@"易积分积分墙",@"多盟积分墙", nil];
        
        self.theUserID = [RuYiCaiNetworkManager sharedManager].userno;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.theUserID = [RuYiCaiNetworkManager sharedManager].userno;
}
-(void)dealloc
{
    _offerWallController.delegate = nil;
    [_offerWallController release];
    _offerWallController = nil;
    [titleArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
//    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
//    [RuYiCaiNetworkManager sharedManager].thirdViewController = self;

    self.navigationItem.title = @"积分换彩";
//    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(backAction:) andAutoPopView:NO];
//    self.navigationItem.title = @"积分换彩";
    [self YouMiInit];
    [self DianRuInit];
    [self DuoMengInit];
    [self EScoreWallInit];
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.rowHeight = 68;
    [self.listTableV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.listTableV];
    
    bgBTopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [bgBTopBar setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:bgBTopBar];
    bgBTopBar.hidden = YES;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return titleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
	ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell)
		cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.titleName = titleArray[indexPath.row];
    cell.littleTitleName = @"完成推荐应用的任务，就能免费获取彩金";
    cell.iconImageName = @"ico_c_bank.png";
    
    [cell refresh];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
 
//            adWallV = [[ADWallViewController alloc] init];
            
//            [self presentModalViewController:adWallV animated:YES];
//            [adWallV release];
            [self enterLiMeiAdWall];

        }
            break;
        case 1:
        {
            
            //            adWallV = [[ADWallViewController alloc] init];
            
            //            [self presentModalViewController:adWallV animated:YES];
            //            [adWallV release];
            [self showYouMiWall];
            
        }
            break;
        case 2:
        {
            
            //            adWallV = [[ADWallViewController alloc] init];
            
            //            [self presentModalViewController:adWallV animated:YES];
            //            [adWallV release];
            [self showDianRuWall];
            
        }
            break;
        case 3:
        {
            
            //            adWallV = [[ADWallViewController alloc] init];
            
            //            [self presentModalViewController:adWallV animated:YES];
            //            [adWallV release];
            [self showEscoreWall];
            
        }
            break;
        case 4:
        {
            
            //            adWallV = [[ADWallViewController alloc] init];
            
            //            [self presentModalViewController:adWallV animated:YES];
            //            [adWallV release];
            [self showDuoMengAdWall];
            
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)DuoMengInit
{
    _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DuoMengPublisherID andUserID:self.theUserID];
    _offerWallController.delegate = self;
    
}
-(void)showDuoMengAdWall
{
    [_offerWallController presentOfferWall];
}

-(void)EScoreWallInit
{
    [YJFUserMessage shareInstance].yjfUserAppId =EScoreUserAppId;//应用ID
    [YJFUserMessage shareInstance].yjfUserDevId =EScoreUserDevId;//开发者ID
    [YJFUserMessage shareInstance].yjfAppKey =EScoreAppkey;//appKey
    [YJFUserMessage shareInstance].yjfChannel =EScoreChannel;//市场渠道号
    [YJFUserMessage shareInstance].yjfCoop_info = self.theUserID;

    YJFInitServer *InitData = [[YJFInitServer alloc]init];
    [InitData getInitEscoreData];
    [InitData release];
}

-(void)showEscoreWall
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    YJFIntegralWall *integralWall = [[YJFIntegralWall
                                      alloc]init];
    integralWall.delegate = self;
    [self presentViewController:integralWall animated:YES
                     completion:nil];
    [integralWall release];
}
-(void)OpenIntegralWall:(int)_value
{
    
}
-(void)CloseIntegralWall
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
}

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
}
-(void)YouMiInit
{
    [YouMiConfig setUserID:self.theUserID]; // [可选] 例如开发者的应用是有登录功能的，则可以使用登录后的用户账号来替代有米为每台机器提供的标识（有米会为每台设备生成的唯一标识符）。
    [YouMiConfig setUseInAppStore:YES];  // [可选]开启内置appStore，详细请看YouMiSDK常见问题解答
    [YouMiConfig launchWithAppID:YouMiAdWallPublishID appSecret:YouMiAdWallSecret];
    [YouMiWall enable];
}
-(void)showYouMiWall
{
    [YouMiWall showOffers:YES didShowBlock:^{
        NSLog(@"有米积分墙已显示");
    } didDismissBlock:^{
        NSLog(@"有米积分墙已退出");
    }];
}
-(void)enterLiMeiAdWall{
    // 实例化 immobView 对象,在此处替换在力美广告平台申请到的广告位 ID;
    self.adView_adWall=[[immobView alloc] initWithAdUnitID:LiMeiAdID];
    //添加 immobView 的 Delegate;
    self.adView_adWall.delegate=self;
    //添加 userAccount 属性,此属性针对多账户应用所使用,用于区分不同账户下的积分(可选)。
    [self.adView_adWall.UserAttribute setObject:self.theUserID forKey:@"accountname"];
    //开始加载广告。
    [m_delegate.activityView activityViewShow];
    [self.adView_adWall immobViewRequest];
}
-(void)onDismissScreen:(immobView *)immobView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    bgBTopBar.hidden = YES;
    [m_delegate.activityView disActivityView];
    self.navigationController.navigationBarHidden = NO;
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
// email 账号未设置。
- (void) emailNotSetupForAd:(immobView *)immobView{
    
}





-(void)backAction:(UIButton * )button{
    if (self.isShowTabBar)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
