//
//  AnimationTabView.m
//  RuYiCai
//
//  Created by  on 12-5-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnimationTabView.h"
#import "RYCImageNamed.h"

@implementation AnimationTabView

@synthesize backImage_white = m_backImage_white;
@synthesize selectButtonTag = m_selectButtonTag;
@synthesize buttonNameArray = m_buttonNameArray;

- (void)dealloc
{
    [m_backImage_white release];
    [m_buttonNameArray release], m_buttonNameArray = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *bgBig = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
        bgBig.image = RYCImageNamed(@"zc_backgroundbig.png");
        [self addSubview:bgBig];
        [bgBig release];
        
        UIImageView *bgSmall = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 31)];
        bgSmall.image = RYCImageNamed(@"zc_backgroungsmall.png");
        [self addSubview:bgSmall];
        [bgSmall release];
        
        m_buttonNameArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        m_selectButtonTag = 0;
    }
    return self;
}

- (void)setMainButton
{
    NSInteger buttonWid = 310/[self.buttonNameArray count];
    m_backImage_white = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, buttonWid, 30)];
    m_backImage_white.image = RYCImageNamed(@"zc_buttonselect.png");
    //m_backImage_white.alpha = 0.8f;
    [self addSubview:m_backImage_white];
    
    for(int i = 0; i < [self.buttonNameArray count]; i++)
    {
        NSInteger buttonWid = 310/[self.buttonNameArray count];
        UIButton* buttonList = [[UIButton alloc] initWithFrame:CGRectMake(6 + buttonWid * i, 6, buttonWid, 30)];
        [buttonList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonList setTitle:[self.buttonNameArray objectAtIndex:i] forState:UIControlStateNormal];
        // [buttonList setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [buttonList setTag:i];
        buttonList.titleLabel.font = [UIFont systemFontOfSize:16];
        [buttonList addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonList];
        [buttonList release];
    }
}

- (void)changeImage
{
    [UIView beginAnimations:@"movement" context:nil]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.5f];
	[UIView setAnimationRepeatCount:1];
	[UIView setAnimationRepeatAutoreverses:NO];
	//CGPoint center = self.backImage_white.center;	
    NSInteger buttonWid = 310/[self.buttonNameArray count];
    self.backImage_white.frame = CGRectMake((buttonWid * m_selectButtonTag + 6), 6, buttonWid, 30);
    
    [UIView commitAnimations];
}

- (void)buttonSelect:(id)sender
{
    int buttontag = [sender tag];
    if(m_selectButtonTag == buttontag)
    {
        return;
    }
    else
    {
        m_selectButtonTag = buttontag;
        [self changeImage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabButtonChanged" object:nil];
    }
}

@end
