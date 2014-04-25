//
//  RuYiCaiNetwork_Category_UserCenter_ReqComplete.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"

@implementation RuYiCaiNetworkManager(RuYiCaiNetwork_Category_UserCenter_ReqComplete)

#pragma mark User Center Event 用户中心
- (void)queryLotWinComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"] || [errorCode isEqualToString:@"0047"])//无记录
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryBetWinOK" object:errorCode];
    }
    else
    {
        [self showMessage:message withTitle:@"中奖查询" buttonTitle:@"确定"];
    }
}

- (void)queryLotBetComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"] || [errorCode isEqualToString:@"0047"])//无记录
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryLotBetOK" object:errorCode];
    }
    else
    {
        [self showMessage:message withTitle:@"投注查询" buttonTitle:@"确定"];
    }
}
- (void)getBetDetailComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getBetDetailOK" object:nil userInfo:KISDictionaryHaveKey(parserDict, @"result")];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
    
}

- (void)queryTrackComplete:(NSString*)resText
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryLotTrackOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"追号查询" buttonTitle:@"确定"];
    }
}

- (void)cancelTrackComplete:(NSString*)resText
{
	NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        isRefreshUserCenter = YES;
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTrackOK" object:nil];
	}
	else
	{
        //isRefreshUserCenter = NO;//一次成功一次失败时会出问题
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
    
}

- (void)queryBalanceComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        self.userBalance = [parserDict objectForKey:@"bet_balance"];
        self.userLotPea = [parserDict objectForKey:@"lotPea"];
        self.userPrizeBalance = [parserDict objectForKey:@"drawbalance"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryUserBalanceOK" object:nil];
    }
    else
    {
        //self.userBalance = nil;
    }
    
    [self.firstViewController updateLoginStatus];
    //    [self.thirdViewController updateLoginStatus];
    
    //    if (NET_APP_SUBMIT_LOT == m_netAppType)
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"submitLotNotification" object:nil];
    //    else
    if (NET_APP_QUERY_DNA == m_netAppType)
        [self queryDNA];
    else
        m_netAppType = NET_APP_BASE;
}

- (void)queryADInformationComplete:(NSString*)resText
{
    NSLog(@"queryADInformationComplete");
    NSTrace();
    m_netAppType = NET_APP_BASE;
    
    NSLog(@"queryADInformationComplete:%@",resText);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryADInformationOK" object:resText];
   
}



- (void)queryGiftComplete:(NSString*)resText
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryGiftOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"赠送查询" buttonTitle:@"确定"];
    }
}

- (void)queryAccountDetailComplete:(NSString*)resText
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryAccountDetailOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"账户查询" buttonTitle:@"确定"];
    }
}

- (void)queryCashComplete:(NSString *)resText
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryCashOK" object:nil];
    }
    else if ([errorCode isEqualToString:@"0047"])  //无提现记录
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryCashOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)queryRecordCashComplete:(NSString*)resText
{
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        NSLog(@"-------------提现文本内容%@",resText);
        self.queryRecordCashStr = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryGetCashRecordOK" object:nil];
    }
    else
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];

}

- (void)getCashComplete:(NSString*)resText
{
    NSTrace();
    NSLog(@"getCashComplete_restext:%@",resText);
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.isRefreshUserCenter = YES;
        
        [CommonRecordStatus commonRecordStatusManager].isGetCashOK = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCashOK" object:nil];
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
    else
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
}

- (void)cancelCashComplete:(NSString*)resText
{   
	//撤销提现
	NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.isRefreshUserCenter = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelGetCashOK" object:nil];
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)bindCertidComplete:(NSString*)resText
{
    NSTrace();
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
//        [m_bindCertidAlterView dismissWithClickedButtonIndex:0 animated:YES];
//        self.certid = m_bindCertidField.text;
//        self.
//
        [self UpdateUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BindCertIdOK" object:nil];

		[self showMessage:@"绑定身份证成功" withTitle:@"提示" buttonTitle:@"确定"];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)bindEmailSecurityComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        [m_bindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
        
        [self showMessage:@"绑定成功" withTitle:@"提示" buttonTitle:@"确定"];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)bindPhoneSecurityComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        [m_bindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
        self.bindPhoneNum = self.bindNewPhoneNum;
        
        
       UIAlertView *bindPhoneSucAlterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功获取验证码，请注意查收短信！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        
        
        bindPhoneSucAlterView.tag = kBindSucPhoneAlterViewTag;
        [bindPhoneSucAlterView show];
        [bindPhoneSucAlterView release];
        
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)bindPhoneComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.bindPhoneNum = m_bindPhoneField.text;
        
        [m_bindPhoneSecurityAlterView dismissWithClickedButtonIndex:0 animated:YES];
        [m_bindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
        
        
        NSString *somePhoneNum = [self.bindPhoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        NSString *mess = [NSString stringWithFormat:@"您已绑定手机%@", somePhoneNum];
        UIAlertView *bindPhoneSucAlertView = [[UIAlertView alloc] initWithTitle:@"手机绑定" message:mess delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [bindPhoneSucAlertView show];
        [bindPhoneSucAlertView release];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRBindPhoneOk" object:nil userInfo:parserDict];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}


- (void)cancelBindEmailComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        [m_cancelBindEmailAlterView dismissWithClickedButtonIndex:0 animated:YES];
        self.bindEmail = @"";
        [self setCancelOKbindEmailView];
//        [self UpdateUserInfo];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag == kBindSucPhoneAlterViewTag) {
        
        

            [self setUpBindPhoneSecurityView];
    }
}

- (void)cancelBindPhoneComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        [m_cancelBindPhoneAlterView dismissWithClickedButtonIndex:0 animated:YES];
        self.bindPhoneNum = @"";
        [self setCancelOKbindPhoneView];	
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRCancelBindPhoneOk" object:nil userInfo:parserDict];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)setNicknameComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        [m_setUpNicknameAlterView dismissWithClickedButtonIndex:0 animated:YES];
        [self UpdateUserInfo];
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        [m_settingNickNameVC.navigationController popViewControllerAnimated:self];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
}

- (void)queryLeaveMessageComplete:(NSString *)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])//|| [errorCode isEqualToString:@"0047"])//无记录
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveMessageOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
	}
}

//- (void)receiveLotterySecurityComplete:(NSString*)resText
//{
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
//    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
//    [jsonParser release];
//    
//    if ([errorCode isEqualToString:@"0000"])
//	{
//        [self showReceiveLotteryAlterView];
//        [self showMessage:@"验证码已发出，请注意查收短信！" withTitle:@"提示" buttonTitle:@"确定"];
//	}
//	else
//	{
//		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
//	}
//}

//- (void)receiveLotteryComplete:(NSString*)resText
//{
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
//    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
//    [jsonParser release];
//    
//    if ([errorCode isEqualToString:@"0000"])
//	{
//        [m_receiveLotteryAlterView dismissWithClickedButtonIndex:0 animated:YES];
//        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveLotteryOK" object:nil];
//	}
//	else
//	{
//		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
//	}
//}

- (void)getIntegralInfoComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IntegralInfoOK" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
	}
}
- (void)integralTransMoneyNeedsScoresComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"transMoneyNeedsScoresOk" object:nil];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"netFailed" object:nil];
	}
}
- (void)transIntegralComplete:(NSString*)resText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
	{
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        [self UpdateUserInfo];
	}
	else
	{
		[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
	}
    
}

- (void)updatePassComplete:(NSString*)resText
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
        self.password = self.newPassword;
        NSLog(@"self.self.newPassword = =%@",self.newPassword);
        NSLog(@"self.passwordself.password = =%@",self.password);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangePassOK" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        [self showMessage:message withTitle:@"修改成功" buttonTitle:@"确定"];
        
//        [self loginWithPhonenum:self.phonenum withPassword:self.password];
    }
    else
    {
        [self showMessage:message withTitle:@"修改失败" buttonTitle:@"确定"];
    }
}

#pragma mark rechargeComplete 账户充值响应
- (void)queryDNAComplete:(NSString*)resText
{
    NSTrace();
    /*SBJsonParser *jsonParser = [SBJsonParser new];
     NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
     NSString* errorCode = [parserDict objectForKey:@"error_code"];
     NSString* message = [parserDict objectForKey:@"message"];
     [jsonParser release];*/

    self.netAppType = NET_APP_GET_CASH;
    self.responseText = resText;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryDNAOK" object:nil];
}

- (void)chargeDNAComplete:(NSString*)resText
{
    NSTrace();//充值
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        self.isRefreshUserCenter = YES;
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)chargeByPhoneCardComplete:(NSString *)resText
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
        self.isRefreshUserCenter = YES;
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        if([CommonRecordStatus commonRecordStatusManager].changeWay == 0)
        {
            [[Custom_tabbar showTabBar] when_tabbar_is_selected:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backNotification" object:nil];
        }
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)chargeByAlipayComplete:(NSString *)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    //NSString* returnUrl = [parserDict objectForKey:@"return_url"];
 
    self.responseText = [parserDict objectForKey:@"return_url"];
    
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        //self.responseText = resText;
        self.isRefreshUserCenter = YES;
        //[self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:returnUrl]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"queryAlipayOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)chargeByUmpayCreDitComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
//    NSString* orderId = [parserDict objectForKey:@"orderId"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeByUmpayCreDitOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)chargeByWealthTenpayComplete:(NSString*)resText
{
    NSTrace();
    m_netAppType = NET_APP_BASE;
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:resText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    //    NSString* orderId = [parserDict objectForKey:@"orderId"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        self.responseText = resText;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeByWealthTenpayOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)chargeByUnionBankCardComplete:(NSString*)resText
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chargeByUnionBankOK" object:nil];
    }
    else
    {
        [self showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}


@end
