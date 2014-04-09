//
//  LeaveMessageView.m
//  RuYiCai
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeaveMessageView.h"

@implementation LeaveMessageView

@synthesize creatTime;
@synthesize content;

- (void)dealloc
{
    [timeLabel release];
    [contentLabel release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
        myLabel.textAlignment = UITextAlignmentLeft;
        myLabel.text = @"我的留言";
        [myLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:myLabel];
        [myLabel release];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 120, 30)];
        [timeLabel setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]];
        timeLabel.textAlignment = UITextAlignmentRight;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:timeLabel];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 280, 60)];
        contentLabel.textAlignment = UITextAlignmentLeft;
        contentLabel.lineBreakMode = UILineBreakModeTailTruncation;
        contentLabel.numberOfLines = 2;
        [contentLabel setTextColor:[UIColor colorWithRed:0 green:102.0/255.0 blue:204.0/255.0 alpha:1.0]];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:contentLabel];
	}
    return self;
}

- (void)refreshView
{
    timeLabel.text = creatTime;
    contentLabel.text = content;
}

@end
