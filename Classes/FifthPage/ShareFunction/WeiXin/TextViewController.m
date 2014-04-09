//
//  TextViewController.mm
//  MicroMessenger
//
//  Created by Tencent on 12-3-21.
//  Copyright 2012 Tecent. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "TextViewController.h"
#import "UINavigationBarCustomBg.h"
#import "AdaptationUtils.h"

#define TABLECELLLEFTMARGIN 10
#define TABLECELLRIGHTMARGIN 5
#define COLLABELWIDTH  50
#define COLLABELWIDTHLONG  80
#define TEXTFIELDWIDTH   (screenRect.size.width - TEXTFIELDLEFTMARGIN * 2)
#define TEXTFIELDLEFTMARGIN 10
#define TEXTFIELDTOPMARGIN 54
#define TEXTFIELDHEIGHT 148
#define TEXTVIEWCONTENTINSETTOP 6
#define TEXTVIEWCONTENTINSETBOTTOM 6

@implementation TextViewController
@synthesize m_delegate;
@synthesize m_nsLastText;
@synthesize titleStr = m_titleStr;

-(void) updateWordCount:(int)wordCount {
	m_wordCountLabel.text = [NSString stringWithFormat:@"%d", wordCount];
}
- (void)textViewDidChange:(UITextView *)textView {
	int words = [textView.text length];
	[self updateWordCount:words];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//	if ([text isEqualToString:@"\n"]) {
//			[self.navigationController popViewControllerAnimated:YES];
//		return NO;
//	}
	return YES;
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

-(void)initTextView{
	CGRect screenRect = [UIScreen mainScreen].bounds;
	CGRect descriptionRect = CGRectMake(TEXTFIELDLEFTMARGIN, TEXTFIELDTOPMARGIN, TEXTFIELDWIDTH, TEXTFIELDHEIGHT);
    
    
	m_textView = [[[UITextView alloc]initWithFrame:descriptionRect] autorelease];
	//m_textView.borderStyle = UITextBorderStyleRoundedRect;
	m_textView.layer.cornerRadius = 5.0;
	m_textView.clipsToBounds = YES;
    m_textView.text = m_nsLastText;
	m_textView.font = [UIFont systemFontOfSize:16];
	m_textView.textAlignment = UITextAlignmentLeft;
	descriptionRect.size.height = m_textView.contentSize.height;
    m_textView.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        m_textView.frame = CGRectMake(TEXTFIELDLEFTMARGIN, TEXTFIELDTOPMARGIN+20, TEXTFIELDWIDTH, TEXTFIELDHEIGHT);
    }else
    {
        m_textView.frame = descriptionRect;
    }
    
	m_textView.contentOffset = CGPointMake(0, 10);
	m_textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	m_textView.autocorrectionType = UITextAutocorrectionTypeYes;
	m_textView.scrollEnabled = YES;
	m_textView.scrollsToTop = YES;
	m_textView.showsHorizontalScrollIndicator = YES;
	m_textView.enablesReturnKeyAutomatically = YES; 	

    
    
	UIEdgeInsets edgeInset = UIEdgeInsetsMake(-TEXTVIEWCONTENTINSETTOP,0,-TEXTVIEWCONTENTINSETBOTTOM,0);
	UIEdgeInsets edgeInsetIndicator = UIEdgeInsetsMake(-TEXTVIEWCONTENTINSETTOP,0,-TEXTVIEWCONTENTINSETBOTTOM,0);
	m_textView.contentInset = edgeInset;
	m_textView.scrollIndicatorInsets = edgeInsetIndicator;
	[m_textView setReturnKeyType: UIReturnKeyDefault];
	m_textView.delegate = self;
    
	[self.view addSubview:m_textView];
	[m_textView becomeFirstResponder];
	
	CGRect wordCountRect = CGRectMake(descriptionRect.origin.x+descriptionRect.size.width-70, descriptionRect.origin.y+descriptionRect.size.height-32, 64, 32);
	m_wordCountLabel = [[[UILabel alloc] initWithFrame:wordCountRect] autorelease];
	m_wordCountLabel.backgroundColor = [UIColor clearColor];
	m_wordCountLabel.textAlignment = UITextAlignmentRight;
	[self.view addSubview:m_wordCountLabel];
	[self textViewDidChange:m_textView];
}

- (void)OnDone {
    
    if ([WXApi isWXAppInstalled])
    {
         [m_delegate onCompleteText:m_textView.text];
    }else
    {
        UIAlertView *installAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请安装微信客户端" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [installAlertView show];
        [installAlertView release];
    }
}

- (void)OnBack {
    [m_delegate onCancelText];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
	self.title = @"编辑消息";
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setHidden:YES];
    UIImageView    *navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_bg.png"]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statView];
        [statView release];
        navImageView.frame = CGRectMake(0, 20, 320, 44);
    }else
    {
       navImageView.frame = CGRectMake(0, 0, 320, 44);
    }
    
    [self.view addSubview:navImageView];
    [navImageView release];
//	[self.navigationController.navigationBar setBackground];
	[self initTextView];
    UILabel *titleLable = [[[UILabel alloc] init] autorelease];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        titleLable.frame = CGRectMake(110, 28, 120, 30);
    }else
    {
        titleLable.frame = CGRectMake(110, 8, 120, 30);
    }
    
//    titleLable.font = [UIFont systemFontOfSize:18];
     titleLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    if (self.titleStr)
    {
        titleLable.text = self.titleStr;
    }else
    {
        titleLable.text = @"微信分享";
    }
    
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLable];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        backBtn.frame = CGRectMake(10, 28, 52, 30);
    }else
    {
        backBtn.frame = CGRectMake(10, 8, 52, 30);
    }
    
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_triangle_c_normal.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        doneBtn.frame = CGRectMake(320-62+3, 28, 52, 30);
    }else
    {
        doneBtn.frame = CGRectMake(320-62+3, 8, 52, 30);
    }
    
    [doneBtn setBackgroundImage:[UIImage imageNamed:@"item_bar_right_button_normal.png"] forState:UIControlStateNormal];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [doneBtn addTarget:self action:@selector(OnDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    
//    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(OnBack) andAutoPopView:NO];
//    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(OnDone) andTitle:@"完成"];
}

- (void)dealloc {
    self.m_nsLastText = nil;
    [m_titleStr release];
    [super dealloc];
}


@end
