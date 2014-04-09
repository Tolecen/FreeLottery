//
//  BuyRemindCell.m
//  Boyacai
//
//  Created by qiushi on 13-5-17.
//
//

#import "My_WeiBoCell.h"

@implementation My_WeiBoCell
@synthesize swith = m_swith;
@synthesize titleLable = m_titleLable;
@synthesize accessoryImageView = m_accessoryImageView;

- (void)dealloc
{
    [m_accessoryImageView release];
    [m_titleLable release];
    [m_swith release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_c_gengduo.png"]];
        bgImageView.frame = CGRectMake(0, 0, 320, 51);
        [self addSubview:bgImageView];
        [bgImageView release];

        m_accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 26, 26)];
        [self addSubview:m_accessoryImageView];
        
        m_titleLable = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 200, 20)];
        m_titleLable.font = [UIFont systemFontOfSize:15];
        m_titleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:m_titleLable];
        
        m_swith = [[UISwitch alloc] initWithFrame:CGRectMake(220, 12, 79, 27)];
        m_swith.backgroundColor = [UIColor clearColor];
        [self addSubview:m_swith];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
