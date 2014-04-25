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
@property (nonatomic,retain)UITextField * textF;
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
    [_textF release];
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
    caidouL.backgroundColor = [UIColor clearColor];
    [caidouL release];
    
    self.caidouNoL = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 100, 20)];
    _caidouNoL.font = [UIFont boldSystemFontOfSize:14];
    _caidouNoL.textColor = [UIColor redColor];
    _caidouNoL.text = _caidouStr;
    [self.view addSubview:_caidouNoL];
    _caidouNoL.backgroundColor = [UIColor clearColor];
    [_caidouNoL release];
    
    UILabel *jiangjinL = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 40, 20)];
    jiangjinL.text = @"奖金:";
    jiangjinL.font = [UIFont boldSystemFontOfSize:14];
    jiangjinL.textColor = [UIColor grayColor];
    [self.view addSubview:jiangjinL];
    jiangjinL.backgroundColor = [UIColor clearColor];
    [jiangjinL release];
    
    self.jiangjinNoL = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 100, 20)];
    _jiangjinNoL.font = [UIFont boldSystemFontOfSize:14];
    _jiangjinNoL.textColor = [UIColor redColor];
    _jiangjinNoL.text = _jiangjinStr;
    [self.view addSubview:_jiangjinNoL];
    _jiangjinNoL.backgroundColor = [UIColor clearColor];
    [_jiangjinNoL release];
    
    UILabel * guizeL = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 300, 70)];
    int a  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ADWallExchangeScale"] intValue];
    guizeL.text =[NSString stringWithFormat:@"兑换比例: 1元=%d彩豆(%d彩豆换取一注彩票)\n\n\n输入兑换金额:",a ,2*a];
    guizeL.numberOfLines = 0;
    guizeL.font = [UIFont systemFontOfSize:14];
    guizeL.textColor = [UIColor blackColor];
    [self.view addSubview:guizeL];
    guizeL.backgroundColor = [UIColor clearColor];
    [guizeL release];
    
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(110, 125, 150, 30)];
    imageV.image = [UIImage imageNamed:@"back_groud_img"];
    [self.view addSubview:imageV];
    [imageV release];
    
    self.textF = [[UITextField alloc]initWithFrame:CGRectMake(120, 130, 200, 22)];
    _textF.font = [UIFont systemFontOfSize:14];
    _textF.placeholder = @"输入兑换金额";
    _textF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_textF];
    [_textF release];
    if ([_jiangjinStr intValue]==0) {
        _textF.enabled = NO;
        _textF.placeholder = @"暂无可提现金额";
    }
    
    UILabel * tishiL = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, 320, 20)];
    tishiL.font = [UIFont systemFontOfSize:10];
    tishiL.textAlignment = NSTextAlignmentCenter;
    tishiL.backgroundColor = [UIColor clearColor];
    tishiL.text = [NSString stringWithFormat:@"输入的金额应为不小于0.1元,且不大于%@,最小单位到角",_jiangjinStr];
    [self.view addSubview:tishiL];
    tishiL.backgroundColor = [UIColor clearColor];
    [tishiL release];
    
    UIButton * exchangeB = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeB setBackgroundImage:[UIImage imageNamed:@"tasktodo"] forState:UIControlStateNormal];
    [exchangeB setTitle:@"兑换" forState:UIControlStateNormal];
    exchangeB.frame = CGRectMake(30, 200, 260, 40);
    [self.view addSubview:exchangeB];
    [exchangeB addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
    
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
- (void)exchange
{
    if (0.1>[_textF.text floatValue]||[_textF.text floatValue]>[_jiangjinStr floatValue]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你造吗,输入的金额应大于0.1小于%.1f", [_jiangjinStr floatValue]] delegate:nil cancelButtonTitle:@"我造了" otherButtonTitles: nil];
        [alert show];
        return;
    }
}
@end
