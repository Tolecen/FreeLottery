//
//  ActivityTypeTwoCell.m
//  Boyacai
//
//  Created by Tolecen on 14-3-27.
//
//

#import "ActivityTypeTwoCell.h"

@implementation ActivityTypeTwoCell
@synthesize nameLabel;
@synthesize tLabel;
@synthesize progressLabel;
@synthesize imgV;
@synthesize timeLabel;
-(void)dealloc
{
    [self.nameLabel release];
    [self.tLabel release];
    [self.progressLabel release];
    [self.imgV release];
    [self.timeLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.nameLabel];
        
        self.tLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 80, 30)];
        [self.tLabel setBackgroundColor:[UIColor clearColor]];
        [self.tLabel setText:@"任务进度:"];
        [self.tLabel setTextColor:[UIColor redColor]];
        [self.tLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:self.tLabel];
        
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 150, 30)];
        [self.progressLabel setBackgroundColor:[UIColor clearColor]];
        [self.progressLabel setText:@"5000/6000"];
        [self.progressLabel setTextColor:[UIColor redColor]];
        [self.progressLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:self.progressLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 40, 80, 30)];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setText:@"4天23时23分"];
        [self.timeLabel setTextColor:[UIColor grayColor]];
        [self.timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.timeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.timeLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.timeLabel];


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
