//
//  NotEnoughMoneyViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-5-29.
//
//

#import "NotEnoughMoneyViewController.h"
#import "RuYiCaiCommon.h"
#import "ChangeViewController.h"
#import "DirectPaymentViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"

//#import "LiMeiAdViewController.h"

@interface NotEnoughMoneyViewController ()

@end

@implementation NotEnoughMoneyViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.title = @"温馨提示";
    
    UILabel *lotLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 300, 30)];
    lotLabel.text = [NSString stringWithFormat:@"彩种：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo]];
    lotLabel.textAlignment = UITextAlignmentLeft;
    lotLabel.textColor = kColorWithRGB(0.0, 0.0, 0.0, 1.0);
    lotLabel.font = [UIFont systemFontOfSize:16];
    lotLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lotLabel];
    [lotLabel release];
    
    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 50, 30)];
    cLabel.text =  @"金额：";
    cLabel.textAlignment = UITextAlignmentLeft;
    cLabel.textColor = kColorWithRGB(0.0, 0.0, 0.0, 1.0);
    cLabel.font = [UIFont systemFontOfSize:16];
    cLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cLabel];
    [cLabel release];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 50, 200, 30)];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    moneyLabel.text = [NSString stringWithFormat:@"%d彩豆",[[RuYiCaiLotDetail sharedObject].amount intValue]/100*aas];
    moneyLabel.textAlignment = UITextAlignmentLeft;
    moneyLabel.textColor = kColorWithRGB(204.0, 0.0, 0.0, 1.0);
    moneyLabel.font = [UIFont systemFontOfSize:16];
    moneyLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:moneyLabel];
    [moneyLabel release];    
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 280, 90)];
    warnLabel.text = @"尊敬的用户，您的账户余额不足以支付本次购买，请选择充值或者直接支付两种方式完成本次购买操作！";
    warnLabel.numberOfLines = 3;
    warnLabel.textAlignment = UITextAlignmentLeft;
    warnLabel.textColor = kColorWithRGB(0.0, 0.0, 0.0, 1.0);
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:warnLabel];
    [warnLabel release];
    
    UIButton *mfButton = [[UIButton alloc] init];
    mfButton.frame = CGRectMake(70, [UIScreen mainScreen].bounds.size.height - 64 - 120, 180, 35);
    [mfButton setTitle:@"做任务,免费获取彩金" forState:UIControlStateNormal];
    [mfButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    mfButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [mfButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_normal.png"] forState: UIControlStateNormal];
    [mfButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_click.png"] forState: UIControlStateHighlighted];
    [mfButton addTarget:self action: @selector(mfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mfButton];
    [mfButton release];

    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 64 - 80, 480, 80)];
    imageBg.image = RYCImageNamed(@"golottery_bg.png");
    [self.view addSubview:imageBg];
    [imageBg release];
    
    UIButton *zfButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zfButton.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 64 - 70, 120, 35);
    [zfButton setTitle:@"直接支付" forState:UIControlStateNormal];
    [zfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zfButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [zfButton setBackgroundImage:[UIImage imageNamed:@"redbg.png"] forState: UIControlStateNormal];
    [zfButton setBackgroundImage:[UIImage imageNamed:@"redbg_click.png"] forState: UIControlStateHighlighted];
    [zfButton addTarget:self action: @selector(zfButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zfButton];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    changeButton.frame = CGRectMake(180, [UIScreen mainScreen].bounds.size.height - 64 - 70, 120, 35);
    [changeButton setTitle:@"充值" forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeButton.titleLabel.font = [UIFont boldSystemFontOfSize: 16];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"redbg.png"] forState: UIControlStateNormal];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"redbg_click.png"] forState: UIControlStateHighlighted];
    [changeButton addTarget:self action: @selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 64 - 35, 300, 30)];
    bottomLabel.text = @"(使用支付宝直接支付)           (选择多种方式给账户充值)";
    bottomLabel.textAlignment = UITextAlignmentLeft;
    bottomLabel.textColor = kColorWithRGB(102.0, 102.0, 102.0, 1.0);
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomLabel];
    [bottomLabel release];


}

- (void)mfButtonClick:(id)sender
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
        [self setHidesBottomBarWhenPushed:YES];
//        LiMeiAdViewController* viewController = [[LiMeiAdViewController alloc] init];
//        viewController.title = @"免费获取彩金";
//        [self.navigationController pushViewController:viewController animated:YES];
//        [viewController release];
    }
}

- (void)zfButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];

    DirectPaymentViewController* viewController = [[DirectPaymentViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)changeButtonClick:(id)sender
{
    [self setHidesBottomBarWhenPushed:YES];

    ChangeViewController* viewController = [[ChangeViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
