//
//  bankChargeViewController.m
//  RuYiCai
//
//  Created by  on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "bankChargeViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "SBJsonParser.h"
//#import "AlixPay.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

#define BankNameButton (122)
#define BankTypeButton (123)

@interface bankChargeViewController (internal)

- (void)okClick;
- (void)queryChargeWarnStrOK:(NSNotification*)notifition;
- (void)querySampleNetOK:(NSNotification*)notifition;

- (void)zfbCharge:(NSString*)amount;
- (void)querySecurityAlipayOK:(NSNotification*)notification;

- (void)lthjCharge:(NSString*)amount;
- (void)chargeByUnionBankOK:(NSNotification*)notification;
- (void)backNotification:(NSNotification*)notification;

@end

@implementation bankChargeViewController

@synthesize amountField;
@synthesize bankButton;
@synthesize bankTypeButton;
@synthesize allBankNameArr;
@synthesize allBankTypeArr;

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryChargeWarnStrOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySecurityAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chargeByUnionBankOK" object:nil];

    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    m_delegate.randomPickerView.delegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backNotification" object:nil];

    [amountField release];
    [bankButton release];
    [bankTypeButton release];
    
    [allBankNameArr release];
    for(int i = 0; i < [allBankTypeArr count]; i++)
    {
        [[allBankTypeArr objectAtIndex:i] release];
    }
    allBankTypeArr = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO; 

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryChargeWarnStrOK:) name:@"queryChargeWarnStrOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySecurityAlipayOK:) name:@"querySecurityAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeByUnionBankOK:) name:@"chargeByUnionBankOK" object:nil];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotification:) name:@"backNotification" object:nil];    
        
    bankNo = 0;
    allBankNameArr = [[NSMutableArray alloc] initWithCapacity:1];
    allBankTypeArr = [[NSMutableArray alloc] initWithCapacity:1];
    recodeButton = 0;
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    
    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
                                        initWithTitle:@"确定"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(okClick)];
    self.navigationItem.rightBarButtonItem = okBarButtonItem;
    [okBarButtonItem release];    
        
    
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:@"recharge" forKey:@"command"];
    [tempDic setObject:@"08" forKey:@"rechargetype"];
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;//银行充值中银行查询
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];    
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
    
    [RuYiCaiNetworkManager sharedManager].netChargeQuestType = NET_QUERY_CHARGE_WARN;//介绍查询
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"bankChargeDescription"];
}

- (void)querySampleNetOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    
    NSArray*  result = (NSArray*)[parserDict objectForKey:@"result"];
    for(int i = 0; i < [result count]; i++)
    {
        [self.allBankNameArr addObject:[[result objectAtIndex:i] objectForKey:@"bankname"]];
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        for(int j = 0; j < [[[result objectAtIndex:i] allKeys] count]; j++)
        {
            if([[[[result objectAtIndex:i] allKeys] objectAtIndex:j] isEqualToString:@"creditCard"])//支持信用卡
            {
                [tempDic setObject:[[result objectAtIndex:i] objectForKey:@"creditCard"] forKey:@"creditCard"];
            }
            else if([[[[result objectAtIndex:i] allKeys] objectAtIndex:j] isEqualToString:@"debitCard"])//借记卡
            {
                [tempDic setObject:[[result objectAtIndex:i] objectForKey:@"debitCard"] forKey:@"debitCard"];
            }
        }
        if([[tempDic allKeys] count] > 0)
            [self.allBankTypeArr addObject:tempDic];
    }
   // NSLog(@"allBankTypeArr %@", self.allBankTypeArr);
}

- (IBAction)bankButtonClick:(id)sender
{
    m_delegate.randomPickerView.delegate = self;

    recodeButton = BankNameButton;
    
    [self.amountField resignFirstResponder];
    
    if(0 == [self.allBankNameArr count])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"未获取到可选择的银行！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
    [m_delegate.randomPickerView setPickerDataArray:self.allBankNameArr];
    [m_delegate.randomPickerView setPickerNum:bankNo withMinNum:0 andMaxNum:[self.allBankNameArr count]];
}

- (IBAction)bankTypeButtonClick:(id)sender
{
    m_delegate.randomPickerView.delegate = self;

    recodeButton = BankTypeButton;
    
    [self.amountField resignFirstResponder];
    if(0 == [self.allBankTypeArr count])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"未获取到可选择的银行卡类型！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
    NSMutableArray *bankType = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < [[[self.allBankTypeArr objectAtIndex:bankNo] allKeys] count]; i++) 
    {
        if([[[[self.allBankTypeArr objectAtIndex:bankNo] allKeys] objectAtIndex:i] isEqualToString:@"debitCard"])
        {
            [bankType addObject:@"借记卡"];
        }
        else if([[[[self.allBankTypeArr objectAtIndex:bankNo] allKeys] objectAtIndex:i] isEqualToString:@"creditCard"])
        {
            [bankType addObject:@"信用卡"];
        }
    }
    [m_delegate.randomPickerView setPickerDataArray:bankType];
    [m_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:[self.allBankTypeArr count]];
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    if(BankNameButton == recodeButton)
    {
        [self.bankButton setTitle:[self.allBankNameArr objectAtIndex:num] forState:UIControlStateNormal];
        bankNo = num;
        
        [self.bankTypeButton setTitle:@"" forState:UIControlStateNormal];
    }
    else if(BankTypeButton == recodeButton)
    {
        [self.bankTypeButton setTitle:[m_delegate.randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
    }
}

- (void)okClick
{
    [self.amountField resignFirstResponder];
    
    if (0 == self.amountField.text.length ||
        0 == self.bankButton.currentTitle.length||
        0 == self.bankTypeButton.currentTitle.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    else if([self.amountField.text intValue] < 20)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额最低20元！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
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

    if([[self.bankTypeButton currentTitle] isEqualToString:@"借记卡"])  
    {
        NSString*  chargeType = [[self.allBankTypeArr objectAtIndex:bankNo] objectForKey:@"debitCard"];
        if([chargeType isEqualToString:@"zfb"])//支付宝
        {
            [self zfbCharge:self.amountField.text];
        }
        else if([chargeType isEqualToString:@"lthj"])//银联
        {
            [self lthjCharge:self.amountField.text];
        }
    }
    else if([[self.bankTypeButton currentTitle] isEqualToString:@"信用卡"])
    {
        NSString*  chargeType = [[self.allBankTypeArr objectAtIndex:bankNo] objectForKey:@"creditCard"];
        if([chargeType isEqualToString:@"zfb"])//支付宝
        {
            [self zfbCharge:self.amountField.text];
        }
        else if([chargeType isEqualToString:@"lthj"])//银联
        {
            [self lthjCharge:self.amountField.text];
        }
    }
}

#pragma mark 跳转充值界面
- (void)zfbCharge:(NSString*)amount
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"recharge" forKey:@"command"];
    [dict setObject:@"07" forKey:@"rechargetype"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [dict setObject:@"" forKey:@"subchannel"];
    NSString* amtValue = [NSString stringWithFormat:@"%d", [self.amountField.text intValue] * 100];
    [dict setObject:amtValue  forKey:@"amount"];
    [dict setObject:@"0300" forKey:@"cardtype"];
    [[RuYiCaiNetworkManager sharedManager] chargeBySecurityAlipay:dict];
}

- (void)querySecurityAlipayOK:(NSNotification*)notification
{
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
//    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
//    [jsonParser release];
//    if ([errorCode isEqualToString:@"0000"])
//    {
//        NSString* orderString = [parserDict objectForKey:@"value"];
//    
//        NSString *appScheme = [[CommonRecordStatus commonRecordStatusManager] getAppScheme:KAppScheme_Alipay];
//        NSLog(@"%@",appScheme);
//        AlixPay * alixpay = [AlixPay shared];
//        int ret = [alixpay pay:orderString applicationScheme:appScheme];//跳转到安全支付页面
//        
//        if (ret == kSPErrorAlipayClientNotInstalled) {
//            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" 
//                                                                 message:@"您还没有安装支付宝的客户端，请前往安装！" 
//                                                                delegate:self 
//                                                       cancelButtonTitle:@"取消" 
//                                                       otherButtonTitles:nil];
//            [alertView addButtonWithTitle:@"确定"];
//            [alertView setTag:123];
//            [alertView show];
//            [alertView release];
//        }
//        else if (ret == kSPErrorSignError) {
//            NSLog(@"签名错误！");
//        }
//    }
//    else
//    {
//        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) 
    {
        if(buttonIndex != [alertView cancelButtonIndex])
        {
            NSString * URLString = @"http://itunes.apple.com/cn/app/id333206289?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
        }
	}
}

- (void)lthjCharge:(NSString*)amount
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"recharge" forKey:@"command"];
    [dict setObject:@"06" forKey:@"rechargetype"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [dict setObject:@"00092493" forKey:@"subchannel"];
    NSString* amtValue = [NSString stringWithFormat:@"%d", [self.amountField.text intValue] * 100];
    [dict setObject:amtValue  forKey:@"amount"];
    [dict setObject:@"0900" forKey:@"cardtype"];
    [[RuYiCaiNetworkManager sharedManager] chargeByUnionBankCard:dict];
}

- (void)chargeByUnionBankOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];
    if (![errorCode isEqualToString:@"0000"])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    UIViewController *viewCtrl = nil;
	[self setHidesBottomBarWhenPushed:YES];
//	viewCtrl = [LTInterface getHomeViewControllerWithType:1 strOrder:[parserDict objectForKey:@"value"] andDelegate:self];
//    viewCtrl = [LTInterface getHomeViewControllerWithType:[parserDict objectForKey:@"value"]
//                                              andDelegate:self];

	[self.navigationController pushViewController:viewCtrl animated:YES];
	//[viewCtrl release];
}

- (void) returnWithResult:(NSString *)strResult 
{
	self.navigationController.navigationBarHidden = NO; 
}

#pragma mark 介绍
- (void)queryChargeWarnStrOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].chargeWarnStr];
    NSString* contentStr = [parserDict objectForKey:@"content"];
    [jsonParser release];
    
    UITextView*    warnView = [[UITextView alloc] initWithFrame:CGRectMake(13, 170, 298, [UIScreen mainScreen].bounds.size.height - 240)];
    warnView.text = contentStr;
    [warnView setTextColor:[UIColor grayColor]];
    [warnView setFont:[UIFont systemFontOfSize:14.0f]];
    [warnView setBackgroundColor:[UIColor clearColor]];
    warnView.scrollEnabled = YES;
    warnView.editable = NO;
    [self.view addSubview:warnView];
    [warnView release];
}

- (void)backNotification:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.amountField resignFirstResponder];
}
@end
