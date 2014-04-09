//
//  FeedBackViewController.m
//  RuYiCaiiPad
//
//  Created by  on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FeedBackViewController.h"
#import "NSLog.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

#define LabelSize  (15)
@interface FeedBackViewController ()<RandomPickerDelegate>
{
    RuYiCaiAppDelegate *m_delegate;
}
@property (nonatomic, retain) NSMutableArray *contactNameArr;
@property (nonatomic, retain) UILabel *contactLabel;
@end

@implementation FeedBackViewController
@synthesize userNamePhone = m_userNamePhone;
@synthesize contactNameArr = _contactNameArr;
@synthesize contactLabel = _contactLabel;
@synthesize proposalStr;
@synthesize bindPhone = m_bindPhone;
@synthesize isPushHid = m_isPushHid;
- (void)dealloc
{
    
    [m_bindPhone release];
    [m_leaveMess release];
    [proposalStr release];
    [m_contactWay release];
    [m_userNamePhone release];
    [_contactNameArr release];
    [_contactLabel release];
    [ploachodlLable release];
    m_delegate.randomPickerView.delegate = nil;
    [super dealloc];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"feedBackOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getUserCenterInfoOK" object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
   
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    self.navigationItem.title = @"留言反馈";
    self.contactNameArr = [NSMutableArray array];
    NSArray* array = [[NSArray alloc] initWithObjects:@"手机号",@"QQ",@"邮箱",nil];
    [self.contactNameArr removeAllObjects];
    [self.contactNameArr addObjectsFromArray:array];
    [array release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedBackOK:) name:@"feedBackOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserCenterInfoOK:) name:@"getUserCenterInfoOK" object:nil];
    [[RuYiCaiNetworkManager sharedManager] UpdateUserInfo];
    
//    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
//										initWithTitle:@"提交"
//										style:UIBarButtonItemStyleBordered
//										target:self
//										action:@selector(okClick)];
//    self.navigationItem.rightBarButtonItem = okBarButtonItem;
//    [okBarButtonItem release];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"提交"];
    
    [self setMainView];
    self.userNamePhone = [[[NSString  alloc] init] autorelease];
}

- (void)setMainView
{
    
    UIImageView *image_midbg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 280, 170)];
    image_midbg.image = RYCImageNamed(@"leaveMess_bg.png");
    [self.view addSubview:image_midbg];
    [image_midbg release];
    
    m_leaveMess = [[UITextView alloc] initWithFrame:CGRectMake(25, 25, 282, 140)];
    m_leaveMess.backgroundColor = [UIColor clearColor   ];
    m_leaveMess.font = [UIFont systemFontOfSize:LabelSize];
    m_leaveMess.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth; 
    m_leaveMess.textColor = [UIColor blackColor];
    m_leaveMess.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_leaveMess.delegate = self;
    //m_leaveMess.keyboardType = UIKeyboardTypeNamePhonePad;
    //m_leaveMess.clearsContextBeforeDrawing = YES;
    [m_leaveMess becomeFirstResponder];
    [self.view addSubview:m_leaveMess];
    m_leaveMess.hidden = NO;
    m_leaveMess.delegate = self;
    
    ploachodlLable = [[UILabel alloc] initWithFrame:CGRectMake(36, 8, 282, 70)];
    ploachodlLable.text = @"欢迎您提出宝贵的意见和建议";
    ploachodlLable.numberOfLines = 0;// 不可少Label属性之一
    ploachodlLable.lineBreakMode = UILineBreakModeCharacterWrap;
    ploachodlLable.font = [UIFont systemFontOfSize:15];
    ploachodlLable.enabled = NO;//lable必须设置为不可用
    ploachodlLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:ploachodlLable];
    
//    UILabel *cLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 142, 120, 50)];
//    cLabel.textAlignment = UITextAlignmentLeft;
//    cLabel.text = @"联系方式：";
//    [cLabel setTextColor:[UIColor blackColor]];
//    cLabel.backgroundColor = [UIColor clearColor];
//    cLabel.font = [UIFont systemFontOfSize:LabelSize];
//    [self.view addSubview:cLabel];
//    [cLabel release];

    
    
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactButton.frame = CGRectMake(30, 160, 75, 20);
    [contactButton setBackgroundImage:[UIImage imageNamed:@"contact_button_normal.png"] forState:UIControlStateNormal];
    [contactButton setBackgroundImage:[UIImage imageNamed:@"contact_button_click.png"] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(selectBankAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contactButton];
    
    self.contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 160, 75, 20)];
    self.contactLabel.textAlignment = UITextAlignmentLeft;
    self.contactLabel.font = [UIFont systemFontOfSize:10];
    self.contactLabel.text = @"手机号";
    [self.contactLabel setTextColor:[UIColor blackColor]];
    self.contactLabel.backgroundColor = [UIColor clearColor];
    self.contactLabel.font = [UIFont systemFontOfSize:LabelSize];
    [self.view addSubview:self.contactLabel];
    [self.contactLabel release];
    
    m_contactWay = [[UITextField alloc] initWithFrame:CGRectMake(110, 145, 180, 50)];
    m_contactWay.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_contactWay.borderStyle = UITextBorderStyleNone;
    m_contactWay.delegate = self;
    m_contactWay.placeholder = @"您的联系方式";
    m_contactWay.returnKeyType = UIReturnKeyDone;
    m_contactWay.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_contactWay.font = [UIFont systemFontOfSize:14];
    m_contactWay.textColor = [UIColor blackColor];
    m_contactWay.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_contactWay.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:m_contactWay];
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.proposalStr =  textView.text;
    if (textView.text.length == 0) {
        ploachodlLable.text = @"欢迎您提出宝贵的意见和建议";
    }else{
        ploachodlLable.text = @"";
    }
}

- (IBAction)selectBankAction:(id)sender
{
    [m_contactWay resignFirstResponder];
    [m_leaveMess resignFirstResponder];
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
    [m_delegate.randomPickerView setPickerDataArray:self.contactNameArr];
    [m_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:[self.contactNameArr count]];
}
#pragma mark RandomPickerDelegate

- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
//    [self.bankNameButton setTitle:[self.contactNameArr objectAtIndex:num] forState:UIControlStateNormal];
    [self.contactLabel setText:[self.contactNameArr objectAtIndex:num]];
}
- (void)okClick
{
    
    

    NSLog(@"%@",    m_contactWay.text);
    NSLog(@"%@",    m_contactWay.text);
    NSLog(@"%@",    self.contactLabel.text);

    
    [m_contactWay resignFirstResponder];
    [m_leaveMess resignFirstResponder];
    
    //    [MobClick event:@"leaveMesPage_tiJiao_button"];
    //    NSLog(@"%@", m_leaveMess.text);
    //    UniChar chr = [m_leaveMess.text characterAtIndex:0];
    //    if('\n' == chr || ' ' == chr)
    //    {
    //        [[RuYiCaiNetworkManager sharedManager] showMessage:@"留言信息前不能有换行符或空格符，谢谢！" withTitle:@"提示" buttonTitle:@"确定"];
    //        return;
    //    }
    NSString *_textField=[m_leaveMess.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *_contactStr=[m_contactWay.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([_textField length] == 0 || m_leaveMess.text.length == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"反馈内容不能为空" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    
    if([RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        if ([self.bindPhone isEqualToString:@""]&&([_contactStr isEqualToString:@""]||_contactStr.length==0))
        {
            [[RuYiCaiNetworkManager sharedManager] sendFeedBack:[NSString stringWithFormat:@"%@ 用户名:%@",_textField,self.userNamePhone] contactWay:@""];
        }else if([self.bindPhone isEqualToString:@""]&&(![_contactStr isEqualToString:@""]||_contactStr.length!=0))
        {
            [[RuYiCaiNetworkManager sharedManager] sendFeedBack:[NSString stringWithFormat:@"%@ %@:%@",_textField,self.contactLabel.text,_contactStr] contactWay:@""];
        }else if(![self.bindPhone isEqualToString:@""]&&([_contactStr isEqualToString:@""]||_contactStr.length==0))
        {
            [[RuYiCaiNetworkManager sharedManager] sendFeedBack:[NSString stringWithFormat:@"%@ 手机号:%@",_textField,self.bindPhone] contactWay:@""];
        }else if(![self.bindPhone isEqualToString:@""]&&(![_contactStr isEqualToString:@""]||_contactStr.length!=0))
        {
            [[RuYiCaiNetworkManager sharedManager] sendFeedBack:[NSString stringWithFormat:@"%@ 输入的%@:%@",_textField,self.contactLabel.text,_contactStr] contactWay:@""];
        }
    }else
    {
        if (_contactStr.length != 0)
        {
            NSLog(@"hahhah留言内容：%@，联系方式%@",[NSString stringWithFormat:@"%@",_textField],[NSString stringWithFormat:@"%@:%@",self.contactLabel.text,_contactStr]);
            [[RuYiCaiNetworkManager sharedManager] sendFeedBack:[NSString stringWithFormat:@"%@ %@:%@",_textField,self.contactLabel.text,_contactStr] contactWay:@""];
        }
        else
        {
            [[RuYiCaiNetworkManager sharedManager] sendFeedBack:[NSString stringWithFormat:@"%@",_textField] contactWay:@""];
        
        }
        
    }

}

- (void)feedBackOK:(NSNotification *)notification
{
//    if (m_isPushHid)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        [self.navigationController popViewControllerAnimated:YES];

//    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_leaveMess resignFirstResponder];
    [m_contactWay resignFirstResponder];
}

#pragma mark textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)getUserCenterInfoOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].userCenterInfo];
    [jsonParser release];
    
    self.userNamePhone  =  [parserDict objectForKey:@"userName"];
    self.bindPhone   = [parserDict objectForKey:@"mobileId"];
}


- (void)back:(id)sender
{
//    if (m_isPushHid)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
//        
//    }else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
