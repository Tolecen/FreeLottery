//
//  RuYiCaiNetworkManager.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"
#import "CommonRecordStatus.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"

#include <sys/socket.h> // mac地址
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIDevice+IdentifierAddition.h"
#import "ActivityView.h"
#import "LotteryOrderAndShowCommander.h"
#import "RankingViewController.h"
#import <AdSupport/AdSupport.h>

@interface RuYiCaiNetworkManager (internal)

- (NSString*)getPath;
- (void)saveUserPlist;
- (void)resetUserPlist;

@end

@implementation RuYiCaiNetworkManager

@synthesize delegate = m_delegate;
@synthesize netAppType = m_netAppType;
@synthesize goBackType = m_goBackType;
@synthesize netHelpCenterCenter = m_netHelpCenterCenter;
@synthesize netChargeQuestType = m_netChargeQuestType;
@synthesize netLotType = m_netLotType;
@synthesize bindName   = m_bindName;

@synthesize hasLogin = m_hasLogin;
@synthesize requestedAdwallSuccess;
@synthesize userno = m_userno;
@synthesize loginName = m_loginName;
@synthesize phonenum = m_phonenum;
@synthesize certid = m_certid;
@synthesize bindPhoneNum = m_bindPhoneNum;
@synthesize password = m_password;
@synthesize newsPassword = m_newsPassword;
@synthesize softwareInfo = m_softwareInfo;
@synthesize highFrequencyInfo = m_highFrequencyInfo;
@synthesize userBalance = m_userBalance;
@synthesize userLotPea;
@synthesize userPrizeBalance;
@synthesize remainingChance;
@synthesize beginCalOutComment;
@synthesize responseText = m_responseText;
@synthesize lotteryInformation = m_lotteryInformation;
@synthesize lotteryInfoList = m_lotteryInfoList;
@synthesize TopWinnerInformation = m_TopWinnerInformation;
@synthesize giftMessageText = m_giftMessageText;
@synthesize newsTitle = m_newsTitle;
@synthesize firstViewController = m_firstViewController;
@synthesize secondViewController = m_secondViewController;
@synthesize thirdViewController = m_thirdViewController;
@synthesize fourthViewController = m_fourthViewController;
@synthesize fifthViewController = m_fifthViewController;
@synthesize rankingViewController = m_rankingViewController;
@synthesize isSafari;
@synthesize m_loginAutoRememberPsw;
@synthesize recentEventInfo = m_recentEventInfo;
@synthesize bindEmail = m_bindEmail;
@synthesize ticketPropagandaInfo = m_ticketPropagandaInfo;
@synthesize isBindPhone;
@synthesize isRefreshUserCenter;
@synthesize m_presentId;
@synthesize userCenterInfo = m_userCenterInfo;
@synthesize shouldCheat;
@synthesize realServerURL;
//@synthesize isHideTabbar;
@synthesize activityTitleStr = m_activityTitleStr;
@synthesize queryRecordCashStr = m_queryRecordCashStr;
@synthesize jzRecentEventInfo = m_jzRecentEventInfo;
@synthesize bdRecentEventInfo = m_bdRecentEventInfo;
@synthesize bindNewPhoneNum      = m_bindNewPhoneNum;
static RuYiCaiNetworkManager *s_networkManager = NULL;

- (void)dealloc 
{
    [_thirdOpenId release];
    [_thirdSource release];
    [m_bdRecentEventInfo release];
    [m_ticketPropagandaInfo release];
    [m_jzRecentEventInfo release];
    [m_recentEventInfo release];
//	[m_phonenum release];
//	[m_password release];
	[m_keyUrl release];
    [m_rankingViewController release];
    [m_changeUserAlertView release];
	[tempString release];
	
	[m_giftMessageText release];
    
	[m_lotteryInformation release];
    [m_lotteryInfoList release];
    
    [m_TopWinnerInformation release];
    
    [m_bindPhoneAlterView release];
    [m_bindEmailAlterView release];
    [m_bindPhoneField release];
    [m_bindEmailField release];
    
    [m_bindPhoneSecurityAlterView release];
    [m_bindPhoneSecurityField release];
    [m_cancelBindPhoneAlterView release];
    [m_cancelBindEmailAlterView release];
    
    [m_cancelOKbindPhoneAlterView release];
    [m_cancelOKbindEmailAlterView release];
    [m_setUpNicknameAlterView release];
    [m_nickNameField release];
    
//    [m_receiveLotteryAlterView release];
//    [m_receiveLotteryField release];
    
    [super dealloc];
}

- (id)init
{
	if (self = [super init])
    {
        m_hasLogin = NO;
 
        m_userno = @"";
        m_phonenum = @"";
        m_password = @"";
        m_certid = @"";
        m_bindEmail = @"";
        m_bindName = @"";
        m_loginAutoRememberPsw = NO;
        
        m_changeUserAlertView = nil;
//        m_progressAlertView = nil;
        m_bindPhoneAlterView = nil;
        m_bindEmailAlterView = nil;
        m_bindPhoneSecurityAlterView = nil;
        m_cancelBindPhoneAlterView = nil;
        m_cancelBindEmailAlterView = nil;
        m_cancelOKbindPhoneAlterView = nil;
        m_cancelOKbindEmailAlterView = nil;
//        m_receiveLotteryAlterView = nil;
        m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
        m_firstViewController = nil;
        m_secondViewController = nil;
        m_thirdViewController = nil;
        m_fourthViewController = nil;
        m_fifthViewController = nil;
        m_netAppType = NET_APP_BASE;
        m_netHelpCenterCenter = NET_MORE_BASE;
        m_netChargeQuestType = NET_CHARGE_BASE;
        isRefresh = NO;
        
        isSafari = NO;
        
        isBindPhone = YES;
        isRefreshUserCenter = NO;
        haveAlert = NO;
        
        self.shouldCheat = NO;
        self.requestedAdwallSuccess = NO;
        
        self.beginCalOutComment = 0;
        
        if ([ifCeShi isEqualToString:@"0"]) {
            self.realServerURL = NNRuYiCaiServer;
        }
        else
            self.realServerURL = CeshiRuYiCaiServer;
//        isHideTabbar = NO;
        //test code
        //m_hasLogin = YES;
        //m_phonenum = kTestPhonenum;
        //m_password = kTestPassword;
	}
    return self;
}

-(int)oneYuanToCaidou
{
    NSString * theV = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADWallExchangeScale"];
    int aas = 250;
    if (theV) {
        aas = [theV intValue];
    }
    return aas;
}

- (NSString*)constructJson:(NSMutableDictionary*)data
{
    NSTrace();
	NSMutableString* json = [NSMutableString stringWithFormat:@"{"];
	if (data)
	{
		NSArray *keys = [data allKeys];
		for (id key in keys) 
        {
			if ([key isKindOfClass:[NSString class]])
            {
				if ([keys indexOfObject:key] != [keys count] - 1)
					[json appendFormat:@"\"%@\":\"%@\",",(NSString*)key, (NSString*)[data objectForKey:key]];
				else
					[json appendFormat:@"\"%@\":\"%@\"",(NSString*)key, (NSString*)[data objectForKey:key]];
			}
		}
		[json appendString:@"}"];
        return json;
	}
    
    return @"";
}

+ (NSString *)macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

- (NSMutableDictionary*)getCommonCookieDictionary
{
    NSTrace();
    UIDevice* device = [UIDevice currentDevice];
	NSString* deviceName = [device model];
//    NSLog(@"%@", [device uniqueIdentifier]);
//    NSString* deviceImei = [[device uniqueIdentifier] substringWithRange:NSMakeRange(0, 15)];
//    NSString* deviceImsi = [[device uniqueIdentifier] substringWithRange:NSMakeRange(0, 15)];
    
    NSString* deviceImei = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString* deviceImsi = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];

    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:10];
    [mDict setObject:kRuYiCaiPlatform forKey:@"platform"];
    [mDict setObject:kRuYiCaiVersion forKey:@"softwareversion"];
    [mDict setObject:deviceName forKey:@"machineid"];
    [mDict setObject:deviceImei forKey:@"imei"];
    [mDict setObject:deviceImsi forKey:@"imsi"];
    [mDict setObject:forBoyaCoopID forKey:@"coopid"];
//    [mDict setObject:kRuYiCaiCoopid forKey:@"channel"];
//    [mDict setObject:@"" forKey:@"smscenter"];
    [mDict setObject:kRuYiCaiCoopid forKey:@"channel"];
    [mDict setObject:@"1" forKey:@"isCompress"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [mDict setObject:idfa forKey:@"mac"];
        
    }
    else
    {
        NSString *macAddress = [[UIDevice currentDevice] macaddress];
        [mDict setObject:macAddress forKey:@"mac"];
    }

    return mDict;
}
- (void)updateImformationOfLotteryInServers
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:@"buyCenter" forKey:@"requestType"];
    [mDict setObject:@"select" forKey:@"command"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    [request setRequestType:ASINetworkRequestTypeUpdateInformationOfLotteryInServers];
	[request setDelegate:self];
	[request startAsynchronous];
    
}

- (void)updateImformationOfPayStationInServers
{
    NSTrace();
    if (self.thirdSource==nil)
    {
        self.thirdSource = @"normal";
    }
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:@"rechargeCenter" forKey:@"newsType"];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:self.thirdSource forKey:@"loginType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"充值中心cookieStr:%@\nsendData:%@", cookieStr, sendData);
    [request setRequestType:ASINetworkRequestTypeUpdatePayStationInServers];
	[request setDelegate:self];
	[request startAsynchronous];
    
}
- (void)softwareUpdate
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"softwareupdate" forKey:@"command"];
    //自动登录
    [m_delegate readAutoLoginPlist];//?????????
    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
        NSString *str = m_delegate.autoLoginRandomNumber;
        [mDict setObject:str forKey:@"randomNumber"];
    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  开机联网: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeSoftUpdate];
	[request setDelegate:self];
	[request startAsynchronous];
}

-(void)cancelAutoLoginStatus
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"cancelAutoLogin" forKey:@"type"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  取消自动登录: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeCancelAutoLogin];
	[request setDelegate:self];
	[request startAsynchronous];
}


-(void)checkNewVersion
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"startUp" forKey:@"command"];
    [mDict setObject:@"upgrade" forKey:@"requestType"];
    //自动登录
//    [m_delegate readAutoLoginPlist];//?????????
//    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
//        NSString *str = m_delegate.autoLoginRandomNumber;
//        [mDict setObject:str forKey:@"randomNumber"];
//    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询新版本: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeCheckNewVersion];
	[request setDelegate:self];
	[request startAsynchronous];
}

-(void)getAdWallImportantInfo
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"announcement" forKey:@"command"];
    [mDict setObject:@"headlines" forKey:@"requestType"];
    [mDict setObject:@"1" forKey:@"type"];
    [mDict setObject:self.userno forKey:@"userno"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  获取积分墙重要通知: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetAdWallImportantInfo];
	[request setDelegate:self];
	[request startAsynchronous];
}



//获取彩豆彩金兑换比例
-(void)getExchangeScaleForAdwall
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"scoreChangeRatio" forKey:@"keyStr"];
    [mDict setObject:@"valueById" forKey:@"requestType"];
    [mDict setObject:@"info" forKey:@"command"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  兑换比例: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetExchangeScaleForAdWall];
	[request setDelegate:self];
	[request startAsynchronous];
}



- (void)updateUserInformation
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"softwareupdate" forKey:@"command"];
    //自动登录
    [m_delegate readAutoLoginPlist];//?????????
    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
        NSString *str = m_delegate.autoLoginRandomNumber;
        [mDict setObject:str forKey:@"randomNumber"];
    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  开机联网: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeUpdateInformation];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)highFrequencyInquiry:(NSString*)lotNo
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:lotNo forKey:@"lotno"];
	[mDict setObject:@"highFrequency" forKey:@"type"];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeLeftTime];
	[request setDelegate:self];
	[request startAsynchronous];

}

- (void)highFrequencyInquiryTheWinningInformation:(NSString*)lotNo Maxresult:(NSInteger)maxresult
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:lotNo forKey:@"lotno"];
	[mDict setObject:@"lastWinInfoList" forKey:@"type"];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:[NSString stringWithFormat:@"%d",maxresult] forKey:@"maxresult"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeWinningInformationMaxresult];
	[request setDelegate:self];
	[request startAsynchronous];
    
}


- (void)getBJDCDuiZhen:(NSString*)_batchCode withLotNo:(NSString*)lotno
{
    NSLog(@"%@",_batchCode);
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:lotno forKey:@"lotno"];
	[mDict setObject:@"duiZhen" forKey:@"requestType"];
    [mDict setObject:@"beiDan" forKey:@"command"];
    [mDict setObject:_batchCode forKey:@"batchcode"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"北单：%@", cookieStr);
    
    [request setRequestType:ASINetworkRequestTypeBase];
	[request setRequestTypeTwo:ASINetworkRequestTypeGetBJDCmatch_Two];
	[request setDelegate:self];
	[request startAsynchronous];
    
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)lotteryInquiry:(NSString*)lotNo reqestType:(ASINetworkReqestType)type{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:lotNo forKey:@"lotno"];
	[mDict setObject:@"highFrequency" forKey:@"type"];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    [request setRequestType:type];
	[request setDelegate:self];
	[request startAsynchronous];
}
- (void)lotterySSQInquiry{
    [self lotteryInquiry:kLotNoSSQ reqestType:ASINetworkRequestTypeSSQ];
}
- (void)lotteryDLTInquiry
{
    [self lotteryInquiry:kLotNoDLT reqestType:ASINetworkRequestTypeDLT];
}
- (void)lotteryFC3DInquiry
{
    [self lotteryInquiry:kLotNoFC3D reqestType:ASINetworkRequestTypeFC3D];
}
- (void)lottery11YDJInquiry
{
    [self lotteryInquiry:kLotNo11YDJ reqestType:ASINetworkRequestType11YDJ];
}
- (void)lottery115Inquiry
{
    [self lotteryInquiry:kLotNo115 reqestType:ASINetworkRequestType115];
}
- (void)lotterySSCInquiry
{
    [self lotteryInquiry:kLotNoSSC reqestType:ASINetworkRequestTypeSSC];
}

- (void)lotteryKLSFInquiry
{
    [self lotteryInquiry:kLotNoKLSF reqestType:ASINetworkRequestTypeKLSF];
}

- (void)lotteryCQSFInquiry
{
    [self lotteryInquiry:kLotNoCQSF reqestType:ASINetworkRequestTypeCQSF];
}

- (void)lotteryNMKSInquiry
{
    [self lotteryInquiry:kLotNoNMK3 reqestType:ASINetworkRequestTypeNMKS];
}

- (void)lotteryCQ115Inquiry
{
    [self lotteryInquiry:kLotNoCQ115 reqestType:ASINetworkRequestTypeCQ115];
}

- (void)lotteryGD115Inquiry
{
    [self lotteryInquiry:kLotNoGD115 reqestType:ASINetworkRequestTypeGD115];
}
- (void)lotteryQLCInquiry
{
    [self lotteryInquiry:kLotNoQLC reqestType:ASINetworkRequestTypeQLC];
}
- (void)lotteryPLSInquiry
{
    [self lotteryInquiry:kLotNoPLS reqestType:ASINetworkRequestTypePLS];
}
- (void)lotteryPLWInquiry
{
    [self lotteryInquiry:kLotNoPL5 reqestType:ASINetworkRequestTypePLW];
}
- (void)lotteryQXCInquiry
{
    [self lotteryInquiry:kLotNoQXC reqestType:ASINetworkRequestTypeQXC];
}

- (void)lottery22X5Inquiry
{
    [self lotteryInquiry:kLotNo22_5 reqestType:ASINetworkRequestType22X5];
}

    
//查询彩种宣传语
- (void)requestTicketPropaganda
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phoneSIM"];
	[mDict setObject:@"buyCenter" forKey:@"requestType"];
    [mDict setObject:@"select" forKey:@"command"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"彩种宣传语cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeTicketPropaganda];
	[request setDelegate:self];
	[request startAsynchronous];
    
}


- (void)highFrequencyAllInquiry:(NSString*)lotNo
{
    NSTrace();
    NSLog(@"%@",lotNo);
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
	
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:lotNo forKey:@"lotno"];
	[mDict setObject:@"highFrequency" forKey:@"type"];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeAllLeftTime];
	[request setDelegate:self];
	[request startAsynchronous];
    
}

//jingcaiType 0蓝球  1足球    jingcaiValueType 0单关 1 多管
- (void)getDataAnalysis:(NSString*)event REQUESTTYPE:(NSString*)requestType  ISZC:(int)lotType
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    if (lotType == 1) {
        [mDict setObject:@"zuCai" forKey:@"command"];
    }
    else if(lotType == 2)
    {
        [mDict setObject:@"beiDan" forKey:@"command"];
    }
    else
    {
        [mDict setObject:@"jingCai" forKey:@"command"];
    }
	
    [mDict setObject:requestType forKey:@"requestType"];
    [mDict setObject:event forKey:@"event"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    NSLog(@"竞彩球队数据分析:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetDataAnalysis];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)QueryJCLQDuiZhen:(NSString*)jingcaiType JingCaiValueType:(NSString*)jingcaivalueType
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"jcDuiZhenLimit" forKey:@"type"];
    [mDict setObject:jingcaiType forKey:@"jingcaiType"];// 0蓝球  1足球
    [mDict setObject:jingcaivalueType forKey:@"jingcaiValueType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];

    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"精彩篮球 对阵:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetJCLQDuiZhen];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
/*
 "event":"1_20120806_1_001"   
 1_20120806_1_001 (类型_day_weekid_teamid)  类型：1足球  0蓝球
*/
- (void)getDataAnalysis:(NSString*)event REQUESTTYPE:(NSString*)requestType
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:@"jingCai" forKey:@"command"];
    [mDict setObject:requestType forKey:@"requestType"];
    [mDict setObject:event forKey:@"event"]; 

    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"竞彩球队数据分析:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetDataAnalysis];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
//竞彩篮球 没有即时比分
//- (void)getInstantScore:(NSString*)state  DATE:(NSString*)date  REQUESTTYPE:(NSString*)requestType
- (void)getInstantScore:(NSMutableDictionary*) dictionary
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:dictionary];
    //	[mDict setObject:@"jingCai" forKey:@"command"];
    //    [mDict setObject:requestType forKey:@"requestType"];
    //    [mDict setObject:state forKey:@"type"];
    //    if ([date length] > 0) {
    //        [mDict setObject:date forKey:@"date"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    NSLog(@"\n竞彩即时比分:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetInstantScore];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
    
}
//- (void)getInstantScoreDetail:(NSString*)event REQUESTTYPE:(NSString*)requestType
- (void)getInstantScoreDetail:(NSMutableDictionary*)dictionary
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:dictionary];
    
    //	[mDict setObject:@"jingCai" forKey:@"command"];
    //    [mDict setObject:requestType forKey:@"requestType"];
    //    [mDict setObject:event forKey:@"event"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    NSLog(@"\n竞彩即时比分x详细@@@@@@@@@:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetInstantScoreDetail];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)zcInquiry:(NSString*)batchCode withLotNo:(NSString*)lotNo
{
	
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	if(batchCode.length != 0)
	{
		[mDict setObject:batchCode forKey:@"batchcode"];
	}
	[mDict setObject:lotNo forKey:@"lotno"];
    [mDict setObject:@"zuCai" forKey:@"command"];
    [mDict setObject:@"duiZhen" forKey:@"requestType"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    
    NSLog(@"mdict----%@ cookstring---%@---",mDict,cookieStr);
    
    [request appendPostData:sendData];
    [request buildPostBody];
    [request setRequestType:ASINetworkRequestTypeGetZCmain];
	[request setDelegate:self];
	[request startAsynchronous];
    
    
	//[tempString release];
//	tempString = [[NSMutableString alloc]init];
	
    //	NSData *mydata2=[NSData dataWithContentsOfURL:url];
    //	NSString *s = [[NSString alloc]initWithData:mydata2 encoding:NSUTF8StringEncoding];
    //	NSLog(@"sss :::%@",s);
    //   [self showURLProgressViewWithTitle:@"联网提示" message:@"加载中..."];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:nil];
}


- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data
{	
	NSString* newText = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
	if (newText != nil) 
	{
		[tempString appendString:newText];
		[newText release];
	}
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    [m_delegate.activityView disActivityView];

//	[m_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];
	if( [tempString compare:@""] !=0) //上传与下载的最后都会调用此函数
	{
		self.responseText = tempString;
		//[tempString setString:@""];
		NSLog(@"res^^^ %@",self.responseText);
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ZCTeamOK" object:nil];
	}
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//	[m_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [m_delegate.activityView disActivityView];
	UIAlertView* alert =[[UIAlertView alloc]initWithTitle: @"提示"
												  message: @"数据获取失败"
												 delegate: nil
										cancelButtonTitle: @"确定" 
										otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)selectUsernoWithPhonenum:(NSString*)phone withPassword:(NSString*)psw
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"login" forKey:@"command"];
    [mDict setObject:phone forKey:@"phonenum"];
    [mDict setObject:psw forKey:@"password"];
    if([CommonRecordStatus commonRecordStatusManager].deviceToken)
        [mDict setObject:[CommonRecordStatus commonRecordStatusManager].deviceToken forKey:@"token"];
    if([appStoreORnormal isEqualToString:@"appStore"] && [RuYiCaiOR91 isEqualToString:@"91"])
    {
        [mDict setObject:@"91appStore" forKey:@"type"];
    }
    if([appStoreORnormal isEqualToString:@"appStore"] && [RuYiCaiOR91 isEqualToString:@"RuYiCai"])
    {
        [mDict setObject:@"appStore" forKey:@"type"];
    }
    else if([appStoreORnormal isEqualToString:@"normal"] && [RuYiCaiOR91 isEqualToString:@"91"])
    {
        [mDict setObject:@"91" forKey:@"type"];
    }
    else
    {
        [mDict setObject:@"ruyicai" forKey:@"type"];
    }
    //添加 自动登录字段
    if (m_delegate.loginView.isRemberMyLoginStatus)
    {
        [mDict setObject:@"1" forKey:@"isAutoLogin"];
    }
    else
    {
        [mDict setObject:@"0" forKey:@"isAutoLogin"];
    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"查询用户编号cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeselectUserNo];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)loginWithPhonenum:(NSString*)phone withPassword:(NSString*)psw
{
    NSTrace();
    self.thirdSource = @"normal";
//    self.phonenum = phone;
//    self.password = psw;
    [CommonRecordStatus commonRecordStatusManager].loginWay = kNormalLogin;

    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"login" forKey:@"command"];
    [mDict setObject:phone forKey:@"phonenum"];
    [mDict setObject:psw forKey:@"password"];
    if([CommonRecordStatus commonRecordStatusManager].deviceToken)
       [mDict setObject:[CommonRecordStatus commonRecordStatusManager].deviceToken forKey:@"token"];
////    if([appStoreORnormal isEqualToString:@"appStore"] && [RuYiCaiOR91 isEqualToString:@"91"])
////    {
//        [mDict setObject:@"91appStore" forKey:@"type"];
////    }
////    if([appStoreORnormal isEqualToString:@"appStore"] && [RuYiCaiOR91 isEqualToString:@"RuYiCai"])
////    {
//        [mDict setObject:@"appStore" forKey:@"type"];
////    }
//    else if([appStoreORnormal isEqualToString:@"normal"] && [RuYiCaiOR91 isEqualToString:@"91"])
//    {
//        [mDict setObject:@"91" forKey:@"type"];
//    }
//    else
//    {
        [mDict setObject:appStoreORnormal forKey:@"type"];
//    }
    //添加 自动登录字段
    if (m_delegate.loginView.isRemberMyLoginStatus)
    {
        [mDict setObject:@"1" forKey:@"isAutoLogin"];
    }
    else
    {
        [mDict setObject:@"0" forKey:@"isAutoLogin"];
    }

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeUserLogin];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"登录中..." net:request];
}

- (void)loginWithSource:(NSString*)source withOpenId:(NSString*)openId withNickName:(NSString*)nickname
{
    
    self.thirdOpenId = openId;
    self.thirdSource = source;
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"login" forKey:@"command"];
    [mDict setObject:@"noRegisterUnionLogin" forKey:@"requestType"];
    [mDict setObject:source forKey:@"source"];
    [mDict setObject:openId forKey:@"openId"];
    if (nickname) {
        [mDict setObject:nickname forKey:@"nickName"];
    }else{
        [mDict setObject:@"" forKey:@"nickName"];
    }
    

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"第三方联合登陆cookieStr:%@", cookieStr);
    
	[request setRequestType:ASINetworkRequestTypeUserLogin];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)regWithPhonenum:(NSString*)phone withPassword:(NSString*)psw 
			 withCertid:(NSString*)certid withName:(NSString*)name withRecPhonenum:(NSString*)RecPhonenum
{
    NSTrace();
    self.phonenum = phone;
    self.password = psw;
    m_netAppType = NET_APP_REGISTER;
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"register" forKey:@"command"];
    [mDict setObject:phone forKey:@"phonenum"];
    [mDict setObject:psw forKey:@"password"];
//    if(isBindPhone)
//    {
//        [mDict setObject:@"1" forKey:@"isBindPhone"];
//    }
//    else
//    {
//        [mDict setObject:@"0" forKey:@"isBindPhone"];
//    }
    if(certid.length != 0 && name.length != 0)
    {
        [mDict setObject:certid forKey:@"certid"];
        [mDict setObject:name forKey:@"name"];
    }

    [mDict setObject:RecPhonenum forKey:@"recommender"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"注册信息cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeUserReg];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)thirdLoginBindWithUserno:(NSString*)userno withOpenId:(NSString*)openId withSource:(NSString*)source
{
    NSTrace();
    m_netAppType = NET_APP_REGISTER;
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"login" forKey:@"command"];
    [mDict setObject:@"unionLoginAccountBinding" forKey:@"requestType"];
    [mDict setObject:userno forKey:@"userno"];
    [mDict setObject:source forKey:@"source"];
    [mDict setObject:openId forKey:@"openId"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"第三方联合登陆绑定信息cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeThirdLoginBind];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)thirdRegisterWithPhonenum:(NSString*)phone withPassword:(NSString*)psw
                       withOpenId:(NSString*)openId withSource:(NSString*)source
{

    self.phonenum = phone;
    self.password = psw;
    NSTrace();
    m_netAppType = NET_APP_REGISTER;
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"login" forKey:@"command"];
    [mDict setObject:@"unionLoginRegister" forKey:@"requestType"];
    [mDict setObject:phone forKey:@"phonenum"];
    [mDict setObject:psw forKey:@"password"];
    [mDict setObject:source forKey:@"source"];
    [mDict setObject:openId forKey:@"openId"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"第三方联合登陆注册信息cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeThirdLoginRegister];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];

}

- (void)betLotery:(NSMutableDictionary*)otherDict
{
//    if ([[RuYiCaiLotDetail sharedObject].moreZuAmount intValue] / 100 > kMaxBetCost)
//    {
//        [self showMessage:@"单个方案注数不能超过10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
//        return;
//    }
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    if(otherDict)
    {
        [mDict addEntriesFromDictionary:otherDict];
 
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
    }
    else
    {
        [mDict setObject:[RuYiCaiLotDetail sharedObject].betCode forKey:@"bet_code"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].amount forKey:@"amount"];
    }
    
    [mDict setObject:[RuYiCaiLotDetail sharedObject].subscribeInfo forKey:@"subscribeInfo"];
    
    [mDict setObject:@"betLot" forKey:@"command"];
    [mDict setObject:m_phonenum forKey:@"phonenum"];
	[mDict setObject:m_userno forKey:@"userno"];
    if([RuYiCaiLotDetail sharedObject].batchCode)
       [mDict setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
    [mDict setObject:[RuYiCaiLotDetail sharedObject].batchNum forKey:@"batchnum"];
    [mDict setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
    [mDict setObject:[RuYiCaiLotDetail sharedObject].lotMulti forKey:@"lotmulti"];
    [mDict setObject:[RuYiCaiLotDetail sharedObject].betType forKey:@"bettype"];
    [mDict setObject:[RuYiCaiLotDetail sharedObject].prizeend forKey:@"prizeend"];
    [mDict setObject:[RuYiCaiLotDetail sharedObject].oneAmount forKey:@"oneAmount"];
    //[mDict setObject:[RuYiCaiLotDetail sharedObject].sellWay forKey:@"sellway"];
    
    if ([[RuYiCaiLotDetail sharedObject].betType isEqualToString:@"gift"])
	{
		[mDict setObject:[RuYiCaiLotDetail sharedObject].toMobileCode forKey:@"to_mobile_code"];
		if([RuYiCaiLotDetail sharedObject].advice.length != 0)
            [mDict setObject:[RuYiCaiLotDetail sharedObject].advice forKey:@"blessing"];
//		      [mDict setObject:[RuYiCaiLotDetail sharedObject].advice forKey:@"advice"];
	}
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"投注betcode:%@", [RuYiCaiLotDetail sharedObject].betCode);
    NSLog(@"投注全部信息:\n%@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeSubmitLot];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)launchLot:(NSMutableDictionary*)otherDict
{
	NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:otherDict];
	[mDict setObject:@"betLot" forKey:@"command"];
    [mDict setObject:m_phonenum forKey:@"phonenum"];
	[mDict setObject:m_userno forKey:@"userno"];
    [mDict setObject:@"startcase" forKey:@"bettype"];

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"发起合买:%@", cookieStr);
    
	[request setRequestType:ASINetworkRequestTypeLaunchLot];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)launchLotShareDetile:(NSString*)caseLotId
{
	NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
//    [mDict addEntriesFromDictionary:otherDict];
	[mDict setObject:@"select" forKey:@"command"];
    [mDict setObject:@"caseLotDetail" forKey:@"requestType"];
	[mDict setObject:m_userno forKey:@"userno"];
    [mDict setObject:caseLotId forKey:@"id"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"发起合买分享:%@", cookieStr);
    
	[request setRequestType:ASINetworkRequestTypeGETShareDetile];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
#pragma MARK 定制跟单
- (void)createAutoJoin:(NSString*)starter  LOTNO:(NSString*)lotNo JOINAMT:(NSString*)joinAmt TIMES:(NSString*)times  JOINTYPE:(NSString*)joinType PERCENT:(NSString*)percent  MAXAMT:(NSString*)maxAmt FORCEJOIN:(NSString*)forceJoin
{
	NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:@"autoJoin" forKey:@"command"];
    [mDict setObject:m_phonenum forKey:@"phonenum"];
	[mDict setObject:m_userno forKey:@"userno"];
    [mDict setObject:@"createAutoJoin" forKey:@"requestType"];
 
    
    [mDict setObject:lotNo forKey:@"lotno"];
    [mDict setObject:starter forKey:@"starterUserNo"];
    [mDict setObject:times forKey:@"times"];
    [mDict setObject:forceJoin forKey:@"forceJoin"];
    [mDict setObject:joinType forKey:@"joinType"];
    if ([@"0" isEqualToString:joinType]) {//按金额
        [mDict setObject:joinAmt forKey:@"joinAmt"];
    }
    else
    {
        [mDict setObject:percent forKey:@"percent"];
        [mDict setObject:maxAmt forKey:@"maxAmt"];
    }
 
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"创建定制跟单:%@", cookieStr);
    
	[request setRequestType:ASINetworkRequestTypecreateAutoJoin];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)queryLaunchLotStater:(NSString*)starterUserNo LOTNO:(NSString*)lotNo
{
	NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:@"autoJoin" forKey:@"command"];
 
    [mDict setObject:@"selectCaseLotStarterInfo" forKey:@"requestType"];
    [mDict setObject:lotNo forKey:@"lotno"];
    [mDict setObject:starterUserNo forKey:@"starterUserNo"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"合买发起人信息:%@", cookieStr);
    
	[request setRequestType:ASINetworkRequestTypeQueryLaunchStater];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)queryCaseLot_autoOrderOfPage:(NSUInteger)pageIndex
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:m_userno forKey:@"userno"];
	[mDict setObject:m_phonenum forKey:@"phonenum"];
    [mDict setObject:@"autoJoin" forKey:@"command"];
    [mDict setObject:@"selectAutoJoin" forKey:@"requestType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDict setObject:@"10" forKey:@"maxresult"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"定制跟单查询：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeQueryCaseLot_AutoOrder];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
    
}
- (void)cancelAutoOrder:(NSString*)caseId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:m_userno forKey:@"userno"];
	[mDict setObject:m_phonenum forKey:@"phonenum"];
    [mDict setObject:caseId forKey:@"id"];
    [mDict setObject:@"autoJoin" forKey:@"command"];
    [mDict setObject:@"cancelAutoJoin" forKey:@"requestType"];
 
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"取消定制跟单：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeCancelAutoOrder];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];

}
- (void)modifyAutoOrder:(NSString*)caseId JOINAMT:(NSString*)joinAmt /*TIMES:(NSString*)times */ JOINTYPE:(NSString*)joinType PERCENT:(NSString*)percent  MAXAMT:(NSString*)maxAmt FORCEJOIN:(NSString*)forceJoin
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	[mDict setObject:@"autoJoin" forKey:@"command"];
    [mDict setObject:m_phonenum forKey:@"phonenum"];
	[mDict setObject:m_userno forKey:@"userno"];
    [mDict setObject:@"updateAutoJoin" forKey:@"requestType"];
 
    [mDict setObject:caseId forKey:@"id"];
    [mDict setObject:joinType forKey:@"joinType"];
    [mDict setObject:forceJoin forKey:@"forceJoin"];
    if ([@"0" isEqualToString:joinType]) {//按金额
        [mDict setObject:joinAmt forKey:@"joinAmt"];
        
        [mDict setObject:@"" forKey:@"percent"];
        [mDict setObject:@"" forKey:@"maxAmt"];
        [mDict setObject:@"" forKey:@"safeAmt"];
    }
    else
    {
        [mDict setObject:percent forKey:@"percent"];
        [mDict setObject:maxAmt forKey:@"maxAmt"];
        
        [mDict setObject:@"" forKey:@"joinAmt"];
        [mDict setObject:@"" forKey:@"safeAmt"];
    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"更新定制跟单:%@", cookieStr);
    
	[request setRequestType:ASINetworkRequestTypeModifyAutoOrder];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryCaseLotOfPage:(NSUInteger)pageIndex
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    //	[mDict setObject:m_userno forKey:@"userno"];
    //	[mDict setObject:m_phonenum forKey:@"phonenum"];
    //    [mDict setObject:@"QueryLot" forKey:@"command"];
    //    [mDict setObject:@"caselot" forKey:@"type"];
    //    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    //    [mDict setObject:@"10" forKey:@"maxresult"];
    //新
    [mDict setObject:m_userno forKey:@"userno"];
    [mDict setObject:@"select" forKey:@"command"];
    [mDict setObject:@"caseLotBuyList" forKey:@"requestType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDict setObject:@"10" forKey:@"maxresult"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"合买查询：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeQueryCaseLot];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)betCaseLot:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:otherDict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeBetCaseLot];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryAllCaseLot:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:otherDict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeQueryAllCaseLot];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryCaseLotDetail:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
	//NSLog(@"%@",otherDict);
    [mDict addEntriesFromDictionary:otherDict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"xxxxxxx——————————cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeQueryCaseLotDetail];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)getLotteryDetailInfo:(NSString*)lotno batchCode:(NSString*)batchCode
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:@"winInfoDetail" forKey:@"type"];
    [mDict setObject:lotno forKey:@"lotno"];
    if(batchCode)
        [mDict setObject:batchCode forKey:@"batchcode"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"开奖详情 ：%@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkReqestTypeGetWinInfoDetail];
	[request setDelegate:self];
	[request startAsynchronous];
    //[self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)getLotteryAwardInfoDetailInfo:(NSString*)lotno batchCode:(NSString*)batchCode
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:@"winInfoDetail" forKey:@"type"];
    [mDict setObject:lotno forKey:@"lotno"];
    if(batchCode)
        [mDict setObject:batchCode forKey:@"batchcode"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"开奖详情 ：%@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkReqestTypeGetAwardInfoDetail];
	[request setDelegate:self];
	[request startAsynchronous];
    //[self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)getLotteryInformation:(NSString*)maxResult lotno:(NSString*)lotno
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"winInfoList" forKey:@"type"];
    [mDict setObject:maxResult forKey:@"maxresult"];
    [mDict setObject:@"0" forKey:@"pageindex"];
    [mDict setObject:lotno forKey:@"lotno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@" 走势图开奖号码 %@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetLotteryInfo];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];	
//    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
//	request.allowCompressedResponse = NO;
//    
//    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
//    [mDict setObject:@"lotteryinfomation" forKey:@"command"];
//    
//    SBJsonWriter *jsonWriter = [SBJsonWriter new];
//    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
//    [jsonWriter release];
//    
//    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
//    [request appendPostData:sendData];  
//    [request buildPostBody];
//    
//	[request setRequestType:ASINetworkRequestTypeGetLotteryInfo];
//	[request setDelegate:self];
//	[request startAsynchronous];
    //[self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)getLotteryInfoList:(NSString*)pageIndex lotNo:(NSString*)lotno
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"winInfoList" forKey:@"type"];
    [mDict setObject:@"10" forKey:@"maxresult"];
    [mDict setObject:pageIndex forKey:@"pageindex"];
    [mDict setObject:lotno forKey:@"lotno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@" 开奖号码 %@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetLotteryInfoList];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];	
}


- (void)getJCLotteryInfor:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:otherDict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@" 竞彩开奖号码 %@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetJCLotteryInfo];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)getJCLotteryInfor:(NSString*)date JCtype:(NSString*)JCtype
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"jcResult" forKey:@"type"];
    [mDict setObject:JCtype forKey:@"jingcaiType"];
    [mDict setObject:date forKey:@"date"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@" 竞彩开奖号码 %@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetJCLotteryInfo];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];	
}

- (void)getGiftMessage
{
	NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"giftmessage" forKey:@"command"];
    [mDict setObject:@"new" forKey:@"requestType"];
    [mDict setObject:@"" forKey:@"pageindex"];
    [mDict setObject:@"" forKey:@"maxresult"];

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetGiftInfo];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];	
}


- (void)getTopWinnerInformation
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:@"prizeRank" forKey:@"type"];

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetTopWinner];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];	
}
- (void)getInformation:(NSInteger)type  withLotNo:(NSString*)lotNo maxresult:(NSInteger)maxNum
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:[NSString stringWithFormat:@"%d",maxNum] forKey:@"maxresult"];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"title" forKey:@"newsType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
    
    NSLog(@"%@",mDict);
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"cookieStr:%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    if (type == CAI_MIN_ZHUAN_QU) {
        [request setRequestType:ASINetworkRequestTypeGetInformationOfCaiMinZhuanQu];
    }else if (type == ZHUAN_JIA_TUI_JIAN){
        [request setRequestType:ASINetworkRequestTypeGetInformationOfZhuanJiaTuiJian];
    }else if (type == ZU_CAI_TIAN_DI){
        [request setRequestType:ASINetworkRequestTypeGetInformationOfZuCaiTianDi];
    }else if (type == ZHAN_NEI_GONG_GAO){
        [request setRequestType:ASINetworkRequestTypeGetInformationOfZhanNeiGongGao];
    }
	
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getInformation:(NSInteger)type  withLotNo:(NSString*)lotNo
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"title" forKey:@"newsType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
    if(type == 2 && lotNo)//彩票资讯
    {
        [mDict setObject:lotNo forKey:@"lotno"];
    }
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"cookieStr:%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetInformation];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];	
}

- (void)getInformationContent:(NSInteger)typeId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"content" forKey:@"newsType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", typeId] forKey:@"newsId"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetInformationContent];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];	
}



- (void)getExpertCode:(NSString*)type
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"expertCode" forKey:@"newsType"];
    [mDict setObject:type forKey:@"type"];
    [mDict setObject:@"" forKey:@"maxresult"];
    [mDict setObject:@"" forKey:@"pageindex"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"推荐 %@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkReqestTypeGetExpertCode];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];

}

#pragma mark action center
- (void)getActivityTitle:(NSInteger)pageIndex
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"activityTitle" forKey:@"newsType"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
	[mDict setObject:@"10" forKey:@"maxresult"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
  
    NSLog(@"活动标题： %@",cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    [request setRequestType:ASINetworkReqestTypeGetActivityTitle];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)getActivityDetail:(NSString*)activityId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"activityContent" forKey:@"newsType"];
	[mDict setObject:activityId forKey:@"activityId"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"活动细节： %@",cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    [request setRequestType:ASINetworkReqestTypeGetActivityContent];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)findPasswordWithPhone:(NSString*)userName bindPhone:(NSString*)phoneNum
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:@"retrievePassword" forKey:@"type"];
    [mDict setObject:userName forKey:@"phonenum"];
    [mDict setObject:phoneNum forKey:@"bindPhoneNum"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"密码：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeFindPsw];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

#pragma mark 首页广告信息
- (void)queryADInformation
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"topimages" forKey:@"type"];
    [mDict setObject:@"10" forKey:@"imageNumber"];
    [mDict setObject:@"configquery" forKey:@"command"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"首页广告信息获取 :%@", cookieStr);
	[request setRequestType:ASINetworkRequestTypeQueryADInformation];
	[request setDelegate:self];
	[request startAsynchronous];
    //[self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

#pragma mark 查询剩余投注次数

-(void)queryRemainingChanceForLot
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"user" forKey:@"command"];
    [mDict setObject:@"leftBetNum" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询剩余投注次数: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeRemainingChance];
	[request setDelegate:self];
	[request startAsynchronous];

}
-(void)queryADWallList
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"scorewall" forKey:@"command"];
    [mDict setObject:@"list" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:@"0" forKey:@"pageindex"];
    [mDict setObject:@"7" forKey:@"maxresult"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询积分墙列表: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryADWallList];
	[request setDelegate:self];
	[request startAsynchronous];
}


//获取自营推荐应用列表，theType=list表示列表，theType=topone表示获取摇一摇最上面广告条
-(void)queryRecommandedAppList:(NSString *)theType
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"market" forKey:@"command"];
    if ([theType isEqualToString:@"list"]) {
        [mDict setObject:@"appList" forKey:@"requestType"];
        [mDict setObject:@"0" forKey:@"type"];
    }
    else if([theType isEqualToString:@"topone"])
    {
        [mDict setObject:@"appTop1" forKey:@"requestType"];
        [mDict setObject:@"1" forKey:@"type"];
    }
    
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:@"0" forKey:@"pageindex"];
    [mDict setObject:@"20" forKey:@"maxresult"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询精品推荐列表: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryRecommandAppList];
	[request setDelegate:self];
	[request startAsynchronous];
}

-(void)queryShakeActList
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"activiy" forKey:@"command"];
    [mDict setObject:@"taskList" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
//    [mDict setObject:@"0" forKey:@"pageindex"];
//    [mDict setObject:@"20" forKey:@"maxresult"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询摇一摇活动列表: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryShakeActList];
	[request setDelegate:self];
	[request startAsynchronous];
}

-(void)doShakeCheckInWithActID:(NSString *)actID AndCheckID:(NSString *)checkID
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"activiy" forKey:@"command"];
    [mDict setObject:@"shakeCheck" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:actID forKey:@"activityId"];
    [mDict setObject:checkID forKey:@"id"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  执行摇一摇签到: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeDoShakeCheck];
	[request setDelegate:self];
	[request startAsynchronous];
}



-(void)queryshakeSigninDescription
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"info" forKey:@"command"];
    [mDict setObject:@"valueById" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:@"shakeSigninDesc" forKey:@"keyStr"];
//    [mDict setObject:@"20" forKey:@"maxresult"];
//    [mDict setObject:@"0" forKey:@"type"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询摇一摇总描述: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryShakeSignInDescription];
	[request setDelegate:self];
	[request startAsynchronous];
}



-(void)queryRemainingIDFA
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"scorewall" forKey:@"command"];
    [mDict setObject:@"leftDeviceNum" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
//    [mDict setObject:@"0" forKey:@"pageindex"];
//    [mDict setObject:@"7" forKey:@"maxresult"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询设备: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTyPeQueryRemainingIDFA];
	[request setDelegate:self];
	[request startAsynchronous];
}

-(void)queryActListWithPage:(NSString *)thePage
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"activiy" forKey:@"command"];
    [mDict setObject:@"partakeList" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:thePage forKey:@"pageindex"];
    [mDict setObject:@"10" forKey:@"maxresult"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询活动列表: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryActList];
	[request setDelegate:self];
	[request startAsynchronous];
}
-(void)queryMyAwardCardListWithPage:(NSString *)thePage
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"activiy" forKey:@"command"];
    [mDict setObject:@"partakeList" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:thePage forKey:@"pageindex"];
    [mDict setObject:@"20" forKey:@"maxresult"];
    [mDict setObject:@"2" forKey:@"category"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  查询活动列表: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryActList];
	[request setDelegate:self];
	[request startAsynchronous];
}


-(void)doQianDaoWithID:(NSString *)theID
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"activiy" forKey:@"command"];
    [mDict setObject:@"everydayCheck" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:theID forKey:@"id"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  签到: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeDoQianDao];
	[request setDelegate:self];
	[request startAsynchronous];
}

-(void)doGoodCommentWithID:(NSString *)theID
{
    NSTrace();
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"activiy" forKey:@"command"];
    [mDict setObject:@"goodComment" forKey:@"requestType"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [mDict setObject:theID forKey:@"id"];
    //自动登录
    //    [m_delegate readAutoLoginPlist];//?????????
    //    if (m_delegate.autoRememberMystatus && [[m_delegate autoLoginRandomNumber] length] > 0) {
    //        NSString *str = m_delegate.autoLoginRandomNumber;
    //        [mDict setObject:str forKey:@"randomNumber"];
    //    }
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"  好评: \nsendData:%@" , cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeDoGoodComment];
	[request setDelegate:self];
	[request startAsynchronous];
}

#pragma mark 头部新闻 今日开奖、加奖
- (void)queryTodayOpenOrAdd
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"select" forKey:@"command"];
    [mDict setObject:@"buyCenter" forKey:@"requestType"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"今日开奖、加奖：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryTodayOpen];
	[request setDelegate:self];
	[request startAsynchronous];
//    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

#pragma mark 头部新闻
- (void)getTopNewsContent
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"topNews" forKey:@"newsType"];

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"头部新闻：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkReqestTypeGetTopNews];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)getTopNewsContentComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* news_title = [parserDict objectForKey:@"title"];
    NSString* news_content = [parserDict objectForKey:@"content"];
    [jsonParser release];
    
    UIAlertView*  alert = [[UIAlertView alloc] initWithTitle:news_title         
                                                     message:news_content 
                                                    delegate:self 
                                           cancelButtonTitle:@"确定" 
                                           otherButtonTitles: nil];
    [alert show];
    [alert release];
    [self showMessage:news_content withTitle:news_title buttonTitle:@"确定"];
}

#pragma mark Request finished and failed

- (void)requestFailed:(ASIHTTPRequest *)request
{
    BOOL showMessageType = YES;
    ASINetworkReqestType retype = request.requestType;
    switch (retype) {
        case ASINetworkRequestTypeSSQ:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeDLT:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeFC3D:
            showMessageType = NO;
            break;
        case ASINetworkRequestType11YDJ:
            showMessageType = NO;
            break;
        case ASINetworkRequestType115:
            showMessageType = NO;            
            break;
        case ASINetworkRequestTypeSSC:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeKLSF:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeNMKS:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeCQ115:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeGD115:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeQLC:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypePLS:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypePLW:
            showMessageType = NO;
            break;
        case ASINetworkRequestTypeQXC:
            showMessageType = NO;
            break;
        case ASINetworkRequestType22X5:
            showMessageType = NO;
            break;
        default:
            break;
    }

    
    if (NET_APP_QUERY_BALANCE != m_netAppType)
    {
        if (showMessageType) {
//            [self showMessage:@"联网失败，请稍后重试" withTitle:@"联网提示" buttonTitle:@"确定"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailedAlert" object:nil];
        }
    
    }
    
    m_netAppType = NET_APP_BASE;
//	[m_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
	[m_delegate.activityView disActivityView];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    [m_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];
    [m_delegate.activityView disActivityView];

	//解压-->解密
    NSData *filData = [[request responseData] newAESDecryptWithPassphrase:kRuYiCaiAesKey];
//    NSLog(@"filData%@", filData);
    NSData *m_data = [RuYiCaiNetworkManager decodeBase64:filData];
//    NSLog(@"%@", [RuYiCaiNetworkManager decodeBase64:filData]);
    NSData *responseData = [ASIHTTPRequest uncompressZippedData:m_data];
    NSString *resText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"resText %@", resText);
    
//	//解密
//	NSData* responseData = [request responseData];
//	NSData* finalData = [responseData newAESDecryptWithPassphrase:kRuYiCaiAesKey];
//	NSString* resText = [[NSString alloc] initWithData:finalData encoding:NSUTF8StringEncoding];
//	NSLog(@"resText:%@", resText);
    
	ASINetworkReqestType retype = request.requestType;
	switch (retype) 
	{
        case ASINetworkRequestTypeBase:
            [self requestFinish_Two:request.requestTypeTwo withStr:resText];
            break;
		case ASINetworkRequestTypeSoftUpdate:
			[self softUpdateComplete:resText];
			break;
        case ASINetworkRequestTypeRemainingChance:
            [self queryRemainingChanceOK:resText];
            break;
        case ASINetworkRequestTypeQueryADWallList:
            [self queryADWallListOK:resText];
            break;
        case ASINetworkRequestTypeQueryRecommandAppList:
            [self queryRecommandAppListOK:resText];
            break;
        case ASINetworkRequestTypeQueryShakeActList:
            [self queryShakeActListListOK:resText];
            break;
        case ASINetworkRequestTypeDoShakeCheck:
            [self doShakeCheckOK:resText];
            break;
        case ASINetworkRequestTypeQueryShakeSignInDescription:
            [self queryShakeSignInDescriptionOK:resText];
            break;
        case ASINetworkRequestTyPeQueryRemainingIDFA:
            [self queryRemainingIDFAOK:resText];
            break;
        case ASINetworkRequestTypeQueryActList:
            [self queryActListOK:resText];
            break;
        case ASINetworkRequestTypeDoQianDao:
            [self doQianDaoOK:resText];
            break;
        case ASINetworkRequestTypeDoGoodComment:
            [self doGoodCommentOK:resText];
            break;
		case ASINetworkRequestTypeUpdateInformationOfLotteryInServers:
			[self updateInformationOfLotteryInServers:resText];
			break;
        case ASINetworkRequestTypeUpdatePayStationInServers:
			[self updatePayStationInServers:resText];
			break;
        case ASINetworkRequestTypeCancelAutoLogin:
			[self cancelAutoLoginOK:resText];
			break;
        case ASINetworkRequestTypeUpdateInformation:
			[self updateImformationComplete:resText];
			break;
		case ASINetworkRequestTypeCheckNewVersion:
            [self checkNewVersionSuccess:resText];
            break;
        case ASINetworkRequestTypeGetAdWallImportantInfo:
            [self getAdWallImportantInfoSuccess:resText];
            break;
        case ASINetworkRequestTypeGetExchangeScaleForAdWall:
            [self getExchangeScaleSuccess:resText];
            break;
		case ASINetworkRequestTypeUserLogin:
            [self loginComplete:resText];
			break;
        case ASINetworkRequestTypeselectUserNo:
            [self selectUsernoComplete:resText];
			break;
        case ASINetworkRequestTypeThirdLoginRegister:
			[self thirdRegisterComplete:resText];
			break;
        case ASINetworkRequestTypeThirdLoginBind:
			[self thirdLoginBindComplete:resText];
			break;
		case ASINetworkRequestTypeUserReg:
			[self regComplete:resText];
			break;
            
        case ASINetworkRequestTypeUpdatePsw:
            [self updatePassComplete:resText];
            break;
			
		case ASINetworkRequestTypeFeedback:
            [self sendFeedbackComplete:resText];
			break;
			
		case ASINetworkRequestTypeQueryLotBet:
			[self queryLotBetComplete:resText];
			break;
            
        case ASINetworkRequestTypeQueryLotWin:
			[self queryLotWinComplete:resText];
			break;
			
		case ASINetworkRequestTypeSubmitLot:
			[self submitLotComplete:resText];
			break;
            
        case ASINetworkRequestTypeQueryBalance:
            [self queryBalanceComplete:resText];
            break;
            
        case ASINetworkRequestTypeRecentlyEvent:
            [self queryRecentlyEventComplete:resText notifacationType:@"queryRecentlyEvent"];
            break;
        case ASINetworkRequestTypeJZRecentlyEvent:
            [self jzQueryRecentlyEventComplete:resText notifacationType:@"jzQueryRecentlyEvent"];
            break;
        case ASINetworkRequestTypeBDRecentlyEvent:
            [self bdQueryRecentlyEventComplete:resText notifacationType:@"bdQueryRecentlyEvent"];
            break;
            
        case ASINetworkRequestTypeQueryADInformation:
            [self queryADInformationComplete:resText];
            break;
            
        case ASINetworkRequestTypeQueryTrack:
            [self queryTrackComplete:resText];
            break;
            
        case ASINetworkRequestTypeQueryGift:
            [self queryGiftComplete:resText];
            break;
            
        case ASINetworkRequestTypeAccountDetail:
            [self queryAccountDetailComplete:resText];
            break;
            
        case ASINetworkRequestTypeQueryCash:
            [self queryCashComplete:resText];
            break;
            
        case ASINetworkRequestTypeGetCash:
            [self getCashComplete:resText];
            break;
            
        case ASINetworkRequestTypeCancelCash:
            [self cancelCashComplete:resText];
            break;
            
        case ASINetworkRequestTypeUpdatePass:
            [self updatePassComplete:resText];
            break;
            
        case ASINetworkRequestTypeGetLotteryInfo:
            [self getLotteryInformationComplete:resText];
            break;
			
        case ASINetworkRequestTypeQueryDNA:
            [self queryDNAComplete:resText];
            break;
            
        case ASINetworkRequestTypeChargeDNA:
            [self chargeDNAComplete:resText];
            break;            
            
        case ASINetworkRequestTypeChargePhoneCard:
            [self chargeByPhoneCardComplete:resText];
            break;
            
        case ASINetworkRequestTypeChargeUnionBankCard:
            [self chargeByUnionBankCardComplete:resText];
            break;
        
        case ASINetworkRequestTypeUmpayCreDit:
            [self chargeByUmpayCreDitComplete:resText];
            break;
        case ASINetworkRequestTypeWealthTenpay:
            [self chargeByWealthTenpayComplete:resText];
            break;
            
        case ASINetworkRequestTypeChargeAlipay:
            [self chargeByAlipayComplete:resText];
            break;
            
        case ASINetworkRequestTypeQueryCaseLot:
            [self queryCaseLotComplete:resText];
            break;
            
        case ASINetworkRequestTypeCancelAutoOrder:
            [self cancelAutoOrderComplete:resText];
            break;
            
        case ASINetworkRequestTypeModifyAutoOrder:
            [self modifyAutoOrderComplete:resText];
            break;
            
        case ASINetworkRequestTypeBetCaseLot:
            [self betCaseLotComplete:resText];
            break;
            
        case ASINetworkRequestTypeQueryAllCaseLot:
            [self queryAllCaseLotComplete:resText];
            break;
            
        case ASINetworkRequestTypeQueryCaseLotDetail:
            [self queryCaseLotDetailComplete:resText];
            break;
		
        case ASINetworkRequestTypeLeftTime:
			[self highFrequencyComplete:resText];
			break;
        case ASINetworkRequestTypeWinningInformationMaxresult:
            [self highFrequencyInquiryTheWinningInformation:resText];
            break;
        case ASINetworkRequestTypeAllLeftTime:
            [self highFrequencyALLComplete:resText];
			break;
        case ASINetworkRequestTypeTicketPropaganda:
            [self ticketPropagandaComplete:resText];
			break;
		
        case ASINetworkRequestTypeCancelTrack:
			[self cancelTrackComplete:resText];
			break;
        
        case ASINetworkRequestTypeLaunchLot:
			[self launchLotComplete:resText];
			break;
        case ASINetworkRequestTypeGETShareDetile:
			[self launchLotGeShareComplete:resText];
			break;
        case ASINetworkRequestTypecreateAutoJoin:
			[self createAutoJoinComplete:resText];
			break;
        case ASINetworkRequestTypeQueryCaseLot_AutoOrder:
			[self queryCaseLot_autoOrderComplete:resText];
			break;
            
        case ASINetworkRequestTypeQueryLaunchStater:
			[self queryLaunchLotStaterComplete:resText];
			break;
		
        case ASINetworkRequestTypeGetGiftInfo:
			[self getGiftMessageComplete:resText];
			break;
        
        case ASINetworkRequestTypeGetTopWinner:
            [self getTopWinnerComplete:resText];
            break;
        
        case ASINetworkReqestTypeBindCertid:
            [self bindCertidComplete:resText];
            break;
        
        case ASINetworkReqestTypeBindPhoneSecurity:
            [self bindPhoneSecurityComplete:resText];
            break;
        case ASINetworkReqestTypeBindEmailSecurity:
            [self bindEmailSecurityComplete:resText];
            break;
        case ASINetworkReqestTypeBindPhone:
            [self bindPhoneComplete:resText];
            break;
        
        case ASINetworkReqestTypeCancelBindPhone:
            [self cancelBindPhoneComplete:resText];
            break;
        case ASINetworkReqestTypeCancelBindEmail:
            [self cancelBindEmailComplete:resText];
            break;
        case ASINetworkRequestTypeFindPsw:
            [self findpasswordComplete:resText];
            break;
        case ASINetworkRequestTypeGetInformation:
            [self getInformationComplete:resText];
            break;
        case ASINetworkRequestTypeGetInformationOfCaiMinZhuanQu:
            [self getInformationComplete:resText RequestType:CAI_MIN_ZHUAN_QU];
            break;
        case ASINetworkRequestTypeGetInformationOfZhuanJiaTuiJian:
            [self getInformationComplete:resText RequestType:ZHUAN_JIA_TUI_JIAN];
            break;
        case ASINetworkRequestTypeGetInformationOfZuCaiTianDi:
            [self getInformationComplete:resText RequestType:ZU_CAI_TIAN_DI];
            break;
        case ASINetworkRequestTypeGetInformationOfZhanNeiGongGao:
            [self getInformationComplete:resText RequestType:ZHAN_NEI_GONG_GAO];
            break;
        case ASINetworkRequestTypeGetInformationContent:
            [self getInformationContentComplete:resText];
            break;
        case ASINetworkRequestTypeUserCenter:
            [self updateUserCenter:resText];
            break;
        case ASINetworkRequestTypeNickName:
            [self setNicknameComplete:resText];
            break;
        case ASINetworkRequestTypeLeaveMessage:
            [self queryLeaveMessageComplete:resText];
            break;
        case ASINetworkRequestTypeIntegralInfo:
            [self getIntegralInfoComplete:resText];
            break;
        case ASINetworkRequestTypeIntegralTransMoneyNeedsScores:
            [self integralTransMoneyNeedsScoresComplete:resText];
            break;
        case ASINetworkRequestTypeTransIntegral:
            [self transIntegralComplete:resText];
            break;
        case ASINetworkRequestTypeGetLotteryInfoList:
            [self getLotteryInfoListComplete:resText];
            break;
        case ASINetworkReqestTypeGetActivityTitle:
            [self getActivityTitleComplete:resText];
            break;
        case ASINetworkReqestTypeGetActivityContent:
            [self getActivityContentComplete:resText];
            break;
        case ASINetworkReqestTypeGetWinInfoDetail:
            [self getLotteryDetailInfoComplete:resText];
            break;
        case ASINetworkReqestTypeGetAwardInfoDetail:
            [self getLotteryAwardInfoComplete:resText];
            break;
        case ASINetworkReqestTypeGetExpertCode:
            [self getExpertCodeComplete:resText];
            break;
        case ASINetworkRequestTypeGetJCLotteryInfo:
            [self getJCLotteryInforComplete:resText];
            break;
        case ASINetworkReqestTypeGetJCLQDuiZhen:
            [self geJCLQDuiZhenComplete:resText];
            break;
        case ASINetworkReqestTypeGetDataAnalysis:
            [self getDataAnalysisOKComplete:resText];
            break;
        case ASINetworkReqestTypeGetInstantScore:
            [self getInstantScoreComplete:resText];
            break;
        case ASINetworkReqestTypeGetInstantScoreDetail:
            [self getInstantScoreDetailComplete:resText];
            break;
        case ASINetworkRequestTypeGetZCmain:
            [self getInstantZCmainComplete:resText];
            break;
            
        case ASINetworkRequestTypeQueryRecordCash:
            [self queryRecordCashComplete:resText];
            break;
        case ASINetworkReqestTypeGetLotDate:
            [self getLotDateOk:resText];
            break;
        case ASINetworkReqestTypeChargeSecurityAlipay:
            [self chargeBySecurityAlipayComplete:resText];
            break;
        case ASINetworkReqestTypeChargeLaKaLa:
            [self chargeByLaKaLaComplete:resText];
            break;
        case ASINetworkReqestTypeGetStartImage:
            [self getStartImageComplete:[request responseData]];
            break;
        case ASINetworkReqestTypeMorePage:
            [self helpCenterNetType:resText];
            break;
        case ASINetworkReqestTypeMorePageOfGNZY:
            [self helpCenterNetType:resText withType:1];
            break;
        case ASINetworkReqestTypeMorePageOfCPWF:
            [self helpCenterNetType:resText withType:3];
            break;
        case ASINetworkReqestTypeMorePageOfCJWT:
            [self helpCenterNetType:resText withType:4];
            break;
        case ASINetworkReqestTypeMorePageOfCPSY:
            [self helpCenterNetType:resText withType:5];
            break;
        case ASINetworkReqestTypeChargePage:
            [self chargePageWithType:resText];
            break;
        case ASINetworkReqestTypeGetTopNews:
            [self getTopNewsContentComplete:resText];
            break;
        case ASINetworkRequestTypeQueryTodayOpen:
            [self queryTodayOpenOrAddComplete:resText];
            break;
        case ASINetworkRequestTypeZCIssue:
            [self queryZCIssueBatchCodeComplete:resText];
            break;
        case ASINetworkRequestTypeZC:
            [self updateZCInformationBatchCodeComplete:resText];
            break;
        case ASINetworkRequestTypeSSQ:
			[self highFrequencyComplete:resText notifacationType:@"updateSSQInformation"];
            break;
        case ASINetworkRequestTypeDLT:
			[self highFrequencyComplete:resText notifacationType:@"updateDLTInformation"];
            break;
        case ASINetworkRequestTypeFC3D:
			[self highFrequencyComplete:resText notifacationType:@"updateFC3DInformation"];
            break;
        case ASINetworkRequestType11YDJ:
			[self highFrequencyComplete:resText notifacationType:@"update11YDJInformation"];
            break;
        case ASINetworkRequestType115:
			[self highFrequencyComplete:resText notifacationType:@"update115Information"];
            break;
        case ASINetworkRequestTypeSSC:
			[self highFrequencyComplete:resText notifacationType:@"updateSSCInformation"];
            break;
        case ASINetworkRequestTypeKLSF:
			[self highFrequencyComplete:resText notifacationType:@"updateKLSFInformation"];
            break;
        case ASINetworkRequestTypeCQSF:
			[self highFrequencyComplete:resText notifacationType:@"updateCQSFInformation"];
            break;
        case ASINetworkRequestTypeGD115:
			[self highFrequencyComplete:resText notifacationType:@"updateGD115Information"];
            break;
        case ASINetworkRequestTypeQLC:
            [self highFrequencyComplete:resText notifacationType:@"updateQLCInformation"];
            break;
        case ASINetworkRequestTypePLS:
            [self highFrequencyComplete:resText notifacationType:@"updatePLSInformation"];
            break;
        case ASINetworkRequestTypePLW:
            [self highFrequencyComplete:resText notifacationType:@"updatePLWInformation"];
            break;
        case ASINetworkRequestTypeQXC:
            [self highFrequencyComplete:resText notifacationType:@"updateQXCInformation"];
            break;
        case ASINetworkRequestType22X5:
            [self highFrequencyComplete:resText notifacationType:@"update22X5Information"];
            break;
        case ASINetworkRequestTypeNMKS:
			[self highFrequencyComplete:resText notifacationType:@"updateNMKSInformation"];
            break;
        case ASINetworkRequestTypeCQ115:
			[self highFrequencyComplete:resText notifacationType:@"updateCQ115Information"];
            break;
        case ASINetworkRequestTypeCaidouDetail:
            [self queryCaodouDetailComplete:resText];
            break;
        case ASINetworkRequestTypeGetCaptcha:
            [self getCaptcha:resText];
            break;
        case ASINetworkRequestTypeCheckoutCaptcha:
            [self CheckoutCaptcha:resText];
            break;
        case ASINetworkRequestTypeExchangeLotPea:
            [self exchangeLotPea:resText];
            break;
        case ASINetworkRequestTypeGetMessageList:
            [self getMessageList:resText];
            break;
        case ASINetworkRequestTypeGetMessageDetail:
            [self getMessageDetail:resText];
            break;
        case ASINetworkRequestTypeGetTopOneMessage:
            [self getTopOneMessage:resText];
            break;
        case ASINetworkRequestTypeGetNotification:
            [self getNotification:resText];
            break;
		default:
			break;
	}
    [resText release];
}
-(void)doGoodCommentOK:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
//    NSArray * arrayG = [parserDict objectForKey:@"result"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        
    }
}
-(void)doQianDaoOK:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
//    NSArray * arrayG = [parserDict objectForKey:@"result"];
//    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
//    if ([errorCode isEqualToString:@"0000"])
//	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TodayQianDaoOK" object:parserDict];
//    }
}
-(void)queryActListOK:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSArray * arrayG = [parserDict objectForKey:@"result"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryActListOK" object:arrayG];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryActListFail" object:arrayG];
    }
}
-(void)queryRemainingIDFAOK:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
//    NSArray * arrayG = [parserDict objectForKey:@"values"];
//    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
//    if ([errorCode isEqualToString:@"0000"])
//	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryRemainingIDFAOK" object:parserDict];
//    }

}
-(void)doShakeCheckOK:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRDoShakeCheckOK" object:parserDict];
    }
}
-(void)queryShakeActListListOK:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRQueryShakeActListOK" object:parserDict];
    }

}
-(void)queryRecommandAppListOK:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryRecommandedAppListOK" object:parserDict];
    }

}
-(void)queryShakeSignInDescriptionOK:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRQueryShakeSigninDescriptionOK" object:parserDict];
    }
}
-(void)queryADWallListOK:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSArray * arrayG = [parserDict objectForKey:@"values"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryADWallListOK" object:arrayG];
    }
}
-(void)queryRemainingChanceOK:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
    NSString * leftBetNum =[NSString stringWithFormat:@"%@",[parserDict objectForKey:@"value"]];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryRemainingChanceOK" object:leftBetNum];
    }
}
- (void)queryTodayOpenOrAddComplete:(NSString*)resText
{
//     self.responseText = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryTodayOpenOrAddOK" object:resText];
}

- (void)getJCLotteryInforComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getJCLotteryInforOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)getExpertCodeComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getExpertCodeOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)geJCLQDuiZhenComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QueryJCLQDuiZhen" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}
- (void)getDataAnalysisOKComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
 
//    NSLog(@"%@",resText);
    self.responseText = resText;
    if ([errorCode isEqualToString:@"0000"])
	{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getDataAnalysisOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}
- (void)getInstantScoreComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    NSLog(@"%@",resText);
    self.responseText = resText;
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getInstantScoreOK" object:nil];
	}
	else if([errorCode isEqualToString:@"0047"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getInstantScoreOK" object:nil];
//		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
    else
    {
//        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)getInstantZCmainComplete:(NSString*)resText

{
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
//    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
//    [jsonParser release];
    //    NSLog(@"开奖查询 ：%@", parserDict);
//    if ([errorCode isEqualToString:@"0000"])
//	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCTeamOK" object:nil];
//	}
//	else
//	{
//		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
//	}

}


- (void)getInstantScoreDetailComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    //    NSLog(@"%@",resText);
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getInstantScoreDetailOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}

}
- (void)getLotteryDetailInfoComplete:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    //    NSLog(@"开奖查询 ：%@", parserDict);
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLotteryDetailOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}
- (void)getLotteryAwardInfoComplete:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    //    NSLog(@"开奖查询 ：%@", parserDict);
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLotteryArardInfoDetailOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)getActivityTitleComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.activityTitleStr = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetActivityTitleOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)getActivityContentComplete:(NSString*)resText
{
    self.responseText = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetActivityContentOK" object:nil];
}

- (void)getLotteryInfoListComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    NSLog(@"开奖查询 ：%@", parserDict);
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.lotteryInfoList = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLotteryList" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
	}
}

- (void)launchLotComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message   = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    
    
    if ([errorCode isEqualToString:@"0000"])
	{
        
        NSString* caseLotId = [parserDict objectForKey:@"caseLotId"];
        //二次请求分享内容
        [self launchLotShareDetile:caseLotId];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"fqHeMaiLotOK" object:nil];
        
	}
	else
	{
        if ([message isEqualToString:KBalanceLess])
        {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"notEnoughMoney" object:nil];
            
            return;
        }
        
		[self showMessage:message withTitle:@"发起合买提示" buttonTitle:@"确定"];
	}
    
}

- (void)launchLotGeShareComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message   = [parserDict objectForKey:@"message"];
    
    [jsonParser release];
    
    
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getShareDetileLotOK" object:nil];
        
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"betCompleteOK" object:nil];
	}
	else
	{
        
		[self showMessage:message withTitle:@"发起合买提示" buttonTitle:@"确定"];
	}
    
}


- (void)createAutoJoinComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* message = KISDictionaryHaveKey(parserDict, @"message");
    [jsonParser release];
    [self showMessage:message withTitle:@"定制跟单提示" buttonTitle:@"确定"];

}
- (void)queryLaunchLotStaterComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    self.responseText = resText;
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryLaunchLotStaterCompleteOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"合买发起人信息提示" buttonTitle:@"确定"];
	}
}

- (void)queryCaseLot_autoOrderComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    self.responseText = resText;
    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryCaseLot_aitoOrderCompleteOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"订单查询信息提示" buttonTitle:@"确定"];
	}

}
- (void)cancelAutoOrderComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAutoOrderCompleteOK" object:nil];
        [self showMessage:message withTitle:@"取消定制跟单提示" buttonTitle:@"确定"];
	}
	else
	{
		[self showMessage:message withTitle:@"取消定制跟单提示" buttonTitle:@"确定"];
	}
}
- (void)modifyAutoOrderComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        
	}
    [self showMessage:message withTitle:@"修改定制跟单提示" buttonTitle:@"确定"];

}

- (void)highFrequencyComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    [jsonParser release];
    
    
	self.highFrequencyInfo = resText;

	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateInformation" object:KISDictionaryHaveKey(parserDict, @"batchcode")];
//    KISDictionaryHaveKey(parserDict, @"lotNo")

}

- (void)highFrequencyInquiryTheWinningInformation:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    [jsonParser release];
    
    
	self.highFrequencyInfo = resText;
    
    NSLog(@"%@",KISDictionaryHaveKey(parserDict, @"result"));
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updatehighFrequencyInquiryTheWinningInformation" object:nil userInfo:KISDictionaryHaveKey(parserDict, @"result")];
    
}



- (void)highFrequencyALLComplete:(NSString*)resText{
	NSTrace();
	self.highFrequencyInfo = resText;
    NSLog(@"%@",resText);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAllInformation" object:nil];
}


- (void)jzQueryRecentlyEventComplete:(NSString *)resText notifacationType:(NSString *)type{
    NSTrace();
	self.jzRecentEventInfo = resText;
    NSLog(@"%@",resText);
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:nil];
}

- (void)bdQueryRecentlyEventComplete:(NSString *)resText notifacationType:(NSString *)type{
    NSTrace();
	self.bdRecentEventInfo = resText;
    NSLog(@"%@",resText);
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:nil];
}


- (void)queryRecentlyEventComplete:(NSString *)resText notifacationType:(NSString *)type{
    NSTrace();
	self.recentEventInfo = resText;
    NSLog(@"%@",resText);
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:nil];
}

- (void)highFrequencyComplete:(NSString *)resText notifacationType:(NSString *)type{
    NSTrace();
	self.highFrequencyInfo = resText;
    NSLog(@"%@",resText);
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:nil];
}
- (void)getGiftMessageComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
		self.giftMessageText = resText;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"getGiftMessageOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}	
}
- (void)findpasswordComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"findPswOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}
- (void)getTopWinnerComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.TopWinnerInformation = resText;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"topWinnerOK" object:nil];
        [m_rankingViewController topWinnerOK:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [m_rankingViewController addPullToRefreshHeader];
	}
}
- (void)getInformationContentComplete:(NSString*)resText
{
    NSTrace();
    self.responseText = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getInformationContentOK" object:nil];
}

- (void)getInformationComplete:(NSString*)resText
{
    NSTrace();
    self.newsTitle = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getInformationOK" object:nil];
}
-(void)getInformationComplete:(NSString *)resText RequestType:(NSInteger)type{
    NSTrace();
    self.newsTitle = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getLotteryZoneInformation" object:[NSString stringWithFormat:@"%d",type]];
}

- (void)updateInformationOfLotteryInServers:(NSString*)resText
{
    NSTrace();
    NSLog(@"彩种配置：%@",resText);
    
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* requestDict = (NSDictionary*)[jsonParser objectWithString:resText];
    [jsonParser release];
    
    
    if (![[requestDict objectForKey:@"error_code"]isEqualToString:@"0000"]) {
        return;
    }
    
    NSArray* lotStateArray = [requestDict objectForKey:@"result"];
    NSMutableDictionary* lotStateDic = [NSMutableDictionary dictionaryWithCapacity:1];
    for (int i = 0; i < [lotStateArray count]; i++) {
        [lotStateDic addEntriesFromDictionary:[lotStateArray objectAtIndex:i]];
        
    }
    NSLog(@"lotStateDic:%@", lotStateDic);
    
    //配置彩种顺序和显示
    LotteryOrderAndShowCommander *lotCommander = [[LotteryOrderAndShowCommander alloc]init];
        
    [lotCommander orderAndIsShowFrom:lotStateDic];


    
    
}
- (void)updatePayStationInServers:(NSString*)resText
{
    NSTrace();
    NSLog(@"充值中心配置：%@",resText);
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* requestDict = (NSDictionary*)[jsonParser objectWithString:resText];
    [jsonParser release];
    
    NSArray* lotStateArray = [requestDict objectForKey:@"result"];
    NSLog(@"%@",lotStateArray);
    
    
    [[NSUserDefaults standardUserDefaults] setObject:lotStateArray forKey:kPayStationShowKey];
	[[NSUserDefaults standardUserDefaults] synchronize];//同步
    
//    NSArray* lotStateArray = [requestDict objectForKey:@"result"];
//    NSMutableDictionary* lotStateDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    for (int i = 0; i < [lotStateArray count]; i++) {
//        [lotStateDic addEntriesFromDictionary:[lotStateArray objectAtIndex:i]];
//        
//    }
//    NSLog(@"lotStateDic:%@", lotStateDic);
//    
//    //配置彩种顺序和显示
//    LotteryOrderAndShowCommander *lotCommander = [[LotteryOrderAndShowCommander alloc]init];
//    
//    [lotCommander orderAndIsShowFrom:lotStateDic];
    
    
}
- (void)softUpdateComplete:(NSString*)resText
{
    NSTrace();
    NSLog(@"%@",resText);
    m_netAppType = NET_APP_BASE;
    self.softwareInfo = resText;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    [jsonParser release];
    
    [CommonRecordStatus commonRecordStatusManager].topActionDic = (NSDictionary*)[parserDict objectForKey: @"broadcastmessage"];
    
    //开机界面图
    NSDictionary* imageDict = (NSDictionary*)[parserDict objectForKey:@"image"];
    if([[imageDict objectForKey:@"errorCode"] isEqualToString:@"true"])
    {
        NSString* strId = [imageDict objectForKey:@"id"];
        [CommonRecordStatus commonRecordStatusManager].startImageId = strId;
        
        if(![self sameStartImageId])//下载图片
        {
            [self getStartImage:[imageDict objectForKey:@"imageUrl"]];
        }
        else
        {
            [self readStartImgRecordPath];
            if(![CommonRecordStatus commonRecordStatusManager].useStartImage)
            {
                [CommonRecordStatus commonRecordStatusManager].useStartImage = YES;
                [self saveStartImgRecordPath];
            }
        }
    }
    else
    {
        [self readStartImgRecordPath];
        if([CommonRecordStatus commonRecordStatusManager].useStartImage)
        {
            [CommonRecordStatus commonRecordStatusManager].useStartImage = NO;
            [self saveStartImgRecordPath];
        }
    }
    if (!m_hasLogin)
    {
        //自动登陆
        NSDictionary* subdict = (NSDictionary*)[parserDict objectForKey:@"autoLogin"];
        NSString *str = [subdict objectForKey:@"isAutoLogin"];
        if([str isEqualToString:@"true"])
        {
            self.userno = [[subdict objectForKey:@"userno"] length] > 0 ? [subdict objectForKey:@"userno"] : @"";
            if ([parserDict objectForKey:@"certid"] == (NSString*)[NSNull null] || [(NSString*)[parserDict objectForKey:@"certid"] isEqualToString:@""])
            {
                self.certid = @"";
            }
            else
            {
                self.certid = [subdict objectForKey:@"certid"];
                self.bindName =[subdict objectForKey:@"name"];
            }
            if([[subdict objectForKey:@"isWapPage"] isEqualToString:@"true"])
            {
                self.isSafari = YES;
            }
            else
            {
                self.isSafari = NO;
            }
            
            self.bindPhoneNum = [[subdict objectForKey:@"mobileId"] length] > 0 ? [subdict objectForKey:@"mobileId"] : @"";
            self.bindEmail = [[subdict objectForKey:@"email"] length] > 0 ? [subdict objectForKey:@"email"] : @"";
            [m_delegate.loginView dismissModalView:nil];
            if (/*m_remmberQuitStatus*/
                [CommonRecordStatus commonRecordStatusManager].remmberQuitStatus)
            {
                //不改变 m_hasLogin
            }
            else
            {
                m_hasLogin = YES;
                [self saveUserPlist];
            }
            /*
             始终记住密码
             */
            //记住密码
            //            [self saveUserPlist];
            //            if (m_loginAutoRememberPsw)
            //                [self saveUserPlist];
            //            else
            //                [self resetUserPlist];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"batchCodeInformation" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sofrWareUpdateOK" object:nil];
}
- (void)requestFinish_Two:(ASINetworkReqestTypeTwo)ASIType withStr:(NSString*)reqStr
{
    switch (ASIType)
    {
        case ASINetworkRequestTypeGetBetDetail_Two:
            [self getBetDetailComplete:reqStr];
            break;
        case ASINetworkRequestTypeGetBJDCmatch_Two:
            [self getBJDCDuiZhenComplete:reqStr];
            break;
        default:
            break;
    }
}
- (void)getBJDCDuiZhenComplete:(NSString*)reqStr
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:reqStr];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        [RuYiCaiNetworkManager sharedManager].responseText = reqStr;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getBJDCDuiZhenOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
    
}
-(void)getExchangeScaleSuccess:(NSString *)resText
{
    NSTrace();
    NSLog(@"getExchangeScaleBack:%@",resText);
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* theValue = [parserDict objectForKey:@"value"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"]) {
        [[NSUserDefaults standardUserDefaults] setObject:theValue?theValue:@"250" forKey:@"ADWallExchangeScale"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
-(void)getAdWallImportantInfoSuccess:(NSString *)resText
{
    NSTrace();
    NSLog(@"查询积分墙重要信息返回:%@",resText);
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSDictionary * vD = [parserDict objectForKey:@"value"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getAdwallImportantInfoOK" object:vD];
  
    }

}
-(void)checkNewVersionSuccess:(NSString *)resText
{
    NSTrace();
    NSLog(@"checkNewVersionBack:%@",resText);
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSDictionary* message = (NSDictionary *)[parserDict objectForKey:@"upgrade"];
    NSDictionary* reviewInfo = (NSDictionary *)[parserDict objectForKey:@"info"];
    [jsonParser release];
    if (reviewInfo) {
        NSString * reviewValue = [reviewInfo objectForKey:@"iphoneAuditState"];
        if (reviewValue) {
            if ([reviewValue isEqualToString:@"1"]) {
                
                if (![RuYiCaiNetworkManager sharedManager].shouldCheat) {
                    [RuYiCaiNetworkManager sharedManager].realServerURL = CeshiRuYiCaiServer;
                }
                [RuYiCaiNetworkManager sharedManager].shouldCheat = YES;
                
            }
        }
    }

    if ([errorCode isEqualToString:@"0000"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newVersionCheckOK" object:message];
        
//        NSString * isUpgrade = [message objectForKey:@"isUpgrade"];
//        if ([isUpgrade isEqualToString:@"1"]) {
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"检测到有新版本\n%@",[message objectForKey:@"description"]] delegate:self cancelButtonTitle:@"暂不升级" otherButtonTitles:@"立刻升级", nil];
//            alert.tag = kNewVersionAlertViewTag;
//            [alert show];
//            [alert release];
//        }
    }
}

-(void)cancelAutoLoginOK:(NSString*)resText
{
    NSTrace();
    NSLog(@"cancelAutoLoginSuccess:%@",resText);
}
- (void)updateImformationComplete:(NSString*)resText
{
    NSTrace();
    NSLog(@"%@",resText);
    m_netAppType = NET_APP_BASE;
    self.softwareInfo = resText;
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    [jsonParser release];
    
    [CommonRecordStatus commonRecordStatusManager].topActionDic = (NSDictionary*)[parserDict objectForKey: @"broadcastmessage"];
    
    //已经登陆 而且不是联合登陆
    if (m_hasLogin && [[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
    {
        NSDictionary* subdict = (NSDictionary*)[parserDict objectForKey:@"autoLogin"];
        NSString *str = [subdict objectForKey:@"isAutoLogin"];
        if([str isEqualToString:@"true"])
        {
            self.userno = [[subdict objectForKey:@"userno"] length] > 0 ? [subdict objectForKey:@"userno"] : @"";
            
            
            if ([parserDict objectForKey:@"certid"] == (NSString*)[NSNull null] || [(NSString*)[parserDict objectForKey:@"certid"] isEqualToString:@""])
            {
                self.certid = @"";
            }
            else
            {
                self.certid = [subdict objectForKey:@"certid"];
                self.bindName =[subdict objectForKey:@"name"];
            }
            self.bindPhoneNum = [[subdict objectForKey:@"mobileId"] length] > 0 ? [subdict objectForKey:@"mobileId"] : @"";
            self.bindEmail = [[subdict objectForKey:@"email"] length] > 0 ? [subdict objectForKey:@"email"] : @"";
        }
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"batchCodeInformation" object:nil];
}
- (void)thirdLoginBindComplete:(NSString*)resText
{
        NSTrace();
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
        NSString* errorCode = [parserDict objectForKey:@"error_code"];
        NSString* message = [parserDict objectForKey:@"message"];
        [jsonParser release];
        NSLog(@"thirdLoginBindComplete:%@",resText);
        
        if ([errorCode isEqualToString:@"0000"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"thirdLoginBindOk" object:nil];
            [self showMessage:message withTitle:@"绑定提示" buttonTitle:@"确定"];
            m_netAppType = NET_APP_LOGIN;//更新登录状态
            [self loginWithPhonenum:self.phonenum withPassword:self.password];
        }
        else
        {
            self.phonenum = @"";
            self.password = @"";
            [self showMessage:message withTitle:@"登录失败" buttonTitle:@"确定"];
        }
}

- (void)thirdRegisterComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    NSLog(@"thirdRegisterComplete:%@",resText);
    
    if ([errorCode isEqualToString:@"0000"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"thirdLoginRegisterOk" object:nil];
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        m_netAppType = NET_APP_LOGIN;//更新登录状态
        [self loginWithPhonenum:self.phonenum withPassword:self.password];
        
        
    }
    else
    {
        self.phonenum = @"";
        self.password = @"";
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}
- (void)selectUsernoComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    NSLog(@"loginComplete:%@",resText);
    
    if ([errorCode isEqualToString:@"0000"])
    {

        self.userno = [parserDict objectForKey:@"userno"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserNoOk" object:nil];
    }
    else
    {

        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}
- (void)loginComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    NSLog(@"loginComplete:%@",resText);
    
    if ([errorCode isEqualToString:@"0000"])
    {
        if(![[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])//联合登录
        {
            self.phonenum = @"";
            self.password = @"";
            [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        }
        else
        {
//            [MobClick event:@"loginPage_login_complete"];
            
            NSString *phoneNum = m_delegate.loginView.loginPhonenumTextField.text;
            NSString *pwd = m_delegate.loginView.loginPswTextField.text;
            if (phoneNum.length > 0 && pwd.length > 0) 
            {
                self.phonenum = phoneNum;
                self.password = pwd;
                [self saveUserPlist];
            }
            else
                [self resetUserPlist];
     
            if ([[m_delegate loginView] isRemberMyLoginStatus])//记住我的登录状态
            {
                [m_delegate setLoginRandomNumberNil];
                [m_delegate setAutoLoginRandomNumber:([[parserDict objectForKey:@"randomNumber"] length] > 0 ? [parserDict objectForKey:@"randomNumber"] : @"")];
                [m_delegate saveAutoLoginPlist];
            }
            else
                [m_delegate resetAutoLoginPlist];
        }
 
        m_hasLogin = YES;
        [CommonRecordStatus commonRecordStatusManager].remmberQuitStatus = NO;
        self.userno = [parserDict objectForKey:@"userno"];
        if ([parserDict objectForKey:@"certid"] == (NSString*)[NSNull null] || [(NSString*)[parserDict objectForKey:@"certid"] isEqualToString:@""])                
        {
            self.certid = @"";
        }
        else
        {
            self.certid = [parserDict objectForKey:@"certid"];
            self.bindName =[parserDict objectForKey:@"name"];
        }
        self.bindPhoneNum = [parserDict objectForKey:@"mobileId"];
        self.bindEmail = [parserDict objectForKey:@"email"];
        NSString* isWapPageStr = [parserDict objectForKey:@"isWapPage"];
        if([isWapPageStr isEqualToString:@"true"])
        {
            self.isSafari = YES;
        }
        else
        {
            self.isSafari = NO;
        }
        [m_delegate.loginView dismissModalView:nil];
        
        [self loginOKLater];
    }else if([errorCode isEqualToString:@"1111"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"firstUseUnionLoginOk" object:nil];
    }
    else
    {
        self.phonenum = @"";
        self.password = @"";
        self.userno = @"";
        self.certid = @"";
        [self showMessage:message withTitle:@"登录失败" buttonTitle:@"确定"];
    }
}

- (void)loginOKLater
{
//    if (NET_APP_JOIN_CUSTOMBAR_USER_CENTER == m_netAppType)
//    {
//        [self queryUserBalance];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"joinCustomBar_usercenter" object:nil];
//    }
//    else
    if (NET_APP_LOGIN == m_netAppType)
    {
        [self queryUserBalance];
        [self queryRemainingChanceForLot];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:nil];
    }
    else if (NET_APP_JOIN_ACTION == m_netAppType)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryJoinLoginOK" object:nil];
    }
    else if (NET_APP_BET_CASE_LOT_LOGIN == m_netAppType)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"betCaseLotLoginOK" object:nil];
    }
    else if (NET_APP_AUTO_ORDER_LOGIN == m_netAppType)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createAutoJoinLoginOK" object:nil];
    }
    
    else if (NET_APP_USER_CENTER == m_netAppType)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoginOK" object:nil];
    }
    else if (NET_APP_FEED_BACK == m_netAppType )//|| NET_APP_HELP_SET == m_netAppType)
    {
        [self queryUserBalance];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoginOK2" object:nil];
    }
    else if(NET_APP_QUERY_LOT_BET == m_netAppType)//投注页面--投注查询
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryBetlot_loginOK" object:nil];
    }
//    else if (NET_APP_QUERY_DNA != m_netAppType)
//    {
//        [self queryUserBalance];//在另一界面登录时，获取余额
//        [self handleUserCenterClick2];
//    }
    else if (NET_APP_QUERY_DNA == m_netAppType)
    {
        [self queryUserBalance];
    }
    else if (NET_APP_ADWALL_LOGIN == m_netAppType){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AdWallloginOK" object:nil];
    }
    else
    {
        [self queryUserBalance];
    }
}

- (void)regComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
//        [MobClick event:@"registPage_regist_complete"];
        
        //[m_registerAlertView dismissWithClickedButtonIndex:0 animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registerOK" object:nil];
        [self showMessage:message withTitle:@"注册成功" buttonTitle:@"确定"];
        
        m_netAppType = NET_APP_LOGIN;//更新登录状态
        [self loginWithPhonenum:self.phonenum withPassword:self.password];
    }
    else
    {
        self.phonenum = @"";
        self.password = @"";
        [self showMessage:message withTitle:@"注册失败" buttonTitle:@"确定"];
    }
}

- (void)sendFeedbackComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"errorCode"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"success"])
    {
        self.isRefreshUserCenter = YES;
        [self showMessage:message withTitle:@"用户反馈" buttonTitle:@"确定"];
        //[self queryLeaveMessage:@"0"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"feedBackOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"用户反馈" buttonTitle:@"确定"];
    }
}

- (void)queryCaseLotComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"] || [errorCode isEqualToString:@"0047"])
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryCaseLotOK" object:errorCode];
    }
    else
    {
        [self showMessage:message withTitle:@"参与合买查询" buttonTitle:@"确定"];
    }
}

- (void)ticketPropagandaComplete:(NSString*)resText{
	NSTrace();
//	self.ticketPropagandaInfo = resText;
    NSLog(@"%@",resText);
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryTicketPropaganda" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"参与合买查询" buttonTitle:@"确定"];
    }

}

- (void)betCaseLotComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        //        self.responseText = resText;
        //        [self showMessage:message withTitle:@"参与合买" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"betCaseLotOKClick" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"参与合买" buttonTitle:@"确定"];
    }
}

- (void)queryAllCaseLotComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryAllCaseLotOK" object:nil];
    }
	else if([errorCode isEqualToString:@"0407"])
	{
		self.responseText = resText;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"queryAllCaseLotOK" object:nil];
//	    [self showMessage:message withTitle:@"查询所有合买" buttonTitle:@"确定"];
	}
    else
    {
        [self showMessage:message withTitle:@"查询所有合买" buttonTitle:@"确定"];
    }
}

- (void)queryCaseLotDetailComplete:(NSString *)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryCaseLotDetailOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"查询所有合买" buttonTitle:@"确定"];
    }
}

- (void)submitLotComplete:(NSString*)resText
{
	NSTrace();//投注
    NSLog(@"betBackStr:%@",resText);
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [CommonRecordStatus commonRecordStatusManager].errerCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        if([[RuYiCaiLotDetail sharedObject].betType isEqualToString:@"gift"])
        {
            [CommonRecordStatus commonRecordStatusManager].resultWarn = message;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"giftSendSms" object:nil];
        }
        else
        {
//            [MobClick event:@"bet_complete"];

            self.isRefreshUserCenter = YES;

            [[NSNotificationCenter defaultCenter] postNotificationName:@"betCompleteOK" object:nil];          
            [self showMessage:message withTitle:@"投注提示" buttonTitle:@"确定"];
        }
    }
    else if([errorCode isEqualToString:@"0406"])//余额不足
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notEnoughMoney" object:nil];

    }
    else if([errorCode isEqualToString:@"1113"])//彩豆余额不足
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notEnoughMoney" object:nil];
        
    }
    else if([errorCode isEqualToString:@"1001"])//过期处理
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"betOutTime" object:[parserDict objectForKey:@"batchcode"]];
    }
    else if ([errorCode isEqualToString:@"1112"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZhuShuOut" object:message];
    }
    else
	{
        
        [self showMessage:message withTitle:@"投注失败提示" buttonTitle:@"确定"];
	}
}

- (void)getLotteryInformationComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    self.lotteryInformation = resText;
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLottery" object:nil];
}
- (void)getNotification: (NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRGetNotificationOK" object:nil userInfo:parserDict];
    }
    else
    {
        [self showMessage:message withTitle:@"" buttonTitle:@"确定"];
    }
}
- (void)getTopOneMessage: (NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRGetTopOneMessageOK" object:nil userInfo:parserDict];
    }
    else
    {
//        [self showMessage:message withTitle:@"" buttonTitle:@"确定"];
    }
}
- (void)getMessageDetail: (NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRGetMessageDetailOK" object:nil userInfo:parserDict];
    }
    else
    {
        [self showMessage:message withTitle:@"" buttonTitle:@"确定"];
    }
}
- (void)getMessageList: (NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRGetMessageListOK" object:nil userInfo:parserDict];
    }
    else
    {
        [self showMessage:message withTitle:@"" buttonTitle:@"确定"];
    }
}
- (void)exchangeLotPea: (NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRExchangeLotPeaOK" object:nil userInfo:parserDict];
    }
    else
    {
        [self showMessage:message withTitle:@"" buttonTitle:@"确定"];
    }
}
- (void)CheckoutCaptcha:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRCheckoutCaptchaOK" object:nil userInfo:parserDict];
    }
    else
    {
        [self showMessage:message withTitle:@"账户查询" buttonTitle:@"确定"];
    }
}
- (void)getCaptcha:(NSString*)resText
{
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRGetCheckoutNoWithPhongNoFail" object:nil userInfo:parserDict];
    }
}
- (void)queryCaodouDetailComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
    }
    else
    {
        [self showMessage:message withTitle:@"账户查询" buttonTitle:@"确定"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryCaodouDetailOK" object:nil userInfo:parserDict];
}
#pragma mark Login Operation

- (void)setupLoginAlertView
{
    [m_delegate.loginView presentModalView:nil];
    
    [m_delegate.loginView.useClearPws setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateNormal];
    [m_delegate.loginView.useClearPws setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateHighlighted];
    
    m_delegate.loginView.loginPswTextField.secureTextEntry = YES;
    m_delegate.loginView.isUseclearPws = NO;
    
    if(!m_delegate.autoRememberMystatus)
    {
//        [m_delegate.loginView.rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateNormal];
//        [m_delegate.loginView.rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
//        m_delegate.loginView.isRemberMyLoginStatus = NO;
    }
    
    //    if (m_loginAutoRememberPsw)
    //    {
    //        m_delegate.loginView.loginPhonenumTextField.text = m_phonenum;
    //        m_delegate.loginView.loginPswTextField.text = m_password;
    //    }
    //    else
    //    {
    //        m_delegate.loginView.loginPhonenumTextField.text = nil;
    //        m_delegate.loginView.loginPswTextField.text = nil;
    //    }
}
- (void)setupLoginAlertViewAndAddAnimation:(BOOL)animationType
{
    [m_delegate.loginView presentModalView:nil andAddAnimationType:animationType];
    
    [m_delegate.loginView.useClearPws setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateNormal];
    [m_delegate.loginView.useClearPws setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateHighlighted];
    
    m_delegate.loginView.loginPswTextField.secureTextEntry = YES;
    m_delegate.loginView.isUseclearPws = NO;
    
    if(!m_delegate.autoRememberMystatus)
    {
//        [m_delegate.loginView.rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_nomal.png"] forState:UIControlStateNormal];
//        [m_delegate.loginView.rememberMyLoginStatusPswButton setBackgroundImage:[UIImage imageNamed:@"login_state_select.png"] forState:UIControlStateHighlighted];
//        m_delegate.loginView.isRemberMyLoginStatus = NO;
    }
    m_delegate.loginView.rememberMyLoginStatusPswButton.hidden = YES;
    
    //    if (m_loginAutoRememberPsw)
    //    {
    //        m_delegate.loginView.loginPhonenumTextField.text = m_phonenum;
    //        m_delegate.loginView.loginPswTextField.text = m_password;
    //    }
    //    else
    //    {
    //        m_delegate.loginView.loginPhonenumTextField.text = nil;
    //        m_delegate.loginView.loginPswTextField.text = nil;
    //    }
}

- (void)showLoginAlertView
{
    if (m_hasLogin)
        return;
    [self setupLoginAlertView];
}
- (void)showLoginAlertViewAndAddAnimation:(BOOL)animationType
{
    if (m_hasLogin)
        return;

    [self setupLoginAlertViewAndAddAnimation:animationType];

}
//- (void)forgetPasswordClick:(id)sender
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ruyicai.com/rules/findPwd.html"]];
//}

- (NSString*)getPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
		NSString* strSub = @"/profile.plist";
        NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[strSub lastPathComponent]];
		return dPath;
	}
	return nil;
}

- (void)readUserPlist
{
    m_loginAutoRememberPsw = NO;
    NSString* strPath = [self getPath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPath] == NO)
		return;
	
	NSMutableArray* userList = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
	NSString* strPhonenum = [userList objectAtIndex:0];
	NSString* strPassword = [userList objectAtIndex:1];
    if (strPhonenum.length > 0 && strPassword.length > 0)
    {
        m_loginAutoRememberPsw = YES;
        self.phonenum = strPhonenum;
        self.password = strPassword;
    }
    [userList release];
}

- (void)saveUserPlist
{
    NSMutableArray* userList = [[NSMutableArray alloc] init];
    [userList addObject:self.phonenum];
    [userList addObject:self.password];
    
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
    m_loginAutoRememberPsw = NO;
}
 
#pragma mark Change User Operation

- (void)showChangeUserAlertView
{
    [self setupLoginAlertView];
}

#pragma mark AlertView

- (void)showMessage:(NSString*)message withTitle:(NSString*)title buttonTitle:(NSString*)buttonTitle
{
    [m_bindPhoneField resignFirstResponder];
    [m_bindEmailField resignFirstResponder];
    [m_bindPhoneSecurityField resignFirstResponder];
    [m_nickNameField resignFirstResponder];
//    [m_receiveLotteryField resignFirstResponder];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:message
												   delegate:self 
										  cancelButtonTitle:buttonTitle
										  otherButtonTitles: nil];
    alert.tag = kNomalAlertViewTag;
	[alert show];
	[alert release];
}

- (void)showProgressViewWithTitle:(NSString*)title message:(NSString*)message net:(ASIHTTPRequest*)myRequest
{
//	[m_progressAlertView release];
//	m_progressAlertView = [[RYCProcessView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:nil];
//	
//	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//	activityView.frame = CGRectMake(139.0f - 18.0f, 80.0f, 37.0f, 37.0f);
//	[m_progressAlertView addSubview:activityView];
//	[activityView startAnimating];
//	m_progressAlertView.request = myRequest;
//	[m_progressAlertView show];
    m_delegate.activityView.titleLabel.text = message;
    [m_delegate.activityView activityViewShow];
    
//    [self performSelector:@selector(alertChaoshi) withObject:self afterDelay:3];
    
    
}
//- (void)alertChaoshi
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请检测您的网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
//    [alertView show];
//    [alertView release];
//}
//- (void)showURLProgressViewWithTitle:(NSString*)title message:(NSString*)message
//{
//	[m_progressAlertView release];
//	m_progressAlertView = [[RYCProcessView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:nil];
//	
//	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//	activityView.frame = CGRectMake(139.0f - 18.0f, 80.0f, 37.0f, 37.0f);
//	[m_progressAlertView addSubview:activityView];
//	[activityView startAnimating];
//	[m_progressAlertView show];	
//}

//- (void)showLotSubmitMessage:(NSString*)messsage withTitle:(NSString*)title
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"betNormal" object:nil];
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (kNomalAlertViewTag == alertView.tag)
    {
		if(isRefresh)
		{
	        [[NSNotificationCenter defaultCenter] postNotificationName:@"betCaseLotOKClick" object:nil];
			isRefresh = NO;
		}
    }
//     if (alertView.tag==kNewVersionAlertViewTag) {
//        if (buttonIndex==1) {
//            [RuYiCaiNetworkManager gotoUpgrade];
//        }
//    }
}


- (void)willPresentAlertView:(UIAlertView *)alertView //委托方法
{ 
    if(kBindCertidAlertViewTag == alertView.tag)
    {
        alertView.frame = CGRectMake(15, 20, 285, 260);
    }
}
#pragma mark Get Information of RuYiCai
- (NSArray*)getSoftwareVersionInfo
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.softwareInfo];
    NSString* news = [parserDict objectForKey:@"news"];
    [jsonParser release];    
    return [news componentsSeparatedByString:@","];
}

- (BOOL)checkSoftwareVersion
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.softwareInfo];
	NSLog(@"softwareInfo:%@\n",self.softwareInfo);
    NSString* updateurl = [parserDict objectForKey:@"updateurl"];
    [jsonParser release];
    if (updateurl.length > 0)
    {
        NSString* message = [parserDict objectForKey:@"message"];
        [self showMessage:message withTitle:@"软件更新提示" buttonTitle:@"确定"];
        return YES;
    }
    return NO;
}

- (NSString*)getBatchCodeOfLot:(NSString*)lotCode
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.softwareInfo];
    [jsonParser release];
    NSDictionary* currentBathCode = [parserDict objectForKey:@"currentBatchCode"];
    NSDictionary* lotDict = [currentBathCode objectForKey:lotCode];

	return [lotDict objectForKey:@"batchCode"];
}

- (NSString*)getEndtimeOfLot:(NSString*)lotCode
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.softwareInfo];
    [jsonParser release];
    NSDictionary* currentBathCode = [parserDict objectForKey:@"currentBatchCode"];
    NSDictionary* lotDict = [currentBathCode objectForKey:lotCode];
    return [lotDict objectForKey:@"endTime"];
}


- (NSString*)highFrequencyLastEvent
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.recentEventInfo];
	//NSString* message = [parserDict objectForKey:@"message"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        NSDictionary* titleStrDic = [parserDict objectForKey:@"result"];
		return [titleStrDic objectForKey:@"recentlyMatch"];
	}
	else
	{
		return @"";//当值小于0时，不做倒计时
	}
}


- (NSString*)jzHighFrequencyLastEvent
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.jzRecentEventInfo];
	//NSString* message = [parserDict objectForKey:@"message"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        NSDictionary* titleStrDic = [parserDict objectForKey:@"result"];
		return [titleStrDic objectForKey:@"recentlyMatch"];
	}
	else
	{
		return @"";//当值小于0时，不做倒计时
	}
}

- (NSString*)bdHighFrequencyLastEvent
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.bdRecentEventInfo];
	//NSString* message = [parserDict objectForKey:@"message"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        NSDictionary* titleStrDic = [parserDict objectForKey:@"result"];
		return [titleStrDic objectForKey:@"recentlyMatch"];
	}
	else
	{
		return @"";//当值小于0时，不做倒计时
	}
}

- (NSString*)highFrequencyLeftTime
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.highFrequencyInfo];
	//NSString* message = [parserDict objectForKey:@"message"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
		return [parserDict objectForKey:@"time_remaining"];
	}
	else
	{
		return @"-1";//当值小于0时，不做倒计时
	}
}

- (NSString*)highFrequencyCurrentCode
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.highFrequencyInfo];
	//NSString* message = [parserDict objectForKey:@"message"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
		return [parserDict objectForKey:@"batchcode"];
	}
	else
	{
		return @"-1";
	}
}

- (NSString*)highFrequencyEndTime
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:self.highFrequencyInfo];
	//NSString* message = [parserDict objectForKey:@"message"];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
		return [parserDict objectForKey:@"endtime"];
	}
	else
	{
		return @"-1";
	}
}


#pragma mark RuYiCai test Net connect
- (BOOL)testConnection {
    BOOL result = YES;
    Reachability *reach=[Reachability sharedReachability];
    [reach setHostName:@"www.baidu.com"];
    NetworkStatus status;
    status=[reach remoteHostStatus];
    if (status == NotReachable) {
        result = NO;
    } else if (status == ReachableViaCarrierDataNetwork) {
        result = YES;
    } else if (status == ReachableViaWiFiNetwork) {
        result = YES;
    }else {
        result = NO;
    }
    return result;
}

#pragma mark base64 method
+ (NSData * )decodeBase64:(NSData * )_data 
{ 
    //NSData * data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    // 转换到base64 
    _data = [GTMBase64 decodeData:_data]; 
    //NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
    return _data; 
}

+ (NSString*)encodeBase64:(NSData*)data  
{  
    //转换到base64  
    data = [GTMBase64 encodeData:data];  
    NSString * base64String = [[NSString alloc] initWithData:data  
                                                    encoding:NSUTF8StringEncoding];  
    return base64String;  
}  

#pragma mark RuYiCai Network Manager initialization

+ (RuYiCaiNetworkManager*)sharedManager
{
    @synchronized(self) 
    {
		if (s_networkManager == nil) 
		{
			s_networkManager = [[self alloc] init];  //assignment not done here
		}
	}
	return s_networkManager;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
		if (s_networkManager == nil) 
		{
			s_networkManager = [super allocWithZone:zone];
			return s_networkManager;  //assignment and return on first allocation
		}
	}	
	return nil;  //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    
}

- (id)autorelease 
{
	return self;
}

@end