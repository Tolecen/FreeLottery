//
//  UINavigationBar+UINavigationBarCustomBg.m
//  TryRoundDisk
//
//  Created by  on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBarCustomBg.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UINavigationBar (UINavigationBarCustomBg)

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"title_bg.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)setBackground{
    
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
//        
//        if ([self respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//            [self setBackgroundImage:[UIImage imageNamed:@"title_bg.png"] forBarMetrics:0];
//        }
//        
//    }else{
//        
//        UIImage *image = [UIImage imageNamed: @"title_bg.png"];
//        CGRect rectFrame=CGRectMake(0, 0 ,320,44);
//        UIGraphicsBeginImageContext(rectFrame.size);
//        [image drawInRect:rectFrame];
//        UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        if ([self respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
//            [self setBackgroundImage:newImage forBarMetrics:0];
//            
//        }
//    }

    
    UIImage *image = [UIImage imageNamed: @"title_bg.png"];
    float h = 0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        h = 64;
    }
    else
        h = 44;
    CGRect rectFrame=CGRectMake(0, 0 ,320,h);
    UIGraphicsBeginImageContext(rectFrame.size);
    [image drawInRect:rectFrame];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([self respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self setBackgroundImage:newImage forBarMetrics:0];
        
    }
    
}


-(void)setNavigationBackgroundColor:(UIColor *)color{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = color;
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [image drawInRect:view.bounds];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([self respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self setBackgroundImage:newImage forBarMetrics:0];
    }
    
}



-(UIImage * )getImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * iamge = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return iamge ;
    
}



@end
