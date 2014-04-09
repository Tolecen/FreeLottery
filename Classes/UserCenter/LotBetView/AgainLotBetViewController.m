//
//  AgainLotBetViewController.m
//  RuYiCai
//
//  Created by  on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "TitleViewButtonItemUtils.h"
#import "AgainLotBetViewController.h"
#import "SeeDetailTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation AgainLotBetViewController

@synthesize myTableView = m_myTableView;
@synthesize startBatch = m_startBatch;
@synthesize lotNo = m_lotNo;
@synthesize lotName = m_lotName;
@synthesize amount = m_amount;
@synthesize contentStr = m_contentStr;

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];


    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [m_againBetBeiField release];
    [m_myTableView release], m_myTableView = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betOutTime:) name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentsChange:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3] && [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[FirstPageViewController class]]) {
        
        //快三返回按钮
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
        
        //右按钮
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick:) andTitle:@"确定" normalColor:@"#74061f" higheColor:@"#4f0415"];
    }else{
        
        [BackBarButtonItemUtils addBackButtonForController:self];
        
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick:) andTitle:@"确定"];
    }
    
    self.startBatch = @"";
    
//    UIBarButtonItem* button_OK = [[UIBarButtonItem alloc]
//                                  initWithTitle:@"确定"
//                                  style:UIBarButtonItemStyleBordered
//                                  target:self
//                                  action:@selector(okClick:)];
//    self.navigationItem.rightBarButtonItem = button_OK;
//    [button_OK release];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    m_myTableView.scrollEnabled = NO;
    [self.view addSubview:m_myTableView];
    
    m_againBetBeiField = [[UITextField alloc] initWithFrame:CGRectMake(120, 121, 48, 32)];
    m_againBetBeiField.borderStyle = UITextBorderStyleNone;
    m_againBetBeiField.delegate = self;
//    m_againBetBeiField.placeholder = @"倍数";
    m_againBetBeiField.text = @"1";
    m_againBetBeiField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_againBetBeiField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    m_againBetBeiField.textAlignment = UITextAlignmentLeft;
    m_againBetBeiField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_againBetBeiField.keyboardAppearance = UIKeyboardAppearanceAlert;
//    m_againBetBeiField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_againBetBeiField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_againBetBeiField.returnKeyType = UIReturnKeyDone;
    m_againBetBeiField.textColor = [UIColor redColor];
    m_againBetBeiField.font = [UIFont systemFontOfSize:15.0f];
    [self.myTableView addSubview:m_againBetBeiField];
    [m_againBetBeiField becomeFirstResponder];
    
    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:self.lotNo];//获取当前期号
}

- (void)updateInformation:(NSNotification*)notification
{
    NSTrace();
    self.startBatch = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
    [self.myTableView reloadData];
}

- (void)okClick:(id)sender
{
    if([m_againBetBeiField.text isEqualToString:@""])
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入倍数" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if(![self beiShuFieldCheck])
    {
        return;
    }
    [m_againBetBeiField resignFirstResponder];

    [RuYiCaiLotDetail sharedObject].batchCode = self.startBatch;
    [RuYiCaiLotDetail sharedObject].lotMulti = m_againBetBeiField.text;
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单注总金额（多注投
    [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
}

- (void)betCompleteOK:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"betCompleteOK" object:nil];
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
        return 4;
 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
        return @"投注信息";

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myIdentifier = @"MyIdentifier";
    SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        switch (indexPath.row) {
            case 0:
            {
                cell.cellTitle = @"彩种";
                cell.cellDetailTitle = self.lotName;
                cell.isTextView = NO;
            }break;
            case 1:
            {
                cell.cellTitle = @"期号";
                cell.cellDetailTitle = [NSString stringWithFormat:@"第%@期", self.startBatch];
                cell.isTextView = NO;
            }break;
            case 2:
            {
                cell.cellTitle = @"倍数";
                cell.cellDetailTitle = @"          倍";
                cell.isTextView = NO;
            }break;
            case 3:
            {
                cell.cellTitle = @"金额";
                NSLog(@"rrrr %d", m_againBetBeiField.text.length == 0 ? 1 : [m_againBetBeiField.text intValue]);
                cell.cellDetailTitle = [NSString stringWithFormat:@"%d  元", [self.amount intValue] * (m_againBetBeiField.text.length == 0 ? 1 : [m_againBetBeiField.text intValue])];
                cell.isTextView = NO;
                cell.isRedText = YES;
            }break;
        }
        [cell refreshCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_againBetBeiField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == m_againBetBeiField) 
    {
        if(![self beiShuFieldCheck])
        {
            m_againBetBeiField.text = @"1";
        }
         
        [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%d", [self.amount intValue]*[m_againBetBeiField.text intValue]*100];
        [self.myTableView reloadData];
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if(m_againBetBeiField == textField)
//    {
//        if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:self.lotNo])
//        {
//            m_againBetBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:m_againBetBeiField.text andLength:4];
//        }
//        else
//        {
//            m_againBetBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:m_againBetBeiField.text andLength:3];
//        }
//    }
//    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.3f];
//    return YES;
//}


-(void)textFieldContentsChange:(NSNotification *)notification{
    
    UITextField * textField = notification.object;
    
    if(m_againBetBeiField == textField)
    {
        if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:self.lotNo])
        {
            m_againBetBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:2000];
            
        }else{

            m_againBetBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:200];
        }
    }
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.3f];
}


- (void)delayMethod
{
    [self.myTableView reloadData];
    
}

- (BOOL)beiShuFieldCheck
{
    for (int i = 0; i < m_againBetBeiField.text.length; i++)
    {
        UniChar chr = [m_againBetBeiField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    if(![m_againBetBeiField.text isEqualToString:@""])
    {
        if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:self.lotNo])
        {
            if([m_againBetBeiField.text intValue] <= 0 || [m_againBetBeiField.text intValue] > 2000)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"高频彩倍数的范围为1～2000！" withTitle:@"提示" buttonTitle:@"确定"];
                return NO;
            }
            else
                return YES;
        }
        else
        {
            if([m_againBetBeiField.text intValue] <= 0 || [m_againBetBeiField.text intValue] > 200)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～200！" withTitle:@"提示" buttonTitle:@"确定"];
                return NO;
            }
            else
                return YES;
        }
    }
    else
        return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 投注期号过期处理
- (void)betOutTime:(NSNotification*)notification
{
    //    该期已过期
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"该期已过期！" withTitle:@"提示" buttonTitle:@"确定"];
}

#pragma mark 投注余额不足处理
- (void)notEnoughMoney:(NSNotification*)notification
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"余额不足！" withTitle:@"提示" buttonTitle:@"确定"];
}


-(void)back:(UIButton *)button{
    
    [TitleViewButtonItemUtils shutDownMenu];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
@end
