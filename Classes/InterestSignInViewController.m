//
//  InterestSignInViewController.m
//  Boyacai
//
//  Created by wangxr on 14-5-12.
//
//

#import "InterestSignInViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
@interface InterestSignInViewController ()

@end

@implementation InterestSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
}
- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent
                                                       *)event
{
    //检测到摇动
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"检测到摇动");        
    }
}
- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //摇动取消
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"摇动取消");
    }
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"摇动结束");
        
    }
}
@end
