//
//  LaKaLaChargeViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LaKaLaChargeViewController.h"
 
#import "RuYiCaiNetworkManager.h"
#import "SBJsonBase.h"
#import "AdaptationUtils.h"

#ifndef KLAKALAShow
//#import "LKLPayment.h"
#endif

#import <CommonCrypto/CommonDigest.h>
@interface LaKaLaChargeViewController  (interval)
- (void)queryChargeWarnStrOK:(NSNotification*)notification;
@end

@implementation LaKaLaChargeViewController

@synthesize amountField = m_amountField;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryLaKaLaChargeOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryChargeWarnStrOK" object:nil];
    
    [m_amountField release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryLaKaLaChargeOK:) name:@"queryLaKaLaChargeOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryLaKaLaChargeWarnStrOK:) name:@"queryChargeWarnStrOK" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotification:) name:@"backNotification" object:nil];
    
    UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 20)];
    titleLabel.text = @"请输入你的充值金额(整数):";
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    m_amountField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 250, 35)];
    [m_amountField setTextColor:[UIColor redColor]];
    m_amountField.borderStyle = UITextBorderStyleBezel;
    m_amountField.text = @"100";
    m_amountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_amountField.keyboardType = UIKeyboardTypeNumberPad;
    m_amountField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_amountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:m_amountField];
    
    UILabel*  danLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 40, 30, 35)];
    danLabel.text = @"元";
    [danLabel setBackgroundColor:[UIColor clearColor]];
    [danLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [danLabel setTextColor:[UIColor redColor]];
    [self.view addSubview:danLabel];
    [danLabel release];
    
    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
                                        initWithTitle:@"确定"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(payButtonClick:)];
    self.navigationItem.rightBarButtonItem = okBarButtonItem;
    [okBarButtonItem release];
    
    [RuYiCaiNetworkManager sharedManager].netChargeQuestType = NET_QUERY_CHARGE_WARN;
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"lakalaChargeDescription"];
}

- (void)payButtonClick:(id)sender
{
    [self.amountField resignFirstResponder];
    if([m_amountField.text intValue] <= 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入正确的金额！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
//    else if([m_amountField.text intValue] > 500)
//    {
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"支付金额每日最高为500元！" withTitle:@"提示" buttonTitle:@"确定"];
//        return;
//    }
    for (int i = 0; i < self.amountField.text.length; i++)
    {
        UniChar chr = [self.amountField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额填写不规范" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"recharge" forKey:@"command"];
    [dict setObject:@"10" forKey:@"rechargetype"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [dict setObject:@"" forKey:@"subchannel"];
    NSString* amtValue = [NSString stringWithFormat:@"%d", [self.amountField.text intValue] * 100];
    [dict setObject:amtValue  forKey:@"amount"];
    [dict setObject:@"0910" forKey:@"cardtype"];
    [[RuYiCaiNetworkManager sharedManager] chargeByLaKaLa:dict];
}

- (void)queryLaKaLaChargeOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    if ([errorCode isEqualToString:@"0000"])
    {
        NSString* merIdString = KISDictionaryNullValue(parserDict, @"merId");
        NSString* orderIdString = KISDictionaryNullValue(parserDict, @"orderId");
        
        NSString* amountString = KISDictionaryNullValue(parserDict, @"amount");
        NSString* macString = KISDictionaryNullValue(parserDict, @"mac");
        
        NSString* minCodeString = KISDictionaryNullValue(parserDict, @"minCode");
        NSString* randNumString = KISDictionaryNullValue(parserDict, @"randNum");
        NSString* notifyUrlString = KISDictionaryNullValue(parserDict, @"notifyUrl");
        NSString *appScheme = [[CommonRecordStatus commonRecordStatusManager] getAppScheme:KAppScheme_Lakala];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
        
        
        [dict setValue:merIdString forKey:@"merId"];
        [dict setValue:orderIdString forKey:@"orderId"];
        [dict setValue:amountString forKey:@"amount"];
        [dict setValue:macString forKey:@"mac"];
        [dict setValue:minCodeString forKey:@"minCode"];
        [dict setValue:randNumString forKey:@"randNum"];
        [dict setValue:appScheme forKey:@"appScheme"];
        [dict setValue:notifyUrlString forKey:@"notifyUrl"];
        NSLog(@"%@",dict);
 
        NSString* amountYuan = @"";
        amountYuan = [NSString stringWithFormat:@"%0.2f" ,[amountString floatValue]/100];
 
#ifndef KLAKALAShow
//        [LKLPayment openLKLWithMerId:merIdString orderId:orderIdString amount:amountYuan mac:macString minCode:minCodeString redirectURL:appScheme random:randNumString];
#endif
 
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	if (alertView.tag == 10000) 
//    {
//        if(buttonIndex != [alertView cancelButtonIndex])
//        {
//            NSString * URLString = [NSString stringWithFormat:@"%@" ,@"http://itunes.apple.com/cn/app/la-ka-la/id523367437"];
//            
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
//        }
//	}
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_amountField resignFirstResponder];
}

- (void)queryLaKaLaChargeWarnStrOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].chargeWarnStr];
    NSString* contentStr = [parserDict objectForKey:@"content"];
    [jsonParser release];
    
    UITextView*    warnView = [[UITextView alloc] initWithFrame:CGRectMake(18, 80, 280, 330)];
    warnView.text = contentStr;
    [warnView setTextColor:[UIColor grayColor]];
    [warnView setFont:[UIFont systemFontOfSize:14.0f]];
    [warnView setBackgroundColor:[UIColor clearColor]];
    warnView.scrollEnabled = YES;
    warnView.editable = NO;
    [self.view addSubview:warnView];
    [warnView release];
}

//- (void)backNotification:(NSNotification*)notification
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

  
@end
