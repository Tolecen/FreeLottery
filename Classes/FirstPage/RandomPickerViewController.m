//
//  RandomPickerViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RandomPickerViewController.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

@implementation RandomPickerViewController

@synthesize delegate;
@synthesize pickerNumArray = m_pickerNumArray;
@synthesize pickerType = m_pickerType;
- (void)dealloc 
{
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	[AdaptationUtils adaptation:self];
	self.view = [self mainView];
    
    float screenHt = [[UIScreen mainScreen] bounds].size.height;
	self.view.frame = CGRectMake(0, screenHt, 320, screenHt);
//    UIView *whitView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height)];
//    whitView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:whitView];
//    [whitView release];
    
	m_randomPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200, 320, [UIScreen mainScreen].bounds.size.height)];
	m_randomPicker.delegate = self;
	m_randomPicker.dataSource = self;
	[m_randomPicker setShowsSelectionIndicator:YES];
	[self.view addSubview:m_randomPicker];
	
	m_pickerNumArray = [[NSMutableArray alloc] init];
}

- (void)presentModalView:(UIView *)subView setPickerType:(int)type
{
	[UIView beginAnimations:@"movement" context:nil]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
	CGPoint center = self.view.center;
	center.y -= [[UIScreen mainScreen] bounds].size.height;
	self.view.center = center;
	m_isMove = NO;
	[UIView commitAnimations];
	
	[m_randomPicker selectRow:0 inComponent:0 animated:NO];
	m_pickerType = type;
}

- (void)dismissModalView:(UIView *)subView
{		
	[UIView beginAnimations:@"movement" context:nil]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
	CGPoint center = self.view.center;
	center.y += [[UIScreen mainScreen] bounds].size.height;
	self.view.center = center;
	[UIView commitAnimations];
}

- (UIView *)mainView 
{
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
	UIView *mainView = [[[UIView alloc] initWithFrame:frame]autorelease];
	[mainView setBackgroundColor:[UIColor clearColor]];
//    mainView.alpha = 0.7f;
//	[mainView setBackgroundColor:[UIColor clearColor]];
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height-200)];
    clearView.backgroundColor = [UIColor grayColor];
    clearView.alpha = 0.7f;
    [mainView addSubview:clearView];
    [clearView release];
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-200, 320, frame.size.height + 40)];
    [imageView setBackgroundColor:[UIColor whiteColor]];
//	imageView.alpha = 0.7f;
	[mainView addSubview:imageView];
    [imageView release];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 20)];
//    //label.text = @"请选择";
//    label.textAlignment = UITextAlignmentLeft;
//	label.textColor = [UIColor whiteColor];
//	label.backgroundColor = [UIColor clearColor];
//	[mainView addSubview:label];
//    [label release];
    
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(pressedCancel)];
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(pressedOK)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200-44, 320, 44)];
	[toolbar setItems:[NSArray arrayWithObjects:cancelButton, submitButton, nil] animated:YES];
	[mainView addSubview:toolbar];
	[toolbar release];
    [cancelButton release];
    [submitButton release];
	return mainView;
}

- (void)setPickerNum:(int)num withMinNum:(int)minNum andMaxNum:(int)maxNum;
{
    m_pickerMinNum = minNum;
    m_pickerMaxNum = maxNum;
    m_selectPickerRow = num - minNum;
    
    if (SSQ_RANDOM_NUM == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        for (int i = m_pickerMinNum; i < (m_pickerMaxNum + 1); i++) 
            [m_pickerNumArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    else if (FC3D_GROUP == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"组三"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"组六"]];
    }
    else if (BANK_GROUP == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"中国工商银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"中国农业银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"中国建设银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"招商银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"中国邮政储蓄银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"华夏银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"兴业银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"中信银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"中国光大银行"]];
//        [m_pickerNumArray addObject:[NSString stringWithFormat:@"上海浦东发展银行"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"平安银行"]];
    }
    else if (PHONE_CARD_TYPE_GROUP == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"移动充值卡"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"联通充值卡"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"电信充值卡"]];
    }
    else if (PHONE_CARD_AMOUNT_GROUP == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"10"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"20"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"30"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"50"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"100"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"200"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"300"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"500"]];
    }
    else if (GAME_CARD_TYPE_GROU == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"征途卡"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"盛大卡"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"骏网一卡通"]];
    }
    else if(GET_CASH_BANK_NAME == m_pickerType)
    {
        NSLog(@"GET_CASH_BANK_NAME");
    }
    else if(P11X5_TYPE == m_pickerType)
	{
		[m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选二"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选三"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选四"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选五"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选六"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选七"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选八"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前一直选"]];

        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前二组选"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前二直选"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前三组选"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前三直选"]];
	}
    else if(DRAG11X5_TYPE == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选二"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选三"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选四"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选五"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选六"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选七"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选八"]];
        
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前二组选"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前三组选"]];
    }
    else if(DRAG11YDJ_TYPE == m_pickerType)
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选二"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选三"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选四"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选五"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选六"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"任选七"]];
        
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前二组选"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"前三组选"]];
    }
	else if(LUCK_PLAY_TYPE == m_pickerType) 
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"星座"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"生肖"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"姓名"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"生日"]];
    }
    else if(LUCK_LOT_TYPE == m_pickerType) 
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"双色球"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"大乐透"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"福彩3D"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"时时彩"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"江西11选5"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"广东11选5"]];
        [m_pickerNumArray addObject:[NSString stringWithFormat:@"十一运夺金"]];
//        [m_pickerNumArray addObject:[NSString stringWithFormat:@"广东快乐十分"]];
    }
    else if(LUCK_NUM == m_pickerType) 
    {
        [m_pickerNumArray removeAllObjects];
        [m_pickerNumArray removeAllObjects];
        for (int i = m_pickerMinNum; i < (m_pickerMaxNum + 1); i++) 
            [m_pickerNumArray addObject:[NSString stringWithFormat:@"%d注", i]];
    }
	[m_randomPicker reloadAllComponents];
    [m_randomPicker selectRow:m_selectPickerRow inComponent:0 animated:YES];//刚进去时选中的行
}

- (int)currentPickerType
{
    return m_pickerType;
}

- (void)setPickerDataArray:(NSArray*)otherArray
{
    [m_pickerNumArray removeAllObjects];
    [m_pickerNumArray addObjectsFromArray:otherArray];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [m_pickerNumArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
	return [m_pickerNumArray objectAtIndex:row];	
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	m_selectPickerRow = row;
}

- (void)pressedCancel 
{
	[self dismissModalView:self.view];
}

- (void)pressedOK
{	
	[delegate randomPickerView:self selectRowNum:m_selectPickerRow];
	[self dismissModalView:self.view];	
}

@end
