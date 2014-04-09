//
//  ColorUtils.h
//  mapper_ios
//
//  Created by zhaoqing huang on 13-1-20.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//  颜色管理工具类。
//  提供16位颜色数值转换为UIColor，随机获取颜色的功能
//  作用：解析color的16进制值，并提供改变view背景的方法

#import <Foundation/Foundation.h>


#define TIME_FOUNT_COLOR @"#7A7A7A"
@interface ColorUtils : NSObject {
    
}
 
//获取随机颜色
+(UIColor *)getRandomColor:(CGFloat)alpha;
+ (UIColor *)parseColorFromRGB:(NSString *)rgb;
+ (UIColor *)parseColorFromRGBA:(NSString *)rgb Alpha:(float)alpha;

+ (void)setDefaultAppBackgroundColorForView:(UIView *) view;
@end
