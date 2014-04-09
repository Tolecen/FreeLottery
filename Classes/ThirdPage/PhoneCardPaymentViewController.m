//
//  PhoneCardPaymentViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhoneCardPaymentViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RuYiCaiNetworkManager.h"
#import "RandomPickerViewController.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface PhoneCardPaymentViewController (internal)

- (void)okClick;
- (void)queryChargeWarnStrOK:(NSNotification*)notifition;
- (void)backNotification:(NSNotification*)notification;

@end

@implementation PhoneCardPaymentViewController

@synthesize cardTypeButton = m_cardTypeButton;
@synthesize cardAmountButton = m_cardAmountButton;
@synthesize cardNoTextField = m_cardNoTextField;
@synthesize cardPasswordTextField = m_cardPasswordTextField;
@synthesize cardType = m_cardType;
@synthesize cardAmount = m_cardAmount;

- (void)dealloc 
{
    m_delegate.randomPickerView.delegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryChargeWarnStrOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backNotification" object:nil];

    [m_cardTypeButton release];
    [m_cardAmountButton release];
    [m_cardNoTextField release];
    [m_cardPasswordTextField release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.cardType = @"0203";  //移动充值卡
    [self.cardTypeButton setTitle:@"移动充值卡" forState:UIControlStateNormal];
    
    [BackBarButtonItemUtils addBackButtonForController:self];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryChargeWarnStrOK:) name:@"queryChargeWarnStrOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotification:) name:@"backNotification" object:nil];    

    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    
//    [self.cardTypeButton setTitle:@"移动充值卡" forState:UIControlStateNormal];
//    self.cardType = @"0203";
//    [self.cardAmountButton setTitle:@"100元" forState:UIControlStateNormal];
//    self.cardAmount = @"100";
    
    m_cardNoTextField.delegate = self;
    m_cardPasswordTextField.delegate = self;
    
//    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
//                                        initWithTitle:@"确定"
//                                        style:UIBarButtonItemStyleBordered
//                                        target:self
//                                        action:@selector(okClick)];
//    self.navigationItem.rightBarButtonItem = okBarButtonItem;
//    [okBarButtonItem release];
    
    //手机充值卡充值 确定
    UIButton* sureButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    [sureButton setBackgroundImage:RYCImageNamed(@"queding_c_btn.png") forState:UIControlStateNormal];
    [sureButton setBackgroundImage:RYCImageNamed(@"queding_c_hov_btn.png") forState:UIControlStateHighlighted];
	[sureButton addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.navigationController.navigationBar addSubview:m_backButton];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:sureButton] autorelease];
    [sureButton release];
    
    [RuYiCaiNetworkManager sharedManager].netChargeQuestType = NET_QUERY_CHARGE_WARN;
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"phoneCardChargeDescription"];

}
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)hideKeyboard
{
    [m_cardNoTextField resignFirstResponder];
    [m_cardPasswordTextField resignFirstResponder];
}

- (IBAction)selectCardTypeAction
{
    [self hideKeyboard];
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:PHONE_CARD_TYPE_GROUP];
    [m_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:3];
}

- (IBAction)selectCardAmountAction
{
    [self hideKeyboard];
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:PHONE_CARD_AMOUNT_GROUP];
    [m_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:8];
}

- (void)okClick
{
    [self hideKeyboard];
	if([self.cardTypeButton currentTitle].length == 0 || [self.cardAmountButton currentTitle].length == 0 || self.cardNoTextField.text.length == 0 || self.cardPasswordTextField.text.length == 0)
	{
		[[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整" withTitle:@"提示" buttonTitle:@"确定"];
	}
	else 
	{
		NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
		[dict setObject:@"recharge" forKey:@"command"];
		[dict setObject:@"02" forKey:@"rechargetype"];
		[dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
		[dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
		[dict setObject:@"" forKey:@"subchannel"];
		NSString* amtValue = [NSString stringWithFormat:@"%d", [self.cardAmount intValue] * 100];
		[dict setObject:amtValue  forKey:@"amount"];
		[dict setObject:self.cardNoTextField.text forKey:@"cardno"];
		[dict setObject:self.cardPasswordTextField.text forKey:@"cardpwd"];
		[dict setObject:self.cardType forKey:@"cardtype"];
		[[RuYiCaiNetworkManager sharedManager] chargeByPhoneCard:dict];
	}
}

#pragma mark RandomPickerDelegate

- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    int currentType = [randomPickerView currentPickerType];
    if (PHONE_CARD_TYPE_GROUP == currentType)
    {
        NSString* cardTypeName = @"";
        switch (num) {
            case 0:
                self.cardType = @"0203";  //移动充值卡
                cardTypeName = @"移动充值卡";
                break;
            case 1:
                self.cardType = @"0206";  //联通充值卡
                cardTypeName = @"联通充值卡";
                break;
            case 2:
                self.cardType = @"0221";  //电信充值卡
                cardTypeName = @"电信充值卡";
                break;
            default:
                break;
        }
        [self.cardTypeButton setTitle:cardTypeName forState:UIControlStateNormal];
    }
    else if (PHONE_CARD_AMOUNT_GROUP == currentType)
    {
        switch (num) {
            case 0:
                self.cardAmount = @"10";
                break;
            case 1:
                self.cardAmount = @"20";
                break;
            case 2:
                self.cardAmount = @"30";
                break;
            case 3:
                self.cardAmount = @"50";
                break;
            case 4:
                self.cardAmount = @"100";
                break;
            case 5:
                self.cardAmount = @"200";
                break;
            case 6:
                self.cardAmount = @"300";
                break;
            case 7:
                self.cardAmount = @"500";
                break;
            default:
                break;
        }
        [self.cardAmountButton setTitle:[NSString stringWithFormat:@"%@元", self.cardAmount] forState:UIControlStateNormal];
    }
}

- (void)queryChargeWarnStrOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].chargeWarnStr];
    NSString* contentStr = [parserDict objectForKey:@"content"];
    [jsonParser release];
    
    UITextView*    warnView = [[UITextView alloc] initWithFrame:CGRectMake(13, 160, 298, [UIScreen mainScreen].bounds.size.height - 237)];
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

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_cardNoTextField resignFirstResponder];
    [m_cardPasswordTextField resignFirstResponder];
    return YES;  
}

@end