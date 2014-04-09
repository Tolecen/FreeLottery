//
//  BatchCodeListView.m
//  RuYiCai
//
//  Created by  on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BatchCodeListView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"

#define LabelSize  (13)

@implementation BatchCodeListView

@synthesize scrollView = m_scrollView;
@synthesize batchCodeDate = m_batchCodeDate;

- (void)dealloc
{
    [m_scrollView release];
    
    [m_batchCodeDate removeAllObjects];
    [m_batchCodeDate release], m_batchCodeDate = nil;
    
    m_batchCodeDate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* viewBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 302, 285)];
        viewBg.image = RYCImageNamed(@"reply_bottom.png");
        [self addSubview:viewBg];
        [viewBg release];
        
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 37, 300, 280)];
        m_scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:m_scrollView];
        
        m_batchCodeDate = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)creatLineWithBathCode:(NSArray*)batchArr withLotMu:(NSInteger)lotmu withAmount:(NSInteger)amount
{
    for(int i = 0; i < [self.batchCodeDate count]; i++)
    {
        UITextField* tempTextField = (UITextField*)[self viewWithTag:TextFeildTagStart + i];
        [tempTextField resignFirstResponder];
    }
    
    m_oneBeiShu = lotmu;
    m_oneAmount = amount;
    
    [self.batchCodeDate removeAllObjects];
    [m_scrollView removeFromSuperview];
    [m_scrollView release];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, 300, 270)];
    m_scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:m_scrollView];
    
    for(int i = 0; i < [batchArr count]; i++)
    {
        UIButton* listButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5 + i * 30, 25, 25)];
        [listButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateNormal];
        [listButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateHighlighted];
        [listButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        listButton.tag = ButtonTagStart + i;
        [self.scrollView addSubview:listButton];
        [listButton release];
        
        UILabel* batchCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5 + i * 30, 110, 25)];
        batchCodeLabel.text = [NSString stringWithFormat:@"%@期", [batchArr objectAtIndex:i]];
        batchCodeLabel.textColor = [UIColor blackColor];
        batchCodeLabel.textAlignment = UITextAlignmentLeft;
        batchCodeLabel.backgroundColor = [UIColor clearColor];
        batchCodeLabel.font = [UIFont systemFontOfSize:LabelSize];
        [self.scrollView addSubview:batchCodeLabel];
        [batchCodeLabel release];
        
        UITextField* lotMuField = [[UITextField alloc] initWithFrame:CGRectMake(150, 5 + i * 30, 50, 25)];
        lotMuField.borderStyle = UITextBorderStyleBezel;
        lotMuField.delegate = self;
        lotMuField.placeholder = @"倍数";
        lotMuField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        lotMuField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        lotMuField.keyboardType = UIKeyboardTypeEmailAddress;
        lotMuField.keyboardAppearance = UIKeyboardAppearanceAlert;
        //lotMuField.clearButtonMode = UITextFieldViewModeWhileEditing;
        lotMuField.autocorrectionType = UITextAutocorrectionTypeNo;
        lotMuField.returnKeyType = UIReturnKeyDone;
        lotMuField.tag = TextFeildTagStart + i;
        lotMuField.textColor = [UIColor blackColor];
        lotMuField.font = [UIFont systemFontOfSize:LabelSize];
        lotMuField.text = [NSString stringWithFormat:@"%d", lotmu];
        [self.scrollView addSubview:lotMuField];
        [lotMuField release];
        
        UILabel* lotmuLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 5 + i * 30, 13, 25)];
        lotmuLabel.text = @"倍";
        lotmuLabel.textColor = [UIColor blackColor];
        lotmuLabel.textAlignment = UITextAlignmentLeft;
        lotmuLabel.backgroundColor = [UIColor clearColor];
        lotmuLabel.font = [UIFont systemFontOfSize:LabelSize];
        [self.scrollView addSubview:lotmuLabel];
        [lotmuLabel release];
        
        UILabel* amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 5 + i * 30, 50, 25)];
        amountLabel.text = [NSString stringWithFormat:@"%d", amount];
        amountLabel.textColor = [UIColor redColor];
        amountLabel.textAlignment = UITextAlignmentRight;
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.font = [UIFont systemFontOfSize:LabelSize];
        amountLabel.tag = AmountLabelTagStart + i;
        [self.scrollView addSubview:amountLabel];
        [amountLabel release];
        
        UILabel* danWeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, 5 + i * 30, 13, 25)];
        danWeiLabel.text = @"元";
        danWeiLabel.textColor = [UIColor blackColor];
        danWeiLabel.textAlignment = UITextAlignmentLeft;
        danWeiLabel.backgroundColor = [UIColor clearColor];
        danWeiLabel.font = [UIFont systemFontOfSize:LabelSize];
        [self.scrollView addSubview:danWeiLabel];
        [danWeiLabel release];
        
        NSMutableDictionary*  tempDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        [tempDic setObject:@"1" forKey:stateKey];
        [tempDic setObject:[batchArr objectAtIndex:i] forKey:batchCodeKey];
        [tempDic setObject:[NSString stringWithFormat:@"%d", lotmu] forKey:lotMuKey];
        [tempDic setObject:[NSString stringWithFormat:@"%d", amount] forKey:amountKey];
        
        [self.batchCodeDate addObject:tempDic];
        [tempDic release];
    }
    self.scrollView.contentSize = CGSizeMake(300, 30 * [batchArr count]);
}

- (void)selectButtonClick:(id)sender
{
    UIButton* tempButton = (UIButton*)sender;
    if([[[self.batchCodeDate objectAtIndex:tempButton.tag - ButtonTagStart] objectForKey:stateKey] isEqualToString:@"1"])
    {
        [tempButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateNormal];
        [tempButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateHighlighted];
        
        [[self.batchCodeDate objectAtIndex:tempButton.tag - ButtonTagStart] setObject:@"0" forKey:stateKey];
    }
    else
    {
        [tempButton setBackgroundImage:[UIImage imageNamed:@"select2_select.png"] forState:UIControlStateNormal];
        [tempButton setBackgroundImage:[UIImage imageNamed:@"select_2.png"] forState:UIControlStateHighlighted];
        
        [[self.batchCodeDate objectAtIndex:tempButton.tag - ButtonTagStart] setObject:@"1" forKey:stateKey];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"batchCodeListFieldEnd" object:nil];
    //NSLog(@"%@", self.batchCodeDate);
}

#pragma mark textFeild delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self.batchCodeDate count] >= 5)
    {
        if(textField.tag >  ([self.batchCodeDate count] - 6) + TextFeildTagStart)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"batchCodeListFieldBegin" object:nil];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if([self.batchCodeDate count] >= 5)
//    {
//        if(textField.tag >  ([self.batchCodeDate count] - 6) + TextFeildTagStart)
//        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"batchCodeListFieldEnd" object:nil];
//        }
//    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    UILabel* tempLabel;

    for (int i = 0; i < textField.text.length; i++)
    {
        UniChar chr = [textField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            textField.text = [NSString stringWithFormat:@"%d", m_oneBeiShu];
            tempLabel = (UILabel*)[self viewWithTag:(AmountLabelTagStart + textField.tag - TextFeildTagStart)];
            tempLabel.text = [NSString stringWithFormat:@"%d", m_oneAmount];
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            textField.text = [NSString stringWithFormat:@"%d", m_oneBeiShu];
            tempLabel = (UILabel*)[self viewWithTag:(AmountLabelTagStart + textField.tag - TextFeildTagStart)];
            tempLabel.text = [NSString stringWithFormat:@"%d", m_oneAmount];
        }
    }

    if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:[RuYiCaiLotDetail sharedObject].lotNo])//高频彩最高倍数为2000
    {
        if([textField.text intValue] <=0 || [textField.text intValue] > 2000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"输入不合法\n倍数范围为1~2000倍" 
                                                     withTitle:@"提示" buttonTitle:@"确定"];
            textField.text = [NSString stringWithFormat:@"%d", m_oneBeiShu];
            tempLabel = (UILabel*)[self viewWithTag:(AmountLabelTagStart + textField.tag - TextFeildTagStart)];
            tempLabel.text = [NSString stringWithFormat:@"%d", m_oneAmount];
        }
        else
        {
            int oneAmount = m_oneAmount/m_oneBeiShu;
            tempLabel = (UILabel*)[self viewWithTag:(AmountLabelTagStart + textField.tag - TextFeildTagStart)];
            tempLabel.text = [NSString stringWithFormat:@"%d", oneAmount * [textField.text intValue]];
        }

    }
    else
    {
        if([textField.text intValue] <=0 || [textField.text intValue] > 200)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"输入不合法\n倍数范围为1~200倍" 
                                                     withTitle:@"提示" buttonTitle:@"确定"];
            textField.text = [NSString stringWithFormat:@"%d", m_oneBeiShu];
            tempLabel = (UILabel*)[self viewWithTag:(AmountLabelTagStart + textField.tag - TextFeildTagStart)];
            tempLabel.text = [NSString stringWithFormat:@"%d", m_oneAmount];
        }
        else
        {
            int oneAmount = m_oneAmount/m_oneBeiShu;
            tempLabel = (UILabel*)[self viewWithTag:(AmountLabelTagStart + textField.tag - TextFeildTagStart)];
            tempLabel.text = [NSString stringWithFormat:@"%d", oneAmount * [textField.text intValue]];
        }
    }
    //NSLog(@"index%d  %d", textField.tag, textField.tag - TextFeildTagStart);
    [[self.batchCodeDate objectAtIndex:textField.tag - TextFeildTagStart] setObject:textField.text forKey:lotMuKey];
    [[self.batchCodeDate objectAtIndex:textField.tag - TextFeildTagStart] setObject:tempLabel.text forKey:amountKey];
}

@end
