//
//  DataAnalysis_Europ_TableCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataAnalysis_Europ_TableCell.h"
#import "RuYiCaiCommon.h"

@implementation DataAnalysis_Europ_TableCell
@synthesize isJCLQ = m_isJCLQ;
@synthesize companyName = m_companyName;
@synthesize homeWinLu = m_homeWinLu;
@synthesize standoffLu = m_standoffLu;
@synthesize guestWinLu = m_guestWinLu;

@synthesize homeWin = m_homeWin;
@synthesize standoff = m_standoff;
@synthesize guestWin = m_guestWin;

@synthesize k_h = m_k_h;
@synthesize k_s = m_k_s;
@synthesize k_g = m_k_g;
@synthesize fanHuanLu = m_fanHuanLu;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel* titleLable_one = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 50, 20)];
        titleLable_one.textAlignment = UITextAlignmentCenter;
        titleLable_one.backgroundColor = [UIColor clearColor];
        titleLable_one.text = @"赔率";
        titleLable_one.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLable_one];
        [titleLable_one release];
        
        UILabel* titleLable_two = [[UILabel alloc] initWithFrame:CGRectMake(48, 20, 50, 20)];
        titleLable_two.textAlignment = UITextAlignmentCenter;
        titleLable_two.backgroundColor = [UIColor clearColor];
        titleLable_two.text = @"概率";
        titleLable_two.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLable_two];
        [titleLable_two release];
        
        UILabel* titleLable_there = [[UILabel alloc] initWithFrame:CGRectMake(48, 40, 50, 20)];
        titleLable_there.textAlignment = UITextAlignmentCenter;
        titleLable_there.backgroundColor = [UIColor clearColor];
        titleLable_there.text = @"凯利指数";
        titleLable_there.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLable_there];
        [titleLable_there release];
        
        // Initialization code
        //公司
        m_companyNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 60)];
        m_companyNameLable.textAlignment = UITextAlignmentCenter;
        m_companyNameLable.backgroundColor = [UIColor clearColor];
        m_companyNameLable.font = [UIFont systemFontOfSize:12];
        m_companyNameLable.lineBreakMode = UILineBreakModeWordWrap;
        m_companyNameLable.numberOfLines = 0;
        [self addSubview:m_companyNameLable];
        
        //胜平负
        m_homeWinLable = [[UILabel alloc] initWithFrame:CGRectMake(98, 0, 50, 20)];
        m_homeWinLable.textAlignment = UITextAlignmentCenter;
        m_homeWinLable.backgroundColor = [UIColor clearColor];
        m_homeWinLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_homeWinLable];
        
        m_standoffLable = [[UILabel alloc] initWithFrame:CGRectMake(148, 0, 50, 20)];
        m_standoffLable.textAlignment = UITextAlignmentCenter;
        m_standoffLable.backgroundColor = [UIColor clearColor];
        m_standoffLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_standoffLable];
        
        m_guestWinLable = [[UILabel alloc] initWithFrame:CGRectMake(198, 0, 50, 20)];
        m_guestWinLable.textAlignment = UITextAlignmentCenter;
        m_guestWinLable.backgroundColor = [UIColor clearColor];
        m_guestWinLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_guestWinLable];
        
        
        // 
        m_homeWinLuLable = [[UILabel alloc] initWithFrame:CGRectMake(98, 20, 50, 20)];
        m_homeWinLuLable.textAlignment = UITextAlignmentCenter;
        m_homeWinLuLable.backgroundColor = [UIColor clearColor];
        m_homeWinLuLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_homeWinLuLable];
        
        m_standoffLuLable = [[UILabel alloc] initWithFrame:CGRectMake(148, 20, 50, 20)];
        m_standoffLuLable.textAlignment = UITextAlignmentCenter;
        m_standoffLuLable.backgroundColor = [UIColor clearColor];
        m_standoffLuLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_standoffLuLable];
 
        m_guestWinLuLable = [[UILabel alloc] initWithFrame:CGRectMake(198, 20, 50, 20)];
        m_guestWinLuLable.textAlignment = UITextAlignmentCenter;
        m_guestWinLuLable.backgroundColor = [UIColor clearColor];
        m_guestWinLuLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_guestWinLuLable];
            
        //凯利指数
        m_k_hLable = [[UILabel alloc] initWithFrame:CGRectMake(98, 40, 50, 20)];
        m_k_hLable.textAlignment = UITextAlignmentCenter;
        m_k_hLable.backgroundColor = [UIColor clearColor];
        m_k_hLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_k_hLable];
        
        m_k_sLable = [[UILabel alloc] initWithFrame:CGRectMake(148, 40, 50, 20)];
        m_k_sLable.textAlignment = UITextAlignmentCenter;
        m_k_sLable.backgroundColor = [UIColor clearColor];
        m_k_sLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_k_sLable];
 
        m_k_gLable = [[UILabel alloc] initWithFrame:CGRectMake(198, 40, 50, 20)];
        m_k_gLable.textAlignment = UITextAlignmentCenter;
        m_k_gLable.backgroundColor = [UIColor clearColor];
        m_k_gLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_k_gLable];
   
        m_fanHuanLuLable = [[UILabel alloc] initWithFrame:CGRectMake(248, 0, 72, 60)];
        m_fanHuanLuLable.textAlignment = UITextAlignmentCenter;
        m_fanHuanLuLable.backgroundColor = [UIColor clearColor];
        m_fanHuanLuLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_fanHuanLuLable];
        
        self.indentationWidth = 20;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布
    
    CGContextSetRGBStrokeColor(context, 205.0/255.0, 204.0/255.0, 202.0/255.0, 1.0); //笔色
	CGContextSetLineWidth(context, 0.9); //线宽
    drawLine(context, CGPointMake(48.0, 0.0), CGPointMake(48.0, 60.0));
    drawLine(context, CGPointMake(98.0, 0.0), CGPointMake(98.0, 60.0));
    if (self.isJCLQ) {
        drawLine(context, CGPointMake(173.0, 0.0), CGPointMake(173.0, 60.0));
    }
    else{
        drawLine(context, CGPointMake(148.0, 0.0), CGPointMake(148.0, 60.0));
        drawLine(context, CGPointMake(198.0, 0.0), CGPointMake(198.0, 60.0));
    }
    drawLine(context, CGPointMake(248.0, 0.0), CGPointMake(248.0, 60.0));//竖
    
    drawLine(context, CGPointMake(48.0, 20.0), CGPointMake(248.0, 20.0));
    drawLine(context, CGPointMake(48.0, 40.0), CGPointMake(248.0, 40.0));//横
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) refreshTableCell
{
    m_companyNameLable.text = m_companyName;

    m_homeWinLable.text = m_homeWin;
    m_standoffLable.text = m_standoff;
    m_guestWinLable.text = m_guestWin;
    
    m_homeWinLuLable.text = m_homeWinLu;
    m_standoffLuLable.text = m_standoffLu;
    m_guestWinLuLable.text = m_guestWinLu;
    
    m_k_hLable.text = m_k_h;
    m_k_sLable.text = m_k_s;
    m_k_gLable.text = m_k_g;

    if (self.isJCLQ) {
        m_standoffLable.hidden = YES;
        m_standoffLuLable.hidden = YES;
        m_k_sLable.hidden = YES;
        
        m_homeWinLable.frame = CGRectMake(173, 0, 75, 20);
        m_guestWinLable.frame = CGRectMake(98, 0, 75, 20);
        m_homeWinLuLable.frame = CGRectMake(173, 20, 75, 20);
        m_guestWinLuLable.frame = CGRectMake(98, 20, 75, 20);
        m_k_hLable.frame = CGRectMake(173, 40, 75, 20);
        m_k_gLable.frame = CGRectMake(98, 40, 75, 20);
    }

    m_fanHuanLuLable.text = m_fanHuanLu;
}

- (void)dealloc
{
    [m_companyNameLable release];
    [m_homeWinLable release];
    [m_standoffLable release];
    [m_guestWinLable release];
    
    [m_homeWinLuLable release];
    [m_standoffLuLable release];
    [m_guestWinLuLable release];
    [m_k_hLable release];
    [m_k_sLable release];
    [m_k_gLable release];
    [m_fanHuanLuLable release];
 
    [super dealloc];
}

@end
