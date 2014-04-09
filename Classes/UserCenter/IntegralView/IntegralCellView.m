//
//  IntegralCellView.m
//  RuYiCai
//
//  Created by  on 12-3-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IntegralCellView.h"

@implementation IntegralCellView

@synthesize title = m_title;
@synthesize score = m_score;
@synthesize time = m_time;
@synthesize blsign = m_blsign;

- (void)dealloc
{
    
    [titleLabel release];
    [scoreLabel release];
    [timeLabel release];

    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        m_title = @"";
        m_score = @"";
        m_time = @"";
        m_blsign = @"";
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
        [titleLabel setTextColor:[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0]];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:titleLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        [timeLabel setTextColor:[UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0]];
        timeLabel.textAlignment = UITextAlignmentLeft;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:timeLabel];
        
        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 92, 30)];
        scoreLabel.textAlignment = UITextAlignmentRight;
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:scoreLabel];
        
	}
    return self;
}

- (void)refreshView
{
    titleLabel.text = self.title;
    timeLabel.text = self.time;
    if([self.blsign isEqualToString:@"-1"])
    {
        [scoreLabel setTextColor:[UIColor colorWithRed:32.0/255.0 green:124.0/255.0 blue:35.0/255.0 alpha:1.0]];
        scoreLabel.text = [NSString stringWithFormat:@"－%@", self.score];
    }
    else if([self.blsign isEqualToString:@"1"])
    {
        [scoreLabel setTextColor:[UIColor colorWithRed:196.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
        scoreLabel.text = [NSString stringWithFormat:@"＋%@", self.score];
    }
}

@end
