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
#define CAduration 3
#define StartingPoint CGPointMake(160.0, 120.0)
@interface DiceViewController ()
@property (nonatomic,retain)UIImageView * diceImgV;
@end

@implementation DiceViewController
- (void)dealloc
{
    [_diceImgV release];
    [super dealloc];
}
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
    _diceImgV.center = StartingPoint;
    _diceImgV.image = [UIImage imageNamed:@"ting1"];
    _diceImgV.animationImages = @[[UIImage imageNamed:@"ting1"],[UIImage imageNamed:@"ting2"],[UIImage imageNamed:@"ting3"],[UIImage imageNamed:@"ting4"],[UIImage imageNamed:@"ting6"],[UIImage imageNamed:@"ting6"]];
    _diceImgV.animationDuration = 0.3;
    [self.view addSubview:_diceImgV];
    [_diceImgV release];
    
}
- (void)diceStarAnimation
{
    [_diceImgV startAnimating];
    
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    spin.duration = CAduration + 1;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setValues:[self randomKeyPointArray]];
    animation.duration = CAduration;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects: animation, spin,nil];
    animGroup.duration = CAduration+1;
    animGroup.delegate = self;
    [[_diceImgV layer] addAnimation:animGroup forKey:nil];
    
}
- (NSArray*)randomKeyPointArray
{
    float high = self.view.frame.size.height-52.5;
    switch (arc4random()%5) {
        case 0:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(50.0, 370);
            CGPoint p3 = CGPointMake(160.0, high);
            CGPoint p4 = CGPointMake(270.0, 370);
            CGPoint p5 = CGPointMake(140.0, 52.5);
            CGPoint p6 = CGPointMake(50.0, 140.0);
            CGPoint p7 = CGPointMake(200.0, high);
            CGPoint p8 = CGPointMake(270.0, high-100);
            CGPoint p9 = CGPointMake(50.0, 200.0);
            CGPoint p10 = CGPointMake(160.0, 52.5);
            CGPoint p11 = CGPointMake(270.0, 100.0);
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p10],[NSValue valueWithCGPoint:p11],[NSValue valueWithCGPoint:p1]];
        }break;
        case 1:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(270.0, 52.5);
            CGPoint p3 = CGPointMake(50.0, high/2);
            CGPoint p4 = CGPointMake(270.0, high);
            CGPoint p5 = CGPointMake(50.0, high-100);
            CGPoint p6 =  CGPointMake(270.0, 350);
            CGPoint p7 = CGPointMake(200.0, 52.5);
            CGPoint p8 = CGPointMake(50.0, high);
            CGPoint p9 = CGPointMake(270.0, high/2);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
        case 2:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(270.0, 200);
            CGPoint p3 = CGPointMake(200.0, high);
            CGPoint p4 = CGPointMake(50.0, high-100);
            CGPoint p5 = CGPointMake(270.0, high/2);
            CGPoint p6 =  CGPointMake(50.0, 200);
            CGPoint p7 = CGPointMake(270.0, high-200);
            CGPoint p8 = CGPointMake(200.0, high);
            CGPoint p9 = CGPointMake(50.0, high/2);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
        case 3:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(100.0, 52.5);
            CGPoint p3 = CGPointMake(270.0, high);
            CGPoint p4 = CGPointMake(50.0, high-100);
            CGPoint p5 = CGPointMake(270.0, high/2);
            CGPoint p6 =  CGPointMake(50.0, 200);
            CGPoint p7 = CGPointMake(270.0, high-200);
            CGPoint p8 = CGPointMake(200.0, high);
            CGPoint p9 = CGPointMake(50.0, high/2);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
        default:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(100.0, high);
            CGPoint p3 = CGPointMake(270.0, 370);
            CGPoint p4 = CGPointMake(50.0, high/2);
            CGPoint p5 = CGPointMake(200.0, 52.5);
            CGPoint p6 =  CGPointMake(270.0, high-100);
            CGPoint p7 = CGPointMake(50.0, high);
            CGPoint p8 = CGPointMake(270.0, 370);
            CGPoint p9 = CGPointMake(50.0, 200);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
    }
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([_diceImgV isAnimating]) {
        return;
    }
     [self diceStarAnimation];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_diceImgV stopAnimating];
    _diceImgV.image = [UIImage imageNamed:@"ting3"];
    
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

@end
