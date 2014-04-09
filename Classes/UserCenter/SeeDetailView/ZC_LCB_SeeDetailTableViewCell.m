//
//  ZC_LCB_SeeDetailTableViewCell.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-1-21.
//
//

#import "ZC_LCB_SeeDetailTableViewCell.h"
#import "ZC_SeeDetailTableViewCell.h"
#import "RuYiCaiCommon.h"

@interface ZC_LCB_SeeDetailTableViewCell ()

@end

@implementation ZC_LCB_SeeDetailTableViewCell
@synthesize contentStr = m_contentStr;
@synthesize isZC_JQC;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (![@"true" isEqualToString:[self.contentStr objectForKey:@"display"]]) {
        
        //0:对所有人立即公开;1:保密;2:对所有人截止后公开;3:对跟单者立即公开;4:对跟单者截止后公开
        if ([@"1" isEqualToString:[self.contentStr objectForKey:@"visibility"]]) {
            [@"保密" drawAtPoint:CGPointMake(5, 10) withFont:[UIFont systemFontOfSize:14]];
        }
        else if ([@"2" isEqualToString:[self.contentStr objectForKey:@"visibility"]]) {
            [@"对所有人截止后公开" drawAtPoint:CGPointMake(5, 10) withFont:[UIFont systemFontOfSize:14]];
        }
        else if ([@"3" isEqualToString:[self.contentStr objectForKey:@"visibility"]]) {
            [@"对跟单者立即公开" drawAtPoint:CGPointMake(5, 10) withFont:[UIFont systemFontOfSize:14]];
        }
        else if ([@"4" isEqualToString:[self.contentStr objectForKey:@"visibility"]]) {
            [@"对跟单者截止后公开" drawAtPoint:CGPointMake(5, 10) withFont:[UIFont systemFontOfSize:14]];
        }
    }
    else{
        
        NSArray* resultArray = [[[self.contentStr objectForKey:@"result"] objectAtIndex:0] objectForKey:@"result"];
        
        [self drawRectangle:context RECT:CGRectMake(0, 30, 300, 30)];
        NSString* wanfa = @"玩法：";
        if ([resultArray count] > 0) {
            wanfa = [wanfa stringByAppendingFormat:@"%@",KISNullValue([self.contentStr objectForKey:@"result"], 0, @"play")];
        }
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
        [wanfa drawAtPoint:CGPointMake(10, 5) forWidth:300 withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation];
        //70 100 50 80
        [@"场次" drawAtPoint:CGPointMake(20, 35) withFont:[UIFont systemFontOfSize:14]];
        [@"对阵" drawAtPoint:CGPointMake(103, 35) withFont:[UIFont systemFontOfSize:14]];
        if(isZC_JQC)
        {
            [@"主队" drawAtPoint:CGPointMake(180, 35) withFont:[UIFont systemFontOfSize:14]];
            [@"客队" drawAtPoint:CGPointMake(250, 35) withFont:[UIFont systemFontOfSize:14]];
        }
        else
        {
            [@"半场" drawAtPoint:CGPointMake(180, 35) withFont:[UIFont systemFontOfSize:14]];
            [@"全场" drawAtPoint:CGPointMake(250, 35) withFont:[UIFont systemFontOfSize:14]];
        }
        [self drawLine:context TOPLEFTPOINT:CGPointMake(70, 30) BOTTOMRIGHTPOINT:CGPointMake(70, 60)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(162, 30) BOTTOMRIGHTPOINT:CGPointMake(162, 60)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(232, 30) BOTTOMRIGHTPOINT:CGPointMake(232, 60)];

        NSInteger heightIndex = 60;
        NSInteger cellheight = zcCellHeight;
        for (int i = 0; i < [resultArray count]; i++) {
            NSInteger currentCellHeight = cellheight;
            NSString* bianhao = KISNullValue(resultArray, i, @"teamId");
            
            NSString* homeTeam = KISNullValue(resultArray, i,@"homeTeam");
            NSString* guestTeam = KISNullValue(resultArray, i,@"guestTeam");
            NSString* duiZhen = @"VS";
            
            NSString* betContentHalf;//半场、主队
            NSString* betContentAll;//全场、客队

            if (isZC_JQC)
            {
                betContentHalf = KISNullValue(resultArray, i,@"betContentHome");//主队
                betContentAll = KISNullValue(resultArray, i,@"betContentGuest");//客队
            }
            else
            {
                betContentHalf = KISNullValue(resultArray, i,@"betContentHalf");//半场
                betContentAll = KISNullValue(resultArray, i,@"betContentAll");//全场
            }
            NSString* touString = @"<font size = \"3\">";
            betContentHalf = [touString stringByAppendingString:betContentHalf];
            betContentHalf = [betContentHalf stringByAppendingString:@"</font>"];
            
            betContentAll = [touString stringByAppendingString:betContentAll];
            betContentAll = [betContentAll stringByAppendingString:@"</font>"];

            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
            [bianhao drawInRect:CGRectMake(0, heightIndex + 20, 70, cellheight) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            [homeTeam drawInRect:CGRectMake(70, heightIndex + 5, 92, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            [duiZhen drawInRect:CGRectMake(70, heightIndex + 20, 92, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            [guestTeam drawInRect:CGRectMake(70, heightIndex + 35, 92, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            //                [[betContentArray objectAtIndex:j] drawInRect:CGRectMake(220 + 25, heightIndex + 20 + j * 16, 60, cellheight) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
            UIWebView*  webView = [[UIWebView alloc] initWithFrame:CGRectMake(162 + 5, heightIndex + 5 , 60, cellheight - 10)];
            [webView loadHTMLString:betContentHalf baseURL:nil];
            [self addSubview:webView];
            [webView release];
            
            UIWebView*  webView_all = [[UIWebView alloc] initWithFrame:CGRectMake(232 + 5, heightIndex + 5 , 60, cellheight - 10)];
            [webView_all loadHTMLString:betContentAll baseURL:nil];
            [self addSubview:webView_all];
            [webView_all release];
            //画线
            //肃
            [self drawLine:context TOPLEFTPOINT:CGPointMake(70, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(70, heightIndex + currentCellHeight)];
            [self drawLine:context TOPLEFTPOINT:CGPointMake(162, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(162, heightIndex + currentCellHeight)];
            [self drawLine:context TOPLEFTPOINT:CGPointMake(232, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(232, heightIndex + currentCellHeight)];

            //横
            [self drawLine:context TOPLEFTPOINT:CGPointMake(0, heightIndex + currentCellHeight) BOTTOMRIGHTPOINT:CGPointMake(300, heightIndex + currentCellHeight)];
            heightIndex += currentCellHeight;
            
        }
    }
}

- (void)drawText:(CGContextRef)_context RECT:(CGRect)rect  TEXT:(NSString*)text
{
    //    // 设置旋转字体
    //    CGAffineTransform myTextTransform = CGAffineTransformMakeRotation(radians(270));
    //    CGContextSetTextMatrix(_context, myTextTransform);
    
    // 设置字体：为16pt Helvetica
    CGContextSelectFont(_context, "Helvetica", 14, kCGEncodingMacRoman);
    //设置文字绘制模式
    // 3种绘制模式：kCGTextFill 填充, kCGTextStroke 描边, kCGTextFillStroke 既填充又描边
    CGContextSetTextDrawingMode(_context, kCGTextStroke); // set drawing mode
    // 设置文本颜色字符为黑色
    CGContextSetRGBFillColor(_context, 0.0, 0.0, 0.0, 1.0); //黑
    //从文本空间到用户控件的转换矩阵 删除的话数字是倒放的
    CGContextSetTextMatrix(_context, CGAffineTransformMakeScale(1.0, -1.0));
    
    CGContextShowTextAtPoint(_context, rect.origin.x, rect.origin.y, [text UTF8String],
                             text.length);
}

- (void)drawRectangle:(CGContextRef)_context RECT:(CGRect)rect
{
    CGContextSetLineWidth(_context, 2);
    CGContextSetRGBFillColor(_context, 248.0/255.0, 248.0/255.0, 246.0/255.0, 1);
    CGContextFillRect(_context, rect);
    CGContextStrokePath(_context);
    
    CGContextAddRect(_context,rect);
    CGContextSetLineWidth(_context, 2);
    CGContextSetRGBStrokeColor(_context, 221.0/255.0, 221.0/255.0, 221.0/255.0, 1);
    CGContextStrokePath(_context);
}

- (void)drawLine:(CGContextRef)_context  TOPLEFTPOINT:(CGPoint)topLeftPoint BOTTOMRIGHTPOINT:(CGPoint)bottomRightPoint
{
    CGContextMoveToPoint(_context, topLeftPoint.x, topLeftPoint.y);
    CGContextAddLineToPoint(_context, bottomRightPoint.x, bottomRightPoint.y);
    CGContextSetLineWidth(_context, 2);
    CGContextSetRGBFillColor(_context, 221.0/255.0, 221.0/255.0, 221.0/255.0, 1);
    
    CGContextStrokePath(_context);
}

@end
