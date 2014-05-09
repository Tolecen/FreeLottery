//
//  BindeUserAccountVC.m
//  Boyacai
//
//  Created by qiushi on 13-11-13.
//
//

#import "BindeUserAccountVC.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
#import "AgreementViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "CommonRecordStatus.h"

@interface BindeUserAccountVC ()

@end

@implementation BindeUserAccountVC

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
    // Do any additional setup after loading the view from its nib.
    [AdaptationUtils adaptation:self];
    [self.view setBackgroundColor:[ColorUtils parseColorFromRGB:@"#f7f3ec"]];
    
    //默认没有全民免费彩票账号的为选中状态
    _noAlreadyButton.selected = YES;
    _alreadyButton.selected = NO;
    [_loginUserView setHidden:YES];
    [_registerUserView setHidden:NO];
    [self setNavView];
    
    
    //输入框的代理设置
    _alreadyNameTextField.delegate = self;
    _alreadyPsdTextField.delegate = self;
    _registerNameTextField.delegate = self;
    _registerPsdTextField.delegate = self;
    _surePsdTextField.delegate = self;
    
    //注册通知
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdLoginRegisterOk:) name:@"thirdLoginRegisterOk" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserNoOk:) name:@"getUserNoOk" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thirdLoginBindOk:) name:@"thirdLoginBindOk" object:nil];
    
    UIButton *proctoclButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [proctoclButton setTitle:@"《阅读并同意用户服务协议》" forState:UIControlStateNormal];
    [proctoclButton setTitleColor:[ColorUtils parseColorFromRGB:@"#0d5f85"] forState:UIControlStateNormal];
    if (KISiPhone5)
    {
        proctoclButton.frame = CGRectMake(60,[UIScreen mainScreen].bounds.size.height-200, 200, 40);
    }else
    {
        proctoclButton.frame = CGRectMake(60,[UIScreen mainScreen].bounds.size.height-160, 200, 40);
    }
    
    proctoclButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [proctoclButton addTarget:self action:@selector(protocolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:proctoclButton];
    
    
    _bindUseButton = [[CustomColorButtonUtils alloc] initWithSize:CGSizeMake(280, 35) normalColor:@"#c80000" higheColor:@"#820000"];
    
    if (KISiPhone5)
    {
        _bindUseButton.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-160,280, 35);
    }else
    {
        _bindUseButton.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height-120,280, 35);
    }
    
    [_bindUseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bindUseButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_bindUseButton setTitle:@"确定并绑定账号" forState:UIControlStateNormal];
    [_bindUseButton addTarget:self action: @selector(sureBindUseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bindUseButton];
    
    
    UILabel *serviceLable = [[UILabel alloc] initWithFrame:CGRectMake(60, [UIScreen mainScreen].bounds.size.height-80, 80, 40)];
    serviceLable.text = @"客服热线:";
    serviceLable.textColor = [ColorUtils parseColorFromRGB:@"#7a746b"];
    serviceLable.font = [UIFont systemFontOfSize:15];
    serviceLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:serviceLable];
    [serviceLable release];
    UIButton *serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    serviceButton.frame = CGRectMake(130, [UIScreen mainScreen].bounds.size.height-80, 120, 40);
    [serviceButton setTitle:@"400-856-1000" forState:UIControlStateNormal];
    serviceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [serviceButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [serviceButton addTarget:self action:@selector(serviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceButton];
    
}
- (void)setNavView
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statView];
        [statView release];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIImageView  *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        navImageView.image = [UIImage imageNamed:@"title_bg.png"];
        [self.view insertSubview:navImageView atIndex:100];
        [navImageView release];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 30)];
        titleLabel.text = @"用户登录";
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.backgroundColor = [UIColor clearColor];
        //    titleLabel.tag =
        [self.view addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        goBackButton.frame = CGRectMake(10, 26, 52, 30);
        
        [goBackButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_normal.png"] forState:UIControlStateNormal];
        [goBackButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_click.png"] forState:UIControlStateHighlighted];
        [goBackButton setTitle:@"返回" forState:UIControlStateNormal];
        goBackButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [goBackButton addTarget:self action: @selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:goBackButton];
    }else
    {
        UIImageView  *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        navImageView.image = [UIImage imageNamed:@"title_bg.png"];
        [self.view insertSubview:navImageView atIndex:100];
        [navImageView release];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 30)];
        titleLabel.text = @"用户登录";
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.backgroundColor = [UIColor clearColor];
        //    titleLabel.tag =
        [self.view addSubview:titleLabel];
        [titleLabel release];
        
        UIButton *goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        goBackButton.frame = CGRectMake(10, 6, 52, 30);
        
        [goBackButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_normal.png"] forState:UIControlStateNormal];
        [goBackButton setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_click.png"] forState:UIControlStateHighlighted];
        [goBackButton setTitle:@"返回" forState:UIControlStateNormal];
        goBackButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [goBackButton addTarget:self action: @selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:goBackButton];
    }
    
    

}

- (void)protocolButtonClick:(id)sender
{
    AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
    agreementVC.navigationItem.title = @"用户服务协议";
    [self presentModalViewController:agreementVC animated:YES];
    [agreementVC release];
}

- (void)bindUseButtonClick
{
    [_bindUseButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    [_alreadyNameTextField resignFirstResponder];
    [_alreadyPsdTextField resignFirstResponder];
    
    if (0 == _alreadyNameTextField.text.length || 0 == _alreadyPsdTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"用户名或密码不能为空！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (_alreadyPsdTextField.text.length < 6 || _alreadyPsdTextField.text.length > 16)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码长度为6~16位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    //    [MobClick event:@"loginPage_login"];
    
    [RuYiCaiNetworkManager sharedManager].phonenum = _alreadyNameTextField.text;
    [RuYiCaiNetworkManager sharedManager].password = _alreadyPsdTextField.text;
    
    [[RuYiCaiNetworkManager sharedManager] selectUsernoWithPhonenum:_alreadyNameTextField.text withPassword:_alreadyPsdTextField.text];
}
- (void)sureBindUseButtonClick
{
    NSLog(@"确定并绑定账号");
    [_bindUseButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    if (0 == _registerNameTextField.text.length
        || 0 == _registerPsdTextField.text.length
        || 0 == _surePsdTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"有注册项未填,请输入！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    //注册手机号码为11位
    if (11 != _registerNameTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"注册手机号码为11位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    if (![phoneTest evaluateWithObject:_registerNameTextField.text]) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入正确的手机号" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    NSString *passwordRegex = @"^[^%&’,;=?$\\^]+$";
    NSPredicate *passwordCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    if (![passwordCardTest evaluateWithObject:_registerPsdTextField.text]) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码不能包含特殊字符" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    if (_registerPsdTextField.text.length < 6 || _registerPsdTextField.text.length > 16)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码长度为6~16位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if(![_registerPsdTextField.text isEqualToString:_surePsdTextField.text])
	{
		[[RuYiCaiNetworkManager sharedManager] showMessage:@"确认密码有误，请重新输入！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
	}
    if ([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString:kQQLogin])
    {
        [[RuYiCaiNetworkManager sharedManager] thirdRegisterWithPhonenum:_registerNameTextField.text withPassword:_registerPsdTextField.text withOpenId:[RuYiCaiNetworkManager sharedManager].thirdOpenId withSource:@"qq"];
    }else if ([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString:kXLWeiBoLogin]){
    [[RuYiCaiNetworkManager sharedManager] thirdRegisterWithPhonenum:_registerNameTextField.text withPassword:_registerPsdTextField.text withOpenId:[RuYiCaiNetworkManager sharedManager].thirdOpenId withSource:@"sina"];
    }
    
}
//电话按钮事件
- (void)serviceBtnClick
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceName = [device model];
    if([deviceName isEqualToString:@"iPad"] || [deviceName isEqualToString:@"iPod touch"])
    {
        [[RuYiCaiNetworkManager sharedManager]showMessage:@"当前设备没有打电话功能！" withTitle:@"提示" buttonTitle:@"确定"];
    }else
    {
        NSURL *phoneNumberURL = [NSURL URLWithString:@"telprompt://4008561000"];
        
        [[UIApplication sharedApplication] openURL:phoneNumberURL];
    }
}

- (IBAction)alreadyButtonClick:(id)sender
{
//更新视图状态
    _alreadyButton.selected = YES;
    _noAlreadyButton.selected = NO;
    [_loginUserView setHidden:NO];
    [_registerUserView setHidden:YES];
    
    [_bindUseButton removeTarget:self action:@selector(sureBindUseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bindUseButton setTitle:@"绑定账号" forState:UIControlStateNormal];
    [_bindUseButton addTarget:self action: @selector(bindUseButtonClick) forControlEvents:UIControlEventTouchUpInside];

}
- (IBAction)noAlreadyButtonClick:(id)sender
{
    //更新视图状态
    _alreadyButton.selected = NO;
    _noAlreadyButton.selected = YES;
    [_loginUserView setHidden:YES];
    [_registerUserView setHidden:NO];
    [_bindUseButton removeTarget:self action:@selector(bindUseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bindUseButton setTitle:@"确定并绑定账号" forState:UIControlStateNormal];
    [_bindUseButton addTarget:self action: @selector(sureBindUseButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)thirdLoginRegisterOk:(NSNotification *)notification{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)thirdLoginBindOk:(NSNotification *)notification{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)getUserNoOk:(NSNotification *)notification{
    if ([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString:kQQLogin])
    {
        [[RuYiCaiNetworkManager sharedManager] thirdLoginBindWithUserno:[RuYiCaiNetworkManager sharedManager].userno withOpenId:[RuYiCaiNetworkManager sharedManager].thirdOpenId  withSource:@"qq"];
    }else if ([[CommonRecordStatus commonRecordStatusManager].loginWay isEqualToString:kXLWeiBoLogin]){
       [[RuYiCaiNetworkManager sharedManager] thirdLoginBindWithUserno:[RuYiCaiNetworkManager sharedManager].userno withOpenId:[RuYiCaiNetworkManager sharedManager].thirdOpenId  withSource:@"sina"];
    }
}
#pragma mark textField delagate
- (void)backButtonClick:(id)sender
{
    UIAlertView *promptAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要退出吗？为了您的账户安全，建议您绑定全民免费彩账号。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [promptAlertView show];
    [promptAlertView release];
    
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"索引值为：buttonIndex = %d",buttonIndex);
    if(buttonIndex==1)
    {
        [self dismissModalViewControllerAnimated:YES];
        UIAlertView *faileLoginAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"联合登录失败！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [faileLoginAlertView show];
        [faileLoginAlertView release];
    }
}




#pragma mark textField delagate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (!KISiPhone5) {
        
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        
         self.layoutView.frame = CGRectMake(0,20,320,300);
        
        [UIView commitAnimations];
        
        
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(_registerPsdTextField == textField || _surePsdTextField == textField)
    {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];

            if (!KISiPhone5) {
                self.layoutView.frame = CGRectMake(0,-50,320,300);
            }
            
        [UIView commitAnimations];
    }else if(_alreadyPsdTextField == textField)
    {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        
        if (!KISiPhone5) {
            self.layoutView.frame = CGRectMake(0,-50,320,300);    }
        
        [UIView commitAnimations];
    }
    
	return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"thirdLoginRegisterOk" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUserNoOk" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"thirdLoginBindOk" object:nil];
    [_loginUserView release];
    [_alreadyNameTextField release];
    [_alreadyPsdTextField release];
    [_registerUserView release];
    [_registerNameTextField release];
    [_registerPsdTextField release];
    [_surePsdTextField release];
    [_noAlreadyButton release];
    [_alreadyButton release];
    [_bindUseButton release];
    [super dealloc];
}

@end
