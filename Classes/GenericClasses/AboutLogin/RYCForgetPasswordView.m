//
//  RYCForgetPasswordView.m
//  RuYiCai
//
//  Created by  on 12-2-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RYCForgetPasswordView.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
#import "CustomColorButtonUtils.h"

@implementation RYCForgetPasswordView

@synthesize userNameField;
@synthesize phoneNumField;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"findPswOK" object:nil];
    [_findButton release];
    [userNameField release];
    [phoneNumField release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findPswOK:) name:@"findPswOK" object:nil];

    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#f7f3ec"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView  *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        navView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:navView atIndex:100];
        [navView release];
    }
    
    
    UIImageView  *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    navImageView.image = [UIImage imageNamed:@"title_bg.png"];
    [self.view insertSubview:navImageView atIndex:100];
    [navImageView release];

    

    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 200, 30)];
    titleLabel.text = @"找回密码";  
    titleLabel.textAlignment = UITextAlignmentCenter;  
    titleLabel.textColor = [UIColor whiteColor];  
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  
    titleLabel.backgroundColor = [UIColor clearColor];  
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    //登陆框和手机号绑定框的背景图片
    UIImageView* changePsdImageC = [[UIImageView alloc] initWithFrame:CGRectMake(20, 84, 280, 100)];
    changePsdImageC.image = RYCImageNamed(@"topinfo_c_bg.png");
    [self.view addSubview:changePsdImageC];
    [changePsdImageC release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 90, 100, 30)];
    nameLabel.text = @"用户名";
    nameLabel.textAlignment = UITextAlignmentLeft;  
    nameLabel.textColor = [ColorUtils parseColorFromRGB:@"#b4b1ad"];
    nameLabel.font = [UIFont boldSystemFontOfSize:15];  
    nameLabel.backgroundColor = [UIColor clearColor];  
    [self.view addSubview:nameLabel];
    [nameLabel release];
    
    userNameField = [[UITextField alloc] initWithFrame:CGRectMake(100, 90, 220, 35)];
    userNameField.borderStyle = UITextBorderStyleNone;
    userNameField.delegate = self;
    userNameField.placeholder = @"您要找回密码的用户名";
    userNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameField.keyboardType = UIKeyboardTypeEmailAddress;
    userNameField.keyboardAppearance = UIKeyboardAppearanceAlert;
    userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:userNameField];

   
    UILabel *phLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 135, 100, 30)];
    phLabel.text = @"手机号";  
    phLabel.textAlignment = UITextAlignmentLeft;  
    phLabel.textColor = [ColorUtils parseColorFromRGB:@"#b4b1ad"];  
    phLabel.font = [UIFont boldSystemFontOfSize:15];  
    phLabel.backgroundColor = [UIColor clearColor];  
    [self.view addSubview:phLabel];
    [phLabel release];
    
    phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(100, 135, 220, 35)];
    phoneNumField.borderStyle = UITextBorderStyleNone;
    phoneNumField.delegate = self;
    phoneNumField.placeholder = @"绑定的手机号码";
    phoneNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumField.keyboardAppearance = UIKeyboardAppearanceAlert;
    phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumField.autocorrectionType = UITextAutocorrectionTypeNo;
    phoneNumField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:phoneNumField];
    
    _findButton = [[CustomColorButtonUtils alloc] initWithSize:CGSizeMake(100, 35) normalColor:@"#c80000" higheColor:@"#820000"];
    
    _findButton.frame = CGRectMake(180, 200, 120,35);
    [_findButton setTitle:@"立即找回" forState:UIControlStateNormal];
    [_findButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _findButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_findButton addTarget:self action:@selector(_findButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findButton];
    
    CustomColorButtonUtils *backbutton = [[CustomColorButtonUtils alloc] initWithSize:CGSizeMake(100, 35) normalColor:@"#c80000" higheColor:@"#820000"];
    
    backbutton.frame = CGRectMake(20, 200, 120, 35);
    [backbutton setTitle:@"取消" forState:UIControlStateNormal];
    [backbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backbutton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [backbutton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
    [backbutton release];
    
    UILabel *promLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 235, 300, 90)];
    promLabel.text = @"如果您尚未绑定手机或用户名忘记了，请拨打客服电话                            ，让客服人员协助您找回密码。";
    promLabel.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
    promLabel.lineBreakMode = UILineBreakModeWordWrap;
    promLabel.numberOfLines = 3;
    promLabel.textAlignment = UITextAlignmentLeft;  
    promLabel.font = [UIFont systemFontOfSize:15];
    promLabel.backgroundColor = [UIColor clearColor];  
    [self.view addSubview:promLabel];
    [promLabel release];
    UIButton *serviceNumButton= [UIButton buttonWithType:UIButtonTypeCustom];
    serviceNumButton.frame = CGRectMake(75, 265,120, 30);
    [serviceNumButton setTitle:@"   400-856-1000" forState:UIControlStateNormal];
    serviceNumButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [serviceNumButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [serviceNumButton addTarget:self action:@selector(serviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serviceNumButton];
    
}


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

- (void)backButtonClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)_findButtonClick:(id)sender
{
    
    [_findButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    [userNameField resignFirstResponder];
    [phoneNumField resignFirstResponder];
    if(userNameField.text.length == 0 || phoneNumField.text.length == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"用户名或手机号未填，请输入！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if(phoneNumField.text.length != 11)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"有效的手机号码为11位，请重新输入！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    [[RuYiCaiNetworkManager sharedManager] findPasswordWithPhone:userNameField.text bindPhone:phoneNumField.text];
}

- (void)findPswOK:(NSNotification*)notification
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码已经成功发送到您绑定的手机上，请注意查收并及时修改密码！" withTitle:@"提示" buttonTitle:@"确定"];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userNameField resignFirstResponder];
    [phoneNumField resignFirstResponder];
}

@end
