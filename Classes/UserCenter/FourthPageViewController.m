    //
//  FourthPageViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FourthPageViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "QueryLotWinViewController.h"
#import "QueryLotBetViewController.h"
#import "QueryLotTrackViewController.h"
#import "QueryUserBalanceViewController.h"
#import "QueryGiftViewController.h"
#import "QueryAccountDetailViewController.h"
#import "QueryCaidouBalanceViewController.h"
#import "GetCashViewController.h"
#import "NSLog.h"
#import "UINavigationBarCustomBg.h"

#import "UserCenterTableViewCell.h"
#import "SBJsonParser.h"
#import "RechargeViewController.h"
#import "HMDTQueryCaseLotViewController.h"
#import "LeaveMessageViewController.h"
#import "IntegralViewController.h"
#import "Custom_tabbar.h"
#import "IntegralRuleViewController.h"
#import "DaiLiChargeViewController.h"
#import "RYCRegisterView.h"
#import "ChangePassViewController.h"
#import "BindCertViewController.h"
#import "ColorUtils.h"
#import "TopUserCell.h"
#import "AdaptationUtils.h"
#import "ExchangeCaidouViewController.h"
#import "MessageCenterViewController.h"


#define ViewTag  (30)

@interface FourthPageViewController (internal)

- (void)getUserCenterInfoOK:(NSNotification *)notification;
- (void)queryDNAOK:(NSNotification *)notification;
- (void)loginOK:(NSNotification *)notification;

- (void)quitLogin;
- (void)setUpBindCertId;

- (void)pushView;
@end

@implementation FourthPageViewController

@synthesize m_nickName;
@synthesize m_bPhone;
@synthesize m_balanceLabel;
@synthesize m_moneyLabel;
@synthesize m_integralLabel;
@synthesize m_isBindCertid;
@synthesize m_isBindPhone;

@synthesize agencyChargeRight = m_agencyChargeRight;
@synthesize loginTopView    =  m_loginTopView;
@synthesize notLoginView    = m_notLoginView;
@synthesize idCardimage     = m_idCardimage;
@synthesize idPhoneimage    = m_idPhoneimage;
@synthesize sectionTitleArray =m_sectionTitleArray;
@synthesize cellTitlArray    =m_cellTitlArray;

- (void)dealloc
{
    [m_sectionTitleArray release];
    [m_cellTitlArray release];
    [m_tableView release], m_tableView = nil;
    [m_idCardimage release];
    [m_idPhoneimage release];
    [m_nickName release];
    [m_balanceLabel release];
    [m_integralLabel release];
    [m_isBindCertid release];
    [m_isBindPhone release];
    [lineLabel release];
    
    [m_button_Login release];
    
    [m_loginTopView release];
    [m_notLoginView release];
    
    [selectTableRow release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUserCenterInfoOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryDNAOK" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    isRequestBindEmeil = NO;
    isRequestBindPhone = NO;
//    if ([RuYiCaiNetworkManager sharedManager].hasLogin) {
//        [[RuYiCaiNetworkManager sharedManager] updateUserInformation];
//    }
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];

    //已经登陆 切不是联合登陆
    if ([[RuYiCaiNetworkManager sharedManager] hasLogin] && [[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin]) {
        if (m_delegate.autoRememberMystatus) {
            NSLog(@"自动登录");
            [[RuYiCaiNetworkManager sharedManager] updateUserInformation];
        }else{
            NSLog(@"非自动登录");
            [[RuYiCaiNetworkManager sharedManager] loginWithPhonenum:[RuYiCaiNetworkManager sharedManager].phonenum withPassword:[RuYiCaiNetworkManager sharedManager].password];
        }
    }else if ([[RuYiCaiNetworkManager sharedManager] hasLogin] && ![[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin]){
        NSLog(@"联合登陆");
        //        [RuYiCaiNetworkManager sharedManager] loginWithSource:<#(NSString *)#> withOpenId:<#(NSString *)#> withNickName:<#(NSString *)#>
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDNAOK:) name:@"queryDNAOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserCenterInfoOK:) name:@"getUserCenterInfoOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOK:) name:@"loginOK" object:nil];
    
    //    [self updateLoginStatus];
    /*
     取消 刷新判断
     */
    if([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] UpdateUserInfo];
        self.loginTopView.hidden = NO;
        self.notLoginView.hidden = YES;
        
        [self setupNavigationBarStatus];
    }
    else
    {
        selectTableRow = nil;
        
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertViewAndAddAnimation:NO];
        
        self.loginTopView.hidden = YES;
        self.notLoginView.hidden = NO;
        //        self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    }
    
    //区内容数组和cell标题数组创建
     self.cellTitlArray= [NSMutableArray arrayWithObjects:@"中奖查询|yhzx_zjcx_icon.png",@"投注记录|yhzx_tzjl_icon.png",@"账户提现|yhzx_zhtx_icon.png",@"账户明细|yhzx_zhmx_icon.png", @"彩豆明细|yhzx_caidou_icon.png",@"消息中心|yhzx_message_icon.png",nil];
   
    if (m_tableView)
    {
        [m_tableView reloadData];
    }
    [[Custom_tabbar showTabBar] hideTabBar:NO];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    
    self.navigationItem.title = @"用户中心";
    [self.navigationController.navigationBar setBackground];
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    [RuYiCaiNetworkManager sharedManager].fourthViewController = self;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    }else
    {
        if (!KISiPhone5) {
           m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20) style:UITableViewStylePlain];
        }else
        {
            m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        }
    }
    
    
    m_tableView.backgroundView = [[[UIView alloc]init] autorelease];
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.contentInset = UIEdgeInsetsMake(140, 0, 0, 0);
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    
    m_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_tableView.separatorColor = [UIColor lightGrayColor];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:m_tableView];
    //底部view显示
    
    UILabel *footUpLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 260, 30)];
    footUpLable.textColor = [UIColor blackColor];
    footUpLable.font = [UIFont systemFontOfSize:14];
    footUpLable.text = @"本软件的彩票运营由博雅彩提供支持";
    footUpLable.backgroundColor = [UIColor clearColor];
    
    UILabel *footDownLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 45, 70, 30)];
    footDownLable.font = [UIFont systemFontOfSize:14];
    footDownLable.textColor = [UIColor blackColor];
    footDownLable.text = @"客服电话：";
    footDownLable.backgroundColor = [UIColor clearColor];

    UIButton * hotLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    hotLineButton.frame = CGRectMake(130, 45, 100, 30);
    [hotLineButton setTitle:@"400-856-1000" forState:UIControlStateNormal];
    hotLineButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [hotLineButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [hotLineButton addTarget:self action:@selector(hotLineServiceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 80)]autorelease];
    [footerView setBackgroundColor:[UIColor clearColor]];
    [footerView addSubview:footUpLable];
    [footUpLable release];
    [footerView addSubview:footDownLable];
    [footDownLable release];
    [footerView addSubview:hotLineButton];
    m_tableView.tableFooterView = footerView;
    
    m_loginTopView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -130, 320, 140)];
    m_loginTopView.scrollEnabled = NO;
    m_loginTopView.backgroundColor = [UIColor clearColor];
    [m_tableView addSubview:m_loginTopView];
    UIImageView *secionLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130, 320, 2)];
    secionLineImageView.image = [UIImage imageNamed:@"secion_c_Line.png"];
    [m_loginTopView addSubview:secionLineImageView];
    [secionLineImageView release];

    
    if([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        m_loginTopView.hidden = NO;
        m_notLoginView.hidden = YES;
    }
    else
    {
        m_loginTopView.hidden = YES;
        m_notLoginView.hidden = NO;
    }
    
    selectTableRow = nil;
    
//    UIButton *buttonSetting = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 30)];
//    [buttonSetting setTitle:@"设置" forState:UIControlStateNormal];
//    buttonSetting.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    [buttonSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [buttonSetting setBackgroundImage:RYCImageNamed(@"item_bar_right_button_normal.png") forState:UIControlStateNormal];
//    [buttonSetting setBackgroundImage:RYCImageNamed(@"item_bar_right_button_click.png") forState:UIControlStateHighlighted];
//    [buttonSetting addTarget:self action:@selector(toSettingV) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * AbuttonSetting = [[UIBarButtonItem alloc] initWithCustomView:buttonSetting];
//    [buttonSetting release];
//    self.navigationController.navigationBar.topItem.leftBarButtonItem = AbuttonSetting;
//    self.navigationItem.leftBarButtonItem = AbuttonSetting;

    [self setupNavigationBarStatus];
    
    [self setUpTopView];
//    [self setUpTopView_notLogin];
    flag[0]=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goLogOut:) name:@"myLogOut" object:nil];
    
}


- (void)setupNavigationBarStatus
{
//    if ([RuYiCaiNetworkManager sharedManager].hasLogin)
//    {
        if(m_button_Login != nil)
            [m_button_Login release];
        UIButton *buttonLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 30)];
        [buttonLogin setTitle:@"更多" forState:UIControlStateNormal];
        buttonLogin.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buttonLogin setBackgroundImage:RYCImageNamed(@"item_bar_right_button_normal.png") forState:UIControlStateNormal];
        [buttonLogin setBackgroundImage:RYCImageNamed(@"item_bar_right_button_click.png") forState:UIControlStateHighlighted];
        [buttonLogin addTarget:self action:@selector(toSettingV) forControlEvents:UIControlEventTouchUpInside];
        m_button_Login = [[UIBarButtonItem alloc] initWithCustomView:buttonLogin];
        [buttonLogin release];
//    }
    self.navigationController.navigationBar.topItem.rightBarButtonItem = m_button_Login;
	self.navigationItem.rightBarButtonItem = m_button_Login;
}


-(void)hotLineServiceAction:(UIButton *)button{
    
    UIDevice * device = [UIDevice currentDevice];
    
    NSString * deviceName = [device model];
    if ([deviceName isEqualToString:@"iPad"] || [deviceName isEqualToString:@"iPod touch"]) {
        [[RuYiCaiNetworkManager sharedManager]showMessage:@"当前设备没有打电话功能！" withTitle:@"提示" buttonTitle:@"确定"];
    }else{
        NSURL * hotLineURL = [NSURL URLWithString:@"telprompt://4008561000"];
        [[UIApplication sharedApplication] openURL:hotLineURL];
    }
}

- (void)quitLogin
{
    UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定注销登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    
    [alterView addButtonWithTitle:@"确定"];
    alterView.delegate = self;
    alterView.tag = 321;
    [alterView show];
    
    [alterView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(321 == alertView.tag)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            //            [MobClick event:@"userPage_loginOut"];
            
//            [RuYiCaiNetworkManager sharedManager].hasLogin = NO;
//            [CommonRecordStatus commonRecordStatusManager].remmberQuitStatus = YES;
//            
//            [m_tableView reloadData];//防止代理充值项 注销后不消失
//            
//            m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
//            [m_delegate.mainMenuTabbar selectTabTapped:@"0"];
        }
    }
}
- (void)exchangeCaidou
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    ExchangeCaidouViewController* viewController = [[ExchangeCaidouViewController alloc] init];
    viewController.caidouStr =m_moneyLabel.text;
    viewController.jiangjinStr = m_balanceLabel.text;
    viewController.navigationItem.title =@"兑换彩豆",
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}
-(void)goLogOut:(NSNotification *)notification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [RuYiCaiNetworkManager sharedManager].hasLogin = NO;
    [CommonRecordStatus commonRecordStatusManager].remmberQuitStatus = YES;
    
    [m_tableView reloadData];//防止代理充值项 注销后不消失
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [m_delegate.mainMenuTabbar selectTabTapped:@"0"];
}

#pragma mark 未登录
- (void)setUpTopView_notLogin
{
    UILabel*  titleLabel_login = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 20)];
    titleLabel_login.text = @"您还未登录，登录后可查看更多信息。";
    [titleLabel_login setTextColor:[UIColor blackColor]];
    [titleLabel_login setFont:[UIFont systemFontOfSize:15]];
    titleLabel_login.backgroundColor = [UIColor clearColor];
    titleLabel_login.textAlignment = UITextAlignmentCenter;
    [self.notLoginView addSubview:titleLabel_login];
    [titleLabel_login release];
    
    UILabel*  titleLabel_regist = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 300, 20)];
    titleLabel_regist.text = @"如果您还未注册，请先注册。";
    [titleLabel_regist setTextColor:[UIColor blackColor]];
    [titleLabel_regist setFont:[UIFont systemFontOfSize:15]];
    titleLabel_regist.backgroundColor = [UIColor clearColor];
    titleLabel_regist.textAlignment = UITextAlignmentCenter;
    [self.notLoginView addSubview:titleLabel_regist];
    [titleLabel_regist release];
    
    UIButton *loginButton_label = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton_label.frame = CGRectMake(111, 11, 30, 20);
    loginButton_label.backgroundColor = [UIColor whiteColor];
    [loginButton_label setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton_label setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    loginButton_label.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    [loginButton_label addTarget:self action: @selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.notLoginView addSubview:loginButton_label];
    
    
    
    UIButton *registButton_label = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton_label.frame = CGRectMake(201, 36, 30, 20);
    [registButton_label setTitle:@"注册" forState:UIControlStateNormal];
    registButton_label.backgroundColor = [UIColor whiteColor];
    [registButton_label setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    registButton_label.titleLabel.font = [UIFont boldSystemFontOfSize: 15];
    [registButton_label addTarget:self action: @selector(registButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.notLoginView addSubview:registButton_label];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 60, 51, 30)];
    
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor clearColor]];
    loginButton.titleLabel.textColor = [UIColor whiteColor];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"item_bar_right_button_normal.png"] forState: UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"item_bar_right_button_click.png"] forState: UIControlStateHighlighted];
    [loginButton addTarget:self action: @selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.notLoginView addSubview:loginButton];
    [loginButton release];
    
    
    UIButton *registButton = [[UIButton alloc] initWithFrame:CGRectMake(180, 60, 51, 30)];
    
    [registButton setBackgroundImage:[UIImage imageNamed:@"item_bar_right_button_normal.png"] forState: UIControlStateNormal];
    [registButton setBackgroundImage:[UIImage imageNamed:@"item_bar_right_button_click.png"] forState: UIControlStateHighlighted];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setBackgroundColor:[UIColor clearColor]];
    registButton.titleLabel.textColor = [UIColor whiteColor];
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [registButton addTarget:self action: @selector(registButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.notLoginView addSubview:registButton];
    [registButton release];
    
    
}

- (void)registButtonClick:(id)sender
{
    selectTableRow = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    RYCRegisterView *registerView = [[RYCRegisterView alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
    [registerView release];
}

- (void)loginButtonClick:(id)sender
{
    selectTableRow = nil;
    
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
    [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
}

- (void)loginOK:(NSNotification *)notification
{
    //cell标题数组创建
    if (m_tableView)
    {
        [m_tableView reloadData];
    }
    
    
    m_loginTopView.hidden = NO;
    m_notLoginView.hidden = YES;
    
    [[RuYiCaiNetworkManager sharedManager] UpdateUserInfo];
    [self setupNavigationBarStatus];
    [self pushView];
}

#pragma mark 登录
- (void)setUpTopView
{
    
    UIImageView *topPhotoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topPhoto_c_Image.png"]];
    topPhotoImage.frame = CGRectMake(10, 10, 80, 80);
    [self.loginTopView addSubview:topPhotoImage];
    [topPhotoImage release];
    
    [self.loginTopView addSubview:topPhotoImage];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 28, 45, 20)];
    nameLabel.text = @"昵    称:";
    nameLabel.backgroundColor = [UIColor clearColor];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    [self.loginTopView addSubview:nameLabel];
    [nameLabel release];
    
    m_nickName = [[UIButton alloc] initWithFrame:CGRectMake(140, 28, 95, 20)];
    [m_nickName setTitle:@"查询中..." forState:UIControlStateNormal];
    [m_nickName setTitleColor:[UIColor colorWithRed:0 green:102.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [m_nickName setBackgroundColor:[UIColor clearColor]];
    m_nickName.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [m_nickName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];;
    [m_nickName addTarget:self action:@selector(setUpNickname) forControlEvents:UIControlEventTouchUpInside];
    m_nickName.enabled = NO;
    [self.loginTopView addSubview:m_nickName];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 6, 45, 20)];
    phoneLabel.text = @"用户名:";
    phoneLabel.backgroundColor = [UIColor clearColor];
    [phoneLabel setTextColor:[UIColor blackColor]];
    [phoneLabel setFont:[UIFont systemFontOfSize:12]];
    [self.loginTopView addSubview:phoneLabel];
    [phoneLabel release];
    
    m_bPhone = [[UIButton alloc] initWithFrame:CGRectMake(140, 7, 120, 20)];
    [m_bPhone setTitle:@"查询中..." forState:UIControlStateNormal];
    m_bPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [m_bPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_bPhone.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    m_bPhone.enabled = NO;
    [self.loginTopView addSubview:m_bPhone];
    
    UILabel *blance = [[UILabel alloc] initWithFrame:CGRectMake(95,50, 45, 20)];
    blance.text = @"彩    豆:";
    blance.backgroundColor = [UIColor clearColor];
    [blance setTextColor:[UIColor blackColor]];
    [blance setFont:[UIFont systemFontOfSize:12]];
    [self.loginTopView addSubview:blance];
    [blance release];
    
    
    m_balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 71, 100, 20)];
    m_balanceLabel.text = @"查询中...";
    m_balanceLabel.backgroundColor = [UIColor clearColor];
    m_balanceLabel.textAlignment = UITextAlignmentLeft;
    [m_balanceLabel setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
    [m_balanceLabel setFont:[UIFont systemFontOfSize:12]];
    [self.loginTopView addSubview:m_balanceLabel];
    
    UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(95,71, 45, 20)];
    money.text = @"奖    金:";
    money.backgroundColor = [UIColor clearColor];
    [money setTextColor:[UIColor blackColor]];
    [money setFont:[UIFont systemFontOfSize:12]];
    [self.loginTopView addSubview:money];
    [money release];
    
    
    m_moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 50, 100, 20)];
    m_moneyLabel.text = @"查询中...";
    m_moneyLabel.backgroundColor = [UIColor clearColor];
    m_moneyLabel.textAlignment = UITextAlignmentLeft;
    [m_moneyLabel setTextColor:[UIColor colorWithRed:204.0/255.0 green:0 blue:0 alpha:1.0]];
    [m_moneyLabel setFont:[UIFont systemFontOfSize:12]];
    [self.loginTopView addSubview:m_moneyLabel];
    

    
    m_isBindCertid = [[UIButton alloc] initWithFrame:CGRectMake(30, 92,110, 30)];
    [m_isBindCertid setBackgroundColor:[UIColor clearColor]];
    [m_isBindCertid setTitle:@"未绑定身份证" forState:UIControlStateNormal];
    m_isBindCertid.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [m_isBindCertid addTarget:self action:@selector(setUpBindCertId) forControlEvents:UIControlEventTouchUpInside];
    
    [m_isBindCertid setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    //m_isBindCertid.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    m_isBindCertid.enabled = YES;
    [self.loginTopView addSubview:m_isBindCertid];
    
    m_isBindPhone = [[UIButton alloc] initWithFrame:CGRectMake(167, 92, 110, 30)];
    [m_isBindPhone setBackgroundColor:[UIColor clearColor]];
    [m_isBindPhone setTitle:@"未绑定手机号" forState:UIControlStateNormal];
    m_isBindPhone.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [m_isBindPhone addTarget:self action:@selector(setUpBindPhone) forControlEvents:UIControlEventTouchUpInside];
    
    [m_isBindPhone setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    m_isBindPhone.enabled = YES;
    [self.loginTopView addSubview:m_isBindPhone];
    
    self.idCardimage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_ncert"]] autorelease];
    m_idCardimage.frame = CGRectMake(10, 97, 18, 18);
    [m_loginTopView addSubview:m_idCardimage];
    [m_idCardimage release];
    
    self.idPhoneimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_nphone"]];
    m_idPhoneimage.frame = CGRectMake(152, 97, 18, 18);
    [m_loginTopView addSubview:m_idPhoneimage];
    [m_idPhoneimage release];
    
    UIButton * caidouB = [UIButton buttonWithType:UIButtonTypeCustom];
    caidouB.frame = CGRectMake(230,71, 60, 20);
    [caidouB setBackgroundImage:[UIImage imageNamed:@"exchange-normal"] forState:UIControlStateNormal];
    [caidouB setBackgroundImage:[UIImage imageNamed:@"exchange-click"] forState:UIControlStateHighlighted];
    [caidouB setTitle:@"兑换彩豆" forState:UIControlStateNormal];
    [caidouB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    caidouB.titleLabel.font = [UIFont systemFontOfSize:12];
    [caidouB addTarget:self action:@selector(exchangeCaidou) forControlEvents:UIControlEventTouchUpInside];
    [self.loginTopView addSubview:caidouB];
}

- (void)getUserCenterInfoOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].userCenterInfo];
    [jsonParser release];
    
    self.agencyChargeRight = [parserDict objectForKey:@"agencyChargeRight"];
    [m_tableView reloadData];
    [RuYiCaiNetworkManager sharedManager].bindEmail = [parserDict objectForKey:@"email"];
    [RuYiCaiNetworkManager sharedManager].bindPhoneNum = [parserDict objectForKey:@"mobileId"];
    //同步email与web每次点击都要刷新是否存在email
    if (isRequestBindEmeil)
    {
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BIND_EMAIL;
        [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
    }
    if (isRequestBindPhone) {
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BIND_PHONE;
        [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
//        [self getUserCenterInfoOK:nil];
    }
    
    
    if(![(NSString*)[parserDict objectForKey:@"nickName"] length] == 0)
    {
        [[self.view viewWithTag:ViewTag + 1] removeFromSuperview];
        NSString* nickStr = [parserDict objectForKey:@"nickName"];
        if(nickStr.length > 6)
        {
            nickStr = [[nickStr substringWithRange:NSMakeRange(0, 6)] stringByAppendingString:@"***"];
        }
        NSLog(@"nickStr %@", nickStr);
        [m_nickName setTitle:nickStr forState:UIControlStateNormal];
        [m_nickName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_nickName.enabled = NO;
    }
    else
    {
        m_nickName.enabled = YES;
        [m_nickName setTitle:@"（点击设置）" forState:UIControlStateNormal];
        [m_nickName setTitleColor:[UIColor colorWithRed:0 green:102.0/255.0 blue:204.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        lineLabel.hidden = NO;
    }
    
    if(![(NSString*)[parserDict objectForKey:@"mobileId"] length] == 0)
    {
        [m_isBindPhone setTitle:@"已绑定手机号" forState:UIControlStateNormal];
        [m_isBindPhone setTitleColor:[UIColor colorWithRed:51.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        m_idPhoneimage.image = [UIImage imageNamed:@"user_yphone.png"];
    }
    else
    {
        [m_isBindPhone setTitle:@"未绑定手机号" forState:UIControlStateNormal];
        [m_isBindPhone setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        m_idPhoneimage.image = [UIImage imageNamed:@"user_nphone.png"];
    }
    if (([appStoreORnormal isEqualToString:@"appStore"] &&
         [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
        NSString * yy = [parserDict objectForKey:@"bet_balance"];
        yy = [yy substringToIndex:(yy.length-1)];
        NSString * jiaMoney = [[NSUserDefaults standardUserDefaults] objectForKey:@"jiaMoney"];
        if (!jiaMoney) {
            jiaMoney = @"0";
        }
        m_balanceLabel.text = [NSString stringWithFormat:@"%.2f元",[yy floatValue]+ [jiaMoney floatValue]];
    }
    else
    {
        m_balanceLabel.text = [NSString stringWithFormat:@"%@", [parserDict objectForKey:@"bet_balance"]];//ke'tou'zhu
    }
    
    m_moneyLabel.text = [NSString stringWithFormat:@"%@", [parserDict objectForKey:@"lotPea"]];
    
    [m_bPhone setTitle:[parserDict objectForKey:@"userName"] forState:UIControlStateNormal];
    //记录登录名
    [RuYiCaiNetworkManager sharedManager].loginName = [parserDict objectForKey:@"userName"];
    
    
    if([[parserDict objectForKey:@"score"] isEqualToString:@""])
    {
        m_integralLabel.text = @"0";
    }
    else
    {
        m_integralLabel.text = [NSString stringWithFormat:@"%@", [parserDict objectForKey:@"score"]];
    }
    if ([(NSString*)[parserDict objectForKey:@"certId"] isEqualToString:@""] || [parserDict objectForKey:@"certId"] == (NSString*)[NSNull null])
    {
        [m_isBindCertid setTitle:@"未绑定身份证" forState:UIControlStateNormal];
        [m_isBindCertid setTitleColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        m_idCardimage.image = [UIImage imageNamed:@"user_ncert.png"];
        
    }
    else
    {
        [RuYiCaiNetworkManager sharedManager].certid = [parserDict objectForKey:@"certId"];
        
        [m_isBindCertid setTitle:@"已绑定身份证" forState:UIControlStateNormal];
        [m_isBindCertid setTitleColor:[UIColor colorWithRed:51.0/255.0 green:102.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        m_idCardimage.image = [UIImage imageNamed:@"user_ycert.png"];
        
    }
}

- (void)setUpNickname
{
    [[RuYiCaiNetworkManager sharedManager] setUpNickName];
}

- (void)setUpBindPhone
{
    [[RuYiCaiNetworkManager sharedManager] UpdateUserInfo];
    isRequestBindPhone = YES;
    isRequestBindEmeil = NO;
    
//    [[RuYiCaiNetworkManager sharedManager] bindPhone];
}
- (void)setUpBindCertId
{
    [[RuYiCaiNetworkManager sharedManager] bindCertid];
}
- (void)seeIntegralExplain
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    
    IntegralRuleViewController* viewController = [[IntegralRuleViewController alloc] init];
    viewController.title = @"积分规则";
    [self.navigationController pushViewController:viewController animated:YES];
    
    NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:@"information" forKey:@"command"];
    [tempDic setObject:@"scoreRule" forKey:@"newsType"];
    viewController.requestDic = tempDic;
    [viewController requestDate];
    [viewController release];
}


- (void)queryDNAOK:(NSNotification *)notification
{
    if([RuYiCaiNetworkManager sharedManager].netAppType == NET_APP_GET_CASH)
    {
        if ([RuYiCaiNetworkManager sharedManager].certid == (NSString*)[NSNull null] || [[RuYiCaiNetworkManager sharedManager].certid isEqualToString:@""])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"为了保障您的账户安全，请您先完成绑定身份证信息后再进行提现操作，谢谢！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        
        GetCashViewController* viewController = [[GetCashViewController alloc] init];
        viewController.navigationItem.title = @"账户提现";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
    else if([RuYiCaiNetworkManager sharedManager].netAppType == NET_APP_BIND_CERTID)
    {
        BindCertViewController* viewController = [[BindCertViewController alloc] init];
        viewController.navigationItem.title = @"身份认证";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if([appStoreORnormal isEqualToString:@"appStore"]&&
           [appTestPhone isEqualToString:[RuYiCaiNetworkManager sharedManager].phonenum])
            
        {
            return 2;
        }else
        {
            return 6;
        }
    }
    else
    {
        return 1;
    }

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"MyIdentifier";
    //单元格用到的cell
    UserCenterTableViewCell *cell = (UserCenterTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[UserCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSUInteger rowIndex = [indexPath row];
    if (indexPath.section==0) {
        cell.title = [[[m_cellTitlArray objectAtIndex:rowIndex] componentsSeparatedByString:@"|"] objectAtIndex:0];
        cell.imageView.image = RYCImageNamed([[[m_cellTitlArray objectAtIndex:rowIndex] componentsSeparatedByString:@"|"] objectAtIndex:1]);
    }
    else
    {
        cell.title = [[[m_cellTitlArray objectAtIndex:4] componentsSeparatedByString:@"|"] objectAtIndex:0];
        cell.imageView.image = RYCImageNamed([[[m_cellTitlArray objectAtIndex:4] componentsSeparatedByString:@"|"] objectAtIndex:1]);
    }

    [cell refresh];
    
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectTableRow = [indexPath copy];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        
        return;
    }
    else
    {
        if (indexPath.section==1) {

          
        }
        [self pushView];
    }
}
-(void)toSettingV
{
    ASettingViewController * aSetV = [[ASettingViewController alloc] init];
    [self.navigationController pushViewController:aSetV animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
}
- (void)pushView
{
    if(selectTableRow == nil)
    {
        return;
    }
    NSUInteger rowIndex = [selectTableRow row];
    NetAppType type = NET_APP_BASE;

        switch (rowIndex)
        {
                
            case 0://中奖查询
            {
                type = NET_APP_QUERY_LOT_WIN;
                
                //                [self setHidesBottomBarWhenPushed:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
                QueryLotWinViewController* viewController = [[QueryLotWinViewController alloc] init];
                viewController.navigationItem.title = @"中奖查询";
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
                
                break;
            }
            case 1:
            {
                type = NET_APP_QUERY_LOT_BET;
                [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = @"";
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
                QueryLotBetViewController* viewController = [[[QueryLotBetViewController alloc] init] autorelease];
                viewController.navigationItem.title = @"投注记录";
                viewController.isPushShow = YES;
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            case 2:
            {
                type = NET_APP_GET_CASH;
                break;
            }
            case 3://账户明细
            {
                type = NET_APP_ACCOUNT_DETAIL;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
                QueryAccountDetailViewController* viewController = [[QueryAccountDetailViewController alloc] init];
                viewController.navigationItem.title =@"账户明细",
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
                break;
            }
                case 4://彩豆明细
            {
                type = NET_APP_CAIDOU_DETAIL;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
                QueryCaidouBalanceViewController* viewController = [[QueryCaidouBalanceViewController alloc] init];
                viewController.navigationItem.title =@"彩豆明细",
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
                break;
            }
                case 5://消息中心
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
                MessageCenterViewController* viewController = [[MessageCenterViewController alloc] init];
                viewController.navigationItem.title =@"消息中心",
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
                break;
            }
            default:
                break;
        }
    [RuYiCaiNetworkManager sharedManager].netAppType = type;
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}

@end

