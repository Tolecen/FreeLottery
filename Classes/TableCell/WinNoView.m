//
//  WinNoView.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WinNoView.h"
#import "RuYiCaiCommon.h"
#import "RYCImageNamed.h"

#define kRandomBallWidth   (25)



@implementation WinNoView

- (void)dealloc 
{
    for (int i = 0; i < [m_buttonsArray count]; i++)
    {
        UIButton* btn = [m_buttonsArray objectAtIndex:i];
        [btn release], btn = nil;
    }
    [m_buttonsArray release], m_buttonsArray = nil;
	[winNumLabel release];
    [tryCodeLabel release];
    [tryCodeBatchCodeLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{    
    self = [super initWithFrame:frame];
    if (self) 
    {
        m_buttonsArray = [[NSMutableArray alloc] initWithCapacity:10];
		
		winNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		winNumLabel.textAlignment = UITextAlignmentRight;
		winNumLabel.backgroundColor = [UIColor clearColor];
		winNumLabel.font = [UIFont systemFontOfSize:18];
		[self addSubview:winNumLabel];
        
        tryCodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tryCodeLabel.backgroundColor = [UIColor clearColor];
        tryCodeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:tryCodeLabel];
        
        tryCodeBatchCodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tryCodeBatchCodeLabel.backgroundColor = [UIColor clearColor];
        tryCodeBatchCodeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:tryCodeBatchCodeLabel];
    }
    return self;
}

- (void)showFC3DWinNo:(NSString*)winNo ofType:(NSString*)type withTryCode:(NSString*)tryCode withTryCodeBatchCode:(NSString*)batchCode
{
    for (int i = 0; i < [m_buttonsArray count]; i++)
    {
        UIButton* btn = [m_buttonsArray objectAtIndex:i];
        [btn removeFromSuperview];
        [btn release];
    }
    [m_buttonsArray removeAllObjects];
    [tryCodeBatchCodeLabel removeFromSuperview];
    [winNumLabel removeFromSuperview];
    [tryCodeLabel removeFromSuperview];
	
    if (winNo == (NSString*)[NSNull null])
        return;
    
    int  nomaleRandomWidth;
    if ([type isEqualToString:kLotTitlePK10]) {
        nomaleRandomWidth = 21;
    }else
    {
        nomaleRandomWidth = 25;
    }
    
    int nRedBall = 0;
    int nBlueBall = 0;
    if ([type isEqualToString:kLotTitleFC3D])
    {
        nRedBall = 3;
        nBlueBall = 0;
    }
    
   	    CGRect buttonFrame = CGRectZero;
    for (int i = 0; i < (nRedBall + nBlueBall); i++)
    {
        buttonFrame = CGRectMake(i * (nomaleRandomWidth + 2),
                                 0,
                                 nomaleRandomWidth,
                                 nomaleRandomWidth);
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];

            if (winNo.length >= (i * 2 + 2))
            {
                if([type isEqualToString:kLotTitleFC3D])
                {
                    NSString* titleStr = [winNo substringWithRange:NSMakeRange(i * 2, 2)];
                    [button setTitle:[NSString stringWithFormat:@"%d", [titleStr intValue]] forState:UIControlStateNormal];
                }
                else
                {
                    [button setTitle:[winNo substringWithRange:NSMakeRange(i * 2, 2)] forState:UIControlStateNormal];
                }
            }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setUserInteractionEnabled:NO];
        
        if (i < nRedBall)
            [button setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
        
        
        [self addSubview:button];
        [m_buttonsArray addObject:button];
        //        [button release];
        if([type isEqualToString:kLotTitleFC3D] && ![tryCode isEqualToString:@""]&& ![batchCode isEqualToString:@""])
        {
            NSString* tryStr = @"";
            for (int i = 0; i < tryCode.length/2; i++)
            {
                if(i != tryCode.length/2 - 1)
                    tryStr = [tryStr stringByAppendingFormat:@"%d,", [[tryCode substringWithRange:NSMakeRange(i * 2, 2)] intValue]];
                else
                    tryStr = [tryStr stringByAppendingFormat:@"%d", [[tryCode substringWithRange:NSMakeRange(i * 2, 2)] intValue]];
            }
            CGSize str1Size = [tryCode sizeWithFont:[UIFont systemFontOfSize:13]];
            tryCodeLabel.frame = CGRectMake((nomaleRandomWidth + 1) * (nRedBall + nBlueBall) + 5, nomaleRandomWidth/2, str1Size.width + 35, nomaleRandomWidth/2);
            tryCodeLabel.text = [NSString stringWithFormat:@"试机号:%@", tryStr];
            tryCodeLabel.textColor = [UIColor brownColor];
            [self addSubview:tryCodeLabel];
            
            tryCodeBatchCodeLabel.frame = CGRectMake((nomaleRandomWidth + 1) * (nRedBall + nBlueBall) + 5, 0, str1Size.width + 35+50, nomaleRandomWidth/2);
            tryCodeBatchCodeLabel.text = [NSString stringWithFormat:@"试机号期号:%@", batchCode];
            tryCodeBatchCodeLabel.textColor = [UIColor brownColor];
            [self addSubview:tryCodeBatchCodeLabel];
            
            
            self.frame = CGRectMake(0, 0, (nomaleRandomWidth + 1) * (nRedBall + nBlueBall) + str1Size.width + 35, nomaleRandomWidth);
        }
        else
        {
            self.frame = CGRectMake(0, 0, (nomaleRandomWidth + 1) * (nRedBall + nBlueBall), nomaleRandomWidth);
        }
    }
}
- (void)showWinNo:(NSString*)winNo ofType:(NSString*)type withTryCode:(NSString*)tryCode
{
    for (int i = 0; i < [m_buttonsArray count]; i++)
    {
        UIButton* btn = [m_buttonsArray objectAtIndex:i];
        [btn removeFromSuperview];
        [btn release];
    }
    [m_buttonsArray removeAllObjects];
    [tryCodeBatchCodeLabel removeFromSuperview];
    [winNumLabel removeFromSuperview];
    [tryCodeLabel removeFromSuperview];
	
    if (winNo == (NSString*)[NSNull null])
        return;
    
    
    int  nomaleRandomWidth;
    if ([type isEqualToString:kLotTitlePK10]) {
        nomaleRandomWidth = 21;
    }else
    {
        nomaleRandomWidth = 25;
    }
    
    int nRedBall = 0;
    int nBlueBall = 0;
    if ([type isEqualToString:kLotTitleSSC])
	{
		[self showSSCWinNo:winNo];
        return;
	}else if ([type isEqualToString:kLotTitleJXSSC])
	{
		[self showSSCWinNo:winNo];
        return;
	}
    else if ([type isEqualToString:kLotTitleSSQ])
    {
        nRedBall = 6;
        nBlueBall = 1;
    }
    else if ([type isEqualToString:kLotTitleFC3D])
    {
        nRedBall = 3;
        nBlueBall = 0;
    }
    else if ([type isEqualToString:kLotTitlePK10])
    {
        nRedBall = 10;
        nBlueBall = 0;
    }
    else if ([type isEqualToString:kLotTitleDLT])
    {
        nRedBall = 5;
        nBlueBall = 2;
    }
    else if ([type isEqualToString:kLotTitleQLC])
    {
        nRedBall = 7;
        nBlueBall = 1;
    }
    else if ([type isEqualToString:kLotTitlePLS])
    {
        nRedBall = 3;
        nBlueBall = 0;
    }
	else if ([type isEqualToString:kLotTitle11X5] || [type isEqualToString:kLotTitle11YDJ]
             || [type isEqualToString:kLotTitleCQ11X5] || [type isEqualToString:kLotTitleGD115])
    {
        nRedBall = 5;
        nBlueBall = 0;
    }
	else if ([type isEqualToString:kLotTitleSFC] || [type isEqualToString:kLotTitleRX9]
			|| [type isEqualToString:kLotTitleJQC] || [type isEqualToString:kLotTitle6CB])
	{
		CGSize str1Size = [winNo sizeWithFont:[UIFont systemFontOfSize:18]];
		winNumLabel.frame = CGRectMake(0, 0, str1Size.width, 30);
		winNumLabel.text = winNo;
        winNumLabel.textColor = [UIColor brownColor];
		[self addSubview:winNumLabel];
		self.frame = winNumLabel.frame;
	}
    else if ([type isEqualToString:kLotTitlePL5])
	{
		nRedBall = 5;
		nBlueBall = 0;
	}
	else if ([type isEqualToString:kLotTitleQXC])
	{
		nRedBall = 7;
		nBlueBall = 0;
	}
    else if([type isEqualToString:kLotTitleKLSF])
    {
        nRedBall = 0;
		nBlueBall = 8;
    }else if([type isEqualToString:kLotTitleCQSF])
    {
        nRedBall = 0;
		nBlueBall = 8;
    }else if ([type isEqualToString:kLotTitleNMK3])
    {
        nRedBall = 3;
        nBlueBall = 0;
    }
    
    CGRect buttonFrame = CGRectZero;
    for (int i = 0; i < (nRedBall + nBlueBall); i++)
    {
        buttonFrame = CGRectMake(i * (nomaleRandomWidth + 2), 
                                 0, 
                                 nomaleRandomWidth, 
                                 nomaleRandomWidth);
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        if ([type isEqualToString:kLotTitleDLT])
        {
            if (0 == i)
            {
                if (winNo.length >= 2)
                    [button setTitle:[winNo substringWithRange:NSMakeRange(0, 2)] forState:UIControlStateNormal];
            }
            else
            {
                if (winNo.length >= (i * 3 + 2))
                    [button setTitle:[winNo substringWithRange:NSMakeRange(i * 3, 2)] forState:UIControlStateNormal];
            }
        }
        else if ([type isEqualToString:kLotTitlePLS] || [type isEqualToString:kLotTitleSSC] 
				 || [type isEqualToString:kLotTitlePL5] || [type isEqualToString:kLotTitleQXC])
        {
            if (winNo.length >= (i + 1))
                [button setTitle:[winNo substringWithRange:NSMakeRange(i, 1)] forState:UIControlStateNormal];
        }
        else
        {
            if (winNo.length >= (i * 2 + 2))
            {
                if([type isEqualToString:kLotTitleFC3D])
                {
                    NSString* titleStr = [winNo substringWithRange:NSMakeRange(i * 2, 2)];
                    [button setTitle:[NSString stringWithFormat:@"%d", [titleStr intValue]] forState:UIControlStateNormal];
                }
                else
                {
                   [button setTitle:[winNo substringWithRange:NSMakeRange(i * 2, 2)] forState:UIControlStateNormal];
                }
            }
		}
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setUserInteractionEnabled:NO];
        
        if (i < nRedBall)
            [button setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
        else
        {
            if([type isEqualToString:kLotTitleKLSF]||[type isEqualToString:kLotTitleCQSF])
            {
                if (winNo.length >= (i * 2 + 2))
                {
                    NSString* titleStr = [winNo substringWithRange:NSMakeRange(i * 2, 2)];

                    if([titleStr isEqualToString:@"19"] || [titleStr isEqualToString:@"20"])
                       [button setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
                    else
                        [button setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
                }
            }
            else
            {
                [button setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
            }
        }
        
        [self addSubview:button];
        [m_buttonsArray addObject:button];
//        [button release];
        if([type isEqualToString:kLotTitleFC3D] && ![tryCode isEqualToString:@""])
        {
            NSString* tryStr = @"";
            for (int i = 0; i < tryCode.length/2; i++)
            {
                if(i != tryCode.length/2 - 1)
                   tryStr = [tryStr stringByAppendingFormat:@"%d,", [[tryCode substringWithRange:NSMakeRange(i * 2, 2)] intValue]];
                else
                   tryStr = [tryStr stringByAppendingFormat:@"%d", [[tryCode substringWithRange:NSMakeRange(i * 2, 2)] intValue]]; 
            }
            CGSize str1Size = [tryCode sizeWithFont:[UIFont systemFontOfSize:15]];
            tryCodeLabel.frame = CGRectMake((nomaleRandomWidth + 1) * (nRedBall + nBlueBall) + 5, 0, str1Size.width + 35, nomaleRandomWidth);
            tryCodeLabel.text = [NSString stringWithFormat:@"试机号:%@", tryStr];
            tryCodeLabel.textColor = [UIColor brownColor];
            [self addSubview:tryCodeLabel];

            self.frame = CGRectMake(0, 0, (nomaleRandomWidth + 1) * (nRedBall + nBlueBall) + str1Size.width + 35, nomaleRandomWidth);
        }else if ([type isEqualToString:kLotTitleNMK3] && ![tryCode isEqualToString:@""] && tryCode !=nil)
        {
            CGSize str1Size = [tryCode sizeWithFont:[UIFont systemFontOfSize:15]];
            tryCodeLabel.frame = CGRectMake((nomaleRandomWidth + 1) * (nRedBall + nBlueBall) + 5, 0, str1Size.width + 35, nomaleRandomWidth);
            tryCodeLabel.text = [NSString stringWithFormat:@"和值:%@", tryCode];
            tryCodeLabel.textColor = [UIColor brownColor];
            [self addSubview:tryCodeLabel];
            
            self.frame = CGRectMake(0, 0, (nomaleRandomWidth + 1) * (nRedBall + nBlueBall) + str1Size.width + 35, nomaleRandomWidth);
        }
        else
        {
            self.frame = CGRectMake(0, 0, (nomaleRandomWidth + 1) * (nRedBall + nBlueBall), nomaleRandomWidth);
        }
    }
}

- (void)showSSCWinNo:(NSString*)winNo
{
    int nRedBall = 6;
    
    CGRect buttonFrame = CGRectZero;
    NSString*  tempStr = @"";

    for (int i = 0; i < nRedBall; i++)
    {
        if(i == nRedBall - 1)
            buttonFrame = CGRectMake(i * (kRandomBallWidth + 3),
                                     0,
                                     70,
                                     kRandomBallWidth);
        else
            buttonFrame = CGRectMake(i * (kRandomBallWidth + 2),
                                 0,
                                 kRandomBallWidth,
                                 kRandomBallWidth);
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        if (winNo.length >= (i + 1) && i != nRedBall - 1)
            [button setTitle:[winNo substringWithRange:NSMakeRange(i, 1)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setUserInteractionEnabled:NO];
        
        if ((winNo.length >= (i + 1)) && (nRedBall - 3 == i  || nRedBall - 2 == i))
        {            
            if([[winNo substringWithRange:NSMakeRange(i, 1)] intValue] > 4)//大
                tempStr = [tempStr stringByAppendingString:@"大"];
            else
                tempStr = [tempStr stringByAppendingString:@"小"];
            if([[winNo substringWithRange:NSMakeRange(i, 1)] intValue] % 2)//单
                tempStr = [tempStr stringByAppendingString:@"单"];
            else
                tempStr = [tempStr stringByAppendingString:@"双"];
        }
        if (nRedBall - 1 == i)
        {
            [button setTitle:tempStr forState:UIControlStateNormal];
        }
        if (i < nRedBall - 1)
            [button setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
        else
            [button setBackgroundImage:RYCImageNamed(@"dxds_biao.png") forState:UIControlStateNormal];

        [self addSubview:button];
        [m_buttonsArray addObject:button];
        
        self.frame = CGRectMake(0, 0, (kRandomBallWidth + 1) * nRedBall + 48, kRandomBallWidth);
    }
}
@end
