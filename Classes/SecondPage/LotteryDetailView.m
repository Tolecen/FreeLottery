//
//  LotteryDetailView.m
//  RuYiCai
//
//  Created by  on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LotteryDetailView.h"
#import "RYCImageNamed.h"

#define BgImageTag  (22)

@implementation LotteryDetailView

@synthesize jiangXiang = m_jiangXiang;
@synthesize winZhuShu = m_winZhuShu;
@synthesize winAccountStr = m_winAccountStr;

- (void)dealloc
{
    [m_jiangXiangLabel release];
    [m_zhuShuLabel release];
    [m_winAccount release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView  *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 30)];
        oneImage.image = RYCImageNamed(@"hang_bgtiaocell.png");
        oneImage.tag = BgImageTag;
        [self addSubview:oneImage];
        [oneImage release];
        
        m_jiangXiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 0, 70, 30)];
        [m_jiangXiangLabel setFont:[UIFont systemFontOfSize:15]];
        m_jiangXiangLabel.textAlignment = UITextAlignmentCenter;
        [m_jiangXiangLabel setTextColor:[UIColor blackColor]];
        m_jiangXiangLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:m_jiangXiangLabel];
        
        m_zhuShuLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 110, 30)];
        [m_zhuShuLabel setFont:[UIFont systemFontOfSize:15]];
        m_zhuShuLabel.textAlignment = UITextAlignmentCenter;
        [m_zhuShuLabel setTextColor:[UIColor blackColor]];
        m_zhuShuLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:m_zhuShuLabel];
        
        m_winAccount = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 120, 30)];
        [m_winAccount setFont:[UIFont systemFontOfSize:15]];
        m_winAccount.textAlignment = UITextAlignmentCenter;
        [m_winAccount setTextColor:[UIColor blackColor]];
        m_winAccount.backgroundColor = [UIColor clearColor];
        [self addSubview:m_winAccount];
       }
    return self;
}

- (void)refeshView
{
    m_jiangXiangLabel.text = self.jiangXiang;
    m_zhuShuLabel.text = self.winZhuShu;
    m_winAccount.text = [NSString stringWithFormat:@"%d", [self.winAccountStr intValue]/100];
}

- (void)setJXNewFrame
{
    if ([[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation]==UIInterfaceOrientationLandscapeRight)//倒屏
    {
        [self viewWithTag:BgImageTag].frame = CGRectMake(5, 0, 470, 30);
        m_jiangXiangLabel.frame = CGRectMake(9, 0, 110, 30);
        m_zhuShuLabel.frame = CGRectMake(120, 0, 175, 30);
        m_winAccount.frame = CGRectMake(295, 0, 175, 30);
    }
    else
    {
        [self viewWithTag:BgImageTag].frame = CGRectMake(5, 0, 310, 30);
        m_jiangXiangLabel.frame = CGRectMake(9, 0, 70, 30);
        m_zhuShuLabel.frame = CGRectMake(80, 0, 110, 30);
        m_winAccount.frame = CGRectMake(190, 0, 120, 30);
    }
}

@end
