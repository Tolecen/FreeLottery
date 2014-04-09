//
//  PickBallViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickBallViewController.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

@implementation PickBallViewController

@synthesize ballState = m_ballState;
@synthesize m_selectBallCount;
@synthesize isHasYiLuo;

- (void)dealloc
{
    [m_ballState release], m_ballState = nil;
	[m_lBallCount release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    labelCount = 0;
    m_LViewFrame = 0;
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)createBallArray:(int)num withPerLine:(int)perLine startValue:(int)start selectBallCount:(int)count
{
    m_numPerLine = perLine;
    m_startValue = start;
	m_selectBallCount = count;
	m_ballState = [[NSMutableArray alloc] init];
    
	for (int i = 0; i < num; i++)
    {
		float lineIndex = i / m_numPerLine;
		UIButton *button = [[UIButton alloc] init];
        if(BIG_BALL == m_ballSize)
        {
            if(isHasYiLuo)
            {
                button.frame = CGRectMake(kBallRectWidth * (i % m_numPerLine) + (i % m_numPerLine) * kBallVerticalSpacing ,
                                          lineIndex * (kBallRectWidth + kBallLineSpacing) + kYiLuoHeight * lineIndex,
                                          kBallWidth, kBallHeight);
            }
            else
            {
                button.frame = CGRectMake(kBallRectWidth * (i % m_numPerLine) + (i % m_numPerLine) * kBallVerticalSpacing,
                                          lineIndex * (kBallRectWidth + kBallLineSpacing),
                                          kBallWidth, kBallHeight);
            }
        }
        else
        {
            button.frame = CGRectMake(kSmallBallRectWidth * (i % m_numPerLine) + (i % m_numPerLine) * kBallVerticalSpacing,
                                      lineIndex * (kSmallBallRectWidth + kBallLineSpacing),
                                      kSmallBallWidth, kSmallBallHeight);
        }
        
        [button setTitle:[NSString stringWithFormat:@"%d", (i + m_startValue)] forState:UIControlStateNormal];
		[button setBackgroundImage:RYCImageNamed(@"ball_c_gray.png") forState:UIControlStateNormal];
        if (m_ballType == RED_BALL){
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont boldSystemFontOfSize:kBallTitleFontSize];
		[button addTarget:self action:@selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = kBallTagBase + i;
		[self.view addSubview:button];
        [button release];
		
		NSString *value = @"0";
		[m_ballState addObject:value];  //0表示未选中，1表示选中
	}
	m_ballNum = num;
}

- (void)createBallArrayDxds:(int)num withPerLine:(int)perLine startValue:(int)start selectBallCount:(int)count
{
	m_numPerLine = perLine;
	m_startValue = start;
	m_selectBallCount = count;
	m_ballState = [[NSMutableArray alloc] init];
	
	NSArray *array = [[NSArray alloc]initWithObjects:@"大",@"小",@"单",@"双",nil];
	
	for(int i = 0; i< num; i++)
	{
		float lineIndex = i / m_numPerLine;
		UIButton *buttons = [[UIButton alloc]initWithFrame:CGRectMake((kBallRectWidth + kBallVerticalSpacing) * (i % m_numPerLine),
                                                                      lineIndex * (kBallRectWidth + kYiLuoHeight),
                                                                      kBallWidth, kBallHeight)];
		[buttons setBackgroundImage:RYCImageNamed(@"ball_c_gray.png") forState:UIControlStateNormal];
		[buttons setTitle:[NSString stringWithFormat:@"%@",[array objectAtIndex:i]] forState:UIControlStateNormal];
		buttons.titleLabel.font = [UIFont boldSystemFontOfSize:kBallTitleFontSize];
        if (m_ballType == RED_BALL)
        {
            [buttons setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [buttons setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        //		[buttons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	    [buttons addTarget:self action:@selector(pressedBallButton:) forControlEvents:UIControlEventTouchUpInside];
		buttons.tag = kBallTagBase + i;
		[self.view addSubview:buttons];
        [buttons release];
		
		NSString *value = @"0";
		[m_ballState addObject:value];  //0表示未选中，1表示选中
	}
	[array release];
	m_ballNum = num;
}

- (int)ballNumPerLine
{
    return m_numPerLine;
}

- (void)randomBall:(int)maxNum
{
	m_randomNumber = 0;
	int randomNum;
	m_selectNum = 0;
	
	for (int i = 0; i < [m_ballState count]; i++)
    {
		UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + i)];
		[tmp setBackgroundImage:RYCImageNamed(@"ball_c_gray.png") forState:UIControlStateNormal];
        //        [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (m_ballType == RED_BALL)
        {
            [tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [tmp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
        tmp.titleLabel.font = [UIFont boldSystemFontOfSize:kBallTitleFontSize];
		[m_ballState replaceObjectAtIndex:i withObject:@"0"];
	}
	
	for (int i = 0; i < [m_ballState count]; i++)
    {
		UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + i)];
		if (tmp.tag == (kBallTagBase + i))
        {
            while (m_randomNumber < maxNum)
            {
                randomNum = arc4random() % m_ballNum;
                while ([m_ballState objectAtIndex:randomNum] != @"1")
                {
                    m_randomNumber += 1;
                    
                    UIButton *tmp = (UIButton *)[self.view viewWithTag:kBallTagBase + randomNum];
                    if (m_ballType == RED_BALL)
                    {
                        [tmp setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
                    }
                    else
                    {
                        [tmp setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
                    }
                    [tmp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [m_ballState replaceObjectAtIndex:randomNum withObject:@"1"];
                    m_selectNum += 1;
                }
            }
        }
    }
}

- (void)pressedBallButton:(UIButton*)ballButton
{
    NSLog(@"按钮被电击了－－－");
	for (int i = 0; i < [m_ballState count]; i++)
    {
		if (ballButton.tag == (kBallTagBase + i))
        {
			if ([m_ballState objectAtIndex:i] == @"0")
            {
				if (m_selectNum < m_selectMaxNum)
                {
                    UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + i)];
                    if (m_ballType == RED_BALL)
                    {
                        [tmp setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
                        [tmp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [tmp setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
                        [tmp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    [m_ballState replaceObjectAtIndex:i withObject:@"1"];
                    m_selectNum += 1;
                    
                    NSMutableDictionary* myDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
                    [myDictionary setObject:self forKey:@"ballView"];
                    [myDictionary setObject:[NSNumber numberWithInt:i] forKey:@"ballIndex"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:myDictionary];
                }
            }
            else
            {
				UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + i)];
				[tmp setBackgroundImage:RYCImageNamed(@"ball_c_gray.png") forState:UIControlStateNormal];
                
                if (m_ballType == RED_BALL)
                {
                    [tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }else{
                    [tmp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
                //                [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
				
                [m_ballState replaceObjectAtIndex:i withObject:@"0"];
				m_selectNum -= 1;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
            }
			
			[m_lBallCount removeFromSuperview];
			[m_lBallCount release];
            if(m_LViewFrame == RIGHT_FRAME)
                m_lBallCount = [[UIView alloc]initWithFrame:CGRectMake(160, -20, 130, 20)];
            else
                m_lBallCount = [[UIView alloc]initWithFrame:CGRectMake(10, -20, 130, 20)];
			m_lBallCount.alpha = 0.7;
			[m_lBallCount setBackgroundColor:[UIColor darkGrayColor]];
			[m_lBallCount.layer setCornerRadius:8];
			m_lBallCount.clipsToBounds = YES;
			[self.view addSubview:m_lBallCount];
			UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,3,125,15)];
			[mLabel setBackgroundColor:[UIColor clearColor]];
			[mLabel setTextColor:[UIColor whiteColor]];
			mLabel.textAlignment = UITextAlignmentCenter;
			mLabel.font = [UIFont systemFontOfSize:12];
			if (m_selectMaxNum - m_selectNum == 0)
			{
				mLabel.text = [NSString stringWithFormat:@"该区不能再选了"];
			}
			else if (m_selectBallCount - m_selectNum >= 0)
			{
				mLabel.text = [NSString stringWithFormat:@"至少还要选 %d 个球",m_selectBallCount - m_selectNum];
			}
			else
			{
				mLabel.text = [NSString stringWithFormat:@"最多还可以选 %d 个球",m_selectMaxNum - m_selectNum];
			}
			[m_lBallCount addSubview:mLabel];
            [mLabel release];
			[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];//取消该方法的调用
			[self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
		}
	}
}

- (void)hideView
{
	m_lBallCount.hidden = YES;
}

- (void)setBallType:(int)type
{
	m_ballType = type;
}

- (void)setBallSize:(int)size
{
    m_ballSize = size;
}

- (void)setLViewFrame:(int)frame
{
    m_LViewFrame = frame;
}

- (void)setSelectMaxNum:(int)num
{
	m_selectMaxNum = num;
}

- (int)getSelectNum
{
	return m_selectNum;
}

- (void)clearBallState
{
    NSTrace();
    for (int i = 0; i < [m_ballState count]; i++)
    {
        [m_ballState replaceObjectAtIndex:i withObject:@"0"];
        UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + i)];
        [tmp setBackgroundImage:RYCImageNamed(@"ball_c_gray.png") forState:UIControlStateNormal];
        if (m_ballType == RED_BALL){
            [tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [tmp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }
    
    if (m_selectNum > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBallState" object:nil];
        m_selectNum = 0;
    }
}

- (NSMutableArray*)selectedBallsArray
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < [m_ballState count]; i++)
    {
        if (@"1" == [m_ballState objectAtIndex:i])
            [ret addObject:[NSNumber numberWithInt:(i + m_startValue)]];
    }
    return ret;
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

- (BOOL)stateForIndex:(int)index
{
    if (@"1" == [m_ballState objectAtIndex:index])
        return YES;
    else
        return NO;
}

- (void)selectBallForStateArr:(NSArray*)stateArray
{
    m_selectNum = 0;
    for (int i = 0; i < [stateArray count]; i++)
    {
        if([[stateArray objectAtIndex:i] isEqualToString:@"1"])
        {
            if([[m_ballState objectAtIndex:i] isEqualToString:@"0"])
            {
                [m_ballState replaceObjectAtIndex:i withObject:@"1"];
                UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + i)];
                if (m_ballType == RED_BALL)
                {
                    [tmp setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
                    [tmp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                else
                {
                    [tmp setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
                    [tmp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
        }
        else
        {
            if([[m_ballState objectAtIndex:i] isEqualToString:@"1"])
            {
                [m_ballState replaceObjectAtIndex:i withObject:@"0"];
                UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + i)];
                [tmp setBackgroundImage:RYCImageNamed(@"ball_c_gray.png") forState:UIControlStateNormal];
                
                if (m_ballType == RED_BALL)
                {
                    [tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }else{
                    [tmp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
                
            }
        }
    }
}

- (void)resetStateForIndex:(int)index
{
    m_selectNum--;
    [m_ballState replaceObjectAtIndex:index withObject:@"0"];
    UIButton *tmp = (UIButton *)[self.view viewWithTag:(kBallTagBase + index)];
    [tmp setBackgroundImage:RYCImageNamed(@"ball_c_gray.png") forState:UIControlStateNormal];
    
    if (m_ballType == RED_BALL)
    {
        [tmp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
        [tmp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
	[m_lBallCount removeFromSuperview];
	[m_lBallCount release];
    if(m_LViewFrame == RIGHT_FRAME)
        m_lBallCount = [[UIView alloc]initWithFrame:CGRectMake(160, -20, 130, 20)];
    else
        m_lBallCount = [[UIView alloc]initWithFrame:CGRectMake(10, -20, 130, 20)];
	m_lBallCount.alpha = 0.7;
	[m_lBallCount setBackgroundColor:[UIColor darkGrayColor]];
	[m_lBallCount.layer setCornerRadius:8];
	m_lBallCount.clipsToBounds = YES;
	[self.view addSubview:m_lBallCount];
	UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,3,125,15)];
	[mLabel setBackgroundColor:[UIColor clearColor]];
	[mLabel setTextColor:[UIColor whiteColor]];
	mLabel.textAlignment = UITextAlignmentCenter;
	mLabel.font = [UIFont systemFontOfSize:12];
	if (m_selectMaxNum - m_selectNum == 0)
	{
		mLabel.text = [NSString stringWithFormat:@"该区不能再选了"];
	}
	else if (m_selectBallCount - m_selectNum >= 0)
	{
		mLabel.text = [NSString stringWithFormat:@"至少还要选 %d 个球",m_selectBallCount - m_selectNum];
	}
	else
	{
		mLabel.text = [NSString stringWithFormat:@"最多还可以选 %d 个球",m_selectMaxNum - m_selectNum];
	}
	[m_lBallCount addSubview:mLabel];
	[mLabel release];
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];
	[self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
}

@end
