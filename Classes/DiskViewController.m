//
//  DiskViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-3-11.
//
//

#import "DiskViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "math.h"
@interface DiskViewController ()

@end

@implementation DiskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [image1 release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [AdaptationUtils adaptation:self];
    //    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"幸运转盘";
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    //添加转盘
    image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newdisk.png"]];
    image1.frame = CGRectMake(0.0, 20.0, 320.0, 320.0);
//    image1 = image_disk;
    [self.view addSubview:image1];
    
    //添加转针
    image2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [image2 setImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    image2.frame = CGRectMake(102.0, 62.0, 120.0, 233.5);
//    image2 = image_start;
    [self.view addSubview:image2];
    [image2 addTarget:self action:@selector(choujiang) forControlEvents:UIControlEventTouchUpInside];
    image2.transform = CGAffineTransformMakeRotation(M_PI*2);
    //    orign = 1;
    
    //添加按钮
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 370, 320, 30)];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"点击转盘上的开始抽奖按钮进行抽奖"];
    [self.view addSubview:textLabel];
    [textLabel release];
//    UIButton *btn_start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn_start.frame = CGRectMake(140.0, 370.0, 70.0, 70.0);
//    [btn_start setTitle:@"抽奖" forState:UIControlStateNormal];
//    [btn_start addTarget:self action:@selector(choujiang) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn_start];
//    [btn_start release];
    
    NSString * gg = [[NSUserDefaults standardUserDefaults] objectForKey:@"choujiangTime"];
    if (!gg) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"choujiangTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    

	// Do any additional setup after loading the view.
}
- (void)choujiang
{
    jiaMoney = [[NSUserDefaults standardUserDefaults] objectForKey:@"jiaMoney"];
    if (!jiaMoney) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"jiaMoney"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString * currentT = [NSString stringWithFormat:@"%f",nowTime];
    NSString * saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"choujiangTS"];
    if (!saved) {
        [[NSUserDefaults standardUserDefaults] setObject:currentT forKey:@"choujiangTS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if (nowTime-[saved floatValue]>24*3600) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"choujiangTime"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        [[NSUserDefaults standardUserDefaults] setObject:currentT forKey:@"choujiangTS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    image2.enabled = NO;
    NSString * choujiangTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"choujiangTime"];
    
    if ([choujiangTime isEqualToString:@"5"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，今天的抽奖次数用完了，明天再来吧" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [alert release];
        image2.enabled = YES;
        return;
    }
    if ([choujiangTime intValue]==0) {
        
    }
    else if ([choujiangTime intValue]==1){
        
    }
    else if ([choujiangTime intValue]==2){
        
    }
    else{
        
    }
    
    //******************旋转动画******************
    //产生随机角度
    //    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    random = (rand() % 20) / 10.0;
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:M_PI*2]];
    if ([choujiangTime intValue]==0) {
        [spin setToValue:[NSNumber numberWithFloat:M_PI * 15.25]];
    }
    else if ([choujiangTime intValue]==1){
        [spin setToValue:[NSNumber numberWithFloat:M_PI * 15.75]];
    }
    else if ([choujiangTime intValue]==2){
        [spin setToValue:[NSNumber numberWithFloat:M_PI * 15.25]];
    }
    else{
        [spin setToValue:[NSNumber numberWithFloat:M_PI * 15.37]];
    }
    
    
    
    [spin setDuration:2.5];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //添加动画
    [[image2 layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    //    if (orign==1) {
    //        image2.transform = CGAffineTransformMakeRotation(M_PI * 15.25);
    //        orign = 2;
    //    }
    //    else{
    //        image2.transform = CGAffineTransformMakeRotation(M_PI * 16);
    //        orign = 1;
    //    }
    if ([choujiangTime intValue]==0) {
        image2.transform = CGAffineTransformMakeRotation(M_PI * 15.25);
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"choujiangTime"];
    }
    else if ([choujiangTime intValue]==1){
        image2.transform = CGAffineTransformMakeRotation(M_PI * 15.75);
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"choujiangTime"];
    }
    else if ([choujiangTime intValue]==2){
        image2.transform = CGAffineTransformMakeRotation(M_PI * 15.25);
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"choujiangTime"];
    }
    else if([choujiangTime intValue]==3){
        image2.transform = CGAffineTransformMakeRotation(M_PI * 15.37);
        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"choujiangTime"];
    }
    else if([choujiangTime intValue]==4){
        image2.transform = CGAffineTransformMakeRotation(M_PI * 15.37);
        [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:@"choujiangTime"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    //锁定fromValue的位置
    //    orign = 10.0+random+orign;
    //    orign = fmodf(orign, 2.0);
    //    orign = M_PI*15.25;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    image2.enabled = YES;
    NSString * choujiangTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"choujiangTime"];
    if ([choujiangTime isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜您获得了125彩豆，已经转为彩金冲入您的账号" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [alert release];
        jiaMoney = [NSString stringWithFormat:@"%f",[jiaMoney floatValue]+0.5];
        [[NSUserDefaults standardUserDefaults] setObject:jiaMoney forKey:@"jiaMoney"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([choujiangTime isEqualToString:@"2"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜您获得了500彩豆，已经转为彩金冲入您的账号" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [alert release];
        jiaMoney = [NSString stringWithFormat:@"%f",[jiaMoney floatValue]+1];
        [[NSUserDefaults standardUserDefaults] setObject:jiaMoney forKey:@"jiaMoney"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([choujiangTime isEqualToString:@"3"]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜您获得了125彩豆，已经转为彩金冲入您的账号" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [alert release];
        jiaMoney = [NSString stringWithFormat:@"%f",[jiaMoney floatValue]+0.5];
        [[NSUserDefaults standardUserDefaults] setObject:jiaMoney forKey:@"jiaMoney"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
