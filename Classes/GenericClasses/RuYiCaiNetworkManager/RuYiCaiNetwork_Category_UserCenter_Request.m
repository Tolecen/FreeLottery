//
//  RuYiCaiNetwork_Category_UserCenter_Request.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"
#import "UserInformationAlertView.h"
#import "UserBindDetileVC.h"


@implementation RuYiCaiNetworkManager (RuYiCaiNetwork_Category_UserCenter_Request)

#pragma mark User Center Event 用户中心

- (void)UpdateUserInfo
{

    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:@"userCenter" forKey:@"type"];
    [mDict setObject:self.userno forKey:@"userno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"用户中心：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeUserCenter];
	[request setDelegate:self];
	[request startAsynchronous];
//    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)handleUserCenterClick
{
    if (m_hasLogin)
        [self handleUserCenterClick2];
    else
        [self showLoginAlertView];
}

- (void)handleUserCenterClick2
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:nil];
    switch (m_netAppType)
    {
        case NET_APP_QUERY_LOT_WIN:
            [self queryLotWinOfPage:0];
            break;
        case NET_APP_QUERY_LOT_BET:
            [self queryLotBetOfPage:0 lotNo:([CommonRecordStatus commonRecordStatusManager].QueryBetlotNO)];
            break;
        case NET_APP_QUERY_TRACK:
            [self queryTrackOfPage:0];
            break;
        case NET_APP_QUERY_BALANCE:
            [self queryUserBalance];
            break;
        case NET_APP_QUERY_GIFT:
            [self queryGiftOfPage:0 hasGift:YES];
            break;
        case NET_APP_ACCOUNT_DETAIL:
            [self queryAccountDetailOfPage:0 transactionType:0];
            break;
        case NET_APP_GET_CASH:
            //[self queryCash];
            [self queryDNA];
            break;
        case NET_APP_BIND_PHONE:
            [self bindPhone];
            break;
        case NET_APP_BIND_EMAIL:
            [self bindNewEmail];
            break;
        case NET_APP_BIND_CERTID:
            [self bindCertid];
            break;
        case NET_APP_CAIDOU_DETAIL:
            [self queryCaidouDetailOfPage:0 requestType:nil];
            break;
        default:
            break;
    }
}
- (void)checkoutCaptchaNoWithPjoneNo:(NSString*)phoneNo CaptchaNo:(NSString*)CaptchaNo
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"userCenter" forKey:@"command"];
    [mDict setObject:@"validateCaptcha" forKey:@"type"];
    [mDict setObject:phoneNo forKey:@"bindPhoneNum"];
    [mDict setObject:CaptchaNo forKey:@"securityCode"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeCheckoutCaptcha];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getCheckoutNoWithPhongNo:(NSString*)phoneNo requestType:(NSString*)type
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"userCenter" forKey:@"command"];
    [mDict setObject:@"generateCaptcha" forKey:@"type"];
    [mDict setObject:phoneNo forKey:@"bindPhoneNum"];
    [mDict setObject:type forKey:@"requestType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetCaptcha];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)queryLotWinOfPage:(NSUInteger)pageIndex
{
//    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
//	request.allowCompressedResponse = NO;
//    
//    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
//    [mDict setObject:@"QueryLot" forKey:@"command"];
//    [mDict setObject:self.phonenum forKey:@"phonenum"];
//    [mDict setObject:self.userno forKey:@"userno"];
//    //[mDict setObject:[NSString stringWithFormat:@"%d", pageIndex * 10] forKey:@"stopline"];
//	//[mDict setObject:[NSString stringWithFormat:@"%d", (pageIndex - 1) * 10] forKey:@"starline"];
//    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
//	[mDict setObject:@"10" forKey:@"maxresult"];
//    [mDict setObject:@"win" forKey:@"type"];
//    
//    SBJsonWriter *jsonWriter = [SBJsonWriter new];
//    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
//	NSLog(@"中奖查询：%@",cookieStr);
//    [jsonWriter release];
//    
//    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
//    [request appendPostData:sendData];  
//    [request buildPostBody];
//    
//	[request setRequestType:ASINetworkRequestTypeQueryLotWin];
//	[request setDelegate:self];
//	[request startAsynchronous];
//    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
    
    
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    //    [mDict setObject:@"QueryLot" forKey:@"command"];
    //    [mDict setObject:self.phonenum forKey:@"phonenum"];
    //    [mDict setObject:self.userno forKey:@"userno"];
    //    //[mDict setObject:[NSString stringWithFormat:@"%d", pageIndex * 10] forKey:@"stopline"];
    //	//[mDict setObject:[NSString stringWithFormat:@"%d", (pageIndex - 1) * 10] forKey:@"starline"];
    //    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    //	[mDict setObject:@"10" forKey:@"maxresult"];
    //    [mDict setObject:@"win" forKey:@"type"];
    //新接口
    [mDict setObject:@"select" forKey:@"command"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
	[mDict setObject:@"10" forKey:@"maxresult"];
    [mDict setObject:@"winList" forKey:@"requestType"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
	NSLog(@"中奖查询：%@",cookieStr);
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryLotWin];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryLotBetOfPage:(NSUInteger)pageIndex lotNo:(NSString *)lotno
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    //    [mDict setObject:@"QueryLot" forKey:@"command"];
    //    [mDict setObject:self.phonenum forKey:@"phonenum"];
    //    [mDict setObject:self.userno forKey:@"userno"];
    //    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    //	[mDict setObject:@"10" forKey:@"maxresult"];
    //    [mDict setObject:@"bet" forKey:@"type"];
    [mDict setObject:lotno forKey:@"lotno"];
    //    [mDict setObject:@"1" forKey:@"isSellWays"];//传回多注投格式
    
    //新接口
    [mDict setObject:@"select" forKey:@"command"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
	[mDict setObject:@"10" forKey:@"maxresult"];
    [mDict setObject:@"betList" forKey:@"requestType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"投注查询%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryLotBet];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryTrackOfPage:(NSUInteger)pageIndex
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
	[mDict setObject:@"10" forKey:@"maxresult"];
	[mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDict setObject:@"track" forKey:@"type"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"＊＊＊＊＊追号查询:%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryTrack];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)cancelTrack:(NSString*)tsubscribeNo
{
	NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"cancelTrack" forKey:@"command"];
	[mDict setObject:tsubscribeNo forKey:@"tsubscribeNo"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"＊＊＊＊＊＊取消追号:%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeCancelTrack];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

//获得最近一场赛事
- (void)getRecentlyEvent:(NSString*)numId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"recentlyJingCaiMatch" forKey:@"type"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phoneSIM"];
    [mDict setObject:kRuYiCaiCoopid forKey:@"coopid"];
    [mDict setObject:numId forKey:@"jingcaiType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"最近一场：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    [request setRequestType:ASINetworkRequestTypeRecentlyEvent];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


//获得最近一场赛事
- (void)getZQRecentlyEvent:(NSString*)numId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"recentlyJingCaiMatch" forKey:@"type"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phoneSIM"];
    [mDict setObject:kRuYiCaiCoopid forKey:@"coopid"];
    [mDict setObject:numId forKey:@"jingcaiType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"最近一场：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    [request setRequestType:ASINetworkRequestTypeJZRecentlyEvent];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


//获得最近一场赛事北京单场
- (void)getBDRecentlyEvent:(NSString*)numId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"recentlyJingCaiMatch" forKey:@"type"];
    [mDict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phoneSIM"];
    [mDict setObject:kRuYiCaiCoopid forKey:@"coopid"];
    [mDict setObject:numId forKey:@"jingcaiType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"BD最近一场：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    [request setRequestType:ASINetworkRequestTypeBDRecentlyEvent];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


- (void)queryUserBalance
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"10" forKey:@"stopline"];
	[mDict setObject:@"0" forKey:@"starline"];
    [mDict setObject:@"balance" forKey:@"type"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"query :%@", cookieStr);
	[request setRequestType:ASINetworkRequestTypeQueryBalance];
	[request setDelegate:self];
	[request startAsynchronous];
    //[self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

#pragma mark 投注明细
- (void)getBetDetailWithDic:(NSMutableDictionary*)inforDic
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:inforDic];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"投注明细：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    [request setRequestType:ASINetworkRequestTypeBase];
	[request setRequestTypeTwo:ASINetworkRequestTypeGetBetDetail_Two];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)exchangeLotPeaWithAmount:(NSString*)amount
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"exchange" forKey:@"requestType"];
    [mDict setObject:@"lotPea" forKey:@"command"];
    [mDict setObject:amount forKey:@"amount"];
    [mDict setObject:self.userno forKey:@"userno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"账户查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeExchangeLotPea];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)queryGiftOfPage:(NSUInteger)pageIndex hasGift:(BOOL)isGift
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    if(isGift)
	{
		[mDict setObject:@"gift" forKey:@"type"];
	}
	else
	{
		[mDict setObject:@"gifted" forKey:@"type"];
	}
    [mDict setObject:@"10" forKey:@"maxresult"];
	int page = pageIndex + 1;
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageindex"];
	[mDict setObject:@"" forKey:@"lotno"];
	[mDict setObject:@"" forKey:@"batchcode"];
	[mDict setObject:self.userno forKey:@"userno"];
	
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"赠送查询：%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryGift];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryAccountDetailOfPage:(NSUInteger)pageIndex transactionType:(NSUInteger)type
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"accountdetail" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"new" forKey:@"type"];
    [mDict setObject:[NSString stringWithFormat:@"%d", type] forKey:@"transactiontype"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"账户查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeAccountDetail];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryCash
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"getCash" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"10" forKey:@"stopline"];
    [mDict setObject:@"0" forKey:@"startline"];
    [mDict setObject:@"queryCash" forKey:@"cashtype"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"提现：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryCash];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getNotificationWithID: (NSString *)ID
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"announcement" forKey:@"command"];
    [mDict setObject:@"msgDetail" forKey:@"requestType"];
    [mDict setObject:ID forKey:@"id"];
    [mDict setObject:self.userno forKey:@"userno"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"账户查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetNotification];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getTopOneMessage
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"announcement" forKey:@"command"];
    [mDict setObject:@"topOne" forKey:@"requestType"];
    [mDict setObject:self.userno forKey:@"userno"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"账户查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetTopOneMessage];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getMessageDetailWithID:(NSString*)ID
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"announcement" forKey:@"command"];
    [mDict setObject:@"msgDetail" forKey:@"requestType"];
    [mDict setObject:ID forKey:@"id"];
    [mDict setObject:self.userno forKey:@"userno"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"账户查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetMessageDetail];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getMessageListWithPage:(NSString*)page
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"announcement" forKey:@"command"];
    [mDict setObject:@"msgList" forKey:@"requestType"];
    [mDict setObject:page forKey:@"pageindex"];
    [mDict setObject:@"10" forKey:@"maxresult"];
    [mDict setObject:self.userno forKey:@"userno"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"账户查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetMessageList];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)queryCaidouDetailOfPage:(NSUInteger)pageIndex requestType:(NSString*)type
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"lotPea" forKey:@"command"];
    [mDict setObject:@"detail" forKey:@"requestType"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];
    [mDict setObject:@"7" forKey:@"maxresult"];
    if (type) {
        if ([type isEqualToString:@"add"]) {
            [mDict setObject:@"1" forKey:@"blsign"];
        }
        if ([type isEqualToString:@"cut"]) {
            [mDict setObject:@"-1" forKey:@"blsign"];
        }
    }
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"账户查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeCaidouDetail];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)queryRecordCash:(NSString*)pageIndex maxResult:(NSString*)maxResult
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"getCash" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"cashRecord" forKey:@"cashtype"];
    [mDict setObject:maxResult forKey:@"maxresult"];
    [mDict setObject:pageIndex forKey:@"pageindex"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"提现记录查询%@",cookieStr);
	
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeQueryRecordCash];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];

}
- (void)getCash:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:otherDict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
	NSLog(@"提现：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeGetCash];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)cancelCash:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:otherDict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"取消提现：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeCancelCash];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)updateUserCenter:(NSString*)resText
{
    
    NSTrace();
    self.userCenterInfo = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getUserCenterInfoOK" object:nil];
}

- (void)nickNameSet:(NSString*)nickname
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"updateNickName" forKey:@"type"];
    [mDict setObject:nickname forKey:@"nickName"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"昵称：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeNickName];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryLeaveMessage:(NSString*)pageIndex
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"feedback" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"feedBack" forKey:@"type"];
    [mDict setObject:@"10" forKey:@"maxresult"];
    [mDict setObject:pageIndex forKey:@"pageindex"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"留言：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeLeaveMessage];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

//- (void)receiveLotterySecurity:(NSString*)presentId
//{
//    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
//	request.allowCompressedResponse = NO;
//    
//    self.m_presentId = presentId;
//    
//    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
//    [mDict setObject:@"betLot" forKey:@"command"];
//    [mDict setObject:self.phonenum forKey:@"phonenum"];
//    [mDict setObject:self.userno forKey:@"userno"];
//    [mDict setObject:@"receivePresentSecurityCode" forKey:@"bettype"];
//    [mDict setObject:presentId forKey:@"presentId"];
//    
//    SBJsonWriter *jsonWriter = [SBJsonWriter new];
//    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
//    [jsonWriter release];
//    NSLog(@"领取彩票验证：%@",cookieStr);
//    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
//    [request appendPostData:sendData];  
//    [request buildPostBody];
//    
//	[request setRequestType:ASINetworkRequestTypeReceiveLotterySecurity];
//	[request setDelegate:self];
//	[request startAsynchronous];
//    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
//    
//}

//- (void)receiveLottery:(NSString*)security 
//{
//    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
//	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
//	request.allowCompressedResponse = NO;
//    
//    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
//    [mDict setObject:@"betLot" forKey:@"command"];
//    [mDict setObject:self.phonenum forKey:@"phonenum"];
//    [mDict setObject:self.userno forKey:@"userno"];
//    [mDict setObject:@"receivePresent" forKey:@"bettype"];
//    [mDict setObject:security forKey:@"securityCode"];
//    [mDict setObject:self.m_presentId forKey:@"presentId"];
//    
//    SBJsonWriter *jsonWriter = [SBJsonWriter new];
//    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
//    [jsonWriter release];
//    NSLog(@"领取彩票：%@",cookieStr);
//    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
//    [request appendPostData:sendData];  
//    [request buildPostBody];
//    
//	[request setRequestType:ASINetworkRequestTypeReceiveLottery];
//	[request setDelegate:self];
//	[request startAsynchronous];
//    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
//}

- (void)getIntegralInfo:(NSString*)pageIndex
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"scoreDetail" forKey:@"type"];
    [mDict setObject:pageIndex forKey:@"pageindex"];
    [mDict setObject:@"10" forKey:@"maxresult"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"积分详细：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeIntegralInfo];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)integralTransMoneyNeedsScores
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"score" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"transMoneyNeedScores" forKey:@"requestType"];
 
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"积分兑换描述：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeIntegralTransMoneyNeedsScores];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)transIntegral:(NSString*)score
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"transScore2Money" forKey:@"type"];
    [mDict setObject:score forKey:@"score"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"积分兑换：%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeTransIntegral];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

#pragma mark Recharge  账户充值
- (void)queryDNA
{
    m_netChargeQuestType = NET_ACCOUNT_TAKE_CASH;
    
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:m_phonenum forKey:@"phonenum"];
	[mDict setObject:m_userno forKey:@"userno"];
    [mDict setObject:@"dna" forKey:@"type"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeQueryDNA];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

//bank charge
- (void)chargeDNA:(NSMutableDictionary*)otherDict
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
    
	[request setRequestType:ASINetworkRequestTypeChargeDNA];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)chargeByPhoneCard:(NSMutableDictionary*)otherDict
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
    NSLog(@"充值 cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeChargePhoneCard];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)chargeByAlipay:(NSMutableDictionary*)otherDict
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
    
	[request setRequestType:ASINetworkRequestTypeChargeAlipay];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


- (void)umpayByCredit:(NSMutableDictionary*)otherDict
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
    NSLog(@"信用卡充值:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeUmpayCreDit];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


- (void)wealthTenpayFor:(NSMutableDictionary*)otherDict
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
    NSLog(@"财付通支付请求:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeWealthTenpay];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


- (void)chargeByUnionBankCard:(NSMutableDictionary*)otherDict
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
    NSLog(@"银联充值:%@", cookieStr);
    
	[request setRequestType:ASINetworkRequestTypeChargeUnionBankCard];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

#pragma mark bindPhone and bindCertid
- (void)bindWithCertid:(NSString*)certNum tureName:(NSString*)turename
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updateUserInfo" forKey:@"command"];
    [mDict setObject:certNum forKey:@"certid"];
    [mDict setObject:turename forKey:@"name"];
    [mDict setObject:m_phonenum forKey:@"phonenum"];
	[mDict setObject:m_userno forKey:@"userno"];
    
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"绑定身份证：%@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    [request setRequestType:ASINetworkReqestTypeBindCertid];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getBindEmailSecurityCode:(NSString*)bindEmail
{
    self.bindEmail = bindEmail;
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"userInfo" forKey:@"command"];
    [mDict setObject:@"bindEmail" forKey:@"requestType"];
    [mDict setObject:bindEmail forKey:@"email"];
	[mDict setObject:m_userno forKey:@"userno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    [request setRequestType:ASINetworkReqestTypeBindEmailSecurity];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)getBindPhoneSecurityCode:(NSString*)bindPhone
{
    self.bindNewPhoneNum = bindPhone;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[RuYiCaiNetworkManager sharedManager].realServerURL]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"userCenter" forKey:@"command"];
    [mDict setObject:@"generateCaptcha" forKey:@"type"];
    [mDict setObject:bindPhone forKey:@"bindPhoneNum"];
    [mDict setObject:@"1" forKey:@"requestType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSLog(@"%@",cookieStr);
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    
    [request buildPostBody];
    [request setRequestType:ASINetworkReqestTypeBindPhoneSecurity];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)bindPhoneNumWithSecurity:(NSString*)securityCode
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"userCenter" forKey:@"command"];
    [mDict setObject:securityCode forKey:@"securityCode"];
    [mDict setObject:@"bindPhone" forKey:@"type"];
    [mDict setObject:self.bindPhoneNum forKey:@"bindPhoneNum"];
	[mDict setObject:m_userno forKey:@"userno"];
    
    

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"绑定手机：%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeBindPhone];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)cancelBindEmail
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"userInfo" forKey:@"command"];
    [mDict setObject:@"removeBindEmail" forKey:@"requestType"];
	[mDict setObject:m_userno forKey:@"userno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    NSLog(@"解绑邮箱：%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeCancelBindEmail];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)cancelBindPhone
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
    request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"userCenter" forKey:@"command"];
    [mDict setObject:@"unbindPhone" forKey:@"type"];
    [mDict setObject:m_phonenum forKey:@"phonenum"];
	[mDict setObject:m_userno forKey:@"userno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"解绑手机：%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeCancelBindPhone];
    [request setDelegate:self];
    [request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)bindCertid
{
    NSLog(@" certid :%@",self.certid);
    if (self.certid == (NSString*)[NSNull null] || [self.certid isEqualToString:@""])
    {
//        [self setUpBindCertidView];
        self.netAppType = NET_APP_BIND_CERTID;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryDNAOK" object:nil];

    }
    else
    {
        if(self.certid.length == 15 || self.certid.length == 18 || self.certid.length == 10)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
            UserBindDetileVC *userBindDetleVC = [[UserBindDetileVC alloc] init];
            userBindDetleVC.navigationItem.title = @"身份证绑定信息";
            userBindDetleVC.nameStr = self.bindName;
            userBindDetleVC.ceridStr  =[self.certid stringByReplacingCharactersInRange:NSMakeRange(self.certid.length-4, 4) withString:@"****"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
            [m_fourthViewController.navigationController pushViewController:userBindDetleVC animated:YES];
        }
        else
        {
            [self showMessage:@"您绑定的身份证位数有误，请拨打客服进行修改！" withTitle:@"提示" buttonTitle:@"确定"];
        }
    }
}
- (void)bindNewEmail
{
    if(self.bindEmail.length == 0)
    {
        NSLog(@"self.bindEmail  -- = %@",self.bindEmail);
        [self setUpBindEmailView];
    }
    else
    {
        [self setUpCancelBindEmailView];
    }
}
- (void)bindPhone
{
    if(self.bindPhoneNum.length == 0)
    {
        NSLog(@"self.bindPhoneNum  -- = %@",self.bindPhoneNum);
        [self setUpBindPhoneView];
    }
    else
    {
//        [self setUpCancelBindPhoneView];
    }
}

- (void)setUpBindEmailView
{
    NSLog(@"取消邮箱绑定-----");
    if (m_bindEmailAlterView)
    {
        m_bindEmailField.text = nil;
        
        [m_bindEmailAlterView show];
        return;
    }
    m_bindEmailAlterView = [[UIAlertView alloc] initWithTitle:@"绑定邮箱"
                                                      message:@"请输入您要绑定的邮箱："
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确认", nil];
    m_bindEmailAlterView.alertViewStyle =UIAlertViewStylePlainTextInput;
    m_bindEmailField = [m_bindEmailAlterView textFieldAtIndex:0];
    m_bindEmailField.keyboardType = UIKeyboardTypeDefault;
    
    m_bindEmailAlterView.tag = kBindEmailAlertViewTag;
    [m_bindEmailAlterView show];
    
}

- (void)setUpBindPhoneView
{
    
    if (m_bindPhoneAlterView)
    {
        m_bindPhoneField.text = nil;
        
        [m_bindPhoneAlterView show];
        return;
    }
    m_bindPhoneAlterView = [[UIAlertView alloc] initWithTitle:@"绑定手机"
                                                      message:@"请输入您要绑定的手机号："
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确认", nil];
    m_bindPhoneAlterView.alertViewStyle =UIAlertViewStylePlainTextInput;
    m_bindPhoneField = [m_bindPhoneAlterView textFieldAtIndex:0];
    m_bindPhoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    m_bindPhoneAlterView.tag = kBindPhoneAlertViewTag;
    [m_bindPhoneAlterView show];
    
}

- (void)cancelPhoneClick:(id)sender
{
    [m_bindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)submitPhoneClick:(id)sender
{
    [m_bindPhoneField resignFirstResponder];
    if(m_bindPhoneField.text.length != 11)
    {
        [self showMessage:@"有效手机号码为11位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    [self getBindPhoneSecurityCode:m_bindPhoneField.text];
}

- (void)setUpBindPhoneSecurityView
{
 
    if (m_bindPhoneSecurityAlterView)
    {
        m_bindPhoneSecurityField.text = nil;
        
        [m_bindPhoneSecurityAlterView show];
        return;
    }
    m_bindPhoneSecurityAlterView = [[UIAlertView alloc] initWithTitle:@"验证码校验"
                                                              message:@"请输入验证码："
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确认",nil];
    
    m_bindPhoneSecurityAlterView.alertViewStyle =UIAlertViewStylePlainTextInput;
    m_bindPhoneSecurityField = [m_bindPhoneSecurityAlterView textFieldAtIndex:0];
    m_bindPhoneSecurityField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    m_bindPhoneSecurityAlterView.tag = kBindPhoneSecurityAlertViewTag;
    [m_bindPhoneSecurityAlterView show];
}

- (void)cancelSecurityPhoneClick:(id)sender
{
    [m_bindPhoneSecurityAlterView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)setUpCancelBindEmailView
{
    if(m_cancelBindEmailAlterView)
    {
        [m_cancelBindEmailAlterView release];
        m_cancelBindEmailAlterView = nil;
    }
    NSString *mess = [NSString stringWithFormat:@"您已绑定邮箱%@", self.bindEmail];
    
    
    m_cancelBindEmailAlterView = [[UIAlertView alloc] initWithTitle:@"邮箱绑定" message:mess delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"我要解绑", nil];
    
    m_cancelBindEmailAlterView.tag = kCancelBindEmailAlterViewTag;
    [m_cancelBindEmailAlterView show];
}
- (void)setUpCancelBindPhoneView
{
    if(m_cancelBindPhoneAlterView)
    {
        [m_cancelBindPhoneAlterView release];
        m_cancelBindPhoneAlterView = nil;
    }
    NSString *somePhoneNum = [self.bindPhoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    NSString *mess = [NSString stringWithFormat:@"您已绑定手机%@", somePhoneNum];
    
   
    m_cancelBindPhoneAlterView = [[UIAlertView alloc] initWithTitle:@"手机绑定" message:mess delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"我要解绑", nil];

    m_cancelBindPhoneAlterView.tag = kCancelBindPhoneAlterViewTag;
    [m_cancelBindPhoneAlterView show];
    
}
#pragma mark ---UIAlertViewDelete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kCancelBindPhoneAlterViewTag)
    {
        if (buttonIndex==0)
        {
            [m_cancelBindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [m_cancelBindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
            [self cancelBindPhone];
        }
    }else if (alertView.tag == kCancelBindEmailAlterViewTag)
    {
        if (buttonIndex==0)
        {
            [m_cancelBindEmailAlterView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [m_cancelBindEmailAlterView dismissWithClickedButtonIndex:0 animated:YES];
            [self cancelBindEmail];
        }
    }
    else if (alertView.tag == kCancelOKBindEmailAlterViewTag)
    {
        if (buttonIndex==0)
        {
            [m_cancelOKbindEmailAlterView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [m_cancelOKbindEmailAlterView dismissWithClickedButtonIndex:0 animated:YES];
            [self setUpBindEmailView];
        }
    }else if (alertView.tag == kCancelOKBindPhoneAlterViewTag)
    {
        if (buttonIndex==0)
        {
            [m_cancelOKbindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [m_cancelOKbindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
            [self setUpBindPhoneView];
        }
    }else if (alertView.tag == kBindEmailAlertViewTag)
    {
        
        if (buttonIndex==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            
            [m_bindEmailField resignFirstResponder];
            
            if(![self isValidateEmail:m_bindEmailField.text])
            {
                [self showMessage:@"请输入正确的邮箱格式" withTitle:@"提示" buttonTitle:@"确定"];
                return;
            }
            
            [self getBindEmailSecurityCode:m_bindEmailField.text];
        }
    }else if (alertView.tag == kBindPhoneAlertViewTag)
    {
        
        if (buttonIndex==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
          
            [m_bindPhoneField resignFirstResponder];
            if(m_bindPhoneField.text.length != 11)
            {
                [self showMessage:@"有效手机号码为11位！" withTitle:@"提示" buttonTitle:@"确定"];
                return;
            }
            
            [self getBindPhoneSecurityCode:m_bindPhoneField.text];
        }
    }else if (alertView.tag == kBindPhoneSecurityAlertViewTag)
    {
        if (buttonIndex==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [m_bindPhoneSecurityField resignFirstResponder];
            if(m_bindPhoneSecurityField.text.length == 0)
            {
                [self showMessage:@"请输入验证码！" withTitle:@"提示" buttonTitle:@"确定"];
            }
            else
            {
                [self bindPhoneNumWithSecurity:m_bindPhoneSecurityField.text];
            }

        }

    }else if (alertView.tag == kNickNameAlterViewTag)
    {
        if (buttonIndex==0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else if (buttonIndex==1)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [m_nickNameField resignFirstResponder];
            if (!KISEmptyOrEnter(m_nickNameField.text)) {
                
                for (int i = 0 ; i < [m_nickNameField.text length]; i++) {
                    UniChar chr = [m_nickNameField.text characterAtIndex:i];
                    if (chr == ' ')//是空格
                    {
                        [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称不能包含空格" withTitle:@"提示" buttonTitle:@"确定"];
                        return;
                    }
                }
                
                NSLog(@"%d",[[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_nickNameField.text]);
                if ([[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_nickNameField.text] < 4) {
                    [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称最少两个汉字或四个字符" withTitle:@"提示" buttonTitle:@"确定"];
                    return;
                }
                
                if ([[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_nickNameField.text] > 16) {
                    [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称最多八个汉字或十六个字符" withTitle:@"提示" buttonTitle:@"确定"];
                    return;
                }
                [self nickNameSet:m_nickNameField.text];
            }
            else
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入昵称" withTitle:@"提示" buttonTitle:@"确定"];
            }

            
        }
    }else if(kNomalAlertViewTag == alertView.tag && [[CommonRecordStatus commonRecordStatusManager].errerCode isEqualToString:@"0000"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"betCaseLotOKClick" object:nil];
        
        [CommonRecordStatus commonRecordStatusManager].errerCode = nil;
        
    }else if (kBindSucPhoneAlterViewTag == alertView.tag)
    {
            
            [self setUpBindPhoneSecurityView];
    }
}

- (void)setCancelOKbindEmailView
{
    if(m_cancelOKbindEmailAlterView)
    {
        [m_cancelOKbindEmailAlterView show];
        return;
    }
    m_cancelOKbindEmailAlterView = [[UIAlertView alloc] initWithTitle:@"邮箱解绑"
                                                              message:@"您已成功解除绑定邮箱！"
                                                             delegate:self
                                                    cancelButtonTitle:@"关闭"
                                                    otherButtonTitles:@"绑定其它",nil];
    
    m_cancelOKbindEmailAlterView.tag = kCancelOKBindEmailAlterViewTag;
    [m_cancelOKbindEmailAlterView show];
}
- (void)setCancelOKbindPhoneView
{
    if(m_cancelOKbindPhoneAlterView)
    {
        [m_cancelOKbindPhoneAlterView show];
        return;
    }
    m_cancelOKbindPhoneAlterView = [[UIAlertView alloc] initWithTitle:@"手机解绑" 
                                                              message:@"您已成功解除绑定手机！"
                                                             delegate:self 
                                                    cancelButtonTitle:@"关闭"
                                                    otherButtonTitles:@"绑定其它",nil];
  
    m_cancelOKbindPhoneAlterView.tag = kCancelOKBindPhoneAlterViewTag;
    [m_cancelOKbindPhoneAlterView show];
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark set nick name

- (void)setUpNickName
{
    if (m_setUpNicknameAlterView)
    {
        m_nickNameField.text = nil;
        
        [m_setUpNicknameAlterView show];
        return;
    }
    
   
    
    m_setUpNicknameAlterView = [[UIAlertView alloc] initWithTitle:@"昵称设置"
                                                          message:@"请输入您要设置的昵称："
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确认",nil];
    m_setUpNicknameAlterView.alertViewStyle =UIAlertViewStylePlainTextInput;
    m_nickNameField = [m_setUpNicknameAlterView textFieldAtIndex:0];
    
    
    m_setUpNicknameAlterView.tag = kNickNameAlterViewTag;
    [m_setUpNicknameAlterView show];
}

- (void)cancelNicknameClick:(id)sender
{
    [m_setUpNicknameAlterView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)submitNickNameClick:(id)sender
{
    //[m_setUpNicknameAlterView dismissWithClickedButtonIndex:0 animated:YES];
    [m_nickNameField resignFirstResponder];
    if (!KISEmptyOrEnter(m_nickNameField.text)) {
        
        for (int i = 0 ; i < [m_nickNameField.text length]; i++) {
            UniChar chr = [m_nickNameField.text characterAtIndex:i];
            if (chr == ' ')//是空格
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称不能包含空格" withTitle:@"提示" buttonTitle:@"确定"];
                return;
            }
        }

        NSLog(@"%d",[[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_nickNameField.text]);
        if ([[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_nickNameField.text] < 4) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称最少两个汉字或四个字符" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        
        if ([[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_nickNameField.text] > 16) {
                    [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称最多八个汉字或十六个字符" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
       [self nickNameSet:m_nickNameField.text];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入昵称" withTitle:@"提示" buttonTitle:@"确定"];
    }
    
}

#pragma mark Change User Password Operation
- (void)changeUserPsw:(NSString*)oldPsw withNewPsw:(NSString*)newPsw
{
    NSTrace();
    self.newPassword = newPsw;
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"updatePass" forKey:@"command"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
	[mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:@"0" forKey:@"type"];
    [mDict setObject:oldPsw forKey:@"old_pass"];
    [mDict setObject:newPsw forKey:@"new_pass"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    NSLog(@"cookieStr:%@\nsendData:%@", cookieStr, sendData);
    
	[request setRequestType:ASINetworkRequestTypeUpdatePsw];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
//- (void)sendFeedBack:(NSString*)content contactWay:(NSString*)contactway qNumTextField:(NSString*)qNumTextField
- (void)sendFeedBack:(NSString*)content contactWay:(NSString*)contactway
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"feedback" forKey:@"command"];
    [mDict setObject:content forKey:@"content"];
    [mDict setObject:contactway forKey:@"contactway"];
    [mDict setObject:self.userno forKey:@"userno"];
//    [mDict setObject:qNumTextField forKey:@""];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSLog(@"fankiu %@", cookieStr);
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
	[request setRequestType:ASINetworkRequestTypeFeedback];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

@end
