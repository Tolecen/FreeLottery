//
//  NewMoreCell.m
//  Boyacai
//
//  Created by qiushi on 13-4-18.
//
//

#import "NewMoreCell.h"
#import "ColorUtils.h"

@implementation NewMoreCell
@synthesize     titleLable;
@synthesize     accessoryImageView;
@synthesize     numberLable;
@synthesize     subLable;

- (void)dealloc
{
    [super dealloc];
    [titleLable release];
    [accessoryImageView release];
    [numberLable release];
    [subLable release];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 42)];
        accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [self addSubview:accessoryImageView];
        self.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 250, 30)];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
        titleLable.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleLable];
        
        numberLable = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 200, 30)];
        numberLable.backgroundColor = [UIColor clearColor];
        numberLable.textColor = [ColorUtils parseColorFromRGB:@"#c80000"];
        numberLable.font = [UIFont systemFontOfSize:16];
        [self addSubview:numberLable];
        
        subLable = [[UILabel alloc] initWithFrame:CGRectMake(150, 18, 200, 30)];
        subLable.backgroundColor = [UIColor clearColor];
        subLable.textColor = [ColorUtils parseColorFromRGB:@"#989898"];
        subLable.font = [UIFont systemFontOfSize:10];
        [self addSubview:subLable];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 12, 8, 16)];
        imageView.image = [UIImage imageNamed:@"accessory_c_normal.png"];
        [self addSubview:imageView];
        [imageView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
