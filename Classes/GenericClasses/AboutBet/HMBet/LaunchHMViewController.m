//
//  LaunchHMViewController.m
//  RuYiCai
//
//  Created by haojie on 11-11-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LaunchHMViewController.h"
#import "RandomPickerViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiLotDetail.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "AdaptationUtils.h"

@interface LaunchHMViewController (internal)

- (void)setupNavigationBar;
- (void)yesSaveButtonClick;
- (void)noSaveButtonClick;
- (void)hasPublicOneButtonClick;
- (void)hasPublicTwoButtonClick;
- (void)hasPublicThereButtonClick;
- (void)hasPublicForeButtonClick;
- (void)hasPublicFiveButtonClick;

- (void)back:(id)sender;
- (void)randomNumSet;

- (void)launchHMOK:(NSNotification*)notification;
@end

@implementation LaunchHMViewController

@synthesize lotTitleLabel;
@synthesize batchCodeLabel;
//@synthesize batchEndTimeLabel;
@synthesize betCodeList;

@synthesize allCountLabel = m_allCountLabel;
@synthesize zhuShuLabel = m_zhuShuLabel;
@synthesize biAccountLabel;
@synthesize buyByTotal = m_buyByTotal;
@synthesize saveByTotal = m_saveByTotal;
@synthesize buyField = m_buyField;
@synthesize lowField = m_lowField;
@synthesize saveField = m_saveField;
@synthesize desText = m_desText;
@synthesize yesSave = m_yesSave;
@synthesize noSave = m_noSave;
@synthesize buttonOne = m_buttonOne;
@synthesize buttonTwo = m_buttonTwo;
@synthesize buttonThere = m_buttonThere;
@synthesize buttonFore = m_buttonFore;
@synthesize buttonFive = m_buttonFive;
@synthesize getButton = m_getButton;

@synthesize zhuiJiaLabel;
@synthesize zhuiJiaSwitch;
@synthesize sliderBeishu;
@synthesize fieldBeishu;

- (void)dealloc 
{
    m_delegate.randomPickerView.delegate = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"launchHMOK" object:nil];
    
    [lotTitleLabel release];
    [batchCodeLabel release];
    [betCodeList release];
    [biAccountLabel release];

	[m_allCountLabel release];
	[m_zhuShuLabel release];
	[m_buyByTotal release];
	[m_saveByTotal release];
	
	[m_buyField release];
	[m_lowField release];
	[m_saveField release];
	
	[m_desText release];
	
	[m_yesSave release];
	[m_noSave release];
	[m_buttonOne release];
	[m_buttonTwo release];
    [m_buttonThere release];
	[m_buttonFore release];
	[m_buttonFive release];
	[m_getButton release];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchHMOK:) name:@"launchHMOK" object:nil];
    
	[self setupNavigationBar];
		
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
    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"] || [[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"3"])//机选
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%@笔投注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
    }
    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"2"])//多注投
    {
        biAccountLabel.text = [NSString stringWithFormat:@"您共有%d笔投注", [[RuYiCaiLotDetail sharedObject].moreDisBetCodeInfor count]];
    }

    self.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    
    m_buyField.delegate = self;
	m_lowField.delegate = self;
	m_saveField.delegate = self;
	
	m_desText.delegate = self;
	m_desText.layer.cornerRadius = 8;
	m_desText.layer.masksToBounds = YES;
	
	m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;

	m_getNum = 10;
    m_getButton = [[UIButton alloc] initWithFrame:CGRectMake(95, 453, 67, 28)];
    [m_getButton setBackgroundImage:RYCImageNamed(@"list_normal.png") forState:UIControlStateNormal];
    [m_getButton setBackgroundImage:RYCImageNamed(@"list_click.png") forState:UIControlStateHighlighted];
    [m_getButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_getButton setTitle:[NSString stringWithFormat:@"%d", m_getNum] forState:UIControlStateNormal];
    [m_getButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 22)];
    [m_getButton addTarget:self action:@selector(randomNumSet) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_getButton];

	m_zhuShuLabel.text = [NSString stringWithFormat:@"共%@注", [RuYiCaiLotDetail sharedObject].zhuShuNum];

    self.batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//    self.batchEndTimeLabel.text = [RuYiCaiLotDetail sharedObject].batchEndTime;
    [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", [RuYiCaiLotDetail sharedObject].disBetCode] forState:UIControlStateNormal];

    allSave = NO;
	isPublic = 0;
	
	m_yesSave = [[UIButton alloc] initWithFrame:CGRectMake(95, 418, 20, 20)];
	[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
	[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
   	[m_yesSave addTarget:self action:@selector(yesSaveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_yesSave];

	m_noSave = [[UIButton alloc] initWithFrame:CGRectMake(165, 418, 20, 20)];
	[m_noSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
	[m_noSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
   	[m_noSave addTarget:self action:@selector(noSaveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_noSave];
		
	m_buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(95, 497, 50, 20)];
//	[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
//	[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
   [m_buttonOne setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
   	[m_buttonOne addTarget:self action:@selector(hasPublicOneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_buttonOne setBackgroundColor:[UIColor clearColor]];
    m_buttonOne.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [self.view addSubview:m_buttonOne];
	
	m_buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(95, 524, 50, 20)];
	[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//	[m_buttonTwo setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
   	[m_buttonTwo addTarget:self action:@selector(hasPublicTwoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_buttonTwo setBackgroundColor:[UIColor clearColor]];
    m_buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [self.view addSubview:m_buttonTwo];
	
	m_buttonThere = [[UIButton alloc] initWithFrame:CGRectMake(95, 549, 50, 20)];
	[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//	[m_buttonThere setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
   	[m_buttonThere addTarget:self action:@selector(hasPublicThereButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_buttonThere setBackgroundColor:[UIColor clearColor]];
    m_buttonThere.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [self.view addSubview:m_buttonThere];
	
	m_buttonFore = [[UIButton alloc] initWithFrame:CGRectMake(95, 576, 50, 20)];
	[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//	[m_buttonFore setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
   	[m_buttonFore addTarget:self action:@selector(hasPublicForeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_buttonFore setBackgroundColor:[UIColor clearColor]];
    m_buttonFore.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [self.view addSubview:m_buttonFore];
	
	m_buttonFive = [[UIButton alloc] initWithFrame:CGRectMake(95, 601, 50, 20)];
	[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//	[m_buttonFive setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
   	[m_buttonFive addTarget:self action:@selector(hasPublicFiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [m_buttonFive setBackgroundColor:[UIColor clearColor]];
    m_buttonFive.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [self.view addSubview:m_buttonFive];
    
    [self refreshTopView];
}

- (void)refreshTopView
{
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
    
    if(self.zhuiJiaSwitch.on)
    {
        allAmount = 3 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    }
    else
    {
        allAmount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    }
    self.allCountLabel.text = [NSString stringWithFormat:@"共%0.0f元", allAmount];
    
    float byCount = [self.buyField.text floatValue]/allAmount *
    100;
	m_buyByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", byCount,@"％"];
    float saveCount = [self.saveField.text floatValue]/allAmount * 100;
    m_saveByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", saveCount,@"％"];
}

- (IBAction)zhuiJiaSwitchChange:(id)sender 
{
    [self refreshTopView];
}

- (void)setupNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"确定"
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(LotComplete:)] autorelease]; 
	
//	UIButton* backButton = [UIButton buttonWithType:101];//UIButtonType，其实101和系统返回按钮一样
//	[backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//	[backButton setTitle:@"返回" forState:UIControlStateNormal];
//	UIBarButtonItem *leftBtn = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
//	self.navigationItem.leftBarButtonItem = leftBtn;
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                             initWithTitle:@"返回"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(back:)] autorelease];
}

- (IBAction)betCodeClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
}

- (IBAction)sliderBeishuChange:(id)sender
{ 
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
    
    [self refreshTopView];
}

- (void)yesSaveButtonClick
{
	if(!allSave)
	{
		allSave = !allSave;
		
		//float allCount = [[RuYiCaiLotDetail sharedObject].amount intValue]/100;
		int saveNum = allAmount - [self.buyField.text intValue];
	
		m_saveField.text = [NSString stringWithFormat:@"%d",saveNum];
		m_saveByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", saveNum/allAmount *100,@"％"];
	

		[m_saveField setTextColor:[UIColor grayColor]];
		m_saveField.userInteractionEnabled = NO;
		//m_buyField.text = @"0";
		//m_lowField.text = @"0";
		//m_buyField.userInteractionEnabled = NO;
		//m_lowField.userInteractionEnabled = NO;

		//m_buyByTotal.text = @"占总额0％";		
		
		[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
		[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_noSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_noSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}

- (void)noSaveButtonClick
{
	if(allSave)
	{
		allSave = !allSave;
		m_saveField.userInteractionEnabled = YES;
//		m_buyField.userInteractionEnabled = YES;
//		m_lowField.userInteractionEnabled = YES;
		m_saveField.text =@"0";
		m_saveByTotal.text = @"占总额0％";
		[m_saveField setTextColor:[UIColor blackColor]];
		
		[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_noSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
		[m_noSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
	}
}

- (void)hasPublicOneButtonClick
{
	if(0 != isPublic)
	{
		isPublic = 0;
		[m_buttonOne setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
//		[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonTwo setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonThere setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFore setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFive setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}
- (void)hasPublicTwoButtonClick
{
	if(1 != isPublic)
	{
		isPublic = 1;
//		[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
        [m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
//		[m_buttonTwo setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonThere setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFore setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFive setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}
- (void)hasPublicThereButtonClick
{
	if(2 != isPublic)
	{
		isPublic = 2;
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonTwo setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
//		[m_buttonThere setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFore setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFive setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}

- (void)hasPublicForeButtonClick
{
	if(3 != isPublic)
	{
		isPublic = 3;
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonTwo setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonThere setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
//		[m_buttonFore setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFive setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];		
	}
}

- (void)hasPublicFiveButtonClick
{
	if(4 != isPublic)
	{
		isPublic = 4;
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonOne setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonTwo setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonThere setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
//		[m_buttonFore setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
//		[m_buttonFive setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];		
	}
}

#pragma mark navigationBar button 
- (void)LotComplete:(id)sender
{
    
    NSString*  countStr = [self.allCountLabel.text substringWithRange:NSMakeRange(1,[self.allCountLabel.text length]-2)];
    int countHM = [countStr intValue];
    NSLog(@"--------->>>>%d",countHM);
    if (countHM <6)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"合买金额不能低于6元" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
	[self.buyField resignFirstResponder];
	[self.lowField resignFirstResponder];
	[self.saveField resignFirstResponder];
	[self.desText resignFirstResponder];
	//[self.navigationController popViewControllerAnimated:YES];
	if([m_buyField.text isEqualToString:@"0"] && [m_saveField.text isEqualToString:@"0"])
	{
		[[RuYiCaiNetworkManager sharedManager] showMessage:@"认购金额和保底金额不能同时为0元" withTitle:@"提示" buttonTitle:@"确定"];
		return;
	}
    [self buildBetCode];
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    if([RuYiCaiLotDetail sharedObject].batchCode)
	  [tempDic setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
	[tempDic setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
	[tempDic setObject:[NSString stringWithFormat:@"%d", numBeishu] forKey:@"lotmulti"];
	[tempDic setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
//    [tempDic setObject:[NSString stringWithFormat:@"%0.0f", allAmount * 100]forKey:@"amount"];
    [tempDic setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];

	if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoDLT])
	{
		if(self.zhuiJiaSwitch.on)
        {
            [tempDic setObject:@"300" forKey:@"oneAmount"];
        }
        else
        {
            [tempDic setObject:@"200" forKey:@"oneAmount"];
        }
	}
	else
	{
		 [tempDic setObject:@"200" forKey:@"oneAmount"];//单注多少元
	}
	[tempDic setObject:[NSString stringWithFormat:@"%0.0f", allAmount * 100] forKey:@"totalAmt"];
	[tempDic setObject:[NSString stringWithFormat:@"%d",[self.saveField.text intValue]*100] forKey:@"safeAmt"];
	[tempDic setObject:[NSString stringWithFormat:@"%d",[self.buyField.text intValue]*100] forKey:@"buyAmt"];
	[tempDic setObject:[NSString stringWithFormat:@"%d",[self.lowField.text intValue]*100] forKey:@"minAmt"];
	[tempDic setObject:self.desText.text forKey:@"description"];
	[tempDic setObject:[NSString stringWithFormat:@"%d",m_getNum] forKey:@"commisionRation"];//提成
    [tempDic setObject:@"1" forKey:@"isSellWays"];//多注投格式
	int visible = 0;
	switch (isPublic)
	{
		case 0:
			visible = 0;
			break;
		case 1:
			visible = 3;
			break;
		case 2:
			visible = 2;
			break;
		case 3:
			visible = 4;
			break;
        case 4:
			visible = 1;
			break;
		default:
			break;
	}
	[tempDic setObject:[NSString stringWithFormat:@"%d",visible] forKey:@"visibility"];//是否公开
	
	[[RuYiCaiNetworkManager sharedManager] launchLot:tempDic];
	[tempDic release];
}

#pragma mark betCode method
- (void)buildBetCode
{
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    
    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    
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

- (void)randomNumSet
{
//	[m_buyField resignFirstResponder];
//	[m_lowField resignFirstResponder];
//	[m_saveField resignFirstResponder];
//    [m_desText resignFirstResponder];
    [self hideKeybord];
	
    [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:SSQ_RANDOM_NUM];
    [m_delegate.randomPickerView setPickerNum:m_getNum withMinNum:1 andMaxNum:10];
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    m_getNum = num + 1;
    [self.getButton setTitle:[NSString stringWithFormat:@"%d", m_getNum] forState:UIControlStateNormal];
}

#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.view.center.y != 360)
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
	//float count = [[RuYiCaiLotDetail sharedObject].amount intValue]/100;
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
	else if(textField == self.buyField)
	{
		self.buyField.text = [NSString stringWithFormat:@"%d",[self.buyField.text intValue]];
		if([self.buyField.text intValue] > allAmount)
		{
			int buyNum = allAmount - [self.saveField.text intValue];
			self.buyField.text = [NSString stringWithFormat:@"%d",buyNum];
		}
		else if([self.buyField.text intValue] == allAmount)
		{
			m_lowField.text = @"0";
			m_saveField.text = @"0";			
		}
		else if([self.buyField.text intValue] <= 0)
		{
			m_buyField.text = @"0";
		}
		if([self.buyField.text intValue] + [self.saveField.text intValue] > allAmount)
		{
			if(allSave)
			{
				int saveNum = allAmount - [self.buyField.text intValue];
				self.saveField.text = [NSString stringWithFormat:@"%d",saveNum];
			}
			else
			{
				int buyNum = allAmount - [self.saveField.text intValue];
				self.buyField.text = [NSString stringWithFormat:@"%d",buyNum];
			}
		}
		if([self.buyField.text intValue] + [self.lowField.text intValue] > allAmount)
		{
			int lowNum = allAmount - [self.buyField.text intValue];
			self.lowField.text = [NSString stringWithFormat:@"%d", lowNum];
		}
		if(allSave)
		{
			int saveNum = allAmount - [self.buyField.text intValue];
			self.saveField.text = [NSString stringWithFormat:@"%d",saveNum];
		}
		
		float byCount = [self.buyField.text intValue]/allAmount *100;
		m_buyByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", byCount,@"％"];
		
		float saCount = [self.saveField.text intValue]/allAmount *100;
		m_saveByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", saCount,@"％"];
	}
	else if(textField == self.lowField)
	{
		self.lowField.text = [NSString stringWithFormat:@"%d",[self.lowField.text intValue]];
		if([self.lowField.text intValue] == 0 || [self.lowField.text intValue] < 0)
		{
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最低跟单为1元" withTitle:@"提示" buttonTitle:@"确定"];
			m_lowField.text = @"1";
		}
		else if([self.lowField.text intValue] > (allAmount-[self.buyField.text intValue]))
		{
			int highCount = allAmount-[self.buyField.text intValue];
			self.lowField.text = [NSString stringWithFormat:@"%d", highCount];
		}
	}
	else 
	{
		self.saveField.text = [NSString stringWithFormat:@"%d",[self.saveField.text intValue]];
		if([self.saveField.text intValue] == 0 || [self.saveField.text intValue] < 0)
		{
			self.saveField.text = @"0";
		}
		else
		{
			if([self.saveField.text intValue] > (allAmount-[self.buyField.text intValue]))
			{
				if(allSave)
				{
					int buyN = allAmount - [self.saveField.text intValue];
					self.buyField.text = [NSString stringWithFormat:@"%d", buyN];
				}
				else
				{
					int highCount = allAmount-[self.buyField.text intValue];
					self.saveField.text = [NSString stringWithFormat:@"%d",highCount];
				}
			}
		}
		float byCount = [self.buyField.text intValue]/allAmount *100;
		m_buyByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", byCount,@"％"];
		
        float saveCount = [self.saveField.text intValue]/allAmount *100;
		m_saveByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", saveCount,@"％"];
	}
}

#pragma  make textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"%f", self.view.center.y);
    if(self.view.center.y != 160)
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

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
	
    if ([@"\n" isEqualToString:text] == YES) 
    {
        [textView resignFirstResponder];
        if(self.view.center.y != 360)
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
    return YES;
}

- (void)hideKeybord
{
    [self.fieldBeishu resignFirstResponder];
    [self.buyField resignFirstResponder];
    [self.lowField resignFirstResponder];
    [self.saveField resignFirstResponder];
    [self.desText resignFirstResponder];
    
    if(self.view.center.y != 360)
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
#pragma mark touch
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.fieldBeishu resignFirstResponder];
    [self.buyField resignFirstResponder];
    [self.lowField resignFirstResponder];
    [self.saveField resignFirstResponder];
    [self.desText resignFirstResponder];
    
    if(self.view.center.y != 360)
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
