//
//  NewMoreCell.m
//  Boyacai
//
//  Created by qiushi on 13-4-18.
//
//

#import "ImageNewCell.h"
#import "ColorUtils.h"

@implementation ImageNewCell

@synthesize     titleLable;
@synthesize     accessoryImageView;
@synthesize     logImageView;

- (void)dealloc
{
    [super dealloc];
    [titleLable release];
    [accessoryImageView release];
//    [logImageView release];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 42)];
        accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [self addSubview:accessoryImageView];
        logImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 26, 26)];
        [self addSubview:logImageView];
        
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 30)];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
        titleLable.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleLable];
        
             
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
