//
//  RYCLoginView.m
//  RuYiCai
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RYCLoginView.h"
#import "RYCForgetPasswordView.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCRegisterView.h"
#import "SharePublicCell.h"
#import "UINavigationBarCustomBg.h"
#import "AdaptationUtils.h"
//#import "AliLog.h"
#import "ColorUtils.h"
#import "BindeUserAccountVC.h"
#import "CheckoutViewController.h"
#define ALI_MOD   ("SPTicketViewController")


//新浪
#define kAppKey             @"3497762629"
#define kAppSecret          @"d8d9128d2dfd8f8f32da3281f852c4f1"
#define kAppRedirectURI     @"http://www.boyacai.com/"

@interface RYCLoginView ()

- (void)trustload;
- (NSString *)datastring:(NSString*) partnerId setuserID:(NSString*) appUserID;
- (void)dataload;
//- (NSString *)trustLogin:(NSString*) partnerId setuserID:(NSString*) appUserID;
- (void)lanchstring:(NSString*) sb;
- (void)addInfo:(UITextField*)text addText:(NSString*)str;

@end


@implementation RYCLoginView

@synthesize loginPhonenumTextField = m_loginPhonenumTextField;
@synthesize loginPswTextField = m_loginPswTextField;
@synthesize rememberMyLoginStatusPswButton = m_rememberMyLoginStatusPswButton;
@synthesize useClearPws;
@synthesize isRemberMyLoginStatus;
@synthesize isUseclearPws;
@synthesize userId=_userId;

@synthesize myTableView = m_myTableView;
@synthesize userInfo;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"firstUseUnionLoginOk" object:nil];
    [m_loginPhonenumTextField release];
    [m_loginPswTextField release];
    [useClearPws release];
//    [m_rememberMyLoginStatusPswButton release];
    [_userId release];
    [m_loginView release];
    [m_registerView release];
    
    [m_myTableView release], m_myTableView = nil;
//    [_tencentOAuth release];
    [_permissions release];
    
//    sinaweibo.delegate = nil;
//    [sinaweibo release], sinaweibo = nil;
    [userInfo release], userInfo = nil;
    
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statView];
        [statView release];
    }
    [self.navigationBar setHidden:YES];
    [self.navigationBar setBackground];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#f7f3ec"];
    UIImageView  *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    navImageView.image = [UIImage imageNamed:@"title_bg.png"];
    [self.view insertSubview:navImageView atIndex:100];
    [navImageView release];
    
    float startY = [[UIScreen mainScreen] bounds].size.height;
    self.view.frame = CGRectMake(0, startY, 320, startY);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstUseUnionLoginOk:) name:@"firstUseUnionLoginOk" object:nil];
    
    
    isRemberPsw = [RuYiCaiNetworkManager sharedManager].m_loginAutoRememberPsw;
    
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //    [self.navigationBar setBackground];
    [self.navigationController.navigationBar setBackground];
    
    //    [m_delegate readAutoLoginPlist];
    isExpendCoop = NO;//默认闭合
    
    _permissions =  [[NSArray arrayWithObjects:
					  @"get_user_info",@"add_share", @"add_topic",@"add_one_blog", @"list_album",
					  @"upload_pic",@"list_photo", @"add_album", @"check_page_fans",nil] retain];
//    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100392744"
//											andDelegate:self];
//	_tencentOAuth.redirectURI = @"www.qq.com";
//    
//    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
//        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
//        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
//        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    isRemberMyLoginStatus = m_delegate.autoRememberMystatus;
    [self setMainView];
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    }
- (void)setMainView
{
//    isRemberMyLoginStatus = YES;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 30)];
    titleLabel.text = @"用户登录";
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    //    titleLabel.tag =
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(10, 26, 52, 30);
    
    [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_normal.png"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_click.png"] forState:UIControlStateHighlighted];
    [registerButton setTitle:@"返回" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [registerButton addTarget:self action: @selector(cancelLoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    m_loginView = [[UIView alloc] initWithFrame:CGRectMake(20, 20 + 45+20, 280, 100)];
    UIImageView* imageC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
    imageC.image = RYCImageNamed(@"topinfo_c_bg.png");
    [m_loginView addSubview:imageC];
    [imageC release];
    [self.view addSubview:m_loginView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 40)];
    nameLabel.text = @"账   号";
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.textColor = [ColorUtils parseColorFromRGB:@"#b4b1ad"];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    [m_loginView addSubview:nameLabel];
    [nameLabel release];
    
    m_loginPhonenumTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 190, 40)];
    m_loginPhonenumTextField.borderStyle = UITextBorderStyleNone;
    m_loginPhonenumTextField.delegate = self;
    m_loginPhonenumTextField.font = [UIFont systemFontOfSize:15];
    m_loginPhonenumTextField.placeholder = @"请输入注册时的手机号";
    m_loginPhonenumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_loginPhonenumTextField.keyboardType = UIKeyboardTypeDefault;
    m_loginPhonenumTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_loginPhonenumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_loginPhonenumTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_loginPhonenumTextField.returnKeyType = UIReturnKeyDone;
    [m_loginView addSubview:m_loginPhonenumTextField];
    
    
    UILabel *pswLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 53, 100, 40)];
    pswLabel.text = @"密   码";
    pswLabel.textAlignment = UITextAlignmentLeft;
    pswLabel.textColor =[ColorUtils parseColorFromRGB:@"#b4b1ad"];
    pswLabel.font = [UIFont boldSystemFontOfSize:15];
    pswLabel.backgroundColor = [UIColor clearColor];
    [m_loginView addSubview:pswLabel];
    [pswLabel release];
    
    m_loginPswTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 53, 190, 40)];
    m_loginPswTextField.borderStyle = UITextBorderStyleNone;
    m_loginPswTextField.delegate = self;
    m_loginPswTextField.font = [UIFont systemFontOfSize:15];
    m_loginPswTextField.placeholder = @"6-16个字母，数字组成";
    m_loginPswTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_loginPswTextField.keyboardType = UIKeyboardTypeEmailAddress;
    m_loginPswTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_loginPswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_loginPswTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_loginPswTextField.returnKeyType = UIReturnKeyDone;
    m_loginPswTextField.secureTextEntry = YES;
    [m_loginView addSubview:m_loginPswTextField];
    
//    m_rememberMyLoginStatusPswButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 260, 23, 23)];
    
    m_rememberMyLoginStatusPswButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [m_rememberMyLoginStatusPswButton setFrame:CGRectMake(40, 260, 23, 23)];
    
//    [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateNormal];
//    [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
    [m_rememberMyLoginStatusPswButton addTarget:self action:@selector(rememberPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_rememberMyLoginStatusPswButton];
    
//    UILabel *LoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 260, 150, 25)];
//    LoginLabel.text = @"自动登录";
//    LoginLabel.textAlignment = UITextAlignmentLeft;
//    LoginLabel.textColor = [UIColor blackColor];
//    LoginLabel.font = [UIFont boldSystemFontOfSize:15];
//    LoginLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:LoginLabel];
//    [LoginLabel release];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(20, 205,280, 35);
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [_loginButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    [_loginButton addTarget:self action: @selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton addTarget:self action: @selector(loginInsideButtonClick:) forControlEvents:UIControlEventTouchDown];
    [_loginButton addTarget:self action: @selector(loginOutsideButtonClick:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:_loginButton];
    
//    if (isRemberMyLoginStatus)
//    {
//        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateNormal];
////        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
//    }
//    else
//    {
//        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateNormal];
////        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
//    }
    
    //注册找回密码
    m_registerView = [[UIView alloc] initWithFrame:CGRectMake(20,300, 280, 100)];
    UIImageView* registerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
    registerImageView.image = RYCImageNamed(@"topinfo_c_bg.png");
    [m_registerView addSubview:registerImageView];
    [registerImageView release];
    [self.view addSubview:m_registerView];
    
    UILabel *newUserLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    newUserLable.text = @"新用户注册";
    [m_registerView addSubview:newUserLable];
    [newUserLable release];
    
    UIImageView *accessImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loging_access_log.png"]];
    accessImageView.frame = CGRectMake(260,18 , 10, 16);
    [m_registerView addSubview:accessImageView];
    [accessImageView release];
    
    
    UIButton *newUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newUserBtn.backgroundColor = [UIColor clearColor];
    newUserBtn.frame = CGRectMake(0, 0, 280, 50);
    [newUserBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_registerView addSubview:newUserBtn];
    
    //注册找回密码
    
    UILabel *forGetPsdUserLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 30)];
    forGetPsdUserLable.text = @"找回密码";
    [m_registerView addSubview:forGetPsdUserLable];
    [forGetPsdUserLable release];
    
    UIImageView *accessForGetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loging_access_log.png"]];
    accessForGetImageView.frame = CGRectMake(260,65 , 10, 16);
    [m_registerView addSubview:accessForGetImageView];
    [accessForGetImageView release];
    
    
    UIButton *forGetPsdUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forGetPsdUserBtn.backgroundColor = [UIColor clearColor];
    forGetPsdUserBtn.frame = CGRectMake(0, 50, 280, 50);
    [forGetPsdUserBtn addTarget:self action:@selector(forgetPasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_registerView addSubview:forGetPsdUserBtn];
    
    UILabel *serviceLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 400, 80, 40)];
    serviceLable.text = @"客服热线:";
    serviceLable.font = [UIFont systemFontOfSize:15];
    serviceLable.backgroundColor = [UIColor clearColor];
    serviceLable.textColor = [ColorUtils parseColorFromRGB:@"#7a746b"];
    [self.view addSubview:serviceLable];
    [serviceLable release];
    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceButton.frame = CGRectMake(150, 400, 120, 40);
    [serviceButton setTitle:@"400-856-1000" forState:UIControlStateNormal];
    serviceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [serviceButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [serviceButton addTarget:self action:@selector(serviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceButton];
    
    [self setM_rememberBtn];
    //合作登录布局
//    [self setCooperationLogin];
    
}

- (void)setCooperationLogin
{
    _cooperationView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-93/2, 320, 90)];
    _cooperationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_cooperationView];
    [_cooperationView release];
    UIButton *libCooperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    libCooperBtn.frame = CGRectMake(0, 0, 320, 93/2);
    [libCooperBtn setBackgroundImage:[UIImage imageNamed:@"hezuo_login_bg.png"] forState:UIControlStateNormal];
    [libCooperBtn addTarget:self action:@selector(isExpendClick) forControlEvents:UIControlEventTouchUpInside];
    [_cooperationView addSubview:libCooperBtn];
    UIImageView *logBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 93/2, 320, 90-93/2)];
    logBottomImageView.image  = [UIImage imageNamed:@"hezuo_login_c_bg.png"];
    [_cooperationView addSubview:logBottomImageView];
    [logBottomImageView release];
    
    UIButton *sinaLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaLoginButton setBackgroundImage:[UIImage imageNamed:@"sina_coop_login.png"] forState:UIControlStateNormal];
    sinaLoginButton.frame = CGRectMake(120, 50,69/2 , 69/2);
    [sinaLoginButton addTarget:self action:@selector(sinaCoopLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_cooperationView addSubview:sinaLoginButton];
    
    UIButton *tencentLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tencentLoginButton setBackgroundImage:[UIImage imageNamed:@"tencent_coop_login.png"] forState:UIControlStateNormal];
    tencentLoginButton.frame = CGRectMake(170, 50,69/2 , 69/2);
    [tencentLoginButton addTarget:self action:@selector(tencentCoopLoginClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_cooperationView addSubview:tencentLoginButton];
}

- (void)isExpendClick
{
    isExpendCoop = !isExpendCoop;
    if (isExpendCoop)
    {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.2f];
        _cooperationView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-90, 320, 90);
        [UIView commitAnimations];
        
        
    }else
    {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.2f];
        _cooperationView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-93/2, 320, 90);
        [UIView commitAnimations];
        
    }
}
//电话按钮事件
- (void)serviceBtnClick
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceName = [device model];
    if([deviceName isEqualToString:@"iPad"] || [deviceName isEqualToString:@"iPod touch"])
    {
        [[RuYiCaiNetworkManager sharedManager]showMessage:@"当前设备没有打电话功能！" withTitle:@"提示" buttonTitle:@"确定"];
    }else
    {
        NSURL *phoneNumberURL = [NSURL URLWithString:@"telprompt://4008561000"];
        
        [[UIApplication sharedApplication] openURL:phoneNumberURL];
    }
}
- (void)loginInsideButtonClick:(id)sender
{
    [_loginButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#820000"]];
}
- (void)loginOutsideButtonClick:(id)sender
{
    [_loginButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
}

- (void)cancelLoginClick:(id)sender
{
    if ([RuYiCaiNetworkManager sharedManager].goBackType == GO_GDSZ_TYPE)
    {
        [m_loginPhonenumTextField resignFirstResponder];
        [m_loginPswTextField resignFirstResponder];
        [self dismissModalView:nil];
    }else
    {
        [m_loginPhonenumTextField resignFirstResponder];
        [m_loginPswTextField resignFirstResponder];
        m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
        [m_delegate.mainMenuTabbar selectTabTapped:@"0"];
        
        [self dismissModalView:nil];
    }
    
}

- (void)useClearPswClick
{
    [m_loginPhonenumTextField resignFirstResponder];
    [m_loginPswTextField resignFirstResponder];
    //NSLog(@"%@",m_loginPswTextField.text);
    if(isUseclearPws)
    {
        isUseclearPws = !isUseclearPws;
        m_loginPswTextField.secureTextEntry = YES;
        [useClearPws setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateNormal];
        [useClearPws setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        isUseclearPws = !isUseclearPws;
        m_loginPswTextField.secureTextEntry = NO;
        //清空一下原来的密码
        //m_loginPswTextField.text = @"";
        [useClearPws setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateNormal];
        [useClearPws setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateHighlighted];
    }
}

- (void)rememberPasswordClick:(id)sender
{
    isRemberMyLoginStatus = !isRemberMyLoginStatus;
    m_delegate.loginView.isRemberMyLoginStatus = isRemberMyLoginStatus;
    if (NO == isRemberMyLoginStatus)
    {
        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateNormal];
//        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        //        [MobClick event:@"loginPage_remeberLogin"];
        
        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateNormal];
//        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateHighlighted];
    }
    
}

- (void)forgetPasswordClick:(id)sender
{
    //    [MobClick event:@"loginPage_find_psw"];
    RYCForgetPasswordView *forgetPswView = [[RYCForgetPasswordView alloc] init];
    
    [self presentModalViewController:forgetPswView animated:YES];
    [forgetPswView release];
}

- (void)registerClick:(id)sender
{
    //    [MobClick event:@"loginPage_register"];
    
    [m_loginPhonenumTextField resignFirstResponder];
    [m_loginPswTextField resignFirstResponder];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[[[CheckoutViewController alloc] init] autorelease]];
    [self presentModalViewController:nav animated:YES];
    [nav release];
}

- (void)loginButtonClick:(id)sender
{
    m_delegate.loginView.isRemberMyLoginStatus = isRemberMyLoginStatus;
    [_loginButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_LOGIN;
    [m_loginPhonenumTextField resignFirstResponder];
    [m_loginPswTextField resignFirstResponder];
    
    if (0 == m_loginPhonenumTextField.text.length || 0 == m_loginPswTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"用户名或密码不能为空！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (m_loginPswTextField.text.length < 6 || m_loginPswTextField.text.length > 16)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码长度为6~16位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    //    [MobClick event:@"loginPage_login"];
    
    [RuYiCaiNetworkManager sharedManager].phonenum = m_loginPhonenumTextField.text;
    [RuYiCaiNetworkManager sharedManager].password = m_loginPswTextField.text;
    
    [[RuYiCaiNetworkManager sharedManager] loginWithPhonenum:m_loginPhonenumTextField.text withPassword:m_loginPswTextField.text];
}

- (void)presentModalView:(UIView *)subView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaBecomeActive:) name:@"SinaBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaHandleOpenURL:) name:@"SinaHandleOpenURL" object:nil];
    
    self.loginPhonenumTextField.text = [RuYiCaiNetworkManager sharedManager].phonenum;
    self.loginPswTextField.text = @"";
    //self.loginPswTextField.text = [RuYiCaiNetworkManager sharedManager].password;
    
	[UIView beginAnimations:@"movement" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
	CGPoint center = self.view.center;
    float startY = [[UIScreen mainScreen] bounds].size.height;
    center.y -= startY;
	self.view.center = center;
	[UIView commitAnimations];
}
- (void)presentModalView:(UIView *)subView andAddAnimationType:(BOOL)animationType
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaBecomeActive:) name:@"SinaBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaHandleOpenURL:) name:@"SinaHandleOpenURL" object:nil];
    
    self.loginPhonenumTextField.text = [RuYiCaiNetworkManager sharedManager].phonenum;
    self.loginPswTextField.text = @"";
    
    //self.loginPswTextField.text = [RuYiCaiNetworkManager sharedManager].password;
//    [self setM_rememberBtn];
    
    if (animationType) {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        float startY = [[UIScreen mainScreen] bounds].size.height;
        center.y -= startY;
        self.view.center = center;
        [UIView commitAnimations];
    }else{
        CGPoint center = self.view.center;
        float startY = [[UIScreen mainScreen] bounds].size.height;
        center.y -= startY;
        self.view.center = center;
        
    }

	
}
-(void)setM_rememberBtn
{
    isRemberMyLoginStatus = YES;
    m_delegate.loginView.isRemberMyLoginStatus = isRemberMyLoginStatus;
    if (NO == isRemberMyLoginStatus)
    {
        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateNormal];
        //        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        //        [MobClick event:@"loginPage_remeberLogin"];
        
        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateNormal];
        //        [m_rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateHighlighted];
    }
    m_rememberMyLoginStatusPswButton.hidden = YES;

}
- (void)dismissModalView:(UIView *)subView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinaBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinaHandleOpenURL" object:nil];
    
	[UIView beginAnimations:@"movement" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
    CGPoint center = self.view.center;
    float startY = [[UIScreen mainScreen] bounds].size.height;
    if(center.y == startY/2)//防止多次影藏
        center.y += startY;
    self.view.center = center;
	[UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_loginPhonenumTextField resignFirstResponder];
    [m_loginPswTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_loginPhonenumTextField resignFirstResponder];
    [m_loginPswTextField resignFirstResponder];
}

-(void)firstUseUnionLoginOk:(NSNotification *)notification{
    
    BindeUserAccountVC *bindUserAccountView = [[BindeUserAccountVC alloc] init];
    [self presentModalViewController:bindUserAccountView animated:YES];
    [bindUserAccountView release];
}
@end
