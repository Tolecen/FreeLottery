    //
//  ZCJinQiuCaiView.m
//  RuYiCai
//
//  Created by haojie on 11-12-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZCJinQiuCaiView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "ColorUtils.h"

#define kZCJinQinCellBallTagBase (100)

@implementation ZCJinQiuCaiView

@synthesize indexLabel = m_indexLabel;
@synthesize hTeamLabel = m_hTeamLabel;
@synthesize vTeamLabel = m_vTeamLabel;
@synthesize fenxiButton = m_fenxiButton;
@synthesize index = m_index;
@synthesize hTeam = m_hTeam;
@synthesize vTeam = m_vTeam;
@synthesize avgOdds = m_avgOdds;
@synthesize cDate = m_cDate;


- (void)dealloc
{
	[m_indexLabel release];
	[m_hTeamLabel release];
	[m_vTeamLabel release];
	[m_ballState release], m_ballState = nil;
	[m_fenxiButton release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {		
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 304, 84)];
        bgImageView.image = RYCImageNamed(@"zcbg_c_sf.png");
        [self addSubview:bgImageView];
        [bgImageView release];
        
		m_indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, 15, 15)];
        m_indexLabel.textAlignment = UITextAlignmentLeft;
        m_indexLabel.backgroundColor = [UIColor clearColor];
        m_indexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_indexLabel];
        
        m_indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 9, 18, 30)];
        m_indexLabel.textAlignment = UITextAlignmentLeft;
        m_indexLabel.backgroundColor = [UIColor clearColor];
        m_indexLabel.textColor = [ColorUtils parseColorFromRGB:@"#787878"];
        m_indexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_indexLabel];
        
        m_hTeamLabel = [[UILabel alloc] initWithFrame:CGRectMake(35+20,9, 70, 30)];
        m_hTeamLabel.textAlignment = UITextAlignmentLeft;
        m_hTeamLabel.textColor = [UIColor blackColor];
        m_hTeamLabel.backgroundColor = [UIColor clearColor];
        m_hTeamLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_hTeamLabel];
        
		UILabel* vLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 9, 30, 30)];
        vLabel.textAlignment = UITextAlignmentLeft;
        vLabel.text = @"VS";
		vLabel.textColor = [UIColor redColor];
        vLabel.backgroundColor = [UIColor clearColor];
        vLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:vLabel];
        [vLabel release];
		
        m_vTeamLabel = [[UILabel alloc] initWithFrame:CGRectMake(240-20, 9, 70, 30)];
        m_vTeamLabel.textAlignment = UITextAlignmentLeft;
        m_vTeamLabel.textColor = [UIColor blackColor];
        m_vTeamLabel.backgroundColor = [UIColor clearColor];
        m_vTeamLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_vTeamLabel];
		
		m_ballState =[[NSMutableArray alloc] init];
		for (int i = 0; i < 4; i++) 
		{
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10 + 30*i,40, 25, 25)];
			[button setBackgroundImage:RYCImageNamed(@"zc_normal.png") forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			if(i == 3)
			{
				[button setTitle:[NSString stringWithFormat:@"%d+", i] forState:UIControlStateNormal];
			}
			else
			{
				[button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
			}		
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
			[button addTarget:self action:@selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];
			button.tag = kZCJinQinCellBallTagBase + i;
			[self addSubview:button];
			[button release];
			
			NSString *value = @"0";
			[m_ballState addObject:value];  //0表示未选中，1表示选中
		}
		for (int i = 0; i < 4; i++) 
		{
			UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150+20 + 30*i, 40, 25, 25)];
			[button setBackgroundImage:RYCImageNamed(@"zc_normal.png") forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			if(i == 3)
			{
				[button setTitle:[NSString stringWithFormat:@"%d+", i] forState:UIControlStateNormal];
			}
			else
			{
				[button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
			}
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
			[button addTarget:self action:@selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];
			button.tag = kZCJinQinCellBallTagBase + 4 + i;
			[self addSubview:button];
			[button release];
			
			NSString *value = @"0";
			[m_ballState addObject:value];  //0表示未选中，1表示选中
		}
		m_fenxiButton = [[UIButton alloc] initWithFrame:CGRectMake(279, 10, 22, 22)];
		[m_fenxiButton setBackgroundImage:[UIImage imageNamed:@"analysisbg.png"] forState:UIControlStateNormal];  
        [m_fenxiButton addTarget:self action: @selector(pressedFenxiButton) forControlEvents:UIControlEventTouchUpInside];  
		[self addSubview:m_fenxiButton];
	}
    return self;
}

- (void)refreshView
{
    NSTrace();
	m_indexLabel.text = self.index;
	m_hTeamLabel.text = self.hTeam;
	m_vTeamLabel.text = self.vTeam; 
}

- (void)clearBallState
{
    for (int i = 0; i < [m_ballState count]; i++)
    {
        [m_ballState replaceObjectAtIndex:i withObject:@"0"];
        UIButton *tmp = (UIButton *)[self viewWithTag:(kZCJinQinCellBallTagBase + i)];
        [tmp setBackgroundImage:RYCImageNamed(@"zc_normal.png") forState:UIControlStateNormal];
        [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (NSArray*)selectedIndexArray
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < [m_ballState count]; i++)
    {
        if (@"1" == [m_ballState objectAtIndex:i])
            [ret addObject:[NSNumber numberWithInt:i]];
    }
    return ret;
}

- (NSArray*)selectedFirstLineArray
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 4; i++)
    {
        if (@"1" == [m_ballState objectAtIndex:i])
		{
			[ret addObject:[NSString stringWithFormat:@"%d",i]];
		}
    }
    return ret;
}

- (NSArray*)selectedSecondLineArray
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:1];
    for (int i = 4; i < 8; i++)
    {
        if (@"1" == [m_ballState objectAtIndex:i])
		{
			[ret addObject:[NSString stringWithFormat:@"%d",i - 4]];
		}
    }
    return ret;
}

- (void)pressedBallButton:(UIButton*)ballButton
{
	for (int i = 0; i < [m_ballState count]; i++) 
    {
		if (ballButton.tag == (kZCJinQinCellBallTagBase + i)) 
        {
			if ([m_ballState objectAtIndex:i] == @"0")
            {
				UIButton *tmp = (UIButton *)[self viewWithTag:(kZCJinQinCellBallTagBase + i)];
				[tmp setBackgroundImage:RYCImageNamed(@"zc_click.png") forState:UIControlStateNormal];
                [tmp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				[m_ballState replaceObjectAtIndex:i withObject:@"1"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
            }
            else
            {
				UIButton *tmp = (UIButton *)[self viewWithTag:(kZCJinQinCellBallTagBase + i)];
				[tmp setBackgroundImage:RYCImageNamed(@"zc_normal.png") forState:UIControlStateNormal];
                [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				[m_ballState replaceObjectAtIndex:i withObject:@"0"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
            }
		}
	}
}

- (void)pressedFenxiButton
{
	NSString *title = [NSString stringWithFormat:@"%@ VS %@",self.hTeam,self.vTeam];
	NSArray  *tempArray = [self.avgOdds componentsSeparatedByString:@"|"];
	NSString *message = [NSString stringWithFormat:@"平均指数\n %@\n %@\n %@\n 时间：%@",
						 [tempArray objectAtIndex:0],[tempArray objectAtIndex:1],[tempArray objectAtIndex:2],
						 self.cDate];
    [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:title buttonTitle:@"确定"];
}


@end
