//
//  ZhuiHaoBetViewController.m
//  RuYiCai
//
//  Created by  on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZhuiHaoBetViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "BatchCodeListView.h"
#import "SBJsonParser.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

@implementation ZhuiHaoBetViewController

@synthesize zhuiHao_lotTitleLabel;
@synthesize zhuiHao_allCountLabel;
//@synthesize zhuiHao_freezeLabel;
@synthesize zhuiHao_zhuShuLabel;
@synthesize zhuiHao_batchCodeLabel;
//@synthesize zhuiHao_batchEndTimeLabel;
@synthesize zhuiHao_betCodeList;
@synthesize zhuiHao_sliderBeishu;
@synthesize zhuiHao_fieldBeishu;
@synthesize zhuiHao_sliderQishu;
@synthesize zhuiHao_fieldQishu;
@synthesize biAccountLabel;

@synthesize batchCodeListView = m_batchCodeListView;
@synthesize batchCodeButton;

@synthesize zhuiJiaLabel;
@synthesize zhuiJiaSwitch;
@synthesize isBatchCodeAdjust;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"batchCodeListFieldBegin" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"batchCodeListFieldEnd" object:nil];

    [zhuiHao_lotTitleLabel release];
    [zhuiHao_allCountLabel release];
    //[zhuiHao_freezeLabel release];
    [zhuiHao_zhuShuLabel release];
    [biAccountLabel release];

    [zhuiHao_batchCodeLabel release];
//    [zhuiHao_batchEndTimeLabel release];
    [zhuiHao_betCodeList release];
    [zhuiHao_sliderBeishu release];
    [zhuiHao_fieldBeishu release];
    [zhuiHao_sliderQishu release];
    [zhuiHao_fieldQishu release];
    
    [m_batchCodeListView release];
    [batchCodeButton release];
    
    [zhuiJiaLabel release];
    [zhuiJiaSwitch release];
        
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batchCodeListFieldBegin:) name:@"batchCodeListFieldBegin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batchCodeListFieldEnd:) name:@"batchCodeListFieldEnd" object:nil];

    isBatchCodeAdjust = NO;
    
    allCount = [[RuYiCaiLotDetail sharedObject].amount intValue];
    
    [RuYiCaiLotDetail sharedObject].prizeend = @"1";//默认
    
    self.zhuiHao_fieldBeishu.delegate = self;
    self.zhuiHao_fieldQishu.delegate = self;
    
    [self setMainView];
}

- (void)refreshZhuiHaoView
{
    int numQishu = (int)(self.zhuiHao_sliderQishu.value + 0.5f);        
    int numBeishu = (int)(self.zhuiHao_sliderBeishu.value + 0.5f);
    int aCount;
    if(self.zhuiJiaSwitch.on)
    {
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
    }
    else
    {
        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
    }
    self.zhuiHao_allCountLabel.text = [NSString stringWithFormat:@"共%d元", aCount];
}

- (void)setMainView
{
    if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:[RuYiCaiLotDetail sharedObject].lotNo])
        self.zhuiHao_sliderBeishu.maximumValue = 2000;
    else
        self.zhuiHao_sliderBeishu.maximumValue = 200;
    self.zhuiHao_sliderBeishu.minimumValue = 1.0;
    self.zhuiHao_sliderBeishu.value = 1.0;
    self.zhuiHao_fieldBeishu.text = @"1";
    self.zhuiHao_sliderQishu.maximumValue = 200;
    self.zhuiHao_sliderQishu.minimumValue = 1.0;
    self.zhuiHao_sliderQishu.value = 20.0;
    self.zhuiHao_fieldQishu.text = @"20";
    
    self.zhuiHao_allCountLabel.text = [NSString stringWithFormat:@"共%d元",([[RuYiCaiLotDetail sharedObject].amount intValue]/100 * 20)];
    self.zhuiHao_zhuShuLabel.text = [NSString stringWithFormat:@"共%@注",[RuYiCaiLotDetail sharedObject].zhuShuNum];
    self.zhuiHao_batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
    
    [self.zhuiHao_betCodeList setTitle:[NSString stringWithFormat:@"%@", [RuYiCaiLotDetail sharedObject].disBetCode] forState:UIControlStateNormal];

    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//机选
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%@笔投注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
    }
    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"])//多注投
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%d笔投注", [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]];
    }
    
    m_batchCodeListView = [[BatchCodeListView alloc] initWithFrame:CGRectMake(0, 406, 320, 260)];
    m_batchCodeListView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_batchCodeListView];
    m_batchCodeListView.hidden = YES;
    
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

    self.zhuiHao_lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
}

- (IBAction)zhuiJiaSwitchChange:(id)sender 
{
//    int numQishu = (int)(self.zhuiHao_sliderQishu.value + 0.5f);    
//    int numBeishu = (int)(self.zhuiHao_sliderBeishu.value + 0.5f);
//    int aCount;
//    
//    UISwitch* tempSwit = (UISwitch*)sender;
//    if(tempSwit.on)
//    {
//        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
//    }
//    else
//    {
//        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
//    }
//    self.zhuiHao_allCountLabel.text = [NSString stringWithFormat:@"共%d元", aCount];
    //[RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", aCount * 100];
    [self refreshZhuiHaoView];
    
    isBatchCodeAdjust = YES;
    [self batchCodeAdjust:nil];
}

- (IBAction)batchCodeAdjust:(id)sender
{
    [self hideKeybord];
    if(isBatchCodeAdjust)
    {
        isBatchCodeAdjust = !isBatchCodeAdjust;
        [batchCodeButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlisthide.png") forState:UIControlStateNormal];
        [batchCodeButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlistexpand.png") forState:UIControlStateHighlighted];
        self.batchCodeListView.hidden = YES;
    }
    else
    {
        isBatchCodeAdjust = !isBatchCodeAdjust;
        [batchCodeButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlistexpand.png") forState:UIControlStateNormal];
        [batchCodeButton setBackgroundImage:RYCImageNamed(@"jclq_sectionlisthide.png") forState:UIControlStateHighlighted];
        self.batchCodeListView.hidden = NO;
        
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempDic setObject:@"QueryLot" forKey:@"command"];
        [tempDic setObject:@"afterIssue" forKey:@"type"];
        [tempDic setObject:[NSString stringWithFormat:@"%d", [self.zhuiHao_fieldQishu.text intValue]] forKey:@"batchnum"];
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
        
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
        [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
    }
}

- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    
    NSArray* resultArr = [parserDict objectForKey:@"result"];
    NSMutableArray* batchCodeArray = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < [resultArr count]; i++)
    {
        [batchCodeArray addObject:[[resultArr objectAtIndex:i] objectForKey:@"batchCode"]];
    }
    int numBeishu = (int)(self.zhuiHao_sliderBeishu.value + 0.5f);
    //int aCount = allCount/100 * numBeishu;
    int aCount;
    if(self.zhuiJiaSwitch.on)
    {
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu ;
    }
    else
    {
        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu ;
    }
    [self.batchCodeListView creatLineWithBathCode:batchCodeArray withLotMu:numBeishu withAmount:aCount];
}

- (IBAction)sliderBeishuChange:(id)sender
{
    int numBeishu = (int)(self.zhuiHao_sliderBeishu.value + 0.5f);
    self.zhuiHao_fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
//    int numQishu = (int)(self.zhuiHao_sliderQishu.value + 0.5f);
//    
//    int aCount;
//    if(self.zhuiJiaSwitch.on)
//    {
//        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
//    }
//    else
//    {
//        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
//    }
//    self.zhuiHao_allCountLabel.text = [NSString stringWithFormat:@"共%d元", aCount];
    
    [self refreshZhuiHaoView];

    isBatchCodeAdjust = YES;
    [self batchCodeAdjust:nil];
}

- (IBAction)sliderQishuChange:(id)sender
{
    int numQishu = (int)(self.zhuiHao_sliderQishu.value + 0.5f);
    self.zhuiHao_fieldQishu.text = [NSString stringWithFormat:@"%d", numQishu];
    
//    int numBeishu = (int)(self.zhuiHao_sliderBeishu.value + 0.5f);
//
//    int aCount;
//    if(self.zhuiJiaSwitch.on)
//    {
//        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
//    }
//    else
//    {
//        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
//    }
//    self.zhuiHao_allCountLabel.text = [NSString stringWithFormat:@"共%d元", aCount];
    
    [self refreshZhuiHaoView];

    isBatchCodeAdjust = YES;
    [self batchCodeAdjust:nil];
}

- (IBAction)switchChange:(UISwitch*)sender
{
    if(sender.on)
    {
        [RuYiCaiLotDetail sharedObject].prizeend = @"1";
    }
    else
    {
        [RuYiCaiLotDetail sharedObject].prizeend = @"0";
    }
}

- (IBAction)betCodeClick:(id)sender
{
     [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
}

- (BOOL)zhuiHaoBetCheck
{
    for (int i = 0; i < zhuiHao_fieldBeishu.text.length; i++)
    {
        UniChar chr = [zhuiHao_fieldBeishu.text characterAtIndex:i];
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
    if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:[RuYiCaiLotDetail sharedObject].lotNo])
    {
        if([zhuiHao_fieldBeishu.text intValue] <= 0 || [zhuiHao_fieldBeishu.text intValue] > 2000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高倍数的范围为1～2000" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    else
    {
        if([zhuiHao_fieldBeishu.text intValue] <= 0 || [zhuiHao_fieldBeishu.text intValue] > 200)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高倍数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }

//    if([zhuiHao_fieldBeishu.text intValue] <= 0 || [zhuiHao_fieldBeishu.text intValue] > 200)
//    {
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高倍数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
//        return NO;
//    }
    
    for (int i = 0; i < self.zhuiHao_fieldQishu.text.length; i++)
    {
        UniChar chr = [self.zhuiHao_fieldQishu.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    if([self.zhuiHao_fieldQishu.text intValue] <= 0 || [self.zhuiHao_fieldQishu.text intValue] > 200)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}

- (void)buildBetCode
{
    int numBeishu = (int)(self.zhuiHao_sliderBeishu.value + 0.5f);
    int numQishu = (int)(self.zhuiHao_sliderQishu.value + 0.5f);
    
    [RuYiCaiLotDetail sharedObject].batchNum = [NSString stringWithFormat:@"%d", numQishu];
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    
    int aCount;
    int oneBiAmount;//单笔金额
    
    if(self.zhuiJiaSwitch.on)
    {
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
        [RuYiCaiLotDetail sharedObject].oneAmount = @"300";
        oneBiAmount = [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * 300;
    }
    else
    {
        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
        [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
        oneBiAmount = allCount;
    }
    if (isBatchCodeAdjust)
    {
        NSMutableArray* tempArray = self.batchCodeListView.batchCodeDate;
        NSInteger  allAmount = 0;
        BOOL   isSameBeiShu = YES;//取第一个倍数
        for(int i = 0; i < [tempArray count]; i++)
        {
            if([[[tempArray objectAtIndex:i] objectForKey:stateKey] isEqualToString:@"1"])
            {
                allAmount += [[[self.batchCodeListView.batchCodeDate objectAtIndex:i] objectForKey:amountKey] intValue];
                if(isSameBeiShu)
                {
                    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%@", [[tempArray objectAtIndex:i] objectForKey:lotMuKey]];
                    isSameBeiShu = NO;
                }
            }
        }
        if(allAmount != 0)
            [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", allAmount * 100];
        else
            [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", aCount * 100];
    }
    else
    {
        [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", aCount * 100];
    }

    [RuYiCaiLotDetail sharedObject].moreZuAmount = [RuYiCaiLotDetail sharedObject].amount;
    
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"0"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"4"])
    {
        [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].betCode stringByAppendingFormat:@"_%d_%@_%d", numBeishu, [RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
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
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%@_%@!", numBeishu, [RuYiCaiLotDetail sharedObject].oneAmount, [RuYiCaiLotDetail sharedObject].oneAmount];
            }
            else
            {
                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%@_%@", numBeishu, [RuYiCaiLotDetail sharedObject].oneAmount, [RuYiCaiLotDetail sharedObject].oneAmount];
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
            oneBiAmount = ([[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_ZHUSHU] intValue]) * [[RuYiCaiLotDetail sharedObject].oneAmount intValue];
            
            if(i != [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count] - 1)
                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d!",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti, [RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
            else
                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti,[RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
           // NSLog(@"aaaa %@", [RuYiCaiLotDetail sharedObject].moreZuBetCode);
        }
    }
    if (isBatchCodeAdjust)
    {
        NSString* subscribeInfo = [self buildSubscribeInfo];
        [RuYiCaiLotDetail sharedObject].subscribeInfo = subscribeInfo;
    }
    else
    {
        [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    }
    NSLog(@"aaaa %@", [RuYiCaiLotDetail sharedObject].moreZuBetCode);
}

- (NSString*)buildSubscribeInfo
{
    NSString* tempStr = @"";
    NSMutableArray* tempArray = self.batchCodeListView.batchCodeDate;
    if(0 != [tempArray count])
    {
        for(int i = 0; i < [tempArray count]; i++)
        {
            if([[[tempArray objectAtIndex:i] objectForKey:stateKey] isEqualToString:@"1"])
            {
                tempStr = [tempStr stringByAppendingFormat:@"%@,",[[tempArray objectAtIndex:i] objectForKey:batchCodeKey]];
                tempStr = [tempStr stringByAppendingFormat:@"%d,",[[[tempArray objectAtIndex:i] objectForKey:amountKey] intValue]*100];

                if((i != [tempArray count] - 1))
                {
                    if((i == [tempArray count] - 2) && [[[tempArray objectAtIndex:[tempArray count] - 1] objectForKey:stateKey] isEqualToString:@"0"])
                    {
                        tempStr = [tempStr stringByAppendingFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:lotMuKey]];
                    }
                    else
                      tempStr = [tempStr stringByAppendingFormat:@"%@!",[[tempArray objectAtIndex:i] objectForKey:lotMuKey]];
                }
                else
                {
                    tempStr = [tempStr stringByAppendingFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:lotMuKey]];
                }
            }
        }
    }
    return tempStr;
}

#pragma mark textField and touch delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.zhuiHao_fieldQishu resignFirstResponder];
    [self.zhuiHao_fieldBeishu resignFirstResponder];
    NSLog(@"%f",self.view.center.y);

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(zhuiHao_fieldBeishu == textField)
    {
        for (int i = 0; i < textField.text.length; i++)
        {
            UniChar chr = [textField.text characterAtIndex:i];
            if ('0' == chr && 0 == i)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
                self.zhuiHao_fieldBeishu.text = @"1";
            }
            else if (chr < '0' || chr > '9')
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
                self.zhuiHao_fieldBeishu.text = @"1";
            }
        }
        if([[CommonRecordStatus commonRecordStatusManager] isHeighLot:[RuYiCaiLotDetail sharedObject].lotNo])
        {
            if([textField.text intValue] <= 0 || [textField.text intValue] > 2000)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高倍数的范围为1～2000" withTitle:@"提示" buttonTitle:@"确定"];
                self.zhuiHao_fieldBeishu.text = @"1";
            }
        }
        else
        {
            if([textField.text intValue] <= 0 || [textField.text intValue] > 200)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高倍数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
                self.zhuiHao_fieldBeishu.text = @"1";
            }
        }
        self.zhuiHao_sliderBeishu.value = [self.zhuiHao_fieldBeishu.text floatValue];
    }
    else if(zhuiHao_fieldQishu == textField)
    {
        for (int i = 0; i < textField.text.length; i++)
        {
            UniChar chr = [textField.text characterAtIndex:i];
            if ('0' == chr && 0 == i)
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
                self.zhuiHao_fieldQishu.text = @"1";
            }
            else if (chr < '0' || chr > '9')
            {
                [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
                self.zhuiHao_fieldQishu.text = @"1";
            }
        }
        if([textField.text intValue] <= 0 || [textField.text intValue] > 200)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高期数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
            self.zhuiHao_fieldQishu.text = @"1";
        }
        self.zhuiHao_sliderQishu.value = [self.zhuiHao_fieldQishu.text floatValue];
    }
    int numQishu = (int)(self.zhuiHao_sliderQishu.value + 0.5f);        
    int numBeishu = (int)(self.zhuiHao_sliderBeishu.value + 0.5f);
    int aCount;
    if(self.zhuiJiaSwitch.on)
    {
        aCount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
    }
    else
    {
        aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu * numQishu;
    }
    self.zhuiHao_allCountLabel.text = [NSString stringWithFormat:@"共%d元", aCount];
    
    isBatchCodeAdjust = YES;
    [self batchCodeAdjust:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    [self.zhuiHao_fieldBeishu resignFirstResponder];
    [self.zhuiHao_fieldQishu resignFirstResponder];
}

- (void)batchCodeListFieldBegin:(NSNotification*)notification
{
    if(self.view.center.y != 153)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y -= 195;
        self.view.center = center;
        [UIView commitAnimations];
    }
    self.zhuiHao_fieldBeishu.enabled = NO;
    self.zhuiHao_fieldQishu.enabled = NO;
}

- (void)batchCodeListFieldEnd:(NSNotification*)notification
{
    NSLog(@"%f",self.view.center.y);
    if(self.view.center.y != 348)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 195;
        self.view.center = center;
        [UIView commitAnimations];
    }
    self.zhuiHao_fieldBeishu.enabled = YES;
    self.zhuiHao_fieldQishu.enabled = YES;

    NSMutableArray* tempArray = self.batchCodeListView.batchCodeDate;
    NSInteger  allAmount = 0;
    NSInteger  allBatchCode = 0;
    NSInteger  allBeiShu = 0;

    for(int i = 0; i < [tempArray count]; i++)
    {
        if([[[tempArray objectAtIndex:i] objectForKey:stateKey] isEqualToString:@"1"])
        {
            allAmount += [[[self.batchCodeListView.batchCodeDate objectAtIndex:i] objectForKey:amountKey] intValue];
            allBatchCode ++;
            allBeiShu += [[[self.batchCodeListView.batchCodeDate objectAtIndex:i] objectForKey:lotMuKey] intValue];
        }
    }
    if(0 == allAmount)
    {
        [self refreshZhuiHaoView];
        isBatchCodeAdjust = YES;
        [self batchCodeAdjust:nil];
    }
    else
    {
        self.zhuiHao_allCountLabel.text = [NSString stringWithFormat:@"共%d元", allAmount];
        self.zhuiHao_sliderQishu.value = allBatchCode;
        self.zhuiHao_fieldQishu.text = [NSString stringWithFormat:@"%d", allBatchCode];
    }
    if (1 == allBatchCode)
    {
        self.zhuiHao_sliderBeishu.value = allBeiShu;
        self.zhuiHao_fieldBeishu.text = [NSString stringWithFormat:@"%d", allBeiShu];
    }
}

- (void)hideKeybord
{
    [self.zhuiHao_fieldQishu resignFirstResponder];
    [self.zhuiHao_fieldBeishu resignFirstResponder];
    NSLog(@"%f",self.view.center.y);
    if(self.view.center.y != 348)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.view.center;
        center.y += 195;
        self.view.center = center;
        [UIView commitAnimations];
    }
    self.zhuiHao_fieldBeishu.enabled = YES;
    self.zhuiHao_fieldQishu.enabled = YES;
}

@end
