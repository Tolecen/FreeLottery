//
//  JC_TabView.m
//  RuYiCai
//
//  Created by ruyicai on 12-5-29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZC_TabView.h"
#import "RYCImageNamed.h"

#import "ZC_pickNumberViewController.h"

@interface ZC_TabView (internal)

-(void) buttonSelect:(id)sender;

@end

@implementation ZC_TabView

@synthesize selectButtonTag = m_selectButtonTag;
@synthesize presentViewController = m_presentViewController;
@synthesize backImage_white = m_backImage_white;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *bgBig = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        bgBig.image = RYCImageNamed(@"zc_backgroundbig.png");
        [self addSubview:bgBig];
        [bgBig release];
        
        UIImageView *bgSmall = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 31)];
        bgSmall.image = RYCImageNamed(@"zc_backgroungsmall.png");
        [self addSubview:bgSmall];
        [bgSmall release];
        
        m_backImage_white = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 77, 30)];
        m_backImage_white.image = RYCImageNamed(@"zc_buttonselect.png");
        //m_backImage_white.alpha = 0.8f;
        [self addSubview:m_backImage_white];
        
        m_sfc_button = [[UIButton alloc] initWithFrame:CGRectMake(6, 6, 77, 30)];
        [m_sfc_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_sfc_button setTitle:@"胜负彩" forState:UIControlStateNormal];
        //        [m_sfc_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [m_sfc_button setTag:0];
        [m_sfc_button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_sfc_button];
        
        m_jqc_button = [[UIButton alloc] initWithFrame:CGRectMake(6 + 77 * 2, 6, 77, 30)];
        [m_jqc_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_jqc_button setTitle:@"进球彩" forState:UIControlStateNormal];
        //        [m_sfc_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [m_jqc_button setTag:2];
        [m_jqc_button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_jqc_button];
        
        m_rjc_button = [[UIButton alloc] initWithFrame:CGRectMake(6 + 77, 6, 77, 30)];
        
        [m_rjc_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_rjc_button setTitle:@"任九场" forState:UIControlStateNormal];
        //        [m_sfc_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [m_rjc_button setTag:1];
        [m_rjc_button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_rjc_button];
        
        m_lcb_button = [[UIButton alloc] initWithFrame:CGRectMake(6 + 77 * 3, 6, 77, 30)];
        [m_lcb_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_lcb_button setTitle:@"六场半" forState:UIControlStateNormal];
        //        [m_sfc_button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [m_lcb_button setTag:3];
        [m_lcb_button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:m_lcb_button];
        
        m_delegate = (RuYiCaiAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc
{
    [m_sfc_button release];
    [m_rjc_button release];
    [m_jqc_button release];
    [m_lcb_button release];
    
    [m_backImage_white release];
    
    [super dealloc];
}


- (void) refreshView
{
    [self changeImage];
    
}

//-(void) changeImage
//{
//    [m_sfc_button setBackgroundImage:nil forState:UIControlStateNormal];
//    [m_jqc_button setBackgroundImage:nil forState:UIControlStateNormal];
//    [m_rjc_button setBackgroundImage:nil forState:UIControlStateNormal];
//    [m_lcb_button setBackgroundImage:nil forState:UIControlStateNormal];
//
//    if (m_selectButtonTag == 0)
//    {
//        [m_sfc_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateNormal];
//    }
//    else if(m_selectButtonTag == 1)
//    {
//        [m_jqc_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateNormal];
//    }
//    else if(m_selectButtonTag == 2)
//    {
//        [m_rjc_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateNormal];
//    }
//    else if(m_selectButtonTag == 3)
//    {
//        [m_lcb_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateNormal];
//    }
//
//    [m_sfc_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateHighlighted];
//    [m_jqc_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateHighlighted];
//    [m_rjc_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateHighlighted];
//    [m_lcb_button setBackgroundImage:RYCImageNamed(@"zc_buttonselect.png") forState:UIControlStateHighlighted];
//}

-(void) changeImage
{
    [UIView beginAnimations:@"movement" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
	//CGPoint center = self.backImage_white.center;
    
    self.backImage_white.frame = CGRectMake((77 * m_selectButtonTag + 6), 6, 77, 30);
    
    [UIView commitAnimations];
}

-(void) buttonSelect:(id)sender
{
    int buttontag = [sender tag];
    m_selectButtonTag = buttontag;
    int zcTag = IZCLotTag_SFC;
    if (m_selectButtonTag == 0)
    {
        zcTag = IZCLotTag_SFC;
    }
    else if(m_selectButtonTag == 1)
    {
        zcTag = IZCLotTag_RJC;
    }
    else if(m_selectButtonTag == 2)
    {
        zcTag = IZCLotTag_JQC;
    }
    else if(m_selectButtonTag == 3)
    {
        zcTag = IZCLotTag_LCB;
    }
    [self changeImage];
    m_presentViewController.ZCTag = zcTag;
    [m_presentViewController refreshBatchCode];
    
}
@end
