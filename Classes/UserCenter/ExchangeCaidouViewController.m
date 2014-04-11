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
    [_jiangjinStr release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    UILabel *caidouL = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 40, 20)];
    caidouL.text = @"彩豆:";
    caidouL.font = [UIFont boldSystemFontOfSize:14];
    caidouL.textColor = [UIColor grayColor];
    [self.view addSubview:caidouL];
    
    self.caidouNoL = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 100, 20)];
    _caidouNoL.font = [UIFont boldSystemFontOfSize:14];
    _caidouNoL.textColor = [UIColor redColor];
    _caidouNoL.text = _caidouStr;
    [self.view addSubview:_caidouNoL];
    
    UILabel *jiangjinL = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 40, 20)];
    jiangjinL.text = @"奖金:";
    jiangjinL.font = [UIFont boldSystemFontOfSize:14];
    jiangjinL.textColor = [UIColor grayColor];
    [self.view addSubview:jiangjinL];
    
    self.jiangjinNoL = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 100, 20)];
    _jiangjinNoL.font = [UIFont boldSystemFontOfSize:14];
    _jiangjinNoL.textColor = [UIColor redColor];
    _jiangjinNoL.text = _jiangjinStr;
    [self.view addSubview:_jiangjinNoL];
    
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
