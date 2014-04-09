//
//  LoadView.m
//  RuYiCai
//
//  Created by  on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {	
//        self.frame = CGRectMake(110, 150, 90, 90);
//        self.alpha = 0.7f;
//        self.backgroundColor = [UIColor blackColor];
//        self.layer.cornerRadius = 8;
        self.frame = CGRectMake(0, 0, 320, 416);
        self.backgroundColor = [UIColor clearColor];
        
        UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        bgView.alpha = 0.6f;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.cornerRadius = 8;
        [self addSubview:bgView];
        [bgView release];

        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //        activityView.frame = CGRectMake(20.0f, 20.0f, 60.0f, 60.0f);
        activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 10);
        [self addSubview:activityView];
        [activityView startAnimating];
        [activityView release];
        
        UILabel*  titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        titleLabel.text = @"加载中⋯⋯";
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.center = CGPointMake(activityView.center.x, activityView.center.y + 35);
        [self addSubview:titleLabel];
        [titleLabel release];
    }
    return self;
}

@end
