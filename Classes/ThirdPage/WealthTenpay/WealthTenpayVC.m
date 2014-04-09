//
//  UmpayCreditCardVC.m
//  Boyacai
//
//  Created by qiushi on 13-6-3.
//
//

#import "WealthTenpayVC.h"
#import "RightBarButtonItemUtils.h"
#import "BackBarButtonItemUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "RuYiCaiNetworkManager.h"
#import "SBJsonParser.h"
#import "WealthTenpayWapView.h"
#import "AdaptationUtils.h"

#define id_tfield_tradeNo 101

#define id_btn_pay 104


@interface WealthTenpayVC ()

@end

@implementation WealthTenpayVC

@synthesize amountTextField = m_amountTextField;
@synthesize ipAdressStr     = m_ipAdressStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chargeByWealthTenpayOK:) name:@"chargeByWealthTenpayOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryChargeWarnStrOK:) name:@"queryChargeWarnStrOK" object:nil];
    
}

- (void)dealloc
{
    [m_amountTextField release];
    [m_ipAdressStr release];
    self.lotNo = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
	// Do any additional setup after loading the view.
    
    if ([self.lotNo isEqualToString:kLotNoNMK3]) {
        
        //快三返回按钮
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
        
        //右按钮
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"确定" normalColor:@"#74061f" higheColor:@"#4f0415"];
    }else{
        
        [BackBarButtonItemUtils addBackButtonForController:self];
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"确定"];
    }
    
    [self setMainView];
    
    [RuYiCaiNetworkManager sharedManager].netChargeQuestType = NET_QUERY_CHARGE_WARN;
    [[RuYiCaiNetworkManager sharedManager] queryChargeWarnStr:@"zftczChargeDescription"];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chargeByWealthTenpayOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryChargeWarnStrOK" object:nil];
    [super viewWillDisappear:animated];
}


- (void)setMainView
{
    //    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 12)];
    //    image_topbg.image = RYCImageNamed(@"croner_top.png");
    //    [self.view addSubview:image_topbg];
    //    [image_topbg release];
    //
    //    UIImageView *image_midbg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 22, 302, 161)];
    //    image_midbg.image = RYCImageNamed(@"croner_middle.png");
    //    [self.view addSubview:image_midbg];
    //    [image_midbg release];
    
    UILabel *bLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 20)];
    bLabel.textAlignment = UITextAlignmentLeft;
    bLabel.text = @"请输入您的充值金额(整数)：";
    [bLabel setTextColor:[UIColor blackColor]];
    bLabel.backgroundColor = [UIColor clearColor];
    bLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bLabel];
    [bLabel release];
    
    m_amountTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 250, 35)];
    m_amountTextField.borderStyle = UITextBorderStyleBezel;
    //m_amountTextField.delegate = self;
    //    m_amountTextField.placeholder = @"请输入金额";
    m_amountTextField.text = @"100";
    m_amountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_amountTextField.keyboardType = UIKeyboardTypeNumberPad;
    m_amountTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_amountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_amountTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_amountTextField.returnKeyType = UIReturnKeyDone;
    [m_amountTextField setFont:[UIFont systemFontOfSize:17]];
    m_amountTextField.textColor = [UIColor redColor];
    [self.view addSubview:m_amountTextField];
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 40, 30, 35)];
    aLabel.textAlignment = UITextAlignmentLeft;
    aLabel.text = @"元";
    //[aLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [aLabel setTextColor:[UIColor redColor]];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:aLabel];
    [aLabel release];
    
    //    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 90, 302, 2)];
    //    lineView.image = RYCImageNamed(@"croner_line.png");
    //    [self.view addSubview:lineView];
    //    [lineView release];
    
    //    UIImageView *bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9, 183, 302, 12)];
    //    bottombg.image = RYCImageNamed(@"croner_bottom.png");
    //    [self.view addSubview:bottombg];
    //    [bottombg release];
//   [self getPublicIP];
}

- (void *)getPublicIP{

    
    NSURL *iPURL = [NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"];
    
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
        if (!error) {
            NSScanner *theScanner;
            NSString *text = nil;
            
            theScanner = [NSScanner scannerWithString:theIpHtml];
            
            while ([theScanner isAtEnd] == NO) {
                
                // find start of tag
                [theScanner scanUpToString:@"<" intoString:NULL] ;
                
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                theIpHtml = [theIpHtml stringByReplacingOccurrencesOfString:
                             [ NSString stringWithFormat:@"%@>", text]
                                                                 withString:@" "] ;
                ipItemsArray =[theIpHtml  componentsSeparatedByString:@" "];
                an_Integer=[ipItemsArray indexOfObject:@"Address:"];
                
                externalIP =[ipItemsArray objectAtIndex:  ++an_Integer];
                
                
                
            } 
            
            NSLog(@"externalIP%@",externalIP);
            self.ipAdressStr = externalIP;
        } else {
            NSLog(@"Oops... g %d, %@", 
                  [error code], 
                  [error localizedDescription]);
        }
    }
    
    
    
    
    return 0;
}

- (void)okClick
{
    [self.amountTextField resignFirstResponder];
    
    if (0 == self.amountTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入充值金额！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    for (int i = 0; i < self.amountTextField.text.length; i++)
    {
        UniChar chr = [self.amountTextField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额填写不规范！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额须为数字！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    if (self.amountTextField.text.length > 5)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"充值金额最高5位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"recharge" forKey:@"command"];
    [dict setObject:@"13" forKey:@"rechargetype"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phoneSIM"];
    [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
    if (self.ipAdressStr)
    {
       [dict setObject:self.ipAdressStr forKey:@"clientip"]; 
    }else
    {
        
    }
    
    NSString* amtValue = [NSString stringWithFormat:@"%d", [self.amountTextField.text intValue]*100];
    [dict setObject:amtValue  forKey:@"amount"];
    [[RuYiCaiNetworkManager sharedManager] wealthTenpayFor:dict];
    
}

- (void)chargeByWealthTenpayOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    NSString* errorCode = [parserDict objectForKey:@"error_code"];
    NSString* message = [parserDict objectForKey:@"message"];
//    NSString* transation_id = [parserDict objectForKey:@"transation_id"];
    NSString* return_url    = [parserDict objectForKey:@"return_url"];
    [jsonParser release];
    if (![errorCode isEqualToString:@"0000"])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    [self setHidesBottomBarWhenPushed:YES];
    WealthTenpayWapView* viewController = [[WealthTenpayWapView alloc] init];
    if (self.lotNo != nil) {
        viewController.lotNo = kLotNoNMK3;
    }
    viewController.title = @"财付通充值";
    viewController.wealthUrl = return_url;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.amountTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryChargeWarnStrOK:(NSNotification*)notifition
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].chargeWarnStr];
    NSString* contentStr = [parserDict objectForKey:@"content"];
    [jsonParser release];
    
    UITextView*    warnView = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 280, [UIScreen mainScreen].bounds.size.height - 150)];
    warnView.text = contentStr;
    [warnView setTextColor:[UIColor grayColor]];
    [warnView setFont:[UIFont systemFontOfSize:14.0f]];
    [warnView setBackgroundColor:[UIColor clearColor]];
    warnView.scrollEnabled = YES;
    warnView.editable = NO;
    [self.view addSubview:warnView];
    [warnView release];
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
