//
//  sharePlatformView.m
//  PetGroup
//
//  Created by wangxr on 13-12-19.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//
#define buttonHigth 54
#import "sharePlatformView.h"

@interface sharePlatformView ()
@property (nonatomic,assign) UIViewController * viewC;
@end
@implementation sharePlatformView
- (void)dealloc
{
    [super dealloc];
}
- (id)initWithView:(UIViewController*)viewC
{
    self = [super init];
    if (self) {
        // Initialization code
        self.viewC = viewC;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, viewC.view.frame.size.height, viewC.view.frame.size.width, viewC.view.frame.size.height);
        [viewC.view addSubview:self];
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-250, self.frame.size.width, 250)];
        whiteView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:whiteView];
        [whiteView release];
        
        UIButton* weiboB = [UIButton buttonWithType:UIButtonTypeCustom];
        [weiboB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        weiboB.tag = 1;
        [weiboB setBackgroundImage:[UIImage imageNamed:@"sina"] forState:UIControlStateNormal];
//        [weiboB setTitle:@"新浪" forState:UIControlStateNormal];
        weiboB.frame = CGRectMake(33, 20 , buttonHigth, buttonHigth);
        [weiboB addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:weiboB];
        
        UILabel* weiboL = [[UILabel alloc]initWithFrame:CGRectMake(20, 75, 80, 20)];
        weiboL.font = [UIFont systemFontOfSize:14];
        weiboL.text = @"新浪微博";
        weiboL.textAlignment = NSTextAlignmentCenter;
        weiboL.textColor = [UIColor grayColor];
        [whiteView addSubview:weiboL];
        [weiboL release];
        UIButton* tWeiboB = [UIButton buttonWithType:UIButtonTypeCustom];
        [tWeiboB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        tWeiboB.tag = 2;
        [tWeiboB setBackgroundImage:[UIImage imageNamed:@"tencent"] forState:UIControlStateNormal];
//        [tWeiboB setTitle:@"腾讯" forState:UIControlStateNormal];
        tWeiboB.frame = CGRectMake(133, 20 , buttonHigth, buttonHigth);
        [tWeiboB addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:tWeiboB];
        
        UILabel* tWeiboL = [[UILabel alloc]initWithFrame:CGRectMake(120, 75, 80, 20)];
        tWeiboL.font = [UIFont systemFontOfSize:14];
        tWeiboL.text = @"腾讯微博";
        tWeiboL.textAlignment = NSTextAlignmentCenter;
        tWeiboL.textColor = [UIColor grayColor];
        [whiteView addSubview:tWeiboL];
        [tWeiboL release];
        UIButton* weiChatFriendB = [UIButton buttonWithType:UIButtonTypeCustom];
        [weiChatFriendB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        weiChatFriendB.tag = 3;
        [weiChatFriendB setBackgroundImage:[UIImage imageNamed:@"wechattimeline"] forState:UIControlStateNormal];
//        [weiChatFriendB setTitle:@"朋友圈" forState:UIControlStateNormal];
        weiChatFriendB.frame = CGRectMake(233, 20 , buttonHigth, buttonHigth);
        [weiChatFriendB addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:weiChatFriendB];
        
        UILabel* weiChatFriendL = [[UILabel alloc]initWithFrame:CGRectMake(220, 75, 80, 20)];
        weiChatFriendL.font = [UIFont systemFontOfSize:14];
        weiChatFriendL.text = @"微信好友";
        weiChatFriendL.textColor = [UIColor grayColor];
        weiChatFriendL.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:weiChatFriendL];
        [weiChatFriendL release];
        UIButton* weiChatB = [UIButton buttonWithType:UIButtonTypeCustom];
        [weiChatB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        weiChatB.tag = 4;
        [weiChatB setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
//        [weiChatB setTitle:@"微信好友" forState:UIControlStateNormal];
        weiChatB.frame = CGRectMake(33, 110 , buttonHigth, buttonHigth);
        [weiChatB addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:weiChatB];
        
        UILabel* weiChatL = [[UILabel alloc]initWithFrame:CGRectMake(20, 165, 80, 20)];
        weiChatL.font = [UIFont systemFontOfSize:14];
        weiChatL.text = @"朋友圈";
        weiChatL.textAlignment = NSTextAlignmentCenter;
        weiChatL.textColor = [UIColor grayColor];
        [whiteView addSubview:weiChatL];
        [weiChatL release];
        UIButton* qqB = [UIButton buttonWithType:UIButtonTypeCustom];
        [qqB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        qqB.tag = 5;
        [qqB setBackgroundImage:[UIImage imageNamed:@"qqfriends"] forState:UIControlStateNormal];
//        [qqB setTitle:@"qq空间" forState:UIControlStateNormal];
        qqB.frame = CGRectMake(133, 110 , buttonHigth, buttonHigth);
        [qqB addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:qqB];
        
        UILabel* qqL = [[UILabel alloc]initWithFrame:CGRectMake(120, 165, 80, 20)];
        qqL.font = [UIFont systemFontOfSize:14];
        qqL.text = @"QQ";
        qqL.textAlignment = NSTextAlignmentCenter;
        qqL.textColor = [UIColor grayColor];
        [whiteView addSubview:qqL];
        [qqL release];
        UIButton* smsB = [UIButton buttonWithType:UIButtonTypeCustom];
        [smsB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        smsB.tag = 6;
        [smsB setBackgroundImage:[UIImage imageNamed:@"renren"] forState:UIControlStateNormal];
//        [smsB setTitle:@"短信" forState:UIControlStateNormal];
        smsB.frame = CGRectMake(233, 110 , buttonHigth, buttonHigth);
        [smsB addTarget:self action:@selector(shareArticle:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:smsB];
        
        UILabel* smsL = [[UILabel alloc]initWithFrame:CGRectMake(220, 165, 80, 20)];
        smsL.font = [UIFont systemFontOfSize:14];
        smsL.text = @"短信";
        smsL.textAlignment = NSTextAlignmentCenter;
        smsL.textColor = [UIColor grayColor];
        [whiteView addSubview:smsL];
        [smsL release];
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [whiteView addSubview:lineV];
        [lineV release];
        UIButton* cancleB = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancleB setTitle:@"取消" forState:UIControlStateNormal];
        cancleB.frame = CGRectMake(0, 200 , 320, 50);
        [cancleB addTarget:self action:@selector(canclesharePlatformView) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:cancleB];
        
        UIButton* cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelB.frame = CGRectMake(0, 0, 320, self.frame.size.height - whiteView.frame.size.height);
        [cancelB addTarget:self action:@selector(canclesharePlatformView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelB];
    }
    return self;
}
-(void)showSharePlatformView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
                     }
     ];
}
-(void)canclesharePlatformView
{
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0,  self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}
-(void)shareArticle:(UIButton*)button
{
    if (self.delegate) {
        [self.delegate sharePlatformViewPressButtonWithIntage:button.tag];
    }
}
-(void)shareContentSuccess
{
    [self canclesharePlatformView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
