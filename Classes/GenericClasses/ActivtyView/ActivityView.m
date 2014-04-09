//
//  ActivityView.m
//  RuYiCai
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView
@synthesize titleLabel;
- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self)
    {	
//        self.frame = CGRectMake(110, 150, 100, 100);
//        self.alpha = 0.7f;
//        self.backgroundColor = [UIColor blackColor];
//        self.layer.cornerRadius = 8;
        
        self.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
        self.backgroundColor = [UIColor clearColor];

        UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        bgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        bgView.alpha = 0.6f;
        bgView.backgroundColor = [UIColor blackColor];
        bgView.layer.cornerRadius = 8;
        [self addSubview:bgView];
        [bgView release];
        
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"delenew"] forState:UIControlStateNormal];
        //        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setFrame:CGRectMake(60, 0, 30, 30)];
        [bgView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(disActivityView) forControlEvents:UIControlEventTouchUpInside];
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        activityView.frame = CGRectMake(20.0f, 20.0f, 60.0f, 60.0f);
        activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 10);
        [self addSubview:activityView];
        [activityView startAnimating];
                
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        self.titleLabel.text = @"加载中...";
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.center = CGPointMake(activityView.center.x, activityView.center.y + 35);
        [self addSubview:self.titleLabel];
        [self.titleLabel release];
        
        [activityView release];

        [self disActivityView];
    }
    return self;
}

- (void)activityViewShow
{
    if(self.frame.origin.y != 0)
      self.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
}

- (void)disActivityView
{
    self.titleLabel.text = @"加载中...";
    if(self.frame.origin.y != [[UIScreen mainScreen] bounds].size.height)
        self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 320, [[UIScreen mainScreen] bounds].size.height);
}

@end
