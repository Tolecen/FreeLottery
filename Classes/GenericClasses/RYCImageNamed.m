//
//  RYCImageNamed.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RYCImageNamed.h"

UIImage* RYCImageNamed(NSString* name)
{
    UIImage * image = [UIImage imageNamed:name];
    
    image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    return image;//该方法图片有缓存，占内存
//    NSArray* imgName = [name componentsSeparatedByString:@"."];
//    if([imgName count] == 2)
//    {
//        NSString*   imgPath = [[NSBundle mainBundle] pathForResource:[imgName objectAtIndex:0] ofType:[imgName objectAtIndex:1]];
//        NSData* imgdata = [NSData dataWithContentsOfFile:imgPath];
//        return [UIImage imageWithData:imgdata];
//    }
//    else
//        return nil;//卡死了
}

UIImageView*  tableBgImage(CGRect topFrame, CGRect middleFrame, CGRect lineFrame)
{
    UIImageView* bgImage = [[[UIImageView alloc] init] autorelease];
    bgImage.backgroundColor = [UIColor clearColor];
    
    UIImageView *image_topbg = [[UIImageView alloc] initWithFrame:topFrame];
    image_topbg.image = RYCImageNamed(@"croner_top.png");
    [bgImage addSubview:image_topbg];
    [image_topbg release];
    
    UIImageView *image_middlebg = [[UIImageView alloc] initWithFrame:middleFrame];
    image_middlebg.image = RYCImageNamed(@"croner_middle.png");
    [bgImage addSubview:image_middlebg];
    
    UIImageView *image_linebg = [[UIImageView alloc] initWithFrame:lineFrame];
    image_linebg.image = RYCImageNamed(@"croner_line.png");
    [bgImage addSubview:image_linebg];
    [image_linebg release];
    
    UIImageView *image_bottombg = [[UIImageView alloc] initWithFrame:CGRectMake(9,image_middlebg.frame.origin.y + image_middlebg.frame.size.height, 302, 12)];
    image_bottombg.image = RYCImageNamed(@"croner_bottom.png");
    [bgImage addSubview:image_bottombg];
    [image_bottombg release];
    
    [image_middlebg release];
    return bgImage;
}

double lnChoose(int n, int m)
{
    if (m > n)
        return 0;
    
    if (m < n/2.0)
        m = n - m;
    
    double s1 = 0;
    for (int i = m + 1; i <= n; i++)
        s1 += log((double)i);
    
    double s2 = 0;
    int ub = n - m;
    for (int i = 2; i <= ub; i++)
        s2 += log((double)i);
    
    return s1 - s2;
}

int RYCChoose(int m, int n)
{
    if (m > n)
        return 0;
    
    return (int)(exp(lnChoose(n, m)) + 0.5);
}

int NumberOfDirectSum(NSArray* indexArray)
{
    int ret = 0;
    for (int i = 0; i < [indexArray count]; i++)
    {
        int index = [[indexArray objectAtIndex:i] intValue];
        switch (index) {
            case 0:
                ret += 1;
                break;
            case 1:
                ret += 3;
                break;
            case 2:
                ret += 6;
                break;
            case 3:
                ret += 10;
                break;
            case 4:
                ret += 15;
                break;
            case 5:
                ret += 21;
                break;
            case 6:
                ret += 28;
                break;
            case 7:
                ret += 36;
                break;
            case 8:
                ret += 45;
                break;
            case 9:
                ret += 55;
                break;
            case 10:
                ret += 63;
                break;
            case 11:
                ret += 69;
                break;
            case 12:
                ret += 73;
                break;
            case 13:
                ret += 75;
                break;
            case 14:
                ret += 75;
                break;
            case 15:
                ret += 73;
                break;
            case 16:
                ret += 69;
                break;
            case 17:
                ret += 63;
                break;
            case 18:
                ret += 55;
                break;   
            case 19:
                ret += 45;
                break;
            case 20:
                ret += 36;
                break;
            case 21:
                ret += 28;
                break;
            case 22:
                ret += 21;
                break;
            case 23:
                ret += 15;
                break;
            case 24:
                ret += 10;
                break;
            case 25:
                ret += 6;
                break;
            case 26:
                ret += 3;
                break;
            case 27:
                ret += 1;
                break;
            default:
                break;
        }
    }
    return ret;
}

int NumberOfGroup3Sum(NSArray* indexArray)
{
    int ret = 0;
    for (int i = 0; i < [indexArray count]; i++)
    {
        int index = [[indexArray objectAtIndex:i] intValue];
        switch (index) {
            case 0:
                ret += 1;
                break;
            case 1:
                ret += 2;
                break;
            case 2:
                ret += 1;
                break;
            case 3:
                ret += 3;
                break;
            case 4:
                ret += 3;
                break;
            case 5:
                ret += 3;
                break;
            case 6:
                ret += 4;
                break;
            case 7:
                ret += 5;
                break;
            case 8:
                ret += 4;
                break;
            case 9:
                ret += 5;
                break;
            case 10:
                ret += 5;
                break;
            case 11:
                ret += 4;
                break;
            case 12:
                ret += 5;
                break;
            case 13:
                ret += 5;
                break;
            case 14:
                ret += 4;
                break;
            case 15:
                ret += 5;
                break;
            case 16:
                ret += 5;
                break;
            case 17:
                ret += 4;
                break;
            case 18:
                ret += 5;
                break;   
            case 19:
                ret += 4;
                break;
            case 20:
                ret += 3;
                break;
            case 21:
                ret += 3;
                break;
            case 22:
                ret += 3;
                break;
            case 23:
                ret += 1;
                break;
            case 24:
                ret += 2;
                break;
            case 25:
                ret += 1;
                break;
            default:
                break;
        }
    }
    return ret;
}

int NumberOfGroup6Sum(NSArray* indexArray)
{
    int ret = 0;
    for (int i = 0; i < [indexArray count]; i++)
    {
        int index = [[indexArray objectAtIndex:i] intValue];
        switch (index) {
            case 0:
                ret += 1;
                break;
            case 1:
                ret += 1;
                break;
            case 2:
                ret += 2;
                break;
            case 3:
                ret += 3;
                break;
            case 4:
                ret += 4;
                break;
            case 5:
                ret += 5;
                break;
            case 6:
                ret += 7;
                break;
            case 7:
                ret += 8;
                break;
            case 8:
                ret += 9;
                break;
            case 9:
                ret += 10;
                break;
            case 10:
                ret += 10;
                break;
            case 11:
                ret += 10;
                break;
            case 12:
                ret += 10;
                break;
            case 13:
                ret += 9;
                break;
            case 14:
                ret += 8;
                break;
            case 15:
                ret += 7;
                break;
            case 16:
                ret += 5;
                break;
            case 17:
                ret += 4;
                break;
            case 18:
                ret += 3;
                break;   
            case 19:
                ret += 2;
                break;
            case 20:
                ret += 1;
                break;
            case 21:
                ret += 1;
                break;
            default:
                break;
        }
    }
    return ret;
}

int NumberOf2XingSum(NSArray* indexArray)
{
	int ret = 0;
    for (int i = 0; i < [indexArray count]; i++)
    {
        int index = [[indexArray objectAtIndex:i] intValue];
        switch (index) {
            case 0:
                ret += 1;
                break;
            case 1:
                ret += 1;
                break;
            case 2:
                ret += 2;
                break;
            case 3:
                ret += 2;
                break;
            case 4:
                ret += 3;
                break;
            case 5:
                ret += 3;
                break;
            case 6:
                ret += 4;
                break;
            case 7:
                ret += 4;
                break;
            case 8:
                ret += 5;
                break;
            case 9:
                ret += 5;
                break;
            case 10:
                ret += 5;
                break;
            case 11:
                ret += 4;
                break;
            case 12:
                ret += 4;
                break;
            case 13:
                ret += 3;
                break;
            case 14:
                ret += 3;
                break;
            case 15:
                ret += 2;
                break;
            case 16:
                ret += 2;
                break;
            case 17:
                ret += 1;
                break;
			case 18:
                ret += 1;
                break;
			default:
                break;
        }
    }
    return ret;
}

#pragma mark 高频彩直选注数算法（去掉含相同球注数）
int numZhuZhiWithDic(NSDictionary* tempDic)
{
//    NSLog(@"tempDic %@", tempDic);
    if(tempDic == nil || [[tempDic allKeys] count] == 0)
        return 0;
    NSArray* wangWei = [tempDic objectForKey:kWangWeiKey];//直二
    NSArray* qianWei = [tempDic objectForKey:kQianWeiKey];
    NSArray* baiWei;
    if([[tempDic allKeys] count] > 2)//直三
    {
       baiWei = [tempDic objectForKey:kBaiWeiKey];
    }
    
    NSInteger zhuShu = 0;
    for (int i = 0; i < [wangWei count]; i++)
    {
        for (int j = 0; j < [qianWei count]; j++)
        {
            if(!([[wangWei objectAtIndex:i] intValue] == [[qianWei objectAtIndex:j] intValue]))
            {
                if([[tempDic allKeys] count] > 2)
                {
                    for (int k = 0; k < [baiWei count]; k++)
                    {
                        if(!([[baiWei objectAtIndex:k] intValue] == [[qianWei objectAtIndex:j] intValue]) && !([[baiWei objectAtIndex:k] intValue] == [[wangWei objectAtIndex:i] intValue]))
                            zhuShu++;
                    }
                }
                else
                {
                    zhuShu++;
                }
            }
        }
    }
    NSLog(@"zhuShu:::: %d", zhuShu);
    return zhuShu;
}
