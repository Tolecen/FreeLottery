//
//  ChangePassViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-11.
//
//

#import "SettingNicknameVC.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"

@interface SettingNicknameVC ()

- (void)ChangePassOK:(NSNotification*)notification;

@end

@implementation SettingNicknameVC


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
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
    //返回按钮
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 40)];
    titleLable.text = @"昵称：";
    titleLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLable];
    [titleLable release];
    
    
    m_newPswTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(100, 50, 180, 40)];
    [m_newPswTextField2 becomeFirstResponder];
    m_newPswTextField2.borderStyle = UITextBorderStyleRoundedRect;
    m_newPswTextField2.delegate = self;
    m_newPswTextField2.placeholder = @"请输入您的昵称";
    m_newPswTextField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_newPswTextField2.keyboardType = UIKeyboardTypeDefault;
//    m_newPswTextField2.keyboardAppearance = UIKeyboardAppearanceAlert;
//    m_newPswTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
//    m_newPswTextField2.autocorrectionType = UITextAutocorrectionTypeNo;
//    m_newPswTextField2.returnKeyType = UIReturnKeyDone;
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
    if (!KISEmptyOrEnter(m_newPswTextField2.text)) {
        
        for (int i = 0 ; i < [m_newPswTextField2.text length]; i++) {
            UniChar chr = [m_newPswTextField2.text characterAtIndex:i];
            if (chr == ' ')//是空格
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称不能包含空格" withTitle:@"提示" buttonTitle:@"确定"];
                return;
            }
        }
        
        NSLog(@"%d",[[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_newPswTextField2.text]);
        if ([[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_newPswTextField2.text] < 4) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称最少两个汉字或四个字符" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        
        if ([[CommonRecordStatus commonRecordStatusManager] asciiLengthOfString:m_newPswTextField2.text] > 16) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"昵称最多八个汉字或十六个字符" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        [[RuYiCaiNetworkManager sharedManager] nickNameSet:m_newPswTextField2.text];
        
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入昵称" withTitle:@"提示" buttonTitle:@"确定"];
    }

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
