//
//  RuYiCaiNetworkManager+RuYiCaiNetCharge_Request.m
//  RuYiCai
//
//  Created by  on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"

@implementation RuYiCaiNetworkManager (RuYiCaiNetCharge_Request)

- (void)querySampleChargeNetRequest:(NSDictionary*)dict isShowProgress:(BOOL)showPro
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", kRuYiCaiServer];
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
    
    NSLog(@"充值简单联网查询:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeChargePage];
	[request setDelegate:self];
	[request startAsynchronous];
    
    if(showPro)
    {
        [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
    }

}

- (void)chargeBySecurityAlipay:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", kRuYiCaiServer];
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
    
	[request setRequestType:ASINetworkReqestTypeChargeSecurityAlipay];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];

}

- (void)chargeByLaKaLa:(NSMutableDictionary*)otherDict
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", kRuYiCaiServer];
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
    
	[request setRequestType:ASINetworkReqestTypeChargeLaKaLa];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
    
}



- (void)queryChargeWarnStr:(NSString*)keyStr
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", kRuYiCaiServer];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"messageContent" forKey:@"newsType"];
    [mDict setObject:keyStr forKey:@"keyStr"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"充值提示语:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeChargePage];
	[request setDelegate:self];
	[request startAsynchronous];

}

@end
