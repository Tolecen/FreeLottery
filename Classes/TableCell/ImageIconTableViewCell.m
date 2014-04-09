//
//  ImageIconTableViewCell.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageIconTableViewCell.h"
#import "RYCImageNamed.h"

@implementation ImageIconTableViewCell

@synthesize iconImageName = m_iconImageName;
@synthesize titleName = m_titleName;

- (void)dealloc
{
    [m_icoImageView release];
    [m_titleLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        m_icoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
        [self addSubview:m_icoImageView];
        
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 10, 250, 48)];
        m_titleLabel.textAlignment = UITextAlignmentLeft;
        m_titleLabel.backgroundColor = [UIColor clearColor];
        m_titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:m_titleLabel];
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

    m_titleLabel.text = self.titleName;
}

@end