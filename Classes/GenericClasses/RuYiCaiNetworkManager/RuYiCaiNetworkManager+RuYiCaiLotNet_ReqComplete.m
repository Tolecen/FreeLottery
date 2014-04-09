//
//  RuYiCaiNetworkManager+RuYiCaiLotNet_ReqComplete.m
//  RuYiCai
//
//  Created by  on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"
#import "CommonRecordStatus.h"

@implementation RuYiCaiNetworkManager (RuYiCaiLotNet_ReqComplete)

- (void)getLotDateOk:(NSString*)resText//分享增加积分不解析返回数据
{
    NSTrace();
    switch (self.netLotType)
    {
        case NET_LOTTERY_INFOR:
        case NET_LOT_BASE:
        case NET_DONT_SHOWALTER:
            [self querySampleLotNetRequestComplete:resText];
            break;
        case NET_LOT_MISSDATE:
            [self getLotMissdateComplete:resText];
            break;
        case NET_LOT_SHOUYILV_BATCH:
            [self getShouYiLvBatchListComplete:resText];
            break;
        case NET_LOT_SHOUYILV_COMPUTE:
            [self computeShouYiLvComplete:resText];
            break;
        case NET_LOT_HISTORY_TRACK:
            [self queryHistoryTrackDetailComplete:resText];
            break;
        case NET_QUXIAO:
            [self quXiaoNetRequestComplete:resText];
            break;
        case NET_DONT_RESULT:
            break;
        default:
            break;
    }
}

- (void)quXiaoNetRequestComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];

    if ([errorCode isEqualToString:@"0000"])
	{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"quXiaoOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)querySampleLotNetRequestComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"] || errorCode == nil)
	{
        if(NET_LOTTERY_INFOR == self.netLotType)
        {
            [CommonRecordStatus commonRecordStatusManager].lotteryInfor = resText;
        }
        else
            [CommonRecordStatus commonRecordStatusManager].sampleNetStr = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"querySampleNetOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)getLotMissdateComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        [CommonRecordStatus commonRecordStatusManager].netMissDate = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getMissDateOK" object:nil];
	}
	else
	{
//		[self showMessage:message withTitle:@"遗漏值提示" buttonTitle:@"确定"];
	}
}

- (void)getShouYiLvBatchListComplete:(NSString*)resText
{
    self.responseText = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getBatchCodeDateOK" object:nil];
}

- (void)computeShouYiLvComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"computeShouYiLvOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)queryHistoryTrackDetailComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHistoryTrackOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)queryZCIssueBatchCodeComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        NSDictionary* tempDic = [NSDictionary dictionaryWithObject:[parserDict objectForKey:@"result"] forKey:@"batchCodeArray"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryZCIssueBatchCodeOK" object:nil userInfo:tempDic];
	}
	else
	{
        
        
        [self showMessage:[NSString stringWithFormat:@"足彩:%@", message] withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryZCIssueBatchCodeOK" object:nil userInfo:nil];
	}
}
- (void)updateZCInformationBatchCodeComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        NSDictionary* tempDic = [NSDictionary dictionaryWithObject:[parserDict objectForKey:@"result"] forKey:@"batchCodeArray"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateZCInformation" object:nil userInfo:tempDic];
	}
	else
	{
        
        
        [self showMessage:[NSString stringWithFormat:@"足彩:%@", message] withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateZCInformation" object:nil userInfo:nil];
	}
}

@end
