//
//  WeiXinViewController.m
//  Boyacai
//
//  Created by qiushi on 13-3-15.
//
//


#import "WeiXinViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "ActivityView.h"
#import "QWeiboSyncApi.h"
#import "QVerifyWebViewController.h"
#import "QWeiboAsyncApi.h"
#import "SBJsonParser.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kQWBSDKAppKey   @"801390953"
#define kQWBSDKAppSecret   @"4eea35f2b342fd0bd7c2bac4c513c2e8"


#import "WeiXinViewController.h"

@interface WeiXinViewController ()
@property (nonatomic, retain) NSURLConnection	*connection;
@property (nonatomic, retain) NSMutableData		*responseData;

@end

@implementation WeiXinViewController

@synthesize WeiXin_shareType;
@synthesize shareContent = m_shareContent;
@synthesize connection;
@synthesize responseData;
@synthesize m_delegate;
- (void)dealloc
{
    [m_contentView release];
    [m_ziNumLabel release];
    
    [activity_views release];
    [connection release];
	[responseData release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
//    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    activity_views = [[ActivityView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:activity_views];
    activity_views.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    
    //    UIBarButtonItem* button_Submit = [[UIBarButtonItem alloc]
    //                                      initWithTitle:@"提交"
    //                                      style:UIBarButtonItemStyleBordered
    //                                      target:self
    //                                      action:@selector(SubmitButtonClick:)];
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

//- (void)SubmitButtonClick:(id)sender
//{
//    [m_contentView resignFirstResponder];
//    //    if (m_delegate.tokenKey && ![m_delegate.tokenKey isEqualToString:@""] &&
//    //        m_delegate.tokenSecret && ![m_delegate.tokenSecret isEqualToString:@""])//跳转到发送页面
//    NSString*  token = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenKey];
//    NSString*  secret = [[NSUserDefaults standardUserDefaults] valueForKey:AppTokenSecret];
//    NSLog(@"token::%@ ,secret::%@", token, secret);
//    
//    if(token && ![token isEqualToString:@""] &&
//       secret && ![secret isEqualToString:@""])
//    {
//        RuYiCaiAppDelegate *appDelegate =
//		(RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
//        
//        NSString* content = m_contentView.text;
//        NSString *_textField=[m_contentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        if ([_textField length] == 0)
//        {
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请填写分享内容，谢谢！" withTitle:@"提示" buttonTitle:@"确定"];
//            return;
//        }
//        QWeiboAsyncApi *api = [[[QWeiboAsyncApi alloc] init] autorelease];
//        
//        self.connection	= [api publishMsgWithConsumerKey:kQWBSDKAppKey
//                                          consumerSecret:kQWBSDKAppSecret
//                                          accessTokenKey:appDelegate.tokenKey
//                                       accessTokenSecret:appDelegate.tokenSecret
//                                                 content:content
//                                               imageFile:nil
//                                              resultType:RESULTTYPE_JSON
//                                                delegate:self];
//        
//        activity_views.hidden = NO;
//        
//    }
//    else//授权页面
//    {
//        QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
//        NSString *retString = [api getRequestTokenWithConsumerKey:kQWBSDKAppKey consumerSecret:kQWBSDKAppSecret];
//        NSLog(@"Get requestToken:%@", retString);
//        
//        [m_delegate parseTokenKeyWithResponse:retString];
//        
//        NSLog(@"1:%@",[[UIApplication sharedApplication] keyWindow]);
//        QVerifyWebViewController *verifyController =
//        [[QVerifyWebViewController alloc] init];
//        
//        [[verifyController.view window] setWindowLevel:UIWindowLevelNormal];
//        NSLog(@"2:%@",[[UIApplication sharedApplication] keyWindow]);
//        [self.navigationController pushViewController:verifyController animated:YES];
//        //[self presentModalViewController:verifyController animated:YES];
//        [verifyController release];
//    }
//    
//}


- (void)SubmitButtonClick:(id)sender{
    [m_delegate onCompleteText:m_contentView.text];
}


#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	self.responseData = [NSMutableData data];
	//NSLog(@"total = %d", [response expectedContentLength]);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	RuYiCaiAppDelegate *appDelegate =
    (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.response = [[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] autorelease];
	
    NSLog(@"response ~~ %@", appDelegate.response);
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:appDelegate.response];
    
    NSLog(@"%@", [parserDict objectForKey:@"ret"]);
    NSString* resultStr = [NSString stringWithFormat:@"%@", [parserDict objectForKey:@"ret"]];//0代表成功，非0代表失败
    NSString* message = [parserDict objectForKey:@"msg"];
    //NSString* message = (NSString*)[parserDict objectForKey:@"meg"];//返回的结果值
    [jsonParser release];
    
	if([resultStr isEqualToString:@"0"])
    {
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:5];
        [tempDic setObject:@"updateUserInfo" forKey:@"command"];
        [tempDic setObject:@"addScore" forKey:@"type"];
        [tempDic setObject:@"9" forKey:@"scoreType"];
        if(self.WeiXin_shareType == WX_SHARE_DOWN_LOAD)
        {
            [tempDic setObject:@"下载地址分享(腾讯微博)" forKey:@"description"];
            [tempDic setObject:@"3" forKey:@"source"];
        }
        else if(self.WeiXin_shareType == WX_SHARE_HM_CASE)
        {
            [tempDic setObject:@"合买方案分享(腾讯微博)" forKey:@"description"];
            [tempDic setObject:@"4" forKey:@"source"];
        }
        else if(self.WeiXin_shareType == WX_SHARE_NEWS)
        {
            [tempDic setObject:@"彩票资讯分享(腾讯微博)" forKey:@"description"];
            [tempDic setObject:@"1" forKey:@"source"];
        }
        else if(self.WeiXin_shareType == WX_LOTTERY_OPEN)
        {
            [tempDic setObject:@"开奖公告分享(腾讯微博)" forKey:@"description"];
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
        
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"分享成功！" withTitle:@"提示" buttonTitle:@"确定"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"分享失败提示" buttonTitle:@"确定"];
    }
	self.connection = nil;
    activity_views.hidden = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	RuYiCaiAppDelegate *appDelegate =
	(RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.response = [NSString stringWithFormat:@"connection error:%@", error];
    
	[[RuYiCaiNetworkManager sharedManager] showMessage:@"分享失败！" withTitle:@"提示" buttonTitle:@"确定"];
    
    
    
    self.connection = nil;
    activity_views.hidden = YES;
}


#pragma mark textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshZiLabelText];
}


@end
