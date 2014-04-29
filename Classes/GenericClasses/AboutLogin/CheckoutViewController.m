//
//  CheckoutViewController.m
//  Boyacai
//
//  Created by wangxr on 14-4-22.
//
//

#import "CheckoutViewController.h"
#import "ColorUtils.h"
#import "RYCRegisterView.h"
#import "AgreementViewController.h"
#import "RuYiCaiNetworkManager.h"
@interface CheckoutViewController ()
@property (nonatomic,retain)UITextField* phoneNoTF;
@property (nonatomic,retain)UITextField* checkoutNoTF;
@end

@implementation CheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#f7f3ec"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkoutCaptchaOK:) name:@"WXRCheckoutCaptchaOK" object:nil];
	// Do any additional setup after loading the view.
    float h = 0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        h = 64;
    }
    else{
        h = 44;
    }
    UIImageView * navImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, h)];
    navImg.image = ({
        UIImage *image = [UIImage imageNamed: @"title_bg.png"];
        CGRect rectFrame=CGRectMake(0, 0 ,320,h);
        UIGraphicsBeginImageContext(rectFrame.size);
        [image drawInRect:rectFrame];
        UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        newImage;
    });
    [self.view addSubview:navImg];
    [navImg release];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(10, h-38, 52, 30);
    
    [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_normal.png"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_click.png"] forState:UIControlStateHighlighted];
    [registerButton setTitle:@"返回" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [registerButton addTarget:self action: @selector(cancelCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, h-39, 320, 30)];
    titleLabel.text = @"用户注册";
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView* imageC = [[UIImageView alloc] initWithFrame:CGRectMake(20, h+10, 280, 40)];
    imageC.image = [UIImage imageNamed:@"modelinfo_c_bg"];
    [self.view addSubview:imageC];
    [imageC release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, h+10, 100, 40)];
    nameLabel.text = @"手机号码";
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.textColor = [ColorUtils parseColorFromRGB:@"#b4b1ad"];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nameLabel];
    [nameLabel release];
    
    self.phoneNoTF = [[UITextField alloc] initWithFrame:CGRectMake(100, h+10, 190, 40)];
    _phoneNoTF.borderStyle = UITextBorderStyleNone;
    _phoneNoTF.font = [UIFont systemFontOfSize:15];
    _phoneNoTF.placeholder = @"请输入您的的手机号";
    _phoneNoTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneNoTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNoTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    _phoneNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNoTF.autocorrectionType = UITextAutocorrectionTypeNo;
    _phoneNoTF.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:_phoneNoTF];
    [_phoneNoTF release];
    
    UIImageView* imageD = [[UIImageView alloc] initWithFrame:CGRectMake(20, h+110, 280, 40)];
    imageD.image = [UIImage imageNamed:@"modelinfo_c_bg"];
    [self.view addSubview:imageD];
    [imageD release];
    
    UILabel *pswLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, h+110, 100, 40)];
    pswLabel.text = @"验 证 码";
    pswLabel.textAlignment = UITextAlignmentLeft;
    pswLabel.textColor =[ColorUtils parseColorFromRGB:@"#b4b1ad"];
    pswLabel.font = [UIFont boldSystemFontOfSize:15];
    pswLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pswLabel];
    [pswLabel release];
    
    self.checkoutNoTF = [[UITextField alloc] initWithFrame:CGRectMake(100, h+110, 190, 40)];
    _checkoutNoTF.borderStyle = UITextBorderStyleNone;
    _checkoutNoTF.font = [UIFont systemFontOfSize:15];
    _checkoutNoTF.placeholder = @"请输入验证码";
    _checkoutNoTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _checkoutNoTF.keyboardType = UIKeyboardTypeNumberPad;
    _checkoutNoTF.keyboardAppearance = UIKeyboardAppearanceAlert;
    _checkoutNoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _checkoutNoTF.autocorrectionType = UITextAutocorrectionTypeNo;
    _checkoutNoTF.returnKeyType = UIReturnKeyDone;
    _checkoutNoTF.secureTextEntry = YES;
    [self.view addSubview:_checkoutNoTF];
    [_checkoutNoTF release];
    
    UIButton * checkoutB = [UIButton buttonWithType:UIButtonTypeCustom];
    checkoutB.frame = CGRectMake(20, h+60, 280, 40);
    [self.view addSubview:checkoutB];
    [checkoutB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkoutB setBackgroundImage:[UIImage imageNamed:@"checkout"] forState:UIControlStateNormal];
    [checkoutB setTitle:@"发送验证码到手机" forState:UIControlStateNormal];
    [checkoutB addTarget:self action:@selector(getnumber:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * querenB = [UIButton buttonWithType:UIButtonTypeCustom];
    querenB.frame = CGRectMake(20, self.view.frame.size.height-200,280, 35);
    [querenB setTitle:@"确认" forState:UIControlStateNormal];
    [querenB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [querenB setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    [querenB addTarget:self action: @selector(CheckoutNo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:querenB];
    
    UIButton *proctoclButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [proctoclButton setTitle:@"《阅读并同意用户服务协议》" forState:UIControlStateNormal];
    [proctoclButton setTitleColor:[ColorUtils parseColorFromRGB:@"#0d5f85"] forState:UIControlStateNormal];
    proctoclButton.frame = CGRectMake(60,self.view.frame.size.height-240, 200, 40);
    proctoclButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [proctoclButton addTarget:self action:@selector(protocolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:proctoclButton];
    
    UIView  *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-100, 320, 50)];
    bottomView.backgroundColor = [ColorUtils parseColorFromRGB:@"#ebe7e1"];
    [self.view addSubview:bottomView];
    [bottomView release];
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(10 ,self.view.frame.size.height-100, 300, 80)];
    lable.numberOfLines = 0;
    lable.text = @"重要提示:\n手机号码是彩票兑换的重要依据,同时也是中奖后领取奖金的重要凭据,建议您如实填写.如果有因为手机号码错误造成的经济损失,后果自行承担.";
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont systemFontOfSize:12];
    lable.textColor =[ColorUtils parseColorFromRGB:@"#b4b1ad"];
    [self.view addSubview:lable];
    [lable release];
}

-(void)cancelCheck
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)protocolButtonClick:(id)sender
{
    AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
    agreementVC.navigationItem.title = @"用户服务协议";
    [self presentModalViewController:agreementVC animated:YES];
    [agreementVC release];
}
- (void)getnumber:(UIButton*)btn
{
    [_phoneNoTF resignFirstResponder];
    [_checkoutNoTF resignFirstResponder];
    NSString * str = [_phoneNoTF.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    if (str.length!=11) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"你造吗？手机号是11位的" delegate:nil cancelButtonTitle:@"我造了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [[RuYiCaiNetworkManager sharedManager] getCheckoutNoWithPhongNo:_phoneNoTF.text requestType:@"0"];
    btn.enabled =NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitle:@"60s之后可以重新发送" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDone:) userInfo:@{@"btn": btn} repeats:YES];
}
- (void)timeDone:(NSTimer*)timer
{
    UIButton* btn = timer.userInfo[@"btn"];
    if ([btn.titleLabel.text intValue] > 0) {
        [btn setTitle:[NSString stringWithFormat:@"%ds之后可以重新发送",[btn.titleLabel.text intValue]-1] forState:UIControlStateNormal];
    }else
    {
        btn.enabled =YES;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"发送验证码到手机" forState:UIControlStateNormal];
        if (timer != nil) {
            if( [timer isValid])
            {
                [timer invalidate];
            }
            timer = nil;
        }
    }
}
- (void)CheckoutNo
{
    [_phoneNoTF resignFirstResponder];
    [_checkoutNoTF resignFirstResponder];
    NSString * str1 = [_phoneNoTF.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    NSString * str2 = [_checkoutNoTF.text stringByReplacingOccurrencesOfString:@" "withString:@""];
    if (str1.length==0||str2.length ==0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"你造吗？手机号或验证码不能为空" delegate:nil cancelButtonTitle:@"我造了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [[RuYiCaiNetworkManager sharedManager] checkoutCaptchaNoWithPjoneNo:_phoneNoTF.text CaptchaNo:_checkoutNoTF.text];
    if (checkoutCaptcha) {
        [self checkoutCaptchaOK:nil];
    }
}
- (void)checkoutCaptchaOK:(NSNotification *)notification
{
    RYCRegisterView *checkoutView = [[RYCRegisterView alloc] init];
    checkoutView.phoneNo = _phoneNoTF.text;
    [self.navigationController pushViewController:checkoutView animated:YES];
    [checkoutView release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNoTF resignFirstResponder];
    [_checkoutNoTF resignFirstResponder];
}
@end
