//
//  BetTabelViewCell.m
//  Boyacai
//
//  Created by fengyuting on 13-10-28.
//
//

#import "BetTabelViewCell.h"

@implementation BetTabelViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_betNumberLabel release];
    [_betSumLabel release];
    [super dealloc];
}
@end
