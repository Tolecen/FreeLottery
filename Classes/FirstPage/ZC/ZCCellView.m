//
//  ZCCellView.m
//  RuYiCai
//
//  Created by haojie on 11-12-2.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZCCellView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "ColorUtils.h"

#define kZCCellViewBallTagBase (100)

@implementation ZCCellView

@synthesize indexLabel = m_indexLabel;
@synthesize hTeamLabel = m_hTeamLabel;
@synthesize vTeamLabel = m_vTeamLabel;
@synthesize sortLabel = m_sortLabel;
@synthesize thereButton = m_thereButton;
@synthesize oneButton = m_oneButton;
@synthesize zeroButton = m_zeroButton;
@synthesize fenxiButton = m_fenxiButton;
@synthesize index = m_index;
@synthesize hTeam = m_hTeam;
@synthesize vTeam = m_vTeam;
@synthesize avgOdds = m_avgOdds;
@synthesize cDate = m_cDate;
@synthesize m_sort;
@synthesize m_isPress;

- (void)dealloc 
{
	[m_indexLabel release];
	[m_hTeamLabel release];
	[m_vTeamLabel release];
	[m_sortLabel release];
	[m_thereButton release];
	[m_oneButton release];
	[m_zeroButton release];
	[m_fenxiButton release];
	[m_ballState release], m_ballState = nil;
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {
		m_isPress = YES;
		
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 304, 84)];
        bgImageView.image = RYCImageNamed(@"zcbg_c_sf.png");
        [self addSubview:bgImageView];
        [bgImageView release];
        
        m_indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 18, 30)];
        m_indexLabel.textAlignment = UITextAlignmentLeft;
        m_indexLabel.backgroundColor = [UIColor clearColor];
        m_indexLabel.textColor = [ColorUtils parseColorFromRGB:@"#787878"];
        m_indexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_indexLabel];
        
        m_hTeamLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,9, 70, 30)];
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
		
        m_vTeamLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 9, 70, 30)];
        m_vTeamLabel.textAlignment = UITextAlignmentLeft;
        m_vTeamLabel.textColor = [UIColor blackColor];
        m_vTeamLabel.backgroundColor = [UIColor clearColor];
        m_vTeamLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_vTeamLabel];
		
		m_sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 15)];
        m_sortLabel.textAlignment = UITextAlignmentCenter;
        m_sortLabel.textColor = [UIColor blackColor];
        m_sortLabel.backgroundColor = [UIColor clearColor];
        m_sortLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:m_sortLabel];
       // 156 + 51*rowIndex, lineIndex*31 + 10, 46, 25)];

		m_thereButton = [[UIButton alloc] initWithFrame:CGRectMake(31, 50, 74, 28)];
        //[m_thereButton setTitle:@"3" forState:UIControlStateNormal];  
		[m_thereButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_thereButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];  
        [m_thereButton setBackgroundImage:[UIImage imageNamed:@"zc_c_normal.png"] forState:UIControlStateNormal];  
        [m_thereButton addTarget:self action: @selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];  
        m_thereButton.tag = kZCCellViewBallTagBase;
		[self addSubview:m_thereButton];	
		
		m_oneButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 50, 74, 28)];
        //[m_oneButton setTitle:@"1" forState:UIControlStateNormal];  
		[m_oneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_oneButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];  
        [m_oneButton setBackgroundImage:[UIImage imageNamed:@"zc_c_normal.png"] forState:UIControlStateNormal];  
        [m_oneButton addTarget:self action: @selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];  
        m_oneButton.tag = kZCCellViewBallTagBase + 1;
		[self addSubview:m_oneButton];	
		
		m_zeroButton = [[UIButton alloc] initWithFrame:CGRectMake(199, 50, 74, 28)];
        //[m_zeroButton setTitle:@"0" forState:UIControlStateNormal]; 
		[m_zeroButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_zeroButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];  
        [m_zeroButton setBackgroundImage:[UIImage imageNamed:@"zc_c_normal.png"] forState:UIControlStateNormal];  
        [m_zeroButton addTarget:self action: @selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];  
        m_zeroButton.tag = kZCCellViewBallTagBase + 2;
		[self addSubview:m_zeroButton];	
		
//		m_fenxiButton = [[UIButton alloc] initWithFrame:CGRectMake(279, 5, 25, 25)];  
//		[m_fenxiButton setBackgroundImage:[UIImage imageNamed:@"btn_fenxi.png"] forState:UIControlStateNormal];  
//        [m_fenxiButton addTarget:self action: @selector(pressedFenxiButton) forControlEvents:UIControlEventTouchUpInside];  
//		[self addSubview:m_fenxiButton];
		
		m_ballState =[[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",nil];
	}
    return self;
}

- (void)refreshView
{
	m_indexLabel.text = self.index;
	m_hTeamLabel.text = self.hTeam;
	m_vTeamLabel.text = self.vTeam; 
	NSLog(@"sfc sort %@",self.m_sort);
	if(self.m_sort.length != 0)
	{
		NSArray *tempArray = [self.m_sort componentsSeparatedByString:@"|"];
	    m_sortLabel.text = [NSString stringWithFormat:@"%@---%@",[tempArray objectAtIndex:0],[tempArray objectAtIndex:1]];
	}
    if(self.avgOdds.length != 0)
    {
        NSArray  *tempArray = [self.avgOdds componentsSeparatedByString:@"|"];
        [m_thereButton setTitle:[NSString stringWithFormat:@"%@",[tempArray objectAtIndex:0]] forState:UIControlStateNormal];
        [m_oneButton setTitle:[NSString stringWithFormat:@"%@",[tempArray objectAtIndex:1]] forState:UIControlStateNormal];
        [m_zeroButton setTitle:[NSString stringWithFormat:@"%@",[tempArray objectAtIndex:2]] forState:UIControlStateNormal];
    }
}

- (void)pressedBallButton:(UIButton*)ballButton
{
	for (int i = 0; i < [m_ballState count]; i++) 
    {
		if (ballButton.tag == (kZCCellViewBallTagBase + i)) 
        {
			if ([m_ballState objectAtIndex:i] == @"0")
            {
				if(m_isPress)
				{
					UIButton *tmp = (UIButton *)[self viewWithTag:(kZCCellViewBallTagBase + i)];
					[tmp setBackgroundImage:RYCImageNamed(@"zc_c_click.png") forState:UIControlStateNormal];
					[m_ballState replaceObjectAtIndex:i withObject:@"1"];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
				}
            }
            else
            {
				UIButton *tmp = (UIButton *)[self viewWithTag:(kZCCellViewBallTagBase + i)];
				[tmp setBackgroundImage:RYCImageNamed(@"zc_c_normal.png") forState:UIControlStateNormal];
				[m_ballState replaceObjectAtIndex:i withObject:@"0"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
            }
			
		}
	}
}

- (void)clearBallState
{
    for (int i = 0; i < [m_ballState count]; i++)
    {
        [m_ballState replaceObjectAtIndex:i withObject:@"0"];
        UIButton *tmp = (UIButton *)[self viewWithTag:(kZCCellViewBallTagBase + i)];
        [tmp setBackgroundImage:RYCImageNamed(@"zc_c_normal.png") forState:UIControlStateNormal];
    }
}

- (BOOL)haveBallPress
{
	for(int i = 0; i < 3; i++)
	{
		if(@"1" == [m_ballState objectAtIndex:i])
			return YES;
	}
	return NO;
}

- (NSMutableArray*)selectedBallsArray
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < [m_ballState count]; i++)
    {
        if (@"1" == [m_ballState objectAtIndex:i])
		{
			switch (i)
			{
				case 0:
					[ret addObject:[NSNumber numberWithInt:3]];
					break;
				case 1:
					[ret addObject:[NSNumber numberWithInt:1]];
					break;
                case 2:
					[ret addObject:[NSNumber numberWithInt:0]];
					break;
				default:
					break;
			}
		}
    }
    return ret;
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
