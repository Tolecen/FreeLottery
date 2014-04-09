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
-(void)dealloc
{
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
        [self.imageV setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:self.imageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 150, 20)];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.nameLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 180, 30)];
        [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.doitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doitBtn setFrame:CGRectMake(230, 25, 80, 30)];
        [self.doitBtn setBackgroundImage:[UIImage imageNamed:@"tasktodo"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.doitBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
