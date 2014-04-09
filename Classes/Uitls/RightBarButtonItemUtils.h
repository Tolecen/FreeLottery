//
//  RightBarButtonItemUtils.h
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-2-3.
//
//

#import <UIKit/UIKit.h>

@interface RightBarButtonItemUtils : UIBarButtonItem
{
    //应该pop的controller
    UIViewController *_viewController;
}

//应该pop的controller
@property(nonatomic,retain) UIViewController *_viewController;

/*
 *添加 navigationItem backButton
 *  target 事件接收地址
 *  action 自定义返回事件
 *  type   是否自动添加弹出该ViewController 如果与action定义的事件有冲突，请设置为no
 */
+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andTitle:(NSString *)title;

+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andTitle:(NSString *)title normalColor:(NSString *)normalColorStr higheColor:(NSString*)higheColorStr;
+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andTitle:(NSString *)title normalColor:(NSString *)normalColorStr higheColor:(NSString *)higheColorStr rightButtontFrame:(CGRect)frame;
@end
