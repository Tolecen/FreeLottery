//
//  TrendView.m
//  RuYiCai
//
//  Created by  on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TrendView.h"
#import "RYCImageNamed.h"
#import "NSLog.h"
#import "RuYiCaiCommon.h"

#define ballHeigth (20)

#define radius 100

#define blueStartBallTag (1000)
#define redStartBallTag (10000)

#define kNMKS3Same   (3)//快三三个号码都一样
#define kNMKS1_2Same  (12)//第1位和第二位相同
#define kNMKS2_3Same  (23)//第2位与第3位相同
#define kNMKS1_3Same  (13)//第1位与第3位相同

@implementation TrendView

@synthesize    batchCodeArray = m_batchCodeArray;
@synthesize    winNoArray = m_winNoArray;
@synthesize    bluePointArray = m_bluePointArray;
@synthesize    tryCodeArray = m_tryCodeArray;
@synthesize    Hnumber;
@synthesize    Vnumber;
@synthesize    isRedView;
@synthesize    lotTitle = m_lotTitle;

- (void)dealloc
{
    [m_batchCodeArray release], m_batchCodeArray = nil;
    [m_winNoArray release], m_winNoArray = nil;
    [m_bluePointArray release], m_bluePointArray = nil;
    [m_tryCodeArray release], m_tryCodeArray = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        m_batchCodeArray = [[NSMutableArray alloc] initWithCapacity:1];
        m_winNoArray = [[NSMutableArray alloc] initWithCapacity:1];
        m_bluePointArray = [[NSMutableArray alloc] initWithCapacity:1];
        m_tryCodeArray = [[NSMutableArray alloc] initWithCapacity:1];
        isRedBallLine = YES;
        isRedView = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布
    
    CGContextDrawImage(context, rect, [[UIImage imageNamed:@"trend_bg.png"] CGImage]);
    
    //    CGContextSetRGBStrokeColor(context, 197.0/255.0, 178.0/255, 178.0/255, 1.0); //笔色
    CGContextSetRGBStrokeColor(context, 255.0/255.0, 255.0/255, 255.0/255, 1.0); //笔色
	CGContextSetLineWidth(context, 0.5); //线宽
    CGRect white;
    CGRect gray;
    CGRect pink;
    CGRect codeWhite;
    for(int k = 0; k <= Hnumber + 2; k++)
    {
        NSInteger MaxNum = (Vnumber < 21) ? 21 : Vnumber;
        for(int h = 0; h < MaxNum; h = h + 2)
        {
            if( k%2 == 0)
            {
                if(isRedView)
                    white = CGRectMake(winNoLabelWidth + batchCodeLabelWidth + ballHeigth * h ,ballHeigth * k, ballHeigth, ballHeigth);
                else
                    white = CGRectMake(ballHeigth * h ,ballHeigth * k, ballHeigth, ballHeigth);
                
                gray = CGRectMake(white.origin.x +ballHeigth ,ballHeigth * k, ballHeigth, ballHeigth);
                
            }
            else
            {
                if(isRedView)
                    gray = CGRectMake(winNoLabelWidth + batchCodeLabelWidth + ballHeigth * h ,ballHeigth * k, ballHeigth, ballHeigth);
                else
                    gray = CGRectMake(ballHeigth * h ,ballHeigth * k, ballHeigth, ballHeigth);
                
                white = CGRectMake(gray.origin.x +ballHeigth ,ballHeigth * k, ballHeigth, ballHeigth);
            }
            CGContextSetRGBFillColor(context, 215.0/255.0 , 215.0/255.0, 215.0/255.0, 1);
            CGContextAddRect(context,white);
            CGContextDrawPath(context,kCGPathFillStroke);
            
            CGContextSetRGBFillColor(context, 239.0/255.0 , 239/255.0, 239/255.0, 1);
            CGContextAddRect(context, gray);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        if(isRedView)//期号背景和开奖号码背景
        {
            if(k%2 == 0)
            {
                pink = CGRectMake(0 , ballHeigth * k, batchCodeLabelWidth, ballHeigth);
                
                CGContextSetRGBFillColor(context, 231.0/255.0, 227.0/255.0, 222.0/255.0, 1);
                CGContextAddRect(context,pink);
                CGContextDrawPath(context,kCGPathFillStroke);
                
                codeWhite = CGRectMake(batchCodeLabelWidth , ballHeigth * k, winNoLabelWidth, ballHeigth);
                CGContextSetRGBFillColor(context, 231.0/255.0, 227.0/255.0, 222.0/255.0, 1);//白色
                CGContextAddRect(context,codeWhite);
                CGContextDrawPath(context,kCGPathFillStroke);
            }
            else
            {
                codeWhite = CGRectMake(0 , ballHeigth * k, batchCodeLabelWidth, ballHeigth);
                CGContextSetRGBFillColor(context, 250.0/255.0, 234.0/255.0, 254.0/255.0, 1);//白色
                CGContextAddRect(context,codeWhite);
                CGContextDrawPath(context,kCGPathFillStroke);
                pink = CGRectMake(batchCodeLabelWidth , ballHeigth * k, winNoLabelWidth, ballHeigth);
                CGContextSetRGBFillColor(context, 250.0/255.0, 234.0/255.0, 254.0/255.0, 1);
                
                
                CGContextAddRect(context,pink);
                CGContextDrawPath(context,kCGPathFillStroke);
            }
        }
    }
    //划线
    //    for(int i = 0; i <= Vnumber; i++)
    //    {
    //        CGContextMoveToPoint(context, batchCodeLabelWidth+ winNoLabelWidth+ballHeigth*i, 0.0);
    //        CGContextAddLineToPoint(context, batchCodeLabelWidth+ winNoLabelWidth+ballHeigth*i, ballHeigth+Hnumber*ballHeigth);
    //        CGContextStrokePath(context);
    //    }
    //    for(int j = 0; j <= Hnumber; j++)
    //    {
    //        CGContextMoveToPoint(context, 0.0, ballHeigth+ballHeigth*j);
    //        CGContextAddLineToPoint(context, batchCodeLabelWidth+ winNoLabelWidth+Vnumber*ballHeigth, ballHeigth+ballHeigth*j);
    //        CGContextStrokePath(context);
    //    }
    if([self.lotTitle isEqualToString:kLotTitleFC3D])//开奖号码与试机号之间的分割线
    {
        CGContextMoveToPoint(context, batchCodeLabelWidth+ winNoLabelWidth/2, 0.0);
        CGContextAddLineToPoint(context, batchCodeLabelWidth+ winNoLabelWidth/2, 3 * ballHeigth+Hnumber*ballHeigth);
        CGContextStrokePath(context);
    }
    if([self.lotTitle isEqualToString:kLotTitleSSQ])//区域线
    {
        CGContextSetRGBStrokeColor(context, 204.0/255.0, 102.0/255.0, 0.0/255.0, 1.0); //笔色
        CGContextSetLineWidth(context, 1.0); //线宽
        for (int s = 1; s <= 3; s++)
        {
            CGContextMoveToPoint(context, batchCodeLabelWidth+ winNoLabelWidth+ballHeigth*11*s, 0.0);
            CGContextAddLineToPoint(context, batchCodeLabelWidth+ winNoLabelWidth+ballHeigth*11*s, ballHeigth+Hnumber*ballHeigth);
            CGContextStrokePath(context);
        }
    }
    if(0 != [m_bluePointArray count])//连球
    {
        CGContextSetRGBStrokeColor(context, 102.0/255.0, 102.0/255.0, 102.0/255.0, 1.0);
        CGContextSetLineWidth(context, 2.0);
        
        if(isRedBallLine)
        {
            for(int k = 0; k < weiShu; k++)
            {
                for(int j = 0; j < Hnumber-1; j++)
                {
                    float sx = [[m_bluePointArray objectAtIndex:(2*weiShu*j)+2*k] floatValue];
                    float sy = [[m_bluePointArray objectAtIndex:(2*weiShu*j+1)+2*k] floatValue];
                    float ex = [[m_bluePointArray objectAtIndex:(2*weiShu*(j+1))+2*k] floatValue];
                    float ey = [[m_bluePointArray objectAtIndex:(2*weiShu*(j+1)+1)+2*k] floatValue];
                    CGContextMoveToPoint(context, sx, sy);
                    CGContextAddLineToPoint(context, ex, ey);
                    CGContextStrokePath(context);
                    
                }
            }
        }
        else
        {
            for(int i = 0; i < [m_bluePointArray count]/2-1; i++)
            {
                float sx = [[m_bluePointArray objectAtIndex:2*i] floatValue];
                float sy = [[m_bluePointArray objectAtIndex:(2*i+1)] floatValue];
                float ex = [[m_bluePointArray objectAtIndex:(2*i+2)] floatValue];
                float ey = [[m_bluePointArray objectAtIndex:(2*i+3)] floatValue];
                CGContextMoveToPoint(context, sx, sy);
                CGContextAddLineToPoint(context, ex, ey);
                CGContextStrokePath(context);
            }
        }
    }
}

- (void)setBetCodeList
{
    UILabel *betLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, batchCodeLabelWidth, ballHeigth)];
    betLabel.text = @"开奖期号";
    betLabel.backgroundColor = [UIColor clearColor];
    betLabel.textColor = [UIColor whiteColor];
    betLabel.textAlignment = UITextAlignmentCenter;
    betLabel.font = [UIFont boldSystemFontOfSize:12];
    [self addSubview:betLabel];
    [betLabel release];
    
    for(int i = 0; i < Hnumber; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ballHeigth+ballHeigth*i, batchCodeLabelWidth, ballHeigth)];
        label.text = [self.batchCodeArray objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:label];
        [label release];
    }
}

- (void)setKLSFWinNoListView
{
    for(int j = 0; j < Hnumber; j++)
    {
        NSString*   blueWinNoString_one = @"";
        
        NSString*   redWinNoString_one = @"";
        NSInteger   redWinNo_one = 0;
        
        NSString*   redWinNoString_two = @"";
        NSInteger   redWinNo_two = 0;
        
        for (int i = 0; i < 8; i++)
        {
            NSString* winStr = [[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange(i * 2, 2)];
            if(i != 7)
            {
                if([winStr isEqualToString:@"19"] || [winStr isEqualToString:@"20"])
                {
                    if([redWinNoString_one isEqualToString:@""])
                    {
                        redWinNoString_one = [redWinNoString_one stringByAppendingFormat:@"%@,", winStr];
                        redWinNo_one = i + 1;
                    }
                    else
                    {
                        redWinNoString_two = [redWinNoString_two stringByAppendingFormat:@"%@,", winStr];
                        redWinNo_two = i + 1;
                    }
                    blueWinNoString_one = [blueWinNoString_one stringByAppendingString:@"     "];
                }
                else
                {
                    blueWinNoString_one = [blueWinNoString_one stringByAppendingFormat:@"%@,", winStr];
                }
            }
            else
            {
                if([winStr isEqualToString:@"19"] || [winStr isEqualToString:@"20"])
                {
                    if([redWinNoString_one isEqualToString:@""])
                    {
                        redWinNoString_one = [redWinNoString_one stringByAppendingFormat:@"%@", winStr];
                        redWinNo_one = i + 1;
                    }
                    else
                    {
                        redWinNoString_two = [redWinNoString_two stringByAppendingFormat:@"%@", winStr];
                        redWinNo_two = i + 1;
                    }
                }
                else
                    blueWinNoString_one = [blueWinNoString_one stringByAppendingFormat:@"%@", winStr];
            }
        }
        UILabel *blueWinLabel = [[UILabel alloc] initWithFrame:CGRectMake(batchCodeLabelWidth, ballHeigth + j * ballHeigth, winNoLabelWidth, ballHeigth)];
        blueWinLabel.backgroundColor = [UIColor clearColor];
        blueWinLabel.textColor = [UIColor colorWithRed:0/255.0 green:83/255.0 blue:176 alpha:1.0];
        blueWinLabel.textAlignment = UITextAlignmentLeft;
        blueWinLabel.font = [UIFont boldSystemFontOfSize:12];
        blueWinLabel.text = blueWinNoString_one;
        [self addSubview:blueWinLabel];
        
        CGSize redStrSize = [redWinNoString_one sizeWithFont:[UIFont systemFontOfSize:12]];
        
        if(redWinNo_one != 0)
        {
            float withX ;
            if(redWinNo_one == 8)
                withX = (redWinNo_one - 1) * redStrSize.width + 20;
            else
                withX = (redWinNo_one - 1) * redStrSize.width;
            
            UILabel *redWinLabel_one = [[UILabel alloc] initWithFrame:CGRectMake(batchCodeLabelWidth + withX, blueWinLabel.frame.origin.y, redStrSize.width, ballHeigth)];
            redWinLabel_one.backgroundColor = [UIColor clearColor];
            redWinLabel_one.textColor = [UIColor colorWithRed:170.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            redWinLabel_one.textAlignment = UITextAlignmentRight;
            redWinLabel_one.font = [UIFont boldSystemFontOfSize:12];
            redWinLabel_one.text = redWinNoString_one;
            [self addSubview:redWinLabel_one];
            [redWinLabel_one release];
        }
        if(redWinNo_two != 0)
        {
            UILabel *redWinLabel_two = [[UILabel alloc] initWithFrame:CGRectMake(batchCodeLabelWidth + (redWinNo_two - 1) * redStrSize.width, blueWinLabel.frame.origin.y, redStrSize.width, ballHeigth)];
            redWinLabel_two.backgroundColor = [UIColor clearColor];
            redWinLabel_two.textColor = [UIColor colorWithRed:170.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
            redWinLabel_two.textAlignment = UITextAlignmentLeft;
            redWinLabel_two.font = [UIFont boldSystemFontOfSize:12];
            redWinLabel_two.text = redWinNoString_two;
            [self addSubview:redWinLabel_two];
            [redWinLabel_two release];
        }
        [blueWinLabel release];
    }
}

- (void)setWinNoListView:(NSString*)type
{
    UILabel *betLabel = [[UILabel alloc] initWithFrame:CGRectMake(batchCodeLabelWidth, 0, winNoLabelWidth, ballHeigth)];
    if([type isEqualToString:kLotTitleFC3D])
        betLabel.text = @"开奖号码        试机号";
    else
        betLabel.text = @"开奖号码";
    betLabel.backgroundColor = [UIColor clearColor];
    betLabel.textColor = [UIColor whiteColor];
    betLabel.textAlignment = UITextAlignmentCenter;
    betLabel.font = [UIFont boldSystemFontOfSize:12];
    [self addSubview:betLabel];
    [betLabel release];
    
    if([type isEqualToString:kLotTitleKLSF]||[type isEqualToString:kLotTitleCQSF])
    {
        [self setKLSFWinNoListView];
        return;
    }
    
    for(int j = 0; j < Hnumber; j++)
    {
        NSString*   redWinNoString = @"";
        NSString*   blueWinNoString = @"";
        NSInteger   redWinCount = 0;
        NSInteger   blueWinCount = 0;
        NSInteger   earchNumWei = 0;
        NSInteger   earchNumLength = 0;
        
        if ([type isEqualToString:kLotTitleSSQ])
        {
            redWinCount = 6;
            blueWinCount = 1;
            earchNumWei = 2;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitleFC3D])
        {
            redWinCount = 3;
            earchNumWei = 2;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitleQLC])
        {
            redWinCount = 7;
            blueWinCount = 1;
            earchNumWei = 2;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitleDLT])
        {
            redWinCount = 5;
            blueWinCount = 2;
            earchNumWei = 3;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitlePLS])
        {
            redWinCount = 3;
            earchNumWei = 1;
            earchNumLength = 1;
        }
        else if([type isEqualToString:kLotTitlePL5])
        {
            redWinCount = 5;
            earchNumWei = 1;
            earchNumLength = 1;
        }
        else if([type isEqualToString:kLotTitleQXC])
        {
            redWinCount = 7;
            earchNumWei = 1;
            earchNumLength = 1;
        }
        else if([type isEqualToString:kLotTitle22_5])
        {
            redWinCount = 5;
            earchNumWei = 2;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitleSSC])
        {
            redWinCount = 5;
            earchNumWei = 1;
            earchNumLength = 1;
        }
        else if([type isEqualToString:kLotTitle11X5])
        {
            redWinCount = 5;
            earchNumWei = 2;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitleGD115])
        {
            redWinCount = 5;
            earchNumWei = 2;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitle11YDJ])
        {
            redWinCount = 5;
            earchNumWei = 2;
            earchNumLength = 2;
        }
        else if([type isEqualToString:kLotTitleCQ11X5])
        {
            redWinCount = 5;
            earchNumWei = 2;
            earchNumLength = 2;
        }else if ([self.lotTitle isEqualToString:kLotTitleNMK3])
        {
            redWinCount = 3;
            earchNumWei = 2;
            earchNumLength = 2;
            //redStartX = batchCodeLabelWidth + 45;
        }
        UILabel *blueWinLabel = [[UILabel alloc] init];
        blueWinLabel.backgroundColor = [UIColor clearColor];
        blueWinLabel.textColor = [UIColor colorWithRed:0/255.0 green:83/255.0 blue:176/255.0 alpha:1.0];
        blueWinLabel.textAlignment = UITextAlignmentLeft;
        blueWinLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:blueWinLabel];
        
        UILabel *redWinLabel = [[UILabel alloc] init];
        redWinLabel.backgroundColor = [UIColor clearColor];
        redWinLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        redWinLabel.textAlignment = UITextAlignmentCenter;
        redWinLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:redWinLabel];
        
        if([type isEqualToString:kLotTitleFC3D])//要放试机号
            redWinLabel.frame = CGRectMake(batchCodeLabelWidth, ballHeigth + j * ballHeigth, winNoLabelWidth/2, ballHeigth);
        else
            redWinLabel.frame = CGRectMake(batchCodeLabelWidth, ballHeigth + j * ballHeigth, winNoLabelWidth - 17 * blueWinCount, ballHeigth);
        
        blueWinLabel.frame = CGRectMake(redWinLabel.frame.origin.x + redWinLabel.frame.size.width, redWinLabel.frame.origin.y, winNoLabelWidth - redWinLabel.frame.size.width, ballHeigth);
        for (int i = 0; i < redWinCount; i++)
        {
            if(i != redWinCount - 1)
            {
                if([type isEqualToString:kLotTitleFC3D])//一位数表示
                    redWinNoString = [redWinNoString stringByAppendingFormat:@"%d,", [[[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange(i * earchNumWei, earchNumLength)] intValue]];
                else
                    redWinNoString = [redWinNoString stringByAppendingFormat:@"%@,", [[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange(i * earchNumWei, earchNumLength)]];
            }
            else
            {
                if([type isEqualToString:kLotTitleFC3D])//一位数表示
                    redWinNoString = [redWinNoString stringByAppendingFormat:@"%d", [[[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange(i * earchNumWei, earchNumLength)] intValue]];
                else
                    redWinNoString = [redWinNoString stringByAppendingFormat:@"%@", [[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange(i * earchNumWei, earchNumLength)]];
            }
        }
        for(int k = 0; k < blueWinCount; k++)
        {
            if([type isEqualToString:kLotTitleDLT])
            {
                if(k != blueWinCount - 1)
                    blueWinNoString = [blueWinNoString stringByAppendingFormat:@"%@,", [[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange([(NSString*)[self.winNoArray objectAtIndex:j] length] - (blueWinCount - k) * earchNumWei + 1, earchNumLength)]];
                else
                    blueWinNoString = [blueWinNoString stringByAppendingFormat:@"%@", [[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange([(NSString*)[self.winNoArray objectAtIndex:j] length] - (blueWinCount - k) * earchNumWei + 1, earchNumLength)]];
                //                NSLog(@"blue str %@", blueWinNoString);
            }
            else
            {
                if(k != blueWinCount - 1)
                    blueWinNoString = [blueWinNoString stringByAppendingFormat:@"%@,", [[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange([(NSString*)[self.winNoArray objectAtIndex:j] length] - (blueWinCount - k) * earchNumWei, earchNumLength)]];
                else
                    blueWinNoString = [blueWinNoString stringByAppendingFormat:@"%@", [[self.winNoArray objectAtIndex:j] substringWithRange:NSMakeRange([(NSString*)[self.winNoArray objectAtIndex:j] length] - (blueWinCount - k) * earchNumWei, earchNumLength)]];
            }
        }
        redWinLabel.text = redWinNoString;
        blueWinLabel.text = blueWinNoString;
        
        [redWinLabel release];
        [blueWinLabel release];
    }
}

- (void)setFC3DTryCode
{
    for(int j = 0; j < Hnumber; j++)
    {
        NSString* tryCodeStr = @"";
        if([[self.tryCodeArray objectAtIndex:j] length] == 6)
        {
            for (int i = 0; i < 3; i++)
            {
                if(i != 2)
                    tryCodeStr = [tryCodeStr stringByAppendingFormat:@"%d,", [[[self.tryCodeArray objectAtIndex:j] substringWithRange:NSMakeRange(i * 2, 2)] intValue]];
                else
                    tryCodeStr = [tryCodeStr stringByAppendingFormat:@"%d", [[[self.tryCodeArray objectAtIndex:j] substringWithRange:NSMakeRange(i * 2, 2)] intValue]];
            }
        }
        UILabel *tryCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(batchCodeLabelWidth + winNoLabelWidth/2, ballHeigth + j * ballHeigth, winNoLabelWidth/2, ballHeigth)];
        tryCodeLabel.text = tryCodeStr;
        tryCodeLabel.backgroundColor = [UIColor clearColor];
        tryCodeLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:80.0/255.0 blue:0.0 alpha:1.0];
        tryCodeLabel.textAlignment = UITextAlignmentCenter;
        tryCodeLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:tryCodeLabel];
        [tryCodeLabel release];
    }
}

- (void)setNumberList:(NSInteger)startNum  endNum:(NSInteger)endNum  blueNum:(NSInteger)blueNum type:(NSString*)type
{
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (endNum-startNum+1)*ballHeigth + batchCodeLabelWidth + winNoLabelWidth, ballHeigth)];
    //    imageBg.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:15.0/255.0 blue:0.0 alpha:1.0];
    imageBg.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    [self addSubview:imageBg];
    [imageBg release];
    
    if([type isEqualToString:kLotTitleKLSF]||[type isEqualToString:kLotTitleCQSF])
    {
        UIImageView *imageBlueBg = [[UIImageView alloc] initWithFrame:CGRectMake(winNoLabelWidth + batchCodeLabelWidth, 0, 18 * ballHeigth, ballHeigth)];
        //        imageBlueBg.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:110.0/255.0 blue:162.0/255.0 alpha:1.0];
        imageBlueBg.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:83.0/255.0 blue:176.0/255.0 alpha:1.0];
        [self addSubview:imageBlueBg];
        [imageBlueBg release];
    }
    for(int i = 1; i <= blueNum * 2; i = i+2)
    {
        UIImageView *imageBlueBg = [[UIImageView alloc] initWithFrame:CGRectMake(winNoLabelWidth + batchCodeLabelWidth+(endNum-startNum+1)*ballHeigth*i, 0, (endNum-startNum+1)*ballHeigth, ballHeigth)];
        //        imageBlueBg.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:110.0/255.0 blue:162.0/255.0 alpha:1.0];
        
        imageBlueBg.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:83.0/255.0 blue:176.0/255.0 alpha:1.0];
        [self addSubview:imageBlueBg];
        
        UIImageView *imageRedBg = [[UIImageView alloc] initWithFrame:CGRectMake(imageBlueBg.frame.origin.x+imageBlueBg.frame.size.width, 0, (endNum-startNum+1)*ballHeigth, ballHeigth)];
        //        imageRedBg.backgroundColor = [UIColor colorWithRed:199.0/255.0 green:15.0/255.0 blue:0.0 alpha:1.0];
        imageBg.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        [self addSubview:imageBg];
        [self addSubview:imageRedBg];
        
        UILabel *blueLabel = [[UILabel alloc] initWithFrame:CGRectMake(winNoLabelWidth + batchCodeLabelWidth+(endNum-startNum+1)*ballHeigth*i, 0, (endNum-startNum+1)*ballHeigth, ballHeigth)];
        blueLabel.text = @"";
        blueLabel.backgroundColor = [UIColor clearColor];
        blueLabel.textColor = [UIColor whiteColor];
        blueLabel.textAlignment = UITextAlignmentLeft;
        blueLabel.font = [UIFont boldSystemFontOfSize:12];
        
        UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake(blueLabel.frame.origin.x+blueLabel.frame.size.width, 0, (endNum-startNum+1)*ballHeigth, ballHeigth)];
        redLabel.text = @"";
        redLabel.backgroundColor = [UIColor clearColor];
        redLabel.textColor = [UIColor whiteColor];
        redLabel.textAlignment = UITextAlignmentLeft;
        redLabel.font = [UIFont boldSystemFontOfSize:12];
        for(int j = startNum; j <= endNum; j++)
        {
            if(j != endNum)
            {
                blueLabel.text = [blueLabel.text stringByAppendingFormat:@" %02d ",j];
                redLabel.text = [redLabel.text stringByAppendingFormat:@" %02d ",j];
            }
            else
            {
                blueLabel.text = [blueLabel.text stringByAppendingFormat:@" %02d",j];
                redLabel.text = [redLabel.text stringByAppendingFormat:@" %02d",j];
            }
        }
        [self addSubview:blueLabel];
        [self addSubview:redLabel];
        [blueLabel release];
        [redLabel release];
        
        [imageBlueBg release];
        [imageRedBg release];
    }
    
    UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(winNoLabelWidth + batchCodeLabelWidth, 0, (endNum-startNum+1)*ballHeigth, ballHeigth)];
    listLabel.text = @"";
    listLabel.backgroundColor = [UIColor clearColor];
    listLabel.textColor = [UIColor whiteColor];
    listLabel.textAlignment = UITextAlignmentLeft;
    listLabel.font = [UIFont boldSystemFontOfSize:12];
    for(int i = startNum; i <= endNum; i++)
    {
        if(i != endNum)
            listLabel.text = [listLabel.text stringByAppendingFormat:@" %02d ",i];
        else
            listLabel.text = [listLabel.text stringByAppendingFormat:@" %02d",i];
        
    }
    [self addSubview:listLabel];
    [listLabel release];
}

- (void)setBlueNumberList:(NSInteger)startNum  endNum:(NSInteger)endNum
{
    if(startNum == 0 && endNum == 0)
    {
        return;
    }
    float  width = ((endNum-startNum+1)*ballHeigth < 320) ? 320 :batchCodeLabelWidth + (endNum-startNum+1)*ballHeigth;
    UIImageView *imageBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, ballHeigth)];
    imageBg.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:83.0/255.0 blue:176.0/255.0 alpha:1.0];
    //    imageBg.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    [self addSubview:imageBg];
    [imageBg release];
    
    UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (endNum-startNum+1)*ballHeigth, ballHeigth)];
    listLabel.text = @"";
    listLabel.backgroundColor = [UIColor clearColor];
    listLabel.textColor = [UIColor whiteColor];
    listLabel.textAlignment = UITextAlignmentLeft;
    listLabel.font = [UIFont boldSystemFontOfSize:12];
    for(int i = startNum; i <= endNum; i++)
    {
        if(i != endNum)
            listLabel.text = [listLabel.text stringByAppendingFormat:@" %02d ",i];
        else
            listLabel.text = [listLabel.text stringByAppendingFormat:@" %02d",i];
        
    }
    [self addSubview:listLabel];
    [listLabel release];
}

- (void)setBallShow:(NSString*)type isRed:(BOOL)isRed
{
    [m_bluePointArray removeAllObjects];
    int nRedBall = 0;
    int nBlueBall = 0;
    int startN = 0;
    self.lotTitle = type;
    if ([type isEqualToString:kLotTitleSSQ])
    {
        nRedBall = 6;
        nBlueBall = 1;
        startN = 1;
        weiShu = 0;
        isRedBallLine = NO;//是否每位的球相连
    }
    else if ([type isEqualToString:kLotTitleFC3D])
    {
        nRedBall = 3;
        nBlueBall = 0;
        startN = 0;
        weiShu = 3;
        isRedBallLine = YES;
    }
    else if ([type isEqualToString:kLotTitleDLT])
    {
        nRedBall = 5;
        nBlueBall = 2;
        startN = 1;
        weiShu = 0;
        isRedBallLine = NO;
    }
    else if ([type isEqualToString:kLotTitleQLC])
    {
        nRedBall = 7;
        nBlueBall = 1;
        startN = 1;
        weiShu = 0;
        isRedBallLine = NO;
    }
    else if ([type isEqualToString:kLotTitlePLS])
    {
        nRedBall = 3;
        nBlueBall = 0;
        startN = 0;
        weiShu = 3;
        isRedBallLine = YES;
    }
    else if ([type isEqualToString:kLotTitlePL5] || [type isEqualToString:kLotTitleSSC])
	{
		nRedBall = 5;
		nBlueBall = 0;
        startN = 0;
        weiShu = 5;
        isRedBallLine = YES;
	}
    else if([type isEqualToString:kLotTitle11X5] || [type isEqualToString:kLotTitleGD115] || [type isEqualToString:kLotTitle11YDJ]||[type isEqualToString:kLotTitleCQ11X5])
    {
        nRedBall = 5;
		nBlueBall = 0;
        startN = 1;
        weiShu = 0;
        isRedBallLine = YES;
    }
	else if ([type isEqualToString:kLotTitleQXC])
	{
		nRedBall = 7;
		nBlueBall = 0;
        startN = 0;
        weiShu = 7;
        isRedBallLine = YES;
	}
    else if ([type isEqualToString:kLotTitle22_5])
    {
        nRedBall = 5;
        nBlueBall = 0;
        startN = 1;
        weiShu = 0;
        isRedBallLine = NO;
    }
    else if([type isEqualToString:kLotTitleKLSF])
    {
        nRedBall = 8;
		nBlueBall = 0;
        startN = 1;
        weiShu = 0;
        isRedBallLine = YES;
    }
    else if([type isEqualToString:kLotTitleCQSF])
    {
        nRedBall = 8;
		nBlueBall = 0;
        startN = 1;
        weiShu = 0;
        isRedBallLine = YES;
    }
    else if([self.lotTitle isEqualToString:kLotTitleNMK3])
    {
        nRedBall = 3;
        nBlueBall = 0;
        startN = 1;
        weiShu = 0;
        isRedBallLine = NO;
        [self setNMKSWinNoBall];
        //return;
    }
    for(int i = 0; i < Hnumber; i++)
    {
        NSString *WinNumString = [self.winNoArray objectAtIndex:i];
        CGRect buttonFrame = CGRectZero;
        NSString *winNum = @"";
        if(isRed)
        {
            for(int j = 0; j < nRedBall; j++)
            {
                if ([type isEqualToString:kLotTitleDLT])//三位一取
                {
                    if (0 == j)
                    {
                        if (WinNumString.length >= 2)
                        {
                            winNum = [WinNumString substringWithRange:NSMakeRange(0, 2)];
                            buttonFrame = CGRectMake(([winNum intValue] - startN)*ballHeigth+batchCodeLabelWidth + winNoLabelWidth + 1, i * ballHeigth+ballHeigth + 1, ballHeigth - 2, ballHeigth - 2);
                        }
                    }
                    else
                    {
                        if (WinNumString.length >= (j * 3 + 2))
                        {
                            winNum = [WinNumString substringWithRange:NSMakeRange(j * 3, 2)];
                            buttonFrame = CGRectMake(([winNum intValue] - startN)*ballHeigth+ batchCodeLabelWidth + winNoLabelWidth + 1, i * ballHeigth +ballHeigth + 1, ballHeigth - 2, ballHeigth - 2);
                        }
                    }
                }
                else if ([type isEqualToString:kLotTitlePLS] || [type isEqualToString:kLotTitlePL5] || [type isEqualToString:kLotTitleQXC] || [type isEqualToString:kLotTitleSSC])//一位一取
                {
                    if (WinNumString.length >= (j + 1))
                    {
                        winNum = [WinNumString substringWithRange:NSMakeRange(j, 1)];
                        buttonFrame = CGRectMake(([winNum intValue] - startN)*ballHeigth+10*ballHeigth*j+batchCodeLabelWidth+ winNoLabelWidth+1, i * ballHeigth+ballHeigth + 1, ballHeigth - 2, ballHeigth - 2);
                        [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.x+10]];
                        [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.y+10]];
                    }
                }
                else
                {
                    if (WinNumString.length >= (j * 2 + 2))//两位一取
                    {
                        winNum = [WinNumString substringWithRange:NSMakeRange(j * 2, 2)];
                        if([type isEqualToString:kLotTitleFC3D])//第二位坐标不同
                        {
                            buttonFrame = CGRectMake(([winNum intValue] - startN)*ballHeigth+10*ballHeigth*j+batchCodeLabelWidth+ winNoLabelWidth+1, i * ballHeigth+ballHeigth + 1, ballHeigth - 2, ballHeigth - 2);
                            [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.x+10]];
                            [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.y+10]];
                        }
                        else if([type isEqualToString:kLotTitle11X5] || [type isEqualToString:kLotTitleGD115] || [type isEqualToString:kLotTitle11YDJ] || [type isEqualToString:kLotTitleKLSF]||[type isEqualToString:kLotTitleCQ11X5]||[type isEqualToString:kLotTitleCQSF])
                        {
                            buttonFrame = CGRectMake(([winNum intValue] - startN)*ballHeigth+batchCodeLabelWidth+ winNoLabelWidth+1, i * ballHeigth+ballHeigth + 1, ballHeigth - 2, ballHeigth - 2);
                            [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.x+10]];
                            [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.y+10]];
                        }
                        else
                            buttonFrame = CGRectMake(([winNum intValue] - startN)*ballHeigth+batchCodeLabelWidth+ winNoLabelWidth+1, i * ballHeigth+ballHeigth + 1, ballHeigth - 2, ballHeigth - 2);
                    }
                }
                UIButton *buttonNum = [[UIButton alloc] initWithFrame:buttonFrame];
                if([type isEqualToString:kLotTitle22_5] || [type isEqualToString:kLotTitle11X5] || [type isEqualToString:kLotTitleGD115] || [type isEqualToString:kLotTitle11YDJ] ||[type isEqualToString:kLotTitleCQ11X5] || [type isEqualToString:kLotTitleNMK3])
                {
                    [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
                    [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateHighlighted];
                }
                else if([type isEqualToString:kLotTitleKLSF]||[type isEqualToString:kLotTitleCQSF])
                {
                    if([winNum isEqualToString:@"19"] || [winNum isEqualToString:@"20"])
                    {
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateHighlighted];
                    }
                    else
                    {
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateHighlighted];
                    }
                }
                else
                {
                    if(nBlueBall == 0 && j % 2 != 0)
                    {
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateHighlighted];
                    }
                    else
                    {
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
                        [buttonNum setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateHighlighted];
                    }
                }
                if([type isEqualToString:kLotTitleFC3D])//一位数表示
                    [buttonNum setTitle:[NSString stringWithFormat:@"%d", [winNum intValue]] forState:UIControlStateNormal];
                else
                    [buttonNum setTitle:winNum forState:UIControlStateNormal];
                [buttonNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                buttonNum.titleLabel.font = [UIFont systemFontOfSize:13];
                //                buttonNum.enabled = NO; //影响背景图色深
                [self addSubview:buttonNum];
                [buttonNum release];
            }
            [self setNeedsDisplayInRect:CGRectMake(batchCodeLabelWidth + winNoLabelWidth, ballHeigth, Vnumber * ballHeigth, Hnumber * ballHeigth)];
        }
        else
        {
            for(int k = 0; k < nBlueBall; k++)
            {
                if ([type isEqualToString:kLotTitleDLT])
                {
                    NSInteger start = WinNumString.length - 5;
                    winNum = [WinNumString substringWithRange:NSMakeRange(start + k * 3, 2)];
                }
                else
                {
                    NSInteger bStart = WinNumString.length - nBlueBall * 2;
                    winNum = [WinNumString substringWithRange:NSMakeRange(bStart, 2)];
                }
                buttonFrame = CGRectMake(([winNum intValue] - startN) * ballHeigth + 1, i * ballHeigth+ballHeigth + 1, ballHeigth - 2, ballHeigth - 2);
                
                [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.x+10]];
                [m_bluePointArray addObject:[NSString stringWithFormat:@"%f", buttonFrame.origin.y+10]];
                
                UIButton *buttonBNum = [[UIButton alloc] initWithFrame:buttonFrame];
                [buttonBNum setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
                [buttonBNum setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateHighlighted];
                [buttonBNum setTitle:winNum forState:UIControlStateNormal];
                [buttonBNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                buttonBNum.titleLabel.font = [UIFont systemFontOfSize:13];
                //                 buttonBNum.enabled = NO;
                [self addSubview:buttonBNum];
                [buttonBNum release];
            }
        }
        [self setNeedsDisplayInRect:CGRectMake(0, ballHeigth, Vnumber * ballHeigth, Hnumber * ballHeigth)];
    }
}

- (void)setNMKSWinNoBall
{
    for(int i = 0; i < Hnumber; i++)
    {
        NSString *WinNumString = [self.winNoArray objectAtIndex:i];
        CGRect buttonFrame = CGRectZero;
        NSString *winNum = @"";
        int sameCount = 0;
        int one_num = [[WinNumString substringWithRange:NSMakeRange(0, 2)] intValue];
        int two_num = [[WinNumString substringWithRange:NSMakeRange(2, 2)] intValue];
        int there_num = [[WinNumString substringWithRange:NSMakeRange(4, 2)] intValue];
        if(one_num == two_num && two_num == there_num)//3号码相同
            sameCount = kNMKS3Same;
        else if(one_num == two_num)
            sameCount = kNMKS1_2Same;
        else if(two_num == there_num)
            sameCount = kNMKS2_3Same;
        else if(one_num == there_num)
            sameCount = kNMKS1_3Same;
        
        for (int j = 0; j < 3; j++) {
            if (WinNumString.length >= (j * 2 + 2)){//两位一取
                winNum = [WinNumString substringWithRange:NSMakeRange(j * 2, 2)];
                buttonFrame = CGRectMake(([winNum intValue] - 1)*ballHeigth+batchCodeLabelWidth+ winNoLabelWidth + 10, i * ballHeigth+ballHeigth + 10, ballHeigth - 2, ballHeigth - 2);
            }
            NSInteger buttonTag = [[NSString stringWithFormat:@"%02d%02d",i , [winNum intValue]] intValue] + redStartBallTag;
            if (kNMKS1_3Same == sameCount && 2 == j) {
                break;
            }
            else
                [self setNormalBallWithColor:YES withPoint:buttonFrame.origin /*withContext:_context */withTitle:winNum withTag:buttonTag];
            
            if (kNMKS3Same == sameCount
                || (kNMKS1_2Same == sameCount && 0 == j)
                || (kNMKS2_3Same == sameCount && 1 == j)
                || (kNMKS1_3Same == sameCount && (0 == j || 2 == j))) {
                NSString* but_title = @"";
                if (kNMKS3Same == sameCount){
                    j = j+2;
                    but_title = @"3";
                }
                else if(kNMKS1_2Same == sameCount && 0 == j){
                    j++;
                    but_title = @"2";
                }
                else if(kNMKS2_3Same == sameCount && 1 == j){
                    j++;
                    but_title = @"2";
                }
                else if(kNMKS1_3Same == sameCount && (0 == j || 2 == j))
                {
                    if (0 == j) {
                        but_title = @"2";
                    }
                    else
                        break;
                }
                UIButton*  sameCountBut = [[UIButton alloc] initWithFrame:CGRectMake(buttonFrame.origin.x+4, buttonFrame.origin.y-12, 8, 8)];
                [sameCountBut setBackgroundImage:RYCImageNamed(@"same_count_bg.png") forState:UIControlStateNormal];
                [sameCountBut setBackgroundImage:RYCImageNamed(@"same_count_bg.png") forState:UIControlStateHighlighted];
                [sameCountBut setTitle:but_title forState:UIControlStateNormal];
                [sameCountBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                sameCountBut.titleLabel.font = [UIFont systemFontOfSize:8.0f];
                [self addSubview:sameCountBut];
                [sameCountBut release];
            }
        }
    }
}

- (void)setNormalBallWithColor:(BOOL)isRed withPoint:(CGPoint)point /*withContext:(CGContextRef)_context*/ withTitle:(NSString*)_title withTag:(NSInteger)_buttonTag
{
    UIButton *buttonNum = [[UIButton alloc] initWithFrame:CGRectMake(point.x - 9, point.y - 9, ballHeigth - 2, ballHeigth - 2)];
    if(isRed)//红球
    {
        [buttonNum setBackgroundImage:RYCImageNamed(@"trdred.png") forState:UIControlStateNormal];
        [buttonNum setBackgroundImage:RYCImageNamed(@"trdgreen.png") forState:UIControlStateSelected];
    }
    else//篮球
    {
        [buttonNum setBackgroundImage:RYCImageNamed(@"trdblue.png") forState:UIControlStateNormal];
        [buttonNum setBackgroundImage:RYCImageNamed(@"trdgreen.png") forState:UIControlStateSelected];
    }
    buttonNum.tag = _buttonTag;
    [buttonNum setTitle:_title forState:UIControlStateNormal];
    [buttonNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonNum.titleLabel.font = [UIFont systemFontOfSize:13];
    [buttonNum addTarget:self action:@selector(redBallSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonNum];
    [buttonNum release];
}

-(IBAction)redBallSelect:(id)sender{
    
}
@end





