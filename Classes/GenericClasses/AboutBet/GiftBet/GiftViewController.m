//
//  GiftViewController.m
//  RuYiCai
//
//  Created by haojie on 11-12-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GiftViewController.h"
#import "RuYiCaiLotDetail.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

@implementation GiftViewController

@synthesize lotTitleLabel;
@synthesize batchCodeLabel;
//@synthesize batchEndTimeLabel;
@synthesize betCodeList;
@synthesize zhuShuLabel;
@synthesize biAccountLabel;

@synthesize adviceTextView = m_adviceTextView;
@synthesize numTextView = m_numTextView;
@synthesize amountLabel = m_amountLabel;
@synthesize geneButton = m_geneButton;
@synthesize phoneBookButton = m_phoneBookButton;

@synthesize zhuiJiaLabel;
@synthesize zhuiJiaSwitch;
@synthesize sliderBeishu;
@synthesize fieldBeishu;

- (void)dealloc
{	
    [lotTitleLabel release];
    [batchCodeLabel release];
//    [batchEndTimeLabel release];
    [betCodeList release];
    [zhuShuLabel release];
    [biAccountLabel release];

	[m_adviceTextView release];
	[m_numTextView release];
	[m_amountLabel release];
	[m_geneButton release];
	[m_phoneBookButton release];
    	
    [zhuiJiaLabel release];
    [zhuiJiaSwitch release];
    [sliderBeishu release];
    [fieldBeishu release];
	[super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(cancelButtonClick)] autorelease];
    
    self.fieldBeishu.delegate = self;
    
    self.sliderBeishu.maximumValue = 200;
    self.sliderBeishu.minimumValue = 1.0;
    self.sliderBeishu.value = 1.0;
    self.fieldBeishu.text = @"1";
    
    zhuiJiaSwitch.on = NO;
   if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoDLT] && [RuYiCaiLotDetail sharedObject].isDLTOr11X2)
	{
        zhuiJiaLabel.hidden = NO;
        zhuiJiaSwitch.hidden = NO;
    }
    else
    {
        zhuiJiaLabel.hidden = YES;
        zhuiJiaSwitch.hidden = YES;
    }
    	
	self.adviceTextView.delegate = self;
	self.adviceTextView.layer.cornerRadius = 8;
	self.adviceTextView.layer.masksToBounds = YES;
	self.adviceTextView.font = [UIFont systemFontOfSize:14];
	
	self.numTextView.delegate = self;
	self.numTextView.layer.cornerRadius = 8;
	self.numTextView.layer.masksToBounds = YES;
	self.numTextView.font = [UIFont systemFontOfSize:14];
	    
    self.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    
	zhuShuLabel.text = [NSString stringWithFormat:@"共%@注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
    self.batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//    self.batchEndTimeLabel.text = [RuYiCaiLotDetail sharedObject].batchEndTime;
    [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", [RuYiCaiLotDetail sharedObject].disBetCode] forState:UIControlStateNormal];
	if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//机选 幸运选号
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%@笔投注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
    }
    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"])//多注投
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%d笔投注", [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]];
    }
	[self.geneButton addTarget:self action:@selector(geneButtonClick) forControlEvents:UIControlEventTouchUpInside];
	[self.phoneBookButton addTarget:self action:@selector(phoneBookButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self refreshTopView];
}

- (void)refreshTopView
{
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    
    if(self.zhuiJiaSwitch.on)
    {
        allAmount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    }
    else
    {
        allAmount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    }
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.amountLabel.text = [NSString stringWithFormat:@"共%d彩豆", allAmount*aas];
}

- (IBAction)zhuiJiaSwitchChange:(id)sender 
{
    [self refreshTopView];
}


- (IBAction)sliderBeishuChange:(id)sender
{ 
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
    
    [self refreshTopView];
}

- (IBAction)betCodeClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
}

- (void)geneButtonClick
{
//	[self.adviceTextView resignFirstResponder];
//	[self.numTextView resignFirstResponder];

    [self hideKeybord];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"giftWordButtonClick" object:nil];
}

#pragma mark Show all contacts
- (void)phoneBookButtonClick
{
//	[self.adviceTextView resignFirstResponder];
//	[self.numTextView resignFirstResponder];
	[self hideKeybord];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"phoneButtonClick" object:nil];
}

#pragma mark buttonClick
- (void)sureButonClick
{
	if(m_numTextView.text.length == 0)
	{
		[[RuYiCaiNetworkManager sharedManager] showMessage:@"赠送号码不能为空" withTitle:@"提示" buttonTitle:@"确定"];
	}
	else
	{
        [self buildBetCode];
        
		[RuYiCaiLotDetail sharedObject].advice = self.adviceTextView.text;
		[RuYiCaiLotDetail sharedObject].betType = @"gift";
		[RuYiCaiLotDetail sharedObject].toMobileCode = self.numTextView.text;
        int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
        [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
        [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单笔总金额（多注投)
		[[RuYiCaiNetworkManager sharedManager] betLotery:dict];
	}
}

- (void)buildBetCode
{
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    
    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    
    int aCount;
    int oneAmount;
    int oneBiAmount;//单笔金额
    if(self.zhuiJiaSwitch.on)
    {
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
        [RuYiCaiLotDetail sharedObject].oneAmount = @"300";
        oneAmount = 300;
        oneBiAmount = [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * 300;//普通投注
    }
    else
    {
        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
        [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
        oneAmount = 200;
        oneBiAmount = [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * 200;
    }
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", aCount * 100];  
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [RuYiCaiLotDetail sharedObject].amount;
    
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"0"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"4"])
    {
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].betCode stringByAppendingFormat:@"_%d_%d_%d", numBeishu, oneAmount, oneBiAmount];
    }
    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//机选
    {
        NSArray*  eachBetCode = [[RuYiCaiLotDetail sharedObject].betCode componentsSeparatedByString:@";"];
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
        for(int i = 0; i < [eachBetCode count]; i++)
        {
            NSString*  aStr;
            if(i != [eachBetCode count] -1)
            {
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%d_%d!", numBeishu, oneAmount, oneAmount];
            }
            else
            {
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%d_%d", numBeishu, oneAmount, oneAmount];
            }
            [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@", aStr];
        }
    }
    else //多注投
    {
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
        NSLog(@"%@", [RuYiCaiLotDetail sharedObject].moreBetCodeInfor);
        for(int i = 0; i < [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count]; i++)
        {   
            oneBiAmount = [[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_ZHUSHU] intValue] * [[RuYiCaiLotDetail sharedObject].oneAmount intValue];
            
            if(i != [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count] - 1)
                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d!",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti, [RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
            else
                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti,[RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
            NSLog(@"aaaa %@", [RuYiCaiLotDetail sharedObject].moreZuBetCode);
        }
    }
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.fieldBeishu)
    {
        for (int i = 0; i < textField.text.length; i++)
        {
            UniChar chr = [textField.text characterAtIndex:i];
            if ('0' == chr && 0 == i)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
                self.fieldBeishu.text = @"1";
            }
            else if (chr < '0' || chr > '9')
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
                self.fieldBeishu.text = @"1";
            }
        }
        if([textField.text intValue] <= 0 || [textField.text intValue] > 200)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
            self.fieldBeishu.text = @"1";
        }
        self.sliderBeishu.value = [self.fieldBeishu.text floatValue];
        [self refreshTopView];
    }
    if(self.view.center.y != 245)
    {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 200;
        self.view.center = center;
        [UIView commitAnimations];
    }
}

#pragma  make textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
	
    if ([@"\n" isEqualToString:text] == YES)
	{
		if(m_numTextView == textView)
		{
			[textView resignFirstResponder];
            if(self.view.center.y != 245)
            {
                [UIView beginAnimations:@"movement" context:nil]; 
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDuration:0.3f];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationRepeatAutoreverses:NO];
                CGPoint center = self.view.center;
                center.y += 200;
                self.view.center = center;
                [UIView commitAnimations];
            }
			return NO;
		}
		else
		{
			return YES;
		}
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"%f", self.view.center.y);

    if(self.view.center.y != 45)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y -= 200;
        self.view.center = center;
        [UIView commitAnimations];
    }
    return YES;
}

#pragma mark touch
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    [self.fieldBeishu resignFirstResponder];
	[self.adviceTextView resignFirstResponder];
	[self.numTextView resignFirstResponder];
	if(self.view.center.y != 245)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 200;
        self.view.center = center;
        [UIView commitAnimations];
    }
}

- (void)hideKeybord
{
    [self.fieldBeishu resignFirstResponder];
    [self.adviceTextView resignFirstResponder];
	[self.numTextView resignFirstResponder];
    
    NSLog(@"%f", self.view.center.y);
	if(self.view.center.y != 245)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 200;
        self.view.center = center;
        [UIView commitAnimations];
    }
}
	 
@end
