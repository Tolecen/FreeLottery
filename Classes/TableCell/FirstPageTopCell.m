//
//  FirstPageTopCell.m
//  Boyacai
//
//  Created by Tolecen on 14-3-13.
//
//

#import "FirstPageTopCell.h"

@implementation FirstPageTopCell
@synthesize titleLabel;
-(void)dealloc
{
    [self.titleLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
