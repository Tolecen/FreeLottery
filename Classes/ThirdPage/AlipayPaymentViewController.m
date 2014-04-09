//
//  AlipayPaymentViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlipayPaymentViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RuYiCaiNetworkManager.h"
#import "RandomPickerViewController.h"
#import "NSLog.h"
#import "AlipayPayWapView.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface AlipayPaymentViewController (internal)

- (void)okClick;
- (void)queryAlipayOK:(NSNotification*)notification;
- (void)queryChargeWarnStrOK:(NSNotification*)notifition;

@end

@implementation AlipayPaymentViewController

@synthesize amountTextField = m_amountTextField;

- (void)dealloc 
{
    [m_amountTextField release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryChargeWarnStrOK" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryAlipayOK" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"确定"];
        
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    m_amountTextField.text = @"100";
    
//    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
//                                        initWithTitle:@"确定"
//                                        style:UIBarButtonItemStyleBordered
//                                        target:self
//                                        action:@selector(okClick)];
//    self.navigationItem.rightBarButtonItem = okBarButtonItem;
//    [okBarButtonItem release];
    
    [RuYiCaiNetworkManager sharedManager].netChargeQuestType = NET_QUERY_CHARGE_WARN;
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"zfbChargeDescription"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryAlipayOK:) name:@"queryAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryChargeWarnStrOK:) name:@"queryChargeWarnStrOK" object:nil];

}

- (IBAction)hideKeyboard
{
    [m_amountTextField resignFirstResponder];
}

- (void)okClick
{
    [self hideKeyboard];
    if (0 == self.amountTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入充值金额" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    else if([self.amountTextField.text intValue] > 2000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"支付金额每日最高为2000元！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }

    for (int i = 0; i < self.amountTextField.text.length; i++)
    {
        UniChar chr = [self.amountTextField.text characterAtIndex:i];
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
    [dict setObject:@"05" forKey:@"rechargetype"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
	[dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [dict setObject:@"0300" forKey:@"cardtype"];
    [dict setObject:@"" forKey:@"subchannel"];
    NSString* amtValue = [NSString stringWithFormat:@"%d", [self.amountTextField.text intValue] * 100];
    [dict setObject:amtValue  forKey:@"amount"];
    [[RuYiCaiNetworkManager sharedManager] chargeByAlipay:dict];
}

- (void)queryAlipayOK:(NSNotification*)notification
{
    [self setHidesBottomBarWhenPushed:YES];    
    AlipayPayWapView* viewController = [[AlipayPayWapView alloc] init];
    viewController.title = @"支付宝wap充值";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.amountTextField resignFirstResponder];
}

- (void)queryChargeWarnStrOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].chargeWarnStr];
    NSString* contentStr = [parserDict objectForKey:@"content"];
    [jsonParser release];
    
    UITextView*    warnView = [[UITextView alloc] initWithFrame:CGRectMake(15, 82, 280, [UIScreen mainScreen].bounds.size.height - 152)];
    warnView.text = contentStr;
    [warnView setTextColor:[UIColor grayColor]];
    [warnView setFont:[UIFont systemFontOfSize:14.0f]];
    [warnView setBackgroundColor:[UIColor clearColor]];
    warnView.scrollEnabled = YES;
    warnView.editable = NO;
    [self.view addSubview:warnView];
    [warnView release];
}
@end
