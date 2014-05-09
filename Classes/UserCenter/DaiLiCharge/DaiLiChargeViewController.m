//
//  DaiLiChargeViewController.m
//  RuYiCai
//
//  Created by  on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DaiLiChargeViewController.h"
#import "Custom_tabbar.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"

@implementation DaiLiChargeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryUserBalanceOK" object:nil];

    [m_accountField release];
    [m_amountField release];
    [m_passwordField release];
    [m_tiXianAmountLabel release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUserBalanceOK:) name:@"queryUserBalanceOK" object:nil];

    UILabel*  accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 31)];
    accountLabel.text = @"对方账户：";
    accountLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:accountLabel];
    [accountLabel release];
    
    m_accountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 15, 200, 31)];
    [m_accountField setTextColor:[UIColor blackColor]];
    m_accountField.borderStyle = UITextBorderStyleRoundedRect;
    m_accountField.delegate = self;
    m_accountField.placeholder = @"对方的全民免费彩账户名";
    m_accountField.font = [UIFont systemFontOfSize:15];
    m_accountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    m_accountField.keyboardType = UIKeyboardTypeNamePhonePad;
    m_accountField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_accountField.returnKeyType = UIReturnKeyDone;
    [m_accountField becomeFirstResponder];
    [self.view addSubview:m_accountField];
    
    UILabel*  canAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 80, 20)];
    canAmountLabel.text = @"可用金额：";
    canAmountLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:canAmountLabel];
    [canAmountLabel release];
    
    m_tiXianAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 60, 120, 20)];
    m_tiXianAmountLabel.font = [UIFont systemFontOfSize:13.0f];
    m_tiXianAmountLabel.backgroundColor = [UIColor clearColor];
    m_tiXianAmountLabel.textColor = [UIColor redColor];
    [self.view addSubview:m_tiXianAmountLabel];
    
    UILabel*  amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 100, 31)];
    amountLabel.text = @"转账金额：";
    amountLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:amountLabel];
    [amountLabel release];
    
    m_amountField = [[UITextField alloc] initWithFrame:CGRectMake(100, 80, 185, 31)];
    [m_amountField setTextColor:[UIColor redColor]];
    m_amountField.borderStyle = UITextBorderStyleRoundedRect;
    //m_amountField.delegate = self;
    m_amountField.text = @"100";
    m_amountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_amountField.keyboardType = UIKeyboardTypeNumberPad;
    m_amountField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_amountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:m_amountField];

    UILabel*  unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(290, 80, 15, 31)];
    unitLabel.text = @"元";
    unitLabel.textColor = [UIColor redColor];
    unitLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:unitLabel];
    [unitLabel release];
    
    UILabel*  passLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 100, 31)];
    passLabel.text = @"登录密码：";
    passLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:passLabel];
    [passLabel release];
    
    m_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(100, 125, 200, 31)];
    [m_passwordField setTextColor:[UIColor blackColor]];
    m_passwordField.borderStyle = UITextBorderStyleRoundedRect;
    m_passwordField.delegate = self;
    m_passwordField.placeholder = @"您的全民免费彩账户登录密码";
    m_passwordField.font = [UIFont systemFontOfSize:15];
    m_passwordField.secureTextEntry = YES;
    m_passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_passwordField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_passwordField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:m_passwordField];

    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
                                        initWithTitle:@"确定"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(okClick)];
    self.navigationItem.rightBarButtonItem = okBarButtonItem;
    [okBarButtonItem release];
    
    [[RuYiCaiNetworkManager sharedManager] queryUserBalance];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}

- (BOOL)valueCheck
{
    if(0 == m_accountField.text.length || 0 == m_amountField.text.length || 0 == m_passwordField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整！" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    for (int i = 0; i < m_amountField.text.length; i++)
    {
        UniChar chr = [m_amountField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额填写不规范！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额须为整数！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    NSString*  canBalanceStr = [m_tiXianAmountLabel.text substringWithRange:NSMakeRange(0, m_tiXianAmountLabel.text.length - 1)];
    double balance = [canBalanceStr doubleValue];
    NSLog(@"balan %f %@", balance, canBalanceStr);

    if([m_amountField.text doubleValue] > balance)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"可用金额不足！" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    else if (m_amountField.text.length > 5)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额最高5位！" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    if(![m_passwordField.text isEqualToString:[RuYiCaiNetworkManager sharedManager].password])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"登录密码输入错误！" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}

- (void)okClick
{
    [m_accountField resignFirstResponder];
    [m_amountField resignFirstResponder];
    [m_passwordField resignFirstResponder];
    
    if(![self valueCheck])
    {
        return;
    }
    NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:@"recharge" forKey:@"command"];
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [tempDic setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [tempDic setObject:@"09" forKey:@"rechargetype"];
    [tempDic setObject:m_accountField.text forKey:@"to_mobile_code"];
    [tempDic setObject:[NSString stringWithFormat:@"%d", [m_amountField.text intValue]*100] forKey:@"amount"];
    [tempDic setObject:m_passwordField.text forKey:@"password"];

    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
}

- (void)querySampleNetOK:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    NSString* message = [parserDict objectForKey:@"message"];
    [jsonParser release];

    [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [m_accountField resignFirstResponder];
    [m_amountField resignFirstResponder];
    [m_passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark balance
- (void)queryUserBalanceOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    m_tiXianAmountLabel.text = [parserDict objectForKey:@"drawbalance"];
    [jsonParser release];
}
@end
