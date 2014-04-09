//
//  TopWinnerTableViewCell.m
//  RuYiCai
//
//  Created by  on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopWinnerTableViewCell.h"

@implementation TopWinnerTableViewCell

@synthesize numImage;
@synthesize winNum;
@synthesize num;
@synthesize winName;
@synthesize numLabel;
@synthesize winNameLabel;
@synthesize winNumLabel;
@synthesize backGroundImageView = _backGroundImageView;

- (void)dealloc
{
    [numImage release];
    [numLabel release];
    [winNameLabel release];
    [winNumLabel release];
    [_backGroundImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        //背景
        self.backGroundImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_c_gengduo.png"]]autorelease];
        self.backGroundImageView.frame = CGRectMake(0, 0, 320,41);
        [self addSubview:_backGroundImageView];
        
        numImage = [[UIImageView alloc] initWithFrame:CGRectMake(3, 7, 26, 26)];
        [self addSubview:numImage];
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 20, 20)];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.textAlignment = UITextAlignmentCenter;
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.font = [UIFont boldSystemFontOfSize:15];
        [numImage addSubview:numLabel];
        
        winNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 7, 130, 26)];
        winNameLabel.textAlignment = UITextAlignmentLeft;
        winNameLabel.backgroundColor = [UIColor clearColor];
        winNameLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:winNameLabel];
        
        
        winNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 7, 100, 26)];
        winNumLabel.textAlignment = UITextAlignmentRight;
        winNumLabel.textColor = [UIColor redColor];
        winNumLabel.backgroundColor = [UIColor clearColor];
        winNumLabel.font = [UIFont boldSystemFontOfSize:15];
        
        UILabel *winlabel = [[UILabel alloc] initWithFrame:CGRectMake(297, 7, 15, 26)];
        winlabel.text = @"元";
        winlabel.textColor = [UIColor blackColor];
        [winlabel setBackgroundColor:[UIColor clearColor]];
        winlabel.textAlignment = UITextAlignmentLeft;
        winlabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:winlabel];
        [winlabel release];
        
        [self addSubview:winNumLabel];
    }
    return self;
}

- (void)refresh
{
    winNameLabel.text = [NSString stringWithFormat:@"%@",winName];
    winNumLabel.text = [NSString stringWithFormat:@"%0.2lf",[winNum doubleValue]/100];
//    numLabel.text = [NSString stringWithFormat:@"%d",num];
}



@end
