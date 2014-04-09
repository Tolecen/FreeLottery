//
//  DataAnalysis_Asia_TableCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-12-13.
//
//

#import "DataAnalysis_Asia_TableCell.h"
#import "RuYiCaiCommon.h"
@implementation DataAnalysis_Asia_TableCell

@synthesize companyName = m_companyName;
@synthesize firstUpodds = m_firstUpodds;
@synthesize firstGoal = m_firstGoal;
@synthesize firstDownodds = m_firstDownodds;

@synthesize upOdds = m_upOdds;
@synthesize goal = m_goal;
@synthesize downOdds = m_downOdds;
@synthesize isJCLQ;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel* titleLable_one = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, 50, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            titleLable_one.textAlignment = NSTextAlignmentCenter;
        else
            titleLable_one.textAlignment = UITextAlignmentCenter;
        titleLable_one.backgroundColor = [UIColor clearColor];
        titleLable_one.text = @"初盘";
        titleLable_one.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLable_one];
        [titleLable_one release];
        
        UILabel* titleLable_two = [[UILabel alloc] initWithFrame:CGRectMake(48, 35, 50, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            titleLable_two.textAlignment = NSTextAlignmentCenter;
        else
            titleLable_two.textAlignment = UITextAlignmentCenter;
        titleLable_two.backgroundColor = [UIColor clearColor];
        titleLable_two.text = @"即时盘";
        titleLable_two.font = [UIFont systemFontOfSize:12];
        [self addSubview:titleLable_two];
        [titleLable_two release];

        // Initialization code
        //公司
        m_companyNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 40)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            m_companyNameLable.textAlignment = NSTextAlignmentCenter;
        else
            m_companyNameLable.textAlignment = UITextAlignmentCenter;
        m_companyNameLable.backgroundColor = [UIColor clearColor];
        m_companyNameLable.font = [UIFont systemFontOfSize:12];
        m_companyNameLable.lineBreakMode = UILineBreakModeCharacterWrap;
        m_companyNameLable.numberOfLines = 2;
        [self addSubview:m_companyNameLable];
        //初盘
 
        m_firstUpoddsLable = [[UILabel alloc] initWithFrame:CGRectMake(98, 0, 74, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            m_firstUpoddsLable.textAlignment = NSTextAlignmentCenter;
        else
            m_firstUpoddsLable.textAlignment = UITextAlignmentCenter;
        m_firstUpoddsLable.backgroundColor = [UIColor clearColor];
        m_firstUpoddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_firstUpoddsLable];
        
        m_firstGoalLable = [[UILabel alloc] initWithFrame:CGRectMake(172, 0, 74, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            m_firstGoalLable.textAlignment = NSTextAlignmentCenter;
        else
            m_firstGoalLable.textAlignment = UITextAlignmentCenter;
        m_firstGoalLable.backgroundColor = [UIColor clearColor];
        m_firstGoalLable.numberOfLines = 0;
        m_firstGoalLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_firstGoalLable];
 
        m_firstDownoddsLable = [[UILabel alloc] initWithFrame:CGRectMake(246, 0, 74, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            m_firstDownoddsLable.textAlignment = NSTextAlignmentCenter;
        else
            m_firstDownoddsLable.textAlignment = UITextAlignmentCenter;
        m_firstDownoddsLable.backgroundColor = [UIColor clearColor];
        m_firstDownoddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_firstDownoddsLable];
        
        //即时盘
        m_upOddsLable = [[UILabel alloc] initWithFrame:CGRectMake(98, 35, 74, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            m_upOddsLable.textAlignment = NSTextAlignmentCenter;
        else
            m_upOddsLable.textAlignment = UITextAlignmentCenter;
        m_upOddsLable.backgroundColor = [UIColor clearColor];
        m_upOddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_upOddsLable];
        
        m_goalLable = [[UILabel alloc] initWithFrame:CGRectMake(172 , 35, 74, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            m_goalLable.textAlignment = NSTextAlignmentCenter;
        else
            m_goalLable.textAlignment = UITextAlignmentCenter;
        m_goalLable.numberOfLines = 2;
        m_goalLable.backgroundColor = [UIColor clearColor];
        m_goalLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_goalLable];
        
        m_downOddsLable = [[UILabel alloc] initWithFrame:CGRectMake(246, 35, 74, 35)];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
            m_downOddsLable.textAlignment = NSTextAlignmentCenter;
        else
            m_downOddsLable.textAlignment = UITextAlignmentCenter;
        m_downOddsLable.backgroundColor = [UIColor clearColor];
        m_downOddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_downOddsLable];
        
        self.isJCLQ = NO;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext(); //画布
    
    CGContextSetRGBStrokeColor(context, 205.0/255.0, 204.0/255.0, 202.0/255.0, 1.0); //笔色
	CGContextSetLineWidth(context, 0.9); //线宽
    drawLine(context, CGPointMake(48.0, 0.0), CGPointMake(48.0, 70.0));
    drawLine(context, CGPointMake(98.0, 0.0), CGPointMake(98.0, 70.0));
    drawLine(context, CGPointMake(172.0, 0.0), CGPointMake(172.0, 70.0));
    drawLine(context, CGPointMake(246.0, 0.0), CGPointMake(246.0, 70.0));//竖
    
    drawLine(context, CGPointMake(48.0, 35.0), CGPointMake(320.0, 35.0));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) refreshTableCell
{
    m_companyNameLable.font = [UIFont systemFontOfSize:12];

    m_firstUpoddsLable.hidden = NO;
    m_firstGoalLable.hidden = NO;
    m_firstDownoddsLable.hidden = NO;
    
    m_upOddsLable.hidden = NO;
    m_goalLable.hidden = NO;
    m_downOddsLable.hidden = NO;
    
    m_companyNameLable.text = m_companyName;
    
    m_firstGoalLable.text = m_firstGoal;
    m_goalLable.text = m_goal;

    if (self.isJCLQ) {//篮球仅让分主在后   总分在前进入else
        m_firstUpoddsLable.text = m_firstDownodds;
        m_firstDownoddsLable.text = m_firstUpodds;
        
        m_upOddsLable.text = m_downOdds;
        m_downOddsLable.text = m_upOdds;
    }
    else
    {
        m_firstUpoddsLable.text = m_firstUpodds;
        m_firstDownoddsLable.text = m_firstDownodds;
        
        m_upOddsLable.text = m_upOdds;
        m_downOddsLable.text = m_downOdds;
    }
}

- (void)dealloc
{
    [m_companyNameLable release];
    [m_firstUpoddsLable release];
    [m_firstGoalLable release];
    [m_firstDownoddsLable release];
    [m_upOddsLable release];
    [m_goalLable release];
    [m_downOddsLable release];
 
    [super dealloc];
}
@end