//
//  MissAndOpenView.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-13.
//
//

#import "MissAndOpenView.h"
#import "RuYiCaiCommon.h"


#define PI 3.14159265358979323846
#define radius 12

static inline float radians(double degrees) {
    return degrees * PI / 180;
}

//static inline void drawArc(CGContextRef ctx, CGPoint point, UIColor* color) {
//    CGContextMoveToPoint(ctx, point.x, point.y);
//    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
//    CGContextAddArc(ctx, point.x, point.y, radius,  0.0, 360.0, 0);
//    //CGContextClosePath(ctx);
//    CGContextFillPath(ctx);
//}

@implementation MissAndOpenView

@synthesize lotNo = m_lotNo;
@synthesize dataArray = m_dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawBatchCodeView];
    if(KISiPhone5)
        [self addiPhone5View];
    if([self.lotNo isEqualToString:kLotNoSSQ])
    {
        [self drawMissAndOpenViewWithSSQ];
        [self drawSSQRectLine];
    }
 }

- (void)addiPhone5View// 底部空白画上：22px
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布
    
    CGContextSetRGBStrokeColor(context, 211.0/255.0, 196.0/255.0, 196.0/255.0, 1.0); //笔色
	CGContextSetLineWidth(context, 0.5); //线宽
    for(int i = 0; i < 49; i++)
    {
        CGRect bgRect = CGRectMake(batchCodeLabelWidth + ballHeigth * i , ballHeigth * [self.dataArray count], ballHeigth, 22);
        
        if(i%2 == 0)
            CGContextSetRGBFillColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1);
        else
            CGContextSetRGBFillColor(context, 241.0/255.0, 241.0/255.0, 241.0/255.0, 1);
        CGContextAddRect(context, bgRect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextSetRGBFillColor(context, 255.0/255.0, 238.0/255.0, 225.0/255.0, 1);
    CGContextAddRect(context, CGRectMake(0 , ballHeigth * [self.dataArray count], batchCodeLabelWidth, 22));
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawBatchCodeView//画期号
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布

    CGContextSetRGBStrokeColor(context, 211.0/255.0, 196.0/255.0, 196.0/255.0, 1.0); //笔色
	CGContextSetLineWidth(context, 0.5); //线宽
    
    for (int k = 0; k < [self.dataArray count]; k++)//期号背景
    {
        CGRect pink = CGRectMake(0 , ballHeigth * k, batchCodeLabelWidth, ballHeigth);
        CGContextSetRGBFillColor(context, 255.0/255.0, 238.0/255.0, 225.0/255.0, 1);
        CGContextAddRect(context,pink);
        CGContextDrawPath(context,kCGPathFillStroke);
        
        //写上期号
        NSString* batchCode = [[self.dataArray objectAtIndex:k] objectForKey:@"batchCode"];
        NSString* fontname = @"Helvetica";
        CGContextSelectFont(context, [fontname UTF8String], 13.0, kCGEncodingMacRoman);
        [[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] setFill];//字色

        CGContextSetShouldAntialias(context, true);//让字体渲染比较清晰 提高画质以使之柔和

        CGContextSetTextDrawingMode(context, kCGTextFill);
        //kCGTextClip kCGTextInvisible这样中间没数字 kCGTextFill kCGTextFillClip有数字
        //stroke描边kCGTextFillStroke kCGTextFillStrokeClip数字黑白相映
        // kCGTextStroke kCGTextStrokeClip数字为空心的黑边

        CGContextSetTextMatrix (context, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
        //从文本空间到用户控件的转换矩阵 删除的话数字是倒放的

        CGContextShowTextAtPoint(context, 15,
                                k * ballHeigth + 20,
                                 [batchCode UTF8String], batchCode.length); //绘制文本
      }
}

#pragma mark 双色球
- (void)drawSSQRectLine//双色球区域线
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布
        
    CGContextSetRGBStrokeColor(context, 204.0/255.0, 102.0/255.0, 0.0/255.0, 1.0); //笔色
	CGContextSetLineWidth(context, 0.8); //线宽
    for (int i = 1; i <= 3; i++)
    {
        CGContextMoveToPoint(context, batchCodeLabelWidth+ 11 * ballHeigth * i, 0.0);
        if (KISiPhone5)
            CGContextAddLineToPoint(context, batchCodeLabelWidth+ 11 * ballHeigth * i, ballHeigth * [self.dataArray count] + 22);
        else
            CGContextAddLineToPoint(context, batchCodeLabelWidth+ 11 * ballHeigth * i, ballHeigth * [self.dataArray count]);
        CGContextStrokePath(context);
    }
}

- (void)drawMissAndOpenViewWithSSQ//画双色球遗落值及开奖号码
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布
    
    CGContextSetRGBStrokeColor(context, 211.0/255.0, 196.0/255.0, 196.0/255.0, 1.0); //笔色
	CGContextSetLineWidth(context, 0.5); //线宽
    
    for(int i = 0; i < [self.dataArray count]; i++)
    {
        for (int k = 0; k < 49; k++)//球背景
        {
            CGRect bgRect = CGRectMake(batchCodeLabelWidth + ballHeigth * k , ballHeigth * i, ballHeigth, ballHeigth);

            if(k%2 == 0)
                CGContextSetRGBFillColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, 1);
            else
                CGContextSetRGBFillColor(context, 241.0/255.0, 241.0/255.0, 241.0/255.0, 1);
            CGContextAddRect(context, bgRect);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        for (int r = 0; r < 33; r++)//红色区域
        {
            NSArray* missRedArr = [[[self.dataArray objectAtIndex:i] objectForKey:@"value"] objectForKey:@"red"];
            NSString* fontname = @"Helvetica";
            CGContextSelectFont(context, [fontname UTF8String], 15.0, kCGEncodingMacRoman);
            NSString* missStr = [NSString stringWithFormat:@"%@", [missRedArr objectAtIndex:r]];

            if([missStr isEqualToString:@"0"])//开的号码，底部画圆
            {
                CGPoint point = CGPointMake(batchCodeLabelWidth + ballHeigth/2 + r * ballHeigth, ballHeigth/2 + i * ballHeigth);
                drawArc(context, point, [UIColor colorWithRed:204.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0], radius);//红圆
                missStr = [NSString stringWithFormat:@"%02d", (r + 1)];
                [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] setFill];//字色
            }
            else
                [[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] setFill];//字色
            CGContextSetShouldAntialias(context, true);//让字体渲染比较清晰 提高画质以使之柔和
            CGContextSetTextDrawingMode(context, kCGTextFill);
            CGContextSetTextMatrix (context, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
            if(missStr.length == 2)
            {
                CGContextShowTextAtPoint(context, 8 + batchCodeLabelWidth + r * ballHeigth,
                                     i * ballHeigth + 22,
                                     [missStr UTF8String], missStr.length); //绘制文本
            }
            else
            {
                CGContextShowTextAtPoint(context, 12 + batchCodeLabelWidth + r * ballHeigth,
                                         i * ballHeigth + 22,
                                         [missStr UTF8String], missStr.length); //绘制文本
            }
        }
        for (int b = 0; b < 16; b++)//蓝色区域
        {
            NSArray* missBlueArr = [[[self.dataArray objectAtIndex:i] objectForKey:@"value"] objectForKey:@"blue"];
            NSString* fontname = @"Helvetica";
            CGContextSelectFont(context, [fontname UTF8String], 15.0, kCGEncodingMacRoman);
            NSString* missStr_blue = [NSString stringWithFormat:@"%@", [missBlueArr objectAtIndex:b]];
            if([missStr_blue isEqualToString:@"0"])//开的号码，底部画圆
            {
                CGPoint point = CGPointMake(batchCodeLabelWidth + 33 * ballHeigth + ballHeigth/2 + b * ballHeigth, ballHeigth/2 + i * ballHeigth);
                drawArc(context, point, [UIColor colorWithRed:53.0/255.0 green:139.0/255.0 blue:231.0/255.0 alpha:1.0], radius);//蓝圆
                missStr_blue = [NSString stringWithFormat:@"%02d", (b + 1)];
                [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] setFill];//字色
            }
            else
                [[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] setFill];//字色
            CGContextSetShouldAntialias(context, true);//让字体渲染比较清晰 提高画质以使之柔和
            CGContextSetTextDrawingMode(context, kCGTextFill);
            CGContextSetTextMatrix (context, CGAffineTransformMake(1, 0, 0, -1, 0, 0));
            if(missStr_blue.length == 2)
            {
                CGContextShowTextAtPoint(context, 9 + batchCodeLabelWidth + 33 * ballHeigth + b * ballHeigth,
                                         i * ballHeigth + 22,
                                         [missStr_blue UTF8String], missStr_blue.length); //绘制文本
            }
            else
            {
                CGContextShowTextAtPoint(context, 12 + batchCodeLabelWidth + 33 * ballHeigth + b * ballHeigth,
                                         i * ballHeigth + 22,
                                         [missStr_blue UTF8String], missStr_blue.length); //绘制文本
            }
        }

    }
}
@end
