//
//  LuckViewController.m
//  RuYiCai
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LuckViewController.h"
#import "RYCImageNamed.h"
#import "LuckListViewController.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

#define xingZuoButtonStartTag  (101)
#define shengXiaoButtonStartTag (201)

@interface LuckViewController (internal)

- (void)setMainView;
- (void)selectButtonClick:(UIButton*)button;
- (void)startButttonClick;

- (void)setNameView;
- (void)setXingZuoView;
- (void)xingZuoButtonClick:(UIButton*)button;

- (void)setShengXiaoView;
- (void)shengXiaoButtonClick:(UIButton*)button;

- (void)setShengRiView;
- (void)setPickDateView;
- (void)dateSelect:(id)sender;

- (void)refreshView;

@end

@implementation LuckViewController

@synthesize nameView = m_nameView;
@synthesize xingZuoView = m_xingZuoView;
@synthesize shengXiaoView = m_shengXiaoView;
@synthesize shengRiView = m_shengRiView;
@synthesize randomPickType = m_randomPickType;
@synthesize birNameImageView = m_birNameImageView;
- (void)dealloc
{
    m_delegate.randomPickerView.delegate = nil;
    m_selectDateView.delegate = nil;
    
    [m_birNameImageView release];
    [m_mainScrollView release];
    
    [m_LuckTypeButton release];
    [m_LuckLotButton release];
    [m_LuckNumberButton release];
    
    [m_nameView release];
    [m_nameField release];
    
    [m_xingZuoView release];
    [xingZuo_imageNameArr_normal release];
    [xingZuo_imageNameArr_click release];
    [m_xingZuoButton release];
    [m_dateLabel release];
    
    [m_shengXiaoView release];
    [shengXiao_imageNameArr_normal release];
    [shengXiao_imageNameArr_click release];
    [m_shengXiaoButton release];
    
    [m_shengRiView release];
    [m_selectDateView release];
    [m_yearButton release];
    [m_monthButton release];
    [m_dayButton release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    m_delegate.randomPickerView.delegate = self;
    m_randomPickType = 0;
    
    m_recoderType = 1;
    m_recodeLotType = 1;
    m_recoderNum = 5;
    
    xingZuo_imageNameArr_normal = [[NSArray alloc] initWithObjects:@"xza_c_1.png", @"xza_c_2.png",@"xza_c_3.png",@"xza_c_4.png",@"xza_c_5.png",@"xza_c_6.png",@"xza_c_7.png",@"xza_c_8.png",@"xza_c_9.png",@"xza_c_10.png",@"xza_c_11.png",@"xza_c_12.png", nil];
    xingZuo_imageNameArr_click = [[NSArray alloc] initWithObjects:@"xzb_c_1.png", @"xzb_c_2.png",@"xzb_c_3.png",@"xzb_c_4.png",@"xzb_c_5.png",@"xzb_c_6.png",@"xzb_c_7.png",@"xzb_c_8.png",@"xzb_c_9.png",@"xzb_c_10.png",@"xzb_c_11.png",@"xzb_c_12.png", nil];
    
    shengXiao_imageNameArr_normal = [[NSArray alloc] initWithObjects:@"sxa_c_1.png", @"sxa_c_2.png",@"sxa_c_3.png",@"sxa_c_4.png",@"sxa_c_5.png",@"sxa_c_6.png",@"sxa_c_7.png",@"sxa_c_8.png",@"sxa_c_9.png",@"sxa_c_10.png",@"sxa_c_11.png",@"sxa_c_12.png", nil];
    shengXiao_imageNameArr_click = [[NSArray alloc] initWithObjects:@"sxb_c_1.png", @"sxb_c_2.png",@"sxb_c_3.png",@"sxb_c_4.png",@"sxb_c_5.png",@"sxb_c_6.png",@"sxb_c_7.png",@"sxb_c_8.png",@"sxb_c_9.png",@"sxb_c_10.png",@"sxb_c_11.png",@"sxb_c_12.png", nil];
    
    NSString *selectpath = [[NSBundle mainBundle]
                      pathForResource:@"selectMusic"
                      ofType:@"mp3"];
	NSURL *selectUrl = [NSURL fileURLWithPath:selectpath];
    //NSError *erro;
    m_musicSelect = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:selectUrl error:nil];	

    NSString *okpath = [[NSBundle mainBundle]
                            pathForResource:@"okClickMusic"
                            ofType:@"mp3"];
	NSURL *okUrl = [NSURL fileURLWithPath:okpath];
    m_musicOK = [[AVAudioPlayer alloc]
                     initWithContentsOfURL:okUrl error:nil];	
 
    [self setMainView];
 
    [self setNameView];
    [self setXingZuoView];
    [self setShengXiaoView];
    [self setShengRiView];
}

- (void)refreshView
{
    if(1 == m_recoderType)
    {
        [m_birNameImageView setHidden:YES];
        self.nameView.hidden = YES;
        self.xingZuoView.hidden = NO;
        self.shengXiaoView.hidden = YES;
        self.shengRiView.hidden = YES;
    }
    else if(2 == m_recoderType)
    {
        [m_birNameImageView setHidden:YES];
        self.nameView.hidden = YES;
        self.xingZuoView.hidden = YES;
        self.shengXiaoView.hidden = NO;
        self.shengRiView.hidden = YES;
    }
    else if(3 == m_recoderType)
    {
        [m_birNameImageView setHidden:NO];
        self.nameView.hidden = NO;
        self.xingZuoView.hidden = YES;
        self.shengXiaoView.hidden = YES;
        
        self.shengRiView.hidden = YES;
    }
    else
    {
        [m_birNameImageView setHidden:NO];
        self.nameView.hidden = YES;
        self.xingZuoView.hidden = YES;
        self.shengXiaoView.hidden = YES;
        
        self.shengRiView.hidden = NO;
    }
}

#pragma mark name view
- (void)setNameView
{
    m_nameView = [[UIView alloc] initWithFrame:CGRectMake(25, 60, 270, 232)];
    m_nameView.backgroundColor = [UIColor clearColor];
    [m_mainScrollView addSubview:m_nameView];
    
    UIImageView* name_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"filed_c_tx.png")]; 
    name_bg.frame = CGRectMake(110, 50, 50, 46);
    [self.nameView addSubview:name_bg];
    [name_bg release];
    
    m_nameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 102, 191, 40)];
    [m_nameField setBackground:RYCImageNamed(@"filed_c_name.png")];
    m_nameField.textAlignment = UITextAlignmentCenter;
    m_nameField.borderStyle = UITextBorderStyleNone;
    m_nameField.delegate = self;
//    [m_nameField.textColor setTextColor:[UIColor colorWithRed:178.0/255.0 green:133.0/255.0 blue:0 alpha:1.0]];
    
    m_nameField.placeholder = @"请输入您的姓名";
//    m_nameField.text    =  @"请输入您的姓名";
    m_nameField.textColor = [ColorUtils parseColorFromRGB:@"#ff6f1e"];
    m_nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_nameField.keyboardType = UIKeyboardTypeEmailAddress;
    m_nameField.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_nameField.clearsOnBeginEditing = YES;
    m_nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    m_nameField.returnKeyType = UIReturnKeyDone;
    [self.nameView addSubview:m_nameField];

//    UILabel*  name_label = [[UILabel alloc] initWithFrame:CGRectMake(22, 137, 150, 25)];
//    name_label.text = @"请输入您的姓名";
//    name_label.backgroundColor = [UIColor clearColor];
//    [name_label setTextColor:[UIColor colorWithRed:178.0/255.0 green:133.0/255.0 blue:0 alpha:1.0]];
//    name_label.font = [UIFont systemFontOfSize:13.0f];
//    [self.nameView addSubview:name_label];
//    [name_label release];
    
    self.nameView.hidden = YES;
}

#pragma mark XingZuo view
- (void)setXingZuoView
{
    m_xingZuoView = [[UIView alloc] initWithFrame:CGRectMake(30, 40, 270, 200)];
    m_xingZuoView.backgroundColor = [UIColor clearColor];
    [m_mainScrollView addSubview:m_xingZuoView];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xz_date_bg.png"]];
    imageView.frame = CGRectMake(75, 55, 108, 101);
    [m_xingZuoView addSubview:imageView];
    [imageView release];
    
    m_xingZuoButton = [[UIButton alloc] initWithFrame:CGRectMake(82, 70, 100, 58)];
    [m_xingZuoButton setTitle:@"白羊座" forState:UIControlStateNormal];
    m_xingZuoButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 2);
    [m_xingZuoButton setBackgroundColor:[UIColor clearColor]];
    [m_xingZuoButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
    m_xingZuoButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    [m_xingZuoButton setBackgroundImage:RYCImageNamed(@"center_txt.png")  forState:UIControlStateNormal];
//    [m_xingZuoButton setBackgroundImage:RYCImageNamed(@"center_txt.png")  forState:UIControlStateHighlighted];
    [self.xingZuoView addSubview:m_xingZuoButton];
    
    m_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 105, 130, 30)];
    m_dateLabel.text = @"3月21日-4月19日";
    m_dateLabel.textAlignment = UITextAlignmentCenter;
    m_dateLabel.backgroundColor = [UIColor clearColor];
    [m_dateLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:0 blue:0 alpha:1.0]];
    m_dateLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [self.xingZuoView addSubview:m_dateLabel];

    for (int i = 0; i < 4; i++)
    {
        UIButton* tempButton_top = [[UIButton alloc] initWithFrame:CGRectMake(22 + 55* i, 2, 50, 50)];
        [tempButton_top setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateNormal];
        [tempButton_top setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:i]) forState:UIControlStateHighlighted];
        tempButton_top.tag = xingZuoButtonStartTag + i;
        [tempButton_top addTarget:self action:@selector(xingZuoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.xingZuoView addSubview:tempButton_top];
        [tempButton_top release];
    }
    for(int j = 4; j < 7; j++)
    {
        UIButton* tempButton_rigth = [[UIButton alloc] initWithFrame:CGRectMake(188, 53+ 53 * (j-4), 50, 50)];
        [tempButton_rigth setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:j]) forState:UIControlStateNormal];
        [tempButton_rigth setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:j]) forState:UIControlStateHighlighted];
        tempButton_rigth.tag = xingZuoButtonStartTag + j;
        [tempButton_rigth addTarget:self action:@selector(xingZuoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.xingZuoView addSubview:tempButton_rigth];
        [tempButton_rigth release];

    }
    for(int n = 9; n > 6; n--)
    {
        UIButton* tempButton_bottom = [[UIButton alloc] initWithFrame:CGRectMake(22 +53 * (9 - n), 160, 50 ,50)];
        [tempButton_bottom setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:n]) forState:UIControlStateNormal];
        [tempButton_bottom setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:n]) forState:UIControlStateHighlighted];
        tempButton_bottom.tag = xingZuoButtonStartTag + n;
        [tempButton_bottom addTarget:self action:@selector(xingZuoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.xingZuoView addSubview:tempButton_bottom];
        [tempButton_bottom release];
    }
    for(int m = 11; m > 9; m--)
    {
        UIButton* tempButton_left = [[UIButton alloc] initWithFrame:CGRectMake(22 , 53 + (11 - m) * 53, 50, 50)];
        [tempButton_left setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:m]) forState:UIControlStateNormal];
        [tempButton_left setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:m]) forState:UIControlStateHighlighted];
        tempButton_left.tag = xingZuoButtonStartTag + m;
        [tempButton_left addTarget:self action:@selector(xingZuoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.xingZuoView addSubview:tempButton_left];
        [tempButton_left release];
    }
}

- (void)xingZuoButtonClick:(UIButton*)button
{
    [m_musicSelect play];
    m_musicSelect.numberOfLoops = 1;
    
    if([[m_xingZuoButton currentTitle] isEqualToString:[button currentTitle]])
    {
        return;
    }
    NSArray* xingZuo_title_Arr = [NSArray arrayWithObjects:@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座",  nil];
    NSArray* xingZuo_date_Arr = [NSArray arrayWithObjects:@"3月21日-4月19日", @"4月20日-5月20日", @"5月21日-6月21日", @"6月22日-7月22日", @"7月23日-8月22日", @"8月23日-9月22日", @"9月23日-10月23日", @"10月24日-11月22日", @"11月23日-12月21日", @"12月22日-1月19日", @"1月20日-2月18日", @"2月19日-3月20日",  nil];
    [m_xingZuoButton setTitle:[xingZuo_title_Arr objectAtIndex:button.tag -xingZuoButtonStartTag] forState:UIControlStateNormal];
    [m_dateLabel setText:[xingZuo_date_Arr objectAtIndex:button.tag -xingZuoButtonStartTag]];
    for(int i = 0; i < 12; i++)
    {
        if((xingZuoButtonStartTag + i ) != button.tag)
        {
            UIButton*  tempButton = (UIButton*)[self.xingZuoView viewWithTag:xingZuoButtonStartTag + i];
            if(i == 0)
            {
                [tempButton setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:i]) forState:UIControlStateNormal];
                [tempButton setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
            else
            {
                [tempButton setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateNormal];
                [tempButton setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
        }
        else
        {
            if(i == 0)
            {
                [button setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateNormal];
                [button setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
            else
            {
                [button setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_click objectAtIndex:i]) forState:UIControlStateNormal];
                [button setBackgroundImage:RYCImageNamed([xingZuo_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
        }
    }
}

#pragma mark shengXiao view
- (void)setShengXiaoView
{
    m_shengXiaoView = [[UIView alloc] initWithFrame:CGRectMake(30, 40, 270, 262)];
    m_shengXiaoView.backgroundColor = [UIColor clearColor];
    [m_mainScrollView addSubview:m_shengXiaoView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xz_date_bg.png"]];
    imageView.frame = CGRectMake(75, 55, 108, 101);
    [m_shengXiaoView addSubview:imageView];
    [imageView release];
    
    m_shengXiaoButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 78, 100, 58)];
    [m_shengXiaoButton setTitle:@"鼠" forState:UIControlStateNormal];
    m_shengXiaoButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 2);
    [m_shengXiaoButton setBackgroundColor:[UIColor clearColor]];
    [m_shengXiaoButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:0 blue:0 alpha:1.0] forState:UIControlStateNormal];
    m_shengXiaoButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f]; 
//    [m_shengXiaoButton setBackgroundImage:RYCImageNamed(@"center_txt.png")  forState:UIControlStateNormal];
//    [m_shengXiaoButton setBackgroundImage:RYCImageNamed(@"center_txt.png")  forState:UIControlStateHighlighted];
    [self.shengXiaoView addSubview:m_shengXiaoButton];
        
    for (int i = 0; i < 4; i++)
    {
        UIButton* tempButton_top = [[UIButton alloc] initWithFrame:CGRectMake(22 + 55* i, 2, 50, 50)];
        [tempButton_top setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateNormal];
        [tempButton_top setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:i]) forState:UIControlStateHighlighted];
        tempButton_top.tag = shengXiaoButtonStartTag + i;
        [tempButton_top addTarget:self action:@selector(shengXiaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shengXiaoView addSubview:tempButton_top];
        [tempButton_top release];
    }
    for(int j = 4; j < 7; j++)
    {
        UIButton* tempButton_rigth = [[UIButton alloc] initWithFrame:CGRectMake(188, 53+ 53 * (j-4), 50, 50)];
        [tempButton_rigth setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:j]) forState:UIControlStateNormal];
        [tempButton_rigth setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:j]) forState:UIControlStateHighlighted];
        tempButton_rigth.tag = shengXiaoButtonStartTag + j;
        [tempButton_rigth addTarget:self action:@selector(shengXiaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shengXiaoView addSubview:tempButton_rigth];
        [tempButton_rigth release];
        
    }
    for(int n = 9; n > 6; n--)
    {
        UIButton* tempButton_bottom = [[UIButton alloc] initWithFrame:CGRectMake(22 +53 * (9 - n), 160, 50 ,50)];
        [tempButton_bottom setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:n]) forState:UIControlStateNormal];
        [tempButton_bottom setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:n]) forState:UIControlStateHighlighted];
        tempButton_bottom.tag = shengXiaoButtonStartTag + n;
        [tempButton_bottom addTarget:self action:@selector(shengXiaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shengXiaoView addSubview:tempButton_bottom];
        [tempButton_bottom release];
    }
    for(int m = 11; m > 9; m--)
    {
        UIButton* tempButton_left = [[UIButton alloc] initWithFrame:CGRectMake(22 , 53 + (11 - m) * 53, 50, 50)];
        [tempButton_left setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:m]) forState:UIControlStateNormal];
        [tempButton_left setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:m]) forState:UIControlStateHighlighted];
        tempButton_left.tag = shengXiaoButtonStartTag + m;
        [tempButton_left addTarget:self action:@selector(shengXiaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.shengXiaoView addSubview:tempButton_left];
        [tempButton_left release];
    }
    
    self.shengXiaoView.hidden = YES;

}

- (void)shengXiaoButtonClick:(UIButton*)button
{
    [m_musicSelect play];
    m_musicSelect.numberOfLoops = 1;

    if([[m_shengXiaoButton currentTitle] isEqualToString:[button currentTitle]])
    {
        return;
    }
    NSArray* shengXiao_title_Arr = [NSArray arrayWithObjects:@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪",  nil];
    [m_shengXiaoButton setTitle:[shengXiao_title_Arr objectAtIndex:button.tag -shengXiaoButtonStartTag] forState:UIControlStateNormal];
    for(int i = 0; i < 12; i++)
    {
        if((shengXiaoButtonStartTag + i ) != button.tag)
        {
            UIButton*  tempButton = (UIButton*)[self.shengXiaoView viewWithTag:shengXiaoButtonStartTag + i];
            if(i == 0)
            {
                [tempButton setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:i]) forState:UIControlStateNormal];
                [tempButton setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
            else
            {
                [tempButton setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateNormal];
                [tempButton setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
        }
        else
        {
            if(i == 0)
            {
                [button setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateNormal];
                [button setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
            else
            {
                [button setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_click objectAtIndex:i]) forState:UIControlStateNormal];
                [button setBackgroundImage:RYCImageNamed([shengXiao_imageNameArr_normal objectAtIndex:i]) forState:UIControlStateHighlighted];
            }
        }
    }
}

#pragma mark shengRi view
- (void)setShengRiView 
{
    m_shengRiView = [[UIView alloc] initWithFrame:CGRectMake(25, 60, 270, 200)];
    m_shengRiView.backgroundColor = [UIColor clearColor];
    [m_mainScrollView addSubview:m_shengRiView];
    
    NSDate *date_now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];//location设置为中国
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSString* nowDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: date_now]];
    NSLog(@"nowDate:%@", nowDate);
    [dateFormatter release];
    
    UIImageView* name_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"birthday_c_imge.png")]; 
    name_bg.frame = CGRectMake(110, 50, 50, 46);
    [self.shengRiView addSubview:name_bg];
    [name_bg release];


    m_dayButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 102, 191, 40)];
    
    [m_dayButton setBackgroundColor:[UIColor clearColor]];
    [m_dayButton setTitleColor:[ColorUtils parseColorFromRGB:@"#ff6f1e"] forState:UIControlStateNormal];
    m_dayButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [m_dayButton setBackgroundImage:RYCImageNamed(@"filed_c_name.png")  forState:UIControlStateNormal];
    [m_dayButton setTitle:@"请输入您的生日" forState:UIControlStateNormal];
    [m_dayButton addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.shengRiView addSubview:m_dayButton];
//
//    UILabel*  date_label = [[UILabel alloc] initWithFrame:CGRectMake(25, 137, 220, 25)];
//    date_label.text = @"  请选择年份           月份            日期";
//    date_label.textAlignment = UITextAlignmentLeft;
//    date_label.backgroundColor = [UIColor clearColor];
//    [date_label setTextColor:[UIColor colorWithRed:178.0/255.0 green:133.0/255.0 blue:0 alpha:1.0]];
//    date_label.font = [UIFont systemFontOfSize:13.0f];
//    [self.shengRiView addSubview:date_label];
//    [date_label release];
    
    self.shengRiView.hidden = YES;
    
    [self setPickDateView];
}

- (void)setPickDateView
{
    m_selectDateView = [[DatePickView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height)];
    m_selectDateView.delegate = self;
    [self.view addSubview:m_selectDateView];
}

#pragma mark main View
- (void)setMainView
{
    UIImageView* big_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"luck_c_bg.png")];
    big_bg.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    [self.view addSubview:big_bg];
    [big_bg release];
    
    m_birNameImageView = [[UIImageView alloc] initWithImage:RYCImageNamed(@"birthday_c_name.png")];
    m_birNameImageView.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    [m_birNameImageView setHidden:YES];
    [self.view addSubview:m_birNameImageView];
    

    m_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 480)/3, 320, 416)];
    m_mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_mainScrollView];
    
//    UIImageView* kit_bg = [[UIImageView alloc] initWithImage:RYCImageNamed(@"luck_kit.png")];
//    kit_bg.frame = CGRectMake(2, 3, 316, 410);
//    [m_mainScrollView addSubview:kit_bg];
//    [kit_bg release];
    if (KISiPhone5) {
        m_LuckTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(43,[UIScreen mainScreen].bounds.size.height - 270, 60, 48)];
    }else{
       m_LuckTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(43,[UIScreen mainScreen].bounds.size.height - 210, 60, 48)]; 
    }
    
    m_LuckTypeButton.backgroundColor =[UIColor clearColor];
    [m_LuckTypeButton setTitle:@"星座" forState:UIControlStateNormal];
    [m_LuckTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_LuckTypeButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [m_LuckTypeButton setBackgroundImage:RYCImageNamed(@"xz_zs_nomal.png") forState:UIControlStateNormal];
    [m_LuckTypeButton setBackgroundImage:RYCImageNamed(@"xz_zs_click.png") forState:UIControlStateNormal];
    [m_LuckTypeButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_mainScrollView insertSubview:m_LuckTypeButton atIndex:100];
    
    
    if (KISiPhone5) {
        m_LuckLotButton = [[UIButton alloc] initWithFrame:CGRectMake(110, [UIScreen mainScreen].bounds.size.height - 270, 100, 48)];
    }else{
       m_LuckLotButton = [[UIButton alloc] initWithFrame:CGRectMake(110, [UIScreen mainScreen].bounds.size.height - 210, 100, 48)];
    }
    
    [m_LuckLotButton setTitle:@"双色球" forState:UIControlStateNormal];
    [m_LuckLotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_LuckLotButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    m_LuckLotButton.backgroundColor =[UIColor clearColor];
    [m_LuckLotButton setBackgroundImage:RYCImageNamed(@"cz_xy_nomal.png") forState:UIControlStateNormal];
    [m_LuckLotButton setBackgroundImage:RYCImageNamed(@"cz_xy_click.png") forState:UIControlStateNormal];
    [m_LuckLotButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_mainScrollView addSubview:m_LuckLotButton];

    if (KISiPhone5) {
        m_LuckNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(215, [UIScreen mainScreen].bounds.size.height - 270, 60, 48)];
    }else{
        m_LuckNumberButton = [[UIButton alloc] initWithFrame:CGRectMake(215, [UIScreen mainScreen].bounds.size.height - 210, 60, 48)];
    }
    
    
    [m_LuckNumberButton setTitle:@"选5注" forState:UIControlStateNormal];
    [m_LuckNumberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_LuckNumberButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    m_LuckNumberButton.backgroundColor =[UIColor clearColor];
    [m_LuckNumberButton setBackgroundImage:RYCImageNamed(@"xz_zs_nomal.png") forState:UIControlStateNormal];
    [m_LuckNumberButton setBackgroundImage:RYCImageNamed(@"xz_zs_click.png") forState:UIControlStateNormal];
    [m_LuckNumberButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_mainScrollView addSubview:m_LuckNumberButton];
    
    UIButton* startButton = [[UIButton alloc] initWithFrame:CGRectMake(23, [UIScreen mainScreen].bounds.size.height - 125, 553/2, 36)];
    startButton.backgroundColor = [UIColor clearColor];
    [startButton setBackgroundImage:RYCImageNamed(@"start_select_num.png") forState:UIControlStateNormal];
    [startButton setBackgroundImage:RYCImageNamed(@"start_select_num_click.png") forState:UIControlStateHighlighted];
    [startButton addTarget:self action:@selector(startButttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    [startButton release];
}

- (void)selectButtonClick:(UIButton*)button
{
    [m_musicSelect play];
    m_musicSelect.numberOfLoops = 1;
    
    m_delegate.randomPickerView.delegate = self;
    if(m_LuckTypeButton == button)
    {
        m_randomPickType = 1;
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:LUCK_PLAY_TYPE];
        [m_delegate.randomPickerView setPickerNum:m_recoderType withMinNum:1 andMaxNum:4];
    }
    else if(m_LuckLotButton == button)
    {
        m_randomPickType = 2;
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:LUCK_LOT_TYPE];
        [m_delegate.randomPickerView setPickerNum:m_recodeLotType withMinNum:1 andMaxNum:3];
    }
    else if(m_LuckNumberButton == button)
    {
        m_randomPickType = 3;
        [m_delegate.randomPickerView presentModalView:m_delegate.randomPickerView.view setPickerType:LUCK_NUM];
        [m_delegate.randomPickerView setPickerNum:m_recoderNum withMinNum:1 andMaxNum:10];
    }
}

#pragma mark RandomPickerDelegate
- (void)randomPickerView:(RandomPickerViewController*)randomPickerView selectRowNum:(int)num
{
    switch (m_randomPickType) {
        case 1:
            m_recoderType = num + 1;
            [m_LuckTypeButton setTitle:[randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
            [self refreshView];
            break;
        case 2:
            m_recodeLotType = num + 1;
            [m_LuckLotButton setTitle:[randomPickerView.pickerNumArray objectAtIndex:num] forState:UIControlStateNormal];
            break;
        case 3:
            m_recoderNum = num + 1;
            [m_LuckNumberButton setTitle:[NSString stringWithFormat:@"选%@", [randomPickerView.pickerNumArray objectAtIndex:num]] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


- (void)startButttonClick
{
    if(3 == m_recoderType)
    {
        NSLog(@"%@",m_nameField.text);
        if(KISEmptyOrEnter(m_nameField.text))
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入您的姓名！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
//        else if([[m_nameField.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "])//第一位不能为空格)
//        {
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"姓名前不能有空格！" withTitle:@"提示" buttonTitle:@"确定"];
//            return;
//        }
    }
    if(4 == m_recoderType)
    {
        if([m_dayButton.titleLabel.text isEqualToString:@"请输入您的生日"])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"请输入您的生日！" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    
    
    [m_musicOK play];
    m_musicOK.numberOfLoops = 1;
    
    [RuYiCaiLotDetail sharedObject].batchCode = @"";

    [self setHidesBottomBarWhenPushed:YES];
    LuckListViewController*  viewController = [[LuckListViewController alloc] init];
    
    switch (m_recodeLotType)
    {
        case 1:
            viewController.lotTitle = kLotTitleSSQ;
            viewController.lotNo = kLotNoSSQ;
            viewController.title = @"双色球投注列表";
            break;
        case 2:
            viewController.lotTitle = kLotTitleDLT; 
            viewController.lotNo = kLotNoDLT;
            viewController.title = @"大乐透投注列表";
            break;
        case 3:
            viewController.lotTitle = kLotTitleFC3D;
            viewController.lotNo = kLotNoFC3D;
            viewController.title = @"福彩3D投注列表";
            break;
        case 4:
            viewController.lotTitle = kLotTitleSSC;
            viewController.lotNo = kLotNoSSC;
            viewController.title = @"时时彩投注列表";
            break;
        case 5:
            viewController.lotTitle = kLotTitle11X5;
            viewController.lotNo = kLotNo115;
            viewController.title = @"江西11选5";
            break;
        case 6:
            viewController.lotTitle = kLotTitleGD115;
            viewController.lotNo = kLotNoGD115;
            viewController.title = @"广东11选5";
            break;
        case 7:
            viewController.lotTitle = kLotTitle11YDJ;
            viewController.lotNo = kLotNo11YDJ;
            viewController.title = @"十一运夺金";
            break;
        case 8:
            viewController.lotTitle = kLotTitleKLSF;
            viewController.lotNo = kLotNoKLSF;
            viewController.title = @"广东快乐十分";
            break;
        default:
            break;
    }
    viewController.m_randomNum = m_recoderNum;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark dateSelect
- (void)dateSelect:(id)sender
{
    [m_musicSelect play];
    m_musicSelect.numberOfLoops = 1;
    NSLog(@"%f",m_selectDateView.frame.origin.y);
    if(m_selectDateView.frame.origin.y == [UIScreen mainScreen].bounds.size.height)
    {
        [m_selectDateView presentModalView:1];
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.shengRiView.center;
        center.y -= 70;
        self.shengRiView.center = center;
        [UIView commitAnimations];
    }
}

#pragma mark datePickView delegate
- (void)randomPickerView:(DatePickView*)randomPickerView selectDate:(NSDate*)selectDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];//location设置为中国
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString* newDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: selectDate]];
    NSLog(@"newDate:%@", newDate);
    [dateFormatter release];
    
    [m_dayButton setTitle:newDate forState:UIControlStateNormal];
    m_dayButton.titleLabel.textColor = [ColorUtils parseColorFromRGB:@"#ff6f1e"];
   
    [UIView beginAnimations:@"movement" context:nil]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    CGPoint center = self.shengRiView.center;
    center.y += 70;
    self.shengRiView.center = center;
    [UIView commitAnimations];
    
}

- (void)cancelPickView:(DatePickView*)randomPickerView
{
    [UIView beginAnimations:@"movement" context:nil]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    CGPoint center = self.shengRiView.center;
    center.y += 70;
    self.shengRiView.center = center;
    [UIView commitAnimations];
}

#pragma mark  textField delagate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(m_nameField == textField)
    {
        [m_nameField resignFirstResponder];
        
        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.nameView.center;
        center.y += 70;
        self.nameView.center = center;
        [UIView commitAnimations];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(m_nameField == textField)
    {
        [m_musicSelect play];
        m_musicSelect.numberOfLoops = 1;

        [UIView beginAnimations:@"movement" context:nil]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.nameView.center;
        center.y -= 70;
        self.nameView.center = center;
        [UIView commitAnimations];

    }
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
