
//  RuYiCaiAppDelegate.m
//  RuYiCai
//
//  Created by ruyicai on 09-3-28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiAppDelegate.h"
#import "RuYiCaiViewController.h"
#import "RuYiCaiStartViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "CommonRecordStatus.h"
#import "NdUncaughtExceptionHandler.h"//异常捕获
#import "NSLog.h"

#import <sys/utsname.h>//腾讯微博
//#import "NSURL+QAdditions.h"
#import "Custom_tabbar.h"
#import "CustomTabBarViewController.h"


#import "YouMiConfig.h"

//#import "MobClick.h"//友盟

#import "ActivityView.h"
#import "KGStatusBar.h"
//shareSDK
#import <ShareSDK/ShareSDK.h>
#import "WeiBoApi.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <RennSDK/RennSDK.h>


@interface RuYiCaiAppDelegate (internal)
- (NSString*)getPath;
- (void)readUserPlist;
- (void)saveUserPlist;
- (BOOL)isSingleTask;
- (void)parseURL:(NSURL *)url application:(UIApplication *)application;

@end

@implementation RuYiCaiAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize randomPickerView;
@synthesize loginView;
@synthesize activityView= m_activityView;
@synthesize autoRememberMystatus = m_autoRememberMystatus;
@synthesize autoLoginRandomNumber = m_autoLoginRandomNumber;

@synthesize isShowNewFuctionInfo = m_isShowNewFuctionInfo;

@synthesize tokenKey;
@synthesize tokenSecret;
@synthesize verifier;
@synthesize response;
@synthesize isStartYaoYiYao = m_isStartYaoYiYao;
@synthesize mainMenuTabbar  = _mainMenuTabbar;
#pragma mark 友盟
- (void)umengTrack {
//    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    //    [MobClick setAppVersion:@"2.0"]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //
//    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:kRuYiCaiCoopid];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    //    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
}

#pragma mark -
#pragma mark Application lifecycle

- (void)showLoading:(id)sender
{
    NSTrace();
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    //[NSThread sleepForTimeInterval:kStartViewShowTime];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    m_startViewController.view.hidden = YES;
    [m_startViewController.view removeFromSuperview];
    
    
    self.window.backgroundColor = [UIColor blackColor];
    
    _mainMenuTabbar =[[CustomTabBarViewController alloc]initViewController];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
        self.window.rootViewController = _mainMenuTabbar;
    else
       [self.window addSubview:_mainMenuTabbar.view];
	_mainMenuTabbar.view.hidden = NO;
	
    [self.window addSubview:randomPickerView.view];
    randomPickerView.view.hidden = NO;
    
    [self.window addSubview:loginView.view];
    loginView.view.hidden = NO;
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"IDFA:%@",idfa);
    
    [self.window addSubview:m_activityView];
    
	[self.window makeKeyAndVisible];
    
    [pool release];
}

- (void)showStartView
{
    NSTrace();
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self.window addSubview:m_startViewController.view];
    m_startViewController.view.hidden = NO;
	
    [self.window makeKeyAndVisible];
}
- (void)initializePlat
{
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"4029149914"
                               appSecret:@"8272b89ca8f31f1f217f003063e21c33"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801513226"
                                  appSecret:@"6645b60977f79bf536baf8172f8f4a6f"
                                redirectUri:@"http://www.app111.com/info/830055983/"
                                   wbApiCls:[WeiboApi class]];
    
    /**
     连接人人网应用以使用相关功能，此应用需要引用RenRenConnection.framework
     http://dev.renren.com上注册人人网开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectRenRenWithAppId:@"268956"
                              appKey:@"9dc7e56740cb4b15ba2b2426489d416e"
                           appSecret:@"2b8458e71a1e4091bad93daab67eb296"
                   renrenClientClass:[RennClient class]];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"101113483"
                           appSecret:@"e5c65e7ad240578365971b1a97876757"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"101113483"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx61a7e3cdad8e201c" wechatCls:[WXApi class]];
}
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSTrace();
    
    [ShareSDK registerApp:@"eefa7b0ec35"];
    [self initializePlat];

    [[RuYiCaiNetworkManager sharedManager] readUserPlist];
    
    //自动登录
    m_autoLoginRandomNumber = @"";
    [self readAutoLoginPlist];
    
//    [[RuYiCaiNetworkManager sharedManager] softwareUpdate];
//    [[RuYiCaiNetworkManager sharedManager] getExchangeScaleForAdwall];
//    [[RuYiCaiNetworkManager sharedManager] updateImformationOfLotteryInServers];//获取彩票显示信息
//    [[RuYiCaiNetworkManager sharedManager] updateImformationOfPayStationInServers];//获取支付显示信息
    
    
    
    randomPickerView = [[RandomPickerViewController alloc] init];
    m_startViewController = [[RuYiCaiStartViewController alloc] init];
	loginView = [[RYCLoginView alloc] init];
    
    m_activityView = [[ActivityView alloc] initWithFrame:CGRectZero];
    
    [self showStartView];
//    self.window.backgroundColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [self loadDefaultKey];//腾讯微博
   
    [NdUncaughtExceptionHandler setDefaultHandler];//异常捕获
    [self sendException];
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    //摇一摇
    
    //没有用，需要自己控制摇一摇的开启关闭
    application.applicationSupportsShakeToEdit = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"YaoYiYao"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"YaoYiYao"];
        [[NSUserDefaults standardUserDefaults] synchronize];//同步
    }
    if ([@"yes" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"YaoYiYao"]]) {//默认 摇一摇开启
        self.isStartYaoYiYao = YES;
    }
    else
    {
        self.isStartYaoYiYao = NO;
    }
    
    [self setDefaultExChangeScale];
    //向微信注册id
//    [WXApi registerApp:@"wx56e45581ef7e3210"];
    
    //友盟访问设备的openudid
    //苹果appstore统计
    [MobClick startWithAppkey:@"532aaac256240b47db0b151b" reportPolicy:SEND_ON_EXIT channelId:@""];
    [DianRuAdWall beforehandAdWallWithDianRuAppKey:@"0000911311000001"];
    
    if (launchOptions) {
        //截取apns推送的消息
        NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        [self havePushNotification:pushInfo];
        
        
    }
    
    return YES;
}

-(void)setDefaultExChangeScale
{
    NSString * theV = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADWallExchangeScale"];
    if (!theV) {
        [[NSUserDefaults standardUserDefaults] setObject:@"250" forKey:@"ADWallExchangeScale"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (NSString*)getPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
        //第一位保存是否已经使用过了开机介绍
		NSString* strSub = @"/newfuctioninfo.plist";
        NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[strSub lastPathComponent]];
		return dPath;
	}
	return nil;
}

- (void)readUserPlist
{
    m_isShowNewFuctionInfo = NO;
    NSString* strPath = [self getPath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPath] == NO)
		return;
	
	NSMutableArray* userList = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
    NSString* strNewFuction = @"";
    if ([userList count] == 1) {
        strNewFuction = [userList objectAtIndex:0];
    }
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];//当前版本号，与保存的是否一样
    if (strNewFuction.length > 0 && [version isEqual:strNewFuction])
    {
        m_isShowNewFuctionInfo = YES;
    }
    [userList release];
}

- (void)saveUserPlist
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];//保存版本号
    NSLog(@"%@", version);
    
    NSMutableArray* userList = [[NSMutableArray alloc] init];
    [userList addObject:version];
    
    NSString* strPath = [self getPath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
    
    [userList writeToFile:strPath atomically:YES];
    [userList release];
}
 
- (void)resetUserPlist
{
    NSString* strPath = [self getPath];
	NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application 
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    [DianRuAdWall dianruOnPause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application 
{
    
    if ([RuYiCaiNetworkManager sharedManager].beginCalOutComment>0) {
        NSTimeInterval nowT = [[NSDate date] timeIntervalSince1970];
        NSLog(@"intime:%f,originTime:%f,cha:%f",nowT,[RuYiCaiNetworkManager sharedManager].beginCalOutComment,nowT-[RuYiCaiNetworkManager sharedManager].beginCalOutComment);
        if (nowT-[RuYiCaiNetworkManager sharedManager].beginCalOutComment>30) {
            [RuYiCaiNetworkManager sharedManager].beginCalOutComment=0;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的评价，接下来我们会审核您的评价，如果满足要求，系统会为您加上相应的彩豆，这个时间可能会有半个小时到几小时，不要着急哦^_^" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];
            [alert release];
            if([RuYiCaiNetworkManager sharedManager].hasLogin)
            {
             }
        }
        else
        {
            [RuYiCaiNetworkManager sharedManager].beginCalOutComment=0;
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，你确定你评价了么。。。再点一次去评价吧！~" delegate:self cancelButtonTitle:@"好吧，被发现了" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
    }
}

#pragma mark 异常处理
- (void)sendException
{
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* excPath = [docPath stringByAppendingPathComponent:@"Exception.txt"];
    
    NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:excPath] == NO)
		return;
    NSString*  contentStr = [NSString stringWithContentsOfFile:excPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"啊啊啊啊啊 %@", contentStr);

    if(contentStr.length > 0)
    {
        [[RuYiCaiNetworkManager sharedManager] sendException:contentStr];
    }
}

#pragma mark 推送
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"嘻嘻嘻嘻 My token is: %@", deviceToken);
//    NSString* tokenStr = [deviceToken description];
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSLog(@"regisger success:%@", deviceTokenStr);
    //注册成功，将deviceToken保存到应用服务器数据库中
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenStr = %@",deviceTokenStr);
    //NSLog(@"%d", tokenStr.length);
    [CommonRecordStatus commonRecordStatusManager].deviceToken = deviceTokenStr;
    NSLog(@"%@",[CommonRecordStatus commonRecordStatusManager].deviceToken);
}
//-(void)application:(UIApplication *)applicationdidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSLog(@"嘻嘻嘻嘻 My token is: %@", deviceToken);
//    NSString* tokenStr = [deviceToken description];
//    //NSLog(@"%d", tokenStr.length);
//    [CommonRecordStatus commonRecordStatusManager].deviceToken = [tokenStr substringWithRange:NSMakeRange(1, tokenStr.length - 2)];
//    NSLog(@"%@",[CommonRecordStatus commonRecordStatusManager].deviceToken);
//}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"呜呜呜呜 Failed to get token, error: %@", error);
    [CommonRecordStatus commonRecordStatusManager].deviceToken = @"";
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{
    //它是类里自带的方法,这个方法得说下，很多人都不知道有什么用，它一般在整个应用程序加载时执行，挂起进入后也会执行，所以很多时候都会使用到，将小红圈清空
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //新浪微博回调
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SinaBecomeActive" object:nil];
    if ([RuYiCaiNetworkManager sharedManager].shouldRefreshShaiZiTimer) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"freshShaiZiTimer" object:nil];
    }
    [DianRuAdWall dianruOnResume];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([userInfo objectForKey:@"type"]) {
        [self havePushNotification:userInfo];
    }
}

//本地消息回调
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@,  %d",notification.alertBody, [UIApplication sharedApplication].applicationIconBadgeNumber);
    [[RuYiCaiNetworkManager sharedManager] showMessage:notification.alertBody withTitle:nil buttonTitle:notification.alertAction];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}



#pragma mark  自动登陆
- (NSString*)getAutoLoginPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
		NSString* strSub = @"/autologin.plist";
        NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[strSub lastPathComponent]];
		return dPath;
	}
	return nil;
}

- (void)readAutoLoginPlist
{
    m_autoRememberMystatus = NO;
    NSString* strPath = [self getAutoLoginPath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPath] == NO)
		return;
	
	NSMutableArray* userList = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
    NSString* strAutoLogin = @"";
    NSString* strAutoLoginRandomNumber = @"";
    if ([userList count] == 2)
    {
        strAutoLogin = (NSString*)[userList objectAtIndex:0];
        
        NSLog(@"adsgasgsdg------:%@",[userList objectAtIndex:1]);
        strAutoLoginRandomNumber = (NSString*)[userList objectAtIndex:1];
    }
 
    NSString *showFuction = @"1";
    m_autoLoginRandomNumber = @"";

    if (strAutoLogin.length > 0 && [showFuction isEqual:strAutoLogin] && [strAutoLoginRandomNumber length] > 0)
        {
            m_autoRememberMystatus = YES;
            m_autoLoginRandomNumber = [m_autoLoginRandomNumber stringByAppendingString:strAutoLoginRandomNumber];
//            m_autoLoginRandomNumber = @"1c69808c-c91d-4c17-8be3-f48136399d66"; //13556403388
        }

    [userList release];
}

- (void)saveAutoLoginPlist
{
    NSMutableArray* userList = [[NSMutableArray alloc] init];
    if ([m_autoLoginRandomNumber length] > 0) 
    {
        [userList addObject:@"1"];
        [userList addObject:m_autoLoginRandomNumber];   
    }
    else
    {
        [userList release];
        return;
    }

    NSString* strPath = [self getAutoLoginPath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];

    [userList writeToFile:strPath atomically:YES];
    [userList release];
    m_autoRememberMystatus = YES;
}

- (void)resetAutoLoginPlist
{	
    NSString* strPath = [self getAutoLoginPath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
    m_autoRememberMystatus = NO;
}

- (void)setLoginRandomNumberNil
{
    m_autoLoginRandomNumber = @"";
}

#pragma mark securityAlipay method 支付宝安全支付
- (BOOL)isSingleTask{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) { 
		return YES;
	}
	else {
		return NO;
	}
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [WXApi handleOpenURL:url delegate:self];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
////    NSString* appScheme = @"";
////    appScheme = [url scheme];
////    if([[[CommonRecordStatus commonRecordStatusManager] getZhifuAppTag:appScheme] isEqualToString:KAppScheme_Sina])
////    {
////        NSMutableDictionary* myDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
////        [myDictionary setObject:url forKey:@"sinaURL"];
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"SinaHandleOpenURL" object:myDictionary];
////
////    }
////    [self parseURL:url application:application];
//    
//
//    return [WXApi handleOpenURL:url delegate:self];
//}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {//退出安全支付时回调，根据版本的不同（将被丢弃使用ß）
//	
//    [self parseURL:url application:application];
// 
//	return YES;
//}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    NSString*   resultStr = @"";
    
    //取回 appscheme，判断 是哪个插件回调的
    NSString* appScheme = @"";
    appScheme = [url scheme];
    if([[[CommonRecordStatus commonRecordStatusManager] getZhifuAppTag:appScheme] isEqualToString:KAppScheme_Sina])
    {
        NSMutableDictionary* myDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
        [myDictionary setObject:url forKey:@"sinaURL"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SinaHandleOpenURL" object:myDictionary];
        
        return;
    }
    else if ([[[CommonRecordStatus commonRecordStatusManager] getZhifuAppTag:appScheme] isEqualToString:KAppScheme_Alipay]) {
        
////        AlixPay *alixpay = [AlixPay shared];
//        AlixPayResult *result = [alixpay handleOpenURL:url];
//        NSLog(@"%d", result.statusCode);
//        if (result)
//        {
//            if (result.statusCode == 9000)
//            {
//                resultStr = @"充值成功";
//
//                if([CommonRecordStatus commonRecordStatusManager].changeWay == 0)
//                {
//                    //返回第一界面
////                    [[Custom_tabbar showTabBar] hideTabBar:NO];
////                    [[Custom_tabbar showTabBar] when_tabbar_is_selected:0];
////                    [[NSNotificationCenter defaultCenter] postNotificationName:@"backNotification" object:nil];
//                }
//                else if([CommonRecordStatus commonRecordStatusManager].changeWay == 2)//直接支付
//                {
//                    resultStr = @"已受理\n注：若投注失败金额将存入账户，请到用户中心查询！";
////                    [[NSNotificationCenter defaultCenter] postNotificationName:@"backNotification" object:nil];
//                }
//            }
//            else
//            {
//                resultStr = result.statusMessage;
//            }
//        }	
    }
    else if([[[CommonRecordStatus commonRecordStatusManager] getZhifuAppTag:appScheme] isEqualToString:KAppScheme_Lakala]) {
        
        NSString *urlString = [url absoluteString];
        NSLog(@"urlString ----> %@",urlString);
        NSArray *array = [urlString componentsSeparatedByString:@"://"];
        NSString *dataString = [array objectAtIndex:1];
        
        if ([dataString isEqualToString:@"Completion"]) {
            resultStr = @"支付成功";
        }
        else {
            resultStr = @"支付失败";
        }
    }else if([[[CommonRecordStatus commonRecordStatusManager] getZhifuAppTag:appScheme] isEqualToString:KAppScheme_Tencent]) {
        
        NSLog(@"KAppScheme_Tencent");
        
//        [TencentOAuth HandleOpenURL:url];
//        NSString *urlString = [url absoluteString];
//        NSLog(@"urlString ----> %@",urlString);
//        NSArray *array = [urlString componentsSeparatedByString:@"://"];
//        NSString *dataString = [array objectAtIndex:1];
//        
//        if ([dataString isEqualToString:@"Completion"]) {
//            resultStr = @"支付成功";
//        }
//        else {
//            resultStr = @"支付失败";
//        }
    }else if([[[CommonRecordStatus commonRecordStatusManager] getZhifuAppTag:appScheme] isEqualToString:KAppScheme_Tencent]) {
        
        NSLog(@"KAppScheme_Tencent");
        
//        [WXApi handleOpenURL:url delegate:self];
    }
    
    if (![resultStr isEqualToString:@""]) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:resultStr
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    
}

#pragma mark 腾讯微博

- (void)loadDefaultKey
{
//	self.appKey = [[NSUserDefaults standardUserDefaults] valueForKey:AppKey];
//	self.appSecret = [[NSUserDefaults standardUserDefaults] valueForKey:AppSecret];
	self.tokenKey = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenKey];
	self.tokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenSecret];
}
- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.tokenKey = [params objectForKey:@"oauth_token"];
	self.tokenSecret = [params objectForKey:@"oauth_token_secret"];
}

- (void)saveDefaultKey {
	
//	[[NSUserDefaults standardUserDefaults] setValue:self.appKey forKey:AppKey];
//	[[NSUserDefaults standardUserDefaults] setValue:self.appSecret forKey:AppSecret];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenKey forKey:AppTokenKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenSecret forKey:AppTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc 
{
    [_mainMenuTabbar release];
    [viewController release];
    [window release];
	[randomPickerView release];
    [m_startViewController release];
    [m_autoLoginRandomNumber release];
    
    [tokenKey release];
	[tokenSecret release];
	[verifier release];

    [m_activityView release];
        
    [super dealloc];
}


#pragma mark 摇一摇 (机选)
//摇一摇 (机选)
//首先在App's Delegate中设定applicationSupportsShakeToEdit属性：
/*
 注：
 3.0以后就用：- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions ；这个方法了
 */
//- (void)applicationDidFinishLaunching:(UIApplication *)application {
//    application.applicationSupportsShakeToEdit = YES;
//    
//    [window addSubview:viewController.view];
//    [window makeKeyAndVisible];
//}
- (void)setYaoYiYao:(BOOL)isStart
{
    if (isStart) {
        self.isStartYaoYiYao = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"YaoYiYao"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        self.isStartYaoYiYao = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"YaoYiYao"];
        [[NSUserDefaults standardUserDefaults] synchronize];//同步
    }
        
}
- (void)havePushNotification:(NSDictionary*)dic
{
    if ([dic[@"type"] isEqualToString:@"announcement"]) {//系统消息
        [[RuYiCaiNetworkManager sharedManager] getNotificationWithID:dic[@"id"]];
    }
    if ([dic[@"type"] isEqualToString:@"adwall"]) {//积分墙返彩豆
        [KGStatusBar showSuccessWithStatus:[dic[@"aps"] objectForKey:@"alert"]];
    }
    if ([dic[@"type"] isEqualToString:@"buyfailed"]) {//购买失败
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"购彩失败" message:[dic[@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
    }
}


/*
//然后在你的View控制器中添加/重载canBecomeFirstResponder, viewDidAppear:以及viewWillDisappear:

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

//最后在你的view控制器中添加motionEnded：

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // your code
    }
}
*/
 

@end
