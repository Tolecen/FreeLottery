//
//  RYCZCBetView.m
//  RuYiCai
//
//  Created by  on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RYCZCBetView.h"
#import "RuYiCaiNetworkManager.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiCommon.h"
#import "GiftViewController.h"
#import "LaunchHMViewController.h"
#import "GiftWordTableViewController.h"
#import "AnimationTabView.h"
#import "ChangeViewController.h"
#import "DirectPaymentViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ExchangeLotteryWithIntegrationViewController.h"


#define kSegIndexNormal (0)
#define kSegIndexHM     (1)
#define kSegIndexGift   (2)

@implementation RYCZCBetView

@synthesize lotTitleLabel;
@synthesize normalScroll;
@synthesize HMScroll;
@synthesize giftScroll;

@synthesize allCountLabel;
@synthesize zhuShuLabel;
@synthesize batchCodeLabel;
//@synthesize batchEndTimeLabel;
@synthesize betCodeList;
@synthesize sliderBeishu;
@synthesize fieldBeishu;

@synthesize animationTabView = m_animationTabView;
@synthesize LaunchHMView = m_LaunchHMView;
@synthesize giftViewController = m_giftViewController;
@synthesize segmentedControl   =m_segmentedControl;

@synthesize buyButton;

- (void)dealloc
{
    [_getShareDetileDic release];
    [lotTitleLabel release];
    [m_segmentedControl release];
    [normalScroll release];
    [HMScroll release];
    [giftScroll release];
    
    [allCountLabel release];
    [zhuShuLabel release];
    [batchCodeLabel release];
//    [batchEndTimeLabel release];
    [betCodeList release];
    [sliderBeishu release];
    [fieldBeishu release];
    
    [m_animationTabView release];
    [m_LaunchHMView release];
    [m_giftViewController release];
    
    [buyButton release];
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"giftWordButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"phoneButtonClick" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"giftSendSms" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fqHeMaiLotOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getShareDetileLotOK" object:nil];

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCompleteOK:) name:@"betCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabButtonChanged:) name:@"tabButtonChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftWordButtonClick:) name:@"giftWordButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneButtonClick:) name:@"phoneButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giftSendSms:) name:@"giftSendSms" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betOutTime:) name:@"betOutTime" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fqHeMaiLotOK:) name:@"fqHeMaiLotOK" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getShareDetileLotOK:) name:@"getShareDetileLotOK" object:nil];
    if([RuYiCaiLotDetail sharedObject].giftContentStr && ![[RuYiCaiLotDetail sharedObject].giftContentStr isEqualToString:@""])//赠言
    {
        self.giftViewController.adviceTextView.text = [self.giftViewController.adviceTextView.text stringByAppendingString:[RuYiCaiLotDetail sharedObject].giftContentStr];
        [RuYiCaiLotDetail sharedObject].giftContentStr = @"";
    }
}

#pragma mark---微信分享
- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (void)doAuth
{
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"post_timeline";
    req.state = @"xxx";
    
    [WXApi sendReq:req];
}

-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    if ([strMsg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}
- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];    
    isNormalBet = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];

    self.normalScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 164);
    self.HMScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 164);
    self.giftScroll.frame = CGRectMake(0, 42, 320, [UIScreen mainScreen].bounds.size.height - 164);
    
    [BackBarButtonItemUtils addBackButtonForController:self];
    
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
//                                             initWithTitle:@"返回"
//                                             style:UIBarButtonItemStylePlain
//                                             target:self
//                                             action:@selector(back:)] autorelease];
    
//    m_animationTabView = [[AnimationTabView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
//    [m_animationTabView.buttonNameArray addObject:@"投注"];
//    [m_animationTabView.buttonNameArray addObject:@"合买"];
//    [m_animationTabView.buttonNameArray addObject:@"赠送"];
//    [m_animationTabView setMainButton];
//    [self.view addSubview:m_animationTabView];

    self.segmentedControl = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 5, 310, 32)
                                                       andNormalImages:[NSArray arrayWithObjects:@"zc_tz_nomal.png",@"zc_hm_nomal.png",@"zc_zs_nomal.png", nil]
                                                  andHighlightedImages:[NSArray arrayWithObjects:@"zc_tz_nomal.png",@"zc_hm_nomal.png",@"zc_zs_nomal.png", nil]
                                                        andSelectImage:[NSArray arrayWithObjects:@"zc_tz_click.png",@"zc_hm_click.png",@"zc_zs_click.png", nil]]autorelease];
    
    self.segmentedControl.delegate = self;
    [self.view addSubview:m_segmentedControl];
    
    self.fieldBeishu.delegate = self;
    
    self.sliderBeishu.maximumValue = 200;
    self.sliderBeishu.minimumValue = 1.0;
    self.sliderBeishu.value = 1.0;
    self.fieldBeishu.text = @"1";
    
    allCount = [[RuYiCaiLotDetail sharedObject].amount intValue];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆",[[RuYiCaiLotDetail sharedObject].amount intValue]/100*aas];
    self.zhuShuLabel.text = [NSString stringWithFormat:@"共%@注",[RuYiCaiLotDetail sharedObject].zhuShuNum];
    self.batchCodeLabel.text = [RuYiCaiLotDetail sharedObject].batchCode;
//    self.batchEndTimeLabel.text = [RuYiCaiLotDetail sharedObject].batchEndTime;
    
    self.lotTitleLabel.text = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:[RuYiCaiLotDetail sharedObject].lotNo];
    
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    [RuYiCaiLotDetail sharedObject].lotMulti = @"1";
    
    [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", [RuYiCaiLotDetail sharedObject].disBetCode] forState:UIControlStateNormal];
    
    m_LaunchHMView = [[LaunchHMViewController alloc] init];
    m_LaunchHMView.view.frame = CGRectMake(0, 0, 320, 720);
    [self.HMScroll addSubview:m_LaunchHMView.view];
    self.HMScroll.contentSize = CGSizeMake(320, 715);
    
    m_giftViewController = [[GiftViewController alloc] init];
    m_giftViewController.view.frame = CGRectMake(0, 0, 320, 490);
    [self.giftScroll addSubview:m_giftViewController.view];
    self.giftScroll.contentSize = CGSizeMake(320, 475);
    
    self.normalScroll.hidden = NO;
    self.HMScroll.hidden = YES;
    self.giftScroll.hidden = YES;
}

#pragma mark -customSegmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    switch (index)
    {
        case 0:
        {
            self.normalScroll.hidden = NO;
            self.HMScroll.hidden = YES;
            self.giftScroll.hidden = YES;
            
            [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
            break;
        }
        case 1:
        {
            self.normalScroll.hidden = YES;
            self.HMScroll.hidden = NO;
            self.giftScroll.hidden = YES;
            
            [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
            break;
        }
        case 2:
        {
            self.normalScroll.hidden = YES;
            self.HMScroll.hidden = YES;
            self.giftScroll.hidden = NO;
            
            [buyButton setTitle:@"立即赠送" forState:UIControlStateNormal];

            break;
        }
            default:
            break;
    }

    
}

- (void)tabButtonChanged:(NSNotification*)notification
{
    [self hideKeybord];
    [self.LaunchHMView hideKeybord];
    [self.giftViewController hideKeybord];
    
    if(self.animationTabView.selectButtonTag == 0)
    {
        self.normalScroll.hidden = NO;
        self.HMScroll.hidden = YES;
        self.giftScroll.hidden = YES;
        
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    else if(self.animationTabView.selectButtonTag == 1)
    {
        self.normalScroll.hidden = YES;
        self.HMScroll.hidden = NO;
        self.giftScroll.hidden = YES;
                
        [buyButton setTitle:@"发起合买" forState:UIControlStateNormal];
    }
    else
    {
        self.normalScroll.hidden = YES;
        self.HMScroll.hidden = YES;
        self.giftScroll.hidden = NO;
                
        [buyButton setTitle:@"立即赠送" forState:UIControlStateNormal];
    }
}

#pragma mark---和买成功
- (void)fqHeMaiLotOK:(NSNotification*)notification//合买成功弹出view
{
    UIAlertView *succesAlertView = [[UIAlertView alloc] initWithTitle:@"博雅彩" message:@"恭喜您已成功发起合买，赶紧告诉更多好友一起中大奖！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    succesAlertView.tag =110;
    [succesAlertView show];
    [succesAlertView release];
}

- (void)getShareDetileLotOK:(NSNotification*)notification//合买成功弹出view
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSLog(@"合买成功之后的再次请求返回的分享信息-------%@",[RuYiCaiNetworkManager sharedManager].responseText);
    
    self.getShareDetileDic = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
}

- (void)back:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)sliderBeishuChange:(id)sender
{ 
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
    
    int aCount = allCount/100 * numBeishu;
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", aCount*aas];
    
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d",allCount * numBeishu];
}

- (IBAction)betCodeClick:(id)sender
{
    [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
}

- (IBAction)buyClick:(id)sender
{
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
    if (![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    if([appStoreORnormal isEqualToString:@"appStore"]&&
       [appTestPhone isEqualToString:[RuYiCaiNetworkManager sharedManager].phonenum])

    {
        if([self normalBetCheck])
        {
           [self buildBetCode];
           [self wapPageBuild];
        }
    }
    else
    {
        switch (self.segmentedControl.segmentedIndex)
        {
                //立即购买
            case kSegIndexNormal:
            {
                if([self normalBetCheck])
                {
                    [self buildBetCode];
                }
                else
                {
                    return;
                }
                
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
                [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单笔总金额（多注投)
                [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
            }break;
            case kSegIndexHM:
            {
                [self.LaunchHMView LotComplete:nil];
            }break;
            case kSegIndexGift:
            {
                //立即赠送
                [self.giftViewController sureButonClick];
            }break;
            default:
                break;
        }
    }
}

- (BOOL)normalBetCheck
{
    for (int i = 0; i < self.fieldBeishu.text.length; i++)
    {
        UniChar chr = [self.fieldBeishu.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"数字不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"填写的必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    if([self.fieldBeishu.text intValue] <= 0 || [self.fieldBeishu.text intValue] > 200)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～200" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}

#pragma mark gift notification
- (void)giftWordButtonClick:(NSNotification*)notification
{
    GiftWordTableViewController*  viewController = [[GiftWordTableViewController alloc] init];
    viewController.title = @"赠言";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)phoneButtonClick:(NSNotification*)notification
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
							   [NSNumber numberWithInt:kABPersonEmailProperty],
							   [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	picker.displayedProperties = displayedItems;
	// Show the picker 
	[self presentModalViewController:picker animated:YES];
    [picker release];	
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    int i;
    for (i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
        NSString *aLabel = [(NSString*)ABMultiValueCopyLabelAtIndex(phoneMulti, i) autorelease];
        NSLog(@"PhoneLabel:%@ Phone#:%@",aLabel,aPhone);
        if([aLabel isEqualToString:@"_$!<Mobile>!$_"])
        {
            [phones addObject:aPhone];
        }
        else if([aLabel isEqualToString:@"iPhone"])
        {
            [phones addObject:aPhone];
        }
    }
    if([phones count]>0)
    {
        NSString *mobileNo = [phones objectAtIndex:0];
        NSArray *phoneNum = [mobileNo componentsSeparatedByString:@"-"];
        if(self.giftViewController.numTextView.text.length != 0)
        {
            self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingString:@","];
            for(int i = 0; i < [phoneNum count]; i++)
            {
                self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
            }
        }
        else
        {
            for(int i = 0; i < [phoneNum count]; i++)
            {
                self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
            }
        }
        NSLog(mobileNo);
    }
    [phones release];
    [self dismissModalViewControllerAnimated:YES];
    [[Custom_tabbar showTabBar] hideTabBar:YES];

	return YES;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
//	ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
//	NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, identifier);
//	NSArray *phoneNum = [personPhone componentsSeparatedByString:@"-"];
//	//NSLog(@"phonenum--- %@",phoneNum);
//	
//	[personPhone release];
//	if(self.giftViewController.numTextView.text.length != 0)
//	{
//		self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingString:@","];
//		for(int i = 0; i < [phoneNum count]; i++)
//	    {
//			self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
//		}
//	}
//	else
//	{
//		for(int i = 0; i < [phoneNum count]; i++)
//	    {
//			self.giftViewController.numTextView.text = [self.giftViewController.numTextView.text stringByAppendingFormat:@"%@",[phoneNum objectAtIndex:i]];
//		}
//	}
//	[self dismissModalViewControllerAnimated:YES];
//    [[Custom_tabbar showTabBar] hideTabBar:YES];
//    
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self dismissModalViewControllerAnimated:YES];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}


#pragma mark MFMessageComposeViewController
- (void)giftSendSms:(NSNotification*)notification
{
//	NSLog(@"sms  sms");
//	NSString *betName;
//    if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoSFC])
//	{
//		betName = @"胜负彩";
//	}
//	else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoRX9])
//	{
//		betName = @"任选九";
//	}
//	else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoJQC])
//	{
//		betName = @"进球彩";
//	}
//	else if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoLCB])
//	{
//		betName = @"六场半";
//	}	
//	
//	NSString *tempString = [NSString stringWithFormat:@"您的好友%@送您 %@ 第%@期 彩票%@注，注码：\n%@\n留言如下：\n%@\n",
//							[RuYiCaiNetworkManager sharedManager].phonenum,
//							betName,
//							[RuYiCaiLotDetail sharedObject].batchCode,
//							[RuYiCaiLotDetail sharedObject].zhuShuNum,
//							[RuYiCaiLotDetail sharedObject].disBetCode,
//							[RuYiCaiLotDetail sharedObject].advice];
//	[self sendsms:tempString];//发送短信	
    [self.navigationController popViewControllerAnimated:YES];
    [[RuYiCaiNetworkManager sharedManager] showMessage:[CommonRecordStatus commonRecordStatusManager].resultWarn withTitle:@"提示" buttonTitle:@"确定"];
}

//- (void)displaySMS:(NSString*)message
//{
//	MFMessageComposeViewController*picker = [[MFMessageComposeViewController alloc] init];
//	picker.messageComposeDelegate=self;
//	picker.navigationBar.tintColor= [UIColor redColor];
//	picker.body= message;// 默认信息内容
//	
//	// 默认收件人(可多个)
//	NSArray *numArray = [self.giftViewController.numTextView.text componentsSeparatedByString:@","]; 
//	picker.recipients = numArray;
//	
//	//picker.recipients = [NSArray arrayWithObjects:@"13161962673", nil];
//	[self presentModalViewController:picker animated:YES];
//	[picker release];
//}
//
//- (void)sendsms:(NSString*)message
//{
//	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//	NSLog(@"can send SMS [%d]", [messageClass canSendText]);
//	NSLog(@"infor:%@",message);
//	if(messageClass !=nil)
//	{
//		if([messageClass canSendText])
//		{
//            [self displaySMS:message];
//		}
//		else
//		{
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"设备没有短信功能" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            [self.navigationController popViewControllerAnimated:YES];
//		}
//	}
//	else
//	{
//        [[RuYiCaiNetworkManager sharedManager] showMessage:@"iOS版本过低，iOS4.0以上才支持程序内发送短信" withTitle:@"提示" buttonTitle:@"确定"];
//	}
//}
//
//- (void)messageComposeViewController:(MFMessageComposeViewController*)controller
//                 didFinishWithResult:(MessageComposeResult)result 
//{
//	switch(result) {
//        case MessageComposeResultCancelled:
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"赠送成功，但发送短信取消" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            break;
//        case MessageComposeResultSent:
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"赠送成功并短信已发送" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            break;
//        case MessageComposeResultFailed:
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"赠送成功，但发送短信失败" withTitle:[CommonRecordStatus commonRecordStatusManager].resultWarn buttonTitle:@"确定"];
//            break;
//        default:
//            break;
//    }
//    [self dismissModalViewControllerAnimated:YES];
//    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
//    
//    [[Custom_tabbar showTabBar] hideTabBar:YES];
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark textField and touch delegate
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.fieldBeishu resignFirstResponder];
//    
//    if(self.view.center.y != 208)
//    {
//        [UIView beginAnimations:@"movement" context:nil]; 
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//        [UIView setAnimationDuration:0.3f];
//        [UIView setAnimationRepeatCount:1];
//        [UIView setAnimationRepeatAutoreverses:NO];
//        CGPoint center = self.view.center;
//        center.y += 100;
//        self.view.center = center;
//        [UIView commitAnimations];
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.fieldBeishu resignFirstResponder];
    
    [UIView beginAnimations:@"movement" context:nil]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    CGPoint center = self.normalScroll.center;
    center.y += 100;
    self.normalScroll.center = center;
    [UIView commitAnimations];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%f", self.normalScroll.center.y);
    
    [UIView beginAnimations:@"movement" context:nil]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    CGPoint center = self.normalScroll.center;
    center.y -= 100;
    self.normalScroll.center = center;
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
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
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    self.allCountLabel.text = [NSString stringWithFormat:@"共%d彩豆", [fieldBeishu.text intValue] * (allCount/100)*aas];
    
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", [fieldBeishu.text intValue]];
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d",allCount * [self.fieldBeishu.text intValue]];
}

- (void)hideKeybord
{
//    NSLog(@"ns %f  %f", self.normalScroll.center.y, (self.normalScroll.frame.size.height)/2 + self.normalScroll.frame.origin.y);
    [self.fieldBeishu resignFirstResponder];
    if(self.normalScroll.center.y != self.normalScroll.frame.size.height/2 + self.normalScroll.frame.origin.y)
    {
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.normalScroll.center;
        center.y += 100;
        self.normalScroll.center = center;
        [UIView commitAnimations];
    }
}

#pragma mark betCode method
- (void)buildBetCode
{
    NSLog(@"buildBetCode");
    int numBeishu = (int)(self.sliderBeishu.value + 0.5f);
    
    [RuYiCaiLotDetail sharedObject].batchNum = @"1"; 
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d",allCount * numBeishu];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].betCode stringByAppendingFormat:@"_%d_200_%d", numBeishu, allCount];
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [RuYiCaiLotDetail sharedObject].amount;
        
    [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
}

- (void)wapPageBuild
{
    if([[RuYiCaiNetworkManager sharedManager] testConnection])
    {
        NSMutableDictionary* mDict = [[RuYiCaiNetworkManager sharedManager] getCommonCookieDictionary];
        [mDict setObject:@"betLot" forKey:@"command"];
        [mDict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
        [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        if([RuYiCaiLotDetail sharedObject].batchCode)
            [mDict setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].batchNum forKey:@"batchnum"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].lotMulti forKey:@"lotmulti"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].betType forKey:@"bettype"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].sellWay forKey:@"sellway"];
        [mDict setObject:@"1" forKey:@"isSellWays"];
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSString* cookieStr = [jsonWriter stringWithObject:mDict];
        [jsonWriter release];
        
        NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
        NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
        NSString *AESstring = [[[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding] autorelease];
        
        NSMutableString *sendStr = [NSMutableString stringWithFormat:
                                    @"%@",kRuYiCaiBetSafari];
        NSString *allStr = [sendStr stringByAppendingString:AESstring];
        NSLog(@"safari:%@ ", allStr);
        
        NSString *strUrl = [allStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"检测不到网络" withTitle:@"提示" buttonTitle:@"确定"];
    }
}

- (void)betCompleteOK:(NSNotification*)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 投注期号过期处理
- (void)betOutTime:(NSNotification*)notification
{
    //    该期已过期
    [[RuYiCaiNetworkManager sharedManager] showMessage:@"该期已过期" withTitle:@"提示" buttonTitle:@"确定"];
    
}
#pragma mark 投注余额不足处理
- (void)notEnoughMoney:(NSNotification*)notification
{
    switch (self.segmentedControl.segmentedIndex)
    {
        case kSegIndexNormal:
        {
            UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:CaiJinDuiHuanTiShi
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:nil];
//            [alterView addButtonWithTitle:@"直接支付"];
            [alterView addButtonWithTitle:@"免费兑换"];
            alterView.tag = 112;
            [alterView show];
            [alterView release];
            
        }break;
        default:
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"余额不足" withTitle:@"错误" buttonTitle:@"确定"];
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(112 == alertView.tag)
    {
        if(1 == buttonIndex)//去充值
        {
            
            ExchangeLotteryWithIntegrationViewController* viewController = [[ExchangeLotteryWithIntegrationViewController alloc] init];
            viewController.isShowBackButton = YES;

            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
//        if(1 == buttonIndex)//直接支付
//        {
//            [self setHidesBottomBarWhenPushed:YES];
//            
//            DirectPaymentViewController* viewController = [[DirectPaymentViewController alloc] init];
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
//        }
//        else if(2 == buttonIndex)//去充值
//        {
//            [self setHidesBottomBarWhenPushed:YES];
//            
//            ChangeViewController* viewController = [[ChangeViewController alloc] init];
//            [self.navigationController pushViewController:viewController animated:YES];
//            [viewController release];
//        }
    }else if (110 == alertView.tag)
    {
        if (buttonIndex==1)
        {
            ShareViewController *shareViewController = [[ShareViewController alloc] init];
            shareViewController.delegate = self;
            shareViewController.navigationItem.title=@"合买分享";
            shareViewController.sinShareContent = [NSString stringWithFormat:@"@博雅彩，我刚发起了一个%@的合买,合买中奖率更大!%@", [[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"lotName"],[[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"url"]];
            shareViewController.txShareContent = [NSString stringWithFormat:@"@博雅彩，我刚发起了一个%@的合买,合买中奖率更大!%@", [[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"lotName"],[[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"url"]];
            shareViewController.shareContent =[NSString stringWithFormat:@"@博雅彩，我刚发起了一个%@的合买,合买中奖率更大!%@", [[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"lotName"],[[self.getShareDetileDic objectForKey:@"result"] objectForKey:@"url"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
            shareViewController.pushType = @"PUSHHIDE";
            [self.navigationController pushViewController:shareViewController animated:YES];
            [shareViewController release];
        }else if(buttonIndex==0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }

}

@end
