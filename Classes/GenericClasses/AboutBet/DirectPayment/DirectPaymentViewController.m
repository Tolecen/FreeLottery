//
//  DirectPaymentViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-8.
//
//

#import "DirectPaymentViewController.h"
#import "CommonRecordStatus.h"
#import "ThirdPageTabelCellView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "AlipayPayWapView.h"
#import "RuYiCaiLotDetail.h"
#import "AdaptationUtils.h"
//#import "AlixPay.h"

@interface DirectPaymentViewController ()

- (void)querySecurityAlipayOK:(NSNotification*)notifition;

- (void)queryAlipayOK:(NSNotification*)notification;
- (void)backNotification:(NSNotification*)notification;

@end

@implementation DirectPaymentViewController
@synthesize myTabelView = m_myTabelView;

- (void)dealloc
{
    [m_myTabelView release], m_myTabelView = nil;
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySecurityAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backNotification" object:nil];

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySecurityAlipayOK:) name:@"querySecurityAlipayOK" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryAlipayOK:) name:@"queryAlipayOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotification:) name:@"backNotification" object:nil];

    [CommonRecordStatus commonRecordStatusManager].changeWay = 2;//余额不足时直接支付
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"支付中心";
    
    m_myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    m_myTabelView.delegate = self;
    m_myTabelView.dataSource = self;
    m_myTabelView.rowHeight = 68;
    [m_myTabelView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:m_myTabelView];
}

#pragma mark 支付宝安全支付
- (void)querySecurityAlipayOK:(NSNotification*)notifition
{
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
//    NSString* errorCode = [parserDict objectForKey:@"error_code"];
//    NSString* message = [parserDict objectForKey:@"message"];
//    [jsonParser release];
//    if ([errorCode isEqualToString:@"0000"])
//    {
//        NSString* orderString = [parserDict objectForKey:@"value"];
//        NSString *appScheme = [[CommonRecordStatus commonRecordStatusManager] getAppScheme:KAppScheme_Alipay];
//        
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
            NSString * URLString = [NSString stringWithFormat:@"%@", @"http://itunes.apple.com/cn/app/id333206289?mt=8"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
        }
	}
}


#pragma mark 手机支付宝支付
- (void)queryAlipayOK:(NSNotification*)notification
{
    AlipayPayWapView* viewController = [[AlipayPayWapView alloc] init];
    viewController.title = @"支付宝充值";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)backNotification:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
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
            cell.iconImageName = @"ico_safeAlipay.png";
            cell.titleName = @"支付宝安全支付(免手续费)";
            cell.littleTitleName = @"安全快捷，免输入密码";
            break;
        case 1:
            cell.iconImageName = @"ico_zhifubao.png";
            cell.titleName = @"手机支付宝充值(免手续费)";
            cell.littleTitleName = @"支持借记卡和信用卡充值，免开通网银";
            break;
        default:
            break;
    }
    [cell refresh];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        if(indexPath.row == 0)
        {
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
            [dict setObject:@"betLot" forKey:@"command"];
            [dict setObject:@"saveorder" forKey:@"bettype"];
            
            [dict setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].lotMulti forKey:@"lotmulti"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].oneAmount forKey:@"oneAmount"];
            [dict setObject:@"1" forKey:@"isSellWays"];

            [dict setObject:@"07" forKey:@"rechargetype"];
            [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
            [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
//            [dict setObject:@"" forKey:@"subchannel"];
            [dict setObject:@"0300" forKey:@"cardtype"];
            [[RuYiCaiNetworkManager sharedManager] chargeBySecurityAlipay:dict];
        }
        else if(indexPath.row == 1)
        {
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
            [dict setObject:@"betLot" forKey:@"command"];
            [dict setObject:@"saveorder" forKey:@"bettype"];            
            
            [dict setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].lotMulti forKey:@"lotmulti"];
            [dict setObject:[RuYiCaiLotDetail sharedObject].oneAmount forKey:@"oneAmount"];
            [dict setObject:@"1" forKey:@"isSellWays"];

            [dict setObject:@"05" forKey:@"rechargetype"];
            [dict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
            [dict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
            [dict setObject:@"0300" forKey:@"cardtype"];
//            [dict setObject:@"" forKey:@"subchannel"];
          
//            NSLog(@"ddd %@", dict);
            [[RuYiCaiNetworkManager sharedManager] chargeByAlipay:dict];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
