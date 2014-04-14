//
//  ActivityTypeOneCell.m
//  Boyacai
//
//  Created by Tolecen on 14-3-27.
//
//

#import "ActivityTypeOneCell.h"

@implementation ActivityTypeOneCell
@synthesize imageV;
@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize doitBtn;
@synthesize statusImgV;
-(void)dealloc
{
    [self.statusImgV release];
    [self.imageV release];
    [self.nameLabel release];
    [self.descriptionLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
//        [self.imageV setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.imageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 150, 20)];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel setFont:[UIFont systemFontOfSize:16]];
//        [self.nameLabel setTextColor:[UIColor grayColor]];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 150, 45)];
        [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.descriptionLabel];
        [self.descriptionLabel setFont:[UIFont systemFontOfSize:13]];
        [self.descriptionLabel setTextColor:[UIColor grayColor]];
        
        self.doitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doitBtn setFrame:CGRectMake(230, 25, 80, 30)];
        [self.doitBtn setBackgroundImage:[UIImage imageNamed:@"tasktodo"] forState:UIControlStateNormal];
        [self.doitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.doitBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:self.doitBtn];
        
        self.statusImgV = [[UIImageView alloc] initWithFrame:CGRectMake(245, 14, 62.5, 51)];
        [self.contentView addSubview:self.statusImgV];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
