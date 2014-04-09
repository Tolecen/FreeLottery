//
//  JC_SeeDetailTableViewCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-12-19.
//
//

#import "JC_SeeDetailTableViewCell.h"
#import "RuYiCaiCommon.h"

@implementation JC_SeeDetailTableViewCell
@synthesize contentStr = m_contentStr;
@synthesize jc_lotNo;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    //    "display":"true"    方案详情 true 可见 false ，保密 不可见
    //    NSLog(@"self.contentStr: display :    %@",[self.contentStr objectForKey:@"display"]);
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
        
        NSArray* resultArray = [self.contentStr objectForKey:@"result"];
        NSString* wanfa = @"玩法：";
        if ([resultArray count] > 0) {
            wanfa = [wanfa stringByAppendingFormat:@"%@",KISNullValue(resultArray, 0, @"play")];
        }
        
        NSArray* wanFa_array = [wanfa componentsSeparatedByString:@","];
        int headHeight = 20 * ([wanFa_array count]/5);
        [self drawRectangle:context RECT:CGRectMake(0, 30 + headHeight, 300, 30)];
        
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
        for (int i = 0; i <= (int)[wanFa_array count]/4; i++) {//玩法所占行数（1行4个）
            if(i != (int)[wanFa_array count]/4)
                [[NSString stringWithFormat:@"%@,%@,%@,%@", [wanFa_array objectAtIndex:4*i], [wanFa_array objectAtIndex:4*i+1], [wanFa_array objectAtIndex:4*i+2],[wanFa_array objectAtIndex:4*i+3]] drawAtPoint:CGPointMake(10, 5 + i * 20) forWidth:300 withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation];
            else
            {
                int lastLineNum = [wanFa_array count]%4;//最后一行含有元素个数
                NSString* lastLineStr = @"";
                for (int j = 0; j < lastLineNum; j ++) {
                    if (j != lastLineNum - 1)
                        lastLineStr = [lastLineStr stringByAppendingFormat:@"%@,", [wanFa_array objectAtIndex:4*i + j]];
                    else
                        lastLineStr = [lastLineStr stringByAppendingString:[wanFa_array objectAtIndex:4*i + j]];
                }
                [lastLineStr drawAtPoint:CGPointMake(10, 5 + i * 20) forWidth:300 withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation];
            }
        }
        //        [wanfa drawAtPoint:CGPointMake(10, 5) forWidth:300 withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation];
        //70 100 50 80
        //        [@"编号" drawAtPoint:CGPointMake(5, 35 + headHeight) withFont:[UIFont systemFontOfSize:14]];
        //        [@"对阵" drawAtPoint:CGPointMake(102, 35+ headHeight) withFont:[UIFont systemFontOfSize:14]];
        //        [@"比分" drawAtPoint:CGPointMake(172, 35+ headHeight) withFont:[UIFont systemFontOfSize:14]];
        //        [@"您的投注" drawAtPoint:CGPointMake(228, 35+ headHeight) withFont:[UIFont systemFontOfSize:14]];
        //        [self drawLine:context TOPLEFTPOINT:CGPointMake(62, 30+ headHeight) BOTTOMRIGHTPOINT:CGPointMake(62, 60+ headHeight)];
        //        [self drawLine:context TOPLEFTPOINT:CGPointMake(162, 30+ headHeight) BOTTOMRIGHTPOINT:CGPointMake(162, 60+ headHeight)];
        //        [self drawLine:context TOPLEFTPOINT:CGPointMake(212, 30+ headHeight) BOTTOMRIGHTPOINT:CGPointMake(212, 60+ headHeight)];
        
        [@"编号" drawAtPoint:CGPointMake(2, 35 + headHeight) withFont:[UIFont systemFontOfSize:14]];
        [@"对阵" drawAtPoint:CGPointMake(70, 35+ headHeight) withFont:[UIFont systemFontOfSize:14]];
        [@"比分" drawAtPoint:CGPointMake(153, 35+ headHeight) withFont:[UIFont systemFontOfSize:14]];
        [@"您的投注" drawAtPoint:CGPointMake(220, 35+ headHeight) withFont:[UIFont systemFontOfSize:14]];
       
        [self drawLine:context TOPLEFTPOINT:CGPointMake(30, 30+ headHeight) BOTTOMRIGHTPOINT:CGPointMake(30, 60+ headHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(135, 30+ headHeight) BOTTOMRIGHTPOINT:CGPointMake(135, 60+ headHeight)];
        [self drawLine:context TOPLEFTPOINT:CGPointMake(195, 30+ headHeight) BOTTOMRIGHTPOINT:CGPointMake(195, 60+ headHeight)];
        
        NSInteger heightIndex = 60 + headHeight;
        NSInteger cellheight = CellHeight;
        for (int i = 0; i < [resultArray count]; i++) {
            NSInteger currentCellHeight = cellheight;
            NSString* bianhao = KISNullValue(resultArray, i, @"teamId");
            
            NSString* homeTeam;
            NSString* guestTeam;
            if ([self.jc_lotNo isEqualToString:kLotNoJCLQ_SF] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_RF] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_SFC] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_DXF] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_CONFUSION] ) {//篮球客队在上
                
                homeTeam = [NSString stringWithFormat:@"%@(客)",KISNullValue(resultArray, i,@"guestTeam")];
                guestTeam = [NSString stringWithFormat:@"%@(主)",KISNullValue(resultArray, i,@"homeTeam")];
            }
            else{//足球客队在下
                homeTeam = KISNullValue(resultArray, i,@"homeTeam");
                guestTeam = KISNullValue(resultArray, i,@"guestTeam");
            }
            NSString* duiZhen = KISNullValue(resultArray, i,@"letScore");
            /*
             足球胜平负玩法投注详情界面优化，当有让球的场次时将“对阵”一栏中的“VS”改为显示让球数，“比分”一栏中增加胜平负彩果信息（注：“胜平负”玩法的最终彩果信息还需要计算是否有让球）letScore
             
             篮球 大小分，VS 处 显示 预设总分 totalScore（篮球大小分 没有让分）
             */
            if([duiZhen length] == 0)
            {
                if([KISNullValue(resultArray, i,@"totalScore") length] == 0)
                    duiZhen = @"VS";
                else
                    duiZhen = KISNullValue(resultArray, i,@"totalScore");
            }
            else if([duiZhen isEqualToString:@"0"])
            {
                duiZhen = @"VS";
            }
            else
            {
                if([KISNullValue(resultArray, i,@"totalScore") length] != 0) {
                    duiZhen = [duiZhen stringByAppendingFormat:@"\n%@",KISNullValue(resultArray, i,@"totalScore")];
                }
            }
            NSString* Score;
            if ([self.jc_lotNo isEqualToString:kLotNoJCLQ_SF] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_RF] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_SFC] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_DXF] ||
                [self.jc_lotNo isEqualToString:kLotNoJCLQ_CONFUSION] )//篮球比分客在前
            {
                Score = KISNullValue(resultArray, i,@"guestScore");
                if(![Score isEqualToString:@""])
                    Score = [Score stringByAppendingFormat:@":%@",KISNullValue(resultArray, i,@"homeScore")];
            }
            else
            {
                Score = KISNullValue(resultArray, i,@"homeScore");
                if(![Score isEqualToString:@""])
                    Score = [Score stringByAppendingFormat:@":%@",KISNullValue(resultArray, i,@"guestScore")];
                
            }
            NSString* scoreResult = KISNullValue(resultArray, i,@"matchResult");
            
            NSString* betContent = KISNullValue(resultArray, i,@"betContentHtml");
            NSString* isDanMa = [KISNullValue(resultArray, i, @"isDanMa") isEqualToString:@"true"] ? @"<font color=\"brown\">(胆)</font>" : @"";
            betContent = [betContent stringByAppendingString:isDanMa];
            
            //设置字体<p></p>的行间距可使用style="line-height:3px
            NSString* touString = @"<p style=\"line-height:17px\"><font size = \"1.5\">";
            betContent = [touString stringByAppendingString:betContent];
            betContent = [betContent stringByAppendingString:@"</font></p>"];
            //            NSArray* betContentArray = [betContent componentsSeparatedByString:@"<br/>"];
            
            CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
            [bianhao drawInRect:CGRectMake(0, heightIndex + 20, 30, cellheight) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            [homeTeam drawInRect:CGRectMake(30, heightIndex + 4, 105, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            if (![duiZhen isEqualToString:@"VS"]) {
                //                CGContextSetRGBFillColor(context, 0, 1, 0, 1.0); //lv
                CGContextSetRGBFillColor(context, 32.0/255.0, 124.0/255.0, 35.0/255.0, 1.0); //lv
                if ([KISNullValue(resultArray, i,@"totalScore") length] != 0 && [KISNullValue(resultArray, i,@"letScore") length] != 0) {
                    [duiZhen drawInRect:CGRectMake(30, heightIndex + 16, 105, 30) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
                }
                else
                    [duiZhen drawInRect:CGRectMake(30, heightIndex + 21, 105, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            }
            else
            {
                CGContextSetRGBFillColor(context, 0, 0, 0, 1.0); //hei
                [duiZhen drawInRect:CGRectMake(30, heightIndex + 21, 105, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            }
            
            CGContextSetRGBFillColor(context, 0, 0, 0, 1.0); //hei
            
            [guestTeam drawInRect:CGRectMake(30, heightIndex + 41, 105, 20) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            [Score drawInRect:CGRectMake(135, heightIndex + 5, 60, cellheight) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            
            
            CGSize betSize = [betContent sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(98, 600)];//投注内容高度
            CGSize resultSize = [scoreResult sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(62, 600)];//赛果高度
            if (betSize.height > resultSize.height) {
                //                if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] && betSize.height > 400)//iPad设备算数据大于400时size总少26
                //                    currentCellHeight = betSize.height + 26;
                //                else
                currentCellHeight = betSize.height <= 65 ? CellHeight : betSize.height;
            }
            else
                currentCellHeight = resultSize.height <= 65 ? CellHeight : resultSize.height;
            
            //赛果
            if ([KISNullValue(resultArray, i, @"homeScore") isEqualToString:@""] &&
                [KISNullValue(resultArray, i, @"guestScore") isEqualToString:@""]) {
                //没有数据 或 未开赛
            }
            else
            {
                UITextView* matchResult = [[UITextView alloc] initWithFrame:CGRectMake(128, heightIndex + 20, 72, currentCellHeight - 20)];
                matchResult.text = scoreResult;
                matchResult.editable = YES;
                matchResult.delegate = self;//禁用放大镜功能
                matchResult.font = [UIFont systemFontOfSize:11];
                matchResult.showsVerticalScrollIndicator = NO;
                matchResult.backgroundColor = [UIColor clearColor];
                matchResult.contentOffset = matchResult.center;
                if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                    matchResult.textAlignment = NSTextAlignmentCenter;
                else
                    matchResult.textAlignment = UITextAlignmentCenter;
                [self addSubview:matchResult];
                [matchResult release];
            }
            
            //            if ([betContentArray count] > 3) {
            //                currentCellHeight = betContentCellHeight * [betContentArray count] + 5;
            //
            //            }
            
            UIWebView*  webView = [[UIWebView alloc] initWithFrame:CGRectMake(196, heightIndex + 2 , 105, currentCellHeight - 4)];
            [webView loadHTMLString:betContent baseURL:nil];
            [self addSubview:webView];
            webView.backgroundColor = [UIColor clearColor];
            //            webView.scrollView.backgroundColor = [UIColor clearColor];//需要5.0以上系统
            //            webView.scrollView.showsVerticalScrollIndicator = NO;
            //            webView.scrollView.scrollEnabled = NO;
            //            [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];
            
            /*for (id subview in webView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
             
             if ([[subview class] isSubclassOfClass: [UIScrollView class]])
             {
             ((UIScrollView *)subview).scrollEnabled = NO;
             ((UIScrollView *)subview).bounces = NO;
             }
             
             }*/
            [webView release];
            
            //            CGContextSetRGBFillColor(context, 1.0, 128.0/255.0, 0, 1.0); //蛋黄
            //            [isDanMa drawInRect:CGRectMake(282, heightIndex + currentCellHeight - 15, 20, 10) withFont:[UIFont systemFontOfSize:10] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
            
            //画线
            //肃
            CGContextSetRGBFillColor(context, 1.0, 128.0/255.0, 0, 1.0);
            [self drawLine:context TOPLEFTPOINT:CGPointMake(30, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(30, heightIndex + currentCellHeight)];
            [self drawLine:context TOPLEFTPOINT:CGPointMake(135, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(135, heightIndex + currentCellHeight)];
            [self drawLine:context TOPLEFTPOINT:CGPointMake(195, heightIndex) BOTTOMRIGHTPOINT:CGPointMake(195, heightIndex + currentCellHeight)];
//            //横
            [self drawLine:context TOPLEFTPOINT:CGPointMake(0, heightIndex + currentCellHeight) BOTTOMRIGHTPOINT:CGPointMake(300, heightIndex + currentCellHeight)];
            heightIndex += currentCellHeight;
            
            
            //            CGContextSetRGBFillColor(context, 1.0, 128.0/255.0, 0, 1.0); //蛋黄
            //            [@"玩法:单式<font color=\"red\">15</font>" drawInRect:CGRectMake(20, 10, 200, 50) withFont:[UIFont systemFontOfSize:10] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
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
    CGContextSetLineWidth(_context, 2);
    CGContextSetRGBStrokeColor(_context, 221.0/255.0, 221.0/255.0, 221.0/255.0, 1);

    CGContextMoveToPoint(_context, topLeftPoint.x, topLeftPoint.y);
    CGContextAddLineToPoint(_context, bottomRightPoint.x, bottomRightPoint.y);
    CGContextStrokePath(_context);
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}
//-(void) creatBetContent_html
//{
//    m_betContent_html =  [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, 300, 135)];
//    m_betContent_html.layer.masksToBounds = YES;
//    m_betContent_html.dataDetectorTypes = UIDataDetectorTypeNone;//去掉下划线
//    m_betContent_html.backgroundColor = [UIColor clearColor];
//    [self addSubview:m_betContent_html];
//
//}
@end
