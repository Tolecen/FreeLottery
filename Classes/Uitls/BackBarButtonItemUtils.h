//
//  BackBarButtonItemUtils.h
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-1-31.
//
//

#import <UIKit/UIKit.h>

@interface BackBarButtonItemUtils : UIBarButtonItem
{
//应该pop的controller
UIViewController *_viewController;
}

//应该pop的controller
//@property(nonatomic,retain) UIViewController *_viewController;

//添加 navigationItem backButton 并默认事件为弹出 该viewController
+(void)addBackButtonForController:(UIViewController *)controller;
/*
 *添加 navigationItem backButton
 *  target 事件接收地址
 *  action 自定义返回事件
 *  type   是否自动添加弹出该ViewController 如果与action定义的事件有冲突，请设置为no
 */
+(void)addBackButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type;

+(void)addBackButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type normalImage:(NSString * )normalImage highlightedImage:(NSString *)highlightedImage;

+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action;
@end
