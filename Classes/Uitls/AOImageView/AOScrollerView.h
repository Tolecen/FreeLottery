//
//  AOScrollerView.h
//  AOImageViewDemo
//
//  Created by akria.king on 13-4-2.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOImageView.h"
#define rightDirection 1
#define leftDirection 0
//点击scrollView中的图片点击事件协议
@protocol ValueClickDelegate <NSObject>

-(void)buttonClick:(int)vid;

@end

@interface AOScrollerView : UIView<UIScrollViewDelegate,UrLImageButtonDelegate>
{
    int pageNumer;//页码
     int switchDirection;//方向
    NSMutableArray *imageNameArr;//图片数组
    NSMutableArray *titleStrArr;//标题数组
    
    UIScrollView *imageSV;//滚动视图
    int page;//页码
}
@property(nonatomic,strong)id<ValueClickDelegate> vDelegate;
//自定义实例化方法
//parameter：
//imageArr：图片url数组
//titleArr：标题数组
//height：视图高度
-(id)initWithNameArr:(NSMutableArray *)imageArr titleArr:(NSMutableArray *)titleArr height:(float)heightValue;
@end
