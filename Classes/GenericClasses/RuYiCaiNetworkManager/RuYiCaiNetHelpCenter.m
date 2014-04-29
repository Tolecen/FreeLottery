//
//  RuYiCaiNetHelpCenter.m
//  RuYiCai
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"

@implementation RuYiCaiNetworkManager (RuYiCaiNetHelpCenter)

- (void)helpCenterNetType:(NSString*)resText
{
    if(NET_QUERY_MESSAGE_SET == m_netHelpCenterCenter)
    {
        [self queryMessageSettingComplete:resText];
    }
    else if(NET_MESSAGE_SET == m_netHelpCenterCenter)
    {
        [self messageSettingComplete:resText];
    }
    else if(NET_HELP_QUERY_TITLE == m_netHelpCenterCenter)
    {
        [self queryHelpTitleComplete:resText];
    }
    else if(NET_HELP_QUERY_CONTENT == m_netHelpCenterCenter)
    {
        [self queryHelpContentComplete:resText];
    }
}
- (void)helpCenterNetType:(NSString*)resText withType:(NSInteger)type
{
    if(NET_QUERY_MESSAGE_SET == m_netHelpCenterCenter)
    {
        [self queryMessageSettingComplete:resText];
    }
    else if(NET_MESSAGE_SET == m_netHelpCenterCenter)
    {
        [self messageSettingComplete:resText];
    }
    else if(NET_HELP_QUERY_TITLE == m_netHelpCenterCenter)
    {
        [self queryHelpTitleComplete:resText withType:type];
    }
    else if(NET_HELP_QUERY_CONTENT == m_netHelpCenterCenter)
    {
        [self queryHelpContentComplete:resText];
    }
}

- (void)queryMessageSetting
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"queryMessageSetting" forKey:@"type"];
    [mDict setObject:self.userno forKey:@"userno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"服务设置查询:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeMorePage];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryMessageSettingComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryMessageSettingOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)messageSetting:(NSString*)info
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"message" forKey:@"command"];
    [mDict setObject:@"messageSetting" forKey:@"type"];
    [mDict setObject:info forKey:@"info"];
    //[mDict setObject:self.userno forKey:@"userno"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"服务设置:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeMorePage];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)messageSettingComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageSettingOK" object:nil];
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

//帮助中心查询
- (void)queryHelpTitleWithType:(NSString*)type
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:type forKey:@"type"];
    [mDict setObject:@"helpCenterTitle" forKey:@"newsType"];
    //[mDict setObject:@"10" forKey:@"maxresult"];
    //[mDict setObject:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageindex"];

    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"帮助中心标题查询:%@", cookieStr);
    
    if ([type isEqualToString: @"1"]) {
        [request setRequestType:ASINetworkReqestTypeMorePageOfGNZY];
    }else if ([type isEqualToString: @"3"]){
        [request setRequestType:ASINetworkReqestTypeMorePageOfCPWF];
    }else if ([type isEqualToString: @"4"]){
        [request setRequestType:ASINetworkReqestTypeMorePageOfCJWT];
    }else if ([type isEqualToString: @"5"]){
        [request setRequestType:ASINetworkReqestTypeMorePageOfCPSY];
    }
    
//    [request setRequestType:ASINetworkReqestTypeMorePage];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryHelpTitleComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHelpTitleOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)queryHelpTitleComplete:(NSString*)resText withType:(NSInteger)type
{
    NSLog(@"%d",type);
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        if (type == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHelpTitleWithGNZYOK" object:nil];
        }else if(type == 3){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHelpTitleWithCPWFOK" object:nil];
        }else if(type == 4){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHelpTitleWithCJWTOK" object:nil];
        }else if(type == 5){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHelpTitleWithCPSYOK" object:nil];
        }
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)queryHelpContentWithId:(NSString*)contentId
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", [RuYiCaiNetworkManager sharedManager].realServerURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"information" forKey:@"command"];
    [mDict setObject:@"helpCenterContent" forKey:@"newsType"];
    [mDict setObject:contentId forKey:@"id"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"帮助中心内容查询:%@", cookieStr);
    
    [request setRequestType:ASINetworkReqestTypeMorePage];
	[request setDelegate:self];
	[request startAsynchronous];
    [self showProgressViewWithTitle:@"联网提示" message:@"加载中..." net:request];
}

- (void)queryHelpContentComplete:(NSString*)resText
{
    self.responseText = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHelpContentOK" object:nil];
}

@end
