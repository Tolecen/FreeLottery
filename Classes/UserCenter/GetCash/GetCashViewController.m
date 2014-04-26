//
//  GetCashViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-10-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GetCashViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "RuYiCaiNetworkManager.h"
#import "RandomPickerViewController.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "AnimationTabView.h"
#import "GetCashRecordView.h"
#import "PullUpRefreshView.h"
#import "Custom_tabbar.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kLotWinDetailViewHeight (100)

#define kBankSaveKey        @"BankImfor"
#define kBankUserNameKey    @"BankUserName"
#define kBankAccountKey     @"BankAccount"
#define kBankNameKey        @"BankName"

//#define kAlipaySaveKey    @"AlipayImfor"
#define kAlipaySaveKey    [RuYiCaiNetworkManager sharedManager].loginName ? [RuYiCaiNetworkManager sharedManager].loginName : @"" 
#define kAlipayAccountKey @"AlipayAccount"
#define kAlipayNameKey    @"AlipayName"

@interface GetCashViewController (internal)

- (void)handleNetworkResponseText;

- (void)refreshSubViewsOfState:(BOOL)isNew;
- (void)cancelGetCashOK:(NSNotification*)notification;
- (void)tabButtonChanged:(NSNotification*)notification;

- (void)getCashRecordInfor;
- (void)queryGetCashRecordOK:(NSNotification*)notification;
- (void)refreshRecordSubViews;

- (void)startRefresh:(NSNotification *)notification;
- (void)netFailed:(NSNotification*)notification;

- (void)setViewAngin;

- (void)getCashOK:(NSNotification *)notification;
- (void)queryUserBalanceOK:(NSNotification *)notification;

- (BOOL)getCashBankCheck;
- (BOOL)getCashAlipayCheck;

@end

@implementation GetCashViewController

@synthesize animationTabView = m_animationTabView;
@synthesize newsCashScrollView = m_newCashScrollView;
@synthesize nameTextField = m_nameTextField;
@synthesize bankNameButton = m_bankNameButton;
@synthesize passWordField = m_passWordField;
@synthesize balanceLabel = m_balanceLabel;
@synthesize m_warnTextView;
@synthesize m_zfbTextView;
@synthesize subbankField = m_subbankField;
@synthesize regionField = m_regionField;
@synthesize bankCardLable = m_bankCardLable;

@synthesize alipayGetCashScrollView = m_alipayGetCashScrollView;
@synthesize alipayAccountField = m_alipayAccountField;
@synthesize alipayNameField = m_alipayNameField;
@synthesize canBalanceLable = m_canBalanceLable;
@synthesize alipayAmountField = m_alipayAmountField;
@synthesize alipayPassWordField = m_alipayPassWordField;

@synthesize bankCardNoTextField = m_bankCardNoTextField;
@synthesize amountTextField = m_amountTextField;
@synthesize cashDetailId = m_cashDetailId;
@synthesize amount = m_amount;
@synthesize userName = m_userName;
@synthesize stat = m_stat;
@synthesize bankName = m_bankName;
@synthesize bankCardNo = m_bankCardNo;
@synthesize allBankName = m_allBankName;
@synthesize region = m_region;
@synthesize subbank =m_subbank;
@synthesize getCashRecordScrollView = m_getCashRecordScrollView;

@synthesize passWordLabel;
@synthesize alipayPassWordLabel;
@synthesize bankTxBtn = m_bankTxBtn;;
@synthesize txLogBtn = m_txLogBtn;
@synthesize alipayBtn = m_alipayBtn;

- (void)dealloc 
{
    m_delegate.randomPickerView.delegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelGetCashOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryGetCashRecordOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getCashOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryUserBalanceOK" object:nil];

    [m_bankCardLable release];
    [m_bankTxBtn release];
    [m_txLogBtn release];
    [m_alipayBtn release];
    [m_animationTabView release];
    [m_newCashScrollView release];
    [m_nameTextField release];
    [m_bankNameButton release];
    //[m_areaNameTextField release];
    [m_passWordField release];
    [m_balanceLabel release];
    [m_warnTextView release];
    [m_zfbTextView release];
    [m_subbankField release];
    [m_regionField release];
    
    [m_alipayGetCashScrollView release];
    [m_alipayAccountField release];
    [m_alipayNameField release];
    [m_canBalanceLable release];
    [m_alipayAmountField release];
    [m_alipayPassWordField release];
    
    [m_bankCardNoTextField release];
    [m_amountTextField release];
    
    [m_allBankName release];
    [m_subbank release];
    [m_region release];
    [m_getCashRecordScrollView release];
    
    [passWordLabel release];
    [alipayPassWordLabel release];
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [self setHidesBottomBarWhenPushed:NO];
    [[Custom_tabbar showTabBar] hideTabBar:NO];
    [self setHidesBottomBarWhenPushed:YES];
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bankTakeCashDescription" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bankTakeCashDescription:) name:@"bankTakeCashDescription" object:nil];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    [self.bankNameButton setBackgroundImage:[UIImage imageNamed:@"select2_normal.png"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelGetCashOK:) name:@"cancelGetCashOK" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryGetCashRecordOK:) name:@"queryGetCashRecordOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRefresh:) name:@"startRefresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCashOK:) name:@"getCashOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryUserBalanceOK:) name:@"queryUserBalanceOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"txyhkCardChargeDescription"];

//    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
//    [m_animationTabView.buttonNameArray addObject:@"银行卡提现"];
////    [m_animationTabView.buttonNameArray addObject:@"支付宝提现"];
//    [m_animationTabView.buttonNameArray addObject:@"提现记录"];
//    [m_animationTabView setMainButton];
//    [self.view addSubview:m_animationTabView];
    
    
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"提现"];
    UIView *topViewBg = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 31)];
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topall_c_bg.png"]];
    
    topImageView.frame = CGRectMake(2, 2, 296, 27);
    [topViewBg addSubview:topImageView];
    [topImageView release];
    [self.view addSubview:topViewBg];
    [topViewBg release];
    
    
    topButtonIndex = 0;
    m_bankTxBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 31)];
    
    [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_highlight.png") forState:UIControlStateNormal];
    [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_highlight.png") forState:UIControlStateHighlighted];
    [m_bankTxBtn addTarget:self action:@selector(bankTxBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    m_alipayBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 100, 31)];
    [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_normal.png") forState:UIControlStateNormal];
    [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_highlight.png") forState:UIControlStateHighlighted];
    [m_alipayBtn addTarget:self action:@selector(alipayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    m_txLogBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 31)];
    [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_normal.png") forState:UIControlStateNormal];
    [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_normal.png") forState:UIControlStateHighlighted];
    [m_txLogBtn addTarget:self action:@selector(txLogBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [topViewBg addSubview:self.bankTxBtn];
    [topViewBg addSubview:self.txLogBtn];
    [topViewBg addSubview:self.alipayBtn];
    
    
    
    m_allBankName = [[NSMutableArray alloc] initWithCapacity:2];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    
    m_nameTextField.delegate = self;
    m_bankCardNoTextField.delegate = self;
    m_amountTextField.delegate = self;
    m_passWordField.delegate = self;
    m_regionField.delegate = self;
    m_subbankField.delegate = self;
    self.newsCashScrollView.contentSize = CGSizeMake(320, 415);
    
    if (KISiPhone5) {
        m_warnTextView.frame = CGRectMake(10, 270, 300, [UIScreen mainScreen].bounds.size.height - 410+30);
    }else{
        m_warnTextView.frame = CGRectMake(10, 240, 300, [UIScreen mainScreen].bounds.size.height - 360);
    }
    
    if (KISiPhone5) {
//        m_zfbTextView.frame = CGRectMake(10, 260, 300, [UIScreen mainScreen].bounds.size.height - 100);
        m_zfbTextView.frame = CGRectMake(10, 230, 300, [UIScreen mainScreen].bounds.size.height - 310);
    }else{
        m_zfbTextView.frame = CGRectMake(10, 210, 300, [UIScreen mainScreen].bounds.size.height - 340);
    }
    
    NSDictionary* alipayImfor = [[NSUserDefaults standardUserDefaults] objectForKey:kAlipaySaveKey];
    if(alipayImfor)
    {
        m_alipayAccountField.text = [alipayImfor objectForKey:kAlipayAccountKey];
        m_alipayNameField.text = [alipayImfor objectForKey:kAlipayNameKey];
    }
    m_alipayAccountField.delegate = self;
    m_alipayNameField.delegate = self;
    m_alipayAmountField.delegate = self;
    m_alipayPassWordField.delegate = self;
    self.alipayGetCashScrollView.contentSize = CGSizeMake(320, 435);
    self.alipayGetCashScrollView.hidden = YES;
    
    if(![[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
    {
        self.passWordField.hidden = YES;
        self.alipayPassWordField.hidden = YES;
        self.passWordLabel.hidden = YES;
        self.alipayPassWordLabel.hidden = YES;
    }
    
    bindState = NO;
//    [m_bankCardLable setHidden:NO];
//    [m_bankNameButton setHidden:NO];
    
    [self handleNetworkResponseText];
    
    m_getCashRecordScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, (int)[UIScreen mainScreen].bounds.size.height - 64 - 45)];
    m_getCashRecordScrollView.delegate = self;
    m_getCashRecordScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height - 105);
    [m_getCashRecordScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.getCashRecordScrollView];
    self.getCashRecordScrollView.hidden = YES;
    
    m_totalPageCount = 0;
    m_curPageIndex = 0;
    m_curPageSize = 0;
    startY = 0;
    centerY = 0;
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - 45, 320, REFRESH_HEADER_HEIGHT)];
    [self.getCashRecordScrollView addSubview:refreshView];
    refreshView.myScrollView = self.getCashRecordScrollView;
    [refreshView stopLoading:NO];
    
    isFirstGetCashRecord = YES;
    
    [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
}



- (IBAction)hideKeyboard
{
    [m_nameTextField resignFirstResponder];
    [m_bankCardNoTextField resignFirstResponder];
    [m_amountTextField resignFirstResponder];
    [m_passWordField resignFirstResponder];
    [m_regionField resignFirstResponder];
    [m_subbankField resignFirstResponder];
    
    [m_alipayAccountField resignFirstResponder];
    [m_alipayNameField resignFirstResponder];
    [m_alipayAmountField resignFirstResponder];
    [m_alipayPassWordField resignFirstResponder];
    if(!KISiPhone5)
    {
        if(self.newsCashScrollView.center.y != 275)
        {
            [UIView beginAnimations:@"movement" context:nil]; 
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationRepeatAutoreverses:NO];
            CGPoint center = self.newsCashScrollView.center;
            center.y += 85;
            self.newsCashScrollView.center = center;
            [UIView commitAnimations];
        }
        if(self.alipayGetCashScrollView.center.y != 275)
        {
            [UIView beginAnimations:@"movement" context:nil]; 
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationRepeatAutoreverses:NO];
            CGPoint center = self.alipayGetCashScrollView.center;
            center.y += 70;
            self.alipayGetCashScrollView.center = center;
            [UIView commitAnimations];
        }
    }
}

- (IBAction)selectBankAction
{
    [self hideKeyboard];
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:GET_CASH_BANK_NAME];
    [m_delegate.randomPickerView setPickerDataArray:self.allBankName];
    [m_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:[self.allBankName count]];
}

- (void)refreshSubViewsOfState:(BOOL)isNew
{
    m_newCashScrollView.hidden = NO;

    self.nameTextField.text = self.userName;
    [self.bankNameButton setTitle:self.bankName forState:UIControlStateNormal];
    self.bankCardNoTextField.text = self.bankCardNo;
//    self.regionField.text = self.region;
//    self.subbankField.text = self.subbank;
    self.amountTextField.text = [NSString stringWithFormat:@"%d", [self.amount intValue] / 100];
}

- (void)handleNetworkResponseText
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    NSString* bind_State = [parserDict objectForKey:@"bindstate"];
    [jsonParser release];
    
    NSArray* array = [[NSArray alloc] initWithObjects:@"中国工商银行",@"中国农业银行",@"中国建设银行",@"中国民生银行",@"招商银行",@"中国银行",@"中国邮政储蓄银行",@"交通银行",
                      @"兴业银行",@"中信银行",@"中国光大银行",@"广东发展银行",@"上海浦东发展银行",@"平安银行",@"杭州银行", @"华夏银行",nil];
    [self.allBankName removeAllObjects];
    [self.allBankName addObjectsFromArray:array];
    [array release];
    
    if ([bind_State isEqualToString:@"0"] || [bind_State isEqualToString:@"1"])  //not bind，未绑定，但是曾经提交过信息，未交钱              //bind，绑定
    {
        self.cashDetailId = [parserDict objectForKey:@"certid"];
        self.amount = @"1000";
        self.userName = [parserDict objectForKey:@"name"];
        self.stat = [parserDict objectForKey:@"bindstate"];
        self.bankName = [parserDict objectForKey:@"bankname"];
        self.bankCardNo = [parserDict objectForKey:@"bankcardno"];
//        self.region = [parserDict objectForKey:@"region"];
//        self.subbank = [parserDict objectForKey:@"subbank"];
        
//        NSLog(@"cashDetailId:%@",self.cashDetailId);
//        NSLog(@"userName:%@",self.userName);
//        NSLog(@"stat:%@",self.stat);
//        NSLog(@"bankName:%@",self.bankName);
//        NSLog(@"bankCardNo:%@",self.bankCardNo);
        
        if([bind_State isEqualToString:@"1"])//绑定 但银行名字可能没保存
        {   
            bindState = YES;
            
            self.nameTextField.borderStyle = UITextBorderStyleNone;
            self.nameTextField.enabled = NO;
            
            [self.bankNameButton setTitle:self.bankName forState:UIControlStateNormal];
            
            if(self.bankName.length == 0)
                self.bankNameButton.enabled = YES;
            else
                self.bankNameButton.enabled = NO;
            
            self.bankCardNoTextField.borderStyle = UITextBorderStyleNone;
            self.bankCardNoTextField.enabled = NO;
            
        }
//

        [self refreshSubViewsOfState:YES];
    }
    else
    {
        NSDictionary* bankImfor = [[NSUserDefaults standardUserDefaults] objectForKey:kBankSaveKey];
        if(bankImfor)
        {
            self.nameTextField.text = [bankImfor objectForKey:kBankUserNameKey];
            [self.bankNameButton setTitle:[bankImfor objectForKey:kBankNameKey] forState:UIControlStateNormal];
            self.bankCardNoTextField.text = [bankImfor objectForKey:kBankAccountKey];
        }
    }
}



- (void)okClick
{
    [self hideKeyboard];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    if(topButtonIndex == 0)
    {
        if(![self getCashBankCheck])
        {
            return;
        }
        
//        NSLog(@"bankname:%@",self.bankNameButton.currentTitle);
//        NSLog(@"bankcardno:%@",self.bankCardNoTextField.text);
//        NSLog(@"password:%@",self.passWordField.text);
//        NSLog(@"name:%@",self.nameTextField.text);
        
        
        [dict setObject:self.bankNameButton.currentTitle forKey:@"bankname"];
        [dict setObject:self.bankCardNoTextField.text forKey:@"bankcardno"];
        [dict setObject:self.nameTextField.text forKey:@"name"];
        
        NSLog(@"self.passWordField = %@",self.passWordField.text);
        if (self.passWordField.text!=nil && ![self.passWordField.text isEqualToString:@""])
        {
            [dict setObject:self.passWordField.text forKey:@"password"];
        }
        
        
//        [dict setObject:self.regionField.text forKey:@"region"];
//        [dict setObject:self.subbankField.text forKey:@"subbank"];
        [dict setObject:[NSString stringWithFormat:@"%0.0lf", [self.amountTextField.text doubleValue] * 100] forKey:@"amount"];
        [dict setObject:@"1" forKey:@"type"];
        
        if(self.nameTextField.enabled)//可编辑就保存
        {
        }
            //保存银行信息
        NSDictionary* bankDic = [NSDictionary dictionaryWithObjectsAndKeys:self.nameTextField.text, kBankUserNameKey, self.bankNameButton.currentTitle, kBankNameKey, self.bankCardNoTextField.text, kBankAccountKey,nil];
        [[NSUserDefaults standardUserDefaults] setObject:bankDic forKey:kBankSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];//同步
        
    }
    else if(topButtonIndex == 1)
    {
        if(![self getCashAlipayCheck])
        {
            return;
        }
        [dict setObject:@"2" forKey:@"type"];
        [dict setObject:self.alipayAccountField.text forKey:@"bankcardno"];
        [dict setObject:self.alipayNameField.text forKey:@"name"];
        if (self.alipayPassWordField.text!=nil && ![self.alipayPassWordField.text isEqualToString:@""])
        {
            [dict setObject:self.alipayPassWordField.text forKey:@"password"];
        }
        
        
        [dict setObject:[NSString stringWithFormat:@"%0.0lf", [self.alipayAmountField.text doubleValue] * 100] forKey:@"amount"];
        
        //保存支付宝信息
        NSDictionary*  alipayDic = [NSDictionary dictionaryWithObjectsAndKeys:self.alipayAccountField.text, kAlipayAccountKey, self.alipayNameField.text, kAlipayNameKey,nil];
        [[NSUserDefaults standardUserDefaults] setObject:alipayDic forKey:kAlipaySaveKey];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];//同步
    }
    [dict setObject:@"getCash" forKey:@"command"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    [dict setObject:@"cash" forKey:@"cashtype"];
        
    [[RuYiCaiNetworkManager sharedManager] getCash:dict];
}

- (BOOL)getCashBankCheck
{
    if(![[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
    {
        if (0 == self.bankCardNoTextField.text.length
            || 0 == self.nameTextField.text.length
            || 0 == self.bankNameButton.currentTitle.length
            || 0 == self.amountTextField.text.length)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    else
    {
        if (0 == self.bankCardNoTextField.text.length
            || 0 == self.nameTextField.text.length 
            || 0 == self.bankNameButton.currentTitle.length 
            || 0 == self.amountTextField.text.length
            || 0 == self.passWordField.text.length)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    int length = self.amountTextField.text.length;
    for (int i = 0; i < length; i++)
    {
        UniChar chr = [self.amountTextField.text characterAtIndex:i];
        if (chr >= '0' && chr <= '9')//是数字
        {
//            if('0' == chr && 0 == i)
//            {
//                [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额填写不规范" withTitle:@"提示" buttonTitle:@"确定"];
//                return NO;
//            }
        }
        else if('.' == chr)
        {
            if(0 == i)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额填写不规范" withTitle:@"提示" buttonTitle:@"确定"];
                return NO;
            }
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额须为整数或小数" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    if ([self.amountTextField.text doubleValue] <= 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额须需大于0" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
 
    NSString*  canBalanceStr = [self.balanceLabel.text substringWithRange:NSMakeRange(0, self.balanceLabel.text.length - 1)];
    double balance = [canBalanceStr doubleValue];
    NSLog(@"balan %f %@", balance, canBalanceStr);
    if (balance < 10)//提现金额少于10元
    {

//        if([self.amountTextField.text doubleValue] != balance)
//        {
//            [[RuYiCaiNetworkManager sharedManager] showMessage: @"可提现金额不足或最低提现金额小于10元需一次提清" withTitle:@"提示" buttonTitle:@"确定"];
//            return NO;
//        }
        
        if([self.amountTextField.text doubleValue] > balance){
            [[RuYiCaiNetworkManager sharedManager] showMessage: @"可提现金额不足。" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
//        else {
//            [[RuYiCaiNetworkManager sharedManager] showMessage: @"最低提现金额小于10元需一次提清。" withTitle:@"提示" buttonTitle:@"确定"];
//            return NO;
//        }
    }
    else
    {
        if([self.amountTextField.text doubleValue] < 10)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最低提现不小于10元！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if([self.amountTextField.text doubleValue] > balance)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额不足！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    if([self.amountTextField.text doubleValue] > 50000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单笔提现金额最高50000元!" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    if([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
    {
        if(![[RuYiCaiNetworkManager sharedManager].password isEqualToString:self.passWordField.text])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"博雅彩账号登录密码不正确！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    return YES;
}

- (BOOL)getCashAlipayCheck
{
    if(![[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
    {
        if (0 == self.alipayAccountField.text.length
            || 0 == self.alipayNameField.text.length
            || 0 == self.alipayAmountField.text.length)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    else
    {
        if (0 == self.alipayAccountField.text.length
            || 0 == self.alipayNameField.text.length 
            || 0 == self.alipayAmountField.text.length
            || 0 == self.alipayPassWordField.text.length)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    int length = self.alipayAmountField.text.length;
    for (int i = 0; i < length; i++)
    {
        UniChar chr = [self.alipayAmountField.text characterAtIndex:i];
        if (chr >= '0' && chr <= '9')//是数字
        {
//            if('0' == chr && 0 == i)
//            {
//                [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额填写不规范" withTitle:@"提示" buttonTitle:@"确定"];
//                return NO;
//            }
        }
        else if('.' == chr)
        {
            if(0 == i)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额填写不规范" withTitle:@"提示" buttonTitle:@"确定"];
                return NO;
            }
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额须为整数或小数" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        
    }
    if ([self.alipayAmountField.text doubleValue] <= 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额须需大于0" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    NSString*  canBalanceStr = [self.balanceLabel.text substringWithRange:NSMakeRange(0, self.balanceLabel.text.length - 1)];
    double balance = [canBalanceStr doubleValue];
    NSLog(@"balan %f %@", balance, canBalanceStr);
//    float balance = [self.canBalanceLable.text floatValue];
    if (balance < 10)//提现金额少于10元
    {
//        if([self.alipayAmountField.text doubleValue] != balance)
//        {
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"可提现金额不足或最低提现金额小于10元" withTitle:@"提示" buttonTitle:@"确定"];
//            return NO;
//        }
        NSLog(@"%f",[self.alipayAmountField.text doubleValue]);
        
        if([self.alipayAmountField.text doubleValue] > balance){
            [[RuYiCaiNetworkManager sharedManager] showMessage: @"可提现金额不足。" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
//        else {
//            [[RuYiCaiNetworkManager sharedManager] showMessage: @"最低提现金额小于10元需一次提清。" withTitle:@"提示" buttonTitle:@"确定"];
//            return NO;
//        }
    }
    else
    {
        if([self.alipayAmountField.text doubleValue] < 10)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最低提现不小于10元！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if([self.alipayAmountField.text doubleValue] > balance)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"提现金额不足！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    if([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString: kNormalLogin])
    {
        if(![[RuYiCaiNetworkManager sharedManager].password isEqualToString:self.alipayPassWordField.text])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"博雅彩账号登录密码不正确！" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    return YES;
}

- (void)setViewAngin
{
    m_curPageIndex = 0;
    startY = 0;
    
    [refreshView removeFromSuperview];
    [refreshView release];
    
    [m_getCashRecordScrollView removeFromSuperview];
    [m_getCashRecordScrollView release];
    
    m_getCashRecordScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, (int)[UIScreen mainScreen].bounds.size.height - 64 - 45)];
    m_getCashRecordScrollView.delegate = self;
    m_getCashRecordScrollView.contentSize = CGSizeMake(320, [UIScreen mainScreen].bounds.size.height - 105);
    [m_getCashRecordScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.getCashRecordScrollView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - 45, 320, REFRESH_HEADER_HEIGHT)];
    [self.getCashRecordScrollView addSubview:refreshView];
    refreshView.myScrollView = self.getCashRecordScrollView;
    [refreshView stopLoading:NO];
}

- (void)cancelGetCashOK:(NSNotification *)notification
{   
    [self setViewAngin];
    
    [[RuYiCaiNetworkManager sharedManager] queryRecordCash:[NSString stringWithFormat:@"%d", m_curPageIndex] maxResult:@"10"];
    //取消提现后 重新请求余额
    [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
    
}

#pragma mark RandomPickerDelegate

- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    [self.bankNameButton setTitle:[self.allBankName objectAtIndex:num] forState:UIControlStateNormal];
}

#pragma mark getCashRecord
- (void)getCashRecordInfor
{
    [[RuYiCaiNetworkManager sharedManager] queryRecordCash:@"0" maxResult:@"10"];
}

- (void)queryGetCashRecordOK:(NSNotification*)notification
{
    [self refreshRecordSubViews];
}

- (void)refreshRecordSubViews
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].queryRecordCashStr];
	NSString* totalPage = [parserDict objectForKey:@"totalPage"];
    m_totalPageCount = [totalPage intValue];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"result"];
    int nCurCount = [dict count];
    m_curPageSize = nCurCount;
    
    GetCashRecordView* m_subViewsArray[m_curPageSize];
    for (int i = 0; i < m_curPageSize; i++)
    {
        m_subViewsArray[i] = [[GetCashRecordView alloc] initWithFrame:CGRectZero];
        [self.getCashRecordScrollView addSubview:m_subViewsArray[i]];
        m_subViewsArray[i].hidden = YES;
    }
    for (int i = 0; i < m_curPageSize; i++)
        [m_subViewsArray[i] release];
    
    for (int i = 0; i < nCurCount; i++)
    {
        NSDictionary* subDict = (NSDictionary*)[dict objectAtIndex:i];
        m_subViewsArray[i].cashTime = KISDictionaryHaveKey(subDict, @"cashTime");
//        [subDict objectForKey:@"cashTime"];
        m_subViewsArray[i].amount = [NSString stringWithFormat:@"%0.2lf", [[subDict objectForKey:@"amount"] doubleValue]/100];
        m_subViewsArray[i].state = KISDictionaryHaveKey(subDict, @"state");
        m_subViewsArray[i].rejectReason = KISDictionaryHaveKey(subDict, @"rejectReason");
        m_subViewsArray[i].stateMemo = KISDictionaryHaveKey(subDict, @"stateMemo");
        m_subViewsArray[i].cashdetailid = KISDictionaryHaveKey(subDict, @"cashdetailid");
        
        m_subViewsArray[i].hidden = NO;
        m_subViewsArray[i].frame = CGRectMake(0, i * kLotWinDetailViewHeight + startY, 320, kLotWinDetailViewHeight);
        [m_subViewsArray[i] refreshView];
    }
    self.getCashRecordScrollView.contentSize = CGSizeMake(320, kLotWinDetailViewHeight * m_curPageSize + startY);
    
    startY = self.getCashRecordScrollView.contentSize.height;
    
    NSLog(@"cc %f", [UIScreen mainScreen].bounds.size.height - 64 - 45);
    centerY = self.getCashRecordScrollView.contentSize.height - (int)([UIScreen mainScreen].bounds.size.height - 64 - 45);
    
    m_curPageIndex++;
    
    if(m_curPageIndex == m_totalPageCount)
    {
        [refreshView stopLoading:YES];
    }
    else
    {
        [refreshView stopLoading:NO];
    }
    [refreshView setRefreshViewFrame];
}

- (void)bankTxBtnClick
{
    
    
    if (topButtonIndex!=0)
    {
        topButtonIndex=0;
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"提现"];
        self.newsCashScrollView.hidden = NO;
        self.alipayGetCashScrollView.hidden = YES;
        self.getCashRecordScrollView.hidden = YES;
        [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_highlight.png") forState:UIControlStateNormal];
        [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_highlight.png") forState:UIControlStateHighlighted];
        [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_normal.png") forState:UIControlStateNormal];
        [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_highlight.png") forState:UIControlStateHighlighted];
        [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_normal.png") forState:UIControlStateNormal];
        [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_highlight.png") forState:UIControlStateHighlighted];
    }
    
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"txyhkCardChargeDescription"];

    
}
- (void)alipayBtnClick
{
    

    if (topButtonIndex!=1)
    {
        
        if(bindState)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"由于您使用DNA充值已绑定了提现银行卡，故无法提现到支付宝账号" withTitle:@"提示" buttonTitle:@"确定"];
            [self.animationTabView buttonSelect:0];
            return;
        }else{
            
            [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"提现"];
            
            topButtonIndex=1;
            self.newsCashScrollView.hidden = YES;
            self.alipayGetCashScrollView.hidden = NO;
            self.getCashRecordScrollView.hidden = YES;
            [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_normal.png") forState:UIControlStateNormal];
            [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_highlight.png") forState:UIControlStateHighlighted];
            [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_highlight.png") forState:UIControlStateNormal];
            [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_highlight.png") forState:UIControlStateHighlighted];
            [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_normal.png") forState:UIControlStateNormal];
            [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_highlight.png") forState:UIControlStateHighlighted];
        }
        
        
    }
    
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"txzfbCardChargeDescription"];
    
}
- (void)txLogBtnClick
{
    if (topButtonIndex!=2)
    {
        topButtonIndex=2;
        self.navigationItem.rightBarButtonItem = nil;
        [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_normal.png") forState:UIControlStateNormal];
        [m_bankTxBtn setBackgroundImage:RYCImageNamed(@"bankTxBtn_highlight.png") forState:UIControlStateHighlighted];
        [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_normal.png") forState:UIControlStateNormal];
        [m_alipayBtn setBackgroundImage:RYCImageNamed(@"alipayTxBtn_highlight.png") forState:UIControlStateHighlighted];
        [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_highlight.png") forState:UIControlStateNormal];
        [m_txLogBtn setBackgroundImage:RYCImageNamed(@"txLogBtn_highlight.png") forState:UIControlStateHighlighted];
        
        if([CommonRecordStatus commonRecordStatusManager].isGetCashOK)//提现成功，刷新提现记录页面
        {
            [CommonRecordStatus commonRecordStatusManager].isGetCashOK = NO;
            
            [self setViewAngin];//进提现记录，刷新界面
            [self getCashRecordInfor];
            
            isFirstGetCashRecord = NO;
        }
        else
        {
            if(isFirstGetCashRecord)
            {
                isFirstGetCashRecord = !isFirstGetCashRecord;
                [self getCashRecordInfor];
            }
        }
        self.newsCashScrollView.hidden = YES;
        self.alipayGetCashScrollView.hidden = YES;
        self.getCashRecordScrollView.hidden = NO;
    }
}


#pragma mark tabButtonChange
- (void)tabButtonChanged:(NSNotification*)notification
{
    NSLog(@"tabButtonChanged~~~");
    [self hideKeyboard];//去掉键盘
    
    if(topButtonIndex == 0)
    {
        self.newsCashScrollView.hidden = NO;
        self.alipayGetCashScrollView.hidden = YES;
        self.getCashRecordScrollView.hidden = YES;
    }
    else if(topButtonIndex == 1)
    {
        if(bindState)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"由于您使用DNA充值已绑定了提现银行卡，故无法提现到支付宝账号" withTitle:@"提示" buttonTitle:@"确定"];
            [self.animationTabView buttonSelect:0];
            return;
        }
        self.newsCashScrollView.hidden = YES;
        self.alipayGetCashScrollView.hidden = NO;
        self.getCashRecordScrollView.hidden = YES;
    }
    else
    {
        if([CommonRecordStatus commonRecordStatusManager].isGetCashOK)//提现成功，刷新提现记录页面
        {
            [CommonRecordStatus commonRecordStatusManager].isGetCashOK = NO;
            
            [self setViewAngin];//进提现记录，刷新界面
            [self getCashRecordInfor];
            
            isFirstGetCashRecord = NO;
        }
        else
        {
            if(isFirstGetCashRecord)
            {
                isFirstGetCashRecord = !isFirstGetCashRecord;
                [self getCashRecordInfor];
            }
        }
        self.newsCashScrollView.hidden = YES;
        self.alipayGetCashScrollView.hidden = YES;
        self.getCashRecordScrollView.hidden = NO;
    }
}

- (void)getCashOK:(NSNotification *)notification
{
    [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
}

#pragma mark balance
- (void)queryUserBalanceOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    self.balanceLabel.text = [parserDict objectForKey:@"drawbalance"];
    
    self.canBalanceLable.text = [parserDict objectForKey:@"drawbalance"];
    
    NSString *balanceString = [parserDict objectForKey:@"drawbalance"];
    double balanceDouble = [balanceString doubleValue];
    
    if (balanceDouble <= 10.0) {
        self.amountTextField.text = [NSString stringWithFormat:@"%.2f",balanceDouble];
        self.alipayAmountField.text = [NSString stringWithFormat:@"%.2f",balanceDouble];
        [self.amountTextField setEnabled:NO];
        [self.alipayAmountField setEnabled:NO];
    }else{
        self.amountTextField.text = [NSString stringWithFormat:@"%@",@"10"];
        self.alipayAmountField.text = [NSString stringWithFormat:@"%@",@"10"];
        [self.amountTextField setEnabled:YES];
        [self.alipayAmountField setEnabled:YES];
    }
    
    [jsonParser release];
}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(m_curPageIndex == 0)
    {
        refreshView.viewMaxY = 0;
    }
    else
    {
        refreshView.viewMaxY = centerY;
    }
    [refreshView viewdidScroll:scrollView];
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [refreshView viewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [refreshView didEndDragging:scrollView];
}

- (void)startRefresh:(NSNotification *)notification
{
    NSLog(@"start");
    if(m_curPageIndex < m_totalPageCount)
    {
        [[RuYiCaiNetworkManager sharedManager] queryRecordCash:[NSString stringWithFormat:@"%d", m_curPageIndex] maxResult:@"10"];
    }
}

- (void)netFailed:(NSNotification*)notification
{
	[refreshView stopLoading:NO];
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    NSLog(@"gg %f",self.newsCashScrollView.center.y);
    NSLog(@"dd %f",self.alipayGetCashScrollView.center.y);
    if(!KISiPhone5)
    {
        if(self.newsCashScrollView.center.y != 275)
        {
            [UIView beginAnimations:@"movement" context:nil]; 
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationRepeatAutoreverses:NO];
            CGPoint center = self.newsCashScrollView.center;
            center.y += 85;
            self.newsCashScrollView.center = center;
            [UIView commitAnimations];
        }
        if(self.alipayGetCashScrollView.center.y != 275)
        {
            [UIView beginAnimations:@"movement" context:nil]; 
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationRepeatAutoreverses:NO];
            CGPoint center = self.alipayGetCashScrollView.center;
            center.y += 70;
            self.alipayGetCashScrollView.center = center;
            [UIView commitAnimations];
        }
    }
	return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"gg %f",self.newsCashScrollView.center.y);
    NSLog(@"dd %f",self.alipayGetCashScrollView.center.y);

    if(!KISiPhone5)
    {
        if(self.amountTextField == textField || self.passWordField == textField)
        {
            if(self.newsCashScrollView.center.y != 190)
            {
                [UIView beginAnimations:@"movement" context:nil]; 
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationRepeatAutoreverses:NO];
                CGPoint center = self.newsCashScrollView.center;
                center.y -= 85;
                self.newsCashScrollView.center = center;
                [UIView commitAnimations];
            }
        }
        if(self.alipayAmountField == textField || self.alipayPassWordField == textField)
        {
            if(self.alipayGetCashScrollView.center.y != 182.5)
            {
                [UIView beginAnimations:@"movement" context:nil]; 
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationRepeatAutoreverses:NO];
                CGPoint center = self.alipayGetCashScrollView.center;
                center.y -= 70;
                self.alipayGetCashScrollView.center = center;
                [UIView commitAnimations];
            }
        }
    }
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)bankTakeCashDescription:(NSNotification *)notification{
    
//下面是直接用服务器返回的，暂时写死...
   // NSString * string = notification.object;
    NSString * string = @"nothing";
//    NSLog(@"%@",string);
    
    if (topButtonIndex == 0) {
        string = @"1、单笔提现金额最少10元；可提现金额小于10元时，申请提现时，需要一次性提清。\r\n2、提现只能提到银行卡上，暂不支持信用卡提现。\r\n3、可提现金额只包含中奖所得金额，用户获赠的彩豆只能在软件内消费，不可提现。\r\n4、银行卡提现不收取手续费。用工商、农业、建设、招商银行的银行卡16：00前的提款申请:当天到账；16：00后的提款申请：第二天到账。使用其他银行卡的提现，到账时间加一天。如有疑问，请致电客服热线：4008561000\r\n5、单笔提现金额最高5万元。";
        if (string != nil && string.length != 0) {
            m_warnTextView.text = [string stringByReplacingOccurrencesOfString:@"线：4008561000" withString:@"\n线："];
            if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
                [self creatSevericeHotLine:CGRectMake(35, 188, 100, 25) title:@"400-856-1000" superView:self.m_warnTextView];
                
            }else{
                [self creatSevericeHotLine:CGRectMake(35, 203, 100, 25) title:@"400-856-1000" superView:self.m_warnTextView];
            }
        }
    }else if(topButtonIndex == 1){
        string = @"1、单笔提现金额最少10元；可提现金额小于10元时，申请提现时，需要一次性提清。\r\n2、可提现金额只包含中奖所得金额，用户获赠的彩豆只能在软件内消费，不可提现。\r\n3、单笔提现金额最高5万元。";
        if (string != nil && string.length != 0) {
            
            m_zfbTextView.text = string;

//            if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
//                [self creatSevericeHotLine:CGRectMake(35, 188, 100, 25) title:[string substringWithRange:NSMakeRange(string.length - 13, 12)] superView:self.m_zfbTextView];
//            }else{
//                
//                [self creatSevericeHotLine:CGRectMake(75, 203, 100, 25) title:[string substringWithRange:NSMakeRange(string.length - 13, 12)] superView:self.m_zfbTextView];
//            }
            
        }
    }
    
}


-(void)creatSevericeHotLine:(CGRect)rect title:(NSString *)title superView:(UITextView *)textView{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(callSevericeHotLine:) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:button];
}


-(void)callSevericeHotLine:(UIButton *)button{

    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceName = [device model];
    if([deviceName isEqualToString:@"iPad"] || [deviceName isEqualToString:@"iPod touch"]){
        
        [[RuYiCaiNetworkManager sharedManager]showMessage:@"当前设备没有打电话功能！" withTitle:@"提示" buttonTitle:@"确定"];
    }else{
        
        NSURL *phoneNumberURL = [NSURL URLWithString:@"telprompt://4008561000"];
        
        [[UIApplication sharedApplication] openURL:phoneNumberURL];
    }

}
@end