//
//  RightBarButtonItemUtils.m
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-2-3.
//
//

#import "ShareRightBarButtonItemUtils.h"
#import "RYCImageNamed.h"
@interface ShareRightBarButtonItemUtils (private)
//初始化方法
- (id) initWithDelfaultRightButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action andTitle:(NSString *)title;
@end



@implementation ShareRightBarButtonItemUtils
@synthesize _viewController;

-(id)initWithDelfaultRightButtonForUIViewController:(UIViewController *)viewController addTarget:(id)target action:(SEL)action andTitle:(NSString *)title{
    
    //right按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0.0, 0.0, 40, 30);
    [rightButton setBackgroundImage:RYCImageNamed(@"share_right_nomal.png") forState:UIControlStateNormal];
    [rightButton setBackgroundImage:RYCImageNamed(@"share_right_highlighted.png") forState:UIControlStateHighlighted];
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

+(void)addShareRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andTitle:(NSString *)title{
    if (controller) {
        ShareRightBarButtonItemUtils *btn = [[ShareRightBarButtonItemUtils alloc] initWithDelfaultRightButtonForUIViewController:controller addTarget:target action:action andTitle:title];
        controller.navigationItem.rightBarButtonItem = btn;
        [btn release];
    }
}


- (void)dealloc {
    [_viewController release];
    [super dealloc];
}

@end
