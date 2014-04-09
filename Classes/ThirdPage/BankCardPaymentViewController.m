//
//  BankCardPaymentViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BankCardPaymentViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RuYiCaiNetworkManager.h"
#import "RandomPickerViewController.h"
#import "NSLog.h"
#import "Custom_tabbar.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface BankCardPaymentViewController (internal)

- (void)okClick;
- (void)queryChargeWarnStrOK:(NSNotification*)notifition;

@end


@implementation BankCardPaymentViewController

@synthesize	scrollBind = m_scrollBind;
@synthesize	scrollNoBind = m_scrollNoBind;
@synthesize bindAmountTextField = m_bindAmountTextField;
@synthesize bindCardNoLabel = m_bindCardNoLabel;
@synthesize bindPhonenumTextField = m_bindPhonenumTextField;
@synthesize noBindAmountTextField = m_noBindAmountTextField;
@synthesize bankNameButton = m_bankNameButton;
@synthesize cardNoTextField = m_cardNoTextField;
@synthesize userNameTextField = m_userNameTextField;
@synthesize certidTextField = m_certidTextField;
@synthesize certidAddressTextField = m_certidAddressTextField;
@synthesize cardAddressTextField = m_cardAddressTextField;
@synthesize phonenumTextField = m_phonenumTextField;
@synthesize bankName = m_bankName;
@synthesize bindName = m_bindName;
@synthesize bindBankCardNo = m_bindBankCardNo;
@synthesize bindCertId = m_bindCertId;
@synthesize bindDate = m_bindDate;
@synthesize bindAddressName = m_bindAddressName;
@synthesize bindBankAddress = m_bindBankAddress;
@synthesize bindPhonenum = m_bindPhonenum;

- (void)dealloc 
{
    m_delegate.randomPickerView.delegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryChargeWarnStrOK" object:nil];

	[m_scrollBind release];
	[m_scrollNoBind release];
    [m_bindAmountTextField release];
    [m_bindCardNoLabel release];
    [m_bindPhonenumTextField release];
    [m_noBindAmountTextField release];
    [m_bankNameButton release];
    [m_cardNoTextField release];
    [m_userNameTextField release];
    [m_certidTextField release];
    [m_certidAddressTextField release];
    [m_cardAddressTextField release];
    [m_phonenumTextField release];
    self.lotNo = nil;
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3]) {
        
        //快三返回按钮
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
        
        //右按钮
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"确定" normalColor:@"#74061f" higheColor:@"#4f0415"];
    }else{
        
        [BackBarButtonItemUtils addBackButtonForController:self];
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"确定"];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryChargeWarnStrOK:) name:@"queryChargeWarnStrOK" object:nil];

    m_bindAmountTextField.delegate = self;
    m_bindPhonenumTextField.delegate = self; 
    m_noBindAmountTextField.delegate = self;
    m_cardNoTextField.delegate = self;
    m_userNameTextField.delegate = self;
    m_certidTextField.delegate = self;
    m_certidAddressTextField.delegate = self;
    m_cardAddressTextField.delegate = self;
    m_phonenumTextField.delegate = self;
    
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    
    self.scrollBind.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    self.scrollBind.contentSize = CGSizeMake(320, 415);
    self.scrollBind.hidden = YES;
    
    self.scrollNoBind.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    self.scrollNoBind.contentSize = CGSizeMake(320, 580 + 50);
    self.scrollNoBind.hidden = YES;
    [self.view addSubview:self.scrollBind];
    [self.view addSubview:self.scrollNoBind];
    
    self.bindAmountTextField.text = @"100";  //银行卡默认充值金额
    [self.bankNameButton setBackgroundImage:[UIImage imageNamed:@"select2_normal.png"] forState:UIControlStateNormal];
    [self.bankNameButton setTitle:@"中国工商银行" forState:UIControlStateNormal];
    
//    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
//                      initWithTitle:@"确定"
//                      style:UIBarButtonItemStyleBordered
//                      target:self
//                      action:@selector(okClick)];
//    self.navigationItem.rightBarButtonItem = okBarButtonItem;
//    [okBarButtonItem release];
    
    m_hasBind = NO;
    
    [RuYiCaiNetworkManager sharedManager].netChargeQuestType = NET_QUERY_CHARGE_WARN;
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"dnaChargeDescription"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    NSString* bindState = [parserDict objectForKey:@"bindstate"];
    [jsonParser release];
    
    self.bindName = [parserDict objectForKey:@"name"];
    self.bindBankCardNo = [parserDict objectForKey:@"bankcardno"];
    self.bindCertId = [parserDict objectForKey:@"certid"];
    self.bindDate = [parserDict objectForKey:@"binddate"];
    self.bindAddressName = [parserDict objectForKey:@"addressname"];
    self.bindBankAddress = [parserDict objectForKey:@"bankaddress"];
    self.bindPhonenum = [parserDict objectForKey:@"phonenum"];
    
    if ([bindState isEqualToString:@"0"])  //not bind，未绑定，但是曾经提交过信息，未交钱
    {
        [self showBindStatus:NO];
    }
    else if ([bindState isEqualToString:@"1"])  //bind，绑定
    {
        [self showBindStatus:YES];
    }
    else  //未绑定
    {
        [self showBindStatus:NO];
    }
    
}

- (void)showBindStatus:(BOOL)hasBind
{
    m_hasBind = hasBind;
    if (m_hasBind)
    {
        self.scrollBind.hidden = NO;
        self.scrollNoBind.hidden = YES;
        self.bindCardNoLabel.text = self.bindBankCardNo;
        self.bindPhonenumTextField.text = self.bindPhonenum;
    }
    else
    {
        self.scrollBind.hidden = YES;
        self.scrollNoBind.hidden = NO;
    }
}

- (IBAction)hideKeyboard
{
    if (m_hasBind)
    {
        [m_bindAmountTextField resignFirstResponder];
        [m_bindPhonenumTextField resignFirstResponder];
    }
    else
    {
        [m_noBindAmountTextField resignFirstResponder];
        [m_cardNoTextField resignFirstResponder];
        [m_userNameTextField resignFirstResponder];
        [m_certidTextField resignFirstResponder];
        [m_certidAddressTextField resignFirstResponder];
        [m_cardAddressTextField resignFirstResponder];
        [m_phonenumTextField resignFirstResponder];
    }
}

- (IBAction)selectBankAction
{
    [self hideKeyboard];
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:BANK_GROUP];
    [m_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:10];
}

- (void)okClick
{
    [self hideKeyboard];
    if(m_hasBind)
    {
        if(m_bindPhonenumTextField.text.length == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入手机号码！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if([m_bindAmountTextField.text intValue] < 20)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最低充值20元！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if([m_bindAmountTextField.text intValue] > 99999)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高充值99999元！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    else
    {
        if(m_phonenumTextField.text.length == 0)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入手机号码！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if([m_noBindAmountTextField.text intValue] < 20)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最低充值20元！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if([m_noBindAmountTextField.text intValue] > 99999)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高充值99999元！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"recharge" forKey:@"command"];
    [dict setObject:@"01" forKey:@"rechargetype"];
    [dict setObject:@"" forKey:@"subchannel"];
    if (m_hasBind)
    {
        [dict setObject:self.bindPhonenumTextField.text forKey:@"phonenum"];
        NSString* amtValue = [NSString stringWithFormat:@"%d", [self.bindAmountTextField.text intValue] * 100];
        [dict setObject:amtValue  forKey:@"amount"];
        [dict setObject:self.bindBankCardNo forKey:@"cardno"];
        [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        [dict setObject:@"0101" forKey:@"cardtype"];
        [dict setObject:self.bindName forKey:@"name"];
        [dict setObject:self.bindCertId forKey:@"certid"];
        [dict setObject:self.bindBankAddress forKey:@"bankaddress"];
        [dict setObject:self.bindAddressName forKey:@"addressname"];
        [dict setObject:@"true" forKey:@"iswhite"];
    }
    else
    {
        [dict setObject:self.phonenumTextField.text forKey:@"phonenum"];
        NSString* amtValue = [NSString stringWithFormat:@"%d", [self.noBindAmountTextField.text intValue] * 100];
        [dict setObject:amtValue  forKey:@"amount"];
        [dict setObject:self.cardNoTextField.text forKey:@"cardno"];
        [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        [dict setObject:@"0101" forKey:@"cardtype"];  //待定，根据银行名称来设置
        [dict setObject:self.userNameTextField.text forKey:@"name"];
        [dict setObject:self.certidTextField.text forKey:@"certid"];
        [dict setObject:self.cardAddressTextField.text forKey:@"bankaddress"];
        [dict setObject:self.certidAddressTextField.text forKey:@"addressname"];
        [dict setObject:@"false" forKey:@"iswhite"];
    }
    [[RuYiCaiNetworkManager sharedManager] chargeDNA:dict];
}

#pragma mark RandomPickerDelegate

- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    switch (num) {
        case 0:
            self.bankName = @"中国工商银行";
            break;
        case 1:
            self.bankName = @"中国农业银行";
            break;
        case 2:
            self.bankName = @"中国建设银行";
            break;
        case 3:
            self.bankName = @"招商银行";
            break;
        case 4:
            self.bankName = @"中国邮政储蓄银行";
            break;
        case 5:
            self.bankName = @"华厦银行";
            break;
        case 6:
            self.bankName = @"兴业银行";
            break;
        case 7:
            self.bankName = @"中信银行";
            break;
        case 8:
            self.bankName = @"中国光大银行";
            break;
//        case 9:
//            self.bankName = @"上海浦东发展银行";
//            break;
        case 9:
            self.bankName = @"平安银行";
            break;
        default:
            break;
    }
    [self.bankNameButton setTitle:self.bankName forState:UIControlStateNormal];
}

- (void)queryChargeWarnStrOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].chargeWarnStr];
    NSString* contentStr = [parserDict objectForKey:@"content"];
    [jsonParser release];
    
    UITextView*    warnView = [[UITextView alloc] init];
    warnView.text = contentStr;
    [warnView setTextColor:[UIColor grayColor]];
    [warnView setFont:[UIFont systemFontOfSize:14.0f]];
    [warnView setBackgroundColor:[UIColor clearColor]];
    warnView.scrollEnabled = YES;
    warnView.editable = NO;
    if(m_hasBind)
    {
        warnView.frame = CGRectMake(12, 150, 295, [UIScreen mainScreen].bounds.size.height - 220);
        [self.scrollBind addSubview:warnView];
    }
    else
    {
        warnView.frame = CGRectMake(5, 380, 310, [UIScreen mainScreen].bounds.size.height - 330);
        [self.scrollNoBind addSubview:warnView];
    }
    [warnView release];
}

#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_bindAmountTextField resignFirstResponder];
    [m_bindPhonenumTextField resignFirstResponder];
    [m_noBindAmountTextField resignFirstResponder];
    [m_cardNoTextField resignFirstResponder];
    [m_userNameTextField resignFirstResponder];
    [m_certidTextField resignFirstResponder];
    [m_certidAddressTextField resignFirstResponder];
    [m_cardAddressTextField resignFirstResponder];
    [m_phonenumTextField resignFirstResponder];
     
    return YES;
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
