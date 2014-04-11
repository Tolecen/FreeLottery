//
//  ExchangeCaidouViewController.m
//  Boyacai
//
//  Created by wangxr on 14-4-10.
//
//

#import "ExchangeCaidouViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
@interface ExchangeCaidouViewController ()
@property (nonatomic,retain)UILabel * caidouNoL;
@property (nonatomic,retain)UILabel * jiangjinNoL;
@end

@implementation ExchangeCaidouViewController

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
    [_caidouStr release];
    [_jiangjinStr release];
    [_caidouNoL release];
    [_jiangjinNoL release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    UILabel *caidouL = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 40, 20)];
    caidouL.text = @"彩豆:";
    caidouL.font = [UIFont boldSystemFontOfSize:14];
    caidouL.textColor = [UIColor grayColor];
    [self.view addSubview:caidouL];
    [caidouL release];
    
    self.caidouNoL = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 100, 20)];
    _caidouNoL.font = [UIFont boldSystemFontOfSize:14];
    _caidouNoL.textColor = [UIColor redColor];
    _caidouNoL.text = _caidouStr;
    [self.view addSubview:_caidouNoL];
    [_caidouNoL release];
    
    UILabel *jiangjinL = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 40, 20)];
    jiangjinL.text = @"奖金:";
    jiangjinL.font = [UIFont boldSystemFontOfSize:14];
    jiangjinL.textColor = [UIColor grayColor];
    [self.view addSubview:jiangjinL];
    [jiangjinL release];
    
    self.jiangjinNoL = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 100, 20)];
    _jiangjinNoL.font = [UIFont boldSystemFontOfSize:14];
    _jiangjinNoL.textColor = [UIColor redColor];
    _jiangjinNoL.text = _jiangjinStr;
    [self.view addSubview:_jiangjinNoL];
    [_jiangjinNoL release];
    
    UILabel * guizeL = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 300, 70)];
    guizeL.text = @"兑换比例: 1元=250彩豆(500彩豆换取一注彩票)\n\n\n输入兑换金额:";
    guizeL.numberOfLines = 0;
    guizeL.font = [UIFont systemFontOfSize:14];
    guizeL.textColor = [UIColor blackColor];
    [self.view addSubview:guizeL];
    [guizeL release];
    
    UITextField * textF = [[UITextField alloc]initWithFrame:CGRectMake(120, 130, 200, 22)];
    textF.font = [UIFont systemFontOfSize:14];
    textF.placeholder = @"输入兑换金额";
    [self.view addSubview:textF];
    [textF release];
    
    UILabel * tishiL = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, 320, 20)];
    tishiL.font = [UIFont systemFontOfSize:10];
    tishiL.textAlignment = NSTextAlignmentCenter;
    tishiL.backgroundColor = [UIColor clearColor];
    tishiL.text = [NSString stringWithFormat:@"输入的金额应为大于0.1元,且小于%@,最小单位到角",_jiangjinStr];
    [self.view addSubview:tishiL];
    
    UIButton * exchangeB = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeB setTitle:@"兑换" forState:UIControlStateNormal];
    exchangeB.frame = CGRectMake(30, 200, 260, 40);
    [self.view addSubview:exchangeB];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
