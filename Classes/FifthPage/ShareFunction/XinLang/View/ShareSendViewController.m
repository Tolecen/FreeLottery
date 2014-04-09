//
//  ShareSendViewController.m
//  RuYiCai
//
//  Created by  on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareSendViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kAppKey             @"3497762629"
#define kAppSecret          @"d8d9128d2dfd8f8f32da3281f852c4f1"
#define kAppRedirectURI     @"http://www.boyacai.com/"

@implementation ShareSendViewController

@synthesize XinLang_shareType ;
@synthesize shareContent = m_shareContent;

- (void)dealloc
{
    [m_contentView release];
    [m_ziNumLabel release];
    
    sinaweibo.delegate = nil;//一定要写在对象release前
    [sinaweibo release];
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinaBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SinaHandleOpenURL" object:nil];

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaBecomeActive:) name:@"SinaBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SinaHandleOpenURL:) name:@"SinaHandleOpenURL" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    
//    UIBarButtonItem* button_Submit = [[UIBarButtonItem alloc]
//                      initWithTitle:@"提交"
//                      style:UIBarButtonItemStyleBordered
//                      target:self
//                      action:@selector(SubmitButtonClick:)];
//    self.navigationItem.rightBarButtonItem = button_Submit;
//    [button_Submit release];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(SubmitButtonClick:) andTitle:@"提交"];
    m_contentView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
    [m_contentView becomeFirstResponder];
    m_contentView.delegate = self;
    m_contentView.font = [UIFont systemFontOfSize:15.0f];
    m_contentView.textColor = [UIColor blackColor];
    m_contentView.backgroundColor = [UIColor whiteColor];
    m_contentView.layer.cornerRadius = 8;
	m_contentView.layer.masksToBounds = YES;
    m_contentView.text = self.shareContent;
    [self.view addSubview:m_contentView];

    m_ziNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 130, 150, 30)];
    m_ziNumLabel.textColor = [UIColor grayColor];
    m_ziNumLabel.textAlignment = UITextAlignmentRight;
    m_ziNumLabel.font = [UIFont systemFontOfSize:12.0f];
    m_ziNumLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_ziNumLabel];
    
    [self refreshZiLabelText];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)refreshZiLabelText
{
//    NSInteger    ziNum = 140 - (int)m_contentView.text.length;
    NSInteger    ziNum = 140 - [[CommonRecordStatus commonRecordStatusManager] unicodeLengthOfString:m_contentView.text];

    if(ziNum >= 0)
    {
        m_ziNumLabel.text = [NSString stringWithFormat:@"还可以输入%d字", ziNum];
        m_ziNumLabel.textColor = [UIColor grayColor];
    }
    else
    {
       m_ziNumLabel.text = [NSString stringWithFormat:@"已超过%d字", [[CommonRecordStatus commonRecordStatusManager] unicodeLengthOfString:m_contentView.text] - 140];
        m_ziNumLabel.textColor = [UIColor redColor];
    }
}

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

- (void)SubmitButtonClick:(id)sender
{
    [m_contentView resignFirstResponder];

    BOOL authValid = sinaweibo.isAuthValid;
    
    if (authValid)//已授权
    {
        NSString *_textField=[m_contentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([_textField length] == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请填写分享内容，谢谢！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }

        [sinaweibo requestWithURL:@"statuses/update.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:m_contentView.text, @"status", nil]
                       httpMethod:@"POST"
                         delegate:self];
    }
    else
    {
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        NSLog(@"%@", [keyWindow subviews]);
        
        [sinaweibo logIn];
    }
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
#pragma mark Authorize
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录成功!" withTitle:@"提示" buttonTitle:@"确定"];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录失败!" withTitle:@"提示" buttonTitle:@"确定"];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    [self removeAuthData];
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
}

#pragma mark - WBEngineDelegate 发送
#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
         [[RuYiCaiNetworkManager sharedManager] showMessage:@"分享失败" withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",request.params);
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:5];
        [tempDic setObject:@"updateUserInfo" forKey:@"command"];
        [tempDic setObject:@"addScore" forKey:@"type"];
        [tempDic setObject:@"9" forKey:@"scoreType"];
        if(self.XinLang_shareType == XL_SHARE_DOWN_LOAD)
        {
            [tempDic setObject:@"下载地址分享(新浪微博)" forKey:@"description"];
            [tempDic setObject:@"3" forKey:@"source"];
        }
        else if(self.XinLang_shareType == XL_SHARE_HM_CASE)
        {
            [tempDic setObject:@"合买方案分享(新浪微博)" forKey:@"description"];
            [tempDic setObject:@"4" forKey:@"source"];
        }
        else if(self.XinLang_shareType == XL_SHARE_NEWS)
        {
            [tempDic setObject:@"彩票资讯分享(新浪微博)" forKey:@"description"];
            [tempDic setObject:@"1" forKey:@"source"];
        }
        else if(self.XinLang_shareType == XL_LOTTERY_OPEN)
        {
            [tempDic setObject:@"开奖公告分享(新浪微博)" forKey:@"description"];
            [tempDic setObject:@"2" forKey:@"source"];
        }
        if([RuYiCaiNetworkManager sharedManager].hasLogin)//只有登陆后再加积分
        {
            [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
            [tempDic setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
        }
        else
        {
            [tempDic setObject:@"" forKey:@"userno"];
            [tempDic setObject:@"" forKey:@"phonenum"];
        }
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_DONT_RESULT;
        [[RuYiCaiNetworkManager sharedManager] quXiaoNetRequest:tempDic];

        [[RuYiCaiNetworkManager sharedManager] showMessage:@"分享成功!" withTitle:@"提示" buttonTitle:@"确定"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshZiLabelText];
}

@end
