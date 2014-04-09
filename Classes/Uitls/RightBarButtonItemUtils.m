//
//  RightBarButtonItemUtils.m
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-2-3.
//
//

#import "RightBarButtonItemUtils.h"
#import "RYCImageNamed.h"
#import "CustomColorButtonUtils.h"
@interface RightBarButtonItemUtils (private)
//初始化方法
- (id) initWithDelfaultRightButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action andTitle:(NSString *)title;
@end



@implementation RightBarButtonItemUtils
@synthesize _viewController;

-(id)initWithDelfaultRightButtonForUIViewController:(UIViewController *)viewController addTarget:(id)target action:(SEL)action andTitle:(NSString *)title{
    
    //right按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0, 0.0, 52, 30);
    [rightButton setBackgroundImage:RYCImageNamed(@"item_bar_right_button_normal.png") forState:UIControlStateNormal];
    [rightButton setBackgroundImage:RYCImageNamed(@"item_bar_right_button_click.png") forState:UIControlStateHighlighted];
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (target != nil && action != nil) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    self = [super initWithCustomView:rightButton];
    if (self) {
        self._viewController = viewController;
    }
    return self;
}

+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andTitle:(NSString *)title{
    if (controller) {
        RightBarButtonItemUtils *btn = [[RightBarButtonItemUtils alloc] initWithDelfaultRightButtonForUIViewController:controller addTarget:target action:action andTitle:title];
        controller.navigationItem.rightBarButtonItem = btn;
        [btn release];
    }
}


+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andTitle:(NSString *)title normalColor:(NSString *)normalColorStr higheColor:(NSString *)higheColorStr{
    
    if (controller) {
        CustomColorButtonUtils *btn = [[CustomColorButtonUtils alloc] initWithRect:CGRectMake(0, 0, 50, 26) normalColor:normalColorStr higheColor:higheColorStr];
        
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [btn release];

        controller.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBarButtonItem release];
    }
    
}


+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andTitle:(NSString *)title normalColor:(NSString *)normalColorStr higheColor:(NSString *)higheColorStr rightButtontFrame:(CGRect)frame{
    
    [self addRightButtonForController:controller addTarget:target action:action andTitle:title normalColor:normalColorStr higheColor:higheColorStr];
    controller.navigationItem.rightBarButtonItem.customView.frame = frame;
}


- (void)dealloc {
    [_viewController release];
    [super dealloc];
}

@end
