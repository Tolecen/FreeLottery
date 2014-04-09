//
//  BindCertViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-11.
//
//

#import "BindCertViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "NSString+Additions.h"
#import "InvalidCerID.h"
#import "AdaptationUtils.h"

@interface BindCertViewController ()

- (void)BindCertIdOK:(NSNotification*)notification;

@end

@implementation BindCertViewController

@synthesize myTableView = m_myTableView;

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BindCertIdOK" object:nil];
    
    [m_myTableView release], m_myTableView = nil;
    [m_bindCertidField release], m_bindCertidField = nil;
    [m_bindTrueNameField release], m_bindTrueNameField = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BindCertIdOK:) name:@"BindCertIdOK" object:nil];
    //返回按钮
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    m_myTableView.scrollEnabled = NO;
    [self.view addSubview:m_myTableView];
    
    m_bindCertidField = [[UITextField alloc] initWithFrame:CGRectMake(120, 20, 180, 40)];
    m_bindCertidField.borderStyle = UITextBorderStyleNone;
    m_bindCertidField.delegate = self;
    m_bindCertidField.placeholder = @"身份证号码";
    m_bindCertidField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_bindCertidField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_bindCertidField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_bindCertidField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_bindCertidField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_bindCertidField.returnKeyType = UIReturnKeyDone;
    [m_bindCertidField becomeFirstResponder];
    [self.myTableView addSubview:m_bindCertidField];
    
    m_bindTrueNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 60, 180, 40)];
    m_bindTrueNameField.borderStyle = UITextBorderStyleNone;
    m_bindTrueNameField.delegate = self;
    m_bindTrueNameField.placeholder = @"真实姓名";
    m_bindTrueNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_bindTrueNameField.keyboardType = UIKeyboardTypeDefault;
    m_bindTrueNameField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_bindTrueNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_bindTrueNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_bindTrueNameField.returnKeyType = UIReturnKeyDone;
    [self.myTableView addSubview:m_bindTrueNameField];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(40, 120, 100, 35);
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton setBackgroundImage:RYCImageNamed(@"log_zhmm_btn.png") forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:RYCImageNamed(@"log_zhmm_hov_btn.png") forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    [cancelButton addTarget:self action: @selector(cancelCertidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableView addSubview:cancelButton];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(180, 120, 100, 35);
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:RYCImageNamed(@"log_zhmm_btn.png") forState:UIControlStateNormal];
    [submitButton setBackgroundImage:RYCImageNamed(@"log_zhmm_hov_btn.png") forState:UIControlStateHighlighted];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    [submitButton addTarget:self action: @selector(submitCertidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableView addSubview:submitButton];
}

- (void)BindCertIdOK:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelCertidClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//绑定身份证 提交按钮事件
- (void)submitCertidClick:(id)sender
{
    
//    char  *carID= (char *)[m_bindCertidField.text UTF8String];
//    InvalidCerID *invalidCerID = [[InvalidCerID alloc] init];
//    int cerId = [invalidCerID checkIDfromchar:carID];
    BOOL cerID = [self validateIdentityCard:m_bindCertidField.text];
    //通知键盘消失
    [m_bindCertidField resignFirstResponder];
    [m_bindTrueNameField resignFirstResponder];
//    if( [m_bindCertidField.text containString:@" "])
//    {
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"身份证号码不能包含空格！" withTitle:@"提示" buttonTitle:@"确定"];
//        return;
//    }
    if(!cerID)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"您输入的身份证不正确！\n请重新输入" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    
    if (0 == m_bindTrueNameField.text.length || [m_bindTrueNameField.text isEqualToString:@" "])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"绑定身份证必须填写真实姓名！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    else if(m_bindTrueNameField.text.length<2|| m_bindTrueNameField.text.length>16 ||[NSString containOtherString:m_bindTrueNameField.text])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"姓名必须是2-16个汉字" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }

//    if(m_bindTrueNameField.text.length == 0)
//    {
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入真实姓名!" withTitle:@"提示" buttonTitle:@"确定"];
//        return;
//    }
//    else
//    {
//        if([[m_bindTrueNameField.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "])
//        {
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"真实姓名有误，请重新输入!" withTitle:@"提示" buttonTitle:@"确定"];
//            return;
//        }
//    }
    //    for (int i = 0; i < m_bindCertidField.text.length; i++)
    //    {
    //        UniChar chr = [m_bindCertidField.text characterAtIndex:i];
    //
    //        if(i == m_bindCertidField.text.length - 1)
    //        {
    //            if((chr < '0' || chr > '9') && (chr != 'x' && chr != 'X'))
    //            {
    //                [[RuYiCaiNetworkManager sharedManager] showMessage:@"身份证号最后一位格式错误" withTitle:@"提示" buttonTitle:@"确定"];
    //
    //                return;
    //            }
    //        }
    //        else
    //        {
    //            if (chr < '0' || chr > '9')
    //            {
    //                [[RuYiCaiNetworkManager sharedManager] showMessage:@"身份证号须为数字" withTitle:@"提示" buttonTitle:@"确定"];
    //
    //                return;
    //            }
    //        }
    //    }
    
    
    [[RuYiCaiNetworkManager sharedManager] bindWithCertid:m_bindCertidField.text tureName:m_bindTrueNameField.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"身份证号码";
            break;
        case 1:
            cell.textLabel.text = @"真实姓名";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
