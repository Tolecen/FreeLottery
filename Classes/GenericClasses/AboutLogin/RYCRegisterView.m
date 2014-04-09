//
//  RYCRegisterView.m
//  RuYiCai
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// 用户注册

#import "RYCRegisterView.h"
#import "RuYiCaiNetworkManager.h"
#import "BaseHelpViewController.h"
#import "NSLog.h"
#import "UINavigationBarCustomBg.h"
#import "NSString+Additions.h"
#import "InvalidCerID.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
#import "AgreementViewController.h"

@interface RYCRegisterView (internal)

- (void)sureButtonClick:(id)sender;
- (void)registerOK:(NSNotification*)notification;
- (void)protocolButtonClick:(id)sender;
- (void)setProView;
- (void)closeClick;

@end

@implementation RYCRegisterView

@synthesize myScrollView;
@synthesize m_registerPhonenumTextField;
@synthesize m_registerPswTextField;
@synthesize m_registerCertidTextField;
@synthesize m_registerNameTextField;
@synthesize m_registerSurePswTextField;
@synthesize m_registerRecNameTextField;

@synthesize bCertid;
@synthesize recNameSwitch;
@synthesize certIdView;
@synthesize recNameView;
@synthesize navgationBarReg = m_navgationBarReg;
@synthesize navgationView   = _navgationView;
@synthesize goBackBtn       = _goBackBtn;
@synthesize navgationTitleLable = _navgationTitleLable;
- (void)dealloc
{
    [_commitProtcolView release];
    [_navgationTitleLable release];
    [_navgationView release];
    [_goBackBtn release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerOK" object:nil];
    [m_navgationBarReg release];
    [myScrollView release];
    [m_registerPhonenumTextField release];
    [m_registerPswTextField release];
    [m_registerCertidTextField release];
    [m_registerNameTextField release];
    [m_registerSurePswTextField release];
    [m_registerRecNameTextField release];
    
    [bCertid release];
    [recNameSwitch release];
    [certIdView release];
    [recNameView release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   [AdaptationUtils adaptation:self];
    [self.view setBackgroundColor:[ColorUtils parseColorFromRGB:@"#f7f3ec"]];

    self.myScrollView.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerOK:) name:@"registerOK" object:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statView];
        [statView release];

            if (KISiPhone5) {
                self.myScrollView.frame =CGRectMake(0,64, 320, 450);
                
            }else
            {
                self.myScrollView.frame =CGRectMake(0,64, 320,380);
                
            }
       
        self.navgationView.frame  = CGRectMake(0, 20, 320, 44);
        self.goBackBtn.frame      = CGRectMake(9, 25, 52, 30);
        self.navgationTitleLable.frame = CGRectMake(122, 29, 76, 26);
    }else
    {
        if (KISiPhone5) {
            self.myScrollView.frame =CGRectMake(0,44, 320, 450);
            
        }else
        {
            self.myScrollView.frame =CGRectMake(0,44, 320, 430);
            
        }
        self.navgationView.frame  = CGRectMake(0, 0, 320, 44);
        self.goBackBtn.frame      = CGRectMake(9, 5, 52, 30);
        self.navgationTitleLable.frame = CGRectMake(122, 9, 76, 26);
    }
    [self.navgationBarReg setBackground];
    m_registerPhonenumTextField.delegate = self;
    m_registerPswTextField.delegate = self;
    m_registerCertidTextField.delegate = self;
    m_registerNameTextField.delegate = self;
	m_registerSurePswTextField.delegate = self;
    m_registerRecNameTextField.delegate = self;
    
    //按钮和协议按钮所放的view
    _commitProtcolView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, 320, 220)];
    _commitProtcolView.backgroundColor = [UIColor clearColor];
    [self.myScrollView insertSubview:_commitProtcolView atIndex:100];
    
    UIButton *proctoclButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [proctoclButton setTitle:@"《阅读并同意用户服务协议》" forState:UIControlStateNormal];
    [proctoclButton setTitleColor:[ColorUtils parseColorFromRGB:@"#0d5f85"] forState:UIControlStateNormal];
    proctoclButton.frame = CGRectMake(60,5, 200, 40);
    proctoclButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [proctoclButton addTarget:self action:@selector(protocolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_commitProtcolView addSubview:proctoclButton];
    
    
    _commiteRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commiteRegisterButton.frame = CGRectMake(20, 50,280, 35);
    [_commiteRegisterButton setTitle:@"确认" forState:UIControlStateNormal];
    [_commiteRegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commiteRegisterButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [_commiteRegisterButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    [_commiteRegisterButton addTarget:self action: @selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_commiteRegisterButton addTarget:self action: @selector(registerInsideButtonClick:) forControlEvents:UIControlEventTouchDown];
    [_commiteRegisterButton addTarget:self action: @selector(registerOutsideButtonClick:) forControlEvents:UIControlEventTouchDragOutside];
    [_commitProtcolView addSubview:_commiteRegisterButton];
    
    
    //底部加的线
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-51, 320, 1)];
    bottomLineView.backgroundColor = [ColorUtils parseColorFromRGB:@"#dedad2"];
    [self.view addSubview:bottomLineView];
    [bottomLineView release];
    
    //底部配置文本信息
    UIView  *bottomView;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, 320, 50)];
    }else
    {
       bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-70, 320, 50)];
    }
    
    bottomView.backgroundColor = [ColorUtils parseColorFromRGB:@"#ebe7e1"];
    [self.view addSubview:bottomView];
    [bottomView release];
    UITextView *promptTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    promptTextView.backgroundColor = [UIColor clearColor];
    promptTextView.text = @"手机号码、身份证信息是彩票兑奖的重要依据，建议您认真填写并核对信息！";
    promptTextView.editable = NO;
    promptTextView.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
    [bottomView addSubview:promptTextView];
    [promptTextView release];
    //更新一下swich状态
    [self recNameSwitchChange:nil];
}

- (IBAction)backButtonClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
//    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)sureButtonClick:(id)sender
{
    
    [_commiteRegisterButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
    [m_registerPhonenumTextField resignFirstResponder];
    [m_registerPswTextField resignFirstResponder];
    [m_registerCertidTextField resignFirstResponder];
    [m_registerNameTextField resignFirstResponder];
    [m_registerRecNameTextField resignFirstResponder];
    
    [UIView beginAnimations:@"movement" context:nil]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
    {
        if (KISiPhone5) {
            self.myScrollView.frame =CGRectMake(0,64, 320, 450);
            
        }else
        {
            self.myScrollView.frame =CGRectMake(0,64, 320, 380);
            
        }
    }else
    {
        if (KISiPhone5) {
            self.myScrollView.frame =CGRectMake(0,44, 320, 450);
            
        }else
        {
            self.myScrollView.frame =CGRectMake(0,44, 320, 380);
            
        }
    }
    
    [UIView commitAnimations];
    if (0 == m_registerPhonenumTextField.text.length
        || 0 == m_registerPswTextField.text.length
        || 0 == m_registerSurePswTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"有注册项未填,请输入！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }

    
    
    
    
    if(bCertid.on) 
    {
        if (0 == m_registerCertidTextField.text.length
            || 0 == m_registerNameTextField.text.length)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"有注册项未填,请输入！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        
        if( [m_registerCertidTextField.text containString:@" "])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"身份证号码不能包含空格！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        char  *carID= (char *)[m_registerCertidTextField.text UTF8String];
        InvalidCerID *invalidCerID = [[InvalidCerID alloc] init];
        int cerId = [invalidCerID checkIDfromchar:carID];
        if( cerId!=1)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"您输入的身份证不正确！\n请重新输入" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if (0 == m_registerNameTextField.text.length || [m_registerNameTextField.text isEqualToString:@" "])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"绑定身份证必须填写真实姓名！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        else if(m_registerNameTextField.text.length<2|| m_registerNameTextField.text.length>16 ||[NSString containOtherString:m_registerNameTextField.text])
        {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"姓名必须是2-16个汉字" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    else
    {
        m_registerCertidTextField.text = @"";
        m_registerNameTextField.text = @"";
    }
    if(recNameSwitch.on)
    {
        if (0 == m_registerRecNameTextField.text.length || [m_registerRecNameTextField.text isEqualToString:@" "])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入推荐人的用户名！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    else
    {
        m_registerRecNameTextField.text = @"";
    }
    //注册手机号码为11位
    if (11 != m_registerPhonenumTextField.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"注册手机号码为11位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    if (![phoneTest evaluateWithObject:m_registerPhonenumTextField.text]) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入正确的手机号" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
//    NSString *identityCardRegex = @"/^(\\d{18,18}|\\d{15,15}|\\d{17,17}x)$/";
//    NSPredicate *identityCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",identityCardRegex];
//    if (![identityCardTest evaluateWithObject:m_registerCertidTextField.text]) {
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入正确的身份证" withTitle:@"提示" buttonTitle:@"确定"];
//        return;
//    }

    //密码长度为6-16个字符
    NSString *passwordRegex = @"^[^%&’,;=?$\\^]+$";
    NSPredicate *passwordCardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    if (![passwordCardTest evaluateWithObject:m_registerPswTextField.text]) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码不能包含特殊字符" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    if (m_registerPswTextField.text.length < 6 || m_registerPswTextField.text.length > 16)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码长度为6~16位！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if(![m_registerPswTextField.text isEqualToString:m_registerSurePswTextField.text])
	{
		[[RuYiCaiNetworkManager sharedManager] showMessage:@"确认密码有误，请重新输入！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
	}
    
//    [MobClick event:@"registPage_regist_button"];

    [[RuYiCaiNetworkManager sharedManager] regWithPhonenum:m_registerPhonenumTextField.text 
                                              withPassword:m_registerPswTextField.text
                                                withCertid:m_registerCertidTextField.text 
                                                  withName:m_registerNameTextField.text
                                           withRecPhonenum:m_registerRecNameTextField.text];
}

//- (IBAction)bPhoneButtonClick:(id)sender
//{
////    [RuYiCaiNetworkManager sharedManager].isBindPhone = bPhone.on;
//}

- (IBAction)bCertidButtonClick:(id)sender
{
    [self recNameSwitchChange:nil];
}

- (IBAction)recNameSwitchChange:(id)sender
{
    if(recNameSwitch.on==YES && bCertid.on== YES)
    {
//        [MobClick event:@"registPage_tuiJian"];

            if (KISiPhone5) {
                self.myScrollView.contentSize = CGSizeMake(320, 550);
            }else
            {
                self.myScrollView.contentSize = CGSizeMake(320, 500);
        
           }
        self.certIdView.frame = CGRectMake(0, 160, 320,140);
        
        self.recNameView.frame = CGRectMake(0, 310, 320,80);
        
        _commitProtcolView.frame = CGRectMake(0,400, 320, 100);
    }else if(recNameSwitch.on==NO && bCertid.on== NO)
    {
        self.myScrollView.contentSize = CGSizeMake(320, 450);
        self.certIdView.frame = CGRectMake(0, 160, 320,40);
        
        self.recNameView.frame = CGRectMake(0, 210, 320,40);
        
        _commitProtcolView.frame = CGRectMake(0, 260, 320, 100);
    }
    else if(recNameSwitch.on==YES && bCertid.on== NO)
    {
            if (KISiPhone5) {
                self.myScrollView.contentSize = CGSizeMake(320, 0);
            }else
            {
                self.myScrollView.contentSize = CGSizeMake(320, 450);
                
            }
        self.certIdView.frame = CGRectMake(0, 160, 320,40);
        
        self.recNameView.frame = CGRectMake(0, 210, 320,80);
        
        _commitProtcolView.frame = CGRectMake(0, 290, 320, 100);
    }
    else
    {
        if (KISiPhone5) {
            self.myScrollView.contentSize = CGSizeMake(320, 0);
        }else
        {
            self.myScrollView.contentSize = CGSizeMake(320, 500);
            
        }
        self.certIdView.frame = CGRectMake(0, 160, 320,140);
        
        self.recNameView.frame = CGRectMake(0, 310, 320,40);
        
        _commitProtcolView.frame = CGRectMake(0, 350, 320, 100);
        
    }
}

- (void)registerOK:(NSNotification*)notification
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)protocolButtonClick:(id)sender
{
    AgreementViewController *agreementVC = [[AgreementViewController alloc] init];
    agreementVC.navigationItem.title = @"用户服务协议";
    [self presentModalViewController:agreementVC animated:YES];
    [agreementVC release];
}


- (void)registerInsideButtonClick:(id)sender
{
    [_commiteRegisterButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#820000"]];
}
- (void)registerOutsideButtonClick:(id)sender
{
    [_commiteRegisterButton setBackgroundColor:[ColorUtils parseColorFromRGB:@"#c80000"]];
}


- (void)closeClick
{
    [protocolView removeFromSuperview];
    [protocolView release], protocolView = nil;
}

#pragma mark textField delagate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"y4y %f", self.myScrollView.center.y);

    if(m_registerCertidTextField == textField || m_registerNameTextField == textField)
    {
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
        {
            if(self.myScrollView.center.y != 64)
            {
                [UIView beginAnimations:@"movement" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationRepeatAutoreverses:NO];
                if (KISiPhone5) {
                    self.myScrollView.frame =CGRectMake(0,-30, 320, 450);
                    
                }else
                {
                    self.myScrollView.frame =CGRectMake(0,-30, 320, 380);
                    
                }
                [UIView commitAnimations];
            }
            
        }else
        {
            if(self.myScrollView.center.y != 44)
            {
                [UIView beginAnimations:@"movement" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationRepeatAutoreverses:NO];
                if (KISiPhone5) {
                    self.myScrollView.frame =CGRectMake(0,-30, 320, 450);
                    
                }else
                {
                    self.myScrollView.frame =CGRectMake(0,-30, 320, 380);
                    
                }
                [UIView commitAnimations];
            }
            
        }
        
        
    }else if(m_registerRecNameTextField == textField)
    {
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
        {
            if(self.myScrollView.center.y != 64)
            {
                [UIView beginAnimations:@"movement" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationRepeatAutoreverses:NO];
                if (KISiPhone5) {
                    self.myScrollView.frame =CGRectMake(0,-60, 320, 450);
                    
                }else
                {
                    self.myScrollView.frame =CGRectMake(0,-60, 320, 380);
                    
                }
                [UIView commitAnimations];
            }
            
        }else
        {
            if(self.myScrollView.center.y != 44)
            {
                [UIView beginAnimations:@"movement" context:nil];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationRepeatAutoreverses:NO];
                if (KISiPhone5) {
                    self.myScrollView.frame =CGRectMake(0,-60, 320, 450);
                    
                }else
                {
                    self.myScrollView.frame =CGRectMake(0,-30, 320, 380);
                    
                }
                [UIView commitAnimations];
            }
            
        }

    }
    return YES;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if(m_registerCertidTextField == textField)
//    {
//        [m_registerCertidTextField resignFirstResponder];
//        if(self.myScrollView.center.y != 206)
//        {
//            [UIView beginAnimations:@"movement" context:nil]; 
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//            [UIView setAnimationDuration:0.3f];
//            [UIView setAnimationRepeatCount:1];
//            [UIView setAnimationRepeatAutoreverses:NO];
//            self.myScrollView.center = CGPointMake(160, 206);
//            [UIView commitAnimations];
//        }
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    NSLog(@"yy %f", self.myScrollView.center.y);
    if(self.myScrollView.center.y != 213)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
        {
            if (KISiPhone5) {
                self.myScrollView.frame =CGRectMake(0,64, 320, 450);
                
            }else
            {
                self.myScrollView.frame =CGRectMake(0,64, 320, 380);
                
            }
            
        }else
        {
            if (KISiPhone5) {
                self.myScrollView.frame =CGRectMake(0,44, 320, 450);
                
            }else
            {
                self.myScrollView.frame =CGRectMake(0,44, 320, 380);
                
            }
        }
        [UIView commitAnimations];
    }
	return YES;
}


@end
