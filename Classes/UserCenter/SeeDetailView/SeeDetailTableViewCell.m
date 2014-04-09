//
//  SeeDetailTableViewCell.m
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SeeDetailTableViewCell.h"
#import "RYCImageNamed.h"

@implementation SeeDetailTableViewCell

@synthesize cellTitle;
@synthesize cellDetailTitle;
@synthesize isTextView;
@synthesize contentStr;
@synthesize isRedText;
@synthesize isWebView;;
@synthesize hasButton;


- (void)dealloc
{
    [cellLabel release];
    [cellDetailLabel release];
    [contentView release];
    [oneButton release];
    [contentWeb release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        cellLabel.textAlignment = UITextAlignmentCenter;
        cellLabel.font = [UIFont systemFontOfSize:15.0f];
        cellLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0];
        cellLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:cellLabel];
        
        cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 180, 40)];
        //        cellDetailLabel.textAlignment = UITextAlignmentRight;
        cellDetailLabel.font = [UIFont systemFontOfSize:15.0f];
        cellDetailLabel.textColor = [UIColor blackColor];
        cellDetailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:cellDetailLabel];
        
        contentView =  [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 285, 135)];
        //        contentView.contentSize = CGSizeMake(285, 140);
        contentView.layer.cornerRadius = 8;
        contentView.layer.masksToBounds = YES;
        contentView.font = [UIFont systemFontOfSize:15];
        contentView.textColor = [UIColor blackColor];
        contentView.editable = NO;
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        contentView.hidden = YES;
        
        contentWeb =  [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, 300, 135)];
        contentWeb.layer.cornerRadius = 8;
        contentWeb.layer.masksToBounds = YES;
        contentWeb.dataDetectorTypes = UIDataDetectorTypeNone;//去掉下划线
        contentWeb.backgroundColor = [UIColor clearColor];
        //        contentWeb.bounds  =CGRectMake(10, 0, 300, 135)
        //        contentWeb.scalesPageToFit = YES;
        //        contentWeb.delegate = self;
        [self addSubview:contentWeb];
        contentWeb.hidden = YES;
        /*       UIScrollView *scroller = [contentWeb.subviews objectAtIndex:0];//去掉阴影
         if (scroller) {
         for (UIView *v in [scroller subviews]) {
         if ([v isKindOfClass:[UIImageView class]]) {
         [v removeFromSuperview];
         }
         }
         }*/
        [(UIScrollView *)[[contentWeb subviews] objectAtIndex:0] setBounces:NO];
        
        oneButton  = [[UIButton alloc] initWithFrame:CGRectMake(248, 10, 50, 26)];
        [oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        oneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [oneButton setBackgroundImage:RYCImageNamed(@"quxiao_normal.png") forState:UIControlStateNormal];
        [oneButton setBackgroundImage:RYCImageNamed(@"quxiao_click.png") forState:UIControlStateHighlighted];
        [oneButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:oneButton];
        oneButton.hidden = YES;
        
        if ([reuseIdentifier isEqualToString:@"cellid_creatAutoOrderCancelButton"]) {
            
            UIButton* cancelButton  = [[UIButton alloc] initWithFrame:CGRectMake(248, 10, 50, 26)];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancelButton setBackgroundImage:RYCImageNamed(@"quxiao_normal.png") forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:RYCImageNamed(@"quxiao_click.png") forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton setTitle:@"撤销" forState:UIControlStateNormal];
            [self addSubview:cancelButton];
            [cancelButton release];
        }
        
        
        isTextView = NO;
        isRedText = NO;
        isWebView = NO;
        hasButton = NONE_BUTTON;
	}
    return self;
}

- (void)refreshCell
{
    cellLabel.text = self.cellTitle;
    cellDetailLabel.text = self.cellDetailTitle;
    if(isTextView)
    {
        contentView.hidden = NO;
        contentView.text = contentStr;
    }
    else
    {
        contentView.hidden = YES;
    }
    if(isWebView)
    {
        contentWeb.hidden = NO;
        
        self.contentStr = [self.contentStr stringByReplacingOccurrencesOfString:@"," withString:@"，"];
        [contentWeb loadHTMLString:contentStr baseURL:nil];
    }
    else
    {
        contentWeb.hidden = YES;
    }
    if(isRedText)
    {
        cellDetailLabel.textColor = [UIColor redColor];
    }
    else
    {
        cellDetailLabel.textColor = [UIColor blackColor];
    }
    if(HMDT_CHEDAN_BUTTON == hasButton)
    {
        [oneButton setTitle:@"撤单" forState:UIControlStateNormal];
        oneButton.hidden = NO;
    }
    else if(ZHUIHAO_STOP_TRACK == hasButton)
    {
        [oneButton setTitle:@"终止追号" forState:UIControlStateNormal];
        oneButton.frame = CGRectMake(220, 7, 80, 26);
        oneButton.hidden = NO;
    }
    else
    {
        oneButton.hidden = YES;
    }
}

- (void)buttonClick:(id)sender
{
    if(HMDT_CHEDAN_BUTTON == hasButton)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheDanNotification" object:nil];
    }
    else if(ZHUIHAO_STOP_TRACK == hasButton)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StopTrackNotification" object:nil];
    }
    else if(HM_CANCEL_ORDER == hasButton)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CheXiaoNotification" object:nil];
    }
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    if ([contentWeb respondsToSelector:@selector(scrollView)])
//    {
//        UIScrollView *scroll=[contentWeb scrollView];
//
//        float zoom=contentWeb.bounds.size.width/scroll.contentSize.width;
//        NSLog(@"%f %f %f",contentWeb.bounds.size.width, scroll.contentSize.width, zoom);
////        [scroll setZoomScale:1.5 animated:YES];
////        scroll.contentSize = CGSizeMake(300, 200);
//    }
//}

@end
