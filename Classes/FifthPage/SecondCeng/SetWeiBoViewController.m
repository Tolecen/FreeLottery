//
//  SetWeiBoViewController.m
//  RuYiCai
//
//  Created by  on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SetWeiBoViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "QVerifyWebViewController.h"
#import "QWeiboSyncApi.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"
#import "My_WeiBoCell.h"

//新浪
//#define kWBSDKDemoAppKey   @"332929882"
//#define kWBSDKDemoAppSecret   @"8dce19e73afe6348f7ae0a752b5db334"
#define kAppKey             @"3497762629"
#define kAppSecret          @"d8d9128d2dfd8f8f32da3281f852c4f1"
#define kAppRedirectURI     @"http://www.boyacai.com/"

//腾讯
#define kQWBSDKAppKey   @"801390953"
#define kQWBSDKAppSecret   @"4eea35f2b342fd0bd7c2bac4c513c2e8"

@implementation SetWeiBoViewController

@synthesize myTableView = m_myTableView;
//@synthesize weiBoEngine_xinLang;

- (void)dealloc
{    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"xinLangViewHideOk" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinaBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinaHandleOpenURL" object:nil];

    [m_myTableView release], m_myTableView = nil;
    
    sinaweibo.delegate = nil;
    [sinaweibo release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xinLangViewHideOk:) name:@"xinLangViewHideOk" object:nil];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaBecomeActive:) name:@"SinaBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaHandleOpenURL:) name:@"SinaHandleOpenURL" object:nil];
    [BackBarButtonItemUtils addBackButtonForController:self];

    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_myTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self queryWeiBoState];
}

- (void)queryWeiBoState
{
    //新浪
    BOOL authValid = sinaweibo.isAuthValid;
    
    if (authValid)//已授权//已登陆
    {
        m_xinLangState = YES;
    }
    else
    {
        m_xinLangState = NO;
    }
    //腾讯
    NSString*  token = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenKey];
    NSString*  secret = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenSecret];    
    if(token && ![token isEqualToString:@""] && 
       secret && ![secret isEqualToString:@""])
    {
        m_tengXunState = YES;        
    } 
    else//授权页面
    {
        m_tengXunState = NO;
    }
    [self.myTableView reloadData];
}

- (void)pressSwitch:(id)sender
{
	UISwitch *temp = (UISwitch *)sender;
    int swithTag = temp.tag;
    if(0 == swithTag)
    {
        if(temp.on)
        {
            [sinaweibo logIn];
        }
        else
        {
            [sinaweibo logOut];
            [self removeAuthData];
        }
    }
    else
    {
        if(temp.on)
        {
            QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
            NSString *retString = [api getRequestTokenWithConsumerKey:kQWBSDKAppKey consumerSecret:kQWBSDKAppSecret];
            NSLog(@"Get requestToken:%@", retString);
            
            [m_delegate parseTokenKeyWithResponse:retString];
            
            QVerifyWebViewController *verifyController = 
            [[QVerifyWebViewController alloc] init];
            
            [self.navigationController pushViewController:verifyController animated:YES];
            [verifyController release];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:AppTokenKey];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:AppTokenSecret];
            [[NSUserDefaults standardUserDefaults] synchronize];//同步 
        }
    }
    //[self queryWeiBoState];
}

//- (void)xinLangViewHideOk:(NSNotification*)notification
//{
//    [self queryWeiBoState];
//}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -  客户端回调消息
- (void)SinaHandleOpenURL:(NSNotification*)notification
{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary*)obj;
        NSURL* url = [dict objectForKey:@"sinaURL"];
        NSLog(@"urlll: %@", url);
        [sinaweibo handleOpenURL:url];
    }
}

- (void)SinaBecomeActive:(NSNotification*)notification
{
    [sinaweibo applicationDidBecomeActive];
}

#pragma mark - WBEngineDelegate 登陆
#pragma mark Authorize 新浪
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录成功!" withTitle:@"提示" buttonTitle:@"确定"];
     [self queryWeiBoState];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录失败!" withTitle:@"提示" buttonTitle:@"确定"];
    [self queryWeiBoState];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo//取消登陆
{
    [self queryWeiBoState];
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
    [self queryWeiBoState];

    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
}

//- (void)engineAlreadyLoggedIn:(WBEngine *)engine
//{
//    if ([engine isUserExclusive])
//    {
//        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
//                                                           message:@"请先登出！" 
//                                                          delegate:nil
//                                                 cancelButtonTitle:@"确定" 
//                                                 otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//    }
//}
//
//- (void)engineDidLogIn:(WBEngine *)engine//WBEngine协议登陆成功后回调方法
//{
//    //activity_views.hidden = YES;
//    [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录成功!" withTitle:@"提示" buttonTitle:@"确定"];
//    [self queryWeiBoState];
//}
//
//- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
//{
//    //activity_views.hidden = YES;
//    NSLog(@"didFailToLogInWithError: %@", error);
//    [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录失败!" withTitle:@"提示" buttonTitle:@"确定"];
//    [self queryWeiBoState];
//}
//
////- (void)engineDidLogOut:(WBEngine *)engine//退出写微博界面，其实就是注销登陆
////{
////    [[RuYiCaiNetworkManager sharedManager] showMessage:@"解绑成功!" withTitle:@"提示" buttonTitle:@"确定"];
////}
//
//- (void)engineNotAuthorized:(WBEngine *)engine
//{
//    
//}
//
//- (void)engineAuthorizeExpired:(WBEngine *)engine
//{
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
//													   message:@"请重新登录！" 
//													  delegate:nil
//											 cancelButtonTitle:@"确定" 
//											 otherButtonTitles:nil];
//	[alertView show];
//	[alertView release];
//}
//

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    My_WeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[My_WeiBoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(0 == indexPath.row)
    {
        cell.titleLable.text = @"新浪微博绑定";
        cell.accessoryImageView.image = [UIImage imageNamed:@"share_xinlang.png"];

        if(m_xinLangState)
        {
            cell.swith.on = YES;
        }
        else
        {
            cell.swith.on = NO;
        }
        cell.swith.tag = 0;
    }
    else if(1 == indexPath.row)
    {
        cell.titleLable.text = @"腾讯微博绑定";
        cell.accessoryImageView.image = [UIImage imageNamed:@"share_tengxu.png"];
        if(m_tengXunState)
        {
            cell.swith.on = YES;
        }
        else
        {
            cell.swith.on = NO;
        }
        cell.swith.tag = 1;
    }
    [cell.swith addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
