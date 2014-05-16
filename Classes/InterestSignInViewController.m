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
#import "AnimationView.h"
@interface InterestSignInViewController ()<UIImagePickerControllerDelegate>
@property (nonatomic,retain)UILabel * descriptionsL;
@property (nonatomic,retain)UILabel * promptL;
@property (nonatomic,retain)AnimationView * animationV;
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
- (void)dealloc
{
    [_descriptionsL release];
    [_promptL release];
    [_animationV release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"摇一摇,签到有惊喜";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
        UIButton * backB = [UIButton buttonWithType:UIButtonTypeCustom];
        backB.frame = CGRectMake(0, 0, 25, 25);
        [backB setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [backB addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        backB;
    })];
    float h = 44;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        h = 64;
    }
    UIImageView * backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-h)];
    backgroundView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:backgroundView];
    [backgroundView release];
    
    UIImageView * textImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, backgroundView.frame.size.height-200, 320, 200)];
    textImageV.image = [UIImage imageNamed:@"textBG"];
    [self.view addSubview:textImageV];
    [textImageV release];
    self.promptL = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 60)];
    _promptL.backgroundColor = [UIColor clearColor];
    _promptL.numberOfLines = 0;
    _promptL.textAlignment = NSTextAlignmentCenter;
    _promptL.textColor = [UIColor redColor];
    [textImageV addSubview:_promptL];
    [_promptL release];
    self.descriptionsL =[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 300, 100)];
    _descriptionsL.backgroundColor = [UIColor clearColor];
    _descriptionsL.textColor = [UIColor blackColor];
    _descriptionsL.font = [UIFont systemFontOfSize:13];
    _descriptionsL.numberOfLines = 0;
    [textImageV addSubview:_descriptionsL];
    [_descriptionsL release];
    
    UIImageView * yaoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(108, self.view.frame.size.height/4, 104, 104)];
    yaoImageView.image = [UIImage imageNamed:@"yao"];
    [backgroundView addSubview:yaoImageView];
    [yaoImageView release];
    
    self.animationV = [[AnimationView alloc]initWithFrame:backgroundView.frame];
    [self.view addSubview:_animationV];
    [_animationV release];
    
    _animationV.subviewsArray = @[@"土豪金",@"土豪银",@"土豪铜",@"土豪铁",@"土豪吕"];
    _promptL.text = @"您就可劲的摇吧，摇到啥就送啥\n要的频率很重要啊";
    _descriptionsL.text = @"今日特将:土豪金一部\n每日总有那么几十个,超值赚豆卡赠送\n每日1000个1元话费卡赠送\n每日1500个任务卡赠送\n每日15-500彩豆随机赠送";
    
}
- (void)back:(id)sender
{
    if (_animationV.animation) {
        return;
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(interestSignInViewControllerDidCancel)]) {
        [_delegate interestSignInViewControllerDidCancel];
        return;
    }
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
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake&&!_animationV.animation) {
        [_animationV starAnimation];
        [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:10];
    }
}
- (void)stopAnimation
{
    [_animationV stopAnimationWithSubviewsLocation:1 completion:^{
        NSLog(@"stop");
    }];
}
@end
