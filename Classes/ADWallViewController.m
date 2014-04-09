//
//  ADWallViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-2-28.
//
//

#import "ADWallViewController.h"
#import "RYCImageNamed.h"
@interface ADWallViewController ()

@end

@implementation ADWallViewController
@synthesize adView_adWall;
@synthesize adWallType;
@synthesize backBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        theUserID = @"123344";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIImageView * titleBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [titleBG setBackgroundColor:[UIColor whiteColor]];
//    [titleBG setImage:[UIImage imageNamed:@"title_bg"]];
//    [self.view addSubview:titleBG];
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0.0, 0.0, 52, 30);
//    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_normal.png") forState:UIControlStateNormal];
//    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_click.png") forState:UIControlStateHighlighted];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    

    
    if (self.adWallType==ADWallTypeLiMei) {
        [self enterLiMeiAdWall];
    }
    

	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0.0, 0.0, 52, 40);
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
}
-(void)enterLiMeiAdWall{
    // 实例化 immobView 对象,在此处替换在力美广告平台申请到的广告位 ID;
    self.adView_adWall=[[immobView alloc] initWithAdUnitID:LiMeiAdID];
    //添加 immobView 的 Delegate;
    self.adView_adWall.delegate=self;
    //添加 userAccount 属性,此属性针对多账户应用所使用,用于区分不同账户下的积分(可选)。
    [self.adView_adWall.UserAttribute setObject:theUserID forKey:@"accountname"];
    //开始加载广告。
    [self.adView_adWall immobViewRequest];
}
// 设置必需的 UIViewController, 此方法的返回值如果为空,会导致广告展示不正常。
- (UIViewController *)immobViewController{ return self;
}
- (void) immobViewDidReceiveAd:(immobView*)immobView {
    //将 immobView 添加到界面上。
    [self.view addSubview:adView_adWall];
    //将 immobView 添加到界面后,调用 immobViewDisplay。
    [self.adView_adWall immobViewDisplay];
}

-(void)QueryScore{
    [self.adView_adWall immobViewQueryScoreWithAdUnitID:LiMeiAdID WithAccountID:theUserID];
}
// 查询积分回调
-(void)immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message{ UIAlertView *uA=[[UIAlertView alloc] initWithTitle:@"积分查询" message: ![message
                                                                                                                                                    isEqualToString:@""]?[NSString stringWithFormat:@"%@",message]:[NSString stringWithFormat:@"当前积分 为:%i",score] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    [uA show];
    [uA release];
}
-(void)ReduceScore{
    [self.adView_adWall immobViewReduceScore:99 WithAdUnitID:LiMeiAdID WithAccountID:theUserID];
}
// 减少积分回调
-(void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message{
    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:status?@"积分减少成功":@"积分减少失败"
                                               message: status?@"":[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"YES"
                                     otherButtonTitles:nil, nil]; [uA show];
    [uA release];
}
- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode{
    
}
// email 账号未设置。
- (void) emailNotSetupForAd:(immobView *)immobView{
    
}

-(void)backAction
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
