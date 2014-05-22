//
//  DiceViewController.m
//  Boyacai
//
//  Created by wangxr on 14-5-22.
//
//

#import "DiceViewController.h"
#import "ActivitiesViewController.h"
#import "ColorUtils.h"
@interface DiceViewController ()
@property (nonatomic,retain)UIImageView * diceImgV;
@end

@implementation DiceViewController

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
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"猜大小,赢双倍彩豆";
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    self.diceImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 105)];
    _diceImgV.center = CGPointMake(85.0, 115.0);
    _diceImgV.image = [UIImage imageNamed:@"ting1"];
    _diceImgV.animationImages = @[[UIImage imageNamed:@"ting1"],[UIImage imageNamed:@"ting2"],[UIImage imageNamed:@"ting3"],[UIImage imageNamed:@"ting4"],[UIImage imageNamed:@"ting6"],[UIImage imageNamed:@"ting6"]];
    [self.view addSubview:_diceImgV];
    
}
- (void)diceStarAnimation
{
    _diceImgV.animationDuration = 0.5;
    [_diceImgV startAnimating];
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
    [spin setDuration:4];
    
    CGPoint p1 = CGPointMake(85.0, 115.0);
    CGPoint p2 = CGPointMake(165.0, 100.0);
    CGPoint p3 = CGPointMake(240.0, 160.0);
    CGPoint p4 = CGPointMake(140.0, 200.0);
    NSArray *keypoint = @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p1]];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setValues:keypoint];
    [animation setDuration:4.0];
    [animation setDelegate:self];
    [_diceImgV.layer setPosition:p1];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects: animation, spin,nil];
    animGroup.duration = 4;
    [animGroup setDelegate:self];
    [[_diceImgV layer] addAnimation:animGroup forKey:@"position"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_diceImgV stopAnimating];
    _diceImgV.image = [UIImage imageNamed:@"ting3"];
}
- (void)back:(id)sender
{
    [self diceStarAnimation];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
