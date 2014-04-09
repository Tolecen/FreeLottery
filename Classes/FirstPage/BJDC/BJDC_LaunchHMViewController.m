//
//  BJDC_LaunchHMViewController.m
//  RuYiCai
//
//  Created by ruyicai on 13-6-13.
//
//

#import "BJDC_LaunchHMViewController.h"

#import "JC_LaunchHMViewController_copy.h"
#import "RandomPickerViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiLotDetail.h"
#import "RYCImageNamed.h"
#import "RuYiCaiCommon.h"
#import "AdaptationUtils.h"

@interface BJDC_LaunchHMViewController (internal)

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


@implementation BJDC_LaunchHMViewController


@synthesize lotTitleLabel;
//@synthesize batchCodeLabel;
//@synthesize batchEndTimeLabel;
@synthesize betCodeList;
@synthesize image_sanjiao;
@synthesize betInfo_downView;
@synthesize launchView;

@synthesize allCountLabel = m_allCountLabel;
@synthesize zhuShuLabel = m_zhuShuLabel;
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

@synthesize qihaoLabel = m_qihaoLabel;

@synthesize jianBeishuButton;
@synthesize jiaBeishuButton;
@synthesize fieldBeishu;
#define kMoveDownHeight 120
#define kFangAnXiangQingViewTag 111
- (void)dealloc
{
    m_delegate.randomPickerView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"launchHMOK" object:nil];
    
    [betInfo_downView release];
    [launchView release];
    [lotTitleLabel release];
    [betCodeList release];
    [image_sanjiao release];
	[m_allCountLabel release];
	[m_zhuShuLabel release];
	[m_buyByTotal release];
	[m_saveByTotal release];
    
    [jiaBeishuButton release];
    [jianBeishuButton release];
	
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
    
    [fieldBeishu release];
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchHMOK:) name:@"launchHMOK" object:nil];
    
	[self setupNavigationBar];
    [self setBatchCodeShow];//北京单场含有期号
    
    self.fieldBeishu.delegate = self;
    self.fieldBeishu.text = @"1";
    
    m_buyField.delegate = self;
	m_lowField.delegate = self;
	m_saveField.delegate = self;
	
	m_desText.delegate = self;
	m_desText.layer.cornerRadius = 8;
	m_desText.layer.masksToBounds = YES;
	
	m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    
    m_betCodeListHeight = [self getBetCodeListHeight];
    
	m_getNum = 10;
    m_getButton = [[UIButton alloc] initWithFrame:CGRectMake(95, 198, 67, 28)];
    [m_getButton setBackgroundImage:RYCImageNamed(@"list_normal.png") forState:UIControlStateNormal];
    [m_getButton setBackgroundImage:RYCImageNamed(@"list_click.png") forState:UIControlStateHighlighted];
    [m_getButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_getButton setTitle:[NSString stringWithFormat:@"%d", m_getNum] forState:UIControlStateNormal];
    [m_getButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 22)];
    [m_getButton addTarget:self action:@selector(randomNumSet) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_getButton];
    
	m_zhuShuLabel.text = [NSString stringWithFormat:@"共%@注", [RuYiCaiLotDetail sharedObject].zhuShuNum];
    
    NSString* betCodeListStr = [RuYiCaiLotDetail sharedObject].disBetCode;
    betCodeListStr = [betCodeListStr stringByReplacingOccurrencesOfString:@"," withString:@" "];//去掉 button中的，
    [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", betCodeListStr] forState:UIControlStateNormal];
    
    allSave = NO;
	isPublic = 0;
	
    m_yesSave = [[UIButton alloc] initWithFrame:CGRectMake(95,162, 20, 20)];
	[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
	[m_yesSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
   	[m_yesSave addTarget:self action:@selector(yesSaveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_yesSave];
    
    m_noSave = [[UIButton alloc] initWithFrame:CGRectMake(165, 162, 20, 20)];
	[m_noSave setBackgroundImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
	[m_noSave setBackgroundImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
   	[m_noSave addTarget:self action:@selector(noSaveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_noSave];
    
    
    m_buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(95, 241, 50, 20)];
	[m_buttonOne setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
    m_buttonOne.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
   	[m_buttonOne addTarget:self action:@selector(hasPublicOneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_buttonOne];
    
    m_buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(95,269, 50, 20)];
	[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
    m_buttonTwo.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
   	[m_buttonTwo addTarget:self action:@selector(hasPublicTwoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_buttonTwo];
	
    m_buttonThere = [[UIButton alloc] initWithFrame:CGRectMake(95, 294 , 50, 20)];
	[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
    m_buttonThere.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
   	[m_buttonThere addTarget:self action:@selector(hasPublicThereButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_buttonThere];
	
    m_buttonFore = [[UIButton alloc] initWithFrame:CGRectMake(95, 319, 50, 20)];
	[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
    m_buttonFore.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
   	[m_buttonFore addTarget:self action:@selector(hasPublicForeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_buttonFore];
    
    m_buttonFive = [[UIButton alloc] initWithFrame:CGRectMake(95, 345, 50, 20)];
	[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
    m_buttonFive.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
   	[m_buttonFive addTarget:self action:@selector(hasPublicFiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.launchView addSubview:m_buttonFive];
    
    [self beishuButtonAddGesture];
    //    [self refreshTopView];
}



- (void)refreshTopView
{
    
    int numBeishu = [self.fieldBeishu.text intValue];
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",numBeishu];
    
    allAmount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    
    self.allCountLabel.text = [NSString stringWithFormat:@"共%0.0f元", allAmount];
    
    self.buyField.text = [self.buyField.text intValue] > allAmount ? @"0" : self.buyField.text;
    self.lowField.text = [self.lowField.text intValue] > (allAmount-[self.buyField.text intValue]) ? @"0" : self.lowField.text;
    self.saveField.text = [self.saveField.text intValue] > (allAmount-[self.buyField.text intValue]) ? @"0" : self.saveField.text;
    
    float byCount = 0.0;
    float saveCount = 0.0;
    if (allAmount == 0) {
        byCount = 0.0;
        saveCount = 0.0;
    }
    else
    {
        byCount = [self.buyField.text floatValue]/allAmount *100;
        saveCount = [self.saveField.text floatValue]/allAmount * 100;
    }
    
	m_buyByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", byCount,@"％"];
    if(allSave)
	{
		int saveNum = allAmount - [self.buyField.text intValue];
		m_saveField.text = [NSString stringWithFormat:@"%d",saveNum];
    }
    m_saveByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", saveCount,@"％"];
}


- (void)setupNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"确定"
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(LotComplete:)] autorelease];
    
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithTitle:@"返回"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(back:)] autorelease];
}

- (void)setBatchCodeShow
{
    if ([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoBJDC_RQSPF] ||
        [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoBJDC_JQS] ||
        [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoBJDC_Score] ||
        [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoBJDC_HalfAndAll] ||
        [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoBJDC_SXDS]) {
        
        m_qihaoLabel.text = [NSString stringWithFormat:@"第%@期",[RuYiCaiLotDetail sharedObject].batchCode];
        m_qihaoLabel.textColor = [UIColor blackColor];
        m_qihaoLabel.font = [UIFont systemFontOfSize:15.0];
    }
}

#pragma mark 倍数按钮添加手势

- (void) beishuButtonAddGesture
{
    
    //加  单击
    [self.jiaBeishuButton addTarget:self action:@selector(jiaHandleTapGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    //减  单击
    [self.jianBeishuButton addTarget:self action:@selector(jianHandleTapGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    //加  长按
    self.jiaBeishuButton.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *jialongpressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jiaButtonPressed:)];
    jialongpressGR.minimumPressDuration = 0.5; //设定长按时间
    [self.jiaBeishuButton addGestureRecognizer:jialongpressGR];
    [jialongpressGR release];
    
    //减  长按
    self.jianBeishuButton.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *jianlongpressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jianButtonPressed:)];
    jianlongpressGR.minimumPressDuration = 0.5; //设定长按时间
    [self.jianBeishuButton addGestureRecognizer:jianlongpressGR];
    [jianlongpressGR release];
}


- (void) jiaHandleTapGesture:(id)sender
{
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu++;
    if (tempBeishu > 100000) {
        tempBeishu = 100000;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}


- (void) jianHandleTapGesture:(id)sender
{
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu--;
    if (tempBeishu <= 1) {
        tempBeishu = 1;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}

- (void) jiaButtonPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.jiaBeishuButton setBackgroundImage:[UIImage imageNamed:@"jia_click.png"] forState:UIControlStateNormal];
        m_timer = [NSTimer scheduledTimerWithTimeInterval:(0.1)
                                                   target:self selector:@selector(jiaBeishu)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    
    
    //    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    //    {
    //
    //        [self.jiaBeishuButton setBackgroundImage:[UIImage imageNamed:@"jia_normal.png"] forState:UIControlStateNormal];
    //        [m_timer invalidate];
    //        m_timer = nil;
    //    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.jiaBeishuButton setBackgroundImage:[UIImage imageNamed:@"jia_normal.png"] forState:UIControlStateNormal];
        [m_timer invalidate];
        m_timer = nil;
    }
}


- (void) jianButtonPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        [self.jianBeishuButton setBackgroundImage:[UIImage imageNamed:@"jian_click.png"] forState:UIControlStateNormal];
        m_timer = [NSTimer scheduledTimerWithTimeInterval:(0.1)
                                                   target:self selector:@selector(jianBeishu)
                                                 userInfo:nil
                                                  repeats:YES];
    }
    
    //    if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    //    {
    //        [self.jianBeishuButton setBackgroundImage:[UIImage imageNamed:@"jian_normal.png"] forState:UIControlStateNormal];
    //        [m_timer invalidate];
    //        m_timer = nil;
    //    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.jianBeishuButton setBackgroundImage:[UIImage imageNamed:@"jian_normal.png"] forState:UIControlStateNormal];
        [m_timer invalidate];
        m_timer = nil;
    }
}


- (void) jiaBeishu{
    
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu++;
    if (tempBeishu > 100000) {
        tempBeishu = 100000;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}


- (void) jianBeishu{
    
    int tempBeishu = [self.fieldBeishu.text intValue];
    tempBeishu--;
    if (tempBeishu <= 1) {
        tempBeishu = 1;
    }
    self.fieldBeishu.text = [NSString stringWithFormat:@"%d",tempBeishu];
    
    [self refreshData];
}


- (void) refreshData
{
    [self refreshTopView];
}

- (void)yesSaveButtonClick
{
	if(!allSave)
	{
		allSave = !allSave;
        
		int saveNum = allAmount - [self.buyField.text intValue];
        
		m_saveField.text = [NSString stringWithFormat:@"%d",saveNum];
		m_saveByTotal.text = [NSString stringWithFormat:@"占总额%0.2f%@", saveNum/allAmount *100,@"％"];
        
        
		[m_saveField setTextColor:[UIColor grayColor]];
		m_saveField.userInteractionEnabled = NO;
        
		
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
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonThere setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFore setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFive setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}
- (void)hasPublicTwoButtonClick
{
	if(1 != isPublic)
	{
		isPublic = 1;
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonOne setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonThere setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFore setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFive setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}
- (void)hasPublicThereButtonClick
{
	if(2 != isPublic)
	{
		isPublic = 2;
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonOne setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFore setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFive setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}

- (void)hasPublicForeButtonClick
{
	if(3 != isPublic)
	{
		isPublic = 3;
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonOne setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonThere setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFive setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
	}
}

- (void)hasPublicFiveButtonClick
{
	if(4 != isPublic)
	{
		isPublic = 4;
		[m_buttonOne setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonOne setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonTwo setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonThere setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonThere setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFore setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
		[m_buttonFore setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateHighlighted];
		[m_buttonFive setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
		[m_buttonFive setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateHighlighted];
	}
}

#pragma mark navigationBar button
- (void)LotComplete:(id)sender
{
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
    int numBeishu = [self.fieldBeishu.text intValue];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    if([RuYiCaiLotDetail sharedObject].batchCode)
        [tempDic setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
	[tempDic setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
	[tempDic setObject:[NSString stringWithFormat:@"%d", numBeishu] forKey:@"lotmulti"];
	[tempDic setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
    //    [tempDic setObject:[NSString stringWithFormat:@"%0.0f", allAmount * 100]forKey:@"amount"];
    [tempDic setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];
    
    
    [tempDic setObject:@"200" forKey:@"oneAmount"];//单注多少元
    
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
    int numBeishu = [self.fieldBeishu.text intValue];
    
    [RuYiCaiLotDetail sharedObject].batchNum = @"";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    
    int aCount;
    int oneAmount;
    int oneBiAmount;//单笔金额
    
    aCount = 2 * [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * numBeishu;
    [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
    oneAmount = 200;
    oneBiAmount = [[RuYiCaiLotDetail sharedObject].zhuShuNum intValue] * 200;
    
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", aCount * 100];
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [RuYiCaiLotDetail sharedObject].amount;
    
    //    if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"0"])
    //    {
    //        [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].betCode stringByAppendingFormat:@"_%d_%d_%d", numBeishu, oneAmount, oneBiAmount];
    //    }
    //    else if([[RuYiCaiLotDetail sharedObject].sellWay isEqualToString:@"1"])//机选
    //    {
    //        NSArray*  eachBetCode = [[RuYiCaiLotDetail sharedObject].betCode componentsSeparatedByString:@";"];
    //        [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
    //        for(int i = 0; i < [eachBetCode count]; i++)
    //        {
    //            NSString*  aStr;
    //            if(i != [eachBetCode count] -1)
    //            {
    //                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%d_%d!", numBeishu, oneAmount, oneAmount];
    //            }
    //            else
    //            {
    //                aStr = [[eachBetCode objectAtIndex:i] stringByAppendingFormat:@"_%d_%d_%d", numBeishu, oneAmount, oneAmount];
    //            }
    //            [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@", aStr];
    //        }
    //    }
    //    else //多注投
    //    {
    //        [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
    //        NSLog(@"%@", [RuYiCaiLotDetail sharedObject].moreBetCodeInfor);
    //        for(int i = 0; i < [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count]; i++)
    //        {
    //            oneBiAmount = [[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_ZHUSHU] intValue] * [[RuYiCaiLotDetail sharedObject].oneAmount intValue];
    //
    //            if(i != [[RuYiCaiLotDetail sharedObject].moreBetCodeInfor count] - 1)
    //                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d!",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti, [RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
    //            else
    //                [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_%@_%d",[[[RuYiCaiLotDetail sharedObject].moreBetCodeInfor objectAtIndex:i] objectForKey:MORE_BETCODE], [RuYiCaiLotDetail sharedObject].lotMulti,[RuYiCaiLotDetail sharedObject].oneAmount, oneBiAmount];
    //            NSLog(@"aaaa %@", [RuYiCaiLotDetail sharedObject].moreZuBetCode);
    //        }
    //    }
}

- (void)randomNumSet
{
    
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
        if([textField.text intValue] <= 0 || [textField.text intValue] > 100000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～100000" withTitle:@"提示" buttonTitle:@"确定"];
            self.fieldBeishu.text = @"1";
        }
        
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
    
    if(self.view.center.y != 500)
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.fieldBeishu) {
        if (self.fieldBeishu.text.length >= 6 && range.length == 0)
        {
            return  NO;
        }
    }
    
    else//只允许输入数字
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    return YES;
}
#pragma  mark textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"%f", self.view.center.y);
    if(self.view.center.y != 150)
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
        if(self.view.center.y != 500)   
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
    
    if(self.view.center.y != 500)
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
    
    if(self.view.center.y != 500)
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

#pragma mark 投注注码 展开
- (IBAction)betCodeClick:(id)sender
{
    //    [[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"%@",[RuYiCaiLotDetail sharedObject].disBetCode] withTitle:@"投注号码" buttonTitle:@"确定"];
    
    BOOL ishave = NO;
    for (UIScrollView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UIScrollView class]] && view.tag == kFangAnXiangQingViewTag) {
            ishave = YES;
            if (!m_expandBetCode) {
                view.hidden = NO;
            }
            else
                view.hidden = YES;
        }
    }
    if (!ishave) {
        UIScrollView* view = [self creatExpandCellView];
        [self.view addSubview:view];
    }
    if (!m_expandBetCode) {
        [betCodeList setTitle:@"" forState:UIControlStateNormal];
        [self betCode_ExpandButtonEvent_move:YES];
    }
    else
    {
        NSString* betCodeListStr = [RuYiCaiLotDetail sharedObject].disBetCode;
        betCodeListStr = [betCodeListStr stringByReplacingOccurrencesOfString:@"," withString:@" "];//去掉 button中的，
        [self.betCodeList setTitle:[NSString stringWithFormat:@"%@", betCodeListStr] forState:UIControlStateNormal];
        [self betCode_ExpandButtonEvent_move:NO];
    }
    
    m_expandBetCode = !m_expandBetCode;
    
    if (m_expandBetCode) {
        image_sanjiao.image = [UIImage imageNamed:@"sanjiao_expand.png"];
    }
    else
        image_sanjiao.image = [UIImage imageNamed:@"sanjiao_hide.png"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"launchViewContentSizeCahnge" object:(m_expandBetCode ? @"yes" : @"no")];
    
}

//获得 注码的高度
-(NSInteger) getBetCodeListHeight
{
    NSMutableString* betcodeList = [NSMutableString stringWithString:[[RuYiCaiLotDetail sharedObject] disBetCode]];
    if ([betcodeList length] == 0) {
        return 0;
    }
    // ; @ , ~
    NSArray* gameArray = [betcodeList componentsSeparatedByString:@";"];
    int heightindex = 0;
    if (gameArray > 0) {
        for ( int i = 0;i < [gameArray count];i++) {
            NSString* str = [gameArray objectAtIndex:i];
            NSArray* array_2 = [str componentsSeparatedByString:@"@"];
            //周一 001 皇家马德里 vs 巴萨
            heightindex += 1;
            if ([array_2 count] == 2)
            {
                NSString* play_str = [array_2 objectAtIndex:1];
                NSArray* array_3 = [play_str componentsSeparatedByString:@","];
                
                for (int j = 0 ; j < [array_3 count];j++) {
                    NSString* str_3 = [array_3 objectAtIndex:j];
                    
                    if ([str_3 length] > 0) {
                        NSArray* array_4 = [str_3 componentsSeparatedByString:@"~"];
                        NSString* play_content = ([array_4 count] > 1 ? [array_4 objectAtIndex:1] : @"");
                        if ([play_content length] > 0)
                        {
                            CGSize labelsize = [play_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300 - 60,2000) lineBreakMode:UILineBreakModeWordWrap];
                            int hangnum = labelsize.height/19 + 1;
                            /*0:2 0:3 1:0 2: 0 3:0 5:2
                             胜其他 平其他 负其他
                             */
                            heightindex += hangnum;
                        }
                    }
                }
            }
        }
    }
    return  heightindex * 20;
}

//创建 注码显示view
-(UIScrollView*) creatExpandCellView
{
    NSMutableString* betcodeList = [NSMutableString stringWithString:[[RuYiCaiLotDetail sharedObject] disBetCode]];
    if ([betcodeList length] == 0) {
        return nil;
    }
    UIScrollView* view = [[[UIScrollView alloc] initWithFrame:CGRectMake(10, 173, 299, kMoveDownHeight)] autorelease];
    view.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:247.0/255.0 blue:241.0/255.0 alpha:1.0];
    view.contentSize = CGSizeMake(299, m_betCodeListHeight);
    view.tag = kFangAnXiangQingViewTag;
    // ; @ , :
    NSArray* gameArray = [betcodeList componentsSeparatedByString:@";"];
    if (gameArray > 0) {
        int heightindex = 0;
        for ( int i = 0;i < [gameArray count];i++) {
            NSString* str = [gameArray objectAtIndex:i];
            
            NSArray* array_2 = [str componentsSeparatedByString:@"@"];
            //周一 001 皇家马德里 vs 巴萨
            UILabel* lable = [[[UILabel alloc] initWithFrame:CGRectMake(10, heightindex * 19 , 300, 19)] autorelease];
            lable.backgroundColor = [UIColor clearColor];
            lable.textColor = [UIColor blackColor];
            lable.font = [UIFont systemFontOfSize:13];
            lable.textAlignment = UITextAlignmentLeft;
            lable.text = ([array_2 count] > 0 ? [array_2 objectAtIndex:0] :@"");
            [view addSubview:lable];
            
            heightindex += 1;
            if ([array_2 count] == 2)
            {
                NSString* play_str = [array_2 objectAtIndex:1];
                NSArray* array_3 = [play_str componentsSeparatedByString:@","];
                
                for (int j = 0 ; j < [array_3 count];j++) {
                    NSString* str_3 = [array_3 objectAtIndex:j];
                    
                    if ([str_3 length] > 0) {
                        NSArray* array_4 = [str_3 componentsSeparatedByString:@"~"];
                        NSString* playChoose = ([array_4 count] > 0 ? [array_4 objectAtIndex:0] : @"");
                        //胜平负：
                        if ([playChoose length] > 0) {
                            
                            UILabel* lable = [[[UILabel alloc] initWithFrame:CGRectMake(10, heightindex * 19 , 70, 19)] autorelease];
                            lable.textColor = [UIColor blackColor];
                            lable.backgroundColor = [UIColor clearColor];
                            lable.font = [UIFont systemFontOfSize:13];
                            lable.textAlignment = UITextAlignmentLeft;
                            lable.text = playChoose;
                            [view addSubview:lable];
                        }
                        
                        NSString* play_content = ([array_4 count] > 1 ? [array_4 objectAtIndex:1] : @"");
                        
                        if ([play_content length] > 0)
                        {
                            CGSize labelsize = [play_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300 - 80,2000) lineBreakMode:UILineBreakModeWordWrap];
                            int hangnum = labelsize.height/19 + 1;
                            /*0:2 0:3 1:0 2: 0 3:0 5:2
                             胜其他 平其他 负其他
                             */
                            UILabel* lable_content = [[[UILabel alloc] initWithFrame:CGRectMake(75, 19 * heightindex, 300 - 80, hangnum * 19)] autorelease];
                            lable_content.backgroundColor = [UIColor clearColor];
                            lable_content.textColor = [UIColor redColor];
                            lable_content.font = [UIFont systemFontOfSize:13];
                            lable_content.textAlignment = UITextAlignmentLeft;
                            lable_content.lineBreakMode = UILineBreakModeWordWrap;
                            lable_content.numberOfLines = hangnum;
                            lable_content.text = play_content;
                            [view addSubview:lable_content];
                            heightindex += hangnum;
                        }
                    }
                }
            }
        }
    }
    return view;
}

//上下 移动
-(void) betCode_ExpandButtonEvent_move:(BOOL)down
{
    
    int moveHeight = 0;
    if (down) {
        moveHeight = kMoveDownHeight + 2;
    }
    else
    {
        moveHeight = -(kMoveDownHeight + 2);
    }
    
    self.betInfo_downView.frame = CGRectMake(self.betInfo_downView.frame.origin.x, self.betInfo_downView.frame.origin.y + moveHeight, self.betInfo_downView.frame.size.width, self.betInfo_downView.frame.size.height);
    
    
    self.launchView.frame = CGRectMake(self.launchView.frame.origin.x, self.launchView.frame.origin.y + moveHeight, self.launchView.frame.size.width, self.launchView.frame.size.height);
}

@end
