//
//  RandomNumViewController.m
//  RuYiCai
//
//  Created by  on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RandomNumViewController.h"
#import "RYCImageNamed.h"

@implementation RandomNumViewController
@synthesize randomBall;
- (void)dealloc
{
    [numListView release];
    [numButton release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {	
        hiddenFrame = frame;
    }
    return self;
}

- (void)createNumBallList:(int)num withPerLine:(int)perLine startValue:(int)start  withFrame:(CGRect)newframe andBallType:(RandomBall)type 
//- (void)createNumBallList:(int)num withPerLine:(int)perLine startValue:(int)start  withFrame:(CGRect)newframe
{
    startNum = start;
    listFrame = newframe;
    numValue = start;
    
    numButton = [[UIButton alloc] initWithFrame:CGRectMake(197, 3, 49, 29)];
    [numButton setTitle:[NSString stringWithFormat:@"%d个", start] forState:UIControlStateNormal];
    [numButton setBackgroundColor:[UIColor clearColor]];
    [numButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    numButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
//    if (m_ballType == RED_BALL){
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    }else{
//        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    }

    NSString *backImgNormalNameStr;
    NSString *backImgClickNameStr;
    if (type == RANDOM_RED_BALL) {
        backImgNormalNameStr = @"random_num_red_normal.png";
        backImgClickNameStr = @"random_num_red_click.png";
    }else if (type == RANDOM_BLUE_BALL){
        backImgNormalNameStr = @"random_num_blue_normal.png";
        backImgClickNameStr = @"random_num_blue_click.png";
    }
    
    
    [numButton setBackgroundImage:RYCImageNamed(backImgNormalNameStr) forState:UIControlStateNormal];
    [numButton setBackgroundImage:RYCImageNamed(backImgClickNameStr) forState:UIControlStateHighlighted];
    [numButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:numButton];
    
    UIButton*  jixuan_button = [[UIButton alloc] initWithFrame:CGRectMake(247, 3, 69, 29)];
    [jixuan_button setTitle:@"机选号码" forState:UIControlStateNormal];
    [jixuan_button setBackgroundColor:[UIColor clearColor]];
    [jixuan_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    jixuan_button.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [jixuan_button setBackgroundImage:RYCImageNamed(@"random_text_button_normal.png") forState:UIControlStateNormal];
    [jixuan_button setBackgroundImage:RYCImageNamed(@"random_text_button_click.png") forState:UIControlStateHighlighted];
    [jixuan_button addTarget:self action:@selector(jiXuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:jixuan_button];
    [jixuan_button release];
    
    int     lineNum = num/perLine + (num%perLine == 0 ? 0 : 1);
    numListView = [[UIView alloc] initWithFrame:CGRectMake(5, 30, 310, lineNum * 40)];
    [numListView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView*  bg_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, numListView.frame.size.width, numListView.frame.size.height)];
    if (lineNum == 1) {
        bg_image.image = RYCImageNamed(@"randomnum1_c_bg.png");
        bg_image.frame = CGRectMake(0,0, numListView.frame.size.width, 45);
    }
    else if(lineNum == 2)
        bg_image.image = RYCImageNamed(@"randomnum_c_bg.png");
    else if(lineNum == 3)
    {
        bg_image.image = RYCImageNamed(@"randomnum_c_bg.png");
        bg_image.frame = CGRectMake(0, -5, numListView.frame.size.width, numListView.frame.size.height);
    }
    [numListView addSubview:bg_image];
    [bg_image release];
    [self addSubview:numListView];
    
    for (int i = 0; i < num; i++)
    {
        float lineIndex = i / perLine;
        CGRect ballFrame = CGRectMake(kNumButtonValue * (i % perLine) + (i % perLine) * kButtonVerticalSpacing + 10,
                                      lineIndex * (kNumButtonValue + kButtonLineSpacing) + 7,
                                      kNumButtonValue, kNumButtonValue);
        UIButton *button = [[UIButton alloc] initWithFrame:ballFrame];
//        [button setBackgroundImage:RYCImageNamed(@"num_bg.png") forState:UIControlStateNormal];
        [button setBackgroundImage:RYCImageNamed(@"tzy_jxxlk.png") forState:UIControlStateNormal];
        [button setBackgroundImage:RYCImageNamed(@"tzy_hov_jxxlk.png") forState:UIControlStateNormal];
		[button setTitle:[NSString stringWithFormat:@"%d", (i + start)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		[button addTarget:self action:@selector(pressedNumButton:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = kButtonTagBase + i;
		[numListView addSubview:button];
        [button release];
    }
    numListView.hidden = YES;
}

- (void)pressedNumButton:(id)sender
{
    UIButton *tmp = (UIButton *)sender;
    NSInteger tempIndex = tmp.tag - kButtonTagBase;
    numValue = tempIndex + startNum;

    NSMutableDictionary* myDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [myDictionary setObject:self forKey:@"numView"];
    [myDictionary setObject:[NSNumber numberWithInt:numValue] forKey:@"numValue"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"randomUpdateBallState" object:myDictionary];
    
    [numButton setTitle:[NSString stringWithFormat:@"%d个", numValue] forState:UIControlStateNormal];

    numListView.hidden = YES;
    self.frame = hiddenFrame;
}

- (void)jiXuanButtonClick:(id)sender
{
    NSMutableDictionary* myDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [myDictionary setObject:self forKey:@"numView"];
    [myDictionary setObject:[NSNumber numberWithInt:numValue] forKey:@"numValue"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"randomUpdateBallState" object:myDictionary];
    
    numListView.hidden = YES;
    self.frame = hiddenFrame;
}

- (void)numButtonClick:(id)sender
{
    if(numListView.hidden)
    {
        numListView.hidden = NO;
        self.frame = listFrame;
    }
    else
    {
        numListView.hidden = YES;
        self.frame = hiddenFrame;
    }
}
@end
