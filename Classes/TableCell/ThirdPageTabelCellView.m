//
//  ThirdPageTabelCellView.m
//  RuYiCai
//
//  Created by  on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThirdPageTabelCellView.h"
#import "RYCImageNamed.h"

@implementation ThirdPageTabelCellView
@synthesize titleLabel = m_titleLabel;
@synthesize littleTitleLabel = m_littleTitleLabel;
@synthesize iconImageName = m_iconImageName;
@synthesize titleName = m_titleName;
@synthesize littleTitleName = m_littleTitleName;

- (void)dealloc
{
    [m_icoImageView release];
    [m_titleLabel release];
    [m_littleTitleLabel release];
    [m_oneLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        m_icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 10, 60, 45)];
        [self addSubview:m_icoImageView];
        
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 140, 48)];
        m_titleLabel.textAlignment = UITextAlignmentLeft;
        m_titleLabel.backgroundColor = [UIColor clearColor];
        m_titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:m_titleLabel];
        
        m_littleTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 25, 250, 48)];
        m_littleTitleLabel.textAlignment = UITextAlignmentLeft;
        m_littleTitleLabel.textColor = [UIColor colorWithRed:131.0/255.0 green:131.0/255.0 blue:131.0/255.0 alpha:1.0];
        m_littleTitleLabel.backgroundColor = [UIColor clearColor];
        m_littleTitleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:m_littleTitleLabel];
        
        m_oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(m_titleLabel.frame.origin.x + m_titleLabel.frame.size.width, 0, 150, 48)];
        m_oneLabel.textAlignment = UITextAlignmentLeft;
        m_oneLabel.backgroundColor = [UIColor clearColor];
        m_oneLabel.font = [UIFont systemFontOfSize:18];
        [m_oneLabel setTextColor:[UIColor colorWithRed:191.0/255.0 green:1.0/255.0 blue:0 alpha:1.0]];
        [self addSubview:m_oneLabel];
        m_oneLabel.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{    
    [super setSelected:selected animated:animated];
}

- (void)refresh
{
    m_icoImageView.image = RYCImageNamed(self.iconImageName);
    NSArray* titleArr = [self.titleName componentsSeparatedByString:@"("];
    if([titleArr count] > 1)
    {
        m_oneLabel.hidden = NO;
        m_oneLabel.text = [NSString stringWithFormat:@"(%@",[titleArr objectAtIndex:1]];        
        m_titleLabel.text = [titleArr objectAtIndex:0];
    }
    else
    {
        m_oneLabel.hidden = YES;
        m_titleLabel.frame = CGRectMake(68, 0, 250, 48);
        m_titleLabel.text = self.titleName;
        m_titleLabel.font = [UIFont systemFontOfSize:18];
    }
    m_littleTitleLabel.text = self.littleTitleName;
}


@end
