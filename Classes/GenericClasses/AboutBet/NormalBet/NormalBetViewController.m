//
//  NormalBetViewController.m
//  RuYiCai
//
//  Created by  on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NormalBetViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"

@implementation NormalBetViewController

@synthesize normalBet_lotTitleLabel;
@synthesize normalBet_allCountLabel;
@synthesize normalBet_zhuShuLabel;
@synthesize normalBet_batchCodeLabel;
@synthesize normalBet_betCodeList;
@synthesize normalBet_sliderBeishu;
@synthesize normalBet_fieldBeishu;
@synthesize biAccountLabel;
@synthesize normalLabelBei;
@synthesize beiLabelBei;

- (void)dealloc
{
    [normalBet_lotTitleLabel release];
    [normalBet_allCountLabel release];
    [normalBet_zhuShuLabel release];
    [normalBet_batchCodeLabel release];
    [normalBet_betCodeList release];
    [normalBet_sliderBeishu release];
    [normalBet_fieldBeishu release];
    [biAccountLabel release];
    [beiLabelBei release];
    if (normalLabelBei) {
        [normalLabelBei release];
    }
    

    [super dealloc];
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    self.normalBet_fieldBeishu.delegate = self;
    
    self.normalBet_sliderBeishu.maximumValue = 2000;
    self.normalBet_sliderBeishu.minimumValue = 1.0;
    self.normalBet_sliderBeishu.value = 1.0;
    self.normalBet_fieldBeishu.text = @"1";
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//机选
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%@笔投注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
    }
    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"])//多注投
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%d笔投注", [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]];
    }
    
    allCount = [[RuYiCaiLotDetail sharedObject].amount intValue];

    self.normalBet_lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    
    self.normalBet_allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆",[[RuYiCaiLotDetail sharedObject].amount intValue]/100*aas];
    self.normalBet_zhuShuLabel.text = [NSString stringWithFormat:@"共%@注",[RuYiCaiLotDetail sharedObject].zhuShuNum];
    

    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].batchCode);
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].disBetCode);
    
    self.normalBet_batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
    
    [self.normalBet_betCodeList setTitle:[NSString stringWithFormat:@"%@", [RuYiCaiLotDetail sharedObject].disBetCode] forState:UIControlStateNormal];
    if ([CanChooseBeiShu isEqualToString:@"NO"]) {
        //        [self.fieldBeishu setFrame:CGRectMake(zhuShuLabel.frame.origin.x, self.fieldBeishu.frame.origin.y, self.fieldBeishu.frame.size.width, self.fieldBeishu.frame.size.height)];
        //        [self.beiLabelBei setFrame:CGRectMake(self.fieldBeishu.frame.origin.x+self.fieldBeishu.frame.size.width+5, self.beiLabelBei.frame.origin.y, self.beiLabelBei.frame.size.width, self.beiLabelBei.frame.size.height)];
        
        
        self.normalLabelBei = [[UILabel alloc] initWithFrame:CGRectMake(normalBet_zhuShuLabel.frame.origin.x, 196, 100, 20)];
        [self.normalLabelBei setBackgroundColor:[UIColor clearColor]];
        [self.normalLabelBei setText:@"1倍"];
        [self.view addSubview:self.normalLabelBei];
        
        
        self.normalBet_sliderBeishu.hidden = YES;
        self.normalBet_fieldBeishu.hidden = YES;
        self.beiLabelBei.hidden = YES;
    }
}

- (IBAction)sliderBeishuChange:(id)sender
{
    int numBeishu = (int)(self.normalBet_sliderBeishu.value + 0.5f);
    self.normalBet_fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
    
    int aCount = allCount/100 * numBeishu;
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.normalBet_allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", aCount*aas];
}

- (IBAction)betCodeClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
}

- (BOOL)normalBetCheck
{
    for (int i = 0; i < self.normalBet_fieldBeishu.text.length; i++)
    {
        UniChar chr = [self.normalBet_fieldBeishu.text characterAtIndex:i];
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
    if([self.normalBet_fieldBeishu.text intValue] <= 0 || [self.normalBet_fieldBeishu.text intValue] > 2000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～2000" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}

- (void)buildBetCode
{
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].betCode);
    int numBeishu = (int)(self.normalBet_sliderBeishu.value + 0.5f);
    
    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].lotMulti);
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d",allCount * numBeishu];
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].amount); 
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [RuYiCaiLotDetail sharedObject].amount;
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].betCode);
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"0"])
    {
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].betCode stringByAppendingFormat:@"_%d_200_%d", numBeishu, allCount];
        NSLog(@"%@",[RuYiCaiLotDetail sharedObject].betCode);
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
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_200_%d!", numBeishu, 200];
            }
            else
            {
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_200_%d", numBeishu, 200];
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
            if(i != [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count] - 1)
                 [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_200_%@!",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti, [[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_AMOUNT]];
            else
                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_200_%@",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti, [[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_AMOUNT]];
            //NSLog(@"aaaa %@", [RuYiCaiLotDetail sharedObject].moreZuBetCode);
        }
    }
}

#pragma mark textField and touch delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.normalBet_fieldBeishu resignFirstResponder];
    if(self.view.center.y != 150)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 100;
        self.view.center = center;
        [UIView commitAnimations];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%f",self.view.center.y);
    if(self.view.center.y != 50)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y -= 100;
        self.view.center = center;
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i = 0; i < textField.text.length; i++)
    {
        UniChar chr = [textField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            self.normalBet_fieldBeishu.text = @"1";
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            self.normalBet_fieldBeishu.text = @"1";
        }
    }
    if([textField.text intValue] <= 0 || [textField.text intValue] > 2000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高倍数的范围为1～2000" withTitle:@"提示" buttonTitle:@"确定"];
        self.normalBet_fieldBeishu.text = @"1";
    }
    self.normalBet_sliderBeishu.value = [self.normalBet_fieldBeishu.text floatValue];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.normalBet_allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", [normalBet_fieldBeishu.text intValue] * (allCount/100) * aas];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.normalBet_fieldBeishu resignFirstResponder];
    if(self.view.center.y != 150)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 100;
        self.view.center = center;
        [UIView commitAnimations];
    }
}

- (void)hideKeybord
{
    [self.normalBet_fieldBeishu resignFirstResponder];
    if(self.view.center.y != 150)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 100;
        self.view.center = center;
        [UIView commitAnimations];
    }
}

@end
