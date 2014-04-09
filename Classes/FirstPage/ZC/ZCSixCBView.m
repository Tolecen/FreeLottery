    //
//  ZCSixCBView.m
//  RuYiCai
//
//  Created by haojie on 11-12-5.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZCSixCBView.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"
#import "ColorUtils.h"


#define kSixCBBallTagBase (100)

@implementation ZCSixCBView

@synthesize indexLabel = m_indexLabel;
@synthesize hTeamLabel = m_hTeamLabel;
@synthesize vTeamLabel = m_vTeamLabel;
@synthesize sortLabelOne = m_sortLabelOne;
@synthesize sortLabelTwo = m_sortLabelTwo;
@synthesize index = m_index;
@synthesize hTeam = m_hTeam;
@synthesize vTeam = m_vTeam;
@synthesize avgOdds = m_avgOdds;
@synthesize m_sort;

- (void)dealloc 
{
	[m_indexLabel release];
	[m_hTeamLabel release];
	[m_vTeamLabel release];
	[m_sortLabelOne release];
	[m_sortLabelTwo release];
	[m_ballState release], m_ballState = nil;
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {		
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 304, 94)];
        bgImageView.image = RYCImageNamed(@"zcbg_c_sf.png");
        [self addSubview:bgImageView];
        [bgImageView release];
        
        m_indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 12, 18, 30)];
        m_indexLabel.textAlignment = UITextAlignmentLeft;
        m_indexLabel.backgroundColor = [UIColor clearColor];
        m_indexLabel.textColor = [ColorUtils parseColorFromRGB:@"#787878"];
        m_indexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_indexLabel];
        
        m_hTeamLabel = [[UILabel alloc] initWithFrame:CGRectMake(35+20,14, 70, 30)];
        m_hTeamLabel.textAlignment = UITextAlignmentLeft;
        m_hTeamLabel.textColor = [UIColor blackColor];
        m_hTeamLabel.backgroundColor = [UIColor clearColor];
        m_hTeamLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_hTeamLabel];
        
		UILabel* vLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 14, 30, 30)];
        vLabel.textAlignment = UITextAlignmentLeft;
        vLabel.text = @"VS";
		vLabel.textColor = [UIColor redColor];
        vLabel.backgroundColor = [UIColor clearColor];
        vLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:vLabel];
        [vLabel release];
		
        m_vTeamLabel = [[UILabel alloc] initWithFrame:CGRectMake(240-20, 14, 70, 30)];
        m_vTeamLabel.textAlignment = UITextAlignmentLeft;
        m_vTeamLabel.textColor = [UIColor blackColor];
        m_vTeamLabel.backgroundColor = [UIColor clearColor];
        m_vTeamLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_vTeamLabel];
        
		m_sortLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 50, 15)];
		m_sortLabelOne.textAlignment = UITextAlignmentLeft;
		m_sortLabelOne.textColor = [UIColor blackColor];
		m_sortLabelOne.font = [UIFont systemFontOfSize:12];
		m_sortLabelOne.backgroundColor = [UIColor clearColor];
		[self addSubview:m_sortLabelOne];
		
		UILabel* bLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 45, 30, 15)];
        bLabel.textAlignment = UITextAlignmentLeft;
        bLabel.text = @"半场";
		bLabel.textColor = [UIColor blueColor];
        bLabel.backgroundColor = [UIColor clearColor];
        bLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:bLabel];
        [bLabel release];		
		
		m_sortLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(60, 70, 50, 15)];
		m_sortLabelTwo.textAlignment = UITextAlignmentLeft;
		m_sortLabelTwo.textColor = [UIColor blackColor];
		m_sortLabelTwo.font = [UIFont systemFontOfSize:12];
		m_sortLabelTwo.backgroundColor = [UIColor clearColor];
		[self addSubview:m_sortLabelTwo];		
		
		UILabel* qLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 75, 30, 15)];
        qLabel.textAlignment = UITextAlignmentLeft;
        qLabel.text = @"全场";
		qLabel.textColor = [UIColor blueColor];
        qLabel.backgroundColor = [UIColor clearColor];
        qLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:qLabel];
        [qLabel release];	
        
        m_ballState =[[NSMutableArray alloc] init];
	}
    return self;
}

- (void)refreshView
{
	m_indexLabel.text = self.index;
	m_hTeamLabel.text = self.hTeam;
	m_vTeamLabel.text = self.vTeam; 
	NSLog(@"six sort %@",m_sort);
	if(self.m_sort.length != 0)
	{
		NSArray *tempArray = [self.m_sort componentsSeparatedByString:@"|"];
	    m_sortLabelOne.text = [NSString stringWithFormat:@"[%@]",[tempArray objectAtIndex:0]];
		m_sortLabelTwo.text = [NSString stringWithFormat:@"[%@]",[tempArray objectAtIndex:1]];
	}
    
    //m_ballState =[[NSMutableArray alloc] init];
    
    NSArray  *tempArray;
    if(self.avgOdds.length != 0)
        tempArray = [self.avgOdds componentsSeparatedByString:@"|"];
    else
        tempArray = [NSArray arrayWithObjects:@"",@"",@"", nil];
  
    for (int i = 0; i < 6; i++) 
    {
        int lineIndex = i / 3;
        int rowIndex = i % 3;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(150 + 51*rowIndex, lineIndex*31 + 9+30, 40, 22)];
        [button setBackgroundImage:RYCImageNamed(@"zc_normal.png") forState:UIControlStateNormal];
        if(0 == i || 3 == i)
        {
            [button setTitle:[NSString stringWithFormat:@"%@",[tempArray objectAtIndex:0]] forState:UIControlStateNormal];
        }
        else if(1 == i || 4 == i)
        {
            [button setTitle:[NSString stringWithFormat:@"%@",[tempArray objectAtIndex:1]] forState:UIControlStateNormal];
        }
        else
        {
           [button setTitle:[NSString stringWithFormat:@"%@",[tempArray objectAtIndex:2]] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [button addTarget:self action:@selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kSixCBBallTagBase + i;
        [self addSubview:button];
        [button release];
        
        NSString *value = @"0";
        [m_ballState addObject:value];  //0表示未选中，1表示选中
    }
}

- (void)clearBallState
{
    for (int i = 0; i < [m_ballState count]; i++)
    {
        [m_ballState replaceObjectAtIndex:i withObject:@"0"];
        UIButton *tmp = (UIButton *)[self viewWithTag:(kSixCBBallTagBase + i)];
        [tmp setBackgroundImage:RYCImageNamed(@"zc_normal.png") forState:UIControlStateNormal];
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
    for (int i = 0; i < 3; i++)
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

- (NSArray*)selectedSecondLineArray
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:1];
    for (int i = 3; i < 6; i++)
    {
        if (@"1" == [m_ballState objectAtIndex:i])
		{
			switch (i)
			{
				case 3:
					[ret addObject:[NSNumber numberWithInt:3]];
					break;
				case 4:
					[ret addObject:[NSNumber numberWithInt:1]];
					break;
				case 5:
					[ret addObject:[NSNumber numberWithInt:0]];
					break;
				default:
					break;
			}
		}
    }
    return ret;
}

- (void)pressedBallButton:(UIButton*)ballButton
{
	for (int i = 0; i < [m_ballState count]; i++) 
    {
		if (ballButton.tag == (kSixCBBallTagBase + i)) 
        {
			if ([m_ballState objectAtIndex:i] == @"0")
            {
				UIButton *tmp = (UIButton *)[self viewWithTag:(kSixCBBallTagBase + i)];
				[tmp setBackgroundImage:RYCImageNamed(@"zc_click.png") forState:UIControlStateNormal];
				[m_ballState replaceObjectAtIndex:i withObject:@"1"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
            }
            else
            {
				UIButton *tmp = (UIButton *)[self viewWithTag:(kSixCBBallTagBase + i)];
				[tmp setBackgroundImage:RYCImageNamed(@"zc_normal.png") forState:UIControlStateNormal];
				[m_ballState replaceObjectAtIndex:i withObject:@"0"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
            }
		}
	}
}

@end
