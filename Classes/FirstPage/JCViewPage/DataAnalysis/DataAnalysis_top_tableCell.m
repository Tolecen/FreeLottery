//
//  DataAnalysis_top_tableCell.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 13-4-18.
//
//

#import "DataAnalysis_top_tableCell.h"
#import "RuYiCaiCommon.h"

@implementation DataAnalysis_top_tableCell

@synthesize topType;
@synthesize isJCLQ;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布
   
    CGContextSetRGBStrokeColor(context, 205.0/255.0, 204.0/255.0, 202.0/255.0, 1.0); //笔色
	CGContextSetLineWidth(context, 0.9); //线宽

    drawRec(context, CGRectMake(0 , 0, 320, 34), [UIColor colorWithRed:255.0/255.0 green:238.0/255.0 blue:225.0/255.0 alpha:1.0]);
    CGContextDrawPath(context,kCGPathFillStroke);

    drawLine(context, CGPointMake(98.0, 0.0), CGPointMake(98.0, 34.0));
     
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0); //黑
    [@"公司" drawAtPoint:CGPointMake(35, 8) withFont:[UIFont boldSystemFontOfSize:15]];
    if (TOPCELL_EUROP == self.topType) {//欧指
        if (self.isJCLQ) {
            drawLine(context, CGPointMake(173.0, 0.0), CGPointMake(173.0, 34.0));
        }
        else
        {
            drawLine(context, CGPointMake(148.0, 0.0), CGPointMake(148.0, 34.0));
            drawLine(context, CGPointMake(198.0, 0.0), CGPointMake(198.0, 34.0));
        }
        drawLine(context, CGPointMake(248.0, 0.0), CGPointMake(248.0, 34.0));
        
         if (self.isJCLQ) {
             [@"客胜" drawAtPoint:CGPointMake(120, 8) withFont:[UIFont boldSystemFontOfSize:15]];
             [@"主胜" drawAtPoint:CGPointMake(195, 8) withFont:[UIFont boldSystemFontOfSize:15]];
         }
        else
        {
            [@"胜" drawAtPoint:CGPointMake(115, 8) withFont:[UIFont boldSystemFontOfSize:15]];
            [@"平" drawAtPoint:CGPointMake(165, 8) withFont:[UIFont boldSystemFontOfSize:15]];
            [@"负" drawAtPoint:CGPointMake(215, 8) withFont:[UIFont boldSystemFontOfSize:15]];
        }
        [@"返还率" drawAtPoint:CGPointMake(265, 8) withFont:[UIFont boldSystemFontOfSize:15]];
    }
    else if(TOPCELL_ASIA == self.topType)//足球亚盘
    {
        drawLine(context, CGPointMake(172.0, 0.0), CGPointMake(172.0, 34.0));
        drawLine(context, CGPointMake(246.0, 0.0), CGPointMake(246.0, 34.0));
        
        [@"主水位" drawAtPoint:CGPointMake(113, 8) withFont:[UIFont boldSystemFontOfSize:15]];
        [@"让球" drawAtPoint:CGPointMake(197, 8) withFont:[UIFont boldSystemFontOfSize:15]];
        [@"客水位" drawAtPoint:CGPointMake(261, 8) withFont:[UIFont boldSystemFontOfSize:15]];
    }
    else if(TOPTYPE_RANGFEN == self.topType)//篮球让分
    {
        drawLine(context, CGPointMake(172.0, 0.0), CGPointMake(172.0, 34.0));
        drawLine(context, CGPointMake(246.0, 0.0), CGPointMake(246.0, 34.0));
        
        [@"客队" drawAtPoint:CGPointMake(123, 8) withFont:[UIFont boldSystemFontOfSize:15]];
        [@"让分" drawAtPoint:CGPointMake(197, 8) withFont:[UIFont boldSystemFontOfSize:15]];
        [@"主队" drawAtPoint:CGPointMake(271, 8) withFont:[UIFont boldSystemFontOfSize:15]];
    }
    else if(TOPTYPE_ALLSCORE == self.topType)//篮球总分
    {
        drawLine(context, CGPointMake(172.0, 0.0), CGPointMake(172.0, 34.0));
        drawLine(context, CGPointMake(246.0, 0.0), CGPointMake(246.0, 34.0));
        
        [@"大球" drawAtPoint:CGPointMake(123, 8) withFont:[UIFont boldSystemFontOfSize:15]];
        [@"总分" drawAtPoint:CGPointMake(197, 8) withFont:[UIFont boldSystemFontOfSize:15]];
        [@"小球" drawAtPoint:CGPointMake(271, 8) withFont:[UIFont boldSystemFontOfSize:15]];
    }
}
@end
