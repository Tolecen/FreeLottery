//
//  BackBarButtonItemUtils.m
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-1-31.
//
//

#import "BackBarButtonItemUtils.h"
#import "RYCImageNamed.h"
#import "TitleViewButtonItemUtils.h"

@interface BackBarButtonItemUtils (private)
//初始化方法
-(id) initWithDelfaultBackButtonForUIViewController:(UIViewController *) viewController;
- (id) initWithDelfaultBackButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type;
- (id) initWithDelfaultBackButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type normalImage:(NSString * )normalImage highlightedImage:(NSString *)highlightedImage;
- (id) initWithDelfaultRightButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action;
@end

@implementation BackBarButtonItemUtils

//@synthesize _viewController;


-(void) backAction{
    [TitleViewButtonItemUtils shutDownMenu];
    
    if (_viewController.navigationController) {
        [_viewController.navigationController popViewControllerAnimated:YES];
    }
}
//初始化方法
-(id) initWithDelfaultBackButtonForUIViewController:(UIViewController *) viewController{
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 52, 30);
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_normal.png") forState:UIControlStateNormal];
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_click.png") forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    //    [backButton setImage:[UIImage imageNamed:@"navigation_back_button_sel.png"] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self = [super initWithCustomView:backButton];
    if (self) {
        _viewController = viewController;
    }
    return self;
}


- (id) initWithDelfaultBackButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type{
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 52, 30);
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_normal.png") forState:UIControlStateNormal];
    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_click.png") forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (type) {
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (target != nil && action != nil) {
        [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    self = [super initWithCustomView:backButton];
    if (self) {
        _viewController = viewController;
    }
    return self;
}


- (id) initWithDelfaultBackButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type normalImage:(NSString *)normalImage highlightedImage:(NSString *)highlightedImage{
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 52, 26);
    [backButton setBackgroundImage:RYCImageNamed(normalImage) forState:UIControlStateNormal];
    [backButton setBackgroundImage:RYCImageNamed(highlightedImage) forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (type) {
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    if (target != nil && action != nil) {
        [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    self = [super initWithCustomView:backButton];
    if (self) {
        _viewController = viewController;
    }
    return self;
}


- (id) initWithDelfaultRightButtonForUIViewController:(UIViewController *) viewController addTarget:(id)target action:(SEL)action{
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 52, 26);
    [backButton setBackgroundImage:RYCImageNamed(@"Ks_more_normal") forState:UIControlStateNormal];
    //[backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_click.png") forState:UIControlStateHighlighted];
    //[backButton setTitle:@"返回" forState:UIControlStateNormal];
    //backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //[backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (target != nil && action != nil) {
        [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    self = [super initWithCustomView:backButton];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

+(void)addBackButtonForController:(UIViewController *)controller{
    if (controller) {
        BackBarButtonItemUtils *btn = [[BackBarButtonItemUtils alloc] initWithDelfaultBackButtonForUIViewController:controller];
        controller.navigationItem.leftBarButtonItem = btn;
        [btn release];
        
    }
}

+(void)addBackButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type{
    if (controller) {
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//            controller.navigationController.interactivePopGestureRecognizer.delegate = controller;
//        }
        BackBarButtonItemUtils *btn = [[BackBarButtonItemUtils alloc] initWithDelfaultBackButtonForUIViewController:controller addTarget:target action:action andAutoPopView:type];
        controller.navigationItem.leftBarButtonItem = btn;
        [btn release];
        
    }
}


+(void)addBackButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action andAutoPopView:(BOOL)type normalImage:(NSString * )normalImage highlightedImage:(NSString *)highlightedImage{
    if (controller) {
        BackBarButtonItemUtils *btn = [[BackBarButtonItemUtils alloc] initWithDelfaultBackButtonForUIViewController:controller addTarget:target action:action andAutoPopView:type normalImage:normalImage highlightedImage:highlightedImage];
        controller.navigationItem.leftBarButtonItem = btn;
        [btn release];
        
    }
}


+(void)addRightButtonForController:(UIViewController *)controller addTarget:(id)target action:(SEL)action{
    if (controller) {
        BackBarButtonItemUtils *btn = [[BackBarButtonItemUtils alloc] initWithDelfaultRightButtonForUIViewController:controller addTarget:target action:action];
        controller.navigationItem.rightBarButtonItem = btn;
        [btn release];
        
    }
}


- (void)dealloc {
//    [_viewController release];
//    _viewController.navigationItem.leftBarButtonItem = nil;
    [super dealloc];
}
@end