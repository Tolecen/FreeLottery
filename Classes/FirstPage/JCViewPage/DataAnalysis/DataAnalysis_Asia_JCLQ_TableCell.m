//
//  DataAnalysis_Asia_JCLQ_TableCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-12-13.
//
//

#import "DataAnalysis_Asia_JCLQ_TableCell.h"
#import "RuYiCaiCommon.h"
@implementation DataAnalysis_Asia_JCLQ_TableCell

@synthesize companyName = m_companyName;
@synthesize firstUpodds = m_firstUpodds;
@synthesize firstGoal = m_firstGoal;
@synthesize firstDownodds = m_firstDownodds;

@synthesize upOdds = m_upOdds;
@synthesize goal = m_goal;
@synthesize downOdds = m_downOdds;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //公司
        m_companyNameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
        m_companyNameLable.textAlignment = UITextAlignmentLeft;
        m_companyNameLable.backgroundColor = [UIColor clearColor];
        m_companyNameLable.font = [UIFont systemFontOfSize:15];
        m_companyNameLable.lineBreakMode = UILineBreakModeCharacterWrap;
        m_companyNameLable.numberOfLines = 2;
        [self addSubview:m_companyNameLable];
        //初盘
        m_letGoals_firstLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 100, 30)];
        m_letGoals_firstLable.textAlignment = UITextAlignmentCenter;
        m_letGoals_firstLable.backgroundColor = [UIColor clearColor];
        m_letGoals_firstLable.text = @"初盘";
        m_letGoals_firstLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_letGoals_firstLable];
 
        m_firstUpoddsLable = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 30, 20)];
        m_firstUpoddsLable.textAlignment = UITextAlignmentCenter;
        m_firstUpoddsLable.backgroundColor = [UIColor clearColor];
        m_firstUpoddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_firstUpoddsLable];
        
        m_firstGoalLable = [[UILabel alloc] initWithFrame:CGRectMake(90 + 30 + 10, 10, 35, 20)];
        m_firstGoalLable.textAlignment = UITextAlignmentCenter;
        m_firstGoalLable.backgroundColor = [UIColor clearColor];
        m_firstGoalLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_firstGoalLable];
 
        m_firstDownoddsLable = [[UILabel alloc] initWithFrame:CGRectMake(95 + 10 + 30 * 2, 10, 30, 20)];
        m_firstDownoddsLable.textAlignment = UITextAlignmentCenter;
        m_firstDownoddsLable.backgroundColor = [UIColor clearColor];
        m_firstDownoddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_firstDownoddsLable];
        
        //即时盘
        m_letGoals_goalLable = [[UILabel alloc] initWithFrame:CGRectMake(215, 5, 100, 30)];
        m_letGoals_goalLable.textAlignment = UITextAlignmentCenter;
        m_letGoals_goalLable.backgroundColor = [UIColor clearColor];
        m_letGoals_goalLable.text = @"即时盘";
        m_letGoals_goalLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_letGoals_goalLable];
        
        m_upOddsLable = [[UILabel alloc] initWithFrame:CGRectMake(215, 10, 30, 20)];
        m_upOddsLable.textAlignment = UITextAlignmentCenter;
        m_upOddsLable.backgroundColor = [UIColor clearColor];
        m_upOddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_upOddsLable];
        
        m_goalLable = [[UILabel alloc] initWithFrame:CGRectMake(220 + 30 , 10, 35, 20)];
        m_goalLable.textAlignment = UITextAlignmentCenter;
        m_goalLable.backgroundColor = [UIColor clearColor];
        m_goalLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_goalLable];
        
        m_downOddsLable = [[UILabel alloc] initWithFrame:CGRectMake(225 + 60, 10, 30, 20)];
        m_downOddsLable.textAlignment = UITextAlignmentCenter;
        m_downOddsLable.backgroundColor = [UIColor clearColor];
        m_downOddsLable.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_downOddsLable];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) refreshTableCell
{
    if (self.tag == 0)
    {
        m_companyNameLable.text = @"公司";
        
        m_letGoals_firstLable.hidden = NO;
        m_letGoals_goalLable.hidden = NO;
        
        m_firstUpoddsLable.text = @"初盘胜水位";
        m_firstGoalLable.text = @"初盘亚盘";
        m_firstDownoddsLable.text = @"初盘负水位";
        
        m_firstUpoddsLable.hidden = YES;
        m_firstGoalLable.hidden = YES;
        m_firstDownoddsLable.hidden = YES;
        
        m_upOddsLable.text = @"即时受注盘胜水位";
        m_goalLable.text = @"即时受注盘亚盘";
        m_downOddsLable.text = @"即时受注盘负水位";
     
        m_upOddsLable.hidden = YES;
        m_goalLable.hidden = YES;
        m_downOddsLable.hidden = YES;
    }
    else
    {
        m_letGoals_firstLable.hidden = YES;
        m_letGoals_goalLable.hidden = YES;
        
        m_firstUpoddsLable.hidden = NO;
        m_firstGoalLable.hidden = NO;
        m_firstDownoddsLable.hidden = NO;
        
        m_upOddsLable.hidden = NO;
        m_goalLable.hidden = NO;
        m_downOddsLable.hidden = NO;
        
        m_companyNameLable.text = m_companyName;
        
        m_firstUpoddsLable.text = m_firstUpodds;
        m_firstGoalLable.text = m_firstGoal;
        m_firstDownoddsLable.text = m_firstDownodds;
        
        m_upOddsLable.text = m_upOdds;
        m_goalLable.text = m_goal;
        m_downOddsLable.text = m_downOdds;
    }
    
}

- (void)dealloc
{
    [m_companyNameLable release];
    [m_letGoals_firstLable release];
    [m_letGoals_goalLable release];
    [m_firstUpoddsLable release];
    [m_firstGoalLable release];
    [m_firstDownoddsLable release];
    [m_upOddsLable release];
    [m_goalLable release];
    [m_downOddsLable release];
 
    [super dealloc];
}
@end