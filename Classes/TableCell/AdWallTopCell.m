//
//  AdWallTopCell.m
//  Boyacai
//
//  Created by Tolecen on 14-3-7.
//
//

#import "AdWallTopCell.h"

@implementation AdWallTopCell
@synthesize titleLabel,remainMoneyLabel,disLabel,detailBtn;
-(void)dealloc
{
    [self.disLabel release];
    [self.remainMoneyLabel release];
    [self.titleLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        UILabel * ttt = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        [ttt setBackgroundColor:[UIColor clearColor]];
        [ttt setFont:[UIFont systemFontOfSize:14]];
        [ttt setTextColor:[UIColor blackColor]];
        [ttt setText:@"做任务获取彩豆，0投入0风险，千万大奖等你拿"];
        [self addSubview:ttt];
        [ttt release];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 65, 20)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        self.titleLabel.text = @"您的彩豆:";
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.titleLabel];
        [self.titleLabel release];
        
        self.remainMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 35, 128, 30)];
        [self.remainMoneyLabel setBackgroundColor:[UIColor clearColor]];
        [self.remainMoneyLabel setFont:[UIFont boldSystemFontOfSize:19]];
        [self.remainMoneyLabel setTextColor:[UIColor redColor]];
        [self.remainMoneyLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.remainMoneyLabel];
        [self.remainMoneyLabel release];
        
        self.disLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 40, 150, 20)];
        [self.disLabel setBackgroundColor:[UIColor clearColor]];
        self.disLabel.textColor = [UIColor grayColor];
        [self.disLabel setFont:[UIFont systemFontOfSize:15]];
        self.disLabel.text = @"";
        [self addSubview:self.disLabel];
        [self.disLabel release];
//        self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.detailBtn setFrame:CGRectMake(260, 5, 40, 40)];
//        [self.detailBtn setImage:[UIImage imageNamed:@"whatthat2"] forState:UIControlStateNormal];
//        [self addSubview:self.detailBtn];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
