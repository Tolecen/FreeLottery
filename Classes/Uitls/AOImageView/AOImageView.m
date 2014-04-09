//
//  AOImageView.m
//  AOImageViewDemo
//
//  Created by akria.king on 13-4-2.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "AOImageView.h"
#import "UrlImageButton.h"
@implementation AOImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
    }
    return self;
}

//新定义初始化视图方法
-(id)initWithImageName:(NSString *)imageName title:(NSString *)titleStr x:(float)xPoint y:(float)yPoint height:(float)height
{
    //调用原始初始化方法
    self = [super initWithFrame:CGRectMake(xPoint, yPoint, 320, height)];
    if (self) {
        // Initialization code
        //设置图片视图
        UrlImageButton *imageView = [[UrlImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
        
        if ([imageName hasPrefix:@"http://"]) {
            [imageView setImageFromUrl:YES withUrl:imageName];
        }else{
            [imageView setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        
        //给定网络图片路径
        
        //设置点击方法
        [imageView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:imageView];
        //设置黑色背景条
        UIView *titleBack = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-10, 320, 30)];
        titleBack.backgroundColor =[UIColor blackColor];
        titleBack.alpha=0.2;[self addSubview:titleBack];
        //设置标题文字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, 320, 30)];
        titleLabel.text=titleStr;
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor=[UIColor whiteColor];
        [self addSubview:titleLabel];
        // NSLog(@"%@,%@,%@",imageView,titleStr,self);
    }
    return self;
}
//新定义初始化视图方法
-(id)initWithImageData:(NSData *)imageData title:(NSString *)titleStr x:(float)xPoint y:(float)yPoint height:(float)height
{
    //调用原始初始化方法
    self = [super initWithFrame:CGRectMake(xPoint, yPoint, 320, height)];
    if (self) {
        // Initialization code
        //设置图片视图
        UrlImageButton *imageView = [[UrlImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
        
       
        [imageView setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
       
        
        //给定网络图片路径
        
        //设置点击方法
        [imageView addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:imageView];
        //设置黑色背景条
        UIView *titleBack = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-10, 320, 30)];
        titleBack.backgroundColor =[UIColor blackColor];
        titleBack.alpha=0.2;[self addSubview:titleBack];
        //设置标题文字
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, 320, 30)];
        titleLabel.text=titleStr;
        titleLabel.backgroundColor =[UIColor clearColor];
        titleLabel.textColor=[UIColor whiteColor];
        [self addSubview:titleLabel];
        // NSLog(@"%@,%@,%@",imageView,titleStr,self);
    }
    return self;
}
-(void)click{
    [self.uBdelegate click:self.tag];
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
