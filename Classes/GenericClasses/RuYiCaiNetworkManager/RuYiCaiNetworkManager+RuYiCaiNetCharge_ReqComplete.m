//
//  RuYiCaiNetworkManager+RuYiCaiNetCharge_ReqComplete.m
//  RuYiCai
//
//  Created by  on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"

@implementation RuYiCaiNetworkManager (RuYiCaiNetCharge_ReqComplete)

- (void)chargePageWithType:(NSString*)resText
{
    if(NET_QUERY_CHARGE_WARN == m_netChargeQuestType)
    {
        [self queryChargeWarnStrComplete:resText];
    }
    else if(NET_SAMPLE_QUERY == m_netChargeQuestType)
    {
        [self querySampleChargeNetRequestComplete:resText];
    }else if(NET_ACCOUNT_TAKE_CASH == m_netChargeQuestType){
        [self accountTakeCashRequestComplete:resText];
    }
}

- (void)querySampleChargeNetRequestComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"] || errorCode == nil)
	{
        [CommonRecordStatus commonRecordStatusManager].sampleNetStr = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryChargeSampleNetOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}


- (void)accountTakeCashRequestComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"] || errorCode == nil)
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bankTakeCashDescription" object:[parserDict objectForKey:@"content"]];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}



- (void)chargeBySecurityAlipayComplete:(NSString*)resText
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
        //[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"querySecurityAlipayOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)chargeByLaKaLaComplete:(NSString*)resText
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryLaKaLaChargeOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)queryChargeWarnStrComplete:(NSString*)resText
{
    NSTrace();
//    m_netAppType = NET_APP_BASE;
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
//    [jsonParser release];

    [CommonRecordStatus commonRecordStatusManager].chargeWarnStr = resText;
        //[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryChargeWarnStrOK" object:nil];

}

@end
