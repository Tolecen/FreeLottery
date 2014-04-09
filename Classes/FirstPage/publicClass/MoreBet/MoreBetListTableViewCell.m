//
//  MoreBetListTableViewCell.m
//  RuYiCai
//
//  Created by  on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreBetListTableViewCell.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiCommon.h"

#define kLabelSize  (15)

@implementation MoreBetListTableViewCell

@synthesize betCodeStr;
@synthesize inforStr;

- (void)dealloc
{
    [redLabel release];
    [blackLabel release];
    [blueLabel release];
    [inforLabel release];
     
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        redLabel = [[UILabel alloc] init];
        redLabel.textAlignment = UITextAlignmentLeft;
        redLabel.textColor = [UIColor redColor];
        redLabel.backgroundColor = [UIColor clearColor];
        redLabel.font = [UIFont systemFontOfSize:kLabelSize];
        [self.contentView addSubview:redLabel];
        
        blackLabel = [[UILabel alloc] init];
        blackLabel.text = @"|";
        blackLabel.textAlignment = UITextAlignmentCenter;
        blackLabel.backgroundColor = [UIColor clearColor];
        blackLabel.font = [UIFont boldSystemFontOfSize:kLabelSize];
        [self.contentView addSubview:blackLabel];
        blackLabel.hidden = YES;
        
        blueLabel = [[UILabel alloc] init];
        blueLabel.textAlignment = UITextAlignmentLeft;
        blueLabel.textColor = [UIColor blueColor];
        blueLabel.backgroundColor = [UIColor clearColor];
        blueLabel.font = [UIFont systemFontOfSize:kLabelSize];
        [self.contentView addSubview:blueLabel];

        inforLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 310, 25)];
        inforLabel.textAlignment = UITextAlignmentLeft;
        inforLabel.backgroundColor = [UIColor clearColor];
        inforLabel.font = [UIFont systemFontOfSize:kLabelSize];
        [self.contentView addSubview:inforLabel];
        
    }
    return self;
}

- (void)refreshCell
{
    inforLabel.text = inforStr;
    
    if(![self.betCodeStr isEqualToString:@""])
    {
        NSArray*  betArr;
        if([[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoSSQ] ||
           [[RuYiCaiLotDetail sharedObject].lotNo isEqualToString:kLotNoDLT])
        {
           betArr = [self.betCodeStr componentsSeparatedByString:@"|"];
        }
        else
        {
            betArr = [NSArray arrayWithObject:self.betCodeStr];
        }
        CGSize redStrSize = [[betArr objectAtIndex:0] sizeWithFont:[UIFont systemFontOfSize:kLabelSize]];
        float strWidth = redStrSize.width > 315 ? 315 : redStrSize.width;
        redLabel.frame = CGRectMake(5, 0, strWidth, 25);
        blackLabel.frame = CGRectMake(5 + strWidth, 0, 5, 25);
        blueLabel.frame = CGRectMake(10 + strWidth, 0, 315 - strWidth, 25);
        
        if([betArr count] == 1)
        {
            redLabel.text = [betArr objectAtIndex:0];
            blackLabel.hidden = YES;
        }
        else if([betArr count] == 2)
        {
            redLabel.text = [betArr objectAtIndex:0];
            blueLabel.text = [betArr objectAtIndex:1];
//            if([RuYiCaiLotDetail sharedObject].isDLTOr11X2)
//            {
//                blackLabel.hidden = NO;
//            }
//            else
//            {
                blackLabel.hidden = NO;
//            }
        }
    }
}

@end
