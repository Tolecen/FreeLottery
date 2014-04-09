//
//  ChangeViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-8.
//
//

#import "ChangeViewController.h"
#import "BankCardPaymentViewController.h"
#import "PhoneCardPaymentViewController.h"
#import "AlipayPaymentViewController.h"
#import "ThirdPageTabelCellView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "SBJsonWriter.h"
#import "SBJsonParser.h"
#import "NSLog.h"
#import "UnionPayViewController.h"
#import "BaseHelpViewController.h"
//#import "AlipaySecurityPayViewController.h"
#import "bankChargeViewController.h"
#import "LaKaLaChargeViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
@interface ChangeViewController (internal)

//- (void)setTopView;
- (void)queryDNAOK:(NSNotification*)notification;

@end

@implementation ChangeViewController
@synthesize myTabelView = m_myTabelView;

- (void)dealloc
{
    [m_myTabelView release], m_myTabelView = nil;
        
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%@",@"充值中心页面加载");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryDNAOK" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDNAOK:) name:@"queryDNAOK" object:nil];
    
    [CommonRecordStatus commonRecordStatusManager].changeWay = 1;//余额不足时充值
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"充值中心";
    [AdaptationUtils adaptation:self];
    //返回按钮
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    m_didSelectRow = 0;
    
    m_myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    m_myTabelView.delegate = self;
    m_myTabelView.dataSource = self;
    m_myTabelView.rowHeight = 68;
    [m_myTabelView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:m_myTabelView];
}
- (void)queryDNAOK:(NSNotification*)notification
{
//    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    switch (m_didSelectRow)
    {
        case 0:
        {
//            AlipaySecurityPayViewController* viewController = [[AlipaySecurityPayViewController alloc] init];
//            viewController.title = @"支付宝充值";
//            [self.navigationController pushViewController:viewController animated:YES];
//            
//			[viewController release];
        }break;
        case 1:
        {
            AlipayPaymentViewController* viewController = [[AlipayPaymentViewController alloc] init];
            viewController.title = @"手机支付宝充值";
            [self.navigationController pushViewController:viewController animated:YES];
			[viewController release];
        }break;
        case 2:
        {
            UnionPayViewController* viewController = [[UnionPayViewController alloc] init];
            viewController.title = @"银联充值";
            [self.navigationController pushViewController:viewController animated:YES];
			[viewController release];
        }break;
        case 3:
        {
            BankCardPaymentViewController* viewController = [[BankCardPaymentViewController alloc] init];
            viewController.navigationItem.title = @"易联语音支付";
            [self.navigationController pushViewController:viewController animated:YES];
            
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
            NSString* bindState = [parserDict objectForKey:@"bindstate"];
            [jsonParser release];
            
            if ([bindState isEqualToString:@"0"])  //not bind，未绑定，但是曾经提交过信息，未交钱
            {
                viewController.bindName = [parserDict objectForKey:@"name"];
                viewController.bindBankCardNo = [parserDict objectForKey:@"bankcardno"];
                viewController.bindCertId = [parserDict objectForKey:@"certid"];
                viewController.bindDate = [parserDict objectForKey:@"binddate"];
                viewController.bindAddressName = [parserDict objectForKey:@"addressname"];
                viewController.bindBankAddress = [parserDict objectForKey:@"bankaddress"];
                viewController.bindPhonenum = [parserDict objectForKey:@"phonenum"];
                [viewController showBindStatus:NO];
            }
            else if ([bindState isEqualToString:@"1"])  //bind，绑定
            {
                viewController.bindName = [parserDict objectForKey:@"name"];
                viewController.bindBankCardNo = [parserDict objectForKey:@"bankcardno"];
                viewController.bindCertId = [parserDict objectForKey:@"certid"];
                viewController.bindDate = [parserDict objectForKey:@"binddate"];
                viewController.bindAddressName = [parserDict objectForKey:@"addressname"];
                viewController.bindBankAddress = [parserDict objectForKey:@"bankaddress"];
                viewController.bindPhonenum = [parserDict objectForKey:@"phonenum"];
                [viewController showBindStatus:YES];
            }
            else  //未绑定
            {
                viewController.bindName = [parserDict objectForKey:@"name"];
                viewController.bindBankCardNo = [parserDict objectForKey:@"bankcardno"];
                viewController.bindCertId = [parserDict objectForKey:@"certid"];
                viewController.bindDate = [parserDict objectForKey:@"binddate"];
                viewController.bindAddressName = [parserDict objectForKey:@"addressname"];
                viewController.bindBankAddress = [parserDict objectForKey:@"bankaddress"];
                viewController.bindPhonenum = [parserDict objectForKey:@"phonenum"];
                [viewController showBindStatus:NO];
            }
			[viewController release];
            
        }break;
            
        case 4:
        {
            LaKaLaChargeViewController* viewController = [[LaKaLaChargeViewController alloc] init];
            viewController.title = @"拉卡拉支付";
            [self.navigationController pushViewController:viewController animated:YES];
			[viewController release];
            
            
        }break;
            
        case 5:
        {
            bankChargeViewController* viewController = [[bankChargeViewController alloc] init];
            viewController.title = @"银行充值";
            [self.navigationController pushViewController:viewController animated:YES];
            
			[viewController release];
        }break;
        case 6:
        {
            [self setHidesBottomBarWhenPushed:YES];
            BaseHelpViewController* viewController = [[BaseHelpViewController alloc] init];
            viewController.title = @"银行转账";
            viewController.htmlFileName = @"ruyicai_zhuanzhang";
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController refresh];
			[viewController release];
        } break;
        case 7:
        {
            PhoneCardPaymentViewController* viewController = [[PhoneCardPaymentViewController alloc] init];
            viewController.title = @"手机充值卡充值";
            [self.navigationController pushViewController:viewController animated:YES];
            
			[viewController release];
        }break;
            
            
            
        default:
            break;
    }
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"cellIdentifier";
	ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell)
		cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    switch ([indexPath row])
    {
        case 0:
            cell.iconImageName = @"ico_c_bank.png";
            cell.titleName = @"易联语音支付(免手续费)";
            cell.littleTitleName = @"使用银联DNA手机支付，支持各大银行";
            break;
        case 1:
            cell.iconImageName = @"ico_c_phone.png";
            cell.titleName = @"手机充值卡充值";
            cell.littleTitleName = @"支持联通、移动、电信充值卡";
            break;
            
        default:
            break;
            
        /** 原版所有支付方式保留，现在将改为只有银联语音和手机充值的付款方式
        case 0:
            cell.iconImageName = @"ico_safeAlipay.png";
            cell.titleName = @"支付宝安全支付(免手续费)";
            cell.littleTitleName = @"安全快捷，免输入密码";
            break;
        case 1:
            cell.iconImageName = @"ico_zhifubao.png";
            cell.titleName = @"手机支付宝充值(免手续费)";
            cell.littleTitleName = @"支持借记卡和信用卡充值，免开通网银";
            break;
        case 2:
            cell.iconImageName = @"ico_unionbank.png";
            cell.titleName = @"银联充值(免手续费)";
            cell.littleTitleName = @"支持借记卡和信用卡充值，免开通网银";
            break;
        case 3:
            cell.iconImageName = @"ico_bank.png";
            cell.titleName = @"银联语音支付(免手续费)";
            cell.littleTitleName = @"使用银联DNA手机支付，支持各大银行";
            break;
            
        case 4:
            cell.iconImageName = @"lakala.png";
            cell.titleName = @"拉卡拉支付(免手续费)";
            cell.littleTitleName = @"支持所有银联卡，免开通网银，无限额";
            break;
            
        case 5:
            cell.iconImageName = @"ico_bankimg.png";
            cell.titleName = @"银行充值(免手续费)";
            cell.littleTitleName = @"根据您的银行卡选择适合的充值方式";
            break;
        case 6:
            cell.iconImageName = @"ico_zhuangzhang.png";
            cell.titleName = @"银行转账";
            cell.littleTitleName = @"通过银行柜台、ATM或者网上银行转账";
            break;
        case 7:
            cell.iconImageName = @"ico_phone.png";
            cell.titleName = @"手机充值卡充值";
            cell.littleTitleName = @"支持联通、移动、电信充值卡";
            break;
            
        default:
            break;
         
         */
    }
    [cell refresh];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_didSelectRow = [indexPath row];
    if([appStoreORnormal isEqualToString:@"appStore"] && [RuYiCaiNetworkManager sharedManager].isSafari)
    {
        if([[RuYiCaiNetworkManager sharedManager] testConnection])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kRuYiCaiCharge]];
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"检测不到网络" withTitle:@"提示" buttonTitle:@"确定"];
        }
    }
    else
    {
        if ([RuYiCaiNetworkManager sharedManager].hasLogin)
        {
            if (3 == m_didSelectRow)
            {
                [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_DNA;
                [[RuYiCaiNetworkManager sharedManager] queryDNA];
            }
            else
            {
                [self queryDNAOK:nil];
            }
        }
        else
        {
            [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_DNA;
            [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
