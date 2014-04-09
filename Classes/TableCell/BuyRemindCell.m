//
//  BuyRemindCell.m
//  Boyacai
//
//  Created by qiushi on 13-5-17.
//
//

#import "BuyRemindCell.h"

@implementation BuyRemindCell
@synthesize subLable = m_subLable;
@synthesize titleLable = m_titleLable;
@synthesize accessoryImageView = m_accessoryImageView;

- (void)dealloc
{
    [m_accessoryImageView release];
    [m_titleLable release];
    [m_subLable release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 46)];
        m_accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [self addSubview:m_accessoryImageView];
        
        m_titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 25)];
        m_titleLable.font = [UIFont systemFontOfSize:15];
        m_titleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:m_titleLable];
        
        m_subLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 200,20 )];
        m_subLable.textColor = [UIColor grayColor];
        m_subLable.font = [UIFont systemFontOfSize:13];
        m_subLable.backgroundColor = [UIColor clearColor];
        [self addSubview:m_subLable];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
