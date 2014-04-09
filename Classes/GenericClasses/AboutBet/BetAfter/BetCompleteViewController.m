//
//  BetCompleteViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-5-30.
//
//

#import "BetCompleteViewController.h"
#import "RuYiCaiCommon.h"
#import "MoreBetListTableViewCell.h"
#import "CommonRecordStatus.h"
#import "RuYiCaiLotDetail.h"
#import "RYCImageNamed.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"


@interface BetCompleteViewController ()

@end

@implementation BetCompleteViewController

@synthesize viewType;
@synthesize allAmount;

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
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backNotification" object:nil];
//    
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backNotification:) name:@"backNotification" object:nil];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    if(TYPE_LAUNCHHM == viewType)
        self.title = @"参与成功";
    else
        self.title = @"投注成功";
    self.view.backgroundColor = kColorWithRGB(248.0, 248.0, 248.0, 1.0);
    
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
//                                              initWithTitle:@"返回"
//                                              style:UIBarButtonItemStylePlain
//                                              target:self
//                                              action:@selector(backButtonClick)] autorelease];

    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(backButtonClick) andAutoPopView:NO];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
   
    if( viewType == TYPE_HM)
        titleLabel.text =  @"恭喜您，发起合买成功！";
    else if(TYPE_GIFT == viewType)
        titleLabel.text =  @"恭喜您，方案赠送成功！";
    else if(TYPE_LAUNCHHM == viewType)
        titleLabel.text =  @"恭喜您，参与合买成功！";
    else
        titleLabel.text =  @"恭喜您，方案发起成功！";
    
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = kColorWithRGB(204.0, 0.0, 0.0, 1.0);
//    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *lotLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 300, 30)];
    if(TYPE_GIFT == viewType)
    {
        lotLabel.frame = CGRectMake(20, 70, 300, 30);
    }
    lotLabel.text = [NSString stringWithFormat:@"彩种：%@", [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo]];
    lotLabel.textAlignment = UITextAlignmentLeft;
    lotLabel.textColor = kColorWithRGB(0.0, 0.0, 0.0, 1.0);
    lotLabel.font = [UIFont systemFontOfSize:16];
    lotLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lotLabel];
    [lotLabel release];
    
    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 50, 30)];
    if(TYPE_GIFT == viewType)
    {
        cLabel.frame = CGRectMake(20, 100, 300, 30);
    }
    cLabel.text =  @"金额：";
    cLabel.textAlignment = UITextAlignmentLeft;
    cLabel.textColor = kColorWithRGB(0.0, 0.0, 0.0, 1.0);
    cLabel.font = [UIFont systemFontOfSize:16];
    cLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cLabel];
    [cLabel release];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 120, 200, 30)];
    if(TYPE_GIFT == viewType)
    {
        moneyLabel.frame = CGRectMake(65, 100, 300, 30);
    }
    moneyLabel.text = self.allAmount;
    moneyLabel.textAlignment = UITextAlignmentLeft;
    moneyLabel.textColor = kColorWithRGB(204.0, 0.0, 0.0, 1.0);
    moneyLabel.font = [UIFont systemFontOfSize:16];
    moneyLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:moneyLabel];
    [moneyLabel release];
    
    if(TYPE_GIFT == viewType && ![[CommonRecordStatus commonRecordStatusManager].resultWarn isEqualToString:@"赠送成功"])
    {
        UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 300, 50)];
        warnLabel.text = [NSString stringWithFormat:@"提示：%@",[CommonRecordStatus commonRecordStatusManager].resultWarn];
        warnLabel.textAlignment = UITextAlignmentLeft;
        warnLabel.numberOfLines = 2;
        warnLabel.textColor = kColorWithRGB(204.0, 0.0, 0.0, 1.0);
        warnLabel.font = [UIFont systemFontOfSize:16];
        warnLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:warnLabel];
        [warnLabel release];
    }
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(75, 170, 170, 41);
    [backButton setBackgroundImage:[UIImage imageNamed:@"button_bg_normal.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"button_bg_click.png"] forState:UIControlStateHighlighted];
  
    if(TYPE_LAUNCHHM == viewType)
        [backButton setTitle:@"返回合买大厅" forState:UIControlStateNormal];
    else
        [backButton setTitle:@"返回投注" forState:UIControlStateNormal];

    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [backButton setBackgroundImage:RYCImageNamed(@"longred_button_normal.png") forState:UIControlStateNormal];
//    [backButton setBackgroundImage:RYCImageNamed(@"longred_button_click.png") forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    [backButton addTarget:self action: @selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton release];

//    if ([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoSSQ] && [[RuYiCaiNetworkManager sharedManager].bindEmail isEqualToString:@""] && !(TYPE_LAUNCHHM == viewType)) {
//        [self notBindEmailView];
//    }
}

- (void)backButtonClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    if (TYPE_LAUNCHHM == self.viewType) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCurPage" object:nil];
    }
}

- (void)notBindEmailView
{
    UIImageView* bgImage = tableBgImage(CGRectMake(9, 230, 302, 12), CGRectMake(9, 242, 302, 20), CGRectZero);
    [self.view addSubview:bgImage];
    
    UIImageView *image_sanjiao = [[UIImageView alloc] initWithFrame:CGRectMake(295, 245, 10, 14)];
    image_sanjiao.image = RYCImageNamed(@"sanjiao.png");
    [self.view addSubview:image_sanjiao];
    image_sanjiao.alpha = 0.7;
    [image_sanjiao release];
    
    UIButton* goToEmailButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 230, 285, 44)];
    [goToEmailButton setTitle:@"将此方案内容发送到邮箱" forState:UIControlStateNormal];
    [goToEmailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goToEmailButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [goToEmailButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [goToEmailButton addTarget:self action:@selector(goToBindEmailView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goToEmailButton];
    [goToEmailButton release];
}

- (void)goToBindEmailView:(id)sender
{
//    [self setHidesBottomBarWhenPushed:YES];
//    BindEmailViewController *viewController = [[BindEmailViewController alloc] init];
//        
//    viewController.navigationItem.title = @"邮箱绑定";
//    viewController.isBindEmail = NO;
//  
//    viewController.lotNo = [RuYiCaiLotDetail sharedObject].lotNo;
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
