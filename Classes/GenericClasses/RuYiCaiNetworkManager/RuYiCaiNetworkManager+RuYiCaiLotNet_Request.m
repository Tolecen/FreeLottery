//
//  RuYiCaiNetworkManager+RuYiCaiLotNet_Request.m
//  RuYiCai
//
//  Created by  on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"

@implementation RuYiCaiNetworkManager (RuYiCaiLotNet_Request)

- (void)getLotMissdateWithLotno:(NSString*)lotno sellWay:(NSString*)sellWay//遗落值
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"missValue" forKey:@"type"];
    [mDict setObject:lotno forKey:@"lotno"];
    [mDict setObject:sellWay forKey:@"sellway"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"遗落值:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
    //[self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


- (NSString *)configurationMissdateDictWithLotno:(NSString*)lotno sellWay:(NSString*)sellWay//遗落值
{
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"missValue" forKey:@"type"];
    [mDict setObject:lotno forKey:@"lotno"];
    [mDict setObject:sellWay forKey:@"sellway"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    return cookieStr ;
}


- (void)getLotMissdateWithString:(NSString*)configurationString//遗落值
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSData* cookieData = [configurationString dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    NSLog(@"遗落值:%@", configurationString);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
    //[self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}


- (void)getShouYiLvBatchList:(NSString*)lotno//收益率期号
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"afterIssue" forKey:@"type"];
    [mDict setObject:@"10" forKey:@"batchnum"];
    [mDict setObject:lotno forKey:@"lotno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"收益率期号:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)computeShouYiLvWithLotno:(NSString*)lotno batchcode:(NSString*)batchcode batchnum:(NSString*)batchnum lotmulti:(NSString*)lotmulti wholeYield:(NSString*)wholeYield beforeBatchNum:(NSString*)beforeBatchNum beforeYield:(NSString*)beforeYield afterYield:(NSString*)afterYield
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"betLot" forKey:@"command"];
    [mDict setObject:lotno forKey:@"lotno"];
    if(batchcode)
      [mDict setObject:batchcode forKey:@"batchcode"];
    [mDict setObject:batchnum forKey:@"batchnum"];
    [mDict setObject:lotmulti forKey:@"lotmulti"];
    [mDict setObject:wholeYield forKey:@"wholeYield"];
    [mDict setObject:beforeBatchNum forKey:@"beforeBatchNum"];
    [mDict setObject:beforeYield forKey:@"beforeYield"];
    [mDict setObject:afterYield forKey:@"afterYield"];
    [mDict setObject:@"yield" forKey:@"bettype"];

    [mDict setObject:[RuYiCaiLotDetail sharedObject].zhuShuNum forKey:@"betNum"];
    [mDict setObject:[RuYiCaiLotDetail sharedObject].betCode forKey:@"bet_code"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"收益率计算:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
    
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];

}

- (void)queryHistoryTrackDetail:(NSString*)trackId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"AllQuery" forKey:@"command"];
    [mDict setObject:@"trackDetail" forKey:@"type"];
    [mDict setObject:trackId forKey:@"tsubscribeNo"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"追期历史详情:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)querySampleLotNetRequest:(NSDictionary*)dict isShowProgress:(BOOL)showPro
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:dict];
    NSLog(@"%@",mDict);
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"简单联网查询:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
    
    if(showPro)
    {
        [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
    }
}

- (void)quXiaoNetRequest:(NSDictionary*)dict//合买撤单、撤资
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict addEntriesFromDictionary:dict];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"取消操作:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeGetLotDate];
	[request setDelegate:self];
	[request startAsynchronous];
    
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}
- (void)lotteryZCInquiry{
    
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"zcIssue" forKey:@"type"];
    [mDict setObject:kLotNoSFC forKey:@"lotno"];
    //    [mDict setObject:@"zuCai" forKey:@"command"];
    //    [mDict setObject:@"duiZhen" forKey:@"requestType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    NSLog(@"足彩预售期:%@", cookieStr);
    
    [request setRequestType:ASINetworkRequestTypeZC];
	[request setDelegate:self];
	[request startAsynchronous];
    
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryZCIssueBatchCode:(NSString*)lotNo
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"QueryLot" forKey:@"command"];
    [mDict setObject:@"zcIssue" forKey:@"type"];
    [mDict setObject:lotNo forKey:@"lotno"];
//    [mDict setObject:@"zuCai" forKey:@"command"];
//    [mDict setObject:@"duiZhen" forKey:@"requestType"];
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];
    [request buildPostBody];
    
    NSLog(@"足彩预售期:%@", cookieStr);
    
    [request setRequestType:ASINetworkRequestTypeZCIssue];
	[request setDelegate:self];
	[request startAsynchronous];
    
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

@end
