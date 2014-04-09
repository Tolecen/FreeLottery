//
//  AgainTrackViewController.m
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AgainTrackViewController.h"
#import "SeeDetailTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation AgainTrackViewController

@synthesize myTableView = m_myTableView;
@synthesize lotNo = m_lotNo;
@synthesize lotName = m_lotName;
@synthesize oneAmount = m_oneAmount;
@synthesize startBatch = m_startBatch;
@synthesize zhuShu = m_zhuShu;

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
    [m_againTrackBeiField release];
    [m_againTrackBatchField release];
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
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    self.startBatch = @"";
    
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick:) andTitle:@"确定"];
//    UIBarButtonItem* button_OK = [[UIBarButtonItem alloc]
//                      initWithTitle:@"确定"
//                      style:UIBarButtonItemStyleBordered
//                      target:self
//                      action:@selector(okClick:)];
//    self.navigationItem.rightBarButtonItem = button_OK;
//    [button_OK release];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
    
    m_againTrackBatchField = [[UITextField alloc] initWithFrame:CGRectMake(120, 49, 80, 32)];
    m_againTrackBatchField.borderStyle = UITextBorderStyleNone;
    m_againTrackBatchField.delegate = self;
    m_againTrackBatchField.placeholder = @"期数";
    m_againTrackBatchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_againTrackBatchField.textColor = [UIColor redColor];
    m_againTrackBatchField.textAlignment = UITextAlignmentLeft;
    m_againTrackBatchField.keyboardType = UIKeyboardTypeNumberPad;
    m_againTrackBatchField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_againTrackBatchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_againTrackBatchField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_againTrackBatchField.returnKeyType = UIReturnKeyDone;
    [self.myTableView addSubview:m_againTrackBatchField];
    [m_againTrackBatchField becomeFirstResponder];
    
    m_againTrackBeiField = [[UITextField alloc] initWithFrame:CGRectMake(120, 89, 80, 32)];
    m_againTrackBeiField.borderStyle = UITextBorderStyleNone;
    m_againTrackBeiField.delegate = self;
    m_againTrackBeiField.placeholder = @"倍数";
    m_againTrackBeiField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_againTrackBeiField.textColor = [UIColor redColor];
    m_againTrackBeiField.textAlignment = UITextAlignmentLeft;
    m_againTrackBeiField.keyboardType = UIKeyboardTypeNumberPad;
    m_againTrackBeiField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_againTrackBeiField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_againTrackBeiField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_againTrackBeiField.returnKeyType = UIReturnKeyDone;
    [self.myTableView addSubview:m_againTrackBeiField];
    
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
    [m_againTrackBatchField resignFirstResponder];
    [m_againTrackBeiField resignFirstResponder];
    if(m_againTrackBatchField.text.length == 0 || m_againTrackBeiField.text.length == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请把信息填写完整！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    for (int i = 0; i < m_againTrackBatchField.text.length; i++)
    {
        UniChar chr = [m_againTrackBatchField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    if([m_againTrackBatchField.text intValue] <= 0 || [m_againTrackBatchField.text intValue] > 200)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数的范围为1～200！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    for (int i = 0; i < m_againTrackBeiField.text.length; i++)
    {
        UniChar chr = [m_againTrackBeiField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:self.lotNo])
    {
        if([m_againTrackBeiField.text intValue] <= 0 || [m_againTrackBeiField.text intValue] > 2000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"高频彩倍数的范围为1～2000！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    else
    {
        if([m_againTrackBeiField.text intValue] <= 0 || [m_againTrackBeiField.text intValue] > 200)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～200！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    [RuYiCaiLotDetail sharedObject].batchCode = self.startBatch;
    [RuYiCaiLotDetail sharedObject].batchNum = m_againTrackBatchField.text;
    [RuYiCaiLotDetail sharedObject].lotMulti = m_againTrackBeiField.text;
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%d", [self.oneAmount intValue]*[self.zhuShu intValue]*[m_againTrackBeiField.text intValue]];

    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单注总金额（多注投
    [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
}

- (void)betCompleteOK:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backOK" object:nil];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return 5;
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myIdentifier = @"MyIdentifier";
    SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) 
    {
        case 0:
        {
            cell.cellTitle = @"彩票种类";
            cell.cellDetailTitle = self.lotName;
            cell.isTextView = NO;
        }break;
        case 1:
        {
            cell.cellTitle = @"追号期数";
            cell.cellDetailTitle = @"                   期";
            cell.isTextView = NO;
//            cell.isRedText = YES;
        }break;
        case 2:
        {
            cell.cellTitle = @"追号倍数";
            cell.cellDetailTitle = @"                   倍";
            cell.isTextView = NO;
//            cell.isRedText = YES;
        }break;
        case 3:
        {
            cell.cellTitle = @"单期付款";
            cell.cellDetailTitle = [NSString stringWithFormat:@"%d元", [self.oneAmount intValue]*[self.zhuShu intValue]*[m_againTrackBeiField.text intValue]/100];
            cell.isRedText = YES;
            cell.isTextView = NO;
        }break;
        case 4:
        {
            cell.cellTitle = @"起始追期";
            cell.cellDetailTitle = [NSString stringWithFormat:@"第%@期", self.startBatch];
            cell.isTextView = NO;
        }break;
        default:
            break;
    }

    
    [cell refreshCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark textFeild delegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    if(m_againTrackBeiField == textField)
//    {
//        if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:self.lotNo])
//        {
////            if(m_againTrackBeiField.text.length > 3)
////            {
////                m_againTrackBeiField.text = [m_againTrackBeiField.text substringWithRange:NSMakeRange(0, m_againTrackBeiField.text.length - 1)];
////            }
//            m_againTrackBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:2000];
//        }
//        else if([self.lotNo isEqualToString:kLotNoJCLQ] || [self.lotNo isEqualToString:kLotNoJCZQ] || [self.lotNo isEqualToString:kLotNoBJDC]){
//            
//            m_againTrackBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:100000];
//
//        }
//        else{
////            if(m_againTrackBeiField.text.length > 2)
////            {
////                m_againTrackBeiField.text = [m_againTrackBeiField.text substringWithRange:NSMakeRange(0, m_againTrackBeiField.text.length - 1)];
////            }
//            m_againTrackBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:200];
//        }
//    }
//    else
//    {
////        if(m_againTrackBatchField.text.length > 2)
////        {
////             m_againTrackBatchField.text = [m_againTrackBatchField.text substringWithRange:NSMakeRange(0, m_againTrackBatchField.text.length - 1)];
////        }
//        m_againTrackBatchField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:200];
//    }
//    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.3f];
//    return YES;
//}


-(void)textFieldContentsChange:(NSNotification *)notification{
    
    UITextField * textField = notification.object;
    
    if(m_againTrackBeiField == textField)
    {
        if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:self.lotNo])
        {
            //            if(m_againTrackBeiField.text.length > 3)
            //            {
            //                m_againTrackBeiField.text = [m_againTrackBeiField.text substringWithRange:NSMakeRange(0, m_againTrackBeiField.text.length - 1)];
            //            }
            m_againTrackBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:2000];
        }
        else if([self.lotNo isEqualToString:kLotNoJCLQ] || [self.lotNo isEqualToString:kLotNoJCZQ] || [self.lotNo isEqualToString:kLotNoBJDC]){
            
            m_againTrackBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:100000];
            
        }
        else{
            //            if(m_againTrackBeiField.text.length > 2)
            //            {
            //                m_againTrackBeiField.text = [m_againTrackBeiField.text substringWithRange:NSMakeRange(0, m_againTrackBeiField.text.length - 1)];
            //            }
            m_againTrackBeiField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:200];
        }
    }
    else
    {
        //        if(m_againTrackBatchField.text.length > 2)
        //        {
        //             m_againTrackBatchField.text = [m_againTrackBatchField.text substringWithRange:NSMakeRange(0, m_againTrackBatchField.text.length - 1)];
        //        }
        m_againTrackBatchField.text = [[CommonRecordStatus commonRecordStatusManager] textMaxLengthWithString:textField.text andLength:200];
    }
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.3f];
}


- (void)delayMethod
{
    [self.myTableView reloadData];
    
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
@end
