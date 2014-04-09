//
//  ShouYiLvSetViewController.m
//  RuYiCai
//
//  Created by  on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShouYiLvSetViewController.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiNetworkManager.h"
#import "SBJsonParser.h"
#import "ComputeShouYiLvListViewConreoller.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

@implementation ShouYiLvSetViewController

@synthesize shouYilv_lotTitleLabel;
@synthesize shouYilv_betCodeList;

@synthesize  batchCodeButton;
@synthesize  touRuBatchField;
@synthesize  beginBatchField;
@synthesize  allBatchButton;
@synthesize  allShouField;
@synthesize  someBatchButton;
@synthesize  qianBatchField;
@synthesize  qianBatchShouField;
@synthesize  houBatchShouField;
@synthesize isAllOrSome;
//@synthesize biAccountLabel;
@synthesize batchListArr = m_batchListArr;

- (void)dealloc
{
    m_delegate.randomPickerView.delegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getBatchCodeDateOK" object:nil];

    [shouYilv_lotTitleLabel release];
    [shouYilv_betCodeList release];
    
    [batchCodeButton release];
    [touRuBatchField release];
    [beginBatchField release];
    [allBatchButton release];
    [allShouField release];
    [someBatchButton release];
    [qianBatchField release];
    [qianBatchShouField release];
    [houBatchShouField release];
    
    [m_batchListArr release], m_batchListArr = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBatchCodeDateOK:) name:@"getBatchCodeDateOK" object:nil];

//    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"])//机选
//    {
//        self.biAccountLabel.text = [NSString stringWithFormat:@"您共有%@笔投注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
//    }
//    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"])//多注投
//    {
//        self.biAccountLabel.text = [NSString stringWithFormat:@"您共有%d笔投注", [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]];
//    }
    
    [self.shouYilv_betCodeList setTitle:[NSString stringWithFormat:@"%@", [RuYiCaiLotDetail sharedObject].disBetCode] forState:UIControlStateNormal];

    isAllOrSome = YES;
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    
    m_batchListArr = [[NSMutableArray alloc] initWithCapacity:1];
    if([RuYiCaiLotDetail sharedObject].batchCode)
       [self.batchListArr addObject:[RuYiCaiLotDetail sharedObject].batchCode];
        
    if([RuYiCaiLotDetail sharedObject].batchCode)
      [self.batchCodeButton setTitle:[RuYiCaiLotDetail sharedObject].batchCode forState:UIControlStateNormal];
    self.batchCodeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    touRuBatchField.delegate = self;
    beginBatchField.delegate = self;
    allShouField.delegate = self;
    qianBatchField.delegate = self;
    qianBatchShouField.delegate = self;
    houBatchShouField.delegate = self;
    allShouField.enabled = YES;
    qianBatchField.enabled = NO;
    qianBatchShouField.enabled = NO;
    houBatchShouField.enabled = NO;
    
    self.shouYilv_lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_SHOUYILV_BATCH;
    [[RuYiCaiNetworkManager sharedManager] getShouYiLvBatchList:[RuYiCaiLotDetail sharedObject].lotNo];
}

- (IBAction)betCodeClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
}

- (IBAction)allOrSomeButtonClick:(id)sender
{
    if(isAllOrSome)
    {
        isAllOrSome = !isAllOrSome;
        [allBatchButton setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
        [allBatchButton setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
        [someBatchButton setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        [someBatchButton setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
        allShouField.enabled = NO;
        qianBatchField.enabled = YES;
        qianBatchShouField.enabled = YES;
        houBatchShouField.enabled = YES;
    }
    else
    {
        isAllOrSome = !isAllOrSome;
        [allBatchButton setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        [allBatchButton setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
        [someBatchButton setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
        [someBatchButton setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
        allShouField.enabled = YES;
        qianBatchField.enabled = NO;
        qianBatchShouField.enabled = NO;
        houBatchShouField.enabled = NO;
    }
    if(self.view.center.y != 250)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 160;
        self.view.center = center;
        [UIView commitAnimations];
    }
}

- (void)okClick:(id)sender
{
    if([touRuBatchField.text intValue] < 1 || [touRuBatchField.text intValue] > 99)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"投入期数的范围为1～99" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if([beginBatchField.text intValue] < 1 || [beginBatchField.text intValue] > 9999)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"起始倍数的范围为1～9999" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if(isAllOrSome)
    {
        if([allShouField.text intValue] < 1 || [allShouField.text intValue] > 999)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"全程收益率的范围为1～999" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    else
    {
        if([qianBatchField.text intValue] < 1 || [qianBatchField.text intValue] >= [touRuBatchField.text intValue])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"前期数输入不正确！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if([houBatchShouField.text intValue] < 1 || [houBatchShouField.text intValue] > 1000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"前收益率值的范围为1～1000" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if([qianBatchShouField.text intValue] < 1 || [qianBatchShouField.text intValue] > 1000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"后收益率值的范围为1～1000" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_SHOUYILV_COMPUTE;
    [RuYiCaiLotDetail sharedObject].lotMulti = self.beginBatchField.text;

    if(isAllOrSome)//全程
    {
        [[RuYiCaiNetworkManager sharedManager] computeShouYiLvWithLotno:[RuYiCaiLotDetail sharedObject].lotNo batchcode:[self.batchCodeButton currentTitle] batchnum:self.touRuBatchField.text lotmulti:self.beginBatchField.text wholeYield:self.allShouField.text beforeBatchNum:@"" beforeYield:@"" afterYield:@""];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] computeShouYiLvWithLotno:[RuYiCaiLotDetail sharedObject].lotNo batchcode:[self.batchCodeButton currentTitle] batchnum:self.touRuBatchField.text lotmulti:self.beginBatchField.text wholeYield:@"" beforeBatchNum:self.qianBatchField.text beforeYield:self.qianBatchShouField.text afterYield:self.houBatchShouField.text];
    }
}

- (void)getBatchCodeDateOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    [self.batchListArr removeAllObjects];
    NSArray* resultArr = [parserDict objectForKey:@"result"];
    for (int i = 0; i < [resultArr count]; i++)
    {
        [self.batchListArr addObject:[[resultArr objectAtIndex:i] objectForKey:@"batchCode"]];
    }
}

- (IBAction)randomNumSet
{
    if([self.batchListArr count] == 0)
        return;
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:RANDOM_TYPE_BASE];
    [m_delegate.randomPickerView setPickerDataArray:self.batchListArr];
    [m_delegate.randomPickerView setPickerNum:1 withMinNum:1 andMaxNum:[self.batchListArr count]];
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
     [self.batchCodeButton setTitle:[m_delegate.randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
}

#pragma mark textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%f",self.view.center.y);
    if(allShouField == textField || qianBatchField == textField || qianBatchShouField == textField || houBatchShouField == textField)
    {
        if(self.view.center.y != 90)
        {
            [UIView beginAnimations:@"movement" context:nil]; 
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.3f];
            [UIView setAnimationRepeatCount:1];
            [UIView setAnimationRepeatAutoreverses:NO];
            CGPoint center = self.view.center;
            center.y -= 160;
            self.view.center = center;
            [UIView commitAnimations];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [touRuBatchField resignFirstResponder];
    [beginBatchField resignFirstResponder];
    [allShouField resignFirstResponder];
    [qianBatchField resignFirstResponder];
    [qianBatchShouField resignFirstResponder];
    [houBatchShouField resignFirstResponder];
    if(self.view.center.y != 250)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 160;
        self.view.center = center;
        [UIView commitAnimations];
    }

    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [touRuBatchField resignFirstResponder];
    [beginBatchField resignFirstResponder];
    [allShouField resignFirstResponder];
    [qianBatchField resignFirstResponder];
    [qianBatchShouField resignFirstResponder];
    [houBatchShouField resignFirstResponder];
    
     NSLog(@"%f",self.view.center.y);
    
    if(self.view.center.y != 250)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 160;
        self.view.center = center;
        [UIView commitAnimations];
    }
}

- (void)hideKeybord
{
    [touRuBatchField resignFirstResponder];
    [beginBatchField resignFirstResponder];
    [allShouField resignFirstResponder];
    [qianBatchField resignFirstResponder];
    [qianBatchShouField resignFirstResponder];
    [houBatchShouField resignFirstResponder];
    
    NSLog(@"%f",self.view.center.y);
    
    if(self.view.center.y != 250)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 160;
        self.view.center = center;
        [UIView commitAnimations];
    }
}
@end
