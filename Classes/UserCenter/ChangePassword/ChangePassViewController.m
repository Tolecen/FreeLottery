//
//  ChangePassViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-11.
//
//

#import "ChangePassViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface ChangePassViewController ()

- (void)ChangePassOK:(NSNotification*)notification;

@end

@implementation ChangePassViewController

@synthesize myTableView = m_myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangePassOK" object:nil];
    
    [m_myTableView release], m_myTableView = nil;
    
    [m_oldPswTextField release], m_oldPswTextField = nil;
    [m_newPswTextField1 release], m_newPswTextField1 = nil;
    [m_newPswTextField2 release], m_newPswTextField2 = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangePassOK:) name:@"ChangePassOK" object:nil];
    
    self.navigationItem.title = @"修改密码";
    
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
    
    m_oldPswTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 20, 190, 40)];
    m_oldPswTextField.borderStyle = UITextBorderStyleNone;
    m_oldPswTextField.delegate = self;
    m_oldPswTextField.placeholder = @"原始密码";
    m_oldPswTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_oldPswTextField.keyboardType = UIKeyboardTypeEmailAddress;
    m_oldPswTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_oldPswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_oldPswTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_oldPswTextField.returnKeyType = UIReturnKeyNext;
    m_oldPswTextField.secureTextEntry = YES;
    [m_oldPswTextField becomeFirstResponder];
    [self.myTableView addSubview:m_oldPswTextField];
    
    m_newPswTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(110, 60, 190, 40)];
    m_newPswTextField1.borderStyle = UITextBorderStyleNone;
    m_newPswTextField1.delegate = self;
    m_newPswTextField1.placeholder = @"新密码";
    m_newPswTextField1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_newPswTextField1.keyboardType = UIKeyboardTypeEmailAddress;
    m_newPswTextField1.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_newPswTextField1.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_newPswTextField1.autocorrectionType = UITextAutocorrectionTypeNo;
    m_newPswTextField1.returnKeyType = UIReturnKeyNext;
    m_newPswTextField1.secureTextEntry = YES;
    [self.myTableView addSubview:m_newPswTextField1];
    
    m_newPswTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(110, 100, 190, 40)];
    m_newPswTextField2.borderStyle = UITextBorderStyleNone;
    m_newPswTextField2.delegate = self;
    m_newPswTextField2.placeholder = @"确认密码";
    m_newPswTextField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_newPswTextField2.keyboardType = UIKeyboardTypeEmailAddress;
    m_newPswTextField2.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_newPswTextField2.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_newPswTextField2.autocorrectionType = UITextAutocorrectionTypeNo;
    m_newPswTextField2.returnKeyType = UIReturnKeyDone;
    m_newPswTextField2.secureTextEntry = YES;
    [self.myTableView addSubview:m_newPswTextField2];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(40, 160, 100, 35);
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton setBackgroundImage:RYCImageNamed(@"tanchuangbtn_normal") forState:UIControlStateNormal];
//    [cancelButton setBackgroundImage:RYCImageNamed(@"tanchuangbtn_normal") forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    [cancelButton addTarget:self action: @selector(cancelChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableView addSubview:cancelButton];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(180, 160, 100, 35);
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [submitButton setBackgroundImage:RYCImageNamed(@"tanchuangbtn_normal") forState:UIControlStateNormal];
//    [submitButton setBackgroundImage:RYCImageNamed(@"tanchuangbtn_normal") forState:UIControlStateHighlighted];
    submitButton.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    [submitButton addTarget:self action: @selector(submitChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myTableView addSubview:submitButton];
}

- (void)ChangePassOK:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelChangeClick:(id)sender
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitChangeClick:(id)sender
{
    [m_oldPswTextField resignFirstResponder];
    [m_newPswTextField1 resignFirstResponder];
    [m_newPswTextField2 resignFirstResponder];
    
    if (0 == m_oldPswTextField.text.length
        || 0 == m_newPswTextField1.text.length
        || 0 == m_newPswTextField2.text.length)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"各项不能为空！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (m_newPswTextField1.text.length < 6 || m_newPswTextField1.text.length > 16 || m_newPswTextField2.text.length < 6 || m_newPswTextField2.text.length > 16)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"密码必须为6－16位数字或字母组成！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (NO == [m_newPswTextField1.text isEqualToString:m_newPswTextField2.text])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"新密码和确认密码不一致！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    [[RuYiCaiNetworkManager sharedManager] changeUserPsw:m_oldPswTextField.text
             withNewPsw:m_newPswTextField1.text];
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
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
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
            cell.textLabel.text = @"原始密码";
            break;
        case 1:
            cell.textLabel.text = @"新密码";
            break;
        case 2:
            cell.textLabel.text = @"确认密码";
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
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(m_oldPswTextField == textField)
    {
        [m_newPswTextField1 becomeFirstResponder];
    }
    else if(m_newPswTextField1 == textField)
    {
        [m_newPswTextField2 becomeFirstResponder];
    }
    else if(m_newPswTextField2 == textField)
    {
        [m_oldPswTextField resignFirstResponder];
        [m_newPswTextField1 resignFirstResponder];
        [m_newPswTextField2 resignFirstResponder];
    }
    return YES;
}
@end
