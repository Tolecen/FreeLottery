//
//  UserCenterTableViewCell.m
//  RuYiCai
//
//  Created by  on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserCenterTableViewCell.h"
#import "RYCImageNamed.h"
#import "CommonRecordStatus.h"
#import "ColorUtils.h"

@implementation UserCenterTableViewCell

@synthesize imageView;
@synthesize imageViewRight;

@synthesize imageName;
@synthesize title;
@synthesize titleLabel;

@synthesize isHaveImageRight;
@synthesize cellimageView;

- (void)dealloc
{
    [cellimageView release];
    [imageView release];
    [titleLabel release];
    [imageViewRight release];
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        //        cellimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 40)];
        //        [self addSubview:cellimageView];
        
        self.contentView.backgroundColor = [ColorUtils parseColorFromRGB:@"#e4e4e4"];
        
        UIImageView *lineimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
        lineimageView.image = [UIImage imageNamed: @"cell_user_Line.png"];
        [self.contentView addSubview:lineimageView];
        [lineimageView release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 25, 22)];
        [self addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 170, 40)];
        titleLabel.textAlignment = UITextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:titleLabel];
        
        imageViewRight = [[UIButton alloc] initWithFrame:CGRectMake(200 + 20, 10, 40, 23)];
        [imageViewRight setBackgroundImage:RYCImageNamed(@"fuction_new.png") forState:UIControlStateNormal];
        imageViewRight.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        [imageViewRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:imageViewRight];
        
        isHaveImageRight = NO;
        
        UIImageView *accessoryImgView = [[UIImageView alloc]initWithFrame:CGRectMake(290, 12, 8, 16)];
        [accessoryImgView setImage:[UIImage imageNamed:@"accessory_c_normal.png"]];
        [self addSubview:accessoryImgView];
        [accessoryImgView release];
        
    }
    return self;
}

- (void)refresh
{
    titleLabel.text = title;
    
    if(isHaveImageRight)
    {
        imageViewRight.hidden = NO;
        [imageViewRight setTitle:[CommonRecordStatus commonRecordStatusManager].inProgressActivityCount forState:UIControlStateNormal];
    }
    else
    {
        imageViewRight.hidden = YES;
    }
}

@end
