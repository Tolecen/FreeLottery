//
//  ChangePassViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-11.
//
//

#import "BindPhoneCheckViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"

@interface BindPhoneCheckViewController ()

- (void)ChangePassOK:(NSNotification*)notification;

@end

@implementation BindPhoneCheckViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    
    
    [m_oldPswTextField release], m_oldPswTextField = nil;
    [m_newPswTextField1 release], m_newPswTextField1 = nil;
    [m_newPswTextField2 release], m_newPswTextField2 = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    //返回按钮
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 40)];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.text = @"验证码：";
    [self.view addSubview:titleLable];
    [titleLable release];
    
    
    m_newPswTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 50, 180, 40)];
    [m_newPswTextField2 becomeFirstResponder];
    m_newPswTextField2.borderStyle = UITextBorderStyleRoundedRect;
    m_newPswTextField2.delegate = self;
    m_newPswTextField2.placeholder = @"验证码";
    m_newPswTextField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_newPswTextField2.keyboardType = UIKeyboardTypeNumberPad;
//    m_newPswTextField2.keyboardAppearance = UIKeyboardAppearanceAlert;
//    m_newPswTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
//    m_newPswTextField2.autocorrectionType = UITextAutocorrectionTypeNo;
    m_newPswTextField2.returnKeyType = UIReturnKeyDone;
//    m_newPswTextField2.secureTextEntry = YES;
    [self.view addSubview:m_newPswTextField2];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(40, 160, 100, 35);
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton setBackgroundImage:RYCImageNamed(@"log_zhmm_btn.png") forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:RYCImageNamed(@"log_zhmm_hov_btn.png") forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    [cancelButton addTarget:self action: @selector(cancelChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(180, 160, 100, 35);
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:RYCImageNamed(@"log_zhmm_btn.png") forState:UIControlStateNormal];
    [submitButton setBackgroundImage:RYCImageNamed(@"log_zhmm_hov_btn.png") forState:UIControlStateHighlighted];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    [submitButton addTarget:self action: @selector(submitChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)ChangePassOK:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelChangeClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)submitChangeClick:(id)sender
{
    [m_newPswTextField2 resignFirstResponder];
    
    if(m_newPswTextField2.text.length == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入验证码！" withTitle:@"提示" buttonTitle:@"确定"];
    }
    
    [[RuYiCaiNetworkManager sharedManager] bindPhoneNumWithSecurity:m_newPswTextField2.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        [m_newPswTextField2 becomeFirstResponder];
       return YES;
}
@end
